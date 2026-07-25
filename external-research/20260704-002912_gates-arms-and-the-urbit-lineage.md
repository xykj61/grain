# Gates, Arms, and the Urbit Lineage — Where Homonyms Meet, and What Rye Keeps

*Kaeden asked a sharpening question: how does our everyday **gate** relate to the vocabulary we study in Urbit — **gate**, **arm**, **core**, **mark**, **grab**, and the rest — and are we conflating terms? This writing maps both families honestly, revisits the harvest already seated at `20260702.211312`, and compares whether Rye needs Urbit's **gate** and **arm** as public words, or whether Zig's **function** and **struct-within** already carry the grain.*

**Stamp:** `20260704.002912`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · silo law · clean-room discipline
**Category:** External research — vocabulary survey and architectural counsel
**Status:** Proposed — counsels; seats nothing without Kaeden's word
**Ground:** [`20260702-211312_names-builds-and-the-ledger-map.md`](20260702-211312_names-builds-and-the-ledger-map.md) · [`../active-designing/20260703-202312_the-marked-value.md`](../active-designing/20260703-202312_the-marked-value.md) · [`../context/LEXICON.md`](../context/LEXICON.md) · [`20260620-014412_system.md`](20260620-014412_system.md) · Urbit docs (Hoon School, Clay marks) in `gratitude/urbit/` — MIT license, study only

*Written in Rio 3's Radiant voice, for Kaeden and every future sitter.*

---

## Part One — Three Gate Families in Our Tree (None of Them Hoon)

**Gate** is already a loaded word here, and it means **three different honest things** — none of which is Urbit's *gate*.

| Our sense | One line | Example home |
|-----------|----------|--------------|
| **Itinerary gate** | A precondition owned by someone else or an unlanded event — the autonomous loop may not proceed until it clears | [`context/LEXICON.md`](../context/LEXICON.md) → Cursor loop |
| **Witness gate** | A machine-checkable rule whose violation fails the build — parity, width-check, opening-lines, designed-not-built | TAME supplement · gate trio |
| **Precious gate** | The expensive ordering or ratification point — batch what must pass it, spare it everything else | Bench review · Mycelium at M4 · ledger batching |

