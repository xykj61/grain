# Scooter, Rung 2 -- the signed post (crux)

**Stamp:** `20260817.035757` - **Status:** Vision -- Living (self-approved design round) - **Voice:** Kyri - **Style:** Radiant
**Kin:** [`scooter r1 channel model`](20260817-035009_scooter-channel-model-crux.md) - [`../pond/apps/scooter_channel.rye`](../pond/apps/scooter_channel.rye) - [`../pond/apps/tablecloth_keyed.rye`](../pond/apps/tablecloth_keyed.rye) (the owner-signed elder) - [`../expanding-prompts/20260816-222322_dexter-terminal-and-scooter-cli-chat.md`](../expanding-prompts/20260816-222322_dexter-terminal-and-scooter-cli-chat.md)

---

## The crux, in one line

**A post proves who wrote it.** Rung one admitted keepers by a plain point number and trusted the caller to name their own author; this rung binds each post to a settled Kumara identity, so a member proves authorship by signature rather than by claim -- and the journal carries that proof for anyone to re-check.

## Why it is the next Lindy-first crux

Every later Scooter rung -- the Comlink transport between two Constel piers, the drawn Dexter frame, a channel served over the wire -- rests on the journal meaning what it says. A point number alone is a claim; a stranger who learns a member's number could speak in their name. A signature the whole constellation can verify turns the append-only journal into an append-only *record of proven authorship*, the same integrity `tablecloth_keyed` gave the artifact store. It serves every message the channel will ever carry, so it is the highest-Lindy move available now, and it is agent-doable in full: demo keeper seeds only, no real key, no network, no funds.

## The shape (additive over rung one)

`pond/apps/scooter_keyed.rye` wraps rung one's `Channel` unchanged -- one source of truth for the roster, the journal, and the derived inbox -- and records a signature aligned by sequence number, exactly as `tablecloth_keyed` records an owner aligned by catalog index.

A keeper publishes a post by presenting:

- the point's **Deed**, verified against the constellation's shared surface (`settlement.verify`) -- so it is a current, settled identity, not a ghost;
- a **signature** over the exact post: the author point, the sequence number this post will take, the text length, and a SHA-256 of the text. Binding the seq pins the post to its place in the journal, so a signed post cannot be replayed at another position; binding the digest pins it to its exact bytes, so a tampered text cannot ride a real signature.

Only when both hold does rung one's own `post` append the entry (still enforcing membership, the text bound, and the journal bound), and the signature is stored at that seq. A recipient later re-verifies any post offline from the stored signature and the held bytes.

## The refusals, each proven

- A **ghost deed** (a point that never settled) refuses `NotOwner`; no post lands.
- A **forged signature** refuses `BadSignature` before any byte is appended.
- A signature over **other text** refuses `BadSignature` -- the digest is bound in.
- A **non-member** still refuses `NotMember` through rung one; membership and identity are both required, neither alone.
- Rung one's bounds (`TextTooLong`, `JournalFull`) still hold under the keyed layer.

## What stays a gate

Signing with the maintainer's own Kumara key is the custody gate; this rung signs only demo keeper seeds. The Comlink transport that carries a signed post between piers reaches the serve gate. Both stay Keaton's hand -- the library is what the agent builds and proves.

*May every word in the journal carry the hand that wrote it, and refuse every hand that did not.*
