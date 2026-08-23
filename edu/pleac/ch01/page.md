# PLEAC 1.1 — Double It: the First Gate

**Language:** EN
**Stamp:** `20260727.132111`
**Chapter:** one — gates
**Desk:** `gate-pleac-double-u32.glow` · **Witness:** `tools/p/pleac_ch01_witness.rish`

*Written together by Keaton and Quin.*

---

**The task.** Take one number from the command line and answer with its double — the first gate every pilot writes, and the smallest whole trip through the pipeline: Glow lowers to Rye, Rye builds through Zig, and the gate runs on metal.

**The desk, four lines.** A bartis (`|=`) takes one typed sample, `sample=@u32`, and its body calls double with `%-`. The comments ride full-line from character zero, as the column law allows. The stem obeys the runner's roster — `gate-*-u32` stems accept exactly one decimal sample — and this page's first finding is that very roster: it is an explicit list, so recipe one accreted one stem to it, the cookbook's first gift back to the kitchen.

**Run it.**

```
rishi/bin/rishi run tools/g/glow_run.rish edu/pleac/ch01/gate-pleac-double-u32.glow 21
rishi/bin/rishi run tools/p/pleac_ch01_witness.rish
```

**The green line.** `GREEN: pleac ch01 — the first gate answers 42; the cookbook is open.`

**Findings for the kitchen.** Two, named plainly. The runner's sample roster is an explicit stem list rather than a pattern — lawful, and now one stem richer. And the built gate answers by exiting clean rather than by speaking: the value never reaches stdout, so the witness proves the exit and the sample road today, and **a speaking recipe — Glow's own way to say a value aloud — is the stdlib's next bite**, reserved as recipe 1.2's whole subject.

*May the first bite be small, true, and green — and may every finding make the next recipe easier to cook.*
