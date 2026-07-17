# TUBE — Glow application framework ladder

*App = Pool agent. Manifest = bounded mold. Publish = signed fold. Packaging = NativeActivity envelope over Glow-built native code — never a Kotlin transpiler.*

**Status:** Checkable — operator compressor (host-side TUBE0 / TUBE0.5 GREEN)
**Depth:** guide
**Ceiling:** ≤150 lines
**Last updated:** 2026-07-17
**Compresses:** [`20260716-142818_glow-application-framework-and-publishing.md`](../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md) · [`20260717-014522_native-activity-shim-and-slc-packaging.md`](../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md)

---

## Thesis — emission, not transpilation

A Glow app declares itself with a **TUBE0** manifest (name, version, capabilities, iteration bound). Android packaging does not rewrite Glow into Kotlin. It **emits** permission lines from a closed table and wraps the Glow-built `.so` in Android's own `NativeActivity` (`hasCode=false`). Every rune, bound, and assertion stays native.

Language path and device path meet here: Glow's fold (language) becomes an installable APK on GrapheneOS (HAWM).

---

## Rung table

| Rung | Claim | Primary witness | State |
|------|-------|-----------------|-------|
| **TUBE0** | App-manifest mold validates at the boundary | `tools/tube0_manifest_witness.rish` | GREEN |
| **TUBE0.5** | Permissions emit; NativeActivity envelope; signed demo APK with `libglowapp.so` | `tools/tube0_5_android_permission_witness.rish` · `tools/tube05_envelope_witness.rish` · `tools/tube05_apk_pack_witness.rish` | **host-side GREEN** `20260717.021857` |
| **TUBE1** | Pool admits an agent iff manifest caps match a grant | — | design (needs agent runtime) |
| **TUBE2–5** | Signed publish · resins · market · Mantra revisions | — | design |
| **TUBE6–7** | Whole stack on GrapheneOS build / physical Pixel | — | joins [`HAWM.md`](HAWM.md) |

---

## What TUBE0.5 packs today

```bash
rishi/bin/rishi run tools/tube05_apk_pack_witness.rish
# → tools/.cache/tube05/sala-broadcaster.apk
#    package org.glow.app.sala_broadcaster
#    NativeActivity + lib/arm64-v8a/libglowapp.so
#    INTERNET from the closed permission table
```

| Piece | Path |
|-------|------|
| Permission emission | `linengrow/tube_manifest_android_permission.rye` |
| Full AndroidManifest.xml | `linengrow/tube_android_manifest.rye` |
| Native entry (`ANativeActivity_onCreate`) | `linengrow/glow_native_activity.rye` |
| Pack worker | `tools/tube05_apk_pack_worker.sh` |

**Still open:** `adb install` on the Pixel 10a; a real Glow fold inside the native entry (today's entry is a symbol-shape stub). Debug keystore under `tools/.cache/tube05/` is host-local, never for publish.

---

## Decision pinned

No Glow→Kotlin/JVM transpiler — [`active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`](../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md). Full ladder plan: [`expanding-prompts/20260716-142818_…`](../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md).

Device ladder this joins: [`HAWM.md`](HAWM.md).

---

*May the manifest stay a mold, and the APK stay an envelope around native truth.*
