# Pixel 10a resolution, Mantrapod floor, and Wired Glass SLC

*World study for Glow Glass display presets and a used-Pixel, wire-synced product path. Clean-room: public hardware specs and this tree’s own Mantrapod / Nix-infuse / Tablecloth research — no vendor settings UI copied.*

**Stamp:** `20260718.122145` (Eastern)  
**Status:** Research — mixed rooms (panel max checkable · Mantrapod floor design-provisional)  
**Voice:** Quin · Acme reader address  
**Silo:** [`../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md`](../active-designing/20260718-122145_hearth-lulu-display-presets-short-home-and-zeta6-send.md)  
**Prompt:** [`../expanding-prompts/20260718-122145_glow-glass-display-short-home-and-dexter-send.md`](../expanding-prompts/20260718-122145_glow-glass-display-short-home-and-dexter-send.md)

---

## Pixel 10a panel (public specs)

Google’s own Pixel phone hardware tech specs (Pixel 10a, 2026) name:

| Field | Value |
|-------|--------|
| Size | 6.3-inch Actua pOLED |
| Aspect | **20:9** |
| Resolution | **1080 × 2424** |
| Density | ~422 ppi |
| Refresh | Smooth Display 60–120 Hz |

Sources for an Acme employee to re-check: [Google Pixel phone hardware tech specs](https://support.google.com/pixelphone/answer/7158570) · store Pixel 10a specs page. GSMArena and press repeat the same 1080×2424 / 20:9 numbers.

**Checkable claim for LULU:** on this SLC body, panel max is 1080×2424 @ 20:9. Runtime `ANativeWindow` width/height remains the live oracle when a preset says “use panel max.”

---

## Same-ratio lower presets (macOS-shaped idea, Glow-owned table)

macOS offers scaled resolutions that keep aspect and trade sharpness for density. Glow’s version is a **closed Bron/Brix table**, not a free integer:

| Preset id | Logical W×H | Notes |
|-----------|-------------|--------|
| `panel_max` | 1080 × 2424 | Device max when body is Pixel 10a-class |
| `scaled_720` | 720 × 1616 | Same 20:9 (720 × 2424/1080) |
| `scaled_540` | 540 × 1212 | Same 20:9 |
| `mantrapod_floor` | *provisional* | See below — never below Skate layout budget |

Aspect lock: `assert(9 * width == 20 * height)` fails closed for 20:9 phone bodies; Desk bodies use a separate Desk table later.

Today’s glass path (`glow_native_surface.rye`) only picks Skate **scale** 2–5 from window height. That is a paint heuristic, not a declared preset. LULU replaces the heuristic with a looked-up preset once LULU1 lands.

---

## Mantrapod e-ink floor (honest register)

| Source | What it says about resolution |
|--------|-------------------------------|
| [`../foundations/20260629-020012_mantrapod-venture-pitch.md`](../foundations/20260629-020012_mantrapod-venture-pitch.md) | Reflective e-ink, no radios, single wire — **no panel pixel count** |
| [`../work-in-progress/20260702-014112_horizons-and-blind-spots.md`](../work-in-progress/20260702-014112_horizons-and-blind-spots.md) | Brushstroke+Skate → e-ink partial refresh; Comlink over USB CDC-NCM (**Setu** name candidate) |

**Design-provisional floor (until a panel SKU is sourced):** the seated Glow Glass layout word needs **≥32 Skate cols × 20 rows**. At minimum readable scale **2**:

- width ≥ `32 × 8 × 2` = **512** px  
- height ≥ `20 × 16 × 2` = **640** px  

That content budget must fit inside every LULU preset (letterboxed or pillarboxed if the panel aspect differs). For **20:9 phone presets**, the lowest table row that still clears 512×640 content is **`scaled_540` (540×1212)** — height and width both above the budget. A future Mantrapod panel may be closer to square or 4:3; then the floor preset is re-derived from the same Skate budget, not from phone 20:9.

**Two Rooms:** budget math is checkable; “this e-ink SKU is N×M” is **not** claimed until sourced.

---

## Nix infuse → Glow store (gratitude, clean-room)

| Inherit (ideas) | Decline |
|-----------------|--------|
| Content-addressed hold; immutable accretion; parameterized declarations; desugar-to-canonical; monoid merge | Nix language, lazy eval, linking `libnix` |

Canon study: [`yonder/20260619-225212_s6-sixos-nix-infuse.md`](yonder/20260619-225212_s6-sixos-nix-infuse.md) · map already seated: **Brix declares · Tablecloth holds · Caravan supervises**.

**Short home (`kd`):** a two-character `home_id` in a Bron hearth record — the Glow parallel to a short `/home/xy`-style identity people can say and type on a low-density glass. Not a Nix profile; not `/nix/store`. Persistence: Bron file first (LULU0); Mantra/Tablecloth when store v1 opens.

---

## Wired Glass SLC (used Pixel, no cellular plan)

**Problem an Acme employee can recognize:** a used Pixel with GrapheneOS is affordable; a cellular plan is not. The person still needs sync, updates, and a path to the network.

**Product shape (design):**

1. **Glow Glass** on GrapheneOS — radios for cellular may stay off; Wi-Fi optional.  
2. **USB wire** to **Glow Desk** (Framework / station) that *does* have internet.  
3. Sync over that wire — Mantrapod’s single-wire spirit; Comlink/Setu CDC-NCM is the named horizon seam (`20260702` horizons map).  
4. Same LULU presets + Skate layout word so software proven on Pixel remains honest on future Mantrapod e-ink.

**Already GREEN nearby:** HAWM3 GrapheneOS on Pixel 10a · TUBE0.5 APK install over adb USB · outer-terminal install card in `REMEMBER.md`.  
**Still horizon:** Setu name affirm · CDC-NCM Comlink lap · “cellular off” as a witnessed metalsmoke checklist.

---

## iOS send vs return (layout family only)

Prior keyboard study ([`20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md`](20260717-175220_glow-english-qwerty-glass-keyboard-ios-inspired.md)) took **mode family** (letters / 123 / #+= / emoji), not Messages send chrome.

Public iOS Messages pattern (observation, not assets): multiline field; return inserts newline; a separate upward control sends. Glow’s clean-room parallel for ZETA6: paint `↑` (or `send`) as its own hit key → Dexter `.submit`; `ret` → newline action.

---

## Gratitude / licenses

| Project | License posture |
|---------|-----------------|
| Nix / infuse.nix | Study only — LGPL/MIT ideas; no link |
| Google Pixel specs | Public documentation citation |
| Apple Messages | Public UX observation; no assets |

---

*May every preset keep the fold readable, and every wire carry home without a tax on the air.*
