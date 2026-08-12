# Karpathy — LLM Wiki pattern (study shelf)

**Language:** EN
**Last updated:** `20260812`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)

---

Andrej Karpathy's **LLM Wiki** gist describes a three-layer personal knowledge base: immutable raw sources, an LLM-maintained markdown wiki, and a schema file that teaches the agent how to ingest, query, and lint.

We hold the gist as a study copy only — [`llm-wiki.md`](llm-wiki.md). Refresh: `tools/fetch_gratitude_web.sh karpathy-llm-wiki`.

Our own-voice distillation — how the `living_docs_lint` keeper relates to Karpathy's **lint** operation — lives at [`../../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md`](../../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md).

## What became real practice here

The three layers arrived as an idea and became structures we run every day. We built our own; the debt is the shape, not the code.

- **Immutable raw → dated testimony.** The layer Karpathy keeps read-only, we keep by the **accrete-never-break** law: dated logs, specs, and counsel are never rewritten, only accreted beside (Tier 1 sealed by proof, Tier 2 by testimony). The raw stays raw because a record you can quietly edit is a record you cannot trust.
- **LLM-maintained wiki → the living docs.** The layer an agent tends, we tend as the foundations, the disciplines, and the reference weave — cross-linked wiki-style so a reader arrives anywhere and finds the way home ([`../../foundations/README.md`](../../foundations/README.md) and the compass habit).
- **Schema and lint → `living_docs_lint` and the sync law.** The layer that teaches an agent to check itself, we run as [`../../tools/living_docs_lint.rish`](../../tools/living_docs_lint.rish) — the fascia ratchet that flags broken links, orphan pages, and retired words — paired with the standing rule that a doc's behavioral claim is an **assertable invariant**, checked by reading and running rather than believed because it was once true ([`../../.claude/rules/docs-implementation-sync.md`](../../.claude/rules/docs-implementation-sync.md)). The lint catches the mechanical half; the discipline catches the rest.

The one line we keep past the borrowing: a doc's claim earns the **checkable room** only once a witness binds it ([`../../context/TWO_ROOMS.md`](../../context/TWO_ROOMS.md)). Karpathy's lint keeps a wiki tidy; ours keeps it *honest* — the same care aimed one notch higher.

- Source: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>
