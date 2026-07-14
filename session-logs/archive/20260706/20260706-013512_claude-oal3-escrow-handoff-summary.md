# Claude OA-L3 escrow — handoff summary and bench packet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.013512

## Prompt

Kaeden confirmed zip 51 landed cleanly (`2272dbe`, parity **157** held). Claude narrowed the OA-L3 gate: three recommendations already seated in counsel; only **vocabulary** needs Kaeden's voice. Kaeden asked Rio to prepare commits, pushes, and a full summary for Claude to implement lap 1.

## Trace

Read OA-L3 escrow hammock brief, OA-L1/L2 witnesses, MALA M1/M2 ladder in modules-aspects note, and the silo-deepening Claude bench pattern. Prepared runnable bench prompt and this handoff summary. No OA-L3 code in this pass — handoff only.

## What stands at tip

| Item | State |
|------|--------|
| **Tip** | `2272dbe46df5a5282ff5f3adea4f2efc8ec4e420` (`2272dbe`) |
| **Parity** | **157** GREEN on metal |
| **OA-L3 counsel** | [`active-designing/20260706-013012_open-asks-escrow-hammock.md`](../active-designing/20260706-013012_open-asks-escrow-hammock.md) |
| **Settlement** | Sui seated; softenings applied; two-lane witness proposed |
| **`.gitignore`** | `/comlink/.build/`, `/linengrow/bin/` |

## The gate (Claude's narrowing)

Of four parked decisions, **three are seated** unless Kaeden overrides:

| Decision | Seated recommendation |
|----------|----------------------|
| Encoding | Reuse `receipt_core` fact; **memo prefix** distinguishes hold vs release |
| Home / ordering | **Inline** in `linengrow/open_asks.rye` (Gall's Law) |
| MALA ladder | **Hold = M1**, **release = M2** |

**One gate remains:** Kaeden speaks the **vocabulary** — words for hold, release, and escrow account (names entering the tree are his). Counsel proposes memo prefixes `escrow-hold request_ref=` and `escrow-release request_ref=`; he may affirm or replace them in the vocabulary block.

## What Claude implements (lap 1 → parity 158)

**Pipeline:** post → apply → accept → **hold** → **release** → verify on one log.

**Invariants first** (from brief §The Invariants): conservation, escrow closes at zero, no negatives, release only to accepted applicant in held amount, no double-hold/release, poster-signed, internal test units only.

**Deliverables:** extend `open_asks.rye`, `tools/open_asks_lap3.rish`, parity **158** block, docs, session log, full parity GREEN.

**Not in scope:** device wire lap 2, MALA module, chain, sourcing note.

## How Kaeden opens the Claude bench

1. Paste [`expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md`](../expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md) as the bench body.
2. Paste the **vocabulary block** from that prompt (filled in) and affirm the three recommendations.
3. Claude implements red-then-green selftest, witness, parity **158**, one GPG commit + four-remote push + session log.

## Paste-ready for Claude (intake header)

```
Anchor 013512 accepted. Tip 2272dbe. Parity 157 on metal.

Vocabulary:
- Hold memo prefix: escrow-hold request_ref=
- Release memo prefix: escrow-release request_ref=
- Escrow account (fold projection): <Kaeden fills>

Affirm: memo-prefix encoding · inline open_asks · M1/M2 mapping · proceed lap 1.

Bench: expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md
Handoff: session-logs/20260706-013512_claude-oal3-escrow-handoff-summary.md
```

(Kaeden replaces `<Kaeden fills>` and may change prefixes before Claude codes.)

## Season arc (for orientation)

```
SLC-L1 (152) → SLC-L2 (155) → OA-L1 (156) → OA-L2 (157) → OA-L3 (158 next)
```

## Files prepared this sitting

| File | Why |
|------|-----|
| `expanding-prompts/20260706-013512_claude-oal3-escrow-first-lap.md` | Runnable Claude bench |
| `session-logs/20260706-013512_claude-oal3-escrow-handoff-summary.md` | This handoff |
| `expanding-prompts/README.md` | Index row |
| `session-logs/README.md` | Index row |
| `work-in-progress/TASKS.md` | Handoff prepared pointer |

**Recommend:** Kaeden speaks vocabulary and opens Claude bench — then Claude lands parity **158**; sourcing-discipline note rides whenever it suits.
