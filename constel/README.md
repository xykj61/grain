# Constel — fake piers that can never be a real ship

**Stamp:** `20260814.074900` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living front door — the Constel test-network journey opens (FORA0 name · FORA1 roster · FORA2 handshake)
**Season:** the Six-Season double-seat, Season D/F thread (Kresfa & Mycelium · Surface & Namespace) · **Waymark:** FORA
**Kin:** [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`../active-designing/20260814-fill-constel-naming-law.md`](../active-designing/20260814-fill-constel-naming-law.md) · [`../active-designing/20260814-041928_fora1-constel-roster-fake-pier-registry.md`](../active-designing/20260814-041928_fora1-constel-roster-fake-pier-registry.md) · [`../active-designing/20260814-042804_fora2-constel-local-handshake.md`](../active-designing/20260814-042804_fora2-constel-local-handshake.md) · [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## What this is

**Constel** is the tree's own answer to elder Urbit's fake-galaxy dev networks — a way to stand up many local piers on one machine and let them meet over Comlink, none of them a real point on the live network. Where Urbit dev nets ran fake galaxies for local testing, Constel runs fake piers with a stronger guarantee: **a Constel name is structurally incapable of being a real `@p`**, so no dev command a newcomer copies could ever reach a stranger's ship.

That guarantee is one clean property, checkable at a glance. Every one of Urbit's 512 real syllables — the 256 three-letter prefixes and 256 three-letter suffixes that compose every galaxy, star, planet, moon, and comet — carries exactly one vowel, and `y` never appears in the table at all. So a name that carries **no vowel** — abjad, Hebrew-style — can never be assembled from real syllables, and therefore can never parse as a real address. The missing vowel *is* the whole safety proof, and it fails closed in a single bounded pass. This is stronger and simpler than counting segment lengths against the syllable table (the `~acme-…` length trick the placeholder law uses for docs illustrations); Constel names are the *runnable* fake piers, and their guarantee is the missing vowel.

Everything here is purely **local** — a string predicate and a bounded in-memory registry on the bench, siloed to `constel/`, run from inside the jailed pier. No network, no keys, no funds, no real address ever formed. The local handshake and the real Comlink transport cross the Comlink seam and stay their own later round; the rungs below give that round names and a constellation already proven safe to greet across.

## The rungs

- **`name.rye` — the name that can never be a real ship (FORA0).** The naming law and the name primitive. `check_ship` / `is_valid_ship` prove a single fake ship lawful (bounded to `max_ship_len`, drawn only from the consonant-and-digit alphabet, vowel-free); `never_a_ship` states the safety invariant positively; `check_constellation` proves a bounded hyphen-joined run of fake piers; and `generate(index)` draws a distinct vowel-free name per `u32` index — a two-letter `xn` silo prefix over a base-21 consonant palette. Every real `@p` example (`zod` · `sarlev` · `sampel` · `palnet` · `sampel-palnet`) refuses `VowelPresent` by name; 512 generated names are deterministic, collision-free, and vowel-free by construction. Witness: `tools/fora_name_witness.rish`.
- **`roster.rye` — a bounded registry of fake piers (FORA1).** The roster every handshake leans on first: who is in the constellation. A `Roster` holds up to `max_piers` (= `name.max_ships`, eight) distinct fake piers, each a `Pier` carrying its `u32` draw index and generated name. Membership is held as an **invariant, not a hope** — a pier enters only through `generate` + `never_a_ship` (asserted on every join), a duplicate name refuses `DuplicatePier`, a ninth pier refuses `RosterFull`, and the hyphen-joined `render` always passes `check_constellation` (`joined_bytes` refusing `ConstellationTooLong` before a join could overflow the byte bound). The API seats `init` · `join` · `stand_up` (join `0…n-1` deterministically) · `find` · `contains` · `member` · `render`. An empty roster reads and renders by name, `stand_up` draws a deterministic constellation, lookup finds the present and refuses the absent, and the full roster renders a lawful whole with no vowel end to end. Witness: `tools/fora_roster_witness.rish`.
- **`handshake.rye` — two piers greet, proven pure (FORA2).** The one thing every real multi-pier sync leans on: **agreement before exchange.** Two piers confirm they are distinct members of the *same* constellation before a single payload byte moves. Three pure steps, each an immutable value the next validates — `open` (the initiator offers its name and constellation), `accept` (the responder confirms same-net membership and answers), `finish` (the initiator confirms the ack — a `Session` `COMPLETE` only when both are distinct never-a-ship members of the one sky) — plus `is_member`, an exact segment scan that names a whole member and refuses a mere substring. A clean handshake completes end to end; a different constellation refuses `ConstellationMismatch`, a non-member refuses `NotAMember`, a self-greet refuses `SameParty`, and a vowel-bearing (real-`@p`-shaped) party refuses `VowelPresent` at open and at accept — the naming law's safety reaching all the way into the greeting. Witness: `tools/fora_handshake_witness.rish`.

## Prove the rungs

```
rishi/bin/rishi run tools/fora_name_witness.rish
rishi/bin/rishi run tools/fora_roster_witness.rish
rishi/bin/rishi run tools/fora_handshake_witness.rish
```

Each prints a `GREEN` line naming exactly what it proved.

## What is not a Constel name

The vowel-bearing self-invented strings `queyqwinqkri` and `maicmalammurr` are **poetic Twilight-theme names**, a different silo entirely (the `queyqwinqkri` theme is its own reserved research task). Constel dev-net names proper are the consonants-only abjad — that separation keeps the safety predicate a single clean scan rather than a special-cased list.

## The road on

The naming, the roster, and the handshake are all proven pure on the bench. The next rung wires that proven handshake to the **real Comlink transport** — the round that genuinely crosses the Comlink seam, carrying the three handshake values (`Greeting` · `Ack` · `Session`) across a real wire between parties already known to belong together. From there Constel grows toward standing up a whole local constellation of fake piers to exercise the Comlink · Pond · Mycelium network end to end, without a single command ever addressing a real hand.

---

*May every fake pier be plainly fake, may no dev command a newcomer copies ever reach a real ship, and may the missing vowel keep the play safe all the way down. Hold the line.*
