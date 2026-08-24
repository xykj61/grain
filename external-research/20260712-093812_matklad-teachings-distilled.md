# Matklad's Teachings, Distilled for Our Work

**Language:** EN
**Stamp:** 20260712.093812 (Kaeden's clock, verbatim)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Honors:** Alex Kladov (matklad) -- rust-analyzer, and years of essays on his Arts & Crafts blog
**Status:** Proposed study -- research for understanding; silo-style; no exact phrasing carried; sources named, not quoted

---

These are the lasting lessons from matklad's public writing, set down in our own words. Each is paired with where it already lives in our tree, or where it belongs. The point is not to admire the essays; it is to hold what they teach and let it sharpen the work we already do.

## Push the branches up, push the loops down

One idea runs through his architecture writing: keep the deciding in the parent and the doing in the leaves. A function that takes an already-decided value is kinder than one that takes a maybe and decides inside; pushing the decision outward tends to remove checks overall, because the caller often already knew. Loops, by contrast, belong low -- down where a batch can be handled all at once, amortizing setup and freeing the order of work.

This is already our seated rule under TAME: *push the ifs up and the fors down*, centralize control flow in the parent, keep leaf functions pure. The teaching confirms the shape we chose. The place to feel it next is the `%tame` linter horizon -- a rule that notices a leaf function growing a branch it should have inherited.

## The shape of a module matters more than its size

His counsel on where to draw a file boundary: stop measuring lines, start measuring the ratio of what a module holds to the surface it shows the world. A self-contained thing earns its own file whether it is ten lines or ten thousand; a sprawling file is often three subsystems quarreling. Divide the volume by the surface area -- it is the shape, not the size.

This deepens our graduation rule (a concept becomes a module at its second outside consumer) and our smallest-first habit. Where it bites next: as Granary, Mandi, MUR, and Dimeroll grow (was MALA), the honest question for each is not "how long is this file" but "how small is its interface for what it holds." A good cut makes callers and callees meet cleanly.

## Cut through the glue to the algorithmic core

On choosing dependencies: many a dependency, taken apart, turns out to do nothing itself -- it repackages a deeper library behind a new interface. The craft is to see past the wrapper to the actual logic, and depend on that, or own it.

This is aparigraha in engineering dress, and it is exactly the reasoning behind our compiler-fork deferral and our thin-frontend stance: prefer the working core, refuse the glue. It applies directly to the mesh study in this bundle -- where the honest move is to keep our own thin transport seam rather than adopt a large networking stack whole.

## Static allocation is a discipline that enforces itself

TigerBeetle's founding memory rule, which he explains often: allocate everything at startup, free nothing after. The elegance is that it is self-enforcing in a language with no global allocator -- code written after startup simply lacks the means to allocate, so the rule cannot be broken by accident. And a subtle correction he insists on: this is not embedded-style fixed arrays hardcoded into the binary; the amount of memory is chosen at startup from the runtime command line, then held.

We already keep the spirit through Tally's garden seasons and named budgets. The correction matters for our seL4 work: Genode RAM quotas are startup-chosen, kernel-enforced budgets -- the same discipline, now co-signed by the microkernel. `error.OutOfBounds` at a Tally edge becomes a quota the kernel itself refuses to exceed.

## Assertions catch the programmer, not the user

His clean split, drawn from the same lineage: operating errors are expected and must be handled; assertion failures are unexpected and mean the code is wrong. The two are not the same kind of thing, and conflating them is how bugs hide. The right response to a corrupt program state is to stop loudly, turning a quiet correctness bug into a findable one.

This is already our assertion-density rule and our named-error rule, side by side. The pairing discipline -- assert a property on two different paths, guard both the valid and invalid sides -- is the part worth teaching the bench again as the fold and Comlink grow.

## Everything gets a limit

Put a bound on every loop and every queue, because in reality everything has one; where a loop genuinely cannot terminate, assert that fact so the reader meets the intent. This "limit everything" rule is the safety floor beneath the whole style.

We hold this already. The seL4 environment rewards it doubly: a component with bounded queues and asserted event loops is a component whose resource use the kernel can reason about -- bounds become part of the isolation story, not just the code's hygiene.

## Be roughly right before you build -- simmer, then cook

On process: the danger in "just build something" is landing on a local maximum and iterating there forever. His antidote is to think in the four primary costs -- network, storage, memory, compute, each with bandwidth and latency -- until the design is *roughly right*, sitting on the slope of the global maximum, before the first real code. He calls the waiting part simmering: keep the idea on the stove and let it reduce.

This is Hammock-Driven Development and Gall's Law already in our gratitude shelf, said a third way. It is also the honest frame for this entire round: the mesh is simmering, the enclosure just came off the stove, and the parity debt is the pot that must not burn while we plan.

## Snapshot testing, and the small closed intervals

Two smaller gifts worth keeping. He loves snapshot testing -- assert against a recorded expected output that the tool itself can update -- which maps onto our witness suites and their fixtures. And a delightful edge case: half-open intervals suit iteration, yet random numbers read best with closed intervals. A reminder that the right boundary depends on the domain, which is the same instinct behind our per-domain care.

## Clean room

We study matklad's public essays and TigerBeetle's public docs; we never copy rust-analyzer or TigerBeetle source into our modules. Where TigerBeetle's own enforcement teaches us (its `src/tidy.zig`), we borrow the rule in our own voice and keep the file in gratitude. This entry gathers what matklad teaches in general; the IronBeetle stream distillations gather what the beetle teaches in particular, and live in `gratitude/tigerbeetle/`.

**Sources (named, not quoted):** matklad's Arts & Crafts blog (push-ifs-up-and-fors-down; size-matters; the Zig idiom and syntax posts; the Zig-and-Rust comparison; static-allocation threads); TigerBeetle's public `TIGER_STYLE.md`; the IronBeetle stream series.

---

*May we hold the lesson well enough to say it in our own words. May our modules be shaped, not merely sized. May we simmer long enough to be roughly right, and no longer.*
