# Security

**Language:** EN - **Style:** Gauge (see `context/GAUGE_STYLE.md`)
**Status:** Living - **Companion:** the full threat model, [`context/THREATS.md`](context/THREATS.md)

Grain is a custody-first, civic project in its incense phase. This page names how to report a weakness and what the project promises about the trust it holds; the Companion line above points to the full model.

## Reporting a vulnerability

Report privately, and give us the chance to fix it before it is public.

- **Preferred:** open a private security advisory on the repository -- GitHub's *Report a vulnerability* button under the **Security** tab. It reaches the maintainer without exposing the issue.
- **What helps:** the affected file or witness, the version (the commit nib -- every commit is GPG-signed, so the history proves exactly what you tested), and the smallest steps that show the weakness.
- **What to expect:** an honest acknowledgment that a human has read it. This is a young project with a single maintainer named plainly in the threat model; a reply is a person, not a service-level promise.

Please keep a security weakness private until it has been addressed, then feel free to open a public issue about it.

## What the project holds

The strongest security promise Grain makes is about what it keeps itself clear of holding.

- **Custody stays counsel-gated.** Grain holds no user funds and no user keys, and it never asks you to trust it with custody. Any rail that would actually move value waits on licensed counsel -- the bookkeeping surfaces record facts about money, they never hold keys.
- **Keys stay cold.** The identity master key is designed to stay offline; day-to-day work signs with a revocable subordinate key inside the enclosure, so a sandbox compromise is contained by revocation rather than a lost root. See [`context/THREATS.md`](context/THREATS.md) section1.
- **Provenance is signed.** Every commit is GPG-signed; `git log --show-signature` proves who wrote each line. The append-only log of signed facts is the permanence substrate.

## Supported versions

Grain stays pre-release, ahead of its first cut version. The living branch is `main`, and the supported surface is its current commit -- read the nib, run the witness, trust what the assertions actually check ([`context/TWO_ROOMS.md`](context/TWO_ROOMS.md): a green line means exactly what its assertions say).

## The full model

[`context/THREATS.md`](context/THREATS.md) states plainly what the pier holds, who can reach it, and what it assumes -- including the honest fact that one maintainer carries the whole project alone. It stays descriptive rather than aspirational: each line is either true today or names a gap and stops.
