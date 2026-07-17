# Setting Up a Pixel 10a with GrapheneOS

**Language:** EN
**Version:** `20260716.200125` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Guide for the task — every step below is transcribed directly from GrapheneOS's own official web installer instructions (`grapheneos.org/install/web`, checked `20260716`), not paraphrased from memory. The Pixel 10a's own verified-boot key hash is quoted verbatim from that same page. This guide has not yet been run end to end against a real device from this session — treat your own first real run as the actual proof, and tell your agent how it goes so this page can be corrected in place if reality differs from what follows.

---

**Navigation:** [Manual home](../README.md)

---

You just bought a real device — a Google Pixel 10a — and you want GrapheneOS on it: Android's own hardware security (Titan M2, verified boot, hardware memory tagging) with none of Google's own software behind it. This guide walks you through the whole install, on this exact Framework 16 AMD Ubuntu 24.04 LTS host, using the official **web installer** — no command line required, no separate flashing tool to compile.

**One thing worth saying plainly before you start:** every step below happens on your own two hands, on the real device, in a real browser window — a cable to plug in, buttons on the phone to press, a website to click through. No agent, no jailed sandbox, no automated script can do any of this for you; the whole point of a locked bootloader and a hardware-rooted verified-boot chain is that it cannot be flipped from software alone. This guide is a map, not a remote control.

## Before You Start — What You Need

- **This computer** — Ubuntu 24.04 LTS is on GrapheneOS's own officially-supported list for the web installer, so you're already on a good host. You'll need at least 2GB of free memory and 32GB of free storage (checked separately from your own agent's own jailed workspace — this runs in your ordinary desktop session, not inside `~/urbit`'s jail).
- **A browser** — **Brave is already installed on this host** and is one of GrapheneOS's own officially-supported browsers for the web installer, with one catch: **disable Brave Shields** on the install page before you start (Shields caps available storage to avoid fingerprinting, which starves the installer of the space it needs to extract the download). Click the Brave Shields icon in the address bar and toggle it off for `grapheneos.org` specifically — no need to disable it everywhere.
- **A real USB-C cable** — the one that came in the box with the Pixel 10a, if you still have it. Avoid a USB hub (the front-panel ports on a desktop case are usually a hub); plug directly into a rear port on this laptop. Cheap or damaged cables are, by GrapheneOS's own account, the single most common cause of installer trouble.
- **Not a virtual machine** — install from this real Ubuntu desktop directly, never through a VM (USB passthrough for this kind of low-level flashing is unreliable, and VMs often shortchange memory/storage). This also means: **do this from your ordinary desktop session, outside `tools/cursor-jail.sh`'s own ai-jail** — the jail's whole point is walling off hardware and devices, which is exactly what this task needs to reach.
- **Two Linux-specific housekeeping steps**, both one-time:
  ```bash
  sudo apt install android-sdk-platform-tools-common
  sudo systemctl stop fwupd.service
  ```
  The first installs the `udev` rules Linux needs to let a non-root user talk to the phone over USB at all (without it, every fastboot command silently fails). The second stops a known, common conflict — Ubuntu's own firmware-update daemon (`fwupd`) sometimes grabs the phone over the same fastboot protocol the installer needs, and you'll see a confusing "device already in use" error if it does. `fwupd` restarts on the next reboot; this only stops it for today.

## Step 1 — Enable Developer Options and OEM Unlocking, on the Phone

This has to happen while the phone is still running its stock software, before anything else:

1. **Settings → About phone → tap "Build number" seven times.** A toast confirms "You are now a developer."
2. **Settings → System → Developer options → toggle on "OEM unlocking."** This may need an active internet connection — the stock OS checks in with Google to confirm the device wasn't sold locked by a carrier. (A carrier-locked Pixel 10a can't be unlocked at all; a carrier-agnostic one, which is what most used/unlocked listings on Marketplace are, unlocks freely.)

## Step 2 — Boot the Phone into the Bootloader

Power the phone off completely, then hold the **volume-down** button while powering it back on (either via the power button, or by plugging in the USB cable while continuing to hold volume-down). Keep holding until you see a **red warning triangle and the words "Fastboot Mode."**

**Do not press the power button once you're there** — that activates the on-device "Start" menu and takes you out of the state the installer needs. Just leave it sitting in Fastboot Mode.

## Step 3 — Connect and Open the Web Installer

1. Plug the USB-C cable into the phone (still in Fastboot Mode) and into a rear port on this laptop.
2. In Brave, with Shields off for this page, go to **`grapheneos.org/install/web`**.
3. The page will ask to connect to the device over WebUSB — approve it. On Linux, if the udev step above wasn't done first, you may need to unplug and replug the cable once the rules are installed.

