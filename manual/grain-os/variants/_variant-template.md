# Glow OS Variant -- `{{VARIANT}}`

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Template -- fill `{{VARIANT}}` with one of Reya / Riyo / Trey / Triz; do not hand-edit the fills, regenerate from this template

---

**Navigation:**
[Hub](../README.md) - [Overview](../overview.md) - [The Five Variants](README.md)
- Siblings: `reya.md` - `riyo.md` - `trey.md` - `triz.md`

---

## What `{{VARIANT}}` Is

`{{VARIANT}}` is one of the four Glow OS variants -- one implementation of the single Glow OS design, written in Glow, governed by TAME Guidance. Everything true of Glow OS as a whole (the overview) is true of `{{VARIANT}}`; this page names only what is specific to `{{VARIANT}}`.

## Its Pair and Its Difference

- **Diverse-redundancy pair:** `{{VARIANT}}` pairs with its twin for safety -- the same design implemented independently, so one implementation fault cannot fell both. The two pairs stand confirmed (`20260714.035600`): **Riyo/Reya** and **Trey/Triz**. One choice stays open at build time -- the *shape* of the redundancy: two separate codebases from one spec, or one codebase with two independently-verified paths.
- **What differs:** the twins agree on all external behavior and may differ only in internal implementation detail. A shared witness suite that both twins pass identically keeps "diverse" from drifting into "divergent."

## Booting `{{VARIANT}}`

```bash
# Placeholder identity only -- never a real @p (see the placeholder-ship-names rule)
# glow-os boot --variant {{VARIANT}} --fake ~acme-corp-test-ship
```

*(Proposed; the boot path is scaffold, not yet built. This block will fill in when `{{VARIANT}}` lands a boot witness.)*

## Status

- **Named:** yes.
- **Confirmed:** see the names checklist.
- **Built:** scaffold, not yet running. This page marks what is real as each piece lands.

---

**Navigation:**
[Hub](../README.md) - [Overview](../overview.md) - [The Five Variants](README.md)
