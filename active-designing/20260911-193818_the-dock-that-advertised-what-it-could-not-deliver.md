# The dock that advertised what it could not deliver

**Stamp:** `20260911.193818`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading below is taken off
[`../tools/am/amphora_carry_atomic_witness.rish`](../tools/am/amphora_carry_atomic_witness.rish),
which runs `tier lap`.
**Kin:** [`20260911-141253_the-wall-built-for-one-verb.md`](20260911-141253_the-wall-built-for-one-verb.md)
-- the same question asked of `pour` earlier the same day.

A vessel is one file, and a dock is the place a vessel lands with its cargo beside it. Amphora's
`carry` moves both across: it cuts the vessel into datagram-sized chunks, proves the reassembled
far bytes equal the near ones, verifies the far vessel's Kumara stamp and cellar seal, and then
ferries every resin body the vessel's manifest names. The order of those steps is the whole
subject of this page.

## The reading

Measured on metal `20260911.183720`, on the ring-1 fixture, before a line changed.

An honest carry lands **1,565 far bytes equal to the near ones**, beside **four** resin bodies and
five chunk cuts. A far restore over that dock reads its catalog -- `files=4 plain_bytes=378` -- and
completes.

Now plant a fault for the ferry to answer. Forge one near resin body, and `ferry_prove_resins`
finds a body whose hash disagrees with the filename addressing it; it answers `cargo unproven`.
The plant rides the production path, with a witness seam and a permission game both left aside.
On the elder binary, a **first** carry into a fresh dock then leaves:

| At the dock | Reading |
|---|---|
| `vessel.bron` | **1,565 bytes**, byte-equal to the near vessel |
| `vessel-core verify` over it | **GREEN** -- Kumara stamp ok |
| `vessel-seal open-check` over it | **GREEN** -- cellar AEAD seal ok |
| `resins/` | **absent** -- zero of the four bodies the manifest names |
| a far `amphora restore` | carry walls pass, restore walls pass, catalog reads whole, then `resin absent` |

So the near end has refused, and the far end holds a vessel that passes every wall Amphora
offers. The one reader who came for the cargo meets the gap at the last step, after every earlier
step said yes.

## The room already held half this promise

`tools/am/amphora_carry_negative_witness.rish` asserts `test ! -e ${far}` after each of its four
chunk plants, in its own words *refusal must leave no far vessel*. That sentence holds because
`assemble_dock_vessel` proves byte-equality before it writes, so a torn, empty, reordered or forged
chunk refuses with the dock untouched. The promise was real and it stopped at the assemble stage;
the three steps after it carried none. So the repair below is the room's own sentence carried to
the end of the crossing rather than a new rule.

## Why the elder order looked right

Two of the three later steps genuinely need the far vessel on disk. `carry_verify_walls` runs
`vessel-core` and `vessel-seal` as subprocesses over a path, and `verify_far_manifest` reads the
landed bytes back. Writing the dock vessel first is what makes those two checks possible at all,
so the order was load-bearing rather than careless.

What it missed is that the dock vessel is also the dock's **promise**. A file named `vessel.bron`
inside a dock says *the crossing arrived*, and it said so from the moment the assembly landed
rather than from the moment the crossing was whole.

## The repair

The assembled vessel lands on a `.crossing` scratch inside the dock. The far walls and the far
manifest read that scratch. The resins ferry beside it, into the dock's own `resins/` directory,
whose address is derived from the dirname either path shares. Only then does `rename(2)` put
`vessel.bron` in place -- one filesystem, so POSIX makes it atomic, which is why the scratch rides
in the dock rather than in a temporary directory somewhere else.

Every refusal after the scratch exists sweeps it, through the same `refuse_and_clear` the pour
repair introduced, generalized to take the suffix it is allowed to remove. A scratch left standing
would be a vessel under another name, which is the same half-made dock one filename over.

Over the identical plant, the repaired binary leaves the dock holding its five chunk cuts **alone**
-- the vessel path empty, the scratch swept. A far reader lists that dock and reads a crossing
still to come, which is the true state.

## What the resins already had right, and why the first carry is the sharp case

A resin body is addressed by its own digest, so a dock's `resins/` directory is idempotent: a
second carry of the same season writes the same bodies at the same names. And `guard_identity_fork` holds a dock to one
identity for its life: a carry whose vessel parent differs from the one already standing there is
turned away at the near end.

Those two together mean a **re-carry** into a populated dock was already nearly safe -- the bodies
it needs are the bodies already there. Measured: a refused re-carry on the elder binary replaced
the dock vessel with byte-equal content and left every body in place. The loss lived entirely in
the **first** carry, where the dock had nothing yet and the refusal left it looking complete.

The repair covers both, and the witness reads both, because a rule that holds only in the case
someone happened to test is a rule waiting for the other case.

## What this does not reach

**The chunk cuts.** `chunk-NNNN.bron` files stay at the dock after a refusal. They are the
crossing's scratch rather than its promise -- only a `AMPHORA_CARRY_TRUST_DOCK` witness run reads
them back, and a production carry re-cuts them every time. They carry sealed bytes, exactly what
the vessel itself carries. Sweeping them is a tidiness lap rather than a wall.

**Pour's own second half.** `pour_ship` lands its vessel by rename and writes the season's resins
afterward, which is the shape this page just repaired one verb over. Whether a near vessel should
also wait on its own bodies is the same question a third time, and it is named here rather than
taken, since the near side is the season's own home and a reader there has the season itself.

## What it taught

The pour repair earlier today closed on the sentence *a wall built for one verb is not a wall
until the sibling verb is asked the same question*. That sentence was written about `pour` and
`restore`. Asked of `carry`, later the same day, it found the same shape at a larger scale -- the
unit that must land whole is the **dock** rather than the file, and the promise a reader trusts is
the one the directory listing makes.
