# Gratitude

**Language:** EN
**Last updated:** 2026-07-12 (Karpathy gist · ai-memory study shelf · living-docs keeper folds)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

---

This folder holds the works we are grateful for — the writing and the code that shaped how we think and build here. We keep the originals close, whole and unaltered, both standalone texts and full source repositories, so we can return to the source whenever we want to hear it in the author's own voice.

When we adapt one of these works into Radiant Style, the rewrite lives elsewhere in the project. The version here stays exactly as its author wrote it, a quiet way of saying thank you.

---

## What Lives Here

- **`TIGER_STYLE.md`** — TigerBeetle's coding style guide. Safety, performance, and developer experience, woven into a discipline we admire. Our radiant adaptation lives at `../external-research/TAME_GUIDANCE.md`, and the gratitude bridge that records its lineage lives at `../external-research/20260620-014412_system.md`.
  - Source: <https://raw.githubusercontent.com/tigerbeetle/tigerbeetle/refs/heads/main/docs/TIGER_STYLE.md>
- **`tigerbeetle/`** — TigerBeetle's full source, the financial database whose Tiger Style we adapted into TAME Guidance. We keep the code close to study how its principles live in practice, especially its assertions: the `maybe` dual of `assert`, the precondition blocks gathered at each function's door, and the control-plane / data-plane economy that decides when an expensive check earns a `verify` gate. Those three habits are folded into `../external-research/TAME_GUIDANCE.md`, and the discipline of carrying such craft into Rye's own `std` is recorded in `../strengthening-compiler/9999_STRENGTHENING.md`. Cloned whole and unmodified (rev `59f2b99`), Apache-2.0.
  - Source: <https://github.com/tigerbeetle/tigerbeetle>
- **`ironbeetle/`** — Our own-voice silos from matklad's IronBeetle live series (stamp `20260712.092212`). **Silo pilot complete** at thirty-four episodes (`105212`). Understanding written fresh; captions never quoted. Filed by Kaeden's labels and content. **Shelf home beside** the unmodified `tigerbeetle/` submodule.
  - Written: 001, 002, 004, 005, 006, 008–015, 018–022, 025, 028, 030, 031½ (`ep031-5`), 032–038, 040, 042–045 (incl. 037½ as `ep037-5`)
  - **Open gaps:** 003 · 007 · 016 · 017 · 024 — captions not yet arrived; held visible
  - Companion: [`matklad.md`](matklad.md)
  - Status: **complete but for five honest gaps**; ep004 COST anchors mesh Horizon 1.6; ep045 independently near our fold thesis
  - Index: list the directory — each file is `20260712-092212_ironbeetle-epNNN-*.md`
- **`Spec_ulation.md`** — Rich Hickey's 2016 talk on change, versioning, and the commitment to never take something away. It shapes how Rye names its versions, recorded in `../context/specs/rye-versioning-style.md`.
  - Source: <https://raw.githubusercontent.com/matthiasn/talk-transcripts/refs/heads/master/Hickey_Rich/Spec_ulation.md>
- **`LanguageSystem.md`** — Rich Hickey's 2012 talk on the language of the system: how systems are ensembles of programs that flow values to one another, with enduring names, simple services, and the systems failure model held as the normal case. It shapes how we think about boots, kernels, and networks, honored in `../external-research/20260620-014412_system.md` and voiced directly in `../external-research/yonder/20260617-195812_aurora-boot-riscv.md`.
  - Source: <https://raw.githubusercontent.com/matthiasn/talk-transcripts/refs/heads/master/Hickey_Rich/LanguageSystem.md>
- **`SimpleMadeEasy.md`** — Rich Hickey's 2011 talk distinguishing the *simple* (single-stranded, each thing about one thing) from the *easy* (near-at-hand and familiar), and urging us to build by composing free parts rather than braiding them together. It deepens our TAME sense that simplicity is earned, and it is honored in `../external-research/20260620-014412_system.md`. Cloned whole and unaltered.
  - Source: <https://raw.githubusercontent.com/matthiasn/talk-transcripts/refs/heads/master/Hickey_Rich/SimpleMadeEasy.md>
