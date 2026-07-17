format session-log-v1
stamp 20260717.021857
editor Cursor
model Cursor Grok 4.5
voice Quin
host Ubuntu 26.04 LTS GNOME Wayland (Framework 16 AMD) — Eastern time convention, context/specs/20260717-003132_eastern-time-framework-host-convention.md
title TUBE0.5 host-side packaging GREEN — first Glow NativeActivity APK
prompt continue implementing in the order you recommend
think TUBE0.5 was the next real build step after the no-Kotlin decision — both gates already closed
think found untracked permission-emission work already GREEN; built on it rather than rewriting
think landed full AndroidManifest.xml emission using Android's own NativeActivity — no custom Kotlin or Java at all, even smaller than the brief's 50-100 line shim once the platform class is reused
think built libglowapp.so for aarch64-linux-android exporting ANativeActivity_onCreate via Zig build-lib
think installed Android build-tools 36.0.0 under the HAWM0 SDK cache; packed and debug-signed the demo APK with aapt/zipalign/apksigner
think three witnesses GREEN: permission emission, envelope emission, APK pack; wired first two into parity_ch01
obs the envelope reuses android.app.NativeActivity with hasCode=false — zero JVM bytecode in the APK, only the native library and the closed-table permission lines
obs on-device adb install and a real Glow fold inside ANativeActivity_onCreate remain the honest next slice; today's entry is a symbol-shape stub
file linengrow/tube_manifest_android_permission.rye closed-table capability to Android permission emission
file linengrow/tube_android_manifest.rye full NativeActivity AndroidManifest.xml emission
file linengrow/glow_native_activity.rye fixed native entry exporting ANativeActivity_onCreate
file tools/tube05_apk_pack_worker.sh host-side APK packer
file tools/tube05_apk_pack_witness.rish packaging witness GREEN
recommend keep-going — next mechanical step is adb install of tools/.cache/tube05/sala-broadcaster.apk onto the Pixel 10a once USB debugging is on, then wiring Sala into ANativeActivity_onCreate
