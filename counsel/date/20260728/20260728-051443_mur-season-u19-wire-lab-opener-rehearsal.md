# MUR Season u19 — Wire-lab opener rehearsal

**Stamp:** `20260728.051443` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u19  
**Breach:** rename-overwrite **approved · seated** · **No live rename this round**  
**Prior:** [`051309` u18 parity](20260728-051309_mur-season-u18-parity-announce-rehearsal.md) · [`050720` u14](20260728-050720_mur-season-u14-tool-wave-prep.md) step 3

## Verdict

**u32 step 3 is rehearsed.** Tool homes for the wire lab are `tools/comlink_mala_wire_lab.rish` + `comlink/run_mala_wire_lab.sh`, with one living caller in `mala_m2_witness` (becomes `murr_m2_witness` after step 1). **Guest rye stays for the module wave** unless Keaton circles a same-sitting guest rename. QEMU lab not re-run this stamp.

## Baseline (this stamp)

| Probe | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `gen_mala` | ABSENT |
| `tools/comlink_mala_wire_lab.rish` | PRESENT |
| `comlink/run_mala_wire_lab.sh` | PRESENT · execs the rish |
| `comlink/guest_mala_{mint,receipt}_{tx,rx}.rye` | PRESENT · four guests |
| Device lab GREEN re-run | **held** (QEMU heavy) — gate at live u32 |

## Dry-run — u32 step 3 (wire lab tool homes)

### Moves (when live · tool slice)

1. `git mv tools/comlink_mala_wire_lab.rish tools/comlink_murr_wire_lab.rish`
2. `git mv comlink/run_mala_wire_lab.sh comlink/run_murr_wire_lab.sh`
3. Inside shell: header + `exec … tools/comlink_murr_wire_lab.rish`
4. Inside rish: header/run-path comments · say banner `mala m2b…` → `murr m2b…` (was mala) · assert fail strings lean MUR
5. Update caller: `murr_m2_witness.rish` device line → `comlink/run_murr_wire_lab.sh` (couples with step 1)
6. Living prose citations (M2b expanding-prompt) — light path repoint

### Keep pointing at guest_mala until module wave

The rish **build lines** may still say `comlink/guest_mala_*.rye` and emit `mala-*.elf` during tool wave. That is the seated stop line: guests + wire memo prefixes ride with **u48+**.

| Held for module wave | Lean later |
| --- | --- |
| `comlink/guest_mala_*.rye` | → `guest_murr_*` |
| elf names `mala-mint-*.elf` | → `murr-mint-*.elf` with guest rename |
| `mala:*` wire memos inside guests | with module memo rename |

### Env ports (optional same-sitting)

| Today | Lean |
| --- | --- |
| `COMLINK_MALA_MINT_LAB_PORT` | `COMLINK_MUR_MINT_LAB_PORT` (accept old as alias one round if needed) |
| `COMLINK_MALA_RECEIPT_LAB_PORT` | `COMLINK_MUR_RECEIPT_LAB_PORT` |

No other tree refs to these env names today — safe to rename with the rish, or hold one round.

### Exit gate (when live)

- `sh comlink/run_murr_wire_lab.sh` GREEN (mint + receipt), **or** honest hold naming QEMU/device block
- `murr_m2_witness` still GREEN through the device stanza (or honest hold)

### Sequencing lean

Steps **1 → 2 → 3** in one sitting preferred so M2 witness never calls a missing shell. Step 4 fixtures stay after or with module rye paths.

## What this round does *not* do

No `git mv` · no guest rye rename · no QEMU re-run · no deploy/shred.

## Next

**u20** — step 4 fixture dry-run (`mala_m1_mint.bron` rye-coupled), **or** seat **kg u32** to execute steps 1–3 live.

---

*u19 wire-lab opener rehearsal · stamp `20260728.051443` · Quin*
