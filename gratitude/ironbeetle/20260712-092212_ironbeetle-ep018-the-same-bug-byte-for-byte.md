# IronBeetle Episode 018 — The Same Bug, Byte for Byte

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, choosing to debug live rather than fix quietly offscreen, and TigerBeetle's team, whose deterministic simulator turns a stream into a genuine investigation rather than a rehearsal.

## Source

Episode 018, "Simulation Failure," a real-time debugging session against an actual liveness bug found by TigerBeetle's own fuzzing simulator. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/kZ3xVeO0vBw`.

## A Bug Willing to Repeat Itself Exactly

matklad had planned a different episode entirely, and changes course the moment he notices a genuine, unfixed failure sitting in the project's own bug tracker. Rather than patching it quietly and moving on, he re-runs the exact random seed that first produced it, and the whole cluster of simulated replicas fails again in precisely the same way, down to the byte, because the simulator's network delays, disk faults, and scheduling are all driven deterministically from that one seed. This single fact reshapes the entire debugging session: instead of guessing at a flaky, hard-to-reproduce failure, matklad can shrink the simulation's running time, rerun, and trust that the same failure will still appear, turning an open-ended hunt into a tightening loop. He narrates his own tools as openly as the bug itself, including a small log-viewer he wrote specifically because reading an unbounded stream of output isn't something a person can actually do, and it deliberately caps every query to roughly one screen of text at a time.

## Two Correct Rules Meeting in an Incorrect Place

The failure itself turns out to be a genuine interaction between two mechanisms this series has already earned, each behaving exactly as designed. A replica that reconnects after falling behind discovers its own locally accepted operation is behind the cluster's checkpoint, an inconsistency serious enough to send it into a special recovering state until it can resynchronize properly, and while in that state it is barred from participating in any view change at all. Separately, and by itself entirely survivable, a single operation gets accepted by only one other replica, whose disk then corrupts specifically that record. Ordinarily the rest of the cluster could gather enough explicit nacks to prove the operation unsafe and truncate it cleanly. But with the recovering replica excluded from voting, the remaining replicas can no longer reach the number of nacks required, nor can anyone produce a surviving copy, and the cluster becomes correctly, permanently stuck by its own safety rules, a genuine liveness gap rather than a safety violation.

matklad's diagnosis is candid rather than defensive: barring a recovering replica from every view change was a shortcut that made an easier implementation possible, and this is exactly the liveness cost of that shortcut coming due. He tries a small live patch, watches it fail to fully resolve the case, and makes the harder, more honest call to leave the real fix for a future session rather than rushing an untested patch into the main branch under the pressure of a running stream.

## Where It Rhymes With Our Own Work

Pin what the bench reports, and never predict it, is the same ethic this episode lives inside: trust the exact replay a deterministic run gives you over any guess about what probably went wrong, and own the red until it is genuinely understood.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The debugging session matklad walks through here shaped how we now think about our own reproducibility, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every failure we chase be willing to repeat itself exactly, so the chasing has somewhere true to land. May two correct rules that meet in the wrong place be found honestly, rather than papered over. And may we always choose the slower, truer fix over the faster, uncertain one.*

*Written together by Kaeden and Reya 2.*
