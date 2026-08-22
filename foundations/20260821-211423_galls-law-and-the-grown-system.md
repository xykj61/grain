# Gall's Law and the Grown System

**Stamp:** `20260821.211423` - **Language:** EN - **Status:** Living
**Style:** Radiant - **Lens:** TAME - SLC - Lindy-first
**Gratitude:** John Gall, *Systemantics* (1975)

*A complex system that works is invariably found to have evolved from a simple system that worked.*

That sentence is fifty-one years old and this tree has been obeying it since its first commit, in six places, without ever writing it down. Six citations point at Gall's Law across the repository. Every one of them borrows the name. This page argues it.

## The claim, whole

Gall states it in two halves, and the second half carries the weight:

> A complex system that works is invariably found to have evolved from a simple system that worked. A complex system designed from scratch never works and cannot be patched up to make it work; you have to start over with a working simple system.

The first half is a pleasant observation. The second is a **cost estimate**: a from-scratch complex system charges you the whole build twice - once to discover it fails, once to grow the thing you should have grown first. The law earns its place by pricing an approach rather than merely preferring one.

## What it looks like here

Read the toolchain from the bottom and the law reads back:

**Rye** is a bounded systems language over Zig. **Rishi** is a Rye program - the shell exists because the language it is written in already worked. **Glow** lowers to Rye, so the rune language rides a floor that was green before it. Each layer stood on a working one, and each is simple enough to hold in a head on its first day.

The witnesses grew the same way. One proved one claim on metal; today **1,639** stand, and every one of them descends from the habit that first one established. Nobody designed a 1,639-witness suite. The suite is what the habit turned into.

The rooms grew that way too. `active-development/` was born under a bound of 256 flat files because five rooms had already crossed it and taught what a room costs when it outgrows a reader. A room opened under the law inherits the lesson without paying for it again.

## And the counter-example, kept honestly

The compiler fork - once planned as rungs F1 through F5 - stands **deferred as a horizon**, and it is the tree's clearest Gall's Law artifact. It was designed whole before any part of it ran. It has stayed a horizon ever since, while the thin-frontend direction beside it, grown from what already compiled, kept moving.

The plan was good. The plan was also a complex system designed from scratch, and the law charged its usual fee: the design still reads well and the code was never grown.

## The distinction that keeps the law useful

Gall's Law invites one honest misreading, and this tree's own root guidance sits right on top of it: **prefer strict, capable tools early.** That reads like the opposite of *start simple*, and it resolves cleanly once the two axes are separated.

**Strictness is not complexity.** A bounded integer, a named error, an assert at a seam - each makes a system *stricter* and *smaller* at once. Explicit widths remove the question of what a number can hold. A named error removes the question of what went wrong. Strictness is subtraction of ambiguity, and the simplest working system is usually the strictest one available at that size.

So the two disciplines agree: **grow the system, and let every size of it be strict.** Simple describes the system's extent; strict describes its edges. A tree can have both from the first day, and this one aims to.

## Where it meets the disciplines already seated

- **SLC** - simple, lovable, complete - is Gall's Law wearing product clothes. It asks for a system whole at its current size, which is exactly the thing that can be grown from.
- **The finishing edge** - ship one real thing before naming the next - keeps the growth *sequential*, which is the only way evolution has ever worked.
- **Lindy-first** chooses which simple system to grow: the one whose shape will still read true on the long return.
- **TAME's bound-everything** is how a simple system stays working while it grows. A bound names the size the system is honest at, so growth past it becomes a decision rather than a drift.
- **Two Rooms** keeps the growth truthful: a claim enters the checkable room once a witness binds it, so what "worked" means at each stage is a fact rather than a hope.

## Why it belongs on the rota

Because the pressure it resists arrives every single lap. The tempting move is always the whole design - the complete season, the full grid, the sixteen rounds named in advance. Four seated ladders announced a size and stopped short, which is the same law charging the same fee in a different currency.

A lap that has just re-read Gall builds the next working thing instead, and lets the shape arrive from underneath.

*May every layer here rest on one that was already green, and may the next reader find a system small enough to understand and whole enough to trust.*
