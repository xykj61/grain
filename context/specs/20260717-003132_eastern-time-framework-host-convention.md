# Eastern Time — The Framework Host's Own Stamp Convention

**Language:** EN
**Version:** `20260717.003132`
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Living — addendum to the one-clock naming law, scoped to this Framework 16 AMD Ubuntu host
**Co-author:** Keaton Dunsford (`xykj61`)

---

## What This Adds

[`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) names the shape of a stamp — `YYYYMMDD.HHMMSS`, one clock, supplied verbatim by Keaton — but names no timezone. [`20260713-201910_pacific-time-local-clone-convention.md`](20260713-201910_pacific-time-local-clone-convention.md) filled that silence for the macOS clone with Pacific Time. This document fills it, separately and explicitly, for a different real machine: **this Framework 16 AMD laptop, running Ubuntu, switched by Keaton's own hand from Pacific to Eastern Time (New York).**

**This host's stamps were Eastern Time, from `20260717.003132` forward through the day before the UDT switch.** Eastern Daylight Time (`UTC-4`) from mid-March to early November; Eastern Standard Time (`UTC-5`) the rest of the year. `TZ=America/New_York` on this machine resolves to the correct offset for either half of the year.

**Later switch:** from `20260720.232932` forward on this same Framework host, Keaton set the system clock to **UDT** (UTC). That season is recorded in [`20260720-232932_udt-framework-host-convention.md`](20260720-232932_udt-framework-host-convention.md).

**Return:** from `20260722.125845` forward, Keaton asked stamps back to Eastern / EDT. Living stamps follow [`20260722-125845_edt-framework-host-convention.md`](20260722-125845_edt-framework-host-convention.md). Every prior era's stamps on this host stay readable.

## Why It Is Shaped This Way

- **The law already said stamps come from Keaton, verbatim.** This addendum does not change that rule; it names *which clock* Keaton's wall reads on this specific host, so a future reader — human or agent — is not left guessing whether an untagged stamp meant UTC, Pacific, Eastern, or something else.
- **This is a second, separate host, not a correction to the first.** The macOS clone's own Pacific convention stands exactly as written — nothing about that document is wrong, and nothing here supersedes it. Two real machines, two real clocks, two conventions, named honestly rather than forced to agree.
- **Existing dated stamps are not rewritten.** Accrete, never break: every `.bron` log and every dated doc stamped on this host before this addendum, under the earlier Pacific convention (`GLOW_PROFILE.bron`'s own prior `timezone America/Los_Angeles`), keeps its stamp exactly as written. This document governs stamps written on this host **from here forward**.
- **The switch is a real, deliberate act, named plainly.** Keaton set this Ubuntu 26.04 LTS GNOME Wayland host's own system clock to New York time; this document exists so the tree's own stamps follow that real change rather than silently drifting out of sync with the machine that actually produces them.

## In Practice

```bash
TZ='America/New_York' date '+%Y%m%d.%H%M%S'
```

reads the correct stamp for a new `.bron` session log, a new dated spec, or any other one-clock artifact on this host, from this document's own stamp forward.

`GLOW_PROFILE.bron`'s own `timezone` and `timezone_label` fields on this host are updated to match, in the same commit as this document — the profile is the machine-local pointer; this spec is the durable, committed record of why.

## Related

- [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) — the law this addends.
- [`20260713-201910_pacific-time-local-clone-convention.md`](20260713-201910_pacific-time-local-clone-convention.md) — the macOS clone's own, separate, unaffected convention.
- [`../../.cursor/rules/session-logs.mdc`](../../.cursor/rules/session-logs.mdc) · [`../../.claude/rules/session-logs.md`](../../.claude/rules/session-logs.md) — both name this host's own Eastern convention alongside the macOS clone's Pacific one, per-host rather than tree-wide.

---

*May the clock stay one clock on every machine, and may each machine's own document say plainly which one it is.*
