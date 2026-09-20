# Open-Weight Companions -- a room, a rule proposal, and a first-draft guide

**Language:** EN
**Style:** New Gauge, Field setting -- Civic register, TAME lens (safety first, bound everything, say why)
**Voice:** Kyri
**Status:** Living expanding prompt -- run to completion in the same sitting that wrote it
**Stamp:** `20260920.141121`
**Kin:** [`../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md) - [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md) - [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) - [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)

## The seed

Keaton asked: take the open-weight-model and open-source-harness research already filed at
`external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md`, and use its
insights to adapt this tree's own `.claude/rules/` discipline for a future where a companion
model beside Claude -- GLM, Qwen, DeepSeek, or another open-weight checkpoint -- might sit at
this bench. Build a new `open/` room holding tutorial guides and first-draft explanations of the
open rules and harness rationale, written for a newcomer, in this tree's own constellation of
voices: Kyri as the standing voice, New Gauge as the working style, Bhakta for a reader with no
background, Radiant and Twilight as the warm and dusk registers, Civic style for naming what a
convention rewards, and TAME discipline for the code-facing half.

## Why this belongs in `open/` rather than inside an existing room

Three existing rooms were considered and set aside, each for a plain reason -- the same test
[`design-rooms.md`](../.claude/rules/design-rooms.md) and
[`comlink-tendency.md`](../.claude/rules/comlink-tendency.md) already ask of a new room's name:

- **`external-research/`** holds the *study* -- what the harness landscape and the open-weight
  field look like today, dated and cited. A tutorial teaching a newcomer how to *use* that study
  is a different document with a different lifespan; it should not compete with a dated research
  shelf for space, and it should not itself be dated testimony frozen the day it was written.
- **`.claude/rules/`** holds *law this bench follows now*. Nothing about running a non-Claude
  companion model is built, wired, or witnessed yet -- so a rule claiming otherwise would be
  exactly the false-settled-fact `docs-implementation-sync.md` and `context/TWO_ROOMS.md` both
  warn against. One proposal-shaped rule page is added (see below), honestly marked **vision**;
  the tutorials that explain it belong elsewhere.
- **`manual/`** holds guides for *this tree as it stands*, largely Cursor-and-Zed-era in its
  existing tutorials (one of which this same round retired). A room naming a horizon feature
  plainly, rather than folding it into a manual that otherwise describes what already runs, keeps
  both honest.

`open/` names itself for what it holds -- material about running *open*-weight models and *open*
harnesses beside this bench -- the same plain-word test Comlink already applies to every new
room and module.

## What ships in this round

1. **`open/README.md`** -- the front door, Gauge Door setting, Radiant-voiced close. States what
   the room is, what it is not (not a witness, not settled law), and how it relates to
   `external-research/` and `.claude/rules/`.
2. **`open/HARNESS_RATIONALE.md`** -- the technical rationale, Gauge Field setting, Civic register,
   TAME lens. Explains *why* this tree studies dsh, OpenCode, Cline, Aider, and Letta the way it
   does, what "harness" and "companion model" mean here, and what a future Tiller-named harness
   (unseated) would need to prove before this tree trusted it the way it trusts Caravan.
3. **`open/COMPANION_MODELS_GUIDE.md`** -- a first-draft, no-background tutorial in **Bhakta**
   style walking a newcomer through GLM, Qwen, DeepSeek, and Kimi: what an open-weight model is,
   why license terms matter here, and how this tree's clean-room discipline
   (`gratitude-licenses.md`) applies to studying one.
4. **`open/TWILIGHT_NOTE.md`** -- a short, earned close in **Twilight** register, since a room
   naming a horizon this far out is exactly the kind of threshold Twilight was seated for.
5. **`.claude/rules/open-weight-companions.md`** (+ no Cursor twin, since that family is
   retired) -- one proposal-shaped rule, marked **Status: Vision -- proposed, not built**, naming
   what a companion-model session would need to satisfy TAME and Gauge discipline: signed commits
   under whatever identity it authors as, session-log provenance fields naming the real model and
   provider rather than borrowing Claude's, and the same reds-first, mechanism-sentence, and
   ascii-first walls every session already meets.

## What this round does not do

- **Does not wire any actual model integration.** No code changes, no fleet-loop script for GLM
  or Qwen, no new provider config. That is a separate, much larger lap, and naming it here as
  built would be the exact false claim `docs-implementation-sync.md` refuses.
- **Does not seat the harness name.** `external-research/20260920-021139_...md` already says
  plainly: "naming a harness is Keaton's word to give." This round repeats that rather than
  quietly seating Tiller by using it as though it were settled.
- **Does not touch `tools/f/fleet-loop-codex.sh`** or any other live fleet infrastructure --
  matching the scope Keaton set for the Codex breach earlier in this same round.

## Running this prompt

Write the four `open/` files and the one rule proposal in this same sitting, cross-link them to
each other and to the external-research study and the comlink-tendency/gratitude-licenses rules
they lean on, run the standing guards (`ascii_document_witness`, `living_docs_lint`,
`mechanism_sentence_witness`), record a session log, and commit + push under the pier's own GPG
key -- the same discipline every other commit in this round already carries.
