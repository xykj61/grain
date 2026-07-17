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
| **TUBE0.5** | Permissions emit; NativeActivity envelope; signed APK with Sala B0 fold; install + `sala_root.txt` on HAWM0 and Pixel 10a | `tools/tube0_5_android_permission_witness.rish` · `tools/tube05_envelope_witness.rish` · `tools/tube05_apk_pack_witness.rish` · `tools/tube05_install_proof_onpath_host.rish` | **GREEN** pack · Sala wire · HAWM0 `20260717.122010` · **Pixel `20260717.123226`** |
| **TUBE1** | Pool admits an agent iff manifest caps match a grant | — | design (needs agent runtime) |
| **TUBE2–5** | Signed publish · resins · market · Mantra revisions | — | design |
| **TUBE6–7** | Whole stack on GrapheneOS build / physical Pixel | — | joins [`HAWM.md`](HAWM.md) |

---

## What TUBE0.5 packs today

```bash
rishi/bin/rishi run tools/tube05_apk_pack_witness.rish
# → tools/.cache/tube05/sala-broadcaster.apk
#    package org.glow.app.sala_broadcaster
#    NativeActivity + lib/{arm64-v8a,x86_64}/libglowapp.so (NDK-linked, DT_NEEDED libc)
#    onCreate runs Sala B0; writes files/sala_root.txt (HAWM1 demo root)
#    INTERNET from the closed permission table
```

| Piece | Path |
|-------|------|
| Permission emission | `linengrow/tube_manifest_android_permission.rye` |
| Full AndroidManifest.xml | `linengrow/tube_android_manifest.rye` |
| Sala B0 fold (same root as HAWM1) | `linengrow/sala_b0_fold.rye` |
| Native entry (`ANativeActivity_onCreate`) | `linengrow/glow_native_activity.rye` |
| Pack worker | `tools/tube05_apk_pack_worker.sh` |

**Install GREEN** — HAWM0 `20260717.122010` · physical Pixel 10a `20260717.123226` (`sala_root.txt` = HAWM1 demo root both times). Re-run anytime:

```bash
# Host terminal (not ai-jail):
rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish   # emulator path
# or: Pixel USB debugging authorized, then:
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
# → 99b3ae967c5a230acfc598a7e949b3c2c638ce996be47a51a7c9f8cb12e4c5fe
```

**Still open:** NativeActivity surface/finish. Debug keystore under `tools/.cache/tube05/` is host-local, never for publish.

---

## Decision pinned

No Glow→Kotlin/JVM transpiler — [`active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`](../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md). Full ladder plan: [`expanding-prompts/20260716-142818_…`](../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md).

Device ladder this joins: [`HAWM.md`](HAWM.md).

---

*May the manifest stay a mold, and the APK stay an envelope around native truth.*
