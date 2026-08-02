# sur — Structures

**Language:** EN  
**Last updated:** `20260802.132104` (Equinox e203 — Mantra M1 Line fields)  
**Status:** Living — room open; Surface pedestals + Glow Tend structure pedestals

The data-structure museum: every non-networked shape on its own pedestal, viewable in isolation, named once and composed elsewhere. House style: [`PLACARD.md`](PLACARD.md). Glow Tend **structures** accrete here; shared gates stay in [`../lib/`](../lib/README.md).

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
| [`shape-brush-pin-key-count.glow`](shape-brush-pin-key-count.glow) | Required `.brush` pins (keys = 4) | same |
| [`shape-caravan-max-name-len.glow`](shape-caravan-max-name-len.glow) | Caravan `max_name_len=48` (Tend C3) | `tools/caravan_glow_tend_limb3_witness.rish` |
| [`shape-tally-parse-int-laws.glow`](shape-tally-parse-int-laws.glow) | Tally `parse_int` two refuse laws (Tend T4) | `tools/tally_glow_tend_limb4_witness.rish` |
| [`shape-tally-stack-laws.glow`](shape-tally-stack-laws.glow) | Tally stack three laws (Tend T6) | `tools/tally_glow_tend_limb6_witness.rish` |
| [`shape-aurora-wire-capacity.glow`](shape-aurora-wire-capacity.glow) | Aurora `wire_capacity=512` (Tend A1) | `tools/aurora_glow_tend_limb1_witness.rish` |
| [`shape-aurora-seed-length.glow`](shape-aurora-seed-length.glow) | Aurora `seed_length=32` (Tend A2) | `tools/aurora_glow_tend_limb2_witness.rish` |
| [`shape-aurora-living-stages.glow`](shape-aurora-living-stages.glow) | Aurora six living stages (Tend A3) | `tools/aurora_glow_tend_limb3_witness.rish` |
| [`shape-mantra-line-field-count.glow`](shape-mantra-line-field-count.glow) | Mantra Line three fields (Tend M1) | `tools/mantra_glow_tend_limb1_witness.rish` |
| [`shape-caravan-supervisor-exit-meanings.glow`](shape-caravan-supervisor-exit-meanings.glow) | Caravan three exit meanings (Tend C4) | `tools/caravan_glow_tend_limb4_witness.rish` |

```
rishi/bin/rishi run tools/mantra_glow_tend_limb1_witness.rish
rishi/bin/rishi run tools/mantra_glow_tend_limb2_witness.rish
rishi/bin/rishi run tools/aurora_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/tally_glow_tend_limb6_witness.rish
rishi/bin/rishi run tools/caravan_glow_tend_limb4_witness.rish
```

Further candidates: Mantra M3 (Diff fields=2 · Store dirs=3) · Aurora A4 `signature_length`. M2 (Weave fields=2) seated e204. Reify map: [`../../counsel/20260802-011821_q58-scope-and-tend-src-reify.md`](../../counsel/20260802-011821_q58-scope-and-tend-src-reify.md).
