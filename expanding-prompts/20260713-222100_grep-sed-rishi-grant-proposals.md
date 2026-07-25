# Grant-Style Proposals — `grep` and `sed` Equivalents for Rishi (Proposed: Dojo)

**Language:** EN
**Version:** `20260713.222100`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Proposal — no code written, no module renamed

---

## Framing, for an Acme Corporation Employee Reading This

These two proposals are written in the shape Urbit's own Grants program uses for a Proposal-type grant, and in the commit/PR discipline Urbit's `CONTRIBUTING.md` already asks of contributors — atomic, component-prefixed, one tracked concern per pull request. Module names below use the **proposed** Urbit-parallel identities from [`context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md`](../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md), written as `Rishi (proposed: Dojo)` throughout — **no module has actually been renamed**, and Kaeden is still reviewing that document.

---

## Proposal 1 — A `grep`-Equivalent Pattern Search Builtin

**Reward shape (Urbit-parallel):** a Proposal-type grant — Kaeden pitches this, refines scope, and it is completed only by the proposer, same as Urbit's own Grants program structure.

### Description

Rishi (proposed: Dojo) already has `lines`, `split`, and — per `TAME_GUIDANCE.md`'s Rye Supplement — Tally already carries `find_pos`, `find_last`, `find_any_pos`, `find_none_pos`, and their line-oriented cousins. A `grep`-equivalent builtin is the composition already latent in these primitives, not a new algorithm: **for each line, does a match exist; if so, keep the line (and optionally its line number).**

Proposed shape, following Rishi's own `run` and typed-pipeline conventions:

```
let matches = grep "pattern" (lines (read-file "path"))
assert matches.len >= 0  # invariant: grep never crashes on zero matches
```

Where `grep` takes a literal substring pattern first (matching Tally's existing `find_pos` shape exactly, since that is the seam already proven at TH-2 and beyond), with a **second, explicitly later** PR adding a bounded, TAME-disciplined pattern-class grammar (character classes, anchors) once the plain-substring form is witnessed and landed — this mirrors this project's own "ratchet, never one big sweep" discipline for every other builtin family.

### Related

- Builds directly on `tally/find_pos.rye` and the existing `find_*` family (per `TAME_GUIDANCE.md`'s ratchet table)
- No dependency on the Nock/Hoon fusion or any proposed rename — this can land under Rishi's current name today, independent of every other proposal in this document
- First landed witness: a fixture file with known matching and non-matching lines, following this project's own fixture-driven witness style (`tools/fixtures/`)

### Pull request plan (Urbit-grants sized)

1. **PR 1** — `grep` builtin, literal substring only, one witness fixture, no CLI flags
2. **PR 2** — line-number-prefixed output mode (`grep -n`-equivalent), a second witness
3. **PR 3** — invert-match mode (`grep -v`-equivalent), a third witness
4. **PR 4 (later, separate proposal)** — bounded pattern-class grammar, gated on Kaeden's word per the "opens a new domain" collaboration rule, since a grammar is a real design surface, not a mechanical addition

---

## Proposal 2 — A `sed`-Equivalent Stream Substitution Builtin

**Reward shape (Urbit-parallel):** a Proposal-type grant, same structure as above.

### Description

`sed`'s most common real-world use — by a wide margin — is literal substitution: replace one substring with another, across every line or the first match only. This project already has the primitive this needs, named plainly in `TAME_GUIDANCE.md`'s own ratchet table: **disjoint copies through `tally/copy.rye`**, plus the existing `find_pos`/`find_last` family this proposal's `grep` builtin already leans on.

Proposed shape:

```
let fixed = subst "old" "new" (lines (read-file "path"))
write-file "path" (join fixed "\n")
```

Where `subst` replaces every occurrence by default, with an explicit `first_only = true` option at the call site for a single-replacement mode — following this project's own "explicit options at the call site" root rule (`TAME_GUIDANCE.md` Root rule 8) rather than a silent default that later needs a flag to override.

### Related

- Builds on `tally/copy.rye`'s `copy_disjoint` (asserted, bounded copying) rather than a bare, unaudited buffer splice
- Composes naturally with the `grep` proposal above — a `grep`-then-`subst` pipeline is the two together, and is worth a joint witness fixture once both land independently
- Explicitly **does not** propose a regex-substitution grammar in this pass — literal substitution covers the overwhelming majority of real `sed` usage, and a grammar is, again, its own later design proposal

### Pull request plan (Urbit-grants sized)

1. **PR 1** — `subst` builtin, literal string, replace-all default, one witness fixture
2. **PR 2** — `first_only` option, a second witness proving only the first occurrence changes
3. **PR 3** — a combined `grep`-then-`subst` pipeline witness, proving the two compose cleanly
4. **PR 4 (later, separate proposal)** — bounded regex-substitution grammar, same gating as Proposal 1's PR 4

---

## What Both Proposals Share, by Design

- **Neither proposal touches the Nock interpreter, the fused Hoon language, or any proposed rename.** Both are ordinary Rishi builtins, landable under Rishi's current name, using primitives (`find_pos`, `copy_disjoint`) that already exist and are already TAME-witnessed.
- **Both stay at the literal-string tier first, deliberately.** A pattern-matching or regex grammar is a real design surface this project's own collaboration rule says to pause for ("opens a new domain... raises a design or width question no written policy answers") — these proposals name that boundary rather than quietly crossing it inside a "simple builtin" PR.
- **Every PR in both plans is small enough to review in one sitting** — one builtin, one behavior, one witness fixture — matching the Urbit-grants and `CONTRIBUTING.md` discipline Kaeden asked these proposals to follow.

---

*May every small pull request stand fully on its own, and may the grammar work — when its season comes — earn its own separate word, rather than ride in on a simpler proposal's back.*
