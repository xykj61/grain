# Proven-Seat Guest — Hammock (living)

*Kaeden granted word for the standing recommendations (`20260712.071405` bench-clock). This hammock opens Genode/Sculpt G0 on the cloud QEMU path while Caravan stays the named horizon — guest, never merger.*

**Stamp:** living ledger (born `20260712.071405` bench-clock) · refreshed `20260712.195339` (G1 opened · crossing spike GREEN)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Status:** Living — **G0** GREEN · **G0-complete** `004012` · **`lane_kvm`** on-path GREEN `140403` · parity re-pin GREEN `193958` · **G1 opened** `195339` — crossing path named; serial verify-witness ahead
**Ground:** ER [`../external-research/20260712-054342_proven-seat-guest-genode-sel4.md`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md) · counsel [`20260712-195155_proven-seat-g1-claude-opening-counsel.md`](20260712-195155_proven-seat-g1-claude-opening-counsel.md) · crossing pin [`20260712-195339_proven-seat-g1-crossing-pin.md`](20260712-195339_proven-seat-g1-crossing-pin.md) · product nib **430** · suite nib **432**
**License (gratitude):** Genode/Sculpt images are AGPL-hosted teacher artifacts — held under `tools/.cache/proven-seat/` (gitignored); never linked into Rye ship binaries; Caravan keeps its name.

---

## Enclosure (Framework 16 · this season)

| Layer | What holds |
|-------|------------|
| **Metal** | Framework 16 AMD Ryzen 7040 · Ubuntu 24.04 LTS · GNOME Wayland · native SVM · `/dev/kvm` on the host |
| **Cursor session** | Inside **ai-jail** (`hostname ai-sandbox`) — GPU/Wayland passed; **`/dev/kvm` not passed** while `LANE_KVM=false` |
| **Pond** | Horizon for superseding ai-jail with TAME-guided safety — **not yet** the daily enclosure |
| **`lane_kvm`** | A-narrow gate in `tools/enclosure.conf` — **off by default**; `/dev/kvm` only; refuse `tools/lane_kvm_refuse.rish`; on-path `tools/proven_seat_g0_complete_jailed.rish` (`-display none` · `-nic none`) |
| **Retired** | Host user D-Bus + systemd transient units as the KVM doorway — [`113900`](20260712-113900_lane-kvm-retire-dbus-escape.md) |

Signing: Kaeden’s own keys on this host; lane key stays cloud; sandbox key stays ai-jail.

## Word

Kaeden: *“i grant my word for any recommendation.”* Treated as the seat word for proven-seat metal (and the other parks that awaited word).

## G0 — environment exists (cloud + metal)

| Check | Result |
|-------|--------|
| Official image | `sculpt-26-04.img` from genode.org (sha256 `241b916ab9e3ed25a089c27119aac98f80fe4d3e67101936b4e69d7f1c708f14`) |
| Signature file | `sculpt-26-04.img.asc` fetched beside the image |
| QEMU | `qemu-system-x86_64` 8.2.2 |
| Boot milestone (TCG / nographic) | SeaBIOS → “Booting from Hard Disk…” → **“GRUB loading.”** |
| Witness | `tools/proven_seat_g0.rish` |

## G0-complete — Leitzentrale under KVM (Framework host)

| Check | Result |
|-------|--------|
| Accel (legacy `004012`) | `-accel kvm -cpu host -machine q35 -m 4G` on the **host** via D-Bus/systemd — **retired** [`113900`](20260712-113900_lane-kvm-retire-dbus-escape.md) |
| Accel (living) | Same QEMU shape under **`lane_kvm`**: `-display none` · `-nic none` · QMP screendump — `tools/proven_seat_g0c_lane_kvm.sh` |
| Glass (`004012`) | Screendump `g0c-leitzentrale-witness.png` — Sculpt **Components** graph with live **`leitzentrale`** node |
| Serial floor | GRUB loading on COM1 |
| Refuse witness | `tools/lane_kvm_refuse.rish` — **GREEN** with `LANE_KVM=false` |
| On witness | `tools/proven_seat_g0_complete_jailed.rish` — ready; needs `LANE_KVM=true` + `/dev/kvm` (host one-shot `run_with_lane_kvm.sh`) |
| Eyes | Session log `20260712.004012` — human/agent witness of the Leitzentrale glass |

Bare-metal USB boot stays a **separate word**. Depot/red diagnostics on first boot are teacher-image unfinished edges, not our blockers for G0-complete.

## Still ahead

| Lap | Prove |
|-----|-------|
| **G1 crossing** | **Named** `195339` — Genode toolchain + posix/libc; probe GREEN; toolchain fetch next |
| **G1 serial** | `receipt_core` verify-witness one GREEN on jailed TCG serial — skeleton `tools/proven_seat_g1.rish` |
| **G2** | Capability-shaped Genode component (console/ROM only) — check in with Claude first |
| **G3** | Optional Caravan seed pattern as Genode parent — check in with Claude first |

## Law held

Guest, never merger. No Genode/seL4 code in `caravan/`. No AGPL link into Rye binaries we ship.

---

*May the seat boot far enough to prove it is real. May Caravan keep its name while Rye learns to stand as a guest. May Pond one day hold the same enclosure with TAME’s calm hands. May every next lap name the machine it needs.*
