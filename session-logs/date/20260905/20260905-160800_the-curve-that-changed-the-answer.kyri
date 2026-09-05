format session-log-v1
stamp 20260905.160800
editor Claude Code
provider Anthropic
product Claude Code
role field captain, Earth trio
modality text
model claude-opus-5
model_status configured default, runtime unverified
voice Kyri
host NixOS pier, ai-jail enclosure, America/New_York
title the curve that changed the answer
prompt stagger the laps and re-measure before we rent anything -- and compare resize, dedicated, and cross-server
think Ran the experiment rather than reasoning further. Four guards timed under synthetic CPU load: 7,980ms alone, 11,240ms with two competing cores, 22,451ms with five. Six ships make every ship 2.81 times slower, so the 904s roster becomes 42 minutes of guards per lap.
think Measured CPU steal at 0.059 percent over 46 hours of uptime. This shared vCPU instance gets the four cores it advertises, which settles the dedicated-server option on its own: it buys quiet the pier already has.
think Discovered the stagger cannot be a lock. The roster runs inside the jail, each jail binds one tree and gets its own tmpfs, so no writable path is shared between ships. The host chooses when a loop starts, and that is the whole control available.
think Named the stagger's honest reach rather than shipping a knob that implies more. An offset helps while the expensive phase is under one Nth of a lap; with a roster near a quarter of a lap, six ships are 140 percent duty on a 100 percent window and overlap becomes arithmetic.
obs Revised my own recommendation on the measurement. The first draft said two piers of three, written before the curve and the steal reading existed. One 8-core host reaches the same throughput for one bill and one bootstrap; two piers remain right for resilience and wrong for capacity.
obs The cross-server option needed the least new machinery of the three and I nearly missed why. The ships already coordinate through git on the anointed remote, so a second pier clones and joins. No new channel is wanted, which makes distribution cheap in machinery and honest in cost: two bills, two bootstraps, two key sets.
obs Caught an ordering fault in my own stagger before shipping it. The block sat above the FLEET_DRY exit, so a dry run would have slept for the seat's full offset while promising to run nothing.
loom contention guards=4 base_ms=7980 plus2_ms=11240 plus5_ms=22451 ratio2=1.41 ratio5=2.81
loom pier steal_pct=0.059 uptime_h=46 cores=4
file tools/l/fleet-loop.sh FLEET_STAGGER, slot read from the live roster, seated below the dry-run exit
file external-research/20260905-154858_four-cores-and-six-ships.md the curve, the steal reading, and the revised recommendation; A at 92
recommend check-in Keaton -- cut the roster first (free), then resize if six ships are still wanted; the falsifier costs an afternoon
