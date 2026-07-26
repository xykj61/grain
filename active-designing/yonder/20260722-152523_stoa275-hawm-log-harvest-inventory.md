# STOA275 — HAWM Log-Harvest Inventary

*An Acme Corporation employee reading this gets the first HAWM deepen inventary after the Dexter→Sala finish: which host logs already exist, the agent-readable Bron harvest shape, and a device-free witness that folds meta (or a fixture) into `hawm-harvest.bron`. Multi-AVD fleets and GrapheneOS images stay held.*

**Language:** EN  
**Version:** `20260722.152523` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260722.152622`  
**Register:** Checkable (Two Rooms) — inventary + harvest shape GREEN; live boot harvest when meta has `device:`  

**Grounds in:** STOA274 lean **A** approved · HAWM fleet check-in `20260722.143648` lean **1A** · `hawm0_boot_onpath_host` · `hawm1_sala_witness`  

**dated_guard:** Do **not** claim fleets or multi-AVD. Do **not** claim GrapheneOS under the emulator. Do **not** require `/dev/kvm` for the inventary witness itself.

---

## Host log surfaces (today)

| Surface | Path / channel | Agent-readable today? |
|---|---|---|
| **Boot meta** | `tools/.cache/hawm0/hawm0-boot-meta.txt` | Yes — progress lines + `device: model=…` |
| **Emulator stdout** | `tools/.cache/hawm0/hawm0-emulator.log` | Noisy; kept as path pointer |
| **Rish say** | terminal during `hawm0_boot_onpath_host` / `hawm1_sala_witness` | Ephemeral unless captured |
| **adb logcat** | live on host | Not harvested this lap |
| **Pixel install proof** | `tube05_install_proof` say + `sala_root` / `sala_live_root` | Separate glass path; not HAWM0 meta |

Jail truth: boot stays **host-onpath** (`/dev/kvm`). Inventary witness runs device-free from fixture or an existing meta file.

---

## Harvest shape — `hawm-harvest-v1`

Bron fields (one per line, no quotes):

```bron
format hawm-harvest-v1
stamp YYYYMMDD.HHMMSS
waymark HAWM
rung HAWM0
source meta|meta-fixture
kvm present|absent
boot_completed 0|1
model …
android …
abi …
qemu …
meta_path tools/.cache/hawm0/hawm0-boot-meta.txt
emulator_log_path tools/.cache/hawm0/hawm0-emulator.log
status GREEN
```

Fixture: `tools/fixtures/hawm_harvest_v1.bron`  
Writer: `tools/hawm_log_harvest_worker.sh`  
Output: `tools/.cache/hawm0/hawm-harvest.bron` (gitignored cache)

---

## Verdict (one breath)

**HAWM_HARVEST_V1.** Inventary of meta · emulator log · ephemeral Rish · logcat-held. First GREEN folds meta/fixture into Bron.

---

## Witness

```bash
rishi/bin/rishi run tools/hawm_log_harvest_witness.rish
# after a real host boot (optional live fold):
#   rishi/bin/rishi run tools/hawm0_boot_onpath_host.rish
#   ./tools/hawm_log_harvest_worker.sh
```

---

## Hold

Multi-AVD slots · fleet orchestration · HAWM2 GrapheneOS image · in-jail KVM · logcat stream harvest.
