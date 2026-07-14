# NS-L2 write revision — immutable recall across revisions

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.033400

## Thinking trace

Continued recommended bench: NS-L2 from the referential namespace lap ladder. Extended `mantra/recall_lap1.rye` with `BoltCatalog` — append-only leaf bindings keyed by peer/bolt/revision/path, in-memory resins with SHA3-256 verification.

Lap 2 proves: revision 2 appends new bytes; revision 1 still recalls original content; duplicate revision refused; revision 3 answers not-yet. Lap 1 witness unchanged and still GREEN via compatibility wrappers.

## Observations

- Same binary `recall-lap1` serves both laps (`selftest-lap1`, `selftest-lap2`, `selftest`).
- Weave fact append remains horizon — catalog models the binding layer first.
- NS-L3 sync over Amphora is next cross-module lap.

## Files

- `mantra/recall_lap1.rye` — BoltCatalog, appendLeaf, lap2 selftest
- `tools/mantra_recall_lap2.rish` — witness (new)
- `tools/parity.rish` — parity **160** block
- `active-designing/20260706-023912_the-referential-namespace.md` — lap 2 landed
- `work-in-progress/TASKS.md` — NS-L2 checked
- `active-designing/README.md` — index row

**Recommend: check in with Claude before NS-L3 sync** — crosses Comlink and Amphora seams; mechanical prep of bolt manifest types can stay local until then.
