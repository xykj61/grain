# Hoon's Core Variance — Gold, Iron, Lead, Zinc — and What Glow's Rune Vision Should Do With It, Fused with Bron and Brix

**Language:** EN
**Version:** `20260717.003402` (Eastern)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Model:** Cursor Sonnet 5 1M Low
**Co-author:** Keaton Dunsford (`xykj61`)
**Status:** Vision register — design and research; grounded directly in Hoon's own kernel source (`old/pkg/arvo/sys/hoon.hoon`), quoted rather than paraphrased from memory. Register: design (Two Rooms — a proposal, not a bound claim). No Glow code written; no core-variance system seated.

---

## What This Answers

Keaton asked for the fusing unification of three threads at once: Glow's own language design goals, the rune grammar already curated in [`../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md), and Hoon's own **cores**, **arms**, and the "alternate shaped cores with other core attributes" — the four-way variance system Hoon calls **gold**, **iron**, **lead**, and **zinc**. This document answers that by going to the real source first (Hoon's own kernel, vendored whole in this fork's own `old/` tree), quoting the actual type and the actual mechanics, then asking the harder question honestly: does Glow need this system at all, and if so, in what shape — connected concretely to Bron (the data notation) and Brix (the composing language).

## Part 1 — What a Core Actually Is, Grounded in Real Source

A Hoon **core** is a cell of `[battery payload]`. The **battery** is compiled code — a map from axis (tree address) to **arm**, a named computation. The **payload** is data — the **sample** (a gate's argument shape) and the **context** (everything the arms can see). An **arm** is one named entry in the battery: `++ arm-name ...` in source, one computed value at one address once built.

This is not paraphrase — `old/pkg/arvo/sys/hoon.hoon` names the battery directly in its own comments: *"tal: map from battery axis to foot"* and *"produce lazy battery"* (lines 9685, 9688). A gate (Hoon's function) is simply a core with one arm, conventionally named `$`, whose sample is the argument.

## Part 2 — The Four Variances, Quoted from the Kernel

Hoon's own type for a core's variance is a four-way enumeration, defined in one line of `hoon.hoon`:

```hoon
+$  vair  ?(%gold %iron %lead %zinc)                    ::  in/contra/bi/co
```

*(`old/pkg/arvo/sys/hoon.hoon`, line 6646 — quoted verbatim.)* The kernel's own trailing comment already names the correspondence to standard type-theory variance: **gold = invariant, iron = contravariant, lead = bivariant, zinc = covariant.** Each word teaches which direction a substitution is allowed to flow:

| Variance | What it means, plainly | Where the kernel proves it |
|---|---|---|
| **gold** (invariant) | The payload must match exactly — neither reads nor overrides may vary. The strictest, most common case; a plain `|=` gate produces gold by default. | `[%brcn *]  (core sut [p.gen %dry %gold] sut *seminoun q.gen)` — a dry core-building rune (`|%`-family) always starts gold (line 10543, and again at 9984). |
| **iron** (contravariant) | The arms may be called with anything **at least as specific** as the declared sample — you may widen what you accept, never narrow it. Safe when a core's arms only ever **consume** the payload, never expose it back out. | `` `++bake`: "convert wet gate to dry gate" `` and the `%ktbr` rune wraps a core to iron via `++wrap` (lines 10005, 10561, 10932) — "put a stricter reading fence around what may be substituted in." |
| **zinc** (covariant) | The arms may **produce** anything **at least as specific** as declared — safe when a core only ever hands payload data back out, never accepts new input for it. | The dual of iron, same `++wrap` arm, tagged `%zinc` (line 10013, 10564) — "loosen what may come back out." |
| **lead** (bivariant) | No constraint at all — the payload's own shape is opaque; a lead core accepts and produces without any nest check. The most permissive, least safe case. | `` ?- variance %gold - %lead [%ktwt -] ... `` (line 7657-7661) — lead is the deliberate escape hatch, reachable yet never the default. |

The actual compatibility check — "can a core of variance A stand in for a core of variance B" — is a real, working arm named `++nest` and its helper `++peel`, quoted directly:

```hoon
++  peel
  |=  [way=vial met=?(%gold %iron %lead %zinc)]
  ^-  [sam=? con=?]
  ?:  ?=(%gold met)  [& &]
  ?-  way
    %both  [| |]
    %free  [& &]
    %read  [?=(%zinc met) |]
    %rite  [?=(%iron met) |]
  ==
```

*(lines 10525–10534)* — read plainly: a **gold** core always demands both the sample and the context check (`[& &]`), the strictest case. A **read**-only access checks the sample only when the core is **zinc** (`?=(%zinc met)`); a **write**-only access checks it only when the core is **iron** (`?=(%iron met)`) — each named variance switches off exactly the one check its own direction never needed in the first place. This is the actual, running proof that iron and zinc are the *directional relaxations* of gold's full strictness, each earning its own independent name rather than staying two arbitrary extra tags.

## Part 3 — Wet and Dry, a Second, Orthogonal Axis

Separately from variance, a core is also **wet** or **dry**. This is the axis that decides *when* the compiler checks a core's own type — a dry core (`%brcn`, the ordinary `|%`/`|=` family) is checked once, at definition; a wet core (`%brpt`, the `|*` family — Hoon's "generic" or "template" gates) is checked **again at every call site**, against whatever concrete type that call actually supplies. `++bake` is the real, named bridge between them: *"convert wet gate to dry gate by specifying argument mold"* (line 541) — you can always turn a wet, call-site-checked gate into a dry, definition-checked one, by nailing down the one mold it should have been checked against all along.

**Why this matters for Glow, concretely:** wet cores are Hoon's own answer to generic programming without a separate generics syntax — `lent` (list length, quoted in this same file at line 548) works on a list of *any* element type because it is wet; its own arm body is re-type-checked fresh at each call. This is exactly the shape of question Zig's own `comptime` already answers for Glow's substrate, by a completely different mechanism (Zig's generics are compile-time monomorphization, not a runtime-adjacent recheck). The two ideas are the same *problem* — "let one function body serve many concrete types, safely" — solved by two genuinely different mechanisms, and Glow inherits Zig's answer already, for free, underneath whatever rune syntax sits on top.

