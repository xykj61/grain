# Three numbers and a name -- the receipt contract's open decisions, weighed

**Language:** EN - **Stamp:** `20260918.000154` - **Voice:** Kyri
**Style:** Bhakta with Radiant warmth; Gauge at the Field setting
**Room:** mixed -- the measurements are **checkable** and every answer below is a **proposal**
**Status:** Proposed -- three decisions, none taken. Each changes what the product admits, so each waits for Keaton's word.
**Kin:** [`20260912-201126_the-receipt-you-can-read-contract.md`](20260912-201126_the-receipt-you-can-read-contract.md) - [`../foundations/20260824-003828_universal-and-regenerative.md`](../foundations/20260824-003828_universal-and-regenerative.md) - [`../.claude/rules/design-rooms.md`](../.claude/rules/design-rooms.md)

---

## What a ceiling is, for a reader meeting one

A **ceiling** is a number the software checks before it keeps anything. *A purpose may run to eighty
bytes.* Offer eighty-one and the program refuses, names the field, names the number, and changes
nothing it had already stored.

Ceilings are how this tree keeps a promise about memory: every collection states its maximum before
accepting a first item, so no input can grow a program past what the machine holds. It matters
to a life because the person running this software owns the machine it runs on, and a program that
can be made to eat that machine is a program that belongs to whoever feeds it.

The receipt contract declares twelve ceilings. **Four were borrowed** -- `product_digest`,
`value_unit`, `return_kind` and `signature` are refused at 96 bytes because 96 was the nearest
number already written down, for a different field. The borrow is honest and recorded. What it wants
is a reason.

---

## One: the four borrowed ceilings

### `product_digest` -- a fingerprint of the data on offer

A SHA-256 digest written in hexadecimal runs to **exactly 64 characters**. It is that length or it is something else.

| Option | Buys | Costs |
|---|---|---|
| **Exact 64** | A wrong-length digest refuses at the door | Refuses the 65-96 range passing today; commits to a 256-bit digest |
| Keep 96 | Leaves today's admissions exactly as they stand | Admits strings a digest could never be |
| 64 now, a row per scheme later | Honest per scheme | Two rows where the product holds one digest |

**Proposed: exact 64, written as a length rather than a ceiling.** A digest of the wrong length
carries no information, so admitting one admits a fault and hands it downstream. This is the single
change here that **tightens** what the product accepts, and the door is the cheapest place that will
ever happen.

**A correction, and it widens the option rather than narrowing it** (`20260918.003514`). An earlier
reading of this row said 64 *commits to SHA-256*. It does not. **Sixty-four hex characters is the
width of any 256-bit digest** -- SHA-256, **SHA3-256**, and BLAKE2b-256 alike, each 32 bytes. So the
length names a family rather than an algorithm, and the scheme stays free to move inside it.

**Which matters, because this tree already owns SHA3.** `crypto/sha3.rye`, `crypto/sha3_digest.rye`
and `crypto/keccak256.rye` stand written, and SHA3-512 already seals
`construction/waymark-registry.kyri` and addresses content in Aurora.

**And SHA3-512 is a real alternative with a real argument.** Its width is **128** hex characters
rather than 64, so the row would read differently:

| Scheme | Bits | Bytes | Hex |
|---|---:|---:|---:|
| SHA-256 / **SHA3-256** / BLAKE2b-256 | 256 | 32 | **64** |
| SHA-512 / **SHA3-512** | 512 | 64 | **128** |

*For* SHA3-512: it is what this tree already seals its registry with, and the DISC ladder signs with
**SLH-DSA-SHAKE-256s** -- SHAKE being SHA3's own extendable-output function -- so choosing SHA3
anywhere in this receipt puts the whole object in one cryptographic family rather than two.

*Against*: 128 hex costs twice the bytes inside a 4,096-byte fact that a post-quantum signature is
already crowding, and 256-bit collision resistance is ample for the content digest of a small data
product.

**Proposed, with the correction folded in: exact 64, and name the scheme SHA3-256 in the row.** It
keeps the Keccak family the tree's own seal and its signature ladder already live in, it matches the
fixture, it costs half of SHA3-512, and writing the row as *a 256-bit digest in hex* lets the width
outlive the algorithm.

### `value_unit` -- the unit an offered value is counted in

The fixture reads `USD-cent-simulated`: eighteen characters, of which the mandatory `-simulated`
suffix takes ten.

