format session-log-v1
stamp 20261011.224138
editor Claude Code, Bakery seat in grain-bakery
provider Anthropic
product Claude Code
role Bakery -- core infrastructure, shared build cache crux
modality text
model claude-haiku-5-5
model_status active runtime per harness system prompt, not independently verified
configured_model claude-opus-5 -- per recursion-prompts/bakery-inner.md engine line, not checked against settings this lap
configured_status declared in the inner prompt only
voice Kyri
host Linux 6.18.41 under the fleet pier, one-clock zone America/New_York
title Bakery, shared Zig cache measured under concurrent writers
prompt baton read; Bakery lap on the shared build cache crux, the seam the prior lap stopped at
think The prior lap stopped before wiring one global Zig cache across eight ships, because concurrent writers were unproven. This lap measures that one fact and wires nothing.
think Pinned toolchain is vendor/zig-toolchain/zig, version 0.16.0. Zig is not on this shell's PATH, so the vendored binary was called by full path.
think Pen: two checkouts, a and b, each holding identical source at a different path, each with its own local cache and one shared --global-cache-dir. Fifteen rounds, both builds launched concurrently in every round.
think First attempt failed 15 of 15, and the fault was in the pen source: Zig 0.16 print takes {d}, not %d, so the compile failed and left a zero-byte binary. The source was corrected and the rounds rerun. The 15-of-15 failure is not a cache result.
think Rerun: 15 rounds, 0 failures. Each binary printed ok-42. The shared cache ended at 819 entries, the same count shared_build_cache_census.sh reads for one cold build, so the second checkout reused the first's entries rather than rebuilding them.
obs The result covers concurrent writers into one global cache, with path-independent reuse, for a single small program. It does not cover the full ~370-guard roster, a tree-sized build, or eight simultaneous writers. Those are still unmeasured.
obs Nothing in the tree changed. The pen lived in .lap/cache-pen, gitignored, and was removed after the run. No witness was re-run, and no claim was opened, because no instrument was built.
obs Still open for the ruling: the receipt key. tree_digest in tools/fixtures/s/standing_equipment_run.sh begins with git rev-parse HEAD, so one tree at two commits reads two digests. Sharing the compile cache does not fix that, and the card already names it as a ruling.
loom zig_concurrent_rounds=15 fails=0 shared_entries=819 census_cold_miss=819
rota none -- measurement lap for a seated seam; the rota read was not the work this round
file tools/b/build_cached.sh why: the per-tree cache default this lap's shared-cache question concerns, read not edited
file vendor/zig-toolchain/zig why: the pinned 0.16.0 toolchain the pen ran, called by full path
file tools/fixtures/b/shared_build_cache_census.sh why: the 819 cold-miss figure the shared-cache count matched
status GREEN for the concurrency measurement, 15 of 15 rounds on this small program. No code landed. Shared-cache wiring and the receipt key stay unruled.
scope measured concurrent shared-cache correctness in a throwaway pen. Did not wire, did not claim, did not change the receipt key.
recommend check-in (Claude) -- the concurrency fact now stands for a small program, so the wiring ruling can be weighed on evidence. It still needs a tree-sized run and a ruling on the receipt key, and both belong to Keaton or Claude.
