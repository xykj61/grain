# Living-docs lint and the Karpathy wiki pattern

**Language:** EN
**Last updated:** 2026-07-12
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Teacher:** Andrej Karpathy — [LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) · study copy [`../gratitude/karpathy/llm-wiki.md`](../gratitude/karpathy/llm-wiki.md)
**Keeper:** `tools/living_docs_lint.rish` (ratchet-advisory · seated `c4694f4` · three folds `223300`)

---

## What Karpathy names

Karpathy's wiki pattern separates **raw sources** (immutable), a **compiled wiki** (LLM-maintained markdown), and a **schema** (agent law). Three operations matter: **ingest** (integrate new sources into the wiki), **query** (answer from compiled pages), and **lint** (health-check — contradictions, stale claims, orphans, missing cross-references).

The lint operation is periodic and advisory in spirit: it keeps a compounding artifact honest as it grows.

## What we already had

This tree runs a stricter cousin of the pattern without calling it a wiki:

| Layer | Our shape |
|-------|-----------|
| Raw | dated `active-designing/`, counsel, Bron session logs — accrete-never-break |
| Compressed | `docs/` shelf (five pages under ceiling) |
| Schema | TAME Guidance, LEXICON nib law, ORGANIZING, session-log Bron fields |

Karpathy's gains for us were **deltas**, not adoption — especially a named **lint** pass on living prose.

## What tonight's keeper implements

`living_docs_lint.rish` is the ratchet-advisory lint Karpathy's gist describes, narrowed to operator docs:

1. **Retired LEXICON words** — with `tools/fixtures/living_docs_lint_keeps.txt` teaching landed-row history (seam-season-hammock lawful *tip* wording).
2. **Broken relative links** — roster-clean after caravan counsel repoint.
3. **Orphans** — inbound from `docs/README`, roster peers, and `ORGANIZING.md` module homes.
4. **Status rooms** — eight module READMEs and every `docs/` page name **Checkable** plainly.
5. **docs pin-strings** — byte-match canon only; duty five printed **clean** on the keeper's first walk.

The keeper always exits 0 — advisories print on every parity run; link-breaks may earn a gate once the shelf proves stable.

## Compression test (aparigraha)

A `docs/` page earns its ceiling only when it **compresses** facts scattered across many dated sources. The shelf is not a second raw tree; it is the compiled layer Karpathy's wiki names, held by humans and agents together.

## ai-memory (sibling teacher, parked)

[`gratitude/ai-memory/README.md`](../gratitude/ai-memory/README.md) — study shelf beside `ai-jail/`; daemon parked (second unsigned authority). Session-memory projection waits on a pipeline round.

---

*May raw stay beneath, compiled pages stay few, and the keeper print only true news.*
