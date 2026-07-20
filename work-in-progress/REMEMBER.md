# REMEMBER — living operator card

*One-page carry card for outer terminal · phone · waymarks. Refreshed when Keaton says **remember**. Rule: [`.cursor/rules/remember.mdc`](../.cursor/rules/remember.mdc) · [`.claude/rules/remember.md`](../.claude/rules/remember.md).*

**Last refreshed:** `20260720.232932` (UDT) · voice Quin  
**Product nib:** ZETA6 · LULU0–5 · **SETU6.5** · HOLD0–HOLD1 · HOLD-W  
**Language nib:** **STOA0–147** GREEN · field capacity freeze at 9 · STOA148 withdrawn  
**Suite nib:** ZETA0–6 · LULU0–5 · SETU0–SETU6.5 · HOLD0–HOLD1 · HOLD-W · STOA0–147  
**Git nib:** `2a1151fd27` capacity freeze · *(UDT seat pending this send)*  

**Season:** Framework 16 host resumed · stamps **UDT (UTC)** — [`../context/specs/20260720-232932_udt-framework-host-convention.md`](../context/specs/20260720-232932_udt-framework-host-convention.md). Language field ladder frozen; next Framework door = SETU live-sent.  
**APK:** `tools/.cache/tube05/sala-broadcaster.apk` · pkg `org.glow.app.sala_broadcaster`

---

## Now

**Pulled** iOS/cloud arc through STOA147 + capacity freeze (`max_fields == 9`).  
**UDT** seated for this host's stamps from `20260720.232932` (was Eastern).  
**Next check-in:** live SETU6.5 **sent** on `usb0`/`ncm` — lean A from freeze brief.

Language smoke (device-free):

```bash
rishi/bin/rishi run tools/glow_barket_lower_witness.rish
rishi/bin/rishi run tools/glow_lower_bartis_witness.rish
```

Capacity freeze: [`../active-designing/20260720-231857_closed-field-capacity-freeze-and-framework-next.md`](../active-designing/20260720-231857_closed-field-capacity-freeze-and-framework-next.md)

Hold: further `*-mold` field widens · ambient gold · Sala B0 Glow rewrite · JABS3.

---

## Seated waymarks (do not redraw)

| Waymark | Ladder | Now |
|---------|--------|-----|
| **HAWM** | GrapheneOS / Pixel SLC | HAWM0–1 GREEN · HAWM3 real Pixel |
| **TUBE** | App framework / NativeActivity pack | TUBE0.5 APK GREEN |
| **ZETA** | English QWERTY glass keyboard | ZETA0–6 GREEN (Pixel look) |
| **JABS** | Sala broadcast live-session fold | JABS0–2 GREEN · JABS3 check-in |
| **LULU** | Hearth · short home · Wired Glass | **LULU0–5 closed** |
| **SETU** | USB hearth carry Glass↔Desk | **SETU0–SETU6.5 · HOLD* GREEN** · live-sent eyes next |
| **STOA** | Glow language SLC | **STOA0–147 GREEN** · capacity freeze at 9 |

Canon: [`../docs/HAWM.md`](../docs/HAWM.md) · [`../docs/TUBE.md`](../docs/TUBE.md) · [`../docs/ZETA.md`](../docs/ZETA.md) · [`../docs/JABS.md`](../docs/JABS.md) · [`../docs/LULU.md`](../docs/LULU.md) · [`../docs/SETU.md`](../docs/SETU.md) · [`../docs/STOA.md`](../docs/STOA.md)

---

## Outer terminal (host shell — not ai-jail)

```bash
cd ~/urbit
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
rishi/bin/rishi run tools/stoa73_product_root_install_onpath_host.rish
$ADB install -r tools/.cache/tube05/sala-broadcaster.apk
$ADB shell am force-stop org.glow.app.sala_broadcaster
$ADB shell am start -n org.glow.app.sala_broadcaster/android.app.NativeActivity
rishi/bin/rishi run tools/setu0_hearth_pull_onpath_host.rish
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
rishi/bin/rishi run tools/setu_desk_hold_wayland_witness.rish
```

---

## Open doors

| Door | Kind |
|------|------|
| Live SETU6.5 **sent** on usb0/ncm | **check-in** — Framework lean A |
| Closed-field capacity freeze at 9 | **seated** |
| Ambient gold · Glow nesting syntax | **held** |
| JABS3 · TAME Lap 3 | **check-in** |

---

*May every hand know the waymarks, and every outer terminal own the USB.*
