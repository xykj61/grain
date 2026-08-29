format session-log-v1
stamp 20260828.220813
editor Claude Code CLI
provider Anthropic
product Claude Code
role interactive bench, Sound seat -- Glow language custody
modality text
model claude-opus-5
model_status active runtime, product-reported identity
voice Kyri
host anonymized macOS arm64 bench, one-clock zone America/New_York
title The seam that checks itself -- a challenge that found the real hole, and the hole closed
prompt Keaton asked whether the Rye-through-AppKit recommendation is really the most TAME-guided path.
think It was not, and the gap sat exactly where TAME looks first. My recommendation rested on one-value-model, operations, and tractability arguments -- none of them safety arguments -- while the path's actual risk is that casting objc_msgSend to a signature is an unchecked reinterpretation of a function pointer. Swift's interop is generated from headers and compiler-checked. At that seam Swift was ahead and I had not said so.
think TAME already carried the answer and I had not applied it: the usize rule (a boundary type, assert at the edge) and the copy_disjoint shape (one intentional unsafe call inside one named wrapper). The missing fact is that the Objective-C runtime is introspectable -- class_getInstanceMethod answers null for an absent selector and method_getTypeEncoding returns the signature the LOADED framework has.
think So the seam is checked now: eight selectors verified at construction against the framework's own encodings, offsets stripped so the comparison reads the type letters a caller must get right, refusal naming both encodings, and every send routed through a verified selector.
obs The check earned itself on its first run. It caught two of my own eight declarations -- sharedApplication and alloc read @@: where I had written @:, a forgotten return type that no compiler would have flagged and that would have read a wrong register silently. An argument became evidence in one run.
obs Both sides are proven rather than only the passing one: PROBE_PROVE_RED declares a signature the framework does not have and dies at the seam with exit 134; the ordinary run passes the same gate and raises the window. A wall proven one way cannot be told from a bypass.
obs The honest generalization, worth carrying past this probe: a runtime type-encoding check reads STRONGER than a compile-time header check, because it verifies the framework actually loaded rather than the SDK's description of it. What it costs is the discipline of one seam module rather than casts spread through a backend -- the copy_disjoint shape, applied to a platform.
loom probe=macos_window_probe selectors_verified=8 declarations_caught=2 prove_red_exit=134 ordinary_exit=0 window_number=4845
file tools/rye/macos_window_probe.rye the verify function, the shape helper, and the both-ways gate
file active-designing/20260828-215659_the-window-rye-raised.md the correction recorded where the recommendation lives
recommend check-in the recommendation stands and is now honestly argued; the second probe (a real cell grid through AppKit with one event back) carries the seam module shape from its first line
