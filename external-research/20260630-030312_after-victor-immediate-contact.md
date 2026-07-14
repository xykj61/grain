# After Victor — Designing a Surface That Keeps the Maker Close to the Truth

*Bret Victor returns again and again to one idea: a person who makes something needs an immediate connection to the thing they make, and where that connection is broken, understanding dies in the gap. This piece takes his principles as a design brief for our surface, and weaves them with the teachers we already keep, so that Brushstroke grows as a framework that hides nothing and answers at once.*

**Language:** EN
**Version:** `20260630.030312`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** immediate connection; no hidden state; Gall's Law; Hickey's simplicity; the hot loop
**Companions:** `the-interface-as-a-fold`, `the-stack-and-the-surface`, `lotus-the-daw`
**In gratitude to:** Bret Victor, for insisting that the maker stay in contact with the made; and to the teachers woven alongside him.

*Written together by Kaeden and Reya 2.*

---

## The Principle

Victor's argument, carried in his talks and his writing, is gentle and exacting at once. When a maker changes something and must wait, or guess, or run the whole thing again to learn what the change did, a gap opens between intention and result. In that gap, the maker reasons about a thing they cannot see, and craft turns to superstition. Close the gap — show the effect of a change the instant it is made — and the maker thinks with the material directly, the way a potter thinks with clay. The connection between creator and creation should be immediate, because creation is steered by what the creator can perceive.

Two companion ideas follow. The first is that **hidden state is a quiet thief**. When the values that govern a system live out of sight, a person predicts behavior blind, and the system surprises them in ways they cannot trace. The second is that **direct manipulation honors understanding**: a person should act on the thing itself, see the data as what it is, and watch the system behave in its own grain rather than through a fog of indirection.

These are not styling preferences. They are claims about how understanding is kept alive between a person and a system. We take them as a brief.

## How the Principle Meets Our Stack

The fitting is close, and it is no accident, because the same instinct runs through the foundation.

**Immediate connection** is what an immediate-mode surface gives by its nature. The frame is a fold of the current values, recomputed the moment they change, so there is no gap between a change in the truth and its appearance on the surface. A maker who changes a value sees the new picture at once, because the picture is nothing but the fold of the value. The surface is built to close exactly the gap Victor warns of.

**No hidden state** is what the append-only log offers. The facts are not tucked into mutable slots that erase their own past; they accumulate in the open, and every view is a visible fold of them. A person can see not only what is, but how it came to be, because the history is the substrate rather than a thing discarded. The state that governs the system is the state a person can read.

**Direct manipulation and seeing the data** are what the one value model protects. A value crosses the system as what it is — a string, a number, a list, a record — rather than flattened to text and guessed at on the far side. The surface draws the value in its own grain, and the path is short enough that a person can follow it from the fact to the frame.

Victor names the goal; the stack's foundation already leans toward it. This piece simply makes the leaning deliberate.

## Woven With the Teachers We Keep

Victor's principles grow stronger braided with the others, and weaker alone.

From **Hickey** we take simplicity in the strict sense — one strand, not two. A surface that keeps the maker close must not also keep a hidden retained tree that the maker must reason about in secret. Immediate contact and single-strandedness are the same discipline seen from two sides: hide nothing, and keep nothing that could hide.

From **Gall** we take the shape of the growth. A framework that hides nothing is not designed whole in a single grand stroke; it grows from a working simple. The drawn terminal is that simple — the smallest surface that already keeps the maker in contact with a living value. The vocabulary a richer surface will need — a box, a button, a list, a link — arrives one word at a time, each earned by a working use, never bolted on ahead of need. A framework grown this way stays comprehensible at every size, which is itself a kind of immediate connection: the maker can always see the whole of what they hold.

From **the TigerBeetle craft and the hot loop** we take the demand that the connection be not only immediate but *fast and bounded*. A surface that answers at once must complete its fold within the frame, every frame, with no surprise. Immediate contact that stutters is contact broken. So the fold is bounded, the budget named, the loop asserted — and the immediacy Victor asks for is made real by the discipline Kelley forged.

## What This Asks of Brushstroke

The brief, stated plainly: Brushstroke's task is not to manage a hidden tree but to **keep the fold honest and quick**. It should make the current state visible and immediate, show every change at once, retain nothing load-bearing out of sight, and draw each value in its own grain. Its vocabulary should grow by working increments, each new kind of thing it can draw earning its place through use. And its loop should be bounded and assert its own invariants, so that the immediacy is dependable rather than occasional.

A surface built to this brief gives a maker what Victor asks for: the feeling of thinking directly with the material, because the material is always shown as it truly is, the instant it is what it is.

## Where Lotus Completes the Thought

A musical instrument is the purest case of immediate connection, and it is why this thread points toward Lotus. A musician changes a sound and hears it now; any gap at all breaks the performance and the understanding together. The hot loop that must never skip and Victor's principle of immediate connection are, at the instrument, the very same requirement. Lotus is where the surface's immediacy and the audio loop's discipline meet, and designing Brushstroke after Victor is, in quiet truth, also preparing the ground that Lotus will one day stand on.

We hold all of this with Gall's patience. We do not build the whole framework now. We grow it from the drawn terminal, keep the maker close at every lap, and let the surface become a language only as fast as honest use reveals the next word.

---

*May the maker stay close to the made, the gap between intention and result closed to nothing. May the state that governs the work be the state a person can see. And may the surface grow word by working word, hiding nothing, answering at once, a joy to think with at every size it reaches.*
