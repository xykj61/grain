# A port is a name on the machine, never a name in a tree

**Stamp:** `20260911.064232`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every figure here was read on metal this morning, and the
repair it argues for is held by a control that is proven able to refuse
**Room:** checkable
**Kin:** `construction/REDS.md` row `%700` -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) -- [`../foundations/20260826-021731_aether-the-row-that-hears.md`](../foundations/20260826-021731_aether-the-row-that-hears.md)

## The mechanism, first

`mantra/recall_tablecloth_query_delivery.rye` spoke to a dependent process over two UDP port
numbers written into the file: `client_port 38490` and `host_port 38491`. The client sent its
request from one socket and then opened a second to receive on, and a fixed 50 ms sleep stood
between spawning the host and talking to it. Both constants are gone. Each side now binds port 0,
the caller hands its kernel-chosen port to the dependent in `argv`, the dependent answers with a
one-byte ready datagram, and `recvfrom` reports the address that byte came from -- which is the
host. One socket per side carries both the send and the receive, bound before anything can answer
it.

## Why one run could never see it

A port is allocated by the **kernel of one machine**, so a number written into a file is a claim
over every process on that machine. This pier runs eight checkouts. All eight carry this file, all
eight spell these two numbers, and every one of their roster passes runs the witness over it.

The reading, taken this morning at load 14 with eight selftests running at once:

| Binary | Eight at once | Run serially |
|---|---|---|
| elder, fixed ports | **39 of 80 refused** | 0 of 120 |
| repaired, ephemeral ports | **0 of 80 refused** | 0 of 120 |

The serial column is the whole reason this cost two laps. A guard that answers green every time a
hand runs it, and red about half the time it runs beside its siblings, presents to the ledger as a
row whose *what went wrong* field reads *sometimes nothing at all*. The elder row said so in those
words, and named its own cause as an inference.

## The three faults were one habit

Each of the three reached for a **constant where a structure belonged**, and each failed in a
different direction:

- **A fixed reply port** is a shared name, so a sibling reads your reply. The repair is the
  sender's own address, which the kernel already supplies and the elder code already captured and
  discarded.
- **Sending before binding** is an ordering assumption. A reply arriving inside that window meets
  a port nobody holds, the kernel drops it, and the bounded receive spends its five seconds.
- **A 50 ms sleep** is a guess about how long a spawn takes on a loaded machine. The ready datagram
  is the dependent saying it has bound, and it carries the address as well, so one receive answers
  both questions under the timeout every other receive here already honors.

## What the repair does not reach

Measured at `66d4c18ce9`, before this change: **37 port constants across 22 authored `.rye` files**,
between 38472 and 38512. The allocation was kept by hand, one block per module -- and it had
already failed inside a single tree. **Five of those ports were spelled by two modules each**,
including the pair repaired here, which `mantra/snapshot_export_delivery.rye` also claimed.

So the hand-kept block answers a collision between modules imperfectly and a collision between
trees not at all, and nothing in the tree reads the allocation. Naming that class with a meter --
count the constants, name the duplicates, and say how many trees share each -- is the next door,
and it is the shape a lantern takes when it has fired twice.

## What holds this still

[`../tools/fixtures/m/mantra_delivery_port_control.sh`](../tools/fixtures/m/mantra_delivery_port_control.sh),
run as a leg of
[`../tools/m/mantra_recall_tablecloth_query_wire.rish`](../tools/m/mantra_recall_tablecloth_query_wire.rish),
builds the module in a pen and runs its selftest **eight at once**. The clean binary must refuse
zero of sixteen. Then it builds a second copy with the client's ephemeral bind mutated back to a
fixed 38490 and requires that copy to refuse -- because a clean reading from an instrument that
cannot make a sound proves nothing at all. The mutant's target is found by its own neighboring
line rather than by a line number, so an edit above it moves the target rather than losing it.
Read on three consecutive trials: clean 0 of 16, mutant 8 of 8, in nine to eleven seconds.

*May the next name this tree writes down be one it is allowed to own.*
