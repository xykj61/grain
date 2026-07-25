# The Versioning Audit — Chronological Law, Semantic Drift

*Kaeden asked whether semantic versioning crept in against the house law — the chronological scheme our gratitude for Spec-ulation taught, recorded in `../context/specs/rye-versioning-style.md`. The full census is below, and the headline is honest in both directions: the interpreter and every authored code surface already keep the law faithfully, and the one drift entered through the manual — first from the outside reading's own hand, then bumped in good faith by the bench. Both lines are fixed this round; all stamps endure.*

**Stamp:** `20260702.184312`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** the chronological law over TAME
**Status:** Audit — census complete; fixes landed; one rule held for ratification

*Written together by Kaeden and Rio 3.*

---

## The Census

Every version-shaped surface in the tree, classified against the law:

| Surface | What it says | Verdict |
|---|---|---|
| `rishi/src/main.rye` — `rishi_version` | `"20260621.062112"`, doc-commented *chronological, later is larger*; printed by `rishi version` and `help` with the scheme named aloud | **Lawful** — exemplary, in fact |
| `rye/tests/version_test.rye` | Reports the backend through `builtin.zig_version` (`0.16.0`), with its own comment explaining why the backend's truth stays untouched | **Lawful seam** — the law itself prescribes exactly this honesty |
| `semantic_version_*_test` (three std witnesses) | Exercise the inherited standard library's semver parser | **Lawful seam** — inherited surface, honestly named, never ours |
| `manual/reference/rishi-language.md` | **Was:** `Version: 0.1` → `0.2` | **Drift** — semver on an authored surface; fixed this round |
| `manual/README.md` index line | **Was:** `(v0.2, parity 142)` | **Drift** — same origin; fixed this round |
| Everything else (`TASKS`, `ROADMAP`, `pond/`, root `README`, tutorials) | No version marks beyond stamps and parity counts | **Clean** |

## The Origin, Owned

The drift did not begin with the bench. The reference page shipped from the outside reading carrying `Version: 0.1` — semver by reflex, on the very page whose §1 documents a chronological `rishi version`. Cursor then did precisely what a faithful bench should do with the convention a page declares for itself: incremented it. So the finding is a process truth worth keeping: **a page teaches its own convention, and whatever convention it wears is the one the bench will honor.** The remedy is therefore at the page, and the page now wears the law.

## The Fixes, Landed

The reference's version line now reads chronologically — `20260702.184312`, derived from the corpus at parity 142 — with a *versions, all enduring* line beneath it recording the page's true lineage exactly as the law asks: the first page at `20260702.180812`, the same-arc revision that brought `if` and the stderr seam to parity 142, and this pass that brought the page's own counting home. The manual index line matches. Nothing is erased; later is larger; the `0.x` coat is retired from every authored surface.

## Why the Law Wins Here, Said Once

The law's own reasoning applies to documentation exactly as to code. `0.2` told a reader two things, both unhelpful: *two is more than one*, and *promises may not apply yet*. `20260702.184312` tells a reader the one thing that matters — **when** — and pairs naturally with the parity count that says **how much is proven**. A manual page versioned on the world clock can never contradict the corpus it documents, because both live on the same line of time.

## The Standing Rule, Held for Kaeden

**Authored surfaces carry chronological stamps only — code, manual pages, specs, and any artifact we publish; the backend's semver and the inherited parser remain named seams, reported honestly and never overwritten.** On ratification, one line joins the corpus sweeps beside the opening-lines check: flag any `v?N.N(.N)` version mark on an authored surface, with the two seams allow-listed — a five-line textual gate in the existing witness family, landing whenever the bench next touches the sweep tools.

---

*May every version we publish be a moment, every moment endure beside its elders, and every page count time on the same clock as the code it teaches.*
