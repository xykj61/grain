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

The first Image history receipt carries already-rendered edit lines without moving Image's grammar
or replay algorithms into Swift. `ImageEditRecordClaim` admits one through forty-nine caller bytes,
the full line width proved by `image/photo_edits.rye`. `ImageEditHistory` keeps sixty-four such
claims in order, with three thousand one hundred thirty-six payload bytes owned inline. A full
history returns `ImageEditHistoryError.historyFull` before changing any admitted record. Surf and
Skate are direct aliases over this history as well.

The first semantic snapshot now regenerates the presentable frame whole. One root plus the eight
declared-line seats gives `AccessibilitySnapshot` nine inline node seats. Every node owns one
closed role, 128 inline label-byte seats, and a row-local cell rect. The root admits the frame's
one-through-128-byte at-nib identity, and the caller supplies its grid rect; each text-line node
admits its one-through-forty already-rendered bytes. An oversized semantic source returns
`AccessibilitySnapshotError.accessibilityTooLarge` before replacing any of the last whole
snapshot's nine physical seats. Surf and Skate are direct aliases over this value too. The later
AppKit translation, interactive roles, and action vocabulary remain outside this headless type.

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
- An Image edit history owns sixty-four inline record seats and forty-nine inline bytes per record.
  It keeps admitted record claims in order and never evicts one to admit another.
- An accessibility snapshot owns exactly nine inline node seats: one frame root and eight text
  lines. Each root label owns one through 128 bytes, each text-line label owns one through forty,
  and every node owns row zero through seven, column start zero through thirty-nine, and a
  one-through-forty-cell row-local rect.
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
- An empty edit record, a fiftieth record byte, and a sixty-fifth history append return named errors
  before owned history state changes.
- An empty label, a 129-byte root label, a forty-first text-line byte, an invalid row, column start,
  or cell span, and a tenth semantic node return named errors before a node or snapshot replaces
  its prior whole value.

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
env DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  CLANG_MODULE_CACHE_PATH="$PWD/tools/.build/skate-clang-cache" \
  SWIFT_MODULE_CACHE_PATH="$PWD/tools/.build/skate-swift-cache" \
  /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift \
  test --disable-sandbox --package-path skate \
  --scratch-path "$PWD/tools/.build/skate-core"

rishi/bin/rishi run tools/s/skate_native_core_witness.rish
```

The tests prove the living three-line seed fold twice for determinism. The exact 128-byte nib,
forty-byte line, declared eighth row, and seventh styled palette seat pass. Their planted boundary
cases cover a missing nib, the 129th nib byte, declared line ceilings zero and nine, an empty frame
and line, a line past either the one-line or eight-line declaration, the forty-first line byte, an
over-wide paint range, an out-of-range row, and palette seats zero and eight. The frame refusal
control begins from a nonempty grid, exercises all four named errors through both mutators, and
after each refusal compares all 320 cells, 320 palette indexes, and eight colors with the prior
value. The alias-sameness test assigns each peer name directly to the other at compile time,
operates through both, and receives the same reserved-slot refusal with the same unchanged state.

The Brushstroke append control begins with the full 128-byte nib and a full forty-byte line. Empty,
forty-first-byte, and past-declared-ceiling appends each return their named error while all 459
stored values remain equal to a value-copy snapshot, including unused line seats hidden from the
public frame reader.

The media controls admit the exact HUNK2 plane at its last cell and seventh palette slot, Lotus's
full sample and peak ceilings, and a thirty-two-byte digest claim. They refuse short or long planes,
a non-block cell, palette slots zero and eight, an impossible Lotus level, and digest widths of
thirty-one and thirty-three. A repeated import yields the same cells, indexes, and fixed anchors.

The Image history controls admit its exact sixty-four-record and forty-nine-byte bounds, including
the maximum-width crop line from Image's public renderer. Empty and fifty-byte record claims refuse.
The sixty-fifth append refuses with all three thousand one hundred thirty-six admitted payload
bytes equal to a value-copy snapshot. Compile-time assignments prove that Surf and Skate name the
same history identity.

The event controls fill all 128 seats, refuse the next event without eviction, drain in FIFO order,
and cross the physical end while keeping the same linear order. A package-internal proof origin
also starts one empty ring just below the unsigned ceiling and admits one event. At the ceiling,
the next append returns `counterExhausted`. A value-copy comparison reads both counters and all 128
physical seats after the full and counter-exhaustion refusals, proving all 130 stored values stay
unchanged in each case. A compile-time assignment proves that Surf and Skate name the same
event-ring identity.

The accessibility controls regenerate one exact frame root and eight forty-byte line nodes. The
root carries all 128 at-nib bytes, every line keeps its rendered bytes and grid row, and compile-time
assignments pass the finished snapshot through both peer names. Repeating one regeneration produces
the same node values and physical seats. Empty labels, a 129-byte frame label, a forty-first line
byte, rows and column starts on both sides of their bounds, empty and over-wide cell counts, and a
span crossing column forty all refuse by name. A ten-node source returns `accessibilityTooLarge`
with the prior count, all nine physical seats, and every node's 128 inline label bytes unchanged.
Regenerating a shorter frame also proves that every retired physical seat is cleared before the new
whole snapshot appears.

This slice establishes the core contract alone. Visual form, animation, domain, identity, release,
and model settings remain later seats at their existing custody gates. Swift does not decode QOI,
meter PCM, recompute SHA3, verify a digest, parse an edit line, or replay an edit in this slice;
those operations remain in their proven Rye modules. A future cross-language boundary must prove
that the carried digest matches the bytes before it may remove the word `Claim`, and Image remains
the authority for every edit record this history carries. The fixed floor is ready for the later
AppKit shell.
