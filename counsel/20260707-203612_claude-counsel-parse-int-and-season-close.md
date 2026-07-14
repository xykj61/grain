# Claude Counsel — a Fourth TigerBeetle Mark, Found by Checking Rather Than Guessing

**Stamp:** `20260707.203612 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the alignment study's own deferred condition, checked rather than assumed closed
**Register:** A season closed, confirmed by direct verification, and a new ratchet found by re-checking a condition the original study left open
**Ground:** `tools/` re-scanned tree-wide on this fresh tip · every one of `enrich_strengthening_docs.rye`'s eight repointed call sites and `resolveRoot`'s three, checked by name and confirmed clean · TigerBeetle's `stdx.parse_int` read in full · all fifteen real `std.fmt.parseInt` call sites in this tree read for context before any were chosen · `tally/parse_int.rye` built, selftested, and used at three real sites, each rebuilt and reselftested afterward

*Written by Kaeden and Rio 3.*

---

## The Season, Confirmed Closed

This bench did not take the report's word for it. `tools/` camelCase functions: zero, re-measured directly. And the one risk named explicitly in the last counsel — `enrich_strengthening_docs.rye`'s eight external call sites, plus `resolveRoot`'s three callers across the files this season already finished — checked by name, one at a time, and found genuinely clean at every tier. Cursor followed the five-tier order precisely, including the cross-cutting touches this bench flagged as the place a stale reference would most likely hide. The whole TigerBeetle-alignment ratchet thread — camelCase, qualified asserts, compound asserts, `@memcpy`, zero-assert coverage — is now closed across the entire authored tree, tools included, not only the original scan directories.

## The New Ratchet, Found by Re-Checking Rather Than Assuming

The alignment study named two bans deferred on one condition each: adopt `stdx`'s PRNG and `parse_int` wrappers *"the day a first real call site appears, not before."* That condition was never re-checked until this counsel — and fifteen real `std.fmt.parseInt` call sites turned up across nine files, not one. `std.fmt.parseInt` accepts a leading zero silently; TigerBeetle's `parse_int` refuses one by default, precisely because a leading zero on parsed input is far more often a sign of truncation, injected data, or a copy-paste seam than a number anyone meant to write that way.

## The Nuance Worth Getting Right Rather Than Steamrolling

Reading all fifteen sites before choosing any of them turned up something a blanket migration would have gotten wrong. Two of the fifteen decode two-digit hex byte pairs — `"0a"`, `"0f"`, `"09"` — where a leading zero is an entirely ordinary, correct byte, not a warning sign. Applying the strict default there would have refused valid data the moment it was migrated. `tally/parse_int.rye`'s options carry `allow_leading_zero` explicitly for exactly this reason, and every call site states its own choice in the text rather than leaning on a default — the same "explicit options at the call site" discipline this tree already keeps for library calls generally.

## What Landed, Migrated and Verified

`tally/parse_int.rye`, ported from TigerBeetle's own `stdx.parse_int` at the letter, including the `@field(std.fmt, "parse" ++ "Int")` indirection that lets the one function whose entire job is calling the banned form exist without the ban seeing it — the identical shape TigerBeetle's own source already uses for the same reason. Its selftest proves both configurations for real: a leading zero refused on the strict decimal path, and the same leading zero welcomed explicitly on the hex-pair path.

Three real sites migrated, chosen for where the strictness genuinely matters most: `linengrow/receipt_core.rye`'s `parse_amount_signed` — a financial amount, now refusing a leading zero rather than silently accepting one — and two hex-pair decoders, in `receipt_core.rye` and `mantra/snapshot_export.rye`, each now stating `allow_leading_zero = true` in the open rather than depending on an unstated default. Both files rebuilt from bare and ran their full selftests GREEN afterward, tampered-input refusal paths included — the migration changed nothing about behavior except the one case it was meant to change.

## The Ratchet, Not Yet a Ban

Twelve real call sites remain, spread across seven files — epoch parsing in `snapshot_export.rye`, a generation/position pair in `mantra/src/main.rye`, and CLI-argument parsing across `caravan/` and `rishi/src/main.rye`. This bench is treating this the same way `@memcpy` and camelCase were treated while large: a counted ratchet that only ever falls, migrated on touch, not a hard ban imposed on a dozen sites at once. `tools/fixtures/tame_style_scan.sh` now prints this count on every run; it graduates to a hard ban the same way every other ratchet in this tree has — once it reaches zero honestly, not before.

One more thing worth naming plainly: writing this ratchet's counter the first time repeated a fragile pattern already sitting in the `@memcpy` counter above it — `grep -c`'s own printed zero, paired with an `|| echo 0` fallback that fires anyway because `grep -c` exits nonzero on no match, doubling the output into an invalid arithmetic expression. This bench found it because the new counter hit it immediately; the older one had simply never happened to test the zero case. Both are fixed now, the same way, since `grep -c` already prints the right number on its own and the fallback was never needed.

---

*May a deferred condition always be re-checked rather than assumed to still hold. May a hex byte and a decimal amount each be judged by what they actually are, never by one rule applied to both without asking. And may every ratchet, however new, fall exactly the way the ones before it did — one honest touch at a time.*
