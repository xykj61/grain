# Cursor Prompt — Place the Architecture, Name Weave, Tend the Lexicon and Gratitude

*The first of two sequenced passes. This one records what is decided — the layering, the name Weave, the clarified roles — and honors what we now lean on. It captures; it builds nothing. The deeper writing follows in a focused pass after a check-in with Claude.*

**Stamp:** `<Kaeden supplies — YYYYMMDD.HHMMSS>` (the record itself carries `20260630.001812`)
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Sequence:** Pass 1 of 2. Run this first; check in with Claude before the research authoring.

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — Place the layering record

Bridge the authored file into `active-designing/20260630-001812_the-stack-and-the-surface.md` (provided by Claude). It already follows the titling convention — no number prefix, H1 leading with its concept, Radiant voice. Register it in the organizing index.

## Edit 2 — Adopt the name **Weave**

Weave is the name of the DAG backend: the append-only DAG of immutable signed facts, the substrate beneath the family. Mantra is the version-control **projection** over Weave.

- In the foundations DAG-backend document, affirm and retitle so the H1 leads with **Weave** (de-numbered, re-dated `2026-06-30`, reviewed-and-kept line, light Radiant freshening). Keep the Silo Principle — name only what is ours.
- Confirm the affirmation touches `Last updated` and the title only; no rename of the file, no reference churn, since the substrate doc is cited.

## Edit 3 — Tend the lexicon, the README, the index

In `LEXICON.md` (the lexicon), add or clarify, in Radiant one-liners:

- **Weave** — the append-only DAG of immutable signed facts; the substrate.
- **Mantra** — the version-control projection folded over Weave.
- **Brushstroke** — the surface; immediate-mode, drawing values fresh each frame, retaining no second copy.
- **Skate** — the primitive that renders a grid of text into a pixel buffer; the simplest thing a surface draws.
- **Drawn application** — a pure fold from values into a frame; the drawn terminal is its simplest form, a rich immersive surface its most advanced.

Update `README.md` (the context home) and the organizing index to register the new record and the Weave name. Keep both indexes truthful and current.

## Edit 4 — Gratitude, for what we now lean on or learn from

Add markdown entries under `gratitude/`, each pinning the license verbatim and keeping the clean-room line — *we study and run these; we never copy their source into our modules.*

- `gratitude/wayland.md` — libwayland-client, **MIT (Expat)**, quoted exactly. The host-seam display library the hosted surface links on the development machine. Note it is a dependency of the hosted build, never of Rye OS proper.
- `gratitude/river.md` — the Wayland compositor written in our systems language, **GPLv3**, quoted exactly. Honored as the lodestar for the eventual Rye-native compositor on bare metal; held at clean-room distance precisely because of its copyleft.
- `gratitude/genesis-daw.md` — the digital audio workstation that gave our systems language its reason to exist, and its bare-metal kin (a Pi-booting game, an x86 kernel example). Honored for the hot-loop discipline that is ours too: bound the loop, surprise it with no allocation, let the craft be a joy. (Inspiration, not a dependency — note its license where one applies, and that we copy nothing.)

## Verify

- The record is placed, registered, and reads in the titling convention.
- Weave is named in the substrate doc, the lexicon, the README, and the index; no dangling reference; the substrate doc affirmed in place, not renamed.
- Three gratitude entries exist with licenses quoted exactly and the clean-room line present.
- `rye build` and `tools/parity.rish` stay green on metal (docs only; confirm nothing referenced a path that moved).

## Record and Push

Commit as one honest unit — the record, the Weave naming and affirmation, the lexicon/README/index updates, the gratitude entries, and the session log. Log at `session-logs/<stamp>_architecture-and-weave.md`. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line. After this, the architecture is recorded and the gratitude is honored — and the next move is **Pass 2 (record the open threads), then check in with Claude**, because the three external-research pieces named there are Claude's to author. State it plainly: *"Recommend: run Pass 2, then check in with Claude before the research authoring."*

---

## Definition of Done

- [ ] `the-stack-and-the-surface` placed, registered, titled to convention
- [ ] Weave named in the substrate doc (affirmed in place), the lexicon, the README, and the index
- [ ] Three gratitude entries with licenses verbatim and the clean-room line
- [ ] `rye build` and parity green on metal; session log shipped; four remotes pushed; Pass 2 recommended
