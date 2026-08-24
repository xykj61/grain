# New Gauge Style -- the working prose style of this tree

**Three names, one style** (seated `20260823.064454`): **New Gauge Style** in full, **Gauge Style** in short form, and **Gauge Guidance** where it addresses an agent -- recursion-loop prompts, autopilot instructions, and any rule an unattended lap reads. Gauge Guidance is to prose what **TAME Guidance** is to code.

**Full guide:** [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md) - **Seated:** `20260823.045448` on Keaton's word - **Status:** Living
**Inherits:** [`radiant-style`](radiant-style.md) (warmth) - `context/CIVIC_STYLE.md` (name what you reward) - [`tame-guidance`](tame-guidance.md) (bound every claim, say why)
**Meter:** [`../../tools/p/prose_register_witness.rish`](../../tools/p/prose_register_witness.rish)

Write documentation, analysis, forecasting, ecosystem description, and design essays in **Gauge
Style** -- writing that carries measurements and stays worth reading. Radiant Style keeps its
place as the warmest register and as the voice this tree writes in; Gauge is the working style
that borrows that warmth and adds the discipline of a number that can be checked.

## The first rule, before every other

**Don't be too smart about it.** Write so the reader understands, rather than so the writer sounds
impressive. When those two aims part, the reader wins, every time.

> Write it the way you would say it to a friend who is smart, curious, and new here.

Being too smart looks like: the specialist word where a common one carries the meaning; a
paragraph compressed into an aphorism that lands as a riddle; a clever name instead of a
descriptive one; the obvious step left out; three true asides stacked in one sentence; and
explaining a thing in terms of another thing the reader also lacks.

## The three settings

One style, one dial, set by who is reading.

| Setting | Where | Negative sentences | Grade | Cross-refs per 100 words |
|---|---|---|---|---|
| **Door** | READMEs, foundations, onboarding | at or under **20%** | at or under 9 | at or under 1 |
| **Field** | documentation, analysis, forecasting, design essays | at or under **30%** | at or under 11 | at or under 3 |
| **Meter** | ledger rows, witness headers, commit bodies | uncapped -- refusal is the subject | uncapped | uncapped |

## What every setting keeps

- **Lead with what is.** Active voice. *Rather than* over a heavy *not*, *yet* over *but*.
- **Compare by what keeps, never by what decays** (seated `20260823.201533`). *A method keeps longer
  than an answer*, rather than *a named winner rots faster than the guide around it* -- same finding,
  and only the second makes a reader picture decay before reaching the point. Watch **rots, decays,
  withers, rusts, dies, goes stale**: each is honest about the world, wrong as a sentence's first
  move, and doubly tempting because it sounds like wisdom.
- **Name a coined term's plain function on first use** -- and a coined **maxim's** too.
- **Bound every claim.** Scope, period, assumptions, before the number.
- **Every figure carries unit, date, and source.** A number without those three is a rumour with
  a decimal point.
- **Every projection carries horizon, assumptions, falsifier, and confidence in plain words.**
- **Separate observation, inference, and projection** into their own sentences.
- **Name what the thing rewards**, and whether that matches the outcome anyone wants.
- **Say why** beside every surprising choice, threshold, or number.
- **Honesty first, brevity second, delight third**, when they pull against each other.

## Quality assurance -- the report card

**Touch it, read it, grade it.** Four readings of one artifact, meaned into one grade on a plain
school scale, and a door at **B**.

| Reading | Asks | How |
|---|---|---|
| **Register** | Does it lead with what is? | counted -- 100 minus the negative-sentence share |
| **Reach** | Can the reader follow it? | counted -- grade and cross-refs against the setting's budget |
| **Truth** | Are its claims still true? | half counted -- every cited path resolves; the rest is judged |
| **Service** | Does it help the work in front of us? | judged, against `construction/ITINERARY.md` |

**97-100 A+ - 96-90 A - 89-85 B+ - 84-80 B - 79-75 C+ - 74-70 C - 69-65 D+ - 64-60 D - under 60 F.**
No minus grades. **B is 80**, which is the Door register ceiling of 20% flipped, so the seated law
and this door are one number. **Truth gates:** below 60 the card reads **F** whatever else it scored.

```
sh tools/fixtures/qa_report_card.sh <path> [--setting door|field|meter] [--service N]
```

A reading below B **pushes a bounded molt frame** onto the round's stack -- the discipline is
[`quality-assurance`](quality-assurance.md), and the four readings are argued in full in the guide.

## Code comments

The dial runs through the code. **Meter** at a bound or an assert, where the comment says why the
number is that number. **Door** at the head of a module, where a reader arrives with no context
and deserves a plain sentence about what the thing is for.

## Standfast

Moving the living documents into their right setting is a **standfast** awaiting Keaton's word,
recorded at `construction/REDS.md` row `%163`. Dated testimony keeps every word it ever wrote. This rule
governs what is written from here forward.

Canonical Cursor twin: [`../../.cursor/rules/gauge-style.mdc`](../../.cursor/rules/gauge-style.mdc)
