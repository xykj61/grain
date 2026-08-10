# Pool — a Gall-Expanded P-Vane for a Content-Creation Computational Data Market

> **Writing fossil (molt `20260810`).** Pool has retired into **Pond**, Grain's application module — the "P-vane" framing was a vane-grid vestige the reframe released. Living path: [`../foundations/20260810-011514_pond-the-application-module.md`](../foundations/20260810-011514_pond-the-application-module.md). This study is kept readable, its good thinking preserved (the market surfaces it named — Granary, Mandi, Open Asks, MUR, Neth — now run as apps in Pond); nothing here is a living claim. Accrete-never-break: the body below is unchanged.

**Language:** EN
**Version:** `20260714.040518` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Vision register — design and research; a proposal; no vane code written; name awaiting confirmation. Register: this is design (Two Rooms — a proposal, not a bound claim). Addressed to a generic Acme Corporation employee.
**Grounds on:** the collision search below (whole `old/` tree), `../context/specs/20260714-002123_naming-decisions-and-role-nesting.md` (module-as-name, vane-as-role), the Linengrow foundations (secularized here), and the existing market surfaces (Granary, Mandi, Open Asks, MUR (was MALA), Neth).

Radiant pass `20260728.050219` — living rename-forward: **MUR** (was MALA)
---

## First, the Collision Search (as required before proposing the name)

The name **Pool** was checked against the whole `old/` tree — the full `urbit/urbit` kernel and userspace, the `urbit.org` docs, and the nested `nockchain` project — for any use as a Hoon term, mold, arm, or module. The finding, stated plainly:

**In the Urbit kernel — Arvo, Zuse, Hoon, Lull, and all ten vanes (`old/pkg/arvo/sys/`) — "pool" does not appear at all. Zero uses.** A vane named Pool collides with nothing in the kernel it would live beside; it is as unclaimed there as Neth and Ojjo were.

Every actual occurrence of "pool" in the tree is incidental or external:

| Where | What it is | Bearing on a Pool vane |
|---|---|---|
| `pkg/arvo/lib/claz.hoon`, `ted/bridge/claz-prep-command.hoon` | `pools` / `get-pool` — faces mirroring the **Azimuth Ethereum contract's** star-delegation `pools()` function | A Solidity function name echoed in bridge code; not an Urbit-native term. No conflict with a vane. |
| `pkg/landscape/app/pool-group-hook.hoon` | a legacy Landscape userspace app ("invite pool") | Userspace, deprecated Landscape; a filename, not a kernel term. |
| `pkg/arvo/app/acme.hoon` | one English comment, "add nonce to pool" | Incidental prose in the Let's Encrypt ACME app. |
| `pkg/base-dev/lib/bip39/english.hoon` | "pool" as one of the 2,048 BIP39 wordlist words | Purely incidental. |
| `nockchain/.../codegen/gene.hoon`, `degen.hoon` | `+$ pool` — a compiler register/subject-use mold | A *separate project's* internal codegen type; not urbit/urbit, not a concern for a Glow vane name. |
| `urbit.org/content/grants/…`, `blog/…` | "pool" in grant/blog prose (mining pools, liquidity, etc.) | Incidental English in docs. |

