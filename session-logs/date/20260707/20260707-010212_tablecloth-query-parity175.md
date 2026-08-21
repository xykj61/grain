# Tablecloth query — parity 175

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** `20260707.010212`

## Thinking trace

Kaeden relayed Claude counsel `20260707.005612` for the last Q3 namespace item: Tablecloth query. The counsel names two unreconciled Tablecloth meanings in the tree and takes the namespace brief's reading as operative — optional peer/bolt/revision filter over the bounded `BoltCatalog`, every match in held order, empty when nothing matches.

Filed counsel to `external-research/`, removed the stray root copy. Implemented `mantra/recall_tablecloth_query.rye` composing over `recall_lap1.rye` and `recall_by_mark.rye` without editing either. Witness catalog spans rev 1 (three leaves) plus rev 2 notes supersede; revision-order rules required `config.toml` at rev 1 before any rev 2 path work.

## Observations

- `queryTablecloth` walks the flat array once; `TableclothQuery` optional fields mirror counsel.
- Convergence proof: exact name recall, `recallByMark` with path hint, and narrowed query agree on bytes.
- No wire lap — counsel scoped in-process only; closes the Q3 ordered list.
- Production scheduling (graceful stop, crash recovery, Caravan poller) remains open.

## Files

| File | Why |
|------|-----|
| `counsel/20260707-005612_claude-counsel-tablecloth-query.md` | Filed counsel |
| `mantra/recall_tablecloth_query.rye` | Tablecloth query implementation + selftest |
| `tools/mantra_recall_tablecloth_query.rish` | Witness script |
| `tools/parity.rish` | Parity **175** witness slot |
| `tools/width-check.rish` | Width surface for new module |
| `work-in-progress/TASKS.md` | Q3 item done; next = production scheduling |
| `work-in-progress/ROADMAP.md` | 175 witnesses; version stamp |
| `active-designing/20260706-023912_the-referential-namespace.md` | Lap 175 + counsel phrase seated |
| `external-research/README.md` | Index row for `005612` |

**Recommend:** keep going to commit/push parity 175 when Kaeden asks — mechanical, single arc closure, policy already written; production scheduling crosses Caravan seam and warrants Claude before unattended real runs.
