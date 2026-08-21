# The First Hour

*From nothing to something you made work. One path, no branching, no choices to make. Everything else in this tree is a map you will want **after** this hour.*

**Language:** EN - **Style:** Radiant - **Voice:** Kyri
**Written:** `20260821.180613`
**Status:** Living - the beginner path
**You will need:** a Linux or macOS terminal with `git`, `curl`, and `tar`, and about an hour.

---

## What you are about to do

Six steps. At the end you will have built a compiler that built a shell, watched a proof run on your own machine, and written a small program of your own that refuses to lie to you.

Nothing here asks you to understand the whole tree. It asks you to make one thing work.

## 1. Clone

```sh
git clone https://github.com/grain-os/grain.git
cd grain
```

## 2. Fetch the toolchain

Grain compiles through a pinned **Zig 0.16.0**, kept at `vendor/zig-toolchain/` and deliberately not committed -- a 172 MB binary does not belong in a git history.

```sh
sh tools/fetch-toolchain.sh
```

That is plain `sh` on purpose: this is the second thing you run, and the tree's own shell does not exist yet -- it is a program that compiles through the toolchain you are fetching right now.

It downloads the official release for your platform, and then **refuses to extract a single byte unless the download matches a checksum pinned in this repository**. Not a checksum fetched from the download site beside the file, which would only catch a corrupted transfer -- one that lives in Grain's own signed commit history, so what you are trusting is the git log rather than the weather on a web server. If the bytes are wrong, nothing is unpacked and the tool says so.

You should see it end with:

```
verified=yes
installed=0.16.0
verdict=ok
```

Confirm it for yourself:

```sh
vendor/zig-toolchain/zig version
# 0.16.0
```

Run it twice if you like -- the second run notices the toolchain already stands and does nothing.

## 3. Build Rye, which builds itself

**Rye** is the bounded systems language everything here lowers to. Its compiler is written in Rye, so the very first build is a cold start -- a small script bridges the source and hands it to the toolchain, and from then on Rye compiles itself.

```sh
cd rye
./bootstrap.sh
cd ..
```

That is a language bootstrapping on your machine. It is worth a moment.

## 4. Build Rishi, the shell

**Rishi** is the faithful hand -- the shell that runs this tree. It is a Rye program, so Rye builds it:

```sh
mkdir -p rishi/bin
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
```

Say hello:

```sh
rishi/bin/rishi run rishi/tests/hello.rish
```

```
hello from Rishi, sibling of Rye!
the year is 2026
Rye
```

**That is the whole toolchain working**, from a Zig binary you verified to a program printing your first line.

## 5. Run a witness, and read what it says

A **witness** is this tree's word for a proof that runs on real hardware. Nothing here is called working because someone wrote that it works; it is called working because a witness said so, on metal, today. There are more than sixteen hundred of them -- the [README](../../README.md) carries the exact count, generated rather than typed, for the same reason this sentence does not.

Run one:

```sh
rishi/bin/rishi run tools/rish_exit_codes_witness.rish
```

```
GREEN: Rishi exit vocabulary -- pre-bound names and exit statement.
```

That green line is a fact a computer spoke first. Read it as one: *the shell's exit vocabulary behaves as documented, checked a second ago, on this machine.* If it had been false, the line would not have printed -- a witness that cannot prove its claim refuses rather than warns.

## 6. Write five lines that refuse to lie

Now your own. Put this in a file called `first.rish`:

```
let rooms = run ["sh" "-c" "ls -d */ | wc -l"]
assert rooms.ok else "the listing must succeed before its number is trusted"
let count = trim rooms.out
say "this tree has ${count} rooms at its root"
assert count != "0" else "a tree with no rooms is not a tree"
```

Run it:

```sh
rishi/bin/rishi run first.rish
```

```
this tree has 71 rooms at its root
```

**Your number may differ, and that is worth understanding on your first day.** A fresh clone holds 71 rooms; a working tree holds more, because `.gitignore` keeps personal files, build output, and the public-seed projection out of git while they still sit on disk. The page said **78** until the reader's walk was actually taken on a clean clone (`20260821.192600`) -- a hand-typed count measured in one tree and promised to every other. Your program is not wrong if it says something else; it is reading *your* tree, which is the whole point of it reading rather than reciting.

Five lines, and **two of them are assertions**. That ratio is the whole discipline in miniature: the program checks that the listing actually succeeded *before* it trusts the number, and checks the number is sane before it reports it. Delete either assert and the program still prints something -- it just stops being able to tell you when it is wrong.

That is what this tree means by bounded, asserted, and proven. You have now written it.

## The longer welcome

This page is the **path** -- six commands, no branching. [`../../manual/20260810-065116_your-first-hour-with-grain.md`](../../manual/20260810-065116_your-first-hour-with-grain.md) is the **welcome**: two hundred lines that say what Grain is, what custody-first means, and why a witness is the unit of truth here. Read whichever suits the morning you are having; they now point at each other rather than each pretending to be the only first hour.

## Where to go next

- **[`../../SOURCE.md`](../../SOURCE.md)** -- the full first day: keys, the enclosure, the signed forge home.
- **[`../../rishi/README.md`](../../rishi/README.md)** -- everything Rishi can do, which is more than five lines suggest.
- **[`../../ORGANIZING.md`](../../ORGANIZING.md)** -- where each kind of work lives, once you want to add some.
- **[`../../foundations/20260821-175723_the-words-a-round-uses.md`](../../foundations/20260821-175723_the-words-a-round-uses.md)** -- the ten words you will meet on your first day here, defined plainly.
- **[`../../foundations/README.md`](../../foundations/README.md)** -- the why beneath all of it, when you want that instead.

---

*May your first hour end with something that works, may the green line mean exactly what it says, and may you find this tree easier to enter than it looks from outside.*
