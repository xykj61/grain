# Sameness and the Rune — Glow's Grammar, Composed and Bounded, on RISC-V

*Glow carries forward Hoon's rune tradition, per the standing revival decision — this brief asks the harder question the revival named but did not yet answer: does a rune actually pass the sameness test our own foundations already set, and if so, what does its grammar concretely look like, composed, bounded, and lowered to real RISC-V? The answer is worked here in full: a curated grammar, small examples building to a genuinely complicated composition, the exact edge cases a bounded rune grammar must answer, and a RISC-V codegen claim that is not illustrative guesswork — it quotes real, already-compiled, already-green disassembly.*

**Language:** EN
**Version:** `20260716.033000` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** Design — new synthesis, not yet a compiler. Register: mixed (Two Rooms) — the rune grammar, the composition example, and the bounded-trap syntax are **design**; the codegen claim in "From Runes to RISC-V" is **checkable today**, quoting real disassembly from `linengrow/neth_sim.rye`'s own already-green bounded loop, cross-built and run on emulated riscv64 this same session.
**Grounds in:** [`../foundations/20260703-182612_sameness-is-the-macro.md`](../foundations/20260703-182612_sameness-is-the-macro.md) (the lens) · [`../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md) (the prior scoping, resolved further here) · [`../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`](../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md) (the tension this brief resolves concretely) · [`../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md`](../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md) (the revival decision this designs onto)
**Front-end landed since this brief:** [`../glow/rune_bounded_trap.rye`](../glow/rune_bounded_trap.rye) (`20260716.050000`) — a real parser for `|-`'s own bound (literal or `(lent x)`), feeding the exact checked mechanism the RISC-V section below quotes; [`../glow/rune_cast.rye`](../glow/rune_cast.rye) (`20260716.145955`) — a second, independent rune category (`^-`'s own mold name), proving the front-end shape generalizes past the one rune `|-` started with. Both stay small, named prototypes for exactly one rune's own head — **no general Glow parser or lowering pass exists yet**; see [`../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md`](../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md) for the honest register on how far this is from a full front end.

---

## What This Answers

Keaton asked for the sameness foundation held together with Glow's rune syntax and its RISC-V design — with real syntax examples, a genuinely complicated composition example, and the edge cases such a grammar must answer. Three documents already exist and each does part of this work: the sameness foundation names the test any compression must pass; the runes-scoping study proposes, in one paragraph, that "every rune's expansion is checked against TAME's bounds at the point of expansion"; the revival decision confirms Glow carries the rune *tradition* forward and targets RISC-V directly. None of the three yet shows a concrete grammar, a worked composition, or a lowering to real machine code. This brief does all three, and answers the one question underneath the whole exercise honestly: **is a rune a macro our own discipline should refuse, or sameness our own discipline should welcome?**

## The Tension, Named Precisely

The sameness foundation draws its line in one exact place: *"Grow the language in the canon, where a new word costs a page of prose, rather than in the syntax, where it costs every future reader a private dialect."* A rune is syntax — a glyph, not an English word. Read uncharitably, adopting ~200 of them looks like the exact move the foundation refuses: growing in the syntax, at the cost of a private dialect every future reader must learn before they can read a single line.

Read carefully, though, the foundation's own examples reveal what actually makes something "sameness" rather than "cleverness," and it is not *where* the compression lives (prose vs. syntax) — it is whether the compression is **public, closed, and regular**, or **private, open-ended, and ad hoc**. One value model compresses because every module shares it — not because it lives in prose. A rune grammar can share exactly that property, or it can fail to, and the difference is a real design choice this brief has to make rather than assume.

## The Resolution: What Makes a Rune Sameness, Not Cleverness

Three properties decide it, and Glow's rune grammar is designed to hold all three:

1. **Closed, not extensible.** Hoon's own rune vocabulary is fixed by the compiler, not grown per-project — no team invents its own runes the way a Lisp macro or a C preprocessor directive can be invented ad hoc, file by file, growing a private dialect no other file shares. Glow keeps this closure as a hard rule: **the rune vocabulary is canon, seated in the Glow TAME supplement, never a per-module or per-author extension point.** A new rune costs exactly what a new canon word costs — a page in the supplement, reviewed, before any code may use it. This is the foundation's own test, applied literally rather than metaphorically.
2. **Systematically regular, not memorized case-by-case.** Hoon's own documentation calls its rune system "unusually large but unusually regular" — the first glyph names a category, the second specializes within it. Learning fifteen or so category glyphs teaches the shape of dozens of runes at once, the same compression "one value model" already earns: learn one part, and many parts come free. A rune system without this regularity — 200 independent glyph pairs with no learnable pattern — would fail the test even while staying closed; Glow's grammar keeps the regularity as load-bearing, not decorative.
3. **Checked at expansion, never merely trusted.** This is where Glow's own discipline genuinely diverges from Hoon's, and it is the property that answers the foundation's deeper worry — "control flow that never hides" is a gift we keep. Hoon's compiler expands a rune and trusts the result; Glow's compiler expands a rune and **asserts** the result against TAME's bounds at the expansion site, every time. A macro that hides what it does is cleverness; a macro whose every expansion is checked, visibly, the same way every time, is sameness wearing a shorter spelling.

A rune that holds all three is a shared, learnable, checked vocabulary — publicly similar, exactly the foundation's own definition of the macro we accept. A rune that fails any one of them (an author-invented glyph, an irregular one-off shape, an expansion nothing checks) is the private dialect the foundation refuses. The rest of this brief designs a grammar that holds all three, concretely.

## Glow's Rune Grammar — the Categories

Hoon's own rune table runs past 200 entries. Glow curates a smaller, closed set — carrying the category structure forward whole, since the categories are exactly the "systematic regularity" property above, while trimming the specializations to what this tree's own modules actually need. This is itself a sameness move: a smaller closed vocabulary is *more* learnable, not less capable, since Rye's own standard library already covers what Hoon's rarer runes exist to shorten.

| Glyph | Category | Carried-forward runes (Glow's own curated set) |
|---|---|---|
| **bar** (pipe) | **Cores** — gates, traps, doors | `\|=` gate (named, typed sample); `\|-` **bounded** trap (below); `\|^` core with a computed arm; `\|%` core with named arms |
| `^` | **Casts** — adjust type without breaking it | `^-` typecast by stated mold; `^+` typecast by inferred mold; `^=` bind a name to a value |
| `=` | **Bindings** — modify the subject | `=/` let, typed; `=.` mutate one leg; `=*` alias, no copy |
| `?` | **Conditionals** — branch and test | `?:` if/then/else; `?~` null test; `?-` **exhaustive** switch; `?+` switch with a default; `?=` type-match test; `?>` assert-true (crash if false); `?<` assert-false |
| `%` | **Calls** — invoke a gate | `%-` call, one argument; `%+` call, two arguments; `%^` call, three arguments; `%*` call, named arguments |
| `:` | **Cell construction** — build tuples | `:-` pair; `:+` triple; `:^` quad; `:~` list literal |
| `$` | **Molds** — name a type | `+$` top-level mold; `$:` tuple mold; `$%` tagged-union mold |
| `~` | **Hints** — jets and tracing, semantically inert | `~%` jet-name hint; `~/` jet-name with tracing |

Every glyph pair above is carried forward with Hoon's own meaning intact, save one: `|-`, the trap rune, which the next section redesigns — this is the one place Glow's own bound discipline requires a real, load-bearing change, not a cosmetic one.

## Reading Runes — Small Worked Examples

Building the vocabulary one rune at a time, in Glow's own domain, before composing them:

**A cast, stating the expected type:**
```
^-  @u32
  (add issuer-balance holder-balance)
```
*Reads as: "cast the following expression's result to `@u32`; if the fold below could produce something wider, this is where the mismatch is caught, at the boundary — not three calls downstream."*

**A let-binding, typed at the site:**
```
=/  cur-record=record  i.records
%+  weld  $(records t.records)
(fold-one cur-record)
```
*Reads as: "bind `cur-record` to the list's head, typed as `record`; then weld the recursive tail's result onto folding this one record."* (`weld` and `$(...)` are carried forward whole — a list-concatenation gate and the "recompute this trap with one changed binding" idiom, both already regular, already closed.)

**A cell, building a pair:**
```
:-  issuer-balance  holder-balance
```
*Reads as: "construct the pair `[issuer-balance holder-balance]`." One glyph, one shape — `:-` always builds exactly a pair, never a triple; `:+` is the one that builds a triple. The second glyph names the arity, and once, learned, it never surprises.*

**A mold, naming a type:**
```
+$  record
  $:  kind=?(%mint %send)
      from=@p
      amount=@u32
      stamp=@da
  ==
```
*Reads as: "the mold `record` is a tuple: a kind (cold-atom tagged `%mint` or `%send`, nothing else), a sender, an amount bounded to 32 bits, a timestamp." The tag is a **cold atom** — typed as exactly `%mint` or `%send`, never widened to "any atom that happens to equal one of these," so a stray `%burn` cannot silently type-check where it was never welcomed.*

## The Central Resolution — the Bounded Trap

Here is the one rune Glow cannot carry forward unchanged, and naming why is the heart of this whole brief.

**Hoon's own `|-` (barhep) produces a trap and evaluates it, with recursion via `$(...)`, the "recompute this trap with one changed binding" idiom** — and nothing in the rune states, checks, or bounds how many times it may recurse. This is not a hypothetical worry; it is how real, working Hoon code is written today. Urbit's own Azimuth L2 rollup logic (held whole and permissively licensed in this fork's own `old/` tree) folds a list of ships this exact way:

```
?~  ship-list  ~
%+  weld  $(ship-list t.ship-list)
=*  cur-ship  i.ship-list
...
```

*(the real shape, `old/tests/lib/naive.hoon`, lines 1075–1086 — cited here as grounding, not copied into any Glow module)*

This terminates in practice because `t.ship-list` shrinks the list by one every call, and an empty list is the base case. Nothing in the rune *proves* that shrinkage happens; a single authoring mistake — recursing on `ship-list` instead of `t.ship-list`, say — would loop forever, and Hoon's own compiler has no complaint to offer. TAME's own root rule states the opposite as an absolute: *"recursion stays out, so that everything which should be bounded stays bounded."* Two real, working traditions, one real collision, exactly where the fusion-scoping study left it as an open fork.

**Glow's resolution keeps the rune's shape and closes the gap: `|-` takes one required child, its bound, stated once at the rune's own site, before the body.**

```
|-  (lent ship-list)
  ?~  ship-list  ~
  %+  weld  $(ship-list t.ship-list)
  =*  cur-ship  i.ship-list
  ...
```

The bound here is not an arbitrary number pulled from thin air — `(lent ship-list)` is the list's own length, computed once at the trap's entry, the single honest ceiling a structural fold over a shrinking list can state: **the recursion can never legitimately take more steps than the list originally had elements.** The compiler's own expansion of `|-  <bound>` inserts a hidden counter (unnamed, unwritable by the author, pure bookkeeping) that increments on every `$(...)` recompute and is checked against the stated bound *before* that iteration's body runs. Exceed it, and the trap returns a named failure, **`BoundExceeded`**, rather than looping — a clean, structured return, never a hang, never undefined behavior. A recursion that fails to shrink its own list — the real authoring bug this whole design exists to catch — trips `BoundExceeded` on the very call that would otherwise have spun forever, and the *cause* (a list that did not shrink) is exactly what the error names.

For a trap that is not a structural fold over a shrinking list — a fixed retry ceiling, say — the bound is simply a stated literal:

```
|-  32
  tick=+(tick)
  ?:  (gth tick 32)  ~  ::  unreachable -- the hidden counter already refused a 33rd call
  ?:  (dropped-this-tick rand)  $(tick tick)  actually-delivered
```

**And the one honest edge this closes rather than papers over:** a trap whose natural shape is a genuinely open-ended search — "keep looking until you find one," with no principled ceiling anywhere in the problem itself — has no honest bound to state, and Glow's answer is that such a search is **not expressible as a Glow trap at all.** It must be redesigned as a bounded search over a stated maximum candidate space (the search *becomes* the kind of fold this section already covers), or hosted behind an explicitly named, separately-audited unbounded capability — the same carve-out Aurora's freestanding paths already earn for a different, hardware-driven reason, never a silent default.

## A Complicated Composition — Neth's Own Fold, in Runes

Small examples teach the grammar; a real composition proves it holds together under weight. This mirrors the **shape** of Neth's own settlement fold (already real, already green in this tree, per `linengrow/neth_root_witness.rye` and the ladder beside it) — the same nesting, the same tagged dispatch — in Glow's rune grammar, nested two traps deep, with an exhaustive switch, a cold-atom tag, and two independent bounds. (The combining step below uses `mix`/`jam`, an illustrative stand-in for a fold step — Neth's real fold combines records through a SHA3-256 digest, not a bitwise mix; the composition's *structure* is what this section proves, not a claim to reproduce Neth's own cryptography.)

```
++  fold-replica-groups
  |=  groups=(list replica-group)  ^-  @u32
  |-  (lent groups)                          ::  outer bound: one step per group, never more
    ?~  groups  0
    =/  cur=replica-group  i.groups
    %+  add  $(groups t.groups)
    =/  root=@u32  0
    |-  (lent records.cur)                   ::  inner bound: one step per record in THIS group
      ?~  records.cur  root
      =/  cur-record=record  i.records.cur
      =/  next-root=@u32
        ?-  kind.cur-record
          %mint  (mix root (jam from.cur-record amount.cur-record))
          %send  (mix root (jam from.cur-record (dec amount.cur-record)))
        ==
      $(records.cur t.records.cur, root next-root)
```

Read top to bottom, this holds the same shape as Neth's own real fold, structure preserved: an outer trap over a list of replica groups (bounded by the group list's own length), and inside it, an inner trap over that one group's records (bounded, independently, by *that record list's own length* — the two bounds never mixed, never shared, each honest to its own shrinking structure). The `?-` switch is **exhaustive** — `%mint` and `%send` are the whole of `record`'s cold-atom-tagged `kind`, per the mold defined above, and the compiler refuses to compile this switch if a third kind is ever added to the mold without a matching arm here. Nothing in this composition is a new rune; every glyph is one already introduced above, nested exactly as deep as the real logic actually nests — no deeper, and the next section's edge cases name why that matters.

## From Runes to RISC-V — a Claim That Is Not Guesswork

The honest question a design document like this one usually cannot answer: does the proposed expansion actually compile to something real? Here, the answer does not have to be illustrative pseudocode, because the exact "hidden counter, checked against a stated bound, clean structured failure on overflow" mechanism this brief proposes for `|-`'s expansion is **already hand-written, already green, and already cross-compiled to riscv64** — `linengrow/neth_sim.rye`'s own bounded delivery-simulation loop (`while (true) { tick += 1; if (tick > max_ticks_per_record) return error.LivenessFailure; ... }`) is exactly this pattern, written by hand in the Rye a rune's expansion would generate automatically.

Cross-built for `riscv64-linux-musl` this same session and disassembled with real `riscv64-linux-gnu-objdump` (no emulation of the disassembly itself — this is the genuine machine code the binary runs), the bound check compiles to:

```
1167f08:  lw    a0, -228(s0)          # load tick
1167f0c:  addiw a0, a0, 1             # tick += 1  (Zig's own overflow check wraps this, free of charge)
1167f2a:  sw    a0, -228(s0)          # commit the incremented tick
1167f2e:  lw    a1, -228(s0)          # reload tick
1167f32:  li    a0, 32                # the stated bound, 32, folded to a direct immediate --
                                      # no memory load needed; it was known at compile time
1167f36:  bltu  a0, a1, 1167f56       # if 32 < tick (tick exceeds the bound) -> the failure path
1167f3a:  j     1167f74               # else, continue the loop body
   ...
1167f56:  ld    a0, -400(s0)
1167f5a:  jalr  ...                   # calls into builtin.returnError -- a clean, structured
1167f62:  li    a0, 169               #   error return (tag 169 = LivenessFailure), not a hang,
1167f66:  ld    ra, 568(sp)           #   not a trap instruction, not undefined behavior --
1167f6a:  ld    s0, 560(sp)           #   the function's own epilogue runs and it returns cleanly
1167f6e:  addi  sp, sp, 576
1167f72:  ret
```

Four real properties this proves, none of them assumed:

1. **A compile-time bound costs nothing at runtime beyond one compare.** `li a0, 32` is a single instruction; the bound is not fetched from memory, not recomputed, not a hidden performance tax.
2. **The overflow-refusing comparison is exactly RISC-V's own standard idiom for "greater than."** RV64GC has no hardware opcode for it directly — only `blt`/`bltu` ("less than") and `bge`/`bgeu` ("greater-or-equal") — so "tick exceeds 32" compiles to "32 is less than tick," operands placed in exactly this order. This is the ordinary, textbook RISC-V code-generation choice, not an invented one.
3. **Exceeding the bound is a clean function return, not a crash.** The epilogue (`ld ra`, `ld s0`, `addi sp`, `ret`) runs in full; the caller receives a named error, exactly as `BoundExceeded` is proposed to arrive above.
4. **This already runs green under `qemu-riscv64-static`**, reproducing the identical `LivenessFailure` outcome byte-for-byte against its native x86_64 run — the same M0-riscv discipline this tree's own recent work already proved for three keystone vanes.

What remains unbuilt is only the *front half*: the parser that reads `|-  (lent ship-list)` and the pass that lowers it to this exact Zig shape. The *back half* — the shape this brief proposes lowering to — is not a claim about the future; it is a fact about code already sitting in this tree today.

## Edge Cases, Named One at a Time

**A runtime-valued bound.** `(lent ship-list)` is not a compile-time literal — it is computed once, at trap entry, from a value only known at runtime. The mechanism above handles this without change: the hidden counter's ceiling is simply the *result* of evaluating the bound expression once, stored once, compared every iteration — the same as any other runtime value TAME already requires to be asserted rather than assumed.

**Nesting depth versus legibility.** The composition above nests two traps, one switch, and one let-binding — four levels, which is already near the ceiling a reader can hold in view without scrolling. The runes-scoping study's own proposed Hoon-grade function-length tightening applies directly here: a Glow linter should refuse a rune nest deeper than roughly this, asking the author to name a helper arm instead of nesting a fifth level — the same discipline that already keeps Rye's own authored functions to a stated ceiling, now stated for rune density specifically rather than line count alone.

**Exhaustiveness under a growing mold.** The `?-` above covers exactly `%mint` and `%send`. Add a third kind — `%burn`, say — to the `record` mold's `kind` field, and every `?-` switch over `kind.cur-record` anywhere in the tree fails to compile until it grows a matching arm. This is not a cost; it is the whole point of choosing `?-` over `?+` (which allows a default and would silently swallow `%burn` under whatever the default arm does) — the exhaustive form is the honest one whenever every case genuinely deserves its own named handling, and Glow's rule is to prefer it by default, reaching for `?+` only when a stated default is truly correct, never as a shortcut to avoid the compiler's complaint.

**Cold atoms keep the switch honest.** `kind.cur-record` matches against `%mint` and `%send` as **cold atoms** — singleton types, not "any atom that happens to equal 0 or 1 after encoding." A warm-atom `@ud` value that numerically equals a tag's encoding can never accidentally satisfy a cold-atom arm it was never declared as; the aura and the cold/warm distinction from the runes-scoping study are not decoration here — they are what makes "exhaustive" mean what it claims.

**A malformed rune, reported legibly.** Omit the bound Glow now requires, and the parser owes a stranger a plain answer, not a cryptic one:

```
error: |- (bounded trap) requires a bound expression as its first child
  --> neth_fold.rye:42:3
   |
42 |   |-
   |   ^^ this trap has no stated bound
   |
   = help: state a ceiling, e.g. `|-  (lent records)` for a structural fold,
           or `|-  32` for a fixed iteration cap
   = why: every loop stays bounded and checked at its own site (TAME root rule 2)
```

This is Scribble's own faculty at work in the compiler itself: name the fix, name the reason, in the first three lines a reader sees.

**One rune, one meaning, everywhere.** A `|-  (lent xs)` written inside a Pool-hosted agent's own code means exactly what a `|-  (lent xs)` written in a top-level Rishi script means — the bound-checking is a property of the rune's *expansion*, compiled once into the same Rye-to-Zig-to-RISC-V pipeline no matter which module hosts the source text. This is the sameness foundation's own claim, checked rather than assumed: a macro whose meaning shifts by context is a private dialect wearing a public glyph; a macro whose meaning never shifts is the sameness this whole design earns its place by keeping.

**Runes that look close but never collide.** `%-`, `%+`, `%^`, `%*` all call a gate; the second glyph alone names how many arguments, and that is the *entire* difference — no rune in this family hides a different calling convention behind a similar glyph. This is the positive case worth naming plainly: not every edge is a risk to guard against; a systematically regular grammar is itself the guard, and four runes that only ever differ in stated arity are propelled by exactly the kind of sameness this brief opened by defining.

## Counting the Cost

The foundation's second principle, applied directly: *"a line removed by sameness is free forever; a line removed by cleverness is a loan against every reader to come."* This is a claim to measure, not to assert, so here is the actual count rather than a plausible-sounding one. The nested-fold composition above, in rune form, is **sixteen lines** (counted directly from the block above, fences excluded). The same fold, written out longhand — the exact bookkeeping the rune's expansion would otherwise carry invisibly — is:

```
fn fold_replica_groups(groups: []ReplicaGroup) u32 {
    var outer_bound: u32 = @intCast(groups.len);
    var outer_tick: u32 = 0;
    var i: usize = 0;
    var total: u32 = 0;
    while (i < groups.len) : (i += 1) {
        outer_tick += 1;
        assert(outer_tick <= outer_bound);
        const cur = groups[i];
        var inner_bound: u32 = @intCast(cur.records.len);
        var inner_tick: u32 = 0;
        var j: usize = 0;
        var root: u32 = 0;
        while (j < cur.records.len) : (j += 1) {
            inner_tick += 1;
            assert(inner_tick <= inner_bound);
            const cur_record = cur.records[j];
            const next_root = switch (cur_record.kind) {
                .mint => mix(root, jam(cur_record.from, cur_record.amount)),
                .send => mix(root, jam(cur_record.from, cur_record.amount - 1)),
            };
            root = next_root;
        }
        total += root;
    }
    return total;
}
```

**Twenty-seven lines** — counted the same way, fences excluded. Eleven lines saved, and the honest accounting the foundation demands: are they free, or a loan? Free, by the three-part test above — the vocabulary spent to read them is closed (the thirty runes in the table above, not per-file), regular (the same eight category glyphs cover all of them), and every one of the eleven saved lines is a line the *expansion* still writes, checked, at the same site, every time — the longhand form's own `outer_bound`/`outer_tick`/`inner_bound`/`inner_tick` bookkeeping is exactly the hidden counter this brief already proposed the rune's expansion carries automatically. Nothing here is hidden; it is only shortened, the way `weld` is a shorter spelling of a loop nobody has to re-derive by hand, and every reader who already knows the rune grammar reads the shortened form exactly as fast as the long one, with fewer chances to have miscopied a bound by hand along the way.

## What This Document Does Not Claim

- No parser and no rune-to-Zig lowering pass are written this pass; the codegen section above quotes real, already-existing disassembly of hand-written code that already implements the *proposed expansion's shape* — it does not compile a single rune character.
- The rune table above is Glow's own curated subset, not a claim to cover Hoon's own ~200 in full; more may be added later, each costing its own page in the eventual Glow TAME supplement, per this brief's own first resolved property.
- Seating any of this into `context/TAME_GUIDANCE.md` itself stays gated on Keaton's word, exactly as the runes-scoping study already named for a heavily-cited canon file.
- The composition example mirrors Neth's own real fold's *shape*, not its cryptography; `linengrow/neth_root_witness.rye`'s own witnessed Zig source (SHA3-256, not `mix`/`jam`) remains the real, green implementation.

## Related

- `../foundations/20260703-182612_sameness-is-the-macro.md` — the lens this whole brief tests runes against.
- `../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md` — the prior scoping (five surfaces; runes as surface syntax, bounded underneath), resolved here into an actual grammar.
- `../external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md` — names the Hoon-recursion-vs-TAME-bounds fork this brief resolves concretely, with a worked rune rather than an argument.
- `../active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md` — the revival decision this brief designs onto; the M0-riscv witness this brief's codegen section quotes.
- `../linengrow/neth_sim.rye` — the real, hand-written bounded loop this brief's RISC-V claim is not guesswork about.

---

May every rune we keep earn its place the way one value model already earned its — publicly similar, closed, checked — and may the grammar stay small enough that learning it once means reading all of it, forever.