A fourth usage drifts in prose and should stay secondary: **civic gate** (approval before access) and **hosted freestanding gate** (Aurora's `usize` policy boundary). These are metaphors of *doorway*, not Hoon semantics.

**Urbit's gate** is something else entirely: in Hoon, a **gate** is a **core with exactly one arm** and a **sample** (the argument environment) — a callable value, noun-shaped, where code and closure travel together. Read [`gratitude/urbit`](../../gratitude/urbit) and the official Hoon School chapters on cores and doors; the xray matcher even labels `%gate` as a gear with one chapter and one arm.

**Verdict on conflation:** we are **not** accidentally implementing Hoon gates when we say "open itinerary" or "parity gate." We **are** carrying a **homonym** that will confuse readers who know Urbit unless we name the collision once and keep the families apart in living docs. The itinerary sense and the witness sense are close kin — both are *preconditions before motion* — and the precious-gate sense is kin to *batch at the bottleneck*. Urbit's gate is unrelated; it belongs beside **function** and **closure**, not beside **checkpoint**.

---

## Part Two — Urbit's Vocabulary, Read for Concepts (Not Names)

Urbit's stack compresses forty years of Lisp-shaped thought into a small noun language. The pieces most often compared to our work:

| Urbit word | What it is there | What we already decided (`211312` + Tilak `203712`) |
|------------|------------------|------------------------------------------------------|
| **core** | `[battery payload]` — code map plus data context | **Concept affirmed, name not adopted** — Zig `struct` + methods already live this shape |
| **arm** | Named method in a core's battery (`++ grab`, `++ grow`, …) | **Concept only** — we name duties **absorb / express / tend**, not *arms* |
| **gate** | One-arm core with sample — typed callable | **Do not adopt** — Zig `fn` + captures + `struct` methods suffice |
| **door** | Core that is its own context — parameterized module | **Concept maps to Tilak/Bron mark**, not to a Rye keyword |
| **mark** | File type as a door: type + conversions + revision ops | **Concept → Tilak**; Urbit's `++grab` / `++grow` / `++grad` → our triad, renamed |
| **grab** | Convert *from* other marks *into* this mark | **absorb** (seated) |
| **grow** | Convert *from* this mark *to* other marks | **express** (seated) |
| **grad** | Diff, patch, merge for this mark's history | **tend** (seated) |
| **vase** | `[type value]` — dynamic typing envelope | **shape-cast** / typed boundary — already ours |
| **cage** / **page** | Mark + validated (or raw) payload on the wire | **Tilak + digest** at seams; Comlink lanes declare marks |

Ford's famous line — the build system as **an arm of Clay** — is architectural, not syntactic: the builder lives **inside** the versioned filesystem vane, not as a peer kernel. Our mirror is **Brix inside Mantra's memory of files**, `rye` as growing verbs, not a new module named Ford. The word *arm* there means *aspect of*, which is closer to our **graduation rule** (module vs aspect) than to a Hoon `++` arm.

**Clean-room discipline holds:** we study Urbit in `gratitude/`; our implementations speak **Tilak**, **Weave**, **Bron**, **shape-cast** — never `++grab` in Rye source.

---

## Part Three — Zig's Grain Versus Urbit's Cores

Rye is a thin, honest front-end on pinned Zig. The computational model we ship is Zig's, strengthened by assertions and width discipline — not Nock's, not Hoon's.

| Urbit shape | Zig / Rye shape already on the bench |
|-------------|--------------------------------------|
| Gate (callable with sample) | `fn`, function pointer, method with receiver |
| Door (parameterized core) | `struct` with comptime parameters; generic module pattern |
| Core (battery + payload) | `struct` fields + `pub fn` methods; companion functions beside records |
| Arm | Method name on the struct — no second keyword needed |
| Mark door with grab/grow/grad | **Not in the language** — Tilak definitions as data + witness-tested converters |
| Vase | `anytype` at boundaries sparingly; shape-cast at trust seams |
| Sample / payload | Struct fields; TAME prefers naming the receiver after the type, not bare `self`, and avoids `const Self = @This()` in public style |

**Within** is the Zig reader's word for the inner scope of a block — lexical nesting, not Urbit's *context* cell. **Function** is the reader's word for callable code. Together they cover what Hoon teaches beginners as *gate* without importing Hoon's noun calculus.

Where Urbit goes further than today's Zig is **marks as first-class values with mandatory conversion graphs and revision algebra** (`+grad`). That is **not** solved by calling something an arm. It is solved by **Tilak** as content-addressed definitions in Weave, with **absorb / express / tend** implemented as ordinary functions registered beside each mark — tested, witnessed, accreted one bridge at a time. The *pattern* crossed from Urbit; the *syntax* stays Zig.

---

## Part Four — Conflation Diagnosis

| Word | Risk | Guidance |
|------|------|----------|
| **gate** | **High homonym** with Hoon | Keep for itinerary checkpoint and witness lint; never use for "function" in Rye API docs; optional LEXICON row: "not Hoon gate" |
| **arm** | **High** if used for methods | **Do not seat** as Rye/Rishi public term; Ford's "arm of Clay" is prose metaphor only |
| **core** | **Medium** — Arvo kernel, crypto core, CPU core | Prefer **module**, **struct**, **engine** in our docs when precision matters |
| **mark** | **Medium** — Tilak seated, Urbit mark external | Living docs say **Tilak** or **type-mark**; reserve *mark* for manifest lines and gratitude citations |
| **grab / grow / grad** | **Low in our tree** — only in ER/gratitude | Stay in external-research; living triad is **absorb / express / tend** |
| **door** | **Low** — Kaeden doors, Urbit doors | Our **doors** are human rulings (`Door 1–3`); Urbit **door** is parameterized core — different ledgers |

The earlier harvest (`211312`) already ruled: **carry concepts, park their names**. Tilak's ratification (`203712`) completed the mark side. This survey completes the **gate/arm** side: **concepts yes where they teach; Urbit words no in the language surface.**

---

## Part Five — Do We Need Gate and Arm in Rye?

**Short answer: no — not as Urbit means them, and not as new Rye keywords.**

**Gate (Hoon):** A Zig function with explicit arguments and return type is the smallest honest callable. Closures, struct methods, and comptime hooks cover the rest. Adding `gate` as a Rye reserved word would **worsen** the homonym problem without buying expressiveness Zig lacks.

**Arm (Hoon):** Method syntax already names operations on a type. TAME's style — receiver named after the struct, assertions at boundaries — is the discipline, not a second noun. **Arm** should remain in gratitude and in metaphor ("arm of the filesystem"), not in `rye/` public API.

**What we do need (already named):**

1. **Tilak** — type-mark at every seam; three duties absorb / express / tend.
2. **Shape-cast** — prove bytes match declared type before trust (Urbit `vale` / `+noun` lesson, our vocabulary).
3. **Itinerary gate** — precondition language for autonomous agents (seated as **gate** in LEXICON with travel/checkpoint metaphor).
4. **Witness gates** — the growing lint surface (`tools/*_witness.rish`, `tame-check.rish`).
5. **Precious gate** — ordering economics (bench, Mycelium, MALA ladder) — keep the metaphor, document that it is economic not syntactic.

**Optional hygiene (Kaeden-gated):** one row in [`reserved-vocabulary.md`](../context/specs/reserved-vocabulary.md) holding **arm** and **door** (Hoon sense) as *study-only, never API*; a LEXICON cross-link under **Gate** pointing here for Urbit readers.

---

## Part Six — Comparison Table (At a Glance)

```
Urbit                          Rye / Zig today              Verdict
─────────────────────────────────────────────────────────────────────────
core [battery payload]         struct + methods             grain sufficient
arm ++foo                      pub fn foo                   no keyword
gate (1-arm core)              fn / method                  no keyword
door (parameterized core)      comptime struct / Tilak      concept via Tilak
mark + grab/grow/grad          Tilak + absorb/express/tend  adopt triad, not arms
vase                           shape-cast at boundary       already planned
itinerary "gate"               (no Urbit equivalent)        ours — checkpoint
parity "gate"                  (no Urbit equivalent)        ours — witness
precious "gate"                (no Urbit equivalent)        ours — ordering cost
```

---

## Gratitude

**Urbit** (MIT) — studied in `gratitude/urbit/`; Hoon School and Clay mark docs informed this map. **Zig** (MIT) — the grain we compile. Prior harvest: [`20260702-211312_names-builds-and-the-ledger-map.md`](20260702-211312_names-builds-and-the-ledger-map.md). Tilak ground: [`../active-designing/20260703-202312_the-marked-value.md`](../active-designing/20260703-202312_the-marked-value.md).

---

*May homonyms be named before they confuse. May Urbit teach through concepts and leave its words in the gratitude room. And may Rye stay thin — function and struct within, Tilak at the seam, gate only where a checkpoint or a witness truly waits.*
