# The Roadmap — Growing the Whole from What Already Works

*A living plan shaped by one law: a complex system that works grows from a simpler system that worked. We build by growing, and we ship something simple that runs at every step.*

**Language:** EN
**Version:** `20260713` (Fresh sitting — morning cup · docs keeper complete)
**Last updated:** 2026-07-13 (parity word landed · suite nib **433** · git nib pending go)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Lens:** TAME — safety, performance, joy; the Seed Law; [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md)
**Status:** Living roadmap

**Direction:** [`active-designing/20260628-043542_thin-frontend-slc-direction.md`](../active-designing/20260628-043542_thin-frontend-slc-direction.md) · **Seam season hammock (living):** [`active-designing/seam-season-hammock.md`](../active-designing/seam-season-hammock.md) · **Counsel:** [`counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md`](../counsel/20260712-052806_claude-counsel-three-doors-and-teacher.md)

---

## The Vision

**Rye OS** — a system that belongs wholly to the one who runs it. One language (Rye), one value model, one kernel (Caravan), one compositor (Brushstroke), one shell (Rishi), one version history (Mantra), one network (Comlink), one database (Tablecloth), one composition language (Brix), one data notation (Bron), one memory model (Tally), one boot (Aurora), one enclosure (Pond). **Linengrow** is the flagship application those modules serve — transparent civic commerce grown from the same spine. Each module individually simple; together they compose a desktop, a forge, a network, and a boot — on x86_64 today and RISC-V as the horizon.

**Rye today** is a thin, honest frontend on pinned Zig 0.16.0 — `rye/lib/std` leaned upon through pristine symlinks, safety living in authored `.rye` (assertions at call sites, `width-check.rish`, the trio). The strengthening chronicle **completed** as analysis; it is record, not product.

The full design lives in [`active-designing/yonder/20260619-225712_the-whole-system.md`](../active-designing/yonder/20260619-225712_the-whole-system.md). This roadmap says what to build and in what order.

---

## Two Tracks, One Spine

Rye OS is the system. **Linengrow** is the first whole built upon it — a transparent civic and social-commerce platform for vegan musicians and activist creators. The two share one architectural spine: state as a pure fold over an append-only log of immutable signed facts, and five foundations beneath everything — keypair, signed event, log, projection, capability.

Correctness by construction in the kernel becomes trust by construction in the platform. The same capability that isolates a process in Caravan names ownership in Linengrow; the same Mantra log that versions a file records a verifiable receipt; the same Comlink that seals a datagram delivers a signed transaction identity to identity. Rye OS grows the infrastructure laps; Linengrow grows its application laps on the same modules. The full Linengrow vision lives in [`../linengrow/`](../linengrow/); this roadmap grows it the SLC way, smallest lovable complete first. The granular plan for both tracks lives in [`TASKS.md`](TASKS.md).

---

## Local macOS fork (`20260713.201910`)

*A parallel thread to the product roadmap below: this `~/urbit` clone now lives on Kaeden's Mac under a fresh `keatondun@gmail.com` / `xykj61` identity, layered over `urbit/urbit` and `urbit/vere` histories, diverging from the Urbit Foundation on purpose. **Landed:** Pass 1 repo mechanics + keys + Pacific-time convention; both forges pushed and signature-verified; the macOS ai-jail equivalent (`sandbox-exec` launcher, witnessed green) + setup guide; the design thread — **Glow** named as the fused Rye-Hoon language, four kernel variants (Riyo/Reya/Trey/Triz) proposed, Nock interpreter and Glow TAME supplement scoped, the grain lineage held whole and siloed. **Open (Kaeden's word):** Azimuth/Comlink integration, vere issue migration, the naming/rename decisions, seating the Glow supplement, the native-arm64 parity witness run, and host FileVault. Granular boxes in [`TASKS.md`](TASKS.md).*

## Now — Fresh sitting (`20260713`)

**Compass rose:** [`foundations/20260706-185112_follow-our-compass.md`](../foundations/20260706-185112_follow-our-compass.md) — foundations → grain → active-designing → TASKS → witnesses → this roadmap.

| Order | Lap | Status | Anchor |
|-------|-----|--------|--------|
| — | **Docs compression** + `living_docs_lint` keeper | **Complete** `223300` · five duties GREEN | [`docs/`](../docs/README.md) · design [`221600`](../active-designing/20260712-221600_docs-compression-layer-design.md) · ER [`223300`](../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md) |
| — | **Parity word** — living_docs_lint advisory ch.1 · signed-Kumara append ch.2 | **Landed** `20260713` · suite nib **433** | [`220400`](../active-designing/20260712-220400_proven-seat-seam-c-and-rye-body.md) · `proven_seat_signed_kumara_parity.rish` |
| **1** | **Forge courtesy** | Open · ~two minutes | Inference track lap 1 closed tip **418** |
| **2** | **G2 naming** — the word today never named | **Open** · weigh seL4-kernel-swap · hw-kernel · Sculpt-integration | ER [`054342`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md) · hammock [`proven-seat-guest-hammock`](../active-designing/proven-seat-guest-hammock.md) |
| — | **Named supersede build word** | Parked · frozen criteria ready | [`210800`](../active-designing/20260712-210800_pond-supersede-exit-criteria.md) · latch [`214200`](../active-designing/20260712-214200_proven-seat-signed-kumara-monocypher.md) |
| — | Route two · Rye-body C-shim · libsodium | Parked on triggers | [`220400`](../active-designing/20260712-220400_proven-seat-seam-c-and-rye-body.md) |

