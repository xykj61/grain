# Two-way sync counsel seated + in-process lap — parity 169

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.000212

## Prompt

Kaeden relayed Claude counsel `20260707.000112` on two-way sync vs subscribe-to-changes.

## Trace

Filed counsel in `external-research/`. Applied namespace brief phrase split. Built `mantra/recall_two_way_sync.rye` — `syncBothWays` composes two `syncRevision` calls with roles swapped; witness proves had-already, duplicate revision refused, rev-2 crossing. Parity **169** GREEN.

## Observations

- Counsel: subscribe is a different lap (poll-first smallest step); wire two-way sync follows NS-L3 climb order.
- `syncRevision` needed zero changes — symmetric composition only.

## Files

- `counsel/20260707-000112_claude-counsel-two-way-sync-and-subscribe.md` — counsel (filed)
- `mantra/recall_two_way_sync.rye` — in-process two-way sync (new)
- `tools/mantra_recall_two_way_sync.rish` — witness (new)
- `tools/parity.rish` — parity 169
- `active-designing/20260706-023912_the-referential-namespace.md` — lap + horizon split
- `work-in-progress/TASKS.md` — landed + next = wire lap
- `work-in-progress/ROADMAP.md` — parity 169
- `session-logs/20260707-000212_two-way-sync-in-process-parity169.md` — this log

**Recommend:** keep going to **two-way sync wire lap** — reverse roles on existing `recall_sync_delivery` exchange; mechanical, follows NS-L3 hosted-then-device climb.
