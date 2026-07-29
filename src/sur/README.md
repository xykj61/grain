# sur — Structures

**Language:** EN  
**Last updated:** 2026-07-28 (Surface p15 — second pedestal)  
**Status:** Living — room open; first resident + second pedestal seated

The data-structure museum: every non-networked shape on its own pedestal, viewable in isolation, named once and composed elsewhere. House style: [`PLACARD.md`](PLACARD.md).

## Pedestals

| Pedestal | Role | Witness |
| --- | --- | --- |
| [`shape-surface-count.glow`](shape-surface-count.glow) | First resident · one-field `@u32` count | `tools/gen/season/src_first_resident_witness.rish` |
| [`shape-frame-max-lines.glow`](shape-frame-max-lines.glow) | Frame Tally ceiling (max_lines = 8) | same |

```
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-surface-count.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-frame-max-lines.glow
rishi/bin/rishi run tools/gen/season/src_first_resident_witness.rish
```

Further candidates: nest-type shapes, truth-semantics values, record shapes the Glow Book describes — each with its own placard.