**Proposed: 32.** A currency code runs to three, a scheme prefix a few more, the suffix ten.
Thirty-two leaves room for a unit nobody here has imagined and refuses a sentence. Ninety-six invites
prose into a field meant for a label.

### `return_kind` -- what the holder promises back

The fixture reads `service-credit`: fourteen characters.

**Proposed: 48.** It holds a hyphenated phrase and refuses a paragraph.

### `signature` -- and this one reaches past its own row

The fixture signature measures twenty. A real one will not. The arithmetic:

| Scheme | Signature size | Inside the 4,096-byte fact? |
|---|---:|---|
| Ed25519, base64 | 88 | yes |
| Ed25519, hex | **128** | yes -- **and 96 refuses it** |
| ML-DSA-44 | 2,420 | barely |
| ML-DSA-65 | 3,309 | ~780 bytes left for all else |
| **SLH-DSA-SHAKE-256s** | **29,792** | **no** |

**The present 96 already refuses an ordinary Ed25519 signature written in hex**, which is a refusal
waiting for the first hand reaching for the encoding half this tree's own key material uses.

The last row is the one to sit with. The **DISC** waymark is this tree's ladder toward
SLH-DSA-SHAKE-256s -- post-quantum, hash-based, resting on hashing alone rather than on elliptic curves staying hard. Its signature runs to roughly **seven times the whole encoded fact**.

**Proposed: 192, with the tension named in the same row.** 192 holds Ed25519 in either encoding with
room for a scheme prefix. What no number under 4,096 can hold is the signature this tree is building
toward. **A post-quantum receipt wants its signature beside the fact rather than inside it** -- a
detached signature, referenced by digest.

That is a **shape** question rather than a number, and it belongs on the contract as the thing a
second milestone must face rather than buried in a ceiling row.

---

## Two: which fields are identifiers

The table declares `each identifier` at 96 and never says which fields are identifiers. Five lean on
that one row: `receipt_id`, `holder_id`, `recipient_id`, `product_id`, `signer_id`.

**This is the exact hole `product_digest` fell through.** It travels inside an array named
`identifiers`, so the borrow read as compliant from both sides while being governed by a row that
never claimed it.

| Option | Buys | Costs |
|---|---|---|
| **Enumerate the five in the row** | The hole closes; one number stays one number | The row grows a clause |
| A row per field | Each earns its own reason | Five numbers that should agree, free to drift |
| Rename the row by shape | Describes rather than lists | A shape is still a judgment about membership |

**Proposed: enumerate the five.** One number governing five named fields is checkable in a second,
and the guard reading this table would then verify membership rather than infer it. Five separate
rows would invite the drift this tree books most: **a rule written five times is a rule five places
may quietly come to disagree about.**

---

## Three: the name

`linengrow/` already holds `receipt.rye`, `receipt_core.rye` and `receipt_verify_guest.rye`. Those
are **SLC-L1's verifiable receipt** -- sign, append, fold, verify -- an elder and unrelated subject.
A hand implementing this milestone's `LinengrowReceipt` reaches for exactly those names.

| Option | Buys | Costs |
|---|---|---|
| **`linengrow/receipt_offer.rye`** | Echoes `mantra/src/receipt_offer.rye`, already built; elder untouched | A two-word module name |
| `linengrow/offer.rye` | Shortest, and *offer* is what it means | Loses the echo with Mantra |
| Rename SLC-L1's | One clean `receipt` | Breaks an elder and every reference to it |

**Proposed: `linengrow/receipt_offer.rye`, leaving the elder exactly where it stands.** The
milestone's admission module is already `mantra/src/receipt_offer.rye`, so the same two words make
the whole milestone read as one thing across three rooms, at no cost to anyone.

**The type name is a separate and real choice.** `LinengrowReceipt` is the contract's word today;
`LinengrowReceiptOffer` would match the module. The braid guard reads the type off the contract's own
residence table, so **renaming it there moves the guard with it** -- one word, and nothing hunts for
references.

---

## What I like best, of the four

**The `product_digest` answer**, and the reason is that it is the only one that makes the product
*stricter*. The other three widen a bound or move a name; this one refuses inputs that pass today.
A system earns trust by what it declines, and a digest of the wrong length is the cheapest thing it
will ever have the chance to decline. If only one of these four is taken, it is the one worth taking.

**The signature row is the one I most expect to be revised**, and I would rather be wrong out loud
now: the honest answer to a post-quantum signature is a different shape rather than a larger number,
and 192 is a number that buys a year.

