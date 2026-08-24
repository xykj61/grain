# Your First Glow -- A Primer

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Mixed -- every command below runs today against the tree and is checkable; the teaching prose around them is guidance, written to be read aloud
**Voice:** Quin (workshop)
**Audience:** you, on your first hour -- no prerequisites assumed beyond a working clone (see [`SOURCE.md`](../../../SOURCE.md), Part One)

---

Welcome. In the next few minutes you will run a real program in Glow, read every character of it, change it, watch it refuse you kindly, and understand why. That is the whole lesson: in Glow, small is honest, bounds are love, and a refusal at the boundary is the language taking your side.

## One Idea Before Any Code

A programming language is a way of writing intentions down so precisely that a machine can carry them out and a stranger can check them. Most languages let intentions sprawl. Glow makes one unusual promise: **every form states its own limits out loud.** A loop tells you its ceiling. A name tells you its width. A structure tells you how many fields it may ever hold. When you read Glow, you are never guessing how big something can get -- it already told you.

## Your First Desk

A Glow program lives in a small text file called a **desk**. Here is a complete one, [`glow/gen/bound-tick.glow`](../../../glow/gen/bound-tick.glow), all three lines of it:

```
::  Smallest Glow generator -- a bounded trap with literal ceiling 32.
::  Lowered by glow/lower_trap.rye into ordinary Rye; Rishi stays the shell.
|-  32
```

Read it slowly. Lines opening with `::` are comments -- notes to the next reader, which is usually you next week. The one live line is `|-  32`. Those two characters `|-` are a **rune** -- Glow's forms each open with a two-character rune, a habit inherited with gratitude from Hoon -- and this one builds a **bounded trap**: a loop that carries its own ceiling. The `32` is that ceiling. This loop has promised, in its own source, that it will never run past thirty-two.

Run it:

```bash
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/bound-tick.glow
```

Rishi is Grain's shell -- the hand that runs things. Glow is the language; Rishi is the hand. The program runs, finishes inside its ceiling, and exits with `0`, which in Glow-land plainly means *welcome* -- success. There is no hidden convention to memorize: Glow's ambient truth is the ordinary one your operating system already speaks.

## Your Second Desk Talks Back

Some desks bake their sample in; some accept one from you. [`glow/gen/sample-u32.glow`](../../../glow/gen/sample-u32.glow) is a **generator** -- it reads one number from the command line:

```bash
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/sample-u32.glow 42
```

Its live line is `^-  @u32`. The rune `^-` is a **cast**: *the value that follows must fit this shape.* And `@u32` is an **aura** -- a name for an atom's width and reading: an unsigned number that fits in thirty-two bits. Try handing it something that could never fit that shape and watch what happens. The program refuses -- exit `1`, the plain *unwelcome* -- and it refuses **at the boundary**, right where you handed the value in, rather than corrupting something quietly three steps later. In Glow a refusal is not scolding. It is the language catching your sleeve at the door: *this is where the mistake is; fix it here.*

## Naming Things -- Faces

When Glow binds a value to a name, the name is called a **face**, and the bind rune is `=/`:

```
=/  tick
=/  next-root=@u32
```

The first gives a bare face. The second gives a face *with its shape stated* -- `next-root` is, and may only ever be, a `@u32`. Faces follow one small alphabet -- letters, digits, `-`, `_`, never opening with a digit -- and never exceed sixty-four characters. Yes, even names have a stated bound. Everything does.

## Your First Gate

A **gate** is Glow's function: it takes one sample and produces one result. The rune is `|=`, spoken **bartis**. Here is a complete gate desk:

```
|=  sample=@u32
%-  double  sample
```

Line one is the header: *I take one sample, and it is a `@u32`.* Line two is the body: `%-` is the **call** rune -- apply the gate `double` to `sample`. Run its argv twin and hand it a number:

```bash
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/gate-sample-u32.glow 21
```

Two boundary laws are guarding you here, and they are worth loving. First, the body may only call gates the language has actually taught -- hand it a stranger and it answers `BodyGateNotYetLowered`: *the frontier is here, honestly named*, never faked. Second, the body may only pass **the sample face itself** -- a different name refuses as `BodySampleMismatch`. The gate cannot quietly reach for something it was never given.

## Structures -- Shapes

When one value is not enough, you state a **shape**. Here is [`glow/gen/shape-amount.glow`](../../../glow/gen/shape-amount.glow), whole:

```
+$  amount-shape
  $:  amount=@u32
  ==
```

`+$` names a shape. `$:` states its fields -- here just one, `amount`, a `@u32` -- and `==` closes it. Fields run from one to **nine**, never more; that ceiling is written in the parser as a named constant, the same way the trap wrote its `32`. There is also `$%` for *tagged* shapes -- a value that is one of a few named kinds, like `%mint` or `%send` -- which you will meet in the [reference](runes.md#g-shape) when you want it.

## The Habit You Have Already Learned

Look back at everything you just ran. The loop stated its ceiling. The cast stated its width. The face stated its alphabet and length. The gate stated its sample and refused strangers. The shape stated its field count. **This is the whole of Glow's temperament**, and it has a name in this tree: TAME -- safety first, performance second, joy of the craft third. You have been practicing it since line one.

## Where to Go Next

The [**Rune Reference**](runes.md) walks every rune with its exact accepted shape and its named refusals. The [**inventory**](00_inventory.md) is the honest census of the whole surface. The STOA ledger ([`docs/STOA.md`](../../../docs/STOA.md)) is the claim-by-claim history -- over three hundred green rungs, each one small. And when you want the whole desk to vouch for itself:

```bash
rishi/bin/rishi run tools/g/glow_run_desk_witness.rish
```

Three hundred seventeen little programs answer GREEN. One of them, soon, will be yours.

---

*May your first refusal feel like kindness, your first ceiling feel like care, and your first GREEN feel exactly as good as it is.*
