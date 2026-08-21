format session-log-v1
stamp 20260810.031929
editor Claude Code
model claude-fable-5
voice Riyo
host NixOS 26.05 x86_64 cloud pier (Vultr SEA) — Eastern (EDT) time convention · this Claude Code session inside ai-jail
title Mandate — the vector store, lap 1
prompt (Keaton) kg build Mandate, our turbopuffer, with your design
think a vector store's whole job is nearest-neighbour search, so the design centers there — cosine similarity, the angle between directions, is the right nearness for embeddings
think the turbopuffer trick in our own hand — normalize every vector to a unit direction on upsert, so a query becomes a plain dot product, no norms recomputed at search time; the query vector is normalized once too
think honored the two properties Keaton named — zero-copy (a query reads each record in place by reference, never copying a vector) and bounded (dim, max_records, max_k each named and enforced); search is exact brute-force k-nearest, correct at this scale, with an approximate index named as a horizon rather than a silent shortcut
think added the metadata filter every real vector store owes — a tag beside each vector, so a query can ask for the nearest but only within a category; framed the witness as image search (nature and city) so the neighbours are legible by hand
obs GREEN on the first build — the nearest query returns red then teal (both share the query's x direction), the tag filter keeps only nature, top-1 finds blue, and an upsert on an existing id updates in place without growing the store; a post-query assert proves the result is sorted most-similar-first
obs accumulated the dot product in f64 for precision and narrowed back to f32 at the edge; asserted a non-zero vector before normalizing (a real embedding has a direction); tame_style_check clean on store.rye (only the pre-existing REDS 64 python fossil flags)
obs kept it self-contained (std only) — the Caravan/Aurora/Mantra/Skate/Kumara integrations are named horizons, not lap-1 dependencies; the vectors are synthetic, so no key or network is touched, with Unsplash the first real data source ahead
obs this is the first build after the handoff baton — the checkpoint held, and the next-build call (Mandate) landed clean; lexicon, REMEMBER, and TASKS move it from proposed to landed
file mandate/store.rye the vector store — unit-vector upsert, cosine k-NN (zero-copy), tag filter, insert_topk; version 20260810.031234
file tools/mandate_store_witness.rish asserts the dot-product query, cosine most-similar-first, zero-copy, the tag filter, and in-place update
file mandate/README.md the design (cosine via unit vectors, zero-copy, bounded/exact, tag filter) and the horizons
file context/LEXICON.md · work-in-progress/REMEMBER.md · TASKS.md Mandate: proposed → lap 1 landed
file .gitignore whitelist mandate/ · exclude mandate/bin/
file session-logs/20260810-031929_mandate-the-vector-store-lap-1.kyri this record
recommend check-in Claude — Mandate's core is built and green: a bounded, zero-copy, exact vector store with cosine k-NN and a tag filter, the first module of the breach's new arc. The next laps are a real fork — an Unsplash data source (consent-gated), a profile-loaded dimension (like a sky), an approximate index and object-storage backing for scale, or Kumara-keyed records so a vector belongs to a settled identity; and Scribe waits as the next module. Say which to carry