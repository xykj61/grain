Radiant pass `20260725.112515`

---

# Anvil — README

**Language:** EN  
**Last updated:** 2026-07-10 (`225320` — corpus lap 2 closed nib **386**)  
**Status:** Checkable-room module — corpus catalog + query + Skate views green; LoRA and training remain horizon  
**Style:** Radiant · **Lens:** TAME · SLC · Gall's Law

Anvil names training and fine-tuning on our own corpus. Lap 0 catalogs `.rye` / `.rish` chunks from **our tree** — gratitude and vendor stay in their reading rooms. Query filters by kind and path prefix. Corpus views fold those hits onto Skate.

| Lap | Claim | Witness |
|-----|--------|---------|
| **0 (corpus)** | Chunk catalog · kind counts · unwelcome incomplete chunk | parity **214** |
| **1 (query)** | Kind + path_prefix filter · overflow refused | parity **216** · `tools/anvil_corpus_lap1.rish` |
| **2 (filters)** | min_lines · max_lines · path_suffix · sum_lines | parity **379**–**382** · `tools/anvil_corpus_lap2.rish`–`lap5.rish` |
| **view** | Rye query hits → six-line Skate frame | parity **259** · `tools/inference_anvil_corpus_view.rish` |
| **prefix view** | `path_prefix pond/` → five-line Skate frame | parity **265** · `tools/inference_anvil_corpus_prefix_view.rish` |
| **rish view** | `kind rish` → five-line Skate frame | parity **269** · `tools/inference_anvil_corpus_rish_view.rish` |
| **rye prefix view** | `kind rye` + `path_prefix pond/` → five-line Skate frame | parity **281** · `tools/inference_anvil_corpus_rye_prefix_view.rish` (`190800`) |
| **tools prefix view** | `path_prefix tools/` → five-line Skate frame | parity **293** · `tools/inference_anvil_corpus_tools_prefix_view.rish` (`192749`) |
| **dimeroll prefix view** | `path_prefix dimeroll/` → five-line Skate frame | parity **297** · `tools/inference_anvil_corpus_dimeroll_prefix_view.rish` (`193358`) |
| **apps prefix view** | `path_prefix pond/apps/` → five-line Skate frame | parity **304** · `tools/inference_anvil_corpus_apps_prefix_view.rish` (`200819`) |
| **rye dimeroll prefix** | `kind rye` + `path_prefix dimeroll/` → five-line Skate frame | parity **317** · `tools/inference_anvil_corpus_rye_dimeroll_prefix_view.rish` (`212715`) |
| **rish tools prefix** | `kind rish` + `path_prefix tools/` → five-line Skate frame | parity **320** · `tools/inference_anvil_corpus_rish_tools_prefix_view.rish` (`212715`) |
| **rye apps prefix** | `kind rye` + `path_prefix pond/apps/` → five-line Skate frame | parity **328** · `tools/inference_anvil_corpus_rye_apps_prefix_view.rish` (`213317`) |
| **min_lines view** | `min_lines 600` → five-line Skate frame | parity **383** · `tools/inference_anvil_corpus_min_lines_view.rish` (`225320`) |
| **max_lines view** | `max_lines 300` → five-line Skate frame | parity **384** · `tools/inference_anvil_corpus_max_lines_view.rish` (`225320`) |
| **path_suffix view** | `path_suffix .rish` → five-line Skate frame | parity **385** · `tools/inference_anvil_corpus_path_suffix_view.rish` (`225320`) |
| **sum_lines view** | rye `sum_lines 1004` → five-line Skate frame | parity **386** · `tools/inference_anvil_corpus_sum_lines_view.rish` (`225320`) |

## Layout

| Path | Role |
|------|------|
| [`anvil_core.rye`](anvil_core.rye) | Catalog parse + query |
| [`anvil.rye`](anvil.rye) | Selftest |
| [`fixtures/rye_corpus.bron`](fixtures/rye_corpus.bron) | Pinned chunk list |
| `anvil.peal` | The forge rings once — a one-minute Opus-in-Ogg audio stream under our four-letter `.peal` mark; the first audio bytes in the tree. Gratitude [`../gratitude/OpusOggXiph.md`](../gratitude/OpusOggXiph.md); the Glow audio-Tilak lane it seeds is in [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md). |

```
rishi/bin/rishi run tools/anvil_corpus_lap1.rish
rishi/bin/rishi run tools/anvil_corpus_lap2.rish
rishi/bin/rishi run tools/inference_anvil_corpus_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_prefix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_rish_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_rye_prefix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_tools_prefix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_dimeroll_prefix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_apps_prefix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_min_lines_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_max_lines_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_path_suffix_view.rish
rishi/bin/rishi run tools/inference_anvil_corpus_sum_lines_view.rish
```

*May the forge know its own tree. May LoRA wait until the catalog tells the truth.*
