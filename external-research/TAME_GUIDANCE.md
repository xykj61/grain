# 996 · TAME Guidance

*The coding style for Rye — safety, performance, and developer experience, in that order.*

**Language:** EN
**Version:** `20260618.204012` (Rye chronological stamp)
**Last updated:** 2026-06-29 (TAME Guidance rename — living canon title and paths)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Status:** Living

---

## Document Stack

Three layers, one discipline:

| Layer | Path | Role |
|-------|------|------|
| **Source** | `../gratitude/TIGER_STYLE.md` | TigerBeetle team's guide, kept whole |
| **Voiced canon** | this document | Our radiant adaptation; Safety, Performance, DX |
| **Operational supplement** | `../context/TAME_GUIDANCE.md` | Checkable root + Rye / Brix / Rishi rules for authors and agents |

Read this document for *why* TAME feels the way it does. Read `context/TAME_GUIDANCE.md` at the keyboard for *what to check*. Landmark filenames follow TigerBeetle's `docs/TIGER_STYLE.md` pattern.

---

## What TAME Guidance Is

TAME Guidance is how we write code for Rye, the language we are growing from Zig 0.16.0. It is a discipline and a delight at once — precise where safety asks for precision, warm in how it reads, and built to be spoken aloud as easily as it is followed. The engineering here is exact on purpose: limits, assertions, and sized types keep their sharp edges, because that sharpness is what keeps us safe. Everything else leads with what is, in a single clear voice.

---

## The Essence Of Style

> The hardest things to shape are steel, diamond, and a clear knowing of ourselves. Style lives where all three meet, so we work it slowly, and with love.

Style evolves. It is a give-and-take at the meeting place of engineering and art — numbers and human intuition, reason and experience, first principles and hard-won knowledge. Precision and poetry, together. Think of music: a tight beat, a rare groove, words that rhyme and rhymes that break on purpose. This is what we have learned along the way, and the best of it is still ahead.

## Why We Keep a Style

Another word for style is design.

> Design runs deeper than how a thing looks or feels. Design is how it works, all the way down.

We hold three design goals, in this order: **safety, performance, and developer experience**. All three matter. Good style advances all three at once. So the question we ask of any piece of code is simple and clarifying: does this make us safer, faster, and easier to work with? That is why style is worth our attention.

Style runs deeper than readability. Readability is table stakes — the floor, rather than the goal.

> We pursue understanding first, and style follows it home. Where the understanding is full, the style is already there.

So we pursue understanding, and let style follow from it.

## Correctness, Not Firefighting

We build so that whole classes of error cannot occur, rather than building quickly and standing ready to chase them. This is the quiet center of TAME Guidance, and it orders everything else.

Assertions, sized types, bounds on every loop and buffer, and — as Rye grows — borrow-checking-style guarantees over Tally's regions (see `yonder/20260618-204012_borrow-checking-and-correctness.md`) are all one move: state what must be true up front, and let the compiler and the runtime make the untrue unrepresentable. An assertion is not a trap we hope to spring; it is a promise we keep, checked. The strengthening compiler works the same way — it states a function's invariants and proves, through the parity gate, that stating them changed nothing the code does.

So we measure our work by whether a fault can occur at all, rather than by how fast we resolve one. We prepare for challenges — we name the invariant, prove the property, design the error class away — rather than brace to put out fires. The cheapest fault is the one the design made impossible; the next cheapest is the one an assertion stops loudly, near its cause, the moment it tries to be born. When a fault does slip through, we meet it calmly, learn from it, and fold the lesson back as a new thing made impossible — so the system grows more correct with every surprise, rather than merely more patched.

This is also how we speak of the work, in keeping with Radiant Style: the language of correctness, preparation, and prevention, rather than of debugging and rescue (see *The Vocabulary of Correctness* in `../context/RADIANT_STYLE.md`). The words point our care to where the leverage lives — early, in the design, rather than late, in the chase.

## On Simplicity and Elegance

