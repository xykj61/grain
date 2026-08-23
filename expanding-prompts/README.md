# Expanding Prompts

*A place where a request becomes a plan. When you hand me a seed of intent, I bring it here, read it closely through every lens we have built, and craft from it a fuller, clearer prompt for myself — one I can then run. The seed stays yours; the expansion is how I make sure I have understood it, sharpened it, and lost none of it.*

**Language:** EN
**Last updated:** `20260811.211431` (AHOY front-door season · **ty every1** closing gesture seated)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Kyri
**Seasons roster:** [`SEASONS.md`](SEASONS.md)

---

## Why This Stack Exists

A prompt is a seed. It carries intent — often more than its words say outright, and sometimes a little less than it means. The other stacks here grow outward from decisions already made; this one grows *inward* first. It takes what you asked and expands it into a working specification before any of it is built.

The practice is simple, and I mean it kindly: I restate your intent in full, I name the deliverables plainly, I apply our active-designing principles, our TAME lens, and the radiant voice, and I add the questions and structure that will make the work good. Then I run that expanded prompt. Nothing of yours is dropped; what I add is scaffolding, never substitution.

Why keep them at all? Because a prompt well understood is half the work, and a prompt misunderstood is the most expensive mistake there is. Writing the expansion down lets you see how I heard you — and correct me before, not after.

## The closing gesture — **ty every1**

Every expanded prompt ends on the same warm note the request that seeded it carries: **ty every1** — thank you, everyone. It is a small, sincere gratitude to every hand and mind the work leans on — the reader who asked, the teachers in [`../gratitude/`](../gratitude/README.md) whose ideas we studied in the clean room, the prior seasons whose fossils we build atop, and whoever will run what we wrote. An expansion is a shared act; the closing line says so plainly. Where a prompt carries an earned radiant wish (`../.claude/rules/radiant-wishes-ending.md`), **ty every1** rides just before it, so the benediction stays the last word. It is never an alarm or a flourish — only the honest, glad thanks that closes a good handoff.

## One clock, one order

