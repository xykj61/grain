# UDT — The Framework Host's Stamp Convention (UTC)

**Language:** EN  
**Version:** `20260720.232932`  
**Style:** Radiant (see `../RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Living — addendum to the one-clock naming law, scoped to this Framework 16 AMD Ubuntu host  
**Co-author:** Keaton Dunsford (`xykj61`)

---

## What This Adds

[`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) names the stamp shape and leaves timezone to each host. This Framework host already carried Pacific, then Eastern ([`20260717-003132_eastern-time-framework-host-convention.md`](20260717-003132_eastern-time-framework-host-convention.md)). Keaton has now set this machine's system clock to **UDT** — the project's long-standing label for **UTC** (same wall as `Etc/UTC` / GMT+0000), matching the Cursor iOS / cloud season that stamped today's STOA arc in UTC.

**This host's stamps are UDT (UTC), from `20260720.232932` forward.**

## Why It Is Shaped This Way

- **Stamps come from Keaton, verbatim.** This addendum names which clock the wall reads here, so agents and future readers do not guess Eastern vs UTC after a real system-clock switch.
- **UDT is the tree's own UTC word.** Early ratified stamps already write `… UDT` beside one-clock times; seating UDT here aligns the Framework host with that label and with the iOS cloud season, rather than inventing a third name for the same zero-offset clock.
- **Prior host conventions stay readable.** Pacific (macOS) and Eastern (this host `20260717.003132`…before this stamp) are never rewritten. Accrete, never break: each note governs stamps written **from its own stamp forward**, on its own host only.
- **The switch is deliberate.** Keaton set Ubuntu's system time to UDT for file writing and stamps so Framework and iOS share one readable clock for this season.

## In Practice

```bash
TZ='Etc/UTC' date '+%Y%m%d.%H%M%S'
# or, when the system clock is already UDT:
date '+%Y%m%d.%H%M%S'
```

Optional prose tag: append `UDT` in headers where a timezone label helps (`20260720.232932 UDT`). Filenames stay hyphen form without a timezone suffix.

`GLOW_PROFILE.bron` on this host points `timezone Etc/UTC` and `timezone_label UDT (UTC)`.

## Related

- [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) — the law this addends  
- [`20260717-003132_eastern-time-framework-host-convention.md`](20260717-003132_eastern-time-framework-host-convention.md) — prior Framework convention (Eastern), superseded for *new* stamps from this document forward  
- [`20260713-201910_pacific-time-local-clone-convention.md`](20260713-201910_pacific-time-local-clone-convention.md) — macOS clone, unaffected  
- [`.cursor/rules/session-logs.mdc`](../../.cursor/rules/session-logs.mdc) · [`.claude/rules/session-logs.md`](../../.claude/rules/session-logs.md)

---

*May every host name its clock, and may UDT stay the honest zero for the seasons that share it.*
