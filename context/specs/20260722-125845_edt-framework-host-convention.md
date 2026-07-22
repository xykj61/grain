# EDT — The Framework Host Returns to Eastern Time

**Language:** EN  
**Version:** `20260722.125845`  
**Style:** Radiant (see `../RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Living — addendum to the one-clock naming law, scoped to this Framework 16 AMD Ubuntu host  
**Co-author:** Keaton Dunsford (`xykj61`)

---

## What This Adds

[`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) leaves timezone per host. This Framework host carried Pacific, then Eastern ([`20260717-003132_eastern-time-framework-host-convention.md`](20260717-003132_eastern-time-framework-host-convention.md)), then **UDT** ([`20260720-232932_udt-framework-host-convention.md`](20260720-232932_udt-framework-host-convention.md)). After a rest, Keaton asked to return stamps to **EDT** — Eastern Daylight Time on the `America/New_York` wall (UTC−4 in summer; EST / UTC−5 in winter).

**This host's stamps are Eastern Time (`America/New_York`), from `20260722.125845` forward.**

In July that wall reads **EDT**. The zone name stays `America/New_York` so the same pointer stays honest when the US falls back to EST.

## Why It Is Shaped This Way

- **Stamps come from Keaton, verbatim.** This note names which clock the wall reads here after the UDT season, so agents do not keep writing UTC stamps once the hand has asked for Eastern again.
- **UDT-era stamps stay readable.** Everything stamped `20260720.232932`…before this seating keeps its UDT meaning. Accrete, never break: each convention governs stamps written **from its own stamp forward**, on this host only.
- **Same Eastern family as `20260717.003132`.** This is a return, not a third inventary clock — New York time again, after an intentional UTC season.

## In Practice

```bash
TZ='America/New_York' date '+%Y%m%d.%H%M%S'
```

Optional prose tag: append `EDT` (or `EST` in winter) in headers where a label helps. Filenames stay hyphen form without a timezone suffix.

`GLOW_PROFILE.bron` on this host points `timezone America/New_York` and `timezone_label Eastern (EDT in summer · EST in winter)`.

Keaton set Ubuntu **Settings → Date & Time** to **New York** at `20260722.130034` (confirmed: `date` prints `EDT -0400`; `/etc/localtime` → `America/New_York`). Plain `date '+%Y%m%d.%H%M%S'` is enough for stamps on this host now. `TZ=America/New_York` remains a fine explicit override if a shell ever inherits a different zone.

## Related

- [`20260627-102012_one-clock-naming-law.md`](20260627-102012_one-clock-naming-law.md) — the law this addends  
- [`20260720-232932_udt-framework-host-convention.md`](20260720-232932_udt-framework-host-convention.md) — prior UDT season on this host  
- [`20260717-003132_eastern-time-framework-host-convention.md`](20260717-003132_eastern-time-framework-host-convention.md) — first Eastern seating  
- [`.cursor/rules/session-logs.mdc`](../../.cursor/rules/session-logs.mdc) · [`.claude/rules/session-logs.md`](../../.claude/rules/session-logs.md)

---

*May every return to a named clock be as plain as the first seating.*
