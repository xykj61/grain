# Two checks, one green line

**Stamp:** `20261007.211328`
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Room:** checkable -- both checks below were read at this stamp
**Status:** Living -- Libra of the orbit that opens at commit 8,056
**Kin:** [`../mantra/README.md`](../mantra/README.md)

Commit 8,062 is Libra, cardinal air, fun. Two checks, one green line.

The first check is the recall pair. `mantra/recall_lap1.rye` asks the same name twice, at lines 367 and 369. Line 371 says the lengths are equal. Line 372 says the bytes are equal. Both lines still say that. The function stays as written.

The second check is the fascia face, and the bundle that moved it sits in the module paired with recall. `pond/apps/spread.rye` says its ceiling is paired with recall's own bound. `parse_manifest` reads the three facts a spread's name carries: the part count, the whole length, and the digest of the bytes. Those three calls now go through `tally_parse_int.parse_int`. The digest keeps `allow_leading_zero`, because a hex byte may be `00`. The part count and the length stay strict.

The meter, `tools/gen/chapter/fascia_metric.rish`, read before that edit:

`parseint=33` `fascia=58` `fascia_units=581000` `fascia_face=58.1000` `fascia_penalties=30000,39000,100000,250000`

And after:

`parseint=30` `fascia=58` `fascia_units=584000` `fascia_face=58.4000` `fascia_penalties=30000,36000,100000,250000`

The face moved by 0.3000. The whole number stayed 58. Both sit inside the bound of 1.0000. The root README badge still prints 58.

The spread selftest did not run. `rye/bin/rye build` refused `rye/lib` before it reached `pond/apps/spread.rye`. The reading above is the meter, not that binary.

The green line is `fascia_face=58.4000`.

Scorpio and Sagittarius are next. Sky of this orbit opens at commit 8,068.

May the same name keep returning the same bytes, and the three facts of that name stay one manifest.