## Step 4 — Unlock the Bootloader (Wipes the Phone)

The installer page has an "Unlock bootloader" button. Press it, then **confirm on the phone itself** — use a volume button to move the on-device selection to the unlock/accept option, then the power button to confirm. This wipes everything currently on the device; since you just bought it used, there's nothing here you'd want to keep anyway, but it's worth naming plainly.

## Step 5 — Download and Flash the GrapheneOS Release

Back in the browser: press **"Download release"** and let it fetch (it downloads the current, signed GrapheneOS factory image for the Pixel 10a specifically — the page detects your exact model automatically). Once downloaded, press **"Flash release."**

This step handles everything itself — flashing the latest firmware, rebooting into the bootloader, flashing the OS — and takes a few minutes. **Don't touch the phone or unplug the cable while it's running.** Let it finish completely before doing anything else.

## Step 6 — Lock the Bootloader (Wipes the Phone Again)

Once flashing finishes, the installer page will offer a "Lock bootloader" button (or you can select it directly on the phone's own bootloader menu). This is not optional if you want the security GrapheneOS actually provides — an **unlocked** bootloader means verified boot cannot fully do its job, and fastboot can still flash/erase partitions from outside the OS. Confirm on the device the same way as Step 4 (volume button to select, power button to confirm). **This wipes the device once more** — the second and last wipe of this whole process, and the one that seats GrapheneOS's own verified-boot key into the Titan M2 secure element for real.

## Step 7 — First Boot and Setup

Press the power button with "Start" selected in the bootloader menu, and GrapheneOS boots for the first time. Walk through the on-device setup screens normally. Near the end, there's a toggle for **OEM unlocking, checked by default — leave it checked to let setup disable OEM unlocking automatically**, which is the recommended, locked-down end state. (You can always re-enable OEM unlocking later from Developer options if you ever need to flash something again.)

## Step 8 — Verify You're Actually Running Real GrapheneOS, Not an Imposter

This is the step most guides skip, and it's the one that actually proves the hardware root of trust did its job. On every boot, GrapheneOS (being an "alternate OS" from the stock bootloader's own point of view) shows a brief yellow notice naming the SHA-256 hash of its own verified-boot public key, burned into the Titan M2 at install time. The Pixel 10a shows the **full** hash (older 4th/5th-gen Pixels only show a truncated 32-bit fragment, so this full check is a genuine Pixel-10a-and-later advantage). Compare what your phone shows against GrapheneOS's own official, published value for exactly this device:

```
Pixel 10a verified-boot key hash:
d8f879d10419eddc9fcda6280718be763f6bf12299e1f72df3ea8ad8a8eb7f80
```

If it matches character for character, the chain of trust from the SoC's own factory-burned fuses, through this exact install, is real. If it doesn't match — stop, and don't trust the device with anything sensitive until you've worked out why with the official GrapheneOS chat channels linked from their own site.

## What This Doesn't Cover Yet

- **Sandboxed Google Play** (if you want any app that needs it) — a separate, later step through GrapheneOS's own "Apps" store, installed per user profile, never given special privileges. Not needed for anything in this tree's own HAWM/TUBE work.
- **Hardware attestation via the Auditor app** — a deeper verification than Step 8's own boot-time check, needing a second Android device to pair with. Worth doing eventually, not required to start using the phone.
- **Flashing Glow/Sala's own userland onto the device** — that's HAWM3's own next rung, gated on this setup finishing first; see [`../../context/specs/two-dev-environments-and-mobile-emulation.md`](../../context/specs/two-dev-environments-and-mobile-emulation.md).

## Related

- `grapheneos.org/install/web` — the official page every step above transcribes; check it directly if anything here goes stale.
- [`../../context/specs/two-dev-environments-and-mobile-emulation.md`](../../context/specs/two-dev-environments-and-mobile-emulation.md) — the HAWM ladder this device unblocks (HAWM3), and the two emulated rungs (HAWM0, HAWM1) already proven before this device arrived.
- [`../../active-designing/20260715-194500_the-slc-product-glow-on-capable-hardware.md`](../../active-designing/20260715-194500_the-slc-product-glow-on-capable-hardware.md) — the go-to-market brief naming where this device sits in the product's own tier plan.

---

*May every unlock be deliberate, every wipe expected, and the hash you check at the end match the one the maker published — proof that trust, once rooted in silicon, travels honestly all the way to the screen in your hand.*
