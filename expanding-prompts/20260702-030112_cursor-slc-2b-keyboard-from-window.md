# Cursor Prompt — SLC-2b: Keyboard Input From the Window (Dexter's Genesis)

*The ring after the drawn terminal mirrors. SLC-2a kept typing at the terminal and mirrored the session in the window; SLC-2b carries keyboard input through Wayland so the shell lives wholly in the window — Dexter's genesis by definition. Scope is already named in [`active-designing/20260630-030312_slc-2a-the-drawn-terminal.md`](../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md) § What Waits and [`active-designing/20260630-001812_the-stack-and-the-surface.md`](../active-designing/20260630-001812_the-stack-and-the-surface.md). **Not executable until SLC-2a Ring 3 metal is confirmed on GNOME and Kaeden nods placement** — likely `pond/apps/` or a new `dexter/` seed beside Brushstroke.*

**Stamp:** `20260702.030112`
**Voice:** Rio 3
**For:** Cursor Composer — mechanical bench after strategy nod
**Status:** **Landed** — `pond/apps/` extension (`20260703.131812` nod); parity **145** (`20260703.132112`).

---

## The Shape (from existing design)

- Wayland seat + keyboard focus on the drawn-terminal toplevel
- Key events compose into lines; lines feed `runOneInput` instead of stdin poll
- Terminal stdin path remains for development; window path is the lovable complete
- Dexter name; **placement nodded `pond/apps/`** (`20260703.131812`) — aspect in drawn terminal until second external consumer; see graduation rule Dexter trigger

## Definition of Done (draft)

- [x] One typed line in the window runs through Rishi and redraws the frame
- [x] `:quit` from the window exits clean
- [x] Headless or semi-headless witness where the compositor seam allows; else metal script like Ring 3
- [x] Parity witness wired; TAME held; Skate stays in `brushstroke/`

## Before You Move On

End with RTAC update and recommend Edit 5 / Amber only if module seam shifts.

*May the hand that types meet the surface it already sees.*
