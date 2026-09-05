# Four cores and six ships -- what this pier can actually carry

**Stamp:** `20260905.154858` -- **Setting:** Gauge, Field -- **Voice:** Kyri
**Question:** is there room on this pier to launch bakery, diffuser, and grass beside incense, pheromone, and petrichor?
**Short answer:** memory carries six comfortably; CPU carries about three, and the gap is wide.

## What was measured, and how

Read on the Dallas pier `20260905.154858` with `free`, `nproc`, `/proc/loadavg`, `ps`, and `df`, while
**three ships were berthed and two were actively running a lap.**

| Reading | Value |
|---|---|
| Total memory | **7,937 MB** (8 GB), **no swap configured** |
| Available memory | 6,351 MB |
| Cores | **4 vCPU**, AMD EPYC-Rome |
| Disk | 176 GB, 11% used |
| Resident memory, two live claude processes | **0.78 GB + 0.42 GB = 1.2 GB** |
| Load average, 3 ships berthed / 2 running | **1.71, 1.88, 2.06** |

## Memory: yes, comfortably

At **0.4 to 0.8 GB resident per active ship**, six ships come to roughly **3.6 GB** against **6.35 GB
available**. That leaves headroom, and disk is not remotely a constraint at 11% of 176 GB.

One caveat worth naming rather than discovering: **this pier runs with swap absent.** A machine in
that state answers memory pressure by killing a process rather than by slowing down. Six ships at
3.6 GB sits well inside the headroom; six ships each running a Zig build or a large witness at once
is a figure still to be measured, and its failure mode is an OOM kill.

## CPU: about three ships, measured

The binding constraint is the standing roster, measured on this pier today: **113 guards, 904
CPU-seconds** for one hot pass. That figure is from a clean run with `tree_moved=no`.

Six ships each running that per lap is **5,424 CPU-seconds** of guard work per lap cycle. On four
cores, perfectly parallel and with nothing else running, that is **1,356 seconds -- roughly
22 minutes of wall time per cycle spent entirely on guards**, before a single line of work is done.

This is measured rather than projected. Today two rosters ran at once on this pier -- one full pass
on petrichor and one hot pass on incense -- and the hot pass, which takes about 15 minutes alone,
spent well over 20. Two rosters already contend for four cores, and six would spend most of their
time waiting on each other.

The load average says the same thing more plainly. **1.71 with two ships running is roughly 0.7 per
active ship.** Six comes to about 4.1 on four cores, which is exactly saturation at rest, before
any roster, build, or witness spike.

## The contention curve, measured rather than derived

The first draft of this page reasoned from load averages. On Keaton's word the experiment was run
instead: **the same four guards, timed under synthetic CPU load**, so the shape of the slowdown
comes from the machine itself.

| Competing busy cores | Wall time | Against baseline | Stands for |
|---|---|---|---|
| 0 | 7,980 ms | 1.00x | one ship |
| +2 | 11,240 ms | **1.41x** | about three ships |
| +5 | 22,451 ms | **2.81x** | about six ships |

**Six ships make every ship 2.81 times slower.** The 904-second roster becomes about **2,540
seconds -- 42 minutes of guards per lap**, which exceeds the 22 minutes the first draft derived,
and which now stands as a reading rather than a projection.

**And CPU steal is 0.059% over 46 hours of uptime.** This is a shared-vCPU instance whose
neighbours are quiet, so the four cores it advertises are four cores it actually gets. That single
number decides one of the three roads below.

## The stagger, and the honest limit of it

Staggering the ships' launch is seated as `FLEET_STAGGER` in `tools/l/fleet-loop.sh`: a seat reads
its slot from the live roster and holds `(slot - 1) x FLEET_STAGGER` seconds before its first lap,
so adding a ship re-spaces the whole fleet from one table.

**An offset rather than a lock, because a lock is impossible here.** The roster is the expensive
phase, it is single-threaded, and it runs *inside* the jail -- and each jail binds exactly one tree
with its own tmpfs `/tmp`, so no writable path is shared between ships. The host chooses when a loop
starts, and that choice is the whole of the control available.

**An offset helps only while the expensive phase is under one Nth of a lap.** With a roster near a
quarter of each lap, six ships come to roughly 140% duty on a 100% window: overlap becomes
arithmetic rather than luck, and no offset avoids it. So the stagger is real relief at three or four
ships, and six needs a different lever. It is worth having, and it is worth knowing its reach.

**The lever is the roster's own size**, which has already moved once today -- 1,510s to 904s, by
removing fork loops and moving one guard to its right tier. The `cadence` tier already exists and
already runs on the fifth round; roughly half the 113 lap guards would answer the same on it.

## Three roads, and what each actually buys

**Double this machine -- 4 to 8 cores.** The curve answers this directly: five competing cores on
*eight* is the same crowding as two on four, which measured **1.41x**. So eight cores carry six
ships at roughly the per-ship speed three ships get today. One machine, one bootstrap, one set of
keys, one bill, and on most providers a resize is a reboot rather than a rebuild.

**Rebootstrap a dedicated server.** Dedicated CPU buys freedom from noisy neighbours, and **the
steal reading says there are none** -- 0.059% over 46 hours. This road buys quiet that the pier already
has, and adds a migration for it. It earns its place the day steal rises, which is one number to
re-read rather than a thing to settle now.

**Two piers, talking over the network.** Worth naming precisely, because the interesting part is
the machinery it already has: **git is the channel, and it is running.** The ships coordinate
through the anointed remote today -- `fleet_round_open.sh` adopts `xy` at every open and a lap's
send is a proposal against it. `construction/fleet-roster.kyri` names a `tree` per seat, which leaves the
loop free of any assumption about hosts. A second pier clones, and it is in the fleet.

That makes distribution nearly free in machinery and honest in cost: two bills, two bootstraps, two
sets of keys to rotate, and two hosts to keep patched. What it buys over one bigger machine is a
**failure domain** -- losing a machine costs three ships rather than six.

**A fourth road, and it is the cheapest.** Cut the roster before buying anything. Half the 113 lap
guards would answer the same on the fifth-round `cadence` clock, and the tier already exists and is
already honored. A roster near 450s makes the expensive phase small enough that the stagger starts
working, which is the one road that improves every other road.

## The recommendation, revised on the measurement

**Cut the roster, then double this machine if six ships are still wanted.** This revises the first
draft, which recommended two piers before the contention curve and the steal reading existed. Two
piers remains the right answer for *resilience*; it is the wrong answer for *capacity*, because one
8-core host reaches the same throughput for one bill and one bootstrap, and the steal reading shows
the shared instance is honest about its cores.

**The falsifier:** move the cadence-eligible guards and re-run the same four-guard timing under +5
synthetic cores. A reading at or under 1.5x means four cores carry six ships, and the
renting question closes itself. That experiment costs an afternoon.

## What this leaves for a hand

**Price.** Every figure above is capacity, measured here. What a second pier or a larger one costs
is a number that lives off this machine, and provisioning and paying is custody gate %2, which
belongs to Keaton's hand.

**Whether six ships are worth running.** Six loops produce six streams of work wanting review, and
the reviewer is a person. Capacity is the easy half of that question.
