# Web installer

*Mirrored verbatim from [`grapheneos.org/install/web`](https://grapheneos.org/install/web), fetched 2026-07-16, under the MIT-style license in [`LICENSE.txt`](LICENSE.txt) (Copyright © 2014-2026 GrapheneOS). Formatting cleaned up for markdown; no wording changed. See [`README.md`](README.md) for why this mirror exists and how we use it.*

---

This is the WebUSB-based installer for GrapheneOS and is the recommended approach for most users. The command-line installation guide is the more traditional approach to installing GrapheneOS.

If you have trouble with the installation process, ask for help on the official GrapheneOS chat channel. There are almost always people around willing to help with it. Before asking for help, make an attempt to follow the guide on your own and then ask for help with anything you get stuck on.

## Prerequisites

You need a computer for running the web installer with at least 2GB of free memory available and 32GB of free storage space. The web installer can be run on an Android phone or tablet, unlike the command-line installation.

You need a USB cable for attaching the device to the computer performing the installation. Whenever possible, use the high quality standards compliant USB-C cable packaged with the device. If your computer doesn't have any USB-C ports, you'll need a high quality USB-C to USB-A cable. You should avoid using a USB hub such as the front panel on a desktop computer case. Connect directly to a rear port on a desktop or the ports on a laptop. Many widely distributed USB cables and hubs are broken and are the most common source of issues for installing GrapheneOS.

Installing from an OS in a virtual machine is not recommended. USB passthrough is often not reliable. To rule out these problems, install from an OS running on bare metal. Virtual machines are also often configured to have overly limited memory and storage space.

Officially supported operating systems for the web install method:

- Windows 10
- Windows 11
- macOS Sonoma (14)
- macOS Sequoia (15)
- macOS Tahoe (26)
- Arch Linux
- Debian 12 (bookworm)
- Debian 13 (trixie)
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS
- Ubuntu 25.04
- Linux Mint 21 (follow Ubuntu 22.04 LTS instructions)
- Linux Mint 22 (follow Ubuntu 24.04 LTS instructions)
- Linux Mint Debian Edition 6 (follow Debian 12 instructions)
- ChromeOS
- GrapheneOS
- Android 14 with Play Protect certification
- Android 15 with Play Protect certification
- Android 16 with Play Protect certification
- Android 17 with Play Protect certification

Older end-of-life versions of these platforms can also be used but are not officially supported.

Make sure your operating system is up-to-date before proceeding.

Officially supported browsers for the web install method:

- Chromium (outside Ubuntu, since they ship a broken Snap package without working WebUSB)
- Vanadium (GrapheneOS)
- Google Chrome
- Microsoft Edge
- Brave (with Brave Shields disabled, since it caps storage usage at a low value to avoid fingerprinting available storage)

On Android, disable desktop mode for the browser since it currently prevents our web installer from detecting Android and handling needing to request permission to reconnect to the device after each reboot. Desktop mode is enabled by default on large tablets with at least 8GB of RAM such as the Pixel Tablet.

You should avoid Flatpak and Snap versions of browsers, as they're known to cause issues during the installation process.

Make sure your browser is up-to-date before proceeding.

Do not use Incognito or other private browsing modes. These modes usually prevent the web installer from having enough storage space to extract the downloaded release.

You need one of the officially supported devices. To make sure that the device can be unlocked to install GrapheneOS, avoid carrier variants of the devices. Carrier variants of Pixels use the same stock OS and firmware with a non-zero carrier id flashed onto the persist partition in the factory. The carrier id activates carrier-specific configuration in the stock OS including disabling carrier and bootloader unlocking. The carrier may be able to remotely disable this, but their support staff may not be aware and they probably won't do it. Get a carrier agnostic device to avoid the risk and potential hassle. If you CAN figure out a way to unlock a carrier device, it isn't a problem as GrapheneOS can just ignore the carrier id and the hardware is the same.

It's best practice to update the device before installing GrapheneOS to have the latest firmware for connecting the device to the computer and performing the early flashing process. Either way, GrapheneOS flashes the latest firmware early in the installation process.

## Enabling OEM unlocking

OEM unlocking needs to be enabled from within the operating system.

Enable the developer options menu by going to Settings > About phone/tablet and repeatedly pressing the Build number menu entry until developer mode is enabled.

Next, go to Settings > System > Developer options and toggle on the OEM unlocking setting. On device model variants (SKUs) which support being sold as locked devices by carriers, enabling OEM unlocking requires internet access so that the stock OS can check if the device was sold as locked by a carrier.

For the Pixel 6a, OEM unlocking won't work with the version of the stock OS from the factory. You need to update it to the June 2022 release or later via an over-the-air update. After you've updated it you'll also need to factory reset the device to fix OEM unlocking.

## Flashing as non-root

On traditional Linux distributions, USB devices cannot be used as non-root without udev rules for each type of device. This is not an issue for other platforms.

On Arch Linux, install the `android-udev` package. On Debian and Ubuntu, install the `android-sdk-platform-tools-common` package.

## Working around fwupd bugs on Linux distributions

The fwupd software often used on Linux distributions for updating firmware is known to incorrectly connect to arbitrary devices using the fastboot protocol which will block using them for the intended purpose. This can result in receiving an error about the USB device already being in use (claimed) when trying to connect to it for the intended purpose.

You can stop fwupd with the following command:

```
sudo systemctl stop fwupd.service
```

This doesn't disable the service and it will start again on reboot.

## Booting into the bootloader interface

You need to boot your device into the bootloader interface. To do this, you need to hold the volume down button while the device boots.

The easiest approach is to reboot the device and begin holding the volume down button until it boots up into the bootloader interface.

Alternatively, turn off the device, then boot it up while holding the volume down button during the boot process. You can either boot it with the power button or by plugging it in as required in the next section.

This step is not complete until your device displays a red warning triangle and the words "Fastboot Mode". You must not press the device's power button to activate the "Start" menu item, because the device must remain paused in Fastboot mode for the installer to connect to it.

## Connecting the device

Connect the device to the computer. On Linux, you'll need to do this again if you didn't have the udev rules set up when you connected it.

Current Windows 10 and Windows 11 include a generic driver usable for fastboot and no longer require installing a driver for installation on the Pixel 4a (5G) or later. It isn't enough for legacy 4th generation Pixels due to the driver not handling fastbootd, so you still need the driver for those. Outdated Windows versions will still need the driver for non-obsolete devices too. You can obtain the driver from Windows Update which will detect it as an optional update when the device is booted into the bootloader interface and connected to the computer. Open Windows Update, run a check for updates and then open the "View optional updates" interface. Install the driver for the Android bootloader interface as an optional update, which will show up as "LeMobile Android Device" due to USB ID overlap. An alternative approach to obtaining the Windows fastboot driver is to obtain the latest driver for Pixels from Google and then manually install it with the Windows Device Manager.

For the Pixel Tablet, disconnect it from the stand before continuing. The stand uses USB to provide charging and audio output, but the tablet lacks support for using both the stand and USB port at the same time.

## Unlocking the bootloader

Press the button below to unlock the bootloader, which enables flashing the OS and firmware: **[Unlock bootloader]** (an on-page button on the installer itself)

The command needs to be confirmed on the device and will wipe all data. Use one of the volume buttons to switch the selection to accepting it and the power button to confirm.

## Obtaining factory images

You need to obtain the GrapheneOS factory images for your device to proceed with the installation process.

Press the button below to start the download: **[Download release]** (an on-page button on the installer itself)

## Flashing factory images

The initial install will be performed by flashing the factory images. This will replace the existing OS installation and wipe all the existing data.

**[Flash release]** (an on-page button on the installer itself)

Wait for the flashing process to complete. It will automatically handle flashing the firmware, rebooting into the bootloader interface and flashing the OS. Avoid interacting with the device until the flashing script is finished. Then, proceed to locking the bootloader before using the device as locking wipes the data again.

## Locking the bootloader

Locking the bootloader is important as it enables full verified boot. It also prevents using fastboot to flash, format or erase partitions. Verified boot will detect modifications to any of the OS partitions and it will prevent reading any modified or corrupted data. If changes are detected, error correction data is used to attempt to obtain the original data at which point it's verified again which makes verified boot robust to non-malicious corruption.

In the bootloader interface, set it to locked: **[Lock bootloader]** (an on-page button on the installer itself)

The command needs to be confirmed on the device and will wipe all data. Use one of the volume buttons to switch the selection to accepting it and the power button to confirm.

## Post-installation

### Booting

You've now successfully installed GrapheneOS and can boot it. Pressing the power button with the default Start option selected in the bootloader interface will boot the OS.

### Disabling OEM unlocking

During first setup, the final screen will contain a toggle regarding OEM unlocking which is checked by default. This will disable OEM unlocking, which is recommended.

If you need to enable or disable OEM unlocking in the future, it can be done in the developer settings menu within the operating system.

### Verifying installation

The verified boot and attestation features provided by the supported devices can be used to verify that the hardware, firmware and GrapheneOS installation are genuine. Even if the computer you used to flash GrapheneOS was compromised and an attacker replaced GrapheneOS with their own malicious OS, it can be detected with these features.

Verified boot verifies the entirety of the firmware and OS images on every boot. The public key for the firmware images is burned into fuses in the SoC at the factory. Firmware security updates also update the rollback index burned into fuses to provide rollback protection.

The final firmware boot stage before the OS is responsible for verifying it. For the stock OS, it uses a hard-wired public key. Installing GrapheneOS flashes the GrapheneOS verified boot public key to the secure element. Each boot, this key is loaded and used to verify the OS. For both the stock OS and GrapheneOS, a rollback index based on the security patch level is loaded from the secure element to provide rollback protection.

### Verified boot key hash

When loading an alternate OS, the device shows a yellow notice on boot with the ID of the alternate OS based on the sha256 of the verified boot public key. 4th and 5th generation Pixels only show the first 32 bits of the hash so you can't use this approach. 6th generation Pixels onwards show the full hash and you can compare it against the official GrapheneOS verified boot key hashes below:

- Pixel 10a: `d8f879d10419eddc9fcda6280718be763f6bf12299e1f72df3ea8ad8a8eb7f80`
- Pixel 10 Pro Fold: `55a2d44103e56d5ec65496399c417987ba77730e6488fc60ba058d09fc3caee3`
- Pixel 10 Pro XL: `141d7fc32af7958a416f2661b37cf6f27bfb376fb5ce616aeaa27a82c7a04f74`
- Pixel 10 Pro: `4e8ee8f717754052198ca6d2d3aaa232e2461b4293c0d6f297e519cc778de093`
- Pixel 10: `3f7415ea26f5df5b14ea6d153256071a7a1af9ce7b0970b7311cc463c7ea02c7`
- Pixel 9a: `0508de44ee00bfb49ece32c418af1896391abde0f05b64f41bc9a2dfb589445b`
- Pixel 9 Pro Fold: `af4d2c6e62be0fec54f0271b9776ff061dd8392d9f51cf6ab1551d346679e24c`
- Pixel 9 Pro XL: `55d3c2323db91bb91f20d38d015e85112d038f6b6b5738fe352c1a80dba57023`
- Pixel 9 Pro: `f729cab861da1b83fdfab402fc9480758f2ae78ee0b61c1f2137dd1ab7076e86`
- Pixel 9: `9e6a8f3e0d761a780179f93acd5721ba1ab7c8c537c7761073c0a754b0e932de`
- Pixel 8a: `096b8bd6d44527a24ac1564b308839f67e78202185cbff9cfdcb10e63250bc5e`
- Pixel 8 Pro: `896db2d09d84e1d6bb747002b8a114950b946e5825772a9d48ba7eb01d118c1c`
- Pixel 8: `cd7479653aa88208f9f03034810ef9b7b0af8a9d41e2000e458ac403a2acb233`
- Pixel Fold: `ee0c9dfef6f55a878538b0dbf7e78e3bc3f1a13c8c44839b095fe26dd5fe2842`
- Pixel Tablet: `94df136e6c6aa08dc26580af46f36419b5f9baf46039db076f5295b91aaff230`
- Pixel 7a: `508d75dea10c5cbc3e7632260fc0b59f6055a8a49dd84e693b6d8899edbb01e4`
- Pixel 7 Pro: `bc1c0dd95664604382bb888412026422742eb333071ea0b2d19036217d49182f`
- Pixel 7: `3efe5392be3ac38afb894d13de639e521675e62571a8a9b3ef9fc8c44fd17fa1`
- Pixel 6a: `08c860350a9600692d10c8512f7b8e80707757468e8fbfeea2a870c0a83d6031`
- Pixel 6 Pro: `439b76524d94c40652ce1bf0d8243773c634d2f99ba3160d8d02aa5e29ff925c`
- Pixel 6: `f0a890375d1405e62ebfd87e8d3f475f948ef031bbf9ddd516d5f600a23677e8`

Checking this is useful after installation, but you don't need to check it manually for verified boot to work. The verified boot public key flashed to the secure element can only be changed when the device is unlocked. Unlocking the device performs the same wiping of the secure element as a factory reset and prevents data from being recovered even if the SSD was cloned and your passphrase(s) are obtained because the encryption keys can no longer be derived anymore. The verified boot key is also one of the inputs for deriving the encryption keys in addition to the user's lock method(s) and random token(s) on the secure element.

### Hardware-based attestation

GrapheneOS provides our Auditor app for using a combination of the verified boot and attestation features to verify that the hardware, firmware and operating system are genuine along with providing other useful data from the hardware and operating system.

Since the purpose of Auditor is to obtain information about the device without trusting it to be honest, results aren't shown on the device being verified. You need a 2nd Android device running Auditor for local QR code based verification. You can also use our optional device integrity monitoring service for automatic scheduled verifications with support for email alerts.

See the Auditor tutorial for a guide.

Auditor is primarily based on a pairing model where it generates a hardware backed signing key and hardware backed attestation signing key and pins them as part of the initial verification. The first verification is bootstrapped based on chaining trust to one of the Android attestation roots. After the first verification, it provides a highly secure system for obtaining information about the device going forward. An attacker could bypass the initial verification with a leaked attestation key or by proxying to another device with the device model, OS and patch level that the user is expecting. Proxying to another device will be addressed in the future with optional support for the hardware serial number attestation feature.

### Further information

Please look through the usage guide and FAQ for more information. If you have further questions not covered by the site, join the official GrapheneOS chat channels and ask the questions in the appropriate channel.

### Replacing GrapheneOS with the stock OS

Installation of the stock OS via the stock factory images is similar to the process described above but with Google's web flashing tool. However, before flashing and locking, there's an additional step to fully revert the device to a clean factory state.

The GrapheneOS factory images flash a non-stock Android Verified Boot key which needs to be erased to fully revert back to a stock device state. Before flashing the stock factory images, you should boot the device into fastboot mode and make sure the bootloader is unlocked. Then erase the custom Android Verified Boot key to untrust it: **[Remove non-stock key]** (an on-page button on the installer itself)
