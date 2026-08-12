# Security

**Language:** EN · **Style:** Radiant (see [`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md))
**Status:** Living · **Companion:** the full threat model, [`context/THREATS.md`](context/THREATS.md)

Grain is a custody-first, civic project in its primordial phase. This page names how to report a weakness, what the project promises about the trust it holds, and where the full threat model lives.

## Reporting a vulnerability

Report privately, and give us the chance to fix it before it is public.

- **Preferred:** open a private security advisory on the repository — GitHub's *Report a vulnerability* button under the **Security** tab. It reaches the maintainer without exposing the issue.
- **What helps:** the affected file or witness, the version (the commit nib — every commit is GPG-signed, so the history proves exactly what you tested), and the smallest steps that show the weakness.
- **What to expect:** an honest acknowledgment that a human has read it. This is a young project with a single maintainer named plainly in the threat model; a reply is a person, not a service-level promise.

Please do not open a public issue for a security weakness until it has been addressed.

## What the project holds

The strongest security promise Grain makes is about what it *does not* hold.

- **Custody stays counsel-gated.** Grain holds no user funds and no user keys, and it never asks you to trust it with custody. Any rail that would actually move value waits on licensed counsel — the bookkeeping surfaces record facts about money, they never hold keys.
- **Keys stay cold.** The identity master key is designed to stay offline; day-to-day work signs with a revocable subordinate key inside the enclosure, so a sandbox compromise is contained by revocation rather than a lost root. See [`context/THREATS.md`](context/THREATS.md) §1.
- **Provenance is signed.** Every commit is GPG-signed; `git log --show-signature` proves who wrote each line. The append-only log of signed facts is the permanence substrate.

## Supported versions

Grain has not yet cut a released version. The living branch is `main`, and the supported surface is its current commit — read the nib, run the witness, trust what the assertions actually check ([`context/TWO_ROOMS.md`](context/TWO_ROOMS.md): a green line means what its assertions say, and no more).

## The full model

[`context/THREATS.md`](context/THREATS.md) states, without flattery, what the pier holds, who can reach it, and what it assumes — including the honest single-point-of-failure of a one-maintainer project. It is descriptive, not aspirational: each line is either true today or names a gap and stops.
