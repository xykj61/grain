# Fleet -- the Earth ships, and room for the other elements

**Language:** EN
**Style:** Gauge, Door setting (see `../context/GAUGE_STYLE.md`), Radiant close
**Voice:** Kyri
**Status:** Vision -- first draft, describing a real fleet with room left for what has not been built
**Last updated:** `20260920.205200`
**Born from:** [`../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md`](../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md)
**Kin:** [`EARTH_FLEET.md`](EARTH_FLEET.md) - [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - [`../open/README.md`](../open/README.md) - `../construction/fleet-roster.kyri` - [`../.claude/rules/the-baton.md`](../.claude/rules/the-baton.md)

---

## What this room holds

Four short documents:

| File | Reader | What it answers |
|---|---|---|
| This page | anyone opening the room | what a fleet is, here, and why it is named the way it is |
| [`EARTH_FLEET.md`](EARTH_FLEET.md) | someone who wants to understand the eight named ships | what "Earth fleet" means, who the ships are, and how the naming works |
| [`ENGINES.md`](ENGINES.md) | someone who wants to know how a ship runs its laps, and which engine it runs on | the three engines -- claude, codex, opencode -- and how a ship switches |
| [`SETUP_GUIDE.md`](SETUP_GUIDE.md) | someone standing up a new ship, or wiring an existing one to an open-weight model | the practical steps, pointing back to [`open/`](../open/README.md) for the provider and harness half |

## What a fleet is, here

A **fleet** is a small group of independent working trees -- each one its own git checkout, its
own running agent session, its own named seat -- coordinating through one shared remote rather
than through one shared process. `construction/fleet-roster.kyri`
is the living roster; this room teaches the *idea* rather than duplicating the roster's own
authority over the *facts*.

**Earth is the one element with real ships today.** Eight of them: `incense`, `pheromone`,
`petrichor`, `bakery`, `diffuser`, `grass`, `copal`, and `patchouli` -- each named for an aroma,
per [`vocabulary-aroma.md`](../.claude/rules/vocabulary-aroma.md)'s own reasoning that earth's
sense is aroma, the thing breathed in. [`EARTH_FLEET.md`](EARTH_FLEET.md) names each one and what
it is for.

## Room for what has not been built

This tree already holds a five-element structure elsewhere -- the council rota
([`the-baton.md`](../.claude/rules/the-baton.md)) reads through five rows, one sense each:
**aether hears, air feels, fire sees, water tastes, earth breathes in.** Earth's fleet is real
because it was built first; the other four elements -- **Air, Fire, Water, and Aether** -- stand
as open slots in the same structure, named here as elements only. **No ship names are proposed
for them in this page.** Naming a fleet is worth the same care this tree already gives every
other name it seats -- clear, fun, safe, chosen when the fleet is actually being built, per
[`comlink-tendency.md`](../.claude/rules/comlink-tendency.md) -- rather than invented ahead of
need by a page describing a fleet that does not exist yet.

## Why this room sits at the tree's root, beside `open/`

A fleet is infrastructure a newcomer to this tree might reasonably want to understand on its own
terms, the same reason `open/` earned its own room rather than living inside `external-research/`
or `.claude/rules/`. [`design-rooms.md`](../.claude/rules/design-rooms.md)'s own test applies
here too: this room would still be worth reading if every line of fleet-coordination code were
deleted, since the *idea* of independent trees coordinating through one remote outlives any one
implementation of it.

May whichever ship reads this next find its own name already suits it, and may the elements still
waiting find theirs in their own good time.
