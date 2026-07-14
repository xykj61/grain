# Turning On FileVault (macOS Disk Encryption)

**Language:** EN
**Version:** `20260714.051016` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — this is the single highest-priority security finding for this work machine, per [`../../context/specs/20260713-211800_local-host-system-hardware-anonymized.md`](../../context/specs/20260713-211800_local-host-system-hardware-anonymized.md)

---

**Navigation:** [Manual home](../README.md)

---

If you treat this laptop as a work machine — holding real SSH keys, a real GPG signing key, and real forge tokens — disk encryption is not optional polish. Without it, anyone who removes the drive (or boots from another disk) can read every private key on it directly, bypassing your login password entirely. FileVault closes that door. This guide walks an Acme Corporation employee through turning it on, saving the one thing that matters (the recovery key) correctly, and confirming it actually took.

## Before You Start

- **Time:** initial encryption runs in the background while you keep working, but budget a few minutes of active attention now to start it correctly.
- **Power:** plug in. Encrypting a large disk on battery is unnecessary risk for no benefit.
- **A place to keep one secret safe:** you will be given a 24-character recovery key. Decide *before* you start where it will live — a password manager's secure notes are the best choice. It must **not** be saved as a plain file on this same disk (that would defeat the entire point) and it must not be a photo left in an easily-searched phone gallery.

## The Steps

1. **Open System Settings.** Click the Apple menu (top-left corner) → **System Settings…**
2. **Go to Privacy & Security.** In the sidebar, click **Privacy & Security**.
3. **Find FileVault.** Scroll down in the main panel until you see **FileVault**. Click it to open its own settings screen.
4. **Turn it on.** Click **Turn On…** (or **Turn On FileVault…**, wording varies slightly by macOS version).
5. **Choose how to recover your key.** macOS offers two paths:
   - **Allow my iCloud account to unlock my disk.** Convenient, and reasonable if your iCloud account itself is well-secured (strong password, two-factor authentication already on). Apple can then help you regain access if you forget your login password.
   - **Create a recovery key and do not use my iCloud account.** The stricter choice for a work machine — no third party (not even Apple) holds a path back in. This is the recommended choice here, since the point of this whole exercise is that *only you* can unlock this disk.
6. **If you chose the recovery-key path, write it down immediately, correctly.** macOS shows you a 24-character key exactly once on this screen. Before you click past it:
   - Copy it character-for-character into your password manager's secure notes, under an entry named something like "MacBook FileVault recovery key."
   - Double-check every character — the key mixes letters and numbers and a single transposed character makes it useless.
   - Do **not** screenshot it into a cloud-synced Photos library, do **not** paste it into a plain text file on this Mac, and do **not** email it to yourself.
7. **Confirm and let it encrypt.** Click through the confirmation. macOS will ask you to restart, or begin encrypting in the background immediately, depending on version. Initial encryption of a large drive can take from under an hour to most of a day depending on how much data is on it — your Mac stays usable the whole time, just slightly slower during the process.

## Confirming It Actually Took

Once encryption reports complete (or even while it is still in progress — the setting itself takes effect immediately), confirm from the command line:

```bash
fdesetup status
```

You should see:

```
FileVault is On.
```

If it instead reports a percentage, encryption is still running in the background — that is expected and fine; re-run the command later to watch it finish.

## What This Actually Protects You From

- **A lost or stolen laptop.** Without FileVault, someone with the physical drive can read your SSH private keys, your GPG signing key, and any cached credentials directly, with no need to guess your login password at all. With FileVault on, the drive is unreadable without either your login password or the recovery key.
- **It does not protect you from:** malware running while you are logged in (FileVault decrypts transparently while the machine is unlocked and running — it is a *disk-at-rest* protection, not a runtime sandbox), a weak login password (make that strong too), or losing the recovery key yourself (there is no back door — write it down correctly, once, in the one safe place you chose above).

## If Something Goes Wrong

- **You forgot to save the recovery key and the screen is gone.** You can view it again before encryption finishes: **System Settings → Privacy & Security → FileVault**, and there is usually a way to view or reset the recovery key from there. If encryption has already completed and you truly have no record of the key and no iCloud recovery path, there is no way to recover the disk if you are ever locked out — this is why step 6 matters more than any other step in this guide.
- **`fdesetup status` says "FileVault is Off" after you thought you turned it on.** Re-open System Settings → Privacy & Security → FileVault and confirm the toggle actually completed; sometimes a restart is required to finish enabling it.

---

*May every secret this machine holds stay unreadable to anyone but you, and may the one key that unlocks it all live somewhere only you can find.*
