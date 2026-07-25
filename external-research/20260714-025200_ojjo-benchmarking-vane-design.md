# Ojjo — a Benchmarking Vane That Proves Hoon/Glow Parity by Measuring It

**Language:** EN
**Version:** `20260714.025200` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Vision register — design and research; a proposal, no vane code written, name awaiting confirmation. Register: this is design (Two Rooms — a proposal, not a bound claim). Addressed to a generic Acme Corporation employee.
**Grounds on:** `../gratitude/MeasureWhatMatters.md` (Doerr/Grove), `../gratitude/TIGER_STYLE.md` (TigerBeetle), `../context/TAME_GUIDANCE.md`, `../context/specs/20260714-024800_warm-aura-date-atom-naming.md`

---

## What Ojjo Is

**Ojjo** is a proposed **O-vane** — a TAME-guidance safety-and-performance **benchmarking vane** whose one job is to turn "is Glow at parity with Hoon?" from a felt impression into a **measured, witnessed number**. It runs the same task two ways — a Hoon program scripting Dojo/Arvo, and the equivalent Glow program scripting Rish/Glow — has each system time itself with its *own* timer, records compile-time and runtime statistics, and reports them side by side so a reader can see, rather than believe, where the two stand.

The name is deliberate on three counts:
- **A palindrome — `Ojjo`.** It reads the same both ways, which is the whole point of a parity harness: the measurement must be symmetric, treating the Hoon side and the Glow side by the identical yardstick, or it is not a fair benchmark. The name *is* the discipline.
- **Four letters, O after N.** The proposed vane sequence runs past Lick (L), Maze (M), Neth (N) — **O** is next, and Ojjo is four letters like every vane. It belongs to the family by shape.
- **Quiet in collision research.** Checked this pass: no programming language, operating system, or kernel named Ojjo. The near names are a software-services company (OjjO Software), a low-code platform (Ojoo), and the unrelated Xojo IDE — none in this project's domain, none a real collision. **Low collision risk.**

## The Parity Claim It Proves

The load-bearing claim, stated plainly enough to witness: **for a given task T, a Glow program scripting Rish produces byte-identical output to the equivalent Hoon program scripting Dojo, and Ojjo records how each performed getting there.** Parity has two halves, and Ojjo measures both:

- **Correctness parity (the safety half, first — per TAME's order).** The two programs must produce the *same result*. This is a `welcome`/`unwelcome` witness like any other: same input, same output, or red. A performance number over a wrong result is worthless, so correctness is asserted before any timing is reported.
- **Performance parity (the second half).** Only once correctness holds does Ojjo report the timed comparison — compile time, runtime, and resource cost — for the two paths.

## What Ojjo Measures, and With Whose Clock

Following *Measure What Matters* (measure **output**, not activity) and *High Output Management* (a few measures, chosen because they predict the outcome), Ojjo records a small, honest set — and, crucially, **each system times itself with its own timer**, so neither side is measured by the other's clock:

| Measure | Hoon/Dojo side | Glow/Rish side | Why it matters |
|---|---|---|---|
| **Compile time** | Dojo/Ford build of the Hoon program, timed by Arvo's own timing (Behn/`~` or the runtime's spinner) | Glow build of the Rish program, timed by Rish's own `run` result timing | How long the loop from source to runnable is — the developer-experience cost |
| **Runtime** | Nock evaluation time of the compiled Hoon, by Vere's own measurement | Glow execution time, by Rish's own measurement | The output cost — what the program actually costs to run |
| **Output identity** | the produced value/bytes | the produced value/bytes | Correctness parity — must be byte-identical, or the timing is meaningless |
| **Steadiness (optional)** | best-of-N and variance over repeated runs | best-of-N and variance | TigerBeetle's own instinct: a single number lies; the distribution tells the truth |

The **warm-aura date atom** stamps every run, so a benchmark result is a dated, append-only fact (`YYYYMMDD.HHMMSS`), never overwritten — a measurement history, not a single mutable score.

## What Grounds It (the four teachers named in the ask)

