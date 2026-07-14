# Claude Counsel — the Top Recommended Path, and the Five Questions Answered in Full

**Stamp:** `20260709.021112 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the same distinction this bench held through the settlement disagreement — TAME narrows implementation risk genuinely; circuit-design risk is a different category, and the first lap should be shaped around that difference rather than past it
**Register:** Cursor's own brief, engaged with directly rather than rubber-stamped — the recommendation to open SLC-L4's backend is sound, and this counsel shapes exactly how to open it safely
**Ground:** `external-research/20260708-223327_sui-zk-primitives-for-donor-amount-privacy.md`, read in full · `circomlib` and `snarkjs` actually installed and tested on this bench before being recommended — not read about and assumed

*Written by Kaeden and Rio 3.*

---

## Verified Before Recommended

This bench does not want to name `circomlib`'s comparator templates or `snarkjs`'s workflow from documentation alone, given how much of this whole arc has turned on the difference between reading about a tool and running it. Both were installed for real. `circomlib`'s `GreaterEqThan(n)` template exists exactly as the shape a donor-amount threshold proof needs. `snarkjs` runs, with real commands — `powersoftau new`, `powersoftau contribute` — matching the trusted-setup ceremony the pin study names honestly as a real requirement, not a footnote. The `circom` compiler itself could not be verified here: it needs Rust, which this bench doesn't have, and a release-binary download hit a proxy boundary this bench's network allowlist doesn't actually clear despite appearing to. Named plainly rather than glossed over — the recommendation below is grounded in what could be checked, and honest about the one piece that still needs a real run on a machine with Rust or a working binary.

## The Top Recommended Path, Named Once

**Open SLC-L4's backend, and open it around one governing idea: a circuit is protocol design, not implementation, and the two carry different risk.** Circomlib's comparator, not a hand-authored range check, is the whole reason this recommendation can be made with any confidence — TAME's own discipline narrows *implementation*-class risk genuinely, and this lap should spend that narrowing on the parts around the circuit, while leaning on circomlib's own years of scrutiny for the part that is actually cryptographic protocol. Everything below is that one idea, worked out five times.

## 1 — Implementation Shape for the First Witness Lap

The circuit: `GreaterEqThan` from circomlib, wired to exactly the signals the pin study already named — `amount` private, `threshold` and `log_digest` public, output constrained true. Nothing hand-authored beyond the wiring. Trusted setup: test/fixture keys only, generated with `snarkjs powersoftau` and `groth16 setup`, checked into the fixture the same way `tools/fixtures/` already keeps every other test's known inputs — never a production ceremony at this lap. The `.bron` receipt: exactly the pin study's proposed fields, no changes needed. The prover seam: a POSIX external-interpreter script, the identical family as SLC-L3's chain lanes, shelling out to `circom` to compile and `snarkjs` to prove — new tool dependencies, named as plainly as `grpcurl` was named for the Sui chain-read seam. **One real refinement to the pin study's own plan, worth making explicit:** the *offline* prove-and-verify pair — fixture witness in, fixture proof out, `snarkjs groth16 verify` confirming it against the pinned test key — is fully deterministic, exactly like every other witness in `tools/parity.rish`, and belongs there once green. Only the *live Sui verify transaction* needs the on-demand, network-seam treatment counsel `221612` already established. This is a real distinction the pin study's own language ("fixture-only vs on-demand chain verify") already gestures at; this counsel makes it a rule rather than a question.

## 2 — What the Lap-Open Brief Needs

Bound "complete" tightly: one circuit, one claim (`amount >= threshold`), offline fixture prove-and-verify GREEN, one `.bron` golden — explicitly not a live Sui transaction, not a production ceremony, not either of the other two ZK passes. Name `circom`, `snarkjs`, and `circomlib` as new tool dependencies up front, the same courtesy `grpcurl` already received. Propose `disclosure_core.rye`'s name and park it for Kaeden's word, matching every other new-name convention this tree already keeps. And name the caveat this counsel has held all along, in the brief's own words rather than buried in a study: this lap proves the *pattern* works end to end; it is not, on its own, a security review of the circuit, and should not be treated as mainnet-ready without one, independent of how clean the demo looks.

## 3 — Realidream Ordering: Agree With A, and the Thin Demo Is Worth Taking

A-first is right, for the reason the brief already gives — SLC-L4 is the next real Linengrow whole, and it extends ground SLC-3 just finished proving. The thin exception is worth taking seriously rather than dismissing, though, and for a precise reason: it needs nothing Realidream's full lap needs. SLC-2a's drawn terminal is the *active* rung, not a held one, and a demo that only renders already-fetched chain-read data through that existing surface — no new input handling, no new Pond policy, nothing Dexter's graduation would gate — never touches the held gates at all. If it can be built genuinely that thin, it is worth a small, parallel track alongside SLC-L4's backend, not instead of it. If building it honestly turns out to need anything from Pond or Dexter, the exception was never really an exception, and it waits with everything else in that lane.

## 4 — Settlement Crown: One New Data Point, No New Verdict

Counsel `221612` still holds entire. One thing from the pin study is worth folding in for whenever the mainnet event arrives: Sui carries native Groth16 verification today; Monad has no equivalent pinned yet. This does not crown a settlement lane — asset integrity and receipt verifiability remain their own axes, untouched by which chain can check a ZK proof — yet it is one more real fact for whoever makes that call, and it belongs in the record now rather than rediscovered later.

## 5 — the Testnet Trial: Practice First, Engineering Only Where Practice Finds a Real Gap

`settlement.rye` and `settlement_core.rye` already exist and already pass their witness; running real Linengrow asks through them on testnet is Kaeden operating what is already built, not this bench building something new. The honest prediction: real use will surface small friction — a rough edge in how a receipt gets checked, a step that wants a shortcut — and *those* specific gaps, found by actually using the thing rather than guessed at in advance, are where small, targeted engineering work belongs. Starting the trial needs no code; finishing it well might ask for a little, once the trial says exactly what.

---

*May every circuit this tree ever writes lean on years of someone else's scrutiny before it leans on its own cleverness. May a thin demo stay thin exactly long enough to prove it could, and no longer. And may the next tool this bench cannot fully verify be named as honestly as this one was, rather than trusted past what was actually checked.*
