# Demos -- four things you can run in a minute

*Each command below was run before it was written down, and the output is what it printed.*

**Language:** EN - **Style:** Gauge, Door setting - **Voice:** Kyri
**Written:** `20260821.190149` - **Last updated:** `20260823.061415` (Gauge pass, and all four outputs re-run; two had drifted)
**Status:** Living - **Kind:** crushed demonstrations
**Before you start:** the [first hour](../tutorials/the-first-hour.md) leaves you with a built `rishi`. That is all these want.

---

## 1. Find a file that moved

When a room grows past what a browser can list, this tree folds it into `date/YYYYMMDD/` -- and
every reference already written at the old path keeps working, because a stale reference is
**resolved** rather than rewritten.

```sh
rishi/bin/rishi run tools/dated_path_resolve.rish session-logs/20260710-000045_one-clock-resins-plainly.md
```

```
verdict=recovered-by-fold-rule
home=session-logs/date/20260710/20260710-000045_one-clock-resins-plainly.md
```

**`recovered-by-fold-rule` is the interesting word.** The new home was *computed* from the stamp
inside the filename, using only the name itself -- no index, no search. That is why the day repeats
in `date/20260710/20260710-000045_...`: the repetition makes the move a pure function anyone can
invert by hand.

## 2. Hash something with the tree's own Keccak

```sh
printf 'Grain' > /tmp/g.bin
sh tools/fixtures/sha3.sh 256 /tmp/g.bin
```

```
caf0cf084d82e6a8a17a6703e75ca23bdd3385e3a32d6bff0fc0ef76da426ed1
```

That digest comes from `crypto/sha3.rye` -- Keccak-f[1600] authored in Rye, studied clean-room from
FIPS 202, standing on its own with the system's crypto libraries left out of it entirely. Check it
against the published standard yourself:

```sh
rishi/bin/rishi run tools/sha3_file_witness.rish
```

It hashes the empty string and `abc` at both widths and compares against the FIPS 202 known
answers, which anyone can look up and which stay fixed wherever this tree goes.

## 3. Ask whether any room has outgrown a reader

```sh
sh tools/fixtures/room_bound_scan.sh
```

```
bound=256
room=session-logs flat=148 verdict=under roster=enforce
enforced_over=0
```

Rooms are **discovered** rather than listed, so one made tomorrow appears here on its own. Six are
enforced, and crossing 256 flat files books a red.

**That `flat=` number moves every day, and this page has watched it.** It read **59** when this
demo was written on `20260821` and reads **148** two days later, because this tree writes roughly a
hundred logs a day. The bound is the interesting part rather than the count: 256 sits well below
the 1,000-entry listing cap a browser gives up at, so a room reaches its fold with room to spare.

## 4. Read the health of the day

```sh
sh tools/fixtures/fascia_metric_v0.sh
```

```
clutter=59
fascia=41
```

**Fascia** is the connective tissue -- whether a reader can follow any thread home. Forty-one of a
hundred, and the number is honest: it is measured, it has room to climb, and it sits on the front
door where it stays in view. It read **45** on `20260821` and **41** today, which is the meter
telling the truth about a tree that grew faster than its connective tissue did.

---

## What every one of these has in common

Every number here was read from the tree rather than typed by a person. Each command went and
looked, then said what it found -- which is the only kind of claim this tree makes about itself.
Two of the four outputs on this page had drifted by the time it was next read, and re-running them
is how the page stays true.

*May a minute here show you more than a page of description could.*
