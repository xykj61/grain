# Glow OS — Get Started

**Language:** EN
**Version:** `20260717.022323` (Eastern) · prior scaffold `20260713.235900`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Mixed register (Two Rooms) — real Pixel/HAWM/TUBE0.5 and Rishi paths named first; four OS variants remain scaffold

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Four Variants](variants/README.md)

---

## Two paths that meet

Glow OS documentation has two front doors that share one house. Pick the door that matches what you came to do; both lead to packaging when you are ready to put a Glow fold on a phone.

| Path | Start here | Compressor |
|------|------------|------------|
| **Language** — what you can type and witness | [`../tutorials/first-witness.md`](../tutorials/first-witness.md) (Rishi) | Glow runes: design brief + [`../../glow/`](../../glow/) (two heads) |
| **Device** — GrapheneOS on Pixel hardware | [`../guides/pixel-10a-grapheneos-setup.md`](../guides/pixel-10a-grapheneos-setup.md) | [`../../docs/HAWM.md`](../../docs/HAWM.md) |
| **Meeting point** — installable APK envelope | `rishi/bin/rishi run tools/tube05_apk_pack_witness.rish` | [`../../docs/TUBE.md`](../../docs/TUBE.md) |

Manual index with both hubs: [`../README.md`](../README.md).

---

## What you can actually run today

### Language path (checkable)

1. **Run your first Rishi witness** — [`../tutorials/first-witness.md`](../tutorials/first-witness.md). This is the teachable language surface today.
2. **Read the Rishi reference** — [`../reference/rishi-language.md`](../reference/rishi-language.md) (parity **142**).
3. **Peek at Glow runes** — `glow/rune_bounded_trap.rye` and `glow/rune_cast.rye` are real, witnessed heads. A full Glow beginner tutorial waits on a general parser; until then, treat Glow grammar as design ([`../../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md)).

### Device path (checkable)

1. **Flash GrapheneOS on a Pixel 10a** — follow [`../guides/pixel-10a-grapheneos-setup.md`](../guides/pixel-10a-grapheneos-setup.md). Confirm the yellow boot-screen hash against GrapheneOS's published Pixel 10a value (`d8f879d1…`). Upstream wording lives in [`../../gratitude/grapheneos/`](../../gratitude/grapheneos/).
2. **Emulation ladder (HAWM0/HAWM1)** — on a Linux host with `/dev/kvm`, boot the AVD and prove Sala B0 inside it: see [`../../docs/HAWM.md`](../../docs/HAWM.md).
3. **Pack a Glow NativeActivity APK (TUBE0.5)** — host-side, no phone required for the pack itself:

```bash
rishi/bin/rishi run tools/tube05_apk_pack_witness.rish
# → tools/.cache/tube05/sala-broadcaster.apk
```

4. **Install and prove the fold (host terminal)** — HAWM0 emulator path GREEN `20260717.122010`; Pixel USB uses the same commands:

```bash
rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish   # if no device yet
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
```

The APK uses Android's own `NativeActivity` and a Glow-built `libglowapp.so` — no Kotlin transpile. `ANativeActivity_onCreate` runs the Sala B0 demo fold and writes `files/sala_root.txt`; the witness checks that root via `run-as`. Ai-jail has neither KVM nor USB.

### Enclosure (checkable)

- On macOS: `./tools/cursor-jail-macos.sh` — [`../guides/macos-ai-jail-setup.md`](../guides/macos-ai-jail-setup.md).
- On this Linux Framework host: the ai-jail under `tools/` (HAWM0/HAWM1 run from a plain host terminal for KVM).

---

## What is still scaffold

These keep the Urbit-shaped "get on the network" outline, marked plainly as proposed:

1. **Choose a variant** — Reya, Riyo, Trey, or Triz ([`variants/README.md`](variants/README.md)). Named, not yet bootable.
2. **Get an identity** — Kumara (Ed25519) runs today; Azimuth integration is open. Docs use invalid placeholders like `~acme-corp-test-ship`, never a real `@p`.
3. **Boot the variant** — fake/local boot path not yet built.
4. **Join the network** — Comlink/Azimuth join remains design.

---

## Honest register in one line

Rishi, HAWM0/HAWM1, HAWM3 (GrapheneOS on a real Pixel 10a), and TUBE0.5 host-side APK packaging are **checkable**. The four OS variants, a full Glow language tutorial, and on-device APK install with a live Glow fold inside `ANativeActivity_onCreate` are the next real steps — not claimed here as done.

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Four Variants](variants/README.md)
