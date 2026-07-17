# Glow English QWERTY Glass Keyboard — Graphene IME vs Own Hand, iOS-Inspired SLC

**Language:** EN
**Version:** `20260717.175220` (Eastern)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** research for understanding — OSK ownership · iOS public layout notes · NativeActivity IME gap (Two Rooms). Addressed to a generic Acme Corporation employee.
**Companion silo:** [`../active-designing/20260717-175220_dexter-english-qwerty-glass-keyboard.md`](../active-designing/20260717-175220_dexter-english-qwerty-glass-keyboard.md)

---

## What This Study Answers

An Acme Corporation employee reading this is weighing four facts that arrived together on Pixel glass:

1. Dexter D3 look is **GREEN** for install and the `DEXTER line · glow` claim.
2. The person **does not see** a soft keyboard to type with, and **does not see** a blinking terminal cursor.
3. Should Glow use **GrapheneOS / AOSP’s** system IME, or implement its **own** English QWERTY?
4. Preference named: **own** English standard QWERTY — same *layout and behavior family* as the latest iOS keyboard (letters · numbers · symbols · emoji), SLC first, other languages later.

## Why `showSoftInput` Did Not Show a Keyboard

D3 correctly calls `ANativeActivity_showSoftInput` and drains `AINPUT_EVENT_TYPE_KEY` into Dexter. On a bare `NativeActivity` there is **no focused editable text field and no `InputConnection`**. Android’s Input Method Framework (what GrapheneOS inherits from AOSP LatinIME and friends) attaches to that connection. Without it, the system keyboard often **refuses to appear**, and soft keys that do appear on other apps never become KEY events for our `.so`.

| Path | Verdict on Glow glass today |
|---|---|
| Graphene / AOSP system IME via `showSoftInput` | **Insufficient alone** — needs Java/Kotlin editable host or a full IME-client bridge; fights the Glow/Rye → native law |
| Hardware KEY / Bluetooth keyboard | Works when KEY events arrive (D3 path already drains them) |
| **Glow-owned on-Skate keyboard** | **Recommended** — paint keys, map taps → existing Dexter `Action`, no IME attachment required |

**Honest D3 close:** Pixel look GREEN for the painted Dexter claim; soft keyboard **absent** and cursor blink **absent** are named gaps, not failures of the KEY mapper.

## Graphene’s Keyboard vs Our Own

| Choice | For | Against |
|---|---|---|
| Rely on Graphene’s IME | Familiar system chrome; no key painting | Unreliable on NativeActivity; Kotlin/TextView gravity; layout not ours; emoji/IME versions drift with the OS |
| **Implement Glow English QWERTY on Skate** | Matches preference; TAME bounds; same Action path as Wayland Dexter; GrapheneOS stays hardware root | We paint and hit-test; emoji SLC must stay bounded |

**Recommendation:** implement our own. GrapheneOS remains the **device root**; the **hand** on glass is Dexter’s, including the on-screen keyboard.

## iOS Inspiration — Public Notes Only (Clean Room)

We study **public** descriptions of how the English iOS onscreen keyboard is *organized*. We do **not** copy Apple assets, fonts, artwork, haptics binaries, or proprietary source. Glow paints its own Skate keys under TAME.

Public sources used this sitting (gratitude; study boundary):

| Source | What it teaches (layout / behavior family) |
|---|---|
| Apple Support — add/change keyboards, switch keyboards (iOS user guides) | English + Emoji as default pair; globe / emoji affordance to switch modes |
| Apple Developer — Custom Keyboard / `UIInputViewController` docs | Mode switching is first-class; ASCII-capable English; width flexibility |
| AFB AccessWorld — “Entering Text on an iPhone” | Three letter rows; **123** toggles numbers; **#+=** / symbols page; emoji categories along the bottom; Return / Delete placement intuition |
| Older Apple Text Programming Guide (archived) | Default keyboard starts alphabetic; user toggles numbers/punctuation |

### English SLC mode map (iOS-inspired, Glow-owned names)

| Mode | Content (SLC) |
|---|---|
| **Letters** | Three QWERTY rows: `qwertyuiop` · `asdfghjkl` · `zxcvbnm`; shift; delete; **123**; space; return; **emoji** |
| **Numbers** | Top row `1234567890`; common punctuation on lower rows; **#+=** → symbols; **ABC** → letters |
| **Symbols** | Further punctuation / specials; **123** / **ABC** returns |
| **Emoji** | Bounded “frequently used” strip + a few category tabs (SLC subset — not the full Unicode emoji catalog) |

Shift behavior (SLC): tap shift → next letter uppercase; double-shift (later) for caps-lock. Space / return / delete match Dexter `Action` already seated (`.char_` · `.submit` · `.backspace`).

Other languages and alternate layouts (AZERTY, one-handed, trackpad-on-space, dictation mic) stay **horizon**.

## Compass · Grain · TAME · Glow Runes

| Strand | Fit |
|---|---|
| **Compass** | Product finishing edge: the hand on glass is incomplete until keys and cursor are visible |
| **Sameness** | One Action model; no private input macros |
| **Witness habitat** | Layout tables and tap→Action proven device-free; Pixel look is thin-edge metalsmoke |
| **TAME** | Bounded key grid, named refuses, no hidden allocation; docs synced with code |
| **Glow runes** | Keyboard is **product glass**, not a new rune form — foundations and `glow/README.md` stay the language pin |
| **Graphene path** | Glow/Rye → native; no Kotlin IME host |

## What This Does Not Claim

- It does not ship painted keys in this study.
- It does not copy Apple’s keyboard artwork or claim iOS compatibility certification.
- It does not implement every iOS gesture (flick, trackpad-on-space, QuickPath) in SLC.
- It does not revive Dill.

## Related

- Dexter reviving silo `20260717-172832`
- D3 KEY drain `linengrow/dexter_glass_key.rye` · `glow_native_activity.rye`
- Happy zone / witness habitat · Two Rooms · TAME
- Apple Support keyboard guides · AFB AccessWorld iPhone text entry · Apple Custom Keyboard docs (study only)

---

*May the hand we paint be our own, and every key prove itself before it promises a letter.*
