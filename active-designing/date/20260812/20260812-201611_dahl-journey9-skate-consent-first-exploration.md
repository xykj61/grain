# DAHL Journey 9 — Skate, the consent-first social layer (exploration)

**Stamp:** `20260812.201611` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — opens Season 3 (Commons) of the 1,024-round itinerary
**Waymark:** **DAHL** (Harvest Equinox 3 — Commons, already seated; no rival draw)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../pond/customs.rye`](../pond/customs.rye) · [`../settlement/names.rye`](../settlement/names.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 1 (The World, TACT) and Season 2 (Yield, GISM · AYRE) stand complete across every agent-doable rung — a stranger reaches a running Pond (Ship-Pilot), publishes and trades under a settled identity, and every module reads real bytes and trades fairly. The 1,024-round itinerary's next Lindy-first crux on the *whole* road is **Season 3 — Commons (DAHL), Journey 9 (Skate)**: the social layer over Pond identities, *a shared surface entered by consent, never by default*.

This is a new domain, so the itinerary's filling law asks for a design read before the first round — this document.

## The durable promise this journey turns on

Season 3's promise: **keepers meet each other with consent, and a community can shape its own sky.** Journey 9 draws the first, load-bearing half — how two keepers come to *see* each other at all. Everything a commons later builds (groups, quorum, skies) rests on the answer, so the answer must be right the first time. That makes it the crux, and it is Lindy-durable: the consent rule a social layer is built on is read for as long as the layer lives.

## The crux — consent is mutual, presence is never default

Pond's own first policy already names the shape at the artifact border: **place · hold · refuse** (`pond/customs.rye`). Skate carries that same trichotomy to the social border, where the default is the strictest verdict:

- **refuse** — the resting state. A keeper is *not* a member of a circle, and two members are *not* linked, until each says so. Nobody is visible by default.
- **hold** — one keeper has asked to link with another, and the other has not yet answered. A one-sided request is a standing offer, never a connection.
- **place (linked)** — *both* keepers have asked to link. Only mutual consent makes a connection, and only a connection makes one member visible to another.

The crux is the mutuality: a `link` between two members exists **only when both have requested it**. A one-sided request holds forever without ever becoming a link; a steward cannot manufacture a connection from one side. This is the honest meaning of *consent-first*: not "opt out is available," but "nothing exists until both opted in."

## Why this shape, against the alternatives

- **Not a follower graph.** A one-directional "follow" would let A make A→B visible without B's word — presence by one keeper's default, exactly what the promise refuses. Mutual-only is the stricter, more durable law.
- **Not an allow-list of marks** (customs' own shape). Customs judges *content* crossing a border; Skate judges *keepers* consenting to be seen. The verdict vocabulary is borrowed; the subject is different, so it earns its own module rather than extending `customs.rye`.
- **Not signed yet, at r1.** Round one fixes the *rule* as a pure state machine (consent as explicit acts, bounded, refusing dishonesty), exactly as `entity_books` r1 and `commerce_trade` r1 fixed their conservation laws before signing. Signing is r2's crux, mirroring `commerce_trade_signed` / `fairtrade_cert_signed`.

## The four rounds (Lindy-first, crux-first)

- **r1 — Consent.** `pond/apps/skate_circle.rye`: a `Circle` keepers join only by their own explicit act; a `link` between two members exists only when both request it (one-sided **holds**, mutual **links**); no member is visible to another by default. Pure state machine, bounded. Refusals: join a taken seat (`AlreadyMember`), link a non-member (`NotMember`), self-link (`SelfLink`), a full circle (`CircleFull`), full links (`LinksFull`). The crux made checkable: a one-sided request never reads as linked; the mutual pair does; visibility follows the link exactly.
- **r2 — Signed.** `pond/apps/skate_circle_signed.rye`: each consent act (join, link-request) is signed by that keeper's settled Kumara identity and verified against a caller-supplied keyring, mirroring `commerce_trade_signed.both_agree` — a steward cannot fabricate a keeper's consent. Honesty crux: forge or relabel a consent act and its signature falls.
- **r3 — Travels.** `pond/apps/skate_circle_bron.rye`: render a circle's members and links to a `format skate-circle-v1` Bron record and parse it back byte-for-byte, still consent-honest offline (a link flipped after the crossing refuses); unknown/missing field · bad header each refuse.
- **r4 — Read-true.** `pond/apps/skate_circle_true.rye`: carry the surface onto a real fixture (or settlement identities) and cross-check the membership/link count against an independent measure — two tools, one answer — so a circle can never drift from what a keeper can count by hand.

## Boundaries (custody-first)

Skate records the *facts* of consent and holds nothing — it opens no network, moves no funds, and generates no real identity. The Comlink-served rung (a circle shared over the wire) reaches the serve custody gate and is the maintainer's hand; demo keeper seeds only, never a real Kumara instance (gate #4). Everything above — the pure rule, signing over demo seeds, Bron travel, reading a real fixture — is agent-doable and does not wait.

---

*May the first rule of the commons be the honest one: that no one is seen until they ask to be, and no bond is made but by two words freely given.*
