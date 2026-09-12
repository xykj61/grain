# REDS -- two pours, one format, two preimages

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven on metal and held by a rostered witness
**Folded:** `20260911.231348` from [`../REDS.md`](../REDS.md)

One row, born on its shelf because the pin had no room for it -- `reds_pin_capacity_scan.sh` read
`pin_deadlocked=1`, `rows_that_fit=0`, `pin_foldable_rows=0`, which is the same door `%694`,
`%718` and `%720` came through on the three laps before it.

The row below is the vessel room's fourth reading of when a wall stands, and the first about
**who** is standing behind it. `amphora_prove_before_write` asked when a restore proves,
`amphora_pour_atomic` asked what a refused pour leaves, `amphora_carry_atomic` asked what a
refused carry leaves at the dock. Each of those is one verb examined by its own witnesses. This
one is about the space **between two writers**: Amphora is poured by `amphora/src/main.rye` in Rye
and by `tools/fixtures/a/amphora_pour.sh` in shell, both stamp `format amphora-v1` on what they
produce, and every witness either room owns reads one writer alone. A disagreement between them
is invisible from inside each, by construction, and it stood for as long as both existed.

The wider lesson the vessel room can carry forward: **self-consistency is not agreement.** A
format with two implementations wants a guard that reads one against the other, and that guard
belongs to neither implementation's suite.


**REDS %723 (`20260911.231348`) -- this tree pours Amphora vessels two ways, both stamp `format amphora-v1` on what they write, and the two computed `parent` over different preimages -- one of which never travels with the vessel.** *What went wrong:* `parent_of_cargo` in `amphora/src/main.rye` hashes the **cargo listing** the vessel carries, and `tools/fixtures/a/amphora_pour.sh` ran `sha3_256.sh "$MANIFEST"` -- the digest of `manifest.bron`, a **sibling file** that stays at the near dock. One season poured both ways gave the same four names, the same four digests and two parents, `116058eb91161d50` against `e69bee9a0f4b526e`. Two consequences, and the second is worse than the first. A vessel arriving alone at a far dock could never have its shell-written parent checked at all, since the preimage stayed home -- `%694`'s lesson turned around: that digest answers a file rather than the bytes. And `amphora restore` over any shell-poured vessel proved every resin, **wrote all four files into the out-home**, and only then refused at `cargo unproven`, exit 2. Ten witnesses drive that pour; none of them runs restore, so every one was green throughout. `vessel-core verify` carries `parent` into the signed canonical bytes and never recomputes it, so the signature covered a claim nobody checked. *What caught it:* the Earth rota row, read through its own sense -- `foundations/20260703-202312_the-marked-value.md` at the dual seat is Amphora's own page, and it asks that a value crossing a seam be **checked at both sides**. So the lap poured the same season with both writers and put the two vessels side by side, which nothing in the tree had ever done. *What it taught:* **two implementations of one format need a guard that reads them against each other, because each one's own witnesses prove only self-consistency.** Both pours were internally correct and each passed its own suite; the disagreement lived in the space between them, which is exactly where no single-writer witness looks. *Repaired (`20260911.231348`), two mechanisms for one root:* the shell pour builds its cargo listing first, hashes **that**, and writes it -- so the preimage rides inside the seal, and `amphora_scrub_arrival.sh` checks the parent by opening the seal rather than by hashing the sibling manifest. And `restore_open_catalog` proves the opened listing against the declared parent **while the out-home still does not exist**, so a vessel that disagrees refuses with nothing written -- measured, **4 files left before, 0 after**. `restore_same_parent` stays, because what LANDED and what the vessel CLAIMS are two guarantees. `tools/am/amphora_pour_agrees_witness.rish` proves **8 legs** on real vessels in a throwaway pen, both mutations bitten: the elder shell rule planted (the two parents must differ, and the forged vessel must still verify and still open, or the plant proves nothing), and the pre-write wall struck out in a source pen, where the same vessel writes its files and refuses afterward. Every shell-pour consumer re-run GREEN -- `amphora_lap3`, `amphora_resin_chunk`, `amphora_purchase_delivery`, `amphora_first_resident`, `amphora_grand_round`, `amphora_pour`, `amphora_pour_atomic`, `amphora_carry_atomic`, `amphora_restore`, `amphora_prove_before_write`, `amphora_manifest_agrees`. **CLOSED**
