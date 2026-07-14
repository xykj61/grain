# 966 · Brix vs Bron — When to Compose and When to Notate

*Two formats, two purposes, one value model. Brix declares what a system is made of — it is the composition language, the way Nix declares a package set for SixOS and s6. Bron carries values as text — it is the data notation, the way JSON carries data between programs. This research draws the boundary precisely, grounded in how Nix and infuse separate composition from data, and how ZON's token efficiency shapes when Bron earns its place.*

**Language:** EN
**Version:** `20260621.064612` (Rye chronological stamp)
**Last updated:** 2026-06-21
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## The Distinction, Plainly

| | **Brix** | **Bron** |
|---|---------|---------|
| **What it is** | Composition language for Rye OS | Data notation for values |
| **What it declares** | What a system is made of: services, stages, dependencies, policies, build targets | What a value contains: settings, headers, metadata, configuration fields |
| **Analogy** | Nix infuse expression language | JSON / ZON (`.json`, `.zonf`) |
| **File extension** | `.brix` | `.bron` |
| **Evaluated?** | Yes — Brix expressions are evaluated to produce build plans, service trees, composition results | No — Bron is parsed, not evaluated. A `.bron` file is data, not a program. |
| **Has functions?** | Yes (growing toward parameterized declarations, like Nix infuse's parameterized overlays) | No. Bron is key-value. No functions, no expressions, no control flow. |
| **Has dependencies?** | Yes — a Brix declaration names what it depends on. Brix interfaces with Mantra for versioned inputs and targets Aurora/Tally for boot stages and memory budgets. | No. A Bron file is self-contained. |
| **Backed by a store?** | Yes — Brix has its own content-addressed build artifact cache (like Nix's `/nix/store`), currently inside `.mantra/blobs/` | No. Bron is a text format; it has no store. |

---

## What Nix and infuse Teach About the Boundary

### Nix infuse separates expression from data

A Nix infuse file is a **program** — it has functions, let-bindings, conditionals, imports. When evaluated, it produces an **attribute set** — which is data. The attribute set can be serialized to JSON, stored in the Nix store, or passed to a builder.

The lesson: **the composition language evaluates to data.** Brix evaluates to Bron. A `.brix` file is a program that, when run, produces a `.bron`-shaped value — a record of keys and values that names what was composed.

### infuse separates sugar from canonical form

Adam Joseph's infuse accepts syntactic sugar (assignments, overlays) and immediately desugars to a canonical form where every leaf is a function. The canonical form is data-shaped — it composes through monoid operations (identity, associativity).

The lesson: **the composition language has a richer syntax than the data it produces.** Brix may have overlays, parameterization, and imports; the result is always a Bron-shaped record.

### SixOS separates declaration from supervision

SixOS declares services in Nix (what exists) and supervises them with s6 (what runs). The declaration is the plan; the supervision is the execution.

The lesson: **Brix declares what Caravan supervises.** The `.brix` declaration produces a service tree; Caravan reads the tree and starts the services. The service tree itself is a Bron value — keys and values naming what to run, what capabilities to grant, what gardens to bound.

---

## When to Use Brix

Use Brix (`.brix`) when you are **composing a system** — declaring what exists, what depends on what, what to build, what to supervise:

- **System composition** — declaring the services, stages, and dependencies of a Rye OS instance
- **Build targets** — naming the source bricks, their versions, and how they compose (like a Nix infuse derivation)
- **Boot stage declarations** — naming what Aurora loads, in what order, with what Tally budgets
- **Service policies** — declaring what capabilities each Caravan-supervised process receives
- **Project descriptors** — the `.brix` file at the repository root that Mantra reads

A `.brix` file may import other `.brix` files, parameterize declarations, and evaluate expressions. It is a program in the Brix language, not just a data file.

---

## When to Use Bron

Use Bron (`.bron`) when you are **carrying a value as text** — settings, metadata, headers, configuration that is read but not evaluated:

- **Editor settings** — `tab-width 4`, `theme rye-dark`
- **Pond policies** — `mem-mb 4096`, `net false` (the value Caravan reads after Brix produces it)
- **Comlink message headers** — `content-name <hash>`, `sealed true`
- **Forge metadata** — `owner kaeden`, `license MIT`
- **LLM-facing configuration** — project context sent to agents (fewer tokens than JSON)
- **Mantra commit metadata** — `parent <hash>`, `weave <hash>` (already Bron-shaped)

A `.bron` file is parsed, not evaluated. It has no functions, no imports, no expressions. It is data.

---

## The Relationship

```
Brix (composition) ──evaluates──→ Bron (data)
                                    │
                                    ├── Caravan reads it (service tree)
                                    ├── Pond reads it (policy)
                                    ├── Rishi reads it (settings)
                                    ├── Comlink carries it (headers)
                                    └── LLMs read it (context)
```

Brix produces Bron the way Nix infuse produces attribute sets. The composition language is richer; the data notation is simpler. Every module that consumes configuration reads Bron — the universal data format of the family.

---

## Token Efficiency — When Bron Saves Money

ZON demonstrated that format efficiency directly affects LLM costs: 35–50% fewer tokens than JSON for the same data. Bron achieves similar savings through the same design pressure — minimal syntax, no quotes, no braces.

**When token efficiency matters (use Bron):**
- System prompts sent to LLMs on every turn — CLAUDE.md, rules, project context
- Forge API responses — repository metadata served to many clients
- Comlink messages — every byte on the wire costs bandwidth
- Configuration files read by tools — smaller files, faster parsing

**When token efficiency does not matter (use Brix):**
- Build declarations evaluated once at composition time
- Boot stage definitions read once at startup
- Service trees generated once and cached

The rule: **if a value is read many times or sent across a wire, Bron. If a value is evaluated once to produce other values, Brix.**

---

## Why Bron Aligns with Zig and Tiger Style, Not with Clojure

Rich Hickey's EDN (Extensible Data Notation) is the notation that honors Clojure's value model — maps, vectors, sets, keywords, all readable as data. EDN taught us that a notation should match the value model it serves. We carry that lesson forward.

Yet Bron aligns with Zig and Tiger Style rather than with Clojure. Where EDN serves a Lisp — parenthesized, homoiconic, reader-macro-extensible — Bron serves a systems language whose values are explicitly sized, whose assertions guard every boundary, and whose discipline is TAME: safety first, performance second, joy third.

| Design choice | EDN (Clojure) | Bron (Rye) |
|--------------|---------------|------------|
| Syntax | Parenthesized, nested, reader macros | Plain key-value, one field per line, no nesting in the seed |
| Value model | Clojure's persistent data structures | Rye's one value model: string, integer, bool, list, record |
| Extension | Reader macros (`#inst`, `#uuid`) | Reserved — grow by accretion, not by macro |
| Philosophy | Homoiconicity — code is data | Separation — Brix is the code; Bron is the data |
| Alignment | Functional, Lisp tradition | Systems, Tiger Style / TAME discipline |

Bron is simpler than EDN on purpose. A systems notation does not need reader macros or nested maps in its seed form. It needs one field per line, stated types by convention, and a parser smaller than the format specification. The simplicity is earned — the same way Tiger Style says simplicity is the hardest revision.

---

## Sources

- Nix infuse: codeberg.org/amjoseph/infuse.nix — expression language that evaluates to attribute sets
- infuse: codeberg.org/amjoseph/infuse.nix — desugaring and monoid composition
- SixOS: codeberg.org/amjoseph/sixos — declaration (Nix) meets supervision (s6)
- ZON: github.com/ZON-Format/ZON — token-efficient notation for LLM workflows. MIT.
- EDN: github.com/edn-format/edn — Rich Hickey's extensible data notation for Clojure.

All read for concepts. The design decisions are our own.

---

*May Brix declare what the system is made of, and may Bron carry the values that result — each on its own ground, each as plain as its purpose demands. The composition language evaluates; the data notation persists. Both speak the one value model, and neither needs more syntax than the meaning requires.*
