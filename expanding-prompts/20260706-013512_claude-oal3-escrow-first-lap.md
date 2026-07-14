# Claude OA-L3 Escrow First Lap — Runnable Bench

**Stamp:** `20260706.013512 UDT` · **Style:** Radiant for logs and scope updates · **Base:** tip `2272dbe` (parity **157** on metal)
**Counsel:** [`../active-designing/20260706-013012_open-asks-escrow-hammock.md`](../active-designing/20260706-013012_open-asks-escrow-hammock.md)
**Handoff summary:** [`../session-logs/archive/20260706/20260706-013512_claude-oal3-escrow-handoff-summary.md`](../session-logs/archive/20260706/20260706-013512_claude-oal3-escrow-handoff-summary.md)

*Written by Kaeden and Rio 3 (Cursor). Kaeden speaks the bench voice-name and the escrow vocabulary in his first message; the one-clock, stop-and-park, and TAME laws inherit whole.*

---

## Ground laws

**One clock.** Body stamps use Kaeden's supplied stamp verbatim. This prompt rides `20260706.013512`.

**Vocabulary gate — before any code.** Kaeden pastes the vocabulary block (below) and affirms the three seated recommendations. Without that block, write counsel only — do not implement.

**Value model.** Escrow touches the money fold. State the invariants in the session log before describing the algorithm. Red-then-green: unwelcome paths must fail before welcome path is declared GREEN.

**TAME.** Safety first (invariants, bounded amounts, no negative balances), performance second, joy third. Width surface: add changed `.rye` files to `tools/width-check.rish`.

**Git.** GPG-sign every commit (`.claude/rules/git-signing.md` — never `--no-gpg-sign`, never `--no-verify`). Exclude `linengrow/bin/` and `comlink/.build/` (now in `.gitignore`). Ship the session log in the **same commit** as the work.

**Stop-and-park.** Lap 1 only — local log, one witness, parity **158**. No OA-L3 device wire (lap 2), no MALA module home, no external chain, no sourcing-discipline canon unless Kaeden asks separately.

---

## What stands at tip (`2272dbe`)

| Item | State |
|------|--------|
| **Parity** | **157** GREEN — OA-L1 + OA-L2 (hosted + device wire) |
| **OA-L3** | Counsel seated — [`20260706-013012_open-asks-escrow-hammock.md`](../active-designing/20260706-013012_open-asks-escrow-hammock.md) |
| **Settlement** | Sui seated; two-lane witness proposed (softenings landed) |
| **Seeds** | Poster `0x51`, applicant `0x52` — same as OA-L1/L2 |
| **Fixture** | `tools/fixtures/open_asks_request.bron` |
| **Receipt spine** | `linengrow/receipt_core.rye` — reuse fact shape |

---

## Kaeden's vocabulary block (paste before code)

Kaeden fills this table and affirms the line below it:

```
## Vocabulary — Kaeden's word

| Role | Word / prefix |
|------|----------------|
| Hold fact (M1 commitment) | memo prefix: escrow-hold request_ref=<64 hex> |
| Release fact (M2 delivery) | memo prefix: escrow-release request_ref=<64 hex> |
| Escrow account (fold projection) | <name Kaeden speaks> |

Affirm seated recommendations:
- [ ] Reuse receipt-core fact with memo prefix (wire does not fork)
- [ ] Grow inline in linengrow/open_asks.rye (Gall's Law from running seed)
- [ ] Hold = M1 commitment, release = M2 delivery
- [ ] Proceed to lap 1 implementation → parity 158
```

If Kaeden changes the memo prefixes or escrow account name, use his words exactly in code and fixtures.

---

## Seated recommendations (already counsel — implement unless Kaeden overrides)

