# Reply — Quin relay: structure fix · Mand home · ring-3 · harvest · Glow floor

**Language:** EN  
**Stamp:** `20260725.120701`  
**Voice:** Quin  
**Ground:** main nib `dae4eeb647`

---

## A — `markdown_structure_witness` false positive fixed

The check now compares **column counts** (split on unescaped pipes · drop empty leading/trailing fields · mask inline `` ` `` spans and fenced blocks). PASS fixture added: `context/fixtures/markdown_structure_valid_table.md`. Lesson recorded in witness header and `context/RADIANT_STYLE.md` pass playbook.

**Full pool scan** (2,601 `.md` files, excluding intentional FAIL fixture): **2 reds remain** — not adjusted per relay:

| File | Issue |
|------|-------|
| `context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md:22` | Header 4 columns · separator 3 (`|---|---|---|` missing fourth `---`) |
| `external-research/README.md:133` | Unclosed link (truncated `](20260721-051312_li`) |

Lines 37–38 of the naming spec are valid four-column tables and **pass** under column logic.

## B — Mand module home

`mand/` seated with README · `capabilities.rye` · `tally_copy.rye` · rings 1–3. Ring-1 · ring-2 · ring-3 witnesses GREEN. Early vane-home graduation per relay order.

## C — Mand ring-3

`mand/mand_ring3.rye` — test-only reach (`witness_mode` gate) · removal fact before destroy · hold re-asserted · chain digest unchanged witness.

## D — Shell harvest

Four verbs seated in `rishi/src/main.rye` (`20260725.120701`):

| Verb | Surface |
|------|---------|
| accumulate | `fold … from … as acc item: …` |
| read bounded | `lines-bounded … max …` |
| filter chained | `where … as x: x > 2` (+ `<` `>=` `<=`) |
| quote safe | single-quoted strings in lists — `'$HOME'` literal in `run` |

Witnesses GREEN. Duty-8 shell-body retirement is the next harvest pass (verbs seated; bodies not yet migrated).

## E — Glow text floor

`glow/text_floor.rye` — `BoundedText` · `TextOverflow` · `EmptyText` · witness GREEN.

## Awaiting Keaton

Framework ritual for vere/old · data-dignity options — counsel may draft unasked.

**Recommend:** keep going on duty-8 shell-body migration now that harvest verbs are seated; check in before production Mand ring-3 key custody.

Claim: [`waymarks/20260725-120701_mand-home-ring3.md`](../../waymarks/20260725-120701_mand-home-ring3.md)
