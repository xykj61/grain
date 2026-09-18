# The witness the essay asked for -- Stefan-Boltzmann as a refusal

**Language:** EN - **Style:** Gauge, Field setting - **Voice:** Kyri
**Stamp:** `20260908.124500` - **Status:** Design -- a shape drawn from an artifact this tree already wrote
**Room:** checkable -- the physics is a formula and the refusal is a program
**Source artifact:** [`../press/date/20260907/20260907-175821_the-radiator-and-the-wire-public.html`](../press/date/20260907/20260907-175821_the-radiator-and-the-wire-public.html),
`20260907.175821`, Kyri, public projection, landed here at its own stamp
**Lane:** diffuser -- moonshots and whitepaper research, energy-saving, in tandem with bakery

## The essay names its own next lap, and this page takes it at its word

*The Radiator and the Wire* argues a chip question for orbit: every watt a die burns leaves as
infrared at a rate set by the fourth power of the radiator's temperature. Its section on the first
ship says plainly what a software tree can contribute:

> A small witness ... that takes junction temperature, coolant delta, emissivity, sink, and faces,
> prints square metres per kilowatt, and refuses a spec outside the Stefan-Boltzmann bound would turn
> section 3 from prose into a program.

That is a specification, not an aspiration. It names five inputs, one output, and a refusal.

## Why this belongs to Grain rather than to a spreadsheet

**Because the refusal is the point.** A spreadsheet computes an area and a reader believes it. A witness
computes the same area and **refuses a specification the physics cannot support**, which is what
separates a bound from a number. This tree already keeps that distinction everywhere: a
ceiling beside a constant with the why, and a guard that reds rather than reports.

**Because the essay's own three habits are ours.** It names them: *the bound before the loop*, *the
supervisor with a thermal ceiling*, and *the witness before the narrative*. A die allowed to run at
100 C needs a scheduler that refuses the job pushing it past the radiator's rating, **and the refusal
has to be provable** -- which is Caravan's shape exactly, a supervisor starting everything inside
limits fixed before it begins.

## The shape

**Five inputs**, each a named constant with a bound and a why: junction temperature, the coolant
delta below it, panel emissivity, the sink temperature the panel faces, and the geometry -- one face
to sink, two faces to sink, or one face to 3 K space and one to 255 K Earth.

**One derived reading**: square metres per kilowatt, with the self-view tax named as its own term
rather than folded silently into emissivity.

**Three verdicts, and the third earns the tool.** `within` -- the specification sits inside the
bound. `refused` -- it asks the panel to shed more than the fourth-power law allows at that
temperature, and the refusal prints the margin. **`unbounded`** -- an input was left unnamed, so no
verdict can be given at all. That third verdict matters for the reason it always does here: a
calculation run on a default nobody chose returns a number wearing an answer's clothes.

**Explicit widths, in Rye.** Temperatures and areas are `u32` in fixed units named at construction --
millikelvin and square centimetres -- with the seam to any floating-point library kept at the edge.
The fourth-power term is where a naive `u32` overflows, so that bound is the first assert the module
owes, and it is the reason this is a Rye module rather than a shell script.

## Where it holds its line

**One steady-state radiative balance**, and that is the whole model: conduction networks and
transients stay outside it. The essay's own field is a first sketch in a browser; this is that sketch
made refusable.

**The claim stays small and says so.** The witness proves a specification is *self-consistent with
the Stefan-Boltzmann law*, which is far less than *this design will work*, and that difference belongs
in its own header where a reader meets it first.

## The falsifier

If a reviewer with orbital thermal experience reads the five inputs and says the missing sixth term
changes the answer by more than the margin the witness prints, then the model is too thin to refuse
anything, and the tool reports rather than gates until that term is named.

## What it costs, honestly

The physics is one equation. The work is the bounds, the widths, the control that plants a
specification outside the law and proves the refusal bites, and the header that keeps the claim
small. That is a lap of days, which the essay itself already said.
