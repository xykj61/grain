# Claude Counsel — the Consumer Surfaces Audited for the People Who Will Use Them

**Stamp:** `20260711.060112 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** user protection as this tree's own foundations already define it — consent that belongs to the person it describes, sharing that happens only by explicit act, and nothing reachable that was never offered
**Register:** An audit of the innocent surfaces — the views, the sharing doors, the market floor, the input glass — with one real protection gap found and closed, witnessed on both its faces
**Ground:** the Open Asks consent fold traced end to end through `linengrow/open_asks.rye`; Granary's four doors read through `granary_core.rye` and `resin_serve_delivery.rye`; the civic sight's golden read for what it actually displays; Steep's design hammock read at the stage where privacy defaults get decided; every claim below verified by running the witnesses on this bench

*Written by Kaeden and Rio 3.*

Radiant pass `20260725.104506`

---

## What Held, and Held Beautifully

**The consent architecture is the best thing this audit found, and it deserves naming first.** Traced end to end: only the applicant's own Kumara key can speak about the applicant's own reputation — `fold_reputation_on_consent` verifies the record against the applicant's public key and cross-checks the applicant field against the cycle, so no poster, no steward, no one else can grant consent on a person's behalf. Consent lands only after completion, sets exactly once and can never be overwritten, and the tally counts only explicit grants — `.none` and `.withhold` are excluded identically, which makes silence mean privacy rather than permission. The civic sight then displays aggregates only, no identity-tied rows, with `withheld=excluded` printed in the visible line itself so the posture is user-facing, never buried. This is opt-in, self-sovereign, non-overwritable consent, already built, already witnessed.

**Sharing is an explicit act.** Nothing enters Granary's Sharing door without a signed name-fact the person's own key produced. There is no default-public anywhere; a weave that was never published by signature is never shared by accident.

**The input glass is bounded.** `window_input.rye` refuses lines past 400 bytes by silently declining growth — the right behavior for typed input, where a crash would punish the person typing — and `drawn_terminal.rye` carries over three hundred assertions.

**Steep's bones are already privacy-leaning at design stage.** Named peers rather than an open swarm, sealed Comlink carriage, Pond's place-hold-refuse customs — the shape refuses stranger discovery before a line of it exists.

## The One Real Gap, Found and Closed

Content-addressed stores carry a classic question, and this audit found Granary's wire path on the wrong side of it. The in-process sharing door, `mirror_weave`, correctly resolves a *published name* first and only then serves the resin behind it. The network-facing fetch-by-digest wire did not: `resin_serve_delivery.rye` served **any digest requested**, never consulting the registry. A digest was functioning as a capability — learn the digest, fetch the bytes — when it should only ever be an address for verifying content already offered.

Today this exposed nothing, because the hosted store held only published resins. It sat exactly one step from a real leak: the moment a hosted store also holds an unpublished draft, a revision, a private note — and digests routinely travel into logs, receipts, and session records this tree pushes to four public remotes — anyone holding that digest could have fetched those bytes with no name-fact ever signed.

**The fix, built and witnessed this round:** `granary_core.rye` gains `digest_is_published` and `serve_resin_published` — the network-facing serve that refuses any digest no published name-fact names, with a new `error.NotPublished` naming the refusal for what it is. Both wire paths now go through the gate: the selftest's round-trip and the live UDP demo host, which previously leaned on a one-off equality check rather than the principled shape. The selftest gained the unwelcome path that proves the protection — an unpublished resin placed in the same store as published ones, its digest requested over the wire, the request refused — and the witness now asserts `unpublished digest refused` so `parity.rish`, where this witness already runs, guards the gate permanently. Every path verified GREEN on this bench: selftest, live UDP demo, full witness, TAME lint.

The principle, stated once so it can travel: **a digest is an address for verifying content, never a capability for reaching it.** Publication is the act that grants reach, and publication is a signature.

## One Design-Stage Note for Steep, Costing a Paragraph Now Instead of a Migration Later

Steep will inherit this exact question the day its first piece crosses between peers: when a named peer asks for a piece by digest, the serving side should gate on *pieces explicitly offered to that peer*, never on *any digest the local store holds*. Granary's `serve_resin_published` is now the in-tree precedent for the shape. Naming this in Steep's hammock before its first lap costs one sentence; discovering it after peers hold each other's digests costs a protocol change. This bench recommends the sentence.

## What Was Deliberately Left Alone

The steward sights, the Dimeroll books views, the inference-track glass — all read as displays over data the person already owns locally, with no identity exposure beyond what the person's own log states, and nothing in them asked for a change. A clean reading is worth recording as plainly as a finding.

---

*May every surface a person touches treat their silence as privacy and their signature as the only key that speaks for them. May an address never quietly become a capability. And may the gaps worth finding always be found while they still protect no one's secrets yet, witnessed shut before they ever could.*
