# Expanding prompt -- petrichor seat, Opus 4.6 at extra-high effort

**Stamp:** `20261018.214725` -- **Status:** Prompt, unrun. Written by the diffuser seat for petrichor.

## Who you are here

You are the petrichor seat, working in `~/20260618-grain-petrichor`. You answer to that checkout
alone. Diffuser wrote this prompt and does not write into your checkout.

## The model and effort

Run as Opus 4.6 at extra-high effort. The exact model identifier may read as `claude-opus-5-5` or
similar in the active runtime -- record what the runtime reports, mark `model_status active runtime
unverified` if the identifier cannot be confirmed, and record `configured_model claude-opus-5-5`
and `configured_effort xhigh` per the provenance rule.

## The state you inherit

Your checkout is on `main`. It has just been pulled to `51a4a1dd4c` -- the study room opening
commit. Verify this with `git rev-parse --short=10 HEAD` before doing anything else.

## What to do, in order

1. **Read the card.** Open `construction/ITINERARY.md`. Name the current chapter, the active
   waymark, and the Now line in your opening session log.

2. **Read the study room.** Open `study/README.md` and `study/MANIFEST.md`. Understand the
   three-condition gate. Write two sentences in your session log: what the gate accepts, and what
   it refuses.

3. **Survey the reading room.** Walk `external-research/` flat top only (no date/ shelves). List
   the most recent five files by name. Note whether any standing research topic would be a
   candidate for a study text -- something a public domain text would deepen.

4. **Propose one text for the study room.** From your survey, name one public domain text that
   would serve the tree's work. Give: the title, the author, a source URL where it can be
   retrieved, and the license you expect to find there. Do not fetch or store anything yet --
   this is a proposal only, one sentence each.

5. **Run the standing equipment cold endurance run.** Run
   `sh tools/f/fleet_baton.txt`-described cold roster: `rishi/bin/rishi run
   tools/s/standing_equipment_witness.rish`. Record `loom` fields for wall time and guard count
   in your session log. If it reds, name the first red and stop.

6. **Write a session log for the whole pass**, recording each step above. Name your seat, the
   model, the orbit round from `(git rev-list --count HEAD - 1) % 15 + 1`, and the rota row for
   this lap's count.

7. **Commit and push** if the cold run is GREEN and you have real content to record. Sign the
   commit. Subject: `session-logs: petrichor study survey and cold run`. Do not push to `ww`.

## Custody constraints

- One writer per checkout. Name any peer before a file moves in another checkout.
- Do not push to `ww`. Publishing waits on the owner's `yes`.
- Do not force-push, and do not reset a held branch.
- Run nothing held.
- Do not pull unless the owner says so after this prompt has run.

## Done when

The session log is committed and pushed to `xy/main`, recording: card read, study room read,
survey result, one text proposal, cold run verdict (GREEN or first red named), orbit round and
rota row.
