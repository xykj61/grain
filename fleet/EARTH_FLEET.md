# The Earth Fleet -- eight ships, one element, one working rhythm

**Language:** EN
**Style:** Bhakta (see `../context/BHAKTA_STYLE.md`) -- this room assumes no prior background
**Voice:** Kyri
**Status:** Vision -- describes a real, running fleet; the description itself is a first draft
**Last updated:** `20260920.205200`
**Kin:** [`README.md`](README.md) - [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - [`../construction/fleet-roster.kyri`](../construction/fleet-roster.kyri) - [`../.claude/rules/vocabulary-aroma.md`](../.claude/rules/vocabulary-aroma.md)

---

## Who this is for

Someone who has seen a name like "incense" or "petrichor" mentioned somewhere in this tree and
wants to know plainly what it means, without needing to already understand this project's whole
naming history first.

## What a "ship" is, in one paragraph

This whole project lives in a single body of source code, tracked by git. A **ship** is one
complete, independent copy of that source code, checked out onto its own machine or its own
corner of a shared machine, with its own running AI agent session working inside it. Several
ships can exist at once, each one able to read and write files, run commands, and make its own
commits -- and all of them push their finished work to the same two shared homes on GitHub, the
way several writers might each keep their own private notebook while all contributing chapters to
one shared book.

## Why ships need names at all

If every ship were simply called "the AI agent," a person coordinating several of them at once
would have no way to say which one found a particular answer, which one is currently working on
which task, or which one to ask a follow-up question. A name turns "the agent" into "incense,"
and from that point on, every session log, every claim on the shared work board, and every commit
message can say plainly who did what.

## Why the names are aromas

This tree already organizes some of its ideas around five senses, borrowed from a classical
five-element framework: **aether hears, air feels, fire sees, water tastes, and earth breathes
in.** The sense tied to earth is aroma -- the thing you breathe in and notice without needing to
look at it or touch it. So when this particular group of eight ships needed names, they were all
drawn from that one sense, giving the group its own name in the process: **the Earth fleet.**

## The eight ships, and what each one is for

| Ship | What it is named for | What it does |
|---|---|---|
| **`incense`** | aroma offered deliberately, as an act | the ship this very page is written from; a general-purpose working ship |
| **`petrichor`** | the aroma the first rain lifts out of dry ground | a general-purpose working ship |
| **`pheromone`** | aroma that carries a message between living things | a general-purpose working ship |
| **`bakery`** | the aroma of bread, something made and shared | a general-purpose working ship |
| **`diffuser`** | the device that spreads a scent through a room | a general-purpose working ship |
| **`grass`** | the aroma of a freshly cut lawn | a general-purpose working ship |
| **`copal`** | a tree resin burned as incense in many cultures | a general-purpose working ship |
| **`patchouli`** | an aromatic plant used in perfumery | a general-purpose working ship |

Each ship's own working tree carries its own name as a suffix, so `incense`'s checkout is
`grain-incense`, `petrichor`'s is `grain-petrichor`, and so on -- the same repository, the same
history, eight separate rooms to work in.

## What this page does not claim

**This page does not describe what each ship is currently working on.** That changes by the hour,
and the living, authoritative record of it is
[`construction/fleet-roster.kyri`](../construction/fleet-roster.kyri), never this page. **This
page does not claim the eight ships are permanently fixed.** A new ship could join the Earth
fleet under a new aroma name, following the same naming test
([`comlink-tendency.md`](../.claude/rules/comlink-tendency.md)) every other name in this tree
earns its place by: clear, fun, and safe.

## Where to go next

[`SETUP_GUIDE.md`](SETUP_GUIDE.md) walks through what a new ship, or an existing one, actually
does to wire itself up to an open-weight model and a coding harness -- the practical continuation
of everything this page has only described in words.
