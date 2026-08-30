# shape — Structures

**Language:** EN  
**Last updated:** `20260829.210056` (Tablecloth's first pedestal seated -- the museum's number is compared to its source rather than copied from it)  
**Status:** Living -- room open; Surface pedestals + Glow Tend structure pedestals + Comlink R1 + Tablecloth
**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../../docs-geode/tutorials/the-first-hour.md`](../../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

The data-structure museum: every non-networked shape on its own pedestal, viewable in isolation, named once and composed elsewhere. House style: [`PLACARD.md`](PLACARD.md). Glow Tend **structures** accrete here; shared gates stay in [`../gate/`](../gate/README.md).

## Pedestals

| Pedestal | Role | Witness |
| --- | --- | --- |
| [`shape-surface-count.glow`](shape-surface-count.glow) | First resident · one-field `@u32` count | `tools/gen/chapter/src_first_resident_witness.rish` |
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
| [`shape-caravan-max-name-len.glow`](shape-caravan-max-name-len.glow) | Caravan `max_name_len=48` (Tend C3) | `tools/ca/caravan_glow_tend_limb3_witness.rish` |
| [`shape-tally-parse-int-laws.glow`](shape-tally-parse-int-laws.glow) | Tally `parse_int` two refuse laws (Tend T4) | `tools/t/tally_glow_tend_limb4_witness.rish` |
| [`shape-tally-stack-laws.glow`](shape-tally-stack-laws.glow) | Tally stack three laws (Tend T6) | `tools/t/tally_glow_tend_limb6_witness.rish` |
| [`shape-aurora-wire-capacity.glow`](shape-aurora-wire-capacity.glow) | Aurora `wire_capacity=512` (Tend A1) | `tools/au/aurora_glow_tend_limb1_witness.rish` |
| [`shape-aurora-seed-length.glow`](shape-aurora-seed-length.glow) | Aurora `seed_length=32` (Tend A2) | `tools/au/aurora_glow_tend_limb2_witness.rish` |
| [`shape-aurora-living-stages.glow`](shape-aurora-living-stages.glow) | Aurora six living stages (Tend A3) | `tools/au/aurora_glow_tend_limb3_witness.rish` |
| [`shape-aurora-signature-length.glow`](shape-aurora-signature-length.glow) | Aurora `signature_length=64` (Tend A4) | `tools/au/aurora_glow_tend_limb4_witness.rish` |
| [`shape-mantra-line-field-count.glow`](shape-mantra-line-field-count.glow) | Mantra Line three fields (Tend M1) | `tools/m/mantra_glow_tend_limb1_witness.rish` |
| [`shape-mantra-weave-field-count.glow`](shape-mantra-weave-field-count.glow) | Mantra Weave two fields (Tend M2) | `tools/m/mantra_glow_tend_limb2_witness.rish` |
| [`shape-mantra-diff-field-count.glow`](shape-mantra-diff-field-count.glow) | Mantra Diff two fields (Tend M3) | `tools/m/mantra_glow_tend_limb3_witness.rish` |
| [`shape-mantra-store-dir-count.glow`](shape-mantra-store-dir-count.glow) | Mantra Store three dirs (Tend M4) | `tools/m/mantra_glow_tend_limb4_witness.rish` |
| [`shape-caravan-supervisor-exit-meanings.glow`](shape-caravan-supervisor-exit-meanings.glow) | Caravan three exit meanings (Tend C4) | `tools/ca/caravan_glow_tend_limb4_witness.rish` |
| [`shape-comlink-ipv6-dual-stack.glow`](shape-comlink-ipv6-dual-stack.glow) | Comlink dual-stack policy=1 (R1 · three walls inline) | `tools/co/comlink_r1_dual_stack_witness.rish` (leg A pure · leg B metal) |
| [`shape-tablecloth-catalog-capacity.glow`](shape-tablecloth-catalog-capacity.glow) | Tablecloth `max_artifacts=32` -- the vane's first Glow desk of any kind | `tools/t/tablecloth_glow_tend_witness.rish` (scan compares, control proves both ways) |

```
rishi/bin/rishi run tools/m/mantra_glow_tend_limb1_witness.rish
rishi/bin/rishi run tools/m/mantra_glow_tend_limb2_witness.rish
rishi/bin/rishi run tools/m/mantra_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/m/mantra_glow_tend_limb4_witness.rish
rishi/bin/rishi run tools/au/aurora_glow_tend_limb3_witness.rish
rishi/bin/rishi run tools/t/tally_glow_tend_limb6_witness.rish
rishi/bin/rishi run tools/ca/caravan_glow_tend_limb4_witness.rish
rishi/bin/rishi run tools/co/comlink_r1_dual_stack_witness.rish
rishi/bin/rishi run tools/t/tablecloth_glow_tend_witness.rish
```

Tend pedestal tier COMPLETE — Aurora A1–A4 · Mantra M1–M4 · Tally/Caravan as seated · Comlink R1. a1 deciding gates + a2 fold lean wait elsewhere. Reify map: [`../../counsel/date/20260802/20260802-011821_q58-scope-and-tend-src-reify.md`](../../counsel/date/20260802/20260802-011821_q58-scope-and-tend-src-reify.md).


---

## The three rooms carried in here, `20260827`

`app/`, `sec/`, and `til/` each held `shape-*.glow` files -- one kind of thing, split by a subject
every filename already carried. Their pedestals moved here and their doors keep their READMEs as
pointers. What each room *taught* is worth keeping, so it is kept:

**Pond agents** (the elder `app/`). Applications are **Pond agents** -- Pond is Glow's Gall-role
host, confirmed `20260714.042545`, and the TUBE ladder packages an app to a signed APK. Agents
written in Glow belong here; today's Rye-authored seeds stay under
[`../../pond/apps/`](../../pond/apps/) beside the enclosure until each is revived into Glow **as a
new artifact beside its elder**, under the reviving-replaces-renaming law. The pedestals name shapes
only -- packaging and APK stay on the TUBE ladder witnesses.

**Security and policy** (the elder `sec/`). The grants, secrets, and policy surface of Glow
userland. Kin: Pond customs, Kumara, the Tilak seams, Mand policy, TUBE1 grants. Mand's own code
stays under `mand/`; the pedestals here only name living counts. **Not this room, and still
refused:** browser stacks, HTML, CSS, JavaScript, JSON-as-home-tongue, and any `web/` userland
folder. `src/web` will not open.

**Tilaks** (the elder `til/`). The tilak is the **type-mark**: the worn sign every value carries at
a seam, seated in [`../../context/LEXICON.md`](../../context/LEXICON.md) and designed at
`foundations/20260703-202312_the-marked-value.md`. Pond customs already admits per Tilak, Weave
content-addresses them, and two roots stand hardcoded -- **plain-bytes** and **manifest**. A short
atom form, `%tile`, is proposed and **held for Keaton's word**; the long word serves everywhere
until then, and no pedestal here seats it. `tilak-root-count.glow` keeps its name: it is a shape by
its own `+$` declaration, and the room it now stands in says so.
