# The SLC Product — Glow on Capable Hardware, Sala Broadcast as the Flagship Lap

**Language:** EN
**Version:** `20260715.194500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Status:** Product brief — names the SLC product and its first laps. Register: mixed — L1 (session record + replay) is checkable (Sala B0 green); L2–L3 are horizon (design), gated as noted.
**Compass:** foundations → grain → Two Rooms → this brief → TASKS/ROADMAP

---

## The Decision, Stated First

The Glow SLC product is **not a phone we fabricate.** mikroPhone (studied with gratitude at `../gratitude/mikrophone.md`) proves the fully-open bespoke-hardware path is performance-limited by design — that simplicity is the price of total openness. So the SLC product is Glow's sovereign, anti-extraction **software**, delivered as Simple-Lovable-Complete laps on **capable existing hardware** (the /e/OS Fairphone of the Glowphone refinement), where the capability comes from the silicon and the sovereignty comes from our code. The flagship first product is **Sala broadcast** — a sovereign way to record, replay, and (later) livestream your own session — because it is small, genuinely wanted, and already complete at its first lap.

## Why Sala Broadcast Is the Right SLC Product

Held against the three SLC questions:

- **Simple** — one clear scope: a session is a signed, ordered, replayable log, and Sala shows it. One loop: record → replay (and later, carry → watch). The edge is drawn honestly; it claims nothing it cannot do.
- **Lovable** — it is genuinely wanted by the very community this whole tree serves: musicians, activists, vegan creators who want to promote and share their work *without a platform between them and their audience*. It runs on the person's own capable phone, verifiable, theirs. Someone would want this today.
- **Complete** — the loop already closes at L1: Sala B0 records a session as a signed log and replays it to a deterministic root, proven green (`../linengrow/sala_session_core.rye`). A modest, finished, whole thing — not a half-built promise.

And it walks the whole compass: **foundations** (sovereignty, anti-extraction, the creator community, calm humane tech), **grain** (a fold over a signed, ordered log), **witness-before-truth** (every session verifiable, B0 witnessed), and it is the **Civic** shape (name the outcome — a sovereign broadcast delivered; the measure — signed session facts served and verified; keep them aligned — never engagement captured).

## The SLC Laps

Each lap simple, lovable, complete at its own scale — grown from the running seed before it, per Gall's Law.

| Lap | Simple scope | Lovable | Complete | State / gate |
|---|---|---|---|---|
| **L1 — Record & replay** | A session recorded as a signed, ordered log; replayed to a deterministic root | Your own session, verifiable, yours | The loop closes: record → replay, byte-for-byte | **GREEN** (Sala B0, `20260715.190000`); runs on capable aarch64, proven at M0 |
| **L2 — Live carriage** | The same log carried in order over Comlink to one viewer, live | Broadcast from your phone to a friend, sovereign, no platform | Record → carry → watch, live, verified | Horizon — gates on **Pool P0** and the Mycelium ordering aspect (Sala B1) |
| **L3 — Audience & back-channel** | Many viewers; chat as folded signed facts; the VOD is the log at rest | A real sovereign alternative to a streaming platform, on your own phone | Broadcast → audience → replay, whole | Horizon — gates on L2 (Sala B2) |

L1 is a complete, lovable product *today* — a person can record a session on a capable phone and replay it, verifiably. That is the SLC stance: modest, finished, worth loving on the day it arrives, claiming no more than it keeps.

## Why This Answers mikroPhone's Lesson

mikroPhone taught the honest limit: bespoke openness costs performance. The SLC product sidesteps that trade entirely — it does not compete with mikroPhone's hardware or chase its openness at the silicon; it delivers *sovereignty in software* on hardware that is already fast, already repairable (Fairphone), already de-Googled (/e/OS). The performance comes from the phone; the freedom comes from Glow; the product is the experience, not the device. And because Glow's fold is proven on aarch64 (M0), the product's own compute already runs on that phone's architecture.

## What This Brief Does Not Claim

- No claim that L1 is a shipped consumer app — it is a green core on capable hardware, the complete first SLC lap, not yet a packaged install.
- No claim to compete with mikroPhone — it is a teacher we honor; the SLC product runs on different (capable) hardware and delivers a different (software-sovereignty) value.
- L2 and L3 stay horizon, honestly gated on Pool P0; nothing here promises live carriage before that keystone lands.

## Reach Tier (`20260715.195500`) — the Budget Used Android, and Modifying the SLC for Reach

Accreted to widen customer potential: the Fairphone /e/OS is the *repairable-flagship* device (own it fully, firmware freer, ~$600), yet it is a barrier to *reach* at that price. For the widest customer potential, the SLC broadcaster client should target a **cheap used/refurbished Android** as its reach tier — and the honest best target, TAME-aligned, is a **used Google Pixel (7a or 8a class)** on a de-Googled ROM (dated July 2026, cited):

- **Reach floor — used Pixel 7a (~$150–220 refurb, or ~$298 pre-flashed with GrapheneOS).** The cheapest sovereign-capable entry: unlockable bootloader, GrapheneOS/CalyxOS/DivestOS/LineageOS support, Tensor G2, 90 Hz OLED. Honest caveat: on the old A-series update policy, security patches end ~2028 — a ~two-year runway, a reach device rather than a keep-for-a-decade one.
- **Best value — used Pixel 8a (~$250 refurb).** Tensor G3, and the first A-series on Google's 7-year policy, so security updates run to **2031** even on a $250 refurb. The buy-once-keep-long choice.
- **Skip:** carrier-financed Pixels (locked bootloaders), Pixel 6a (2025 battery recall), Pixel 6/earlier (support ended).

**Why the used Pixel is the reach sweet spot** — it is cheap and *abundant* (Google's high sales volume feeds a deep refurb market), it is one of the few cheap Androids with a genuinely *unlockable* bootloader (most budget carrier phones are locked), and it has the *widest* sovereign-ROM support of any device family. A creator can even buy one **pre-flashed with GrapheneOS**, so being a sovereign broadcaster needs zero flashing skill — that removes the technical barrier that would otherwise cap reach.

**The one honest tension**, the same one the Glowphone study named: a used Pixel is GrapheneOS-*hardened* yet runs the *least firmware-free* silicon (closed secure element, closed baseband and camera blobs). So the two device tiers serve different values and are complementary, not competing: the **Fairphone** leads on repair + firmware-freedom (own-it-fully), the **used Pixel** leads on hardened-security + low-cost + abundance (reach). Both are de-Googled and sovereign; a person picks by which value they weigh most.

**Modifying the first SLC for reach** — three changes, none of which touch the green core:

1. **Broaden the broadcaster-client target** from Fairphone-only to *any de-Googled-capable cheap used Android*, with the used Pixel 7a/8a as the lead reach device. Entry cost drops roughly 4x (~$600 → ~$150–250), so far more people can be a sovereign broadcaster.
2. **Lower the skill barrier** by supporting pre-flashed GrapheneOS/CalyxOS devices, so no flashing is required to start.
3. **Keep the audience platform-agnostic** — the viewer reaches any broadcast over the open web (the WebSocket bridge the Sala-broadcast study names), so the *watching* side has universal reach regardless of the broadcaster's device or the viewer's.

Together these keep the SLC's green L1 core untouched while widening both who can broadcast (cheap sovereign device) and who can watch (any device, over the web) — reach on both sides, sovereignty uncompromised.

## Related

- `../gratitude/mikrophone.md` — the teacher whose performance limit points to this software-on-capable-hardware stance.
- `../external-research/20260715-181500_sala-broadcast-live-session-fold.md` — the broadcast lane (B0–B3) this product delivers.
- `../external-research/20260715-182500_glowphone-firmware-freedom-two-body-strategy.md` — the /e/OS Fairphone this ships on.
- `../context/SIMPLE_LOVABLE_COMPLETE.md` — the discipline this brief keeps.
- `../counsel/20260715-190000_the-design-over-build-ratio-and-finishing.md` — the finishing edge L1 already walks.

---

The SLC product is not a phone but a fold made lovable: Glow's sovereign broadcast, complete at its first small lap today, growing on capable hardware toward the live sovereign window a creator has always deserved.
