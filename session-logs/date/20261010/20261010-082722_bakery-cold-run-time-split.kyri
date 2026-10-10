format session-log-v1
stamp 20261010.082722
editor claude-code terminal
provider anthropic
product Claude Code
role bakery -- core infrastructure, cold-run measurement
modality text
model claude-haiku-5-5
model_status active runtime unverified
voice Kyri
host Framework / cloud bench, one-clock zone America/New_York
title Bakery times the cold run's guards: the top ten hold a quarter
prompt Bakery lap on the shared build cache crux: read the card and the claim board, take step one (measure where repeated work lives), leave the build for a check-in.
think The shared cache crux is claimed on the board by bakery today (`20261010.071744`), and the 073006 lap held it for a check-in, so no build is opened here.
think Step one of bakery's own list is measurement. The newest cold transcript, session-output/standing-equipment-cold.txt, ended with run_verdict=died_unexpectedly exit_code=143, so it carries 307 timed guards, not the full roster; the figures below name that.
think The cut is by guard wall time read from the transcript's own per-line millisecond field, not from a re-run. A re-run would cost about seventy minutes and would hold the tree still for that long.
think Result: 3,363.9 s of guard time over 307 guards. The top ten take 23.8 percent and the top fifty 59.4 percent, so the long tail of 257 guards carries the other 41 percent. A cache keyed on a few hot guards would miss most of the cost.
think The 19 reds in that partial run are read as the run's own findings, not verdicts. They are not booked here; the run died before a verdict line.
obs A shared cache pays most when many guards repeat the same compile, and this split suggests the cost is spread, so the first proof should measure compile share per guard before it promises a cut.
obs The transcript refusal names a near-full disk. The root filesystem read 95 percent used (8.4G free of 176G) at this lap, which may have contributed to the death; the cause is not established by this reading.
obs Fast-forwarded five peer commits to e652a1001a before measuring; the tree was clean, so no staged work was at risk.
loom witness=standing_equipment_cold_partial guards_timed=307 total_ms=3363913 top10_share=23.8 top50_share=59.4 reds=19
rota none -- measurement lap on a claimed crux; no council row deep-read this round
orbit round 1 sign unread -- the round load table in context/SPELLBOOK.md was not read this lap
file session-logs/date/20261010/20261010-082722_bakery-cold-run-time-split.kyri this log -- the measurement and its reading
file construction/ITINERARY.md git nib carried forward to the parent of this follow-up commit
scope Measure the cold transcript's guard time split. No code, no receipt, no pin, no claim changed.
status GREEN for the measurement (307 guards timed from one transcript). Not a full-roster figure. The shared cache build is left for a check-in.
recommend check-in (claude) -- the crux is held for a ruling; the first proof wants a per-guard compile-share measurement, and a cache keyed on hot guards would miss most of the cost.
