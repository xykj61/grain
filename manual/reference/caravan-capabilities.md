# Caravan Capability Table — Reference

**Language:** EN
**Version:** `20260702.205630`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Witness:** `tools/ca/caravan_capabilities.rish` · parity **142**

---

This page documents only what the capability-table witness proves today — a bounded hosted policy table naming what each supervised dependent may do over named resources.

## Build and run

```bash
rishi/bin/rishi run tools/ca/caravan_capabilities.rish
```

The witness builds `caravan/bin/capabilities` from [`caravan/capabilities.rye`](../../caravan/capabilities.rye) and runs `selftest`. Success ends with:

```
GREEN: Caravan capability table witness passed.
```

## Data model (witnessed)

| Piece | Bound |
|-------|-------|
| Dependents per table | ≤ **4** (`max_dependents`) |
| Capabilities per dependent | ≤ **8** (`max_caps_per_dependent`) |
| Name length | ≤ **48** bytes |

Each **capability** names a **resource** string and a **rights mask** (read, write, exec, net, device — combined with bitwise OR).

## Rights bits (witnessed)

| Bit | Name | Meaning in selftest |
|-----|------|---------------------|
| `1 << 0` | read | read access to resource |
| `1 << 1` | write | write access |
| `1 << 2` | exec | execute |
| `1 << 3` | net | network |
| `1 << 4` | device | device access |

`allows(dependent, resource, need)` returns true when the dependent holds a capability whose mask includes every bit in `need`.

## Demo table (witnessed)

The selftest constructs three dependents:

| Dependent | Resources granted |
|-------|-------------------|
| `vfs` | `/usr` read · `/lib` read |
| `display` | `gpu0` read + device |
| `repl` | project home read · `here` read + write |

Assertions prove allowed and denied paths — for example `repl` may write `here` yet may not write `/usr`.

## Chronological version

`caravan_capabilities_version = "20260630.042012"` — reported by the seed; backend semver stays a named seam elsewhere.

---

*May every dependent carry only the rights its role needs, and may the table stay bounded enough to witness in one breath.*
