# Arbor -- spoken tiles with their labels kept outside

**Language:** EN
**Style:** New Gauge, Door setting
**Status:** Living foundation -- local authoring and validation only
**Where this sits:** home is [`../README.md`](../README.md) -- the elder launcher this room adapts is [`../tools/l/launch-claude-chapter.rish`](../tools/l/launch-claude-chapter.rish)

Arbor is Grain's plain-prose surface for a voice reader. The central example is
[`launch-chatgpt-chapter.arbor`](launch-chatgpt-chapter.arbor), a fully spoken adaptation of the
outer and inner recursion ideas in `tools/l/launch-claude-chapter.rish`. The elder launcher remains
unchanged. Arbor configures no service, chooses no model, and makes no network request.

The central example remains the canonical practical reading. Its companion,
[`launch-chatgpt-chapter-dark-euphoria-light-terra.arbor`](launch-chatgpt-chapter-dark-euphoria-light-terra.arbor),
speaks the same mechanism in Gauge's newer paired register. The name follows the two palettes in
`kyri/receipt.rye`: light terra gives the lap its grounded motion, while dark euphoria gives that
motion a calm inner feel. The five row pages seated on the same day confirm that both registers are
legitimate. This is the current meaning of the companion sometimes called Radiant Twilight; it is
more specific than a mechanical blend of the older Radiant and Twilight guides.

## The readable form

An `.arbor` file contains only words meant to reach the listener. One paragraph tile occupies one
physical line, and a blank line gives the voice a clear breath between tiles. The file carries no
title block, front matter, labels, paths, commands, stage directions, markup, or speech tags.

The extension is a proposed Tilak, or type-mark, for spoken prose. It does not seat the held short
atom `%tile`. Here, a **tile** simply means one ordered spoken paragraph.

## The authoring form

The neighboring [`launch-chatgpt-chapter.brix`](launch-chatgpt-chapter.brix) holds the facts that a
reader should never hear. Its `output` field names the readable file, its `catalog` field names the
Ember-compatible sidecar, and each repeated `tile` field holds one paragraph in reading order.
Running the local author copies those tile values into the `.arbor` file with one blank line between
them.

```sh
sh arbor/author.sh check arbor/launch-chatgpt-chapter.arbor
sh arbor/author.sh verify arbor/launch-chatgpt-chapter.brix
sh arbor/author.sh build arbor/launch-chatgpt-chapter.brix
sh arbor/author.sh render arbor/launch-chatgpt-chapter.brix
```

Use the companion's matching Brix path in the same commands to check, verify, build, or render its
reading. The practical and companion forms each have their own descriptor and corpus sidecar, so
their spoken files remain free of labels and style declarations.

`check` and `verify` are read-only. `build` replaces only the two paths declared by the descriptor.
`render` prints the spoken result. Every command is repository-local and invokes no model or voice
service.

## Four proven seams

Scribble supplies the reading shape. Its parser already keeps paragraphs in source order, and Arbor
uses the same `max_doc_bytes` bound from `scribble/scribble_core.rye`.

Lattice supplies the small shape. Its `max_dim` is eight, so an Arbor document holds at most eight
paragraph tiles: one bounded row of spoken values.

Lantern supplies the request edge. Each tile stays within `max_prompt_len` from
`lantern/lantern_core.rye`. Arbor borrows the bound only; it creates no request and sets no model
option.

Ember supplies the corpus seam. Its catalog already accepts `kind other` and filters by
`path_suffix`, so [`launch-chatgpt-chapter.corpus.bron`](launch-chatgpt-chapter.corpus.bron) can name
the finished `.arbor` value without changing Ember or claiming a new trained kind.

## What the chapter adaptation keeps

The outer loop is a spoken boundary: continue one complete lap at a time until a deadline or a
custody gate returns the choice to the user. The inner loop restores repository memory, chooses the
oldest durable crux an agent can advance, clears urgent repairs first, verifies the work from both
sides, records the result, and gives a concise handback before another lap begins.

The adaptation leaves service launch, authentication, model selection, audio generation, automatic
continuation, remote synchronization, and a first-class Ember `arbor` kind for later decisions.
Those choices need a real local adapter or a user's explicit setting; this foundation stays a
readable, checkable value in the tree.

Both readings keep those same boundaries and the same eight-step order. The companion changes only
the register: earth and sky, light and dark, sound and silence, vision and night, and harvest and
fallow hold the instructions together while every operation and stop remains exactly the same.
