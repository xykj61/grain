# PLACARD -- How a Pedestal Reads

**Language:** EN
**Last updated:** 2026-07-27 (`20260727.111359` -- the standard seated ahead of the first resident)
**Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Status:** Living -- the museum's house style; every structure that ever stands in this room opens with the placard below, so a visitor meets every shape the same way

---

## The Placard's Six Lines, In This Order

Every pedestal is one structure in one file, and every file opens with a placard -- six lines a visitor reads before any code, always in this order:

**Name** -- the structure's worded name, exactly as seated; a pedestal never guesses a held name. **Shape** -- the fields, one per line, in the value model's plain terms (string - int - boolean - list - record), each bounded field naming its bound. **Invariant** -- at least one, stated positively, before any use. **Example** -- a single literal value, small enough to read aloud. **Readers** -- the modules that consume this shape, by name. **Nib** -- which version of the mark this pedestal shows, because a pedestal always displays a value *at a nib*.

## The Form, In the Room's Own Grammar

Structures in this room are Glow, and Glow speaks its comments with `::`. The placard is the file's opening block:

```
::  name       <the seated name>
::  shape      <field> -- <kind>[, bound <n>]
::             <field> -- <kind>
::  invariant  <what always holds, said positively>
::  example    <one small literal>
::  readers    <Module - Module>
::  nib        <mark-version this pedestal shows>
```

## The Laws of the Room

**One pedestal, one structure.** A file that wants a second shape wants a second file. **Pedestals stand alone.** No pedestal imports another; a shape viewable only beside its neighbors is not yet ready for the museum -- the same simplicity the composing bricks keep. **Change is supersession.** A pedestal advances only at a new nib; the prior placard stays beneath a rule line, so the museum remembers every dress a shape has worn. **Placards read aloud.** The gentle register is welcome here; a visitor hearing the placard should meet the idea before the syntax.

## One Worked Placard, On an Unheld Shape

The clock reading is ours, seated long ago, and touches no held word -- so it models the standard:

```
::  name       clock reading
::  shape      stamp -- string, bound 15   :: YYYYMMDD.HHMMSS
::  invariant  later readings compare larger; the dot sits after day
::  example    20260727.111359
::  readers    Mantra - every dated artifact
::  nib        one-clock, the only version there has ever been
```

## The Witness, Named for Its Day

A **placard witness** -- every file in this room opens with the six lines, in order, before any rune -- earns its build the day the room holds its second resident, and not before. Until then this page is the standard, and the first resident's own review is the gate.

---

*May every shape in this room stand alone in good light, wear its placard plainly, and be understood by a visitor who reads only the first six lines aloud.*
