# suckless -- sbase and ubase, short enough to hold in the eye

**Source:** <https://git.suckless.org/sbase> - <https://git.suckless.org/ubase>
**License:** **MIT** (sbase) - **MIT/X Consortium** (ubase), both read from their own `LICENSE`
**Held as:** git submodules at `sbase/` and `ubase/`, cloned whole and unmodified
**Living pins:** `c546c3a572` (`2026-05-22`) - `e8249b49ca` (`2025-12-17`) - **Fetched:** `20260905.112846` on Keaton's word

---

We are grateful for **sbase** and **ubase**, and for a quality the other studies could not show us, because it only appears when you hold three implementations of one command side by side.

The elder inventory of `20260617` called sbase *"our single best starting point for coreutils in Rye"* and described it as *"each command short enough to hold in the eye."* That was a claim. Here it is as a number: **98 commands, 18,869 lines of C, and a median command of 91 lines.**

## What the smallness is made of

Their own README says it plainly -- sbase holds *"unix tools that are inherently portable across UNIX and UNIX-like systems,"* and ubase is its Linux-specific complement, *"together intended to form a base."* Portability is achieved by declining to do the things that are not portable, and the size follows from that decision rather than from cleverness.

`cat.c` is **52 lines** and accepts one flag, `-u`. Read beside its siblings, the reason is visible:

| `cat` | lines | flags |
|---|---|---|
| **sbase** (C) | **52** | 1 |
| **toybox** (C) | 68 | 4 |
| **uutils** (Rust) | 796 | 11, plus a `platform/` directory with a Windows port |

Nothing there is waste. Each project is paying for a different promise: sbase for portability by subtraction, toybox for a whole userland in one binary, uutils for exact GNU compatibility on five operating systems. **The prices differ because the promises do**, and seeing all three at once is what makes each price legible.

The pattern holds across the family, measured on the same commands:

| | sbase | toybox | uutils |
|---|---|---|---|
| `grep` | 266 | 548 | -- |
| `sort` | 438 | 400 | 5,687 |
| `tr` | 318 | 239 | 1,332 |
| `cut` | 215 | 247 | 1,762 |
| `wc` | 122 | 129 | 1,386 |

## Why this one is the model for a re-grow

A specification tells you what a command must accept. **It cannot tell you what a command must be.** sbase answers the second question in a form a person can read in a sitting -- and reading is the whole method here, since we re-grow in our own hand rather than porting.

For a base suite grown in Rye under TAME, the fit is close in a way the size only hints at. TAME asks for **bounded everything, asserted invariants, short functions named with a verb**. A 91-line median command written to be portable by subtraction is already most of the way to a module that names its bounds, because it has so few places left to hide one.

**And sbase has no `awk`** -- which, after the last three studies, reads as agreement rather than absence. `awk` carries a whole language, `sed` at 1,738 lines is the largest thing sbase attempts, and even here the text-processing tools are the hard half.

## What we owe

We hold both whole and unmodified. We read sbase as the shape a small correct command takes, ubase as the Linux-facing half a base suite eventually needs, and both as the answer to a question no standard document contains: *how little can this be and still be true?*

Thank you, Connor Lane Smith, Dimitris Papastamos, Laslo Hunhold, Hiltjo Posthuma, and the suckless community, for showing what stays when everything unnecessary is removed.
