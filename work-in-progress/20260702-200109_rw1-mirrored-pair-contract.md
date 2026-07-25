# RW-1 — Mirrored Pair Contract (Rishi ↔ Mantra History)

*Witness contract on paper — collaboration and contract twins for the shell↔history seam, drawn only from the audit, the happy-zone foundation, and the SLC-1 verbs already green. Implementation waits on SLC-2b; the mirror lands while the seam is warm.*

**Stamp:** `20260702.200109`
**Voice:** Rio 3
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · happy zone · mirrored pair
**Status:** Contract prep — no `.rish` files until ladder rung 5; two commits, parity **+2**

**Ground:** [`20260702-180812_testing-audit-first-pass.md`](20260702-180812_testing-audit-first-pass.md) · [`../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) · [`../active-designing/20260628-071012_slc-1-rishi-mantra-shell.md`](../active-designing/20260628-071012_slc-1-rishi-mantra-shell.md)

---

## The Seam

**Asker:** Rishi REPL (`:version`, `:history`, `:recall`, session buffer, transcript append).

**Answerer:** Mantra history store (`.mantra/` tree — init, add, HEAD, blobs; stubbed in collaboration witness).

**Contract:** the meta-commands the shell may issue and the shapes the store must return — welcome answers and unwelcome ones alike.

---

## Witness 1 — `tools/rw1_shell_collab.rish` (collaboration)

The shell runs against a **stub history store** (fixture under `tools/fixtures/rw1_stub_mantra/`) that speaks only contract.

### Welcome paths (assert `.ok` and expected stdout fragments)

| Input sequence | Shell must |
|----------------|------------|
| `:history` on empty session | survive; print empty-history message (reuse RW-4 kind wording) |
| `let x = 1` then `:history` | survive; numbered entry includes the line |
| `:recall 1` after one line | survive; re-run or echo prior line; output carries `1` |
| `:version` after transcript change | survive; invoke store add path (stub records call) |
| `:quit` | exit clean |

### Unwelcome path (assert `.ok` — shell survives)

| Input | Shell must |
|-------|------------|
| `:recall` with bad argument | survive; print usage (aligned with RW-4 `rw4_recall_bad_arg`) |
| `:recall 99` on one-line session | survive; kind out-of-range message |

### Fixtures (to land with witness)

- `tools/fixtures/rw1_collab_empty.input`
- `tools/fixtures/rw1_collab_one_line.input`
- `tools/fixtures/rw1_collab_version.input`
- `tools/fixtures/rw1_collab_recall_bad.input`

**Commit message:** `Add RW-1 shell collaboration witness — parity +1` (first of two; exact parity number follows ladder arithmetic at build time).

---

## Witness 2 — `tools/rw1_history_contract.rish` (contract)

The **stub store** (or minimal `.mantra` fixture tree) is exercised directly — no full REPL — proving the answerer honors every question the collaboration witness asks.

### Welcome demonstrations

| Contract question | Store must |
|-------------------|------------|
| init on empty cwd | create `.mantra/HEAD`, `blobs/` |
| add after session line | advance HEAD; blob present under `blobs/` |
| history read after add | return transcript-compatible listing |
| recall index 1 | return exact prior line bytes |

### Unwelcome demonstration (mirrored to collaboration)

| Contract probe | Store must |
|----------------|------------|
| recall out of range | return error shape the shell maps to kind message |

**Commit message:** `Add RW-1 history contract witness — parity +1` (second of two).

---

## Parity wiring

Each witness earns one standard quartet at the parity tail when landed. Register in order: collaboration first, contract second. Refresh ROADMAP gate-trio count in the contract commit.

---

## What Stays Outside (RW-2 and later)

- App↔Brushstroke `setFrame` collaboration twin (RW-2)
- Full Mantra merge/log/diff CLI
- Pond drawn-terminal history seam (uses same session buffer; RW-1 pins the shell↔store boundary first)

---

*May the asker and the answerer mirror each other line for line, and may the seam stay thin enough to check alone.*