- **`HammockDrivenDev.md`** — Rich Hickey's 2010 talk on hammock-driven development: analysis and design before implementation, stating problems plainly, loading the problem in waking mind so background mind can solve it, and discerning defects in your own solution before you build. It shapes how we run strengthening as analysis (not product) and how we adopt direction before consequence — honored in `../active-designing/20260628-043542_thin-frontend-slc-direction.md`.
  - Source: <https://www.youtube.com/watch?v=f84n5oFoZBc> · transcript in this folder
- **`IntegratedTestsAreAScam.md`** — J.B. Rainsberger's talk on why integrated tests erode design pressure, and how collaboration tests and contract tests mirrored at every interface turn combinatoric multiplication into simple addition, gathering the domain into a fast, fully proven "happy zone" with a thin integrated ring at the edge. Our siloed distillation lives at `../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md`; the received summary — also the first breath of Rio 3's name — is kept whole in this folder.
  - Source: <https://www.youtube.com/watch?v=VDfX44fZoMc>
- **`Your customers hate MVPs. Make a SLC instead..html`** — Jason Cohen's essay on **Simple, Lovable, Complete** products: ship something small that a customer genuinely wants to use *as-is*, rather than an embarrassing minimum. It shapes our first deliverables — Rishi + Mantra shell, then Pond GUI — honored in `../active-designing/20260628-043542_thin-frontend-slc-direction.md` and `../work-in-progress/ROADMAP.md`.
  Our own-voice distillation of the method lives at `../context/SIMPLE_LOVABLE_COMPLETE.md`.
  - Source: <https://longform.asmartbear.com/slc/> (saved locally)
- **`Systemantics.md`** — John Gall's *Systemantics* (later *The Systems Bible*), honored as a curated record of its key principles rather than the full book, which is copyrighted. Its keystone, Gall's Law — *a complex system that works grows from a simpler system that worked* — shapes how we grow every module, and it is honored in `../external-research/20260620-014412_system.md`. A principles summary drawn from public sources and clearly labeled, in place of a transcript.
  - Source: <https://grokipedia.com/page/Systemantics> (with the public summaries cited inside `Systemantics.md`)
