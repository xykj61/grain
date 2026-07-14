# Making Your Identity Key Cards

**Language:** EN
**Version:** `20260714.032200` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Guide for the task — the macOS path is witnessed end to end on this host; the Linux path is the inherited script

---

**Navigation:** [Manual home](../README.md)

---

A key card is a single image that carries your public identity — your name, your forge handle, your email, and the three fingerprints that let anyone verify your SSH and signing keys — laid out around a diamond, with each fingerprint rendered both as text and as a scannable QR code. You pin it to a profile, print it, or hand it over; because fingerprints are public by design, a key card is safe to share anywhere. This guide shows an Acme Corporation employee how to make their own.

## What You Get

Two images at the repository root, one landscape and one portrait, sharing the same square core so they read identically in either orientation:

- `keys_<font>_<yourhandle>_landscape.png`
- `keys_<font>_<yourhandle>_portrait.png`

They default to a **plain palette** — white background, black text and QR — which prints cleanly on any printer and scans reliably under any light. If you want a themed card, you can override the colors; the plain default is what most people want.

## Before You Start

You need your three fingerprints, which are all public:

```bash
ssh-keygen -lf ~/.ssh/your_codeberg_key.pub    # copy the "SHA256:..." part
ssh-keygen -lf ~/.ssh/your_github_key.pub       # copy the "SHA256:..." part
gpg --fingerprint you@example.com               # the spaced 40-hex string
```

## Fill In Your Details

Copy the committed template to your own gitignored config and fill it in:

```bash
cp tools/key-card.conf.example tools/key-card.conf
```

Open `tools/key-card.conf` and set your name, handle, email, and the three fingerprints. If you also fill in the optional `KEY_SSH_*` paths and `GPG_EMAIL`, the generator will **audit each fingerprint against the real key on your machine before it renders anything** — so a card can never go out with a fingerprint that does not match the key it claims. Your filled `tools/key-card.conf` stays out of git; only the `.example` template is tracked.

## Make the Cards

### On macOS (recommended — audited end to end)

Install the two dependencies once, then run the Rish orchestrator:

```bash
brew install qrencode imagemagick
rishi/bin/rishi run tools/make_key_card.rish
```

The orchestrator does three things in order, and stops loudly if any fails: it audits your declared fingerprints against your real keys, renders the landscape and portrait cards, then audits that the output images came out valid and correctly shaped. A green run means the whole chain held — the fingerprints on the card are the true ones, and the images are well-formed. **The font is Menlo** — it ships on every Mac, needs no install step, and is the settled choice for this path; no Fira Code lookup or install is needed.

### On Linux

```bash
./tools/make-key-card.sh
```

This builds its QR encoder from the vendored `gratitude/libqrencode` submodule into the gitignored `tools/.build/`, and uses `apt`-installed Fira Code. On Debian or Ubuntu, `sudo apt install gcc libpng-dev pkg-config imagemagick fonts-firacode` covers the dependencies.

## Verify Before You Trust

A card is only as good as the fingerprints on it, so confirm the QR codes decode back to exactly what the text says:

```bash
brew install zbar    # macOS; on Linux: sudo apt install zbar-tools
zbarimg --raw keys_*_<yourhandle>_landscape.png
```

Each decoded line should match, character for character, the fingerprint printed beneath its QR code — and each of those should match what `ssh-keygen`/`gpg` printed above. When all three agree, the card is honest.

## Doing It From Inside the Enclosure

Everything here runs inside the macOS `sandbox-exec` enclosure or the Linux ai-jail — the generators write only to the repository, and the QR/image tools are ordinary local binaries. If Cursor is set up, you can simply ask the agent to *"fill in my key-card config and render my cards,"* and it will, from inside the sandbox.

## When Something Goes Wrong

- **`qrencode not found`** — install it (`brew install qrencode`, or `apt install qrencode`).
- **ImageMagick not found** — install it (`brew install imagemagick`, or `apt install imagemagick`).
- **The audit fails with a fingerprint mismatch** — the fingerprint in your config does not match the key at the path you gave. Re-copy it from `ssh-keygen`/`gpg`; the audit is doing its job by refusing to render a misleading card.
- **You want a different look than Menlo** — that is a deliberate, settled choice for this path (no install step, ships on every Mac), not a fallback; if you truly want a different font, edit `resolve_font` in `tools/make_key_card_macos.sh` directly.

---

*May your card carry only what is true, may every QR scan back to exactly what it claims, and may your keys stay yours while their fingerprints travel freely.*
