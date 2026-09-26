# A receipt row loses an admitted trailing space

**Stamp:** `20260925.154203` (America/New_York; study claimed at this stamp)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- mixed room: the source and local byte comparison are checkable; receipt meaning awaits Incense
**Room:** mixed
**Lane:** Diffuser research; Incense owns product meaning and Skate owns the rendered witness
**Kin:** [receipt contract](../20260912/20260912-201126_the-receipt-you-can-read-contract.md) - [card source](../../../skate/Sources/SkateCore/ReceiptCard.swift) - [snapshot source](../../../skate/Sources/SkateCore/ReceiptAccessibilitySnapshot.swift)

## The question

Can a reader recover the exact admitted purpose bytes from the Still card? The current source gives a counterexample. This matters if the receipt promises to reproduce a signed fact byte for byte. The accepted product contract promises readable terms and leaves trailing ASCII space meaning for this decision.

## Observation -- one byte enters and disappears

On 2026-09-25, `mantra/src/tally_receipt_refusal.rye`'s `text_refusal` checks nonempty length, the declared ceiling, and ASCII. It passes admitted bytes through as written. `ReceiptCard.validate` admits printable ASCII byte `0x20`. The card writes `"purpose  \(purpose)"` into a 72-cell row initially filled with `0x20`; `accessibilityLine` removes trailing `0x20` bytes before `stillFrame` and `ReceiptAccessibilitySnapshot` read the row.

A local Python reproduction of that row construction on 2026-09-25 held every other field constant. The two inputs below have different lengths and the same complete 72-byte row digest:

| Purpose input | Input length | Complete row SHA-256 |
|---|---:|---|
| `habitat-planning` | 16 ASCII bytes | `44425bbe60dffd2417efeb256452bfdd4b662bf11e22993a89c40a3714c4ab58` |
| `habitat-planning ` | 17 ASCII bytes | `44425bbe60dffd2417efeb256452bfdd4b662bf11e22993a89c40a3714c4ab58` |

The command used the source's label and padding rule: `('purpose  ' + value).encode('ascii').ljust(72, b' ')`, then SHA-256. This is a source-model reproduction on Linux. This host has no Swift toolchain, and no macOS render or accessibility runtime result is claimed.

The same source rules admit a purpose containing one ASCII space: Tally's `text_refusal` checks length and ASCII, and `ReceiptCard.validate` accepts printable `0x20`. On 2026-09-25, the same local model made its 72-byte row digest `af09fc64282a40d5f6704dff97eeedb4cba0748a21b1f08d7e71b56f4607811e`; trimming the row yielded `purpose` with no value. The input is one byte, while the visible purpose value is zero bytes. This is a source-model finding, pending a macOS runtime witness.

## Inference -- the display cannot recover that byte

For these two admitted inputs, the extra space occupies a cell that the shorter input already fills with padding. Every cell in the purpose row is equal. With all other fields fixed, the card plane and the snapshot derived from it have no place left to carry which input arrived. A test that compares only the visible Still rows and snapshot entries can pass for both while the admitted purpose bytes differ.

The source-order witness guards the order of eleven deciding fields. It does not ask whether one displayed field maps back to one admitted byte string. That is a distinct product promise to decide before it is tested.

The one-space case also shows that the current nonempty admission check and a nonempty displayed term ask different questions. A field can pass the first and appear blank to the reader. Incense's ruling should cover both trailing-space identity and space-only terms; the paired-input witness alone would leave the blank-term case open.

## Projection -- two buildable rules, one product choice

**Canonical text.** Incense could rule that trailing ASCII spaces have no product meaning. Admission would define and apply a canonical form before a fact is signed, appended, replayed, or shown. Over the next development round, a witness could present both spellings and prove they become one canonical fact, with an all-space purpose refused as empty. This assumes existing signed fixtures may be migrated or versioned without changing their published meaning. **Falsifier:** a previously admitted signed fact needs its trailing spaces to distinguish its terms, or a downstream digest changes without an explicit version crossing. Confidence in feasibility is medium; the policy consequence needs the product owner's word.

**Exact bytes.** Incense could rule that every admitted space is significant. Skate would then need an ASCII-safe display encoding or an explicit length that lets a reader distinguish content from padding, with a composed-row ceiling and a refusal before publication when the encoding cannot fit. Over the next development round, a witness could admit both inputs and require distinct complete Still frames and distinct accessibility values on macOS. **Falsifier:** the selected encoding still maps two admitted inputs to one output, or the 72-cell row cannot carry the longest admitted purpose without a new bound. Confidence in a bounded implementation is medium; the chosen presentation needs the visual seat's review.

## Handoff

Incense can decide which promise the receipt makes. After that ruling, Skate can write the corresponding paired-input runtime test and a planted negative. Until then, the current card is a readable projection of the fixture, with byte-exact recovery from arbitrary admitted purpose text unproven and contradicted by this source-model pair.
