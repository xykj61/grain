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

## Kumara-keyed records (`keyed.rye`, landed `20260810`)

A bare store keys a vector by any `u32`. [`keyed.rye`](keyed.rye) makes the key an **identity**: a record belongs to a settled Kumara **point**, and only that point's owner may store its vector. The gate mirrors the name registry — the owner presents the point's **Deed**, verified against the constellation's shared surface, and **signs** the exact vector (its SHA-256 digest, with the point and tag). So a stolen id cannot poison another identity's search, and a query returns *who*, not merely *which number*: `place_of` resolves each match to its galaxy, star, or planet. Refusals proven: a non-owner, a forged signature, a tampered vector.

## Horizons

- **Unsplash** as the first real data source — image embeddings, IRL ROC camera (consent-gated partnership).
- A **profile-loaded dimension** (the way topology loads a sky), so `dim` is data rather than a constant.
- An **approximate index** for scale, and **object-storage backing** so the store is serverless like its inspiration.
- Served over **Comlink**, rendered on **Skate**; resolved to a spoken name via `../settlement/names.rye`.

---

*May the nearest thing always be found, the bytes read once and borrowed kindly, and every bound named before it is reached.*