**Season held.** Proven-seat **G0-complete** · **G1 closed digest-grade** `204549` · **signed-Kumara GREEN resting** `220400` · metal parity chaptered **GREEN** `193958`.

---

## The Ground — What Already Runs

| Module | Seed | Witnesses |
|--------|------|-----------|
| **Rye** | Thin frontend; `rye/lib/std` → vendor symlink | **140** witness regression suite |
| **Aurora** | Six-stage relay + deciding stage on RISC-V | Freestanding |
| **Caravan** | seed → bounded → twin → chain → service → poll service → **restart-on-ok** → **signal ring** → capabilities | Hosted; graceful stop complete through parity **179** |
| **Tally** | seed + named gardens (blob/diff/frame) | 15 invariants; seed + gardens in parity |
| **Brix** | `.brix` descriptor, 10 tracked bricks | Read by Mantra |
| **Bron** | Data notation (`.bron`) | Used by `.brix` |
| **Tablecloth** | Application database + Brix artifact store (horizon); **Tablecloth query** = namespace filter at parity **175** | Store designed (future); query landed |
| **Mantra** | Weave + referential namespace + reference spec `20260707-011412` | parity **159–175**; [`mantra/README.md`](../mantra/README.md) |
| **Rishi** | Shell: typed values, file I/O, string builtins; **`repl`** — type, run, version, recall (SLC-1 **done**) | Gate trio + four SLC-1 witnesses incl. `slc1_accept.rish` |
| **Brushstroke** | Hosted seed + Wayland seed (Skate grid on xdg toplevel) | Frame from values; seed + grid raster in parity |
| **Skate** | Text grid: 8×8 monospace → ARGB8888 buffer | Headless selftest GREEN; feeds Wayland seed |
| **Comlink** | Sealed datagram: shared-memory + localhost UDP | Full crypto stack; hosted wire in parity (suite at **144**) |
| **Pond** | First app: [`pond/apps/drawn_terminal.rye`](../pond/apps/drawn_terminal.rye) (Skate viewer + Dexter keyboard) | **SLC-2b** — keyboard witness at parity **145**; RW-1 at **147**; chrono sweep at **148**; Lap 3 at **140** |

**Strengthening arc:** complete — chronicle + lexicon at `strengthening-compiler/0000_STRENGTHENING_LEXICON.md`; call-site harvest at [`archive/20260628-044200_call-site-harvest.md`](archive/20260628-044200_call-site-harvest.md).

**The trio:** `parity.rish` (**nib 432** living suite — regression suite + SLC-1 + SLC-2a + SLC-2b + RW-1 + RW-2 + Caravan + Comlink + Tally/Brushstroke seeds + hosted `width-check` + RW-3 + RW-4 + Edit 5 + Amber lap 1 + **Amber manifest Tilak (I6)** + chrono version sweep + crossing manifest seed + **SLC-L1 receipt** + **MALA M1** + **MALA M2** + **SLC-L4 Sigma** + **SLC-L2 sealed delivery** + **OA-L1 closed ask loop** + **OA-L2 cross-party delivery** + **OA-L3 escrow** + **OA-L4 reputation-as-fold** + **OA-L5 accept/complete/consent wire** + **NS-L1 recall** + **NS-L2 write revision** + **NS-L3 bolt sync** + **NS-L3 wire lap 1 hosted sync** + **NS-L3 resin-batch frame** + **NS-L3 beading** + **NS-L3 recall_beaded** + **marks-on-read** + **two-way sync (in-process)** + **two-way sync wire (hosted + device)** + **catch-up-to-latest (in-process)** + **catch-up-to-latest wire (hosted + device)** + **outer subscribe poll (in-process)** + **outer subscribe poll wire (hosted + device)** + **Tablecloth query (in-process)** + **I2 snapshot replay** + **I2 snapshot horizon** + **I2 snapshot wire lap 3** + **Caravan witness-stop footgun** + **Caravan source-crash recovery** + **NS-L3 batch wire (hosted + device + chunking)** + **two-rooms doorway** + **identity check** + **Comlink device wire** + **Realidream thin view** + **compass rose** + **Dimeroll lap 1** + **Dimeroll books view** + **Dimeroll lap 2** + **Linengrow sight view** + **Lattice lap 0** + **Scribble lap 0** + **Lantern lap 0** + **Lantern lap 1** + **Lantern lap 2** + **Lantern lap 3** + **Anvil corpus lap 0** + **Inference assist view** + **Inference assist view lap 2** + **Inference assist sight** + **Inference assist view lap 4** + **Inference assist sight lap 2** + **Anvil corpus lap 1** + **Lattice lap 1** + **Lattice lap 2** + **Lattice lap 3** + **Lattice lap 4** + **Scribble lap 1** + **Scribble lap 2** + **Scribble lap 3** + **Tablecloth query wire** + **Tablecloth query device wire** + **Realidream query view** + **Realidream query device view** + **Realidream query unified view** + **Realidream forge view** + **Realidream forge device view** + **Realidream forge unified view** + **Amphora lap 1** + **Amphora lap 2** + **Amphora lap 3** + **Amphora device wire** + **Amphora vessel stamp** + **Amphora vessel seal** + **Amphora resin chunk** + **Pond customs** + **Amphora purchase delivery** + **Granary lap 1** + **Granary weave view** + **Granary lap 2 write gate** + **Granary lap 3 Sharing** + **Granary lap 4 resin wire** + **Granary lap 5 Exchange** + **Mandi lap 1** + **Granary lap 4b device wire** + **Mandi floor view** + **Granary Exchange view** + **Mandi listing settle** + **Granary weave settle** + **Mandi settle view** + **Granary settle view** + **Realidream forge query view** + **Realidream forge query device view** + **Realidream forge query unified view** + **Anvil corpus view** + **Scribble outline view** + **Anvil corpus prefix view** + **Dimeroll exception view** + **Lattice lap 5** + **Anvil corpus rish view** + **Scribble lap 4** + **Dimeroll P&L view** + **Lattice lap 6** + **Scribble paragraphs view** + **Dimeroll BS view** + **Lantern lap 4** + **Lattice lap 7** + **Dimeroll TB view** + **Scribble fence kinds view** + **Lantern lap 5** + **Lattice lap 8** + **Anvil corpus rye prefix view** + **Scribble lap 6** + **Lantern lap 6** + **Lattice lap 9** + **Dimeroll journal view** + **Scribble plain snippets view** + **Lantern lap 7** + **Inference assist view lap 5** + **Inference assist sight lap 3** + **Linengrow sight view lap 2** + **Lattice lap 10** + **Dimeroll chart view** + **Anvil corpus tools prefix view** + **Lantern lap 8** + **Door 3 consumer-edge pass** + **receipt-verify Wasmtime**), `parity-selftest.rish` (std symlink guard), `additive-gate.rish` (structural std diff — applies when `rye/lib/` changes in HEAD). All in Rishi. **Status:** parity + selftest green on metal; SLC-L3 settlement stanza **removed** `152612` (MALA path).

