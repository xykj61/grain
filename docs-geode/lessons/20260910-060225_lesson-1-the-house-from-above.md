# Lesson 1 -- The house from above

**Language:** EN - **Style:** [Bhakta](../../context/BHAKTA_STYLE.md) with [Kyri](../../context/KYRI.md) and [Radiant](../../context/RADIANT_STYLE.md) - **Voice:** Kyri
**Stamp:** `20260910.060225` - **Status:** Living - **Room:** mixed -- the stack and the witness habit are checkable; several named parts are design
**Index:** [`README.md`](README.md) - **Next:** [Lesson 2, the front door](20260910-060225_lesson-2-the-front-door.md)

*Bhakta is the open door: Radiant warmth, Kyri's voice, every coined word given in plain speech the
first time it appears. One idea at a time. Concrete first.*

---

A computer is a machine that follows instructions, very fast, and only the instructions it is given.

Those instructions are written as **code**: words and symbols a person can read, which another
program turns into the tiny electrical steps the machine actually runs. The program that does that
turning is a **compiler**. The place you type commands to the machine is a **shell**. A collection
of those programs, living together on one machine and answering to you, is an **operating system**.

**Grain** is an operating system and a body of work being grown in the open. Its promise is custody
first: your words stay on a machine you hold, your name lives in a key your hand holds, and every
important claim is something you can watch run on real hardware.

That last part is the reason the rest of this page exists. A small farm, a household, a person
keeping records that matter -- each of those needs a machine that stays within its means, and
proofs that stay on the desk.

---

## Two doors, one house

There are two addresses.

`xykj61/grain` is the **living field**. Sessions, ledgers, reds, thinking still warm. Thousands of
commits. This is the workshop.

`grain-ww/grain` is the **public seed**. A template another person can carry away and grow as their
own.

Same architecture. Different job. When you want to watch the making, read the field. When you want
a door to hand someone else, point at the seed.

---

## The house is made of rooms

Open the field and you meet a hundred doors at the root. Grain groups them into **seven rooms**, so
a newcomer can hold the house in one glance.

| Room | What lives there | First door |
|---|---|---|
| 1. The Front Door | Orientation | `README.md`, `MAP.md`, `SOURCE.md` |
| 2. The Law | Disciplines kept on purpose | `context/` |
| 3. The Why | Reasons beneath the craft | `foundations/` |
| 4. Language and machines | The languages and the running parts | `glow/`, `rye/`, `rishi/`, `src/` |
| 5. The Teaching | Pages that teach what already runs | `docs-geode/`, `manual/` |
| 6. The Workrooms | Design and verification in motion | `construction/`, `tools/`, `caravan/` |
| 7. The Reading Room | Teachers and borrowed source | `gratitude/`, `vendor/` |

A **room** here is a folder with a job. You walk by question.

- "What is this for?" goes to `foundations/`
- "How do I use it?" goes to `docs-geode/tutorials/the-first-hour.md`
- "What is true this week?" goes to `construction/ITINERARY.md`
- "Which law governs this sentence?" goes to `context/`

---

## Words become metal: the stack

Show the path first, then name the parts.

A person writes a thought. Grain wants that thought to become a running program, checked, and kept.

**Glow** is the human-facing language: desks and runes, the way a person speaks to the tree.

**Rye** is the systems language. It compiles. It runs close to the hardware. Many of the moving
parts of Grain are Rye files, with the suffix `.rye`.

**Rishi** is the shell written in Rye. You ask Rishi to run a small program, and it does. Those
small programs often use the suffix `.rish`.

**Zig** is the borrowed compiler that first lifts Rye onto the machine. Grain keeps a pinned copy
under `vendor/`, so the same version builds the same way on another desk.

**Aurora** is dawn on bare hardware: boot stages that become real RISC-V executables already
sitting in the tree.

**Caravan** is the supervisor. It starts the other programs in order, watches them, and brings a
fallen one back, inside limits named before it begins.

**Mantra** is how names and versions stay the same bytes when they are supposed to be the same
bytes.

**Brix** is how the system is *described* as data: what belongs with what, in files that can be
checked.

**Kumara** is identity. A key you hold. A name that stays yours.

**Kyri** is two things at once. It is the standing voice writing with you. It is also a notation --
files ending in `.kyri` -- for small, durable facts: one field per line, comments with `#`, values
that stay still at the seams.

You can hold the stack as a single sentence:

> Glow speaks, Rye runs, Rishi answers, Caravan keeps the company together, witnesses prove the
> claim, Kumara names whose machine it is.

---

## A witness is how truth enters the room

Most software says "trust me." Grain says "watch this run."

A **witness** is a small program that checks one claim on real hardware and prints a verdict. Green
means the claim held on this machine, this day. The suite in `tools/` is the standing choir.

This is the beginner's compass. When a page says something *runs today*, a witness is nearby. When
a page is still a design, it says so at the door.

