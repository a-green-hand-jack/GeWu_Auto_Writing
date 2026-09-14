#!/usr/bin/env python3
"""Read-only, stdlib-only TeX and PDF metrics for GeWu paper workspaces."""

import argparse
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


INPUT_RE = re.compile(r"\\(?:input|include)\s*\{([^}]+)\}")
CLASS_RE = re.compile(r"\\documentclass\s*(?:\[([^]]*)\])?\s*\{([^}]+)\}")
SECTION_RE = re.compile(r"\\section\*?\s*(?:\[[^]]*\])?\s*\{([^{}]*)\}")
CITE_RE = re.compile(r"\\[A-Za-z]*[Cc]ite[A-Za-z]*\s*(?:\[[^]]*\]\s*)*\{([^}]*)\}", re.S)
THEOREM_RE = re.compile(r"\\begin\{(?:theorem|proposition|lemma|corollary)\}")
BIBLIOGRAPHY_RE = re.compile(r"\\bibliography\s*\{([^}]*)\}")
NARRATION_RE = re.compile(
    r"verified through|not independently verified|preparation environment|Crossref|retrieved on|consulted on",
    re.I,
)


def strip_comments(text):
    """Remove TeX comments while retaining line boundaries and escaped percents."""
    lines = []
    for line in text.splitlines(keepends=True):
        for index, char in enumerate(line):
            if char != "%":
                continue
            slashes = 0
            cursor = index - 1
            while cursor >= 0 and line[cursor] == "\\":
                slashes += 1
                cursor -= 1
            if slashes % 2 == 0:
                line = line[:index] + ("\n" if line.endswith("\n") else "")
                break
        lines.append(line)
    return "".join(lines)


def under_root(path, root):
    try:
        path.relative_to(root)
        return True
    except ValueError:
        return False


def include_path(value, root):
    name = Path(value.strip())
    # TeX resolves ordinary \input names from its compilation working directory.
    # The paper root is the compilation directory; nested files do not add search paths.
    candidates = [root / name]
    resolved = []
    for candidate in candidates:
        if not candidate.suffix:
            candidate = candidate.with_suffix(".tex")
        candidate = candidate.resolve()
        if candidate not in resolved:
            resolved.append(candidate)
    return resolved


def bibliography_files(root, text):
    """Return explicitly named in-root BibTeX databases, using TeX root semantics."""
    files = []
    for group in BIBLIOGRAPHY_RE.findall(text):
        for name in group.split(","):
            candidate = root / Path(name.strip())
            if not candidate.suffix:
                candidate = candidate.with_suffix(".bib")
            candidate = candidate.resolve()
            if candidate.is_file() and under_root(candidate, root) and candidate not in files:
                files.append(candidate)
    return files


def flatten_source(root, main):
    """Expand only in-root input/include files, preserving their source order."""
    root = root.resolve()
    main_path = (root / main).resolve()
    issues = []
    seen = set()
    source_files = []

    def read(path, ancestry):
        if not under_root(path, root):
            issues.append({"kind": "outside_root", "path": str(path)})
            return ""
        if path in ancestry:
            issues.append({"kind": "include_cycle", "path": str(path.relative_to(root))})
            return ""
        if not path.is_file():
            issues.append({"kind": "missing_source", "path": str(path.relative_to(root))})
            return ""
        try:
            text = strip_comments(path.read_text(encoding="utf-8", errors="ignore"))
        except OSError as error:
            issues.append({"kind": "unreadable_source", "path": str(path.relative_to(root)), "detail": str(error)})
            return ""
        if path not in seen:
            seen.add(path)
            source_files.append(str(path.relative_to(root)))

        def expand(match):
            requested = match.group(1).strip()
            candidates = include_path(requested, root)
            in_root = [candidate for candidate in candidates if under_root(candidate, root)]
            if not in_root:
                issues.append({"kind": "outside_root_include", "path": requested})
                return ""
            for candidate in in_root:
                if candidate.is_file():
                    return read(candidate, ancestry | {path})
            issues.append({"kind": "missing_include", "path": requested})
            return ""

        return INPUT_RE.sub(expand, text)

    if not under_root(main_path, root):
        return "", [], [{"kind": "outside_root_main", "path": str(main)}]
    if main_path.name != "main.tex":
        return "", [], [{"kind": "entrypoint_must_be_main_tex", "path": str(main)}]
    return read(main_path, set()), source_files, issues


