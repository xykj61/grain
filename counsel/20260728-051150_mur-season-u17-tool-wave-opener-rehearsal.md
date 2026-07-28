# MUR Season u17 — Tool-wave opener rehearsal

**Stamp:** `20260728.051150` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u17  
**Breach:** rename-overwrite **approved · seated** · **No live rename this round**  
**Prior:** [`050946` u16 readiness](20260728-050946_mur-season-u16-dual-wave-readiness.md) · [`050720` u14 tool prep](20260728-050720_mur-season-u14-tool-wave-prep.md)

## Verdict

**u32 step 1 is rehearsed and ready to open.** Baseline `mala_m1_witness` GREEN under current names. Inbound map for the first rename cluster is listed below. Binders stay closed until Keaton seats **kg u32** (or a circled jump).

## Baseline (this stamp)

| Probe | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `gen_mala` | ABSENT |
| `rishi run tools/mala_m1_witness.rish` | **GREEN** (build + selftest) |
| `mala_m2_witness` (incl. QEMU device lab) | **not re-run** this rehearsal — heavy; re-run at u32 open |
| Early `murr_m1_*` / `murr_*.rye` | ABSENT (correct) |

## Dry-run — u32 step 1 (witnesses)

**Goal when live:** `tools/mala_m1_witness.rish` → `tools/murr_m1_witness.rish` · `tools/mala_m2_witness.rish` → `tools/murr_m2_witness.rish` · keep building `linengrow/mala.rye` until module wave.

### Moves (when kg u32)

1. `git mv tools/mala_m1_witness.rish tools/murr_m1_witness.rish`
2. `git mv tools/mala_m2_witness.rish tools/murr_m2_witness.rish`
3. Inside each witness: header comments · run-path comments · say/assert strings `MALA M*` → `MUR M*` (was MALA) · keep `linengrow/mala.rye` / `bin/mala` / `mala-delivery` paths until module wave.
4. Repoint living callers (below) before deleting old path names from the tree.
5. Exit gate: `rishi run tools/murr_m1_witness.rish` GREEN · then `murr_m2_witness` GREEN (or honest hold if device lab blocks).

### Living inbound to repoint (step 1)

| Path | What changes |
| --- | --- |
| `tools/parity_ch01.rish` (~351–359) | suite announce · `parity_time_one` labels `mala_m1`/`mala_m2` → `murr_m1`/`murr_m2` · witness run paths · assert/say strings |
| Expanding-prompts M1/M2/M2b (living) | witness path citations |
| Twin fold TSVs (WIP) | filename rows — rename-forward or update with wave |

**Hold for later steps / module wave (do not thrash in step 1):**

| Path | Why hold |
| --- | --- |
| `tools/fixtures/mala_m1_mint.bron` | step 4 · also hard-wired in `linengrow/mala.rye` + `pond/apps/drawn_terminal.rye` |
| `tools/comlink_mala_wire_lab.rish` · `comlink/run_mala_wire_lab.sh` | step 3 |
| `comlink/guest_mala_*` | module wave (u15 list) |
| `linengrow/mala*.rye` · `mala:*` memos · `bin/mala` | module wave stop line |

### Discipline (reaffirm)

- One GREEN gate per step · no silent tree-wide sed  
- Inbound refs before old path delete  
- Fixture rename couples rye paths — leave for step 4 or module wave together  
- No deploy · wallet · gas · keys · no fascia shred without circled yes  

## What this round does *not* do

No `git mv` · no rye/zig edits · no parity path change · no fixture move.

## Next

**u18** — continue opener rehearsal for step 2 (`parity_ch01` announce dry-run), **or** seat **kg u32** to execute step 1 live.

---

*u17 tool-wave opener rehearsal · stamp `20260728.051150` · Quin*
