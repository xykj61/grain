# The collision advice -- parked draft

**Language:** EN
**Status:** Recovered historical record -- checkable
**Style:** Gauge, Meter
**Voice:** Kyri
**Recovered:** `20260909.120503`
**Source stash:** `3a05f1f438fe123ec623e7cb521022b05fda954f`
**Source blob:** `0977f0460efc72481765141b468b53ef9a5a91e5`

This draft proposed a repair to a published number collision. The current
[operator card](../ITINERARY.md) holds that decision for Keaton. Its advice code and
rule changes are unlanded. This recovery preserves their account and grants no ruling.

## Saved draft -- historical claims

The quotation preserves the parked page. Its row numbers were draft allocations,
and its claims of completion describe that parked lap, not the current tree.

> # REDS shelf -- a guard that named a fault nobody could act on, row %536
>
> **Language:** EN
> **Stamp:** `20260907.021500`
> **Status:** Shelf -- immutable once written
> **Rows:** `%536` -- folded from [`../REDS.md`](../REDS.md) on `20260907.021500`
> **Voice:** Kyri
>
> One row number bound to two rows that had both already reached the anointed spine. The gate said
> `rebinding` and stopped there, so three ships read the red and two of them correctly declined to
> renumber a peer's published row on a guess -- while the withheld roster receipt cost every ship a
> full cold pass. The authority to decide it was already on disk: rule 2 makes the remote the
> allocator, so the row that arrived after the number was spent never held a valid allocation, and
> `git log -S` over that ref answers in one call. The guard hands over the repair now, ordered by
> ancestry rather than by clock, because a collision is exactly when two peers push seconds apart.
>
>
> **REDS %536 (`20260907.021500`) -- a row number bound to two published rows deadlocked the guard built to catch it, because the reading names the collision and cannot say which binding is legitimate.** *What went wrong:* `%530` stood bound to `20260906.225150` in `construction/archive/REDS-a-lock-is-shared-by-design-a-pen-never-is-rows-530.md` and to `20260907.000030` on the living pin, **both already on `xy`** -- so `squatters` read zero, `reds_spine_derive` said `verdict=rebinding`, and the derived spine's rule 3 (*a published number never moves*) appeared to forbid the only repair. Its diagnosis was worse than silent: the stamp lookup `awk '$2 == s {print $1; exit}' shared.txt` did not exclude the disputed number, and since the colliding stamp also stood upstream at `%531`, the first match WAS `%530` -- so the sentence read *the anointed spine binds %530 to A, and binds B to %530*, naming one number as the seat of two stamps and contradicting itself in one clause. *What caught it:* this ship's cold open, `guards_red=4`, of which `readme_reach` and its cascade `reds_fold` a peer had already repaired upstream and `standing_equipment` was reading the remainder. The two session logs `20260907.013145` and `20260907.013921` record two peers reaching the same red, checking out `xy/main` detached to prove their own commits were nowhere in it, and leaving it standing -- **the right call from the letter of rule 3, and it left the fleet paying.** A red guard withholds the roster receipt, so `--scoped` refuses and all eight ships pay a FULL cold pass; this one measured **948s**. *What it taught:* **a guard that names a fault nobody is authorized to act on is a guard that gets read and stepped around**, and the authority it was missing was already on disk. Rule 2 makes the anointed remote the allocator, so the row that arrived AFTER the number was spent never held a valid allocation -- arrival order decides it, and `git log -S` over the anointed ref answers in one call. Measured: `20260906.225150` reached `xy` at `01:00:34`, `20260907.000030` at `01:05:10`, **four minutes and thirty-six seconds later**. *Repaired (`20260907.021500`):* the later row moved to `%535` -- matched on its full `**REDS %N (\`stamp\`)` signature with a count asserted at exactly one before the substitution, never a blind `sed` (`%519`) -- and **the shift cost one line**, since every other citation of it is its stamp or sits in testimony. `reds_spine_derive_scan.sh` gained the arrival advice and the excluded-self lookup; the rule and its Cursor twin carry the case rule 3 did not name. **The control found three faults in my own first draft**, which is what a control is for: two commits landing in one second are indistinguishable at `%cI` resolution and the pen read exactly backwards, so ordering is by **ancestry** now -- and a collision is precisely when two peers push seconds apart, so the clock was the wrong instrument twice over, committer skew being the second. My "declines to advise" case planted a **squatter** rather than a rebinding and exercised nothing; the reachable asymmetric case -- a local seat that never reached the spine at that number -- now names itself the row to shift, which is more use than declining. And the pathspec that makes the probe affordable (**0.37s limited to `construction`, 9.4s unlimited, 25x on this pier**) is **derived from the spine's own file list**, because spelling it would be right here and answer `unknown` in every pen while looking exactly like a probe that ran. `MAX_ADVICE=8` bounds the expensive reading while the gate stays unbounded, proven by planting nine. **31 cases, 8 new, every refusal shown from both sides**; the gate is still single. *Not taken:* whether any OTHER rostered guard can red on an unchanged tree -- I measured the class this lap and it stands at **8 of 216** whose instrument reads the wall clock, of which `rota_declared` is handled by `capability day_shelf`, `one_clock` is clock-shaped by design, and `reds_ledger_headline`'s control carries a midnight-boundary race; the rest read a nonce, a planted fixture, or a commit author time. **CLOSED** on `reds_spine_derive_witness.rish` GREEN and the control 31 of 31.
