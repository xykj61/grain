format session-log-v1
stamp 20261018.224007
editor Claude Code
provider Anthropic
product Claude Code
role repository
modality text
model claude-sonnet-4-6
model_status active runtime unverified
configured_model claude-sonnet-4-6
configured_effort low
voice Kyri
host Framework pier, America/New_York
title has_rota and has_loom predicates added to scribe/reader.rye
prompt kg -- continue has_rota/has_loom lap; also explain OpenCode reimplementation in TAME, Skate harness with Mantra+Ember+Kyli 7, and license considerations
think read reader.rye lines 128-357 to find insertion point -- after is_inventory (line 150), before bat-fleet archetype section; confirmed structure
think added has_rota predicate: checks rota field value starts with "lap " (declared form) or "none -- " (honest-absence form); zero-copy, no allocation
think added has_loom predicate: checks loom field value contains "=" (at least one key=value pair); std.mem.indexOfScalar, no allocation
think added prove_field_shapes selftest: 7 cases covering declared rota, absent-form rota, missing rota, malformed rota; well-formed loom, missing loom, malformed loom; all from both directions
think called prove_field_shapes from run_selftest; updated GREEN print to name the new predicates
think ran scribe_reader_witness -- GREEN
obs both predicates are pure (bool, no allocation, no error); they match exactly the shapes session-logs.md defines in prose; single-stranded gap closed
obs rota and loom field shapes now have one Rye home; scan scripts can cite has_rota and has_loom rather than re-deriving the prefix logic in shell
file scribe/reader.rye added has_rota and has_loom after is_inventory; added prove_field_shapes selftest; updated GREEN print line
recommend check-in (either) -- claim to close; need to update rota_declared_scan.sh and loom_trend.sh to cite has_rota and has_loom; that is the second half of the lap
scope local
status send
