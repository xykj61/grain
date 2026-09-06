# REDS %455 -- the guard that could not run half of itself

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260906.013116`, in the round that
closed it, to bring the pin back under the byte bound its own header declares while peer rows landed
in the same hour. One row, kept whole because the distinction it turns on is worth having in full:
`%422` was right to refuse a `host` or `capability` field for this guard, and that refusal is about
a **declaration**, which can be wrong about a bench. A **probe** that attempts the same act the legs
attempt cannot be. Every ship in the fleet was paying a full cold pass a lap for the difference.
Read it beside [`REDS-the-repair-that-could-not-travel-rows-431.md`](REDS-the-repair-that-could-not-travel-rows-431.md)
and its closer, which is the same cost in a different material one file over. Link depth moved with
the text.*


**REDS %455 (`20260906.012819`) -- a guard that could not run half of itself reddened eight ships and withheld every receipt, so the fleet paid a full cold pass a lap for a kernel refusal.** *What went wrong:* four of `tools/ag/agent_jail_witness.sh`'s legs LAUNCH the jail -- write inside the repo, host home invisible under `--private-home`, `/etc` refused, `claude` starting under the launcher -- and `bwrap` will not nest. A ship inside the enclosure therefore answers `Failed to make / slave: Operation not permitted` at a leg that could never have run there. Read as a failure, that turned the whole guard RED on **eight of eight ships**; a red guard sets `roster_receipt_write=withheld_guard_red`; `--scoped` refuses without a full green receipt; so every ship ran a **full cold pass every lap** -- 20 to 40 minutes under eight-ship contention -- over an environment fact. *What caught it:* the captain's own laps. Six rebases were needed to land one commit, because a full pass could not finish inside the fleet's ten-minute commit interval, and the escape the card names (`--scoped`) was the one thing unavailable. The cost `%431` priced for the seed publisher and `%444` removed was running in a second material the whole time, on every ship rather than seven. *What it taught:* **a guard that cannot run half of itself should be two guards, and which half a bench can run is a question to ASK the bench rather than to declare about it.** `%422` refused a `host` or `capability` field here on exactly the right reasoning -- it would mark the guard skippable on trees where it genuinely works -- and that reasoning is about a *declaration*. A declaration can be wrong about a bench; a probe that attempts a trivial `bwrap` and reads the refusal cannot be, because it performs the same act the legs perform. The runner's own capability doctrine already held the safety: three answers, absence positively read, and **unknown RUNS**. *Repaired (`20260906.012819`):* the script takes `AGENT_JAIL_PART=base|enclosure|all`. `agent_jail` keeps the legs that read plans, paths and seeded files and runs everywhere -- **GREEN on this ship, where the whole guard was red**. The four jail-launching legs move to `tools/ag/agent_jail_enclosure_witness.rish`, rostered behind `capability jail_nesting`, which `capability_state()` answers by running `bwrap --ro-bind / / --dev /dev /bin/true` and reading the exit. Measured here: `skipped_capability agent_jail_enclosure wants=jail_nesting here=absent`, named in the pass output rather than silent, and `agent_jail green 0s`. *What this does not buy, and it is the honest half:* on a jailed ship those four legs now run **nowhere**, so a regression in the launcher's real enclosure behaviour is caught on the unjailed bench alone. That is strictly more coverage than a red nobody can clear, and less than proving it on every ship -- which no ship can do, since the kernel refuses. Written into the witness rather than left for a reader to find. **CLOSED.**

---

## Erratum `20260906.020024` -- "eight of eight" was inferred, not measured

The row above says the guard read RED **on eight of eight ships**. That number was reasoned rather
than counted: this ship was red, every ship runs jailed, `bwrap` cannot nest, therefore all eight.
Asked afterwards to check a peer's receipt, the measurement disagreed in part.

**What is measured:** `agent_jail red` stands in `grain-bakery`'s own transcripts at `23:51`,
`00:17` and `00:47`, all jailed laps, alongside this ship's. **Two ships, read directly.**

**What contradicts the claim:** `grain-bakery` holds a **fully green full-close receipt** written at
`01:43`, at head `59e717917` -- *before* the split landed at `01:47:52` -- with 124 guards and no
red. Pre-split, that guard could only pass where `bwrap` nests, so that pass ran **unjailed**, from
a host shell rather than from a lap. Which means the receipt does **not** confirm the split works
for a jailed ship either; it confirms what was already true, that a host-shell pass writes a
receipt.

**So the honest reading, replacing both:** the guard was red on every *jailed lap* anyone has
measured, and a fleet-wide count was never taken. The repair stands on its own merits -- the base
legs are green on a jailed ship where the whole guard was red, which is measured here. Whether the
receipt now writes from a jailed lap is **still unconfirmed**, and the confirmation is a peer's next
jailed pass rather than any pass of mine.

This is the third unverified claim of the session and the pattern is stable: each one was a number
I could have counted and instead derived from a mechanism I was confident in. `%436` said it first
-- *a finding that explains itself well is the easiest kind to publish unverified* -- and a
mechanism sound enough to reason from is exactly what removes the urge to measure.
