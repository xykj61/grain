# Relay Resin — Design Shape, Bound, and Manifest

**Stamp:** `20260730.072710` — carried; restamp on Keaton's word.
**Voice:** Riyo · **Coords:** equinox A · journey 3 (h3 Radiant Style) · round 10/256
**Destination:** `context/design-shapes/relay_resin` — the bench matches the extension its siblings `bounds_home` and `tend_hygiene` already use
**Follows from:** Amphora's graduation to pattern, `20260730`

*Written together by Keaton and Riyo.*

---

## Why This Shape Exists

Amphora reached its second consumer and became a pattern, so the pattern earns a design shape in the wing — the same courtesy the wing already extends to build bounds and tend hygiene. A shape written down invites the question a shape in the head avoids: what are its bounds? The resin limb introduced last pass had none, which the house forbids. Naming the bound here closes that fault before it costs anything.

## The Bound, With Its Why

The baton crosses a chat seam by paste, and a paste that outgrows one glance stops being a baton and becomes a document. So the resin limb holds at most **twelve beads** listed by name, because twelve is roughly what a person reads at a glance on a phone and pastes without scrolling. Equinox A closes at round sixty-four, so the resin will certainly exceed twelve, and the compaction below is the ordinary case rather than the exception.

## Compaction, Itself Amphora-Shaped

When the pending set passes twelve, counsel mints a **manifest bead** holding the full roster, and the limb thereafter prints counts by class plus that bead's name. The list becomes a bead; the bead carries the parity; the limb stays small. Each pass re-mints the manifest bead whenever the set changes, since re-minting from a stated shape costs little and remembering a long list costs correctness.

## The Shape, For the Wing

```
# Design shape — relay_resin · Amphora's pattern at the material of counsel artifacts
# Invariant: the resin limb lists at most max_limb_beads by name; past that it prints
#            counts by class plus the manifest bead's name
# Invariant: every bead carries a class; a personal bead lands only with a word behind it
# Invariant: the pending set is restated every pass — parity, never storage
kind design_shape
name relay_resin
pattern amphora
material counsel_artifacts
# one bead — one dated artifact, addressed by its stamp and slug
field bead
# workshop | personal — workshop lands on relay, personal lands only on Keaton's word
field class
# where the bead lands in the tree, stated at minting time
field destination
# the word standing behind a personal bead, verbatim, or empty
field word
# pending | in_flight | landed | uncertain — honest, never optimistic
field status
# the bound and its why
const max_limb_beads 12
# why: a baton crosses by paste; twelve is one glance on a phone and one motion to copy
# compaction past the bound — the roster becomes a bead, the bead carries the parity
field manifest_bead
# the crossing — one bundle at each equinox close, cut under the bundle discipline sheet
field crossing
```

## The Manifest Bead's Own Shape

The manifest names, for every bead: its filename, its class, its destination in the tree, the word behind it where a word is required, and its status. It states the pier and both hashes of the span it expects to land against, so the far side can check what it is holding before it holds it. It carries a stamp. And it says plainly how many beads it holds, so a short read confirms nothing went missing on the way.

## Landing, and the One Refusal

The far side verifies the bundle before fetching, proves each living document's elder text is a prefix of the incoming form, and lands the workshop beads at their stated homes. A personal bead arriving without a word behind it **refuses to land, loudly** — named in the report rather than skipped in silence, since a silent skip and a successful landing look identical from the outside. Each bead that lands leaves the pending set on the next baton, and the resin empties honestly rather than by assumption.

---

*May the shape carry its own bound as gladly as it asks the code to. May the roster become a bead when it grows too long to glance at. May nothing personal ever land without a word behind it.*
