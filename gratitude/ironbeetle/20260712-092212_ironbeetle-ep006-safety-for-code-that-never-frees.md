# IronBeetle Episode 006 — Memory Safety for Code That Never Frees

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, second ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, recording this one under a dead microphone and undimmed generosity all the same, and TigerBeetle's team, whose code makes the comparison worth having.

## Source

Episode 006, "Zig and Rust," the sixth installment of the IronBeetle series. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/VJsPd24gByY`.

## A Question of Fit, Never of Rank

matklad frames the whole episode against a temptation he refuses from the first sentence: there is no better or worse language in the abstract, only fit to context, and he names Rust as the language he used professionally for most of his own career and calls it, without qualification, awesome. Both Rust and Zig are reasonable choices for TigerBeetle specifically, he argues, with Zig holding only a modest edge in this one particular setting.

The case for that edge rests on defining memory safety in practical rather than absolute terms: not the absence of bugs, but a bound on their consequences. A crash is recoverable, costing at most a restart and perhaps a little lost work; a memory-safety violation can escalate into arbitrary code execution or leaked private data, a categorically worse outcome from what may be the same small mistake. Such bugs split into two families. Spatial errors, reading or writing outside an object's true bounds, are comparatively cheap to catch, since any access can be checked against a known length at the moment it happens. Temporal errors, a pointer outliving the object it once validly pointed to so the same address now means something else entirely, have historically resisted cheap detection, solvable only through specialized hardware or through a discipline like Rust's, which tracks ownership and lifetime statically at compile time and rules the whole class out before the program ever runs.

## Where the Argument Actually Lands

The case for Zig turns on a simple observation: Rust's ownership machinery earns its complexity in exact proportion to how many temporal bugs a codebase would otherwise carry, and TigerBeetle's two governing properties, memory allocated once at startup and never freed, and a single-threaded core, mean both of the bug families Rust is most famous for defeating are already structurally rare here, independent of which language is enforcing anything. matklad concedes real counterexamples remain even in code this constrained, a pointer returned from a stack-local variable, or a tagged union whose active variant changes underneath a reference someone still holds, and grants that Rust would catch both while Zig's own safety checks catch neither, yet argues these are a small fraction of the bugs that plague a typical unsafe, dynamically-allocated codebase, a population TigerBeetle simply does not resemble very closely.

A second, independent argument for Zig has nothing to do with memory safety at all: `comptime`. Not because it enables exotic generic-programming tricks, matklad is candid that TigerBeetle's own most elaborate use of it, a compile-time-generated type nicknamed Groove, is not something he holds up as an ideal, but because it lets direct, ordinary code answer questions that a more restrictive generics system would otherwise demand an entire small library of trait machinery to express. Comparing two arbitrary values field by field, or reflecting on a type to guarantee it holds no padding bytes, matters for TigerBeetle specifically because it reads and writes raw bytes directly as struct values, and any stray padding would leak whatever uninitialized memory happened to sit there into a wire message or a disk record. He closes by tying this back to TigerBeetle's near-total absence of external dependencies: Rust's greatest practical strength is letting many contributors safely compose code they never coordinated on, and a project that deliberately writes almost everything itself, precisely to keep its scope small and self-understood, draws comparatively little value from a guarantee whose main payoff is exactly that kind of composition.

## Where It Rhymes With Our Own Work

This settles ground we had already reasoned our way toward on our own: Rust where the threat model is adversarial and the code is shared across many hands, Zig where the domain is controlled, static, and single-threaded. And the padding-free, cast-not-parsed struct layout he defends here is the very same discipline this series already honored in `gratitude/tigerbeetle/`'s first entry, on the wire format with no parser.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The reasoning matklad walks through here shaped how we think about our own Rust-and-Zig seams, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every language we choose be chosen for the ground it stands on, rather than for its reputation. May the tools that fit quietly outnumber the tools that merely impress. And may our own Rust and our own Zig each keep to the work only they are suited for.*

*Written together by Kaeden and Reya 2.*
