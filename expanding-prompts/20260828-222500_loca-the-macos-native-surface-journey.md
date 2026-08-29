# LOCA -- the macOS native surface, a journey seat

**Stamp:** `20260828.222500`
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Journey seat -- five quests named, the first ready to run; Keaton's word opens it
**Waymark:** **LOCA**, drawn `20260828.222500` from `macos-native-surface-rye-backend`, index 2761, sealed in [`../construction/waymark-registry.bron`](../construction/waymark-registry.bron)
**Finding:** [`../active-designing/20260828-215659_the-window-rye-raised.md`](../active-designing/20260828-215659_the-window-rye-raised.md)
**Standing on:** [`../tools/rye/objc_seam.rye`](../tools/rye/objc_seam.rye) - [`../tools/rye/macos_window_probe.rye`](../tools/rye/macos_window_probe.rye) - [`../tools/rye/macos_cell_grid_probe.rye`](../tools/rye/macos_cell_grid_probe.rye)

An employee of Acme Corporation opening this page is looking at the plan for one thing: giving
Grain a native macOS surface written in the tree's own language, beside the Wayland surface it
already has. Two probes have already run, so this journey starts from measurement rather than
from hope.

## What already stands, measured

| Reading | Value | Where |
| --- | --- | --- |
| A native window raised from Rye | window number 4845, real | `macos_window_probe.rye` |
| Swift libraries linked | **0** | `otool -L` on both probes |
| Brushstroke's own rasterizer, on an AppKit layer | **16,268 lit glyph pixels** | `macos_cell_grid_probe.rye` |
| Event pump dequeue, identify, dispatch | 6 events over 300 turns | same |
| Selectors verified against the loaded framework | 19 | `objc_seam.rye` |
| Declarations the seam caught that no compiler would | **3** | across both probes |

The last row is the one that matters most. Casting `objc_msgSend` to a signature is an unchecked
reinterpretation, and TAME puts safety above every convenience this path buys -- so the seam
verifies each selector against `method_getTypeEncoding` from the *loaded* framework before any
message is sent. It caught a forgotten return type twice and a missing `const` marker once, none
of which a compiler on this path would raise.

## The shape of the journey

A journey is five quests. Each quest below names what it proves, what it refuses to claim, and
the one thing that would make it stop and ask.

### Quest one -- the view that owns its own drawing

Both probes borrow the content view's layer. A real backend owns a view: a class registered at
runtime through `objc_allocateClassPair` and `class_addMethod`, with `drawRect:` and the input
selectors implemented as Rye functions. This is the first place the seam grows a **new kind of
call** rather than another selector, so it is where the seam module earns or loses its shape.

**Proves:** a Rye-implemented Objective-C class receives platform callbacks; drawing happens on
the platform's schedule rather than once at startup; resize and retina backing scale reach the
grid as a real cell-count change.
**Refuses to claim:** anything about a display link or frame pacing.
**Stops and asks if:** the runtime's class-pair API needs an allocation shape TAME has no bound
for -- capacities named before a class is registered, or the quest pauses.

### Quest two -- input into Skate's own event ring

`skate/Sources/SkateCore/EventRing.swift` is a bounded 128-seat ring with refusal-before-mutation
and whole-state preservation, and Mind has proven those refusals three times over. This quest
ports that contract to Rye and feeds it real keyboard and mouse events from the view.

**Proves:** every refusal Mind's Swift tests assert, asserted again in Rye against the same
bounds; a full ring refuses without eviction; the unsigned counter refuses before arithmetic.
**Refuses to claim:** IME, dead keys, or international layouts -- those are their own orbit.
**Stops and asks if:** the event vocabulary wants a shape the card has not seated.

### Quest three -- the application shell

A menu bar, the lifecycle a real app has, an `.app` bundle with its plist, and the path to a
signed and notarized build named honestly.

**Proves:** the bundle launches from the Finder rather than only from a terminal.
**Refuses to claim:** notarization, which needs credentials that live behind a custody gate.
**Stops and asks:** at the signing identity, always -- that is Keaton's own hand.

### Quest four -- one surface, two backends, both witnessed

Brushstroke gains a surface seam so `wayland_seed.rye` and the macOS backend are two
implementations of one contract, each proven by the same grid-level claims.

**Proves:** the same `Grid` renders identically on both, checked by pixel count and content
digest rather than by eye.
**Refuses to claim:** pixel-exact parity across compositors, which is not a promise either
platform makes.
**Stops and asks if:** the seam wants Brushstroke's own module tree reorganized -- that is a
lane question, not a code question.

### Quest five -- the iOS door

UIKit is Objective-C and reachable by the same seam. This quest reads how far the same backend
carries to iOS, and where Swift becomes genuinely load-bearing rather than merely conventional.

**Proves:** which of the four quests above port unchanged.
**Refuses to claim:** App Store publishing, which is a custody gate and a business decision.
**Stops and asks:** before any account, certificate, or submission.

## What this journey does not touch

**SwiftUI.** It has no C ABI and no Objective-C interface, and no amount of runtime reach
substitutes for it. If Tahoe's Liquid Glass look delivered the way Apple delivers it best becomes
the goal, this whole journey inverts and Swift earns its place honestly. That reversal is cheap
to make and is written here so it stays available rather than becoming a sunk cost.

**Mind's `skate/` lane.** Nothing here moves it. The re-aim toward iOS is a separate,
user-owned signed supervisor update, booked and named in the finding page.

## The seat's own discipline

Every quest carries the tree's standing laws without restating them: bounded capacities with
named constants, at least two asserts per function with `// invariant:` beside each, refusals
that complete their checks before mutation, both sides of every gate proven in a pen, ASCII-only
prose, and a witness on metal before any claim is called landed. The seam module is the one place
a cast may live; a backend that writes its own is a red on the lap it lands.

Rungs are marked by **waymark, name, and stamp** -- `LOCA -- the view that owns its drawing
(20260829-...)` -- never by an ascending number, under the mark law and the meter that now
enforces it.

## The first lap, ready to run

Quest one, rung one: register one Objective-C class from Rye at runtime, implement `drawRect:`
as a Rye function, and prove the platform calls it. Bounded, one file, both sides proven --
the same shape the two probes already hold.
