# Diffuser moonshot -- Tablecloth inbox surface

**Language:** EN
**Stamp:** `20261019.004636` (EDT)
**Voice:** Kyri
**Style:** Gauge at Field, Radiant warmth
**Status:** Living plan -- **Room:** vision
**Ship:** Diffuser (Brushstroke and Skate product surface)
**Sprig:** `diffuser-moonshot-tablecloth-inbox-surface`
**Kin:** [`../20261007-194208_aquarius-and-pisces.md`](../20261007-194208_aquarius-and-pisces.md) - [`../../construction/ITINERARY.md`](../../construction/ITINERARY.md) (Diffuser section) - [`../../context/LEXICON.md`](../../context/LEXICON.md) (Tablecloth)

## The moonshot

A person opens a Tablecloth inbox on their own device and sees, in the Skate grid, every
data product that has arrived for them: an offer from another person, a consent receipt
returning from a use, a correction notice, a settlement claim. Each item is a bounded
Tablecloth artifact, content-addressed and sealed by Amphora, waiting for the person's
word before it enters their own store. The inbox is Still by default and Settles into a
detail view on selection. No item mutates state until the person accepts or refuses it.

## What Diffuser builds toward this

1. **The inbox grid component** in Skate-Brushstroke: a bounded list of pending Tablecloth
   artifacts rendered as Receipt Cards (the 72 by 18 shape already standing in
   `skate/Sources/SkateCore/ReceiptCard.swift`). Each card shows the artifact's type,
   sender identity (Kumara public half), timestamp, and a one-line value summary. The
   grid is Still; selection Settles into the detail card.

2. **The detail view** renders the full artifact: every fact, every consent term, the
   Amphora seal, and two actions -- **accept** (moves the artifact from inbox to the
   person's Tablecloth store via Mantra append) and **refuse** (marks it refused with a
   reason, which the sender may read). Reduced-motion, renderer-loss, and accessibility
   equivalence all hold.

3. **The empty-inbox state** is a single honest line rather than a splash: "Nothing has
   arrived." The frame stays Still and the event ring stays idle.

4. **The inbox count** appears as a bounded number on the hearth display -- the home
   screen that LULU already seats. A person glancing at the phone sees how many items
   wait. The count is derived from the Tablecloth catalog query for pending artifacts,
   so it is always true.

## Acceptance conditions

- Every animated state reaches the same final frame as Still inside its declared duration.
- Accept and refuse each produce a Mantra fact the consent replay witness can verify.
- The inbox count never exceeds the Tally ceiling declared for pending artifacts.
- Accessibility snapshot, keyboard path, and text label hold for every action.
- A renderer loss returns to Still and the inbox count before a boot deadline.

## What this does not open

- Network transport: how artifacts arrive over Comlink is the JARL ladder, and the inbox
  reads from a local Tablecloth catalog rather than from the wire.
- Custody: accepting an artifact does not move money, open a rail, or create an obligation
  beyond the receipt's own terms.
- Push notifications: the inbox count is pulled on hearth refresh, never pushed from outside.

## Why this is a moonshot

The inbox is the surface where Linengrow's promise to a person becomes real. A receipt
they can read is already the first SLC milestone. An inbox they can see, accept from, and
refuse into is the second and third milestones arriving together: the consent they can
change, and the value they can follow. It composes the Receipt Card already standing,
the Skate grid already rendering, and the Tablecloth store already content-addressed,
into the one place a person actually meets their own data.
