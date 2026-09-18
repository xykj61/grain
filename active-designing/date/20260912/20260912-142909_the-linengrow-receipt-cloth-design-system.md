# The Linengrow Receipt Cloth Design System

**Stamp:** `20260912.142909` (EDT)
**Language:** EN
**Style:** Bhakta with Radiant warmth; Gauge at Field for measured design claims
**Voice:** Kyri
**Status:** Mixed -- living design system and implementation plan. Existing Brushstroke and Skate capabilities are checkable; new components and motion profiles remain proposed until witnessed.
**Molted from:** [`archive/20260826-022443_the-linengrow-design-theme.md`](archive/20260826-022443_the-linengrow-design-theme.md), historical testimony outside Mitra and shred-prep.
**Public inspiration:** [Bit Trading Company](https://bit-trading-company.com/) - [Shadow v2](https://bit-trading-company.com/shadow-v2/) - [ASE](https://ase.lat/) - [public repositories](https://github.com/Bit-Trading-Company)
**Design lead:** DJINN retains the visual-design seat under custody gate 6. This page adapts public patterns into Grain's own ASCII-first, bounded implementation language.

## What this system is for

Linengrow helps a person understand when their work or data carries value. Dimeroll helps a steward keep an honest account of that value. Their shared surface is a **receipt cloth**: a calm place where an offer, consent, use, value, expiration, and correction remain visible together.

- **Linengrow Skate** shows the person what they offer, who may use it, what value returns, and when permission ends.
- **Dimeroll Skate** shows the books produced by the same signed facts: value promised, earned, owed, expired, corrected, and closed.

Both applications use Brushstroke to describe frames and Skate to render them. They share tokens and components while keeping product meanings distinct.

## What the public DJINN surfaces teach

The three public sites repeat a small set of strong ideas.

**ASCII is structure.** Brackets become buttons, rules become borders, and monospaced columns become a grid. An ambient ASCII field gives atmosphere while foreground meaning stays readable.

**Motion belongs to the whole surface.** Sections reveal on one clock, pointer motion bends a field, and panels arrive as one object. The interface keeps its shape while it moves.

**Stillness is complete.** ASE checks reduced-motion preference before its introduction, restores the interface when its optional renderer fails, and offers a static composition without WebGL. Bit removes animation under reduced motion. These are safety properties and accessibility courtesies together.

**Data receives dignity.** Tabular numbers, restrained uppercase labels, visible focus, quiet borders, one accent, and explicit states let a dense terminal feel calm.

**Delight responds.** A ripple, a rule changing from `-` to `=`, a caret moving four pixels, and an amber bloom answer a person's action without taking the page away from them.

This system takes patterns as inspiration. It copies no source, logo, private identity, or unlicensed asset.

## Safe, fast, joyful

### Safe

- Meaning survives without scripts, animation, custom fonts, or color.
- Every control has a text label, keyboard path, focus-visible state, and stable reading order.
- `prefers-reduced-motion` selects the still profile before the first animated frame.
- A boot deadline restores the complete interface when an optional renderer fails.
- Value, permission, and expiration use words and symbols together.
- Personal facts begin folded. Mechanism, terms, and receipt identity begin visible.

### Fast

- The base is a fixed cell grid with declared rows, columns, palette seats, and event capacity.
- ASCII chrome is cached as a frame or glyph atlas.
- Animation runs for a transition or direct interaction and rests on a still frame afterward.
- Pointer effects have a fixed radius, pulse count, lifetime, and frame-time ceiling.
- Fonts and tokens ship locally; a fallback monospace face keeps tables aligned.

### Joyful

- Stone and Hearth remain quiet grounds; linen weave remains the material metaphor.
- Amber marks invitation. Financial direction also carries a word.
- A receipt gently brightens along the line a person reads.
- Completed consent and closed periods settle into stillness.
- Small ASCII transformations reward action: `[ open ]` becomes `[ opened ]`, and `-` grows toward `=` while bounded work completes.

## Three design layers

### Linengrow Design System -- meaning

- **Value receipt:** what data or work was offered, under which consent, for what return.
- **Consent window:** who may use it, for which purpose, until which expiration.
- **Use line:** one signed use of a valuable data product.
- **Return line:** money, service, access, attribution, or another named return.
- **Portable bundle:** the person's signed facts and receipts ready to leave with them.

### Brushstroke Linengrow System -- description

Each component declares its grid bound, semantic role, reading order, state names, tokens, motion profile, and projection bindings. Product state remains in Mantra rather than inside a mutable widget.

### Skate Linengrow System -- behavior

Skate renders fixed frames, admits bounded events, moves focus, responds to pointers inside a fixed radius, regenerates accessibility snapshots, and produces deterministic still frames for witnesses.

The layers are dual descriptions of one surface. A meaning change moves its Brushstroke declaration and Skate snapshot together under a correspondence witness.

## The shared component cloth

| Component | Linengrow reading | Dimeroll reading | Complete state |
|---|---|---|---|
| **Receipt card** | value and promised return | journal facts and recognition | every deciding field visible |
| **Consent rail** | purpose, party, duration, revoke path | authorization evidence | active or expired in words |
| **Value meter** | offered value and basis | booked amount and account | amount, unit, source, and date |
| **Use ledger** | each permitted use | each corresponding entry | counts reconcile to signed facts |
| **Expiration ribbon** | permission ending | obligation ending | stamp and consequence visible |
| **Correction leaf** | later fact supersedes an elder | adjusting entry preserves history | both facts reachable |
| **Portable bundle** | export what belongs to the person | export books a steward may carry | digest and count verified |

## Tokens and motion

- **Ground:** Stone `#DDD3BD`; Hearth `#2A2520`.
- **Surface:** Oat `#EDE5D3`; Ember `#3A332C`.
- **Invitation:** amber, paired with a word.
- **Positive value:** plant green plus `in`, `earned`, or `returned`.
- **Outgoing value:** warm clay plus `out`, `owed`, or `spent`.
- **Private:** folded texture plus `[ private ]`.
- **Expired:** a quiet rule plus the expiration stamp.
- **Type:** Vollkorn for narrative, Public Sans for interface labels where available, and a local open monospace face for receipts and meters.

**Still** renders every state and supports every action without temporal meaning.

**Settle** moves the whole view between complete states in at most one second. Its final frame equals Still.

**Respond** reacts locally to pointer, keyboard, or receipt arrival. It has fixed radius, at most four pulses, and a declared lifetime. It changes no product state.

Reduced motion, renderer loss, and a hidden document map to Still. These mappings are part of completeness.

## Simple, Lovable, Complete growth

Each milestone receives its actual one-clock stamp when it lands. Its name describes an achieved whole; forecast numbers stay out of names.

| Growth milestone | Simple | Lovable | Complete |
|---|---|---|---|
| **The receipt you can read** | one signed value receipt | warm cloth and clear consent | render, verify, refuse malformed input |
| **The consent you can change** | one permission and expiration | control stays with the person | grant, inspect, revoke, preserve history |
| **The value you can follow** | one use and one return | movement is visible without surveillance | facts reconcile through Dimeroll |
| **The bundle you can carry** | one portable export | the person can leave with dignity | export, digest, import, compare meaning |
| **The books you can trust** | one entity and closed period | calm reports with provenance | journal, statements, receipts, close |
| **The surface that moves as one** | one component family | restrained responsive motion | Still, Settle, Respond, access, bounds agree |

## The favorite-word module weave

- **Kyri** writes receipt notation; **Mantra** appends and replays facts; **Tally** bounds sizes, amounts, durations, events, and projections.
- **Brix** infuses themes and policies; **Comlink** carries sealed receipts; **Caravan** admits capabilities; **Pond** encloses applications.
- **Amphora** seals portable bundles; **Granary** stores addressed bundles; **Dimeroll** folds facts into books.
- **Mandi** lists a data product when that milestone arrives. **MUR** may record a return after legal and custody gates open; early milestones use simulated settlement.
- **Brushstroke** describes frames; **Skate** renders and admits interaction.
- **Lantern** may explain data after consent and provenance are explicit. **Mycelium** enters when several holders must agree on order. The first whole stays local.
- **Cellar** keeps completed periods and retired design testimony.

## Witnesses

- ASCII frame parity between Brushstroke and Skate.
- Still-frame equality after motion settles.
- Reduced-motion and renderer-loss equivalence.
- Keyboard, focus, and accessibility snapshot parity.
- Receipt meaning parity across Kyri, Mantra replay, Dimeroll projection, Brushstroke, and Skate.
- Contrast, frame-time, event, pulse, grid, and text-width bounds.
- A privacy witness proving folded personal fields stay absent from the public frame.

## Boundary

DJINN keeps the visual-design seat: final palette values, signature compositions, logo work, and direct extensions of his public systems wait for his invitation. Grain may build original accessible components from these general patterns and prove them on its own metal.

May every receipt feel worth keeping. May every private person remain larger than the data they choose to share. May the cloth move gently, settle quickly, and leave the truth easy to read.
