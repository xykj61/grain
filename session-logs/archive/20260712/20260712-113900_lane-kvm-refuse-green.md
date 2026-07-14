# lane_kvm seated — refuse GREEN · D-Bus escape retired

**Stamp:** `20260712.113900`
**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3
**Prompt:** Kaeden — `word granted` for A-narrow `lane_kvm` after parity GREEN. Filing clock from the 11:39 message minute.
**Product tip:** **430** · **Suite tip:** **432**

## Thinking trace

1. Word granted for counsel `090512` ordered green #2: seat `lane_kvm` off by default, `/dev/kvm` only, paired refuse, in-jail G0-complete (`-display none` + QMP PNG + GRUB), retire D-Bus/systemd escape.
2. Current enclosure: `hostname ai-sandbox`, `/dev/kvm` absent (ai-jail `--dev` minimal). Teacher ai-jail has `--gpu`, no `--kvm` — left unmodified (GPL clean room).
3. Seated config: `LANE_KVM=false` in `enclosure.conf.example` + personal `enclosure.conf`.
4. Gate: `tools/lane_kvm.sh` (status · assert-off · assert-on · run · refuse-probe) + `tools/run_with_lane_kvm.sh` one-shot wrapper.
5. On-path scripts: `proven_seat_g0c_lane_kvm.sh` (`-accel kvm -cpu host -m 4G -display none -nic none` + QMP screendump + GRUB serial) + `proven_seat_g0_complete_jailed.rish`.
6. Refuse witness `lane_kvm_refuse.rish` → **EXIT:0 GREEN**. On-path correctly asserts refuse without kvm (EXIT:1 until host grant).
7. Dated retirement: `active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md`. Hammock, TASKS, RTAC, dependency ladder A3, enclosure-editors, legacy G0-complete header refreshed. `cursor-jail.sh` warns if lane flipped on.

## Observations

Refuse floor holds inside today’s jail. On-path G0-complete wants a host one-shot with `LANE_KVM=true` and `/dev/kvm` — no D-Bus escape. Pond still graduates the lane at supersede. G1 / Pond baseline stay on word.

## Files

- `tools/enclosure.conf.example` · `tools/enclosure.conf` — `LANE_KVM=false`
- `tools/lane_kvm.sh` · `tools/run_with_lane_kvm.sh` — gate
- `tools/lane_kvm_refuse.rish` — paired refuse GREEN
- `tools/proven_seat_g0c_lane_kvm.sh` · `tools/proven_seat_g0_complete_jailed.rish` — on-path
- `tools/cursor-jail.sh` · `tools/proven_seat_g0_complete.rish` — warn / legacy note
- `active-designing/20260712-113900_lane-kvm-retire-dbus-escape.md` · hammock · TASKS · RTAC · ladder · enclosure-editors

## Next-step recommendation

**Recommend:** keep going to host one-shot on-path G0-complete when Kaeden grants `LANE_KVM=true` on a session with `/dev/kvm` — mechanical against written gate; check in with Claude before G1 or Pond six-bar baseline (new domain rungs).