Simplicity is a prize we earn, rather than a discount we take. It sits in full harmony with our design goals. Simplicity is how we bring those goals together — how we find the single "super idea" that solves several problems at once, and arrives as something elegant.

> Simplicity and elegance ask for hard work and steady discipline. We give them gladly, because what they return is worth far more than what they cost.

Simplicity is the hardest revision rather than the first attempt. Saying "let's keep it simple" is easy. Achieving it takes thought, many passes, many sketches, and the willingness to throw one away and begin again. The hard part is how much thought goes into everything.

We spend that mental energy upfront, on purpose. When the thinking is done well, implementation and testing dwarf the design cost, and the long years of operation and maintenance dwarf it again. An hour of design buys weeks in production.

> The simple, elegant system is the one we design right and quickly, the one that runs lean, and the one that stays reliable for years.

## Zero Technical Debt

We would rather ask "what could go wrong?" than "what went wrong?" — because code, like steel, is cheaper to shape while it is still hot. A problem solved in design costs a fraction of the same problem solved in production.

So Rye keeps a **zero technical debt** policy. We do it right the first time, for two reasons that reinforce each other. The second chance may never arrive. And doing work we are proud of builds the momentum that carries the next piece. We ship things we know to be solid. We may lack a feature for a while, and what we do have meets our design goals. That is the only way to make steady progress we can trust as progress.

---

## Safety

> Good rules are like a seat-belt. They feel snug at first, then settle into second nature, until the day comes when working without them is the thing we can no longer imagine.

These safety rules will change how you write code, for good. Here is how we live them in Rye.

**Keep control flow simple and explicit.** Clarity is the goal. We avoid recursion, so that everything which should be bounded stays bounded. We use a minimum of excellent abstractions, and only where they genuinely fit the domain — every abstraction carries a cost, and every one risks leaking.

**Put a limit on everything.** In reality, everything has a limit, so our code says so. Every loop and every queue carries a fixed upper bound, which keeps infinite loops and tail-latency spikes away and lets us fail fast, catching trouble early. Where a loop runs forever by design, such as an event loop, we assert that fact plainly.

**Use explicitly sized types** like `u32` everywhere, and set aside the architecture-specific `usize`. Exact sizes keep behavior exact.

**North star (`051312`):** Rye forks to a **literal `usize` ban** — [`20260621-051312_literal-usize-ban-language-fork.md`](../external-research/20260621-051312_literal-usize-ban-language-fork.md), design [`970_explicit_width_in_rye.md`](../active-designing/yonder/20260621-051312_explicit-width-in-rye.md). Until fork F3, interim seam policy: [`20260621-050312_usize-boundary-not-design.md`](../external-research/20260621-050312_usize-boundary-not-design.md).

**Interim (Zig-ground era):** **`usize` is a boundary type, not a design type** — pick `u32` for in-memory counts bounded by a named constant; `u64` for wire-persistent sizes; reserve `usize` only at the immediate Zig slice seam until the fork lands. Do not publish `usize` in struct fields, parameters, or return types we author. Pair every `@intCast` with a narrow assert. Operational detail: `context/TAME_GUIDANCE.md`; strengthening audit: `tools/tame_usize_audit.rye`.

**Assertions are how we discover bugs early and often.** They detect programmer errors — the unexpected kind. Operating errors are expected, and we handle those. An assertion failure means the code itself is wrong, and the only correct response is to crash, which turns a silent correctness bug into a loud liveness bug we can find. Assertions multiply the power of fuzzing.

