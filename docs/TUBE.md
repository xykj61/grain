# TUBE — Glow application framework ladder

*App = Pool agent. Manifest = bounded mold. Publish = signed fold. Packaging = NativeActivity envelope over Glow-built native code — never a Kotlin transpiler.*

**Status:** Checkable — operator compressor (TUBE0 / TUBE0.5 / TUBE1–5 / TUBE7 GREEN; Resource Scope · Network · Sensors Grants GREEN; TUBE6 horizon)
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
| **TUBE1** | Pool admits an agent iff manifest caps match a grant | `tools/tube1_admission_witness.rish` · glass gate `tube1_glass_gate.rye` | **GREEN** device-free `20260717.131000` · glass + Pixel `20260717.131404` |
| **TUBE2** | Maker signs app+manifest into Granary; consumer verifies before install | `tools/tube2_publish_witness.rish` · glass `tube2_glass_pub.rye` | **GREEN** device-free `20260717.131500`; glass + Pixel `20260717.144536` |
| **TUBE3** | Manifest resin fetched by digest under Comlink seal; verified before admit | `tools/tube3_resin_fetch_witness.rish` · glass `tube3_glass_fetch.rye` | **GREEN** device-free `20260717.133900`; glass + Pixel `20260717.145328` |
| **TUBE4** | Price on Exchange, settle via Neth, unlock sealed fetch | `tools/tube4_market_rail_witness.rish` · glass `tube4_glass_market.rye` | **GREEN** device-free `20260717.134300`; glass + Pixel `20260717.145547` |
| **TUBE5** | Update as a Mantra revision; rollback selects prior rev | `tools/tube5_mantra_revision_witness.rish` · glass tip `tube5_glass_tip.rye` | **GREEN** device-free `20260717.135200`; glass pack + Pixel look `20260717.140600` |
| **TUBE6** | Whole stack on real GrapheneOS build | — | horizon — needs HAWM2 |
| **TUBE7** | Packaging + admit + rail present on physical Pixel | TUBE0.5 install · TUBE1–5 glass | **GREEN** `20260717.145547` — Pixel look for 0.5+T1–T5; HAWM3 already closed |

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

**Surface + Skate on Pixel GREEN `20260717.125858`:** `glow_native_surface.rye` rasterizes Brushstroke Skate onto the ANativeWindow; Keaton confirmed on-device. Fold + `sala_root.txt` still land in onCreate; tap finishes.

**Thin-view on glass GREEN `20260717.130602`:** R1 path landed; Keaton confirmed ledger lines on Pixel.

**R2 surface on glass GREEN `20260717.130848`:** `sala_r2_surface.rye` hosts ask · receipt · reputation (capability-isolated) onto one `sala_surface.Surface`; Skate paints `[ask] issuer 200` / `[receipt] issuer 250` / `[reputation] issuer 275` above the B0 hex. Install proof GREEN; Keaton confirmed on Pixel.

**TUBE1 glass gate GREEN `20260717.131404` · cover `20260717.161220`:** `tube1_glass_gate.rye` admits sala-broadcaster (three state resources + `photos` + `contacts`) before R2 paints; covering Storage · Contact Scopes are load-bearing. Title `SALA B0+R2+T1  GREEN` / `TUBE1 admitted · Pool x3`. Install proof GREEN; Keaton confirmed on Pixel.

**TUBE5 tip on glass GREEN `20260717.140600`:** after admit + R2, `tube5_glass_tip.rye` lands Mantra rev1/rev2 and paints `TUBE5 tip rev2 · 0.2.0`. Install proof GREEN (binds `sala_root.txt`); Keaton confirmed the tip line on Pixel.

**TUBE2 publish on glass GREEN `20260717.144536`:** after tip + hex, `tube2_glass_pub.rye` runs demo publish + resolve/admit and paints `TUBE2 published · verified` on row 8. Install proof GREEN; Keaton confirmed on Pixel.

**TUBE3 sealed fetch on glass GREEN `20260717.145328`:** `tube3_glass_fetch.rye` runs demo publish + Comlink-sealed fetch and paints `TUBE3 sealed · fetch ok` on row 9. Install proof GREEN; Keaton confirmed on Pixel.

**TUBE4 market on glass GREEN `20260717.145547`:** `tube4_glass_market.rye` runs demo Exchange+Neth acquire and paints `TUBE4 market · acquired` on row 10. Install proof GREEN; Keaton confirmed on Pixel. Debug keystore under `tools/.cache/tube05/` is host-local, never for publish.

**TUBE7 glass path GREEN `20260717.145547`:** installable APK on GrapheneOS Pixel presents admit + R2 + tip + publish + sealed fetch + market acquire. TUBE6 (real GrapheneOS *build*) stays horizon behind HAWM2.

**Resource Scope (Storage · Contact) GREEN `20260717.155846` · glass cover `20260717.161220`:** [`../linengrow/glow_storage_scope.rye`](../linengrow/glow_storage_scope.rye) — one mold for GrapheneOS Storage Scopes and Contact Scopes. [`admit_manifest_scopes`](../linengrow/tube1_admission.rye) stacks scopes under Caravan grant; revoke refuses. Glass declares `photos` + `contacts` and Scopes cover them (`tube1_glass_gate.rye`); weaker/revoked scopes refuse. APK permission emission stays on the separate TUBE0.5 path. GrapheneOS stays the hardware root; Glow implements the parallels in Glow, never Kotlin.

**Network Grant GREEN `20260717.160607` · TUBE1 wire `20260717.160828`:** [`../linengrow/glow_network_grant.rye`](../linengrow/glow_network_grant.rye) — clean-room Glow parallel of GrapheneOS Network permission toggle. Binary grant/revoke; refused grant **appears down**. [`admit_manifest_networked`](../linengrow/tube1_admission.rye) requires the grant only when the manifest declares `network`; glass keeps the door live without adding INTERNET to the R2 present path. Manifest emission of `network` + `right_net` → INTERNET stays TUBE0.5.

**Sensors Grant GREEN · TUBE1 wire `20260717.161013` · TUBE0.5 emit `20260717.161448`:** [`../linengrow/glow_sensors_grant.rye`](../linengrow/glow_sensors_grant.rye) — GrapheneOS Sensors permission toggle parallel. Binary grant/revoke; refused grant **appears zeroed**. [`admit_manifest_gated`](../linengrow/tube1_admission.rye) stacks Network + Sensors; engages `sensors` only when declared. Glass keeps both toggle doors live on the R2 present path. TUBE0.5 closed table: `sensors` + `right_device` → `android.permission.OTHER_SENSORS`.

---

## Decision pinned

No Glow→Kotlin/JVM transpiler — [`active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`](../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md). Full ladder plan: [`expanding-prompts/20260716-142818_…`](../expanding-prompts/20260716-142818_glow-application-framework-and-publishing.md). GrapheneOS-facing app logic stays Glow/Rye → native.

Device ladder this joins: [`HAWM.md`](HAWM.md).

---

*May the manifest stay a mold, and the APK stay an envelope around native truth.*
