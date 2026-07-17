# Sala as a Broadcast Surface — a Live Session Is a Fold Over a Signed, Ordered Log

**Language:** EN
**Version:** `20260715.181500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Vision register — design → horizon lane, siloed. Register: design (Two Rooms — a proposal, no broadcast code). Sources studied and thanked below; nothing copied. Addressed to a generic Acme Corporation employee.
**Companion:** `20260715-172000_pool-keystone-revival-realidream-landscape.md` (Sala as the Landscape-parallel viewer under Pool — this doc gives Sala a live face); `20260712-093812_mesh-inference-study.md` (the pooled-compute mesh this rides on)

---

## What This Answers

How Sala — Glow's unified viewer — could broadcast and livestream a session, so an Acme Corporation employee promoting their work from a phone can share a live, verifiable window into what they are doing. The seed named a constellation of familiar tools to fuse: Asciinema's recorded terminal session, WebSockets' live channel, Twitch's live audience, the existing Realidream viewer ideas, a Mycelium-shaped ordered stream, Lattice's arithmetic voice, Pool's application host, and the Cursor-iOS-style mobile session itself. The finding that gathers them: **a broadcast is a fold over a signed, append-only, ordered log of events** — which is the exact shape this whole tree already rests on. Sala-broadcast is Neth, Weave, and Mantra wearing a live hat, carried by Comlink, witnessed rather than trusted.

## The One Idea That Unifies the Constellation

Asciinema already teaches the core move, and it is the reason this fits our grain so cleanly: a recorded terminal session is **not a video** — it is a small, replayable log of timestamped typed events, re-rendered on playback. That is a fold. Twitch adds a live audience, a chat, and a saved recording (VOD) after; WebSockets is merely the pipe that carries the events while they are fresh. Read together, a livestream is:

- a **log of signed session events** (keystrokes, frames, fold results) — which is **Weave/Mantra**, the append-only record we already keep;
- delivered **in order, while fresh**, to subscribers — which is **Comlink's ordering aspect (Mycelium)**, the latency-sensitive ordered stream already named at gate M4 and already motivated by the mesh split;
- **re-rendered as a frame** by each viewer — which is **Sala**, rendering a pure fold from the log to the glass, exactly as it renders any Pool-hosted agent;
- with a **live back-channel** (chat, reactions) — which is more signed facts folded into the same log, deduped on their own hash for free;
- **saved and replayable** afterward (the VOD) — which is simply the Mantra log replayed, byte-for-byte, because a fold over an immutable log always reproduces.

So almost nothing here is new machinery. The broadcast is the session log; the stream is Comlink carrying it in order; the player is Sala folding it; the recording is the log at rest.

## Where Each Named Tool Lands

- **Asciinema** → the *shape*: a session as a replayable event log, not a pixel dump. A Sala broadcast of a Rishi session is asciinema's idea grown into a signed Weave log — smaller, verifiable, and re-foldable at any speed.
- **WebSockets** → the *transport role*, played by **Comlink**. The live channel is a Comlink lane; the wire format stays ours (the sealed datagram already proven), and a browser bridge can speak WebSocket at the edge where a non-Glow viewer connects.
- **Twitch** → the *social shape*: live audience, chat, and VOD. Subscribers are Comlink subscriptions (`sup`/`wex` in the bowl); chat is signed facts folded; the VOD is the log replayed. What Twitch centralizes on one company's servers, Sala keeps sovereign — the broadcaster hosts their own stream under Pool.
- **Realidream / Sala** → the *viewer*: the unified surface that renders the live fold. A broadcast is just another Pool-hosted agent's state Sala shows, live rather than at rest.
- **Mycelium** → the *ordered-stream seam*: a live broadcast is latency-sensitive and order-dependent, which is exactly Mycelium's job (Comlink's ordering aspect). The livestream is a strong, concrete motivation for Mycelium rather than an abstract one — the same finding the mesh-inference study reached for split-pipeline activations.
- **Lattice / Quin** → the *inference voice over the stream*: live captions, a summary fold, a highlight detector — inference run over the session log as it grows, served by Quin, bounded by Tally. Optional, never required for the stream to work.
- **Pool** → the *host*: the broadcast is a Pool-hosted agent (P0's shape), so it inherits capability isolation, the bowl's determinism, and the fold discipline from birth.
- **The Cursor-iOS mobile session** → the *first real broadcaster*: a person promoting their work from a phone, broadcasting their Rishi/Sala session live to an audience, is the concrete first tenant this lane is for — the mobile, sovereign answer to a Twitch stream.

## The First Laps — Smallest Lovable Complete

Named as a ladder, each provable before the next, none built:

| Rung | Name | What it is | Gate |
|---|---|---|---|
| **B0** | **Session-as-log** | A Rishi session recorded as a signed Weave log of timestamped events, replayable through Sala at rest (asciinema's shape, our fold) | Weave slice green (it is) |
| **B1** | **Live carriage** | The same log carried in order over Comlink to one subscriber, rendered live in Sala; the ordered-stream seam is Mycelium's first real consumer | B0 · Pool P0 · Comlink ordering aspect |
| **B2** | **Audience + back-channel** | Many subscribers; chat and reactions as signed facts folded into the same log; the VOD is the log at rest | B1 |
| **B3** | **Inference and economics** | Quin folds live captions/summary over the stream; MALA/Pool meter a giving lane (broadcast freely as seva) or a market lane (priced), the same fact shape underneath | B2 · Quin lap · MALA |

## Civic-Style Integrity Audit

Naming the outcome, the measure, and their alignment, per Civic Style:

- **Outcome wanted:** a person can broadcast a live, verifiable window into their work from their own phone, owning the stream end to end, without a platform between them and their audience.
- **What the reward measures:** signed session facts actually served and verified by real viewers — never engagement time, never attention captured. The metric is *useful, verifiable broadcast delivered*, and the giving/market lanes both meter that same fact, so livelihood and seva point the same way.
- **The boundary that must hold:** the broadcaster owns and signs the log; viewers verify from public data; the back-channel is consent-gated and moderation is a fold-choice with receipts (the moderation-fact shape already named). No stream is admitted unsigned; capabilities gate who may broadcast into a shared space, exactly as the mesh study's one-boundary rule requires.

This keeps the broadcast lane inside the same discipline as the rest: it hands attention back rather than harvesting it, tells the truth in a log anyone can check, holds lightly (the VOD is the broadcaster's to keep or purge, with a signed refusal fact for a decline), and stays kind by default.

## What This Doc Does Not Claim

- No broadcast code, no live carriage, no player is built; this scopes a horizon lane, gated behind Pool P0 and the Mycelium ordering aspect.
- It does not reimplement a codec or a video pipeline; heavy media stays a bounded host seam under Maitreya, named in gratitude, never linked into what we ship.
- It does not claim datacenter-grade interactivity; honest to the mesh study's own finding, sovereign home carriage is respectable-but-modest, and the design leads with verifiability rather than raw latency.

## With Gratitude

The session-as-replayable-log shape is studied with thanks to **Asciinema** (Marcin Kulik); the pooled-carriage and key-addressed transport pattern to the **iroh / n0** team (already thanked in the mesh study); the live-broadcast social shape to the many streaming communities that proved the form. Every idea is re-expressed in our own vocabulary; nothing is copied, and the sovereign, verifiable, attention-returning version is ours to carry.

## Related

- `20260715-172000_pool-keystone-revival-realidream-landscape.md` — Sala under Pool, the viewer this gives a live face.
- `20260712-093812_mesh-inference-study.md` — the ordered-stream and one-boundary findings this reuses.
- `../foundations/20260629-014512_money-that-stays-close-to-home.md` — the giving/market lane the economics rung rides.

---

A livestream is a session log carried in order and folded to a frame; Sala already knows how to fold, Comlink already knows how to carry, and the broadcaster keeps the whole of it in their own hand.