- **Assert every function's arguments, return values, preconditions, postconditions, and invariants.** A function works on data it has checked, rather than operating blind. Each function exists to raise the odds that the program is correct, and its assertions are part of how it does that job. We aim for an average of at least two assertions per function.
- **Pair your assertions.** For every property worth enforcing, find at least two code paths where you can check it. Assert validity right before writing to disk, and again right after reading back.
- On occasion, a blatantly true assertion makes stronger documentation than a comment, when the condition is both critical and surprising.
- **Split compound assertions.** Prefer `assert(a); assert(b);` over `assert(a and b);` — it reads more simply and tells you exactly which half failed.
- Use a single-line `if` to assert an implication: `if (a) assert(b);`.
- **Assert the relationships of compile-time constants**, as a sanity check and as living documentation of subtle invariants and type sizes. Compile-time assertions are wonderfully powerful: they verify the design's integrity before the program ever runs.
- **The golden rule: assert the _positive space_ you expect, and assert the _negative space_ you reject.** The boundary between valid and invalid is exactly where the interesting bugs gather. For the same reason, tests cover that boundary exhaustively — valid data, invalid data, and valid data as it crosses into invalid.
- Assertions support human understanding rather than replacing it. A fuzzer reveals the presence of bugs, leaving their absence unproven. So we build a precise mental model first, encode that understanding as assertions, write the code and comments to justify the model to a reviewer, and let the simulator stand as the final line of defense.

**Three habits we sharpened by reading closely.** Studying how a database built on these very principles writes its assertions in practice — TigerBeetle, in Zig — gave us three refinements worth keeping. We record them here with gratitude: the craft learned by example, the application made our own.

- **Mark the variable space with `maybe`, the dual of `assert`.** Where `assert` names what must always hold, `maybe(condition)` names what is *legitimately* sometimes true and sometimes false. It reads as documentation today — a statement a reviewer can trust, and one a coverage tool could one day check — and it completes the golden rule: assert the positive space, reject the negative space, and mark with `maybe` the space that genuinely varies. A single line defines it: `fn maybe(ok: bool) void { assert(ok or !ok); }`.
- **Open a function with its preconditions.** Gather a function's argument and state checks into a small block at its very entrance, so a reader meets the rules the function depends on before meeting the work it does. The shape grows familiar and scannable: the door states plainly what must hold to pass through it.
- **Spend assertions where they are free, and gate them where they are dear.** Assertions are a safety budget we spend deliberately. In the control plane — coordination code that batching already makes cheap — assert without hesitation; it is fine to spend O(n) time checking an O(1) result, because the path is rare. In the data plane — the hot inner loops — assert the O(1) precondition unconditionally before an O(n) loop, yet guard a costly per-iteration check behind a compile-time `verify` flag, so the thorough version runs in tests and simulation while the shipped path stays lean. Never spend an O(n) assertion on an O(1) computation. This is how dense safety and a fast path live together — the same line between control plane and data plane we draw for performance, now drawn for assertions too.

**Allocate all memory at startup.** After initialization, Rye programs allocate nothing dynamically — no new allocations, no free-and-reallocate. This keeps behavior predictable, keeps performance steady, and closes the door on use-after-free. As a happy second-order effect, designing for all memory upfront tends to produce simpler, faster systems that are easier to reason about.

**Declare variables in the smallest possible scope, and keep few variables in scope at once.** The fewer the variables, the smaller the chance one gets misused.

**Hold functions to 70 lines.** There is a real, physical break between a function that fits on the screen and one that makes you scroll. Art is born of constraints. Many ways exist to cut a wall of code into 70-line pieces, and only a few of those cuts will feel right. Some guides toward the right cut:

- A good function has the shape of an hourglass turned on its side: a few parameters, a simple return type, and a lot of meaty logic between the braces.
- **Centralize control flow.** Keep the `switch` and `if` statements in the parent function, and move the straight-line fragments into helpers. One function owns the branching; the rest stay free of it. Push the `if`s up and the `for`s down.
- **Centralize state.** Let the parent hold the relevant state in local variables and let helpers compute what should change, rather than changing it directly. Keep leaf functions pure.

**Welcome every compiler warning at the strictest setting**, from day one.

**Run at your own pace.** When the program meets the outside world, it acts on its own schedule rather than reacting directly to each external event. This keeps control flow in your hands, which makes the program safer; it also lets you batch rather than context-switch on every event, which makes it faster; and it keeps the work-per-interval within bounds you can reason about.

