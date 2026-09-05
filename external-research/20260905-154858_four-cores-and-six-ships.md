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

## Three roads, and what each actually buys

**Optimize here.** The roster is the whole cost, and it has already been cut once today's chapter --
1,510s to 904s by removing fork loops and moving one guard to its right tier. Two further moves are
available and neither is speculative: **stagger the ships' laps** so their rosters never overlap
(a rota over six seats rather than six independent clocks), and **widen the cadence tier**, which
already exists and already runs on the fifth round. Roughly half of the 113 lap guards would answer
the same on a fifth-round clock. That buys perhaps 3 to 4 ships on this hardware, and 6 stays out of reach.

**Rent a second pier.** Three ships per pier is a measured fit rather than a guess -- it is what
this pier runs today at load 1.7 of 4. A second identical machine carries bakery, diffuser, and
grass with the same headroom, and the fleet already supports it: `construction/fleet-roster.kyri`
names a `tree` per seat and nothing in the loop assumes one host. The cost is a second machine and
a second bootstrap, and the bootstrap is already a script (`tools/l/birth_a_clone.rish`, repaired
today to make a newborn self-contained).

**Rent one larger machine and move everything.** Eight cores would carry six ships by the same
arithmetic. This costs a migration and concentrates the fleet in one failure domain, where two piers survive
losing one machine. In its favour, one machine means one bootstrap, one set of keys, and one thing
to pay for.

## The recommendation, and its falsifier

**Two piers of three, rather than six here or one larger machine.** Three per pier is the only
figure in this document that was measured rather than derived, the fleet already reads its seat
table from a file that names a tree per seat, and two hosts is the shape that survives losing one.

**The falsifier:** stagger the laps and widen the cadence tier here first, then measure the load
average with all six berthed. A reading that holds under 3.0 on this hardware overturns this
recommendation and makes one pier enough. That experiment costs an afternoon and nothing else, so
it belongs ahead of any rental.

## What this leaves for a hand

**Price.** Every figure above is capacity, measured here. What a second pier or a larger one costs
is a number that lives off this machine, and provisioning and paying is custody gate %2, which
belongs to Keaton's hand.

**Whether six ships are worth running.** Six loops produce six streams of work wanting review, and
the reviewer is a person. Capacity is the easy half of that question.
