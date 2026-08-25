# Caravan -- Process Supervision

**Language:** EN
**Last updated:** `20260824.062207` (the front door -- the rung record and the harness record moved to their own pages)
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- 110 modules in this directory, and 109 witnesses in `../tools/ca/` standing over them, counted `20260824`
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

**Caravan starts the other programs a system needs, watches them while they run, and brings home
any that stumble -- all inside limits fixed before it begins.**

That is the whole job. Everything below is what it takes to do it honestly, and you can read this
page start to finish in about ten minutes.

## Where the name comes from

A caravan is a group that travels together and arrives together. One program alone is easy to
start; a system is a dozen of them that have to come up in the right order, reach exactly the
memory they were promised, speak only to the neighbors they were introduced to, and keep going when
one of them falls over at three in the morning. Caravan is the part that holds that group together
on the road.

## A supervised process is a dependent

Caravan calls the processes it supervises **dependents** -- something held up by what it was
granted, rather than offspring. The arc earned the word: a dependent is weighed by the line of
resource it currently holds rather than by the ceiling its domain was granted, and its reach can
travel to it and return from it while it runs. The one place the elder word still stands is
`std.process.Child`, which is Zig's own name at the seam and stays exactly as Zig wrote it. The
record of the word that departed waits in
[`../construction/CHECKPOINTS.md`](../construction/CHECKPOINTS.md).

## The five words a system is written in

Five words describe any system Caravan supervises, and each one names something you can point at in
a file.

| Word | What it means here |
|---|---|
| **dependent** | a running program Caravan started and now holds up |
| **domain** | one named part of a system, holding its own rights |
| **channel** | a declared line joining exactly two domains |
| **region** | a named piece of memory, sized in bytes |
| **grant** | one domain's permission to reach one region, at one permission |

## A whole system is a file you can read

Here is a real one, [`systems/serial_stack.bron`](systems/serial_stack.bron), trimmed to its
declarations. One serial device driver serves two clients, and both clients share a read-only font.

```
system serial_stack

domain serial_virt
domain client_a
domain client_b

channel serial_virt client_a
channel serial_virt client_b

region rx_a 4096
region rx_b 4096
region font_rom 65536

grant rx_a serial_virt rw
grant rx_a client_a r
grant rx_b serial_virt rw
grant rx_b client_b r
```

Read it top to bottom and you hold the entire communication and sharing surface of that system: who
runs, who may speak to whom, what memory exists, and who may touch it and how far. Client A reads
its own receive buffer and reaches exactly that; the two clients share a channel with the driver
and hold none to each other, because sharing here is deliberate and visible rather than ambient.

The supervisor derives its own capability table from these same sentences, so the rights it
enforces and the grants a reviewer reads are one text rather than two. That is the property the
whole arc is built around: **two sources of truth wearing one architecture's name is the oldest way
a proof stops meaning anything.**

One rule lives in the grammar itself. A permission is `r`, `rw`, or `rx`, and the word for
write-and-execute together was left out of the language -- so a declaration can say one of exactly
three things, and write stands apart from execute by construction rather than by a later check.

## What an exit code says

A supervisor that knows only *zero is done, anything else is retry* stalls a poller the moment its
first cycle succeeds. Caravan reads three answers instead of two.

| Code | Name | What the supervisor does |
|---|---|---|
| `0` | `cycle_ok` | an ordinary cycle finished -- start it again |
| `8` | `stop_requested` | a deliberate stop -- leave the loop |
| anything else | a fall | start it again, up to a bounded number of attempts |

Zero here means *ordinary* rather than *finished*, and one reserved code carries the deliberate
stop. That code means the same thing whether a person created the sentinel file by hand or the
signal handler in [`supervisor_signal.rye`](supervisor_signal.rye) created it from a real
`SIGTERM`, so a stop reads identically however it arrives.

## The ladder

Caravan grew one rung at a time. A rung is a small program that proves one new thing while
composing over the rung beneath it: [`seed.rye`](seed.rye) supervises a single dependent and starts
it again when it falls, and ninety-seven rungs later [`farewell.rye`](farewell.rye) tells a reader
the plan has quietly stopped writing to them, in the box they already read.

Each later ring imports an earlier one, or restates its shape one step further out, so every rung
stands as it was written and the ladder reads as a history as well as a design.

**[`LADDER.md`](LADDER.md)** holds the full table of all 110 modules and the record of what each
rung proves and why it exists.

## The shared harness

A rung's checks live where they are written once. [`ladder_checks.rye`](ladder_checks.rye) is the
harness a rung hands itself to: a lifted check takes the rung as a comptime parameter and reaches
every helper through it, so one body runs against whichever rung called it -- that rung's own
report, its own helpers, its own wire. A rung publishes a check only to change it.

**[`HARNESS.md`](HARNESS.md)** holds the record of that carry, lap by lap, and the meter that keeps
it honest.

## Run it

One command runs every rung witness in the arc and names which rung answered what:

```
rishi/bin/rishi run tools/ca/caravan_suite_witness.rish
```

It proves its roster whole before it sings from it. Every `tools/ca/caravan_*_witness.rish` on disk
is registered in the suite, and every registration names a file that exists -- a bijection rather
than a tally, so a rung's witness can always be heard.

A second guard holds this page's own ladder table to the modules beside it:

```
rishi/bin/rishi run tools/ca/caravan_ladder_roster_witness.rish
```

## What Caravan does today, and where it stops

Caravan supervises processes, and stops exactly there. [`system.rye`](system.rye) reads flat Bron,
the same notation Brix descriptors use, and it declares Caravan's own rings alone -- composing a
build stays Brix's work, and Pond's policy layer stays its own.

Extended-run stability -- dozens of supervised cycles, watched for resource growth -- waits for a
genuine indefinite consumer to make the longer run mean something. The reasoning is at
[`../counsel/date/20260707/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](../counsel/date/20260707/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md).

---

*May every dependent that falls be caught, and every dependent that finishes ordinarily be trusted
to go again. May a stop always mean the same thing, however it arrives.*
