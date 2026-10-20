format session-log-v1
stamp 20261012.151013
editor Claude Code terminal
provider Anthropic
product Claude Code
role patchouli lane, Mantra and Tally
modality text
model unverified
model_status active runtime unverified
configured_model claude-haiku-5-5
configured_reasoning medium
configured_status resolved by tools/fixtures/d/declared_model.sh resolved_model
evidence .claude/settings.json and the resolved clone config, read this lap
voice Kyri
host anonymized Framework bench, one-clock zone America/New_York
title Patchouli batch frame budget, queue reopened by a class no lap had named
prompt Run the Patchouli lane: read the inner prompt, find agent-doable work, build it if found, close with the session record.
think The inner prompt records the lane's queue as empty for twenty-nine laps, each widening by one net. The last lap named a fresh class to try.
think The unbounded-loop class had not been swept: grep for while (true) over mantra/ and tally/ found three receive loops.
think Two batch receivers return after one complete batch, so a frame budget bounds them without changing the happy path. The subscribe-poll daemon serves forever on purpose, so its lifetime bound is a policy question and stays unbuilt.
think Baseline first: recall_batch_wire and snapshot_hosted were GREEN on the untouched tree, then GREEN after the edit.
obs The batch assembler does not cap datagram count, and the timeout only ends a silent peer. A peer sending valid frames with no completion held the receive open with no named bound.
obs The TooManyFrames exit is not yet exercised by any witness. The GREEN runs prove the happy path only. A planted over-budget sender would prove the refusal, and that probe is not built this lap.
obs The REDS row for this is not booked. The lane's pin sits near its byte bound, so the row waits on headroom, the same hold the lane recorded for its earlier red.
file mantra/recall_batch_delivery.rye bounded the chunk-assembly receive loop with max_batch_frames and a named TooManyFrames exit
file mantra/snapshot_export_delivery.rye the same bound on the snapshot receive loop, byte-matched to the sibling
file session-logs/date/20261012/20261012-151013_patchouli-batch-frame-budget.kyri this record
rota none -- pure repair of a bound, no rota read this lap
file construction/ITINERARY.md Git nib carried forward to the work commit's parent, per remember-git-nib rule 5
recommend check-in (Claude) -- the subscribe-poll daemon's forever loop and the unexercised TooManyFrames refusal both want a ruling or a planted-sender probe before they are called closed
status GREEN on recall_batch_wire, snapshot_hosted, udp_reuseaddr; TooManyFrames refusal not yet witnessed; REDS row not booked, pin headroom
scope two mantra/ receive loops and the day shelf; no send beyond the commit and push
