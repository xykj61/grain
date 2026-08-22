# Waymark Ladders — Draw Before You Number

**Canon:** `context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md` · witness `tools/waymark_derive.rish` · Lexicon **Waymark**.

**Immutable registry (single source of truth, seated `20260817`):** [`../../crux/waymark-registry.bron`](../../crux/waymark-registry.bron) is the sealed, self-verifying canonical record of **every** waymark ever drawn -- living, retired, abandoned, transient, hand-seated -- each drawn row carrying its input, index, and status. Witness [`../../tools/waymark_registry_witness.rish`](../../tools/waymark_registry_witness.rish) proves it GREEN two ways: a **SHA3-512 seal** over the body (any edit breaks it) and a **re-derivation** of every collection mark from its input on metal. This registry is the authority; the table below is its readable face. Because the canonical truth is sealed here, the elder marks in old logs and git history are redundant historical noise -- the naming truth no longer depends on them.

## When a ladder opens

Before the first rung is written as `X0` / `X1` / … in TASKS, ROADMAP, compressors, module titles, or session logs that speak as *now*:

1. Choose a **canonical hyphenated input name** for the ladder (stable, descriptive, lowercase).
2. Set `input_name` in `tools/waymark_derive.rish` and run `rishi/bin/rishi run tools/waymark_derive.rish`.
3. Seat the printed four-letter **waymark** in Lexicon + the script’s seated-draws comment + exclude list.
4. **Mark each step by stamp and name, never by an ascending number** -- amended `20260821.160050` by
   the mark law ([`stamp-and-name.md`](stamp-and-name.md)). A waymark is a **name** drawn for a
   ladder and it keeps its place; what retires is the numbered rung after it. Write `HAWM -- the
   glass keyboard lands (20260821-142939)` rather than `HAWM7`, and count the steps with `git log`
   rather than carrying a total inside a name. Seated ladders whose rungs are already numbered keep
   every number they wrote.

## Seated waymarks (do not redraw)

