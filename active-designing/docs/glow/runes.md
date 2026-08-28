# The Glow Rune Reference

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Mixed -- every **deep** entry (✦) below was written against its module source read whole in the workshop (rounds 1-3), with claims traceable to the STOA ledger; every **seed** entry (◌) restates the working pin ([`glow/README.md`](../../../glow/README.md)) and ledger ([`docs/STOA.md`](../../../docs/STOA.md)) -- none remain at v2. Anchors follow [`ANCHORS.md`](ANCHORS.md).
**Voice:** Quin (workshop)
**Audience:** a careful beginner writing their first Glow, and any LLM asked to help them

---

Glow is Grain's language: Hoon's runes carried over bounded, asserted, TAME-disciplined semantics, lowering to ordinary Rye and from there to Zig. A rune is two ASCII characters that open a form. The desk under [`glow/gen/`](../../../glow/gen/) holds over three hundred real fixtures and generators you can run today, filed by first letter (`ls glow/gen` counts them truer than any number written here); begin with [`primer.md`](primer.md) if this is your first hour, and [`00_inventory.md`](00_inventory.md) for the census.

<a id="gd-entry-shape"></a>
## How to Read an Entry

Each entry gives the digraph and spoken name, the **Shape** (the exact form the parser accepts today -- Glow's parsers are deliberately narrow, one proven shape at a time, and each module's own comment names what it does *not* claim), the **Refusals** (named errors at the boundary -- Glow refuses loudly where the mistake was made, never three calls downstream), a runnable **Desk**, and the **Source** thread. ✦ deep - ◌ seed with its round promise.

<a id="gd-truth"></a>
## Truth Comes First

Glow's ambient truth is Zig's: `bool`, ordinary `if`, exit `0` for success. Nock's loobean (atom `0` = yes) lives only at an explicit interop seam -- [`truth_semantics.rye`](../../../glow/truth_semantics.rye)'s `loob_to_bool`/`bool_to_loob`, refusing any atom past `1` as `MalformedLoobean`. Welcome paths exit `0`; unwelcome, `1`.

<a id="gd-auras"></a>
## Auras and Shapes, in One Breath

An **aura** names an atom's width and reading: `@u8` `@u16` `@u32` `@u64`, `@t` bounded cord (ceiling 1024), `@ux` hex. A **shape** is Glow's living word for stated structure -- `+$` names one, `$:` states one-to-nine fields, `$%` tags variants -- with *mold* kept as the Hoon-study word. The admitted field auras live as **data in one place** (`admitted_shape_auras`, four entries), so widening the language is a table row, never a scattered edit. Nest questions resolve in [`nest_type.rye`](../../../glow/nest_type.rye), accept and refuse both asserted.

---

## The Cell Family -- `:` Builds Structure

<a id="g-cell"></a>
### ✦ `:-` cell -- the pair

**Shape:** `:-  left  right` -- two bare faces exactly. **Refusals:** `NotACell` - `MissingLeft` - `MissingRight` - `FaceTooLong` (64) - `MalformedFace` (never leads with a digit) - `TrailingJunk` -- a third word refuses, because a pair means *two*. Fills a `CellSpec` of NUL-padded fixed buffers: bounds-on-everything made visible. **Desk:** STOA2 family. **Source:** [`rune_cell.rye`](../../../glow/rune_cell.rye):`parse` - [`lower_cell.rye`](../../../glow/lower_cell.rye).

<a id="g-triple"></a>
### ✦ `:+` triple - <a id="g-quad"></a>`:^` quad - <a id="g-list"></a>`:~` list

**Shapes:** `:+  from  amount  note` - `:^  from  amount  note  tag` - `:~  from  amount  note` (one to four faces). The refusal ladders name each missing seat -- `MissingFirst`...`MissingFourth` -- with `TrailingJunk` guarding the top of triple and quad, and the list bounding as `TooManyFaces` at four: arity is meaning, and every seat has a name. **STOA3-5.** **Source:** [`rune_triple.rye`](../../../glow/rune_triple.rye) - [`rune_quad.rye`](../../../glow/rune_quad.rye) - [`rune_list.rye`](../../../glow/rune_list.rye).

## The Call Family -- `%` Applies

<a id="g-call"></a>
### ✦ `%-` call -- one argument

