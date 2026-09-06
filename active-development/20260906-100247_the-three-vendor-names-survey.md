# The three vendor names -- a survey before the molt

**Language:** EN - **Style:** Gauge, Field - **Voice:** Kyri
**Stamp:** `20260906.100247` - **Status:** Survey. **No cut is opened here.**
**Asked by:** Keaton, `20260906` -- *molt and archive any files, rules and documents associated with
ChatGPT, Cursor, and/or Grok*, widened in the same sitting to *include a breach and mitra shed prep
of all old files*, and again to *include arbor and dotfile folders too*.

A **survey** is this tree's named looking pass: walk, name every site and gap, open one checkable
door, and cut nothing (`.claude/rules/vocabulary-survey.md`). A **molt** preps; the cut stays RED
until Keaton circles it (`.claude/rules/molt.md`). This page is the map the seating is decided from.

## How this was measured, so it can be re-run

Living files are tracked files whose own basename carries no one-clock stamp and which sit outside
`date/`, `archive/`, and `yonder/` -- the tree's own test for testimony
(`.claude/rules/stamp-and-name.md`). Everything else is testimony and **never moves**.

```
git ls-files | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' | grep -vE '/date/|/archive/|/yonder/'
```

That answers **6,499 living files** on `20260906.100247`, out of 14,700-odd tracked.

## What stands, by family

| Family | Living files naming it | Tracked paths naming it | Its own rooms |
|---|---|---|---|
| **Cursor** | 353 by the bare word; **135** by a strong editor marker | 202 | `.cursor/` (53), `.cursorignore`, `tools/cu/` (6) |
| **ChatGPT / Codex / OpenAI** | **66** | 21 | `arbor/` (7 of 9), `tools/l/chatgpt-mind.*` (3), `tools/fixtures/c/chatgpt_*` (4) |
| **Grok** | **9**, of which 3 are incidental | 12 | none -- one gratitude page |

A *strong editor marker* is `.cursor/`, `cursor-agent`, `cursorignore`, `cursor_jail`, `Cursor
twin`, or `.mdc`. The gap between 353 and 135 is the first trap below.

## The four traps, each measured rather than assumed

**1. `cursor` is also the caret, and Brushstroke owns it.** `brushstroke/edit_cursor.rye` and
`brushstroke/cursor_preview.rye` are the text cursor -- the blinking caret -- and `edit_cursor.rye`
alone spells the capitalised type name `Cursor` **17 times**. A sweep on `\bcursor\b` breaks
Brushstroke. Every sweep in this molt must key on a **strong marker**, never on the word.

**2. `GROK` is an ordinary English word and the waymark list holds it.**
`tools/fixtures/f/flw-four-letter.txt` line 19 carries `GROK` between `GROG` and `GROT`. That file
is the pinned word list `tools/w/waymark_derive.rish` draws from, and
`tools/w/waymark_derive_witness.rish` proves the draw. **Editing it re-draws seated waymarks.** It
is not in scope and must be named out loud so nobody's sweep finds it.

**3. The public seed already scrubs both editor rooms.** `template-manifest.bron` reads
`scrub .cursor  # Cursor twins of the same rules` beside `scrub .claude`. So retiring `.cursor/`
changes **nothing public** -- this is entirely a private-field tidy, which lowers its risk and also
lowers its urgency.

**4. `rule_twin` is the law that makes `.cursor/` load-bearing.** 51 `.claude/rules/*.md` have 53
`.cursor/rules/*.mdc` twins, **26 of the Markdown rules end with a "Canonical Cursor twin" line**,
and `tools/r/rule_twin_witness.rish` gates the parity at **gate `%7`** in
`construction/standing-equipment.kyri`. Retiring the room retires the guard, the law, and 26
footers together, or it retires none of them.

## The seating, proposed in three tiers

Ordered Lindy-first, crux-first: the cheapest complete thing first, the structural thing last.

### Tier 1 -- Grok. One page, five edits, no guard moves.

| Site | Verdict |
|---|---|
| `gratitude/grok-grokipedia-and-the-daily-service.md` | **archive** to `gratitude/archive/`, or keep -- see the question below |
| `.claude/rules/collaboration.md` + `.cursor` twin | **breach** the phrase *Cursor/Grok bench* to the seat's own name |
| `tools/fixtures/b/bench_bakeoff_scorecard.md` | breach -- a dated bake-off's scorecard, living by path |
| `tools/gen/chapter/personalize.template.brix`, `recursion_block.brix` | breach the template mention |
| `tools/fixtures/f/flw-four-letter.txt`, `gratitude/README.md`, `gratitude/Systemantics.md` | **out of scope** -- trap 2, and two incidental mentions |

**The question Tier 1 asks:** `gratitude/` is a *thanks* record, and the licence discipline says we
keep what we learned from (`.claude/rules/gratitude-licenses.md`). Archiving a gratitude page is a
different act from retiring a tool. **Keaton's word decides whether gratitude retires with the
vendor or outlives it.**

### Tier 2 -- ChatGPT / Codex / arbor. One lane, one shed, precedent already open.

