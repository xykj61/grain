# Generator Season s1 — Living pin `prin_scope` → Rishi

**Stamp:** `20260728.184313` · **Voice:** Quin · **Season:** Generator · **Scope:** sext · **Round:** s1  
**Prior:** [s0 planning](20260728-183510_generator-season-s0-planning-glow-rishi-dojo.md) · charter [sext](20260728-183510_the-generator-season-sext-charter.md)  
**Ask:** waymark s0 complete / s1 next · kg prin_scope migrate

## Verdict

**s1 LANDED.** Living season slate now homes in `tools/prin_scope.rish`. Bash call sites stay green via shim + dispatch. `prin scope` asserts GREEN · sext · nib.

## What moved

| Path | Role |
| --- | --- |
| `tools/prin_scope.rish` | **Living pin** — edit waymark / seat / charter here |
| `tools/fixtures/prin_scope.sh` | Accrete shim → `rishi run tools/prin_scope.rish` |
| `tools/fixtures/prin_dispatch.sh` | `scope\|outer\|inner` execs the rish door |
| `tools/prin.rish` | Documents scope door · light asserts on scope modes |

## Choir

| Path | Result |
| --- | --- |
| `rishi run tools/prin_scope.rish` | **GREEN** |
| `rishi run tools/prin.rish scope` | **GREEN** · asserts hold |
| `bash tools/fixtures/prin_scope.sh` | **GREEN** (shim) |
| `bash tools/fixtures/prin_dispatch.sh scope` | **GREEN** |
| `prin.rish help` · `once` | **GREEN** (non-scope unbroken) |

## What this round does *not* do

No matrix/ticker rewrite · no O3 · no shred · no MUR unpause · no Glow↔Rishi kernel fuse.

## Next

**LANDED s2** — generators dual-census · Glow 317 / Rishi 610 · no move.

---

*s1 prin_scope → rish · stamp `20260728.184313` · Quin · GREEN*
