# Brix Infuse -- Declaring What a System Is Made Of

**Language:** EN
**Stamp:** `20260823.222019`
**Style:** Gauge, Door setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Registers:** Gauge - Civic - TAME
**Voice:** Kyri
**Status:** Living -- a foundation, written for a complete beginner
**Kin:** [`../README.md`](../README.md) - [Mantra](20260823-222018_what-mantra-is.md) - [Brix infuse](20260823-222019_what-brix-infuse-is.md) - [Tablecloth](20260823-222020_what-tablecloth-is.md)

---

**Brix is the language that says what a system is made of. Infuse is the act of running that
declaration until it holds.**

## Two ideas, kept apart

**A declaration** says how things should be. *This system has these parts, in these versions, with
these settings.* It describes an intended state, leaving the present moment to the other half.

**An infusion** takes a declaration and makes the world match it. It reads what is actually there,
compares, and moves only what differs.

Keeping the two apart is the whole point. A declaration you can read, check, review, and store is a
different kind of object from a script whose only mode is running while you watch.

## What a Brix file looks like

One field per line, a first word naming the field and the rest its value, `#` for comments, no
quotes and no braces. That is deliberate: a person reads it with no manual, and a program parses it
with no grammar.

You have already seen one if you have read `context/document-mirrors.brix`, which declares that a
document lives in more than one place and lets a guard prove the copies match.

## The chemical formula

```
declaration + world  ->  infusion  ->  world'          (world' matches the declaration)
infusion(world')  ->  world'                            (idempotent: running it again moves nothing)
```

**Idempotent** is the property worth learning here. It means running the same infusion twice does
the same thing as running it once. That is what makes an infusion safe to run whenever you are
unsure whether it already ran -- which, in practice, is most of the time.

## Why declaration beats instruction

**A declaration can be checked before it runs.** You read it, diff it against last week's, and have
someone review it, with the system itself left entirely alone.

**A declaration says what, so the how can improve.** The same file works when the method underneath
gets better.

**A declaration is a record.** Six months on it tells you what the system was meant to be, which
outlasts a log of commands somebody once typed.

## Where to read next

The naming layer underneath is [Mantra](20260823-222018_what-mantra-is.md); the store is
[Tablecloth](20260823-222020_what-tablecloth-is.md). The module itself is
[`../brix/README.md`](../brix/README.md).
