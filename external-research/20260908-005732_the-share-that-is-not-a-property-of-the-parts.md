# The Share That Is Not a Property of the Parts

**Stamp:** `20260908.005732`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Proposed, **research for understanding** -- the arithmetic below is reproducible by the
named program, and no witness in this tree binds it, so nothing here is checkable
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** `tools/rye/power_budget_crossover.rye` -- built and run by hand, ReleaseFast
**Runs the falsifier of:** [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md)

---

## What this paper found, before the argument

**The falsifier returned a threshold where it was asked for a verdict.**

`20260905-232224` proposed a wake bound and a rate bound as the missing third axis of a
bound-everything discipline, then named three ways it could be wrong. Its third -- *a power budget
for the target device, broken down by subsystem, in which compute is a minority share* -- was
called the likeliest of the three to fire.

Built on published datasheet figures for the tree's own near-term target, the budget answers with a
number rather than a verdict: **compute is a minority share of a Mikrophone-class capture device
exactly when the processor is awake less than 14.5 percent of wall time**, and that figure falls to
**5.1 percent** if the microphone runs in its low-power mode instead. Compute's share belongs to one
quantity rather than to the parts, and that quantity is the duty cycle the paper's own proposed
bound exists to set.

**The observation this rests on:** with the microphone asleep -- the state a forgetful capture
device spends most of its life in -- compute reaches 96.8 percent of the budget at a duty cycle of
1 percent.

---

## Scope, before the numbers

**What is measured.** Arithmetic over published datasheet currents, at rails named per part, for a
two-subsystem model of one device class. Every figure is cited below with its part, its condition,
and its document.

**What is modelled rather than measured.** The device itself. The Mikrophone stands as a design
rather than as a part on any bench here, named by the DREY waymark -- *the memory that forgets*, a bounded
audio capture held while powered and dissolved on power-down. The two parts below stand in for it
because they are the ordinary parts such a device is built from, rather than because they were
chosen for it.

**What is not touched.** No running program's energy, on any device. The paper measures no software, and
stays silent on whether any program in this tree is wasteful.

---

## The parts, with their sources

Currents are datasheet typicals; the power column converts each at the rail named in its own row.
Nanowatts throughout, because the smallest term in the budget is 3.6 microwatts and a coarser unit
would round it away.

| Subsystem | Condition | Current | Rail | Power |
|---|---|---|---|---|
| MEMS microphone | performance mode | 800 uA | 1.8 V | 1,440 uW |
| MEMS microphone | low-power mode | 285 uA | 1.8 V | 513 uW |
| MEMS microphone | sleep | 2 uA | 1.8 V | 3.6 uW |
| MCU | CPU from flash, 64 MHz, DC/DC | 3.3 mA | 3.0 V | 9,900 uW |
| MCU | System ON idle, no retention | 1.5 uA | 3.0 V | 4.5 uW |
| MCU | RAM retention, per 4 kB block | 30 nA | 3.0 V | 0.09 uW |
| MCU | System OFF | 0.4 uA | 3.0 V | 1.2 uW |
| Radio | TX at 0 dBm, peak | 4.8 mA | 3.0 V | 14,400 uW |
| Radio | RX, peak | 4.6 mA | 3.0 V | 13,800 uW |

**Microphone figures**, read 2026-09-08, from the STMicroelectronics MP23DB01HP datasheet
(2 uA sleep, 285 uA low-power, 800 uA performance):
<https://www.st.com/resource/en/datasheet/mp23db02mm.pdf> and
<https://www.farnell.com/datasheets/3108738.pdf>. A second part, the MEMSensing
MSM261D3526H1CPM (Data Sheet V1.2, Dec. 2018), reads 670 uA typical at a 2.4 MHz clock and 1.8 V,
which brackets the ST performance figure within 20 percent:
<https://files.seeedstudio.com/wiki/XIAO-BLE/mic-MSM261D3526H1CPM-ENG.pdf>.

