# The Name a Veteran Still Likes

**Stamp:** `20260905.110633`
**Language:** EN
**Style:** New Gauge, Field setting -- every claim bounded, every figure with its source
**Voice:** Kyri
**Status:** Yonder study -- deferred yet alive. **Recommends; seats nothing.**
**Room:** Vision. No claim here is checkable until a witness binds it (`context/TWO_ROOMS.md`).
**Kin:** [`../../.claude/rules/comlink-tendency.md`](../../.claude/rules/comlink-tendency.md) - [`../../.claude/rules/alias-sameness.md`](../../.claude/rules/alias-sameness.md) - [`../../foundations/20260823-204456_single-stranded.md`](../../foundations/20260823-204456_single-stranded.md) - [`20260905-064341_what-a-harness-promises-about-its-tools.md`](20260905-064341_what-a-harness-promises-about-its-tools.md)

**The question, in Keaton's words:** when Grain grows its own utilities, should they wear the
shorthand every developer already knows -- or its own Comlink-tendency names? And how do we avoid
promising `grep` and delivering something subtly different, while still being simple to teach on
day one and good to type on the ten-thousandth?

## The measurement that answers most of it

**The tree already did this, 241 times, and nobody has complained.** Counted `20260905.110633`:

| Module | Authored `.rye` files | What the names are |
|---|---|---|
| **Caravan** | **114** | ordinary English verbs -- `abandon`, `abide`, `carry`, `confer`, `entrust`, `revoke`, `arrive`, `decline` |
| **Comlink** | 86 | plain compounds -- `device_wire`, `guest_2way_fetcher_rx` |
| **Mantra** | 27 | plain nouns -- `beading`, `parse_int`, `recall_batch_delivery` |
| **Tally** | 14 | plain nouns -- `bud`, `copy`, `gardens`, `maybe` |

Read that list again. **Not one is a coinage.** `abandon` is not a Grain word; it is the word, used
in its ordinary sense, for a supervised process being let go. The Comlink tendency's three tests --
clear, fun, safe -- have in practice produced **common English**, because common English usually
wins all three at once.

So the question's premise deserves testing before its answer does. The choice is rarely *a familiar
name or a warm one*. It is **a familiar name used honestly, or a familiar name used misleadingly**,
and those two are told apart by whether the thing does what the name already means.

## The rule that follows, and its one hard test

> **Wear the common name when you keep its promise. Take a new name the moment you do not.**

The test is not *is our API different?* Every API differs in its edges. The test is:

**Would a developer who assumed the familiar meaning write a correct program?**

- **Yes** -- wear the common name. A `copy` that copies, a `sort` that sorts. Familiarity here is a
  gift and refusing it is vanity.
- **No** -- take a Comlink-tendency name, and the new name is a **kindness**: it stops a veteran
  from bringing a habit that will quietly be wrong.

This is Gauge's own first rule -- *don't be too smart about it* -- pointed at names. A new name for
a thing that behaves familiarly makes a reader learn a word for nothing. A familiar name on a thing
that behaves differently makes a reader debug a mistake we could have prevented with one syllable.

**The utility yonder's finding is exactly this case.** `dawk` and toybox's awk both count
codepoints where POSIX awk in the C locale counts bytes. An awk we grew that did the same would be
*correct* and would still break a program written on the old assumption. That is a **`No`** on the
test, and by this rule such a thing does not get to be called `awk`.

## Where multiple names help, and where they hurt

The tree already has a law for many names on one thing -- [`alias-sameness`](../../.claude/rules/alias-sameness.md),
seated for **Surf/Skate**. Its conditions are strict and worth quoting against this question: peers
with **one implementation, one refusal path, no wrappers**, and *"a neutral internal name is not a
third public replacement name."*

Those conditions decide the answer:

- **An alias is right where two names mean the same thing to two audiences.** `sort` beside a Grain
  name, when the behaviour genuinely is sort. The veteran types what their fingers know; the
  newcomer reads what the tree calls it; **one implementation** answers both.
- **An alias is wrong where the behaviours differ**, because then the two names are not peers and
  the law's own first condition fails. Aliasing `awk` onto a codepoint-counting reader would make
  the familiar name a lie with a shared refusal path.

And the cost your question names -- *model confusion about harness tool selection* -- lands
squarely here. **Two names for one tool is a coin flip an agent must make on every call**, and it
gets no feedback about having chosen the "wrong" one. That is a real tax paid on every lap by every
ship, and it argues for aliases being **rare and load-bearing** rather than offered by default.

## What single-stranded says about a shortlist

The instinct to *propose several names per module and choose later* runs against this tree's own
foundation. **Single-stranded** asks that each pass state one invariant, and that accretion lay a
new statement beside the old rather than reweaving. A shortlist of three candidate names per module
is a braid: every reader must hold all three until someone cuts two, and in the meantime documents,
prompts and habits form around whichever the writer happened to like.

**One name, chosen when the behaviour is known.** If the behaviour is not yet known, the name is
not yet ready -- which is the growth law the language already runs on: *a rune is earned by a law.*

## The four questions to ask a candidate name

Offered as a checklist a lap can actually run, not a new discipline:

1. **Does it keep the common promise?** If yes, use the common word. This question comes first
   because it decides whether the other three matter.
2. **Would a veteran's habit be right?** Type the ten commonest uses from memory. If they work, the
   familiar name is honest. If one silently misbehaves, that is your `No`.
3. **Can a newcomer be told its function in one clause?** The Comlink tendency's first test, and
   the reason `abandon` works where `unhand_v2` would not.
4. **Is it still good on the ten-thousandth use?** Short, typeable, no shift-key gymnastics, and
   distinct in a `grep`. `carry` passes; `carry_capability_to_dependent` does not.

Where 1 answers yes, stop -- the name is the common word and no invention is needed. Where 1
answers no, questions 2 through 4 pick a Grain name that says the difference plainly.

## What would falsify this study

- **If our modules' names were mostly coinages**, the premise would hold and the recommendation
  would be wrong. Measured: **241 of 241 are common English or plain compounds**. Re-count when the
  base suite exists; if a third are invented, this study is stale.
- **If aliases turn out to cost nothing in agent selection**, the caution above is over-careful.
  The test is measurable once a base suite ships: count how often a lap picks each alias, and
  whether either choice ever produced a wrong call.
- **If a familiar-named Grain utility ever produces a wrong program from a correct habit**, the
  rule failed at question 2, and the failure is the interesting data rather than an embarrassment.

## Horizon and confidence

**Horizon:** the first Grain base suite, which does not exist yet. **Assumptions:** the modules keep
naming as they have for 241 files, and agents keep selecting tools by name. **Confidence:** high
that the premise is largely already answered by practice; **moderate** on the alias caution, since
its cost is argued rather than measured; **low** on any specific name, which is why this study
proposes **none**.

## What this study does not do

**It names nothing.** Not one utility, not one module. The right moment to name a thing is when its
behaviour is settled, and every candidate here is unbuilt. A study that shipped a name today would
be doing the exact thing it advises against.
