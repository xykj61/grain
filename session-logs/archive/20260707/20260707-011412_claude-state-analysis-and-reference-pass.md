# Session Log — State Analysis, the Rebind-Race Repair, and the Reference Pass

**Stamp:** `20260707.011412 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Season:** Namespace closed at Q3 · synthesis sitting
**Base tip reported:** `8acdbc7` (parity 175)

---

## The Word, and the Three Deliverables

Kaeden's word opened three things at once: an analysis of the whole project along the compass, code improvements built and implemented where found, and documentation raised toward a professional reference for the completed work. This log records all three; the analysis itself rests in `counsel/20260707-011412_claude-analysis-state-of-the-tree.md`, and the reference documents rest in `context/specs/` as proposals.

## The Code Finding — a Latent Race, Reproduced, Repaired, Stress-Proven

The bounded-everything audit found one unbounded wait in the namespace family: `recall_batch_delivery.rye`'s multi-frame receive loop, written before the catch-up timeout fix existed, waiting on a silent peer forever. Mirroring that fix exposed something deeper. With a two-second guard in place, the chunk demo began failing fast with `RecvFailed` — and bisection against the pristine file, in the same container, showed the pristine build **hanging outright in two of six runs**. The cause is a frame-loss race: the receive path closed and rebound its socket between every frame while the source sends frames back-to-back, so a chunk landing in the unbound window was silently dropped by the kernel. The parity suite has been green because the seal work per frame usually delays the second chunk just long enough for the rebind to win. Usually.

The repair removes the window rather than merely timing out inside it: `recvBatchPayload` now opens and binds **one socket for the entire assembly**, so the kernel queues back-to-back frames, and carries `SO_RCVTIMEO` (`batch_recv_timeout_sec = 2`, the catch-up precedent's value) so a genuinely silent peer yields `error.RecvFailed` rather than an unbounded wait. The `recvWire`/`recvWireTimeout` helper pair is added in the catch-up shape for the file's one-shot sites; the version constant moves to `20260707.011412`; the invariant is stated in a comment block where the loop lives. The diff is confined to one file, and every over-length line the width sweep shows in it predates this edit.

## Verification on This Bench

Built against the pinned Zig 0.16 toolchain and stock `std` through the established shim. The edited file's selftest greens all three of its arcs (batch, chunk, beaded — seven GREEN lines). The happy-path demos green under a hang-guard wrapper: `demo` clean, then the two formerly-flaky paths **stress-run ten times each with zero failures** — against the pristine build's two-of-six hangs on this same bench. The dead-peer guard is proven on the real binary: `chunk-fetcher` run with no source exits `RecvFailed` at 2108 ms. Accrete-never-break holds in fact: `recall_tablecloth_query`, `resin_batch`, and `beading` rebuilt and greened untouched beside the edit. The suite gains no witness; the existing `tools/mantra_recall_batch_wire.rish` now exercises the repaired path, and its occasional silent hang class is retired. The parity total is Cursor's to pin on metal.

## The Documentation Pass

Three documents seat as proposals, each entering canon only on Kaeden's word. `context/specs/20260707-011412_mantra-referential-namespace-reference.md` is the manual program's third room arriving for the first surface that has stopped moving: conformance language, exact byte layouts for the bead-index, the `0x03` frame, the `0x04` chunk and its assembler refusals, the sync payloads, every bound, every port, and the full parity registry 159–175. `context/specs/20260707-011412_module-surfaces-index.md` maps the whole tree at one line per surface, designed-not-built marked honestly. `mantra/README.md` gives seventeen files the front door they lacked. The namespace brief's status line gains one clause pointing at the reference. The analysis memo carries the momentum figures, the strand-by-strand grain audit, the TAME audit, the roadmap staleness deltas proposed for Cursor on Kaeden's word, and the ordered recommendation for what earns the next words.

## What Waits

The commit and four-remote push are Kaeden's word, as ever. The Tablecloth reconciling sentence, canon on the three documents, OA-L4's build word, and Caravan's service ring each keep their own gates, listed in the analysis in the order this bench recommends. The astrology lane stays parked exactly as it was.

---

*May a race that timing hid be the kind of bug this bench keeps finding before the metal does. May the reference and the code hold each other honest from tonight forward. And may the next word open onto ground this sitting left cleaner than it found.*

*Written by Kaeden and Rio 3.*