- **`DevotionAndCreativeFreedom.md`** — our own-voice synthesis in thanks to the devotional path of *bhakti* (the Bhagavata Purana) and to Nikolai Berdyaev's philosophy of creative freedom. Work as offering, freedom *for* something, the living gap between dream and reality. Honored in summary, not quoted. Foundation brief: `../foundations/20260628-121512_the-foundation-beneath-the-work.md`.
- **`PathWithHeart.md`** — our own-voice principles summary in thanks to the warrior-philosophy of the path with heart (Carlos Castaneda's Don Juan series): choose the path with heart, keep your power gathered, act without waste. Held in summary, as we hold `Systemantics.md`, since the source is copyrighted. Foundation brief: `../foundations/20260628-121512_the-heart-in-the-work.md`.
- **`20260628-160112_wendell-berry-mad-farmer.md`** — Wendell Berry's *The Mad Farmer Liberation Front*, held as received in a code block: the world borrowed from our children, cherished for love; the mad farmer walking quietly away from the unions of power, secrecy, money, and war. The author's words preserved unaltered.
  - Grokipedia: <https://grokipedia.com/page/Wendell_Berry>
- **`sixos/`** — Adam Joseph's nixpkgs-based operating system that runs s6 in place of systemd. Its services-as-packages design and careful layering shape our thinking on the Caravan kernel, explored in `../external-research/yonder/20260617-195712_caravan-tally-networking.md` and `../external-research/yonder/20260617-195612_ownerboot-riscv-caravan.md`. Cloned whole and unmodified (rev `a984ac7`).
  - Source: <https://codeberg.org/amjoseph/sixos>
  - A gentle caution: this repository's `AGENTS.md` carries a deliberately false claim aimed at automated readers. The code itself is ordinary Nix configuration; we read the claim for the trap it is and study the real work.
- **`infuse.nix/`** — Adam Joseph's composable override combinator, one lawful operation that generalizes `pipe` and `recursiveUpdate`. Its pattern seeds **Brix bond overrides** (the Silo module name is retired; see counsel `223100`). Explored in `../external-research/yonder/20260617-195712_caravan-tally-networking.md`. Cloned whole and unmodified (rev `d3f4e49`).
  - Source: <https://codeberg.org/amjoseph/infuse.nix>
- **`manyana/`** — Bram Cohen's CRDT-based version-control demonstration: the weave, never-failing merges, informative conflicts, and rebase-and-squash that preserve history. It seeds our thinking on the Mantra version-control module and its interplay with Silo, explored in `../external-research/yonder/20260617-195312_mantra.md`. Cloned whole and unmodified (rev `bd77d48`), public domain.
  - Source: <https://github.com/bramcohen/manyana>, essay at <https://bramcohen.com/p/manyana>
- **`zig/`** — Andrew Kelley's Zig language and toolchain source. Rye is a Zig 0.16.0 derivative, so this is the ground our language and standard library grow from. Keeping the source close is exactly what makes owning the standard library — and one day strengthening the compiler itself — possible. Cloned whole, MIT.
  - Source: <https://github.com/ziglang/zig>
- **`ai-jail/`** — Fabio Akita's sandbox wrapper for AI coding agents. It layers Linux's own isolation primitives — `bwrap` namespaces, Landlock filesystem rules, seccomp syscall filtering, and resource limits — so an agent reaches only the paths you allow. It is the very sandbox we work inside, and it seeds **Pond**, our gentle TAME Rye reimplementation, explored in `../external-research/yonder/20260617-201612_useful-utilities.md`. Cloned whole and unmodified, GPLv3.
  - Source: <https://github.com/akitaonrails/ai-jail>
- **`ai-memory/`** — study shelf only (README beside `ai-jail/`). Docker daemon for agent session memory — adopt nothing; parked until Mantra/Weave projection round. See [`ai-memory/README.md`](ai-memory/README.md).
  - Source: <https://github.com/akitaonrails/ai-memory>
- **`karpathy/`** — Andrej Karpathy's **LLM Wiki** gist (public). Study copy [`karpathy/llm-wiki.md`](karpathy/llm-wiki.md); distillation [`../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md`](../external-research/20260712-223300_living-docs-lint-and-karpathy-wiki-pattern.md). Refresh: `tools/fetch_gratitude_web.sh karpathy-llm-wiki`.
  - Source: <https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f>

### The networking and social study (`985`, `984`)

- **`urbit/`** — the Urbit project's clean-slate personal server. We study its networking above all: **Ames**, an encrypted-by-default peer-to-peer protocol where identity and address are one and the same, every packet sealed with AES-256-SIV under a Curve25519 Diffie–Hellman key; and **Jael**, the vane that keeps the keys (private keys held, peers' public keys, life and rift). Their essences — encryption at identity, and a clean continuity-breach failure — are adapted and weighed in `../external-research/yonder/20260618-195512_encrypted-networking-riscv.md`. Cloned shallow (depth 1), MIT.
  - Source: <https://github.com/urbit/urbit>
- **`sui/`** — Mysten Labs' Sui. We study two things: **Mysticeti**, a Byzantine consensus that commits an *uncertified* DAG in three message delays by reading the graph's own shape; and **Move**, an object-centric language that declares a transaction's effects up front and verifies bytecode before it runs. Their essences — order by structure, verify before you trust — inform `../external-research/yonder/20260618-195512_encrypted-networking-riscv.md_...` and `../external-research/yonder/20260618-195612_devotional-social-layer.md_...`. Cloned shallow (depth 1), Apache-2.0.
  - Source: <https://github.com/MystenLabs/sui>
