# REDS -- one literal, two verdicts

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260909.001908`
**Row:** `%662` (`20260909.001908`) -- BOOKED, born onto this shelf. The spine answered `next_free=655`
after `git fetch xy` at this lap's send, and the send never landed: the lap sat in a round-open
stash until `20260909.011200`, by which time `%655` had gone to the lap recovered beside it
(`20260908.234354`, the earlier stamp). The key is the stamp; the number is a view
(`derived-spine`).

**Recovery:** The parked row is rebound to `%662` against the fetched shared spine. Its immutable stamp remains `20260909.001908`; the former shelf path routes here so dated logs keep their references.

The row is born folded rather than landed and folded, for the reason the shelf beside it records:
`construction/REDS.md` stood at **40,787 bytes against a bound of 40,960** -- 173 bytes free
against a row of 3,335 -- with all fourteen of its remaining rows OPEN and so unfoldable by law.
`pin_deadlocked=1`, measured by `tools/fixtures/r/reds_pin_capacity_scan.sh` on the lap that
wrote this.

**It is BOOKED rather than OPEN, and the word is load-bearing here.** The defect's instances are
held still by a ratchet, and the whole remainder is a **seat** -- Keaton's ruling on which way the
law falls -- which is the third status word's own definition (door B, `20260829`). Marked OPEN it
would read `shelf_open_rows=1` against a ceiling of **0**, and that ceiling is honest: it fell
from 2 on `20260829.160317` when the two exiled live rows closed. **The two doors closed
independently, each correctly, and their conjunction is what a new live red now meets** -- a
deadlocked pin and a shelf that admits no OPEN row. Neither lap that closed a door could see the
other.

---

**REDS %662 (`20260909.001908`) -- Glow declares a house parse law in one reader of fourteen, so one literal gets two verdicts.** *What went wrong:* `glow/rune_shop_gate.rye:522 parse_decimal_u32` carries a comment naming a **house parse law** -- *refuses empty, leading zero, overflow* -- and it is the only one of the language's **fourteen** source-decimal readers that holds it. Proven on metal `20260909.001908` on three paths in one tree: `?:  (eq a b)  01  0` refuses with `MalformedBody` through the shop gate, while `=/  amount  007` lowers GREEN through `glow/lower_multi.rye parse_trailing_u32` to `const amount: u32 = 7;` and `=/  amount  03` lowers GREEN through `glow/lower_compose.rye` to 3. Both directions shown in one file: lifting the `01` back to `1` returns the gate desk to GREEN. **The lexer is neutral, which is why the split could hide** -- `glow/tokens.rye scan_digits` takes any run of digits and emits one `.decimal` token, so nothing about a leading zero reaches the token stream; the disagreement lives entirely in the fourteen functions that turn those bytes into a u32, and no two of them are called from one place, so no test ever sat them side by side. `glow/rune_assert.rye parse_decimal` is the shop gate's function **byte for byte, minus the loop variable's name and minus the one line that refuses**. *What caught it:* an air-row lap running a hand along the one boundary the elder block left as a question -- *does Glow accept `007`?* -- and **running it rather than reading it**. The derivation then caught the hand that wrote it: a grep found **5** readers, deriving the population from the room found **14**, which is REDS %532's own lesson landing on the seat that cited it. *What it taught:* **a law declared in one reader of fourteen is a law nobody can rely on, and the declaration reads exactly like a guarantee.** The sharper half is that the fault is invisible from every single site -- each of the fourteen is internally consistent and correct on its own terms, and the split exists only in the relation between them, which is how fourteen careful hands produced it. *Repaired in the instrument, with the ruling left standing:* `tools/fixtures/g/glow_decimal_law_scan.sh` derives the reader population from the room every pass, gates `law_claimed_absent` at zero -- a comment naming the law above a body without its check -- and ratchets **`verdicts`**, the count of distinct answers one literal gets, at **2**. That reading is ruling-neutral on purpose: a ceiling on law-breaking readers would red on the lap that landed the answer *accept everywhere*, so the meter holds the fault still without deciding it, and two control legs carry exactly that shape -- a room refusing everywhere and a room accepting everywhere both read one verdict and both pass. `tools/fixtures/g/glow_decimal_law_control.sh` proves **27 behaviors** on miniature compiler rooms in a pen, every refusal planted then lifted, the ceiling shown both ways, and four deliberate perturbations of the scan each caught by the control before it shipped. `tools/g/glow_decimal_law_witness.rish` rostered `tier lap` at 4s. *Not taken, and named rather than assumed:* **which way the law falls -- Glow refuses a leading zero everywhere, or accepts one everywhere -- is a language custody ruling and waits on Keaton's word.** **BOOKED.**
