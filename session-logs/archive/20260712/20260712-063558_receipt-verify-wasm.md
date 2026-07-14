# receipt-verify Wasmtime — tip 432

**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3  
**Stamp:** 20260712.063558  
**Prompt:** kg opening anything

## Thinking trace

Kaeden said keep going and open anything. Next on the seated order after Door 3 was the component compile lap. Wrote WIT `receipt-verify`, freestanding guest wrapping `receipt_core`’s pinned path, built `wasm32-freestanding` with rye, invoked `verify_witness` and `refuse_tampered` under Wasmtime 31 — both return 1. Wired tip **432**. Full component packaging left for accretion; core ABI is isomorphic to the WIT world.

## Observations

- Guest imports nothing from the host (no WASI)
- Native SLC-L1 receipt witness untouched
- Witness requires `wasmtime` on PATH
- Proven-seat Genode metal remains the heaviest parked lift

## Files

| File | Why |
|------|-----|
| `linengrow/wit/receipt-verify.wit` | Contract |
| `linengrow/receipt_verify_guest.rye` | Wasm guest |
| `tools/receipt_verify_wasm.rish` · `parity.rish` | Tip **432** |
| hammock · TASKS · ROADMAP · LEXICON | Living status |

**Recommend:** hold at product tip **430** / suite **432** — proven-seat metal is the next counsel item and wants a machine plus a deliberate word — or keep going only if Kaeden wants that Genode guest sketch opened now.
