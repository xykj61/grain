# Caravan host mirror under supervision

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.052212

## Prompt

Keep going — ring 4 of counsel `044112`: host-mirror under supervision, then TASKS sweep.

## Thinking trace

Counsel ranked host mirror third among Caravan hardening items because in-process mirror (`recall_subscribe_poll.rye`, parity **173**) and supervised single-pair wire (`caravan_subscribe_poll_service.rish`, parity **176**) each proved alone; nothing yet proved the pair-list loop under Caravan.

**Delivery (`recall_subscribe_poll_delivery.rye`):** added `initDemoMirrorSource` / `initDemoMirrorFetcher` and `mirror_pairs` (peerB/b + peerC/c); `source-loop-mirror` and `fetcher-poll-mirror` subcommands; mirror source holds peerB rev 1–2 and peerC rev 1 so cycle 1 syncs one revision across two pairs and later cycles stay `cycle_ok` without a hard revision floor.

**Supervisor (`subscribe_poll_service.rye`):** `CARAVAN_WITNESS_MIRROR=1` (requires `CARAVAN_WITNESS_MODE=1`) selects mirror source/fetcher subcommands; distinct GREEN line names supervised host mirror.

**Witness:** `tools/caravan_subscribe_poll_mirror_service.rish` — two cycles via `witness-stop-after-2`; asserts mirror cycle log and supervisor GREEN.

**TASKS sweep:** collapsed counsel `044112` Caravan hardening block to one landed summary; updated next-climb line.

Full parity **188** GREEN (~144s).

## Observations

Mirror mode stays witness-gated like `witness-stop-after-N` — production may adopt the same subcommands later without the env vars. The gap counsel named is closed: supervisor + two-pair poll loop run together on localhost wire.

## Files

| File | Why |
|------|-----|
| `mantra/recall_subscribe_poll_delivery.rye` | Mirror source/fetcher subcommands + pair list |
| `caravan/subscribe_poll_service.rye` | `CARAVAN_WITNESS_MIRROR` supervision path |
| `tools/caravan_subscribe_poll_mirror_service.rish` | Ring 4 witness |
| `tools/parity.rish` | Parity **188** slot |
| `work-in-progress/TASKS.md` | Ring 4 done; hardening collapsed; sweep |
| `work-in-progress/ROADMAP.md` | Parity **188** |

**Recommend:** check in with Claude before Brix first lap or Pond customs — each waits its own foundational word per counsel `044112`; mechanical Caravan queue is complete.
