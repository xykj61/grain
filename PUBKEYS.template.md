# Public Keys — Fork Template

**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`)

---

A fork begins here. Copy this file to `PUBKEYS.md` at the repository root and replace every placeholder with your own four public fingerprints — two SSH (forge authentication) and two OpenPGP (signing). The keeper's canonical record in this repository lives at `context/PUBKEYS.md`; a keeper may also place `PUBKEYS.md` at the root for local override.

Run `rishi/bin/rishi run tools/identity_check.rish` from the repository root to prove the shape.

---

## The Identity

Replace the handle and email with your own.

- **Handle** — @your-handle
- **Email** — you@example.com

---

## The Keys

**Codeberg · SSH**

```
SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**GitHub · SSH**

```
SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**OpenPGP · signing** (master identity key)

```
XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
```

**OpenPGP · sandbox signing** (optional dedicated agent key)

```
XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
```

---

## Verifying

Compare SSH:

```
ssh-keygen -lf <path-to-public-key>
```

Confirm OpenPGP:

```
gpg --fingerprint <your-email>
```

When the printed fingerprint matches the line in `PUBKEYS.md`, character for character, the key is the right one.

---

*May every fork record its own public face honestly. May the private halves stay home.*
