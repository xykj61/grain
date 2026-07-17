format session-log-v1
stamp 20260717.121445
editor Cursor
model Cursor Grok 4.5 300k High Fast
voice Quin
host Ubuntu 26.04 LTS GNOME Wayland (Framework 16 AMD) — Eastern time convention, context/specs/20260717-003132_eastern-time-framework-host-convention.md
title Sala B0 fold wired into TUBE0.5 NativeActivity APK
prompt Keaton sent a pack-failure screenshot (unexpected EOF matching quote in tube05_apk_pack_worker.sh) and asked to recommend the best path and keep going
think read the failure as a mid-pack bash quote break, not a link or fold bug — ABIs had already built; packaging died on an unclosed string
think found UTF-8 em-dashes and fancy arrows inside double-quoted echo/die lines; replaced string-literal punctuation with ASCII so bash cannot mis-parse mid-edit or mid-locale
think re-ran the pack worker end to end — both arm64-v8a and x86_64 NDK-linked .so files, signed APK at tools/.cache/tube05/sala-broadcaster.apk
think ran tools/tube05_apk_pack_witness.rish GREEN — envelope, permission emission, Sala B0 unit root, and pack all green in one witness
think confirmed ai-jail has no /dev/kvm and no adb devices, so on-device sala_root.txt proof stays a host-terminal slice
obs best path after the screenshot: fix pack hygiene, land the Sala fold already wired in glow_native_activity, refresh living docs that still said symbol-shape stub, then hand off install to a host terminal with KVM or USB
obs Zig plain -dynamic android .so still fails dlopen without DT_NEEDED; the archive plus NDK clang -shared path with -fsingle-threaded is the checkable fix that earned GREEN
obs do not claim emulator or Pixel install GREEN from inside the jail — witness before narrative
file tools/tube05_apk_pack_worker.sh ASCII-only echo/die strings; NDK link path for both ABIs
file linengrow/sala_b0_fold.rye same HAWM1 demo fold root
file linengrow/glow_native_activity.rye onCreate runs fold and writes sala_root.txt
file rye/src/main.rye build-lib command for static archives
file docs/TUBE.md host-terminal adb install and cat sala_root.txt recipe
file work-in-progress/TASKS.md checked Sala-fold-wired lap at 20260717.121445
file work-in-progress/ROADMAP.md Still-open narrowed to adb proof
recommend keep-going — on a host terminal (outside ai-jail): boot HAWM0, adb install the APK, start NativeActivity, cat sala_root.txt and match the HAWM1 root; say send when that proof is ready to ship with this tree, or say send now to land the host-side GREEN first
