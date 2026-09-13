# Paper workspace memory policy

Persist research mappings, source hashes, plans, literature evidence, manuscript
files, draft state and review issues in the user workspace resolved by
paper_workspace. Use PAPERWRITER_WORKSPACE, PAPERWRITER_INPUT_ROOT,
PAPERWRITER_TEMPLATE_ROOT and PAPERWRITER_METADATA_PATH and the returned paths;
do not assume /workspace or require manual staging. These are
user deliverables, not runtime resources or a second backend session database.
Keep all sidecar JSON, downloaded literature and logs outside paper/, which contains
only LaTeX, bibliography, templates and final figure assets accepted by the compiler.

Use native in-process compaction for long tasks. The default print invocation is
--no-session: no raw conversation is saved. The private reviewer plugin uses
persist_session=false and output_transcript=false. Do not recommend saving raw
conversations for recovery; structured artifact records are sufficient. Do not export sessions or persist raw
provider responses, hidden reasoning, auth stores, environment dumps or tool traces.
A sanitized lifecycle observer belongs to the caller and excludes message contents.

After interruption, inspect actual files and recompute source/template/manuscript
hashes before resuming. Use paper_lifecycle status/verify to validate the artifact bindings before the
next action, and deliver only after current hashes pass the relevant gates.
State flags alone are not evidence of completion; timeout records are not valid
reviews, and stale compile/review receipts cannot be promoted by editing state. Preserve
prior manuscript versions outside paper/ before revisions; invalidate compile,
review and visual results when their bound inputs change. Never overwrite an
operator policy or approval. Workspace data never belongs in software releases.
