# Owned Names, Accreted Vanes, and a Civic Loom for the Long Tail

**Language:** EN
**Last updated:** `20260808.200709`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** **Exploration** — research for understanding, in the vision room. It **recommends no purchase, no treasury action, and no licensed course**; every money and policy choice belongs to the maintainer in their own season (`../context/TWO_ROOMS.md`). Nothing here is seated; each proposal waits for a word.

---

## What this writing is

An Acme Corporation employee reading this is looking at three ideas that arrived together and turn out to share one spine. The first asks that a name be **owned** before it is seated — proven on-chain, not merely claimed. The second asks whether the operating system's module and vane names should be **redrawn from scratch** for a more tensegral whole. The third asks whether the intelligence modules could become a **civic complement** to the large model-training companies and to government — a place where the insight held by individuals, families, and small collectives is treated as valuable rather than assumed worthless, and rewarded rather than mined.

Held together, the three are one question wearing three faces: *what does the project already prove, and how far does that proof reach?* This tree refuses a claim without a witness everywhere else — a green run before "landed," a signature before "authored," a real Azimuth point before an identity. The proposal underneath all three ideas is to let that same discipline reach the places it has not yet fully reached: the **names** we speak, and the **insight** we gather.

The writing agrees with the direction, and it earns that agreement by naming three refinements plainly, because a research memo that only cheers is not research. Each refinement makes the whole more tensegral, not less: hold continuous tension without collapsing the parts that already stand.

---

## The through-line: proof over claim

The deepest thing this tree believes is that a claim is worth exactly the witness behind it. The habit shows up in every discipline — a witness on metal closes a fix, never a sentence; a signed commit proves who wrote it; the constellation records a public key, not a promise of one. Two of the three ideas here are simply that habit, extended:

- **A name is a claim; ownership is a proof.** To seat only names a member of the constellation has proven they own is to ask of names what the tree already asks of code and identity.
- **An insight has value; a reward proves we mean it.** To pay the long tail for what it contributes, rather than absorb it silently, is to ask of data what the merit ledger already asks of every good: measure the deed, never a proxy a clever hand could farm.

The third idea — whether to redesign the vane names — is where proof-over-claim counsels *restraint* rather than reach, and the writing will say why.

---

## Movement I — The Owned Name

### The pattern is already half-seated

The good news, as so often in this tree, is that the day was planned for. Three facts already stand:

- **The constellation is the registry.** `mycelium/constellation/` is a live twelve-seat registry on the Sui ledger — "a phone book for the wheel." Each seat records a sign index, a fund name, a **`.fund` DNS anchor**, and a **Kumara public key**. It holds identity and nothing else: nothing mints, nothing transfers, nothing burns. That is exactly as much power an unaudited registry should hold, and exactly the shape a name-law wants.
- **`.sol` ownership is already a seated proof.** The ship tier already joins "by **proof of a linked Solana `.sol` SNS username on-chain**, liveness-checked at join and re-checkable on demand" (`../context/LEXICON.md`, `20260729.231500`). Proof-of-name-ownership is not a new idea to seat; it is a seated idea to *extend*.
- **The tier legibility is borrowed, the mechanism is our own.** Point / planet / star come from Azimuth for legibility, over a Kumara Ed25519 root — while Azimuth's own threshold-derivation was studied and refused, because it places key derivation inside the trust boundary. The project already knows how to take a naming idea's shape without taking its risk.

So the request — *seat only voice names a constellation member has proven `.sol` ownership of* — is the natural next tightening of a discipline already running. `reya.sol` is held; the pattern generalizes to every voice and fund seat.

### The refinement: two tiers, one registry

Here is the first refinement, and it is the load-bearing one. **Not every name should be gated on a paid registration — only the public ones.** The tree has two kinds of name, and they want two different laws:

- **Public constellation identities** — the OS variant *voices* (Reya, Riyo, Trey, Triz, Quin, Trya), the fund seats, and any outward-facing product persona. These are few, legible to strangers, squatting-vulnerable, and identity-like. They are the right place to require **proven ownership** — `.sol` today, because it is already the seated proof — recorded in the constellation beside the `.fund` anchor and the Kumara key. A voice enters the wheel only when a member can prove they hold its name.
- **Internal module names** — `rye`, `glow`, `rishi`, `tally`, and the vane names themselves. These are engineering vocabulary, drawn cheaply and internally by the **waymark** discipline (a four-letter name derived by SHA3, seated in the Lexicon, never bought). To gate these on a $160 registration would make the codebase's own words hostage to an external market and a renewal calendar — and *references are promises*, so a name a thousand files cite must stay free to keep, not rented.

