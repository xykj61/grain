# MUR Season — Round u15 · Module-Wave Prep

**Stamp:** `20260728.050833`  
**Season:** [`20260728-025220_the-mur-season-innermost-charter.md`](20260728-025220_the-mur-season-innermost-charter.md)  
**Prior:** [`20260728-050720_mur-season-u14-tool-wave-prep.md`](20260728-050720_mur-season-u14-tool-wave-prep.md)  
**Wave map:** [`20260728-044738_mur-season-u6-tool-module-wave-map.md`](20260728-044738_mur-season-u6-tool-module-wave-map.md)  
**Voice:** Quin · nested frame Trey · Trya  
**Ground:** origin/main `ed734a12ef` (pre-send)  
**Exit:** module-wave order seated · no renames yet · u16 next

*Written together by Keaton and Quin.*

---

## Residual re-probe

| Probe | Result |
|-------|--------|
| `gen_mala` | **ABSENT** |
| `gen_murr` | GREEN · deploy RED |
| Tool-wave prep | seated u14 · still held until u32 |
| Code `mala*` | **unchanged this round** |

## Inventory (held · not moved)

### Entry · core · delivery

| Home today | Lean rename |
|------------|-------------|
| `linengrow/mala_core.rye` | → `murr_core.rye` · symbols `fold_mala_*` → `fold_murr_*` |
| `linengrow/mala.rye` | → `murr.rye` · bin `linengrow/bin/murr` |
| `linengrow/mala_delivery.rye` | → `murr_delivery.rye` |
| Memo prefixes `mala:mint` · `mala:send` · `mala:receipt` | → `murr:*` |

### Importers (~40 `.rye` · ~15 `.zig` twins)

| Cluster | Example homes | Note |
|---------|---------------|------|
| Neth | `neth_serial_core` · `neth_sim` · root/install witnesses | settle consumers |
| Seva / glass | `seva_*` · `glow_seva_b0_*` · `dexter_seva_append` | carriage · view |
| Tube | `tube1_admission` · `tube4_market_rail` | market rail |
| Pool | `pool_host_seam` · `pool_isolation_witness` | host seam |
| Zig twins | matching `.zig` beside rye | keep rye/zig pair per step |

### Comlink guests (with M2b / wire)

| Home today | Lean |
|------------|------|
| `comlink/guest_mala_{mint,receipt}_{tx,rx}.rye` | → `guest_murr_*` |
| `comlink/run_mala_wire_lab.sh` | → `run_murr_wire_lab.sh` |

## Proposed module-wave order (when u48 opens)

| Step | Work | Exit |
|------|------|------|
| **0** | Prefer tool-wave (u32+) already GREEN under new witness names still building old `mala.rye` — or open module wave first if he seats otherwise | honest gate |
| **1** | Rename `mala_core` + update imports in `mala.rye` / `mala_delivery` only | core selftest GREEN |
| **2** | Rename entry + bin; point M1 witness at new paths | `murr_m1` GREEN |
| **3** | Delivery + wire memos `murr:*`; M2 witness GREEN | hosted mail GREEN |
| **4** | Neth importer cluster · choir | neth witnesses GREEN |
| **5** | Seva / glow / dexter cluster · choir | seva witnesses GREEN |
| **6** | Tube · pool cluster · choir | tube/pool GREEN |
| **7** | Zig twin sync per cluster (no drift) | twins match |
| **8** | Comlink guests + `run_*_wire_lab` | M2b lab GREEN |
| **9** | Selftest unit strings · remaining `"mala"` say-lines | clean living |

**Discipline:** one cluster GREEN before the next; repoint every inbound before deleting old paths; TAME width after each rename wave.

## Hard lines (this round and until u48)

- No file renames · no rye/zig edits · no wire prefix change tonight  
- Tool wave may still precede (u32) per u14 list  
- No live shred · deploy · wallet · gas · keys  
- WOV retire still roadmap last  

## Trey — documentary frame

*Camera: a second packing list for the rye shelves — core first, then neth, seva, tube, guests last; the binders stay closed.*

He names the forge order. He does not strike the labels early.

*Cut. u15 complete. u16 next.*

---

*May the module wave open by cluster, may each choir green before the next, may tools and modules keep their calendars.*
