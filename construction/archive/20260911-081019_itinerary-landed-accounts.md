# ITINERARY -- landed accounts, shelved `20260911.081019`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The DIFFUSER account the live card carried before the lap of `20260911.081019`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**DIFFUSER -- A MUTATION THAT DID NOT BITE, AND THE COMMENT THAT CLAIMED IT WOULD.**

Elder [shelved](20260910-230908_itinerary-landed-accounts.md).
**MECHANISM:** the local spine read in `reds_spine_derive_scan.sh` piped each of 440 ledger files
into its own `sed`. `sed` takes many file operands, so the walk is two invocations: paths
accumulate with `set -- "$@" "$f"`, flushing at `MAX_SED_OPERANDS=256`.
**MEASURED:** `execve` **483 to 45**, `sed` **442 to 4**; wall **3.4x**, 3,021 against 896 ms,
five runs each ALTERNATING at load 9.4-10.3. Two laps: **14,157 ms / 1,745 to 896 / 45**.
Byte-identical output. Five readers GREEN.
**THE FALSIFIER FIRED:** three new control legs, each mutated -- **11 of 24 cases** fell when the
flush went, **1** on a word-split operand list, **0** when the `if` became a trailing `&&`. That
third comment claimed `set -e` would kill the script; on metal a false AND-list returns 1 and runs
on. The leg proves the row count rather than the exit status.
**ALSO CLOSED:** `prose_register` refused at `door_setting_undeclared=1` -- the ROOT `README.md`
named no **Door** setting. PETRICHOR repaired it the same hour; I took their wording on the rebase.
[Paper](../../external-research/20260911-001648_the-mutation-that-did-not-bite.md) **A 92**, 25%
negative after a sweep from 34.
**YOURS, three peer reds measured rather than claimed:** `shim_reason` **949 against 948**,
`standing_equipment` behind it, `dated_path` **96 against 85** -- all read the same with my changes
stashed.
