# Ember -- the forge that reads our own tree

**Stamp:** `20260827.185500` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living module -- the corpus catalog, its query, and the Skate view are green on metal; training and LoRA are horizon, named and unbuilt
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Kin:** [`Lattice`](../lattice/README.md) counts, [`Lantern`](../lantern/README.md) serves, [`Scribble`](../scribble/README.md) reads -- the four faculties of the **Q-vane** ([`../context/QUIN.md`](../context/QUIN.md)) (the card seated **Lumen** as this vane's name on `20260816` and 80 living pages still say Q-vane -- **REDS %300**, open and gated) - the trinity essay [`Lantern, Lattice, Kiln`](../foundations/20260827-025117_lantern-lattice-kiln.md) - the reading-room law [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md), which decides what Ember may swallow

---

## What this is

**Ember is the forge.** It reads this tree's own source -- the `.rye` and `.rish` files a hand
here actually wrote -- folds them into a catalog of chunks, and answers questions about that
catalog. It is the front half of teaching a model to know this codebase, and it stops precisely
where honesty stops: the catalog is real, the query is real, and **nothing has been trained yet.**

The one boundary that matters most is a licensing one, and Ember was built around it.
`gratitude/` and `vendor/` are **reading rooms** -- other people's work, held whole and studied,
never copied. Ember's catalog folds **our tree only**, so what the forge swallows is what this
tree has the right to teach from. That rule lives in
[`gratitude-licenses`](../.claude/rules/gratitude-licenses.md) and is the reason the corpus is
smaller than it could be.

## What stands, and what is proven

| Lap | What it does | Proven by |
|-----|--------------|-----------|
| **0 -- corpus** | Folds `.rye` and `.rish` chunks into a catalog; counts by kind; refuses an incomplete chunk | [`../tools/e/ember_corpus_lap1.rish`](../tools/e/ember_corpus_lap1.rish) |
| **1 -- query** | Filters by kind and by path prefix; refuses an overflowing result | `ember_corpus_lap1.rish` - `lap2.rish` |
| **2 -- filters** | `min_lines` - `max_lines` - `path_suffix` - `sum_lines` | [`../tools/e/ember_corpus_lap2.rish`](../tools/e/ember_corpus_lap2.rish) through `lap5.rish` |
| **view** | Folds query hits onto a six-line Skate frame | [`../tools/i/inference_ember_corpus_view.rish`](../tools/i/inference_ember_corpus_view.rish) |

**Horizon, named rather than claimed:** LoRA, fine-tuning, and any training run. None of it exists.
The catalog earns those before they are worth building, which is why the closing wish below says
what it says.

## The name, and the seat it gave away

Ember is the third name this module has worn: **Anvil**, then **Oven**, then **Ember** on
`20260808.220423`. The lineage is kept rather than tidied away, because three renames are three
readings of what the thing is for, and a reader meeting `oven/` in an old log deserves to land
somewhere.

On `20260827.025117`, on Keaton's word, the **bake seat unbraided to Kiln**. Ember keeps the forge
-- the reading, the catalog, the query -- and **Kiln** takes the baking of a model. Kiln is a named
part of [the trinity essay](../foundations/20260827-025117_lantern-lattice-kiln.md) rather than a
directory on disk; when it earns one, it will stand beside `lattice/` and `lantern/`.

## Layout

| Path | Role |
|------|------|
| [`ember_core.rye`](ember_core.rye) | Catalog parse and query |
| [`ember.rye`](ember.rye) | Selftest binary |
| [`fixtures/rye_corpus.bron`](fixtures/rye_corpus.bron) | The pinned chunk list |
| `ember.peal` | The forge rings once -- Opus-in-Ogg under `.peal`. Gratitude: [`OpusOggXiph`](../gratitude/OpusOggXiph.md) |

```
rishi/bin/rishi run tools/e/ember_corpus_lap1.rish
rishi/bin/rishi run tools/i/inference_ember_corpus_view.rish
```

---

*May the ember know its own tree, and no other. May the catalog tell the truth before anything is
taught from it.*
