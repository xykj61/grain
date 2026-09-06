# The First Hour

*From nothing to something you made work. One path, straight through. Everything else in this tree
is a map you will want **after** this hour.*

**Language:** EN - **Style:** Gauge, Door setting - **Voice:** Kyri
**Written:** `20260821.180613` - **Last updated:** `20260903.215224` (NixOS cloud path -- musl `-lc`, `RYE_ZIG` from clone root)
**Status:** Living - the beginner path
**You will need:** a Linux or macOS terminal with `git`, `curl`, and `tar`, and about an hour.
**Where this sits:** home is [`../../README.md`](../../README.md) - the whole path from nothing to a
signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

> Three names appear in this hour and each has a page for someone meeting it for the first time:
> [Mantra](../../foundations/20260825-211056_what-mantra-is.md) hands out names that stay true,
> [Brix infuse](../../foundations/20260823-222019_what-brix-infuse-is.md) declares what a system is made of,
> and [Tablecloth](../../foundations/20260823-222020_what-tablecloth-is.md) holds a thing by its content.

> Still choosing the three things this hour rests on -- a language model, a source forge, and somewhere to keep bytes? [`SHOPPING.md`](SHOPPING.md) is how to shop for them, ordered safety, performance, joy.

---

## What you are about to do

Six steps. At the end you will have built a compiler that built a shell, watched a proof run on
your own machine, and written a small program that checks its own answers before it trusts them.

This hour asks one thing of you: make one thing work. The whole tree can wait.

## 1. Clone

```sh
git clone https://github.com/grain-os/grain.git
cd grain
```

## 2. Fetch the toolchain

Grain compiles through a pinned **Zig 0.16.0**, kept at `vendor/zig-toolchain/` and deliberately
left out of git -- a 172 MB binary belongs on disk rather than in a history everyone clones.

```sh
sh tools/f/fetch-toolchain.sh
```

That is plain `sh` on purpose. This is the second thing you run, and the tree's own shell arrives a
few steps from now -- it is a program that compiles through the toolchain you are fetching right
this moment.

The script downloads the official release for your platform and extracts it once the bytes match a
checksum pinned in this repository. That pin lives in Grain's own signed commit history rather than
beside the file on a download server, so what you are trusting is the git log. When the bytes match
it unpacks; when they differ it stops and tells you plainly.

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

Run it twice if you like -- the second run notices the toolchain already stands and rests.

## 3. Build Rye, which builds itself

**Rye** is the bounded systems language everything here lowers to. Its compiler is written in Rye,
so the very first build is a cold start: a small script bridges the source and hands it to the
toolchain, and from then on Rye compiles itself.

```sh
cd rye
./bootstrap.sh
cd ..
```

That is a language bootstrapping on your machine. It is worth a moment.

**On NixOS**, `./bootstrap.sh` stops: Zig 0.16 wants `-lc` for `getpid`, and this host has no FHS libc. From `rye/`, with Zig at the **clone** vendor (not `rye/vendor`):

```sh
cd rye
unset RYE_ZIG
zig="$PWD/../vendor/zig-toolchain/zig"
cp src/main.rye src/main.rye.zig
mkdir -p bin
"$zig" build-exe src/main.rye.zig -femit-bin=bin/rye --zig-lib-dir lib -target x86_64-linux-musl -lc
rm -f src/main.rye.zig
./bin/rye version
cd ..
```

Witnessed `20260903` on NixOS 26.05: `rye 20260827.023156`. `file(1)` is not on the host; skip it. Do not `export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"` while you are still inside `rye/` -- that path does not exist.

## 4. Build Rishi, the shell

**Rishi** is the faithful hand -- the shell that runs this tree. It is a Rye program, so Rye builds
it:

```sh
mkdir -p rishi/bin
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
```

**On NixOS**, stay at the clone root and pass musl again:

```sh
mkdir -p rishi/bin
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
./rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi -target x86_64-linux-musl -lc
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

**That is the whole toolchain working**, from a Zig binary you verified to a program printing your
first line.

## 5. Run a witness, and read what it says

A **witness** is this tree's word for a proof that runs on real hardware. Everything here earns the
word *working* the same way: a witness said so, on metal, today. There are more than sixteen
hundred of them, and the [README](../../README.md) carries the exact count, generated rather than
typed, for the same reason this sentence keeps it vague.

Run one:

```sh
rishi/bin/rishi run tools/r/rish_exit_codes_witness.rish
```

```
GREEN: Rishi exit vocabulary -- pre-bound names and exit statement.
```

That green line is a fact a computer spoke first. Read it as one: *the shell's exit vocabulary
behaves as documented, checked a second ago, on this machine.* The line prints only where the claim
holds, so a witness stays quiet about anything it could prove otherwise.

## 6. Write five lines that check themselves

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
rishi/bin/rishi first.rish        # or the short way -- the same thing
```

```
this tree has 72 rooms at its root
```

**Your number will differ, and that is worth understanding on your first day.** A working tree
holds more rooms than a fresh clone, because `.gitignore` keeps personal files, build output, and
the public-seed projection on disk while leaving them out of git. Your program stays correct when
it says something else; it is reading *your* tree, which is the whole point of it reading rather
than reciting.

This one line has already been corrected twice, and the story is worth your first day. It promised
**78** until a reader's walk on a clean clone found **71** -- a count measured in one tree and
promised to every other. An hour later, shipping a room that walk had found still to be written
made it **72**. A generated number stays true as the tree moves, where a typed one holds only
until the next commit -- which is exactly why the front-door [README](../../README.md) generates
its four numbers, and why this page tells you what the output *means* rather than what it will say.

Five lines, and **two of them are assertions**. That ratio is the whole discipline in miniature:
the program confirms the listing succeeded *before* it trusts the number, and confirms the number
is sane before it reports it. Keep both and the program can always tell you whether its answer
stands; with either one gone it still prints, and quietly.

That is what this tree means by bounded, asserted, and proven. You have now written it.

## The longer welcome

This page is the **path** -- six commands, one line through.
[`../../manual/20260810-065116_your-first-hour-with-grain.md`](../../manual/20260810-065116_your-first-hour-with-grain.md)
is the **welcome**: two hundred lines saying what Grain is, what custody-first means, and why a
witness is the unit of truth here. Read whichever suits the morning you are having; they point at
each other, so either one leads to the other.

## Where to go next

- **[`../../SOURCE.md`](../../SOURCE.md)** -- the full first day: keys, the enclosure, the signed
  forge home.
- **[`../../rishi/README.md`](../../rishi/README.md)** -- everything Rishi can do, which is a good
  deal more than five lines suggest.
- **[`../../ORGANIZING.md`](../../ORGANIZING.md)** -- where each kind of work lives, once you want
  to add some.
- **[`../../foundations/20260821-175723_the-words-a-round-uses.md`](../../foundations/20260821-175723_the-words-a-round-uses.md)**
  -- the ten words you will meet on your first day here, defined plainly.
- **[`../../foundations/README.md`](../../foundations/README.md)** -- the why beneath all of it,
  when you want that instead.

---

*May your first hour end with something that works, may the green line mean exactly what it says,
and may you find this tree easier to enter than it looks from outside.*
