# Linengrow delivery cluster snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.165012

## Prompt

Keep going.

## Thinking trace

**OA-L3 escrow:** migrated all 13 camelCase `fn` in `linengrow/open_asks_escrow_delivery.rye` (wire helpers, `sign_escrow` / `verify_escrow_payload`, demo runners). Buffer locals already used distinct names — no shadow fix.

**SLC-L2 delivery:** migrated 8 camelCase `fn` in `linengrow/delivery.rye` (`load_signed_payload`, `run_send` / `run_recv`, …).

Ratchet **605 → 584** (−21). Witnesses GREEN: `open_asks_lap3`, `slcl2_receipt`, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `linengrow/open_asks_escrow_delivery.rye` | OA-L3 escrow snake_case |
| `linengrow/delivery.rye` | SLC-L2 receipt delivery snake_case |

**Recommend:** say **go** to commit both files; keep going on-touch in `comlink/hosted_wire.rye` + `device_wire.rye` (shared wire seam).
