# Twin Keys and the Exit Bundle — Said Plainly

*A checkable-room note for anyone who hears "dual monarch D1" and wants the picture without a consensus textbook: two signatures, one body, and a way to leave when the ledger goes quiet.*

**Stamp:** `20260709.230414`
**Voice:** Rio 3
**Editor:** Cursor · **Model:** Grok 4.5
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable-room research — explains living practice; cites `linengrow/wov_core.rye` dual path
**Ground:** exit honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md) · dual design [`224531`](../context/specs/20260709-224531_wov-dual-monarch.md) · parity **205** · Pedersen plainly [`200022`](20260709-200022_pedersen-and-sigma-plainly.md) · compass [`185112`](../foundations/20260706-185112_follow-our-compass.md)

*Written by Kaeden and Rio 3 (Grok). Creative climb inside the jail — no TigerBeetle io_uring required.*

---

## In One Breath

A **WOV root** is a signed snapshot of who holds what inside the fast lane. An **exit bundle** is the public table of those balances, hashed into the root, so a holder can prove their row and walk back to MALA even if the monarch never answers again.

**Dual monarch D1** means two named keys must both sign the **same** root fact bytes — twin log lines, one story — before the tree treats that root as current. One key alone is not enough once the instance is dual.

---

## The Everyday Picture

Imagine a community ledger on a fast shelf (WOV). Every so often the keepers publish a **photograph** of every non-zero balance: who has how much, and a small nonce so exits cannot be replayed. That photograph is the **exit bundle**. Its fingerprint (SHA3) is the **state root**.

They also write a short diary line on the slow, honest log (MALA): "root number N for this instance points at fingerprint F." That diary line is the **root fact**. Holders who keep a copy of the photograph can later prove "I had 700 at root N" without asking the shelf again.

With **one monarch**, one signature on that diary line is enough.

With **two monarchs (D1)**, the diary prints the **same sentence twice** — same from/to/memo/amount/stamp bytes — and each monarch signs their own copy. Verifiers accept the root only when **both** signatures check. A lone signature is refused. That is twin keys: two pens, one text.

---

## Why Twin Lines (Not a Third King)

| Choice | Meaning here |
|--------|----------------|
| One monarch | Solo operator; lap 1 and seam A still valid |
| Two monarchs (D1) | Both must attest; availability still rests on the published bundle |
| Three+ | Not WOV — that door is Mycelium at M4 |

Dual control is a **signing policy**, not a second ledger and not Byzantine agreement among strangers. The exit bundle grammar stays the same as lap 1. Conservation still reads: sum of balances = issued − redeemed.

---

## How Exit Honesty Feels

1. Keepers mint and transfer on the fast shelf (in memory, or later via TigerBeetle when io_uring allows).
2. They build the exit bundle and both sign the root fact (D1).
3. A holder verifies both signatures, re-hashes the bundle, finds their row, and may `wov:exit` once against that root.
4. If the shelf goes dark tomorrow, the photograph already in hand is enough for the exit path.

Silence after a published dual root still leaves facts, not hope.

---

## What Lives on Metal (Jail-Friendly)

| Piece | Role |
|-------|------|
| `publish_root_dual` | Bundle + twin log lines |
| `verify_latest_root_dual` | Both signatures or refuse |
| `accept_exit_dual` | Exit against an accepted dual root |
| `tools/wov_dual_monarch.rish` | Witness — parity **205** |
| Seam A projection | TB-shaped balances → same bundle grammar (live REPL skips in jail) |

No new curve. No OR-proof. No Zig client into the pin. Creativity here is **clarity**: the same honesty story, told so a second key fits without inventing a third.

---

## Tiny Glossary

| Word | Plain meaning here |
|------|--------------------|
| Exit bundle | Public balance photograph for one root |
| State root | SHA3 of that photograph |
| Root fact | Signed diary line pointing at the state root |
| D1 twin lines | Two signatures over identical fact bytes |
| D2 envelope | Later shape: one line carrying both sigs |
| Soak | Hold W1 / seam B until a reopen trigger |

---

## What to Read Next

- Exit honesty law: [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md)
- Dual design + D1 land: [`224531`](../context/specs/20260709-224531_wov-dual-monarch.md)
- Sealed envelopes (SLC-L4): [`200022`](20260709-200022_pedersen-and-sigma-plainly.md)
- Parity as green light: [`194437`](20260709-194437_what-parity-is.md) (count now **205**)
- Navigation habit: [`185112`](../foundations/20260706-185112_follow-our-compass.md)

---

*May two pens guard one sentence without inviting a crowd. May every photograph of a balance leave with its holder. And may the jail that blocks a fast disk still leave room for a clear story.*
