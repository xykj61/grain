# Pacific Time — The Local-Clone Stamp Convention

**Language:** EN
**Version:** `20260713.201910`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — addendum to the one-clock naming law, scoped to this local clone

---

## What This Adds

[`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) names the shape of a stamp — `YYYYMMDD.HHMMSS`, one clock, supplied verbatim by Kaeden — but it names no timezone. That silence traveled unremarked through the `veganreyklah2` upstream. This local clone, forked into `~/urbit` on this Mac, makes the silence explicit rather than carrying it forward unstated:

**This local clone's stamps are Pacific Time — the zone Reno, NV keeps.** Pacific Daylight Time (`UTC-7`) from roughly mid-March to early November; Pacific Standard Time (`UTC-8`) the rest of the year. `TZ=America/Los_Angeles` on this machine already resolves to the correct offset for either half of the year — Reno, NV observes the same civil clock as the Pacific coast, despite sitting in Nevada.

## Why It Is Shaped This Way

- **The law already said stamps come from Kaeden, verbatim.** This addendum does not change that rule; it names *which clock* Kaeden's wall reads, so a future reader — human or agent — is not left guessing whether an untagged stamp meant UTC, Pacific, or something else.
- **Existing dated stamps are not rewritten.** Accrete, never break: every `.bron` log and every dated doc stamped before this addendum keeps its stamp exactly as written. This document governs stamps written **from here forward** on this local clone.
- **Upstream and this fork may diverge here, and that is fine.** If `groupproject36/veganreyklah2` later states its own timezone convention, this fork's Pacific convention stands on its own — the two histories are already diverging by design (see `SOURCE.md` and the fork rationale in this project's own root).

## In Practice

```bash
TZ='America/Los_Angeles' date '+%Y%m%d.%H%M%S'
```

reads the correct stamp for a new `.bron` session log, a new dated spec, or any other one-clock artifact on this clone.

---

*May the clock stay one clock, and may it always say plainly which one it is.*
