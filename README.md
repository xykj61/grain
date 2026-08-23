<p align="center">
  <img src="assets/grain-logo.svg" width="168" height="168" alt="Grain -- a sepia-gold wheat stalk whose ten grains are the sephirot, woven on a linen grid" />
</p>

<h1 align="center">Grain</h1>

<p align="center"><em>An operating system and a civic application, built in the open, from first principles, with genuine joy.</em></p>

<p align="center">
  <a href="LICENSE"><img alt="Code license: Apache-2.0 OR MIT" src="https://img.shields.io/badge/code-Apache--2.0%20OR%20MIT-c8992f"></a>
  <a href="LICENSE-CC-BY"><img alt="Docs license: CC-BY-4.0" src="https://img.shields.io/badge/docs-CC--BY--4.0-9a6f22"></a>
  <a href="context/RADIANT_STYLE.md"><img alt="Prose: Radiant Style" src="https://img.shields.io/badge/prose-Radiant-d9b45a"></a>
  <a href="context/TAME_GUIDANCE.md"><img alt="Code: TAME discipline" src="https://img.shields.io/badge/code-TAME-9a6f22"></a>
  <a href="tools/"><img alt="Proof: witnesses on metal" src="https://img.shields.io/badge/proof-witnesses%20on%20metal-2f7d4f"></a>
  <a href="context/TWO_ROOMS.md"><img alt="Status: primordial, honest register" src="https://img.shields.io/badge/status-primordial-b9954a"></a>
</p>

---

**Grain is an operating system you can actually own.** Every promise it makes is checked by a
program rather than asserted in a sentence, every part of it declares its limits before it runs,
and the keys stay in your hands. It is early and it says so. What is here already runs, and this
page marks plainly which parts those are.

**New here?** Two links, and nothing else you need yet: **[why this exists](foundations/20260823-034321_the-return-that-feeds-everyone.md)**
for the idea in plain English with no code in it, and **[your first hour](docs-geode/tutorials/the-first-hour.md)**
to clone the tree and watch something turn green on your own machine.

---

## Contents

