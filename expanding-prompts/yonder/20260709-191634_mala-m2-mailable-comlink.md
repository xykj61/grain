# Expanding Prompt -- MUR M2: Mailable over Comlink (Hosted - was MALA)

**Stamp:** `20260709.191634`
**Voice:** Rio 3
**Language:** EN
**Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Status:** Opened with Kaeden's keep-going word -- implement + verify this sitting
**Ground:** design [`20260702-031312`](../../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) - M1 [`182354`](20260709-182354_mala-m1-one-issuer-one-holder.md) - SLC-L2 [`000812`](../../active-designing/20260706-000812_slcl2-sealed-delivery.md) - counsel [`152612`](../../counsel/20260709-152612_claude-counsel-mala-wov-already-designed.md)
Radiant pass `20260728.052149` -- living rename-forward: **MUR** (was MALA); dated path tables keep `mala*` until **kg u32** / **u48**; rehearsals u17-u22 seated  
Radiant pass `20260728.054844` -- delivery + memos landed u50: `murr_delivery` - `murr:*`
Radiant pass `20260728.054644` -- entry/bin landed u49: `murr.rye` / `bin/murr`
Radiant pass `20260728.053112` -- tool-wave u32: living paths -> murr_* witnesses/fixture/wire lab; memo mala:* held for module
Radiant pass `20260728.044925` -- living rename-forward: **MUR** (was MALA); dated path - `mala*` code/witness homes held for tool/module waves

*Written by Kaeden and Rio 3 (Grok).*

---

## The Word, Expanded

Build MUR M2 (was MALA): a mint fact **crosses Comlink's fact lane** between two hosted processes, the holder verifies and folds, and a **signed receipt crosses back** to the issuer. Stop at hosted UDP -- device wire is a later sub-lap (M2b).

## What "Complete" Means, Bound Tightly

**In scope:**

- `linengrow/murr_core.rye` -- shared seeds, memo helpers, sign-append, fold (extracted from M1 so delivery is a second consumer).
- `linengrow/murr.rye` -- M1 selftest rebinds to `murr_core` (behavior unchanged).
- `linengrow/murr_delivery.rye` -- selftest (seal/open/verify/fold in one process) + demo (holder binds mint port -> issuer sends sealed mint -> holder folds -> holder sends sealed `murr:receipt` -> issuer verifies).
- Compact payload via `receipt_core.encode_compact_payload` + `wire_format` seal (same as SLC-L2).
- Ports **38492** (mint -> holder) and **38493** (receipt -> issuer).
- `tools/murr_m2_witness.rish` -- build + selftest + demo; parity-eligible when green.
- Unwelcome in selftest: tampered wire or wrong inner signature refused.

**Explicitly out of scope:**

- Device / virtio wire lab (**M2b**).
- WOV / TigerBeetle.
- Many issuers / Mycelium.
- Changing M1 memo shapes or seeds.

## Demo Ordering (Race Discipline)

Parent spawns **holder** first (binds 38492). Pause. Spawn **issuer** child that **binds 38493 before sending** the mint, then waits for the receipt. Holder: recv mint -> fold -> send receipt to 38493. Matches SLC-L2's recv-first grain; avoids the OA-L3 two-send poster race.

## Verification Shape

`mala` selftest still GREEN. `murr-delivery selftest` and `demo` GREEN. `murr_m2_witness` GREEN. Wire into `parity.rish` -> **199**.

---

*May the mint that leaves one node arrive as the same signed promise on the other. May the receipt that returns close the loop without asking a stranger to agree.*
