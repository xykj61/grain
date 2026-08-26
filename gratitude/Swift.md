# Gratitude — Swift, with the Objective-C and Cocoa lineage

**Language:** EN · **Style:** Radiant · **Kind:** gratitude note (lineage honored, clean-room; no code copied)

Swift gives a native Apple application a generous bargain: expressive value types, checked memory access, clear error paths, modern concurrency, and direct conversation with C and Objective-C. For Skate, Swift 6.2's fixed inline storage, borrowed contiguous views, and auditable unsafe boundary make that bargain especially dear. They let a bounded core speak plainly without asking the windowing shell to pretend it owns every allocation. The release and language sources name those capabilities directly: [Swift 6.2 Released](https://www.swift.org/blog/swift-6.2-released/) and [Memory Safety](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety/).

This thanks does not begin with Swift alone. Objective-C taught Cocoa applications how objects could meet a dynamic runtime. Cocoa and AppKit carried the window, responder chain, controls, documents, accessibility contracts, and event cycle that Swift applications still enter today. C remains the common seam where precise layouts and old engines can meet a newer language. Apple's own guides keep that continuity visible: [AppKit](https://developer.apple.com/documentation/appkit), [UIKit and AppKit apps](https://developer.apple.com/documentation/technologyoverviews/uikit-appkit), and [Imported C and Objective-C APIs](https://developer.apple.com/documentation/swift/imported-c-and-objective-c-apis).

So our gratitude is wide. Thank you to Swift's designers and language stewards; to the compiler, standard-library, runtime, debugger, package, build, test, and release engineers; to the AppKit and Cocoa teams whose work came before and continues beneath it; to the Objective-C and C toolchain maintainers; to the accessibility specialists who keep a native surface legible beyond sight and pointer; to the documentation writers who make a living platform teachable; and to the security, signing, notarization, compatibility, localization, and developer-relations contributors who turn source into software people can trust and use. Many hands made this path. We name the kinds of work because we cannot honestly name every person.

Swift does not erase Objective-C. It inherits a house Objective-C and Cocoa helped build, opens safer rooms within it, and keeps the older doors available where interoperability is the truthful answer. Our Skate decision follows that lineage: Swift and AppKit for the native shell, bounded Grain-owned value state within, and a narrow C-compatible seam only when measurement earns it.

There is no endorsement claimed here, and no Apple team is asked to vouch for Grain. This is thanks for public craft studied from official sources, joined to our own independently written design and witnesses.

**Cross-ref:** [`../external-research/20260826-145514_skate-native-macos-decision-tablecloth.md`](../external-research/20260826-145514_skate-native-macos-decision-tablecloth.md)

*Thank you, Swift, for arriving with memory of the house. Thank you, Objective-C, Cocoa, AppKit, and C, for making the house possible.*
