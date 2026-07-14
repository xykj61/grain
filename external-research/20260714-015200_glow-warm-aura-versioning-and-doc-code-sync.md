# Glow's Warm-Aura Datetime, and Docs-as-Claims — One Idea From Spec-ulation, Applied Twice

**Language:** EN
**Version:** `20260714.015200` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Design and research — no code, no aura seated; extends `../context/specs/rye-versioning-style.md` and root rule 9 toward Glow. Register: this is design (Two Rooms — a proposal, not a bound claim). Addressed to a generic Acme Corporation employee.
**Builds on:** `../gratitude/Spec_ulation.md` (Rich Hickey), `../context/specs/rye-versioning-style.md`, `20260714-013700_aurora-vere-arvo-boot-fusion-and-kelvin-strategy.md`, `../context/TAME_GUIDANCE.md` root rule 9

---

## The One Idea, and Where It Lands Twice

Rich Hickey's *Spec-ulation* has a single load-bearing idea beneath its rant: **"change" is not one thing — it is either growth or breakage.** You grow by *accreting* (providing more, requiring less) and by keeping names enduring; you break by requiring more, providing less, or reusing a name for something else. The whole talk is that one distinction, drawn through functions, namespaces, artifacts, versioning, and web services.

This document applies that one idea to two places it has not yet been drawn through in this tree: **how Glow tells time (its version datetime), and how Glow keeps its docs honest (root rule 9).** Both turn out to be the same idea wearing Hoon's clothing — which is why they belong in one document rather than two.

---

## The Two Clocks That Pull Apart

This fork already made one versioning decision, deliberately, and now inherits a second one by fusing with Urbit. They pull in opposite directions, and pretending they do not would be its own small dishonesty.

**The chronological clock (already decided).** `../context/specs/rye-versioning-style.md` chose, from *Spec-ulation* directly, to version by `YYYYMMDD.HHMMSS` on one world clock — counting **up**, later-is-larger, growing only by accretion, never by a breaking major bump. A version is a moment; the name above it (Rye, and now Glow) endures like "Maven Central" endures.

**The kelvin clock (inherited from Hoon/Arvo/Zuse).** Urbit's kernel counts **down** toward zero, on purpose. As its own *Stable Arvo* post says plainly, kelvin versioning "doesn't infinitely increase … we decrease the version number on each significant change in the hope that our software will eventually not need to change at all." A lower number is newer; zero is the horizon where the thing *freezes* and never changes again. (Today's landed stable kelvin is **409**; see the aurora/kelvin fusion doc for the live-checked figures.)

One clock grows without end; the other counts down to a final freeze. The temptation is to pick one and suppress the other. The better move is to notice they are describing **two different states of the same value** — and Hoon already has the exact vocabulary for that.

---

## The Insight: Warm and Cold Are Growth and Freeze

Hoon distinguishes a **warm** atom from a **cold** one. A warm atom is typed by its aura but free in its value — it is "a date," and its specific instant may be any value of that aura. A cold atom is a *constant* — a specific frozen value that nests only under exactly itself. (Glow inherits both, per the supplement scoping in `20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`.)

Lay that beside *Spec-ulation*, and the two clocks resolve into one coherent picture:

| Hoon aura state | Spec-ulation motion | Urbit clock | What it is for |
|---|---|---|---|
| **Warm** — typed, free to take any value of its aura | **Growth / accretion** — later is larger, provide more | the chronological `YYYYMMDD.HHMMSS` clock | how a living thing *grows* |
| **Cold** — a frozen constant, nests only under itself | **Freeze / fixation** — the final form that never changes | kelvin counting down to zero | how a stable thing *promises to stop changing* |

Warm is growth. Cold is freeze. Glow needs both — and it needs to keep them **separate and honestly named**, exactly as Two Rooms keeps a vision claim separate from a checkable one.

---

## Glow's Warm-Aura Datetime

The proposal, stated plainly: **Glow's own version stamp is a warm date aura.**

- It is typed as an instant (Hoon's own absolute-date aura `@da` is the natural parent; Glow's warm datetime is that aura, warm rather than frozen).
- Its value is free to take any *later* moment — that is what "warm" buys, and it is exactly the one semantic *Spec-ulation* says to keep: later is larger.
- It grows only by accretion: a new stamp arrives *beside* the old one, never overwriting it — the way `rye-versioning-style.md` already keeps every founding stamp alongside every divergence stamp.
- It carries Hoon's directness (an aura a Hoon reader recognizes on sight) over Rye's chronological discipline (a real instant on one world clock, not a self-relative `4.3`).