**Shape:** `%-  double  amount` -- gate, then one argument face, against a closed demo set. That line beside its `::` comment is the *entire* fixture [`gen/call-one.glow`](../../../glow/gen/call-one.glow) -- a desk is honestly small. **STOA6.** **Source:** [`rune_call.rye`](../../../glow/rune_call.rye) - [`lower_call.rye`](../../../glow/lower_call.rye) - [`tools/g/glow_run_desk_witness.rish`](../../../tools/g/glow_run_desk_witness.rish).

<a id="g-call2"></a>
### ✦ `%+` two-arg - <a id="g-call3"></a>`%^` three-arg - <a id="g-calln"></a>`%*` named-arg

**Shapes:** `%+  add  from  amount` - `%^  sum  from  amount  note` - `%*  mix  left  right` (exactly two named faces today), each against its closed demo gate. Shared refusals: `MissingGate` - `MissingSample`/`MissingName` - `ExtraTail` - `NameTooLong` - `MalformedName`. **STOA7-9.** **Source:** [`rune_call2.rye`](../../../glow/rune_call2.rye) - [`rune_call3.rye`](../../../glow/rune_call3.rye) - [`rune_calln.rye`](../../../glow/rune_calln.rye).

## Casts and Shapes -- `^` and `$` State Intent

<a id="g-cast"></a>
### ✦ `^-` cast -- say the shape at the boundary

**Shape:** `^-  @u32` or a named shape. Extracts the shape name only -- the module's own comment refuses to smuggle a general expression grammar in through a cast. **Refusals:** `NotACast` - `MissingMold` - `MoldTooLong` - `MoldNotAnAura` (a leading digit could never name a shape, so the slip refuses *here*). Covers the width auras, cord, hex, and named-cast twins across desks (STOA77-82 - 176 - 182). **Source:** [`rune_cast.rye`](../../../glow/rune_cast.rye):`parse` - [`lower_cast.rye`](../../../glow/lower_cast.rye) - [`lower_named_cast.rye`](../../../glow/lower_named_cast.rye).

<a id="g-shape"></a>
### ✦ `+$` name a shape - `$:` state fields - `$%` tag variants

**Shape** (a real desk, [`gen/shape-amount.glow`](../../../glow/gen/s/shape-amount.glow), whole):

```
+$  amount-shape
  $:  amount=@u32
  ==
```

`$:` admits one to **nine** fields (`max_fields: u32 = 9`, the capacity freeze of STOA147), each `face=aura` from the admitted table (`@u32` - `@t` - `@ux` - `@u64`). `$%` builds a tagged union of cold atoms -- unit payload `[%tag ~]` or one-to-three payload faces across two-to-three tags, per the header's own worked example, `%mint`/`%send`. STOA97 rebuilt this parser **token-first**: `tokenize` -> walk the stream -> `ShapeSpec`, retiring byte-level line surgery -- the shape system is where Glow's front end grew up. The living Grain desks lead with `*-shape` names; `*-mold` twins stay siloed Hoon study. **Ledger:** STOA74-97 - 122-126 - 134-147 - 161-176 - 187-190. **Source:** [`rune_shape.rye`](../../../glow/rune_shape.rye) (header read whole; body pass round 3) - [`lower_shape.rye`](../../../glow/lower_shape.rye).

## The Tests -- `?` Asks

<a id="g-conditional"></a>
### ✦ `?:` if -- the test comes first

**Shape:** `?:  (gth tick 32)` -- the test child only, cut at the first whitespace *outside parentheses*, with a real depth counter: an unbalanced `)` refuses as `MalformedTest`, an empty `()` refuses, a bare identifier is welcome, a leading digit is refused. Then/else arms are left to their own lap, and the module says so. **Refusals:** `NotAnIf` - `MissingTest` - `TestTooLong` (96) - `MalformedTest`. **Source:** [`rune_conditional.rye`](../../../glow/rune_conditional.rye):`parse`.

<a id="g-switch"></a>
### ✦ `?-` switch - <a id="g-null"></a>`?~` null-test

