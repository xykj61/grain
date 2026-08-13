---

# Kiln — README

**Language:** EN  
**Last updated:** 2026-07-28 (`235520` — Kiln Season o1 path cut)  
**Status:** Checkable-room module — corpus catalog + query + Skate views green; LoRA and training remain horizon  
**Style:** Radiant · **Lens:** TAME · SLC · Gall's Law

Kiln names training and fine-tuning on our own corpus (was **Anvil** forge path). The catalog folds `.rye` / `.rish` chunks from **our tree** — gratitude and vendor stay in their reading rooms. Query filters by kind and path prefix. Corpus views fold those hits onto Skate.

| Lap | Claim | Witness |
|-----|--------|---------|
| **0 (corpus)** | Chunk catalog · kind counts · unwelcome incomplete chunk | `tools/oven_corpus_lap1.rish` |
| **1 (query)** | Kind + path_prefix filter · overflow refused | `tools/oven_corpus_lap1.rish` / lap2 |
| **2 (filters)** | min_lines · max_lines · path_suffix · sum_lines | `tools/oven_corpus_lap2.rish`–`lap5.rish` |
| **view** | Rye query hits → six-line Skate frame | `tools/inference_oven_corpus_view.rish` |

## Layout

| Path | Role |
|------|------|
| [`oven_core.rye`](oven_core.rye) | Catalog parse + query |
| [`kiln.rye`](kiln.rye) | Selftest |
| [`fixtures/rye_corpus.bron`](fixtures/rye_corpus.bron) | Pinned chunk list |
| `kiln.peal` | The forge rings once — Opus-in-Ogg under `.peal`. Gratitude [`../gratitude/OpusOggXiph.md`](../gratitude/OpusOggXiph.md). |

```
rishi/bin/rishi run tools/oven_corpus_lap1.rish
rishi/bin/rishi run tools/inference_oven_corpus_view.rish
```

*May the kiln know its own tree. May LoRA wait until the catalog tells the truth.*
