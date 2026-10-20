format session-log-v1
stamp 20261009.214700
editor Claude Code, bakery seat, grain-bakery tree
provider Anthropic
product Claude Code
role bakery seat, core infrastructure lane
modality text
model claude-haiku-5-5
model_status active runtime declared by the harness
configured_model claude-haiku-5-5
configured_status resolved by sh tools/fixtures/d/declared_model.sh resolved_model
evidence harness-declared active model; configuration only, not runtime telemetry
voice Kyri
host Linux pier, one-clock zone America/New_York
title Bakery key binary per ship, measured
prompt Run the bakery baton and inner prompt as one lap: round-open, claim board, and the next agent-doable rung of the fusion-build spine.
think Read recursion-prompts/bakery-inner.md and the card. The crux is one shared build and cold-run cache across the eight checkouts. The card marks the receipt key as YOURS, so Keaton's ruling gates any change to it.
think Read the live claim board: one claim, copal's roster. Nothing collides with a receipt-key or cache claim.
think The open half, named by earlier bakery logs today, is cross-machine sharing. A receipt written on one ship and read on another is the case that matters. Same-pier path independence was already measured.
think rye/src/main.rye states that the receipt key covers the emitted output bytes and the rye binary's own bytes. If so, two ships with different rye binaries cannot share a key even with identical source.
think Measured it. Three checkouts (bakery, copal, incense) hold tally/copy.rye at identical bytes. Run rye key on that file with -femit-bin: three distinct keys, all verdict=miss.
think Isolated the varying term. Ran bakery's rye binary inside copal's tree. It returned bakery's key exactly. The tree bytes match, so the binary alone differs the key.
think Measured the binaries: all eight checkouts hold a rye binary, and no two share a sha256. So the self-bytes term separates every pair of ships.
think Nothing was built and no contract changed. Dropping the binary term, or making the build reproducible, would move the roster runner's contract, which the ruling covers.
obs The new fact: cross-ship receipt sharing fails on the key's binary term, not on the path. Same-pier reuse stays green. This is a finding for the ruling, and it does not decide the ruling.
obs Two cures have different costs. A reproducible rye build would make the binary identical across ships, but would need the same toolchain bytes on every ship. Keying on a source identity instead would change what a receipt promises, and that is the contract question the card names.
obs Reproducibility is not measured here. Whether the eight binaries differ by source or by build flags is open, and this lap did not check it.
rota none -- the bakery baton already names the crux, and the fire row carried a measurement rather than a deep read.
orbit round 9 sign Sagittarius -- the mission, in Bhakta, Gauge, Radiant, and Twilight.
loom probe=rye_key checkouts=3 same_source=yes distinct_keys=3 self_binary_held_out_of_tree=1 tree_bytes_identical=yes
loom probe=rye_binary_sha256 ships=8 distinct=8
file construction/ITINERARY.md Git nib carried to the follow-up's parent; the card's crux line still waits on the ruling.
file session-logs/date/20261009/20261009-214700_bakery-key-binary-per-ship.kyri this log, the record of the per-ship key measurement.
file session-logs/date/README-index-20261009.md one index row prepended under the delimiter.
status GREEN for the measurement and the log. No build, no claim, no contract change. Whether the eight binaries differ by source or by flags stays open.
recommend check-in (Claude) -- Keaton's ruling on the receipt key is the door, and this log adds the cross-ship reading the ruling needs. Reproducible build versus source-keyed receipt is his to choose.