---

## The Primary Track — Simple, Lovable, Complete wholes

Grow running seeds into things a person can use *as-is*. See [`gratitude/Your customers hate MVPs. Make a SLC instead..html`](../gratitude/Your%20customers%20hate%20MVPs.%20Make%20a%20SLC%20instead..html).

| Lap | What | Status |
|------|------|--------|
| **SLC 1** | **Rishi + Mantra shell** — hosted, scriptable REPL with versioned history in a terminal (type → run → version → recall) | **Done** (`2026-06-29`) — four verbs + `tools/slc1_accept.rish`; scope [`20260628-071012`](../active-designing/20260628-071012_slc-1-rishi-mantra-shell.md). TAME hardening **complete** (`2026-06-29`). |
| **SLC 2** | **Pond GUI / Skate viewer** — SLC-2a Laps 1–3 **landed**; **SLC-2b keyboard** **landed** (`20260703.132112`) | Scope [`20260630-030312`](../active-designing/20260630-030312_slc-2a-the-drawn-terminal.md); parity **145** |
| **Compose** | Comlink device wire → ~~capability table~~ **landed** → Comlink v1 → Brix v1 → Tablecloth → Forge | Horizon 2; capability table `2026-06-30` |

**Authored width migration** — **complete and blocking in parity** (TH-3 through TH-7; hosted `width-check`). Remaining authored surfaces migrate as-you-touch beside SLC-2; not a pending milestone.

---

## The Linengrow Track — Trust by Construction

Grown from the same modules Rye OS is already building, smallest lovable complete first.

| Lap | What | Grows from |
|------|------|-----------|
| **SLC-L1** | A verifiable receipt — sign a transaction fact, append it to the log, produce a receipt anyone can verify; **landed** `20260704.021800` — [`linengrow/receipt.rye`](../linengrow/receipt.rye) + witness at parity **152** | keypair + Mantra log + projection |
| **SLC-L2** | Sealed delivery — signed receipt identity to identity under Comlink seal; **landed** `20260706.000812` — parity **155** | Comlink |
| **OA-L1** | Closed ask loop — post, apply, accept, complete, verify; **landed** `20260706.010912` — parity **156** | Linengrow + SLC-L1 receipt |
| **OA-L2** | Cross-party delivery — request + application under Comlink seal; **landed** `20260706.011512` — parity **157** | SLC-L2 + OA-L1 |
| **OA-L3** | Escrow — hold at acceptance, release at completion, verified with the escrow balance closing at zero on one log; **landed** `20260706.014512` — parity **158** | Linengrow + OA-L1 |
| **OA-L4** | Reputation-as-fold — applicant consent facts; witness bolt; **landed** `20260706.232812` — parity **167** | OA-L1 + escrow |
| **OA-L5** | Accept, complete, consent wire — hosted + device; **landed** `20260707` — parity **184** | OA-L3 + wire |
| **SLC-L3** | Settlement rail — landed `20260708.182500`, **removed from tree** `152612` (Sui/Monad path superseded by MALA); hammock + counsel remain as record | ~~Sui / Monad testnet seams~~ |
| **SLC-L4** | Fixed-tier Sigma (donor-amount privacy) — Zig-native Pedersen + proof of opening; **landed** `20260709.194437` — [`disclosure_core.rye`](../linengrow/disclosure_core.rye) + [`pedersen.rye`](../tally/pedersen.rye) at parity **200** | prompt [`031612`](../expanding-prompts/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) · hammock [`194500`](../active-designing/20260708-194500_slcl4-selective-disclosure.md) |
| **MALA M1** | One issuer, one holder — mint, send, receipt, balance-as-fold on one node; **landed** `20260709.184051` — [`linengrow/mala.rye`](../linengrow/mala.rye) + witness at parity **198** | design [`031312`](../active-designing/20260702-031312_modules-aspects-and-mailable-money.md) · prompt [`182354`](../expanding-prompts/20260709-182354_mala-m1-one-issuer-one-holder.md) |
| **MALA M2** | Mailable — mint crosses Comlink hosted UDP; receipt crosses back; **landed** `20260709.191634` — [`mala_delivery.rye`](../linengrow/mala_delivery.rye) + witness at parity **199** (device wire = M2b) | prompt [`191634`](../expanding-prompts/20260709-191634_mala-m2-mailable-comlink.md) |
| **Dimeroll** | Centralized books — chart, journal, fold, P&L/BS, exception queue, sight view, lap-4 filters; **own root** `dimeroll/`; **landed** laps 1–4 `20260710.230433` — parity **207**–**210** · **387**–**394** | hammock [`125953`](../active-designing/20260710-125953_dimeroll-hammock.md) · lap 4 [`230433`](../active-designing/20260710-230433_dimeroll-lap4-filters.md) · sight [`132548`](../active-designing/20260710-132548_dimeroll-lap3-sight-view.md) · horizon [`131956`](../external-research/20260710-131956_seen-books-living-desktop-horizon.md) |
| **Horizon** | The data market, premium tiers, state-currency circulation, the PBC and its rounds | the business model in `../linengrow/` |

