# The Root Profile, and Keeping Context and Foundations Generically Addressed

**Language:** EN
**Version:** `20260714.015200` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — seats `GLOW_PROFILE.bron` and the generic-Acme adaptation of the living entry docs

---

## What This Decides

Two paired moves, one purpose: let the durable, teachable parts of this tree — the context disciplines and the foundation briefs — read as if written for **any** contributor (a generic Acme Corporation employee), while the parts that are genuinely specific to one professional contributor live in **one loadable place** rather than scattered through the prose.

That one place is a new root config file, **`GLOW_PROFILE.bron`** — the sibling to `GLOW_HOST.bron`.

## The Two Root Profiles, Side by Side

The fork now carries two root Bron configs, each declaring one axis of "this particular clone," each with a committed `.template` and a gitignored filled copy:

| File | Declares | Read by |
|---|---|---|
| **`GLOW_HOST.bron`** | the **host**: os, arch, toolchain paths | `tools/glow_host_run.sh` (refuses a mismatched toolchain) |
| **`GLOW_PROFILE.bron`** | the **contributor**: professional name, forge handles, clock, session-log defaults, placeholder identities | the session-logs convention and the README's setup path cite it as the single record of "who / when / how this clone is configured" |

Both are the Bron-level sibling to `.claude/rules` and `.cursor/rules`: those configure *agent behavior*; these configure the *host* and the *contributor*. All four together are how a fresh clone declares itself without editing a single shared, teachable document.

## Why a Profile at All

The `acme-employee-voice` rule already asks that reader-facing documentation — `expanding-prompts/`, design-research `external-research/`, and `context/specs/` that instruct rather than record — address a generic Acme Corporation employee, never a named individual. That rule keeps the *instructional* voice general. But it left a real, unmet need: some things a working contributor genuinely needs are specific and professional, not generic — the real name a paid contribution ships under, the forge handles, which wall clock the stamps come from, the editor and voice defaults for a session log. Those cannot honestly be "generic," and scattering them back through the docs would undo the very generality the rule exists to protect.

`GLOW_PROFILE.bron` resolves the tension the way `GLOW_HOST.bron` already resolved the toolchain-footgun tension: **name the specific thing once, in its own declarative file, and let the shared documents point at it rather than embed it.** The generic docs stay generic; the specifics stay loadable; neither has to pretend to be the other (the same Two-Rooms instinct, applied to identity rather than to claims).

## The Single-Source Discipline It Keeps

Per `../TAME_GUIDANCE.md` root rule 9 (docs and implementation stay synced), the profile does **not** copy the canonical public key fingerprints — those live in `PUBKEYS.md`, and the profile carries a `pubkeys` pointer to that record instead. Two files that both claim to hold the same fingerprints would be two claims that can drift; one canonical record plus a pointer cannot. The profile is metadata *about* the contributor that references the canonical identity record, not a second copy of it.

## What Changed in the Living Docs, On Touch

Per the fork's migrate-on-touch discipline (living files move as they are next edited; no mass sweep):

- **`README.md`** (new root front door) — written in the generic Acme voice, highlighting the four Glow OS variants as the template's central choice, and pointing at both root profiles for setup.
- **`context/README.md`** — the stale `~/veganreyklah2` workspace path corrected to the Glow OS repository; a line added naming `GLOW_PROFILE.bron` as where the specific contributor lives; the reader addressed generally; `Kaeden` → `Keaton` on this touch.
- **`foundations/README.md`** — `Kaeden` → `Keaton` on this touch; the "adaptable to any community" framing it already carried left intact.
- **`ORGANIZING.md`** — a `GLOW_PROFILE.bron` entry added beside the existing `GLOW_HOST.bron` entry.

Dated artifacts are untouched, per `dated_guard` and accrete-never-break. Session logs and decision records keep naming Keaton plainly, exactly as the `acme-employee-voice` rule's own exceptions already require — anonymizing a decision record would make it useless.

## What Remains Open

- Whether a small tool should *read* `GLOW_PROFILE.bron` (the way `glow_host_run.sh` reads `GLOW_HOST.bron`) — for example, to stamp session-log headers from the profile automatically. Today the profile is a declarative record that documents cite; wiring a reader is a natural, separately-witnessed next step if the need proves real, not built ahead of it.
- A wider audit of dated living-adjacent docs for generic-voice adaptation stays a ratchet, not a sweep — done on touch, never as one large pass.

---

*May the shared documents stay open to every reader, and may the one who signs the work be named clearly in the one place that is meant to name them.*
