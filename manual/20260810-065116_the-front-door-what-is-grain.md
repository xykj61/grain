# What Is Grain OS, and Why?

**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Audience:** anyone meeting Grain for the first time — no prior knowledge assumed, and none needed
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Status:** Overview — the front door. It names what runs today plainly, and marks each horizon as a horizon. Every capability it claims is proven by a witness you can run yourself.

---

Welcome. You have found the front door of a personal operating system you can own.

Take your time here. This page asks nothing of you — no account, no purchase, no prior knowledge. It is simply the warm room you step into first, where the whole house is explained before you walk any farther in. By the end you will know what Grain is, why it is built the way it is, and exactly where to go to hold a piece of it in your own hands.

## Grain in One Breath

**Grain is a personal operating system you own.**

Not an account on someone else's machine. Not a service you rent by the month. A whole small computer's worth of software that lives in a folder you control — one you can read from end to end, copy freely, and keep working whether or not anyone else is watching. When you clone Grain, the entire thing is yours: the code, the records, the identity, the history. Nothing important lives somewhere you cannot reach.

That is the promise. The rest of this page is why that promise matters, and how Grain keeps it honestly.

## Where the Family Comes From

Grain descends from the ideas of **Urbit** — the project that first dreamed of a personal server every person truly owns, identity and all. From that lineage Grain inherits three ideas it holds dear:

- **Owned identity** — who you are on the system is a thing you hold, not a login a company grants and can revoke.
- **Referential transparency** — a plain, sturdy discipline where the same inputs always give the same result, so behavior stays predictable and provable rather than surprising.
- **The personal-server dream** — the whole idea that a person can run their own corner of the network, on their own terms, in software small enough to understand.

Grain carries that dream forward in its own language and its own hands. It thanks its ancestor plainly, and stands on its own worth. You do not need to know a word of Urbit to use Grain — that world has its own vocabulary (you may hear the word "vane" over there), and none of it is required here. Grain is written for families and small collectives who may never hear those words and should never have to. The lineage is named so you know where the care comes from, and then the door opens onto our own ground.

## Why Grain Is Built This Way — the Values, Plainly

Grain is shaped by a handful of civic values. They are not decoration; each one changes real decisions in the code. Here they are in plain words.

### Custody-first

One value stands above the rest: **custody-first.** *Custody* means keeping — the way you keep a key, a letter, a memory. Grain is built so that what is yours stays yours: your identity, your records, your secrets. Nothing important lives somewhere you cannot reach it, and nothing is built that would take it away from you.

When a design choice pulls between "convenient for a company" and "kept safe in your own hands," Grain chooses your hands, every time. You will see this value made concrete below — in **vault**, which splits a secret so a fire or a forgotten day cannot erase it, and in the fact that even Grain's own diary is written in plain lines you can always read.

### Bounded and asserted

Grain is built to be **sound before it is clever.** Two habits carry this, and they run through every module:

- **Bounded** — every list, every store, every stretch of memory names a limit up front. Nothing is left to grow without a stated maximum, so the system's appetite is known in advance rather than discovered under strain.
- **Asserted** — the code states out loud what must be true, at the moment it must be true, and checks it right there. These stated truths are called *invariants*: promises the code makes to itself and verifies as it runs, so a wrong assumption is caught at once rather than drifting quietly into harm.

