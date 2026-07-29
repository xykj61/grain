# sur — Structures

**Language:** EN  
**Last updated:** 2026-07-29 (Surface p44 — tenth pedestal)  
**Status:** Living — room open; ten pedestals seated

The data-structure museum: every non-networked shape on its own pedestal, viewable in isolation, named once and composed elsewhere. House style: [`PLACARD.md`](PLACARD.md).

## Pedestals

| Pedestal | Role | Witness |
| --- | --- | --- |
| [`shape-surface-count.glow`](shape-surface-count.glow) | First resident · one-field `@u32` count | `tools/gen/season/src_first_resident_witness.rish` |
| [`shape-frame-max-lines.glow`](shape-frame-max-lines.glow) | Frame Tally ceiling (max_lines = 8) | same |
| [`shape-frame-seed-line-count.glow`](shape-frame-seed-line-count.glow) | Seed Frame example lines (3) | same |
| [`shape-brush-skate-cols.glow`](shape-brush-skate-cols.glow) | Thin Skate proof grid width (cols = 40) | same |
| [`shape-brush-skate-rows.glow`](shape-brush-skate-rows.glow) | Thin Skate proof grid height (rows = 8) | same |
| [`shape-brush-max-bytes.glow`](shape-brush-max-bytes.glow) | `.brush` source ceiling (bytes = 16384) | same |
| [`shape-brush-max-pin-bytes.glow`](shape-brush-max-pin-bytes.glow) | One pin value ceiling (bytes = 128) | same |
| [`shape-brush-parse-error-count.glow`](shape-brush-parse-error-count.glow) | Named `ParseError` paths (errors = 10) | same |
| [`shape-brush-surface-field-count.glow`](shape-brush-surface-field-count.glow) | `BrushSurface` fields (fields = 4) | same |
| [`shape-brush-frame-field-count.glow`](shape-brush-frame-field-count.glow) | `BrushFrame` fields (fields = 3) | same |

```
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-surface-count.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-frame-max-lines.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-frame-seed-line-count.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-skate-cols.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-skate-rows.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-max-bytes.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-max-pin-bytes.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-parse-error-count.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-surface-field-count.glow
rishi/bin/rishi run tools/glow_run.rish src/sur/shape-brush-frame-field-count.glow
rishi/bin/rishi run tools/gen/season/src_first_resident_witness.rish
```

Further candidates: `.brush` pin-key count · nest-type / truth-semantics / Glow Book shapes. Brush_parse surface+frame field lane through p44.
