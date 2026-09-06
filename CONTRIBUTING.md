# Contributing

**Language:** EN
**Style:** Gauge (see `context/GAUGE_STYLE.md`)
**Voice:** Kyri  
**Last updated:** `20260906` - pull-request title classes, three reusable body shapes, and the eight lanes
(voice molted Riyo -> Kyri `20260810`; SUNN12 `20260730.154600` seated Riyo before)

---

This proposal keeps the strictness of the `CONTRIBUTING.md` it inherited from `urbit/urbit` -- now resting, unaltered, in the elder lane at [`xykj61/urbit`](https://github.com/xykj61/urbit), where the `old/` archive stayed behind when Grain began clean -- and grows its own voice on top of it. Read both: the older document's rules still bind, and this one names what this proposal adds. Grain grows downstream as a contribution offered back to Urbit, so its own discipline deliberately mirrors Urbit's, keeping any eventual upstream pull request small, legible, and in the house style.

## Where Things Live

Start at [`ORGANIZING.md`](ORGANIZING.md) for the shape of the whole tree -- what each top-level directory is for, and where new work belongs.

## Commits

Every commit follows Urbit's own inherited discipline: **atomic**, **component-prefixed**, **under 50 characters** in the subject line, in a compiling and runnable state. Work still in progress lands on a branch, and `main` holds finished commits.

This proposal adds a voice to that structure, seated as an always-on rule at [`.claude/rules/commit-messages.md`](.claude/rules/commit-messages.md) / [`.cursor/rules/commit-messages.mdc`](.cursor/rules/commit-messages.mdc): every commit body is written in Kyri's voice at the **Meter** setting of New Gauge Style, with a short paragraph naming what changed and why, and a `Related` section, which stays present even where the work resolves a tracked issue or stands on its own.

## Pull Requests

When work is ready for review, open a pull request formatted as Urbit's own inherited convention asks:

```
### Description

Resolves #<N>.

Thoroughly describe the changes made.

### Related

Reference any related issues, links, papers, etc. here.
```

Where the work stands on its own, which is common in this proposal's exploratory passes, say so plainly rather than inventing a number: `No tracking issue; see the linked session log for context.`

## Pull Request Titles -- one bracket, then the ordinary subject

A pull request title opens with a **classification in brackets**, then the ordinary
component-prefixed subject:

```
[guard] seed: prove an allowed room actually ships
[red] caravan: a spent window read as a fault
[foundations] name the ten words a round uses
```

The bracket rides **outside** the fifty-character budget the commit subject keeps, so the
inherited rule is untouched and the class is free. One class per title: work spanning two is
usually two pull requests.

| Class | The work it names | The law it answers to |
|---|---|---|
| `[red]` | a fault found, booked with its three fields | [`reds-first`](.claude/rules/reds-first.md) |
| `[guard]` | a witness, scan, or control -- a claim made checkable | [`quality-assurance`](.claude/rules/quality-assurance.md) |
| `[foundations]` | harmony with what the foundations already say | [`foundations/README.md`](foundations/README.md) |
| `[rota]` | adherence to the council rota a lap reads | [`the-baton`](.claude/rules/the-baton.md) |
| `[designing]` | a design that outlives the code it describes | [`design-rooms`](.claude/rules/design-rooms.md) |
| `[molt]` | a rename or supersede that keeps the elder readable | [`molt`](.claude/rules/molt.md) |
| `[seed]` | the public projection and what it carries | [`git-signing`](.claude/rules/git-signing.md) |
| `[fleet]` | the ships, their loops, and the seams between lanes | [`the-baton`](.claude/rules/the-baton.md) |
| `[doc]` | teaching prose, a front door, a tutorial | [`gauge-style`](.claude/rules/gauge-style.md) |

## Pull Request Bodies -- three shapes you can reuse

Every body is New Gauge at its **Meter** setting: the mechanism in plain engineering words first,
the reason after, and a `Related` section that stays present even when there is nothing to relate.
Three classes come up often enough to be worth writing out.

**`[foundations]` -- harmony.** A foundation is read thousands of times over years, so a change to
one earns a sentence naming what a reader gains and what stays exactly as it was.

```
### Description

<what the page now says that it did not, in plain words>.

It agrees with <the foundation it must not contradict> on <the shared claim>, and
leaves <what it deliberately does not touch> unchanged.

### Related

<the foundation, the round, or "no tracking issue; this stands on its own">.
```

**`[rota]` -- adherence.** The council rota is a meter rather than a ritual: each lap deep-reads one
row of the grid, and a rota pull request says which row, what it surfaced, and what changed because
of it.

```
### Description

Row <N> of the council grid, read through <its sense>. It surfaced
<what the reading found that a summary would not have>.

Changed: <the file and the line>. Left standing: <what the reading
found and deliberately did not repair, with the reason>.

### Related

The rota's grid: recursion-prompts/seed/autonomous-loop.seed.md, section 1.
```

**`[designing]` -- progression.** Design writing earns its room by outliving the code, so the body
says which question moved and which stayed open.

```
### Description

<the question this piece answers>, and how: <the mechanism, plainly>.

Still open: <the question it leaves, sized honestly>. Superseded:
<the earlier piece, which keeps every word it wrote>.

### Related

<the earlier design, and the module the design describes>.
```

## The Eight Lanes

Work in this tree arrives through eight lanes, and a pull request names the lane rather than a
person. The lanes and their subjects live in one seat table, `construction/fleet-roster.kyri` --
read that file rather than this paragraph, since a lane is added or retired by editing one row
there. **It is named here rather than linked**, because the maintainer's own field carries it and
the public projection does not; a link would open onto nothing for most readers of this page.

Naming the lane tells a reviewer which laws your change answers to and which peer's files it must
not move without a word. It also keeps a pull request **depersonalized by construction**: the
description says what changed, the lane says where it belongs, and neither needs a name. That is
the same discipline the reader-facing documentation already keeps -- it addresses whoever is
reading rather than whoever wrote it.

## Pitching Beyond This Fork

A commit or proposal substantial enough to matter past this repository's own tree may carry a **Galaxy Pitch** block, formatted for Urbit's real Azimuth galaxy holders -- see [`.claude/rules/azimuth-galaxy-proposal-format.md`](.claude/rules/azimuth-galaxy-proposal-format.md) / [`.cursor/rules/azimuth-galaxy-proposal-format.mdc`](.cursor/rules/azimuth-galaxy-proposal-format.mdc). A commit earns that block by mattering outside this tree, so most commits leave it out.

## Signing

Every commit is GPG-signed. This repository's own signing key is recorded at [`PUBKEYS.md`](PUBKEYS.md); `.claude/rules/git-signing.md` and `.cursor/rules/git-signing.mdc` govern the discipline, and both `--no-gpg-sign` and `--no-verify` stay off the table.

## Voice

Everything you write here -- code comments, commit messages, documentation, session logs -- speaks in **New Gauge Style**, in Kyri's voice, per [`context/GAUGE_STYLE.md`](context/GAUGE_STYLE.md) and [`context/KYRI.md`](context/KYRI.md). Its first rule comes before the others: **don't be too smart about it.** Gauge inherits its warmth from [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md). Kyri gathers what prior writing seasons (Reya 2 - Rio 3 - Quin-as-writer - Riyo) each held best; **Quin** keeps the fifth OS variant and the Q-vane ([`context/QUIN.md`](context/QUIN.md)). Reader-facing documentation in `expanding-prompts/` and design research addresses a generic Acme Corporation employee rather than a named individual, per [`.claude/rules/acme-employee-voice.md`](.claude/rules/acme-employee-voice.md).

---

*May every contribution arrive small, honest, and signed -- carrying its own reason plainly, the way the tree it joins already does.*
