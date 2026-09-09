# The machine you can write down

**Language:** EN - **Style:** [New Gauge Radiant](../context/RADIANT_STYLE.md) -- measured, and affirmative throughout - **Voice:** Kyri
**Stamp:** `20260909.004934` - **Status:** Living - **Room:** vision
**Rule:** [`.claude/rules/declared-host-config.md`](../.claude/rules/declared-host-config.md) - **Twin:** [`.cursor/rules/declared-host-config.mdc`](../.cursor/rules/declared-host-config.mdc)
**Kin:** the ordering this implies is argued in [`active-designing/20260909-005121_the-pier-a-newcomer-stands-up.md`](../active-designing/20260909-005121_the-pier-a-newcomer-stands-up.md);
the steps are walked in [`SOURCE.md`](../SOURCE.md) and [`docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md); home is [`README.md`](../README.md).

## The idea, in one line

**A computer you can describe in a file is a computer you can have again.**

## Where this comes from, and what we made our own

The world calls this **declarative configuration**, and NixOS is where we met it: a whole operating
system expressed as text, built from that text, and rebuilt from it whenever you ask. The idea is
older than the tool. A recipe outlives the meal; a score outlives the performance; a seed carries
the shape of a plant into a season still ahead of it.

What this tree takes from that is a direction rather than a technology. **The description is the
original, and the running machine is the copy.** Nix supplies the mechanism today, and the
direction would hold on any system that lets a machine be built from a written account of itself.

## Why the direction is the whole of it

A machine configured by hand is a machine exactly one person can rebuild, and only while they still
remember. Every choice lives in a memory: which package, which flag, which afternoon.

A machine built from a file is one anybody can stand up again -- a colleague, a stranger following
a guide, or you in a year, on new hardware, starting fresh. The file says everything the
machine is, so having the file is having the machine.

## The order, and what it buys

**Write the description, then copy it out.** The description is reviewed, committed, and shared;
the machine receives it.

Run it the other way -- change the machine, then update the description -- and each reconciliation
asks *which side is right, line by line*. A person settles that question, at the hour they look.

**Measured the night this was written:** a config bump ran the other way, and the reconciliation
found the tree carrying **eleven lines that lived there alone** -- a decision about a package pin,
recorded in the tree, seated on a word, and standing there alone. Copying the machine over the tree
would have spent that decision. Written in the seated order, the answer is mechanical: a copy either matches
the description or trails it, and `diff` says which in one line.

## What it asks of a description

**Everything the machine is, and only that.** Packages, services, disks and pins
belong in the file. Keys, tokens and one person's hardware stay on the machine, with the file
carrying a placeholder where each belongs. A description that names a person describes one machine;
a description that names a shape describes every machine anyone builds from it.

## Why we ship ours

The public seed carries this tree's own host description, so the pier a newcomer stands up is the
pier this work runs on. **A guide describing a machine held private asks for trust; shipping the
file asks only that you read it.** Somebody following it reaches a host that already works, and reads exactly
why it works while they wait for it to build.

## The horizon this holds until

This tree borrows a host today and builds toward being one. When **Mantra**, **Caravan** and
**Rishi** run fully on **Microkit seL4 for RISC-V**, the question of who writes the machine's
description is answered by the tree being the machine. Until that day the borrowed host is
described here and copied there, so the whole arc keeps one property from beginning to end.

**And the property is the same one at every scale.** A file you can rebuild a machine from, a
witness you can rebuild a claim from, a ledger you can rebuild a decision from. Each says: the
account is the original, and what runs is a copy of it.

May every machine this work touches be one somebody else can have again.
