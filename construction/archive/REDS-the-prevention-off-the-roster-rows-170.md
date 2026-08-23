# REDS -- row %170, the prevention that stood off the roster

**Folded here** `20260823.152322` from [`../REDS.md`](../REDS.md), every byte kept, on the lap it
was booked, as row %171 carried the living pin past its 24,576-byte bound. CLOSED. Its repair
stands in `construction/standing-equipment.kyri`, where `living_card_ascii` is now the 31st guard,
and in the operator card, which measures zero bytes above 0x7F.

---

**REDS %170 (`20260823.144100`) -- REDS %83's own prevention guard was standing off the roster, and the card it protects had four non-ASCII lines.** *What went wrong:* `tools/l/living_card_ascii_witness.rish` enforces zero bytes above 0x7F in `construction/ITINERARY.md` and `construction/REDS.md`. It was seated `20260817` as the booked prevention for REDS %83 -- the operator card that silently triple-encoded itself into 2,797 runs of mojibake. It was never added to `construction/standing-equipment.kyri`, so no run ever invoked it, and the `20260823.103804` ROADMAP fusion carried four rows of em-dashes, middots, and a right-arrow straight into the card. *What caught it:* running the guard by hand while chasing an unrelated red, which is the only way an unrostered guard is ever run. *What it taught:* **a prevention booked against a red is only as standing as the roster that runs it** -- REDS %156 and %165 said the same thing about two other guards, so this is a lantern firing a third time. The repair is the loom rather than the sweep: the four rows are ASCII now, and the guard joins the roster, which is what makes the next one impossible to miss rather than merely unlikely.

**REDS %170 CLOSED (`20260823.144100`).** *The repair, on metal:* the four table rows in `construction/ITINERARY.md` rewritten to `--`, `-`, and `->`; the card measures zero bytes above 0x7F; `living_card_ascii` seated as the roster's 31st guard and GREEN with its planted mojibake control still caught.
