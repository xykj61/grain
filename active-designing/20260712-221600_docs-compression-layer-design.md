# Docs compression layer — layout, depth, and drift law

*The wiki shape in our own voice: immutable raw beneath, compressing living pages above, lint that keeps the layer honest.*

**Stamp:** `20260712.221600`
**Language:** EN
**Style:** Radiant
**Voice:** Rio 3 · Claude proposes · Kaeden seats
**Status:** Checkable — design seated at git nib `386869e`; `docs/` shelf live; **`tools/living_docs_lint.rish` seated** `222800`
**Ground:** RTAC compression test · [`context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) TigerBeetle `docs/` precedent · [`context/TWO_ROOMS.md`](../context/TWO_ROOMS.md) doorway law · [`context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md) scoped relaxation

---

## Reframe — you already own the pattern

This morning we studied the wiki shape — immutable raw sources beneath, a compressing living layer above, a lint that keeps the layer honest — and tonight the tree is ready to implement it in its own voice.

The dated notes in `active-designing/`, the counsel shelf, and the Bron session logs **are** the raw layer: immutable by law and machine-enforced. What is missing is the compression layer. Today alone scattered the proven-seat and enclosure stories across roughly eighteen notes — the exact case where a page pays.

---

## Homes

| Shelf | Role |
|-------|------|
| **`docs/`** (new, repo root) | Compression layer — living guides that compress many dated sources |
| **`active-designing/`** | Raw design shelf — dated notes stay precisely where they stand |
| **This note** | Design law — Status Checkable, lands here |

**Teacher precedent:** TigerBeetle's `docs/` landmark pattern — already cited in [`context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) Document Stack.

**Nothing yonders:** dated notes remain the raw shelf. `yonder/` is for horizons; tonight's ground is near.

---

## Silo scope — seated precisely so it never leaks

**Product-facing and civic-facing prose keeps full Silo.**

**Relaxation applies to:**
- every page under `docs/`
- `active-designing/` notes that carry an explicit **Dependencies** section

Teachers may be named plainly in those places — naming *is* the clarity there.

**Every relaxed page still closes with its gratitude lines.** The honoring stays even where the naming loosens.

