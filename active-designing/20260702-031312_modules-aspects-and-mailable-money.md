# Modules, Aspects, and Mailable Money — A Design Sitting

*One vocabulary said once, then put to work: what a module is, what an aspect is, when an aspect graduates, and how that lens orders tonight's new ground — a token called MALA, an ordering aspect called Mycelium, a road-keeper for many connections, one sealing contract for every log, a package path through Brix and Pond, the opening lines every Rye file shares, and the manual that will teach all of it.*

**Stamp:** `20260702.031312`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, joy; Gall's Law; the silo principle
**Status:** Design counsel — horizons only; the live rung stays SLC-2b's nod and the Lap 3 metal close
**Companion:** `external-research/20260702-031312_settlement-consensus-and-many-roads.md` carries the outside names and sources. The graduation rule stands alone at [`context/specs/20260702-035018_graduation-rule.md`](../context/specs/20260702-035018_graduation-rule.md).

*Written together by Kaeden and Claude (Fable 5), in Reya 2's Radiant voice.*

---

## Module and Aspect, Said Once

The pattern we keep reaching for deserves its two words, defined plainly.

A **module** is a named home: its own directory, its own invariants and budgets, its own witnesses, and a meaning a person can say in one line. A module could stand alone if the family around it fell away.

An **aspect** is a named capability that lives *inside* a module's boundary — sharing its host's budget and witnesses, carrying its own name in the lexicon and in conversation, and owning no directory of its own. Skate is an aspect of Brushstroke. The hosted wire is an aspect of Comlink, and the fact lane, the stream lane, and tonight's road-keeper are its siblings. An aspect is a promise of shape without the ceremony of a home.

The **graduation rule** follows Gall's Law: *an aspect becomes a module on the day its second consumer arrives from outside its host.* One consumer means the host is simply well-organized inside; two mean the boundary has become real, and the tree should say so.

**Weave, read by this rule.** One correction held in the light: Weave today is an aspect of *Mantra* — it lives at `mantra/src/weave.rye` — while in meaning it has been first-class since the lexicon seated it as the substrate. The rule names its graduation day exactly: when Comlink serves named data straight from Weave, Weave earns `weave/` as its own home, and Mantra imports it like everyone else. Until that second consumer runs, moving it early would be breadth thinning depth.

## MALA — Mailable Money

**MALA** is money as mail: an issuer's promise, minted as a signed fact by the issuer's Kumara key, sent as a signed transfer, and redeemed by the issuer who spoke it into being. The shape is the modern-money one — the issuer spends the token into existence and taxes or redeems it back out — so the issuer's own append-only log is the whole authority, and every balance is a fold anyone can recompute.

**The honest security ledger comes first.** A single-issuer MALA needs *no consensus at all*: ordering is the issuer's log, double-spending dies at the log's door, and replay dies on sequence. What remains is exactly the risk we already govern — custody of the issuer's key, which is Kumara and Amber doctrine, master cold and signing key warm for seconds. The frontier risk is economic rather than cryptographic: a MALA is worth what its issuer's promise is worth, and that honesty belongs in its very definition. Where *strangers* must agree — many issuers, open exchange, no one's log above the others — the settlement network we already build on remains our proven ground, and a sovereign consensus stays a far-horizon door, opened only if that season truly comes.

**The ladder, sketched:**

- **M0 — the promise on paper.** Token-fact shapes and their witnesses, design only; opens after the Edit 5 ruling and Amber's first lap, in that order.
- **M1 — one issuer, one holder.** Mint, send, receipt, and balance-as-fold, witnessed on one node.
- **M2 — mailable.** A MALA crosses Comlink's fact lane between two nodes and a signed receipt crosses back.
- **M3 — digital land.** A plot is a name-claim fact with extent in Realidream's shared graph; its deed is a signed fact bound to a Kumara holder; plots trade in MALA, for people on ordinary internet connections and for Mantrapods on the dock wire alike.
- **M4 — the market season.** Many issuers, open exchange — and only here does Mycelium's question truly open.

