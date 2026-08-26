# The Languages an Open Model Owes

**Stamp:** `20260826.001748`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; the language row of Ember's materials honesty, with the tokenizer seam and its witness; proposals only
**Kin:** [`../foundations/20260728-232511_lantern-lattice-kiln.md`](../foundations/20260728-232511_lantern-lattice-kiln.md)

The open model layer's foundation makes a promise: the kiln is honest about its
materials -- the data it learns from, the energy it spends, the bounds it keeps. One
material has yet to be named in that inventory, and an early-2026 outreach draft carried
the case for it before the campaign around it went quiet. The material is language, and
the debt is measurable.

## The debt, stated as numbers

A model trained overwhelmingly in one language serves that language's speakers and
shrugs at everyone else. The classic public figure: the 2020 training corpus behind one
foundational model was above nine-tenths English by token count (the GPT-3 paper's own
documentation, 2020). Later commercial models carry larger non-English shares, and none
of the large closed labs publishes the breakdown -- which is exactly the opening for a
commons model. **Ember publishes its shares.** Corpus share per language, stated as a
table with units and dates, is the language row of the honesty the foundation already
promises. A community weighing whether the commons model is theirs can read the answer
instead of guessing it. The old draft's own scale figures make the stakes concrete:
Persian alone counts on the order of a hundred million speakers across three countries
and a diaspora (common reference estimates, cited in the 2026 draft), against a corpus
share the draft put below one percent -- that second figure unverifiable, and the point
survives its imprecision.

## The tokenizer is a seam, and a seam gets a witness

The subtler debt lives below the corpus. A tokenizer built for one language fragments
another's morphology -- splitting a possessive construction mid-joint, shattering an
agglutinated word into shards that carry no meaning. The damage is invisible in the
aggregate loss and obvious to every native reader. So the tokenizer is named as a seam
and gets what every seam here gets: a witness. Round-trip a corpus of real text per
supported language, count fragments per word, and hold each language under a named
ceiling. A language whose fragment count blows the bound is a language the model does
not yet honestly support, and the table should say so rather than the marketing.

## Who tends a language's corpus

The old draft's warmest idea generalizes cleanly once its campaign clothing comes off:
the people who span both worlds are the natural tenders of their language's corpus. A
diaspora community holds the language, the cultural context, and the technical fluency
of its adopted home at once. A commons model layer should make that tending a
first-class, credited contribution -- corpus curation as signed facts on the same ledger
that meters everything else, so the honor roll of who fed a language into the commons is
readable forever. This is the bake-contribution pattern with prose instead of gradients.

## Consulting a canon, plainly

One more pattern from the draft survives translation into plain engineering: retrieval
over a bounded local corpus of a literary canon, so a model's answer is grounded in a
community's own texts rather than in the model's diffuse memory. As engineering it is
ordinary retrieval-augmented generation with a bounded, content-addressed corpus --
which is exactly why it belongs here: it runs on a small local machine, it cites what it
retrieved, and the corpus is a value the community holds. The devotional framing the old
draft wrapped around it stays with the old draft; the pattern stands without it.

## Sources and standing

**Drawn from:** `2026-02-01-123000-pst-hafez-persian-ai-sovereignty-cursor-prompt.md`.

**The living tree already covers:** the open model layer and its honesty promise in
`foundations/20260728-232511_lantern-lattice-kiln.md`; self-hosted intelligence as
custody in `foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md` and the
surrounding stack; the reader-neutral voice this draft keeps, per the tree's standing
documentation rules.

**Genuinely new here:** language coverage as a published, dated table of shares -- the
language row of Ember's materials honesty; the tokenizer-as-seam rule with its
fragments-per-word witness and named ceiling; corpus tending as a credited, signed
contribution with the diaspora as its natural steward; and the canon-retrieval pattern
restated as bounded engineering. The campaign apparatus, the code samples in a foreign
stack, and the specific poet's register all stay with the source.