66 living files, concentrated in three places:

- **`arbor/`** -- 7 of its 9 files are ChatGPT chapter corpora
  (`launch-chatgpt-chapter{,-dark-euphoria-light-terra}.{arbor,brix,corpus.bron}`) plus
  `launch-mystery-chapter.arbor`. `README.md` and `author.sh` are the room itself.
- **The MIND supervisor family** -- `tools/l/chatgpt-mind.sh` (byte-pinned, its SHA-256 the
  adaptation receipt), `tools/l/chatgpt-mind.rish`, `tools/l/chatgpt-mind-rishi-adaptation.md`,
  four `tools/fixtures/c/chatgpt_*` controls and lane files, `.mind-state/` on disk, and
  `.claude/rules/mind-source-adaptation.md` with its twin.
- **The seats** -- `dream` (engine `codex`, status `parked`) in `construction/fleet-roster.kyri`;
  `mind` and `mystery`, off-roster by design, still known by name in `tools/f/fleet_rearm.sh`;
  `agent-jail.sh`'s whole `codex` arm; `tools/l/dream_seat_prompt.txt`.

**The shed is already open.** `construction/SHRED_PREP.md` **Class H** -- the third mitra shed,
opened `20260828`, cut still RED -- already holds `launch-mind-cardinal-chapter.rish` and
`launch-dream-dual-chapter.rish`, with the note *the Codex supervisor law at
`tools/l/chatgpt-mind.rish` is untouched*. Tier 2 is that note's other half: file the supervisor
law itself as **Class M**, bannered, citers repointed, cut RED.

**What must move first:** `fleet_rearm.sh` prints the `mind` and `mystery` pastes by name, and
`tools/f/fleet_rearm_witness.rish` asserts on `MIND_SEAT=cardinal` in both directions. Retire the
seats and those legs must go with them in the same commit, or the guard reds on every ship.

### Tier 3 -- Cursor. Structural, and it is one decision rather than many.

| Site | Count | What it is |
|---|---|---|
| `.cursor/rules/*.mdc` | 53 | canonical twins of `.claude/rules/*.md` |
| `.claude/rules/*.md` ending in a *Canonical Cursor twin* line | 26 | the law's own footer |
| `tools/cu/` | 6 | the macOS Cursor jail family and its three witnesses |
| `tools/r/rule_twin_*` | 4 | the guard, its scan, its additive scan, its control |
| `manual/tutorials/cursor-and-the-compass.md` | 1 | a whole tutorial, 3,880 bytes |
| `SOURCE.md` | 1 | **58 mentions**; Part One's stated end is *a working, jailed Cursor* |
| `CLAUDE.md`, `CONTRIBUTING.md`, `ORGANIZING.md`, `bibliography.md`, `context/specs/enclosure-editors.md` | 5 | the Dual editors posture |
| `tools/l/launch-cursor-agent.rish`, `tools/fixtures/r/rs3_launch_macos_cursor.rish` | 2 | launchers |
| `.cursorignore`, `template-manifest.bron` | 2 | the dotfile and its verdict |

**The crux is `SOURCE.md`.** Part One is written as *a first day that ends with Cursor open inside
the enclosure*. Retiring Cursor rewrites the onboarding guide's spine, not a paragraph -- and that
is the same document Keaton has already named for the fleet-insight refresh. **The two jobs are one
job**, and doing them separately would rewrite the same 45,037 bytes twice.

## The dotfile folders, named in full

Tracked root dot entries and what each is: **`.cursor`** (53 files, Tier 3), **`.claude`** (52, the
living rule room and not in scope), **`.cursorignore`** (Tier 3), **`.vscode`** (1 file -- a third
editor's settings, no vendor in this molt's list, and worth a yes-or-no in the same breath since it
is the same posture), plus `.brix`, `.gitignore`, `.gitattributes`, `.gitmodules`, which are the
tree's own.

Untracked on disk, and therefore invisible to every tracked-file guard: **`.mind-state/`** -- the
Codex supervisor's state, named by the byte-pinned `tools/l/chatgpt-mind.sh` and held out of the
`loops/` fold on purpose (`.claude/rules/read-scope.md`) -- and **`.dp_sprigs.961549`**, a stray
temporary from the dated-path tooling that belongs to nobody and should be swept whatever is
decided here.

## What this survey does not decide

**Whether the fleet still needs a second editor at all.** Eight Claude Code ships and a watch now do
what the Cursor bench did, which is the honest reason the question came up -- yet a tree that can be
worked from exactly one vendor's client has traded a dependency for a deeper one. That is a
direction question and it is Keaton's.

**Anything under `date/`, `archive/`, or `yonder/`.** Roughly 190 of the 202 Cursor paths and every
Grok path but one are dated testimony. They keep every word they wrote.

## The one checkable door this survey opens

A marker-based census that a guard can run, so the sweep is measured rather than eyeballed and so
the caret and the word list are excluded **by construction** rather than by care. Named here, built
on the word -- because a meter written before the seating would be a meter written for a shape
nobody has chosen yet.