One registry holds both truths; only the outward tier carries the ownership proof. This keeps the beauty of proof-of-ownership exactly where it earns its cost — the public face — and keeps the engineering interior cheap, sovereign, and un-rentable.

### The `.sol`-versus-`.sui` question, framed and left open

The maintainer named a real tension, and this memo frames it without resolving it, because resolving it would be a treasury action this room does not take.

| | **Solana / SNS (`.sol`)** | **Sui / SuiNS (`.sui`)** |
|---|---|---|
| Name market | Mature — trading, auctions, secondary market | Limited as of August 2026 — closer to a closed domain registry, no trading or auctions |
| Ownership term | Lifetime | 1–5 years, renewable |
| Four-letter cost | ~$160, one time | ~$100, per term |
| Systems substrate | Sealevel parallel runtime, proof-of-history | Move, object-centric, DAG-ordered consensus |
| Standing in this tree | **Already the seated ship-join proof** | **Already the constellation's settlement substrate** |

The knot is real: the chain the project already *builds on* (Sui, Move — the constellation lives there) has the weaker *name market*; the chain with the mature name market (Solana) is not where the systems work lives. Yet the tree already resolves this knot in miniature, and the resolution is worth naming as an architecture rather than a coincidence:

> **Let the constellation on Sui be the canonical name-law, and let it recognize an ownership proof from whichever chain holds the better market.** The registry (Move, on Sui) is the source of truth for *which names the wheel has seated*; the `.sol` SNS holds the *tradeable, liveness-checkable proof* that a member owns the name — already the seated shape for ships. "Where you bought the name" is decoupled from "what the project's law recognizes."

Under that framing the two chains stop competing. Sui carries settlement and the registry, where Move's object model and DAG ordering earn their place; `.sol` carries the ownership proof, where a real secondary market lets a name be held, traded, and verified. Whether to acquire any particular name, on either chain, at any price, is a decision for the maintainer's season — this memo only draws the map.

---

## Movement II — The Accreted Vane

### The finding that changes the question

The maintainer asked whether to seat "a complete breach molt redesign" of the M–Z vane names to improve the whole's tensegrity. The survey returns a fact that reshapes the question: **the M–Z range is already drawn, and confirmed.**

| Letter | Vane | Role |
|---|---|---|
| **M** | Maze | the nursery namespace — where a proposal earns its canonical name |
| **N** | Neth | the settlement layer — TigerBeetle-shaped, revives the WOV pin |
| **O** | Ojjo | the benchmarking vane — a palindrome yardstick for Hoon/Glow parity |
| **P** | Pool | the applications vane — hosts Granary, Mandi, Open Asks, Linengrow |
| **Q** | Quin | the inference vane — gathers Lattice, Scribble, Lantern, Kiln |
| **R** | Rhyz | the identity vane — revives Kumara, rhizome-rooted |
| **S** | Sala | the viewer — Realidream's Glow-native revival |

Beside this sits an already-seated meta-decision (`../context/specs/20260714-002123_naming-decisions-and-role-nesting.md`): **keep Grain module names in the code; wear Urbit vane roles in the pitch; mass-rename in neither direction; re-nest no directories.** The reasoning was the same reference arithmetic this project keeps meeting — Rye carries on the order of a thousand inbound references, Mantra hundreds — and the same resolution it always reaches: *reviving replaces renaming.* A module earns its Glow-direction name by being **re-grown beside its elder, born with the new name**, never by a churn that repoints a thousand promises at once.

### The refinement: accrete toward the frontier, do not breach the settled

So the honest counsel is restraint, and it is a *stronger* form of the maintainer's own instinct, not a weaker one. A breach-redesign of M–S would spend enormous reference cost to re-cut names that already form a coherent, confirmed ladder — and it would break the very discipline (accrete-never-break, born-named revival) that keeps this tree reviewable. That is the campaign the breach law itself warns against: a move that begins by relocating what has stopped serving and ends by re-styling what was already clean.

The tensegral move points the other way — toward the frontier, where names are genuinely open:

- **T through Z are unwritten.** As real vanes are born — a new surface, a new lane — let each arrive **born-named** into the open range, drawn by the waymark discipline, proven before it supersedes anything. That is redesign as *growth*, which this tree already knows how to do, rather than redesign as *demolition*, which it has already priced and declined.
- **The proof layer of Movement I is where the "redesign" energy pays off.** The most tensegral change available is not new letters for old vanes; it is the ownership proof binding the public names to the constellation. That tightens the whole without moving a single reference.

