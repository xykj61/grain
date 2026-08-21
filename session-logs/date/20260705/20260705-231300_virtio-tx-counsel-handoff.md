# Virtio TX counsel handoff for Claude

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260705.231300

## Prompt

Kaeden asked whether Rio wants to describe virtio bring-up struggles to Claude with a full session log and/or summary.

## Thinking trace

Yes — the prior pass already recommended checking in with Claude because QEMU 8.2 transitional MMIO (version 1 at slot 7, modern `queue_num_max` zero) is a width question no written policy answers. Rather than duplicate the long debug narrative in chat, I seated a counsel handoff brief Claude can rule from directly.

## What the handoff contains

`active-designing/20260705-231300_virtio-tx-counsel-handoff.md` — GREEN proofs, failure symptom (`used.idx` never advances), MMIO scan table, approaches tried, current tree layout, six explicit questions, repro commands, grain constraints. Linked from the device wire lap brief.

Prior session log `20260705-230100_device-wire-sub-lap2-grain.md` remains the step-by-step climb record.

## Files

| File | Why |
|------|-----|
| `active-designing/20260705-231300_virtio-tx-counsel-handoff.md` | Counsel brief for Claude |
| `active-designing/20260705-225412_comlink-device-wire.md` | Ground link to handoff |
| `session-logs/README.md` | Index row |

**Recommend:** check in with Claude using the handoff brief — once queue programming is ruled, keep going to sub-lap 2 linktest (mechanical); sub-lap 3 sealed payload follows the same carriage.
