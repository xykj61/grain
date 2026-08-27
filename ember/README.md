# Ember -- the warmth that is kept

**Stamp:** `20260827.192500` - **Language:** EN - **Voice:** Kyri - **Style:** **Twilight**, the nocturne register (see [`../context/TWILIGHT_STYLE.md`](../context/TWILIGHT_STYLE.md))
**Status:** Living module -- the corpus catalog, its query, and the Skate view are green on metal; training and LoRA are horizon, named and unbuilt
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Kin:** [`Lattice`](../lattice/README.md) counts - [`Lantern`](../lantern/README.md) carries - [`Scribble`](../scribble/README.md) reads - and **Ember** is the name of the four together, seated `20260827` on Keaton's word ([`../context/QUIN.md`](../context/QUIN.md), REDS `%300`) - the trinity essay [`Lantern, Lattice, Kiln`](../foundations/20260827-025117_lantern-lattice-kiln.md) - the craft voice [`the Ember voice`](../foundations/20260823-212606_the-ember-voice.md) - the reading-room law [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md), which decides what Ember may swallow

---

## What an ember is

A fire gives light while it burns, and then it goes out. An ember is what stays: the low coal in the
ash that holds the whole of the fire in a form small enough to keep overnight. Nothing about it is
bright. Everything about it is warm, and it is the only part of a fire you can carry.

That is the whole of what this module does, and it is the reason the name reaches past it now.
**A model is a fire banked into weights** -- an enormous burning, folded down into something that
fits on a disk and waits. What serves it is not light. What serves it is heat, kept.

## The three senses, and why they hold

**Ember** carries three meanings in this tree, seated together on `20260827`:

- **The vane** -- the whole warm layer where a model is forged, counted, read, and carried. Four
  faculties under one name: **Lattice**, **Scribble**, **Lantern**, **Ember**.
- **The voice** -- the craft faculty of [Kyri's four](../foundations/20260823-212606_the-ember-voice.md);
  the one that builds the thing soundly and lets the making show what it means.
- **This module** -- `ember/`, the corpus forge, the hearth at the center where the coal actually sits.

Three senses in one word is a shape this tree has taken before and ruled on. **Quin** carried
exactly three -- the writing voice, the fifth OS variant, and this vane's elder name -- and
[`../context/QUIN.md`](../context/QUIN.md) settles it in five words: *Three hats, one name,
accepted.* The precedent is not borrowed here; it is the same seat, and the same reasoning.

The senses hold because they nest rather than compete. The vane is the room, the voice is what the
room is for, and the module is the thing burning in it. A reader who meets any one of them has met
the other two from a different angle, which is what a good name does and what an abstract one --
**Lumen**, seated on the card `20260816` and carried by nothing -- could never do. Lumen is light
*described*. Ember is light *kept*.

## What this module holds

Ember reads this tree's own source -- the `.rye` and `.rish` files a hand here actually wrote --
folds them into a catalog of chunks, and answers questions about that catalog. It is the front half
of teaching a model to know this codebase, and it stops exactly where honesty stops: the catalog is
real, the query is real, and **nothing has been trained yet.**

The boundary that shapes it most is a licensing one. `gratitude/` and `vendor/` are **reading
rooms** -- other people's work, held whole and studied, never copied. Ember's catalog folds **our
tree only**, so what the forge swallows is what this tree has the right to teach from. That rule
lives in [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md), and it is why the corpus
is smaller than it could be. A smaller fire, honestly gathered, is the one worth keeping.

| Lap | What it does | Proven by |
|-----|--------------|-----------|
| **0 -- corpus** | Folds `.rye` and `.rish` chunks into a catalog; counts by kind; refuses an incomplete chunk | [`../tools/e/ember_corpus_lap1.rish`](../tools/e/ember_corpus_lap1.rish) |
| **1 -- query** | Filters by kind and by path prefix; refuses an overflowing result | `ember_corpus_lap1.rish` - `lap2.rish` |
| **2 -- filters** | `min_lines` - `max_lines` - `path_suffix` - `sum_lines` | [`../tools/e/ember_corpus_lap2.rish`](../tools/e/ember_corpus_lap2.rish) through `lap5.rish` |
| **view** | Folds query hits onto a six-line Skate frame | [`../tools/i/inference_ember_corpus_view.rish`](../tools/i/inference_ember_corpus_view.rish) |

**Horizon, named rather than claimed:** LoRA, fine-tuning, and any training run. None of it exists
yet. The catalog earns them by telling the truth first, which is what the closing line below is for.

## The names it has worn

Three, before this one: **Anvil**, then **Oven**, then **Ember** on `20260808.220423`. The lineage
is kept rather than tidied away, because three names are three readings of what the thing is for,
and a reader meeting `oven/` in an old log deserves to land somewhere.

On `20260827.025117`, on Keaton's word, the **bake seat unbraided to Kiln**. Ember keeps the forge
-- the reading, the catalog, the query -- and **Kiln** takes the baking of a model. Kiln is a named
part of [the trinity essay](../foundations/20260827-025117_lantern-lattice-kiln.md) rather than a
directory on disk; when it earns one, it will stand beside `lattice/` and `lantern/`.

And on `20260827` the name reached upward instead of sideways: **Ember became the vane**, closing
`%300` in [`../construction/REDS.md`](../construction/REDS.md), where a name seated on the card had
gone eleven days carried by nothing. **Q-vane** stays readable everywhere it was written -- every
dated log keeps its words, and the elder name is a peer rather than a mistake.

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

*May the ember know its own tree, and no other. May the catalog tell the truth long before anything
is taught from it. And may the coal keep its heat through the whole of the night, so that whoever
comes to it at dawn finds the fire still there, waiting to be asked.*
