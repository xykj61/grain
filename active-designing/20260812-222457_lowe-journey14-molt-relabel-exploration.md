# LOWE Journey 14 — Molt, the meaning-preserving relabel (exploration)

**Stamp:** `20260812.222457` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens Journey 14 of Season 4 (Seal) in the 1,024-round itinerary
**Waymark:** **LOWE** (CION Equinox 2 — Molt, already seated; each journey is `LOWE-J<N>`)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-215153_vols-journey13-survey-complete-census-exploration.md`](20260812-215153_vols-journey13-survey-complete-census-exploration.md) · [`../work-in-progress/vols-survey-ledger.bron`](../work-in-progress/vols-survey-ledger.bron) · [`../tools/gen/season/cion_module_labeling_witness.rish`](../tools/gen/season/cion_module_labeling_witness.rish) · [`../context/specs/20260810-222755_chronological-semantic-labeling-and-the-cion-meta-season.md`](../context/specs/20260810-222755_chronological-semantic-labeling-and-the-cion-meta-season.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 4's first journey, Survey (VOLS), closed with a census complete by construction: **223 sites = 144 kept witness handles + 79 prose gaps**, seated as the living pin `work-in-progress/vols-survey-ledger.bron`, read true against an independent measure. The map LOWE relabels against stands on metal — every prose gap named, every kept handle set apart.

Journey 14 is **Molt (LOWE)**: *relabel every living now-line to chronological/semantic form, dated testimony untouched.* Where VOLS named the work, LOWE does it — it carries each of the 79 prose gaps from a bare `lap N` capability identity to a **semantic label plus stamp**, the form the labeling law already seated for the seven hand-swept modules, and it **grows the CION guard** to cover each relabeled surface so it can never drift back.

## The durable promise this journey turns on

The CION guard (`cion_module_labeling_witness`) is a gate over a curated set — it bites a bare `lap N` only in the files a human listed. VOLS proved that curation is a blind spot: `guarded_sites = 0` today because the guard scans exactly the seven swept modules and nothing else, while 79 living surfaces carry the drift unguarded. LOWE's durable job is to close that gap **surface by surface**: each relabel is landed *and* the surface is added to the guard's scan list in the same round, so the census's `guarded_sites` count climbs toward `sites` and the labeling law finally holds everywhere it claims to.

The relabel itself is Lindy-durable in a quieter way. A module's front-door doc-comment is read every time someone opens the file for years; a bare `lap 3` tells a newcomer nothing, while `vessel cargo fetch · 20260713` names the capability *and* dates it. The molt trades an ordinal that meant something only to the person who counted it for a name that teaches every later reader.

## The crux — a relabel that preserves meaning and respects the handle boundary

The naive molt is a blind `sed 's/lap [0-9]*/…/'`. That is wrong, and dangerously so, because the survey already proved the tree carries `lap N` in three genuinely different roles, and only one of them is drift:

- **Prose identity** — `//! amphora/manifest_entry.rye — Amphora lap 1: one cargo line…` names the capability by a bare ordinal. **This is the drift LOWE relabels** to `Amphora — manifest entry: one cargo line… · 20260713`.
- **A kept witness handle** — `amphora_lap1.rish`, and a living README's shorthand reference to it (`lap 1 · lap 2 · lap 3` beside a `Witnesses:` list). The filename is a stable identifier the law keeps (Keaton's prose-only ruling); a reference to it must be **reworded to point at the handle unambiguously**, never deleted — the handle keeps its name, the prose stops pretending the ordinal is the capability.
- **Dated testimony** — a stamped Arc note embedded in a living surface. The law never rewrites what history recorded; where such a note rides inside a living README, LOWE keeps its meaning and its stamp while dropping the bare ordinal that trips the guard.

So the crux is **a molt that is meaning-preserving, not pattern-blind**: it names the capability the ordinal stood for (from the file's own words and its honest stamp), it keeps every witness handle, and it leaves dated testimony's facts intact. Checkable three ways per surface — the capability is still named (no information lost), the guard now scans the surface and stays GREEN (the drift is gone *and* guarded), and the stamp is drawn from the record (git-first date or the file's own recorded stamp), never fabricated.

## Why this shape, against the alternatives

- **Not a blind sed sweep.** A single regex replace would destroy handle references and flatten dated testimony — the exact distinctions VOLS spent a journey drawing. The molt reads each site and names its capability; the survey's per-site classification is what makes that tractable.
- **Not "relabel all 79 in one round."** One keystone, one send. LOWE climbs the prose gaps **cluster by cluster** — a self-contained module per round — so each round lands a guard-GREEN increment followable on GitHub, and a mistake touches one cluster, not seventy-nine sites at once.
- **Not growing the guard without relabeling.** Adding a drifted file to the scan list would turn the guard RED — the guard is a gate, not a census. LOWE relabels *first*, then adds the clean surface, so every round leaves the guard GREEN over a strictly wider set.

## The four rounds (Lindy-first, crux-first — smallest complete cluster first)

- **r1 — Amphora, the crux cluster.** The smallest self-contained module carrying all three roles at once (prose identity in two `.rye` headers, a handle reference in the README, a stamped Arc note): relabel `manifest_entry.rye` and `vessel_fetch_delivery.rye`'s prose identities to semantic label + stamp, reword the README's handle reference to point at `amphora_lap1/2/3.rish` unambiguously, add all three surfaces to the CION guard scan list, and prove the guard stays GREEN over the widened set. Proves the whole discipline end to end on one module — meaning preserved, handles kept, testimony intact, drift guarded.
- **r2 — The comlink guest cluster.** Fifteen near-identical device guests (`guest_*_tx/rx.rye`) each carrying an `I2 … lap 3 device` prose identity, plus `comlink/README.md`: relabel each to its semantic device role + stamp, grow the guard, GREEN. The largest single cluster, opened by r1's proven discipline.
- **r3 — The voice and market modules.** The Q-vane voices and their kin (`ember`, `lantern`, `lattice`, `mandi`, `dimeroll`, `glow/nock`): relabel each module's README and authored `.rye` prose identities, grow the guard, GREEN.
- **r4 — Mantra, the tools prose, and read-true close.** The remaining `mantra/` prose and the living `tools/*.rish` doc-comment sites; then re-run the VOLS survey and prove `guarded_sites` has climbed to cover every surface LOWE touched — the census reads the molt true, and Journey 14 closes with the guard finally scanning what it claims to govern.

Each round: relabel a cluster's prose identities, keep its handles, grow the guard, guard GREEN, send as its own signed increment.

## Boundaries (custody-first)

The molt reads and rewrites **living prose surfaces only** — module READMEs and authored `.rye`/`.rish` doc-comments. It never rewrites a dated session log, counsel, archive, or dated spec (the survey excluded those structurally, and LOWE honors that boundary exactly). It touches no key, no funds, no network. It opens no cut — OFFY debrides dead ordinal tissue on Keaton's word, a later journey. Stamps are drawn from the record, never fabricated. Everything above is agent-doable and waits on no gate.

---

*May the molt name every capability the way a newcomer needs, keep faith with every handle and every dated word history earned, and hand the seal a tree whose living surfaces finally say what they mean — one cluster relabeled, one guard widened, before the next.*