def source_metrics(root, main):
    """Return literal source metrics, without evaluating TeX macros or conditionals."""
    root = Path(root).resolve()
    text, source_files, issues = flatten_source(root, main)
    main_text = ""
    main_path = (root / main).resolve()
    if main_path.name == "main.tex" and under_root(main_path, root) and main_path.is_file():
        main_text = strip_comments(main_path.read_text(encoding="utf-8", errors="ignore"))
    class_match = CLASS_RE.search(main_text)
    options = class_match.group(1).lower() if class_match and class_match.group(1) else ""
    document_class = class_match.group(2).strip().lower() if class_match else None
    option_set = {part.strip() for part in options.split(",")}
    prx = document_class == "revtex4-2" and "prx" in option_set
    amsart = document_class == "amsart"
    body = text
    document_start = re.search(r"\\begin\{document\}", body)
    if document_start:
        body = body[document_start.end():]
    else:
        body = ""
    body = re.split(r"\\end\{document\}", body, maxsplit=1)[0]
    body_without_abstract = re.sub(r"\\begin\{abstract\}.*?\\end\{abstract\}", "", body, flags=re.S)
    sections = [title.strip() for title in SECTION_RE.findall(body_without_abstract)]
    has_manual_refs = any(title.lower() == "references" for title in sections)
    has_bibliography = bool(re.search(r"\\(?:bibliography|printbibliography)\b|\\begin\{thebibliography\}", body))
    if has_manual_refs:
        refslabel = "manual"
    elif amsart and has_bibliography:
        refslabel = "amsart"
    elif document_class == "revtex4-2" and has_bibliography and option_set.intersection(
        {"aps", "pra", "prb", "prc", "prd", "pre", "prl", "prx", "rmp"}
    ):
        refslabel = "aps-native"
    elif document_class == "revtex4-2" and has_bibliography:
        refslabel = "unknown"
    else:
        refslabel = "MISSING"
    citations = set()
    for group in CITE_RE.findall(text):
        citations.update(key.strip() for key in group.split(",") if key.strip())
    bib_files = bibliography_files(root, text)
    main_bbl = (root / "main.bbl").resolve()
    bbl_files = [main_bbl] if main_bbl.is_file() and under_root(main_bbl, root) else []
    entries = set()
    for bib in bib_files:
        try:
            entries.update(re.findall(r"@[A-Za-z]+\s*\{\s*([^,\s]+)", bib.read_text(encoding="utf-8", errors="ignore")))
        except OSError:
            continue
    narration = 0
    for bibliography in bib_files + bbl_files:
        try:
            narration += len(NARRATION_RE.findall(bibliography.read_text(encoding="utf-8", errors="ignore")))
        except OSError:
            continue
    bibitems = 0
    for bbl in bbl_files:
        try:
            bibitems += len(re.findall(r"\\bibitem\b", bbl.read_text(encoding="utf-8", errors="ignore")))
        except OSError:
            continue
    return {
        "source_files": source_files,
        "issues": issues,
        "document_class": document_class,
        "prx": prx,
        "amsart": amsart,
        "floatbarrier": bool(re.search(r"\\FloatBarrier\b", text)),
        "refslabel": refslabel,
        "sections": sections,
        "citations": sorted(citations),
        "bibliography_files": [str(path.relative_to(root)) for path in bib_files],
        "bibitems": bibitems,
        "bib_entries": len(entries),
        "uncited": len(entries - citations),
        "narration": narration,
        "theorems": len(THEOREM_RE.findall(text)),
    }


def valid_pdf(path):
    validator = shutil.which("pdfinfo")
    if not validator:
        return {"valid_pdf": "unknown", "validator": "unavailable", "detail": "pdfinfo_not_found"}
    try:
        result = subprocess.run(
            [validator, str(path)], text=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, timeout=10
        )
    except subprocess.TimeoutExpired:
        return {"valid_pdf": "unknown", "validator": "pdfinfo", "detail": "timeout"}
    except OSError as error:
        return {"valid_pdf": "unknown", "validator": "pdfinfo", "detail": f"error:{error.errno}"}
    if result.returncode == 0:
        return {"valid_pdf": "yes", "validator": "pdfinfo", "detail": "parsed"}
    return {"valid_pdf": "no", "validator": "pdfinfo", "detail": "invalid"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root")
    parser.add_argument("--main", default="main.tex")
    parser.add_argument("--valid-pdf", metavar="PDF")
    args = parser.parse_args()
    if args.valid_pdf:
        if args.root:
            parser.error("--valid-pdf cannot be combined with --root")
        result = valid_pdf(args.valid_pdf)
    elif args.root:
        result = source_metrics(args.root, args.main)
    else:
        parser.error("provide --root or --valid-pdf")
    json.dump(result, sys.stdout, sort_keys=True)
    print()


if __name__ == "__main__":
    main()
