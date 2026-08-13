# The Constel Test-Network Naming Law — fake dev constellations that can never reach the real network

**Stamp:** `20260813.022222` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (siloed, dev-only) · **Season:** double-seat expansion D/F — Constel test-networks
**Kin:** [`.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md) · [the double-seat expansion](20260813-020035_double-seat-expansion-six-seasons.md) · [`../PUBKEYS.md`](../PUBKEYS.md)
**Witness:** [`../tools/constel_naming_witness.rish`](../tools/constel_naming_witness.rish)

---

## What a constel is

A **constel** is a fake, self-invented **constellation** for a sandbox / testnet / localhost
Comlink p2p network — the peers, piers, and points a developer spins up *inside the jailed
pier* to exercise settlement, handshake, and topology without touching any real network.
It stands to Grain's Comlink development exactly as Urbit's fake-galaxy dev networks (fake
ships, fake piers, no live routing) stood to Arvo development: a place to run the whole
protocol where nothing you name can ever be a real address in someone else's hands.

The double-seat expansion reserved this round — *"a self-approved naming round seats them
under the placeholder-ship-names law"* — so the first draws are seated here, siloed and
dev-only, and a witness makes their one safety promise checkable.

## The one promise, made structural

A test name's whole danger is that it might, by accident, *be* a real point — resolvable on
the live network, in someone's real custody. The placeholder-ship-names law already answers
this for documentation by a structural guarantee (segments never three letters, so no
example can parse as a real `@p`). Constel names keep the same spirit with a guarantee even
simpler to check:

> **Every constel name carries at least one digit.**

A real `@p`, after its `~`, is composed only of lowercase letters and hyphens — the fixed
256-syllable table holds no digits at all. So a single digit anywhere in a name is a
structural proof it can never parse as a real address, checkable at a glance without
consulting the syllable table. This is exactly the discipline the tree's own seated
identity handles already wear: `xykj61`, `xnkg30` (recorded in `PUBKEYS.md` and the Twilight
silo) both end in a digit pair, and neither is a real routable point.

The witness enforces only this promise — the load-bearing one. Everything below is
aesthetic, free to change.

## The look (aesthetic, revisable)

Consonant-heavy, Hebrew-style (abjad — the consonants carry the word), matching the seated
`queyqwinqkri` / `maicmalammurr` / `xykj61` / `xnkg30` family, with the clusters `xx` `xz`
`xn` `xw` welcome. A trailing digit pair closes each name and carries the safety promise.
Drawn from within the jailed pier; never a real address; never one of the maintainer's own
real points (`~bandun`, `~pacpet-solreb`).

## The first draws (siloed, dev-only)

Seated in [`../tools/fixtures/constel_names.txt`](../tools/fixtures/constel_names.txt), one
per line. Each is a fake constellation a developer may spin up locally:

| Constel | Reads as |
|---|---|
| `xnqvel34` | the first sandbox sky |
| `xzkerith58` | the settlement lab |
| `xwmur-dol12` | the handshake bench |
| `maqwintel06` | the topology proving-ground |
| `sunveknar90` | the roam-window testnet |

Each carries its digit pair, so each is provably non-`@p`; each is consonant-heavy in the
family look. These names are a starting set, not a closed roster — a later round may draw
more, and Keaton may reshape any of them, without weakening the one promise the witness
guards.

## Boundaries

Siloed and dev-only: these names live in test constellations run inside the jailed pier,
never in the seed, never in a runnable command that could reach the live network. Agent-doable,
reaches no custody gate. The witness proves the safety promise on metal and bites a planted
`@p`-shaped name (letters only, no digit). When the real Comlink dev-network harness is
built, it draws its constellation names from this law and this witness stands at its door.