- **Measure What Matters (Doerr).** Objective: know if Glow is at parity. Key Results: the measured numbers above. The book's discipline is Ojjo's whole shape — name the outcome, measure whether you reached it, let the number be the verdict.
- **High Output Management (Grove).** Measure *output* (compile time, runtime) not *activity* (runs launched). Choose the few measures that predict the outcome. Keep them transparent.
- **TAME Guidance.** Safety first: correctness parity is asserted before performance is reported. Performance second: the numbers are sought and shown, but never above correctness. And a benchmark is itself bounded — a fixed task set, a fixed N, named budgets.
- **TigerBeetle / Tiger Style.** Performance is won in design and *proven on metal*, and a distribution beats a single sample. Ojjo reports best-of-N and variance in that spirit, and — like the parity trio already does — treats a green benchmark run as a fact on hardware, not a claim in prose.

## My Honest Opinion (as the ask requested)

**I like it — genuinely — with two refinements and one caution named plainly.**

What is strong about it:
- **It answers a real, recurring question with a fact instead of a vibe.** "Is our new language actually competitive with the one it fuses from?" is exactly the kind of question that otherwise gets answered by feel and then quietly drives bad decisions. A witnessed number is the right answer, and the palindrome name earns its keep by insisting the yardstick be symmetric.
- **It fits the whole project's grain.** It is Two Rooms (measure, don't assert), Civic Style (the measure points at the real outcome), and TAME (safety before performance) all pointed at one concrete target. It is not a new philosophy — it is the project's existing one, applied.
- **It is honest about the hardest part.** Cross-language benchmarking is notoriously easy to do dishonestly. Having each side time itself with its own clock, and gating every timing on byte-identical output, is the honest way to do it.

The two refinements:
- **Correctness parity is the product; performance parity is the passenger.** I would build Ojjo's first lap as a pure *correctness* harness — same task, same output, Hoon vs Glow, green or red — with **no timing at all**. Timing is the second lap. This keeps the first witness small and unfakeable, and it means Ojjo delivers value (a conformance suite proving Glow matches Hoon) even before any performance number is trustworthy.
- **The timer is a seam, not a core.** Wall-clock timing is inherently noisy and host-dependent; per the enclosure/host work, a number from this Mac is not a number from a VPS. Ojjo should treat the timer as a host seam (like the `.peal` codec or the QEMU wire), report the host alongside every number (`GLOW_PROFILE.bron` already names it), and never pin a performance number as a cross-host promise.

The one caution:
- **A benchmark can become a target, and then it lies (Goodhart).** *Measure What Matters*' own warning applies: if "beat Hoon on Ojjo" becomes the goal, someone will optimize the benchmark rather than the language. The guard is TAME's: keep correctness parity the hard gate, keep the task set honest and broad, and treat a fast-but-wrong result as the worst outcome, not a near-miss. Ojjo measures to inform, never to win — the same reason the reframe set down competition-as-engine.

**Recommendation: confirm Ojjo as the O-vane, and build it correctness-first (lap 1 = conformance, no timing), timing-second (lap 2 = the measured comparison, host-stamped).** The name is apt, quiet, and teaches its symmetric discipline; the design is the project's own values pointed at a real question. Denying it is reasonable only if benchmarking is judged premature before Glow itself is built — a fair call, since Ojjo has nothing to measure until there is a Glow program to run. In that case it is a *named horizon vane*, not a today lap.

## Resolved (`20260714.050500`)

- **The name Ojjo is confirmed** (`20260714.034900`), as the O-vane in the proposed vane sequence — recorded in [`../context/specs/20260713-235600_names-awaiting-confirmation.md`](../context/specs/20260713-235600_names-awaiting-confirmation.md) and `../context/LEXICON.md`.
- **Build timing confirmed:** Ojjo is seated **now** as a named horizon vane; lap 1 (correctness-first, no timing) opens the day Glow runs its first program.
- **Correctness-first laps confirmed:** the lap-1-conformance / lap-2-timing split stands as designed above.

---

*May the yardstick read the same both ways, may correctness always gate the clock, and may every number Ojjo reports be one the metal actually gave — measured to learn, never to win.*
