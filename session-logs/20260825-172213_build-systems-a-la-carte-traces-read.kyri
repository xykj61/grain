format session-log-v1
stamp 20260825.172213
editor Claude Code
model claude-fable-5
voice Kyri
title build systems a la carte -- verifying vs constructive traces, Shake, Nix CA early cutoff
prompt subagent research task: read Build Systems a la Carte (Mokhov-Mitchell-Peyton Jones, ICFP 2018) taxonomy -- schedulers and rebuilders, verifying vs constructive traces, Shake practice, Nix CA-derivation early cutoff -- and return findings with grain relevance
think fetched the ICFP PDF, extracted all 29 pages with pypdf in the scratchpad, and read sections 2.3-2.4, 4.1-4.4, 5.3-5.4, 6.4 directly rather than trusting summaries
think the load-bearing distinction: recordVT stores hashes of dependency values plus hash of result; recordCT stores the actual result value beside the same dependency hashes -- so when the result is one GREEN line the two costs converge and the constructive trace is nearly free
think deep constructive traces key only on terminal inputs, require determinism (Frankenbuild, Fig 11), and give up early cutoff -- the caveat that bounds any verdict-cache design for witnesses that read the live clock
think JFP 2020 version adds Shake's real structure, verifying step traces -- built/changed timestamps plus dependency keys, no per-dep hashes -- an O(1) trace for applicative tasks
think Nix side: input-addressed store fixes output paths from inputs, so no early cutoff; RFC 0062 CA derivations resolve inputs to content paths and skip already-realised resolved drvs; costs named -- non-determinism, self-reference rewriting is heuristic, trust moves to signed realisations
obs a witness verdict cache is the paper's Cloud Shake quadrant (suspending + constructive traces) purchasable at verifying-trace prices, because the stored value is tiny; Testament is already a signed constructive trace in grain vocabulary
obs no repo work committed -- research pass only; findings returned to the orchestrating session via structured output, sources carry access date 20260825
file external-research/20260825-132951_alpenglow-mysticeti-vsr-read-against-mycelium.md read for Constel context the findings serve
file active-designing/20260825-133156_three-real-mox-and-the-outer-loop.md read to ground grain relevance in the three-MOX outer-loop proposal
recommend check-in the parent workflow holds the findings; whether a witness verdict-trace store opens as a design round is Keaton's call