**Shapes:** `?-  kind.cur-record` -- the exhaustive switch over a cold-atom-tagged subject, front half extracting the subject wing (dotted paths welcome); the module's own comment promises that *a later compiler refuses a missing arm* -- exhaustiveness is the seated intent, arms are a coming lap. `?~  records.cur` -- the null test's subject, then/else arms later. Refusals: `NotASwitch`/`NotANullTest` - `MissingSubject` - `SubjectTooLong` - `MalformedSubject`. **Source:** [`rune_switch.rye`](../../../glow/rune_switch.rye) - [`rune_null.rye`](../../../glow/rune_null.rye).

<a id="g-assert"></a>
### ✦ `?>` assert-true - `?<` assert-false

**Shape:** `?>  (gth tick 32)  1` -- Hoon's wutgar/wutgal parallels, lowered to ordinary Rye `assert` (STOA88). TAME's first habit -- the design written where the machine can check it -- as a first-class rune pair, positive and negative space arriving together. **Source:** [`lower_assert.rye`](../../../glow/lower_assert.rye) - desk [`gen/assert-true.glow`](../../../glow/gen/assert-true.glow).

## The Binds -- `=` Holds

<a id="g-face"></a>
### ✦ `=/` face -- a typed let

**Shape:** `=/  next-root=@u32` - `=/  cur-record=record` - `=/  tick` (bare, shape implicit). The parser reads the *clause* only -- face, optional `=`, optional shape -- and never the bound value; the mold side keeps the cast's rule (aura or named shape, never digit-led), and every character of both halves is checked against the identifier alphabet. **Refusals:** `NotAFace` - `MissingFace` - `FaceTooLong` - `MalformedFace`. `=/` also serves as the one optional **payload line** inside a `|%` core, where a typed payload is `@u32`-only today and anything else refuses as `AuraNotYetLowered` -- honesty about the frontier, spelled as an error name. **Source:** [`rune_face.rye`](../../../glow/rune_face.rye):`parse`.

<a id="g-mutate"></a>
### ✦ `=.` mutate - <a id="g-alias"></a>`=*` alias

**Shapes:** `=.  root` -- mutate one leg, the wing extracted, the new value another parser's day (optional trailing decimals accepted per the pin). `=*  records` -- alias, no copy, the last of the three binding siblings (`=/` let - `=.` mutate - `=*` alias), optional source wing accepted. Refusals: `NotAMutate`/`NotAnAlias` - `MissingWing`/`MissingFace` - `*TooLong` - `Malformed*`. **Source:** [`rune_mutate.rye`](../../../glow/rune_mutate.rye) - [`rune_alias.rye`](../../../glow/rune_alias.rye).

## The Cores -- `|` Builds Engines

<a id="g-trap"></a>
### ✦ `|-` bounded trap -- the loop that states its ceiling

**Shape:** `|-  32` -- the smallest Glow generator, whole ([`gen/bound-tick.glow`](../../../glow/gen/bound-tick.glow)): a trap with a **literal ceiling**, lowered to `run_bounded`, refusing past its bound with `BoundExceeded`. Where Hoon's trap recurses on faith, Glow's arrives already wearing TAME's bound: the ceiling is part of the form. Under `|-`, `(lent ...)` emits a shrinking-list fold under `face.len`. **Source:** [`rune_bounded_trap.rye`](../../../glow/rune_bounded_trap.rye) - [`lower_trap.rye`](../../../glow/lower_trap.rye).

<a id="g-bartis"></a>
### ✦ `|=` bartis -- the gate

**Shape:** two lines -- header `|=  sample=@u32` (or `sample=<named>-shape`), then a body: the **identity** face, or a **call** `%-  <gate>  <sample-face>` against the closed demo set (`double` - `inc` - `dec` - `flip`). The parse is fully token-driven -- skip newlines - `|=` - ident - `=` - aura-or-named-shape - newline - body - trailing newlines only -- and the module's header is itself a ledger, forty-plus STOA lines from STOA100 to STOA330 recording every widening. Three boundary laws worth learning from: the sample shape must **nest** (`nest_type.assert_aura_nests` / `assert_bartis_named_shape`, refusing as `SampleDoesNotNest`); a call body's argument must be *the sample face itself* (`BodySampleMismatch` otherwise -- no silent capture of a stranger); and an unknown gate refuses as `BodyGateNotYetLowered` -- the frontier named, never faked. The named-shape allowlist runs `amount`->`nona` (nine fields), plus the tagged `kind`/`xact`/`xfer` -- every entry a STOA seat. Twelve refusals in all, `EmptySource` through `BadToken`. **Desks:** identity, call bodies, argv generators (`gate-sample-u32.glow`, STOA101), tagged flips through STOA327. **Source:** [`rune_shop_gate.rye`](../../../glow/rune_shop_gate.rye):`parse_source` - [`lower_shop_gate.rye`](../../../glow/lower_shop_gate.rye) - [`tools/g/glow_lower_shop_gate_witness.rish`](../../../tools/g/glow_lower_shop_gate_witness.rish).

