# The window Rye raised -- macOS needs no Swift, and the Swift work is early rather than wasted

**Stamp:** `20260828.215659`
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living design -- the finding is measured; the re-aim awaits its own supervisor update
**Probe:** [`../tools/rye/macos_window_probe.rye`](../tools/rye/macos_window_probe.rye)
**Kin:** REDS %295 (the host tier) - [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) - the Mind seat's operating prompt

Keaton asked whether macOS Tahoe needs a Swift wrapper to run a GUI application at all, whether
the whole thing could be Rye, and whether the Swift work already standing is a waste of time.
Three questions, and the first one is answerable by doing rather than by argument -- so it was
done, and this page records what the doing showed.

## What was measured, on this Mac, `20260828.215659`

`tools/rye/macos_window_probe.rye` builds with the tree's own toolchain and raises a real native
window. The reading it printed:

```
macos-window-probe: window_number=4648 frame=256x160 bytes=163840
macos-window-probe: GREEN -- a native macOS window, painted from Rye, with no Swift linked.
```

A nonzero window number is the window server's own receipt that the window exists on screen
rather than only in the process's memory. `otool -L` on the binary counts **zero** Swift
libraries. The 256x160 buffer of RGBA bytes is filled by a `paint` function in the probe itself,
handed to `CGBitmapContextCreate`, and set as the content view's layer contents -- so the pixels
on screen are the program's own, which is exactly the shape a frame grid needs.

The mechanism, in one sentence: **AppKit is Objective-C, the Objective-C runtime is a plain C
ABI, and Rye calls C without a shim.** `objc_getClass` finds the class by name, `sel_registerName`
finds the selector, and `objc_msgSend` cast to an exact signature sends the message. Core Graphics
is straight C and needs no runtime at all. On this target there is not even a separate
struct-return entry point to reach for.

## The one true fork

**SwiftUI has no C ABI and no Objective-C interface.** Its calling conventions, generics, result
builders, and property wrappers are Swift-language constructs, and no amount of runtime cleverness
reaches them from Rye. That is the whole of the constraint, and it is a real one:

- **AppKit surface** -- Rye reaches all of it, proven above.
- **SwiftUI surface** -- Swift, necessarily. If the Tahoe Liquid Glass look delivered the way
  Apple delivers it best is the goal, that goal names Swift.

Nothing else on the macOS side requires Swift. An `.app` bundle is a directory with a plist and a
Mach-O; code signing and notarization read a binary and never ask which compiler made it.

## Why this fork points away from Swift for *this* application

`skate/Sources/SkateCore/` is two files, `FrameGrid.swift` and `EventRing.swift`, and they import
**nothing** -- no AppKit, no Foundation. It is a bounded cell grid with a palette and an event
ring: a custom-drawn surface, which is the easiest possible case for the C path. One window, one
view, one buffer. It wants no `NSTableView`.

And the tree has already done this work once, on the other platform. **Brushstroke is 72 Rye
modules driving Wayland natively** -- its own pixel buffers, `xdg_surface`, shm. `linengrow/
glow_native_activity.rye` drives Android's NativeActivity the same way. macOS's protocol is
`objc_msgSend` where Wayland's is `wl_display`; the shape of the work is one shape.

The Swift path's cost is already paid and already measured: **REDS %295** exists because
`xcrun swift test` cannot run on the Linux pier, which is what the host tier was seated to answer.
That is one guard rooted to one machine, plus a second value model and a second proof idiom.

## The counterweights, stated honestly

**Ghostty** -- in this tree's own gratitude library -- is a Zig core with a *Swift* macOS shell,
chosen by the author who also wrote the Zig-to-Objective-C bindings. That is evidence from
someone who had both roads open and took the Swift one for the Mac app.

Swift 6.2's `InlineArray`, `borrowing`, and StrictMemorySafety give a great deal of what TAME
asks for, natively -- visible in SkateCore's own shape, which is genuinely disciplined code.

And if the shell ends up SwiftUI, a Swift core removes a foreign-function seam rather than adding
one.

## The verdict: early, not wasted

The **design** is the value, and the design is language-independent: a bounded grid, refusal
before mutation, whole-state preservation across a refusal, alias-sameness over one referent.
Those port to Rye in an afternoon, and the proofs that matter -- the refusal cases -- port with
them.

What the finding changes is the **aim**. Swift is optional on macOS and load-bearing on **iOS**,
where UIKit is reachable but the publishing surface, the tooling, and the modern framework floor
all lean Swift in a way macOS does not. So the honest reading of the Swift work standing today is
that it is **early rather than misplaced** -- a core written in the language the iOS door will
want, before that door is the one being opened.

## What the re-aim would cost, named rather than assumed

Moving `skate/` under a yonder shelf is **not** a file move this bench can simply make:

- `skate/` is one of three roots in Mind's staged-path wall, spelled in
  `tools/fixtures/c/chatgpt_mind_lane.awk`, whose SHA-256 is byte-pinned in the launcher.
- The lane appears again in the operating prompt, the adaptation receipt, and the witness path on
  the standing roster.
- Every one of those is a **user-owned signed supervisor update**, which is the same gate the
  `skate/` grant itself came through.

So the physical yonder is a booked proposal rather than tonight's edit, and it deserves its own
lap with the pins moved in one commit. What tonight seats is the finding and the aim.

## The falsifiers, so this page can be proven wrong

- If a Swift-free entry point turns out to be refused in a *shipped, signed, notarized* bundle
  under Tahoe's hardened runtime -- the probe proves a window, never a shipped app.
- If Liquid Glass is wanted specifically, and AppKit's adoption of it proves too thin.
- If the iOS door opens first, in which case the Swift core is simply already in the right place
  and this page's re-aim is the whole of its contribution.

The probe stays a hand-run instrument rather than a rostered guard, on purpose: it opens a window
on somebody's screen, which is a rude thing for an unattended loop to do at three in the morning.
Its build and run lines live in its own header.
