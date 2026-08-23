# Pattern Two — The Fact Fold

**Stamp:** `20260730.072710` — carried; metal blanks `20260730.081647` · door 8 **GREEN** under j4 `20260730.083821`.
**Voice:** Kyri · nested documentary voice: Trey · **Style:** Radiant · **Discipline:** TAME
**Coords:** equinox A · journey 4 (h4 Accrete-never-break) · door 8 **CLOSED** · round 13/256
**Destination:** `docs-geode/sangha/02-fact-fold.md` — living page, plain spoken name
**Elder sibling:** `docs-geode/sangha/01-descriptor-exchange.md` — the bench conforms this page's headings to pattern one where they differ
**Written from:** `mycelium/fold.rye`, green on metal · design shape `context/design-shapes/fact_fold.brix`

*Written together by Keaton and Riyo.*

---

## What This Pattern Holds

A group of peers needs to agree on a number that changes — how much exists, who holds a place, what has been spent — while trusting each other only as far as signatures reach. The fact fold answers that need with a single discipline: **state is a pure fold over an append-only log of immutable signed facts.** Every peer derives the total. Each peer appends a fact, and every peer computes the same total from the same facts, arriving at agreement through arithmetic rather than through authority.

The pattern earns its place in the book because it composes rather than accumulates. Pattern one carries descriptors between peers; this pattern carries meaning. Once facts travel reliably and identity holds at the seam, the fold turns a stream of signed events into a number every participant can check alone, from the log, on their own.

## The Shape

Three parts stand in the pattern, and each is simple by itself.

**A fact** is immutable, signed, and typed by its kind. It says what happened, once, and never says anything else afterward. Nothing in the system amends a fact; a correction is a new fact referencing the original.

**A log** is append-only. Facts enter at the end and never leave. The log's order is the only history there is, and the same order yields the same reading to every reader.

**A fold** walks the log from its beginning and computes state. The fold holds no memory beyond what the log gave it, reaches for no clock, and consults no outside source. Given a log prefix, the fold's answer is fixed — which is the property that makes agreement possible at all.

## The Invariant

The fold's law reads plainly: **supply equals issued minus taxed**, and it holds at *every prefix* of the log rather than only at the end. The distinction matters more than it first appears. A law checked once at the end can pass while every intermediate state was nonsense. A law asserted at each step turns the fold into its own witness, and the first fact to violate it halts the walk exactly where the fault lives.

Supply stays non-negative at every prefix. A tax that would carry supply below zero turns away the fold whole rather than clamping quietly to zero, because a clamp would invent a number nobody signed. The turn-away is loud, named, and testable.

```
// Invariant: supply == issued - taxed, at every prefix of the log.
// Invariant: supply >= 0 at every prefix — a tax that would overdraw refuses whole.
```

## Identity at the Seam

Every fact verifies through the Kumara seam before the fold counts it. Identity lives in one module by law, so the fold reaches for that module rather than for a signature primitive of its own. A fact enters the fold's arithmetic once its signature verifies, so the check always comes before the counting.

Metal: `kumara.verify_bytes(msg[0..n], fact.sig[0..], pk) catch return error.IdentityRefused` inside `fold_fact` — the public key is first rebuilt with `kumara.PublicKey.fromBytes(fact.signer_pk)`, and that path returns `error.IdentityRefused` for key bytes that read as anything else.

## Refusal, Never Silence

An unfamiliar fact kind turns away the whole fold, loudly. This is the pattern's sharpest edge and its most important one. A fold that skipped what it could parse would produce a number that merely looks correct, and every witness downstream would read it as sound. Turning away whole means the only answers that exist are answers that hold.

The same discipline governs facts that arrive malformed, oversized, or carrying fields beyond what their kind names. Each turn-away carries a named error rather than a boolean, so a caller learns exactly which fault it met.

Metal — named errors from `fold_fact` / `fold_log` / `append_fact`: `IdentityRefused` · `UnknownKind` · `Overdraw` · `StarTaken` · `LogFull`.

## Purity, Proven Twice

The fold's purity earns a witness rather than a promise. Two paths compute the same state, and the witness asserts they agree byte for byte: one path folds the log **fresh** from its beginning, and the other **resumes** from a persisted intermediate state and folds only the remainder. When fresh and resumed agree, purity holds in the only way that matters — under the conditions the system actually runs in, where processes restart and state persists across sleep.

Pairing the assertion on two paths follows the discipline the whole tree keeps: find two places to check a property, and check it in both.

## Bounds, Each With Its Why

Log length carries a named ceiling, because a fold states how long it might walk before its design is finished. Fact size carries a named ceiling, because a fact arriving larger than the reader's budget is a fault rather than a surprise. Arithmetic at persistence boundaries runs in `u64`, so a quantity means the same thing on every target that ever reads the log.

Metal bounds from `mycelium/fold.rye` (checked equal in `mycelium/build_bounds.rye`):

| Bound | Value | Why (from source) |
| --- | --- | --- |
| `myc_fact_max_bytes` | **256** | one signed fact's body ceiling — seated v27 |
| `star_name_max_bytes` | **32** | star name ceiling — seated v27 · `%term`-compatible |
| `myc_log_max_facts` | **1024** | append-only log length — power of two; holds a journey of journeys of facts |

`build_bounds.rye` also pins discovery seats (descriptor 512 · peers 256 · staleness 4096 · fanout 8 · hops 2) and myc policy numbers (genesis 12288 · star price 64 · ceiling 4096) as data the fold does not invent.

## The Witness

The pattern's proof runs as a witness rather than resting in prose. It walks the log fresh and resumed and asserts equality. It asserts the invariant at every prefix, rather than at the end. It presents a fixture that would overdraw and asserts the whole fold refuses. It presents a fact of unknown kind and asserts the same. It presents a fact with a failing signature and asserts refusal before arithmetic. Each fixture bites, which is what makes the green line worth reading.

Metal witness: `mycelium/fold.rye` itself (`rye/bin/rye run mycelium/fold.rye`). Green line:

`GREEN: myc fold — Check shape · supply={d} · stars={d} · purity · refuse whole`

## How It Composes

The fold sits beneath the patterns that carry facts and above the modules that keep them. Pattern one's descriptor exchange brings peers into contact; facts then travel between them; and each peer folds independently to the same number. Because the fold consults nothing outside the log, two peers who hold the same prefix agree without negotiating, and a peer who holds a shorter prefix knows precisely how much of the story it is missing.

Metal imports in `mycelium/fold.rye`: **Kumara** (`kumara.rye` — sign/verify) and **Tally** (`tally_copy.rye` — disjoint copy). The fold file imports those two and stops there. Composition the tree already names in prose: Sangha pattern one (Comlink discovery) brings peers into contact; this pattern folds facts once they arrive. Pond surface is not named in the fold source.

## What This Page Never Decides

Membership semantics stay outside the pattern entirely: who may join, what departure means, what a reservation's release or expiry implies, and every policy word touching value. The fold computes, and leaves every decision to its caller. Those words are Keaton's alone, and no page invents them.

## Trey's Note, on the Record

*The fold arrived fifth, after four primitives had already learned to speak — describe, tabulate, gossip, introduce. Each of those moved something from one place to another. The fold was the first to make a claim: that a number could be agreed upon without anyone being trusted to hold it. It landed green on the first witness in a single-file round, under a season law that kept every round narrow while the tending caught up. The pattern book's second page exists because the code ran first, and the page merely wrote down what the code already knew.*

---

*May every fact stay exactly as it was signed. May the fold refuse whole rather than answer wrongly. May every peer who walks the same log arrive at the same number, alone and unafraid.*
