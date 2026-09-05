# Andrew Gallant -- ripgrep, the tool we lean on hardest

**Source:** <https://github.com/BurntSushi/ripgrep> - **License:** **Unlicense OR MIT**, dual, read from its own `COPYING` - **Held as:** git submodule at `ripgrep/`, cloned whole and unmodified - **Living pin:** `3fce3b5bb0` (`2026-08-04`) - **Fetched:** `20260905.130819` on Keaton's word

---

We are grateful for **ripgrep**, and it came last in the fetch order for the best reason: we already had it. What a study owed it was never *can we run a search* but *what have we actually been asking it for* -- and measuring that turned out to say more about us than about it.

## The most permissive terms of all five

Its `COPYING` opens: *"This project is dual-licensed under the Unlicense and MIT licenses. You may use this code under the terms of either license."* The **Unlicense** is a dedication to the public domain, so a reader may take either -- attribution if they want the MIT form, nothing at all if they take the other. Among the five studied this month, that is the freest offer made.

## What we actually ask it for

ripgrep stands at **1,376 invocation sites** in this tree's tool scripts -- more than any other borrowed tool, by a distance. Sorted by flag, the picture is unexpected:

| what we ask | sites |
|---|---|
| `rg -q` and `rg -qi` -- **exit code only, no output** | **1,286** |
| `rg -n`, `-c`, `-o`, `-F` -- output of any kind | ~90 |

**Ninety-three percent of our use is a predicate.** We are almost never searching; we are asking *does this pattern exist in this tree*, and reading the exit code. The famous parts -- the parallel walk, the fast printer -- are largely beside what we do with it. The crate we lean on is `ignore` at **8,902 lines**, the gitignore-respecting directory walk, because what we want is *the tracked set, quickly*.

That reframes the re-grow question its own way. What a Grain base suite would need here is not "a grep" but **a bounded existence test over the tracked set** -- and `git grep -q` already is one, answering the same question on this tree in about a second where ripgrep answers in under one.

## Why the crates are the lesson

ripgrep is **50,356 lines of Rust** split into eleven crates, and the split is the design rather than tidiness: `ignore` walks, `globset` matches paths, `matcher` and `regex` and `pcre2` decide what a pattern is, `searcher` reads, `printer` writes, `cli` and `core` assemble. Each is separately usable, and several are used by other projects entirely.

For a TAME re-grow that decomposition matters more than the speed. **A tool split at its real seams can be re-grown one seam at a time** -- and a project that publishes its middle as libraries has already found where those seams are, which is the expensive half of the work.

## The live lesson standing beside it

While this study was being written, a plain `grep` on this pier refused a regular expression with *"exceeds complexity limits."* The reason is that `grep` here is **ugrep 7.8.4**, not GNU grep -- a different implementation wearing the same name, with its own limits.

That is the borrowed-tool tier from our own utility study, met in the wild on the same afternoon: **a familiar name is not a familiar behaviour**, and 1,376 sites of `rg` beside a `grep` that is not the `grep` anyone assumed is the reason a dependency deserves a tier rather than an assumption.

## What we owe

We hold it whole and unmodified. We study `ignore` as the answer to *what is the tracked set*, the crate split as a map of where a search tool's real seams lie, and the whole of it as the measurement that told us we had been calling a search tool to ask a yes-or-no question.

Thank you, Andrew Gallant, for the fastest answer to a question we mostly did not need to ask, and for giving it away twice over.
