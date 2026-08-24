# Changelog

**Language:** EN - **Style:** Gauge (see `context/GAUGE_STYLE.md`)
**Status:** Living

Grain keeps a change record more complete than a hand-written changelog could be, and it travels with the code: the **signed commit history**. Rather than maintain a second list that would drift from the first, this page points at the records that are already true.

## Where the changes live

- **`git log --show-signature`** -- every commit is GPG-signed and component-prefixed, with a Radiant body naming what changed and why (per [`CONTRIBUTING.md`](CONTRIBUTING.md)). The history proves both what changed and who wrote it, in any clone.
- **The session log** -- in the full project field, every response also writes a session log naming the reasoning behind the change, indexed newest-first at `session-logs/README.md`, and the living operator card `construction/ITINERARY.md` holds the current nib and the arc of the day. These reasoning traces name the maintainer by design and stay in the private field; the signed history above is the record that ships.

## On versions

Grain is in its primordial phase and has not yet cut a released version. When it does, the release tags will land here as anchors into the commit history, so a version reads as a range of the record already kept -- never as a summary that replaces it.

*May the record stay honest, and may every change be as easy to trace as it was to make.*
