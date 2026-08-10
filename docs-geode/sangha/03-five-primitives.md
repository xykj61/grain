# Pattern Three — The Five Primitives

**Stamp:** `20260730.103002` · door 12 **GREEN** under j4 h4 Accrete-never-break  
**Voice:** Kyri · nested documentary voice: Trey · **Style:** Radiant · **Discipline:** TAME  
**Coords:** equinox A · journey 4 · quest Do  
**Destination:** `docs-geode/sangha/03-five-primitives.md` — living reference page  
**Elder siblings:** [`01-descriptor-exchange.md`](01-descriptor-exchange.md) · [`02-fact-fold.md`](02-fact-fold.md)  
**Written from:** GREEN myc metal only — kumara · fold · fold_persist · ship_sol · refusal_storm · build_bounds

*Written together by Keaton and Riyo.*

---

## Context

A newcomer opens the tree and asks what the house is made of. The answer is five primitives — **keypair**, **signed event**, **append-only log**, **pure fold**, **capability** — a technical account of a moral posture: nothing is destroyed, every change is a fact, every fact is signed, and the past is not editable by whoever holds the present. Pattern one carries peers into contact. Pattern two folds value facts into a number. This page names the five as a set, so the posture is hearable aloud without hunting five selftests.

## Forces

- **Identity vs anonymity.** A fact without a keypair is a rumor; a keypair without a fact is an unused key.
- **Event vs edit.** A signed event says what happened once; a correction is a new event, never a rewrite.
- **Log vs ledger-of-now.** Append-only history refuses quiet deletion; the present is a fold, not a mutable cell.
- **Fold vs authority.** Agreement comes from arithmetic over the same prefix, not from trusting a holder.
- **Capability vs ambient power.** A seal at a seam grants a bounded right; over-bound and tamper refuse whole.

## The shape — five sections

### 1. Keypair

**Invariant.** The same seed yields the same keypair. A signature verifies over the exact message bytes it sealed — or the verify path refuses.

**Bounds.** Ed25519 seed and signature lengths from `mycelium/kumara.rye` (`seed_length` · `signature_length`). Identity lives in one home; other modules reach through kumara rather than inventing a second crypto surface.

**Refuse.** Tampered message → verify fails (`VerifyFailed` at kumara; fold maps bad seals to `IdentityRefused` before arithmetic).

**Witness.**

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/kumara.rye
```

Metal (this door): `GREEN: tally kumara — deterministic keypair, sign, verify.`

### 2. Signed event

**Invariant.** A fact is immutable, typed by kind, and sealed by a keypair before it counts. Verify precedes fold — never the reverse.

**Bounds.** `myc_fact_max_bytes` **256** · `star_name_max_bytes` **32** — seated in `tools/gen/season/recursion_block.brix`, published by `mycelium/fold.rye`, checked equal in `mycelium/build_bounds.rye`.

**Refuse.** Bad seal → `IdentityRefused`. Unknown kind → `UnknownKind` (never skip silent).

**Witness.**

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold.rye
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/refusal_storm.rye
```

Metal (this door): fold GREEN · storm cases include tamper and unknown kind.

### 3. Append-only log

**Invariant.** Facts enter at the end and never leave. A refused append leaves `log.len` identical — no quiet trim, no hole.

**Bounds.** `myc_log_max_facts` **1024** — power of two; holds a journey of facts. Full log → `LogFull`.

**Refuse.** Duplicate star reserve → `StarTaken` · length unchanged (storm limb 3).

**Witness.** Same fold and refusal_storm commands as above. Storm asserts `log.len` unchanged on every refuse.

### 4. Pure fold

**Invariant.** **Supply equals issued minus taxed** at every prefix. Fresh fold of the full log equals resume-from-snapshot then fold of the remainder. Supply stays non-negative; overdraw refuses whole.

**Bounds.** Snapshot ceiling `myc_fold_snapshot_max_bytes` **4096** (`mycelium/fold_persist.rye`). Fact and log ceilings as above.

**Refuse.** Overdraw → `Overdraw`. Truncated / unknown-version snapshot → refuse whole (`Truncated` and kin).

**Witness.**

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold.rye
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold_persist.rye
```

Metal (this door): `supply=872` fold · `supply=1072` sleep·wake · refuse whole · bound=4096.

```
// Invariant: supply == issued - taxed, at every prefix.
// Invariant: fresh(full log) == restore(snapshot) then fold(remainder).
```

### 5. Capability / seal at the seam

**Invariant.** A capability is a bounded, sealed proof at a named seam — here the ship `.sol` proof and the fold snapshot byte door. Over-bound and tamper refuse whole; cadence policy stays parked.

**Bounds.** `ship_sol_proof_max_bytes` **1024** · `sol_name_max_bytes` **256** (name fits inside the proof). Snapshot bound **4096** as above.

**Refuse.** Tampered sol → `IdentityRefused`. Empty/oversize body → `BoundRefused` / `ShapeRefused`. Storm limb 5 bites truncate and sol tamper.

**Witness.**

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/ship_sol.rye
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold_persist.rye
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/refusal_storm.rye
```

Metal (this door): `GREEN: ship_sol — Check shape · bound 1024 · seal · refuse whole · purity`.

## Bounds table (inherited, never invented)

| Bound | Value | Why (seated) |
| --- | --- | --- |
| `myc_fact_max_bytes` | **256** | one signed fact body |
| `star_name_max_bytes` | **32** | `%term`-compatible star name |
| `myc_log_max_facts` | **1024** | append-only log length |
| `ship_sol_proof_max_bytes` | **1024** | on-chain name-proof reference |
| `sol_name_max_bytes` | **256** | SNS name inside the proof |
| `myc_fold_snapshot_max_bytes` | **4096** | one FoldState freeze |
| `refusal_storm_min_cases` | **5** | one adversarial bite per primitive |

Checked on metal: `mycelium/build_bounds.rye`.

## The witness (page)

Negative space for all five gathers in one storm:

```
env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/refusal_storm.rye
```

Metal (this door): `GREEN: myc refusal_storm — five primitives refuse · cases=5 · bound=5 · log.len=3`.

Page-structure pin (paths and headings resolve):

```
rishi/bin/rishi run tools/sangha_five_primitives_page_witness.rish
```

## How It Composes

Descriptor exchange (page one) finds peers. Facts travel as signed events on an append-only log. Each peer folds independently to the same supply. Capabilities seal proofs at seams without inventing ambient authority. The refusal storm proves the unwelcome path for each limb in one place. Accrete-never-break holds: elders stay; this page only names what already ran green.

## What This Page Never Decides

Membership · join · departure · star release/expiry · SNS liveness hours · wallet · gas · deploy · season name. The five compute and refuse; they do not spend policy words.

## Trey's Note, on the Record

*Five names, one posture. The page is late on purpose — after the storm, after sleep·wake, after the sol seal — so every sentence points at a GREEN line rather than a hope. A reader who hears the five aloud has heard the house.*

---

*May every key stay in a hand. May every fact stay as signed. May the log grow only forward. May the fold agree alone. May every seam seal refuse louder than it guesses.*
