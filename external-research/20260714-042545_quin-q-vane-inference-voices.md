# Quin — a Q-Vane Unifying the Four Inference Voices, and Where the Test-Sandboxes Live

**Language:** EN
**Version:** `20260714.042545` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Design and research — proposals; no vane code. Register: design (Two Rooms — proposals, not bound claims). Addressed to a generic Acme Corporation employee.
**Grounds on:** the collision search below, the inference family already built (`../active-designing/20260710-133500_inference-stack-lap0-hammock.md`), the Neth simulation horizon (`20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md`), and Puddle (`20260702-035018_puddle-sandboxed-rye-containers.md`).

---

## The Collision Search (before proposing the name)

**Quin** was checked against the whole `old/` tree. In the Urbit kernel — Arvo, Zuse, Hoon, Lull, and all ten vanes — **"quin" does not appear at all.** The only occurrences anywhere are inside `pkg/arvo/lib/number-to-words.hoon`, where "quintillion" and "quindecillion" are English number words in a spell-out library — incidental substrings, not a term, mold, arm, or module. **Quin is a free, additive vane name; nothing to rename.** It takes the Q slot after Pool's P (…Neth·N, Ojjo·O, Pool·P, **Quin·Q**), four letters like every vane.

## What Quin Is — the Vane of the Four Voices

The inference family is already four modules, built and green through their lap-0/lap-1 climbs, each a distinct **voice** in the same conversation:

| Voice | What it does today (built) |
|---|---|
| **Lattice** | f32 tensors in bounded gardens — the *arithmetic* voice |
| **Scribble** | markdown → blocks; `rye_fence` / `rish_fence` — the *reading* voice |
| **Lantern** | bounded inference request/response, fixture-served — the *asking* voice |
| **Anvil** | corpus catalog + query over our own `.rye`/`.rish` tree — the *forge* voice |

Today they are peer modules with no named host — the same "scattered surfaces, no vane" situation Pool resolves for the market. **Quin is the proposal to gather them under one vane:** the inference **Q-vane**, Glow's home for local-forge intelligence, under which Lattice, Scribble, Lantern, and Anvil run as the four voices of one instrument. It is governed by **TAME guidance** (safety-first: a bounded tensor, a bounded request, a bounded corpus, every claim witnessed) and sheltered, while it earns its canonical shape, in the **Maze** nursery — the proving-ground namespace exactly meant for a proposal finding its single clear responsibility before it graduates.

The name teaches its function: **Quin** — from the root for *five* — names not four but the *fifth thing*, the unity the four voices make together. Four instruments, one quintet; four voices, one Quin. (It also quietly fits the count: the vane and its four voices are five parts in one.)

## Why a Unifying Vane Helps

- **A named home for the homeless.** Like Pool for the market surfaces, Quin gives the inference voices one place to belong, so "run the forge" is a thing Glow OS hosts rather than four modules wired by hand each time.
- **One law across four voices.** TAME's bounds and witnesses, applied once at the vane, hold for every voice — a bounded tensor and a bounded request are the same discipline seen twice.
- **Maze guidance is the right shelter.** Quin is precisely what the Maze nursery is for: a proposal that gathers real, working pieces while it earns its own single responsibility and canonical four-letter name, then graduates. Nothing about Quin is a junk drawer — it has one clear job (host the inference voices), which is what keeps it out of the anti-pattern Maze warns against.

## The Nested Deterministic-Testing Sandboxes — Where Should They Live?

Keaton's second thread: a home for **agents that spawn agents in sandboxes**, where seeded deterministic testing rides *inside* the prompting — Glow vibe-coding automation, TAME + Maze guided, so a generated attempt is proven in an isolated, ephemeral, reproducible region before it is trusted. Three candidate homes were named (Neth, Pond/Puddle, Quin); here is the honest read of each.

- **Neth** already owns the *seeded deterministic simulation* horizon (from the IronBeetle silo): faults and delays from one seed so a failure replays byte-for-byte. That is the **testing engine** — the deterministic substrate. But Neth's domain is settlement replication, not agent hosting; it should *provide* the deterministic-replay mechanism, not *host* the agents.
- **Pond / Puddle** already own *isolation*: Pond is the enclosure inside one running whole; Puddle is the layer that hosts many isolated Rye wholes as ephemeral, snapshot-able containers, each with its own Kumara and policy. That is exactly "isolated sandboxed ephemeral regions" — the **sandbox** half of the request. Puddle should *provide* the ephemeral enclosure.
- **Quin** (or Pool) is where the **agents** live — inference is what generates the attempts, and hosting agents is a userspace-vane concern.

**The recommendation, stated plainly:** this is not one home but a **composition of three vanes doing what each already does** — the honest Gall's-Law answer rather than a new catch-all:

1. An agent runs under **Quin** (the inference voices generate the attempt — Glow vibe-coding).
2. It is spawned into an **ephemeral Puddle** — an isolated, snapshot-able region with its own Kumara and policy, torn down after (Pond bounds it from the inside).
3. The test inside that region runs on **Neth's seeded deterministic harness**, so the attempt's success or failure replays byte-for-byte and is *witnessed*, not guessed.
4. **Maze** guides the whole loop while it is still a proving-ground pattern; **TAME** governs it (the sandbox is bounded, the test is asserted, the result is pinned, never predicted).

So: **no new vane for the sandboxes.** The capability is Quin (agents) × Puddle (ephemeral isolation) × Neth (deterministic replay), Maze-sheltered and TAME-guided. Naming a fresh vane for it would violate the same "compose what already works, invent no primitive" instinct that shaped Pool. If a single named *pattern* is wanted for the loop, it belongs in the Maze nursery as a proving-ground recipe — not as a canonical vane — until it earns one.

## My Honest Opinion

- **Quin: I like it.** It is the same good move as Pool — a named host for real, scattered, already-working pieces — and the "fifth thing the four voices make" reading is apt and quiet (kernel-free). The one care, as with every common-ish name, is to lead with the four-voices meaning so "quin" is not first heard as just a number-prefix. Maze shelter is exactly right for it.
- **The sandboxes: compose, do not name a new vane.** The instinct to seed nested deterministic testing is strong and correct, but its honest home is the composition above (Quin × Puddle × Neth, Maze/TAME guided), not a new Q-or-other vane. Seeding it "under Neth" is half-right (Neth provides the replay engine); seeding it "under Pond" is half-right (Puddle provides the isolation); the whole is the composition.

## Open Questions (for Keaton's word)

- **Confirm Quin** as the Q-vane and as the unifying host of Lattice/Scribble/Lantern/Anvil.
- **Now or horizon?** Like Pool, Quin has little to host until Glow runs an agent; seat as named horizon vane now, or defer?
- **The sandbox loop** — accept the compose-don't-name recommendation (Quin × Puddle × Neth, Maze-sheltered), or do you want a single named pattern for it in the Maze nursery?

---

*May the four voices find one instrument, may the sandbox borrow its isolation, its agents, and its honest replay from vanes that already hold each, and may nothing be named a new thing that is really three trusted things composed.*
