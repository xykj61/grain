# Constel -- fake piers that can never be a real ship

**Stamp:** `20260814.105746` - **Split:** `20260824.104946` - **Language:** EN - **Voice:** Kyri
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living front door -- the Constel test-network journey, **31 modules** proven across **31 witnesses**, FORA0 through FORA30
**Season:** the Six-Season double-seat, Season D/F thread (Kresfa & Mycelium - Surface & Namespace) - **Waymark:** FORA

---

## What this is

**Constel** is the tree's own answer to elder Urbit's fake-galaxy dev networks -- a way to stand up
many local piers on one machine and let them meet over Comlink, every one of them local to this
bench. Where Urbit dev nets ran fake galaxies for local testing, Constel runs fake piers with a
stronger guarantee: **a Constel name is structurally incapable of being a real `@p`**, so a dev
command a newcomer copies stays inside this machine.

That guarantee is one clean property, checkable at a glance. Every one of Urbit's 512 real syllables
-- the 256 three-letter prefixes and 256 three-letter suffixes that compose every galaxy, star,
planet, moon, and comet -- carries exactly one vowel, and the table leaves `y` out entirely. So a
consonants-only name -- abjad, Hebrew-style -- is unassemblable from those syllables, and therefore
stays outside the space of real addresses altogether. The **missing vowel** is the whole safety
proof, and it fails closed in a single bounded pass. This is stronger and simpler than counting
segment lengths against the syllable table (the `~acme-...` length trick the placeholder law uses
for docs illustrations); Constel names are the *runnable* fake piers, and their guarantee is the
vowel-free spelling itself.

Everything here is purely **local** -- a string predicate and a bounded in-memory registry on the
bench, siloed to `constel/`, run from inside the jailed pier. It works on local strings alone, with
the network, keys, funds, and real addresses all sitting outside what it touches. The local
handshake and the real Comlink transport cross the Comlink seam and stay their own later round.

## Where to read next

| Page | What it holds |
|---|---|
| [`MODULES.md`](MODULES.md) | the roster -- 31 rows in eleven families, one per `.rye` module beside it, held as one set by a standing guard |
| [`LADDER.md`](LADDER.md) | the rung reasoning, FORA0 through FORA30, the commands that prove each one, and the road that runs through them |

The ladder climbs from a name to a durable consensus, and each rung leans on the one below it:
identity, then the greeting, then a local transport, then a voice the whole sky hears, then a
majority decision, then one leader, then one value, then an ordered log, then everything that keeps
that log honest across re-elections, membership changes, crashes, and reads.

## Two names that belong to a different silo

The vowel-bearing self-invented strings `queyqwinqkri` and `maicmalammurr` are **poetic
Twilight-theme names**, a different silo entirely (the `queyqwinqkri` theme is its own reserved
research task). Constel dev-net names proper are the consonants-only abjad -- that separation keeps
the safety predicate a single clean scan rather than a special-cased list.

## The one rung that stops for a hand

Thirty-one rungs stand proven pure on the bench, every one of them addressing this machine alone.
**The socket** is the rung that genuinely crosses the Comlink seam: this same switchboard with each
mailbox backed by a real local file descriptor between fake piers -- the addresses still provably
fake, and the transport real. Because it touches `seed/comlink/` and a real wire, it waits for the
maintainer's word rather than self-approving. From there Constel exercises the Comlink - Pond -
Mycelium network end to end, the many-pier logic already proven the round before.

---

*May every fake pier be plainly fake, may every dev command a newcomer copies stay safely at home, and may the missing vowel keep the play safe all the way down. Hold the line.*
