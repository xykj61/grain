# Cursor Prompt — Record the Open Threads, Scope the Research

*The second of two sequenced passes. This one keeps the new ideas from slipping away — the open names, the gaps, the research worth writing — by recording them where they will be found, without building any of them. The full research is Claude's to author next; this pass reserves its place.*

**Stamp:** `<Kaeden supplies — YYYYMMDD.HHMMSS>`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Sequence:** Pass 2 of 2. Run after Pass 1; then check in with Claude.

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — Record the open names in TASKS (Open Questions)

Add to `work-in-progress/TASKS.md`, under Open Questions, each as a question rather than a task to build:

- **Input** — the counterpart to drawing. Who carries keyboard and pointer events into the fold, on both the hosted and the sovereign backend? Within the surface, or beside it? The drawn terminal will ask this first.
- **Identity as a module** — does the keypair primitive earn its own home, the thing that signs a fact before it enters Weave? Today identity rests in keys kept outside the family.
- **The value-model core** — does the one value model carry a name of its own, or is it simply Rye? This governs the seam where a value crosses modules without being flattened to text.
- **Bron** — proposed, role undefined. Brix describes *what a system is made of*; what does Bron describe alongside it? Hold until the role is clear. *(Open ruling for Kaeden.)*
- **Tablecloth** — proposed layout or structured-view layer, named and not yet shaped. Hold until its shape is clear.
- **.brush** — a surface-description extension for the day Brushstroke becomes a small language of its own. Horizon; raised only when a hand-written surface proves it needs one.

## Edit 2 — Scope the three research pieces (named, reserved for Claude)

Record these in `TASKS.md` as named research to be authored by Reya 2, each a one-line scope. Do **not** create empty stub files — a document that renders nothing is scaffolding, and we keep no debt. These inform Brushstroke's design; they are horizon, not blocking the live rung.

- **Immediate-mode, the anti-retained-tree, the interface as a fold over the log** — why the surface keeps one copy and draws it, why that is single-stranded, and how a drawn application is one fold from the log to the frame. Destined for `external-research/`.
- **Designing frameworks for drawn applications, after Bret Victor** — immediate connection between creator and creation, no hidden state, direct manipulation, woven with Hickey, Gall, the TigerBeetle craft, and the hot-loop discipline. Destined for `external-research/`.
- **The hot loop as the forge — lessons from the music studio that birthed our systems language** — bound the loop, surprise it with no allocation, own the dependency surface, draw to the bare machine. Destined for `external-research/`, in gratitude.

## Edit 3 — Keep the live rung clear

Confirm `TASKS.md` still names **SLC-2a — the drawn terminal (the Skate viewer)** as the active rung in Now, unchanged by this pass. Everything recorded above is horizon. The viewer itself waits on two things, noted plainly: confirming the hosted surface seed shows a window on the development machine's compositor, and the two-backend scope brief Claude will write once that window is confirmed.

## Verify

- TASKS carries the open names and the three scoped research pieces, each clearly a question or a reservation, not a build task.
- No empty stub files were created.
- SLC-2a remains the named active rung; nothing above it was started.
- `rye build` and `tools/parity.rish` green on metal (docs only).

## Record and Push

Commit as one honest unit — the TASKS additions and the session log. Log at `session-logs/<stamp>_open-threads-and-research-scope.md`. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line, and it is almost certainly: *"Recommend: check in with Claude — the three research pieces are Claude's to author, and the SLC-2a scope brief waits on confirming the hosted window."* The organizing and capturing are done; the next moves are Claude's writing and the viewer's scope.

---

## Definition of Done

- [ ] The open names recorded in TASKS as Open Questions (Bron, Tablecloth, .brush, input, identity, value-model core)
- [ ] The three research pieces scoped in TASKS as reserved for Claude, no empty files created
- [ ] SLC-2a confirmed as the unchanged active rung; nothing above it begun
- [ ] `rye build` and parity green on metal; session log shipped; four remotes pushed; check-in with Claude recommended