The first lap needs no ledger and no currency — only the foundations Rye OS already grows.

---

## The Visual Track — Realidream (horizon lane, ladder already named)

*Where Linengrow's SLC product gets designed and **seen** — every surface a pure fold from Weave to the frame, per the three living essays. Opened `20260708.021912` from the grain-sketchbook mining ([study](../external-research/20260708-021912_grain-sketchbook-realidream-mining.md) · [counsel](../counsel/20260708-021912_claude-counsel-realidream-zig016-brix.md)); the sketchbook's unified DAG UI backend (Aurora + Skate + Realidream) is this lane's direct ancestor, its event DAG the unsigned ancestor of Weave itself.*

| Rung | Name | State | Gate |
|------|------|-------|------|
| 0 | **Weave slice + Kumara** | **landed** — I2 export + identity seam; Ed25519 ratchet **0** (`030200`) | — |
| 1 | **SLC-2a drawn terminal (Skate viewer)** | **active rung** — thin view (MALA/WOV **202**); books view (Dimeroll TB + P&L/BS **208**); **sight view** (carriage + books + journal **210**/**290**); assist plain+journal **288**/**289** | already in Now |
| 2 | **Pond's first policy** | held | Pond's own word |
| 3 | **Dexter graduation** | held — a Realidream viewer is the natural second consumer the rule waits for | second consumer arrives |
| 4 | **Realidream** | horizon — ask, receipt, reputation, sanctuary page rendered as views over Weave; thin-view exception proves local facts → frame without Pond/Dexter | rungs 1–3 |

**Gratitude shelf for the lane:** Hyperfiddle (Dustin Getz — UIs as streaming DAGs) · Matklad (project-wide semantic graph) · the Nostr protocol (signed-event, relay-subscribed shape — [`nips/`](../gratitude/nips/)) · TigerBeetle (already kept) · grain-sketchbook (Kaeden's archived prototype — [`grain-sketchbook.md`](../gratitude/grain-sketchbook.md)) · Noah B. (name's artistic source — [`noah-b-realidream.md`](../gratitude/noah-b-realidream.md)). **Affirmed `174500`.** **Departures the lane keeps:** immutable facts re-folded, never nodes patched; meaning per-entry via Tilak, never one shared enum across consumers; values cross seams as Bron, never JSON-in-a-payload.

### The Audio Tilak lane — `.peal`, and Glow over sound (horizon, opened `20260714.023700`)

*Opened from the `anvil/anvil.peal` easter egg — the first audio bytes in the tree (Opus-in-Ogg under a four-letter Glow-compatible mark; gratitude [`../gratitude/OpusOggXiph.md`](../gratitude/OpusOggXiph.md)). A struck anvil should ring, so the forge module carries the first peal.* The lane grows a real capability, smallest-first, so Glow code can process audio as an ordinary value the system already knows how to fold:

| Rung | Name | What it is | Gate |
|------|------|------------|------|
| **A0** | **`.peal` mark exists** | **landed** — a servable Opus-in-Ogg stream at `anvil/anvil.peal`, tracked (not gitignored), decode-verified | done `023700` |
| **A1** | **Peal Tilak** | a Glow type-mark for a `.peal` value: `absorb` (bytes → peal), `express` (peal → duration/channels/bitrate summary, waveform frame), `tend` (peal history in its own grain) — the same three Tilak duties every marked value keeps ([`../context/LEXICON.md`](../context/LEXICON.md)) | Tilak family stable; a real audio consumer asks |
| **A2** | **Peal over Weave** | a peal enters Weave as a content-addressed resin (SHA3 name), so Glow code folds over it exactly as it folds over text and receipts — audio as a first-class value, not a blob beside the system | A1 · Weave resin tiers |
| **A3** | **Brushstroke peal view** | a Brushstroke component that renders a peal's waveform/metadata as an immediate-mode frame — Landscape/Realidream-compatible, drawn from the value every frame, per the three living essays | A2 · Brushstroke frame seam · Realidream rung 1 |
| **A4** | **Maitreya time seam** | playback/decode as a bounded host seam under **Maitreya** (the media driver already named in `LEXICON.md` for audio/video time), so Realidream can play a peal through the same seam Lotus and Linengrow will | A3 · Maitreya first lap |

**Departures this lane keeps (same as Realidream's):** the peal is an immutable signed value re-folded, never a mutable buffer patched; its meaning rides a Tilak, never a shared enum; it crosses seams as Bron-wrapped bytes, never an untyped payload. **The codec stays borrowed and free; the mark stays ours** — anything needing raw Opus re-probes in one step.

---

## The Inference Track — Local Forge (horizon lane, lap 0 opened `20260710.133500`)

*Where Rye-literate models are forged, served, and seen — on Minisforum metal under Aurora/Caravan, with parity as the exam.*

| Rung | Name | State | Gate |
|------|------|-------|------|
| **0** | **Module roots + assist view** | **landed** — Lattice **211**–**217** · Scribble **212** · Lantern **213** · Anvil corpus **214**–**216** · `assistviewtest` **215** | Kaeden go-forth `133500` |
| **1** | **Corpus query + matrix add + rye snippets** | **landed** `20260710.134200`–`134800` — Anvil query **216**; Lattice add **217**; Scribble extract **218** | — |
| **1b** | **Allow-list · rish snippets · assist sight · forge query unified** | **landed** `20260710.180747` — Lantern **252**; Scribble **253**; assist sight **254**; forge query unified **255** | — |
| **1c** | **Forge query device · reshape · temp/seed · corpus view** | **landed** `20260710.181653` — forge query device **256**; Lattice reshape **257**; Lantern temp/seed **258**; corpus view **259** | — |
| **1d** | **Reduce · headings · scribble view · assist rye/rish** | **landed** `20260710.182118` — Lattice reduce **260**; Scribble headings **261**; scribble view **262**; assist kinds **263** | — |
| **1e** | **Scale · corpus prefix · assist sight kinds · exception view** | **landed** `20260710.182502` — Lattice scale **264**; corpus prefix **265**; assist sight kinds **266**; exception view **267** | — |
| **1f** | **Transpose · corpus rish · paragraphs · P&L view** | **landed** `20260710.185542` — Lattice transpose **268**; corpus rish **269**; Scribble paragraphs **270**; P&L view **271** | — |
| **1g** | **Mul · paragraphs view · BS view · top_p** | **landed** `20260710.185947` — Lattice mul **272**; paragraphs view **273**; BS view **274**; Lantern top_p **275** | — |
| **1h** | **Fill · TB view · fence kinds view · err_stop** | **landed** `20260710.190319` — Lattice fill **276**; TB view **277**; fence kinds view **278**; Lantern err_stop **279** | — |
| **1i** | **Copy · rye prefix view · plain snippets · stop_sequence** | **landed** `20260710.190800` — Lattice copy **280**; rye prefix view **281**; plain snippets **282**; Lantern stop_sequence **283** | — |
| **1j** | **Sub · journal view · plain view · stop_sequence pin** | **landed** `20260710.191112` — Lattice sub **284**; journal view **285**; plain view **286**; Lantern stop pin **287** | — |
| **1k** | **Assist/sight composition — plain + journal** | **landed** `20260710.192018` — assist lap 5 **288**; assist sight lap 3 **289**; Linengrow sight lap 2 **290** | — |
| **1l** | **Neg · chart view · tools prefix · prompt pin** | **landed** `20260710.192749` — Lattice neg **291**; chart view **292**; tools prefix **293**; Lantern prompt pin **294** | — |
| **1m** | **Div · rye snippets view · dimeroll/ prefix · max_tokens pin** | **landed** `20260710.193358` — Lattice div **295**; rye snippets view **296**; dimeroll prefix **297**; Lantern max_tokens pin **298** | — |
| **1n** | **Mean · rish snippets view · sight chart · text pin** | **landed** `20260710.200203` — Lattice mean **299**; rish snippets view **300**; sight chart **301**; Lantern text pin **302** | — |
| **1o** | **Abs · apps prefix · assist chart · temperature pin** | **landed** `20260710.200819` — Lattice abs **303**; apps prefix **304**; assist chart **305**; Lantern temperature pin **306** | — |
| **1p** | **Clamp · heading depth · assist chart · seed pin** | **landed** `20260710.211930` — Lattice clamp **307**; Scribble depth+h1 **308**; assist chart **309**; Lantern seed pin **310** | — |
| **1q** | **Reduce_max · h2 view · sight P&L · TopPMismatch** | **landed** `20260710.211930` — Lattice reduce_max **311**; h2 view **312**; sight P&L **313**; Lantern TopPMismatch **314** | — |
| **1r** | **Reduce_min · h3 · rye+candy · err_stop pin** | **landed** `20260710.212715` — Lattice reduce_min **315**; h3 view **316**; rye+dimeroll **317**; Lantern err_stop pin **318** | — |
| **1s** | **Sqrt · rish+tools · assist P&L · length_stop pin** | **landed** `20260710.212715` — Lattice sqrt **319**; rish+tools **320**; assist sight P&L **321**; Lantern length_stop pin **322** | — |
| **1t** | **Exp · depth tally · sight BS · empty allow-list** | **landed** `20260710.213317` — Lattice exp **323**; depth tally **324**; sight BS **325**; empty allow-list **326** | — |
| **1u** | **Log · rye+apps · assist P&L · allow_count pin** | **landed** `20260710.213317` — Lattice log **327**; rye+apps **328**; assist P&L **329**; allow_count pin **330** | — |
| **1v** | **Pow · tally · sight TB · dual-model allow** | **landed** `20260710.213738` — Lattice pow **331**; tally **332**; sight TB **333**; dual-model **334** | — |
| **1w** | **Relu · assist BS · require_model** | **landed** `20260710.213738` — Lattice relu **335**; assist sight BS **336**; assist view BS **337**; require_model **338** | — |
| **1x** | **Sigmoid · blocks · sight exceptions · stopped eos** | **landed** `20260710.214145` — sigmoid **339**; blocks **340**; sight exceptions **341**; stopped eos **342** | — |
| **1y** | **Softmax · assist exceptions · stopped length** | **landed** `20260710.214145` — softmax **343**; assist sight/view exceptions **344**/**345**; stopped length **346** | — |
| **1z** | **Tanh · fence+heading · sight ex reason · stream false** | **landed** `20260710.215613` — tanh **347**; fence+heading **348**; sight ex reason **349**; stream false **350** | — |
| **1aa** | **Gelu · assist ex reason · stream true** | **landed** `20260710.215613` — gelu **351**; assist sight/view ex reason **352**/**353**; stream true **354** | — |
| **1ab** | **Silu · tally+blocks · sight ex2 · stopped err_stop** | **landed** `20260710.223639` — silu **355**; tally+blocks **356**; sight ex2 **357**; stopped err_stop **358** | — |
| **1ac** | **Leaky ReLU · assist ex2 · stopped stop_sequence** | **landed** `20260710.223639` — leaky_relu **359**; assist sight/view ex2 **360**/**361**; stopped stop_sequence **362** | — |
| **1ad** | **Softplus · para+blocks · sight tallies · top_k** | **landed** `20260710.224322` — softplus **363**; para+blocks **364**; sight tallies **365**; top_k **366** | — |
| **1ae** | **Maximum · assist tallies · frequency_penalty** | **landed** `20260710.224322` — maximum **367**; assist sight/view tallies **368**/**369**; frequency_penalty **370** | — |
| **1af** | **Minimum · h1+blocks · sight kinds · presence_penalty** | **landed** `20260710.224805` — minimum **371**; h1+blocks **372**; sight kinds **373**; presence_penalty **374** | — |
| **1ag** | **Elu · assist kinds · n pin — lap 1 close** | **landed** `20260710.224805` — elu **375**; assist sight/view kinds **376**/**377**; n pin **378**; **Inference Track lap 1 closed** | — |
| **Anvil corpus lap 2** | **min/max lines · path_suffix · sum_lines + views** | **landed** `20260710.225320` — filters **379**–**382**; Skate views **383**–**386**; **Anvil corpus lap 2 closed** | keep-going after lap-1 close |
| **Dimeroll lap 4** | **account/memo filters · cash flow · sum amounts + views** | **landed** `20260710.230433` — filters **387**–**390**; Skate views **391**–**394**; **Dimeroll lap 4 closed** | keep-going after Anvil lap 2 |
| **1ah** | **Softsign · h2+blocks · square · tokens_out** | **landed** `20260710.231151` — softsign **395**; h2+blocks **396**; square **397**; tokens_out **398** | — |
| **1ai** | **Sign · h3+blocks · reciprocal · tokens_in — fixture deepen close** | **landed** `20260710.231151` — sign **399**; h3+blocks **400**; reciprocal **401**; tokens_in **402** | — |
| **1aj** | **Hard sigmoid · rye+blocks · rsqrt · echo** | **landed** `20260710.232158` — hard_sigmoid **403**; rye+blocks **404**; rsqrt **405**; echo **406** | — |
| **1ak** | **Hardtanh · rish+blocks · cube · user — fixture deepen lap close** | **landed** `20260710.232158` — hardtanh **407**; rish+blocks **408**; cube **409**; user **410** | — |
| **Glass composition** | **blocks · fence-rye · echo · user on assist/sight** | **landed** `20260710.234004` — assist/sight folds **411**–**418**; glass composition lap closed | keep-going after fixture deepen |
| **2** | **ROCm host seam** | horizon | hardware + ship policy; opens after lap-1 close |
| **3** | **Lantern in Pond** | horizon | Pond policy word |
| **4** | **Anvil LoRA + eval** | horizon | Tablecloth checkpoints |
| **5** | **Live editor assist** | horizon | Wayland metal + rung 3 |

Essay: [`external-research/20260710-133500_local-forge-minisforum-inference.md`](../external-research/20260710-133500_local-forge-minisforum-inference.md) · hammock: [`active-designing/20260710-133500_inference-stack-lap0-hammock.md`](../active-designing/20260710-133500_inference-stack-lap0-hammock.md) · progress: [`20260710-220706_slc-and-inference-progress.md`](20260710-220706_slc-and-inference-progress.md)

**Lap 1 close (`224805`):** the fixture-served contract family is whole — activations through ELU/min/max, sampling pins through `n`/`presence_penalty`, Scribble combos, and exception folds on glass. **Anvil corpus lap 2** (`225320`) deepens catalog filters through tip **386**. **Dimeroll lap 4** (`230433`) deepens journal filters and cash flow through tip **394**. Further Inference Track work opens at rung **2** (ROCm) or another named lap on Kaeden's word.


---

## Horizon 3 — Deliberated horizons (not today's primary track)

| Horizon | What |
|---------|------|
| **Steep** | Peer file sharing — sealed content-addressed pieces; TAME Rye alternative spirit to BitTorrent; named `210433` — [`hammock`](../active-designing/20260710-210433_steep-peer-file-sharing-name.md); first lap not opened |
| **Language fork** | Self-hosted compiler, Rye-native `std` — revisited from a **mature whole** when RISC-V-first genuinely demands it ([`20260628-043542` direction](../active-designing/20260628-043542_thin-frontend-slc-direction.md)) |
| **Whole machine** | Aurora on RISC-V, full desktop, Brushstroke web-portable, Rye OS on open silicon |
| **Inference stack** | **Lap 1 closed** tip **378**; Anvil **386**; Dimeroll lap 4 **394**; fixture deepen **410**; glass composition tip **418** (`234004`); RW-5 tips **420**/**421** (`005028`); assist integration tip **428** (`025301`); next rung **2** ROCm (horizon) |

Prior fork steps F0–F5 remain documented in [`active-designing/yonder/20260621-070712_the-compiler-fork.md`](../active-designing/yonder/20260621-070712_the-compiler-fork.md) as **research**, not the active build order.

---

## Horizon 1 — What to Build Next

### Build (SLC 1 first)

**Gate before the SLC-1 merge:** ~~`rishi/bin/rishi run tools/parity.rish` green once on metal~~ **done** (`2026-06-28`) — parity suite green; SLC-1 witnesses registered (now **132** total with hosted `width-check`).

**SLC-1 build order** (granular; mirrors [`TASKS.md`](TASKS.md)):

| Step | Verb | What lands | Witness |
|------|------|------------|---------|
| **1 — type + run** | Type, Run | `rishi repl`; prompt `rishi> `; in-process eval; shared `Env`; `:quit` / `:q` | `tools/slc1_repl_step1.rish` — binding carry-forward |
| **2 — version** | Version | Session buffer; `.mantra/session.log` transcript; `:history`; lazy `mantra init`; `:version` → `mantra add` | `tools/slc1_version_step2.rish` — HEAD advances; blob in `.mantra/blobs/` |
| **3 — recall** | Recall | `:recall <n>` and `!<n>`; in-session rerun via `runInputLine` | `tools/slc1_recall_step3.rish` — prior line re-runs |
| **accept** | all four | Meta-commands in `rishi/README`; the trio on metal | `tools/slc1_accept.rish` — type, run, version, recall in one session |

**SLC-1 is done** on its functional promise (`2026-06-29`). **TAME hardening is complete** (`2026-06-29`) — TH-0–TH-7, RS-1–RS-3, hosted `width-check` blocking in parity (132 witnesses). The bench turns to the next product lap.

**Landed since this section was drawn:** SLC-2a Laps 1–3 witnessed with metalsmoke GREEN (parity **140**); Caravan capability table (`2026-06-30`); RW-3 and RW-4 (**141**, **142**); fixture twins in Rishi; the manual's first reference and tutorial.

**The current position — doors closed, ladder open** (granular boxes in [`TASKS.md`](TASKS.md)):

| Step | Owner | Parity |
|------|-------|--------|
| Door 1 — Pond clause · Door 2 — Lap 3 metal close · Door 3 — Edit 5 ruling | **Kaeden** | ✅ closed |
| Edit 5 wired | Cursor | **143** ✅ |
| **Amber first lap** — five rungs (a)–(e) | Cursor | **144** ✅ |
| SLC-2b — keyboard from the window, Dexter's genesis | Cursor | **145** ✅ |
| RW-1 mirrored pair — Rishi↔Mantra seam | Cursor | **147** ✅ |
| Chrono version sweep — authored surfaces | Cursor | **148** ✅ |
| RW-2 mirrored pair — app↔Brushstroke seam | Cursor | **150** ✅ |
| Happy-zone second pass — Inference Track | Cursor | audit `001225` ✅; next season **RW-5** |
| Commerce steward demo — list → settle → Dimeroll | Cursor | **419** ✅; live TB still Rest-until |
| RW-5 mirrored pair — Drawn Terminal ↔ Lantern | Cursor | **420**/**421** ✅; contract `005028` |
| Steward composition — list → settle → Dimeroll on Skate | Cursor | **422** ✅; hammock `010030` |
| Steward sight — livelihood + books on one Skate frame | Cursor | **423** ✅; hammock `011254` |
| Granary weave steward — list → settle → Dimeroll on Skate | Cursor | **424** ✅; hammock `012451` |
| Granary steward sight — weave + books on one Skate frame | Cursor | **425** ✅; hammock `014304` |
| Open Asks view — closed ask loop on Skate | Cursor | **426** ✅; hammock `014454` |
| Open Asks escrow view — Nyasa hold/release on Skate | Cursor | **427** ✅; hammock `015106` |
| RW-5 assist integration — assist glass asks complete_fixture | Cursor | **428** ✅; contract `005028` |
| Open Asks reputation view — consent-before-counting on Skate | Cursor | **429** ✅; hammock `030123` |
| Open Asks civic sight — lifecycle · escrow · consent on Skate | Cursor | **430** ✅; hammock `032657` |
| Door 3 consumer-edge pass — access vs truth (in-process) | Cursor | **431** ✅; hammock `063213` |
| receipt-verify Wasmtime guest — component compile lap | Cursor | **432** ✅; hammock `063558` |
| Vocabulary ground — TWO_ROOMS seat · canonical gloss · doorway witness | Cursor | **153** ✅ |

**Season (`20260705.203144`):** **Linengrow-via-Comlink** — ground first, then **Comlink device wire** (Rye spine step that unlocks SLC-L2 sealed delivery). Zip **47** seals the astrology silo bench (`e8d1919`). **Landed through tip 430** — civic glass arc closed; hold menu [`counsel/20260711-033228_hold-at-tip-430.md`](../counsel/20260711-033228_hold-at-tip-430.md).

**Season (`20260712.052806`):** **Seam season** — nib-430 horizon door named. Universality through the application seam (portable ABI + sealed record carriage + consumer-edge pass), not the hardware summit. **Four RTAC studies landed** through `054521`. CapTP-as-fold declined on counsel (formal seat awaits word); Spritely teacher now / ally after two-sided witness; Caravan stays named horizon (guest, never merger); giving-lane asymmetry filed (private payer · transparent payee). Granular boxes in [`TASKS.md`](TASKS.md).

Still on the prior horizon, after vocabulary ground: **Comlink device wire** — sealed datagram over virtio-net between two QEMU guests — **landed**; **Rishi builtins** as-you-touch.

### Ground (thin frontend)

7. **Std re-fork** — **done** (`20260628`) — pristine symlink; see [`archive/20260628-044300_std-refork-plan.md`](archive/20260628-044300_std-refork-plan.md).

### Study

8. **Display-layer study** — Wayland specs; Ghostty (MIT) for Skate.
9. **Close reading** — Comlink packet format from `gratitude/` before format hardens.

**Retired from active track:** strengthening sweep; pass 9886 as chronicle continuation; "fork is the priority."

---

## Horizon 1.5 — Seam season (studies now · `20260712.052806`)

*Opened from the nib-430 horizon-brief door. Studies only; nothing seats CapTP as fold carriage or names an institutional ally today. Pass = door, record = room.*

| Study | What | Status |
|-------|------|--------|
| **1** | Capability-protocol idiom (OCapN) beside Comlink’s sealed datagram | **Landed** [`053324`](../external-research/20260712-053324_ocapn-beside-comlink.md) |
| **2** | One existing seed through a component-model / Wasm target | **Landed** [`054135`](../external-research/20260712-054135_component-model-one-seed.md) — **`receipt_core`** |
| **3** | Proven-seat guest (Genode / seL4) for Rye userland — Caravan stays horizon | **Landed** [`054342`](../external-research/20260712-054342_proven-seat-guest-genode-sel4.md) |
| **4** | Giving-asymmetric money (GNU Taler) for Linengrow’s giving lane | **Landed** [`054521`](../external-research/20260712-054521_taler-giving-lane-asymmetry.md) |

**Four Seam studies complete.** **Seated:** CapTP-as-fold **declined** [`054650`](../context/specs/20260712-054650_captp-as-fold-carriage-declined.md) · giving-lane T0 in money-close-to-home · **T1 gap map** [`054942`](../active-designing/20260712-054942_giving-lane-t1-open-asks-field-map.md). **Parked:** Spritely ally · Door 3 · component compile · proven-seat G0–G3 · giving T2.

## Horizon 1.6 — Proposed destinations (`20260712.093812`)

*Additions-only from the Fable study bundle. Studies and rows — nothing opened as a lap. Infusion map [`093812`](../external-research/20260712-093812_infusion-map.md).*

| Destination | Status | Depends |
|-------------|--------|---------|
| **Mesh inference (TAME-guided)** | Horizon study [`093812`](../external-research/20260712-093812_mesh-inference-study.md) — Kumara-admitted · MALA-metered; not a lap. **Sobriety anchor:** IronBeetle ep004 COST [`../gratitude/ironbeetle/20260712-092212_ironbeetle-ep004-refuses-to-be-sharded.md`](../gratitude/ironbeetle/20260712-092212_ironbeetle-ep004-refuses-to-be-sharded.md) — beat one honest thread before scaling counts | Comlink · Mycelium M4 · seL4 seat · model-runtime seam |
| **Proven-seat G1–G3 children** | **G1 closed digest-grade** `204549` · **signed-Kumara GREEN resting** `220400` · **G2 naming open** (seL4-kernel-swap · hw-kernel · Sculpt-integration) — counsel [`092212`](../counsel/20260712-092212_claude-counsel-hoon-azimuth-ames-verdicts.md) · seam-C [`220400`](../active-designing/20260712-220400_proven-seat-seam-c-and-rye-body.md) | **`lane_kvm` on-path GREEN** `140403` · G2 word before G3 lap |
| **Comlink maturation** | Key-addressing · `%fade` from birth · content-address dedupe — shared prerequisite for Genode transport + mesh | RTAC seat |

**Dependency ladder:** [`093812`](../external-research/20260712-093812_dependency-ladder.md) · **Matklad distilled:** [`093812`](../external-research/20260712-093812_matklad-teachings-distilled.md).

## Horizon 2 — Compose the Simples

- [ ] **Pond GUI** — SLC 2
- [ ] **Comlink v1** — typed, content-named, sealed delivery (sealed datagram stays fold carriage; consumer-edge pass is a later composition)
- [ ] **Brix v1** — lawful composition + content-addressed store
- [ ] **Tablecloth v1** — storage for Pond applications
- [ ] **Caravan v1** — supervision tree with capability table (proven-seat guest is study, never merger)
- [ ] **Pond v1** — policy as value
- [ ] **The Forge** — Mantra served, Brushstroke drawn, Comlink replicated
- [ ] **The TAME Editor** — select-then-act in Skate
- [ ] **Comlink Remoting** — value-based state sync over UDP
- [ ] **Unified keys** — one owner seed deriving all keys
- [ ] **Portable component seam** — one ABI for browser / rented server / later Caravan host (Seam study 2)

---

## The Discipline

- **Ship something simple, lovable, and complete at every step.**
- **Grow; never design the whole from scratch.**
- **Prove each step through its witnesses.**
- **Safety lives in authored code** — assert at call sites; pristine `std` you lean on.
- **Keep it loose and single-stranded.**
- **Two-thirds implementation, one-third design.**

---

*May we grow the whole from what already works, and trust each small running thing as it carries the next. May every horizon arrive by degrees, never by a leap. And may the system we build stay simple enough, at every stage, to be loved, understood, and grown a little further tomorrow.*
