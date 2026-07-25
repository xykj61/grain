# Bandwidth and Moderation — One Answer for a Friend's Two Questions

*A close friend of this project — a vegan developer reading the home-server guide and the self-hosted app designs — asks the question every honest self-hoster must answer: "How would you handle networking bandwidth and moderation?" This memo answers both in full, and finds at the bottom of each the same mechanism: the chosen fold. You do not download the whole world; you download what your fold can see. You do not police the whole world; you choose what your fold will render. Bandwidth and moderation are the same discipline wearing two coats.*

**Stamp:** `20260703.015512`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, joy third; CIVIC — the reward points at the good; the gentle register where people are tender
**Ground:** [`20260703-013412_home-server-purchase-guide.md`](20260703-013412_home-server-purchase-guide.md) · [`20260702-014112_comlink-beyond-dns-and-sockets.md`](20260702-014112_comlink-beyond-dns-and-sockets.md) · [`20260702-211312_names-builds-and-the-ledger-map.md`](20260702-211312_names-builds-and-the-ledger-map.md) · [`../context/CIVIC_STYLE.md`](../context/CIVIC_STYLE.md)

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice — with gratitude to the friend whose question sharpened it.*

---

## Part One — Bandwidth: Name the Budget, Bound the Lanes, Let Popularity Leave Home

### The true budget is the front door, and it has a number

The home fiber is generous; the rented front door is the honest constraint. A five-to-ten-dollar VPS carries a monthly transfer cap — commonly one to ten terabytes — and that cap, never the home line, is the rack's real public bandwidth. TAME's oldest rule applies without modification: everything has a limit, so **the monthly egress budget becomes a named constant**, metered at the tunnel's mouth, checked at the edge, failing loud with a named condition rather than a silent overage bill. A budget nobody named is a budget somebody else will name for you, at the end of the month, in dollars.

The arithmetic beneath the fear is kinder than the fear. A signed fact — a MALA transfer, a receipt, a post, a label — is hundreds of bytes. A month of vigorous civic life in facts is megabytes. **The ledger world costs almost nothing to serve.** An entire community's transactions, attestations, and conversation ride inside a budget that a single hour of video would spend. This is the first comfort to hand the friend: the parts of the platform that matter most are the parts that are nearly free.

### The lanes already know their manners

Comlink's two-lane design is a bandwidth policy wearing an architecture's clothes. The **fact lane** is reliable and small: it backpressures, it retries, it never drops a signed fact, and it never needs to be fast because facts are tiny. The **stream lane** is bounded and drop-late: media degrades in quality before it degrades in fairness, and a congested hour costs frames rather than truth. The **road-keeper** carries per-road bounded queues and scorecards, so a rack with two paths spends each according to its measured worth. Every lane carries a named maximum; nothing unbounded ever touches the wire. When media does flow, it flows through the royalty-free codec families at **named bitrate constants** — a stream whose ceiling is written down is a stream that can be budgeted, and one that is written down nowhere will eat the month.

### Popularity should leave home

The deepest answer is content addressing. **Resins** — content-addressed, signed, verifiable — are not bound to their birthplace. Any peer who holds a resin can serve it, and the receiver verifies the digest rather than trusting the host, so **the home rack is the root of authorship, never the sole servant of popularity**. The availability lesson already siloed from the settlement world completes the shape: *availability itself is a fact on the log* — a peer can publish a signed claim of holding, and anyone can check it. A post that finds a thousand readers should cost the author's rack a handful of transfers, with the neighborhood carrying the rest; the fold pulls resins from the nearest willing holder, and the front door serves only what no one nearer holds.

### The household comes first, and the seasons help

Two domestic courtesies close the bandwidth story. The rack reserves **household headroom** — a named fraction of the home uplink that the tunnel never crosses — so the family's evening is never starved by a stranger's download; the machine is a guest in the house, and a guest does not empty the pantry. And heavy synchronization schedules itself into the quiet hours, the same off-peak discipline the ecological-compute doctrine already keeps, so the network's slack hours and the grid's kind hours coincide. When a true popularity season arrives, the ladder is already priced: a second rented door in a second region, peers-as-mirrors by availability fact, and — for the far horizon the blueprint already names honestly — colocation.

## Part Two — Moderation: The Log Records; the Fold Decides What Renders

### The thesis, said once

