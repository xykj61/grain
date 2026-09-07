# REDS %512 -- a pen one path wide for eight ships

*Folded from the living pin [`../REDS.md`](../REDS.md) on `20260906.220000`, the row **BOOKED** --
its one instance repaired, the nine collidable pens beside it counted and left to their own lanes.*

**What the row taught, in one line:** one writer per checkout keeps two ships out of one working
directory and says nothing about the one `/tmp` all eight of them share, so a pen named for its
purpose alone is a fleet-wide race that looks exactly like a flake -- and gets recorded as one.

**How it was told from a flake, which is the part worth keeping.** Two concurrent copies of the
elder file both failed **in two different legs**. A guard that fails differently each time is
reading state it does not own; a guard that fails the same way each time is simply wrong. That
difference is the tell, and it is available on any pier without instrumenting anything.

**Kin.** [`%291`](REDS-the-booked-remainders-rows-291-330.md) seats one writer per checkout, and
this row is the sentence that widens it past the checkout.
[`%487`](REDS-a-handler-that-cleans-up-and-carries-on-rows-487.md) is the same ground vanishing
under a running script from the other direction -- there the peer that deleted the scratch was the
script's own trap handler.

---


**REDS %512 (`20260906.202423`) -- eight ships share one pier and therefore one `TMPDIR`, and a control that names its pen with a constant lets one ship delete another ship's pen mid-build.** *What went wrong:* `tools/fixtures/t/topology_point_metric_control.sh` set `PEN="${TMPDIR:-/tmp}/topology_point_metric_control_pen"`, then `rm -rf "$PEN"` at the top and `trap 'rm -rf "$PEN"' EXIT INT TERM` at the bottom. Every seat on this pier runs it on its own lap at `tier lap`, so two overlapping runs share one directory and each wipes the other's -- the reading that comes back is a fault nobody wrote. *What caught it:* a hot roster pass on a lap that touched no comlink file answered `comlink_topology red`, `bridge_dropped_named 2 wanted=1`, where the same control run alone read `faults=0 verdict=proven`. *Proven on metal, both directions:* two concurrent copies of the elder file both FAILED and **in two different legs** -- `legs_removed_exit 90` and `search_starts_late_named 2` -- which is itself the tell, since a guard that fails differently each time is reading state it does not own; two concurrent copies of the repaired file both read `verdict=proven`. *What it taught:* **`%291` reaches past the checkout.** One writer per tree keeps two ships out of one working directory, and says nothing about the one `/tmp` all eight of them share -- so a pen named by its purpose alone is a fleet-wide race that looks exactly like a flake, and gets recorded as one. The previous lap on this tree wrote *two guards read red cold and green alone... the leading read is contention* and could not tell contention from a race; this is the same observation with its mechanism found. *Repaired:* the pen carries `$$`, the spelling the sibling `topology_attained_control.sh` in the same family already used, with the reason written above the line rather than left for the next reader to re-derive. *The class, measured `20260906.202423` over `git ls-files 'tools/fixtures/*.sh'`:* **15** pen or work assignments under `TMPDIR`, of which **3** already carry `$$` and **12** name a constant. One is repaired here. Of the **11** remaining, **9 are collidable pens** -- `topology_revocation_control_pen`, `topology_floor_control_pen`, `tlb_reach_control_pen`, `tlb_reach_census_pen`, `signal_trap_control_pen`, `signal_trap_scan_work`, `footprint_latency_control_pen`, `footprint_latency_census_pen`, `fleet-lap-verdict-pen` -- one is a snapshot file (`link_witness_round_selfcheck_before.txt`) worth the same look, and one is `grain-amphora-vessel-port-38494.lock`, where a shared name is the whole point of a lock and must stay. They span five lanes, so each wants its own witness run rather than a sweep from here. **BOOKED.**