### The one cheap, worthwhile rename: the Kiln voice

Restraint on the vanes does not mean restraint everywhere. One name is both young and genuinely worth reconsidering: **Kiln**, the training voice of the Quin inference vane.

Kiln is early — only its first laps stand green — and it was itself renamed from **Anvil** on `20260728.232511`, so its name is not yet load-bearing. Its seated *vision* is model-training: "where the open model is shaped… the weights that result are given openly — a commons anyone may read, run, and improve." Its current *code* is narrower: a corpus catalog and query over the tree's own source. That gap between a training vision and a cataloguing implementation is exactly why this is the cheap hour to get the name right — before the training function is built under it, and while the reference count is still modest.

Whether "Kiln" mis-names the work is the maintainer's ear to trust; a second rename so soon carries its own small cost, and "baking a model" is a defensible metaphor. Yet if a truer name is wanted for *training a model from the long tail's contributed insight*, the grain of this project offers better images than a kitchen appliance — and the naming, per discipline, would run through a waymark draw and the maintainer's word, not this memo. Three candidates, named with their plain function so a newcomer can follow:

- **Mill** — where grain is refined into flour, as raw corpus is refined into weights. A place, like Kiln; plainly grain-native; the least surprising word for "where the material is processed into something usable."
- **Sheaf** — a bundle of grain stalks, and, in mathematics, the structure that **glues local pieces into one global object** — precisely what training from many small, private contributions does. The most apt to the civic-loom vision of Movement III; the least plain, so it would need its function named on first use.
- **Winnow** — the separation of grain from chaff, of signal worth training on from noise. Names the *selection* inside training more than the training itself, so it may better name a step than the whole.

