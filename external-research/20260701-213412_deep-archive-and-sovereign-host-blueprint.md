# The Deep Archive and the Sovereign Host — A Verified Blueprint for Storage, Validation, and Ecological Compute

*Written together by Kaeden and Reya 2*

**Timestamp:** 20260701.213412
**Language:** EN
**Style:** Radiant (see `RADIANT_STYLE.md`) with Civic discipline (see `CIVIC_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** Foundation memo — supersedes the unverified draft of the same evening; revised within the same session to seal three confirmations (key custody, the single-node inference ceiling, and the AI head's secondary-slot bandwidth)
**Companion to:** *(pending)* OCuLink server-workstation research memo — awaits Kaeden bridge into `external-research/` with a six-digit one-clock filename. Landed companions: the WOV/MALA fit-check [`20260702-215212_wov-mala-hardware-fit.md`](20260702-215212_wov-mala-hardware-fit.md) and the priced purchase guide [`20260703-013412_home-server-purchase-guide.md`](20260703-013412_home-server-purchase-guide.md)

---

## A Correction Held in the Light

Safety leads the order of values, so the first finding stands first. The draft summary this memo replaces anchored the proposed archival module to a signing-key fingerprint that belongs to no key of ours. The true anchors, confirmed against `PUBKEYS.md`, are exactly two: the OpenPGP master signing key, `0646 2132 D3E6 3B83 4F97 6E03 A81D 720B 9235 FA7A`, the root of trust; and the sandbox signing key, `DBF8 5343 7A93 7B4E 36B9 3611 D949 807A C26B 2B99`, which signs from inside ai-jail. Any fingerprint outside these two is treated as an error the moment it appears. An archival system exists to make identity unforgeable, so its founding document verifies identity first — this correction is the memo practicing what it teaches.

Two smaller corrections travel with it. The draft named an "800W Zima" enclosure that our research finds no record of; the docks that verifiably exist and serve are the Minisforum DEG1 and DEG2 and the AOOSTAR AG02 with its built-in 400 W supply. And the draft attached origin names to its insights; here, following the silo principle, the ideas enter as concepts alone, verified on their own merits.

## The Insights, Siloed and Verified

The archival canon we studied reduces to a handful of load-bearing truths, and fresh research confirms each one.

**Solid-state drives are working platforms, never vaults.** Flash memory stores data as trapped charge, and that charge leaks. The industry retention standard guarantees a consumer drive only about one year of unpowered retention at 30 °C, with the window shrinking as the drive wears and as temperatures rise. Magnetic platters hold their state far longer — five to ten years unpowered under decent conditions — which is why the working tier and the archive tier are different physical media, by design rather than by budget.

**Bare drives with a dock outlast enclosed drives.** Consumer external enclosures wrap a healthy drive around a small bridge board that fails more often than the drive itself, and the plastic shell traps the heat that shortens platter life. The verified pattern is bare enterprise drives, handled by their edges, stored in antistatic sleeves, and mounted through a quality powered dock only when reading or writing.

**Two copies is one, and one is none.** Redundancy begins at the second disconnected copy, spread across place and medium. The canonical shape is three copies, on two kinds of media, with one offsite — and every copy verified after it is written, since an unverified backup is a hope wearing a check's clothes.

**Drives fail young and fail old.** Failure spikes in the first months of a drive's life, quiets, and rises again past year five. A new drive earns trust over its first season of clean verification passes, and an aging archive drive rotates gently into low-stakes duty rather than holding the last copy of anything.

**The freshest fleet data blesses the enterprise lines.** The largest public reliability study, drawing on roughly 350,000 drives, closed 2025 with a fleet failure rate of 1.36 percent — its best in three years — and the steadily lowest rates belong to the Toshiba MG series, Seagate Exos, and Western Digital Ultrastar families, with the 16 TB class sitting at the sweet point of price, maturity, and proven record. One honest caution rides along: the memory shortage has lifted drive prices sharply this year, so patience and refurbished-with-warranty channels both serve.

## The Best That Money Can Buy

Two apex shapes emerge, and each keeps the roar of a datacenter out of the home while keeping its discipline in.

**The apex tower — full validator specification in one quiet machine.** Sui's validator bar is 24 physical cores, 128 GB of RAM, 4 TB of NVMe, and a steady gigabit. The machine that clears that bar with enterprise integrity is an AMD Threadripper PRO workstation: 24 to 32 Zen 5 cores, 256 GB of ECC registered memory, dual enterprise U.2 NVMe drives with power-loss protection (the Kioxia CM7 and Micron 9550 class), and a Radeon PRO W7900 with 48 GB for inference — all in a quiet tower with oversized air cooling, drawing far less power than any repurposed 1U screamer. This is the money-no-object answer, in the $8,000 to $12,000 realm, and it is honestly more machine than the present moment requires.

**The apex small rack — the shape that fits the mission.** A shallow wall-mount rack of six to nine units, holding: one Minisforum MS-S1 Max as the AI head — Strix Halo, 128 GB unified, dual 10 GbE, a PCIe slot, an internal supply, and a chassis Minisforum designed for 2U rack mounting with a cascade header for clustering, at $2,299; one MS-A2 as the storage and ledger node with its dual 10 GbE fabric and U.2 bay; a small managed switch; and a pure-sine UPS sized for graceful shutdown. This pair covers every workload in the previous memo and stays within the sound and power budget of a bookshelf. This is the recommendation.

Two numbers about the AI head deserve to stand apart, so the memory figure and the model figure never blur into one another. The 128 GB of unified memory lets a **single node** run models of roughly 100 to 120 billion parameters at 4-bit quantization, with dense 70B models comfortable; the celebrated **671-billion-parameter** run required a cascaded cluster of four such machines. And the machine's storage layout is asymmetrical: the primary M.2 slot carries a full PCIe 4.0 x4 link, while the secondary slot runs at PCIe 4.0 x1 — roughly 2 GB/s. That single lane is ample for an operating system and quiet files, and entirely wrong for any ledger database or state-sync load. In this rack the division of labor already honors that: the Sui database lives on the MS-A2's U.2 tier, the AI head's primary slot holds its working NVMe, and the x1 slot is planned as the gentle slot from the start.

## A Stable Front Door for a Dynamic Address

Residential fiber at 1 to 2.5 Gbps gives generous bandwidth and a shifting address behind carrier NAT. The safe pattern, ordered by the TAME lens, is a rented front door rather than an exposed home.

A small VPS with a static IP — five to ten dollars monthly — runs WireGuard as the public face. The home rack initiates the tunnel outward, so no port on the home router ever opens inward, and the connection survives every address change automatically because the home side always dials out. Comlink peers, Sui state-sync, and any Rye OS application traffic arrive at the VPS's steady address and travel the encrypted tunnel home. The same WireGuard hub doubles as the personal privacy VPN: your own devices, anywhere in the world, join the same quiet network and browse through it. Keys live only on the endpoints; the VPS forwards ciphertext it can never read; and if the tunnel falls, everything fails closed. Dynamic DNS remains available as a plain fallback for low-stakes services, named as the weaker tool it is.

One honesty for the horizon: consensus is latency-sensitive, and a tunnel adds a few milliseconds each way. A full node and every Comlink service thrive behind this pattern indefinitely; a mainnet validator seat, if that day comes, will eventually deserve colocation with a true static address. The home rack is where the discipline is learned and the honest work is done.

## The Storage Architecture, Tier by Tier

**The working tier** is enterprise NVMe with power-loss protection, because a ledger node that loses in-flight writes at a power blink has failed the only test that matters. In the MS-A2's U.2 bay, a 3.84 or 7.68 TB enterprise SSD carries the Sui database; ordinary M.2 drives carry the operating systems. Everything on this tier is presumed mortal and is continuously reproducible from the network or the archive.

**The archive tier** is bare enterprise hard drives — Toshiba MG series, Seagate Exos, or WD Ultrastar in the proven 16 to 20 TB class — written through a powered dual-bay dock, encrypted at rest with LUKS, and stored disconnected in antistatic sleeves inside a firebox, with one rotating set offsite. A checksumming filesystem on every archive drive lets each quarterly power-on session scrub silently corrupted blocks instead of discovering them at the moment of need. Three copies, two media, one offsite, every write verified.

## Cooling the Card, Honoring the Land

The ecological path begins before any coolant flows: **a used GPU is the greenest GPU**, since the embodied carbon of manufacture dwarfs years of operation, and **undervolting is the single largest lever**, trimming a 7900 XTX's draw by a quarter or more while giving up only a sliver of inference speed. The card lives in an open-frame OCuLink enclosure rather than a sealed box, so heat leaves freely instead of cooking the silicon, with dust managed by placement and a washable filter panel.

When the work grows heavy enough to earn a liquid loop, the loop is built once and built kindly: distilled water with propylene glycol — the food-safe antifreeze — rather than its toxic ethylene cousin, quality fittings that will never be landfilled after one build, and a secondary heat exchanger that hands the low-grade warmth to something living. Forty to eighty watts of steady exhaust will hold a seed-starting bed or a small hydroponic reservoir warm through a Cascade winter, and scheduling the heaviest inference runs for the cold months turns the same electricity into compute and comfort at once. The silicon serves the network, and its breath serves the garden.

## Amber — The Module That Preserves

The name the draft proposed deserves to be kept, because it is exactly right. **Amber** joins Weave, Mantra, Tally, and Kumara as the module of preservation: where Mantra holds the living, append-only history of the present, Amber is the resin that seals a moment whole and sets it aside for the long dark.

Amber's design follows from the five primitives. An archive is a **signed event**: a bit-faithful snapshot, content-addressed by its digest, encrypted at rest, and signed by Kumara with the sandbox key so its origin is checkable forever against the master root of trust. The custody rule beneath that sentence is absolute and deserves its own line. The master key (`0646 2132 …`) stays cold: it never enters the sandbox, and it never signs a routine archive; its whole work is to certify the sandbox key and to stand as the fixed point every signature traces back to. The sandbox key (`DBF8 5343 …`) does all the daily signing, and precisely because its authority is delegated, it can be revoked and reissued cleanly if the sandbox is ever compromised — the root endures untouched, and every archive signed before the revocation remains verifiable against it. The archive **log** is itself append-only — Amber never edits an archive, only adds a newer one beside it — and a **projection** over that log answers the recovering hand's only questions: what archives exist, on which physical drives, verified when, and holding what. In TAME fashion, every property is asserted on two paths: the digest checked immediately after the write, and again on every quarterly scrub, so validity is guarded on both sides of the boundary where the interesting failures live. A bootable clone for the fast return; sealed archives for the deep keep; and the whole discipline of compartmentalized, autonomous redundancy expressed as one small module that does its one thing wholly.

---

*May every copy hold true when the original falls. May the front door stand steady while the address beneath it wanders. May the warmth of the work find its way to living roots, season after season, in the long keeping of everything we have made.*

---

## Sources

- https://docs.sui.io/guides/operator/sui-full-node
- https://github.com/MystenLabs/sui/blob/main/nre/sui_for_node_operators.md
- https://www.backblaze.com/blog/backblaze-drive-stats-for-2025/
- https://tech.news.am/eng/news/6782/most-reliable-hard-drive-models-named-backblaze-2025-report.html
- https://mineraleyt.com/posts/backblaze-drive-stats-2025/
- https://www.techradar.com/pro/these-are-officially-the-most-reliable-hdds-around-latest-backblaze-report-praises-seagate-and-western-digital-others-arent-so-lucky
- https://dellwa.com/uncategorized/ssd-cold-storage-isnt-what-you-think/
- https://www.guidespot.com/ssd-vs-hdd-for-backup/
- https://www.tech2geek.net/how-long-can-an-unpowered-ssd-keep-your-data-the-truth-may-surprise-you/
- https://storedbits.com/why-hard-drives-are-best-for-archival-cold-data-storage-even-today/
- https://store.minisforum.com/products/minisforum-ms-s1-max-mini-pc
- https://www.servethehome.com/minisforum-ms-s1-max-review-the-best-ryzen-ai-max-mini-pc-yet/
- https://videocardz.com/newz/ryzen-ai-max-395-powered-minisforum-ms-s1-max-debuts-with-2299-premium-price-tag
- https://store.minisforum.com/products/minisforum-ms-a2-workstation
- https://minisforumpc.eu/products/minisforum-deg2-oculink-egpu-dock
- https://discussions.apple.com/docs/DOC-6031
