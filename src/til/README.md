# til — Tilaks

**Language:** EN  
**Last updated:** 2026-07-28 (Surface p18 — second pedestal)  
**Status:** Living — room open; first resident + second pedestal seated · `%tile` still held

The tilak is the type-mark: the worn sign every value wears at a seam (seated in [`../../context/LEXICON.md`](../../context/LEXICON.md); design at `foundations/20260703-202312_the-marked-value.md`). Pond customs already admits **per Tilak**; Weave content-addresses them; two roots stand hardcoded (**plain-bytes** · **manifest**). This room gathers tilak definitions written in Glow, one file per mark.

A short atom form (`%tile`) is proposed and **held for Keaton's word**; until then the long word serves everywhere. Pedestals here do not seat `%tile` — they name living counts from the marked-value brief.

## Pedestals

| Pedestal | Role | Witness |
| --- | --- | --- |
| [`tilak-root-count.glow`](tilak-root-count.glow) | First resident · two engine roots | `tools/gen/season/src_first_resident_witness.rish` |
| [`shape-manifest-field-count.glow`](shape-manifest-field-count.glow) | Three-field manifest line | same |

```
rishi/bin/rishi run tools/glow_run.rish src/til/tilak-root-count.glow
rishi/bin/rishi run tools/glow_run.rish src/til/shape-manifest-field-count.glow
rishi/bin/rishi run tools/gen/season/src_first_resident_witness.rish
```
