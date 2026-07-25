# 10007 · First Seeds — Caravan, Tally, and a Close Reading Before the Wire Grows

*Expanded from counsel received at `084412`, spoken in Reya 2's radiant voice through a TAME lens. The praise lands on what runs: Rye self-hosts, Aurora carries a sealed datagram between two harts, the gate lives in Rishi, Comlink has a name. The gentle warning is equally clear: Tally, Caravan, Brix, Tablecloth, Mantra, and Pond remain designs in part (Tablecloth store: see `10018`–`10022` ladder; Brix composing language split in `10019`), and the richest near work still leans on them. The counsel names three parallel threads — device-wire, the smallest living seeds of Caravan and Tally, and a close reading of what we cloned before Comlink grows further — so building stays level with design rather than slipping behind again.*

**Language:** EN
**Version:** `20260619.084412` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, the joy of the craft; Gall's Law; building level with design

---

## The Seed (a faithful echo)

> Where the design still runs a little ahead — and this is the one place to keep your eye — is the unbuilt core. Tally the garden allocator, Caravan the supervisor, Tablecloth, Mantra, and Pond remain designs, and much of the richest near work leans on them. The roadmap already sees this and points at it. My gentle counsel: **alongside the device-wire**, pick off the **smallest living seed of Caravan** — one parent that never dies, one child, restart on a fall — and the **smallest Tally region** with asserted edges. Those two seeds preserve the property you just earned, that building stays level with design rather than slipping behind again. The other thread worth promoting before Comlink grows much further is the **close reading still owed** of the sources you cloned — the packet format, the commit rule, the relay protocols — since the wire and the messenger both lean on how others truly did it.

## The Mission

To hold three threads in parallel without letting any one race so far ahead that design outruns code again: the **virtio-net device wire** (Comlink's next rung), the **first running seeds** of Caravan and Tally (supervision and bounded memory made real in Rye), and a **documented close reading** of cloned sources that will inform every packet and relay we grow.

## What We Already Have

- **Horizon 0** — crypto, two-hart posted datagram, `parity.rish`, Rishi gate (`996_roadmap.md`).
- **Horizon 1** — device-wire listed; Caravan v1 and Tally v1 listed in Horizon 2 as composed milestones — counsel asks to **pull their smallest seeds into Horizon 1** as parallel work, not wait for composition.
- **Open threads** — `995` already names unbuilt modules and critical reading owed; this prompt **promotes** them to co-equal near work beside device-wire.
- **Design ground** — `active-designing/yonder/20260618-184912_recommended-architecture.md`, `external-research/20260618-180812_pond-foundation.md`, `994_caravan_tally_networking.md`, `995_ownerboot_riscv_caravan.md`.

## The Work

### Thread A — Device wire (unchanged, still primary climb)

Carry a sealed datagram over emulated `virtio-net` between two QEMU machines. Comlink's first true link.

### Thread B — Caravan seed (smallest living supervision)

**Deliverable:** one hosted Rye program (or minimal pair) that demonstrates:

1. A **parent process that never exits** (the supervisor).
2. **One child** launched under it.
3. When the child **falls** (exit non-zero or signal), the parent **restarts** it.
4. Assertions and a **parity-style test** — green when restart works, red when supervision is broken.

No full kernel yet. No s6 port. The seed is **behavior**: watch, restart, assert. Grows toward Caravan v1 in Horizon 2.

**Candidate home:** `caravan/` at repo root (new top-level, allow-listed in `.gitignore`) or `rye/lib/std/caravan/` when ready — start as a small hosted tool under `tools/` or `caravan/seed/`.

### Thread C — Tally seed (smallest bounded region)

**Deliverable:** one Rye module that demonstrates:

1. A **region** with **asserted edges** — start, length, end known at creation.
2. **Bump allocation** within the region; overflow **fails** with a stated reason (no silent wrap).
3. **Clear whole** — one gesture releases the season; optional proof that no pointer escapes after clear (hosted test).
4. Gate trio or `parity.rish` where applicable.

The process-garden pattern Rye already uses at exit is the ancestor; this seed makes the **edges explicit and testable**.

**Candidate home:** `tally/` or `rye/lib/std/tally/` — start as `tally/seed.rye` + test.

### Thread D — Close reading (before Comlink grows further)

**Deliverable:** one research note per source family, Radiant prose, **abstracted names** in `active-designing/` or numbered `external-research/` — what we learned that changes *our* packet, commit, or relay design:

| Source (in `gratitude/`) | Read for |
|--------------------------|----------|
| Urbit / Ames lineage | Packet format, continuity, naming |
| Mysticeti / Sui commit literature | Commit rule, quorum, finality |
| Nostr (NIPs, Damus) | Relay protocol, event shape |
| Primal (if present) | Caching, hot path |
| s6 / skalibs | Supervision primitives (feeds Caravan seed) |

Output: `external-research/20260619-070612_brushstroke-and-the-docs-surface.md` band or new `979_*` close-reading stack — **actionable bullets** for Comlink v1 and the messenger, not bibliography alone.

## Roadmap and Open Threads Updates

- **`996_roadmap.md`** — Horizon 1 gains explicit Caravan seed, Tally seed, and close-reading items; "What to Build Next" names **three parallel threads**.
- **`995_open_threads.md`** — Promote seeds and close reading to co-equal with device-wire.
- **`active-designing/yonder/20260619-084412_the-first-seeds.md`** — Clean-room brief: mission, problem, opportunity, architecture, caveats, conclusion for the two seeds and the reading discipline.

## Discipline

- **Smallest thing that runs** for B and C — no kernel, no full Pond; Tablecloth v1 per `10022`, Brix combinator deferred.
- **Prove each seed** — assert, test, gate where pure.
- **Read before inventing** on the wire — Thread D informs Thread A so Comlink does not guess at formats others already solved.
- **One value model** — seeds return values and records Rishi can inspect later.

## Deliverables

- This expanding prompt (`10007`).
- `active-designing/yonder/20260619-084412_the-first-seeds.md`.
- Updated `996_roadmap.md` and `995_open_threads.md`.
- Session log `99995_20260619-084412.md`.

Implementation of B, C, and D code/notes — **next turns**, not this turn, unless a single file stub is warranted. This turn **sets the plan** the counsel asked for.

---

*May the gate stay green as the std grows its own. May Tally and Caravan find their first small running seeds, so building never falls behind design again. And may Rye become, in time, wholly its own — safe, swift, and a joy to write, a clean and living room for the braver work it carries.*