**Rename manageability: there is nothing to rename.** Because the kernel has zero "pool" usage, proposing Pool as a vane is a clean, additive naming act — no find-replace, no cross-reference churn, no manageability problem at all. (One small note worth flagging for amusement and clarity, not conflict: `pkg/arvo/app/acme.hoon` is Urbit's Let's Encrypt **ACME** app — unrelated to this project's "Acme Corporation" generic-employee placeholder. Same four letters, different thing; neither touches Pool.)

## What Pool Is

**Pool is the proposed P-vane** — the next in the vane sequence (…Lick·L, Maze·M, Neth·N, Ojjo·O, **Pool·P**), four letters like every vane. It is a **Gall-expanded** vane: where Urbit's **Gall** is the vane that hosts userspace agents, Pool is Glow's parallel to that role, *expanded and headlined* toward one purpose — **a content-creation computational data market**. The market's application surfaces run *as agents inside Pool*, the way Gall hosts agents; Pool is the host and the market fabric, not a replacement for the surfaces already named.

The name earns its place by teaching its function, the way the LEXICON asks. A **pool** is where things gather and are shared from — and that is exactly what this vane is: a place where **content is pooled** (creators' work), **data is pooled** (what that work produces and describes), **computation is pooled** (the compute that transforms and serves it), and **demand is pooled** (buyers meeting sellers). The reading to hold is the *shared-resource* pool — a commons things are drawn from and returned to — rather than the memory-pool or liquidity-pool senses the word also carries (named here so the ambiguity is chosen with open eyes, not stumbled into).

## The Secular, Acme-Generic Restatement of the Foundations

Linengrow's foundations describe this market in a specific, values-laden register — vegan musicians, activist creators, sanctuary donations, a particular conscience. Pool's design **secularizes that vision** into the general shape any Acme Corporation employee can build on, keeping the load-bearing structure and setting down the specific register (per the generic-Acme-voice rule). Stated generally:

- **A content-creation computational data market** is a place where a *maker* offers content, data, or a computation over them; a *consumer* obtains access under clear terms; a price is struck; and the exchange settles with a verifiable receipt. Nothing about it requires any particular kind of maker or cause — it is the general mechanism, offered to anyone.
- **The mechanism is transparent; the individual is private.** The market's rules are visible to everyone — every offer wears its terms, every sale carries its receipt, every contract shows its expiration — because the honesty of the room is the market's whole promise. The person stays private by default, revealing only what they choose through a zero-knowledge proof. (Linengrow's own framing, restated for any market, any participant.)
- **Everyone owns their side.** A maker owns their content and their data in a portable server they carry; a consumer owns what they bought; the market owns no one's graph. Ownership is a key, not a login.
- **The market composes what already exists** — it invents no new primitive:

| The market needs | Glow OS already has | Role in Pool |
|---|---|---|
| Money | **MUR (was MALA)** (own-issuer, M1/M2 landed) | prices and pays |
| Settlement with finality | **Neth** (the settlement N-vane) | clears the trade |
| A named sharing surface | **Granary** (namespace / sharing / exchange) | lists and shares the goods |
| A market floor | **Mandi** (vessel market floor) | where offers meet demand |
| A civic ask loop | **Open Asks** | commissions and bounties |
| Sealed delivery | **Comlink** | delivers identity to identity |
| Amount/term privacy | **Sigma / Pedersen** (SLC-L4) | proves without exposing |
| Verifiable receipts | **SLC-L1 receipt** | proves the trade happened |
| Identity | **Kumara** | roots every party |
| Books | **Dimeroll** | records the ledger |

Pool is the **vane that hosts and composes these into one market** — the Gall-role that runs the market's agents (Granary, Mandi, Open Asks, and Linengrow itself) on one spine, so a content-creation computational data market is a thing Glow OS *runs*, not a thing bolted beside it. Linengrow remains the values-specific flagship built *in* Pool; Pool is the general market fabric beneath it, describable to anyone.

## My Honest Opinion (as asked)

**I like it — with one framing refinement and one ambiguity named plainly.**

What is genuinely strong:
- **It is architecturally honest.** A market is a userspace-agent concern, which is exactly Gall's domain — so a Gall-expanded vane is the *right layer* for it, not a category error. Positioning Granary/Mandi/Open Asks as agents *in* Pool (rather than peers beside it) finally gives the scattered market surfaces one named home, which is real organizational value.
- **The collision result is as clean as it gets.** Zero kernel usage means Pool is a free, additive name — no rename, no churn. That is the cheapest possible naming act, exactly the manageable-PR shape the vane proposals aim for.
- **The name teaches its function** in the shared-resource sense — content, data, compute, and demand pooled in one place — and it fits the P slot in the sequence.

The refinement:
- **Say clearly that Pool is the userspace-application vane whose *headline* is the market, not a market-only sub-vane.** Gall hosts all agents; if Pool is "Glow's Gall," it hosts all userspace, and the data market is its flagship expansion rather than its sole purpose. I would frame Pool as *the* application vane, with the content-creation data market as the first and defining thing it is built to run — so it does not accidentally narrow to "only a market" and leave other userspace homeless.

The ambiguity named plainly:
- **"Pool" is a very common systems word** — memory pool, thread pool, connection pool, liquidity pool, mining pool. In Urbit it is unclaimed, but in the wider world it is heavily loaded, and a reader could first hear "liquidity pool" (DeFi) or "memory pool" rather than "the place content and compute are pooled." This is the same shape of consideration as Glow (unclaimed in Urbit, loaded outside). It is not disqualifying — the shared-resource reading is apt and the DeFi echo is even faintly on-theme for a market — but the docs should lead with the shared-resource meaning every time, so the intended sense wins.

**Recommendation: confirm Pool as the P-vane — framed as Glow's Gall-role application vane whose defining expansion is the content-creation computational data market, with Granary/Mandi/Open Asks/Linengrow as agents that run in it.** The collision search makes it a free, clean name; the architecture is sound; the one care to take is leading with the shared-resource meaning so the common-word ambiguity resolves the right way. Denying it is reasonable only if you would rather the market surfaces stay peer modules with no hosting vane — but I think naming the host is the more legible choice, and "Pool" fits it well.

## Resolved (`20260714.050500`)

- **The name Pool is confirmed** (`20260714.042545`), as the P-vane — recorded in [`../context/specs/20260713-235600_names-awaiting-confirmation.md`](../context/specs/20260713-235600_names-awaiting-confirmation.md) and `../context/LEXICON.md`.
- **Framing confirmed:** Pool is Glow's **whole application vane** — the full Gall-role, hosting all userspace — with the content-creation data market as its headline, defining expansion, not a market-only sub-vane. This adopts the refinement named in the honest opinion above.
- **Build timing confirmed:** seated **now** as a named horizon vane; Granary, Mandi, Open Asks, and Linengrow move in as agents *in* Pool once Glow can host an agent.
- **Now or horizon?** Like Ojjo, Pool has little to host until Glow can run an agent; is it seated as a named horizon vane now, or deferred until the agent runtime exists?
- **Relationship to Linengrow and the market surfaces** — confirm that Granary, Mandi, Open Asks, and Linengrow are agents *in* Pool rather than peers beside it.

---

*May the pool be a commons and not a moat — a place where content, data, and compute gather to be shared under clear terms, owned by the ones who bring them, and drawn from in the open.*