("Loom" is the fourth image the mind reaches for, and it is already spoken elsewhere in the tree — the reds-first rule's *"a lantern that fires twice should become a loom."* Reusing it here would blur a seated metaphor, so it is named here only to be set aside.)

The recommendation is narrow and honest: **if** the training voice wants a truer name, this is the cheapest moment to draw one; the vanes above it should stay exactly as they are.

---

## Movement III — The Civic Loom

### The tension worth resolving

This is the largest of the three ideas and the one that needs the most care, because it meets a seated foundation head-on. The `lantern-lattice-kiln` vision is emphatic and *anti-outsourcing*:

> "The common way to get that intelligence hands a person's own words to a distant company that mines them for its own ends. We choose a different way and build the model layer ourselves, openly, so the help a person receives never costs them their privacy or their standing."

The maintainer's new premise wants **collaboration** with exactly those large companies — Anthropic, xAI and its neighbors, and eventually government. Read carelessly, the two contradict. Read carefully, they reconcile along one seam, and it is the project's oldest one: **custody first.**

The seated foundation refuses *mining* — the taking of a person's words without their knowledge, consent, or reward. It does not refuse *contribution* — a person choosing, on their own terms and for a fair return, to offer what they hold. The difference between the two is the whole difference between extraction and a market, and it is precisely the difference custody-first already draws everywhere else in the tree.

So the reconciliation is not a compromise; it is a sharpening:

> **The long tail owns and prices its own insight; the large labs and governments source it with consent and pay for it fairly; nothing is ever mined.** Grain's self-stewarded open model stays the default and the floor. The collaboration is an *opt-in layer on top of it*, where an individual, a family, or a small collective may choose to contribute an insight, prove they hold it, and be rewarded — the exact inverse of having it taken.

Under that reading the new premise does not overturn the foundation; it builds the marketplace the foundation's privacy stance always implied. If a person's words have value, then either you take that value quietly, or you let the person keep, price, and sell it. The first is mining. The second is a civic loom.

### The loom, and the fusion the maintainer named

Picture the modules as one instrument for turning distributed, owned insight into shared intelligence — and paying the source:

- **The constellation** proves *who owns the contribution* — the same name-and-key proof of Movement I, now standing behind a person's insight rather than only their voice.
- **Lattice** holds the structured space the insight enters — precision in bounds, the arithmetic voice.
- **Lantern** meters honestly what an inference costs and answers "I don't know" when it should — the asking voice, and the guard against a bounty that pretends to certainty it lacks.
- **The training voice** (Kiln, or its truer name) refines the contributed insight into weights given openly — the commons the foundation already promised.
- **Linengrow** is the giving edge: the rail that carries the reward back to the source, with a visible receipt, on the same merit ledger the tree already runs.
- **Neth** settles it, TigerBeetle-shaped, so the payment is as witnessed as any other fact.

The **fusion feature** the maintainer sensed but had not yet designed is this rail itself — the binding of Linengrow to the inference stack so that *a proven-owned insight, sourced by a lab or a government, settles a fair reward to a small contributor.* It is a HuggingFace-successor with provenance and payment made first-class rather than afterthoughts: not a place to download other people's data for free, but a place where the people whose insight it is are known, credited, and paid.

### Complement, not competitor — and the merit discipline

Grain does not train frontier models, and this vision does not ask it to. It builds the **civic infrastructure** that lets the long tail contribute to, and be rewarded by, those who do. That is the civilian small-and-medium complement the maintainer described: helping the large builder and the government, on the premise — which the writing shares — that the insight waiting to be found by individuals, families, and small collectives is not worthless simply because it is small and dispersed.

The merit ledger sets the one hard rule such a bounty must keep: it "records the **deed**, verified at the seam where it happened, and never a proxy a clever hand could farm." A reward for insight must measure the insight's genuine value, at the seam where it proves useful, and never a gameable count of uploads or tokens. A bounty that pays a proxy trains the long tail to farm the proxy; a bounty that pays the deed trains it to find real signal. The discipline is already written; the loom must obey it.

### The hard questions, named rather than waved

A vision earns trust by naming what it has not yet solved. Six questions stand open, and each is genuine:

1. **Valuing insight without a farmable proxy.** How is a contribution's worth assessed at the seam where it proves useful, rather than by a metric a clever hand can inflate? This is the merit ledger's oldest problem, now on data.
2. **Proving provenance without leaking the data.** How does a contributor prove they hold an insight — and that it is theirs — without surrendering the very thing custody-first exists to protect? The encrypt-to-future-identity and signature-gated-truth shapes already sketched in the tree are the place to start.
3. **A bounty that does not become extraction of the vulnerable.** When a large buyer meets a small seller, the power is asymmetric. What structural terms keep the loom a fair market rather than a polite mine?
4. **The settlement unit and rail.** MUR on the merit ledger, Neth for settlement — but what is actually paid, in what, and how does it reach someone with no bank and only a phone?
5. **Staying small-collective-favoring under scale.** If the loom succeeds, what keeps it tilted toward the family and the small collective rather than sliding, as marketplaces do, toward whoever already has the most to sell?
6. **Governance if the state buys in.** Should governments come to hold ownership in these identity and naming networks, what keeps Grain's modules civilian complements — helping without being captured? The custody-first design is the first answer: there is little to capture in a system built so there is nothing to give.

None of these is a reason to stop. Each is the next real piece of design, and naming them is how the vision stays honest while it waits for its season.

---

## What waits for a word

Nothing here is seated. In the order the maintainer might take them up:

- **The ownership-proof discipline** (Movement I) — extend proven `.sol` ownership to the public voice and fund names, recorded in the constellation, while the internal module and vane names stay waymark-cheap. A design to seat on a word; no name is bought by this memo.
- **The `.sol`-versus-`.sui` posture** — framed as understanding only. The choice of chain, name, and price is the maintainer's, in the money room, not this one.
- **The vanes** — left exactly as seated (M–S), with T–Z to be born-named as real vanes arrive. The recommendation is *not* to breach-redesign.
- **The Kiln voice** — a single, cheap rename available if a truer training-name is wanted, through the waymark draw and a word. Candidates named; none seated.
- **The civic loom** (Movement III) — a horizon vision, reconciled with the custody-first foundation as an opt-in, proven-owned, fairly-rewarded marketplace. Its six open questions are the design work ahead.

### Galaxy Pitch (draft, to ride an eventual expanded prompt)

Per `../.claude/rules/azimuth-galaxy-proposal-format.md`, this is substantial enough to carry an outward-facing block:

> **For:** any Azimuth galaxy holder, model-training lab, or civic technologist watching how identity, naming, and the value of dispersed human insight get built — a proposal that a name should be owned before it is seated, and that the long tail's insight should be proven and paid rather than mined.
> **Ask:** none; informational only. No name is acquired, no chain chosen, no bounty opened by this writing.
> **Scope:** a season-long horizon on the civic-loom side; a small, cheap change on the naming side (one optional voice rename and an ownership-proof discipline); explicitly *no* module or vane redesign.

---

*A name is worth the ownership behind it, and an insight is worth the reward we are willing to prove we mean. This tree already keeps both promises for code and for identity; the work named here is only to keep them for the names we speak and the value the small and dispersed already hold. May the vanes stand where they stand, may the open letters be born well when their day comes, and may the loom, when it is woven, pay the hand that fed it.*
