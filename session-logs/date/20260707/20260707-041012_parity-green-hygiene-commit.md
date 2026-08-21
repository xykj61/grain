# Parity GREEN — hygiene commit (I6 + OA-L5 + doorway)

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.041012

**Prompt:** keep going

## Thinking trace

Kaeden said keep going after I6 and OA-L5 landed uncommitted. First action: confirm parity on metal. The prior parity run had hung for 40+ minutes on `recall-subscribe-poll-delivery demo` because `runDemo` waited on `source-loop`'s infinite `while(true)` before the fetcher child exited.

Fixed `mantra/recall_subscribe_poll_delivery.rye` `runDemo`: wait fetcher first, then `kill` source (matching `caravan/subscribe_poll_service` — no wait after kill). Wire witness GREEN in ~7s.

Full parity then failed on `two_rooms_doorway` — four counsel intakes from this session lacked `**Status:**` lines required since TWO_ROOMS seating. Added the standard research-for-understanding Status line to each.

Second parity run: **PARITY_EXIT=0** in ~130s. Committed all hygiene + OA-L5 work together.

## Observations

- The subscribe-poll demo hang was latent — production supervisor always kills source; demo path never did.
- Doorway scan is doing its job — counsel pages need the door like everything else after seating.
- Parity **184** confirmed on metal.

## Files

| File | Why |
|------|-----|
| I6 amber fixtures + witness + `amber/ring1_manifest_shape.bron` | Tilak hygiene lap |
| `linengrow/open_asks_lap5_delivery.rye` + `tools/open_asks_lap5.rish` | OA-L5 wire |
| `tools/parity.rish` | I6 + OA-L5 slots |
| `mantra/recall_subscribe_poll_delivery.rye` | Demo no longer hangs on source-loop |
| Four `external-research/20260707-*counsel*.md` | TWO_ROOMS Status lines |
| `work-in-progress/TASKS.md` + `ROADMAP.md` | Parity **184** |
| Session logs | Trace + index |

**Recommend:** keep going to OA-L5 device wire (mirror OA-L2/OA-L3 virtio lab pattern) — mechanical, single-module, policy already written in `open_asks_cross-party-delivery.md`; or pause for Kaeden word on push and next bench item.
