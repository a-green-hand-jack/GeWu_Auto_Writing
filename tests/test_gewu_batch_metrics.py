import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
BATCH = REPO / "tools" / "gewu-batch"
METRICS = REPO / "tools" / "gewu_tex_metrics.py"


class GeWuBatchMetricsTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.base = Path(self.tmp.name) / "runs"
        self.paper = self.base / "sample-run" / "01-paper" / "workspace" / "paper"
        (self.paper / "sections").mkdir(parents=True)

    def tearDown(self):
        self.tmp.cleanup()

    def run_batch(self, command, batch=BATCH, run="sample-run"):
        env = os.environ | {"GEWU_BATCH_BASE": str(self.base)}
        return subprocess.run(
            [str(batch), command, str(run)],
            cwd=REPO,
            env=env,
            check=True,
            text=True,
            capture_output=True,
        ).stdout

    def metrics(self, *args, env=None):
        result = subprocess.run(
            [sys.executable, str(METRICS), *args],
            cwd=REPO,
            env=env,
            check=True,
            text=True,
            capture_output=True,
        )
        return json.loads(result.stdout)

    def write(self, relative, content):
        path = self.paper / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")

    def test_report_requires_prx_option_and_valid_pdf(self):
        self.write(
            "main.tex",
            r"""\documentclass[aps,reprint]{revtex4-2}
\begin{document}\bibliography{references}\end{document}
""",
        )
        (self.paper / "main.pdf").write_bytes(b"not a PDF")

        report = self.run_batch("report")

        self.assertIn("prx_class=0", report)
        self.assertIn("valid_pdf=0", report)
        self.assertNotIn("compiled_pdf=", report)

    def test_gates_follow_main_includes_strip_comments_and_accept_native_aps_refs(self):
        self.write(
            "main.tex",
            r"""% \documentclass[aps,prx,reprint]{revtex4-2}
\documentclass[aps,prx,reprint]{revtex4-2}
\begin{document}
\begin{abstract}\section{Ignored abstract heading}\end{abstract}
\input{sections/body}
\bibliography{references,nested/notes}
\end{document}
""",
        )
        self.write(
            "sections/body.tex",
            r"""% \FloatBarrier
\section{Method}
\FloatBarrier
\input{sections/details}
""",
        )
        self.write("sections/details.tex", r"\section{Results}\cite{used}")
        self.write(
            "unrelated.tex",
            r"""\documentclass[aps,prx,reprint]{revtex4-2}
\FloatBarrier
\section*{References}
""",
        )
        self.write("references.bib", "@article{used, title={A}}\n")
        self.write(
            "nested/notes.bib",
            "@article{unused, note={Retrieved on 2026-01-01}}\n",
        )

        gates = self.run_batch("gates")
        parsed = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertIn("revtex4-2", gates)
        self.assertIn("yes", gates)  # active FloatBarrier in an included source
        self.assertIn("aps-native", gates)
        self.assertIn(" 1 ", gates)  # recursive bibliography narration
        self.assertEqual(parsed["sections"], ["Method", "Results"])
        self.assertEqual(parsed["issues"], [])
        self.assertEqual(parsed["narration"], 1)
        self.assertIn("prx_class=1", self.run_batch("report"))

    def test_gates_ignore_commented_and_unrelated_tex_commands(self):
        self.write(
            "main.tex",
            r"""\documentclass{article}
\begin{document}
% \FloatBarrier
\input{sections/body}
\end{document}
""",
        )
        self.write("sections/body.tex", r"\section{Method}\n")
        self.write(
            "scratch.tex",
            r"""\documentclass[aps,prx,reprint]{revtex4-2}
\FloatBarrier
\section*{References}
""",
        )

        gates = self.run_batch("gates")
        report = self.run_batch("report")

        self.assertIn("article", gates)
        self.assertIn(" NO ", gates)
        self.assertIn("MISSING", gates)
        self.assertIn("prx_class=0", report)
        self.assertIn("floatbarrier_present=0", report)

    def test_pdf_validation_reports_unknown_when_no_validator_is_available(self):
        pdf = self.paper / "main.pdf"
        pdf.write_bytes(b"not a PDF")
        env = os.environ | {"PATH": ""}

        result = self.metrics("--valid-pdf", str(pdf), env=env)

        self.assertEqual(result["valid_pdf"], "unknown")
        self.assertEqual(result["validator"], "unavailable")

    def test_source_parser_does_not_follow_paths_outside_paper_root(self):
        outside = Path(self.tmp.name) / "outside.bib"
        outside.write_text("@article{outside, note={Retrieved on 2026-01-01}}\n", encoding="utf-8")
        self.write(
            "main.tex",
            r"""\documentclass{article}
\begin{document}\input{../../../../../outside}\end{document}
""",
        )
        (self.paper / "linked.bib").symlink_to(outside)

        result = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertEqual(result["narration"], 0)
        self.assertIn("outside_root_include", {issue["kind"] for issue in result["issues"]})

    def test_source_parser_never_rereads_an_outside_root_main(self):
        outside = Path(self.tmp.name) / "outside.tex"
        outside.write_text(r"\documentclass[aps,prx]{revtex4-2}\n", encoding="utf-8")

        result = self.metrics("--root", str(self.paper), "--main", "../../../../../outside.tex")

        self.assertIsNone(result["document_class"])
        self.assertEqual(result["source_files"], [])
        self.assertIn("outside_root_main", {issue["kind"] for issue in result["issues"]})

        (self.paper / "main.tex").symlink_to(outside)
        linked_result = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertIsNone(linked_result["document_class"])
        self.assertEqual(linked_result["source_files"], [])
        self.assertIn("outside_root_main", {issue["kind"] for issue in linked_result["issues"]})

    def test_nested_input_uses_paper_root_before_including_file_directory(self):
        self.write(
            "main.tex",
            r"""\documentclass{article}
\begin{document}\input{sections/body}\end{document}
""",
        )
        self.write("sections/body.tex", r"\input{shared}\n")
        self.write("shared.tex", r"\section{Root choice}\n")
        self.write("sections/shared.tex", r"\section{Nested choice}\n")

        result = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertEqual(result["sections"], ["Root choice"])
        self.assertIn("shared.tex", result["source_files"])
        self.assertNotIn("sections/shared.tex", result["source_files"])

    def test_non_aps_revtex_bibliography_is_unknown_not_aps_native(self):
        self.write(
            "main.tex",
            r"""\documentclass[aip,reprint]{revtex4-2}
\begin{document}\bibliography{references}\end{document}
""",
        )
        self.write("references.bib", "@article{a, title={A}}\n")

        result = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertEqual(result["refslabel"], "unknown")
        self.assertIn("bibliography_blocks_detected=0", self.run_batch("report"))

    def test_nested_file_is_not_an_implicit_tex_search_directory(self):
        self.write("main.tex", r"\documentclass{article}\begin{document}\input{sections/body}\end{document}")
        self.write("sections/body.tex", r"\input{details}")
        self.write("sections/details.tex", r"\section{Not found by ordinary TeX}")

        result = self.metrics("--root", str(self.paper))

        self.assertEqual(result["sections"], [])
        self.assertIn("missing_include", {issue["kind"] for issue in result["issues"]})

    def test_amsart_class_without_bibliography_does_not_report_a_block(self):
        self.write("main.tex", r"\documentclass{amsart}\begin{document}\section{Introduction}Text\end{document}")

        result = self.metrics("--root", str(self.paper))

        self.assertEqual(result["refslabel"], "MISSING")
        self.assertIn("bibliography_blocks_detected=0", self.run_batch("report"))

    def test_bibliography_metrics_ignore_unrelated_nested_bbl(self):
        self.write(
            "main.tex",
            r"""\documentclass{article}
\begin{document}\bibliography{references}\end{document}
""",
        )
        self.write("references.bib", "@article{used, title={A}}\n")
        self.write("main.bbl", r"\bibitem{used} A\n")
        self.write(
            "nested/stale.bbl",
            r"\bibitem{stale} Retrieved on 2026-01-01\n\bibitem{old} B\n",
        )

        result = self.metrics("--root", str(self.paper), "--main", "main.tex")

        self.assertEqual(result["bibitems"], 1)
        self.assertEqual(result["narration"], 0)

    def test_batch_follows_its_real_script_target_when_invoked_via_symlink(self):
        self.write("main.tex", "\\documentclass{article}\n")
        bin_dir = Path(self.tmp.name) / "bin"
        bin_dir.mkdir()
        link = bin_dir / "gewu-batch"
        link.symlink_to(BATCH)

        gates = self.run_batch("gates", batch=link)

        self.assertIn("article", gates)

    def test_explicit_run_path_without_trailing_slash_finds_tasks(self):
        self.write("main.tex", "\\documentclass{article}\n")

        gates = self.run_batch("gates", run=self.base / "sample-run")

        self.assertIn("01-paper", gates)
        self.assertIn("article", gates)

    def test_gates_and_report_surface_unresolved_source_issues(self):
        gates = self.run_batch("gates")
        report = self.run_batch("report")

        self.assertIn("SOURCEISSUES", gates)
        self.assertRegex(gates, r"01-paper.*\s1\n")
        self.assertIn("source_parse_issues=1", report)


if __name__ == "__main__":
    unittest.main()
