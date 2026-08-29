# The iOS door -- a reading of how far four closed movements carry

**Stamp:** `20260829.013907`
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living reading -- LOCA movement five; measures taken on this Mac, no build shipped
**Standing on:** [`../tools/rye/objc_seam.rye`](../tools/rye/objc_seam.rye) - [`../brushstroke/skate_event_ring.rye`](../brushstroke/skate_event_ring.rye) - [`../brushstroke/surface_claims.rye`](../brushstroke/surface_claims.rye) - the four closed movements of the LOCA ladder
**Custody:** every account, certificate, and submission stays at Keaton's gate; this page reads, it does not enroll

LOCA's fifth movement asks a question rather than building a thing: how far do the four closed
movements -- the view that owns its drawing, input through the event ring, the application
shell, and the parity claims -- carry to iOS unchanged, and where does Swift become genuinely
load-bearing rather than merely conventional? This page answers from the mechanisms the
movements actually used, anchored in three things measured on this Mac tonight.

## What was measured, on this Mac, `20260829.013907`

- **The iOS SDK is already here.** `xcrun --sdk iphonesimulator --show-sdk-path` answers
  `iPhoneSimulator26.5.sdk` inside the installed Xcode. Nothing needs downloading to begin.
- **Our own toolchain knows the target.** `vendor/zig-toolchain/zig targets` lists `ios` among
  its operating systems; `aarch64-ios` and `aarch64-ios-simulator` are the triples.
- **The one gap is plumbing, not possibility.** Building the pure ring witness with
  `-target aarch64-ios` stops at `unable to find libSystem` -- the linker wants the SDK's
  library path, and the `--sysroot` flag did not reach the compiler through the `rye build`
  wrapper on the first try. That is a flag-forwarding door in our own wrapper, roughly a
  one-lap fix, and it gates only LINKING: nothing in the language or the modules refused.

## The four movements, read one at a time

| Movement | Mechanism it stands on | On iOS | Verdict |
|---|---|---|---|
| The view that owns its drawing | `objc_allocateClassPair`, `class_addMethod`, `drawRect:`, the checked seam | The Objective-C runtime is the SAME C ABI; `UIView` subclasses draw through `drawRect:` exactly as `NSView` does; the graphics context arrives via `UIGraphicsGetCurrentContext` (a C call) rather than `NSGraphicsContext` | **Ports whole**; two selector spellings and a y-flip change, the seam unchanged |
| Input through the event ring | the pure Rye ring; `sendEvent:` dispatch into registered methods | The ring is pure Rye and ports byte for byte; `UIApplication` has the same `sendEvent:` spine; fingers replace keys -- `touchesBegan:withEvent:` and kin -- so the seated domain event grows touch kinds beside key and mouse | **Ring whole, vocabulary grows**; the movement-two shape repeats with different selectors |
| The application shell | the plist bundle, the delegate protocol, `run` | The bundle-with-plist shape is identical; the delegate mirrors (`application:didFinishLaunchingWithOptions:` answers a BOOL and takes options, so the encoding differs); the bootstrap is `UIApplicationMain` -- a plain C function taking the delegate class NAME, which is friendlier to Rye than the macOS path was | **Ports with renames**; the menu bar has no phone equivalent and stays a Mac grace |
| The parity claims | pure Rye counting and our own Keccak at the hand-off | Nothing platform-shaped is in the module at all; the hand-off is a `CALayer` on both platforms | **Ports untouched** -- the strongest carry of the four |

The reading beneath the table: the LOCA architecture put everything platform-shaped behind one
checked seam and kept everything else pure, and that decision is what the iOS door pays back.
Three of four movements are either pure Rye or the same runtime spoken with different selector
spellings -- and the seam's discipline (verify against the loaded framework, superclass as the
inward oracle, optionals wherever nil can answer) transfers without edits because it never
mentioned AppKit by name.

## Where Swift is genuinely load-bearing, said precisely

- **SwiftUI and its exclusive frameworks.** WidgetKit, Live Activities, and App Intents UI
  surfaces accept only SwiftUI types. An app that wants a home-screen widget writes Swift for
  that widget, full stop. The core surface -- window, drawing, input, lifecycle -- never
  requires it, on iOS exactly as on macOS.
- **Not code signing.** `codesign` reads a Mach-O and never asks which compiler made it; the
  finding page's own sentence holds on both platforms.
- **Not the store's machinery, but the store's PATH.** Provisioning profiles, entitlements,
  and submission tooling assume an Xcode project in practice; driving them against an
  outside-built binary is documented and done, and it is friction rather than a wall. This is
  what "the publishing surface leans on Swift" honestly reduces to: lean, not load-bearing.

## The order of work, when the door opens

1. **The rye wrapper forwards `-target` and `--sysroot`** so pure modules link against the
   simulator SDK -- the measured gap, about one lap.
2. **The pure core crosses first**: ring, claims, reference, grid -- witnesses running in the
   simulator prove the crossing (the bench already carries a simulator control surface).
3. **The seam speaks UIKit**: `UIView` registration, `touchesBegan:` into the ring,
   `UIApplicationMain` bootstrap -- each a rung shaped exactly like the movements already
   closed, which is the point of having closed them.

**Projection, bounded:** with the wrapper door open, the pure core runs in the simulator within
one sitting, and a drawn `UIView` within one more -- assuming the runtime seam behaves on iOS as
its C ABI documents, which movement one's shape makes cheap to test and cheaper to refuse.
**Falsifier:** a simulator run where `objc_allocateClassPair` or `class_addMethod` refuses a
registered class that macOS accepted. Confidence: high on the pure core, moderate on the first
drawn view, and every store-facing step waits at the custody gate regardless.

## What this reading refuses

No account, no certificate, no submission, no shipped build -- the movement's own stops. And no
claim that Tahoe-styled polish comes free: the one true fork from the finding page stands on
iOS too, and if SwiftUI's delivery of the platform look ever becomes the goal, the whole ladder
inverts honestly there as well.
