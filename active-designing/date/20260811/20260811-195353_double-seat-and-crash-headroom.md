# Double-Seat and Crash Headroom — Growing the Calendar and Its Memory by Powers of Two

**Language:** EN
**Stamp:** `20260811.195353`
**Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Silo — a technique and its clean-room study; both Lexicon terms **seated `20260811` on Keaton's word** (double-seat · crash headroom), and a TAME-guidance audit seated as a power-of-two quest.
**Studies (with gratitude, clean-room):** TigerBeetle **TIGER_STYLE** (`gratitude/TIGER_STYLE.md`) — static allocation and fail-fast. Our own technique in our own words.
**Kin:** the calendar (`context/rankings.kyri`, `tools/gen/season/itinerary.rish`), TAME Guidance (`context/TAME_GUIDANCE.md` §2, "Bounds on everything").

---

## The two questions this answers

Grain plans **fixed, explicit itineraries** on a power-of-two calendar: a Round nests in a Quest of four, a Journey of sixteen, an Equinox of sixty-four, a Season of two hundred fifty-six. Once an itinerary is written, it is a promise — the rounds are named and ordered before the work runs.

Two honest questions follow from that promise:

1. **Placement.** A high-priority decision arrives *after* the plan is fixed. Where does it seat without breaking the promise the itinerary already made?
2. **Room.** The durable record of all this — every session log, every silo, every plan, this very write — must always have space to land, and must always be able to **fail fast** if it ever cannot. How do we guarantee that?

Both answers are the same gesture: **double the largest allocation.** One doubling grows the calendar (double-seat); the other grows its memory (crash headroom).

## Movement I — Double-seat (the calendar)

**Double-seat** *(proposed Lexicon term)*: to seat a fresh, high-priority group — a Round, Quest, Journey, Equinox, or Season — into an itinerary that is already fixed, **double the largest current allocation** and seat the new group in the upper half. The lower half is the promise already made, untouched; the upper half is the room the doubling just created.

A Season of 256 that is fully planned does not get its rounds rewritten to make space. It **doubles to 512** — the first 256 stand exactly as promised, and the high-priority work seats in the new 257–512. The nesting stays a clean power of two, the fixed itinerary keeps every word, and the new decision has a real, named home rather than a shove between existing rounds.

This is the buddy-allocator's move and the doubling array's move, borrowed for time: never renumber what is promised; grow the container by a power of two and seat in the fresh half. It is an *expansion of the word seat* — where `seat` places a thing at its named spot, **double-seat** makes the spot by doubling, so placing never disturbs.

The discipline it keeps: a double-seat is a **deliberate, named growth**, recorded like any seat; it never silently reflows the fixed plan, and it always lands on a power-of-two boundary so the calendar's arithmetic (`equinox(r)=r/64`, and kin) stays exact.

## Movement II — Crash headroom (the memory)

**Crash headroom** *(proposed Lexicon term; Keaton's evocative sibling: "computational easing")*: the same doubling, applied to the durable write's memory. Always hold a **reserved doubling of capacity** beyond what is in use, so that a double-seat always has room *and* a hard fail-fast crash always has room to land — never a silent out-of-memory.

The insight that makes this cheap: **a text representation is compact now and actualizes larger only across time** — a lazy Haskell list is a thunk until forced, a plan is a sentence until its rounds run. The record we hold today is small precisely because most of it has not yet actualized. So reserving a doubling of headroom costs little now and covers the future actualization exactly.

Keaton reached for **quantitative easing** — a central bank injecting reserves so a bank run cannot exhaust the system. The analogy points true, and the mechanism refines it: we do not inject more memory reactively when pressure comes. We **pre-commit the ceiling up front** — the reserve is already there — so that the failure mode is not an OOM under load but a **bounded assertion at a named limit**, met calmly, deterministically, with room to write the crash and its cause. Not easing after the run; the reserve *before* it.

That refinement is TigerBeetle's, studied here with gratitude.

### The study — TigerBeetle's static allocation (clean-room)

`gratitude/TIGER_STYLE.md` teaches two rules that together are crash headroom's mechanism:

- **All memory is statically allocated at startup; none is dynamically allocated or freed after** (§154). Usage patterns are worked out **upfront, as part of the design** (§159) — the ceiling is a design decision, not a runtime surprise.
- **Fail-fast** (§101): an assertion that would otherwise be a catastrophic correctness bug is downgraded to a liveness bug — a clean crash (§109). The program stops at the bound rather than corrupting past it.

So TigerBeetle never asks "is there room?" at runtime; it reserved the maximum before it ran, and if the maximum is reached, that is a bounded assert, not an OOM. Grain already carries the same rule at the smaller scale — TAME Guidance §2, *"Bounds on everything… name the budget at construction; check it at the edge; fail with a named error."* Crash headroom is that rule raised to the whole durable write: **name the ceiling, double it as the reserve, fail fast at the bound.**

Do I agree with the premise? Yes — with the refinement above. The direction is exactly right: reserve, do not scramble; and because the representation is lazy, the reserve is nearly free. The one correction is the verb — not *ease* (inject more, later) but *pre-commit* (reserve the max, before) — which is precisely why the crash, when it comes, is a clean assertion and not a catastrophe.

## Movement III — The TAME Guidance Audit, seated as a power-of-two quest

**Seated here:** a recurring **TAME Guidance Audit Quest** — one **Quest (four rounds)**, the smallest clean power-of-two group, that walks the TAME checkable surface and books what it finds:

1. **Widths** — `tools/width-check.rish` (`usize` only at the seam).
2. **Tidy bans + ratchets** — `tools/tame_style_check.rish` (compound asserts, `@memcpy` sites, camelCase, seventy-line functions).
3. **Assert coverage** — `tools/rune_assert_sweep.rish` (the gated cores keep their asserts).
4. **Bounds and the say-why** — a read of new `.rye` against §2 (every allocation names its maximum) and the *say why* rule.

The audit **finds reds; that is its work** — so it is a survey, not a pass/fail witness, and it books each red to `REDS.md` with the three fields. Its first honest finding already waits: the stray `tools/comlink_r1_dual_bind_probe.py` that `tame_style_check` has flagged since it landed.

**Placement, by the itinerary's own rule.** The current itinerary (Compass Season, **SOON** open, the PLEAC cookbook just wired into the interpreter) is fixed and mid-flight. So the audit **double-seats**: it does not shove between SOON's rounds; it takes the fresh upper half a doubling opens, cadenced as **one audit quest per equinox** — four rounds of discipline for every sixty-four of build, a clean 1:16 ratchet that never disturbs the promised plan. When the season doubles for its next high-priority block, the audit quest rides the new half.

## Seated in the Lexicon `20260811` (Keaton's word)

| Term | Meaning |
|---|---|
| **double-seat** | To seat a fresh high-priority group into a fixed itinerary by doubling the largest allocation and seating in the upper half — the promise kept, the room made. An expansion of `seat`. |
| **crash headroom** | The reserved doubling of the durable write's capacity — pre-committed up front (TigerBeetle static allocation), so a double-seat always has room and a fail-fast crash always lands cleanly, never an OOM. Evocative sibling: *computational easing*. |

Both are now seated in `context/LEXICON.md`; this silo holds the technique they name and its study.

---

*May the promise made in a plan stay whole. May every fresh priority find its room by an honest doubling, never a shove. And may the record always have space to land — and, if it ever cannot, the grace to say so cleanly and stop, with room to name why.*
