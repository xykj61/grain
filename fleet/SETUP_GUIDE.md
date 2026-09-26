# Fleet Setup Guide -- wiring a ship to an open-weight model

**Language:** EN
**Style:** Gauge Field, TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- a guide, proven once on one real ship, generalized for the rest
**Last updated:** `20260920.205200`
**Kin:** [`README.md`](README.md) - [`EARTH_FLEET.md`](EARTH_FLEET.md) - [`../open/SHIP_QUICKSTART_TEMPLATE.md`](../open/SHIP_QUICKSTART_TEMPLATE.md) - `../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md`

---

## What this page is, and is not

**This page is the fleet-level half of a setup that has an open-weight-model half too.** The two
halves are deliberately kept apart: this page names what is specific to *being a ship in this
fleet* (a named seat, a shared roster, a shared remote), and [`open/`](../open/README.md) names
what is specific to *reaching an open-weight model* (a provider key, a harness, a proof of
connection). A ship needs both, and neither page repeats the other's own steps.

## Part 1: what makes a checkout a ship, rather than just a clone

1. **A named seat**, entered in `construction/fleet-roster.kyri` --
   `seat <name>` and `tree grain-<name>`, following [`EARTH_FLEET.md`](EARTH_FLEET.md)'s own
   naming test if the new ship is joining the Earth fleet, or naming a fresh element's own first
   ship if not.
2. **A working tree checked out under that ship's own name**, `~/grain-<name>`, cloned from the
   same shared remotes every other ship in the fleet already pushes to.
3. **The pier's own signing key**, set up per [`git-signing.md`](../.claude/rules/git-signing.md)
   -- every commit from every ship stays GPG-signed, with no exception for a newly joined seat.
4. **A round-open habit** -- pulling the shared remotes before starting work, per
   [`the-baton.md`](../.claude/rules/the-baton.md)'s own ORDER clause, so a fresh ship never
   works from a stale tree without knowing it.

## Part 2: reaching an open-weight model, once the ship itself is real

Everything from here is the *provider and harness* half, and it lives in
[`open/`](../open/README.md) rather than being repeated on this page:

1. **Get a provider key and verify it live** -- [`open/PROVIDER_SETUP.md`](../open/PROVIDER_SETUP.md).
2. **Check any hard compliance requirement against real evidence, not just policy** --
   [`open/US_DATACENTER_POLICY.md`](../open/US_DATACENTER_POLICY.md).
3. **Wire a coding harness to the chosen provider** -- [`open/HARNESS_SETUP.md`](../open/HARNESS_SETUP.md).
4. **Or follow the generalized, ship-agnostic checklist directly** --
   [`open/SHIP_QUICKSTART_TEMPLATE.md`](../open/SHIP_QUICKSTART_TEMPLATE.md), which is exactly
   this section, written once, for every ship to reuse.

## Part 3: what one real ship's own lap looked like

`../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md`
is `incense`'s own dated record of walking through Part 2 above for the first time on this fleet --
kept whole, with its own two caught mistakes named plainly, as testimony rather than as a second
copy of the template.

## What this page does not do

**It does not stand up a new ship's actual infrastructure.** No script here creates a working
tree, registers a seat, or provisions a machine -- this page names the steps in order, and each
one is a separate, already-documented action.

**It does not repeat `open/`'s own content.** Reading this page and skipping `open/` leaves half
the work undone; the split exists so neither room duplicates the other, per the same reasoning
[`design-rooms.md`](../.claude/rules/design-rooms.md) already gives for keeping design and
development apart.