---

## Where a weighed decision like this should live

Keaton asked whether the closed `counsel/` room should be revived for pages of this kind, or whether
something better exists.

**One room already holds this, and [`design-rooms`](../.claude/rules/design-rooms.md) decides it with one
question:** *would this still be worth reading if the code it describes were deleted?* Yes -- the
signature arithmetic, the enumerate-rather-than-five-rows reasoning, and the grace shown to an elder
name each outlive this milestone. So it files here, in `active-designing/`, which already holds
exactly this shape: [`the bounded torus moonshots`](20260910-060204_the-bounded-torus-moonshots.md)
ranks twelve proposals and carries four errata correcting its own rankings.

**And `counsel/`'s closure already rules its own reuse.** *Closed means no longer growing, never no
longer true. Mine it on touch, never wholesale -- when living work cites a piece, lift that piece's
insight into its proper room then.* The design-over-build counsel of `20260715` is **already
lifted**, into [`lindy-first-crux`](../.claude/rules/lindy-first-crux.md), which cites it by name.
It wants obeying rather than re-filing; a third copy would be the drift this tree books most.

## The friction that is real, and it sits elsewhere

Measured `20260918.000154` over living tracked Markdown, past the dated, archive, yonder and
vendored shelves:

| Reading | Files |
|---|---:|
| Pages parking a decision on Keaton's word | **80** |
| Pages recording a word already granted | 44 |
| `YOURS:` lines on the operator card | 6 |
| `Open doors for Keaton` sections | 1 |

**A decision can be parked in four places and nothing reads them together**, so *what is waiting on
me* is a question with four partial answers. That is the gap a new room would make worse by adding an eighty-first
place to park one.

**Proposed instead: one reading over the rooms that exist.** A scan gathering every living page that
says a decision returns to, waits for, or stays Keaton's word, printing each with its page and its
sentence. Reported and gated on nothing, since a pending decision is a state rather than a fault. It is named here as a
proposal with its measurement rather than built, so the building is chosen rather than assumed.

**Built** (`20260918.025301`): [`tools/fixtures/p/pending_decision_scan.sh`](../tools/fixtures/p/pending_decision_scan.sh)
tells a forward-looking sentence from an already-granted one by its verb, and counts a `YOURS:` line
and an `Open doors for Keaton` bullet beside them -- all four places, one reading, reported and
gated on nothing exactly as proposed. Run it fresh rather than trusting the table above, whose count
was one lap's measurement and moves as the tree does:

```sh
sh tools/fixtures/p/pending_decision_scan.sh
rishi/bin/rishi run tools/p/pending_decision_witness.rish
```

## The falsifier

The four-places reading above is a measurement, and its falsifier is one command: run
`sh tools/fixtures/p/pending_decision_scan.sh` and read a count different from the 80 and 44 named
here, which would mean the four places have drifted apart since this page was written. The three
decisions themselves are proposals awaiting Keaton's word rather than projections, so they carry no
falsifier of their own -- the one number that could kill the page's claim is the census, and it is
re-runnable rather than trusted.

## Where this touches the wider vision

**[Universal and Regenerative](../foundations/20260824-003828_universal-and-regenerative.md)** asks
one question of any arrangement: *does what it returns exceed what it takes, for anyone, anywhere?*
A ceiling is that test written as an integer. Ninety-six for a digest **takes** -- it admits
malformed input and hands the cost downstream. Exactly sixty-four **returns** -- it refuses at the
one moment refusing is free. And *anyone, anywhere* is why `value_unit` wants room for a unit nobody
at this desk has imagined.

**Silken Ground** argues a duality: things that look like separate worlds turn out to be one object
seen from two sides. **This contract is that argument in miniature.** One admitted fact becomes a
holder's receipt and an accountant's evidence, and neither projection may import the other. The braid
guard exists to keep the two sides honest about being one object.

**[Anywhere the Vortex Finds Us](../press/20260910-054448_anywhere-the-vortex-finds-us.md)** records
who reached a result first, because grace is the ground this tree stands on. Question three is that
discipline at the smallest possible scale: `linengrow/receipt.rye` arrived first, and the new work
moves aside. It costs one word.

**The moonshots page** carries four errata correcting its own rankings. That is the posture kept
here: every answer above is a proposal awaiting its own first witness, and the one I expect to be
revised is named as such.

---

*May the numbers we choose be ones we can say why about, and may the elder names keep the ground
they found first.*
