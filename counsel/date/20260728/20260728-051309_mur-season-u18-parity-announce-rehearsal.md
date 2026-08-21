# MUR Season u18 — Parity announce dry-run

**Stamp:** `20260728.051309` · **Voice:** Quin · **Season:** MUR innermost · **Round:** u18  
**Breach:** rename-overwrite **approved · seated** · **No live rename this round**  
**Prior:** [`051150` u17 opener](20260728-051150_mur-season-u17-tool-wave-opener-rehearsal.md) · [`050720` u14 tool prep](20260728-050720_mur-season-u14-tool-wave-prep.md) step 2

## Verdict

**u32 step 2 is rehearsed.** The only living parity announce surface for MALA M1/M2 is `tools/parity_ch01.rish` lines ~351–359. Labels are free strings into `parity_time_one.sh` (cost TSV name column) — rename them with the witness paths. Prefer **same sitting as step 1** so chapter-01 never points at a missing witness.

## Baseline (this stamp)

| Probe | Result |
| --- | --- |
| `gen_murr` | GREEN · deploy RED |
| `gen_mala` | ABSENT |
| Living `MALA M1` / `MALA M2` announce homes | **only** `tools/parity_ch01.rish` |
| Other `tools/*.rish` parity chapters | no additional M1/M2 announce stanzas |
| Cost cache labels | ephemeral under `tools/.cache/parity-cost/` — not living doors |

## Dry-run — u32 step 2 (`parity_ch01`)

**Couples with:** step 1 witness `git mv` (`mala_m*_witness.rish` → `murr_m*_witness.rish`).

### Exact stanza lean (when live)

| Today | Lean |
| --- | --- |
| `say "witness suite: MALA M1…"` | `MUR M1…` (was MALA) |
| `parity_time_one.sh" "mala_m1"` | `"murr_m1"` |
| `run" "tools/mala_m1_witness.rish"` | `tools/murr_m1_witness.rish` |
| `let mala_m1` / `assert mala_m1.ok` / fail string / GREEN say | `murr_m1` · `MUR M1…` |
| same pattern for M2 | `murr_m2` · `MUR M2…` · `murr_m2_witness.rish` |

### Suggested single-block patch shape (not applied)

```
say "witness suite: MUR M1 one issuer, one holder…"
let murr_m1 = run ["sh" "tools/parity_time_one.sh" "murr_m1" "--" "rishi/bin/rishi" "run" "tools/murr_m1_witness.rish"]
assert murr_m1.ok else "MUR M1 witness failed"
say "GREEN: MUR M1 one-issuer one-holder witness passed."

say "witness suite: MUR M2 mailable Comlink (hosted + device wire)…"
let murr_m2 = run ["sh" "tools/parity_time_one.sh" "murr_m2" "--" "rishi/bin/rishi" "run" "tools/murr_m2_witness.rish"]
assert murr_m2.ok else "MUR M2 witness failed"
say "GREEN: MUR M2 mailable Comlink (hosted + device wire) witness passed."
```

### Exit gate (when live)

- Chapter child that runs M1/M2 stanzas still GREEN, **or** honest hold naming the failing witness.
- Old cost-log rows named `mala_m1` / `mala_m2` may remain in cache — dated artifacts; do not thrash cache as living rename.

### Hold (not step 2)

| Item | Owner |
| --- | --- |
| Witness file rename + internal MALA strings | step 1 |
| Wire lab / `run_mala_wire_lab.sh` | step 3 |
| Fixture `mala_m1_mint.bron` | step 4 / module (rye-coupled) |
| `linengrow/mala*.rye` · `mala:*` | module wave |

## Sequencing lean

1. Step 1 `git mv` witnesses + internal say/assert harden  
2. Step 2 this `parity_ch01` block **in the same commit or immediate next**  
3. Then step 3 wire lab  

Do not leave `parity_ch01` pointing at `tools/mala_m*_witness.rish` after those paths move.

## What this round does *not* do

No edits to `parity_ch01.rish` · no witness rename · no rye/zig · no deploy/shred.

## Next

**u19** — step 3 wire-lab opener rehearsal, **or** seat **kg u32** to execute steps 1–2 live.

---

*u18 parity announce rehearsal · stamp `20260728.051309` · Quin*
