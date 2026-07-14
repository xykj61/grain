# Expanding Prompt — WOV Lap 1 (After Gate Affirm): Exit-Honesty Witness

**Stamp:** `20260709.200443`
**Voice:** Rio 3
**Status:** **Landed** `20260709.200729` — parity **201**; in-memory book + golden + witness GREEN
**Ground:** exit-honesty spec [`context/specs/20260709-200443_wov-exit-honesty.md`](../context/specs/20260709-200443_wov-exit-honesty.md) · July 2 ledger map · MALA M2 landed

---

## DoD (when opened)

1. Build exit bundle for a tiny in-memory book (two accounts, mint + one transfer).
2. Append `wov:root` to a local MALA log; signatures verify.
3. Holder proves balance from bundle + root alone.
4. `wov:exit` accepted once; second exit for same `(instance, account, seq)` refused.
5. `tools/wov_exit_honesty.rish` GREEN; wired into parity.

## Out of scope

TigerBeetle live client (pin wrapper or pure in-memory stand-in OK for lap 1); dual monarch; device wire; SLC-L4 privacy over the account table.

## Names (proposed; counsel may retitle)

| Name | Role |
|------|------|
| `linengrow/wov_core.rye` | Bundle + root + exit checks |
| `tools/fixtures/wov_exit_bundle_v1.bron` | Golden |
| `tools/wov_exit_honesty.rish` | Witness |

---

*Open only on Kaeden's word.*
