# triallax -- dawk, an awk written in Zig

**Source:** <https://codeberg.org/triallax/dawk> - **License:** MIT - **Held as:** git submodule at `dawk/`, cloned whole and unmodified - **Living pin:** `bc87acca83` (`2026-08-01`) - **Fetched:** `20260905.080810` on Keaton's word

---

We are grateful for **dawk**, and for a reason its author did not set out to give us.

It is an implementation of POSIX awk written in Zig, by one person, opened with a warning we admire for its honesty: *here be dragons, may eat both your homework and your dog.* Its stated goals put learning and enjoyment first, and standards compliance and speed after -- *"I started this project to learn a new language and to actually implement a language for once."* That ordering is the whole reason it was worth reading. A program written to be understood teaches more than a program written to win.

## What it gave us, measured rather than assumed

**8,293 lines of Zig across 42 files** in its own `src/`, and it **builds with the very compiler we already vendor** -- Zig `0.16.0`, one `zig build`, no second toolchain between reading a program and running it. That mattered more than any feature: our own Rye compiles through Zig, so a Zig awk is the first implementation of a core utility we could read in the language we build in.

A public summary described the repository as 83% C++. Its own bytes say otherwise: the C++ is `simdutf`, a vendored dependency, and the project's source is Zig almost entirely. We record that because we nearly repeated the summary instead of the source, and the difference between those two habits is the whole of this room.

## And what it taught us by refusing

We ran our own `tools/fixtures/u/utf8_valid.awk` through it -- a validator whose entire job is to find bytes that are *not* valid UTF-8 -- and dawk answered:

```
dawk: encountered invalid UTF-8
```

It is **Unicode-native**, and it is right to be. `length` of a four-letter word whose last character is two bytes reads **4** under dawk and **5** under gawk in the C locale, because one counts characters and the other counts bytes. POSIX awk in the C locale is byte-oriented; dawk chose text, deliberately and consistently.

That answered a question we had been circling for a day, and answered it as a clean **no** -- which is worth as much as a yes and arrives far cheaper. Our guards do not merely want *an awk*; they want **an awk that keeps the C-locale byte view**, because a tool that inspects bytes cannot be built on a reader that insists its input is already text. The first program we would have needed to port is precisely the one that cannot run.

That is not a fault in dawk. It is a requirement in us that we had never written down, and it took someone else's honest, well-made program to show it to us.

## What we owe

We hold it whole and unmodified, as this room holds everything. We study its structure -- a hand-written parser, a resolver, a compiler and a VM, each in a file small enough to read in a sitting -- as the nearest map anyone has drawn of the country between a POSIX utility and a Zig program. When our own base suite is grown in Rye, the debt is paid the way this room always pays: by having learned in the open, and by saying so.

Thank you, triallax, for building a thing to understand it, and for leaving it where we could read it.
