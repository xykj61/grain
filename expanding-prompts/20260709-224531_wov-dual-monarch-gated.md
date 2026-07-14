# Expanding Prompt — WOV Dual Monarch (Gated)

**Stamp:** `20260709.224531`
**Voice:** Rio 3
**Status:** **Landed** `20260709.224634` — **D1** twin log lines; parity **205**
**Ground:** design [`../context/specs/20260709-224531_wov-dual-monarch.md`](../context/specs/20260709-224531_wov-dual-monarch.md) · exit honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md) · seam A parity **204**

---

## Affirm

Kaeden keep-going after design `224531` chose **D1**.

## DoD

1. Two monarch seeds; fact `from` A / `to` B; identical canonical bytes — GREEN.
2. Twin signatures required — GREEN (`verify_latest_root_dual`).
3. Exit bundle + prove + exit GREEN.
4. Solo-signed root refused under dual verify — GREEN.
5. Parity **205** — `tools/wov_dual_monarch.rish`.

## Out of scope (still)

Three+ monarchs; Mycelium; D2 envelope; seam B.

---

*Two keys, one body, honest exits.*
