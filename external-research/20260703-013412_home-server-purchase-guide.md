# The Home Server Kit — A Complete Purchase Guide

*The sovereign-host blueprint named the shapes; the fit-check proved them against WOV and MALA; this guide turns both into a shopping list a person can carry. Every part is here — compute, storage, network and the NAT front door, enclosure, cooling, wiring — with a new price and a used-or-recertified price beside each, three budget tiers at the bottom, and two appendices weighing this kit against the apex tower and against the six-GPU training box from the tinygrad world. Prices marked **est.** are honest current-market estimates; everything else was confirmed against a live listing or review this week. One standing caution rides the whole list: the memory shortage has prices moving, so verify each line the week you buy.*

**Stamp:** `20260703.013412`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, joy third; ecological compute
**Ground:** [`20260701-213412_deep-archive-and-sovereign-host-blueprint.md`](20260701-213412_deep-archive-and-sovereign-host-blueprint.md) · [`20260702-215212_wov-mala-hardware-fit.md`](20260702-215212_wov-mala-hardware-fit.md)

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## The Kit in One View

Two quiet machines on a shallow wall rack divide every workload cleanly. The **AI head** (MS-S1 Max, Strix Halo, 128 GB unified) carries inference and heavy builds. The **storage-and-ledger node** (MS-A2, 16 Zen 5 cores) carries the settlement database on enterprise U.2, the WOV ledger file on its own power-loss-protected M.2, and the QEMU guests. A used, undervolted RX 7900 XTX breathes in an open-frame dock beside them for auxiliary inference. Bare enterprise drives sleep in a firebox and wake quarterly for the Amber scrub. A small SFP+ switch joins the pair at 10 GbE, and a rented WireGuard front door gives the whole rack a steady public face with **zero inbound ports** — the home router's NAT stays closed forever, because the rack always dials out.

## One — The Compute Pair

| Part | New | Used / Refurb | Notes |
|------|-----|---------------|-------|
| **Minisforum MS-S1 Max** (AI head; Strix Halo, 128 GB unified, dual 10 GbE, PCIe slot, 2U-mountable) | $2,299 list; sale sightings near **$1,539** | — (too new for a used channel) | Watch the official store; a ~$760-off sale was live this spring |
| **Minisforum MS-A2, Ryzen 9 9955HX** (ledger node) | **$999** barebone ($799 on sale); **$1,199** w/ 32 GB + 1 TB; **$1,919** w/ 96 GB + 2 TB | **$671** manufacturer-refurbished (reg. $1,089) | Refurb direct from Minisforum's own refurbished store — the value pick |
| DDR5-5600 SODIMM for a barebone A2 (2×48 GB) | $280–340 est. | $200–260 est. | Skip if buying the 96 GB configured unit |

The A2's storage layout, confirmed against the maker's sheet: one M.2-2280/U.2 shared bay at PCIe 4.0 ×4 accepting enterprise U.2 to 15 TB through a powered adapter board, plus two further M.2 bays (PCIe 3.0 ×4 by default, BIOS-switchable to 4.0 ×4), 23 TB ceiling, RAID 0/1. Networking is dual 10 G SFP+ on Intel X710 plus dual 2.5 GbE. There is **no USB4 and no Thunderbolt** — the eGPU path is OCuLink, below.

## Two — OCuLink, Confirmed, and the Breathing Card

