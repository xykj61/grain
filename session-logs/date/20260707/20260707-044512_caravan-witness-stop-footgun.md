# Caravan witness-stop footgun — counsel order committed, ring one landed

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.044512

## Thinking trace

Kaeden committed Claude's `044112` order — not a re-investigation, a sequence. This pass filed the counsel to `external-research/`, updated TASKS with the ranked climb, and landed the first ring: `witness_stop_after` footgun guard.

`subscribe_poll_service.rye` now requires `CARAVAN_WITNESS_MODE=1` when the third argument (`witness-stop-after-N`) is supplied; otherwise exit **2** with a named refusal. Existing `caravan_subscribe_poll_service.rish` sets the env var; new `caravan_witness_stop_footgun.rish` proves refusal and allowed paths.

Parity **186** GREEN (~137s; one retry after OA-L3 escrow hung on stale port — killed and reran).

## Observations

Counsel order now seated: footgun ✓ → source-crash recovery → snapshot device wire (lap 3 virtio leg) → host-mirror under supervision → TASKS sweep. MALA, Brix, Pond, continuity, sourcing note each hold on their own words. Extended-run stability deferred per counsel.

## Files

- `counsel/20260707-044112_claude-recommendation-path.md` — filed with Status line
- `caravan/subscribe_poll_service.rye` — env gate + version bump
- `tools/caravan_witness_stop_footgun.rish` — new witness
- `tools/caravan_subscribe_poll_service.rish` — sets `CARAVAN_WITNESS_MODE=1`
- `tools/parity.rish` — footgun slot
- `work-in-progress/TASKS.md` — committed order + footgun checked
- `work-in-progress/ROADMAP.md` — parity **186**

**Recommend:** keep going to source-crash recovery — mechanical Caravan ring, no new spec; check in with Claude before supervision policy changes or snapshot device wire if virtio port allocation needs counsel.
