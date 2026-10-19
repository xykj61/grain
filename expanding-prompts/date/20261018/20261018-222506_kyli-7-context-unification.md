# Kyli 7 -- context unification and front-door alignment

**Stamp:** `20261018.222506`
**Seat:** petrichor captain, opus xhigh
**Status:** Living -- expanding prompt
**Room:** checkable
**Style:** Gauge at Meter
**Ordering:** Lila-first, Long-Return-first (see `foundations/20261002-111449_lila-and-the-long-return.md`)

## What this chapter does

The `20261015-grain-incense` clean-slate tree carries a context structure the field tree can
adopt: voices and styles composed from a shared library, each stated once. This chapter brings
that structure into the field tree's own `context/`, upgrades the voice configuration to
**Kyli 7**, and aligns the front door with the clean-slate shape.

**Kyli 7** is the seventh version of the field tree's voice-and-style configuration. The name
comes from the composition voice that observed the clean-slate tree first. The upgrade is
structural: shared moves stated once in a library, each voice and style composing from that
library, the devotional register (Radha prema bhakti) added beside Radiant and Twilight.

## Security constraints (inherited from the parent prompt)

- Do not pull from incense in this lap or any lap going forward, except as below.
- Do not push to `ww` without Keaton's explicit word in this session.
- Do not force-push, and do not reset a held branch.
- One writer per checkout.
- ASCII-first.

## Steps -- Long Return first, Lila within each tier

### 1. Create `context/styles/lib/` -- the shared library

Read the clean-slate tree's `context/styles/lib/` for reference. Write the field tree's own
versions of:
- `shared-register.md` -- the core moves every voice keeps (from RADIANT_STYLE.md, GAUGE_STYLE.md)
- `voice-limits.md` -- what every voice keeps out
- `precision.md` -- the Gauge measurement moves (from GAUGE_STYLE.md)
- `devotional-register.md` -- the devotional register for Radha and Twilight pieces

Each page states its content once. The existing style pages (`GAUGE_STYLE.md`, `RADIANT_STYLE.md`,
`TWILIGHT_STYLE.md`, `BHAKTA_STYLE.md`, `TEACHER_STYLE.md`) stay as living pages and gain a
`**Composed from:**` line pointing at the library pages they draw on. No deletion -- accrete.

### 2. Create `context/voices/` -- voice pages composed from the library

Write voice pages for the field tree's voices:
- `kyri.md` -- the standing voice, composed from shared-register + precision
- A `README.md` index of voices

The existing `context/KYRI.md` stays as the full identity page. The new `context/voices/kyri.md`
is the composed page that points at the library, the way the clean-slate tree does.

### 3. Add `context/styles/radha.md` -- Radha prema bhakti

Bring the devotional register into the field tree as a style page. Reference the clean-slate
tree's `context/styles/radha.md` for structure. The page composes from `devotional-register.md`
and `shared-register.md`.

### 4. Update `context/README.md` -- name the new structure

Add the `styles/lib/`, `styles/`, and `voices/` rooms to the context index. Keep every existing
page. Name the structure plainly.

### 5. Write a Kyli 7 composition entry

A composition entry in `composition/` marking the upgrade: what changed, why, and what the
version number means.

### 6. Align the front door

Read the clean-slate tree's README.md for register and density. Touch the field tree's README.md
toward that shape: shorter paragraphs, one idea each, Bhakta at the Door setting for the
opening sections. The Long Return work -- will still read true in three years.

### 7. Session log and send

Write the session log in `.kyri`. Commit with the work. Push `xy`.

## What this does not do

- Delete existing style or voice pages
- Rename context files that carry inbound references
- Touch the seed projection (that catches up on its own schedule)
- Force-push or pull from a held branch
