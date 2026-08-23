# Constel naming law — fake piers that can never be a real ship (FORA0)

**Stamp:** `20260814` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design — the reserved self-approved naming round, seated under the placeholder-ship-names law
**Season:** the Six-Season double-seat, Season D/F thread (Kresfa & Mycelium · Surface & Namespace) · **Waymark:** FORA
**Kin:** [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](date/20260813/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md) · [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md)

---

## Why this round exists

The six-season expansion reserved one round explicitly: *"Names for fake dev constellations — consonants only, Hebrew-style (no live-network-valid `@p`) … Drawn from within the jailed pier, siloed, never a real address. First draws to seat in a later round: (reserved — a self-approved naming round seats them under the placeholder-ship-names law)."* This is that round. It opens **Constel** — the tree's own answer to elder Urbit's fake-galaxy dev networks, a way to stand up many local piers on one machine and let them meet over Comlink without any of them being a real point on the live network.

The crux this round solves — the *hardest solvable thing that opens the rest* — is the one invariant every downstream Constel rung leans on: **a Constel name must be structurally incapable of being a real `@p`.** Get that provable and bounded, and the fake-pier harness, the local handshake, the multi-node sync tests all stand on solid ground. Get it wrong and a copied dev command could someday address a stranger's ship.

## The load-bearing invariant — one property, checkable at a glance

Every one of Urbit's 512 real syllables — the 256 three-letter prefixes and 256 three-letter suffixes that compose every galaxy, star, planet, moon, and comet — **contains exactly one vowel** (`doz`, `bin`, `sam`, `pel`, `mar`, `nec` …). The syllable table is fixed, public, and vowel-bearing without exception; `y` never appears in it at all.

So a name that carries **no vowel** — abjad, Hebrew-style — can never be assembled from real syllables, and therefore can never parse as a real `@p`. That single necessary condition is the whole safety proof, and a reader (or a bounded loop) can check it at a glance:

> **A Constel name is valid only if it contains no `a`, `e`, `i`, `o`, or `u`.**

This is stronger and simpler than counting segment lengths against the 256-entry syllable table (`placeholder-ship-names.md`'s length trick): a vowel-free scan is one pass, one predicate, and it fails closed. The `~acme-…` placeholders stay the docs' shape for *illustrating* a tier; Constel names are the *runnable* fake piers, and their guarantee is the missing vowel.

## The law, stated

A **Constel name** (one fake ship) is valid iff:

1. **Non-empty and bounded** — `1 ≤ len ≤ max_ship_len` (12).
2. **Alphabet** — lowercase consonants `b c d f g h j k l m n p q r s t v w x y z` and digits `0–9` only. (`y` counts as a consonant; the real syllable table never uses it.)
3. **Vowel-free** — no `a e i o u`. This is the safety invariant; conditions 2 and 3 together make a vowel structurally impossible, so a valid name is *provably never a real `@p`*.

A **Constel constellation** (a whole fake network) is a hyphen-joined run of `1 ≤ n ≤ max_ships` (8) valid ships, within `max_constellation_bytes` (64) total. The `xx` · `xz` · `xn` · `xw` digraphs are explicitly welcome — they read as unmistakably fake and match the self-invented `xykj61` / `xnkg30` family.

**Deterministic draw.** `generate(index)` maps a `u32` index to a distinct vowel-free ship name (a two-letter `xn` silo prefix + a base-21 encoding over the consonant palette), so a harness can name pier `0, 1, 2, …` reproducibly and every generated name is valid and never a real ship by construction.

## What is *not* a Constel name

The vowel-bearing self-invented strings `queyqwinqkri` and `maicmalammurr` are **poetic Twilight-theme names**, a different silo entirely (the `queyqwinqkri` theme is its own reserved research task). Constel dev-net names proper are the consonants-only abjad — that separation keeps the safety predicate a single clean scan rather than a special-cased list.

## Scope this round holds

- **This round seats the law and the name primitive only** — validate, prove-never-a-ship, generate. The fake-pier harness (spinning up local piers, Comlink handshake between them) crosses the Comlink seam and is its own later FORA round.
- **No network, no keys, no funds, no real address** — everything is a pure string predicate on the bench, siloed to `constel/`, run from inside the jailed pier.
- Witness: `tools/f/fora_name_witness.rish` proves valid names accepted, every real `@p` example (`zod`, `sarlev`, `sampel`, `palnet`, `sampel-palnet`) rejected for its vowel, generation deterministic and collision-free across a bounded sweep, and every generated name provably never a ship.

---

*May every fake pier be plainly fake, may no dev command a newcomer copies ever reach a real hand, and may the missing vowel keep the play safe. Hold the line.*