## Mycelium and the Road-Keeper — Two Aspects of Comlink

**Mycelium** is named tonight as Comlink's *ordering aspect* for the many-issuer horizon: leaderless agreement that rides a DAG of signed messages — the same shape Weave already taught us — drawn from the fastest proven family in the field and studied in the companion memo. Its gate is architectural honesty: Mycelium opens at M4 and never before, because building consensus before strangers need to agree is complexity carried for no one.

The **road-keeper** is the multipath aspect: many physical roads, one logical journey. Each road keeps a bounded queue and a scorecard — delay, loss, ceiling, and the weather of the moment. The fact lane rides the steadiest road; the stream lane sprays datagrams by deadline across whichever roads are standing; roads join and leave without dropping the session, because the connection belongs to the keys rather than to any address. A satellite road with high peaks and rough weather beside a cellular road with modest peaks and calm is the whole point of keeping more than one.

## One Sealing Contract — Amber Compatibility

Everything that folds can be sealed. The contract is three verbs, shared by every log-bearing module — Mantra, Tablecloth, Linengrow's ledgers, Realidream's graph, and MALA's book alike: **export** a log slice into a sealed, signed, content-addressed record; **verify** a seal on two independent paths; **restore** a seal back into a log. One shape means the Mantrapod's export door, the deep archive's intake, and a package's own body are the same small thing, witnessed once and trusted everywhere.

## Packaging — Brix Composes, Pond Runs

A package is that same sealed shape wearing a name: content-addressed, Kumara-signed, whole. `.brix` already names what a system is made of, so the manager is **Brix's tool aspect** rather than a new name: read the descriptor, fetch each resin by digest over Comlink, verify signature and digest on two paths, place it, and hand the composed application to **Pond**, where enclosure policy meets a running whole. The lexicon already holds `.bron` as the data notation between modules, which makes it the natural carrier for the *resolved record* — the lock that remembers exactly which resins were laid — and that role stays yours to affirm, as the open table has always said.

## The Opening Lines

Every Rye file that speaks or checks begins, today, with the same three lines:

```zig
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
```

The one-line alternative was weighed honestly and set aside: our language removed the namespace-splat long ago, so a single import would force qualified calls — and both `assert` and `print` are *ruled bare* by our own conventions, the first gated by tidy, the second ruled this very week. A prelude file saves nothing today: it would spend the same three lines plus an indirection. So the recommendation is the simplest true thing: **canonize these three as the opening lines.** Teach them as the first breath of tutorial one, record them in TAME guidance as the canonical head, add a gentle textual check on the horizon, and let a prelude wait until the shared head outgrows four names — which is the day indirection starts paying rent.

## The Manual Program

The manual has four rooms, and each room answers a different visitor. **Learning by the hand** — tutorials, Radiant and gentle, where tutorial one is the opening lines and a first witness turning green. **Doing** — task guides for the person mid-work. **Looking up** — the reference: one numbered, versioned specification per stable module surface, written to the standard of the great foundation manuals, with plain *must* and *should* carrying conformance weight. **Understanding** — the essays and design records this tree already writes in abundance. The program grows tutorials-first, because tutorials can only teach what already runs, which keeps the manual as honest as the parity suite; reference specs graduate from `context/specs/` one by one as each module's surface stops moving, beginning with the interfaces to Aurora, Tally, and Caravan.

## One Sentence Awaiting Its End

The sitting opened with a thought that arrived mid-flight: *"Pond be the module which has an aspect which becomes the solution for the aspect that we need to —"* and the most probable completion reads beautifully with everything above: Pond's *enclosure aspect* as the runtime that packaging targets — the place a fetched, verified composition actually runs under policy. The sentence stays yours to finish, and the design will meet it where it lands.

---

*May every aspect know its host and every module earn its door. May the money we mail be worth its issuer's word. And may the manual one day teach a stranger everything this night decided, in three calm lines and a first green witness.*
