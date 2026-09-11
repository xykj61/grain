# The wall built for one verb

**Stamp:** `20260911.141253`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **Room:** checkable; every figure here was read off metal and the repair stands under `tools/am/amphora_pour_atomic_witness.rish`
**Kin:** [`../foundations/20260823-222019_what-brix-infuse-is.md`](../foundations/20260823-222019_what-brix-infuse-is.md) - [`../foundations/20260826-021734_water-the-row-that-tastes.md`](../foundations/20260826-021734_water-the-row-that-tastes.md) - [`../amphora/README.md`](../amphora/README.md) - REDS row `20260911.130000`

On `20260910` the vessel room seated a rule for **restore**: prove every resin before the first
byte lands. The witness that holds it, `amphora_prove_before_write`, opens by saying exactly what
it is for -- a restore read each resin, wrote it, and re-hashed it, so the write sat between the
read and its own proof for no reason.

One day later, on a water lap, I asked **pour** the same question. Pour is the sibling verb, in the
same file, roughly forty lines away. It had the shape restore had just left behind.

## What the measurement found

`pour_ship` in `amphora/src/main.rye` called `write_unsealed_vessel` on the target path first, then
ran the seal over it, then the stamp. So the window between the write and the stamp belonged to
whatever refusal happened to arrive. On the ring-1 fixture, with the binaries built from HEAD:

| Step | What stood at the target afterward |
|---|---|
| an honest pour | 1,565 bytes, `seal_cargo` and `stamp_sig` both present, both walls accepting |
| a re-pour with `AMPHORA_VESSEL_SEAL` absent | **956 bytes**, manifest and cargo listing in the clear, neither seal nor stamp |
| a re-pour with `AMPHORA_VESSEL_CORE` absent | **1,425 bytes**, sealed and unstamped |

After the second row, `vessel-core verify` and `vessel-seal open-check` both answered
`InvalidVessel` over the wreck of a vessel that had passed both of them minutes earlier. The third
row is the quieter one: those leavings carry `seal_cargo`, so a hand checking the seal alone reads
a legitimate vessel and finds the missing stamp only if it thinks to look.

## Why it stood

Two things held it up, and both of them read as care from the inside.

**The room's own pour witness asked the right question and stopped one line short.**
`tools/am/amphora_pour_witness.rish` ends with a leg named *same-season re-pour welcomes*: it pours
twice and asserts the second pour exits ok. That is the idempotence gesture the water row's cardinal
seat asks for -- run the actual thing a second time -- and it read the **exit code** where the
subject was the **file**. An exit code stood in for something nobody opened.

**And the front door had already written the promise down.** `amphora/README.md`, in the paragraph
about what makes a vessel worth trusting, says the room answers by name the moment a wall disagrees
*"while the vessel already on disk keeps every byte it had."* The sentence is exactly right. It had
been true of every wall the negative twins plant -- a forged manifest line, a tampered seal, a
truncated vessel, a torn chunk -- because each of those refuses at a read. It was false of the two
walls that refuse at a **tool**, and nothing in the room compared the sentence against them.

## The repair

The fill, the seal and the stamp land on a `.pouring` scratch beside the target, and `rename(2)`
replaces the target once the rite has passed. Same directory on purpose: POSIX makes a rename atomic
within one filesystem, and a cross-device rename refuses rather than half-finishing, so a
copy-then-delete would reopen the very window this closes. `refuse_and_clear` sweeps the scratch on
every refusal, because a scratch left standing is a clear-cargo copy of the season lying beside the
vessel -- the same exposure one filename over.

Eight legs hold it, and two of them are the wall shown from the other side: a pen rebuilds the elder
shape, watches it lose the vessel over a plant, and then watches the repaired binary keep every byte
of that same plant. A refusal proven only in the passing direction reads the same as a door with
nothing behind it.

## What it teaches

**A wall built for one verb is a wall for one verb.** The restore rule was stated generally --
prove before you write -- and implemented locally. Its own header argues the general case
beautifully and names `restore` in every sentence, so a reader finishing it has learned the
principle and has no reason to walk one function over.

The cheapest guard against this is a habit rather than an instrument: **when a rule lands on one
verb, name its siblings in the row that seats it, and say whether each was asked.** Amphora has
three verbs. Restore was asked on `20260910`, pour on `20260911`, and **carry has yet to be asked**
-- it writes into a far dock and guards identity there exactly as pour does, so the same question
is open and is named here rather than assumed answered.

The water row's own instruction is what found it: taste works only up close. The reading that
mattered was not a scan over the room; it was pouring a vessel, breaking one tool, and opening the
file that came back.

*May every vessel that refuses leave the shelf exactly as it found it.*
