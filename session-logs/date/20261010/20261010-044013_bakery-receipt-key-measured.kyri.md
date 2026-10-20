format session-log-v1
stamp 20261010.044013
editor Claude Code terminal, grain-bakery tree
provider Anthropic
product Claude Code
role bakery, core infrastructure lane
modality text
model unverified
model_status active runtime unverified
configured_model claude-opus-5 (fleet default per .claude/settings.json; resolved value not read this lap)
configured_status declared default, not runtime telemetry
evidence .claude/settings.json and recursion-prompts/bakery-inner.md engine line
voice Kyri
host Framework bench, one-clock zone America/New_York
title Bakery: content-keyed Rishi compile already lands; the cross-ship gap measured
prompt Bakery lap on the inner prompt's crux: share one build cache across eight checkouts, starting with the claimed content-keyed Rishi compile.
think The claim board already held bakery-content-keyed-compile from 043341; the card says the compile layer shares by content and the open question is the receipt key. Before building, check what rye already does.
think rye/src/main.rye already keys builds by a SHA-256 over the import closure, forwarded flags, toolchain bytes and the compiler's own bytes, and writes a receipt beside the output. Rishi builds through rye build -femit-bin, so the receipt applies to it.
think Measured in place: a rebuild through the wrapper, then a forced fresh build, then repeat builds. The binary's mtime moved on the first repeat and not on the second, so the second repeat hit.
think Pen test in a relative-shaped layout (rishi/src, rishi/bin): identical bytes hit, a one-byte source change misses, a changed -OReleaseSafe flag misses, and restoring the bytes hits again.
think The same bytes under an absolute path miss, so the key depends on how the source path is spelled, not only on its bytes. This is consistent with the rye header note that a closure source's path stays in the key as framing.
think Across the eight checkouts every rishi/src/main.rye is byte-identical, yet a read-only key from each sibling root misses. Each ship's rye/bin/rye has different bytes and the key hashes the compiler's own bytes by design, so no two ships share a receipt until they run the same rye.
obs The content-keyed compile exists for one tree. The shared-cache fruit is blocked on the compiler-identity term of the key, not on the Rishi build. Changing that term is a seam ruling about rye, so this lap did not change the key.
obs No source or key code changed this lap. rishi/bin/rishi was rebuilt in place from the same source through the wrapper, and it still answers.
loom rishi_build fresh_wall_s=1.11 first_miss_wall_s=1.53 key_reads=3 pen_legs=4
rota lap 9277, row 2 -- fire sees: the claim was already on the board; the measured gap is the compiler's own bytes in the key, so the fire reads where the receipt stops
orbit round 7 Libra -- balance: the two checks meet, each answering the other
file construction/fleet-claims.kyri closed bakery-content-keyed-compile; the claim had no build to finish, and the withdrawal is recorded here
file construction/ITINERARY.md git nib carried to 5c4d4b9593 with the claim close
file session-logs/date/20261010/20261010-044013_bakery-receipt-key-measured.kyri this log, the measured findings, and the open ruling
scope read rye/src/main.rye key path, measured rishi builds and pen legs, read sibling key readings; no source or key code edited
status GREEN for the measurements; the content-keyed compile claim is closed as already landed in rye, and cross-ship sharing is OPEN pending a ruling on the compiler-identity term
recommend check-in (Claude) -- rule whether the receipt key should hash rye's source closure instead of its own binary bytes; that changes the cross-ship contract and the rye key seam
