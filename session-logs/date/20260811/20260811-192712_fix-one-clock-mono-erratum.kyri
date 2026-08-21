format session-log-v1
stamp 20260811.192712
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Fix the one_clock mono-erratum — archive-tolerant integrity + retire one dangling entry
prompt kg fix the one_clock mono-erratum, baton prin recur
think the mono scan's erratum-integrity check required each erratum stamp to be a top-level LIVING file, but its glob is non-recursive, so folding a day's logs into session-logs/archive/YYYYMMDD/ made three erratum entries look like ghosts (20260724.221013 · 20260725.002400 · 20260725.002955), reddening MONO
obs surveyed each entry: three are folded into session-logs/archive (accrete-safe, still in the tree); the fourth (20260725.003013) is nowhere in the tracked tree — its log was removed after the erratum entry was added (3e1da26bff), so the entry is genuinely dangling
obs two-part fix: (1) taught the integrity check to accept an erratum stamp that lives in the archive too (find session-logs/archive -name STAMP_*) — a folded log is still in the tree; (2) retired the truly-dangling 003013 to a comment naming why (its file is gone; the UTC-drift it recorded stays in REDS/history) — a whitelist entry for an absent file gates nothing
obs MONO now GREEN: TRUE_HEAD 20260811.192204, three ERRATUM_ARCHIVED, MONO_OK; sh -n clean on the scan
obs fixing mono surfaced the NEXT leg (REDS #55 — a red left standing hides the one behind it): the zone check reds because this sandbox host has no zone config (UTC) while the witness asserts America/New_York by name. Environmental — the real Framework/pier host (/etc/localtime → America/New_York) passes it, or TZ exported; NOT a tree drift and not mine to fake
file tools/fixtures/one_clock_mono_scan.sh integrity check now archive-tolerant (living OR folded)
file tools/fixtures/one_clock_drift_erratum.txt retired the dangling 20260725.003013 to a commented note
file work-in-progress/REMEMBER.md mono-erratum FIXED; zone leg noted as sandbox-env
recommend check-in (Keaton) — the mono-erratum is fixed (MONO_OK) and the fix is fold-aware for future archive folds; the remaining one_clock zone red is this sandbox's host zone (UTC), which the real EDT host passes — no tree change wanted. Next door (a further cookbook builtin, TAME core/shelf, Aurora, or a fresh module) is Keaton's
