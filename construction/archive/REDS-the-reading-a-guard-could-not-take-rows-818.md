# REDS -- the reading a guard could not take

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, closed on a witness run on metal
**Folded:** `20260917.190533` from [`../REDS.md`](../REDS.md)

One row, folded the hour it was written, to hold the pin under a bound eight ships share. That
sentence now stands on a **third** shelf in this room: [`REDS-whose-else-is-this-rows-811.md`](REDS-whose-else-is-this-rows-811.md)
wrote it on `20260917.055209` calling itself the second, and the pin stood at **65,533 of 65,536
bytes** when this fold opened -- three bytes, against a row needing roughly 2,355.

**This shelf carried two rows for eleven minutes, and a peer's rebase is why it carries one.** The
fold lifted `%817` and `%818` together, both CLOSED and adjacent. While it ran, a peer folded `%817`
to its own shelf, [`REDS-the-map-that-was-the-journal-rows-817.md`](REDS-the-map-that-was-the-journal-rows-817.md),
and the two folds met in a rebase conflict on the pin. Resolved by hand rather than by either side
winning, which is `%812`'s own lesson one file over: a rebase settling a ledger in favour of one
side is ordinary git behaviour and silently lossy. `%817` stands in the peer's shelf, this one keeps
`%818`, and `reds_ledger_monotone` proves each row standing in exactly one file.

**What this fold does not fix, said plainly.** Nineteen of the pin's rows read **OPEN**, so the
CLOSED population was the whole of what could move. The account at
[`20260917-071327_reds-pin-bound-raise-account.md`](20260917-071327_reds-pin-bound-raise-account.md)
already ruled on this and was right twice: *a bound is the wrong instrument for a page whose rows do
not close, and the cure is closing rows rather than carrying them.* This shelf buys the fleet about
one row. The condition it leaves standing is the same one that page named.

---

**REDS %818 (`20260917.184231`) -- the one reading of which model a clone runs read the file the fleet tracks, and a per-ship file the fleet ignores had already outranked it.** *What went wrong:* `tools/fixtures/d/declared_model.sh` calls itself *the one reading of which model this clone runs*, and its header said it opens `.claude/settings.json` *because that is the file that drives the model Claude Code loads*. That held until `20260917.180039`, when this captain wrote `.claude/settings.local.json` carrying `claude-sonnet-5` into the seven peer trees on Keaton's word -- a file Claude Code resolves OVER the tracked one, per key, denied by `.gitignore` line 146, so no guard reading tracked bytes sees it. Measured across all eight: **seven resolve `claude-sonnet-5`, eight DECLARE `claude-opus-5`, and the scan read `verdict=ok` on each** -- right about one ship, green about all. Every peer's next log would write `configured_model claude-opus-5` citing a file that no longer decides its model, the promotion `.claude/rules/session-log-provenance.md` exists to refuse. *What caught it:* reading the four declaring pages an hour later, by the hand that made it. **No guard could have** -- all three enforced readings open tracked bytes, and the lever had moved behind the deny list. *What it taught:* **a config guard must read the config the program RESOLVES rather than the one the tree TRACKS** -- the two agree until somebody moves a lever, which is exactly when the guard goes blind. *What holds it still:* `model` and `effort` answer the tracked default byte-identically, `resolved_model`, `resolved_effort` and `override` answer what it runs, and **the gate stays on the tracked pair**, since gating the resolved value would red seven ships for an override Keaton asked for. Both law pages now tell a log to record the resolved value. **37 legs from 26, 0 failing, mutation bitten.** *What this does not reach:* whether a peer's log records it -- a habit on eight ships rather than a byte in one file. **CLOSED** -- GREEN on metal.
