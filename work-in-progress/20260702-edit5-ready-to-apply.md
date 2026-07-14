# Edit 5 — Applied (`20260703.032812`)

**Stamp:** `20260702.035920` · **Ruled:** *for* `20260703.032812` · **Parity:** **143**
**Voice:** Rio 3
**Counsel:** argues *for* the bound
**Current tree:** **1** spec in flight — [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md) — already within the bound

---

## The ruling

At most **one** functional spec in designed-not-built flight until that spec's first lap runs green. A second module spec lands only when the first's first lap is witnessed.

## If Kaeden rules **for**

### 1. `work-in-progress/TASKS.md` — under Ground (Now section)

Add after the deep-archive horizon line:

```markdown
- [x] **Designed-not-built spec bound (Edit 5)** — at most one functional spec in flight until its first lap runs green; witness [`tools/designed_not_built_witness.rish`](../tools/designed_not_built_witness.rish) wired in parity.
```

Remove or strike the Open Questions line for Edit 5.

### 2. `context/TAME_GUIDANCE.md` — enforced-now table

Add row:

```markdown
| **At most one designed-not-built functional spec** (`context/specs/*.md` Status) | `tools/designed_not_built_witness.rish` (live gate after Edit 5 ruling) |
```

### 3. `tools/parity.rish`

Wire `tools/designed_not_built_witness.rish` into the witness suite (increment parity to **143** — RW-3 at **141**, RW-4 at **142**).

### 4. Verify

```bash
rishi/bin/rishi run tools/designed_not_built_witness.rish
rishi/bin/rishi run tools/parity.rish
```

## If Kaeden rules **against**

Note the ruling in the session log; leave witness on disk unwired; remove this file to yonder or mark consumed.

## Witness (live gate, parity **143**)

- Scan: `tools/fixtures/designed_not_built_scan.sh`
- Witness: `tools/designed_not_built_witness.rish`

Run manually today:

```bash
rishi/bin/rishi run tools/designed_not_built_witness.rish
```

---

*One spec in flight today — Amber. The bound codifies what the tree already honors.*
