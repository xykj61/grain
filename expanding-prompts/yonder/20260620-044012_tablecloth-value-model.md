# 10021 · Tablecloth in the One-Value Model

*Rung 3 of the Tablecloth ladder (`10018`). Expanded at `044012`: **remember** — how Tablecloth sits beside Mantra, Brix, and Rye so a value stays one value from keystroke to hash-named artifact. Unifies slices from `10000`, `10011` Track C, and `977`.*

**Language:** EN
**Version:** `20260620.044012` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — no marshaling seams; `977` flow of values; `990` correctness by construction

**Ladder:** `10018` → `10019` → `10020` → **`10021`** → `10022`

---

## The Seed

> Values with enduring names — content-addressing, accretion, Brix/Mantra/Tablecloth (`10011` Track C).

## Remember (one of four flows)

| Operation | Meaning | Tablecloth's slice |
|-----------|---------|-------------------|
| **Transform** | Change a value in place within a garden | — |
| **Move** | Carry a value across a boundary | — |
| **Route** | Send a value toward a named destination | — |
| **Remember** | Persist under an enduring name | **Tablecloth** blobs; Mantra commits; Brix + HEAD chain; Aurora stage hashes |

Tablecloth's job in **remember**: store immutable bytes under a content hash. Mantra's job: weave line history and name commits. Brix's job: declare which bricks exist and which hashes a build expects.

## One Value Model

A value made in **Rye**, carried by **Rishi**, composed by **Brix**, stored in **Tablecloth**, named by **Mantra**, and sent over **Comlink** should be the *same* value — no marshaling seam.

Practical checks:

- A blob in Tablecloth is opaque bytes; interpretation happens in Rye after `get`
- Mantra blob store (`.mantra/blobs/`) is Tablecloth in miniature today
- Nostr-style content ids, sealed datagram payloads, and build artifacts share the instinct: **name by content, never mutate in place**

## Deliverables (this rung)

| Track | Work |
|-------|------|
| **A** | `977_flow_of_values.md` — Tablecloth under **Remember**, aligned with `983` |
| **B** | `10000` — point Tablecloth bullets here; trim duplicate prose |
| **C** | `10011` Track C — one line pointer to `10021` for remember slice |
| **D** | `10007` — unbuilt core list cites `10022` for Tablecloth seed, not vague "designs" |

**Defer:** encrypted networking research execution — `10000` scope stays; Tablecloth role is defined here.

**Next rung:** `10022` — smallest living Tablecloth beyond Mantra's blob dir.

---

*Remembering is naming; Tablecloth is where the name keeps its promise about bytes.*