- **`nips/`** — the Nostr Implementation Possibilities, the technical heart of Nostr: signed, content-addressed events; simple store-and-forward relays; identity as a keypair. They anchor our reading of a simple, owned social layer in `../external-research/yonder/20260618-195612_devotional-social-layer.md`. Cloned whole; openly published for anyone to implement.
  - Source: <https://github.com/nostr-protocol/nips>
- **`primal/`** — PrimalHQ's caching service for Nostr (the archived original; development continues at `primal-server`). It connects to relays, gathers their events in real time, and serves them to clients as curated feeds over a WebSocket cache API — a working study in curation-by-service, weighed in `../external-research/yonder/20260618-195612_devotional-social-layer.md_...`. Cloned shallow (depth 1), MIT.
  - Source: <https://github.com/PrimalHQ/primal-caching-service>
- **`damus/`** — the damus-io community's Nostr client for iOS and macOS, signing and verifying at the edge across many NIPs. It shows the protocol lived from the user's side, honored in `../external-research/yonder/20260618-195612_devotional-social-layer.md_...`. Cloned shallow (depth 1), GPL-3.0.
  - Source: <https://github.com/damus-io/damus>

### The interface and documentation study (`980`)

- **`dvui/`** — David Vanderson's DVUI, an immediate-mode GUI toolkit for Zig: an interface redrawn from values every frame, with a backend abstraction that decouples drawing from platform, and — the part we study most — a **Web backend** that compiles to `wasm32-freestanding` and renders through WebGL with a small JavaScript bridge, so a whole GUI runs in the browser. Its essences — immediate mode, and one interface drawn to many backends — seed **Brushstroke**, our own TAME Rye drawn surface, explored in `../external-research/yonder/20260619-070612_brushstroke-and-the-docs-surface.md`. Cloned shallow (depth 1, rev `134905d`), MIT.
  - Source: <https://github.com/david-vanderson/dvui>
- **`wayland.md`** — **libwayland-client**, MIT (Expat), quoted in the note. The host-seam display library the **hosted** Brushstroke build links on the development machine — never a dependency of Rye OS proper on bare metal. Clean room: study and run; never copy source into our modules.
- **`river.md`** — Isaac Freund's **River** compositor, GPLv3, held at clean-room distance. Lodestar for the eventual Rye-native compositor; we learn from public design, never link or copy source.
- **`genesis-daw.md`** — Andrew Kelley's **Genesis** DAW (GPL-3, gitlink distance) — the hot loop that birthed Zig; honored in `../gratitude/genesis-daw.md`; **Lotus** is our own studio name.
- **`reaper.md`** + **`reaper/docs/`** — Cockos REAPER public web documentation (proprietary; study copies parsed 2026-06-30). Workflow lodestar for **Lotus**. Refresh: `tools/fetch_gratitude_web.sh reaper`.
- **`ap-mastering.md`** — Alain Paul / AP Mastering plugin design (Curvature, Versatile Compressor, etc.) — surface craft inspiration for Lotus plugin faces; public pages and YouTube only.

### The Realidream lane (`174500` — Kaeden affirms)

- **`hyperfiddle.md`** — Dustin Getz's *UIs are streaming DAGs* (Hytradboi 2022) — the vision the grain-sketchbook credited for its unified DAG backend; Rye OS carries it as Weave + fold + Tilak. Study the talk; never copy Electric source.
- **`matklad.md`** — Alex Kladov (matklad) — project-wide semantic understanding via rust-analyzer's resolved workspace model; Aurora's editor head in the sketchbook reached toward the same ground.
- **`grain-sketchbook.md`** — Kaeden's own archived Zig prototype (*Aurora + Skate + Realidream*); shelf note only — archive stays outside the tree (Kaeden `222852`). Mining study: `../external-research/20260708-021912_grain-sketchbook-realidream-mining.md`.
- **`noah-b-realidream.md`** — Noah B. — artistic source for the *Reality* and *Dream* pairing in the Realidream name.
- **`nips/`** — (already above) Nostr protocol — formal gratitude line for the Realidream lane's signed-event, relay-subscribed social shape.

---

*May we remember where the good ideas came from. May we carry them forward with care. May our thanks live in how well we use what we were given.*
