# The pier a newcomer stands up

**Language:** EN - **Style:** [New Gauge Radiant](../context/RADIANT_STYLE.md) -- measured, and affirmative throughout - **Voice:** Kyri
**Stamp:** `20260909.005121` - **Status:** Living - **Room:** mixed -- the procedure is checkable, the ordering is a proposal
**Above it:** [`foundations/20260909-004934_the-machine-you-can-write-down.md`](../foundations/20260909-004934_the-machine-you-can-write-down.md) -- why a machine is written down
**Below it:** [`SOURCE.md`](../SOURCE.md) and [`docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) -- the steps themselves
**Rule:** [`.claude/rules/declared-host-config.md`](../.claude/rules/declared-host-config.md) - **Home:** [`README.md`](../README.md)

## What this page is for

The foundation above says **why** a machine should be written down. The guides below say **which
keys to press**. This page holds the layer between: **which host, in which order, and why that
order rather than another.** It is the page that moves when the answer moves, so the foundation
keeps its principle and the guides keep their steps.

## Four names this page uses plainly

The [silo technique](../context/SILO_TECHNIQUE.md) asks that a borrowed idea arrive in our own
words. **Four names are exceptions, granted `20260909`, and each for the same reason:** a reader types
them exactly, where an idea would be restated.

**NixOS**, **Vultr**, **Claude Code** and **Codex** are dependencies with spellings. A guide that
renamed them would hand a reader a beautiful sentence beside a command that lands elsewhere. The
principle each carries -- a declared host, a pier you hire, an agent at a bench -- is siloed
everywhere it is discussed; the *name* stands wherever it is typed.

## The order, and the reason for it

**A cloud pier comes first, ahead of the laptop.** Every later step assumes a host described by
a file, and a hired machine reaches that state with the fewest choices along the way.

**Vultr, Ubuntu 22.04, eight or twelve cores.** Ubuntu is a springboard rather than a destination:
it is chosen because the panel offers it and it answers SSH the moment the machine boots, and it is
left in the very next step. Eight cores and twelve cores are both recommended, and the difference
shows later, in how many agent laps run beside each other.

**Then kexec, rather than convert-in-place.** The `nixos-kexec-installer` image is fetched, unpacked
and run; the SSH session becomes a ghost; the machine comes back as a NixOS installer in RAM,
holding the disk exactly as it was beneath it.

**Why this road, measured against the other.** `nixos-infect` converts a running system in place,
and on `20260903` that left IPv4 silent on this SKU. kexec keeps the springboard whole until the
new system is already running, so a machine that stays quiet is one you reboot
into Ubuntu and try again. Recorded in
[`session-logs/date/20260903/20260903-222043_molt-names-kexec-not-infect.kyri`](../session-logs/date/20260903/20260903-222043_molt-names-kexec-not-infect.kyri).

**Then the declared config, from this tree.** `nixos/configuration.nix` ships in the public seed, so
the newcomer's first NixOS host is described by the same file this work runs on. They copy it out
and rebuild, which is the same motion every later change takes.

## Why the guide ends where it does

A first hour that ends with **a declared host the reader can rebuild** has delivered the whole
idea, and everything after it is application. That is the seam this ordering aims at: the reader
holds a machine, a file describing it, and the habit of changing the file first.

## What would move this page

**A provider whose panel offers NixOS directly** would retire the springboard and the kexec step
together, leaving a shorter first hour. **A cheaper or nearer pier** would move the recommendation.
And **Microkit seL4 on RISC-V**, once Mantra, Caravan and Rishi run there, retires the whole
question: the tree becomes the system it currently borrows.

## The falsifier

If a reader following this order reaches a running NixOS pier more slowly than one following the
provider's own installer, this page is where the better ordering gets recorded.
