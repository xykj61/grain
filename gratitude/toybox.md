# Rob Landley -- toybox, the whole userland in one binary

**Source:** <https://landley.net/toybox/> - **Repository:** <https://github.com/landley/toybox> - **License:** **0BSD**, read from its own `LICENSE` - **Held as:** git submodule at `toybox/`, cloned whole and unmodified - **Living pin:** `b7ec52ac35` (`2026-06-22`) - **Fetched:** `20260905.104613` on Keaton's word

---

We are grateful for **toybox**, which the elder inventory of `20260617` placed first for a reason that has only grown truer: *"a toolkit that always works, in one static binary we trust."*

## The license, read rather than repeated

Its own `LICENSE` grants *"Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee"* -- and stops there. It asks for **no attribution and no notice: 0BSD**, the most permissive license anything in this room carries. The project's website says simply "BSD-licensed"; the file is the authority, and the file gives everything away.

## What it holds

**257 commands** in one multicall binary -- 70 under `posix/`, 94 under `other/`, 14 under `lsb/`, 12 under `net/`, and 52 under `pending/`, which its own README defines exactly: *"external submissions awaiting review and/or cleanup,"* defaulting to off. Sorting commands by maturity, directory by directory, is worth as much as the code in them.

Counted against this tree's own tool scripts, toybox answers **10,854 of our 11,971 invocation sites**. Of the 1,117 it leaves, **992 are `rg`**, which belongs to no coreutils family at all.

## Why it closes the map the other two opened

Read alone it is a static binary. Read third, after `uutils` and `dawk`, it completes a picture those two opened:

- **uutils** covers the coreutils family exactly, leaving `grep`, `sed`, `awk` and `find` to the projects that own them -- **3,129 of our sites**.
- **toybox holds all four**, `grep`/`sed`/`find` in `posix/` and `awk` in `pending/`.

So the two together answer nearly everything, from opposite directions: one a faithful GNU-compatible family under MIT, the other the whole userland under 0BSD in a single executable.

## And the answer to the question dawk taught us to ask

`dawk` is Unicode-native, and refusing our byte-level UTF-8 validator taught us the requirement we had never written down: **a re-grow must keep the C-locale byte view.**

toybox's awk is **4,579 lines** citing the POSIX 2024 specification, with its deviations listed in the first eight lines -- the first being *"Don't handle LANG, LC_ALL, etc."* Its `length` calls `utf8cnt`, counting codepoints unconditionally, exactly as dawk does.

Then the first line of `utf8cnt` reads `if (!len || FLAG(b)) return len;`, and the usage text says:

```
-b : count bytes, not characters (experimental)
```

**The requirement dawk taught us to name is a flag in the very next project we read.** Marked experimental, and labelled so -- the same courage as the `pending/` directory. Two implementations chose text as the default; one of them kept a door back to bytes and said where it is.

## What we owe

We hold it whole and unmodified. We read its `posix/` directory as a catalogue of what a base suite must offer, its `pending/` as a lesson in marking what is unfinished, and its awk as the nearest thing to a specification for the one command we most need and least want to write twice. When our own base suite is grown in Rye, the debt is paid the way this room always pays: in the open, and by saying so.

Thank you, Rob Landley, for giving it all away and for marking honestly what is not yet done.
