# Computing Toward the Field -- A Survey of Photonic and Thermodynamic Compute

**Stamp:** `20260826.002700`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; twelve companies and one thermodynamic-compute thread surveyed 2026-08-26, read through the field-monist grammar the tree already carries
**Kin:** [`../gratitude/grain-lineage/topos-aether-agni-geometry.md`](../gratitude/grain-lineage/topos-aether-agni-geometry.md) -- [`../foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md`](../foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md)

The machines below share one direction of travel. They move away from charge switched through
wires, toward computation done by shaping a continuous physical field: light in a waveguide,
thermal fluctuation in a lattice of transistors, phase in a ring of silicon. The tree already
carries the grammar for reading this. The topos essay in `gratitude/grain-lineage/` holds the
whole present in every part, and the wafer foundation holds compute close to where the work
happens. This survey reads a dozen companies through that lens, with every figure bounded,
dated, and sourced. All web reads are dated 2026-08-26. Company efficiency claims are named as
claims.

## The observation, before the lens

A processor today computes by switching charge. A bit is a bucket of electrons moved across a
gate, and most of the energy goes to the moving. Three families of hardware now compute
differently. Photonic machines let light interfere in a waveguide, so a matrix multiply happens
in the propagation itself. Thermodynamic machines let transistor noise do the sampling, so a
probability distribution is drawn from physics rather than simulated in logic. And photonic
interconnect keeps even ordinary processors talking through light. The carrying -- the costliest
part of the wafer foundation's story -- then happens in a field rather than a wire.

## The companies, bounded

**Extropic** (US) builds Thermodynamic Sampling Units: standard CMOS transistors whose thermal
noise is steered to sample from programmable probability distributions. The X0 prototype led to
the Z1, its first production-scale part. Funding: $14.1M seed, Dec 2023, led by Kindred Ventures
(The Quantum Insider, 2023-12-05); a letter of intent up to $75M with the US Department of
Commerce CHIPS R&D Office, announced 2026-07-29 (extropic.ai; PRNewswire). Its
orders-of-magnitude efficiency numbers are company claims awaiting independent benchmarks.

**Tenstorrent** (US/Canada) is the electronic kin in this list: RISC-V AI processors and
licensable IP under Jim Keller. Its Galaxy Blackhole platform reached general availability
2026-04-28 (TechStackIPO). Funding: $693M Series D, Dec 2024, at $2.6B (techstartups.com); talks
for $800M at $3.2B pre-money led by Fidelity, Nov 2025 (techstartups.com, 2025-11-18); Qualcomm
reportedly pursuing an acquisition at $8-10B, June 2026 (TechTimes, 2026-06-17) -- a report,
still open. It matters here for one plain reason. The open instruction set -- the same RISC-V
floor Grain's front door names -- carries a multi-billion-dollar frontier company.

**Akhetonics** (Germany) takes the contrarian photonic path: all-optical DIGITAL logic, a
general-purpose processor in light, where nearly everyone else builds analog accelerators.
Funding: EUR 6M, Nov 2024, led by Matterwave Ventures, after EUR 2.3M in July 2024 (Vestbee;
Silicon Canals). Small money, large thesis: that light can carry the whole of computing rather
than only its multiplications.

**Q.ANT** (Stuttgart) builds analog photonic co-processors on thin-film lithium niobate -- the
LENA architecture inside its Native Processing Server. Funding: EUR 62M Series A, July 2025,
co-led by Cherry Ventures, UVC Partners, and imec.xpand, the largest European photonic-computing
Series A (qant.com, 2025-07). Its first co-processor entered the Leibniz Supercomputing Centre's
production HPC floor in July 2025, and a second generation followed March 2026 (DCD,
2026-03-18). An analog light machine sits inside a working supercomputer today.

**Lightmatter** (US) builds Passage, photonic interconnect: the M1000 3D photonic interposer at
114 Tbps announced March 2025, with L200-class parts at 32-64 Tbps expected 2026 (DCD; Sacra).
Funding: $400M Series D announced 2024-10-16 at a $4.4B valuation (BusinessWire), roughly $850M
total (Sacra). This is the field applied to the carrying itself.

**Ligentec** (Switzerland/France) is the quiet substrate under many of these stories: a low-loss
silicon nitride photonic-IC foundry, an EPFL spinout from 2016. It fabricates on 200mm wafers
with X-FAB (Semiconductor Today, 2026-01-20). It reports itself self-financed at roughly 50%
annual growth (venturelab.swiss), and it partners in an EU pilot-line consortium totaling EUR
48M (startupticker.ch). A foundry that keeps its own books balanced is the Lindy-shaped company
in this table.