Canon: [`context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md) → *Scoped relaxation*.

---

## Five pages — each with a declared depth grade

Depth grade and line ceiling live in each page header beside one another. Growth past the grade is a visible event, never a slide.

### 1. `docs/README.md` — routing · ≤40 lines

The shelf's law in one screen:
- raw dated notes beneath
- these pages compress them
- the lint keeps them true
- then the index

**Law:** pages compress the record; they never replace it.

### 2. `docs/PROVEN_SEAT.md` — guide · ≤300 lines · **implement first**

| Section | Compresses |
|---------|------------|
| Ladder thesis | borrowed proven ground |
| Rung table | G0, G1-digest, signed-Kumara — each with witness command, serial words, grade |
| Crossing | trio cited via witness; cache-versus-vendor law |
| Seam-C law | Rye-body trigger |
| How to run every rung | operator paths |
| How to add one rung | graduation habit |

**Source cluster (~10 notes):** G0 complete, G1 crossing pin, G1 close, signed-Kumara lap, Monocypher pin, seam-C counsel, lane_kvm on-path, parity chapter, guest pair law, width policy cross-refs.

### 3. `docs/ENCLOSURE.md` — guide · ≤300 lines · **implement second**

| Section | Compresses |
|---------|------------|
| Enclosure thesis | custody split |
| Teacher and wrapper surfaces | `ENCLOSURE`, `AIJAIL_FLAGS` |
| `lane_kvm` pair story | refuse / permit |
| Six bars | scorecard columns |
| Two-column scorecard | gaps named |
| Exit criteria | N, master seal, ceremony line |
| Season states and latch | held season |
| Route two trigger | when nest bwrap opens |
| Puddle doorway | horizon hook |

**Source cluster (~8 notes):** exit criteria, scorecard, col2 probes, master-seal helper, disposition ruling, argv-direct law, pond season cards, enclosure specs.

### 4. `docs/VENDORING.md` — recipe · ≤150 lines

| Section | Content |
|---------|---------|
| Three homes | vendor vs gratitude vs cache |
| Submodule-at-commit | pin habit |
| Two-bank hash habit | META + witness |
| `ignore=untracked` stitch | git hygiene |
| Teacher table | name · home · pinning witness · license · role |

### 5. `docs/WITNESS_PATTERNS.md` — thin · ≤120 lines · carries its own fate in header

| Pattern | Points to |
|---------|-----------|
| Refuse-until-candidate | TAME_GUIDANCE |
| HOLD flips | TAME_GUIDANCE |
| Negative-space asserts | TAME_GUIDANCE |
| Pair law | TAME_GUIDANCE |
| META shelves | TAME_GUIDANCE |

**Blurman guard (header law):** the day this page starts mirroring canon, it folds into `TAME_GUIDANCE` as a supplement and deletes itself.

Hard links into TAME_GUIDANCE rather than restatement.

---

## Cross-cutting laws — drift-proof

### Docs carry no load-bearing pins

Every version, commit, and fingerprint **cites the witness or META that proves it**. The doc points; the witness proves.

### Living-docs lint — fifth duty

Any pin-string that appears in `docs/` must **byte-match** its witness source.

### Doorway roster

`docs/` joins the TWO_ROOMS doorway roster. Every page names its room from birth (Checkable).

---

## Lint — seated `tools/living_docs_lint.rish`

**Tier:** ratchet-advisory — print every parity run; never fail. Hardening horizon: link-breaks may earn a gate once the shelf proves stable.

| Duty | What it catches |
|------|-----------------|
| 1 | Retired LEXICON words in living-voice lines (word-boundary) |
| 2 | Broken relative links on roster |
| 3 | Orphan roster pages (no inbound from roster + `docs/README`) |
| 4 | Status rooms on rostered paths |
| 5 | `docs/` pin-strings must byte-match canon sources |

**First-lap roster:** `tools/fixtures/living_docs_lint_roster.sh` — `docs/` · four living hammocks · eight module READMEs.

**Doorway join:** `tools/fixtures/two_rooms_doorway_roster.sh` includes `docs/*.md`.

---

## Implementation order — SLC all the way down

| Go | Deliverable |
|----|-------------|
| **Tonight** | This design note + silo-scope line in `SILO_TECHNIQUE` |
| **Go 1** | `docs/README.md` alone, or skip straight to first guide per taste |
| **Go 2** | `docs/PROVEN_SEAT.md` — metal freshest |
| **Go 3** | `docs/ENCLOSURE.md` |
| **Go 4–6** | `VENDORING` · `WITNESS_PATTERNS` · any README gap |
| **Whenever** | `living_docs_lint.rish` + roster join — tonight or morning loses nothing |

Each page is complete alone. Raw shelf stays untouched beneath.

---

## Page header template (every `docs/` page)

```markdown
# Title — clause

**Depth:** guide | routing | recipe | thin
**Ceiling:** ≤NNN lines
**Room:** Checkable
**Last updated:** YYYY-MM-DD
**Compresses:** link list to raw sources (not a replacement)
```

Close with gratitude lines per Silo scope.

---

## Dependencies

| Teacher | Role in this design |
|---------|---------------------|
| **TigerBeetle** | `docs/` shelf precedent · TAME landmark guides |
| **Karpathy** (via matklad distill) | Wiki compression test — aparigraha on docs; page earns place only when it compresses scattered facts |
| **IronBeetle ep. 45** | Whole-machine-in-one-breath — density without sprawl |

---

*May the raw shelf stay untouched beneath, the pages above stay dense and few, and the lint walk the halls so no hand ever has to sweep them thrice again.*