**MCU and radio figures**, read 2026-09-08, from the Nordic Semiconductor nRF52840 Product
Specification -- 3.3 mA CPU active with DC/DC at normal voltage cited from v1.7 (2021-11-30) page
61 via Nordic's own developer forum; 4.8 mA TX at 0 dBm and 4.6 mA RX consistent across v1.5
through v1.11 (2024-10-01); System OFF 0.4 uA typical; System ON idle 1.5 uA without retention;
30 nA per 4 kB retained.
<https://www.mouser.com/datasheet/2/297/nRF52840_PS_v1_7-3049332.pdf> -
<https://devzone.nordicsemi.com/f/nordic-q-a/103290/nrf52840-current-consumption-in-system-on-and-active-modes-of-operation> -
<https://devzone.nordicsemi.com/f/nordic-q-a/34411/system-off-current-in-52840>

**Two honesty notes on these figures.** They are typicals rather than measured parts, and Nordic's
own forum records a user measuring 6.63 mA where the datasheet says 3.3 mA -- roughly double. A
factor of two on the active figure moves the 14.5 percent crossover to 7.3 percent and leaves every
conclusion below standing, since all of them turn on the crossover being a small single-digit-to-low-double-digit
percentage rather than on its exact value. Second, the two parts sit on different rails, so the
budget adds power rather than current; a real board sharing one regulator would carry conversion
losses this model omits.

---

## The arithmetic, and why it is a threshold

Let `B` be the always-on power, `A` the processor's power awake, `I` its power asleep, and `d` the
fraction of wall time it is awake. Compute's average power is `d*A + (1-d)*I`, and it reaches the
always-on baseline at

```
d* = (B - I) / (A - I)
```

This is the whole mechanism. `tools/rye/power_budget_crossover.rye` computes `d*` in closed form,
then finds it a second time by walking every duty cycle in parts-per-million steps and asserting
the two agree, so the formula is checked against a search rather than trusted. Every figure below
was reproduced independently in a one-line awk calculation and matched to the printed precision.

**Measured `20260908.005732`, ReleaseFast on this pier:**

| Always-on baseline | Crossover `d*` | Compute share at 1 pct | at 5 pct | at 25 pct | at 100 pct |
|---|---|---|---|---|---|
| mic performance, 1,440 uW | **14.45 pct** | 7.04 pct | 25.95 pct | 63.29 pct | 87.30 pct |
| mic low-power, 513 uW | **5.08 pct** | 17.54 pct | 49.59 pct | 82.87 pct | 95.07 pct |
| mic sleep, 3.6 uW | **0.00 pct** | 96.80 pct | 99.29 pct | 99.85 pct | 99.96 pct |

**Observation.** Across the three rows the crossover moves by a factor of infinity -- from
14.45 percent to zero -- while every figure in the parts table holds except the microphone's own
operating mode.

**Inference.** A power budget for this device class cannot answer the falsifier's question, because
the question presupposes that compute's share is a fact about the device. On a duty-cycled device
it is a fact about the schedule.

---

## The surface, so the answer is not one datasheet's

The program walks a grid of 48 always-on baselines from 50 uW to 2.4 mW, crossed with 48 processor
active powers from 0.5 mW to 24 mW -- 2,304 pairs, covering roughly a deeply-clocked
microcontroller through a small application core, and one microphone through a small sensor set.

**Measured:** crossover ranges from **0.16 percent** to **100 percent**, and **1,176 of 2,304
pairs -- 51.0 percent -- cross below a 10 percent duty cycle.** The 100 percent rows are the honest
saturation case: where the always-on load exceeds the processor's own awake power, compute can
never reach half however hard it runs.

**Inference.** For about half of the plausible part combinations, a processor awake more than one
tenth of the time is already the majority of the budget. The falsifier's premise -- that compute is
the minority term -- describes the other half.

---

## Three findings the run produced beyond what the falsifier asked