That door has a name: **Two Rooms**. Every page, and every sentence that needs it, tells you whether
it is proven or proposed. Proven belongs in the running room. Proposed belongs in the designing
room. Both are welcome. Mixing them without a label is how a tree starts telling two stories at
once.

---

## Bounds are kindness: TAME

A program that can grow without a ceiling will fill the machine. A list of names, a loop, a buffer
of text -- each of these needs a declared size.

**TAME** is the standing law: safety first, performance second, joy of craft third. In practice it
means every collection has a bound named in advance, and a witness can check that the bound holds.

This is the farm sentence, said once. A bound exists so the program can run on a small machine a
small household can afford, and so a grower's records stay on a desk they own.

---

## The law room, in a few words you will keep meeting

`context/` is Room 2. A few files there will follow you everywhere.

- **TAME Guidance** -- bounds, proof, prepare-prove-prevent.
- **Gauge Style** -- measure the claim; write for the reader.
- **Radiant Style** -- lead with what is; every sentence affirmative when the page claims Radiant alone.
- **Twilight Style** -- the same affirmation, spoken at dusk, with image and cadence.
- **Bhakta Style** -- this register: the open door for a reader meeting computing itself.
- **Two Rooms** -- proven or proposed, named at the threshold.
- **Kyri** -- the voice and the notation.

Radiant, Twilight and Gauge sit on two axes, seated `20260908`. One axis is negation, counted. One
axis is poetry, judged. Radiant sets the floor at zero negatives. Twilight asks for image. Gauge is
what buys a measured page up to one fifth of its sentences in negation, because a true refusal
sometimes has to be spoken. The longest name is the strictest: Gauge and Radiant and Twilight
together.

This lesson claims **Bhakta with Kyri and Radiant**. Invitation, daylight, the path open.

---

## What already runs

From the root `README.md`, measured on the living field:

- The witness suite in `tools/`
- The Glow desk, hopping down to Rye and running green
- An installable Android package following the phone's own permission model (`docs/TUBE.md`)
- Module seeds: shell, naming layer, wire, each with a witness
- Aurora boot stages as real RISC-V executables

**Read the counts rather than trusting a sentence.** The README's figures come from a witness that
writes those numbers, and they move every week. A number copied into a lesson goes out of date the
first lap nobody edits both.

Everything past that list lives in the designing room until a witness brings it across.

---

## A first picture of code

You will write this in the first hour, after the toolchain is on the desk. Read it now as a story.

```
let rooms = run ["sh" "-c" "ls -d */ | wc -l"]
assert rooms.ok else "the listing must succeed before its number is trusted"
let count = trim rooms.out
say "this tree has ${count} rooms at its root"
assert count != "0" else "a tree with no rooms is not a tree"
```

Line by line.

1. Ask the machine to list the folders at the root and count them. Store that answer in a name, `rooms`.
2. Check that the listing itself succeeded *before* trusting the number. That check is an
   **assertion**: a promise the program insists on.
3. Clean the extra space off the number, call it `count`.
4. Speak the sentence with the number filled in.
5. Check that the tree has at least one room.

Two habits live in those five lines, and they are Grain in miniature. **Measure first. Trust a
number only after the step that produced it has been shown to work.**

---

## How a beginner walks the first hour

Hands come after the map. The tree already wrote this path as
[`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md), in this same register.

1. Clone the seed or the field with `git`.
2. Fetch the pinned Zig toolchain. Read `verdict=ok`.
3. Build Rye. A language compiling itself is called **bootstrapping**.
4. Build Rishi from Rye. Run a hello program and hear it answer.
5. Run one witness. Watch it print green.
6. Write `first.rish`. Run it. Hear the tree count its own rooms.

Each step shows a result you can see. That is the whole method.

---

## A small glossary to carry

| Word you will see | What it is in one breath |
|---|---|
| Code | Instructions a person writes for a machine |
| Compiler | Turns those instructions into what the chip runs |
| Shell | The place you type, and the program that listens |
| Repository / tree | The project as a folder, with history |
| Commit | One saved, signed moment of that history |
| Witness | A program that proves a claim on metal |
| Bound | A named ceiling, set before work begins |
| Two Rooms | Proven, or proposed, and labelled |
| Room | A folder with a job |
| Green | The witness held |

---

## Where Lesson 2 goes

Three honest next walks, each about an hour of reading and looking:

**Walk A -- the Front Door.** Read `README.md`, then `MAP.md`, then the first pages of `SOURCE.md`.
You will know what runs and where the keys come later.

**Walk B -- the first hour with hands.** Follow the tutorial on a machine with `git` and a
terminal. You will have compiled a language, built a shell, and run a witness.

**Walk C -- one running part, slowly.** Open `caravan/README.md` and its ladder. A ladder here means
each module proves one new property on top of the one beneath it.

[Lesson 2](20260910-060225_lesson-2-the-front-door.md) takes Walk A.