[The problem](#the-problem) - [What makes this different](#what-makes-this-different) -
[What runs today](#what-runs-today) - [Where the tree stands](#where-the-tree-stands) -
[The words we build with](#the-words-we-build-with) -
[What we are working on now](#what-we-are-working-on-now) -
[How this tree is organised](#how-this-tree-is-organised) -
[Start here](#start-here) - [The disciplines](#the-disciplines) -
[License and community](#license-and-community)

---

## The problem

The computer in your hand is the least-owned thing you use.

Your words live on someone else's machine. Your identity is a row in a company's table, and the
company can drop the row. The software updates itself without asking, you cannot read what it
does, you cannot check what it claims, and when it changes in a way you dislike your only move
is to leave and lose what you put there.

Meanwhile the software itself has stopped being answerable. A modern application will happily
consume all the memory on a machine because nothing ever told it not to. It will claim a feature
works because a person wrote a sentence saying so. Both of those are normal, and neither has to
be.

**Grain is a bet that a computer can be a thing you own rather than a thing you rent** -- and
that the way to get there is not more features, but fewer unchecked promises.

## What makes this different

Three commitments, and they are the whole pitch.

**1. Everything names its bound.** Every list says in advance how long it may get. Every loop
says how many times it may run. Every buffer says how much it will hold. Nothing grows until
something breaks. Our code discipline is called **TAME**, and its ordering is **safety first,
performance second, joy third** -- where *joy* is a real entry meaning clear names, short
functions, and writing down *why* and not only *what*. Safety is structural here rather than a
convention people are asked to remember. See [`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md).

**2. A claim is true when a machine says so.** A **witness** is a small program whose only job
is to try to break a claim and print **GREEN** only when it could not. "The parser handles empty
input" is a hope; a witness that feeds the parser empty input on a real machine and prints green
is a fact -- one a computer stated before any human wrote a sentence about it. And a check that
cannot fail is not a check: every witness here must be shown failing on purpose against a
deliberately broken input, or it does not count.

**3. Every page tells you which room it is in.** What *runs* and what is *designed* are never
allowed to blur, because a project that blurs them is lying slowly. Each page marks itself
proven or proposed -- the discipline has its own home at [`context/TWO_ROOMS.md`](context/TWO_ROOMS.md).

Underneath all three is one idea, borrowed from ecological farming and explained without jargon
in **[The Return That Feeds Everyone](foundations/20260823-034321_the-return-that-feeds-everyone.md)**:
a field can be made to feed itself, producing its own fertility from plants alone rather than
buying it on a truck each season. **A system that renews itself from within needs no input it
cannot account for.** That is a farming sentence and a software sentence, and they are the same
sentence.

## What runs today

Stated conservatively. Anything not listed here is design rather than software.

- **The witness suite** -- the parity gates in [`tools/`](tools/) that guard every push. This is
  the load-bearing one: state proven on metal rather than asserted in prose.
- **The Glow desk** -- the language's generator hops lower to Rye and run green. Glow is what
  people write; **Rye** is the bounded systems language it becomes, and Rye runs on the metal
  with nothing interpreting it. See [`glow/README.md`](glow/README.md) and [`rye/README.md`](rye/README.md).
- **A real app on a real phone** -- an installable Android package with resource, network, and
  sensor grants that respect the platform's own permission model. See [`docs/TUBE.md`](docs/TUBE.md).
- **The module seeds** -- the shell, the naming layer, the wire, and the rest, each with its own
  witness in `tools/`.
- **First light on bare hardware** -- **Aurora** cross-builds boot stages to real RISC-V
  executables in the tree.

**A full operating-system boot is a bright horizon rather than a thing you can do today**, and
this page will not pretend otherwise until a witness says so.

## Where the tree stands

These numbers are **generated, never typed** -- refreshed by `rishi/bin/rishi run tools/readme_metrics.rish write`
and held honest by [`tools/readme_metrics_witness.rish`](tools/readme_metrics_witness.rish),
which reds if the block drifts. A hand-typed figure in the most-read file a project owns is a
claim that quietly rots.

<!-- metrics:begin -- generated by tools/readme_metrics.rish; do not edit by hand -->

| Reading | Now |
|---|---|
| **Fascia** -- can a reader follow any thread home | **41** / 100 |
| **Witnesses** running on metal | **1657** |
| **Rye modules** they stand over | **1890** |
| **Rooms grown past what a browser can list** | **0** |

<!-- metrics:end -->

Commit count and file count are deliberately absent: both move constantly, neither says whether
the software is well, and a number that goes stale every commit is one nobody keeps current.

## The words we build with

A name should be clear enough for a newcomer on day one and still pleasant to type on day ten
thousand, so this project reaches for the plainest, warmest, safest word it can find and never
for a clever coinage. Simplicity is the point, not a compromise toward it.

| Name | What it does, plainly |
|---|---|
| **[Caravan](caravan/)** | A group that travels together and arrives together. It starts every other part in the right order, watches each one, and restarts anything that stumbles -- all within limits fixed before it began. |
| **[Tally](tally/)** | Keeps the books on memory. Every allocation is counted against a declared ceiling, so the system can *prove* it stayed inside its promise rather than believing it did. |
| **[Mantra](mantra/)** | Names things so a name never lies. Ask for a name, get exactly the bytes you got last time, forever -- what makes a system reproducible rather than merely repeatable. |
| **[Comlink](comlink/)** | Carries sealed messages between machines. It moves bytes without reading them, and what arrives is bit-for-bit what left, or it is refused. |
| **[Pond](pond/)** | A fence around a running program: this much memory, these files, this network, nothing else. A program cannot exceed a boundary it was never handed. |
| **[Amphora](amphora/)** | A sealed vessel for something crossing a boundary -- closed, checked, opened only by whoever it was addressed to. |
| **[Rishi](rishi/)** | The shell. The plain-language hand you use to run the tree. |
| **[Glow](glow/)** - **[Rye](rye/)** | The language people write, and the bounded systems language it lowers to. |
| **[Kumara](kumara/)** | Identity you own -- a key you hold, rather than an account someone grants and can revoke. |
| **[Aurora](aurora/)** | The dawn. The first code that wakes on bare hardware before an operating system exists. |
| **[Skate](skate/)** - **[Brushstroke](brushstroke/)** | The drawing surface, and the strokes made on it. |
| **[Mycelium](mycelium/)** | The quiet network underneath, named for the thread that connects a forest. |

Every seated term, with the date and the reason it was chosen, lives in
[`context/LEXICON.md`](context/LEXICON.md).

## What we are working on now

**Caravan**, and one thing at a time on purpose.

Caravan is the supervisor -- the part that starts everything else and keeps it honest. In a
system whose entire promise is that it stays inside its bounds, **the part that supervises
everything else is where that promise is either kept or lost.** Nothing beneath it can be
trusted further than it can. So it gets the attention now, ahead of features that would demo
better, because it is the hardest problem still solvable and the one whose solution unlocks the
rest.

**This repository is molten**, and that word is chosen carefully. It is in its primordial phase:
shapes are still moving, interfaces still change, and a design settled on Tuesday may be re-cut
on Friday because a better one appeared. That is deliberate -- it is far cheaper to move a wall
now than after a thousand people have hung pictures on it.

The honest consequence: **polished tutorials are not the priority yet.** Beautiful documentation
for an interface about to change is work thrown away twice, once writing it and once believing
it. What you get instead is honest marking -- every page says whether it runs or is planned. When
the shapes settle, the teaching begins in earnest, and the room for it is already built.

## How this tree is organised

A room is a promise about what you will find in it. There are more rooms than most projects
have, for one reason: **thinking and building are filed separately, so neither crowds the other
out.**

**The rooms that ship here**

- **[`foundations/`](foundations/)** -- *why* the work exists. Durable essays that would still
  be worth reading if every line of code were deleted. Start here if you want the spirit.
- **[`external-research/`](external-research/)** -- the world, studied with its real names
  attached. Outside projects are read directly and cited plainly. This room is allowed to be
  wide and curious.
- **[`active-designing/`](active-designing/)** -- design that outlives its code: a shape, a name,
  an invariant, a trade-off. Essays about *how a thing should be*.
- **[`active-development/`](active-development/)** -- the notes of a working session: scoping a
  round, planning a lap, recording what a survey found. Notes about *what we did*.
  One blunt question sorts the two: *would this still be worth reading if the code it describes
  were deleted?* Yes goes to designing, no goes to development.
- **[`docs-geode/`](docs-geode/)** -- the shipped documentation shelf, and an ambition rather
  than a finished thing. A geode is plain outside and crystalline within; the aim is a reference
  that repays cracking open -- the [language reference](docs-geode/api/rishi-language-reference.md),
  a [generated index of every library](docs-geode/libraries/README.md), [demos you can run in a
  minute](docs-geode/demos/README.md), and [how to read this tree](docs-geode/study/README.md).
- **[`manual/`](manual/)** and **[`edu/`](edu/)** -- the onboarding rooms and the teaching material.
- **[`context/`](context/README.md)** -- the disciplines themselves, listed below.
- **[`tools/`](tools/)** -- every witness. The proof, not the prose.
- **[`waymarks/`](waymarks/)** and **[`context/specs/`](context/specs/)** -- the named plans and
  the settled rules.

**The rooms kept in the maintainer's field**

Some rooms are personal working tissue rather than published work, and the public seed is
projected without them. They are named here so the tree is legible rather than mysterious --
there is nothing to click, because in this repository there is deliberately nothing there.

*Session logs* keep a reasoning trace for every working round, so a future reader can follow how
a decision was actually reached. *Crux* holds the live operator card -- what is next, right now.
*Expanding-prompts* holds intent expanded into runnable plans. *Gratitude* is a reading library
of the projects we learn from, held whole and unmodified, which is why it is not redistributed
here. And *classical-vedic-astrology* is exactly what it sounds like: a personal study room for
learning and self-reflection, kept in the field because a person's contemplative practice is not
a dependency of an operating system. It does earn one working use -- a reading **rota** cycles a
few foundational documents back into view on a schedule, so the reasoning behind the work stays
fresh rather than being read once and forgotten.

**Two disciplines that shape what gets written**

- **The silo** ([`context/SILO_TECHNIQUE.md`](context/SILO_TECHNIQUE.md)) -- an idea from outside
  enters by being understood and then restated in our own words, with the original names and
  phrasing left at the door. Ideas cross freely; copied text never does. If a sentence still
  sounds like its source, it has not been siloed yet. Gratitude stays in its own room, explicit
  and warm, so the teacher is thanked rather than erased.
- **Civic style** ([`context/CIVIC_STYLE.md`](context/CIVIC_STYLE.md)) -- the same care applied
  to policy and public benefit as to code. Every system rewards something; the whole of good
  design is asking *what, exactly*, and closing the gap between what you measure and what you
  actually want.

## Start here

**Your first hour**, before any map: [`docs-geode/tutorials/the-first-hour.md`](docs-geode/tutorials/the-first-hour.md).
Clone, run one witness, read the green line it prints, write five lines and run them. One page,
one path, no branching.

Then, in order:

1. **[`SOURCE.md`](SOURCE.md)** -- from nothing to a signed, sandboxed home.
2. **[`ORGANIZING.md`](ORGANIZING.md)** -- where each kind of work lives.
3. **[`MAP.md`](MAP.md)** -- the rooms of the tree at a glance.
4. **[`manual/glow-os/`](manual/glow-os/README.md)** -- the onboarding rooms.
5. **[`CONTRIBUTING.md`](CONTRIBUTING.md)** -- how a contribution arrives: small, signed,
   component-prefixed, and written like prose rather than a changelog.

Two root config files hold what is specific to *your* machine and *your* identity, so the tree
stays a clean template: copy **[`GLOW_HOST.template.bron`](GLOW_HOST.template.bron)** to
`GLOW_HOST.bron` for this host's OS, architecture, and toolchain paths, and
**[`GLOW_PROFILE.template.bron`](GLOW_PROFILE.template.bron)** to `GLOW_PROFILE.bron` for the
identity that signs the work. Both stay out of git.

## The disciplines

- **[`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md)** -- how the code stays safe.
  Invariants stated before the code that leans on them, a bound on everything, docs and code kept
  in step. Safety first, performance second, joy third.
- **[`context/RADIANT_STYLE.md`](context/RADIANT_STYLE.md)** -- how the prose reads: lead with
  what *is*, active voice, warm and true read aloud.
- **[`context/SIMPLE_LOVABLE_COMPLETE.md`](context/SIMPLE_LOVABLE_COMPLETE.md)** -- how a thing is
  scoped so it is worth loving.
- **[`context/TWO_ROOMS.md`](context/TWO_ROOMS.md)** -- why every page tells you whether it is
  proven or proposed.

The reasons beneath them live in [`foundations/`](foundations/README.md) -- among them
[the custody-first principle](foundations/20260724-200912_nothing-to-give-custody-first-principle.md)
(*build nothing that destroys*), [the wire serves the fold](foundations/20260706-022912_the-wire-serves-the-fold.md),
[sameness is the macro](foundations/20260703-182612_sameness-is-the-macro.md), and
[the long return](foundations/20260811-211431_the-lindy-effect-and-the-long-return.md).

**Standing on shoulders.** Grain is built in gratitude to the makers who came before, and we
study their ideas in a clean room and write our own code beneath our own names. We owe the
static-allocation discipline behind TAME to a database team who proved it in production; the
stop-the-line, fix-it-now habit to a manufacturing tradition; clarity that scales, safety a
compiler can prove, and the floor the whole house stands on to three languages that came before
ours; small tools that compose and the freedom to run and share them to the Unix and GNU/Linux
lineage; tensegrity -- strength from balanced tension -- to a visionary engineer; and the runes,
referential transparency, and the personal-server dream to a project that first lit this way,
held [with thanks rather than dependence](.claude/rules/urbit-reframe.md). Each is thanked by
name, one note apiece, in the maintainer's field, where the works themselves are held whole and
unmodified rather than redistributed.

## License and community

A single top-level **[LICENSE](LICENSE)** indexes the terms: code under
**[Apache-2.0](LICENSE-APACHE) OR [MIT](LICENSE-MIT)**, your choice; prose and documentation
under **[CC-BY-4.0](LICENSE-CC-BY)**. Every commit is signed, and the history proves who wrote
it.

How we treat each other: [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md). How to report a weakness
privately: [`SECURITY.md`](SECURITY.md). What changed: [`CHANGELOG.md`](CHANGELOG.md). How to
contribute: [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

> *"When I am working on a problem, I never think about beauty ... but when I have finished, if
> the solution is not beautiful, I know it is wrong."* -- attributed to **Buckminster Fuller**.
>
> *"Be joyful though you have considered all the facts."* -- **Wendell Berry**,
> *Manifesto: The Mad Farmer Liberation Front*.

---

*May the front door stay plain and glad. May every promise here be one a machine can check, so
you never have to take our word for it. May the ground you stand on be yours. And may you find,
on your first visit or on your long return a decade from now, exactly what you came for -- and a
reason to smile on the way through.*