<a id="g-barket"></a>
### ✦ `|^` barket -- the gate with a helper core

The **27th digraph** (STOA111), tokenized, parsed, and lowered along the same ladder as bartis -- header-only (STOA112), identity (STOA113), call bodies (STOA115-116), the full named-shape allowlist, and one distinction of its own: barket passes `is_nesting=true` through the nesting-nests seam under stated shapes (STOA121/130), where bartis states the no-op. Header read whole; body pass shares round 3 with bartis's lower half. **Source:** [`rune_shop_nest.rye`](../../../glow/rune_shop_nest.rye) - [`lower_shop_nest.rye`](../../../glow/lower_shop_nest.rye).

<a id="g-core"></a>
### ✦ `|%` core -- arms on a spine

**Shape:** `|%` - optional one `=/` payload line (bare `face  <decimal>` or typed `face=@u32  <decimal>`) - one to **three** `++` arms - `--`. A closed arm is a bare name; an open arm carries a body expression -- `sample` or the payload face, a literal, `(mix ...)` - `(jam ...)` - `(lent ...)` - `(cue ...)` - a `^-` cast, one-deep nest jams left/right/both -- and every face inside an open body is checked against the core's own scope (`BadBodyFace` otherwise): an arm may speak only of what the core actually holds. Order is law: `PayloadAfterArm` refuses a payload below the first arm; `TooManyPayloads`, `TooManyArms` name the bounds. Sixteen refusals in all. **Desk** ([`gen/core-double.glow`](../../../glow/gen/core-double.glow), whole): `|%` / `++  double` / `--`. **Ledger:** STOA14-27. **Source:** [`rune_core.rye`](../../../glow/rune_core.rye):`parse_source` - [`lower_core.rye`](../../../glow/lower_core.rye) - [`lower_compose_core*.rye`](../../../glow/lower_compose_core.rye).

<a id="g-lib"></a>
### ✦ `/+` library compose -- the import

**Shape:** `/+  <stem>` as a desk's first line brings a library desk's core into scope by stem name; the canonical two-line consumer is `/+ <stem>` then `^- <mold>`, recognized whole at the token level by `cross_desk_parts` (see [machine-reading](machine-reading.md#gm-dispatch)). The `use-lib-*` consumer desks pair with `lib-*` emitters (which export arms and carry no `main`), across open, nest, payload, and cue-of-jam variants -- STOA31 - 57-70. **Source:** [`glow/tokens.rye`](../../../glow/tokens.rye):`cross_desk_parts` - [`lower_compose_lib.rye`](../../../glow/lower_compose_lib.rye).

---

<a id="gd-desk"></a>
## Running a Desk

```bash
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/bound-tick.glow      # a fixture
rishi/bin/rishi run tools/g/glow_run.rish glow/gen/sample-u32.glow 42   # a generator, argv
rishi/bin/rishi run tools/g/glow_run_desk_witness.rish                  # the whole desk, GREEN
```

A fixture bakes its sample; a generator reads argv through Rishi's hand. Welcome exits `0`; the shell stays the hand that runs it.

---

## Gratitude close

With warmth and respect we thank the **Urbit** community and the Hoon tradition for the runes themselves -- the digraphs, their spoken names (bartis, barket, wutgar, wutgal, and kin), the desk word, and the mold idea we study under its own name -- borrowed with gratitude into a system that gives them bounded, asserted, Zig-ambient semantics of its own. The study twins stay siloed under `gen/hoon-study/`; the mapping into Grain is ours to keep honest.

---

*May every rune refuse at its own boundary, may every frontier wear its honest error name, and may the Book and the code keep holding hands.*