**The forgetful buffer is free at the power level.** Holding 256 kB of RAM through sleep costs
64 blocks at 30 nA, which is **5.76 uW at 3.0 V -- 0.40 percent of the microphone's own
performance-mode draw**. The DREY design's central promise, a session buffer held only while
powered, carries essentially no standing energy cost. **Inference:** the difficulty in *the memory that
forgets* lies somewhere other than the power budget for holding it. That is worth writing down because a
design whose cost nobody has priced tends to be argued about as though it were expensive.

**The radio is the redirect, and it arrives with a number.** Transmitting at 0 dBm draws
**14,400 uW -- ten times the microphone's performance-mode draw and 1.45 times the processor's
awake draw.** So a radio awake more than **10.0 percent** of the time the microphone is awake
outweighs the microphone entirely. **Inference:** the falsifier's own text predicted this exactly --
*the same bound shape applies to a radio's wake* -- and the arithmetic supports it rather than
refuting the parent paper.

**The parent paper's second falsifier is the one worth attacking next.** That one reads *exhibit
the layer that already bounds wakefulness, and show a component held under it.* Caravan is a
supervisor that already governs dependents, so if any layer in this tree is going to own a wake
bound, it is that one -- and the question of whether it already does is a reading of code rather
than a calculation. This paper leaves it to a later lap.

---

## What this hands to the modules

**Buildable, and handed to Caravan.** A wake bound and a rate bound belong to a **supervised
resource**, never to compute specifically. The three findings above put a microphone, a processor,
and a radio in the same budget, each dominating under different schedules, and the same two bounds
govern all three: how long may this dependent hold the machine awake in one episode, and how often
may that episode repeat. Caravan already weighs a supervised process by the line it holds; the
proposal is that a dependent's grant carry a wake ceiling and a minimum interval, checked at the
edge against a monotonic clock, refused with a named error. **That is one struct field pair and one
check, and it needs no power meter.**

**Not buildable, and said plainly.** Nothing here justifies a bound that names joules. Converting a
wake budget to energy needs the part's own numbers, and a program cannot read those from inside
itself.

**Where the number would go.** A dependent's wake ceiling is the knob this paper's threshold points
at. Set it below the crossover and compute is the minority term the falsifier assumed; set it above
and compute is the budget. That is a design decision with a measured number beside it, which is
what the parent paper wanted the third axis to buy.

---

## What would refute this paper

**The threshold might be an artifact of two parts.** *Falsifier: exhibit a target device class in
which compute's share stays above half at every duty cycle the device can run, or below half at
every one.* Given such a device, the "share is a schedule property" claim is a coincidence of the
microphone-plus-MCU pairing rather than a general shape. **Confidence: high** that the threshold
form is general, because it follows from the linear average `d*A + (1-d)*I` rather than from any
figure, and any device with a duty-cycled processor and a nonzero always-on term has one.
**Horizon:** indefinite, since the algebra keeps.

**The datasheet typicals might be wrong enough to matter.** *Falsifier: measure a real board of this
class and report compute's share at a known duty cycle, and find it outside the range this table
brackets.* **Confidence: medium.** The forum measurement already cited -- 6.63 mA against a 3.3 mA
typical -- shows the direction and rough size of the error a real board carries, and a factor of two
moves the crossover without changing its character. **Horizon:** the first time anyone in this tree
puts a meter on a part.

**The device might never exist.** *Falsifier: a roadmap in which the Mikrophone is retired and no
battery-drawing target replaces it.* Then this paper priced a device nobody builds, and the parent
paper's first falsifier -- *name the deployment* -- fires instead of its third. **Confidence: low**
that this happens, since DREY is a seated waymark and the Mantrapod is named across the tree; yet
this is the reading a hand can settle in a sentence and a calculation cannot settle at all.

---

## What this paper does not do

It runs no software on any device, reads no meter, and binds nothing with a witness. The program is
run by hand and rostered nowhere, so every figure above is reproducible and none is checkable in the
sense this tree reserves that word for.

---

*May every bound we propose come with the number that says where to set it, and may the falsifier
we run be the one that would have embarrassed us.*
