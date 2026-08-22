# Hardware & Right-to-Repair — the body you can hold

*The season where the whole vision becomes something a person can pick up, open with a small screwdriver, and mend. A device family built from honest parts, whose software already stands — proven, bounded, and forgetting on purpose — waiting for the metal.*

**Stamp:** `20260814.071700`
**Voice:** Kyri, with **Keaton Livermore** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Living — Season A front door; the software surfaces below are proven on metal, the hardware itself is a named custody gate
**Kin:** [`20260801-005853_mantrapod-venture-pitch.md`](20260801-005853_mantrapod-venture-pitch.md) · [`20260628-133212_the-device-that-forgets.md`](20260628-133212_the-device-that-forgets.md) · [`../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

> *What forgets, protects. What opens, endures.*

---

## Why this front door exists

Two journeys of Season A already stand whole and witnessed — the **Mikrophone firmware** (waymark **DREY**, thirteen proven rungs) and the **open image module** with the **Photos app** and the **parts marketplace** grown above it (waymark **HUNK**). A newcomer meeting them, though, met scattered modules and a wall of witnesses, with no single page naming what the season *is* and how its surfaces belong to one promise. This is that page: the season-level front door, tying four built surfaces into one durable claim a reader grasps in a minute.

Season A is the body you can hold. Where the language season proved the tree can think, and the surface season proved it can show a graph to a person, this season answers the plainest question a family asks: *what do I actually pick up?* The answer is a device that keeps nothing it should not keep, opens for repair instead of aging into waste, and runs software that was proven before the first board was ever ordered.

## The durable promise

**A person can hold a Grain device, trust what it forgets, and repair what wears out.** Three commitments carry that promise, and each is already load-bearing in code:

- **What forgets, protects.** The device holds your work only while you hold it; the deliberate act of keeping is yours alone. The Mikrophone proves this as a boot-time invariant, not a marketing line.
- **What opens, endures.** The body opens with a small screwdriver; parts slide out like a book returned to a shelf. The parts marketplace is built so a worn part is *found and replaced*, never a reason to discard the whole.
- **Open underneath.** Every image, every recording, every part index rests in an open format the tree owns end to end — no proprietary codec, no locked catalog, nothing a reader cannot check for themselves.

## The four surfaces — proven before the metal

### The Mikrophone — a memory that forgets on purpose

A field recorder, civic microphone, and voice terminal, firmware-first — the near-term surface of the Mantrapod ([`20260801-005853_mantrapod-venture-pitch.md`](20260801-005853_mantrapod-venture-pitch.md)). Its whole story is proven pure in Rye, so the founding promise is an invariant rather than a hope:

- The **working buffer forgets on power-down** ([`../mikrophone/session.rye`](../mikrophone/session.rye), DREY0) — a capture held only while powered, zeroed whole when the power leaves.
- A keeper **strikes a private span before the keep** ([`../mikrophone/redact.rye`](../mikrophone/redact.rye), DREY10) — the struck bytes as gone as a powered-down buffer, no residue a later read could recover.
- Only a **deliberately committed run crosses the wire**, verify-before-trust, through a self-describing frame that refuses six corruptions by name ([`../mikrophone/wire.rye`](../mikrophone/wire.rye) · [`../mikrophone/firmware.rye`](../mikrophone/firmware.rye), DREY1 · DREY3).
- The far-side **desk keeps only the proven**, addresses by content, and converges git-style through one bounded pull ([`../mikrophone/inbox.rye`](../mikrophone/inbox.rye) · [`../mikrophone/archive.rye`](../mikrophone/archive.rye) · [`../mikrophone/catalog.rye`](../mikrophone/catalog.rye) · [`../mikrophone/sync.rye`](../mikrophone/sync.rye), DREY4–DREY12).

Front door: [`../mikrophone/README.md`](../mikrophone/README.md). One-command proof: [`../tools/drey_witness.rish`](../tools/drey_witness.rish) runs all thirteen rungs from cold and asserts each GREEN.

### The open image module — verified bytes that decode to a grid

An image is verified bytes that **decode, deterministically and within named bounds, to a pixel grid** — a malformed stream refuses by name rather than painting garbage. The tree owns both halves of a real lossless codec so the property that matters is provable on metal: `decode(encode(pm))` recovers the pixmap byte-for-byte, across every chunk kind ([`../image/qoi.rye`](../image/qoi.rye), HUNK0; witness [`../tools/hunk_qoi_witness.rish`](../tools/hunk_qoi_witness.rish)). A decoded image becomes a **content-addressed Tablecloth artifact** whose every bead is proven against its digest before a pixel is read ([`../pond/apps/image_artifact.rye`](../pond/apps/image_artifact.rye), HUNK1), and lowers straight into **Skate** paint ([`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye), HUNK2).

### Photos — the app named plainly

The first things a Photos app is *for*, each a pure bounded function over the decoded grid that leaves its source untouched: **crop, flip, rotate, scale, adjust, and a family of filters** ([`../image/photos.rye`](../image/photos.rye), HUNK3+). Every gesture records **as data** in a non-destructive edit-list, so the original is never wounded and an edited image never needs its pixels stored — only the pair of source and edit-list, replayed deterministically ([`../image/photo_edits.rye`](../image/photo_edits.rye), HUNK11). No edit is a wound; every edit travels.

### The parts marketplace — repair made findable

Built in the shape of **McMaster-Carr**: one massive sprite image, each product rendered as an index into that single image — the render trick that makes a catalog of thousands feel instant. Tablecloth holds the sprite in the open image format above; Skate and Brushstroke paint it; the catalog faceted, searched, and sorted so a keeper finds the exact part a worn device needs ([`../image/sprite.rye`](../image/sprite.rye) · [`../image/part_catalog.rye`](../image/part_catalog.rye) · [`../image/part_facets.rye`](../image/part_facets.rye)). Right-to-repair is not a slogan here; it is a working index from a broken part to its replacement.

## The gates — honestly named

Software proves; hardware waits for the keeper's hand. This season keeps its gates plainly:

- **Real hardware is custody gate #2.** Ordering, provisioning, and flashing a physical board is Keaton's own act, never an autonomous one — the code proves the behavior a board will carry, and stops at the metal.
- **The refurbished-parts rail is custody gate #3.** Sourcing certified-refurbished Bluetooth, speakers, and cameras through MCP-friendly marketplaces is real-world procurement, counsel- and keeper-gated.
- **The Grainphone hybrid stays a research horizon.** A color e-ink touchscreen, a single front-and-back camera, and the refurb-parts sourcing each want a web-search research round before code — named ([`../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md)), not yet run, so no part here is fabricated.

## Gratitude, siloed

Season A studies the world clean-room and thanks its teachers plainly: **QOI** (the "Quite OK Image" format — public spec only, [`../gratitude/qoi.md`](../gratitude/qoi.md)), **McMaster-Carr** (the single-sprite render trick), and the common **iCloud Photos / Google Photos** crop and non-destructive-edit gestures (concept only). Each is thanked, studied through the clean room, and siloed — never a line of their code in ours.

---

*May the device forget what it should, and keep only what a hand chose on purpose. May the screwdriver always fit, the part always be found, and the picture always decode true. The software stands proven and waiting; may the metal, when it comes, be as honest as the code that already knows its shape.*
