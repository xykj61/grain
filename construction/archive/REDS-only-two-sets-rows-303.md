# REDS -- row %303, folded from the living pin

**Folded:** `20260827.211629` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The sealed registry that called itself the record of every waymark was missing one, and its own
witness was green the whole time because it could not see an absence.*

The seal proves nothing was edited. The re-derivation proves every row present is honest. Neither
reading can see a row that is simply gone, because a missing row is well-formed -- REDS %298's class
at its sharpest.

**A guard over one set proves things about the members it has; only a guard over two sets can prove
the set is whole.** That sentence outlived this row on the same day: `%304` found a ban gate whose
roster named twelve rooms while the tree held nineteen, and nothing had compared the two either.

---

**REDS %303 (`20260827.205859`) -- the registry that calls itself the record of every mark was missing one, and its own witness could not see an absence.** *What went wrong:* `.claude/rules/waymark-ladders.md` names `construction/waymark-registry.bron` *"the sealed, self-verifying canonical record of **every** waymark ever drawn"* and *"the authority; the table below is its readable face."* **AHOY** stood in that table with its input recorded, and in **24 living files** including `foundations/README.md` and the operator card -- and `grep -c AHOY construction/waymark-registry.bron` read **0**. The registry held 35 rows and the authority was missing a name it claimed to hold. *What caught it:* an adversarial sweep set on the whole tree, by differencing the rule table against the registry -- a comparison nothing in the tree performed. *What it taught:* **a seal proves nothing was edited and a re-derivation proves every row present is honest, and neither can see a row that is simply absent.** `tools/w/waymark_registry_witness.rish` was GREEN the entire time, correctly: it verified `SEAL_OK` over the body and re-derived all 30 corpus marks, and an absent row breaks neither reading. This is REDS %298's class at its sharpest -- the guard reads structure, and **the missing thing is well-formed**. The general shape is worth carrying: *a guard over a set proves things about the members it has; only a guard over two sets can prove the set is whole.* *Repaired (`20260827.205859`):* AHOY derived on metal from its own recorded input -- `sha3-512` prefix `b7aa8eb8` -> index **65** of 5,526 -> **AHOY** -- so the row was computed rather than invented, appended, and the body **re-sealed** (`DERIVE_OK` rose 30 -> 31). A completeness leg now stands beside the seal: `tools/fixtures/waymark_table_registry_completeness.sh` differences the rule table's 29 seated marks against `^mark` rows and refuses by name, proven **both ways** on metal by deleting the AHOY row, watching it print `absent_from_registry=AHOY` and `verdict=incomplete`, and restoring it to green. CLOSED.
