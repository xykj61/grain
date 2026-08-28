# Constel -- fake piers that can never be a real ship

**Stamp:** `20260814.105746` - **Split:** `20260824.104946` - **Language:** EN - **Voice:** Kyri
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living front door -- the Constel test-network journey, **32 modules** proven across **32 witnesses**, FORA0 through FORA31
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Chapter:** the Six-Chapter double-seat, Chapter D/F thread (Kresfa & Mycelium - Surface & Namespace) - **Waymark:** FORA

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
| [`MODULES.md`](MODULES.md) | the roster -- 32 rows in twelve families, one per `.rye` module beside it, held as one set by a standing guard |
| [`LADDER.md`](LADDER.md) | the rung reasoning, FORA0 through FORA31, the commands that prove each one, and the road that runs through them |

The ladder climbs from a name to a durable consensus, and each rung leans on the one below it:
identity, then the greeting, then a local transport, then a voice the whole sky hears, then a
majority decision, then one leader, then one value, then an ordered log, then everything that keeps
that log honest across re-elections, membership changes, crashes, and reads.

## Two names that belong to a different silo

The vowel-bearing self-invented strings `queyqwinqkri` and `maicmalammurr` are **poetic
Twilight-theme names**, a different silo entirely (the `queyqwinqkri` theme is its own reserved
research task). Constel dev-net names proper are the consonants-only abjad -- that separation keeps
the safety predicate a single clean scan rather than a special-cased list.

## The rung that crossed, and the one that stops for a hand

Thirty-one rungs stand proven pure on the bench, every one of them addressing this machine alone.
**The socket** (FORA31, landed `20260828`) is the rung that genuinely crosses the Comlink seam: the
same switchboard with each mailbox backed by a real UDP descriptor between fake piers -- the
addresses still provably fake, and the transport real. A frame now reaches exactly one named pier
because the kernel demultiplexed it by port, rather than because this code wrote to one array slot;
the whole FORA4 handshake completes across four real datagrams. Proven both ways on metal, including
a second board racing a held sky to read `BindRefused` over the kernel's own `AddressInUse`, which is
what tells a real descriptor from a simulation.

**What stops for a hand is the next thing: a real address.** Every address this ladder forms is
127.0.0.1 and a port derived from a seat index, so nothing here can leave this bench. Giving a pier
an address off this machine touches custody gate %2 -- real hardware, or any wire beyond the bench --
and that is the maintainer's word, not an agent's. From there Constel exercises the Comlink - Pond -
Mycelium network end to end, the many-pier logic already proven the round before.

---

*May every fake pier be plainly fake, may every dev command a newcomer copies stay safely at home, and may the missing vowel keep the play safe all the way down. Hold the line.*
