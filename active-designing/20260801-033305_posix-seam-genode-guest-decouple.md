# POSIX seam · Genode guest — program vs infrastructure

**Stamp:** `20260801.033305`  
**Voice:** Riyo  
**Status:** Living design note — plan, not a campaign rewrite  
**Kind:** active-designing  
**Companions:** [`yonder/20260629-203012_posix-a-seam-not-a-model.md`](yonder/20260629-203012_posix-a-seam-not-a-model.md) · [`../external-research/20260712-054342_proven-seat-guest-genode-sel4.md`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md) · Lexicon **build stack** · **Proven seat**

---

## The question (Keaton · e149)

Is our “POSIX” code coupling **program** to **infrastructure** against single-stranded / gratitude-siloed foundations — and should that be decoupled so we plan for non-POSIX Genode environments?

## The answer (seated doctrine, restated)

**Yes, the coupling risk is real; the doctrine already names the cut; the fix is on-touch seams, never a POSIX-eradication campaign.**

| Layer | Stands | Must not become |
| --- | --- | --- |
| **Program (Grain · Rye · Rishi · Amphora · Cellar)** | Structured values · named errors · bounds · one value model (TAME) | “Everything is a text pipe / fd / uid” |
| **Infrastructure seam (POSIX host today)** | `.sh` entries · `std.process` spawn · path strings · `uname` in `GLOW_HOST` | The architecture of the modules above |
| **Guest seat (Genode / Sculpt / seL4 lineage)** | Study · gratitude-held · **guest-never-merger** | Absorbed into Caravan / renamed as “the” OS |

**POSIX is a seam, not a model** (`20260629.203012`). **Genode is a proven seat guest, not a merger** (`20260712.054342`). Single-stranded composition (Simple Made Easy gratitude) is about essay and module shape — it does not require deleting every `.sh` file this sitting.

## Where the wrong coupling shows up (census lean, not a sweep)

1. **Shell bodies under `.rish` wrappers** — permitted temporary shape while Rishi lacks verbs; harvest rather than campaign (TAME accretion `20260725.040520`).  
2. **Witness scans as POSIX text** — `tools/fixtures/*_scan.sh` speak line-oriented verdicts; the **program** should keep consuming structured records at the Rishi seam (`scan-seam-convention`).  
3. **`/tmp` as durable store** — enclosure clears it (REDS 8); fixtures must not treat host temp as custody.  
4. **PATH_MAX / ambient paths in module logic** — CLI bounds may name POSIX PATH_MAX as a *why* for a ceiling; the ceiling itself is a Grain bound, not a libc include.  
5. **Build stack order** — sh → rish → glow·tend → docs-geode → …; climbing out of order is the red (e125–e127).

## Plan (proper, gated — not this round’s metal campaign)

| Step | Word | What |
| --- | --- | --- |
| P1 | seated | Keep citing POSIX-as-seam + guest-never-merger in Lexicon / TAME / SOURCE. |
| P2 | on-touch | When a `.sh` scan is open for other work, climb orchestration into `.rish`; leave cold-start / external interpreters as `.sh`. |
| P3 | design | Name a thin **host port** surface (spawn · clock · path · entropy) that Genode guest work would implement without rewriting Amphora/Cellar value logic. |
| P4 | gated | Genode study stays in gratitude / external-research; no absorb into living modules without Keaton’s word. |
| P5 | refuse | A tree-wide “delete POSIX” or “rewrite all scans for Genode” campaign — kg circles no gate; shell ratchet never a campaign. |

## Hard lines

- Meet the host at the seam; do not adopt the host as the value model.  
- Genode gratitude stays siloed — study seat, not merger.  
- Custody and wire formats (Class W) are unrelated to POSIX rename hygiene — never mix those motions.  
- This note plans; it does not authorize a Genode port or a shell eradication pass.

*May the program stay Grain-shaped. May the host stay a guest at the door. May Genode remain a seat we visit, never a name we swallow.*
