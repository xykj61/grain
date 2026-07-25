# Component Compile Lap — receipt-verify under Wasmtime

*First portable seam green: `receipt_core`’s pinned verify path as a `wasm32-freestanding` guest under Wasmtime. WIT world `receipt-verify` is the contract; core ABI exports are isomorphic for lap one. Full component packaging accretes later.*

**Stamp:** `20260712.063558`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Checkable-room — tip **432** · witness `tools/receipt_verify_wasm.rish`
**Ground:** ER [`../external-research/20260712-054135_component-model-one-seed.md`](../external-research/20260712-054135_component-model-one-seed.md) · `linengrow/receipt_core.rye` · Door 3 tip **431**

---

## Claim

Same guest fold rules, one host today (Wasmtime). `verify_witness` returns 1 on the pinned path; `refuse_tampered` returns 1 when a flipped fact fails verify.

## Surfaces

| Path | Role |
|------|------|
| `linengrow/wit/receipt-verify.wit` | Contract world (imports nothing) |
| `linengrow/receipt_verify_guest.rye` | Freestanding guest exporting isomorphic C ABI |
| `tools/receipt_verify_wasm.rish` | Build + Wasmtime invoke witness |
| `tools/parity.rish` | Tip **432** |

## Host note

Wasmtime CLI must be on `PATH`, or at `tools/.cache/wasmtime/wasmtime` (gitignored pin; bench used `wasmtime-cli 31.0.0`). Guest artifact is built by the witness; not committed under `linengrow/bin/`.

## Out of scope

- Full component-model packaging / wit-bindgen
- Second host (browser / Caravan)
- Proven-seat Genode metal
- Brushstroke freestanding canvas (twin track)

---

*May one ABI carry the fold wherever a host will hold it.*
