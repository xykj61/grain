# The Words a Round Uses

*Ten words this tree reaches for every working day, defined for someone meeting them on their first morning -- and an honest account of which ones were carrying more than one meaning, and what happened to them.*

**Stamp:** `20260821.175723`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Foundation -- the definitional half of the Standfast restrategizing, arc three
**Kin:** [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) (how work is marked) - [`../context/LEXICON.md`](../context/LEXICON.md) (every seated term, with its date) - [`20260816-214652_standfast-the-stopped-line.md`](20260816-214652_standfast-the-stopped-line.md)

---

## Why this page exists, and why it is short

A tree that names things well accumulates names. Ours accumulated faster than it defined them: `arc`, `carry`, `lap`, `ladder`, `fold` and `rung` were doing daily work in session logs, commit messages, and the operator card while the Lexicon held a row for none of them. A word in constant use and never written down drifts, and a drifting word eventually means two things at once -- which is how this tree ended up with **`fold` carrying four senses** and **two live meters sharing the name `sundial`, told apart by a capital letter.**

So this page does two things and stops. It **defines** the ten words a round actually uses, and it records **which words were pruned** so the next reader inherits fewer meanings rather than more. The success condition for the round that wrote it was a *shorter* glossary, not a longer one, and that discipline governs this page too: ten entries, one paragraph each, no coinages.

## The ten

**arc** -- a bounded stretch of work with a named end. An arc opens on a word, holds one question, and closes when that question is answered or honestly set down. Bigger than a round, smaller than a season. *"Arc one is the mark and the path"* names a whole line of work; you can tell an arc is over because something is true that was not true before.

**round** -- one exchange of work: a question, the work it asks for, and the record it leaves. A round ends with a session log and, usually, a commit. It is the unit this tree actually lives in.

**lap** -- one complete pass of mechanical work inside a round. A lap is **complete in itself and owes nothing to the lap before it** -- you can run the fortieth without the thirty-ninth. That independence is exactly why `lap` replaced numbered rungs for planned work: a lap makes no promise about order, and an ascending number does.

**ladder** -- a real file whose entries genuinely run in sequence, where the order is load-bearing. `caravan/ladder_checks.rye` is one: 8,768 lines of checks whose doc comment explains why each must come after the one above it. The metaphor is exact there, and the word is kept for exactly that.

**rung** -- one entry of a real ladder. Kept where a ladder exists in code; **retired** as a name for a step of *planned* work, where it borrowed a ladder's implied dependency for items that had none. For planned work, say **lap**.

**fold** -- to file dated files into `<room>/date/YYYYMMDD/` when a room outgrows a reader. This is the sense the word now holds: it is seated in the mark law, in three tools, and in a Lexicon row. Folding moves files and changes paths; it never changes a basename, which is what makes every reference to a folded file recoverable.

**lift** -- to take a family of rungs out of a ladder into its own module, leaving a short delegate behind. This work used to be called folding too, and the two senses were both operational verbs about moving things around the tree -- the one real collision. **`lift` is the word going forward**, and it is the word the commits already reached for on their own: *"Fold AI lifts weigh_the_standing..."*

**carry** -- the total lines a ladder holds, counting every copy. Carry falling is the point of a lift. Carry alone can be gamed, though: a three-line delegate that forwards to a two-hundred-line body reports as three, so carry can be satisfied by *moving* lines rather than removing them. Which is why it is never read alone.

**delegate** -- the short forwarder a lift leaves behind in the ladder. Counted beside carry (`CARRY_DELEGATES`, 2,365 as of `20260821`) precisely because it is the thing carry cannot see. When carry falls and delegates hold, lines genuinely left the tree; when both move together, a fold traded a cost for a cheaper-looking one. **Two readings, so no single number can dress movement as progress.**

**fascia** -- the tree's connective tissue: the references, links, and citations that hold the writing to the code and each room to its neighbours. High fascia means a reader can follow any thread home. **The word is kept as it is** -- a proposal to lengthen it to *myofascia* was declined, because *myo-* means muscle and narrows the word away from the between-everything sense actually meant. What fascia needed was not a longer name but a definition and a working meter, and its meter is honestly **RED** today (REDS %112): `tools/gen/season/fascia_metric_v0.rish` cannot report because an unrelated Amphora lap fails first. An instrument should be no more braided than the thing it measures.

## Two words that were one

**Sundial** and **Plumb** were a single word wearing two jobs, separated only by a capital letter -- which is not a distinction, it is a typo waiting to happen.

**Sundial** keeps the health face (`sundial/sundial.rye`): module witnesses rolled into a health percent, plus the fascia reading. A sundial tells the health of the day, the name suits it, and it is the one that ships in the public seed.

**Plumb** is the recursion-prompt confidence meter -- how well the living doors still match the prompt text, as a percent with named bands. A plumb line tells you whether a thing is **true**, which is exactly what that meter reads. The word was free in the entire tree, colliding with nothing. Its file keeps the elder path on purpose: seven living files call it by that name, and a promise kept is worth more than a tidy filename.

## What this page deliberately does not do

It does not rewrite history. Every dated log, commit, and counsel note that wrote `Fold AI`, `f0-f63`, or the lowercase `sundial` **keeps every letter it wrote** -- the one-clock law and accrete-never-break protect them, and a reader three years on should find the record as it was written, not as we later wished it read. These definitions govern what is written from here forward, and living lines sweep to them as they are touched.

It also does not add a word. Not one term here is coined; every one was already in daily use and merely undefined. That was the whole point of the round: a vocabulary problem is almost never solved by more vocabulary.

---

*May these ten words stay few, may each keep meaning one thing, and may the reader who meets them on a first morning find them plain enough to use by afternoon.*