The append-only log sounds like a moderation nightmare until the fold is remembered. **State is a pure fold over the log — and moderation is a property of the fold, rather than of the log.** Nothing needs erasing for something to stop appearing; the projection simply declines to render it. History stays whole, accrete-never-break holds, and every moderation decision becomes reversible, auditable, and personal. The friend's question assumes moderation means deletion; the architecture's answer is that moderation means *choice of fold* — which is gentler, more honest, and more powerful at once.

### Moderation actions are signed facts, so moderation has receipts

A mute, a label, a limit — each is itself a small signed fact: who spoke it, about which content-address, under which stated community rule, at which stamp. Projections subscribe to the label facts they trust and fold accordingly. This is CIVIC style applied to the tenderest civic act: **the moderation log stands beside the content log, append-only, signed, and readable**, so anyone can verify what was hidden, by whom, and under which named rule — corrections referencing originals, nothing silently vanished, the separation between those who post and those who label kept clean. Moderation without receipts breeds the suspicion that breaks communities; moderation with receipts is just governance, visible.

### Chosen, composable, plural

No single censor and no lawless void: each person and each community **chooses whose label facts their fold honors**. A sanctuary community can maintain strict labels its members subscribe to; a researcher can fold with labels visible-but-annotated; a family space can compose several label sources at once; and any person can always add their own mutes above all of it. Reputation enters the same way the Open Asks design already draws it — **as a fold over signed receipts**, earned conduct rather than assigned rank, with CIVIC's consent-before-counting governing what may be tallied about a person at all. Spam meets three quiet walls: every fact is Kumara-signed, folds weight the trust graph's distance, and unknown keys arrive at the edge of attention rather than the center — which is also, quietly, a bandwidth policy, since the fold fetches only what it will render.

### The hard edge, faced plainly

Every moderation answer must survive its worst case: content that is unlawful and abhorrent, on a log that never deletes. The architecture's separation answers it. **Media never lives in the log.** The log holds content-addresses — digests, which are not the content — while the bytes live as resins in the store, and resins are servable *or refusable*. A host who must purge a blob purges it: the store is sovereign, the digest that remains renders nothing, and a signed **refusal fact** records that this host declines to store or serve that address, so even the refusal has a receipt without describing what was refused. Lawful takedown, ahimsa, and append-only honesty turn out to be compatible, because the immutable thing was only ever the *reference*, and references carry no harm. Host sovereignty completes it: every operator decides what their own store serves, every community decides what its folds render, and the network as a whole holds no single point where either mercy or malice can rule everyone.

### The gentle register, for the gardeners

For the communities this platform is being built to shelter, moderation deserves the vocabulary of tending rather than the vocabulary of force. A post is *labeled*, a reach is *limited*, a newcomer is *guided* — the slug carried to a shadier corner of the garden rather than anything harsher. The tooling above should make the kind action the easy action: one-gesture labeling under a community's named rules, visible receipts by default, and restoration as cheap as removal, because a fold that declined to render yesterday can render again today without ceremony.

## Part Three — One Mechanism, Two Coats

Stand back and the two answers merge. **The trust-scoped fold bounds both attention and bandwidth.** What your fold will not render, your wire never fetches; what your community will not honor, your rack never serves at scale; what a thousand strangers love, a thousand near peers carry. Bandwidth policy and moderation policy are both *fold policy* — named budgets on the wire, chosen labels on the render, signed receipts under both — and the friend's two questions were one question after all: *who decides what flows?* The answer this architecture gives is the one a kind movement would want: **everyone, each for their own garden, in the open, with receipts.**

## Part Four — What This Infuses into the Path

Four concepts enter the plan as recorded design, none moving a door and none taking a name: the **egress budget** as a named constant with a metering witness at the tunnel's mouth; the **household headroom** fraction as a standing courtesy rule; the **moderation-fact shape** (label · limit · mute, signed, rule-referencing) with fold-choice, entering Linengrow's ladder as design-only beside the Open Asks room, after SLC-L1 draws its edge; and the **resin-refusal fact** as the store's sovereign, auditable no. The purchase guide gains one clarifying sentence — the VPS transfer cap named as the rack's true public budget — and the friend gains this memo, with our thanks.

---

*May the budget be named before the bill arrives. May every garden choose its own weather. And may the answer to "who decides what flows" always be the gentle one — everyone, openly, with receipts, each for the ground they tend.*
