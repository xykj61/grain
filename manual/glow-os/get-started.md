# Glow OS — Get Started

**Language:** EN
**Version:** `20260718.192716` (Eastern) · prior `20260717.173427` · scaffold `20260713.235900`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Audience:** an Acme Corporation employee choosing a first door on this tree
**Status:** Mixed register (Two Rooms) — real Pixel/HAWM/TUBE0.5 and Rishi paths named first; OS variants remain scaffold

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Five Variants](variants/README.md)

---

## Two paths that meet

Glow OS documentation has two front doors that share one house. Pick the door that matches what you came to do; both lead to packaging when you are ready to put a Glow fold on a phone.

| Path | Start here | Compressor |
|------|------------|------------|
| **Language** — what you can type and witness | [`../tutorials/first-witness.md`](../tutorials/first-witness.md) (Rishi) | Glow: [`../../glow/README.md`](../../glow/README.md) (eight heads) · Acme first code [`../../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md`](../../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md) |
| **Device** — GrapheneOS on Pixel hardware | [`../guides/pixel-10a-grapheneos-setup.md`](../guides/pixel-10a-grapheneos-setup.md) | [`../../docs/HAWM.md`](../../docs/HAWM.md) · waymarks [`../../docs/JABS.md`](../../docs/JABS.md) |
| **Meeting point** — installable APK envelope | `rishi/bin/rishi run tools/tube05_apk_pack_witness.rish` | [`../../docs/TUBE.md`](../../docs/TUBE.md) |

Manual index with both hubs: [`../README.md`](../README.md).

---

## What you can actually run today

### Language path (checkable)

1. **Walk the compass once** — compressor [`../../docs/COMPASS.md`](../../docs/COMPASS.md) · card [`../../docs/compass_card.bron`](../../docs/compass_card.bron) · tutorial [`../tutorials/cursor-and-the-compass.md`](../tutorials/cursor-and-the-compass.md). Stitches foundations, **witness habitat** (Acme face for the happy zone), Cursor rules, Bron logging, and send.
2. **Run your first Rishi witness** — [`../tutorials/first-witness.md`](../tutorials/first-witness.md). This is the teachable language surface today.
3. **Read the Rishi reference** — [`../reference/rishi-language.md`](../reference/rishi-language.md) (parity **142**).
4. **Peek at Glow runes** — eight heads lower today; desk hop `rishi/bin/rishi run tools/glow_run_desk_witness.rish`. Start with Acme first code [`../../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md`](../../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md) (`glow/gen/face-mix.glow`). Pin [`../../glow/README.md`](../../glow/README.md). Grammar design: [`../../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md). Law: [`../../context/TAME_GUIDANCE.md`](../../context/TAME_GUIDANCE.md) (Glow supplement still horizon — scoping ER linked from the Glow pin).

### Device path (checkable)

1. **Flash GrapheneOS on a Pixel 10a** — follow [`../guides/pixel-10a-grapheneos-setup.md`](../guides/pixel-10a-grapheneos-setup.md). Confirm the yellow boot-screen hash against GrapheneOS's published Pixel 10a value (`d8f879d1…`). Upstream wording lives in [`../../gratitude/grapheneos/`](../../gratitude/grapheneos/).
2. **Emulation ladder (HAWM0/HAWM1)** — on a Linux host with `/dev/kvm`, boot the AVD and prove the **JABS0** Sala fold root inside it (module `sala_b0_fold` — dated name kept): see [`../../docs/HAWM.md`](../../docs/HAWM.md) · [`../../docs/JABS.md`](../../docs/JABS.md). Waymark law: [`../../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md`](../../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md).
3. **Pack a Glow NativeActivity APK (TUBE0.5)** — host-side, no phone required for the pack itself:

```bash
rishi/bin/rishi run tools/tube05_apk_pack_witness.rish
# → tools/.cache/tube05/sala-broadcaster.apk
```

4. **Install and prove the fold (host terminal)** — HAWM0 GREEN `20260717.122010` · Pixel 10a GREEN `20260717.123226`; same commands:

```bash
rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish   # if no device yet
rishi/bin/rishi run tools/tube05_install_proof_onpath_host.rish
```

The APK uses Android's own `NativeActivity` and a Glow-built `libglowapp.so` — no Kotlin transpile. `ANativeActivity_onCreate` runs the JABS0 Sala fold demo (module `sala_b0_fold`) and writes `files/sala_root.txt`; the witness checks that root via `run-as`. Ai-jail has neither KVM nor USB.

### Enclosure (checkable)

- On macOS: `./tools/cursor-jail-macos.sh` — [`../guides/macos-ai-jail-setup.md`](../guides/macos-ai-jail-setup.md).
- On this Linux Framework host: the ai-jail under `tools/` (HAWM0/HAWM1 run from a plain host terminal for KVM).

---

## What is still scaffold

These keep the Urbit-shaped "get on the network" outline, marked plainly as proposed:

1. **Choose a variant** — Reya, Riyo, Trey, Triz, or Quin ([`variants/README.md`](variants/README.md)). Named, not yet bootable.
2. **Get an identity** — Kumara (Ed25519) runs today; Azimuth integration is open. Docs use invalid placeholders like `~acme-corp-test-ship`, never a real `@p`.
3. **Boot the variant** — fake/local boot path not yet built.
4. **Join the network** — Comlink/Azimuth join remains design.

---

## Honest register in one line

Rishi, eight Glow rune heads + desk hops, HAWM0/HAWM1, HAWM3 (GrapheneOS on a real Pixel 10a), and TUBE0.5 host-side APK packaging are **checkable**. OS variants, a full Glow language textbook, and glass authored in Glow rather than Rye remain horizon — named honestly in the Acme first-code prompt, not claimed here as done.

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Five Variants](variants/README.md)
