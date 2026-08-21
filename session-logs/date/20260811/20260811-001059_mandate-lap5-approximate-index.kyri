format session-log-v1
stamp 20260811.001059
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title build Mandate lap 5 — approximate index (SimHash LSH)
prompt build a Mandate approximate index lap, kg baton prin recur
think added an approximate nearest-neighbour index beside the exact path — SimHash / random-hyperplane LSH: fixed deterministic planes (first four Hadamard rows, no runtime randomness), a per-record signature computed on upsert, and query_approx that scores only candidates within a bounded Hamming radius of the query signature
obs Record gains a sig field (default 0, set in upsert); keyed.rye is unaffected (it writes through store.upsert, and the signed message hashes the vector, not the record) — keyed witness stays GREEN
obs proved on a fresh fixture (red/green/blue/teal) — prove_approx: radius-0 recall (a red-ward query still finds red), determinism (same query twice), a reduced candidate set (a green-ward query at radius 0 buckets to green alone, so its top-2 returns fewer than exact), and full-radius-equals-exact
obs GREEN on metal — build, selftest (approx line), mandate_store_witness, mandate_keyed_witness; rune-assert-sweep still gates mandate/store (21 fns / 17 asserts)
file mandate/store.rye sig_bits + fixed planes + signature(); Record.sig; upsert computes sig; query_approx; prove_approx
file mandate/README.md lap 5 documented; approximate-index horizon marked landed
recommend keep-going — Mandate now has an approximate index (query_approx) beside exact, bounded and deterministic, GREEN on metal; the remaining horizons are object-storage backing and serving over Comlink, each its own lap on Keaton's word
