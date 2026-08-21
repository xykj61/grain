# VOLS Journey 13 — Survey, the complete derived census (exploration)

**Stamp:** `20260812.215153` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — opens Journey 13 of Season 4 (Seal) in the 1,024-round itinerary
**Waymark:** **VOLS** (CION Equinox 1 — Survey, already seated; each journey is `VOLS-J<N>`)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../context/specs/20260810-222755_chronological-semantic-labeling-and-the-cion-meta-season.md`](../context/specs/20260810-222755_chronological-semantic-labeling-and-the-cion-meta-season.md) · [`../tools/fixtures/labeling_module_scan.sh`](../tools/fixtures/labeling_module_scan.sh) · [`../tools/gen/season/cion_module_labeling_witness.rish`](../tools/gen/season/cion_module_labeling_witness.rish) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 3, Commons, closed end to end — living keepers meet with consent (Skate), quorum (Membership), a whole loaded sky (Council), and a keeper's word outlives the keeper with dignity (Data-dignity). The 1,024-round itinerary names Season 4 as **Seal** — the CION meta-season, whose subject is the tree's own labels, history, and connective tissue: name them, heal them, guard them, then rest. Its first journey is **Survey (VOLS)**: *name every living count-up ID — each site, each gap — before a single relabel.*

CION already ran an opening lap under VOLS and swept seven modules by hand (`mandate`, `scribe`, `vault`, `pond`, `granary`, `scribble`, `linengrow`), each named into `tools/gen/season/cion_module_labeling_witness.rish`'s scan list. That lap proved the *pattern* — a bare `lap N` in a living surface is drift; a structured code (`lap 4b`, `OA-L3`) or `sub-lap` is not. It did not prove *completeness*: the guard scans exactly the files a human remembered to list, so a new module's README slips it in silence — the very failure that let a human, not a witness, catch red #65.

## The durable promise this journey turns on

A relabel is only as trustworthy as the census that precedes it. LOWE (the molt) will relabel living now-lines; OFFY (the debride) will cut dead ordinal tissue; GRAD (the seal) will witness the whole. Every one of them reads the survey. If the survey is a hand-list, each downstream equinox inherits its blind spots — a site nobody enumerated is a site nobody relabels, and the labeling law quietly fails exactly where no witness happens to look. So the survey's durable job is **completeness by construction**: the living-surface set is *derived* from the tree, never hand-typed, so a capability born tomorrow appears in the census the day it lands, with no one editing the tool.

A measurement grounds the stakes: a derived scan of the source tree today finds **hundreds** of living surfaces carrying a bare `lap N`, against the seven the hand-list guards. Most are honest not-yet-swept modules (`lattice`, `lantern`, `mandi`, the comlink guests); some are stable witness-handle filenames the law deliberately keeps (`tools/granary_lap1.rish` — a handle, not prose identity); some are the `seed/` projection, a derived copy rather than an independent site. The survey's crux is to name all of it *and* to tell those kinds apart, so LOWE relabels prose identity and leaves stable handles and derived copies alone.

## The crux — a census that is complete by construction and honest about its kinds

The naive survey greps for `lap N` and prints a number. A trustworthy survey **derives** its file set from the tree (so nothing is missed), **excludes dated testimony** structurally (session logs, counsel, archive, dated specs keep the ordinals they recorded — the law governs living surfaces only), and **classifies** each finding by kind so a relabel knows what to touch:

- **site** — a living prose surface (a module README, an authored `.rye`/`.rish` doc-comment, a living now-line) naming a capability by a bare `lap N`. LOWE relabels these.
- **stable handle** — a witness filename or invocation handle the law keeps as a stable identifier (Keaton's prose-only ruling). Named, never relabeled.
- **derived copy** — a `seed/` projection of a source file. Named once as its source, not double-counted.

Completeness is the crux made checkable: the census derives its inputs with `find`, so a planted living surface appears without touching the tool; a planted bare ordinal inside a dated log does **not** appear (the testimony boundary holds); and the total agrees with an independent measure — two tools, one answer — so no site hides between the survey and the maintainer's own count.

## Why this shape, against the alternatives

- **Not the hand-list guard.** `cion_module_labeling_witness` is a *gate* over a curated set — right for guarding already-swept modules, wrong for finding the unswept. The survey is a *census*: it reports every site and gap rather than failing on a curated few. The gate stays; the census feeds the gate's future growth.
- **Not "grep the whole tree for `lap`."** That drowns the signal — dated testimony, structured codes, and stable handles all carry the token honestly. The survey earns its trust precisely by drawing the testimony boundary and the kind distinctions the naive grep cannot.
- **A survey reports; it does not fail on drift.** VOLS names sites; it is GREEN when its census is *complete and honest*, however many sites exist. Failing on a nonzero site count would confuse the survey (name the work) with the seal (prove the work done) — GRAD's job, not VOLS's.

## The four rounds (Lindy-first, crux-first)

- **r1 — The derived census.** `tools/fixtures/vols_survey_scan.sh` derives the living-surface set under a given root via `find` (excluding testimony and the `seed/` projection structurally), scans each for the bare `lap N` ordinal with the refined PCRE pattern the law already uses, and emits a census: per-site lines plus totals (`surfaces` · `sites` · `hits`). `tools/gen/season/vols_survey_witness.rish` proves it on a controlled fixture tree — a living README counted, a dated log excluded, a structured code and a `sub-lap` not counted — and cross-checks the total against an independent grep measure, then reports the live source-tree census informationally. The crux made checkable: the input set is derived, the testimony boundary holds, two tools give one count.
- **r2 — Sites, handles, gaps.** Extend the census to classify each finding by kind (site · stable handle · derived copy) and to name the **gap set** — living surfaces carrying a site that no existing guard (`cion_module_labeling_witness`) yet scans. The gap set is what LOWE must grow the guard to cover; checkable that guarded ∪ gap covers every site with no surface in both.
- **r3 — The census travels.** Render the census to a `format cion-survey-v1` Bron record — the VOLS ledger LOWE reads — and parse it back byte-for-byte; unknown/missing field · bad header each refuse. A durable artifact, not a console print that scrolls away.
- **r4 — Read-true and seat the ledger.** Cross-check the rendered ledger's counts against the live derived scan (the ledger equals the tree it claims to describe), seat the VOLS survey ledger as a living pin under `work-in-progress/`, and name Journey 13 complete — the map LOWE relabels against stands on metal.

## Boundaries (custody-first)

The survey reads the tree and writes a census; it touches no key, no funds, no network, and no dated testimony (which it reads only to exclude). It opens no relabel and no cut — LOWE molts and OFFY debrides on Keaton's word, each a later journey. VOLS names the road; it does not walk it. Everything above is agent-doable and waits on no gate.

---

*May the survey miss nothing a relabel will need, keep faith with every ordinal that history earned, and hand the molt a map it can trust — every site named, every gap seen, before a single label moves.*