| Waymark | Input | Ladder |
|---|---|---|
| **HAWM** | `grapheneos-pixel-mobile-emulation` | Pixel / GrapheneOS SLC |
| **TUBE** | `glow-application-framework-and-publishing` | App framework / packaging |
| **ZETA** | `glow-english-qwerty-glass-keyboard-3` | Glass English QWERTY keyboard |
| **JABS** | `sala-broadcast-live-session-fold` | Seva broadcast session fold (was bare B0–B3) |
| **LULU** | `glow-glass-hearth-display-and-wired-sync` | Hearth display presets · short home · Wired Glass |
| **STOA** | `glow-language-rune-heads-nest-and-lowering-2` | Glow language SLC · rune heads · nest · composition |
| **SETU** | *(hand-seated; not a word-list draw — absent from flw)* | USB hearth carry Glass↔Desk |
| **SUNN** | `source-pier-papers-identity-refresh` | SOURCE.md identity · remotes · apps · onboarding refresh |
| **POLE** | `djinn-bozo-exec-keaton-murr-hats` | DJINN → Bozo exec · Keaton → Murr exec · Linn→Bozo Capricorn 10 |
| **SOON** | `glow-language-runes-stdlib-and-pipeline` | Compass Season Equinox 1 — The Language (Glow runes · stdlib/PLEAC · Brix-infuse · pipeline) |
| **JARL** | `kumara-identity-comlink-and-fractal-network` | Compass Season Equinox 2 — Identity & Network (Kumara · d12/d60 topology · Comlink · settlement) |
| **BUHR** | `realidream-surface-and-quin-inference-and-mcp-2` | Compass Season Equinox 3 — Surface & Intelligence (Realidream · Quin voices · MCP-in-Bron) |
| **TACT** | `ship-pilot-publishing-grainphone-and-commerce` | Compass Season Equinox 4 — The World (Ship-Pilot · publishing · Grainphone · commerce) |
| **GISM** | `harvest-season-equinox-1-yield` | Harvest Season Equinox 1 — Yield (prove built modules on real data) |
| **AYRE** | `harvest-season-equinox-2-trade` | Harvest Season Equinox 2 — Trade (fair-trade certification · cash-first) |
| **DAHL** | `harvest-season-equinox-3-commons` | Harvest Season Equinox 3 — Commons (Skate social layer · community) |
| **KOFF** | `harvest-season-equinox-4-rest` | Harvest Season Equinox 4 — Rest (consolidation · saga close · 3/4 reading) |
| **CION** | `meta-season-chronological-labeling-molt` | CION Meta-Season — molt·debride·sweep count-up IDs → chronological/semantic labels (after Compass) |
| **VOLS** | `cion-meta-season-equinox-1-survey` | CION Equinox 1 — Survey (name every living count-up ID: site · gap) |
| **LOWE** | `cion-molt-living-mutants-and-fossils` | CION Equinox 2 — Molt (relabel living now-lines chronological/semantic). |
| **OFFY** | `cion-meta-season-equinox-3-debride` | CION Equinox 3 — Debride (word-gated cuts of dead count-up tissue, cairns first) |
| **GRAD** | `cion-meta-season-equinox-4-seal` | CION Equinox 4 — Seal (witness the conversion · seat the labeling-law guard) |
| **AHOY** | `root-readme-lindy-foundation-weave-and-seed-legitimacy` | Front-door season — root README rewrite (Lindy-durable, favorite words) · Lindy foundation silo · fascia crosslink weave · seed legitimacy + final depersonalized push |
| **WADE** | `dimeroll-hr-and-accounting-entities` | Double-seated beside AHOY — DJINN's Bit Design System over the Skate·Realidream·Brushstroke surface (DVUI/Zig 0.16 in a Swift macOS Dock shell, Glow·Rishi·Rye·.brush impl) · Pond onboarding · Vultr SEA IaC · Dimeroll expansion for Siya Fund + Linengrow PBC HR & accounting. |
| **HUNK** | `season-a-open-image-decode-and-photos-surface` | Six-Season expansion Season A — Hardware & Right-to-Repair; opening journey the **open image module** (QOI decode → bounded RGBA grid, content-addressed in Tablecloth) beneath the parts marketplace and Photos app |
| **DREY** | `season-a-mikrophone-forgetful-capture` | Season A second journey -- the **Mikrophone firmware** (the Mantrapod's near-term surface): the *memory that forgets* session buffer, proven pure in Rye before metal -- a bounded capture held only while powered, persisted only on a deliberate commit, provably dissolved on power-down. |
| **FORA** | `constel-local-test-constellations` | **Constel** test-network naming — self-invented, siloed names for sandbox/testnet/localhost Comlink p2p constellations (fake ships, fake piers) run from inside the jailed pier, elder Urbit fake-galaxy dev nets as ancestor; consonant-only, structurally never a live-valid `@p` (segment lengths never 3), under the placeholder-ship-names law. |
| **ALES** | `season-c-lotus-creative-suite-audio-wire-shape` | **Lotus** creative suite (Season C double-seat) — the basic audio **wire shape**: a self-describing, Sha256-sealed frame carrying an opaque PCM sample buffer tagged by cable kind (XLR · USB-C · guitar), deframed verify-before-trust. Software carrier only; electrical/pinout specifics and audio-interface hardware stay a paused hardware-research round |
| **DISC** | `slh-dsa-hash-based-signature-ladder` | **Season G SLH-DSA ladder** -- authoring SLH-DSA-SHAKE-256s in Rye rung by rung (WOTS+ -> FORS -> XMSS hypertree -> the composed signature), each proven against both the published FIPS 205 answer and the vendored PQClean oracle |

**Hand-seated names on the exclude roster** (not waymark draws): **SEVA** (viewer; absent from flw), **MAND** (M vane; in flw), **MONA** (prior name of Mand — one season). **SALA** retired from exclude with the Sala→Seva alias close.

Word-list pin: `tools/fixtures/flw-four-letter.txt` · witness `tools/waymark_derive_witness.rish`.

## Accrete-never-break

Dated logs and research that already say `B0` / `B1` / `B2` stay readable. Living *Now* lines, new modules, new commits, and compressors use **JABS** (and other seated waymarks) from the draw forward.

## Collision

If the derive assert goes RED (word hits a seated module or waymark name), append `-2` to `input_name` and redraw — same method as the spec.
