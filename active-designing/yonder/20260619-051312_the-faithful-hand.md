# The Faithful Hand — the Design of Rishi

> **Yondered `20260702.185912`** — early brief, consumed into the living records; the stamp above endures as the moment it was written. Index: `../README.md`.

*Rishi is the shell of the family: the hand a person works with, and the seer who hears them and speaks faithfully to the machine. This brief designs what Rishi is meant to be: the shape it grows toward. The way we grow it is `996`'s method. One promise orders the rest: a value at the hand is the same value in the program and on the wire, so the shell adds reach without ever opening a seam.*

**Language:** EN
**Version:** `20260619.051312` (Rye chronological stamp)
**Last updated:** 2026-06-30
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, then the joy of the craft
**Status:** Active Design — **Reviewed and kept** (`2026-06-30`).

---

## What Rishi Is For

A shell is where a person meets the machine most directly: a keystroke becomes an act, a line becomes a small program, a saved file becomes a tool used daily. Rishi's name holds its purpose — the seer who hears the human truly and speaks faithfully onward. Its whole work is faithful translation: of intent into action, of a value into the same value, of a fact into a check the machine can keep.

That faithfulness is the design. A shell that quietly reshapes what you meant, or flattens what you held, or acts in an order you did not ask for, has broken faith in a place a person cannot easily see. Rishi means to keep faith in each of these, and the rest of this brief is what keeping it asks.

## The Unbroken Seam

Rishi's values are Rye's values (`990`). A list, a record, a string, a truth at the Rishi prompt are the very same things they are inside a Rye program — one value model, shared (`995`). This is the deepest decision in the shell, and the one most often gotten wrong: when a value passes from a program into the shell and onward, it stays whole — never flattened into a flat line of text and reparsed. The seam between the language and the hand never opens, so nothing leaks through it.

The reward is reach without loss. A value computed deep in a program can be carried to the hand, set beside another, gated, and sent to the network — sealed and named (`993`) — and arrive as the very value it began as. The shell becomes a place values *flow through*, rather than a place they are torn down and rebuilt at every step.

## Terse for the Hand, Typed for Safety

A shell holds two duties that pull against each other, and Rishi honors both. It must be **terse**, because a person types it live and a long incantation is a cost paid every day. And it must be **safe**, because that same live line can delete, send, or overwrite. We decline to trade one for the other: brevity that costs safety is a poor bargain, and safety that costs all brevity is a shell no one will use.

The resolution is that the types do the guarding quietly, so the surface can stay short. A value carries its own kind; an operation that cannot make sense is refused plainly rather than half-done; the common path reads briefly because the safety lives underneath it rather than in front of it.

## The Gate Is Native

In Rishi an assertion is not a debugging aid; it is a way of speaking. `assert` makes a fact a **gate** — when it holds, the script flows on; when it fails, the script stops, says plainly why, and reports the failure outward so another program can trust the verdict. A Rishi script can therefore check its own truth as it runs, which is exactly what a script that guards real work must do.

This is no accident of features. The first whole program Rishi is built to run is the parity gate itself (`996`) — the program that proves Rye's own strengthening kept faith. A shell whose first and most important task is to assert a truth is a shell that treats the gate as native, never bolted on.

## Where Text Becomes a Value

Some input arrives as raw text — a keystroke, a file, a message off the wire — and text from outside is not yet trusted. Rishi draws a bright line at that boundary: untrusted text becomes a trusted value only by passing a **shape-cast**, a validation against the form the value must have, refused at the edge when it does not fit (`992`). What is shorter than its form, or larger than its bound, or simply malformed, does not cross.

Holding this line is what lets everything upstream stay simple. Past the cast, a value is known to be well-formed, so the rest of a script need not defend against shapes that cannot occur. The check happens once, at the door, and the room behind it stays clean.

## One Continuum: Keystroke, Script, Tool

Rishi means to be one language across three sizes, with no cliff between them. A single line typed at the prompt, a short script saved to a file, and a daily tool that composes many smaller ones are the same language seen at three magnifications. What a person learns typing one line carries unchanged into the script, and from the script into the tool. We refuse the common split where the interactive shell and the scripting language quietly disagree, because that split makes a person learn the machine twice.

## Honest About Effects

A shell acts on the world — it runs processes, touches files, reaches the network — and Rishi is honest about it. An effect is named for what it does; its order is the order written; and the result of an act, such as running a process, is itself a **structured value** — its output and its outcome carried together — rather than a smear of text a later line must guess at. Effects stay in the open, never hidden under convenience. A person should be able to read a Rishi script and know what it will do to the world, and in what sequence, before it does it.

## Grown on Rye

Rishi rests on Rye the way Rye rests on its own foundation: implemented in it, sharing its value model, owned by path (`996`). It wears a thin costume first and grows one proven feature at a time — comparison, the gate, lists, records, and onward to running processes and shaping pipelines — each stamped, each tested, nothing taken away once given. The parity gate is its first specification: we build exactly enough shell to speak that one truth, and then a little more, by degrees.

---

*May Rishi hear us truly and speak without distortion. May a value at the hand be the same value all the way down, may every fact it asserts be one it can keep, and may a person always be able to read what it will do before it does it — terse in the hand, and faithful underneath.*
