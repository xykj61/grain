# GrapheneOS — why this mirror exists

**Stamp:** filed `20260717.020412`.

GrapheneOS's official documentation carries an MIT-style license (`LICENSE.txt` in this folder, fetched from `grapheneos.org/LICENSE.txt`) that names, in its own words, "this software and associated documentation files" — so a verbatim mirror of the docs is exactly as clean as mirroring the code itself would be. We keep these pages close for the same reason we keep `tigerbeetle/` and `zig/` close: to read the source in its own author's own voice, re-checkable against the live site whenever GrapheneOS's own guidance changes, rather than trusting our own paraphrase of it.

## What lives here

- **`install-web.md`** — the WebUSB-based web installer guide, mirrored from `grapheneos.org/install/web`. This is the path [`../../manual/guides/pixel-10a-grapheneos-setup.md`](../../manual/guides/pixel-10a-grapheneos-setup.md) walks, and the one Keaton actually used to flash the physical Pixel 10a.
- **`install-cli.md`** — the command-line install guide, mirrored from `grapheneos.org/install/cli`, for the more traditional `fastboot`-driven path.
- **`features-overview.md`** — the full features overview, mirrored from `grapheneos.org/features`, naming every hardening layer beneath the userland surface this project's own HAWM ladder reaches from the outside (verified boot, hardened allocator, sandboxing, Titan-class attestation, and the rest).
- **`LICENSE.txt`** — GrapheneOS's own MIT-style license, covering the software and its documentation together, fetched verbatim.

## Why it matters to this project

`context/specs/two-dev-environments-and-mobile-emulation.md`'s own honest register names the boundary plainly: HAWM0/HAWM1 exercise real AOSP/Android userland; only HAWM2 (a real GrapheneOS build) or HAWM3 (the physical device) actually touch GrapheneOS's own hardening. Keeping this documentation close, rather than working from memory or a paraphrase, is what let the Pixel 10a setup guide quote the Pixel 10a's own verified-boot key hash verbatim (`d8f879d1…`) and let Keaton confirm it, digit for digit, against the device's own boot screen — the real proof HAWM3 closed on `20260717.013700`.

## Refreshing this mirror

Fetch fresh from `grapheneos.org` and update the "fetched" date named at the top of each mirrored file when GrapheneOS's own guidance changes. Never edit the mirrored wording itself; only the formatting cleanup already named in each file's own header note.