1. **Encoding** — Reuse `receipt_core` transaction fact (`from`, `to`, `amount`, `memo`, `stamp`). Distinguish role by **memo prefix** on the canonical fact bytes. Hold and release both poster-signed; `from` = poster, `to` = applicant (or escrow account name for hold leg — match brief's conservation story).

2. **Home** — Extend [`linengrow/open_asks.rye`](../linengrow/open_asks.rye) inline. No new top-level module; no `mala/` until second consumer (graduation rule).

3. **Ladder** — Hold is M1 (committed, not yet mailable to applicant as payout); release is M2 (delivered to applicant). Document in scope note status when landed.

---

## Invariants (witness must bind — from counsel brief)

State these in the session log, then implement the fold to enforce them:

- Conservation: sum(holds) = sum(releases) per completed bounty; escrow balance returns to **zero**
- No negative poster spendable balance after hold; no negative escrow balance
- Release only to **accepted applicant**, only for **accepted request_ref**, only in **held amount**
- Release requires prior matching hold; hold requires prior **acceptance**
- No double-hold, no double-release on same `request_ref`
- Every escrow fact poster-signed; amounts within `receipt_core` bounds
- **Internal only** — test units, own log, own keys; no chain

---

## Lap 1 — pipeline to implement

Extend OA-L1 loop:

```
post → apply → accept → HOLD → RELEASE → verify (fold: held, released, completed; escrow_balance = 0)
```

| Step | Actor | Fact |
|------|-------|------|
| Post / apply / accept | (unchanged) | OA-L1 shapes |
| Hold | Poster | Receipt-core fact, memo `escrow-hold request_ref=<ref>` (or Kaeden's prefix) |
| Release | Poster | Receipt-core fact, memo `escrow-release request_ref=<ref>` (or Kaeden's prefix) |

**FoldState** grows: `held`, `released`, `escrow_balance` (i32/i64 per existing amount discipline).

**classifyFact** or memo-prefix helper distinguishes hold vs release vs OA-L1 completion (OA-L3 release *replaces* the old single-step completion payment for this lap).

---

## Welcome path (selftest)

1. Load fixture request; run full loop with deterministic keys
2. Fold → `held`, `released`, `completed` (or equivalent flags); `escrow_balance == 0`; stipend conserved
3. Print `GREEN: OA-L3 escrow — hold, release, verify on one log.`

Mirror [`tools/open_asks_lap1.rish`](../tools/open_asks_lap1.rish) witness shape.

---

## Unwelcome paths (selftest — each must refuse)

Exercise at least these; witness may rely on selftest output:

1. Release with **no prior hold**
2. Release in **wrong amount**
3. Release to **wrong applicant**
4. **Second release** on settled bounty
5. (Optional) Second hold on same request_ref

Each unwelcome path prints a clear refusal line; selftest exits 0 only after all unwelcome paths fail as expected.

---

## Deliverables checklist

| # | Deliverable |
|---|-------------|
| 1 | Extend `linengrow/open_asks.rye` — hold/release parsing, fold with invariants, selftest welcome + unwelcome |
| 2 | `tools/open_asks_lap3.rish` — build + selftest witness |
| 3 | `tools/parity.rish` — one block after OA-L2 → parity **158** |
| 4 | `tools/width-check.rish` — if file list changed |
| 5 | Update [`20260706-013012_open-asks-escrow-hammock.md`](../active-designing/20260706-013012_open-asks-escrow-hammock.md) status → landed parity **158** |
| 6 | `work-in-progress/ROADMAP.md` · `work-in-progress/TASKS.md` · `linengrow/README.md` — parity **158**, OA-L3 lap 1 checked |
| 7 | `active-designing/README.md` — OA-L3 row → **landed** when wired |
| 8 | Session log + `session-logs/README.md` index row |
| 9 | `rishi/bin/rishi run tools/parity.rish` GREEN on metal (~70s) |

---

## Commit and push (Kaeden's word on the commit)

One commit when lap 1 is GREEN:

```
Land parity 158 — OA-L3 escrow hold and release on one log.

Hold at acceptance and release at completion reuse receipt-core memo prefixes; invariants bound in fold and witness; internal test units only.
```

Then push **origin**, **github**, **gp36-codeberg**, **gp36-github**:

```bash
git push origin main
git push github main
git push gp36-codeberg main
git push gp36-github main
```

Session log in the **same commit**. Report tip hash and parity spot-check in the log.

---

## Doorway

Forward-facing scope updates need `**Status:**` naming `checkable-room` (or vision / mixed / research for understanding). Run:

```bash
rishi/bin/rishi run tools/two_rooms_doorway.rish
```

---

## Horizon (do not build in this bench)

- OA-L3 lap 2 — escrow facts over Comlink device wire
- OA-L4 — reputation fold
- SLC-L3 settlement rail
- MALA module graduation
- Sourcing-discipline `context/` note

---

*May the hold be visible before the work is done. May the release close the ledger at zero. And may parity 158 earn its number on honest metal.*