This discipline has a name in this tree — **TAME** ([`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)) — and it orders the work in a clear priority: **safety first, performance second, the joy of clear and well-named code third.** When those pull against each other, safety wins. That order is why you can trust what Grain tells you: it is built to be correct on purpose, rather than patched after the fact.

And Grain never asks you to take its word. Every module can be proven true by a small script called a **witness** — a short program that runs the module on real metal and ends with a line beginning `GREEN:` when the fact holds. Green means true, checked, seen. The witnesses live in the open at [`../tools/`](../tools/), and you can run any of them yourself. Nothing on this page is a claim you must trust; each one is a green line you can go and watch appear.

### Name-clean

Grain's public template is **name-clean.** It carries no real person's name, no company, no wallet, no private detail — because it is meant to be cloned by anyone, shared with anyone, and read by a stranger without exposing a soul. Throughout the manual you are addressed simply as **you**, and the person who tends the tree is called **the maintainer**. This is care made into a habit: a template that is safe to hand to the next person, exactly as it is.

### Ecological in spirit

Grain grows the way a healthy thing grows — one small, proven piece at a time, keeping what serves and releasing what no longer does. New capability opens only when it can be proven, and old records are kept rather than quietly erased, so the system's own history stays honest and legible. Nothing here is built to sprawl faster than it can be understood. That restraint is a kindness to everyone who comes after: the tree stays small enough to hold in your head, and every part of it can explain itself.

## What Grain Is Made Of

Grain is a set of small, honest **modules** — self-contained pieces, each doing one clear thing well. You do not need to learn them all to begin; here they are simply so the house has a map. Every one of these runs today and is proven green by its own witness.

| Module | What it keeps or does |
|--------|-----------------------|
| **kumara** | your identity — who you are on the system |
| **vault** | your secrets, split into shares so a fire or a forgotten day cannot erase them (custody-first, made concrete) |
| **comlink** | carries messages between people, sealed on the wire, over an inclusive network shape that has room for everyone |
| **settlement** | a shared ledger of a small community and its names |
| **mandate** | remembers many things and finds them fast, without copying data it does not have to |
| **scribe** | reads Grain's own records — the piece you build first in the tutorial |
| **pond** | the surface an application draws on |
| **rye** | the builder — it turns a module's source into a program you can run |
| **rishi** | the witness runner — it runs the little scripts that prove a fact is true |
| **glow** | the language and runes the whole system is written in |

A few more — **tally**, **caravan**, **aurora** — hold the quieter foundations that let the rest stand. You will meet the ones you need, when you need them, and never before.

## The Rhythm of the Whole System

If you remember one thing from this room, let it be the rhythm — because every part of Grain, from the smallest witness to the largest module, moves to it:

**Build a module. Let it test itself. Let a witness prove it. Read the green line. Keep what is yours.**

*Build, prove, read, keep.* That is the heartbeat. Everything larger is made of exactly these small, honest moves — which means once you have felt the rhythm once, you understand how the entire system grows, and how you can grow it too.

## The Four Rooms of This Manual

This manual is one house with four rooms, each answering a different visitor. As you go deeper, this is the map:

| Room | Who it serves | Where it lives |
|------|---------------|----------------|
| **Tutorials** | someone learning by the hand, step by step | start with [`the first hour`](20260810-065116_your-first-hour-with-grain.md) |
| **Guides** | someone in the middle of a task, needing the shape for the machine in front of them | [`Running Grain on Your Machines`](20260810-065116_running-grain-on-your-machines.md) |
| **For developers** | someone who wants to change the code and send a contribution | [`The Developer Guide`](20260810-065116_the-developer-guide.md) |
| **Editors & agents** | someone working on the template with a modern editor and a coding agent | [`IDEs, Agents, and the API`](20260810-065116_ides-agents-and-the-api.md) |

The full index of every room lives in the manual's own [`README`](README.md). Take the rooms one at a time; each is written to be complete on its own.

## Start Here — Your First Hour

Reading is a lovely beginning. Doing is better.

Everything on this page becomes real the moment you clone Grain and watch a piece of it prove itself true in front of you. That is exactly what the first-hour tutorial is for: in about an hour, with no prior knowledge, you will clone your own complete copy of a personal operating system, build a real module from its source, watch it test itself, run a witness, and see the `GREEN:` line prove it true with your own eyes.

**Your next step is here:**

### → [Your First Hour with Grain](20260810-065116_your-first-hour-with-grain.md)

That door needs nothing but a terminal and a little patience for one download. Walk through it, and the rhythm this page described — *build, prove, read, keep* — stops being a promise and becomes something you have done with your own hands.

---

*Welcome home. May the house prove sturdy, the records read true, and everything you build here stay wholly and plainly yours.*
