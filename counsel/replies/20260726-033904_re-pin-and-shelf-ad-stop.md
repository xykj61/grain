# Reply — Pin and shelf · AD STOP (forge auth)

**Language:** EN  
**Stamp:** `20260726.033904`  
**Voice:** Quin  
**Ground:** paste seats AA–AF · zip `files (57).zip` · arrival count **2** · origin/main was `66f1f3d6d9` · monocypher commit `bbce1fd5c9`  
**Status:** Partial send — **AD STOP** (no forge API token in enclosure) · T3 held for Keaton’s two strike lists · F re-run still Keaton-timed  
**Answers:** [`counsel/20260726-032231_the-pin-and-the-shelf.md`](../20260726-032231_the-pin-and-the-shelf.md)

---

## Arrival

| File | Destination | Result |
|------|-------------|--------|
| `20260726-032231_the-pin-and-the-shelf.md` | `counsel/` | filed verbatim |
| `MAP.md` | repo root | filed verbatim · `!/MAP.md` allowlisted in `.gitignore` |

## What landed

| Step | Result |
|------|--------|
| **AA** | counsel filed · index row prepended |
| **AB** | gitlink restored at `ab2b16dd619ad5f6979a4fbe69cfa324a6fcc35f` (tag **4.0.3**) · commit `bbce1fd5c9` · `proven_seat_signed_kumara_fetch` **GREEN** · `proven_seat_signed_kumara_parity` **GREEN** (fetch-only / jail-safe) |
| **AC** | `MAP.md` gates: markdown_structure tables·fences·links **GREEN** · living_docs_lint **GREEN** (advisory) · radiant_lint **GREEN** (advisory; MAP header clean, bare-but 0) · `LINK_WITNESS_FILES=MAP.md` **GREEN** (41 relative links) · **claim_preserve not run** · README untouched |
| **AE** | one shell-ratchet line on `work-in-progress/ROADMAP.md` |
| **AF** | reading-only strike table at [`work-in-progress/20260726-032231_wip-breach-census.md`](../../work-in-progress/20260726-032231_wip-breach-census.md) — KEEP 9 · MOVE 17 archive · MOVE 3 yonder |

### AB forensics (one line)

`git log --diff-filter=D --oneline -- vendor/monocypher | head -3` → **empty** on this clone (no deleted gitlink in reachable history; `.gitmodules` named the path while HEAD never carried mode `160000` until `bbce1fd5c9`).

## What resisted — AD STOP

Forge description (301 characters by Python `len`; counsel said 305 — same verbatim paste):

> Grain — an open proposal to Urbit: one language (Glow — Hoon's runes over bounded, asserted, TAME-disciplined semantics), five switchable OS variants, and a witness-first tree where every claim is proven on metal before it is written in prose. Safety first, performance second, joy of the craft third.

Attempts from this enclosure:

| Forge | Result |
|-------|--------|
| GitHub (`gh api` PATCH) | no `GH_TOKEN` / `tools/gh-token.secret` — CLI refuses auth |
| Codeberg (API PATCH) | HTTP **401** `token is required` |
| Public readback | GitHub `description: null` · Codeberg `description: ""` — **neither accepted a change** |

Per STOP-if-red on forge refusal / inability to confirm: **AD does not land.** No invented token. Shown text on both forges remains empty.

## F · H

Signed-Kumara fetch+parity witnesses are **GREEN**. Full parity re-run (~106 min) stays **Keaton-timed**. Until that full suite is GREEN, send notes still treat campaign **F** as awaiting re-run; **H** unblocks only after full GREEN.

## What stays held

- **T2** — Keaton strikes WIP list **and** the 247 (empty = move all proposed)  
- **T3** rounds (WIP pilot first) under ROUND MODE  
- **T4** arithmetic · **breach two** (next season) · **U · V · I** · parked gates-for-content-laps  

## What the bench asks

1. Paste the description verbatim into GitHub **and** Codeberg (or drop a scoped `tools/gh-token.secret` + Codeberg token and say **resume AD**).  
2. Seat both **T2 strike lists**.  
3. Time the full parity re-run when ready — then H.

---

*May the pin stay at 4.0.3. May the map greet the traveler before the shelf grows short. And may a forge description wait for a real hand rather than a guessed key.*
