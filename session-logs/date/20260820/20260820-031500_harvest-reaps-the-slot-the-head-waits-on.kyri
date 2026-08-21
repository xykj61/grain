format session-log-v1
stamp 20260820.031500
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title REDS %95 closed -- readiness reaps the slot the head is waiting on
prompt Standfast on reds: close the open agent-closable reds before new work. REDS %95 was booked open in the same lap that found it.
think The row was booked with a measurement rather than a hunch -- 2 of 12 cold runs RED on `by_readiness.idle_by_order != 0`, with nothing in the tree changing between a green run and a red one. The temptation was to soften the assert; the discipline is to find out why a readiness turn stands idle at all before touching the guard.
think So I probed the choice itself rather than reasoning about it. A print in choose_slot naming the chosen slot showed the failing run differs at exactly one turn: readiness chose slot 2 where every green run chose slot 1. My hypothesis had been that the lingering eldest became ready too early and got reaped first; the measurement said otherwise, and the measurement won.
think The root is in the module. Readiness reaps the lowest-indexed ready dependent without asking whether its going helps. The stagger lap's head asks for client_b; when client_c happens to finish first, readiness reaps client_c and empties a slot the head still cannot use. Converting nothing is exactly what this reading exists to avoid.
think So choose_slot now prefers, among the dependents already exited, the one whose going lets the head enter -- and the question is put to `rolling.admissible` itself, built over the table as it would stand with that slot gone, rather than guessed from domain names. Same door the fill asks.
think That halved the failures rather than ending them, which was the honest second finding. When the dependent the head waits on is still working, an idle turn is ordinary and no reaping order removes it. The exact-zero assertion had been counting two different things under one number: waiting a reading could have converted, and waiting nobody could.
think So the module now measures the one it can guarantee -- idle_key_ready, a turn that stood idle beside a dependent already exited whose going would have opened the door. That is the claim the RED message was already wording; only the counter it checked was wrong. Eldest-first stands 1 such turn on the stagger lap every run, readiness stands 0 by construction, and the raw idle counts are reported honestly and asserted nowhere.
obs 16 of 16 runs GREEN where 2 of 12 had been RED, and the 55-rung choir sung twice through. The two runs that still show `by readiness 1` on the raw line now show 0 on the key-ready line -- the idle turn was ordinary, and the run says which kind it was.
obs Both RED paths proven on metal. Invert the preference so readiness reaps a sibling that opens nothing, and it stands 1 or 2 key-ready idle turns. Silence the counter, and the lap refuses its own precondition, since the eldest reading must stand idle beside a ready slot for the finding to mean anything at all.
obs The lesson worth keeping is about where a flaky witness points. The temptation reads it as the assert being too strict; here it was the assert being too coarse, and underneath it a real gap in the module. A witness that fails a correct tree teaches a bench to re-run rather than to read -- and this one was failing a tree that was, in one honest respect, not correct.
loom witness=caravan_harvest_witness runs=16 red=0 prior_red=2 prior_runs=12 idle_key_ready_age=1 idle_key_ready_ready=0 red_paths_proven=2
loom witness=caravan_suite_witness rungs=55 sings=2 red=0
file caravan/harvest.rye the root fix -- choose_slot prefers the ready slot that opens the door; idle_key_ready is the number the rung guarantees
file tools/caravan_harvest_witness.rish reads the key-ready claim and leaves the machine-dependent counts unasserted, naming why
file crux/REDS.md REDS %95 closed with the diagnosis, the two RED paths, and the 16-of-16 measurement
file crux/REMEMBER.md the card carries the close rather than the open red
file caravan/README.md the sharpening recorded beside the arc's own prose
recommend keep-going the reds queue is clear again, so the next lap is a rung rather than a repair -- the reckon rung answers what a plan came to, and the question standing above it is what a supervisor does with that answer: a run whose plan reports short has learned something no rung yet acts on.
