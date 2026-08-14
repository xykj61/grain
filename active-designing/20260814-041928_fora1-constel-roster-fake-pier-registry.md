# Constel roster — a bounded registry of fake piers (FORA1)

**Stamp:** `20260814.041928` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design — self-approved round, the pure roster beneath the later Comlink handshake
**Season:** the Six-Season double-seat, Season D/F thread (Kresfa & Mycelium · Surface & Namespace) · **Waymark:** FORA · rung FORA1
**Kin:** [`20260814-fill-constel-naming-law.md`](20260814-fill-constel-naming-law.md) · [`../constel/name.rye`](../constel/name.rye) · [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## Why this round exists

FORA0 seated the naming law: a Constel name is provably never a real `@p`, guaranteed by the missing vowel, and `generate(index)` draws a distinct vowel-free name per `u32` index. FORA0's own scope note reserved the next rung plainly: *"The fake-pier harness (spinning up local piers, Comlink handshake between them) crosses the Comlink seam and is its own later FORA round."*

That later round splits honestly into two. The **handshake and transport** genuinely cross the Comlink seam and want their own round against real Comlink. Yet the thing every handshake leans on first — **the roster of who is in the constellation** — is pure, bounded, and provable on the bench today, exactly as DREY proved the Mikrophone firmware pure before any metal. This round is that roster: the crux beneath the harness, solved where it can be solved cleanly.

The crux FORA1 fixes — the hardest solvable thing that opens the rest — is **membership held as an invariant, not a hope**: a constellation is a bounded set of distinct fake piers, every member provably never a ship, and the whole always a lawful `check_constellation` string. Get that provable and the handshake round stands up local piers by index and greets them by name with no fear a member could ever be a real address.

## What a Constel roster is

A **Roster** is one fake constellation held in memory: up to `max_piers` (= `name.max_ships`, 8) distinct piers. A **Pier** is one fake pier — the `u32` draw index that named it and its generated Constel name. The roster owns three promises, each an asserted invariant rather than a checked-once fact:

1. **Every member is never a ship.** A pier only ever enters through `generate` + `never_a_ship`; the roster asserts it on every join.
2. **Members are distinct.** A name already held refuses `DuplicatePier` rather than doubling a pier.
3. **The whole is always lawful.** The hyphen-joined render is bounded to `max_constellation_bytes` and passes `check_constellation`, so the roster can never present a string the naming law would reject.

## The API this round seats

- `init()` — an empty roster (count 0).
- `join(self, index)` — draw `generate(index)`, prove it never-a-ship, refuse a duplicate name, refuse past `max_piers`, refuse if the rendered whole would exceed `max_constellation_bytes`; append and return the new slot.
- `stand_up(self, n)` — the convenience the harness wants: join piers `0 … n-1` deterministically, standing up an `n`-pier local constellation in one call.
- `find(self, name)` — the slot holding a name, or `NotFound`.
- `contains(self, name)` — the predicate form.
- `member(self, slot)` — the name at a slot.
- `render(self, buf)` — the hyphen-joined constellation string, asserted to pass `check_constellation`.

## Scope this round holds

- **Pure roster only** — membership, bounds, distinctness, deterministic stand-up, render. No network, no Comlink transport, no handshake, no keys, no funds, no real address. Everything is a bounded in-memory registry over `name.rye`'s public API, siloed to `constel/`, run from inside the jailed pier.
- **The Comlink handshake stays its own later round** — FORA1 gives that round a roster already proven correct to greet across.
- Witness: `tools/fora_roster_witness.rish` proves an empty roster, deterministic stand-up, distinctness (a duplicate index refused), the bound (a ninth pier refused), lookup (present and absent), render passing `check_constellation`, and every member never-a-ship across the whole roster.

---

*May every roster hold only the plainly fake, may no member ever wear a real name, and may the handshake that comes next greet across a constellation already proven safe. Hold the line.*
