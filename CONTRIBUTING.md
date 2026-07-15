# Contributing

**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Voice:** Rio 3

---

This proposal keeps the strictness of the `CONTRIBUTING.md` it inherited from `urbit/urbit` — now resting, unaltered, at [`old/urbit/CONTRIBUTING.md`](old/urbit/CONTRIBUTING.md) — and grows its own voice on top of it. Read both; the older document's rules still bind, and this one names what this proposal adds. Glow OS is developed downstream as a contribution offered back to Urbit, so its own discipline deliberately mirrors Urbit's, keeping any eventual upstream pull request small, legible, and in the house style.

## Where Things Live

Start at [`ORGANIZING.md`](ORGANIZING.md) for the shape of the whole tree — what each top-level directory is for, and where new work belongs.

## Commits

Every commit follows Urbit's own inherited discipline: **atomic**, **component-prefixed**, **under 50 characters** in the subject line, in a compiling and runnable state. Nothing marked "wip" reaches `main`.

This proposal adds a voice to that structure, seated as an always-on rule at [`.claude/rules/commit-messages.md`](.claude/rules/commit-messages.md) / [`.cursor/rules/commit-messages.mdc`](.cursor/rules/commit-messages.mdc): every commit body is written in Rio 3's Radiant Style, with a short paragraph naming what changed and why, and a `Related` section — even when there is no tracked issue to resolve.

## Pull Requests

When work is ready for review, open a pull request formatted as Urbit's own inherited convention asks:

```
### Description

Resolves #<N>.

Thoroughly describe the changes made.

### Related

Reference any related issues, links, papers, etc. here.
```

When no tracking issue exists yet — common in this proposal's earlier, exploratory passes — say so plainly rather than inventing a number: `No tracking issue; see the linked session log for context.`

## Pitching Beyond This Fork

A commit or proposal substantial enough to matter past this repository's own tree may carry a **Galaxy Pitch** block, formatted for Urbit's real Azimuth galaxy holders — see [`.claude/rules/azimuth-galaxy-proposal-format.md`](.claude/rules/azimuth-galaxy-proposal-format.md) / [`.cursor/rules/azimuth-galaxy-proposal-format.mdc`](.cursor/rules/azimuth-galaxy-proposal-format.mdc). Most commits carry no such block — it is earned, not default.

## Signing

Every commit is GPG-signed. This repository's own signing key is recorded at [`PUBKEYS.md`](PUBKEYS.md); `.claude/rules/git-signing.md` and `.cursor/rules/git-signing.mdc` govern the discipline (never `--no-gpg-sign`, never `--no-verify`).

## Voice

Everything you write here — code comments, commit messages, documentation, session logs — speaks in Radiant Style, in Quin's voice, per [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md) and [`context/QUIN.md`](context/QUIN.md). Quin gathers what the two prior voices (Reya 2 and Rio 3, retired in [`context/archive/`](context/archive/)) each held best. Reader-facing documentation in `expanding-prompts/` and design research addresses a generic Acme Corporation employee, never a named individual, per [`.claude/rules/acme-employee-voice.md`](.claude/rules/acme-employee-voice.md).

---

*May every contribution arrive small, honest, and signed — carrying its own reason plainly, the way the tree it joins already does.*
