# MUR Season u32 — Tool-wave live (steps 1–4)

**Stamp:** `20260728.053112` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u32  
**Breach:** rename-overwrite **approved · seated** · **Live tool rename this round**  
**Plan:** [u21 GO](20260728-051741_mur-season-u21-tool-wave-go-nogo.md)

## Verdict

**Tool-wave steps 1–4 LANDED GREEN.** Witnesses, parity announces, wire-lab tool homes, and fixture path (lean A) now live under `murr_*`. Module rye homes (`mala.rye` · `mala_core` · `mala:*` memos · guests) remain for **u48+**.

## What moved

| From | To |
| --- | --- |
| `tools/mala_m1_witness.rish` | `tools/murr_m1_witness.rish` |
| `tools/mala_m2_witness.rish` | `tools/murr_m2_witness.rish` |
| `tools/comlink_mala_wire_lab.rish` | `tools/comlink_murr_wire_lab.rish` |
| `comlink/run_mala_wire_lab.sh` | `comlink/run_murr_wire_lab.sh` |
| `tools/fixtures/mala_m1_mint.bron` | `tools/fixtures/murr_m1_mint.bron` |
| `parity_ch01` M1/M2 stanzas | MUR / `murr_m1` / `murr_m2` |
| `linengrow/mala.rye` fixture path | `murr_m1_mint.bron` (module file name held) |
| `pond/apps/drawn_terminal.rye` | `murr_mint_fixture` path |

**Held:** `guest_mala_*` · `mala-*.elf` build names · `memo mala:mint` · `linengrow/mala*.rye` module rename · `bin/mala`

**Env:** `COMLINK_MUR_*_LAB_PORT` (was `COMLINK_MALA_*`)

## Witnesses (this stamp)

| Gate | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `rishi run tools/murr_m1_witness.rish` | **GREEN** |
| `rishi run tools/murr_m2_witness.rish` | **GREEN** (hosted + device wire) |

## Still held (module wave)

`mala_core` / `mala.rye` / `mala_delivery` / `mala:*` / guests / `fold_mala_log` — see [u22](20260728-051844_mur-season-u22-module-wave-opener-rehearsal.md) · [u15](20260728-050833_mur-season-u15-module-wave-prep.md).

## Next

**u33** — tool-wave residual (twin-fold TSV rows · dated ER path notes · any missed living callers), **or** begin module-wave approach when he seats toward u48.

---

*u32 tool-wave live · stamp `20260728.053112` · Quin · GREEN*