## Part 4 — Does Glow Need Any of This? Three Honest Options

This is the real design fork Keaton's ask opens, and it deserves three named answers rather than one assumed one.

**Option A — Glow needs none of it.** TAME's own bounded, checked-at-every-site discipline (root rule 2, and the bounded-`|-` rune design already seated) already answers the question core variance exists to answer, from a different direction: Hoon's variance system exists because Hoon lets you build a *hierarchy of cores* (a door within a door within a door) and needs a rule for when one such nested structure may stand in for another. Glow's own modules — Pool, Comlink, Caravan's capability table — are not built this way; they are flat, named Rye/Zig modules composed through Brix bonds, not through nested core substitution. If Glow never grows Hoon's own nested-door idiom, it may never need Hoon's own variance vocabulary either — the problem the vocabulary solves simply would not arise.

**Option B — Glow needs the *idea*, expressed through Rye/Zig's own vocabulary, not Hoon's four words.** Zig's own type system already has a real, structural answer to "can value A stand in for value B" — `anytype` parameters (structurally, Hoon's wet gate, re-checked per call), `comptime` generics (monomorphized, closer to a "bake"), and Zig's own duck-typed structural interfaces. A Glow rune for "this core's payload may only be read, never written, by callers who substitute their own" is expressible today, honestly, as a Zig `const`-qualified pointer parameter — no new rune needed, because Zig's own `const`/mutable pointer distinction is already, structurally, iron-vs-zinc's own read/write asymmetry, just spelled differently. Under this option, Glow's rune grammar gains **documentation and naming** for this existing Zig capability (perhaps a rune-table entry that reads as sugar for a `const`-qualified parameter), never a new runtime mechanism.

**Option C — Glow grows a real, new capability Hoon's variance system names, one Zig's own type system does not yet cleanly express.** The one genuine gap: Zig has no first-class notion of "bivariant, unchecked" (lead) as an *opt-in escape*, named and auditable at the call site the way `%lead` is a visible tag in Hoon source. If Pool's own agent-hosting model ever wants "trust this payload's shape completely, no nest check, and make that trust grep-able," a Glow rune analogous to `%lead` — expanding to an explicit `@ptrCast`/`anyopaque` escape, checked visibly rather than silently — would be a real, new, and honestly motivated addition. This is the only one of the three options that proposes new Glow surface at all, and it stays narrow by design: one rune, one escape hatch, named so its use is always searchable.

