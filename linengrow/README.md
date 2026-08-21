# Linengrow

**Language:** EN
**Last updated:** 2026-07-11 (commerce steward demo nib **419** · Dimeroll own root; MALA/WOV still here)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

---

Linengrow is the first whole built upon Rye OS — a transparent civic and social-commerce platform for vegan musicians and activist creators, where every sponsored post carries a visible label, every data sale carries a visible receipt, every contract carries a visible expiration, and every person owns their complete data in a portable server they can carry whenever they choose. Where Rye OS is the system, Linengrow is what the system is *for*: the place its foundations meet real people, real creators, and real communities.

This folder holds the vision. The build grows the SLC way — smallest lovable complete first — and its laps rest on the same modules Rye OS is already growing. The **commerce steward demo** (nib **419**) closes the in-process livelihood loop: Mandi list → settle → Dimeroll receipt — hammock [`../active-designing/date/20260711/20260711-004652_commerce-citizen-steward-demo-hammock.md`](../active-designing/date/20260711/20260711-004652_commerce-citizen-steward-demo-hammock.md).

---

## One Spine, Two Altitudes

Linengrow shares Rye OS's architectural spine exactly: state as a pure fold over an append-only log of immutable signed facts, and five foundations beneath everything — keypair, signed event, log, projection, capability. The civic-platform thesis is a dependency, not a metaphor:

- The **keypair** that roots a Rye identity roots a Linengrow account; one owner seed, a whole presence derived.
- The **signed event** that records a fact records a sponsorship, a data sale, a donation.
- The **Mantra log** that versions a file records a transaction, kept whole, nothing grasped back.
- The **projection** that folds a log into a view folds transactions into a verifiable receipt and a balance.
- The **capability** that isolates a process in Caravan names ownership and permission in Linengrow.
- **Comlink** seals delivery identity to identity; **MALA** is Linengrow's own-issuer money (M1 landed); **Pond** confines each application in a bounded, policy-as-value enclosure.

Correctness by construction in the kernel becomes trust by construction in the platform. The same discipline that makes a kernel safe makes a marketplace honest.

The unifying civic vision — open OS, open hardware, regenerative land, the ledger, creator tools — lives in [`../foundations/20260628-124512_anywhere-we-are-found.md`](../foundations/20260628-124512_anywhere-we-are-found.md). The currency that keeps value circulating close to home is drawn out fully in [`../foundations/20260629-014512_money-that-stays-close-to-home.md`](../foundations/20260629-014512_money-that-stays-close-to-home.md). Linengrow carries forward its creator-facing gifts: the fable, the tools surface, and the privacy-by-disclosure model, below.

---

## Privacy and Disclosure

Linengrow holds two truths at once, and zero-knowledge proofs are what let it: **the mechanism is transparent; the individual is private.** The marketplace's rules stay visible to everyone — a sponsored post wears its label, a data sale carries its receipt, a contract shows its expiration — because the honesty of the room is the platform's whole promise. The person, by contrast, is private by default: opted out of public sharing until they choose otherwise, revealing only what they choose through a zero-knowledge proof — proving they are a verified vegan creator without naming themselves, proving a sponsorship was disclosed without exposing its terms, opening a door with a cryptographic pass while keeping the key behind it. The powerful mechanism is transparent; the individual stays private.

The default leans toward privacy, on purpose. No one is made public against their will; a person opts in to what they reveal, selectively, through proofs they control. Yet the culture and the economics make opting in attractive — a creator who shares their **fable**, their story told and proven honestly, is met and rewarded for it; transparency is celebrated as a community value; the positive economics flow toward those who choose to be seen. People opt in to being public because it is honored and it pays, never because the door was forced. The cryptographic pass is the everyday shape of this — it opens what you want opened, and keeps closed what you keep.

This satisfies all four promises a tool can keep at once, and most of all *tell the truth* and *hold lightly*: the room is honest, and the person remains free.

### The creator's surface

Linengrow serves makers with tools that are theirs: free tools for music, for fashion, for keeping notes, and for holding a social graph a person actually owns. Each creator's **fable** — their attested story — is the thread that runs through them, told once and provable anywhere, carried under the person's own key.

---

## The SLC Ladder

The full vision — a public benefit corporation, a computational data market, state-currency circulation, investor rounds — is the horizon. We grow toward it one lovable, complete lap at a time. That computational data market has since been named as its own vane: **Pool** (the Gall-expanded P-vane), where Linengrow runs as one values-specific flagship agent and the market mechanism itself is described secularly for any maker — [`../external-research/20260714-035600_pool-p-vane-content-data-market.md`](../external-research/20260714-035600_pool-p-vane-content-data-market.md). Linengrow stays the vision; Pool is the market fabric beneath it.

