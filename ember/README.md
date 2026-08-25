---

# Ember -- README

**Language:** EN  
**Last updated:** 2026-07-28 (`235520` -- Kiln Season o1 path cut; module renamed Ember)  
**Status:** Checkable-room module -- corpus catalog + query + Skate views green; LoRA and training remain horizon  
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)

Ember names training and fine-tuning on our own corpus (the forge path, named **Anvil** and then **Kiln** before it). The catalog folds `.rye` / `.rish` chunks from **our tree** -- gratitude and vendor stay in their reading rooms. Query filters by kind and path prefix. Corpus views fold those hits onto Skate.

| Lap | Claim | Witness |
|-----|--------|---------|
| **0 (corpus)** | Chunk catalog  -  kind counts  -  unwelcome incomplete chunk | `tools/e/ember_corpus_lap1.rish` |
| **1 (query)** | Kind + path_prefix filter  -  overflow refused | `tools/e/ember_corpus_lap1.rish` / lap2 |
| **2 (filters)** | min_lines  -  max_lines  -  path_suffix  -  sum_lines | `tools/e/ember_corpus_lap2.rish`-`lap5.rish` |
| **view** | Rye query hits -> six-line Skate frame | `tools/i/inference_ember_corpus_view.rish` |

## Layout

| Path | Role |
|------|------|
| [`ember_core.rye`](ember_core.rye) | Catalog parse + query |
| [`ember.rye`](ember.rye) | Selftest |
| [`fixtures/rye_corpus.bron`](fixtures/rye_corpus.bron) | Pinned chunk list |
| `ember.peal` | The forge rings once -- Opus-in-Ogg under `.peal`. Gratitude [`../gratitude/OpusOggXiph.md`](../gratitude/OpusOggXiph.md). |

```
rishi/bin/rishi run tools/e/ember_corpus_lap1.rish
rishi/bin/rishi run tools/i/inference_ember_corpus_view.rish
```

*May the ember know its own tree. May LoRA wait until the catalog tells the truth.*