**This document's own recommendation: Option A first, Option C only if a real Pool agent ever needs the escape it names.** Nothing here proposes adopting gold/iron/zinc/lead as Glow vocabulary wholesale — the honest reading of Glow's own foundations (sameness is the macro; a rune must be closed, regular, checked at expansion) is that importing four Hoon-specific words for a substitution problem Glow's own module shape may never actually pose would be exactly the "private dialect" the sameness foundation refuses, borrowed from a teacher rather than earned by a real need.

## Part 5 — The Fusion with Brix: Bond Overrides Are Already Asking Core Variance's Own Question

Here is the concrete connection Keaton's ask names, made precise rather than left as a gesture. Brix's own **bond overrides** — the mechanism `context/LEXICON.md` already names as the surviving shape of the retired "Silo" idea — let one module's declared configuration be overridden by another's, composing systems the way Nix's own attribute-set overrides compose derivations. Read plainly, **a bond override is asking exactly the question Hoon's `++nest`/`++peel` answer**: *can the overriding value stand in for the value it replaces, and in which direction — may it only be read where the original was read, only written where the original was written, or fully substituted either way?*

This is not a coincidence of two systems that happen to rhyme; it is the same underlying question (substitutability, checked once or checked always, in one direction or both) arising twice because both systems compose smaller wholes into larger ones and both need an honest rule for when a smaller whole may replace another. **The concrete proposal:** when Brix's own bond-override semantics are next specified in full (not attempted in this document — that is Brix's own spec's job), name the override direction explicitly using the same three real distinctions Part 2 proved out, in Glow's own vocabulary rather than Hoon's: an override that only needs to satisfy what its target *reads* from it (iron's own shape), an override that only needs to satisfy what its target *produces* to callers (zinc's own shape), or an override that must match exactly, both directions (gold's own shape, the safe default). Bivariant/lead-shaped overrides — no check at all — should stay exactly Option C's own narrow, auditable escape, never a bond-override default.

## Part 6 — The Fusion with Bron: Where Variance Does and Does Not Apply

Bron itself — flat key-value text, no braces, no nesting, no code — carries no battery at all; a Bron file is pure payload with no arms attached to it. **Variance, as Hoon defines it, is a property of cores, and Bron values are never cores** — so the honest answer is that Bron itself needs nothing from this whole document. The place the question actually lands is one seam further along: **when Brix reads a Bron value and binds it into a system's own configuration, that binding is a mold check** — is this text, read as this shape, compatible with what the consuming module declared it needs? This is Hoon's own `nest`/`mull` machinery's actual job (proving one type's own shape compatible with another's, quoted in Part 2), simply applied to a Bron-carried value being checked against a Brix-declared mold rather than to one core's payload checked against another's. **The fusion, stated plainly: Bron is the untyped wire; Brix's own mold-checking of a Bron value at the moment it enters a bond is where a Hoon-style nest check belongs, if Glow ever wants one — never inside Bron's own notation, which stays deliberately, permanently untyped.**

## What This Document Does Not Do

- It does not seat gold/iron/lead/zinc, or any Hoon-derived variance vocabulary, into Glow's own rune table — that stays gated on a real, named need arising (per Option A/C above), and on Keaton's own word.
- It does not specify Brix's own bond-override semantics in full — Part 5 names the concrete connection and a proposed vocabulary shape; the actual specification is Brix's own document's job, not this one's.
- It does not change Bron's own notation in any way — Part 6's conclusion is that Bron needs nothing from this thread at all, and names exactly where the real question actually belongs instead.
- It does not claim Zig's own generics or `const`-qualification are a byte-for-byte reimplementation of Hoon's variance system — Option B names them as the closest existing structural analog, honestly, not an exact match.

## Related

- `../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md` — the rune grammar this document holds Hoon's variance system against.
- `../active-designing/yonder/20260621-063912_bron-notation.md` — Bron's own design brief, the ground for Part 6.
- `../context/LEXICON.md` — names Brix's own "bond overrides" as the surviving shape of the retired Silo idea, the ground for Part 5.
- `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` — the wider vane-parallel mapping this document's own Hoon-source reading extends.
- `old/pkg/arvo/sys/hoon.hoon` — every quotation in Parts 1–3 is drawn directly from this file, line-cited, not copied into any Glow module.

---

*May every substitution we ever allow be named honestly for which direction it flows, and may we borrow only the word we actually need, the day a real payload asks for it — never the whole vocabulary, in advance of the question.*
