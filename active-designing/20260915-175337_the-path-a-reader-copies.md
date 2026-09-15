# The path a reader copies

**Stamp:** `20260915.175337`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **checkable room**: the reading is built, rostered, and green from both sides
**Ship:** Petrichor -- **Rota:** fire sees (row 2, N=4917)
**Kin:** [`20260911-000651_the-front-door-that-named-no-ceiling.md`](20260911-000651_the-front-door-that-named-no-ceiling.md) -- [`../tools/l/link_text_promise_witness.rish`](../tools/l/link_text_promise_witness.rish) -- [`../tools/l/law_tool_citation_witness.rish`](../tools/l/law_tool_citation_witness.rish)

This tree writes almost every cross-reference the same way: a backticked relative path as the
visible text, and the same path again as the link target. One line, and **two promises**, because
two readers use it in two ways. One clicks, and arrives. One copies what they see -- into a
terminal, into a grep, into a sibling page -- and arrives wherever the visible half points.

Where the halves disagree, the first reader is served and the second is sent nowhere. Every
standing guard reports the line as sound, and each of them is right to.

## Measured before it was argued

`tools/fixtures/l/link_text_promise_scan.sh`, read `20260915.175337` over the tracked tree:

| Reading | Count |
|---|---|
| living pages read | 6,347 |
| backticked links read | 15,907 |
| broken promises in `docs-geode/` | **3**, now zero |
| broken promises in other living pages | **223**, across 68 pages |
| broken promises in dated testimony | 104 |

The largest single living site holds 24, and every one of its texts names a pre-fold path while its
target names the folded one. The class grows whenever a room folds and grows nowhere else, which is
why it is worth a wall rather than a sweep: a sweep finishes and the next fold refills it.

## Three near neighbours, each passing it for a good reason

`tools/t/tracked_link_witness.rish` resolves link **targets**, and every target in this class
resolves -- which is precisely what keeps the class invisible. A page can hold a hundred of these
and read perfectly.

`tools/l/law_tool_citation_witness.rish` reads backticked paths and gates them, bounded to
`.claude/rules/` by its own header, for a reason that header states plainly: inside that one room a
printed path is unambiguously a promise about a file that exists.

`tools/d/docs_command_path_witness.rish` reads a path a page tells a reader to **run**, and passes
an absent one free on purpose. Tree-wide, a printed path the tree lacks is often one the reader is
being asked to create.

## Why the elder proposal could not become a gate, and this one can

The kin page above proposed a guard for `docs-geode/`: resolve each backticked relative path
against its page's own directory, hold untracked at zero. Run that reading against
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) and it
refuses `./bootstrap.sh` -- a line the page is entirely right to print. Two lines above it the page
says `cd rye`, and `rye/bootstrap.sh` is a file this tree carries. The path is relative to the
reader's working directory, and the page said so.

**A bare backticked path states nothing about what it is relative to.** So a reading that resolves
one must guess, and a guard that guesses is a guard that refuses honest work.

**A link does state it.** Markdown resolves a relative target against the document, by the format's
own rule, so a link's text half and its target half are both page-relative by construction. Their disagreement is
legible with no guess about intent at all, and that is the whole difference between a proposal and
a wall.

## What the wall holds, and what it declines

**Gated at zero: `docs-geode/`.** The shipping shelf -- the pages a newcomer meets in their first
hour, where a copied path that reaches nothing costs the most. Three stood there; all three are
repaired in the commit that lands this guard, so the wall refuses only what arrives after it.

**Ratcheted under a ceiling that only falls: every other living page.** The remaining 223 stand
across 68 pages in rooms this lane does not own. A gate at zero would red on other ships' work, and
a gate that reds on somebody else's work is a gate somebody turns off. A lane sweeping its own page
lowers `CEILING` in the same commit.

**Read past, each for its own reason.** A page whose own basename carries a one-clock stamp is
testimony and keeps every word it wrote, so its 104 are counted apart and gate nothing. A text that
**resolves** is welcomed even where it differs from its target -- a text naming a room beside a
target opening that room's door is one line doing two honest jobs. A broken target belongs to
`tracked_link`, which already owns it. A URL target answers a different question.

## Proven from both sides

`tools/fixtures/l/link_text_promise_control.sh` builds real git repositories in a throwaway pen and
proves **38 behaviors**, every refusal planted and then lifted so a reading returns to zero rather
than merely passing. Two mutations are asserted to bite, each deleting one clause of the reading:
dropping *the text resolves* makes two honest files read as a broken promise, and dropping *the
target resolves* pulls in the neighbour's whole class. The leg count is pinned in the witness,
because `control_failures=0` reads alike whether a leg passed or was deleted.

## What this does not settle

**Why the disagreements arose.** `tools/d/dated_path_repoint.rish` rewrites every occurrence of a
matching path on a line, anchor text included, so the fold repointer is not the cause it first
looks like -- and its regex requires a dated basename, which most of these texts lack. The 223 have
more than one origin, and naming them is a separate reading.

**Whether the other 68 pages should be swept.** They belong to other lanes, and each is one edit.
The ceiling makes the sweep optional and the regrowth impossible.

**Whether a path is the right visible text at all.** A sentence naming the room often serves a
reader better than a path they must count `../` steps through. That is a style question, and this
guard is neutral on it: it asks only that a path shown is a path the tree carries.

*May what a reader copies land where a reader clicks, and may every promise this tree shows be one
it can keep.*