Beyond those rules:

- **Split compound conditions into simple ones** using nested `if/else` branches, and turn complex `else if` chains into `else { if { } }` trees. A reader can then verify that every case is handled. While you are there, ask whether each `if` wants a matching `else`, so that the positive and negative spaces are each handled or asserted.
- **State invariants positively.** Negations are genuinely hard to hold in the mind. When you work with lengths and indexes, the affirmative form is easy to get right and easy to read:

```zig
if (index < length) {
  // The invariant holds.
} else {
  // The invariant doesn't hold.
}
```

- **Handle every error.** Nearly every catastrophic failure begins as a small, signaled error that someone left unhandled — the kind a simple test of the error-handling path would have caught. So we handle each one.

> Nearly every catastrophic failure begins as a small, signaled error left unhandled. We handle every error, and so the catastrophe never arrives.

- **Always motivate. Always say why.** Explaining the reason behind a decision raises the reader's understanding, makes them more likely to follow it, and hands them the very criteria they need to weigh the decision for themselves.
- **Pass options explicitly at the call site**, rather than leaning on a library's defaults. Write `@prefetch(a, .{ .cache = .data, .rw = .read, .locality = 3 });` over `@prefetch(a, .{});`. This reads more clearly, and it guards against a quiet, potentially catastrophic bug should the library ever change what its defaults mean. Rye honors this same value in its versioning: a meaning pinned in place stays put, yours to rely on.

---

## Performance

> A few back-of-the-envelope sketches, drawn early, spare us a world of trouble later. So we always sketch first.

- **Think about performance from the very beginning.** The huge thousand-fold wins live in the design phase — the very moment before we can measure or profile. Fixing performance after implementation is harder, and the gains are smaller. So cultivate mechanical sympathy. Like a carpenter, work with the grain.
- **Sketch on the back of an envelope** across the four resources — network, disk, memory, and CPU — and their two characteristics, bandwidth and latency. Sketches are cheap, and they land you within reach of the best possible design.
- **Optimize the slowest resource first** — network, then disk, then memory, then CPU — after weighing how often each is used. A memory cache miss that happens thousands of times can cost as much as a single disk fsync.
- **Separate the control plane from the data plane.** A clean line between them, drawn with batching, lets us keep dense assertions for safety while keeping the fast path fast.
- **Amortize costs by batching** accesses across network, disk, memory, and CPU.
- **Let the CPU be a sprinter.** Be predictable. Spare it the zig-zag of changing lanes. Hand it large enough chunks of work — which brings us back to batching.
- **Be explicit, and lean lightly on the compiler.** Extract hot loops into stand-alone functions that take primitive arguments and skip `self`. The compiler then has less to prove about caching fields in registers, and a human reader can spot redundant work more easily.

---

## Developer Experience

> The hard things in our craft are cache invalidation, naming things, and the off-by-one error — and there are only two of them.

### Naming Things

- **Get the nouns and verbs just right.** Great names are the essence of great code. They capture what a thing is or does and hand the reader a crisp, intuitive mental model. They show that you understand the domain. Take the time to find nouns and verbs that work together, so the whole becomes greater than its parts.
- **Use `snake_case`** for functions, variables, and file names. The underscore is the closest thing we have to a space, and it invites descriptive names.
- **Write names in full**, rather than abbreviating — the one exception being a primitive integer used as an argument to a sort or matrix calculation. In scripts, use long flags like `--force`, and save single letters for interactive use.
- **Capitalize acronyms properly** — `VSRState`, rather than `VsrState`.
- **For everything else, follow the Zig style guide.**
- **Put units and qualifiers last, in descending significance**, so the name opens with its most important word and closes with its least. Prefer `latency_ms_max` over `max_latency_ms`. Then `latency_ms_min` lines up beside it, and all the latency names group together.
- **Infuse names with meaning.** `allocator: Allocator` is fine and a little dull. `gpa: Allocator` and `arena: Allocator` are excellent — each tells the reader at a glance whether `deinit` should be called.
- **Match the length of related names** where you can. As arguments to a copy, `source` and `target` beat `src` and `dest`, because then `source_offset` and `target_offset` line up too. The code grows symmetrical, with clean blocks the eye parses easily.
- **Show the call history in helper names.** When a function calls a helper or a callback, prefix the helper with the caller's name: `read_sector()` and `read_sector_callback()`.
- **Put callbacks last** in the parameter list, mirroring the control flow, since the callback is invoked last.
- **Order for the reader.** We read a file top to bottom, so put the important things near the top, and let `main` go first. Within a struct, the order is fields, then types, then methods:

```zig
time: Time,
process_id: ProcessID,

const ProcessID = struct { cluster: u128, replica: u8 };
const Tracer = @This(); // This alias concludes the types section.

pub fn init(gpa: std.mem.Allocator, time: Time) !Tracer {
    ...
}
```

  When a nested type grows complex, lift it to a top-level struct. When several orders seem equally right, sorting alphabetically reads well — big-endian naming makes that work in your favor.

- **Give each name one meaning.** Avoid names that shift sense with context. If `commit` already means writing a transaction to disk, reusing `commit` for a consensus step will quietly confuse every reader who crosses between the two. One name, one meaning.
- **Imagine the name outside the code**, in a document or a conversation. A noun often serves better than an adjective or a participle, because it travels directly into prose. Compare `replica.pipeline` with `replica.preparing`: the noun reads straight into a section header, while the participle needs rephrasing. Nouns also compose cleanly into derived names like `config.pipeline_max`.
- **Use named arguments** through the `options: struct` pattern whenever arguments could be mixed up. A function taking two `u64` values wants an options struct. When an argument can be `null`, name it so the meaning of `null` is clear at the call site. Thread singleton dependencies like an allocator or a tracer through constructors positionally, from the most general to the most specific.
- **Write commit messages that inform and delight** the reader, because people truly read your commit messages. A pull request description lives outside the repository and stays invisible to `git blame`, so it never replaces a commit message.
- **Say why.** Code alone is not documentation. Use comments to explain why you wrote the code as you did. Show your workings.
- **Say how.** When you write a test, open it with a short note on the goal and the method, so a reader can get up to speed or skip ahead without diving into every line.
- **Write comments as sentences** — a space after the slash, a capital letter, and a full stop, or a colon when they introduce what follows. Comments are well-written prose about the code. A comment trailing the end of a line may be a phrase, with no punctuation.

### Comments in the Radiant Voice

A comment is prose living inside code, so it answers to both disciplines at once: TAME governs the code around it, and Radiant Style governs the words themselves. The two agree more than they differ — TAME already asks for well-written prose that says why — and where Radiant Style adds its grain, let the comments carry it.

- **Lead with what is.** State what the code does and why it is so, plainly and affirmatively, rather than opening with what it avoids. A comment is a small gift to the next reader; begin it with the thing itself.
- **Say why, in a complete sentence.** The most valuable comment explains intent, trade-off, or a constraint the code cannot show on its own. Prefer a whole sentence that lands over a clipped fragment, except for the brief phrase trailing a line.
- **Favor the lighter word.** Reach for "rather than" in place of a heavy "not," and "yet" in place of "but," when the contrast is real. Reserve plain negation for where it is the essential point — a safety note, an invariant stated as what must never happen.
- **Let an assertion speak when it can.** Where a blatantly true assertion documents a surprising, critical condition more strongly than a sentence would, prefer the assertion; it is prose that is also checked.
- **Skip the narration.** A comment that merely restates the obvious code earns no place. Comment the reasons, the surprises, and the workings — never the line that already speaks for itself.

Read a comment aloud, the way we read everything we mean to keep. If it flows and feels generous, it belongs; the code is the better for a voice that matches the project's own.

### Cache Invalidation

