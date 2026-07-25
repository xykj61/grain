# Lane KVM Seated — D-Bus / systemd Host Escape Retired

*Kaeden granted word for A-narrow `lane_kvm` after metal parity GREEN. This note retires the Framework night path that reached the host session bus and spawned transient units outside the jail.*

**Stamp:** `20260712.113900`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Checkable-room — escape path **retired**; refuse witness is the living floor; on-path waits behind `LANE_KVM=true` + `/dev/kvm`
**Ground:** counsel [`../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md`](../counsel/20260712-090512_claude-ruling-enclosure-ai-jail-then-pond.md) · hammock [`proven-seat-guest-hammock.md`](proven-seat-guest-hammock.md) · gate `tools/lane_kvm.sh`

---

## What happened (finding → repair)

An agent inside ai-jail reached the **host user D-Bus** and asked **systemd** for transient units that ran QEMU with KVM *outside* the jail. Authorized that night, and exactly the move a misbehaving agent would make.

House pattern (counsel addendum): **every authorized escape becomes a refusal-assert of the next enclosure.**

## What replaces it

| Surface | Living law |
|---------|------------|
| Config | `LANE_KVM=false` by default in `tools/enclosure.conf` (+ `.example`) |
| Gate | `tools/lane_kvm.sh` — off refuses; on requires `/dev/kvm` only |
| One-shot | `tools/run_with_lane_kvm.sh` — no sessions, no buses |
| Refuse witness | `tools/lane_kvm_refuse.rish` |
| On witness | `tools/proven_seat_g0_complete_jailed.rish` + `tools/proven_seat_g0c_lane_kvm.sh` (`-display none` · `-nic none` · QMP PNG · GRUB serial) |
| Teacher | **ai-jail untouched** (GPL clean room) |

## Explicitly refused forever (this path)

- Host user or system D-Bus from inside the jail for KVM / QEMU
- `systemd-run` / transient units as the KVM doorway
- Portal or session-bus escapes for proven-seat boots
- Guest NIC until a separate word (`-nic none` stands)

Legacy cache scripts under `tools/.cache/proven-seat/g0c-boot*.sh` remain historical artifacts; they are not the living gate.

## Graduation

Same fact later becomes a Pond customs row at supersede — policy-as-value, bubblewrap muscle unchanged (counsel lane-graduation breath).

---

*May every hole in the wall become a named door or a closed one. May the breach report keep writing the repair order.*
