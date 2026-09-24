# Skate on macOS -- the native-shell decision tablecloth

**Stamp:** `20260826.145514`
**Language:** EN
**Style:** Gauge, Field setting, radiant register (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding and an implementation-floor architecture decision; current tree and source readings are checkable, future native application work is proposed, and DJINN's visual seats remain untouched at custody gate %6
**Kin:** [`../active-designing/20260826-014903_skate-returns-the-dag-rendering-platform.md`](../active-designing/20260826-014903_skate-returns-the-dag-rendering-platform.md) -- [`../active-designing/20260826-022443_the-linengrow-design-theme.md`](../active-designing/20260826-022443_the-linengrow-design-theme.md) -- [`20260826-021135_caravan-read-against-the-optimization-spine.md`](20260826-021135_caravan-read-against-the-optimization-spine.md) -- [`../active-designing/20260826-001744_the-bound-in-the-shape.md`](../active-designing/20260826-001744_the-bound-in-the-shape.md) -- [`../gratitude/grain-sketchbook.md`](../gratitude/grain-sketchbook.md) -- [`../gratitude/Swift.md`](../gratitude/Swift.md)

## Decision and confidence

**Decision:** **Swift 6.2 or newer with AppKit** is Skate's native macOS shell. The
Grain-owned model and frame path use Swift value types, fixed-capacity `InlineArray`
storage where the capacity is small, `Span` for borrowed contiguous views, opt-in strict
memory safety, complete concurrency checking, and warnings as errors. A narrow C-compatible
seam may carry the existing Brushstroke or Skate core only after a measured spike proves that
the seam is needed. Objective-C remains welcome at a framework or legacy boundary; it is not
the language of the new application body.

**Confidence:** high for Swift plus AppKit as the shell and medium for the exact shape of the
render-core seam. Apple gives both candidate languages the same native AppKit reach. Swift
6.2 gives the bounded core fixed inline storage, lifetime-bound contiguous views, auditable
unsafe use, value semantics, and strict concurrency checks without requiring the whole
application to live in C. The open question is narrower: whether the present Rye and
Brushstroke renderer crosses through a C ABI, is re-expressed behind a Swift value interface,
or remains a separately built engine. A prototype and measurements decide that seam; they do
not reopen the shell choice.

This is a **Power-of-Ten-inspired constrained profile**. It is not NASA certification, JPL
approval, safety-critical qualification, or a claim of full compliance with Holzmann's C
rules. It carries the rules' verifiable intent into the code and resources Grain owns while
naming the Cocoa boundary honestly.

## The ground already standing

The current repository has no tracked Swift, Objective-C, Xcode-project, or Swift-package
source. Its native drawing path is therefore a decision and a build plan, not a renamed
artifact that already exists.

Skate currently lives as an aspect of Brushstroke in
[`brushstroke/skate_grid.rye`](../brushstroke/skate_grid.rye). The grid owns `u32` rows and
columns, two parallel allocated slices for cells and palette indices, and an eight-entry
palette held inline. Text movement already goes through Tally's `copy_disjoint` mark. The
Wayland presenter in [`brushstroke/wayland_seed.rye`](../brushstroke/wayland_seed.rye) proves a
hosted Linux surface; it is evidence for the fold-to-frame contract, not an Apple window.

Tally supplies the allocation posture. [`tally/region.rye`](../tally/region.rye) hands slices
from one buffer that never grows and returns `OutOfBounds` at its end.
[`tally/stack.rye`](../tally/stack.rye) places its maximum in the type and stores its elements
inline. Those are the structures the macOS core should resemble even when Swift spells them
differently.

Caravan supplies one implemented periodic fact. [`caravan/queue.rye`](../caravan/queue.rye)
maps a monotonic sequence number into one of four physical slots with modulo, and its self-test
proves that a full queue returns to the first slot. That is a one-dimensional ring whose wrap
is meaning. A two-dimensional toroidal field is proposed in
[`the wafer rehearsed in software`](../active-designing/20260826-001747_the-wafer-rehearsed-in-software.md);
it is not present Skate or Brushstroke behavior. The native plan keeps those standings apart.

The local macOS bench read for this decision carries Xcode 26.6, Apple Swift 6.3.3, and Apple
Clang 21.0.0. It can build a Swift 6.2-language-floor prototype. The deployment floor for a
shipped application remains a measured product choice: select the oldest macOS release whose
AppKit behavior and Swift runtime support pass the same build, unit, UI, accessibility, and
performance checks. This record does not invent that number.

The `vendor/microkit` gitlink is not populated in this worktree. That is an environment
precondition for Microkit-backed Caravan work, not a defect in a native AppKit shell and not a
reason to postpone this decision.

## The older sketchbook, read without inheritance fog

The public `grain-sketchbook` was fetched read-only and pinned as the gitlink
[`gratitude/grain-sketchbook`](../gratitude/grain-sketchbook) at
`99b87f20f1fdbd2fc216cb13c07bdd0531916d27`. That commit has no Swift file, `Package.swift`,
Xcode project, or Xcode workspace. `build/macos_apps.zig` built Zig executables and linked AppKit,
Foundation, CoreGraphics, and QuartzCore. `archaeology/src/tahoe/grain_skate_main.zig` opened a
bounded initial window and entered the AppKit event loop through a general-purpose allocator.
The bridge in `archaeology/platform/macos_tahoe/macos_tahoe/cocoa_bridge.zig` and
`objc_wrapper.c` spread many typed forms of dynamic Objective-C messaging across a broad seam.
There was no complete application-bundle, code-signing, or notarization lane.

Three lessons survive translation into current Grain. Keep the framework event-loop handoff.
Keep explicit frame, title, event, and dirty-region ceilings, with refusal and boundary tests.
Do not repeat the broad runtime-message bridge: let Swift hold AppKit directly, and admit one
C-compatible renderer call only after measurement makes its cost worthwhile. The old fixed
128-event ring silently discarded its oldest entry when full; current Skate keeps the bounded
ring and rejects that policy in favor of a named `EventQueueFull` answer. No sketchbook source line is copied
into this record or the proposed application. Its root carries third-party
licenses but no repository-wide license, so the gitlink remains study-only and any later code
reuse requires a separate license decision.

The sketchbook pin also contains a case-colliding `README.md` and `readme.md` pair under the old
Rye checkout. A default case-insensitive macOS worktree cannot materialize both cleanly. That is
an old-source study constraint, not evidence for or against either application language. The
gratitude receipt records the local sparse-checkout boundary and the exact source paths read.

## Two best possible candidates

Choice A is treated at its strongest. It is not a loose Objective-C application full of
unbounded Foundation collections. It is an AppKit shell in Objective-C with a C core whose
arrays, pools, queues, loops, input sizes, and failure paths are fixed explicitly. ARC manages
the shell's objects. Clang warnings, the static analyzer, sanitizers, and tests stay clean. A
custom `NSView` presents a preallocated frame buffer without turning the C core into an object
graph.

Choice B applies the same discipline to Swift. AppKit remains the shell. Small tables and
queues use `InlineArray`; large frame memory is acquired to a declared ceiling at
initialization and reused; `Span` carries borrowed views without letting their lifetimes
escape; value types hold domain state; strict memory safety names every unsafe operation; and
a C seam stays smaller than the renderer it serves.

| Question | A -- constrained Objective-C and C | B -- constrained Swift 6.2+ | Reading |
|---|---|---|---|
| Native macOS reach | Direct AppKit access; Objective-C is one of Apple's supported traditional app languages. | Direct AppKit access; Swift is the other supported traditional app language. | Even. AppKit, not the language, supplies windows, events, controls, documents, and the main loop. |
| Fixed storage | C structs and fixed arrays express exact layout and require manual pointer discipline at every crossing. | `InlineArray` places a fixed count in the type and adds no separate heap allocation for its own storage. Large slabs can still be allocated once to a fixed capacity. | Swift wins for new owned state; the bound and the safer access path live together. |
| Borrowed memory | Pointer plus count can be narrow and fast, while lifetime and alias correctness remain reviewer duties. | `Span` is a nonescaping, lifetime-bound view over contiguous memory; strict memory safety makes unsafe uses visible in source. | Swift wins unless an existing C ABI is already the proven source of truth. |
| Object lifetime | ARC inserts retain and release operations, while Objective-C's object model keeps dynamic messaging and runtime binding. | Swift classes also use ARC, while structs and enums let the deterministic core avoid reference identity. | Swift wins in the core; both share Cocoa object allocation at the shell. |
| Loop and recursion law | C can satisfy bounded loops and no recursion directly, with strong analyzer support. | Swift can state the same law; fixed-capacity collections make many loop ceilings structural, and a repository scan can forbid recursion in the constrained target. | Even in capability; Swift requires a focused source witness because the language permits more than the profile does. |
| Existing core interop | C is the shortest route to a C-compatible export from the current Rye or Zig-ground renderer. | Swift imports C and Objective-C APIs directly, so it can keep that export narrow rather than moving the application body into Objective-C. | Swift shell plus a measured C seam composes both strengths. |
| Memory safety | C and Objective-C permit pointer and bounds errors; ARC solves object lifetime bookkeeping, not buffer safety. | Swift checks memory access by default, and the 6.2 strict mode makes unsafe constructs auditable. A C call can still weaken the guarantee. | Swift wins, with the bridge reported as an unsafe boundary rather than hidden. |
| Accessibility | Standard AppKit controls bring built-in accessibility; a custom drawn view owes roles, values, actions, and notifications. | The same AppKit contracts are available in Swift, with the same duty for custom Brushstroke content. | Even at the framework; Swift keeps the semantic snapshot in safer owned values. |
| Tests and analysis | XCTest, UI tests, Clang warnings, static analysis, ASan, TSan, UBSan, and Main Thread Checker are available. | Swift Testing or XCTest, UI tests, warnings as errors, strict checks, ASan, TSan, and Main Thread Checker are available; UBSan is C-family only. | Both are strong. The mixed target runs the tools appropriate to each language. |
| Maintenance | Exact layout is familiar to systems programmers, while headers, ownership qualifiers, C pointers, Objective-C messages, and the bridge all remain visible at once. | One current language covers the AppKit shell and most bounded state; C appears only where measurement earns it. | Swift wins by keeping the unsafe vocabulary at one seam. |
| Toolchain and deployment | Mature Clang and Objective-C runtime; no `InlineArray` compiler floor. | Swift 6.2 compiler floor for `InlineArray`, `Span`, strict memory safety, and warning controls; deployment behavior still needs an explicit matrix. | Objective-C has the older-toolchain advantage. The current bench already clears Swift's floor, and safety carries more weight than that convenience. |

Apple's traditional-app overview explicitly gives AppKit to both Swift and Objective-C and
places initialization, the app delegate, controllers, views, and the event loop on the same
framework ground. Swift's official interoperability guide then makes the deciding composition
possible: Swift can call C and Objective-C directly, so choosing Swift for the shell does not
close the one narrow door where a C core may prove better.

Objective-C's strongest advantage is therefore local rather than architectural: an existing C
layout can cross with less ceremony. Its C pointer surface, dynamic binding, and ARC-managed
object graph do not make the whole AppKit process more statically bounded. Swift 6.2 removes
the old fixed-array objection while preserving the same AppKit access. Choice B carries more
safety without giving up Choice A's best seam. The old sketchbook makes this concrete: its wide
Objective-C runtime bridge worked toward an Apple window, but its signature-sensitive adapter
surface is exactly the maintenance and proof cost this decision confines to one measured seam.

## The honest allocation boundary

A Cocoa application cannot truthfully promise that its whole process performs no dynamic
allocation after initialization. AppKit creates and retires framework objects while handling
windows, text, fonts, accessibility, input methods, pasteboards, and events. Objective-C runtime
objects and ARC may allocate. Swift classes, strings, standard collections, bridging, and the
same framework machinery may allocate. Instruments can measure this traffic; neither candidate
language erases it.

The profile instead makes a firm promise about **Grain-owned deterministic state**:

- Every capacity is named before the state opens.
- Small fixed collections live inline. Large byte stores acquire one declared capacity during
  initialization and never grow.
- An event, file, pasteboard item, image, document, network value, or accessibility snapshot is
  size-checked before it enters owned storage.
- One frame performs at most the work admitted by the frame budget. Excess work remains queued
  under a named policy; it never expands the budget in secret.
- Histories and snapshots carry ceilings and a named full answer. User-owned history is never
  silently dropped to preserve a memory claim.
- Platform objects may allocate behind AppKit's boundary. The domain snapshot handed to them is
  bounded, immutable for the handoff, and reproducible from owned state.
- Any unsafe or C operation is confined to a reviewed adapter target, acknowledged in source,
  and covered by boundary tests and the C-family analyzers.

This split is the macOS form of Tally's garden: bound what belongs to us, state what belongs to
the host, and never turn an environment mechanism into a repository claim.

## The Civic Tame constrained profile

These ten rules adapt Holzmann's intent to the Grain-owned model and render core. They are a
project profile, not a claim that Swift or Cocoa follows the original C rules automatically.

1. **Simple flow.** The constrained target uses structured control flow and no direct or
   indirect recursion. Recursive framework behavior outside the target stays outside the
   claim.
2. **Every loop has a ceiling.** A collection walk is bounded by its declared capacity, a frame
   walk by its frame dimensions, and a parser walk by the admitted input length. A witness must
   be able to name the ceiling from source.
3. **Owned capacity settles at initialization.** The core acquires its large stores once, keeps
   their capacity immutable, and answers overflow by name. This rule does not claim control of
   AppKit, Swift runtime, Objective-C runtime, or operating-system allocations.
4. **Functions stay reviewable.** Aim below sixty logical lines for core functions. A longer
   unit earns a named reason and is split when its invariants can stand separately.
5. **Invariants stand beside the work.** Preconditions, postconditions, loop invariants, and
   state transitions are asserted or returned as typed errors. Assertions stay free of side
   effects.
6. **Scope stays narrow.** Prefer local immutable values and private value types. Shared mutable
   reference state belongs behind one actor or one explicit owner.
7. **Inputs and results are checked.** Validate every untrusted size, count, offset, enum, and
   return value at the boundary. An intentionally ignored result carries a reason.
8. **Metaprogramming stays small.** The constrained Swift target uses no code-generating macro
   to hide control flow. A C adapter limits the preprocessor to includes, constants, and simple
   complete declarations.
9. **Unsafe access has one home.** `Span` is the ordinary contiguous view. Unsafe pointers and C
   imports live in the adapter, use one level of dereference where practical, never escape their
   owner, and carry an audit entry.
10. **The build is quiet and analyzed.** Treat warnings as errors. Enable Swift strict memory
    safety and complete concurrency checks. Run the Clang static analyzer for C or Objective-C,
    and run the applicable address, thread, undefined-behavior, main-thread, leak, unit, UI, and
    accessibility checks on their declared cadence.

Safety comes first, performance follows measurement, and joy arrives through a surface whose
limits a person can understand. That is the Civic Tame order carried into an Apple application.

## Concrete owned structures

| Structure | Capacity shape | Allocation point | Full or invalid answer |
|---|---|---|---|
| `SkateState` | Value graph with a compile-time maximum node and edge count | Initialization; small tables inline | `StateFull`, with the prior state unchanged |
| `FrameGrid` | Fixed maximum columns times rows; cell and palette-index counts agree | One pixel and cell slab at initialization, reused every frame | `FrameTooLarge` before raster work begins |
| `Palette` | `InlineArray` at the present eight-seat Skate ceiling | Inline with the frame state | Invalid slot is refused before mutation |
| `EventRing` | `InlineArray<N, Event>` with monotonic `u64` head and tail; only the physical slot is modulo `N` | Inline with application state | `EventQueueFull`; linear counts never wrap |
| `DirtySet` | Fixed bitset over the maximum drawable-node count | Inline with application state | An out-of-range node id is refused |
| `HistoryRing` | Fixed record slots plus fixed payload budget | Initialization | `HistoryFull`; no silent eviction of user-owned history |
| `ResourceCatalog` | Fixed metadata seats and one byte quota for admitted fonts, tiles, and images | Initialization and bounded import into reserved space | `ResourceTooLarge` or `CatalogFull` before partial admission |
| `AccessibilitySnapshot` | Fixed semantic-node ceiling, regenerated from the current state | Reused frame scratch | `AccessibilityTooLarge`, while the last whole snapshot remains available |
| `BridgeRequest` | Explicit-width C-compatible fields and borrowed input/output spans | Adapter call only | Typed bridge error; no callback or retained pointer crosses |

Large frame and image buffers should not become enormous stack values merely to wear a fixed
type. `InlineArray` is right for palettes, queues, bitsets, and small tables. A pixel slab is
right as one initialization-time allocation whose maximum byte count was checked in widened
arithmetic and whose logical length changes inside an immutable capacity. The distinction keeps
the bound without trading it for stack exhaustion.

## Brushstroke, Skate, Caravan, Tally, and the torus

**Brushstroke** remains the drawn surface. The AppKit view presents a finished buffer and
translates platform events into bounded domain events. It does not become the keeper of
application truth.

**Skate** remains the paint target. Its deterministic input is a bounded state snapshot; its
output is one frame inside the preallocated slab. AppKit owns presentation and the main event
cycle. This separation keeps a headless renderer witnessable on any host.

**Tally** supplies the law rather than a new dependency name in Swift: declare capacity, allocate
once, divide without overlap, refuse past the end, clear whole. The adapter proves that its Swift
storage and the present Rye grid agree on dimensions, stride, channel order, and palette slots.

**Caravan** supplies the queue law: a bell or AppKit callback says work arrived; the bounded queue
says how much. The native shell does not wait for Microkit. Later supervision work may compose at
a process boundary after the missing checkout is populated and its own witness is green.

**Toroidal behavior** stays exact. The implemented fact today is Caravan's periodic physical
queue slot. A future tile sampler may use `x modulo tile_width` and `y modulo tile_height` only
because a repeating texture is periodic in both axes; it must first require nonzero bounded tile
dimensions and prove opposite edges join. Window coordinates, byte offsets, counts, input
lengths, graph depths, and history positions are linear and refuse their edge. The proposed wafer
field remains a proposal until its own module and witness land.

**Aetheric remains a conceptual and poetic design register.** The aether row asks why and listens
for the work's purpose. It chooses no allocator, ABI, topology, language, or physical mechanism.
This architecture can carry its vocabulary in voice and theme names while every executable claim
stands on code, measurements, and witnesses that remain true if the word disappears.

## Phased implementation and proof

### Phase zero -- this decision

Keep this record indexed and bind its central claims with the companion witness. The control
plants a reversed choice, a false certification boundary, a missing primary source, an
executable aether claim, and a false sketchbook pin; each must red while the living record stays
green.

### Phase one -- the native shell

Create the smallest Xcode application target in Swift with AppKit: application delegate, one
window, one standard accessible status control, and one custom frame view. Pin the Swift language
floor at 6.2 or newer, enable strict memory safety and complete concurrency checking, promote
warnings to errors, and add unit plus UI test targets. The first green is a blank bounded frame
presented on this Mac with keyboard focus and an accessibility label, not a visual-design seat.

### Phase two -- the bounded model package

Build a Swift package target with no AppKit import. Seat capacities for events, frame cells,
palette entries, semantic nodes, history, imported bytes, and frame work. Prove happy-zone fills,
each just-over-ceiling refusal, atomic state on refusal, deterministic replay, and no recursion.
Run the same tests under address and thread sanitizers where supported.

### Phase three -- the Brushstroke seam

Measure two spikes against identical fixtures: a pure Swift frame fold and a narrow C-compatible
call into the present renderer. Compare frame bytes, peak owned memory, allocations per steady
frame, latency percentiles, binary and bridge complexity, and analyzer coverage. Keep Swift when
the difference is within the declared frame budget. Keep the C seam only when it wins a measured
budget or preserves a proven body that a rewrite would duplicate. In either case, one golden
fixture must produce byte-identical cells, palette indices, and pixels on both sides.

### Phase four -- periodic texture at the floor

Implement a neutral periodic tile sampler only after the renderer seam is green. Prove a small
tile repeated across a larger frame, both opposite-edge joins, deterministic output, nonzero
dimension guards, and refusal of over-ceiling dimensions. The sampler establishes topology, not
appearance. Stroke shape, color mapping, softness, and the Linengrow theme remain DJINN's visual
seat at gate %6.

### Phase five -- native whole

Exercise keyboard, pointer, resizing, backing-scale changes, reduced motion, VoiceOver semantics,
save and restore, corrupted and oversized inputs, frame-budget exhaustion, and repeated steady
frames. Record owned allocation counts separately from platform allocation counts. Ship no claim
stronger than the instruments can distinguish.

### Phase six -- signed distribution

Choose the release channel explicitly: Mac App Store, or Developer ID outside the store. The
outside-store lane enables the hardened runtime, signs the finished application and its nested
code with the appropriate Developer ID identity, submits the exact artifact for Apple
notarization, staples the accepted ticket where the format permits, and validates the distributed
copy on a clean supported Mac. Keep bundle identity, entitlements, privacy declarations, update
policy, crash-symbol custody, and minimum-macOS tests in the release proof. These are shipping and
identity obligations, not evidence that Swift is safer than Objective-C. Apple credentials,
certificates, signing, notarization submission, and release are user-custody gates; this local
decision performs none of them.

## Revisit and exit triggers

Revisit the C seam, while keeping Swift as the shell, when a repeatable benchmark shows Swift
cannot meet the seated frame or owned-memory budget; when the existing renderer exposes a stable
and smaller C ABI than a faithful Swift expression; or when a required hardware API is available
only through an audited C interface.

Revisit the Swift 6.2 compiler floor when the chosen minimum macOS release or the repository's CI
hosts cannot build and run the features this profile requires. The response is a measured
deployment decision: raise the deployment floor, back-deploy a smaller bounded container, or
park the native target. It is not a quiet fall back to unbounded collections.

Exit this architecture if AppKit cannot supply the accessibility, input, windowing, or rendering
behavior the product requires after a real prototype; if the custom surface cannot maintain its
semantic accessibility tree inside the stated budget; or if the design lead seats a different
surface at custody gate %6. Each trigger asks for a new decision record with the failed witness or
measurement attached.

## Primary-source receipt

These sources were read on `2026-08-26`. Current Apple and Swift pages support the present
toolchain and framework claims. The two Apple Objective-C guides are archive material; the
objects-and-classes guide is a retired historical source used only for the stable runtime model,
not for present-day release procedure.

- Gerard J. Holzmann, NASA/JPL, ["The Power of 10: Rules for Developing Safety-Critical Code"](https://spinroot.com/gerard/pdf/Power_of_Ten.pdf), 2006. The paper targets C and states the ten rules this profile adapts: simple nonrecursive flow, bounded loops, no dynamic allocation after initialization, small functions, assertion density, narrow scope, checked inputs and returns, limited preprocessing and pointers, and zero-warning compiler plus analyzer runs.
- Swift.org, ["Swift 6.2 Released"](https://www.swift.org/blog/swift-6.2-released/), 2025. This is the release source for `InlineArray`, `Span`, opt-in strict memory safety, approachable concurrency, and warning controls.
- Swift Evolution, [SE-0453, `InlineArray`](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0453-vector.md). The fixed-size array stores elements inline and introduces no separate heap allocation for its own storage.
- Swift Evolution, [SE-0447, `Span`](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0447-span.md), and [SE-0458, Strict Memory Safety](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0458-strict-memory-safety.md). These establish the nonescaping contiguous view and the auditable unsafe boundary.
- The Swift Programming Language, [Memory Safety](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety/). This is the language's standing account of safe memory access and exclusive access to memory.
- Apple, [UIKit and AppKit apps](https://developer.apple.com/documentation/technologyoverviews/uikit-appkit) and [AppKit](https://developer.apple.com/documentation/appkit). Apple names Swift and Objective-C as the traditional application languages and describes the application, delegate, controller, view, and event-loop division.
- Apple, [Imported C and Objective-C APIs](https://developer.apple.com/documentation/swift/imported-c-and-objective-c-apis). Swift can call C and Objective-C and can coexist with both in one project.
- Apple, [Accessibility for AppKit](https://developer.apple.com/documentation/appkit/accessibility-for-appkit). Standard controls bring built-in accessibility; custom views and elements carry explicit protocol and element duties.
- Apple, [Diagnosing memory, thread, and crash issues early](https://developer.apple.com/documentation/xcode/diagnosing-memory-thread-and-crash-issues-early) and [Adding tests to your Xcode project](https://developer.apple.com/documentation/xcode/adding-tests-to-your-xcode-project). These name the sanitizer, main-thread, unit, integration, and UI test surfaces used in the proof plan.
- Apple Documentation Archive, [Programming with Objective-C](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html) and [About Memory Management](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html?language=objc). These establish Objective-C's C substrate and explain that ARC inserts reference-counting operations at compile time; Cocoa objects still form runtime-allocated graphs.
- Apple Retired Document, [Defining a Class](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocObjectsClasses.html). This retired historical source is used only for Objective-C's stable dynamic-binding and runtime object-creation model.
- Apple, [Distributing your app for beta testing and releases](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases) and [Notarizing macOS software before distribution](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution). These ground the separate release phase: choose a distribution lane, and use Developer ID, hardened runtime, and notarization for the outside-store path.
- `xwb122m/grain-sketchbook`, [commit `99b87f20f`](https://github.com/xwb122m/grain-sketchbook/commit/99b87f20f1fdbd2fc216cb13c07bdd0531916d27). The exact source paths and independently restated lessons are recorded in [`gratitude/grain-sketchbook.md`](../gratitude/grain-sketchbook.md); no code was copied.

## What this record does not claim

It does not ship an application, choose a visual system, populate Microkit, prove a two-dimensional
torus, or convert aether imagery into engineering. It does not promise zero process allocations,
hard real-time AppKit behavior, or safety certification. It does not use Apple credentials, sign
or notarize an artifact, choose an App Store business path, or claim endorsement from Apple,
NASA, JPL, Swift, or the older sketchbook. It decides the next implementation floor firmly enough
to build: Swift and AppKit outside, bounded value state inside, and one measured unsafe seam at
most.

The native shell can now begin on clear ground. The framework carries the window, the bounded
core carries the truth, the renderer carries one frame, and every crossing says exactly which
promise belongs to it.
