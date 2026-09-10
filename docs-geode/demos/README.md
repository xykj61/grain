# Demos -- five checks you can run

**Language:** EN
**Style:** Gauge, Door setting
**Voice:** Kyri
**Written:** `20260821.190149`
**Updated:** `20260909.173000` -- land the recovered fifth check, all five commands run again
**Status:** Living -- checkable; commands run in the working field on 2026-09-09
**Kind:** crushed demonstrations
**Where this sits:** home is [`../../README.md`](../../README.md) - start with
[The First Hour](../tutorials/the-first-hour.md), then follow the full path in
[`../../SOURCE.md`](../../SOURCE.md). The first hour builds the tools used here.

Run these commands from the repository root. Each check answers one small question about the
copy in your hands. The output below records this field on September 9, 2026; your counts may
differ. Read each command's full output when you run it.

## 1. Find a file that moved

A dated file can move onto a day shelf while keeping its name. The resolver reads the stamp
in an old address and computes the new address:

```sh
rishi/bin/rishi run tools/d/dated_path_resolve.rish session-logs/20260710-000045_one-clock-resins-plainly.md
```

```
verdict=recovered-by-fold-rule
home=session-logs/date/20260710/20260710-000045_one-clock-resins-plainly.md
basename=20260710-000045_one-clock-resins-plainly.md
```

The repeated day is useful. It lets the tool find the file from its name alone. This example
uses a session log in the working field; the public seed withholds that room.

## 2. Hash a short message

A hash is a short value computed from bytes. It helps a program check whether those bytes
changed. Keep this trial's input in this checkout's ignored output room:

```sh
mkdir -p session-output
printf 'Grain' > session-output/demo-grain.bin
sh tools/fixtures/s/sha3.sh 256 session-output/demo-grain.bin
```

```
caf0cf084d82e6a8a17a6703e75ca23bdd3385e3a32d6bff0fc0ef76da426ed1
```

The same five bytes give the same SHA3-256 digest. The tree's implementation lives in
`crypto/sha3.rye`. Run its witness to check published answers for empty input and `abc`,
at both supported widths, and to check that changing one byte changes the digest:

```sh
rishi/bin/rishi run tools/s/sha3_file_witness.rish
```

## 3. Check the size of a room

```sh
sh tools/fixtures/r/room_bound_scan.sh
```

Selected lines from the full output:

```
bound=256
room=session-logs flat=0 verdict=under roster=enforce
undated_room=construction/archive flat=713 verdict=over roster=advise
enforced_over=0
undated_over=1
terminal_over=0
shelf_bound=768
verdict=ok
```

`flat` counts files directly in a room. Session logs arrive on day shelves, so their parent
room reads zero. `enforce` marks a checked limit; `advise` marks a finding for review. Here the
archive exceeds its advisory bound while every enforced room stays within its limit.

That archive count climbs through the day as ledger rows fold onto shelves. It read 680 earlier
on the same date and 713 when this page was landed, so read the line as the day's reading
rather than the tree's. Nothing here holds it still; the command is what tells you today's.

The scan discovers rooms each time it runs. Its full output names the room beside every count,
so you can see where a finding belongs.

## 4. Read the maintenance score

```sh
sh tools/fixtures/f/fascia_metric_v0.sh
```

Two adjacent lines from the full output:

<!-- selected: two adjacent lines of a longer report, one unbroken run -->
```
clutter=43
fascia=57
```

**Fascia** is this tree's name for its connective tissue. This meter turns four maintenance
signals into a score out of 100: references to superseded work, outstanding style categories,
held vocabulary, and long functions. The full output gives each signal and its penalty.
A score describes those four readings; a product earns its working claims through its own witnesses.

## 5. Compare an announced plan with its recorded work

```sh
sh tools/fixtures/a/announced_length_scan.sh
```

One `met:` line, then the two lines that close the report. The report's own `announcements_checked`
total is left out on purpose: it counts a surface that grows whenever anyone announces a ladder, so
a page quoting it would go stale without a word being written.

<!-- selected: one met line and the two closing lines, gathered from a longer report -->
```
met: constel/LADDER.md announces FORA0-FORA31, reached FORA31
forecasts_short=0
verdict=no_living_forecast
```

The scan compares an announced range with the highest step recorded for that name. `met` says
the recorded steps reach the announcement. `forecasts_short` counts the announcements still
ahead of their recorded steps. These are records in the tree, rather than proof that each step
works. Quoted scan results stay records too; the scan leaves those quotations out of its tally.

[Reading a name](../study/reading-a-name.md) explains why new work gets a stamp and a plain name,
with its steps counted afterward.

---

Each command lets you check one claim for yourself. Fixed inputs keep their answers; room counts
and maintenance scores follow the copy you run. Keep the command beside the reading so the next
person can check it again.

*May each small check help you find your footing.*
