# DREY0 — the memory that forgets: a session buffer that holds only while powered

**Stamp:** `20260814.020500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · founding rung DREY0)
**Kin:** [`../foundations/20260801-005853_mantrapod-venture-pitch.md`](../foundations/20260801-005853_mantrapod-venture-pitch.md) · [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## Why this journey opens

Season A's opening journey — the Open Image module — stands whole and witnessed (HUNK0–HUNK93): a picture a keeper owns all the way down, a marketplace built on one sprite, a Photos app that edits without ever losing the first frame. By Lindy-first, crux-first, the next durable crux on the whole road is Season A's own **near-term joy**: the **Mikrophone**, the Grainphone/Mantrapod hybrid that exists to hold in a hand — a field recorder, a civic microphone, a voice terminal — and its real near-term surface is **firmware**.

The device's founding promise is the one line above the venture pitch: *What forgets, protects.* The Mantrapod holds a keeper's work in working memory while the power is on, and lets it dissolve when the device is set down. It carries no store waiting in the dark to be mined; what a keeper wishes to keep, they keep on purpose, committing it deliberately across the single wire. That promise is not a slogan to paint on a box — it is a firmware invariant, and it is exactly the kind of bounded, pure state machine this tree proves in Rye **before** a single trace is cut in metal (the way `ship_pilot.rye` proved the onboarding arc pure before wiring real modules).

## The crux

**A capture is held only while powered, persists nothing except on a deliberate commit, and provably dissolves on power-down — the buffer leaks nothing it was never told to keep.** The hardest still-tractable move that opens the whole firmware journey is this single discipline, proven pure: a bounded session buffer whose only three verbs are *capture a sample*, *commit what should survive*, and *power down*, with the invariant that after power-down the working buffer is zero — no residue a later read could recover.

Everything the Mikrophone firmware grows later — the wire protocol to Comlink, the amber-light idle, the field-recorder controls — stands on a session model already known correct. Prove the forgetting first.

## The shape

A new module `mikrophone/session.rye` (a fresh journey directory), inventing no storage and asking no network:

- `Session` — a bounded working buffer over a fixed capacity (`max_samples`, a named constant), a `powered` flag, and a `committed` slice that names only what a deliberate commit chose to keep. No heap that outlives the power.
- `capture(session, sample)` — append one bounded sample while powered; a capture past `max_samples` refuses `BufferFull` by name, a capture while unpowered refuses `NotPowered`. Nothing is persisted by capturing — samples live only in the working buffer.
- `commit(session)` — the one deliberate act that lets a capture survive power-down: it marks the current buffer as the committed payload a keeper chose to carry out across the wire. An empty buffer refuses `NothingToCommit`; a second commit over the same unchanged buffer refuses `AlreadyCommitted` (one deliberate act, not an accidental double).
- `power_down(session)` — dissolve the working buffer: overwrite every working sample to zero, drop the length to nothing, clear `powered`. The **only** bytes that leave a powered-down session are the ones a prior `commit` handed out as an owned payload *before* power-down; the working buffer itself is provably zero afterward.
- `carry(session)` — read back the committed payload as bytes to hand to Comlink (a later DREY rung wires the actual wire). Uncommitted, it returns nothing — there is nothing to carry.

## The invariants the witness proves

1. **Capture holds only while powered.** A capture on an unpowered session refuses `NotPowered`; a bounded run of captures accumulates exactly, and the working buffer reads back byte-for-byte what was captured.
2. **The buffer is bounded.** A capture past `max_samples` refuses `BufferFull` before it writes — never a sample past the buffer.
3. **Commit is the one deliberate act.** An empty buffer refuses `NothingToCommit`; a captured buffer commits once; a redundant second commit refuses `AlreadyCommitted`. Only committed bytes are carried.
4. **Power-down forgets.** After `power_down`, the working buffer is **entirely zero** and its length is nothing — a fresh scan of the working region finds no residue of what was captured. This is the founding promise, asserted on metal.
5. **Only a commit survives.** A session captured and powered down **without** a commit carries nothing (`carry` is empty); a session captured, committed, then powered down carries exactly the committed bytes and no more.

## Custody

A sample is captured, held, zeroed, and — only on a deliberate commit — handed back as bytes. Nothing is stored to disk, nothing reaches a network, no key signs, no funds move. The real Mikrophone hardware (buying, provisioning a board) stays **custody gate #2**; this rung proves the firmware's defining shape in pure Rye on the bench, where it can be read whole and witnessed, long before a board exists.

*A device that forgets on purpose owes its keeper a proof that it truly forgets. DREY0 writes that proof first, so every surface built on it inherits a session that leaks nothing it was never told to keep.*
