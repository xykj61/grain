# uutils -- the coreutils, rewritten in Rust

**Source:** <https://github.com/uutils/coreutils> - **License:** MIT - **Held as:** git submodule at `uutils-coreutils/`, cloned whole and unmodified - **Living pin:** `e0ff0ebf29` (`2026-09-05`) - **Fetched:** `20260905.100012` on Keaton's word

---

We are grateful for **uutils**, and for the discipline it chose rather than the language it chose.

It reimplements the GNU core utilities in Rust -- **109 of them** in its own `src/uu` -- and holds itself to a rare standard: *"Matching GNU's output (stdout and error code) exactly."* Its README puts the consequence in four words -- **"Differences with GNU are treated as bugs"** -- and publishes a chart of how many GNU tests it passes, so the claim is a measurement anyone can re-run.

That is the promise this tree makes to itself in a different room: a witness that says a thing is true, and a number beside it anyone can check.

## What it gives us, measured

Of the seventeen utilities our own guards lean on hardest, **uutils implements all seventeen**. Three of those sit outside POSIX entirely -- **`mktemp`** (dropped from the standard in 2008, and 353 sites here), **`readlink`**, and **`stat`** -- which is where a portable answer is hardest to find, since there is no standard to appeal to. Here they are in one place, under MIT, with a stated behavioural target.

Counted against our own tool scripts, uutils covers **5,380 invocation sites** and leaves **3,129** to other hands.

## What it does not cover, and why that is the useful half

`grep`, `sed`, `awk` and `find` live elsewhere, and **the boundary is exactly right**: `grep` and `find` belong to GNU findutils, while `sed` and `awk` are their own projects again. That boundary draws our map:

| | Sites here | Where the answer lives |
|---|---|---|
| the coreutils family | **5,380** | here, all of it, MIT |
| `grep`, `sed`, `awk`, `find` | **3,129** | four separate projects, each its own study |

So the re-grow is **two undertakings**, and this clone is what made the line visible. The text-processing tools -- the ones carrying whole languages inside them -- are the hard half; the coreutils half has a complete permissive reference sitting in one repository.

Read beside `dawk`, the pair says something neither says alone: **dawk showed us that a re-grow must keep the C-locale byte view; uutils shows us how much of the work has already been done by someone willing to be measured against a standard.**

## What we owe

We hold it whole and unmodified, as this room holds everything, and study it for **behaviour** rather than implementation -- what each command must *do* at its edges, which is the part a specification leaves to a test suite. When our own base suite is grown in Rye, the debt is paid the way this room always pays: in the open, and by saying so.

Thank you, uutils developers, for holding a rewrite to the original's exact output, and for publishing the number.