The key detail, settled with sources: **the MS-A2 carries no native OCuLink port** (that was the MS-A1's gift). The sanctioned path is Minisforum's **optional OCuLink adapter card**, which takes four lanes from the A2's PCIe 4.0 slot (×16 physical, ×8 electrical, **split-capable into two ×4**) and presents a rear OCuLink connector — made precisely to meet the **DEG1 OCuLink eGPU dock**. The split matters: OCuLink can take one ×4 half while the other ×4 half stays free for a future controller. PCIe 4.0 ×4 is ~8 GB/s — generous for inference, where the model loads once and lives in VRAM.

| Part | New | Used | Notes |
|------|-----|------|-------|
| OCuLink adapter card (PCIe → rear OCuLink, low-profile) | $30–45 est. | — | Minisforum's own, or the common M.2→OCuLink cable ($20–30 est.) as fallback |
| **Minisforum DEG1** OCuLink eGPU dock (open-frame) | $99 est. | $70–85 est. | The blueprint's verified dock; open frame lets heat leave freely |
| **Used RX 7900 XTX, 24 GB** | — (buy used by doctrine) | **$600–750 est.** | Undervolt ~25%; a used GPU is the greenest GPU |
| SFX/ATX PSU for the dock, 650–750 W Gold | $100–130 | $55–75 est. | The AG02 dock's built-in 400 W is honest only for smaller cards; a 355 W-class card deserves headroom |

## Three — The Working Tier (Flash)

| Part | New | Used / Recert | Notes |
|------|-----|---------------|-------|
| Enterprise U.2, 3.84 TB, power-loss protection (Kioxia CM6/CM7, Micron 7450/9400 class) — settlement DB | $380–480 est. | $200–300 est. | Lives in the A2's U.2 bay; PLP is the whole point |
| Enterprise M.2 22110 with PLP, 1.92 TB (Micron 7450 PRO class) — **the WOV ledger's own drive** | $190–260 est. | $120–170 est. | The fit-check's first delta: the ledger file never queues behind the settlement DB |
| OS M.2 drives, 1 TB ×2 (one per machine) | $120–150 | $70–100 est. | Ordinary consumer NVMe; presumed mortal, continuously reproducible |

## Four — The Archive Tier (Amber's Metal)

The recertified channel is real and confirmed: dedicated resellers stock recertified Exos X18/X20 and Ultrastar HC550 18 TB drives with full-sector scans and SMART verification before sale, and the going wisdom holds — datacenter pulls run roughly half to two-thirds off retail, with Toshiba MG09 the budget-honest third family.

| Part | New | Recert / Used | Notes |
|------|-----|---------------|-------|
| Enterprise 18 TB ×3 (Exos X18/X20, Ultrastar HC550, Toshiba MG09) | $330–430 ea. est. | **$170–240 ea. est.** | Three copies, two media, one offsite; helium models run quieter |
| Powered dual-bay dock (verified families: Minisforum DEG-class docks are GPU-side; for drives use a quality dual-bay SATA dock) | $60–90 | $40–60 est. | Drives mount only for write, verify, and the quarterly scrub |
| Antistatic sleeves + labels | $15–25 | — | Handled by the edges, stored sleeping |
| Firebox (media-rated) | $70–120 | $40–70 est. | Paper passphrases live here too, per the custody rulings |

## Five — Network, NAT, and the Front Door

| Part | New | Used | Notes |
|------|-----|------|-------|
| **MikroTik CRS309-1G-8S+** (8× SFP+ managed) — or CRS305 (4× SFP+) on a budget | $269 / $149 | $170–200 / $90–110 est. | Fanless; the rack's 10 GbE spine |
| SFP+ DAC cables, 1 m ×3 | $45–60 | $20–30 est. | Machines to switch; passive DACs run cool |
| Cat6a patch set + 10 GbE SFP+→RJ45 module (uplink to the home router) | $50–70 | — | One warm module is plenty |
| **WireGuard VPS front door** | **$5–10 / month** (opex) | — | The rack dials out; **no port on the home NAT ever opens inward**; survives every address change; fails closed |

One budget sentence joins it, per the bandwidth memo: **the VPS plan's monthly transfer cap is the rack's true public bandwidth budget** — name it as a constant and meter it at the tunnel's mouth ([`20260703-015512_bandwidth-and-moderation.md`](20260703-015512_bandwidth-and-moderation.md)). The NAT posture deserves its one plain sentence: the home router keeps every inbound door shut, the tunnel is the only public face, and dynamic DNS remains the named weaker fallback for low-stakes services only.

## Six — Enclosure, Power, Cooling, Wiring

| Part | New | Used | Notes |
|------|-----|------|-------|
| Shallow wall-mount rack, 9U open-frame | $90–160 | $50–90 est. | The S1 Max is designed for 2U mounting; the A2 rides a shelf |
| 1U vented shelves ×2 + blank panels | $50–70 | $25–40 est. | |
| **Pure-sine UPS**, 1500 VA (CyberPower CP1500PFCLCD class) | $220–260 | $120–160 est. (renewed) | Sized for graceful shutdown of both nodes + switch |
| Surge PDU, 1U | $35–55 | $20–30 est. | |
| 120 mm quiet fans ×2 + washable filter panel (for the open-frame GPU) | $45–65 | — | Dust managed by placement and the filter, per the blueprint |
| Velcro, cable combs, labels | $25–35 | — | Wiring that can be read is wiring that can be trusted |

## The Budget, Three Ways

**Tier one — the ledger-and-archive core** (no AI head, no eGPU yet; everything MALA M0–M2 and Amber's first seasons need): A2 refurb + RAM + U.2 recert + WOV M.2 + OS drive + three recert 18 TB + dock + firebox + CRS305 + cables + rack + UPS renewed + power/cooling small parts — **≈ $2,700–3,100**.

**Tier two — the full value kit** (both machines, the breathing card, everything above, used and recertified wherever the part is proven): **≈ $5,000–5,600**, with the midpoint near **$5,200**. This is the recommendation — the whole blueprint realized, at ecological prices, with headroom through WOV's two-monarch season.

**Tier three — the full kit bought new** (sale pricing on the S1 Max, configured 96 GB A2, new drives throughout, used only where doctrine demands it — the GPU): **≈ $7,600–8,400**. Worth naming honestly: all-new pricing brushes the apex tower's floor, which is exactly where Appendix A picks up.

## Appendix A — Against the Apex Tower ($8,000–12,000)

The tower from the blueprint's own pages — Threadripper PRO, 24–32 Zen 5 cores, **256 GB of registered ECC**, dual enterprise U.2 with PLP, a 48 GB workstation GPU, one quiet chassis — remains the money-no-object answer, and the value math now reads cleanly in both directions. Against the **value kit (~$5.2k)**, the tower costs roughly double and buys the three things the small rack honestly lacks: full-path ECC (the fit-check's named threshold for a value-bearing monarch), twice the unified GPU memory in one card, and single-box simplicity. Against the **all-new kit (~$8k)**, the tower's premium shrinks to near nothing — so the rule of thumb writes itself: *buy the small rack used and it is the clear win; the day you find yourself pricing it all-new, price the tower instead, because ECC at that point costs almost nothing extra.* The tower also remains the pre-written answer for MALA M4's validator-class season, exactly as the fit-check bracketed it.

## Appendix B — Against the tinybox red

The tinygrad world's red box is the kindred spirit at the far end of the scale, and its maker's bet rhymes with ours: consumer Radeon silicon, chosen deliberately, priced against the datacenter. Confirmed shape: **six RX 7900 XTX** on full-fabric PCIe 4.0 ×16 links with working peer-to-peer, an **EPYC 7532** (32 cores), **128 GB** of system RAM, five 1 TB NVMe drives (four in RAID, one boot), **two 1600 W supplies**, a 12U chassis, **~738 FP16 TFLOPS**, **144 GB pooled VRAM**, ~5.76 TB/s aggregate memory bandwidth — **$15,000** at launch, with 2026 coverage placing the line at $15–17k.

Read against our rack, the comparison is a fork in purpose rather than a ranking. The red box is a **training appliance**: one loud, hungry, magnificent machine whose dual-1600 W supplies alone outdraw our entire rack several times over, built to pool six cards into one workload. Our kit is a **sovereign homestead**: ledger, archive, network, and inference in under ~500 W typical, sized for rooms where people sleep. On raw inference arithmetic, our single undervolted XTX is one-sixth of its compute (~123 FP16 TFLOPS), while the S1 Max's 128 GB *unified* memory runs 100–120 B-parameter models on one quiet node — a capability the red box reaches differently, by pooling 144 GB of VRAM across six cards. And one of its lessons travels home free of charge: the red box exists because 7900 XTX peer-to-peer genuinely works, which is the same silicon honesty our WOV lane leans on. If a true training season ever arrives, the red box — or a used one — is the shelf to look at; until then it is the proof, at 6×, that the card we already chose was the right bet at 1×.

---

*May every part on this list earn its place the day it arrives. May the used and the recertified outlast the doubt that discounted them. And may the whole rack hum so quietly that the ledger, the archive, and the household all keep their peace under one roof.*

---

## Sources

- https://store.minisforum.com/products/minisforum-ms-a2-workstation
- https://refurbished.minisforum.com/products/minisforum-ms-a2
- https://videocardz.com/newz/minisforum-launches-ms-a2-mini-workstation-with-ryzen-9-9955hx-price-starts-at-799
- https://hothardware.com/news/minisforum-ms-a2-mini-pc-ryzen-9-9955hx-dual-10gbe-lan
- https://www.servethehome.com/minisforum-ms-a2-review-an-almost-perfect-amd-ryzen-intel-10gbe-homelab-system/2/
- https://nascompares.com/review/minisforum-ms-a2-review-the-ms-01-killer/
- https://serverpartdeals.com/collections/seller-refurbished-hdd
- https://diskdojo.com/articles/enterprise-drives-home-nas-guide
- https://www.tomshardware.com/tech-industry/artificial-intelligence/tinybox-packs-a-punch-with-six-of-amds-fastest-gaming-gpus-repurposed-for-ai-george-hotzs-new-box-uses-radeon-7900-xtx-and-retails-for-dollar15k-now-in-production
- https://www.tweaktown.com/news/97110/tinycorps-new-tinybox-ai-system-amd-gpu-starts-at-15k-nvidia-25k/index.html
- https://dev.to/onsen/tinybox-the-offline-ai-device-running-120b-parameters-548
