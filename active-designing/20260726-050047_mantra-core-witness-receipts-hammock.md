# Witness Receipts — Mantra-Core Hammock (S3)

**Language:** EN  
**Stamp:** `20260726.050047`  
**Voice:** Quin  
**Status:** Hammock — design only; implementation waits for S0 cost-table numbers and Keaton's word  
**Ground:** counsel [`../counsel/20260726-044729_the-graph-is-not-a-vane.md`](../counsel/20260726-044729_the-graph-is-not-a-vane.md) · Ford Fusion demotion (graph inside Mantra, not a vane) · Ojjo consumes timings  
**Home:** Mantra (content-addressed versions over Weave) — pure core, synchronous, memoized by content  

---

## Claim

Each witness may earn a **receipt** so a FAST hand-loop can skip work the content key proves unchanged — without ever letting FAST satisfy a COLD gate. Receipts live at the tools layer as a Mantra-shaped pure function, not as a Pear/Pool/P-vane.

## Content key

```
key = SHA3(
    script_bytes
    ‖ sorted_input_hashes
    ‖ toolchain_pins
    ‖ ABSENT_set
)
```

| Part | Meaning |
|---|---|
| `script_bytes` | The witness `.rish` (or timed command identity) — self-tracking |
| `sorted_input_hashes` | Declared inputs (start coarse: module dir · script · pins); refine later the dep-file way |
| `toolchain_pins` | Zig path/version · wasmtime pin · Rye · other named pins |
| `ABSENT_set` | Ordered names of host tools ABSENT for this run |

Early cutoff: an input that rebuilds byte-identical yields the same key.

## Shelf

GREEN writes `{key, stamp, nib}` under `tools/.cache/witness-receipts/` (gitignored).

## FAST vs COLD

| Mode | Behavior |
|---|---|
| **FAST** | Consults receipts; skips holders; prints `GREEN (receipt <key> · <stamp>)`; receipt GREENS counted **separately** in the summary |
| **COLD** | Ignores the shelf entirely |

**COLD alone** unblocks H, precedes release-shaped sends, or claims the suite whole. Receipts serve the hand's loop and never the release truth.

## What may never happen

- Fabricate or receipt-launder a bare GREEN  
- Hide an ABSENT  
- Let FAST words satisfy a COLD gate  
- Optimize a witness S0 has not weighed  

## Implementation gate

Waits for:

1. S0 cost table from an instrumented full run (`work-in-progress/<stamp>_parity-cost-table.md`)  
2. Keaton's word to open the implementation lap  

No receipt code in this hammock round.

---

*May every skipped witness say its receipt out loud. May COLD stay the only truth we release on. And may the graph live where Ford ended — small, pure, and inside Mantra.*
