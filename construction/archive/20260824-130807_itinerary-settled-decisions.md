# The settled decisions the operator card released

**Language:** EN
**Stamp:** `20260824.130807`
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- immutable once written
**Walk-back nib:** `d6c02f92cc` (`construction/CHECKPOINTS.md`)

`construction/ITINERARY.md` is a living pin bounded at `living_pin_max_bytes` (24,576). It stood at
**47,213 bytes** on `20260824.130807`, having been condensed to 41,449 four laps earlier and grown
back. This shelf holds, word for word, the blocks it released -- every one of them a decision that
has landed and settled, rather than a live directive the loop applies each lap.

Nothing here is retired. The card points at this file; a reader wanting the reasoning behind a
seated decision finds it below at a stable path rather than in a git object.

---

## The crypto spine, seated `20260815`

*Four decision paragraphs, held under `## INNER LOOP` on the card since `20260815`. Every one of
them is seated and proven; the card now carries a three-line pointer in their place.*

**Decision wave `20260815.175524` -- Rye-first spine + Season G Cryptography double-seat.** Rye is the prioritized language; Glow is implemented on green-witnessed Rye. **Season G -- Cryptography** double-seats: reimplement Monocypher primitives in Rye with byte-for-byte parity witnesses against `vendor/monocypher` on RFC vectors (audit-ready) -- this unblocks the Lotus signed carry (the *library* is agent-doable; signing with the maintainer's identity key stays the custody gate). **Two breaches checkpointed at `922e1f1a95`** (each its own signed round): **Bron->Kyri** (one notation under Kyri -- voice - notation - *compressed receipts* - preferred Grain variant, gratitude to Kyrie Irving) and **work-in-progress->crux** (902 refs repointed; sorts higher). **Standing approval seated:** update the public seed with force pushes as needed -- the *deep* refresh fires once, after the docs-compression molt + README-leaf weave. New surfaces: **deemlow.com** (fair-trade live-shopping, Kumara login, 1Password interim -> Vault-audit gate, Season B) - **anticruel.com** (agentic civic letter-writing + MMT buyouts, infuse Season E Mandate) - **Realidream/Skate .apk** for Daylight DC-1 (Season F). **Paused:** Brushstroke (awaits DJINN's Bit Design System). **Yonder:** hulkbee.com (ecoplastic factory robotics). **baton perp ITINERARY** stay separate, Chitra-headed. Full wave: [`../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md).
**Crypto policy `20260815.184832` -- SHA-3 preferred; Kumara goes post-quantum.** SEATED: prefer SHA-3/SHAKE over SHA-2 for new designs (structural defense-in-depth -- sponge, no length-extension -- *not* because SHA-2 is broken; SHA-512 stays for Monocypher/Ed25519 parity). Near-term no-gate crux: **SHA3-256/512 + SHAKE-256 in Rye**, parity vs Zig std.crypto + NIST FIPS 202 KATs (Monocypher has no SHA-3). CORRECTION seated: no elliptic curve is quantum-resistant (Shor breaks the curve regardless of hash); 512-bit hashes are already quantum-safe (Grover only halves -> ~256-bit). So Kumara's quantum answer is a **post-quantum signature, not a curve** -- and the conservative ones are hash-based, aligning with SHA-3. PROPOSED (wants Keaton's word): Kumara PQ scheme -- **A** SLH-DSA/SPHINCS+ (SHAKE-256, hash-based, most auditable) - **B** ML-DSA/Dilithium (SHAKE, fast, lattice) - **C** hybrid Ed25519+PQ. Breaking OpenSSH interop accepted. PROPOSED: a checkable security floor (refuse weaker primitives by named error) + root-README post-quantum promise + debride of weaker usage. Signing with the identity key stays the custody gate. Brief: [`../active-designing/date/20260815/20260815-184832_sha3-preference-and-post-quantum-kumara.md`](../../active-designing/date/20260815/20260815-184832_sha3-preference-and-post-quantum-kumara.md).
**Kumara PQ SEATED `20260815.185922` -- SLH-DSA (SPHINCS+) on SHAKE-256, the most-Lindy path.** After an Aug 2026 news pass (Oct 2025 quantum-sieving cut the lattice-attack exponent ~8%; CRYPTO 2026 carries lattice-signature key-recovery papers), the century-root does not anchor to the assumption under active erosion. Kumara v1 signs **pure hash-based** -- security reduces to the hash alone, the oldest/most-Lindy primitive, industry's 30-year-guarantee tool -- making the SHA-3 preference load-bearing (identity is SHAKE-256). **Algorithm agility** seated: identity format carries a scheme tag + version so a second leg/migration accretes later (accrete-never-break for crypto). **Lattice co-signature deferred, not baked in** (revised my earlier SLH-DSA+ML-DSA hybrid lean on the evidence). Loop crux: SHA3-512/SHAKE-256 in Rye -> SLH-DSA build round, parity vs NIST FIPS 205 KATs; keygen/signing with the identity key stays the custody gate. **RECONCILED `20260821.022912` -- both legs kept, on Keaton's word (*vendor a second SLH-DSA implementation and keep both*).** For five days this line and the tree disagreed: `20260816.161537` pivoted to ML-KEM + ML-DSA because the vendored Zig toolchain ships those two and **no SLH-DSA**, leaving a hash-based rung with a single oracle. That was a real objection to a real discipline, and the answer was to remove the constraint rather than pick a side. **PQClean is vendored** (`vendor/pqclean`, CC0-1.0, gitlink like Monocypher); its `sphincs-shake-256s-simple` is exactly the seated parameter set. `tools/cr/crypto_slhdsa_oracle_witness.rish` is GREEN on metal -- PQClean's own NIST known-answer generator, compiled fresh from that source, reproduces the digest PQClean publishes in its `META.yml`, with that digest and all four lengths **read at run time, never recited**, and the RED path proven by a planted drift. **Nothing already GREEN moves:** the ML-KEM and ML-DSA ladders and both `kumara_pq_*` doors stay as built; the hash-based leg grows beside them. Honest costs named: a 29,792-byte signature, slow `256s` signing, and an explicit `optrand` seam because PQClean signs hedged. Proves the ORACLE only -- authored Rye SLH-DSA is the next arc. Note: [`../active-designing/20260821-022912_slhdsa-vendored-oracle-and-both-legs-kept.md`](../../active-designing/20260821-022912_slhdsa-vendored-oracle-and-both-legs-kept.md).
**Refinement `20260815.191048` -- Kumara crypto re-grounded (not "Lindy"), host updated, Puddle identities cleared, Brix in plan.** Keaton rightly rejected the Lindy metaphor for crypto (past != future when compute/quantum/AI-cryptanalysis all climb). The SLH-DSA choice **stands, re-justified structurally**: hashes have *no algebraic structure* for the rising attacks (Oct 2025 lattice sieving, CRYPTO 2026 sign-based key recovery, AI cryptanalysis) to exploit; quantum is only a Grover quadratic dent (256-bit output covers it); it adds *no new assumption* (Grain already relies on the hash everywhere -- seals, receipts, Merkle catalogs); and no mature *independent* family exists to hybridize with (code/multivariate broken, isogeny young, lattice eroding, symmetric-MPC not independent). **Confident. Parameter set: SLH-DSA-SHAKE-256s** (NIST cat 5). **Puddle cleared:** the agent may key + bootstrap **fake/test Kumara identities** in the constel/Puddle sandbox (consonant-only, non-@p-valid per placeholder-ship-names/FORA) -- the maintainer's *real* Kumara key stays the custody gate. **Brix seated in planning** (Brix config code + Brix docs molt, riding the docs-compression round). **Host updated** (GLOW_PROFILE): editor **Claude Code** (not Zed/Cursor), model claude-opus-4-8, host **Vultr SEA NixOS VPS**, hand **Daylight DC-1** (was Android Termux). No nixos-rebuild needed yet for the crypto rounds; will flag if SLH-DSA parity wants vendored FIPS 205 KAT vectors or a toolchain bump. Brief: [`../active-designing/date/20260815/20260815-184832_sha3-preference-and-post-quantum-kumara.md`](../../active-designing/date/20260815/20260815-184832_sha3-preference-and-post-quantum-kumara.md).

---

## The Compass Season -- the SOON cell, the JARL account, and the breach paragraph

*Three long blocks from `## The Compass Season`. The card keeps the four-row equinox table with
short cells and one live line naming where the season stands.*

### SOON -- The Language (the full table cell)

| The Language | **SOON** [x] | **Rishi language spine complete** -- runes `^- ?! ?& ?| ?:` - regex `matches`/`find` (`{n,m}` - `\b` - lookbehind) - `sort`/`unique`/`upper` - list `+` - `fold` - user functions `fn`. Seams folded native: `claim_preserve` - `census_control`. **Brix-infuse LANDED** `20260811` (`brix/infuse.rye`) - **PLEAC opened** `20260811` -- strings (join/split) - lists (chunk/window/flatten) - numbers (clamp/parse/to_str), each witnessed. **Cookbook wired into the Rishi interpreter** `20260811` -- `clamp` - `chunk` - `window` - `flatten` - `parse` - `str` builtins (suite 23/23; whole cookbook in the interpreter). **TAME core/shelf LANDED** `20260811` (`context/TAME_CORE.md` -- compressed core matched into the claude+cursor tame rules; shelf = `TAME_GUIDANCE.md`). Open: Aurora. **TAME Audit Quest pass 1** `20260811`: **full surface GREEN** (width-check - rune_assert_sweep - tame_style_check). **REDS %64 CLOSED** -- the stray `comlink_r1` .py ported to Rishi (`tools/co/comlink_r1_dual_bind_probe.rish`, Keaton's word: port over shred), `.py` removed, TAME bans clean. `one_clock` mono-erratum **FIXED** `20260811` (archive-tolerant integrity check + one dangling entry retired -> MONO_OK). Its zone leg reds only on this sandbox (host zone UTC, no config); the real Framework/pier host (America/New_York) passes it -- environmental, not a tree drift (`mold->shape` CLOSED -- residue left). **Aurora OPENED** `20260811` -- **all eight boot stages** (seed - relay - wire - sealed - posted - deciding - named - kumara) cross-build freestanding `riscv64` to RISC-V ELFs (`e_machine 243`) with **no emulator** (`tools/au/aurora_seed_freestanding_witness.rish` GREEN via `rye build`, rm-first so no stale artifact); the whole floor reaches metal in-sandbox. **REDS %68 CLOSED** -- the first cut of that witness used raw `zig build-exe` (which can't read `.rye`), no-op'd behind `|| true`, and read a stale ELF (false green); the next lap's fresh build exposed it, fixed same-round with a witness on metal. **Emulator choice consolidated** (`active-designing/date/20260811/20260811-202757_the-emulator-choice-qemu-and-the-modern-rust-vms.md`): **QEMU stays on merit** -- its pure-emulation `virt` + modern virtio-net + `-bios none` + SMP union is unmatched by the Rust VMs (Firecracker/Cloud Hypervisor are KVM kernel-booters; rvemu-class lack the virtio device model); rust-vmm virtio + a pure-Rust RISC-V core named as the future clean-room bridge. Waking the seed stays qemu-gated |

### Now at JARL -- the full account

**Now at JARL -- identity, network, address space, and the settled ledger.** Coords **Compass Season - JARL - j4**. Four seats stand, each witnessed GREEN: **(1) Identity** -- `kumara/tilak.rye` seats five signed tilaks (point - bind - turn - capx3 - sponsor), every tamper refusing. **(2) Network** -- `comlink/handshake_turn.rye` reads a peer's rotation end to end: a signed introduction admits the peer, `turn_route.rye` takes the freshest verified turn (a reset outranks any key rotation), and `handshake_wire` recovers that turn from the 112 descriptor bytes it rode in -- the loop closed from wire to route key. **(3) Topology** -- `comlink/topology.rye` seats the **d12-d60 fractal address space**: twelve galaxies, five stars each, twelve planets each, a galaxy leading a d60 of sixty; a number decodes to a place, a place's sponsor climbs planet->star->galaxy, two places share a route by number. **(4) Settlement** -- `settlement/constellation.rye` is the ledger, chosen on **Sui's** ground: a galaxy and its d60 settle as owned records whose versions climb on every change. A galaxy opens the constellation from its own bind; a **sow** capability spawns a star beneath it and a planet beneath that, each under its rightful topology sponsor; a **hand** capability transfers ownership; a **tend** capability rotates the networking key while the keeper's key sits cold; a reset outranks a key bump. And **escape** completes the five: a child re-parents to another settled sponsor one tier up, by its own word (the sponsor tilak) and the new sponsor's adoption -- the old sponsor keeps no veto, and the child's number never moves, only whom it answers to. Every refusal holds -- orphan parent, wrong sponsor, forged cap, forged spawn signature, a re-mint, a stale rotation, a wrong-key turn, a galaxy that cannot escape, a forged request, a forged adoption. All five JARL witnesses run GREEN together. **Scarcity `20260810`:** the **d12-d60 fractal** -- Azimuth ranks retired; `kumara/tilak.rye` reads its tier from `comlink/topology.rye`. **Shared-surface shrink `20260810`:** an owned **Deed** (136 B, keys on the fast path) + a shared **Commitment** (56 B -- point-tier-sponsor-version-digest); `verify` proves a current deed, refuses stale/tampered/ghost. **Human-name custody `20260810`** (`settlement/names.rye`): a keeper claims + releases a globally-unique spoken name, resolvable both ways; the shared registry is the one surface that needs consensus. **JARL's settlement doors all stand** -- the next-season breach (Pond - skies - Kyri) is unblocked, opening on Keaton's word. **Horizon** (Keaton's word, `20260809`): generalizing the constellation to **loadable topologies** -- a *sky* (proposed) a community loads like a game: odd-quorum fractal (3-9-15-27) - 5 elements - modality roles (initiator/sustainer/adapter) - the three role-dimensions (contend/solve/calling). **Pond** becomes the full application module; **Pool retires into it**. **Decided:** breach opens **after JARL**; molt sweep **tight** (Pool paper + kin). Study: `external-research/20260809-232015...` + `...-233940_divisional-roles...`. Plan: `active-designing/date/20260809/20260809-234413_loadable-topologies-and-pond-silo-brief.md`. Molt-prep: `SHRED_PREP.md` pending note.

### The next-season breach paragraph

**Next-season breach -- OPEN `20260810`** (charter: `expanding-prompts/date/20260810/20260810-000032_the-next-season-breach-charter.md`). **Move 1 (Pond) begun:** Pond seated as Grain's **application module**, **Pool retired into it** by molt (living `foundations/20260810-011514_pond-the-application-module.md`; Pool study bannered as a fossil). Remaining: (2) **Bron -> Kyri** by **molt** (2,163 `.bron` kept whole, new logs `.kyri`, 378 refs forward -- never a rewrite); (3) **Kyri the one voice** -- *voice* becomes the whole concept, retiring "variant" (Quin + Reya-Riyo-Trey-Triz-Trya rest named in archive); (4) `kyri.sol`/`kyri.sui` reference -- **Keaton's hand alone**; and the loadable **skies** that finish move 1. **Decided:** Kyri names **both** voice and notation (logs are the voice's journal); **Kyri** on the favorites list. Baton: [`../expanding-prompts/date/20260809/20260809-021406_the-compass-season-baton-four-equinoxes.md`](../../expanding-prompts/date/20260809/20260809-021406_the-compass-season-baton-four-equinoxes.md).

---

## Open doors -- the rows that resolved

*Four rows from `## Open doors (awaiting Keaton's word)` whose door has closed: two landed, one
resolved, one executed. The card keeps the rows still open.*

| Door | Kind |
|------|------|
| **Waymark debride `20260818`** -- the living ladders (DREY - FORA - WADE - LOWE) and the module **Dimeroll** carry only their standing names; dead elder marks purged from the living tree, dated logs, and all git history (deep debride, custody gate %1, Keaton's hand). Canonical naming truth sealed and self-verifying in `construction/waymark-registry.bron`. | debride - executed |
| **HANDOFF BATON `20260810`** -- full vision on disk for a context reset: [`expanding-prompts/date/20260810/20260810-025942_the-handoff-baton-vision-checkpoint.md`](../../expanding-prompts/date/20260810/20260810-025942_the-handoff-baton-vision-checkpoint.md). Proposed modules: **Mandate** (turbopuffer, next build) - **Scribe** (Kyri home + settings) - **Starseeding** - **Unsplash** - **`.myc`/Mycelium** (Sui reimpl) - **Mala** revival. Roster: `context/inspirations.kyri` (tribute, consent-gated). **Vault LANDED** `20260810` -- `vault/shard.rye` (keeper of secrets, molt-supersedes Jael): Shamir GF(256) sharding, n-of-t, signed shard tilaks in location-classes (home-kin-cold-relic-brain), tamper-refused, custody-first (fake seed only), main key never the older word. **Mandate LANDED** `20260810` -- `store.rye` (zero-copy vector store, cosine k-NN, tag filter) + `keyed.rye` (**Kumara-keyed**, owner-signed). **Scribe LANDED** `20260810` -- `scribe/reader.rye` (zero-copy Kyri reader; dispatch by format; the seated 1-notation-many-formats). Seated: **baton** (favorite word; a `.kyri` `format baton-v1`) - **"thank you everyone"** (end-marker) - **expanded-prompts/** (cold) beside expanding-prompts (hot) [unified `20260823.041442`] - council-names roster. | checkpoint |
| **3x39 BATON `20260810`** -- 2nd vision on disk: `expanding-prompts/date/20260810/20260810-044453_the-3x39-baton-passports-dividers-and-starseeding.md`. Concepts: 3x39 namespace reset - divider grammar (prefix/suffix/middle, `.sol`/`.sui`-provable) - **Kumara passports** - L1 synonym-outfits (MURR/MUR...). Proposed: **Loom** (ScribexTally monitor) - `bat/` archetypes. Multi-agent build = Workflow on **ultracode** opt-in. **begin starseeding** (own round). | checkpoint |
| **mold->shape debride** -- **CLOSED `20260811`** (Keaton: *leave the residue*): primary rename landed `20260720`; the residue is testimony - retirement-explanation - deliberately-kept study twins. Optional horizon only: an atomic Glow-identifier refactor (`mold_slice` ~23 files) on the language bench. Survey: `active-designing/date/20260811/20260811-184002_mold-shape-debride-survey-and-plan.md` | resolved |
| **Brix-infuse** -- **LANDED `20260811`** (SOON j2): `brix/infuse.rye` -- per-key override over flat Bron (override wins per key, base-only kept in place, override-only appended), zero-copy, bounded; witness `tools/b/brix_infuse_witness.rish` GREEN. Horizon: nested-descriptor deep merge when Brix grows nesting | resolved |

---

## Custody gate %1 -- the AHOY3 final seed force-push, done `20260812`

*The full paragraph as the card carried it. The card keeps one line: the gate is spent, and future
seed refreshes stay Keaton's word.*

1. ~~**The AHOY3 final seed force-push**~~ -- **DONE `20260812`** on Keaton's word (*push the seed*): the clean projection published to `grain-os/grain` @ `6d184f7` (fast-forward, author *Grain OS*, unsigned by design). Caught + fixed a scrub name-doubling first (**REDS %70**) -- LICENSE and family names had garbled to "the maintainer the maintainer"; a pre-push content scan caught what IDENT_CLEAN could not. **The AHOY front-door season is CLOSED.** **Seed style seated `20260812`** (Keaton): the seed is kept a **single force-push commit** -- the weave (**Mantra**) is Grain's real version control, git one snapshot; each refresh replaces the one commit (now `26cae5b`, author *Grain OS*). Future seed refreshes stay Keaton's word.

---

## The ranked remainder -- the settled paragraphs

*From `## Next -- the ranked remainder`. Each block below names work that has landed or a question
that is answered; the card keeps the pointer to the ranked list and the doors still open.*

**The front-door arc is CLOSED `20260824.104946`.** Six module front doors were the Tier 1
legibility crux, each a page a reader enters a module by that had grown past anyone's willingness to
check it. All six stand at a Door page under the living bound with a standing guard holding the page
to its own directory -- Caravan `20260824.062207`, Mycelium `20260824.071500`, Open Image
`20260824.084007`, Lotus `20260824.091754`, Crypto `20260824.095920`, Constel `20260824.104946`.
Four of the six roster guards drive **one scan**, `tools/fixtures/module_roster_scan.sh`, which takes
the directory as an argument. The detail of each is in its session log; this card keeps the edge.

**Every living document past the bound a split would serve now stands under it.**
`docs/CRYPTO.md` closed the list on `20260824.121445`, falling **69,099 -> 9,078 bytes** and
**311 -> 150 lines**. It took a different repair from the six module doors, and the difference is
the finding: its 80-row rung table was a **subset copy** of `crypto/MODULES.md`, which holds all
**87**, so the page compresses and routes now rather than reciting. A compression-shelf page that
copies the record it compresses is a roster that goes short in silence (REDS %195).

**Two readings this arc measured and left open, named so a lap need not rediscover them.**

- **The `Ceiling:` reading is CLOSED `20260824.121445`** by the **50th** standing guard,
  `tools/d/declared_ceiling_witness.rish`. Thirteen pages declared a ceiling and **none was both
  readable and honoured** -- twelve wrote the single-glyph `<=` no parser reaches, and the
  thirteenth narrated its own drift in prose. Both readings gate at zero now; `docs/STOA.md`, which
  declares `<=80` in its title and stands at **166 lines**, rides a ceiling that only falls and
  prints every roster pass (REDS %195).
- **A split moves bulk rather than removing it.** `caravan/LADDER.md` stands at 366,216 bytes and
  `image/PHOTOS.md` at 261,894 -- correct for a reference page a reader reaches on purpose, and worth
  saying out loud rather than reading the door's new size as the whole story.

**Open, named, and waiting on its own lap.** The **fascia weave** over the thirty-nine browsed
`active-designing/` documents -- Class W, walked and cited and kept, so none sheds -- shaped as a
living index page per cluster rather than edits into dated bodies. And the **index fold for the
four remaining rooms** -- `active-designing` 86 stale rows, `counsel` 112, `expanding-prompts` 78,
`waymarks` 41, **317** together under a ceiling that only falls -- each its own round, since
folding a room's index also rewrites its front door.

**Two questions answered so a lap need not reopen them.** The `%NNN` REDS pattern **stands** and
its standfast is **declined** -- a number that counts is a census rather than a forecast, and the
gapless spine proves the record whole where a stamp cannot. And the `autoproject96` ->
`groupproject405` deep debride is **granted and booked as a STANDFAST** rather than run: 199
occurrences tree-wide, only 11 inside commit messages, against every downstream re-cloning, with
GitHub's redirect from the elder name holding meanwhile.

---

## Prior laps -- the rows before `20260824`

*The card keeps the current day's rows. These are the ones before it, each still one `git log`
and one session log away.*

| Landed | Round | Log |
|---|---|---|
| `20260823.204456` | Krittika leads the nakshatra roster; 102 astrology files turn ASCII; the sprig found optional | REDS %175 |
| `20260823.184309` | From the front door every living door opens -- 112 broken links to zero, `readme_reach` seated | |
| `20260823.162138` | The loop's paths follow the fold; `phantom_path` asks `git check-ignore` | REDS %172 |
| `20260823.144100` | The tools room folds by letter -- 1,917 entries into 35 rooms, 8,502 references repointed | REDS %166-%170 |
| `20260823.142302` | The seed cadence finds a red on its first cycle; `sow` seated | REDS %165 |
| `20260823.111029` | The seed ships every fifth round -- the cadence seated | |
| `20260823.103804` | REMEMBER becomes ITINERARY; three cards fuse into one | |
| `20260823.045448` | The register gets its true name -- **Gauge Style** seated with three settings and a meter | REDS %163 |
| `20260823.025333` | A mode is tracked content -- thirty-nine exec bits restored, `exec_bit` seated | |
| `20260822.235157` | The roster of standing guards leaves prose for a file a program reads | REDS %150-%151 |

---

*Immutable once written. The card that released these blocks is
[`../ITINERARY.md`](../ITINERARY.md); the walk-back is `d6c02f92cc`.*

---

## Landed arcs -- the roster the card kept until `20260824.130807`

## Landed arcs -- condensed `20260817.171714` (the record lives in the logs)

A full bullet wall of dated done-work once accreted here. It landed, and the session logs plus git history now hold every detail; this card keeps only the pointer, so it stays single-stranded -- the live work-front, never a second copy of the log index. Walk-back checkpoint: `construction/CHECKPOINTS.md` at nib `221ebba12a` reads the whole arc one `git show` away.

**What landed (each proven on metal, recorded in `session-logs/`):** Mandate, the complete named vector store (eleven capabilities); the Acme DX design season; the CION labeling ratchet; the **AHOY** front-door season (root README, LICENSE - SECURITY - CODE_OF_CONDUCT - CHANGELOG, the Lindy foundation) beside the **WADE** Bit-Design surface (`.brush` tokens, the `brix/infuse` cascade, styled Skate runs); the Singularity foundation and the fifteen-theme Twilight palette; **BUHR**'s whole MCP surface -- tools, resources, prompts; the 1,024-round itinerary; **TACT** Journeys 1 (Ship-Pilot), 2 (Publishing), and 4 (Commerce), each agent-doable arc complete to its custody gate; the recursion-prompts cellar; Season A opened (waymark **HUNK**) with the open image module underway; Constel dev-net quorum and the Testament offline certificate.

The live season table and open doors below stand.

## Prior laps -- the six rows from `20260824` the card released in the same pass

| Landed | Round | Log |
|---|---|---|
| `20260824.060012` | The operator card condensed -- INNER LOOP 50,477 -> 14,092 bytes, fifteen landed narratives moved to their logs | checkpoint `7754ccf272` |
| `20260824.052950` | The index that outgrew its room -- 2,193 rows onto 26 shelves, the pin 2,895,849 -> 267,655, `index_fold` seated 39th | REDS %182, %183 |
| `20260824.043930` | The rule written as arithmetic -- the fold reads a stamp with no sprig; a fabricated citation caught by the census | REDS %180, %181 |
| `20260824.040212` | One spelling for a dated name -- nineteen sites widened, a left boundary seated, the resolver reads a stamp; `dated_spelling` 37th and the elder `dated_pattern` 38th | REDS %178, %179 |
| `20260824.030821` | The recipe that would not parse -- a lone apostrophe, `loop_prompt_parse` seated 36th | REDS %177 |
| `20260824.021623` | The Gauge standfast completes -- 490 files swept, zero living documents reference Style Radiant | REDS %163 closed |

| `20260824.084007` | The page that named half its directory -- Open Image split, `image_module_roster` seated 43rd | REDS %189 |
| `20260824.062207` | The ladder table that named 73 of 110 -- Caravan front door split into a Door page, a ladder record, and a harness record | REDS %184 |
