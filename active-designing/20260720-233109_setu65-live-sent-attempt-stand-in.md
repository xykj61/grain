# SETU6.5 Live-Sent Attempt — Stand-In, Then Pixel Attach

*Keaton approved Framework lean A (live SETU6.5 sent eyes). First pass had no device; Pixel then appeared on adb as charging+debug without `usb0`/`ncm`. Enabling NCM without `adb` dropped the debug interface; phone left the bus. Live **sent** still waits on a real NCM iface.*

**Language:** EN  
**Version:** `20260720.233220` (UDT) · attempt stamp `20260720.233109`  
**Style:** Radiant  
**Voice:** Quin  
**Status:** Checkable — stand-in SKIP GREEN; live-sent **eyes pending**  
**Register:** Mixed — stand-in path **checkable**; live-sent **intent** until `ncm*` / `usb0`  
**Grounds in:** [`20260718-201601_setu65-lab-tx-gate.md`](20260718-201601_setu65-lab-tx-gate.md) · [`20260720-231857_closed-field-capacity-freeze-and-framework-next.md`](20260720-231857_closed-field-capacity-freeze-and-framework-next.md) · [`../docs/SETU.md`](../docs/SETU.md)

---

## What already ran GREEN

| Step | Result |
|------|--------|
| Device-free SETU6 / SETU6.5 witnesses | **GREEN** stand-in |
| Host probe + TX (no gadget) | **GREEN** SKIP |
| `adb devices` (later) | Pixel 10a `stallion` · charging+debug `18d1:4ee7` |
| Host ifaces then | `lo` · `wlp5s0` · `virbr0` only |
| Graphene tether config | `tetherableUsbRegexs: [ncm\d]` · `mUsbTetheringFunction: NCM` |

**Not earned:** `setu65-check` printing **sent** on a real iface.

---

## Hand — re-arm the Pixel (GrapheneOS)

1. **Unplug and replug** the USB-C cable (adb was dropped when `svc usb setFunctions ncm` ran without `,adb`).
2. Accept **USB debugging** if prompted.
3. On the phone: **Settings → Network & internet → Hotspot & tethering → USB tethering** (on).  
   Or the USB notification → enable tethering / choose a mode that starts NCM.
4. On Desk (this host), confirm:

```bash
ADB=tools/.cache/hawm0/android-sdk/platform-tools/adb
$ADB devices
ip -br link | grep -E 'usb0|ncm' || true
lsusb | grep -i 18d1
```

Want: device listed · an iface matching `ncm*` or `usb0` · lsusb not stuck on “charging + debug” alone.

5. If the iface appears but is down, bring it up from a **plain host terminal** (modules may need root):

```bash
sudo modprobe usbnet cdc_ncm
sudo ip link set ncm0 up   # or whatever name appeared
```

6. Say **kg** — agent re-runs:

```bash
rishi/bin/rishi run tools/setu6_lab_probe_onpath_host.rish
rishi/bin/rishi run tools/setu65_lab_tx_onpath_host.rish
```

Want: **armed** · **framed payload sent on \<iface\>**.

**Do not** run `svc usb setFunctions ncm` alone — always keep debug: `ncm,adb` if using adb to set functions.

---

*May the cable show ncm before we claim the send.*
