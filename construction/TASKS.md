# Tasks -- fused into ITINERARY

**Language:** EN
**Status:** Pointer -- the living content moved to [`ITINERARY.md`](ITINERARY.md) on `20260823.103804`
**Living pin bound:** `living_pin_max_bytes = 24576`
**Operator card:** [`ITINERARY.md`](ITINERARY.md)
**Ledger:** [`THREADS.md`](THREADS.md)

---

The live lap edge lives in **[`ITINERARY.md`](ITINERARY.md)**, under *Now* and *The laps*. A lap
that lands folds into a *Prior lap* line there, and its detail stays in the session log that
recorded it -- so one card carries what is next rather than two carrying halves of it.

This file stays as a pointer rather than leaving, because seventeen tracked files name it and
several are **machinery** -- `compass_rose.rish` tests for it directly, and roughly thirty
`equinox_e*_scan.sh` fixtures read one or another of these cards. A guard reading a file that is
gone reports green while measuring nothing. Retiring the stub is its own later round.

Every landed lap row the elder card carried is one `git show` away:
`git show <nib>:construction/TASKS.md`, with the nib recorded in
[`CHECKPOINTS.md`](CHECKPOINTS.md) at `20260823.103804`.

---

*May each lap be complete in itself, and owe nothing to the lap before it.*