| Lap | What | Grows from |
|------|------|-----------|
| **SLC-L1** | **A verifiable receipt** — sign a transaction fact, append it to the log, produce a receipt anyone can verify | keypair + Mantra log + projection · scope [`../active-designing/date/20260702/20260702-195426_slcl1-verifiable-receipt.md`](../active-designing/date/20260702/20260702-195426_slcl1-verifiable-receipt.md) · witness **152** |
| **SLC-L2** | **Sealed delivery** — a signed receipt sent identity to identity, under seal | Comlink · scope [`../active-designing/date/20260706/20260706-000812_slcl2-sealed-delivery.md`](../active-designing/date/20260706/20260706-000812_slcl2-sealed-delivery.md) · witness **155** |
| **OA-L1** | **Closed ask loop** — post, apply, accept, complete, verify on one log | scope [`../active-designing/date/20260706/20260706-002912_open-asks-hammock-scope.md`](../active-designing/date/20260706/20260706-002912_open-asks-hammock-scope.md) · witness **156** |
| **OA-L2** | **Cross-party delivery** — request + application under Comlink seal | scope [`../active-designing/date/20260706/20260706-011512_open-asks-cross-party-delivery.md`](../active-designing/date/20260706/20260706-011512_open-asks-cross-party-delivery.md) · witness **157** |
| **OA-L3** | **Escrow** — hold at acceptance, release at completion, the escrow balance closing at zero on one log | scope [`../active-designing/date/20260706/20260706-013012_open-asks-escrow-hammock.md`](../active-designing/date/20260706/20260706-013012_open-asks-escrow-hammock.md) · witness **158** |
| **OA-L4** | **Reputation-as-fold** — applicant consent facts; witness bolt | witness **167** |
| **OA-L5** | **Accept, complete, consent wire** — hosted + device | witness **184** |
| **SLC-L3** | **Settlement rail** — landed then **removed** `152612` (Sui/Monad path replaced by MUR / was MALA); hammock kept as record | replaced by MUR |
| **MALA M1** | **One issuer, one holder** — mint, send, balance-as-fold on one node; [`mala.rye`](mala.rye) · witness **198** | design [`../active-designing/date/20260702/20260702-031312_modules-aspects-and-mailable-money.md`](../active-designing/date/20260702/20260702-031312_modules-aspects-and-mailable-money.md) |
| **MALA M2** | **Mailable (hosted)** — mint under Comlink seal; receipt back; [`mala_delivery.rye`](mala_delivery.rye) · witness **199** | prompt [`../expanding-prompts/yonder/20260709-191634_mala-m2-mailable-comlink.md`](../expanding-prompts/yonder/20260709-191634_mala-m2-mailable-comlink.md) |
| **MALA M2b** | **Device wire** — virtio mint + receipt hops; ports **15569**/**15570**; extends M2 witness | prompt [`../expanding-prompts/yonder/20260709-201734_mala-m2b-device-wire.md`](../expanding-prompts/yonder/20260709-201734_mala-m2b-device-wire.md) |
| **SLC-L4** | **Fixed-tier Sigma** — donor-amount privacy; [`disclosure_core.rye`](disclosure_core.rye) + [`../tally/pedersen.rye`](../tally/pedersen.rye) · witness **200** | prompt [`../expanding-prompts/yonder/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md`](../expanding-prompts/yonder/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) |
| **WOV — exit honesty** | **Exit honesty** — in-memory book, root fact, prove, exit; [`wov_core.rye`](wov_core.rye) · witness **201** | spec [`../context/specs/20260709-200443_wov-exit-honesty.md`](../context/specs/20260709-200443_wov-exit-honesty.md) |
| **Dimeroll** | **Centralized books** — moved to own root [`../dimeroll/`](../dimeroll/); witnesses **207**–**209** | hammock [`../active-designing/date/20260710/20260710-125953_dimeroll-hammock.md`](../active-designing/date/20260710/20260710-125953_dimeroll-hammock.md) |
| **Horizon** | The data market, premium tiers, state-currency circulation, the PBC and its rounds | the business model, below |

The first lap needs no ledger and no currency — only the foundations Rye OS already grows. A sanctuary receiving donations with cryptographic receipts is a complete, lovable, honest beginning, and everything larger grows from there.

---

## The Vision Documents

- `20260628-124512_linengrow-business-model.md` — the business model and investor-outreach approach: the public benefit corporation, four transparent revenue channels, the market opportunity, the go-to-market, and the conscience rubric that tests every decision against whether it nourishes, circulates, and returns what it takes.
- `20260628-124512_linengrow-venture-pitch.md` — the venture pitch: the problem of an opaque attention economy, the architecture of transparency, the business model in brief, and the longer horizon.

Both are generalized templates; settlement now rides MALA's own-issuer path rather than an external chain, so the vision stays reusable across regions and rounds while Linengrow carries it forward as our own.

---

## How It Grows

Linengrow lives here as vision and design while its first lap is small. Like every module, it may graduate to its own home — `xwb122m/linengrow-*` — once its first lap runs and earns the move. Until then, it grows beside the system it rests on, so the two stay coherent and the spine stays one.

The granular tasks for both tracks live in `../work-in-progress/TASKS.md`; the order and the why live in `../work-in-progress/ROADMAP.md`.

---

*May the economics of attention grow as transparent as a farmers' market in full morning light. May every receipt be verifiable, every contract carry its expiration in plain sight, and every person carry their own data freely wherever they go. May what we build nourish the people who make it, circulate through the communities that hold it, and return, season after season, more than it ever takes.*
