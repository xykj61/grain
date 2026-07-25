# Scribble — Markdown as Values

**Language:** EN
**Last updated:** 2026-07-10 (h1+blocks view `224805`; parity **372** — Inference lap 1 close)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room module — laps 0–7 green (parse · rye/rish/plain snippets · headings · depth filter · paragraphs · fence kinds); rye/rish/plain/fence/paragraph/outline/h1/h2/h3/depth-tally/tally/blocks/fence+heading/tally+blocks/para+blocks/h1+blocks views on Skate

---

Scribble turns human prose into block values — headings, paragraphs, and fenced code with `rye_fence` / `rish_fence` / plain kinds for corpus work. Heading extract feeds the outline Skate view; depth filter selects h1, h2, or h3 folds; paragraph extract gathers prose bodies in source order; fence-kinds count folds rye/rish/plain tallies; plain-snippet extract gathers unmarked fence bodies.

| Lap | Claim | Witness |
|-----|--------|---------|
| **0** | Headings · paragraphs · rye/rish fences · unwelcome unclosed fence | parity **212** |
| **1** | `extract_rye_snippets` from session fixture · overflow refused | parity **218** |
| **2** | `extract_rish_snippets` from session fixture · overflow refused | parity **253** · `tools/scribble_lap3.rish` |
| **3** | `extract_headings` · outline Skate view | parity **261**/**262** · `tools/scribble_lap4.rish` · `tools/inference_scribble_view.rish` |
| **4** | `extract_paragraphs` · overflow refused | parity **270** · `tools/scribble_lap5.rish` |
| **paragraphs view** | Prose bodies → five-line Skate frame | parity **273** · `tools/inference_scribble_para_view.rish` |
| **5** | `count_fence_kinds` · rye/rish/plain tallies | `tools/scribble_lap6.rish` |
| **fence kinds view** | rye/rish/plain counts → five-line Skate frame | parity **278** · `tools/inference_scribble_fence_view.rish` |
| **6** | `extract_plain_snippets` · overflow refused | parity **282** · `tools/scribble_lap7.rish` |
| **plain snippets view** | Unmarked fences → five-line Skate frame | parity **286** · `tools/inference_scribble_plain_view.rish` (`191112`) |
| **rye snippets view** | Rye fences → five-line Skate frame | parity **296** · `tools/inference_scribble_rye_view.rish` (`193358`) |
| **rish snippets view** | Rish fences → five-line Skate frame | parity **300** · `tools/inference_scribble_rish_view.rish` (`200203`) |
| **7** | `extract_headings_at_depth` · h1 Skate view | parity **308** · `tools/scribble_lap8.rish` · `tools/inference_scribble_h1_view.rish` (`211930`) |
| **h2 view** | Depth-2 headings → five-line Skate frame | parity **312** · `tools/inference_scribble_h2_view.rish` (`211930`) |
| **h3 view** | Depth-3 headings → five-line Skate frame | parity **316** · `tools/inference_scribble_h3_view.rish` (`212715`) |
| **depth tally view** | h1/h2/h3 counts → five-line Skate frame | parity **324** · `tools/inference_scribble_depth_view.rish` (`213317`) |
| **tally view** | Headings + paragraphs counts → five-line Skate frame | parity **332** · `tools/inference_scribble_tally_view.rish` (`213738`) |
| **blocks view** | Six outline blocks → Skate frame | parity **340** · `tools/inference_scribble_blocks_view.rish` (`214145`) |
| **fence+heading view** | Fence kinds + heading count → Skate frame | parity **348** · `tools/inference_scribble_fence_heading_view.rish` (`215613`) |
| **tally+blocks view** | Headings/paragraphs tally + block count → Skate frame | parity **356** · `tools/inference_scribble_tally_blocks_view.rish` (`223639`) |
| **para+blocks view** | Paragraphs + block count → Skate frame | parity **364** · `tools/inference_scribble_para_blocks_view.rish` (`224322`) |
| **h1+blocks view** | Depth-1 headings + block count → Skate frame | parity **372** · `tools/inference_scribble_h1_blocks_view.rish` (`224805`) |

## Layout

| Path | Role |
|------|------|
| [`scribble_core.rye`](scribble_core.rye) | Parse walk, snippet + heading + depth + paragraph extract, fence-kinds count |
| [`scribble.rye`](scribble.rye) | Selftest binary |
| [`fixtures/sample.md`](fixtures/sample.md) | Pinned sample |
| [`fixtures/session_snippets.md`](fixtures/session_snippets.md) | Rye training fences |
| [`fixtures/session_rish_snippets.md`](fixtures/session_rish_snippets.md) | Rish training fences |
| [`fixtures/outline.md`](fixtures/outline.md) | Heading + paragraph outline |
| [`fixtures/outline_h3.md`](fixtures/outline_h3.md) | Depth-three outline for h3 view |
| [`fixtures/fence_kinds.md`](fixtures/fence_kinds.md) | One rye · one rish · one plain fence |
| `pond/apps/scribble/scribble_core.rye` | Symlink for drawn-terminal import |

```bash
rishi/bin/rishi run tools/scribble_lap8.rish
rishi/bin/rishi run tools/inference_scribble_h1_view.rish
rishi/bin/rishi run tools/inference_scribble_h2_view.rish
rishi/bin/rishi run tools/inference_scribble_h3_view.rish
rishi/bin/rishi run tools/inference_scribble_depth_view.rish
rishi/bin/rishi run tools/inference_scribble_tally_view.rish
```

*May what we write become values the stack can diff and render.*
