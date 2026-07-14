# Public Keys — This Fork's Identity

**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Since:** `20260713.201910` (this fork's first commit)

---

This fork of Urbit, layered over the Rye OS project from `groupproject36/veganreyklah2`, carries its own identity forward from here. The record below is this identity's public face; the private halves stay home, exactly as `PUBKEYS.template.md` asks of every fork.

---

## The Identity

- **Handle** — `xykj61`
- **Name** — Keaton Dunsford
- **Email** — keatondun@gmail.com
- **Urbit Azimuth star** — `~bandun`
- **Urbit Azimuth planet** — `~pacpet-solreb`

---

## The Keys

**Codeberg · SSH**

```
SHA256:/zQD+VRI1L/KuqGavhb4N+F/K7FdaH7B0YR4OT7a8iw
```

**GitHub · SSH**

```
SHA256:fL9IfWIyHik6gAU8sM2/zmfpJsW3+75fN4FjOE/98YA
```

**OpenPGP · signing** (this fork's identity key)

```
1622 6BC7 D5B3 1C88 8809  2BE6 F096 19B9 B845 1F67
```

---

## Verifying

```
ssh-keygen -lf ~/.ssh/id_ed25519_urbit_codeberg.pub
ssh-keygen -lf ~/.ssh/id_ed25519_urbit_github.pub
gpg --fingerprint keatondun@gmail.com
```

When the printed fingerprint matches the line above, character for character, the key is the right one.

---

## Why the Azimuth Points Are Named Here Too

Kumara's own Ed25519 identity seam already echoes Urbit's own point-identity model in spirit, per this fork's naming-mapping proposal (`context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md`). Naming the real `~bandun` and `~pacpet-solreb` points here, alongside the forge keys, keeps this fork's whole identity — forge, signing, and network — in one honest place, ready for whenever the Azimuth/Comlink integration work (still on this project's own open list) needs a real point to build against.

---

*May every fork record its own public face honestly. May the private halves stay home. May this new journey carry its name forward plainly, from this point on.*
