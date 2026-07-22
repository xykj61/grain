# STOA277 — HAWM0 Boot → Harvest Chain

*An Acme Corporation employee reading this gets the one-shot host chain after inventary: `hawm0_boot_onpath_host` then `hawm_log_harvest_worker` into `hawm-harvest.bron`. The chain is authored and the harvest half is GREEN device-free. Full boot GREEN needs `/dev/kvm` on a plain host terminal — the jail refuses honestly when KVM is absent.*

**Language:** EN  
**Version:** `20260722.152801` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — chain authored · harvest half GREEN `20260722.152801` · full boot onpath pending host KVM  
**Register:** Checkable for authoring + harvest half; Intent for live boot GREEN until host onpath prints GREEN  

**Grounds in:** STOA276 lean **B** · STOA275 inventary · `hawm0_boot_onpath_host` · `hawm_log_harvest_worker`  

**dated_guard:** Do **not** claim full boot→harvest GREEN from a session without `/dev/kvm`. Do **not** claim fleets. HAWM1 root-into-harvest stays lean C.

---

## Verdict (one breath)

**BOOT_HARVEST_CHAIN.** Onpath script · kvm refuse · harvest half GREEN · host runs full chain when KVM is free.

---

## Witness / operator

```bash
# Device-free (jail OK):
rishi/bin/rishi run tools/hawm0_boot_harvest_chain_witness.rish

# Full chain (plain host terminal with /dev/kvm):
rishi/bin/rishi run tools/hawm0_boot_harvest_onpath_host.rish
```

---

## Hold

HAWM1 root field in harvest · multi-AVD · HAWM2 · gold · JABS3 · UDP.
