format session-log-v1
stamp 20260811.124417
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Mandate lap 9 — the serve protocol (served over Comlink)
prompt kg ty every1, baton prin recur — the arc's capstone: serve Mandate over Comlink
think the "served over Comlink" horizon has two halves — resolve a match to a spoken name, and carry a query over a wire; I built the wire-message half (the protocol), the clean bounded low-risk lap
think serve.rye is the wire shape: QueryRequest (k, optional tag filter, vec) and QueryResponse (matches id+score), each serialized to bounded little-endian bytes — the messages a Comlink transport carries; serve(store, request_bytes, out) is the one-call server (decode, answer, encode) so the same store answers in-process or across a wire by the same path
think decode enforces the store's own bounds at the door — k in 1..=max_k refused rather than clamped, count bounded, magic + version checked — so a malformed request never reaches store.query
obs the spoken-name half is genuinely blocked: seating a NameRegistry from outside names.rye needs its tag_claim (private to that module's own selftest), so external claim can't sign a valid name. Named honestly in the README; the serve layer resolves to a PLACE via keyed.place_of today, to a spoken name once names.rye offers a claim helper or a public tag. A real finding, not a workaround
obs proved on metal: a request round-trips through bytes; a served query equals a direct in-process query (same nearest + order); a tag filter narrows to nature only (ids 1,2); a bad magic, over-range k, and too-small out buffer all refused. serve.rye carries no TAME bans; assert-sweep advise tier stays empty
loom witness=mandate_serve_witness wall_ms=15 max_request_bytes=56 max_response_bytes=144
loom build=mandate/serve.rye rye_zig=vendor/zig-toolchain/zig exit=0
file mandate/serve.rye the serve protocol — QueryRequest/Response, encode/decode, answer, one-call serve, prove_serve, selftest + main
file tools/mandate_serve_witness.rish asserts the serve GREEN lines
file mandate/README.md lap 9 documented; Comlink-socket wiring + spoken-name resolution (needs names.rye tag_claim) named as the remaining horizons
recommend check-in (Claude) — Mandate's nine-lap arc is whole (CRUD → durable → served); the two open doors are cross-module (a Comlink socket carrying serve bytes, and names.rye exposing a claim helper so serve resolves spoken names) and the Acme DX design season. A natural place to rule direction. Rest is Keaton's to take