- **Avoid duplicating variables or aliasing them.** Fewer copies means less chance the state drifts out of sync.
- **Pass large values as `*const`.** When you mean an argument to stay un-copied, and its type runs beyond 16 bytes, take it as `*const`. This catches the bug where a caller quietly copies onto the stack before the call.
- **Build larger structs in place**, by passing an out-pointer during initialization. In-place construction assumes pointer stability and immovable types while sparing the intermediate copy-moves that grow the stack. Keep in mind that in-place initialization is viral: once any field initializes in place, the whole containing struct does too.

```zig
fn init(target: *LargeStruct) !void {
  target.* = .{
    // in-place initialization.
  };
}

fn main() !void {
  var target: LargeStruct = undefined;
  try target.init();
}
```

- **Shrink the scope** to keep the fewest variables in play, which lowers the odds the wrong one is reached for.
- **Compute and check variables close to where they are used.** Bring a variable in only when it earns its place, and let it go once its work is done. This shrinks the gap between a check and its use — and most bugs hide in exactly that gap, the semantic distance opened by time or space.
- **Stay alert to buffer bleeds** — the buffer underflow, opposite of an overflow, where a buffer goes under-filled and its padding is left un-zeroed. Beyond leaking sensitive bytes, this can break the deterministic guarantees Rye depends on.
- **Group allocation and deallocation with newlines** — a blank line before the allocation and another after the matching `defer` — so a leak becomes easy to spot.

### Off-By-One Errors

- **Treat `index`, `count`, and `size` as distinct types**, even though all three are primitive integers, with clear rules for crossing between them. An `index` is 0-based and a `count` is 1-based, so moving from index to count adds one. Moving from a count to a size multiplies by the unit. This is one more reason units and qualifiers belong in the name.
- **Show your intent around division.** Reach for `@divExact()`, `@divFloor()`, or `div_ceil()` to tell the reader you have thought through where rounding might enter.

### Style By the Numbers

- **Run `zig fmt`.**
- **Indent with 4 spaces**, rather than 2 — the wider indent is plainer to the eye at a distance.
- **Hold every line to 100 columns**, without exception, for a good typographic measure. Use the width fully, and stay within it, so nothing hides behind a horizontal scrollbar. Let a column ruler help. To wrap a signature, call, or structure, add a trailing comma and let `zig fmt` do the rest. The number 100 is physical too: just enough to set two copies of the code side by side on screen.
- **Brace your `if` statements**, except when they fit on a single line — for consistency, and as defense in depth against the "goto fail;" family of bugs.

### Dependencies

Rye keeps a **zero dependencies** policy, apart from the Zig toolchain. Dependencies tend, over time, toward supply-chain risk, safety and performance cost, and slow installs. For foundational infrastructure, that cost echoes through everything built on top.

### Tooling

Tools carry costs too. A small, standard toolbox is simpler to operate than a drawer of specialized instruments, each with its own manual. Our primary tool is Zig. It fits nearly every task, and serves the rest well enough, so we invest in our Zig tooling to tackle new problems quickly with little accidental complexity.

> The right tool is often the one already in our hands. A new tool costs more than it first appears, so we reach for the familiar one and grow fluent with it.

So the next time you reach for a script, write `scripts/*.zig` rather than `scripts/*.sh`. A Zig script is cross-platform and portable, type-safe, and far more likely to run the same for everyone on the team than a script that meets a Bash or OS-specific snag. Standardizing on Zig keeps our dimensionality low as the team and its range of tastes grow. It may feel slower for you today, and it makes the whole team faster tomorrow.

---

## The Last Stage

At the end of the day: keep trying things, have fun, and remember — it is called TAME Guidance because the code stays calm and gentle, and because gentleness, held with discipline, is its own kind of strength.

> Our adventures and escapes were never managed by luck alone, and never for our sake alone. We are fine and capable, and we are small fellows in a wide and wonderful world. For that, we are thankful, and we laugh, and we get back to the work.

---

*May our code be safe, and swift, and a pleasure to read. May the limits we set keep us free. May every name endure, every assertion hold, and every reader who comes after find the work clear, kind, and built to last.*
