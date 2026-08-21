# Demos -- four things you can run in a minute

*Each command below was run before it was written down, and the output is what it printed.*

**Language:** EN - **Style:** Radiant - **Voice:** Kyri
**Written:** `20260821.190149` - **Status:** Living - **Kind:** crushed demonstrations
**Before you start:** the [first hour](../tutorials/the-first-hour.md) leaves you with a built `rishi`. These need nothing else.

---

## 1. Find a file that moved

When a room grows past what a browser can list, this tree folds it into `date/YYYYMMDD/` -- and every reference already written at the old path keeps working, because a stale reference is **resolved** rather than rewritten.

```sh
rishi/bin/rishi run tools/dated_path_resolve.rish session-logs/20260710-000045_one-clock-resins-plainly.md
```

```
verdict=recovered-by-fold-rule
home=session-logs/date/20260710/20260710-000045_one-clock-resins-plainly.md
```

**`recovered-by-fold-rule` is the interesting word.** No index was consulted and nothing was searched -- the new home was *computed* from the stamp inside the filename. That is why the day is repeated in `date/20260710/20260710-000045_...`: the repetition makes the move a pure function anyone can invert.

## 2. Hash something with the tree's own Keccak

```sh
printf 'Grain' > /tmp/g.bin
sh tools/fixtures/sha3.sh 256 /tmp/g.bin
```

```
caf0cf084d82e6a8a17a6703e75ca23bdd3385e3a32d6bff0fc0ef76da426ed1
```

That digest comes from `crypto/sha3.rye` -- Keccak-f[1600] authored in Rye, studied clean-room from FIPS 202. No openssl, no system library. Check it against the published standard yourself:

```sh
rishi/bin/rishi run tools/sha3_file_witness.rish
```

It hashes the empty string and `abc` at both widths and compares against the FIPS 202 known answers, which anyone can look up and nobody here can quietly change.

## 3. Ask whether any room has outgrown a reader

```sh
sh tools/fixtures/room_bound_scan.sh
```

```
bound=256
room=session-logs flat=59 verdict=under roster=enforce
enforced_over=0
```

Rooms are **discovered** rather than listed, so one made tomorrow appears here without anyone remembering to add it. Six are enforced; crossing 256 flat files is a red.

## 4. Read the health of the day

```sh
sh tools/fixtures/fascia_metric_v0.sh
```

```
clutter=55
fascia=45
```

**Fascia** is the connective tissue -- whether a reader can follow any thread home. Forty-five of a hundred, and the number is honest: it is low, it is measured, and it is on the front door where it cannot be quietly forgotten.

---

## What every one of these has in common

None of them printed a number a person typed. Each read the tree and said what it found -- which is the only kind of claim this tree makes about itself.

*May a minute here show you more than a page of description could.*