This is the "warm aura for date time, adopted from Hoon and Arvo and Zuse for Glow": Glow tells its own time as a **warm** atom because Glow, internally, is a *growing* thing — and a growing thing must never freeze a name it already gave.

## Kelvin as the Cold Pin

Kelvin, then, is not Glow's internal clock — it is a **cold constant Glow declares compatibility against**, at its outer, Urbit-facing seam. A cold atom nests only under its exact value; declaring "Glow interoperates with kelvin 409" is asserting exactly that kind of cold nest — a specific frozen number, checked, not a range.

This is the same conclusion the aurora/kelvin fusion doc reached, now with a cleaner name for *why* it is right: **Glow grows warm on the inside and pins cold at the edge.** Its stdlib accretes on the chronological clock (warm, growing, never breaking a shipped name); its interop declaration names a specific kelvin as a cold constant (frozen, verifiable, revisited only deliberately). The two never contradict because they are two different aura-states doing two different jobs — one for growth, one for the promise to eventually stop.

---

## The Same Idea, Applied to Docs (Root Rule 9)

Root rule 9 — docs and implementation stay synced — is *Spec-ulation*'s idea again, and it wears the same warm/cold aura once you look.

*Spec-ulation*'s sharpest line about dependencies is **"the only truth is runtime"**: a POM's declared version is a *suggestion*; the truth is the classpath that actually resolves and runs. A documentation claim is exactly a POM entry. A doc that says "X does Y" is *declaring a dependency on a behavior* — and that declaration is only a suggestion until a witness actually resolves it on metal.

So docs, too, are warm until they are pinned cold:

- **A doc's behavioral claim is a warm atom** — typed as "true," free to be true or stale, until something binds it. This is the vision room of Two Rooms: a claim named as intent or horizon.
- **A green witness is the cold pin** — it freezes the claim to a specific, checked, this-exact-behavior-now truth. This is the checkable room: a claim a witness binds.
- **Accretion applies to docs, verbatim.** A doc grows by adding a claim beside the old ones; removing or contradicting a shipped claim is breakage, and — per *Spec-ulation* — breakage wants a new name (a new doc, a new page), not a silent in-place rewrite. This is why rule 9 is a ratchet, not a sweep.
- **A doc's cited paths are enduring names.** When a doc cites `tools/foo.rish` as the witness behind a claim, that path *is part of the claim* — and *Spec-ulation*'s whole ethic is that such a name must endure or move deliberately with the thing it names, never silently break. A citation left pointing at something that no longer says what the doc claims is exactly the "unrelated stuff under the same name" breakage Hickey warns against.

Rule 9, then, is not a new rule so much as *Spec-ulation* finally applied to the one artifact this doc-heavy tree produces most: prose. "The only truth is runtime" becomes "the only truth about a doc's claim is a witness that binds it now" — read or run before you cite, and pin cold what you mean to state as fact.

---

## Why One Document, Not Two

The versioning fusion and the doc-sync rule looked like two separate asks. They are one idea seen twice: **grow warm, freeze cold, and never break a name you already gave** — whether the name is a version stamp, a public function, or a claim in a README. Naming them together is itself an act of the discipline they describe: one enduring idea, accreted into a second place, rather than two half-overlapping rules left to drift.

---

## What Remains Open

- Whether Glow's warm datetime aura should parent directly on Hoon's `@da`, or define its own aura letter — a real Glow-supplement design choice, not made here.
- Whether the "cold pin" for kelvin interop is declared once for the whole kernel (Zuse's number, as Urbit's own shorthand does) or per layer (Zuse / Arvo / Lull / Hoon) — the open question the aurora/kelvin doc already named.
- Whether rule 9 eventually earns a *machine* check for warm-vs-cold claims (a doc claim tagged "witnessed by `X`" whose witness is then actually run), or stays the human-and-agent discipline it is today. `living_docs_lint` catches the mechanical half; the behavioral half waits on a proven need before any tool is built for it.

---

*May Glow grow warm where it lives and freeze cold only where it promises to, and may every name it gives — a stamp, a function, a sentence — still mean tomorrow exactly what it meant today.*
