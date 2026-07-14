# Subject-Oriented Programming and the Rye Core — Urbit's Context Lesson Applied

*Kaeden asked for a writing on Urbit's philosophy of **subject-oriented programming** — studied from public docs and the gratitude tree — and how that philosophy sharpens the Rye core research and the siloed shell pattern at `211012`. This survey names Urbit's model honestly, maps what transfers as discipline, and keeps Nock's noun calculus in gratitude rather than in Zig.*

**Stamp:** `20260704.214100` · **Last updated:** `20260704.215012`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME · SLC · TWO_ROOMS
**Category:** External research — philosophical survey; proposes refinements only; seats nothing
**Status:** Proposed — Urbit context discipline seated in silo companion; archive lap wears `preview` / `fold` on metal
**Ground:** [Urbit — Why Hoon?](https://docs.urbit.org/hoon/why-hoon) · [Hoon School — Subject-Oriented Programming](https://docs.urbit.org/build-on-urbit/hoon-school/o-subject) · [Hoon School — Cores](https://docs.urbit.org/build-on-urbit/hoon-school/f-cores) · [`20260704-211012_rye-cores-and-the-gratitude-lineage.md`](20260704-211012_rye-cores-and-the-gratitude-lineage.md) · [`../active-designing/20260704-211012_the-rye-core-and-the-shell.md`](../active-designing/20260704-211012_the-rye-core-and-the-shell.md) · [`20260704-002912_gates-arms-and-the-urbit-lineage.md`](20260704-002912_gates-arms-and-the-urbit-lineage.md)

*Written in Rio 3's Radiant voice, for Kaeden and every future sitter.*

---

## Part One — What Urbit Means by Subject-Oriented Programming

Urbit's Hoon docs name **subject-oriented programming** as a first-class paradigm — not a slogan, a compile-time and runtime contract.

**The subject is the whole context.** Every Hoon expression evaluates relative to a **subject**: a noun (binary tree) that holds everything in scope — compiler, standard library stack, local bindings, and the data a computation needs. There is **no implicit environment**. The subject serves simultaneously as **state**, **lexical scope**, **compile-time environment**, and **function argument** ([Why Hoon?](https://docs.urbit.org/hoon/why-hoon)).

**Cores marry code and context.** Almost everything nontrivial in Hoon is a **core** — a cell `[battery payload]` where the **battery** is the code map (arms) and the **payload** is the data context (sample, legs, nested context). An **arm** is always evaluated with its **parent core as the subject** — the guarantee that sibling arms see the same payload and can refer to each other through the battery head ([Cores](https://docs.urbit.org/build-on-urbit/hoon-school/f-cores), [Subject module](https://docs.urbit.org/build-on-urbit/hoon-school/o-subject)).

**Subject horizon is composed, not global.** Cores stack with `=>` (tisgar) and `=<` (tisgal): the product of an inner core becomes part of the outer core's context. An arm in the outer core can call an arm in the inner core when the inner core sits in the outer payload — **subject horizon** is directional. `+bar` may call `+foo` when `foo`'s core is in `bar`'s context; the reverse fails with `-find` ([Subject module — `hoon.hoon` walkthrough](https://docs.urbit.org/build-on-urbit/hoon-school/o-subject)).

**Imperative feel, functional law.** Hoon is purely functional: running the same formula on the same subject yields the same product. Yet many runes **mutate a copy** of the subject for downstream runes — Forth-like stack discipline — so programming *feels* like updating an environment while the mathematics stay immutable ([Why Hoon?](https://docs.urbit.org/hoon/why-hoon)).

**Types are scopes.** Everything about a scope — bindings, aliases, docstrings — lives in the **subject's type**. The compiler is a function from **subject type + source** to **product type + Nock formula**. Running that formula against a value of the subject type yields a **vase** `[type value]` ([Why Hoon?](https://docs.urbit.org/hoon/why-hoon)).

**The Arvo stack is recursive compilation.** The kernel compiles with the Hoon compiler as subject; Zuse compiles with Arvo as subject; apps and vanes compile with Zuse as subject — each layer's **subject** is the layer below, bootstrapped upward ([Why Hoon?](https://docs.urbit.org/hoon/why-hoon)).

**Scry is read-only context lookup.** Subject-oriented programming also governs **how state is observed without mutation**: `+peek` and the `.^` (dotket) scry path read the referentially-transparent namespace; `+poke` carries effects. Deferred computation chains through `;` (mic) runes; direct subject replacement uses `%=` (centis) and the `=` (tis) family ([Subject module](https://docs.urbit.org/build-on-urbit/hoon-school/o-subject)).

Three motives Urbit names for choosing this model: **minimalism** (one context carrier), **compilation simplicity** (subject type fully specifies the environment), and **ergonomics** (imperative surface on functional bedrock).

---

## Part Two — The Rye Core Pattern, Read Through the Subject Lens

Our [`211012`](20260704-211012_rye-cores-and-the-gratitude-lineage.md) lap law — **core proves, shell witnesses** — is already subject-shaped. Urbit's vocabulary makes the shape explicit.

### The core is a bounded subject

A **Rye core** is not Urbit's `%core` noun. It is our name for the smallest **typed, testable body** whose **public context is explicit**:

| Urbit subject piece | Rye core reading |
|----------------------|------------------|
| Payload (data legs) | Struct fields, `init.garden`, fixture paths passed into `selftest` |
| Battery (arms) | `pub fn` methods and free functions beside the struct |
| Parent core as subject | Methods receive the struct; tests construct a known subject value |
| No implicit environment | No hidden globals; `std.process.Init` with explicit `io` + `garden` |

The discipline Urbit enforces by noun structure, we enforce by **TAME width law** and **assert at seams**: if it is not in the struct or the init block, it is not in the subject.

### Selftest is evaluation in a sandbox subject

Urbit evaluates every arm against its parent core. Our **`selftest`** subcommand is the same contract at lap grain:

- Build a **fixture subject** — sandbox directory, fake clock, test vectors.
- Run the core's public surface against that subject **without** the witness suite.
- Exit code or stdout carries the product.

The witness is not the subject of the core's logic — it is an **outer core** that holds the built binary and the bench paths in *its* payload, then calls inward. Separation vow from the silo: business logic lives in the core exactly once.

### Subject horizon — what the shell may see

Urbit's `=>` composition defines **who can call whom**. Our horizon law:

| Inner (visible to) | Outer (orchestrator) | Horizon rule |
|--------------------|----------------------|--------------|
| Core algorithms | Rishi shell | Shell calls `selftest`; core never imports `parity.rish` |
| `selftest` | Witness | Witness re-runs; core never asserts GREEN for parity |
| Witness | `parity.rish` | Parity lists witnesses; witnesses do not list each other |
| Core | Pond / enclosure policy | Core returns bytes; Pond applies policy at receipt |

A core that reaches for parity counts or README rows has **broken horizon** — the `-find.bar` error in our dialect is a witness that imports business logic.

### Battery / payload and control / data

Urbit's core cell is the ancestor of our **control-before-data** vow:

- **Battery** — what may run (verify signature, parse manifest, fold paths).
- **Payload** — what it runs on (bytes, digests, directory listings).

Comlink's resin-batch counsel maps cleanly: **header** verified once (battery duty on a small subject); **resins** prove by digest (payload legs). The signed manifest is not re-parsed per resin — same separation as a vane's `+poke` accepting a cage versus `+peek` returning a read-only scry.

### Poke and peek at witness grain

Urbit separates **mutation** (`+poke`) from **read-only scry** (`+peek`). Our silo already vows **read vs mutate** witnesses:

| Urbit habit | Our witness split |
|-------------|-------------------|
| `+poke` — change the world | `session_logs_archive` fold; `slcl1_receipt` append |
| `+peek` — observe without write | `preview` subcommand; verify-only paths; parity read checks |
| Scry path `/vane/care/case/spur` | Declared Brix inputs + content keys — no timestamp inference |

Zip-42 counsel sharpened this: **replay-on-host** (peek-shaped) before **boot-shaped replay** (poke-shaped). Subject-oriented programming does not allow one witness to silently do both.

### The Arvo stack and our lap ladder

Urbit compiles each layer with the prior layer as subject. Our **growth law** is the same recursion with different names:

```
Urbit stack                 Our lap ladder
────────────────────────────────────────────────────
Hoon compiler as subject    Seed (`*.rye` one claim)
Arvo kernel as subject      Core + unit tests + selftest
Zuse as subject             Witness (`*_witness.rish`)
App / vane as subject       Parity wire + module home
```

Each graduation **widens the subject** the next layer may assume — yet the inner layers stay buildable alone. You can compile Zuse's arms against Arvo without Gall; you can run `session_logs_archive` `selftest` without `parity.rish`.

### Types as scopes — Tilak at the seam

Urbit stores scope in **subject type**. We store scope in **Tilak** and **shape-cast**:

- A manifest line is not "a string" — it is a **typed subject** with three fields; damaged lines refuse whole.
- Crossing seams cast bytes to declared marks before trust — the vase lesson without dynamic `!>` everywhere.
- The compiler discipline Urbit achieves through subject type, we achieve through **witness-tested converters** (absorb / express / tend) registered beside each mark.

### Imperative feel, functional proof

Urbit copies the subject to feel mutable. Rye copies **sandbox trees** and **fixture READMEs** in `selftest`, then the witness runs on **real metal** — two evaluations, same formula, different subjects. Idempotency is the functional law: second fold `moved=0` when the world is already true.

---

## Part Three — What We Adopt, What We Refuse

| Urbit lesson | Adopt as discipline | Refuse as surface |
|--------------|----------------------|-------------------|
| Explicit subject, no implicit env | Explicit init, declared Brix inputs, no hidden globals | Single global Urbit subject noun |
| Parent core as subject | Struct + methods; fixture subject in tests | `%core` keyword |
| Subject horizon (`=>`) | Shell/core/parity layering; one-way visibility | Hoon `tisgar` syntax |
| Poke vs peek | Separate mutation and read-only witnesses | Unified "do everything" scripts |
| Types as scopes | Tilak + shape-cast at seams | Vase at every boundary |
| Recursive stack compilation | Seed → core → witness → parity → module | Nock bootstrapping |
| Scry namespace | Content-keyed Weave reads; `preview` entry points | Ambient `.^` into live state |
| Mutant copy discipline | Sandbox selftest then metal witness | Pretending host I/O is pure |

**Homonym guard** (from [`002912`](20260704-002912_gates-arms-and-the-urbit-lineage.md)): **subject**, **core**, **arm**, **gate**, and **scry** stay in gratitude and external-research. Living Rye source speaks **struct**, **witness**, **selftest**, **Tilak**.

---

## Part Four — Sharpening the Silo (Seated)

These refinements are **seated** in [`../active-designing/20260704-211012_the-rye-core-and-the-shell.md`](../active-designing/20260704-211012_the-rye-core-and-the-shell.md) as of `20260704.215012` — concepts only, gratitude names stripped:

**1. Name the subject explicitly in core APIs.** Prefer a struct that carries paths, clocks, and gardens over scattered `argv` parsing in `main`. The entry subject should be constructible in tests and in the witness.

**2. Document horizon in each lap README row.** One line: what the core may assume; what only the shell provides; what parity pins. Urbit's `-find` errors become review failures when a core imports a witness.

**3. Split peek-shaped and poke-shaped entry points.** `preview`, `verify-only`, and `fold` are separate subcommands or witnesses — seated on archive lap 2026-07-04.

**4. Selftest constructs the smallest true subject.** Fixtures are not "mock helpers" floating outside the core; they are **payload legs** the battery expects — same spirit as Urbit's `[sample context]` cell.

**5. Parity is the compiled app layer.** Wire witnesses only after red-then-green — the outermost subject that may claim GREEN for the whole bench.

---

## Part Five — Worked Example — Session Archive Fold

| Urbit concept | Session archive lap |
|---------------|---------------------|
| Core `[battery payload]` | `session_logs_archive.rye` — fold logic + `DayRoot` paths in struct |
| Arm evaluated on parent | `foldSessionLogs`, `rewriteReadmeLink` called with archive root in subject |
| `selftest` subject | `tools/fixtures/session_logs_archive/` — minimal tree, not production `session-logs/` |
| Outer witness subject | Built binary path + repo root; witness does not reimplement link algebra |
| Poke | `fold` moves files and rewrites README |
| Peek | `preview` reports `moved=N` without `git mv` |
| Idempotent product | Second fold `moved=0` — same formula, subject already folded |
| Horizon | Core never calls `parity.rish`; witness never parses log headers |

---

## Part Six — Comparison at a Glance

```
Urbit SOP                    Rye core + shell (211012)
──────────────────────────────────────────────────────────────────
subject noun                 explicit struct + init + gardens
core [battery payload]       .rye struct + pub fn + selftest
arm on parent core           method / function on typed receiver
=> subject horizon           shell → core → (no upward imports)
compiler(subject, src)       Zig compile + witness runs selftest
vase [type value]            shape-cast / Tilak at seams
+poke / +peek                mutation witness vs read-only witness
Arvo stack layers            seed → core → witness → parity
scry .^ path                 Brix inputs + Weave content keys
mutant copy of subject       fixture sandbox, then metal run
```

---

## Gratitude

| Source | License | What we studied |
|--------|---------|-----------------|
| **Urbit / Hoon docs** | MIT · public web | Subject-oriented programming, cores, subject horizon, poke/peek, scry, Arvo compilation stack |
| **Urbit** (`gratitude/urbit/`) | MIT | `hoon.hoon` nesting, vane patterns — study only |
| Prior surveys | — | [`211012`](20260704-211012_rye-cores-and-the-gratitude-lineage.md) · [`002912`](20260704-002912_gates-arms-and-the-urbit-lineage.md) |

Concepts entered through the clean room. Implementations stay in `rye/`, `rishi/`, `tools/`. Urbit's words remain in the library.

---

*May every core know its subject — explicit, bounded, testable alone. May every shell respect the horizon and call inward. May read and mutate stay in separate rooms. And may Urbit's philosophy teach through comparison while Rye keeps Zig's grain and Tilak's marks at the seam.*