**Anello Photonics** (US) puts the field to work as a sense organ. Its SiPhOG is a
silicon-photonics optical gyroscope: it reads rotation from the phase of counter-propagating
light -- the Sagnac effect on a chip -- for navigation where GPS is jammed or absent. Funding:
an additional $25M Series B-2, May 2026, led by MESH with Lockheed Martin Ventures among
existing investors (PRNewswire, 2026-05-04), plus a $20M APFIT award, Jan 2026 (PRNewswire).

The photonic quantum five close the table. **Quandela** (France): over EUR 107M total (company
press kit, May 2026); its 12-qubit Belenos machine in 2025 and its Lucy system delivered into
CEA's TGCC under EuroHPC in late 2025 (The Quantum Insider, 2026-04-14). **QuiX Quantum**
(Netherlands): EUR 15M Series A, July 2025, co-led by Invest-NL and the EIC Fund (The Quantum
Insider, 2025-07-10), targeting a first universal single-photon machine in 2026 on silicon
nitride. **PsiQuantum** (US): $1B Series E, 2025-09-10, at $7B, led by BlackRock funds
(psiquantum.com), with utility-scale sites rising in Brisbane (AUD 940M public backing, Q2 2024)
and Chicago (over $500M public support). **Xanadu** (Canada): Aurora, a networked, modular,
room-temperature photonic machine -- 4 racks, 35 photonic chips, 13 km of fiber -- published in
Nature, Jan 2025 (The Quantum Insider, 2025-01-22); public listing April 2026 raising $302M gross
(investors.xanadu.ai, 2026-04-09). **Sparrow Quantum** (Denmark): deterministic single-photon
source chips from the Niels Bohr Institute; EUR 27.5M Series A total, Dec 2025 (The Quantum
Insider, 2025-12-01).

**Sygaldry Technologies** (US) is real, and worth the verification it asked for. Rigetti
Computing founder Chad Rigetti started it in 2024 with Idalia Friedson and Michael Keiser, to
build hybrid quantum-accelerated AI servers. It has raised $139M: a $34M seed led by Initialized
Capital, then a Series A led by Breakthrough Energy Ventures, closed March-April 2026 (DCD;
Crain's Detroit Business, 2026-04-14).

## The inference -- read through the lens the tree carries

Observation first: every non-quantum machine above wins, where it wins, by removing carrying.
Interference computes in place. Noise samples in place. Photonic links carry more while heating
less. That is the wafer foundation's own sentence -- hold the working thing close to the work --
arriving from a second direction.

The inference is the monist one, and the topos essay already wrote its grammar. In each of these
machines the computation is a shaped continuous field. The answer is a local section of a global
state: an interference pattern reads out here what the whole waveguide did everywhere. The whole
is present in every part, in silicon nitride as in the essay's sheaf. Charge-switching treats
computing as beads on wires. These machines treat it as field-shaping, and the hardware is
drifting toward the field view on plain engineering merit -- energy per answer.

A caution keeps the reading honest. Analog photonics trades precision for energy, and the 99.7%
task accuracy Q.ANT reports (qant.com, 2025) is a company figure on chosen workloads. Photonic
quantum machines remain pre-commercial; every delivery above is a research deployment. The
projection, bounded to a five-year horizon: it is likely that photonic interconnect becomes
ordinary in large AI clusters, and the $850M behind Lightmatter is a market saying so. It is
plausible that analog photonic and thermodynamic co-processors earn stable niches in sampling
and inference. Whether all-optical digital or utility-scale photonic quantum arrives inside the
horizon stays an open question. The falsifier is public: benchmark energy-per-answer against a
current GPU, on a named workload, by an independent lab.

For Grain the survey lands as three quiet confirmations. The open floor holds: RISC-V carries
Tenstorrent to frontier scale, and mature-node fabrication carries Extropic and Akhetonics. The
wafer foundation's open-silicon horizon has living company. The field grammar holds: the
machines that win on energy are the ones shaped like the sheaf. And the sensing door the topos
essay names -- signals past the strictly Hertzian framework -- has near neighbors already
shipping. A gyroscope reads rotation from light's phase, and single-photon sources sell as
products.
