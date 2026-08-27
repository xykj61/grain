# Surf and Skate Core -- the bounded Brushstroke frame on native ground

**Language:** EN
**Style:** New Gauge, Door setting
**Status:** Living implementation floor -- pure Swift core; no AppKit shell yet
**Home:** [Grain](../README.md)

This package gives the existing Brushstroke-to-Surf-and-Skate frame contract its first native
Swift body. Surf and Skate are peer synonyms for one surface. Either name may be spoken without
changing its meaning. The `skate/` path and `SkateCore` module remain stable names for the package.
Brushstroke already lowers a `.brush` value into one through eight declared lines and paints those
lines into a forty-column by eight-row proof grid. The core carries that exact small shape in fixed
inline storage, with eight palette seats and slot zero kept as the existing foreground sentinel.

The package belongs to phase two of the
[native macOS decision](../external-research/20260826-145514_skate-native-macos-decision-tablecloth.md).
This package stays headless and testable. A future AppKit view may present its finished frame. The
paired measurement described in the decision record remains the gate for any C seam.

The same bounded package now carries the first neutral event admission seam. `EventRing` owns 128
inline seats and two monotonic counters. Modulo chooses a physical seat only; FIFO order and counts
remain linear. A full ring returns `EventRingError.full` with every admitted event still present,
and a counter at the unsigned ceiling returns `counterExhausted` before arithmetic or mutation.
No AppKit callback shape or product gesture enters this type. A later shell may translate its
platform events into a separately seated domain value and offer that value to this queue. The ring
bounds its seats and counters; it does not prove the nested storage of an arbitrary generic event.
Strings, collections, references, and other payloads remain outside this admission claim until the
domain event type gives them an independent fixed bound.

The first media receipt now joins three already-computed public values without pulling their
implementations into Swift. `ImageSkatePlane` admits the exact forty-by-eight full-block plane that
`brushstroke/image_skate.rye` produces from the image module. `LotusMeterReading` admits Lotus's
sample count, peak, and root-mean-square reading under Lotus's own bounds. `Sha3DigestClaim` admits
exactly thirty-two public bytes, the width of `crypto/sha3.rye`'s SHA3-256 result. `MediaReceipt`
holds those values beside one native frame. Surf and Skate are compile-time aliases over this
receipt too.

## Alias-sameness

Grain already calls a lawful pair of names with one behavior
[**alias-sameness**](../.claude/rules/alias-sameness.md); the counsel piece that first proved the
beta leg is held in the maintainer's own study room, which this projection withholds.
This local slice uses its strongest Swift form. `FrameGrid` owns the one implementation.
`SurfFrameGrid` and `SkateFrameGrid` are public compile-time aliases of that neutral type. The two
spoken names therefore share one state shape, initializer, method set, capacity law, and refusal
contract. They add no wrapper, conversion, subclass, duplicated storage, or second source that
could drift.

This core has no serialized frame format yet, so the aliases add no serialized spelling. A future
format belongs to the one underlying `FrameGrid` contract. A repository-wide alias registry or
cross-language name schema remains a separate canon decision; this package records only the local
MIND-owned instance.

## The owned bounds

- A Brushstroke frame declares a ceiling from one through eight and holds no more nonempty lines
  than that declaration.
- Its `at-nib` identity holds one through 128 bytes, matching the living parser's pin bound.
- Each line holds at most forty bytes.
- A Surf or Skate frame owns exactly three hundred twenty cells and three hundred twenty palette
  indexes through the one `FrameGrid` implementation.
- The palette owns eight inline colors. Slot zero remains reserved; styled runs use one through
  seven.
- The event ring owns exactly 128 inline seats. It never evicts an admitted event, and its physical
  slot may wrap while its public head and tail counts stay linear.
- An admitted image plane owns exactly three hundred twenty full-block cells and three hundred
  twenty palette indexes. Each index is one through seven, matching HUNK2's fixed anchor palette.
- A Lotus meter reading owns a count from zero through two to the twenty-sixth samples, a peak no
  greater than thirty-two thousand seven hundred sixty-eight, and a root-mean-square no greater
  than its peak. An empty reading carries zero levels.
- A SHA3 digest claim owns exactly thirty-two bytes. The type proves that width only. It neither
  hashes content nor claims those bytes came from Grain's crypto implementation.
- A missing or 129-byte nib, a line ceiling of zero or nine, a line past the declared ceiling, a
  forty-first byte, an invalid row or range, and an invalid palette seat return a named error
  before owned state changes.

The input collection belongs to the caller. The core checks its count, then copies it into
`InlineArray` storage. This promise covers Grain-owned frame state. AppKit, Swift, callers, and the
operating system retain their own allocation behavior. Every loop walks an admitted nib, line, row,
column, cell, or event bound. The control flow stays iterative throughout the target.

Apple Swift 6.3.3 on this bench exposes `InlineArray` to macOS 26 or newer, so the prototype API
wears that availability gate. The package leaves the shipping deployment floor open. Phase five's
deployment matrix will choose among raising that floor, using another bounded container on older
systems, and parking the native target there. The compiler's availability answer becomes evidence
for that later choice.

## Prove the seam

```sh
env CLANG_MODULE_CACHE_PATH="$PWD/tools/.build/skate-clang-cache" \
  SWIFT_MODULE_CACHE_PATH="$PWD/tools/.build/skate-swift-cache" \
  xcrun swift test --disable-sandbox --package-path skate \
  --scratch-path "$PWD/tools/.build/skate-core"

rishi/bin/rishi run tools/s/skate_native_core_witness.rish
```

The tests prove the living three-line seed fold twice for determinism. The exact 128-byte nib,
forty-byte line, declared eighth row, and seventh styled palette seat pass. Their planted boundary
cases cover a missing nib, the 129th nib byte, declared line ceilings zero and nine, an empty frame
and line, a line past either the one-line or eight-line declaration, the forty-first line byte, an
over-wide paint range, an out-of-range row, and palette seats zero and eight. Each mutation case
keeps the last whole state unchanged. The alias-sameness test assigns each peer name directly to
the other at compile time, operates through both, and receives the same reserved-slot refusal with
the same unchanged state.

The media controls admit the exact HUNK2 plane at its last cell and seventh palette slot, Lotus's
full sample and peak ceilings, and a thirty-two-byte digest claim. They refuse short or long planes,
a non-block cell, palette slots zero and eight, an impossible Lotus level, and digest widths of
thirty-one and thirty-three. A repeated import yields the same cells, indexes, and fixed anchors.

The event controls fill all 128 seats, refuse the next event without eviction, drain in FIFO order,
cross the physical end and continue in the same linear order, and refuse unsigned counter wrap. A
compile-time assignment proves that Surf and Skate name the same event-ring identity.

This slice establishes the core contract alone. Visual form, animation, domain, identity, release,
and model settings remain later seats at their existing custody gates. Swift does not decode QOI,
meter PCM, recompute SHA3, or verify a digest in this slice; those operations remain in their proven
Rye modules. A future cross-language boundary must prove that the carried digest matches the bytes
before it may remove the word `Claim`. The fixed floor is ready for the later AppKit shell.
