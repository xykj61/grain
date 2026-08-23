# Contributing

**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Voice:** Kyri  
**Last updated:** `20260810` · voice molted Riyo → Kyri (SUNN12 `20260730.154600` seated Riyo before)

---

This proposal keeps the strictness of the `CONTRIBUTING.md` it inherited from `urbit/urbit` — now resting, unaltered, in the elder lane at [`xykj61/urbit`](https://github.com/xykj61/urbit), where the `old/` archive stayed behind when Grain began clean — and grows its own voice on top of it. Read both: the older document's rules still bind, and this one names what this proposal adds. Grain grows downstream as a contribution offered back to Urbit, so its own discipline deliberately mirrors Urbit's, keeping any eventual upstream pull request small, legible, and in the house style.

## Where Things Live

Start at [`ORGANIZING.md`](ORGANIZING.md) for the shape of the whole tree — what each top-level directory is for, and where new work belongs.

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

## Pitching Beyond This Fork

A commit or proposal substantial enough to matter past this repository's own tree may carry a **Galaxy Pitch** block, formatted for Urbit's real Azimuth galaxy holders — see [`.claude/rules/azimuth-galaxy-proposal-format.md`](.claude/rules/azimuth-galaxy-proposal-format.md) / [`.cursor/rules/azimuth-galaxy-proposal-format.mdc`](.cursor/rules/azimuth-galaxy-proposal-format.mdc). A commit earns that block by mattering outside this tree, so most commits leave it out.

## Signing

Every commit is GPG-signed. This repository's own signing key is recorded at [`PUBKEYS.md`](PUBKEYS.md); `.claude/rules/git-signing.md` and `.cursor/rules/git-signing.mdc` govern the discipline, and both `--no-gpg-sign` and `--no-verify` stay off the table.

## Voice

Everything you write here — code comments, commit messages, documentation, session logs — speaks in **New Gauge Style**, in Kyri's voice, per [`context/GAUGE_STYLE.md`](context/GAUGE_STYLE.md) and [`context/KYRI.md`](context/KYRI.md). Its first rule comes before the others: **don't be too smart about it.** Gauge inherits its warmth from [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md). Kyri gathers what prior writing seasons (Reya 2 · Rio 3 · Quin-as-writer · Riyo) each held best; **Quin** keeps the fifth OS variant and the Q-vane ([`context/QUIN.md`](context/QUIN.md)). Reader-facing documentation in `expanding-prompts/` and design research addresses a generic Acme Corporation employee rather than a named individual, per [`.claude/rules/acme-employee-voice.md`](.claude/rules/acme-employee-voice.md).

---

*May every contribution arrive small, honest, and signed — carrying its own reason plainly, the way the tree it joins already does.*
