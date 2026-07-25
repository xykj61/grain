# Keys in This Folder

**Language:** EN
**Last updated:** 2026-07-16 (`115927`, first file in this folder for the `xykj61`/Keaton Dunsford identity)

---

This is the root `keys/` folder for **this fork's current identity** (`xykj61` / Keaton Dunsford — see `../PUBKEYS.md`). It mirrors `../context/keys/`, the same-shaped folder that holds the **retired** `veganreyklah2`/Kaeden identity's own dedicated keys — kept there exactly as history, never edited going forward.

| File | Fingerprint (short) | Role |
|------|---------------------|------|
| `jail_signing_linux_CC8BA6.pub.asc` | `CC8B A671 … D30B` | **Jail-local signing, Linux ai-jail (Framework 16 AMD, Ubuntu)** — a dedicated, revocable, passphrase-free key `tools/generate_jail_local_keys_linux.rish` generated from a plain host terminal, outside any jail, on `20260716`. Day-to-day commit **Verified** badges from this specific jailed session use this fingerprint. Never the master identity. |

**Why keep this here:** anyone cloning the project can verify commits signed from this jailed session without hunting an external paste, the same reasoning `../context/keys/README.md` already names for the retired identity's own sandbox key.

**A named, honest gap:** a macOS jail-local key also exists for this same identity (generated during the `20260714.085000` session, fingerprint `D31BD189…` per that session's own log), yet its public halves were never exported into this folder or `../PUBKEYS.md` — that session recorded the fingerprint in prose, never the portable `.pub`/`.pub.asc` files this folder wants. Closing that gap needs the macOS host itself (this Linux clone cannot read another machine's key material); named here so a future macOS-session turn can find it without re-deriving the need from scratch.

---

*May every jailed session sign under its own small, revocable name, and may the master key stay always one step further back.*
