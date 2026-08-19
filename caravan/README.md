# Caravan — Process Supervision

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 2 · host mirror under supervision)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — process supervision ladder

**Caravan supervises.** It watches a dependent process, restarts it when it falls, and grows — one accretion at a time — toward the fuller shape a real service needs: bounded memory per dependent, more than one dependent, ordered startup, a named capability table, and a real exit-code vocabulary that tells restart-on-fall apart from an ordinary cycle and a deliberate stop.

Every ring here composes over the one before it. A later ring imports an earlier one, or restates its shape one step further out — nothing is rewritten to make room for the next proof.

## The Ladder

| Ring | File | Proves |
|------|------|--------|
| seed | [`seed.rye`](seed.rye) | one parent, one dependent, restart on fall |
| bounded | [`bounded.rye`](bounded.rye) | supervision composed with a dependent's Tally garden |
| twin | [`twin.rye`](twin.rye) | two dependents, separate gardens, independent restart |
| chain | [`chain.rye`](chain.rye) | ordered startup stages, each restarting on its own fall |
| service (B) | [`service.rye`](service.rye) | one long-running dependent, a bounded multi-tick loop, a fall mid-sequence restarting the whole sequence |
| capabilities | [`capabilities.rye`](capabilities.rye) | a bounded table naming what each dependent may do |
| exit vocabulary | [`supervisor_exit.rye`](supervisor_exit.rye) | the three-way exit code: `cycle_ok` (0) spawns again, `stop_requested` (8) halts, anything else falls and restarts |
| restart-on-ok (D) | [`restart_on_ok.rye`](restart_on_ok.rye) | the exit vocabulary proven pure, argv-driven, before any wire work touches it |
| signal ring | [`supervisor_signal.rye`](supervisor_signal.rye) | a real `SIGTERM`/`SIGINT` handler whose entire body is one atomic store; the loop top creates the same sentinel a manual `touch` would |
| poll service (C) | [`subscribe_poll_service.rye`](subscribe_poll_service.rye) | production scheduling — Caravan supervises Mantra's real subscribe-poll wire work, single pair and host-mirror pair-list alike |
| channels | [`channels.rye`](channels.rye) | the static supervision graph -- a bounded roster of protection domains, channels joining exactly two of them, every refusal named |
| regions | [`regions.rye`](regions.rye) | the declared sharing surface -- named memory regions granted to named domains at named permissions, with write and execute held apart |

## Why the Exit Code Carries Three Meanings, Not Two

A supervisor that only knows "zero means done, anything else means retry" stalls a poller — an ordinary, successful cycle looks identical to a finished job, and the supervisor stops exactly when it should keep going. `supervisor_exit.rye` names the third answer: zero is *ordinary*, rather than *finished* — restart regardless. A reserved code, `stop_requested`, alone halts the loop, and it means the same thing whether a human created a sentinel file by hand or `supervisor_signal.rye`'s handler created it from a real signal. Counsel: [`counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md`](../counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md), [`counsel/20260707-021012_claude-counsel-ring4-signal-handler.md`](../counsel/20260707-021012_claude-counsel-ring4-signal-handler.md).

## Why the Graph Is Declared, Rather Than Discovered

`capabilities.rye` names what each dependent may do; `channels.rye` names who each dependent may talk to. Both are declared at construction and readable whole, so the complete communication graph of a supervised system lives in the declaration rather than emerging at runtime -- and a static graph is a graph a witness can check whole. Two clients wired to the same virtualiser still hold no path to each other, since sharing here is deliberate and visible rather than ambient. The shape comes from the Microkit clean-room brief, [`20260819-094721_clean-room-microkit-protection-domains-channels.md`](../active-designing/20260819-094721_clean-room-microkit-protection-domains-channels.md), studied from public docs alone -- concepts crossed the clean room, no source did. This is the first Rye rung of the Microkernel Target's Equinox 1, and it stands on hosted ground: pure policy, asserted and witnessed, with no kernel underneath it yet.

## Why Sharing Is Granted, Rather Than Assumed

`regions.rye` completes the triad: capabilities name **what** a dependent may do, channels name **who** it may talk to, and regions name **what memory** it may touch and how far. Every share is a declared grant of a named region into a named domain at a named permission, so a domain reaches exactly what its declaration hands it and nothing beside. Two clients served by one virtualiser each read their own receive buffer while reaching none of the other's, and the map answers *why* a refusal happened -- an undeclared region, an undeclared domain, an ungranted pair, a denied write, a denied execute -- rather than a bare no.

Two invariants carry the ring. Every grant reads, since a grant permitting nothing declares nothing. And write never stands beside execute in the same grant -- the W xor X rule, held structurally at the constructor and refused by name at the door, so the whole declaration can be checked at once by `write_xor_execute`. Two reads summarize a map for a human: `holders` counts how widely a region is shared, and `footprint` sums the bytes a domain reaches in total. Witness: [`tools/caravan_regions_witness.rish`](../tools/caravan_regions_witness.rish), GREEN on metal, its RED path proven by removing the guard and watching the constructor's own assert catch it.

## Held

Extended-run stability (dozens of supervised cycles, watched for resource growth) waits for a genuine indefinite consumer to make the longer run mean something — see [`counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](../counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md) for the reasoning. Nothing here reaches toward Pond's policy layer or Brix's composition layer; Caravan supervises processes, and stops exactly there.

---

*May every dependent that falls be caught, and every dependent that finishes ordinarily be trusted to go again. May a stop always mean the same thing, however it arrives.*