Dated prompts carry `YYYYMMDD-HHMMSS_short-slug.md`; this README is the living foundation. Full naming law: [`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

**Consumed prompts** — including executed `cursor-*` bench passes and legacy `cursor-prompt_*` files from the one-clock reorg — rest in [`yonder/`](yonder/) when the work they drove has landed. Session logs record the outcome; the prompt stays as an honest record of how the request was expanded.

## Redirects and retired patterns

**Executed prompts** become redirect stubs at the stub-event stamp `20260621-051612` with distinct `-redirect` slugs. See also [`../external-research/README.md`](../external-research/README.md).

**Current tooling (use these):**

| Role | Path |
|------|------|
| Parity gate | `tools/parity.rish` |
| Additive gate | `tools/additive-gate.rish` |
| Strengthening enricher | `tools/enrich_strengthening_docs.rye` |
| Session log aligner | `tools/align_session_logs.rye` |
| Width audit (hosted gate) | `tools/width-check.rish` in `tools/parity.rish`; charter [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md) |


### Topic routing (from retired `10010_reserved`)

| Topic | Lives in |
|-------|----------|
| Tablecloth + Brix compose | [`20260620-043812_tablecloth-brix-split.md`](yonder/20260620-043812_tablecloth-brix-split.md) through [`20260620-044112_tablecloth-v1-seed.md`](yonder/20260620-044112_tablecloth-v1-seed.md) |
| Main track (Rye · Rishi · strengthening · width fork) | [`yonder/20260621-051612_main-track-rye-rishi-strengthening.md`](yonder/20260621-051612_main-track-rye-rishi-strengthening.md) (consumed), [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md), [`../crux/ROADMAP.md`](../crux/ROADMAP.md), [`../crux/TASKS.md`](../crux/TASKS.md) |
| Strengthening doc + width enricher | [`yonder/20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md`](yonder/20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md) → [`../tools/enrich_strengthening_docs.rye`](../tools/enrich_strengthening_docs.rye) |
| Literal `usize` ban / language fork | [`../external-research/20260621-051312_literal-usize-ban-language-fork.md`](../external-research/20260621-051312_literal-usize-ban-language-fork.md), [`../active-designing/yonder/20260621-051312_explicit-width-in-rye.md`](../active-designing/yonder/20260621-051312_explicit-width-in-rye.md), [`../external-research/20260621-050312_usize-boundary-not-design.md`](../external-research/20260621-050312_usize-boundary-not-design.md) |

**Retired in new prompts:** `tools/parity.sh`, `enrich_strengthening_docs.py`, `align_session_logs.py`, `parity.rye` as gate target, `init.arena`, authored `ArenaAllocator`, “`usize` only at seam” as **permanent** policy (interim only — see width fork links above).

**Width:** charter [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md); baseline [`../crux/20260620-212126_usize-width-baseline.md`](../crux/20260620-212126_usize-width-baseline.md); fork research [`../external-research/20260621-051312_literal-usize-ban-language-fork.md`](../external-research/20260621-051312_literal-usize-ban-language-fork.md); design [`../active-designing/yonder/20260621-051312_explicit-width-in-rye.md`](../active-designing/yonder/20260621-051312_explicit-width-in-rye.md); interim seam [`../external-research/20260621-050312_usize-boundary-not-design.md`](../external-research/20260621-050312_usize-boundary-not-design.md).

## What Belongs Here

- The expanded prompt itself: my improved, structured reading of a request.
- A faithful echo of the original intent, so the seed is never lost.
- The lens applied: which principles and filters shaped the expansion.
- The plan I will run, and the deliverables it should produce.

What does *not* belong here is the work itself — that lands in the research, design, and code stacks. This is only where intent is sharpened into a plan.

---

*May every seed be heard in full. May what I add only clarify, never crowd. And may the prompt I write for myself stay truer to your meaning than the bare words could carry alone.*

## Expanded prompts (newest first)

| Stamp | Prompt | Meaning |
|-------|--------|---------|
| `20260728.025220` | [MUR Season u0 recursion](date/20260728/20260728-025220_mur-season-u0-recursion-prompt.md) | **Active walk** — innermost OPEN · u0 bowed · u1 next · Gren CLOSED handback |
| `20260728.012725` | [Constellation Season m0 recursion](yonder/20260728-012725_constellation-season-m0-recursion-prompt.md) | **yonder** · outer PAUSED · not the active walk |
| `20260728.025634` | [Gren Season recursion](yonder/20260728-025634_gren-season-g0-recursion-prompt.md) | **yonder** · Archival — core CLOSED · handed back `return_mur_u0` · living Gren doors |
| `20260728.030310` | [Keeh Season recursion](yonder/20260728-030310_keeh-season-q0-recursion-prompt.md) | **yonder** · Archival — quint CLOSED · handed back `return_gren_g0` · living Keeh/Shyu/Linn doors |
| `20260728.015541` | [Inner Scope Season i0 recursion](yonder/20260728-015541_inner-scope-season-i0-recursion-prompt.md) | **yonder** · Archival — inner PAUSED i6/i7 · living seat 2 Gren · fascia wait |
| `20260725.040520` | [Four Rishi harvest laps](date/20260725/20260725-040520_rishi-four-harvest-laps.md) | accumulate · read bounded · filter chained · quote safe — shell harvest |
| `20260724.143155` | [Vanes, shelves, names, maps — braided](yonder/20260724-143155_vanes-shelves-names-maps-braid.md) | **yonder** · Files second+third counsel · P3 under 8KB · waymarks · replies · stewards · Aparigraha · letters · rung 1 · coverage GREEN |
| `20260724.132812` | [Workshop and Warehouse — context economy](yonder/20260724-132812_workshop-and-warehouse-context-economy.md) | **yonder** · Files Fable 5 counsel · seats pin-and-ledger `24576` · untracks `tools/bin/` · rolls living pins · watcher excludes · sixth lint duty · workshop/warehouse doctrine · P3 rules partial · P6–P7 skeletons |
| `20260718.122145` | [Glow Glass display, short home, Dexter send, Wired Glass](yonder/20260718-122145_glow-glass-display-short-home-and-dexter-send.md) | **yonder** · Expands ret=newline · ↑ send · Hearth short home `kd` · LULU display presets (Pixel 10a 1080×2424 → same-ratio lower → Mantrapod Skate floor) · Wired Glass SLC (used Pixel, no cellular, USB to Desk) · draws waymark **LULU** · seats silo + ER + align |
| `20260716.142818` | [The Glow application framework and publishing mechanism, held against GrapheneOS](yonder/20260716-142818_glow-application-framework-and-publishing.md) | **yonder** · Grounds GrapheneOS's own app model (signed repository tied to verified boot, sandboxed Play as an unprivileged app, A/B verified-boot update rail, capability-gated permissions — checkable, dated) · maps each service onto the closest Glow module/vane (Pool+Caravan the strongest match; Granary/Amber/Comlink the repository; MUR/Neth/Sigma/Mandi an *improvement* on Play payments; was MALA) · connects the framework to the rune design (an app is a Pool agent, its manifest a bounded mold, its capabilities an exhaustive `?-` checked at admission, its loops the bounded `\|-`) · names the publishing mechanism as a fold over signed offers, not a central store · lays the **TUBE** ladder (waymark-derived, TUBE0–TUBE7) and recommends TUBE0 (the app-manifest mold) as the reachable, device-free next step |
| `20260715.163900` | [A separate ai-jail identity for urbit on the Framework/Ubuntu host](yonder/20260715-163900_linux_framework_jail_identity_separation.md) | **yonder** · Settles that ai-jail's own --private-home already isolates veganreyklah2's real keys by default on Linux (kernel namespaces, no macOS-style enumeration needed) · scopes tools/generate_jail_local_keys_linux.rish as the one remaining piece, not yet written |
| `20260715.181500` | [Sala as a broadcast surface, and the Glowphone](yonder/20260715-181500_sala-broadcast-and-glowphone.md) | **yonder** · Ran two intertwined visions into grounded studies: Sala-broadcast (a livestream is a fold over a signed ordered log) and the Glowphone (a two-body firmware-free-client + open-AI-home-forge strategy, hardware forks dated and cited) |
| `20260715.164500` | [Glow's non-vane strata, the Urbit fleet reconciliation, and mold nesting](yonder/20260715-164500_glow-vane-strata-fleet-and-molds.md) | **yonder** · Ran a round of Glow design questions into three citable studies: the three non-vane strata + Pond's narrowing, the Glow/Neth/fleet reconciliation, and bounded mold nesting as the sixth Glow-supplement surface |
| `20260715.160500` | [A student's "mixed" on college, AI, and the vows that fit](yonder/20260715-160500_college-education-mixed-exploitation-ai-and-vows.md) | **yonder** · Siloed a student's honest word on education-as-exploitation and the age of AI; ran it into study #58 on Kali Yuga, the Brahmana in grihastha, artha, and how Grain balances the extraction underneath |
| `20260711.053412` | [Apply Cursor-bot arc audit](yonder/20260711-053412_apply-cursor-bot-arc-audit.md) | Consumed — WOV money fn split; counsel; in `yonder/` |
| `20260710.133500` | [Inference stack — module roots](yonder/20260710-133500_inference-stack-lap0.md) | **yonder** · Module roots + assist view; parity **215** |
| `20260710.132548` | [Dimeroll — sight view](yonder/20260710-132548_dimeroll-lap3-sight-view.md) | **yonder** · Carriage + books Skate frame; parity **210** |
| `20260710.131212` | [Dimeroll root — reports](yonder/20260710-131212_dimeroll-root-lap2-reports.md) | Own folder; P&L · BS · exceptions; parity **209**; in `yonder/` |
| `20260710.125953` | [Dimeroll — books view](yonder/20260710-125953_dimeroll-lap1-books-view.md) | **yonder** · Chart · journal · fold · Skate booksviewtest; parity **207**/**208** |
| `20260709.225159` | [MUR kind field — gated](yonder/20260709-225159_mala-kind-field-gated.md) | K0 keep memos; K1 still gated; in `yonder/` · dated path kept (was MALA) |
| `20260709.224531` | [WOV dual monarch — gated](yonder/20260709-224531_wov-dual-monarch-gated.md) | D1 twin-lines landed (parity **205**); D2 later; in `yonder/` |
| `20260709.224325` | [SLC-L4 width — gated](date/20260709/20260709-224325_slcl4-lap2-width-gated.md) | W0 cleared; W1/W2 soak |
| `20260709.204026` | [WOV lap 2b TB client wrapper](yonder/20260709-204026_wov-lap2b-tb-client-wrapper.md) | **yonder** · Seam A host landed (parity **204**); unify 0–5 GREEN |
| `20260709.203527` | [WOV — TigerBeetle pin](yonder/20260709-203527_wov-lap2-tigerbeetle-pin-presence.md) | **yonder** · Pin presence; parity **203** · TB pin retired |
| `20260709.202427` | [Realidream thin view](yonder/20260709-202427_realidream-thin-view-local-facts.md) | **yonder** · Local fixtures → Skate; parity **202** |
| `20260709.201734` | [MUR M2b device wire](yonder/20260709-201734_mala-m2b-device-wire.md) | **yonder** · Device-wire MUR path (was MALA; dated filename) |
| `20260709.200443` | [WOV — exit honesty](yonder/20260709-200443_wov-lap1-exit-honesty-witness.md) | **yonder** · Exit honesty; parity **201** · unify 0–5 GREEN |
| `20260709.191634` | [MUR M2 mailable Comlink](yonder/20260709-191634_mala-m2-mailable-comlink.md) | **yonder** · Hosted M2; parity **199** · was MALA |
| `20260727.234913` | [Tensegral Season r0 recursion prompt](yonder/20260727-234913_tensegral-season-r0-recursion-prompt.md) | **yonder** · Tensegral CLOSED · bow paste archival |
| `20260727.234913` | [Tensegral Season Expanded plan](yonder/20260727-234913_tensegral-season-expanded.md) | **yonder** · Tensegral CLOSED · runway archival |
| `20260709.182354` | [MUR M1 one issuer one holder](yonder/20260709-182354_mala-m1-one-issuer-one-holder.md) | **yonder** · M1 first lap; parity **198** · was MALA; dated filename |
| `20260709.031612` | [SLC-L4 fixed-tier Sigma](yonder/20260709-031612_slcl4-lap1-fixed-tier-sigma-protocol.md) | **yonder** · Pedersen + proof of opening; parity **200** |
| `20260706.190644` | [Claude zip 58 — NS-L3 handoff](yonder/20260706-190644_claude-zip58-ns-l3-handoff.md) | **yonder** · Wire ladder complete; OA-L4 vs MUR (was MALA); wire-serves-the-fold then proposed, now landed `232812` |
| `20260706.013512` | [Claude OA-L3 escrow first lap](yonder/20260706-013512_claude-oal3-escrow-first-lap.md) | **yonder** · Runnable bench — vocabulary gate, hold/release on one log, parity **158** |
| `20260705.195812` | [Fidelity soften — thirteen title-drawn studies](yonder/20260705-195812_fidelity-soften-instructions.md) | Consumed — gratitude softening on #24–#36; in `yonder/` |
| `20260705.190812` | [Claude recursion v9 — batch-6 bundle](yonder/20260705-190812_claude-recursion-v9.md) | Consumed — apply b1→b4→b5→b6; in `yonder/` |
| `20260705.184612` | [Claude recursion v8](yonder/20260705-184612_claude-recursion-v8.md) | Consumed — mid-arc handoff; in `yonder/` |
| `20260705.174412` | [Claude recursion v7](yonder/20260705-174412_claude-recursion-prompt-v7.md) | Consumed — studies #24–#36 batches 1–3; in `yonder/` |
| `20260705.161900` | [Claude silo deepening transcript bench](yonder/20260705-161900_claude-silo-deepening-transcript-bench.md) | **yonder** · Runnable Claude bench — transcript intake, dissociation, recomposition, commit/push/zip 47 |
| `20260705.160712` | [Claude silo deepening recursion v1](yonder/20260705-160712_claude-silo-deepening-recursion-v1.md) | **yonder** · replaced for execution by `161900` |
| `20260705.042512` | [Cursor final — reading canon and shelf](yonder/20260705-042512_cursor-final-reading-canon.md) | Consumed — Chitra ruling, Makara sweep, canon derive; in `yonder/` |
| `20260705.041312` | [Cursor final — privacy audit and rebase](yonder/20260705-041312_cursor-final-privacy-audit-and-rebase.md) | Consumed — history pickaxe, zip 45 cut; in `yonder/` |
| `20260705.031812` | [Cursor infusion — wheel v4 and Brooke shelf](yonder/20260705-031812_cursor-infusion-wheel-v4-and-brooke-shelf.md) | Consumed — diurnal method, renderer wheels; in `yonder/` |
| `20260705.022512` | [Cursor infusion — final Brooke round](yonder/20260705-022512_cursor-infusion-final-brooke-round.md) | Consumed — batches A–D placed and gate-verified; in `yonder/` |
| `20260704.185412` | [Cursor lane — unified zip-42 intake](yonder/20260704-185412_cursor-lane-zip42-counsel-unified.md) | **yonder** · One paste for the whole sitting: both counsels, Kaeden's words listed with the lens gate added, mechanical stops smallest-first, zip 43 cut discipline. |
| `20260704.181012` | [Zero-copy resins — Claude counsel](yonder/20260704-181012_zero-copy-resins-claude-counsel.md) | **yonder** · Snapshot + Comlink batch architecture; ROADMAP/TASKS/decoder refresh; CIVIC alignment — **answered** at `181612`/`185412` |
| `20260704-030300` | [Cursor recursion prompt v4 — itinerary, stops, journey's pause](date/20260704/20260704-030300_cursor-recursion-prompt-v4.md) | **Active loop** — open itinerary · STOPS · journey's pause; supersedes v2/v3 |
| `20260703-020012` | [Cursor recursion prompt v3 — land eight, then hold the doors](yonder/20260703-020012_cursor-recursion-prompt-v3.md) | Replaced by v4 — **yonder** (u70 prune) |
| `20260702-202612` | [Astrology silos 19–20 — Cursor](yonder/20260702-202612_cursor-astrology-silos-19-20.md) | Consumed — studies 19–20 distilled and landed; raw transcripts never committed; in `yonder/` |
| `20260702-030112` | [SLC-2b — keyboard from the window](yonder/20260702-030112_cursor-slc-2b-keyboard-from-window.md) | **yonder** · **Next open question** — Dexter genesis; awaits Kaeden nod |
| `20260701-231512` | [SLC-2a Ring 3 — mirror live session](yonder/20260701-231512_cursor-slc-2a-ring-three.md) | Consumed — witness at parity 139; metal-closed on GNOME `20260703.032412`; in `yonder/` |
| `20260701-221512` | [Amber and deep archive docs round](yonder/20260701-221512_cursor-amber-and-deep-archive.md) | Consumed — blueprint, Amber spec, rulings; in `yonder/` |
| `20260628-120912` | [Kernel direction, Brix, and foundations — batch brief](yonder/20260628-120912_kernel-direction-brix-and-foundations.md) | **yonder** · Microkernel as Caravan direction (horizon); Brix clarification; foundation layer; revitalization practice |
| `20260621-051612` | [10023 · Main Track — Rye, Rishi, and Strengthening](yonder/20260621-051612_main-track-rye-rishi-strengthening.md) | Consumed — strengthening arc and width gate complete; in `yonder/` |
| `20260621-051612` | [10025 · Strengthening Stdlib Doc + Width Pass — Redirect](yonder/20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md) | Redirect stub — in `yonder/` |
| `20260621-051612` | [10015 · Documentation and Almanac Sync — Redirect](yonder/20260621-051612_documentation-and-almanac-sync-redirect.md) | Redirect stub — in `yonder/` |
| `20260621-051612` | [10013 · What We Mean by Seed — Redirect](yonder/20260621-051612_what-we-mean-by-seed-redirect.md) | Redirect stub — in `yonder/` |
| `20260620-210812` | [10024 · Explicit Width Audit — `usize` to `u32` / `u64`](date/20260620/20260620-210812_explicit-width-audit.md) | Expanded at `210812` from the seed: TAME modeled on Tiger Style demands explicitly sized types; our  |
| `20260620-044112` | [10022 · Tablecloth v1 — Smallest Living Store](yonder/20260620-044112_tablecloth-v1-seed.md) | Rung 4 of the Tablecloth ladder (`10018`). Expanded at `044112`: grow **Tablecloth v1** from Mantra' |
| `20260620-044012` | [10021 · Tablecloth in the One-Value Model](yonder/20260620-044012_tablecloth-value-model.md) | Rung 3 of the Tablecloth ladder (`10018`). Expanded at `044012`: **remember** — how Tablecloth sits  |
| `20260620-044012` | [10018 · Tablecloth Ladder — Index and Vocabulary](yonder/20260620-044012_tablecloth-ladder-index.md) | Expanded at `043712` to unify every expanding prompt that named the content-addressed **store** — no |
| `20260620-043912` | [10020 · Tablecloth and Brix — The Build](yonder/20260620-043912_tablecloth-brix-build.md) | Rung 2 of the Tablecloth ladder (`10018`). Expanded at `043912`: how **Brix** and **Tablecloth** com |
| `20260620-043812` | [10019 · Tablecloth and Brix — The Split](yonder/20260620-043812_tablecloth-brix-split.md) | Rung 1 of the Tablecloth ladder (`10018`). Expanded at `043812`: **Tablecloth** holds and **Brix** c |
| `20260620-040712` | [10017 · Build Catches Design — Two-Thirds Code, One-Third Prose](yonder/20260620-040712_build-catches-design.md) | Expanded at `040712` after counsel from the Zed Opus agent: seven new `.rye` programs and five Rishi |
| `20260620-034212` | [10016 · Virtio-Net Device Wire](yonder/20260620-034212_virtio-device-wire.md) | Expanded at `034212` after Comlink's hosted wire: the same sealed datagram that crossed shared memor |
| `20260620-032012` | [10014 · Device Wire and Comlink's Next Rung](yonder/20260620-032012_caravan-chain-and-device-wire.md) | Expanded at `032012` after Caravan chain-loading: supervision now runs seed → bounded → twin → chain |
| `20260620-021612` | [10012 · Brushstroke Wayland Seed and the Display Frontier](yonder/20260620-021612_brushstroke-wayland-and-display-frontier.md) | Expanded at `021612` after push and Caravan twin: the hosted Brushstroke seed draws from values on s |
| `20260620-021212` | [10011 · Display Frontier, Flow of Values, and Garden Vocabulary — Autonomous Milestone Run](yonder/20260620-021212_display-flow-gardens-and-next-milestones.md) | Expanded at `021212` from the active-designing lens review: priorities align with Gall's Law, single |
| `20260619-153612` | [10009 · Pond as Native Desktop — Rishi Shell, Mantra Version Control, Brushstroke Surface, x86_64 First](yonder/20260619-153612_pond-gui-rishi-mantra-x86-amd.md) | Expanding the vision: a Pond GUI application, drawn by Brushstroke, running a Rishi shell whose Mant |
| `20260619-090512` | [10008 · Zed Claude Rules and the Agent Panel — Mirror Cursor, Run in Zed](yonder/20260619-090512_zed-claude-rules-and-agent-panel.md) | Consumed — Zed rules, agent panel, and enclosure all live; spec repointed; in `yonder/` |
| `20260619-084412` | [10007 · First Seeds — Caravan, Tally, and a Close Reading Before the Wire Grows](yonder/20260619-084412_caravan-tally-seeds-and-close-reading.md) | Expanded from counsel received at `084412`, spoken in Reya 2's radiant voice through a TAME lens. Th |
| `20260619-081812` | [10006 · Two Editors, One Garden — ai-jail, Zed, Cursor, and a Cloneable Template](yonder/20260619-081812_dual-editors-enclosure-template.md) | Expanded from a seed of four strands. The first asks how to run **ai-jail** from `~/veganreyklah2` f |
| `20260619-072600` | [10005 · silo the Surface, Honor the Ground, Keep a Log](yonder/20260619-072600_silo-the-surface-honor-ground-keep-log.md) | Expanded from a seed of three strands. The first asks for a new practice: that I write down my step- |
| `20260619-070612` | [10004 · Documentation, and a Drawn Surface for Rye](yonder/20260619-070612_brushstroke-and-documentation.md) | Expanded from a seed with two strands woven together: a question about documentation, and a vision f |
| `20260619-024512` | [The Near Future — From a Proven Foundation Toward the First Living Network](yonder/20260619-024512_the-near-future.md) | Consumed — arc largely built; living successor is ROADMAP + TASKS; in `yonder/` |
| `20260618-215512` | [10002 · One Identity, Many Keys — and a Fractal Address Space](yonder/20260618-215512_unified-keys-and-address-space.md) | Consumed prompt — Comlink landed; identity + fractal address horizon; in `yonder/` |
| `20260618-212012` | [10001 · A Content-Centric Messenger, From the Network In](yonder/20260618-212012_content-centric-messaging.md) | Consumed prompt — networking in Aurora/Comlink; messenger + shape-casting horizon; in `yonder/` |
| `20260618-195512` | [10000 · Encrypted Networking and the Social Layer](yonder/20260618-195512_encrypted-networking-and-social.md) | Consumed prompt — networking landed as Comlink; social is horizon; in `yonder/` |
