format session-log-v1
stamp 20260810.055705
editor Zed
model claude-opus-4-8
voice Riyo
git_nib 5c91fdc65a
title Loom — process/activity/memory monitor design brief
prompt design a Scribe-and-Tally hybrid for process/activity/memory monitoring + light orchestration; name module home, bounded state model, first witnessed lap, how it composes caravan + tally — brief only, no code
think grepped the tree for loom first (comlink-tendency): loom is ENCUMBERED — 3 hits, the reds-first rule's "a lantern that fires twice should become a loom" is a live seated metaphor (caught recurring failure promoted to a guard); a prior collision-check 20260808 already set Loom aside for this reason
think read caravan/subscribe_poll_service.rye — caravan OWNS processes (spawn, waitpid/WNOHANG, reap, restart, exit vocabulary cycle_ok/stop_requested/fall). the design boundary writes itself: Loom must OBSERVE without owning
think read scribe/reader.rye — zero-copy .kyri parse into bounded [max_fields]Field, dispatch by format, one-notation-many-formats. Loom emits .kyri, Scribe reads it back — the round trip is the natural lap-1 witness
think read tally/README — fixed named bounded gardens (max_gardens=8), copy_disjoint, no_padding, seam-map symlinks. Loom composes tally exactly like every hosted module
think confirmed /proc surface on this host — /proc/self/stat, statm, loadavg, meminfo all present and parseable; settlement/constellation.rye already uses a bounded ring, so the ring pattern has tree precedent
obs the load-bearing design choice: Loom and Caravan meet ACROSS A FILE (.kyri roster + Caravan's own stop-sentinel convention), never across a symbol — so Loom cannot corrupt Caravan's invariants; safety is structural, a property of the file boundary you cannot get from a shared pointer
obs widths chosen per supplement from lap 1: u32 for ring/table indices bounded by ring_capacity(256)/max_watched(32); u64 for seq/at_ns/mem_held (wire-persistent/cross-target for the Comlink horizon) so a remote reader reads identically without a later migration
obs first lap deliberately reads NO live /proc — proves the ring's constant-memory-under-unbounded-time invariant on synthetic samples first, then Scribe reads it back; reds-first habit, prove the line before the firehose
obs custody-first extended to the NAME: brief seats nothing, claims no clearance; proposed name Loom is offered with its encumbrance named, plus consent-gated alternatives (Tender/Vigil/Warden) each owed its own grep
file active-designing/undefined_plan-loom-process-activity-memory-monitor.md the brief — module home loom/, three-part bounded state (Watched table, Sample ring, memory record), lap-1 ring+scribe-roundtrip witness, caravan/tally composition across a file, laps 2-5 + Mycelium/RISC-V horizons
recommend check-in the name Loom is encumbered (reds-first metaphor) and needs a whole-tree grep + Keaton's word before seating; the module home path and every file path are provisional and move with the final name — this is a design brief awaiting the naming decision, not an implementation
