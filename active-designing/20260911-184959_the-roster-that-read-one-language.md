# The roster read one language, and the tree declared ports in two

**Stamp:** `20260911.184959`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every count below comes from
[`../tools/fixtures/p/port_band_scan.sh`](../tools/fixtures/p/port_band_scan.sh), and both new readings
are held at zero by [`../tools/p/port_band_witness.rish`](../tools/p/port_band_witness.rish).
**Kin:** [`20260911-145641_the-roster-a-sentence-could-not-hold.md`](20260911-145641_the-roster-a-sentence-could-not-hold.md) -- [`20260911-074907_the-flap-that-shared-a-port.md`](20260911-074907_the-flap-that-shared-a-port.md) -- REDS `%700`

A port is a name on the machine, and this pier stands eight checkouts deep. Yesterday's lap answered
that for the delivery band: `port_band_scan.sh` reads every `const <name>_port: u16 = <number>;` off
the living Rye sources, holds two walls at zero, and each lock header now points at the reading
instead of spelling a roster a hand would have to re-type.

It read one language. The wire labs that carry these same capabilities onto virtio declare their
ports in **Rishi**, as the default half of an environment override:

```
let port_request_raw = env "COMLINK_SYNC_LAB_PORT"
if port_request_raw == "" then let port_request = "15561" else let port_request = port_request_raw
```

A reading of `const <name>: u16` passes over every one of those. So `ports_outside_band=0` was a true
sentence about Rye and a silent one about a room of **29 declarations across 15 labs**, sitting
twenty-three thousand numbers below the seated band.

## What stood in the room nobody counted

Measured `20260911` before the repair: fifteen labs claimed twenty-two numbers between 15555 and
15576, and **five of those numbers carried two or three claimants.**

| Number | Claimed by |
|---|---|
| 15561, 15562 | the open-asks lap-5 ladder, `recall_sync`, and `recall_two_way_sync` |
| 15563 | the open-asks lap-5 ladder and `recall_batch` |
| 15565, 15566 | `recall_catch_up` and `recall_subscribe_poll` |

Two labs proving **different** capabilities held byte-identical pairs, twice over. The cause reads
plainly once the files sit side by side: each was made by copying a sibling and editing the
capability name, and the four-line port block travelled unread.

## The escape hatch shared the collision

The sharper half is the one a census of numbers alone would have missed. `recall_two_way_sync` reads
`COMLINK_SYNC_LAB_PORT` -- the same variable name `recall_sync` reads. `recall_subscribe_poll` reads
`COMLINK_CATCHUP_LAB_PORT`, beside `catch_up`. **Four override names, each read by two labs, and
they are exactly the four labs whose numbers collide.**

So a hand meeting the clash and reaching for the documented override moved both labs at once and met
it again. An override exists to separate two runs; these separated nothing. That is now its own
reading, `device_override_shared`, and it is held at zero.

## What the table said, and how it taught a reader past the fault

`comlink/README.md` carries a Port Map, hand-typed, and its own note reads: *ports repeat across
unrelated laps by design ... the table therefore reads 38490 / 38491 twice, and both rows are right.*
That sentence is true, and it is about the **hosted** column, where each witness binds and releases
inside one bounded run. Read as a heading over the whole table it excuses the device column too --
and the device column is where two labs hold one QEMU listen address.

The map was also stale in four rows. It showed `--` for the two-way sync and catch-up device pairs,
which both labs declare, and it carried no row at all for the four labs at 15555 through 15560.

A peer's paper had already seen the shape and said so in its own *does not reach* section, on
`20260911.074907`: *the Port Map shows `15561-15563` shared between two rows, and every reading here
stopped at the hosted pairs.* An honest boundary, and it stood for a day because nothing counted it.

## The mechanism

`tools/fixtures/p/port_band_scan.sh` gained a second room. It reads
`tools/co/comlink_*_wire_lab.rish` for `if <var> == "" then let <name> = "<number>"`, keeps the
declaration when `port` is a whole component of `<name>`, and harvests each lab's `env "..._PORT..."`
names. Three readings join the printout, and each is a **wall** rather than a ratchet:

| Reading | Held at |
|---|---|
| `device_ports_outside_band` -- a lab default outside the seated band `15555-15600` | zero, enforced |
| `device_double_claimed` -- one number, two labs | zero, enforced |
| `device_override_shared` -- one override name, two labs | zero, enforced |

Four labs moved to clear all five collisions, each of them a mantra capability, and no other lane's
file was touched: `recall_sync` to 15577/15578, `recall_two_way_sync` to 15579/15580 under its own
`COMLINK_TWO_WAY_SYNC_*` names, `recall_batch` to 15581/15582, and `recall_subscribe_poll` to
15583/15584 under its own `COMLINK_SUBSCRIBE_POLL_*` names. `recall_catch_up` and the open-asks
lap-5 ladder kept every number they had.

**Zero is what makes each of these a wall.** The next lab copied from a sibling without editing its
port block reds on the lap it lands, which is the whole reason to spend a repair before seating a
number.

## Why the reading is worth more than the run

Nothing here fires on this pier: `qemu-system-riscv64` is absent, so the labs never execute, and
they stand off the standing roster for exactly that reason -- `%646`, a witness that reds on an
absent optional dependency can never be rostered. Both halves of the hazard were invisible for one
cause: **nothing runs them here.**

A reading of the sources needs no QEMU. That is the property that let one scan see what five
collisions and four shared overrides had kept from every run this machine can make.

## Proven

`tools/fixtures/p/port_band_control.sh` builds real git repositories in a throwaway pen and proves
**80 behaviors**, up from 46. Every device refusal is planted, read, then lifted and read as
zero; the double ceiling is shown from both sides; and the override leg plants two labs whose
**numbers differ**, so it can only pass by reading the name.

Two further mutations each bite their own leg. Deleting the whole-component rule -- written once and
read by both halves -- makes a lab's `passport` default count as a port, and it sits outside the
device band, so the mutant reds a pen the scan reads clean. Deleting the `sort -u` inside the
override harvest makes one lab naming its own variable twice read as two labs sharing it: a fault
against a correct file, which is the one failure a guard cannot afford.

## What this does not reach

**Whether the labs ever meet.** That depends on a pier with QEMU running two at once, and this
reading proves the shape that lets the meeting happen.

**The lock, one room over.** Thirty runners build a constant-port module and **five** wrap the run in
a port lock. Inside mantra the split is exact: **both** locked runners sit on the standing roster and
**all eleven** unlocked ones sit off it, so the discipline reached exactly as far as the roster did.
Tree-wide it is 5 locked-and-rostered, 21 unlocked-and-off, and **4 unlocked runners that the roster
does run** -- `amphora_mark_wreck`, `comlink_rehearsal_wire`, `fora_socket`, and
`neth_serial_core_delivery`. Those four are the live exposure on this pier, where eight ships open
the same roster. Counting the class is its own lap.

**The three doubles in the delivery band**, still standing at 38495, 38496 and 38497, each a choice
of number inside another lane.
