# Ten batches — Pixel · HAWM · TUBE0.5 — then align and send

**Stamp:** `20260717.121800`  
**Editor:** Cursor · **Model:** Cursor Grok 4.5 300k High Fast · **Voice:** Quin  
**Host:** Ubuntu 26.04 LTS GNOME Wayland (Framework 16 AMD) — Eastern time  
**Format note:** Keaton asked for this batch summary as Markdown. Living session logs remain Bron (`.bron`); this file is an explicit MD roll-up for the arc below.

**Prompt:** Summarize the last 8–10 batches of work in an md session log, align following the compass, and send.

---

## The arc in ten batches (oldest → newest)

### 1. A real Pixel arrives (`20260716.193409`)
Used Google Pixel 10a, 128GB, $325. Tensor G4 / Titan M2 / GrapheneOS production support through ~2033. Satisfies HAWM3’s device gate; lands as a real value-tier phone ahead of the flagship purchase the go-to-market brief ordered.

### 2. GrapheneOS setup guide (`20260716.200125`)
`manual/guides/pixel-10a-grapheneos-setup.md` transcribed from GrapheneOS’s own install/web page, boot-key hash quoted verbatim, host-specific Ubuntu/Brave notes checked on this machine. Human hands only — no agent can unlock a bootloader.

### 3. GrapheneOS installed + boot hash matched (`20260717.013213` / `.013700`)
Eight guide steps run end to end. Yellow boot notice SHA-256 matched GrapheneOS’s published Pixel 10a value (`d8f879d1…7f80`). **HAWM3 closed** — first rung on the ladder to touch real hardware with a checked chain of trust.

### 4. No Kotlin transpiler (`20260717.014522`)
Design decision: Glow stays Zig→bionic native. Packaging gap filled by Android’s own `NativeActivity` + Glow `.so`. New rung **TUBE0.5** named. Brief: `active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`.

### 5. TUBE0.5 host-side packaging GREEN (`20260717.021857`)
Permission emission, NativeActivity envelope, signed demo APK with `libglowapp.so` exporting `ANativeActivity_onCreate`. Three witnesses GREEN. Entry was still a symbol-shape stub.

### 6. Dual-door docs (`20260717.022323`)
Language path (Rishi / Glow runes) and device path (Pixel / HAWM / TUBE) meet without merging into one textbook. Compressors `docs/HAWM.md` · `docs/TUBE.md`; **HAWM** / **TUBE** seated in LEXICON; `manual/README.md` hubs.

### 7. GrapheneOS gratitude mirror finished (`20260717.020613`)
`gratitude/grapheneos/` docs mirror (install/cli, features, README) under GrapheneOS’s MIT-style license — the same surface that supplied the boot-hash check.

### 8. Sala B0 fold wired into the APK (`20260717.121445`)
`sala_b0_fold.rye` + `glow_native_activity.rye` run the HAWM1 demo fold from `ANativeActivity_onCreate`, write `files/sala_root.txt`. Pack path: `rye build-lib -fsingle-threaded` → NDK `clang -shared` for arm64 + x86_64 (Zig plain `-dynamic` lacks `DT_NEEDED`). Pack-worker ASCII hygiene after UTF-8 em-dash broke bash quotes. Pack witness GREEN.

### 9. Install-proof host witness (`20260717.121625`)
`tools/tube05_install_proof_onpath_host.rish` — adb install, launch NativeActivity, `run-as` cat `sala_root.txt`, match `99b3ae96…e4c5fe`. In-jail correctly refuses (no device / no KVM).

### 10. Jailed slice polished (`20260717.121743`)
Rye rebuilt with `build-lib`; rye README + HAWM door synced; pack witness re-GREEN. Host-side half as finished as ai-jail allows.

---

## Align pass (`20260717.121800`)

Walked the compass rose: foundations (sovereignty, ahimsa, person owns the device) → grain (witness before narrative, bounds) → Two Rooms (checkable packaging vs horizon UI) → active-designing (native-activity brief) → TASKS / ROADMAP → green witnesses.

| Claim | Room | State |
|-------|------|-------|
| HAWM0 / HAWM1 | checkable | GREEN (emulator + Sala on bionic) |
| HAWM3 install + boot hash | checkable | closed |
| TUBE0.5 host pack (permissions, envelope, Sala-in-APK) | checkable | GREEN (`tube05_apk_pack_witness.rish`) |
| TUBE0.5 on-device install + `sala_root.txt` | checkable when run | **open** — host terminal only |
| NativeActivity surface / finish | vision / later slice | open |
| Kotlin transpile | declined | brief seated |

**Aligned next step:** from a plain host terminal (outside ai-jail):

```bash
rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish   # if emulator not up
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
```

That single GREEN closes TUBE0.5’s on-device half. Pixel USB path is the same witness with a physical device. No new design door before that finish.

**Finishing edge:** ship the host-side GREEN (this send), then run the install proof — build the next real thing rather than name another idea.

---

## Related Bron logs (this morning’s packaging slice)

- `20260717-121445_sala-fold-wired-tube05-apk.bron`
- `20260717-121625_tube05-install-proof-host-witness.bron`
- `20260717-121743_tube05-jailed-slice-ready.bron`

## Recommend

Keep going on the host-terminal install proof after this send lands; that is the one aligned next step.
