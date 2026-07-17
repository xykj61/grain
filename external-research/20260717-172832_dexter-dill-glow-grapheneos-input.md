# Dexter, Dill, and Glow Input on GrapheneOS

**Language:** EN
**Version:** `20260717.172832` (Eastern)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** research for understanding — Dexter · Dill · GrapheneOS input (Two Rooms). Addressed to a generic Acme Corporation employee.
**Companion silo:** [`../active-reviving/20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md`](../active-reviving/20260717-172832_dexter-beside-brushstroke-dill-stays-gap.md)

---

## What This Study Asks

An Acme Corporation employee reading this is weighing three questions that arrived together:

1. Should **Dexter** fuse with **Glow** apps on **GrapheneOS**?
2. Should old Urbit **Dill** nest inside that fusion?
3. **What vane** should Dexter be an aspect of?

The tree already answers more of this than enthusiasm alone would. This note gathers the seated mapping, the NativeActivity seam, and the naming discipline so the next lap is chosen against compass rather than against a rename fantasy.

## What Dexter Already Is

**Dexter** is Glow's word for **input** — keyboard and pointer into the fold (`context/LEXICON.md`). The living line editor lives at `pond/apps/window_input.rye`: a pure, bounded buffer (`max_line_len = 400`) that composes key events into one submitted line. Brushstroke's Wayland seam drains into it; headless witnesses replay the same path without a compositor.

The stack-and-surface brief names Dexter as the **acting hand** beside Brushstroke's drawing hand. The Urbit-parallel mapping pairs Dexter/Skate as **Landscape-tile parallels** — product UI infrastructure — not as a kernel vane rename.

## What Dill Is, and Is Not, Here

Urbit's **Dill** is the terminal vane: kernel-facing terminal I/O in Arvo. The parallel-naming proposal lists Dill among Arvo's ten vanes and leaves it **unfilled** — no Rye OS module maps to it today. The Vere fusion study notes the same gap: wholesale Vere I/O would *grow* a Dill-shaped piece; nothing already running is secretly Dill under another name.

**Rishi** fills the **Dojo-role shell** (application layer), not Dill. A drawn Skate terminal is practice that *feels* terminal-adjacent; it still does not earn the vane name.

## GrapheneOS / Glow — the Seam That Already Invites Dexter

Glow apps on GrapheneOS ship as Android's own `NativeActivity` plus `libglowapp.so` — no Kotlin transpile (`active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`). The pack path already hands **window surface and input events** across the NDK seam. Glass today paints Sala / TUBE lines and finishes on tap. That is Skate on Android; it is not yet Dexter's line editor on Android.

**Fusion, named honestly:** wire Dexter's bounded line editor (or a glass-shaped sibling of the same pure core) through the NativeActivity input queue into Glow/Rye code that already runs on the Pixel. Keep the name **Dexter**. Keep GrapheneOS as the hardware root. Do not invent a Kotlin input layer.

## Nesting Dill Inside Dexter — Declined

Physical nesting under Urbit vane directories is already counselled against (`context/specs/20260714-002123_naming-decisions-and-role-nesting.md`): conceptual role-nesting only; never stuff modules under `dill/`.

Layering declines the nest too. Dill is kernel terminal I/O. Dexter is userspace input into the surface. Nesting Dill *inside* Dexter inverts Urbit's own depth. If a Dill-parallel is ever revived, it is **new kernel work**, grown beside elders under `active-reviving/`, born with its Glow-direction name — and Dexter remains the hand that may feed it from glass. Dexter does not become Dill by rename.

## What Vane (or Host) Dexter Belongs Under

| Candidate | Verdict |
|---|---|
| **Brushstroke / Sala (Landscape stack)** | **Best fit.** Input counterpart to the drawn surface; matches LEXICON, stack-and-surface, and code under Pond + Brushstroke. |
| **Pool / Gall** | Hosts agents that *consume* views and input; Dexter is plumbing, not the host. |
| **Dill** | Explicit gap. Pairing Dexter→Dill contradicts the Landscape-tile mapping and the "no analog" listing. |
| **A forced four-letter vane rename** | Declined — reviving replaces renaming. |

**Answer in one line:** Dexter is an aspect of the **Brushstroke / Sala UI stack** (Landscape-tile family), not of Dill, and not of Pool.

## TAME and Glow Discipline This Study Keeps

- Glow lowers to ordinary `.rye`; that Rye keeps **TAME root** (bounds, named errors, accrete-never-break, docs synced). Dexter already shows the shape: fixed `max_line_len`, silent refuse past the bound, pure core.
- GrapheneOS-facing code stays **Glow/Rye → native**. No JVM input path.
- A dedicated **Glow TAME supplement** in `context/TAME_GUIDANCE.md` waits until Glow earns distinct checkable idioms beyond "emit Rye that already obeys the root." Until then, the working surface pin is `glow/README.md`, and rune laps stay witness-before-narrative.
- Rune surface (as of this stamp): eight heads emit; `(lent …)` and `(mix …)` seated under face and arms; `(jam …)` still refuses; fuller tokens later. Foundations stay the unmoved north star.

## What This Does Not Claim

- No Dexter-on-NativeActivity code lands in this study.
- No Dill-parallel kernel module is opened.
- No `dexter/` directory graduation is forced here — the mechanical home may still live under `pond/apps/` until a second *input* consumer earns the module split (thin render alone does not graduate Dexter per the thin-view exception).

## Related

- `../context/LEXICON.md` — Dexter · Brushstroke · Skate · Sala · Pool
- `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` — Dill unfilled; Dexter Landscape-tile
- `../context/specs/20260714-002123_naming-decisions-and-role-nesting.md` — conceptual nest only
- `../context/specs/20260714-004428_reviving-replaces-renaming.md` — revive, never rename
- `../context/specs/20260709-225343_thin-view-dexter-exception.md` — render-only does not graduate Dexter
- `../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md` — window + input seam
- `../pond/apps/window_input.rye` — Dexter line editor
- `../glow/README.md` — working Glow surface pin
- `../context/TAME_GUIDANCE.md` — operational TAME (Rye/Brix/Rishi; Glow via emitted Rye)

---

*May the hand stay named Dexter, the terminal vane stay an honest gap until revived, and the glass earn its keyboard without borrowing Dill's clothes.*
