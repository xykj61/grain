# Shelved from construction/ITINERARY.md -- GRASS's eval_expr split account

**Shelved:** `20261002.161804`, in the same send that lands GRASS's next
account (`glow_run.rye`'s `main` split).

---

**GRASS -- `EVAL_EXPR` SPLITS AT ITS OWN NATURAL SEAMS.** [Account
shelved](../../active-designing/date/20261002/20261002-144246_grass-eval-expr-split-account.md):
unlike caravan's and mycelium's sequential-narrative shape (declined twice already), `rishi/src/
main.rye`'s `eval_expr` is a flat string-prefix dispatch table with eight real seams its own
comments already name. Split into a 20-line dispatcher and eight helpers, every line and comment
kept verbatim; the two groups reading untrimmed `text` (comparison, the two word-op families) kept
taking `text`, the rest kept `trimmed`. Clean rebuild; all 36 `rishi/tests/*.rish` scripts
byte-identical in stdout, stderr, and exit code against a pre-split baseline; a dozen
rishi-dependent witnesses GREEN; the long-function scanner confirms `eval_expr` (242 lines) is gone
from the roster and no new entry crosses 70. One slow witness, `rishi_list_bound`, was proven to
time out identically on the pre-split binary -- named as pre-existing and unrelated. `YOURS:` none
from this file -- `glow/glow_run.rye: main` and `rye/src/main.rye: bridge_to_zig` remain the two
large real candidates still unread.
