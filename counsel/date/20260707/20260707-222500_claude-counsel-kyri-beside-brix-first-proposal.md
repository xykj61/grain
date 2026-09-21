# Claude Counsel — Kyri Beside Brix, a First Proposal

**Stamp:** `20260707.222500 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** single-stranded modules · grain strand "values apart"
**Register:** A first concrete answer to an Open Question — proposes; does not seat Kyri as a built module
**Ground:** [`../active-designing/yonder/20260621-063912_kyri-notation.md`](../active-designing/yonder/20260621-063912_kyri-notation.md) · [`../active-designing/20260702-185912_brix-the-composer.md`](../active-designing/20260702-185912_brix-the-composer.md) · [`../active-designing/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · counsel [`220912`](../counsel/20260707-220912_claude-counsel-roadmap-synthesis.md)

*Written by Rio 3 for Kaeden.*
Radiant pass `20260725.103949`

---

## The Question

TASKS asks: **Brix describes what a system is made of; the `.kyri` notation brief exists — what does Kyri describe alongside it?**

## The First Proposal — One Sentence

**Kyri describes immutable values at seams; Brix describes composable wholes that bind those values into systems.**

Kyri is the **letter**. Brix is the **blueprint written in letters**.

---

## Division of Labor

| Module | Describes | Extension | Analogy |
|--------|-----------|-----------|---------|
| **Kyri** | A **value** — facts, policies, receipts, manifests, tool man pages, Comlink headers | `.kyri` | JSON, TOML — data at rest and in transit |
| **Brix** | A **system** — courses of bricks, bonds, service declarations, overrides | `.brix` | Nix expressions — composition and override |

**Brix uses Kyri as surface syntax** the way Nix expressions produce attribute sets. Kyri also stands alone wherever a value crosses a seam without composing a whole.

---

## What Kyri Carries (Concrete)

Already seated in practice on the bench:

| Artifact | Role |
|----------|------|
| `tools/fixtures/slcl1_fact.kyri` | Transaction fact |
| `tools/fixtures/open_asks_request.kyri` | Open-asks request fact |
| Receipt / settlement receipt shapes | Fold output values |
| Pond enclosure policy (horizon) | Policy-as-value |
| Amber manifest entries (Tilak lines) | Catalog records |
| Tool `.kyri` man records (horizon) | Self-describing utilities |

Kyri answers: **what are the fields, and what are their canonical bytes?**

---

## What Brix Carries (Concrete)

Not yet built past descriptor seeds — and that is correct:

| Artifact | Role |
|----------|------|
| `.brix` descriptor | Declares bricks, bonds, services |
| Bond overrides | Infuse changes into a declared whole |
| Course evaluation | Closure of content-addressed bricks |

Brix answers: **what is this system made of, and how do parts lawfully combine?**

---

## What Kyri Does Not Do

- Declare **supervision graphs** (Caravan)
- **Content-address** or store bricks (Tablecloth)
- **Weave** history (Mantra)
- **Seal** transit (Comlink)
- **Evaluate** bonds into running children (Brix's job, not Kyri's)

Keeping Kyri from growing into a second composition language is the discipline.

---

## Graduation Rule for Kyri

Kyri does **not** need a `kyri/` module tree for v1. The notation is already used across fixtures and facts. A dedicated module earns its home when:

1. A **parser/validator** beyond Rishi one-liners ships (Tilak shape-cast at scale), **and**
2. A **second external consumer** outside Mantra/Linengrow fixtures depends on that parser.

Until then, Kyri remains a **notation spec** (`yonder/20260621-063912`) plus witness-proven `.kyri` fixtures — same pattern as Dexter staying an aspect until a second consumer.

---

## Open Ruling for Kaeden

| Question | Proposal |
|----------|----------|
| Is this division enough to close the Open Question? | **Yes**, pending Kaeden's word |
| Does Kyri absorb Silo config? | **No** — Silo infuse pattern becomes **Brix bond overrides**; Kyri carries only the override *values*, not the composition language |
| Rename `.kyri` / seat `kyri/` now? | **No** — premature; notation + fixtures suffice |

---

*May the letter stay small enough to sign. May the blueprint stay honest about what it composes. And may the seam between value and whole stay visible in every file extension we choose.*
