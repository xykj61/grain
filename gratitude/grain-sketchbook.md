# Grain-sketchbook — Kaeden's archived unified-DAG prototype

**Language:** EN · **Style:** Radiant · **Kind:** gratitude and clean-room source receipt

**Source:** <https://github.com/xwb122m/grain-sketchbook> · gitlink [`grain-sketchbook/`](grain-sketchbook/) · pinned `99b87f20f1fdbd2fc216cb13c07bdd0531916d27` (`2026-04-20T22:52:22-07:00`)

**Provenance and license boundary:** Keaton identified this public repository as his own older sketchbook. The pinned root carries `THIRD_PARTY_LICENSES.md` but no repository-wide `LICENSE`, `COPYING`, or `NOTICE`. We therefore hold the source only as an unmodified gitlink for study. No source line is copied, linked, or shipped from Grain; any later code reuse needs its own explicit license decision.

**Shelf:** the old `20260708.222852` decision kept only this note. Keaton reopened that choice on `20260826`: the archive now stands at gitlink distance, so Grain records one commit pointer rather than making the old tree look like new `xy` source.

**What it was:** A Zig 0.15.2-era prototype (~168k lines) built across a long Cursor span — *"Unified DAG UI backend (Aurora + Skate + Realidream)"* in one readme line. Three visual consumers over one `DagCore`: Aurora as editor semantic head, Skate as drawn surface seed, Realidream as browser and Nostr social head. The event DAG is **Weave's unsigned ancestor**; the compositor-window-editor seed is **SLC-2a's drawn terminal** reborn.

**Role for us:** Named inspiration — the mining study already carried the DAG lineage. The fresh native-Skate read adds five smaller lessons, independently restated in current language:

- `build/macos_apps.zig` linked AppKit, Foundation, CoreGraphics, and QuartzCore into Zig executables. It had no Swift source, Xcode project, application bundle, signing, or notarization path. That is proof of an early native seam, not a shipping architecture.
- `archaeology/src/tahoe/grain_skate_main.zig` reached a real AppKit event loop and a bounded initial window, while using a general-purpose allocator. Keep the event-loop handoff; replace its allocation posture with today's explicit owned capacities.
- `archaeology/platform/macos_tahoe/macos_tahoe/cocoa_bridge.zig` and `objc_wrapper.c` exposed a broad, signature-sensitive `objc_msgSend` bridge. Its hard-won lesson is to let Swift own the AppKit shell and keep any C bridge narrow, typed, measured, and tested from both sides.
- `research/src_backup/grain_skate/window.zig` named title and frame limits; `archaeology/tests-2026-01-13-035403-pst/015_dirty_region_test.zig` proved dirty bounds at pixels and edges. Current Skate keeps the explicit ceilings and dirty-region witnesses, without importing the implementation.
- `src/grain_core/window_events.zig` held a fixed 128-event ring but silently dropped the oldest event when full. Current Grain keeps the ring shape and rejects the silent-loss policy: overflow must return a named answer, and user-owned history must not vanish to preserve a bound.

The checkout itself contains both `grainstore/codeberg/ryelang/rye/README.md` and `readme.md`. A default case-insensitive macOS volume cannot materialize both cleanly, so this bench studies the pin through Git objects and a local sparse checkout that omits the colliding pair and root `.DS_Store`. The gitlink remains the exact commit above. This is an old-source portability boundary, not a defect in current Grain.

Full lineage account: [`../external-research/20260708-021912_grain-sketchbook-realidream-mining.md`](../external-research/20260708-021912_grain-sketchbook-realidream-mining.md). Current native-shell decision: [`../external-research/20260826-145514_skate-native-macos-decision-tablecloth.md`](../external-research/20260826-145514_skate-native-macos-decision-tablecloth.md). Counsel: [`../counsel/date/20260708/20260708-021912_claude-counsel-realidream-zig016-brix.md`](../counsel/date/20260708/20260708-021912_claude-counsel-realidream-zig016-brix.md).

**Clean room:** Concepts cross into current design only after they are translated, bounded, and re-proven under Civic Tame. Implementations enter through Grain's own modules only. The submodule is a reading room, never a dependency.

**Cross-ref:** [`../construction/ROADMAP.md`](../construction/ROADMAP.md) — Visual Track
