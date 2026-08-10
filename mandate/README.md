# Mandate — Grain's turbopuffer

**Language:** EN
**Status:** Living — the vector store, lap 1 seated `20260810.031234`
**Voice:** Riyo
**Kin:** the first build of the breach's new arc (`../expanding-prompts/20260810-025942_the-handoff-baton-vision-checkpoint.md`)

Mandate is Grain's search organ — a **vector store**, its own answer to turbopuffer. It holds the embeddings a model turns meaning into, and answers the one question a vector store exists for: *which of my records is nearest this query?*

## The design

- **Cosine similarity, via unit vectors.** Nearness is the angle between two directions. Mandate normalizes every vector to length one **on upsert**, so a query is a plain **dot product** — no norms recomputed at search time. That is the turbopuffer trick, in our own hand.
- **Zero-copy.** A query never copies a stored vector; it reads each record **in place**, by reference, and accumulates the dot product. The store owns the bytes once; search borrows them.
- **Bounded, exact.** The store (`max_records`), the dimension (`dim`), and the result count (`max_k`) each name a maximum, enforced at the edge. Search is exact brute-force k-nearest — every record considered — which is correct at this scale. An approximate index (for scale past a single node) is a named horizon, not a shortcut taken silently.
- **A metadata filter.** Each record carries a **tag** beside its vector, so a query may filter — *the nearest images, but only nature ones* — the filter every real vector store owes.

## Build and prove

```
rye build mandate/store.rye -femit-bin=mandate/bin/store
mandate/bin/store selftest
rishi/bin/rishi run tools/mandate_store_witness.rish
```

The selftest frames its vectors as image embeddings (nature and city tags) so the nearest neighbours are legible by hand; the vectors are plainly synthetic, so no key or network is touched.

## Horizons

- **Unsplash** as the first real data source — image embeddings, IRL ROC camera (consent-gated partnership).
- A **profile-loaded dimension** (the way topology loads a sky), so `dim` is data rather than a constant.
- An **approximate index** for scale, and **object-storage backing** so the store is serverless like its inspiration.
- Records keyed by a **Kumara point** (`../settlement/`), so a vector belongs to a settled identity; served over **Comlink**, rendered on **Skate**.

---

*May the nearest thing always be found, the bytes read once and borrowed kindly, and every bound named before it is reached.*
