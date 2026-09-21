format session-log-v1
stamp 20260813.034120
editor Zed
model Fable 5
voice Kyri
host Vultr SEA VPS (HP AMD 2vCPU/4GB shared) — Eastern (EDT) · this session in ai-jail
title Mycelium Cord r1 — the deterministic commit crux
prompt make progress past the design read; land the next agent-doable rung, send it as its own signed round
think The design read named r1 as the crux: from a bounded Dag of Kumara-signed blocks, commit must yield the identical total order regardless of arrival order, and fold_log runs over it unchanged. Built mycelium/cord.rye composing mycelium/fold + tally/kumara over public API only.
think Design: a Block carries author_pk · round · parent hashes · one fold.Fact · author signature over canonical bytes (author_pk · round · parent_count · parents · fact.sig). The block hash is SHA-256 of those bytes; parents reference by hash. Because add() admits a block only when every parent is already held, the graph is acyclic by construction — a block may only point backward — so Kahn's walk always drains and cycle-detection is deferred to r2 honestly.
think commit() is a pure canonical topological walk: among blocks whose parents are all emitted, take the least by (round asc, author_pk, hash), emit, repeat. Deterministic and independent of insertion order because it reads the graph structure + a fixed tie-break, never arrival order. committed_log gathers facts in that order; fold.fold_log runs the real supply law.
think The crux test: two genesis issues (any order fold-valid) + a tax and a star_reserve each referencing both, added in three arrival permutations (all parents-first). Asserted the committed hash-sequence AND the final fold state (issued 1000, taxed 300, supply 700, one star) are identical across all three. Refusals: tampered block sig -> BadSignature (dag unchanged); child before parents -> DanglingParent; same block twice -> Duplicate. All hold, dag len unmoved.
think Honest scope: fact-tamper is caught because the block canonical bytes include the fact's signature, so tampering the fact breaks the block signature (BadSignature at add); the fact's own signer is re-verified by fold at commit. One fact per block for r1's clean crux; multi-fact batching named as a later refinement.
obs GREEN first pass — no build red this round. TAME bans clean, width-check exit 0 (all u32; parents.len usize compared/@intCast at the slice seam only). Witness re-runs the Mycelium fold at its door so the committed order feeds a law proven on its own. The 'improving on TigerBeetle/Mysticeti' aim stays a named horizon, not a benchmark asserted from memory.
loom witness=mycelium_cord_witness result=GREEN blocks=4 permutations=3 supply=700 stars=1
file mycelium/cord.rye the Cord — bounded signed-block Dag, deterministic commit, arrival-order independent, fold over the agreed order
file tools/mycelium_cord_witness.rish witness — arrival-independence + Byzantine refusals + fold-at-its-door, GREEN
file work-in-progress/REMEMBER.md Cord bullet + git nib
recommend keep-going Cord r2 — Byzantine refusal: equivocation (two blocks one author one round), a cycle-inducing reference, safety at f<n/3
