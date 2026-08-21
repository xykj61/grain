# Cloud cannot host full Sculpt QEMU — use Framework 16

**Stamp:** 20260712.072525 (bench-clock)  
**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3  
**Prompt:** if this cloud can't host the QEMU boot, say to use Framework 16 AMD Ubuntu 24.04 LTS GNOME Wayland instead of Cursor iOS  
**Product tip:** **430** · **Suite tip:** **432** · **Proven-seat:** **G0** (GRUB only on cloud)

## Thinking trace

Kaeden asked whether the cloud can host the QEMU boot, and whether to return to the Framework 16 host. Re-checked the machine: CPU advertises SVM/VMX bits, yet `/dev/kvm` is absent — nested KVM is not exposed to this pod. Prior G0 run reached SeaBIOS → disk → **GRUB loading** under TCG, then stalled; a three-minute wait never produced Genode/Sculpt userspace; VGA screendump stayed nearly black.

## Verdict

| What | Cloud (this Cursor pod) | Framework 16 (AMD · Ubuntu 24.04 · GNOME Wayland) |
|------|-------------------------|-----------------------------------------------------|
| Fetch Sculpt image + pin sha256 | Yes | Yes |
| QEMU install | Yes (done) | Yes (`qemu-system-x86`) |
| KVM acceleration | **No** — no `/dev/kvm` | **Yes** — native AMD SVM |
| GRUB-loading milestone (G0 partial) | GREEN (already witnessed) | Expected |
| Full Sculpt / Leitzentrale (G0-complete) | **No** — TCG stalls | **Yes** — Genode’s `-accel kvm -cpu host` path |
| G1 receipt guest under Genode | **No** on this pod | **Yes** once Sculpt boots |

**Recommendation:** leave proven-seat G0-complete and G1 for the **Framework 16** host. Keep using Cursor iOS / this cloud for prose, hygiene, Door 3 / Wasmtime witnesses, and T2 glass composition that does not need KVM. For Sculpt boot and the receipt guest, work on the Framework.

On the Framework, from repo root after pull:

```bash
sudo apt install qemu-system-x86
mkdir -p tools/.cache/proven-seat && cd tools/.cache/proven-seat
curl -fLO https://genode.org/files/sculpt/sculpt-26-04.img
curl -fLO https://genode.org/files/sculpt/sculpt-26-04.img.asc
# Genode’s known-good shape (KVM):
qemu-system-x86_64 -accel kvm -cpu host -display sdl -machine q35 \
  -m 1024 -drive format=raw,file=sculpt-26-04.img \
  -netdev user,id=net0 -device e1000,netdev=net0
```

Then extend `tools/proven_seat_g0.rish` (or a G0-complete sibling) once Leitzentrale is visible, and open G1.

## Files

| File | Why |
|------|-----|
| this log | Durable machine counsel |

**Recommend:** keep going on the Framework 16 for proven-seat G0-complete → G1; keep cloud/iOS for non-KVM laps (T2 glass witness, four-remote sync from a credentialed host).
