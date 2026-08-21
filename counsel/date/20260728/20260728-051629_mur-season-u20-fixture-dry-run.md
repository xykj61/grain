# MUR Season u20 — Fixture dry-run

**Stamp:** `20260728.051629` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u20  
**Breach:** rename-overwrite **approved · seated** · **No live rename this round**  
**Prior:** [`051443` u19 wire](20260728-051443_mur-season-u19-wire-lab-opener-rehearsal.md) · [`050720` u14](20260728-050720_mur-season-u14-tool-wave-prep.md) step 4

## Verdict

**u32 step 4 is rehearsed — with an honest couple.** The only mala golden fixture is `tools/fixtures/mala_m1_mint.bron`. Renaming its **path** requires two living rye path strings (`linengrow/mala.rye` · `pond/apps/drawn_terminal.rye`). The bron **body** still carries `memo mala:mint` — that memo rename waits for the **module wave**. Tool wave may end at step 3 and defer the fixture, or do a thin path-only step 4.

## Baseline (this stamp)

| Probe | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `gen_mala` | ABSENT |
| `tools/fixtures/mala_m1_mint.bron` | PRESENT · sole `*mala*` fixture |
| Body memo | `mala:mint` (module-wave content) |
| Hard path readers | `linengrow/mala.rye:48` · `pond/apps/drawn_terminal.rye:190` |

## Dry-run — u32 step 4 (fixture)

### Two seated leans

| Lean | When | Work |
| --- | --- | --- |
| **A — thin path** | tool wave wants golden name aligned | `git mv` → `murr_m1_mint.bron` · update the two rye path strings · leave `memo mala:mint` + header comment rename-forward · M1 selftest GREEN |
| **B — defer** | prefer zero rye edits in tool wave | keep path until u48 · tool wave exit after steps 1–3 GREEN |

**Default lean when kg u32 opens:** **A** if M1/M2 witnesses already renamed; **B** if a sitting wants zero rye touch.

### Moves for lean A (when live)

1. `git mv tools/fixtures/mala_m1_mint.bron tools/fixtures/murr_m1_mint.bron`
2. `linengrow/mala.rye` — path string only → `tools/fixtures/murr_m1_mint.bron` (no core/module rename)
3. `pond/apps/drawn_terminal.rye` — `mala_mint_fixture` path (+ optional const name → `murr_mint_fixture`)
4. Fixture header comment: `MUR M1 — pinned first mint… (was MALA)` · **keep** `memo mala:mint` until module memo wave
5. Expanding-prompt / ER path citations — light repoint
6. Exit: `rishi run tools/murr_m1_witness.rish` GREEN · optional `drawn-terminal thinviewtest` if that door is in the sitting

### Do not in step 4

- Rename `mala:mint` / `mala:send` / `mala:receipt` wire memos (module wave)
- Rename `linengrow/mala.rye` itself or `bin/mala`
- Touch guest rye / wire lab guests

### Inbound map (complete for this fixture)

| Path | Role |
| --- | --- |
| `linengrow/mala.rye` | selftest reads golden fact |
| `pond/apps/drawn_terminal.rye` | thinview local facts |
| M1 expanding-prompt · ER night-climb · counsel seats | prose citations |

## Tool-wave rehearsal block status

| Step | Round | State |
| --- | --- | --- |
| 1 witnesses | u17 | rehearsed · M1 baseline GREEN |
| 2 parity announces | u18 | rehearsed |
| 3 wire lab tools | u19 | rehearsed · guests held |
| 4 fixture | **u20** | rehearsed · rye-coupled · memo held |

**u32 may open** for live steps 1–3 (and 4 lean A or B) when Keaton seats it.

## What this round does *not* do

No `git mv` · no rye path edit · no memo rewrite · no deploy/shred.

## Next

**u21** — tool-wave go/no-go harden (single checklist before live u32), **or** seat **kg u32** to execute.

---

*u20 fixture dry-run · stamp `20260728.051629` · Quin*
