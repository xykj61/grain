# Session log — SLC-1 Step 3 recall built

**Stamp:** `20260629.024012`
**Editor:** Cursor · **Model:** Composer

## Thinking trace

Kaeden handed the Step 3 build prompt grounded in the landed `History` ring. Implementation followed 3a → 3c:

1. **`runInputLine`** — lifted transcript append, arena dupe, history record, and eval+error handling from the inline normal path. Both typed lines and recall travel the same road.

2. **`recallByIndex`** — shared resolution for `:recall <n>` and `!<n>`. Empty ring, non-numeric arg, and out-of-range index each print a friendly message and return — no assertions on untrusted input. Target captured into a local before `runInputLine` so a full ring cannot invalidate the slice mid-recall.

3. **Witness** — Step 1 inline pattern (`repl < fixture`); counts two `RE-RAN` via `split result.out "RE-RAN"` (three parts). Build prompt's `by` keyword is not Rishi surface syntax — used `split text sep` form from `split.rish`.

4. **Docs** — REPL meta-command table added to `rishi/README.md`.

Metal: build green, Step 3 witness green, full `parity.rish` green (119 witnesses).

## Observations

- `!<n>` landed cleanly via `recallByIndex` — no tangled branches.
- SLC-1 acceptance is in reach: four verbs exist; combined acceptance witness still open on TASKS.

## Files

| File | Why |
|------|-----|
| `rishi/src/main.rye` | `runInputLine`, `recallByIndex`, `:recall`, `!<n>` |
| `tools/slc1_recall_step3.rish` | Step 3 witness |
| `tools/fixtures/slc1_recall_step3.input` | REPL fixture |
| `tools/parity.rish` | Register Step 3 |
| `rishi/README.md` | Meta-command reference |
| `work-in-progress/TASKS.md` | 3a–3c checked |
| `work-in-progress/ROADMAP.md` | Step 3 sealed; 119 witnesses |
| `expanding-prompts/20260629-024012_cursor-build-slc1-step3-recall.md` | Moved from repo root |
