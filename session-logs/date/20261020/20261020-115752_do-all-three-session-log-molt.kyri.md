format session-log-v1
stamp 20261020.115752
session-header [20261020-105909_session-log-compression-fascia-links.kyri.md](20261020-105909_session-log-compression-fascia-links.kyri.md)
title do all three -- session log molt to .kyri.md, scribe reader, fascia links
prompt do all three
think Move 2 (Markdown links): `link_path()` added to scribe/reader.rye; `session-logs.md` updated with Markdown link form for `file` field
think Move 1 (pointer compression): `session_header_path()`, `ResolvedDocument`, and override-rule added to scribe/reader.rye; `session-header` field documented in `session-logs.md`
think Move 3 (.kyri.md rename): `is_scribe_extension()` bug fixed to recognize both `.kyri` and `.kyri.md`; 13,366 session log files renamed via mv + git add -A; 86 shelf index files repointed `.kyri)` -> `.kyri.md)`
think tools updated: `session_logs_archive.rish` comment corrected; `session_logs_archive.rye` `is_kyri` check extended to include `.kyri.md`
think index lock issues from backgrounded `git mv` loop (one lock per file); resolved by using plain `mv` + single `git add -A`
obs this log is the first resident of the `.kyri.md` convention -- born `.kyri.md`, carrying `session-header` pointer to the first log of this session
file [scribe/reader.rye](../../scribe/reader.rye) link_path + session_header_path + ResolvedDocument + fixed is_scribe_extension
file [.claude/rules/session-logs.md](../../.claude/rules/session-logs.md) .kyri.md molt, session-header field, Markdown link form for file field
file [tools/s/session_logs_archive.rish](../../tools/s/session_logs_archive.rish) comment updated for .kyri.md sibling
file [tools/rye/session_logs_archive.rye](../../tools/rye/session_logs_archive.rye) is_kyri extended to recognize .kyri.md
recommend keep-going -- append OUTPUT.md rows, commit, push to xy
orbit round 3 Gemini dual air fun -- say the work aloud
scope local
status pre-send
