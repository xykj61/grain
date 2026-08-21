# The Pin and the Shelf

**Language:** EN
**Stamp:** `20260726.032231`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Mixed — checkable where it cites the tree, the writings, and counts recomputed at nib `66f1f3d6d9` · vision where it designs breach two
**Ground:** W–Z landed · ROUND MODE proven both ways · 2544 bucketed (2374 unique keys · archive 1178 · same-basename 2150 cross-cut · old/vere nearly absent) · monocypher diagnosis complete: **no gitlink in HEAD** · T3 held on Keaton's strike list · F stays RED
**Answers:** [`counsel/replies/20260726-030603_re-sixteen-hot-round-mode-stop-t2.md`](replies/20260726-030603_re-sixteen-hot-round-mode-stop-t2.md) · the Z diagnosis · Keaton's ten root-shelf questions
**Files this create carries:** this memo · `MAP.md`
**Counsel model this sitting:** Claude Fable 5 1M Max

*Written together by Keaton and Quin.*
Radiant pass `20260727.224156` — path re-point only; claims unchanged

---

## Monocypher — Yes, the Writings Confirm It, With One Refinement

The recollection is real and the tree holds its receipts. The founding note is `external-research/yonder/20260617-201612_useful-utilities.md`, which names Monocypher as audited primitives in one readable file — Blake2b, ChaCha20, Poly1305, X25519, Ed25519, Argon2 — and states the plan in the very words you remember: *the ideal size and license to re-grow as Rye's own `std.crypto` companions — a right-sized reference for the signing and hashing primitives Mantra and Tally lean on.* The seat itself lives in `active-designing/20260712-214200_proven-seat-signed-kumara-monocypher.md` and its pin twin `214900`: tag **4.0.3**, commit `ab2b16dd619ad5f6979a4fbe69cfa324a6fcc35f`, surface `src/monocypher.{c,h}` plus `src/optional/monocypher-ed25519.{c,h}`, CC0 · BSD dual license, and a seam narrowed to **`crypto_ed25519_check` only** — RFC 8032 with SHA-512 — with a red-avoid assert that `crypto_eddsa_` appears nowhere in the guest, because Monocypher's native EdDSA speaks Blake2b and the tree demanded RFC 8032 interop.

The one refinement to the memory: hosted Rye's Zig std **does** carry Ed25519 — the tree even seats a routing law that authored code reaches it through `tally/kumara.rye`. What the stdlib cannot reach is the **seam-C world**: the signed-Kumara proven seat runs a C guest where Genode components require C, and no Zig std exists inside that guest at all. So Monocypher earns its seat twice over — as the audited, trusted C implementation the guest actually compiles, and as the reference oracle any future Rye- or Glow-native implementation will be audited against for correctness, exactly as you recalled. The useful-utilities note even marks the complement precisely: SHA3 the std already supplies; signing at the C seam Monocypher does.

## The Red, Named — and No Third Word

The Z diagnosis settles it. `.gitmodules` is correct, the URL is live, the directory is absent, and — the load-bearing line — **`git ls-tree HEAD vendor/monocypher` is empty**. No gitlink exists in the tree, so every clone on every host fails with the same pathspec error before any fetch is attempted. This is neither an unprovisioned host nor a stale URL. It is missing tree content.

So the taxonomy stays two words wide, and that is the ruling: **a host tool absent earns ABSENT; tree content absent is a plain RED with a plain repair.** Extending the third word here would let a genuine tree fault wear an environment label, which is exactly the confusion the third word was built to prevent. The repair is one commit — restore the gitlink at the seated pin — and the existing fetch witness already asserts everything that matters afterward: HEAD equals `ab2b16d…`, the red-avoid seam holds, and the regenerated fixture byte-matches the committed one. Nothing new needs designing; the seat was designed well the first time. One optional forensic line for the record: `git log --diff-filter=D --oneline -- vendor/monocypher` on the full pier clone will name the commit where the gitlink vanished — the untrack-vere-and-old lap of `20260725.143250` is the natural suspect.

## The Work-in-Progress Census, Computed Here

Twenty-nine files rest one level deep, and the rooms already exist — `work-in-progress/archive/` and `work-in-progress/yonder/` are both live. Counsel computed inbound counts across the tree (inflated by archived session logs, so read them as ranking rather than gospel) and proposes this split. **Keep, nine:** the four living instruments (`REMEMBER` · `TASKS` · `ROADMAP` · `README`), the living queue `ready-to-ask-claude.md`, the canonical `20260620-212126_usize-width-baseline.md` that `ORGANIZING.md` itself names as kept, and the three current-season records — the breach census, the 2544 buckets, and the monocypher diagnosis. **Move, twenty:** the consumed explores, handoffs, audits, mirrored-pair contracts, and round summaries — consumed work points backward, so `archive/` for the clearly finished (open-threads, edit5, the recursion prompts, the Cursor handoffs, the audits) and `yonder/` for the few still forward-leaning (the markdown-archive migration plan, the testing-audit passes if their season may return). The full table travels in the relay's manifest step; your strikes over it are the seating word.

**And the ordering ruling you asked for: work-in-progress goes first, as the pilot round.** Twenty files is the perfect proving ground for ROUND MODE — small blast radius, same machinery, and if anything about snapshot-move-repoint-compare is wrong, it is wrong on twenty files rather than on two hundred forty-seven. Round one is work-in-progress; rounds two through six are the active-designing 247. One strike sitting covers both lists.

## The Forge Description — 305 Characters, Identical on Both

GitHub's description field binds at 350 characters and Forgejo's at 2048, so the smaller limit governs and this fits both with room to spare. The relay carries it verbatim for pasting into both forges unchanged:

> Grain — an open proposal to Urbit: one language (Glow — Hoon's runes over bounded, asserted, TAME-disciplined semantics), five switchable OS variants, and a witness-first tree where every claim is proven on metal before it is written in prose. Safety first, performance second, joy of the craft third.

The forge itself is the gate here — GitHub refuses loudly past its limit — so the bench's confirmation that both sites accepted it is the green.

## The Shell Census — a Ratchet, Never a Campaign

One hundred seventeen `.sh` files are ours: 71 in `tools/fixtures/`, 26 in `tools/`, 15 in `comlink/`, 2 in fixtures' yonder, and one each in `rye/`, `classical-vedic-astrology/`, and `aurora/`. The roadmap answer is **yes, as the ratchet TAME already shaped** — migrate on-touch, print the count every advise run, and never sweep. Three standing exemptions keep it honest: the named permanent seams (`rye/bootstrap.sh` cold start, external interpreters, REPL-over-stdin scripts); the python-heredoc witness bodies, which stay until Rishi grows the verbs — this is precisely the duty-8 harvest lane, so the ratchet and the harvest are one thread; and the thin-delegate elders plus legacy parity selftest scripts already ruled kept. The ratchet's true surface is pure-shell orchestration, and it shrinks as duty-8 lands its verbs. One roadmap line seats the intent this round; implementation rides on-touch.

## Breach Two — The Root Shelf, Designed and Held for the Word

Sixty-eight entries greet a forge visitor before the README's first sentence. Here is each question ruled, the whole executed **next season** with the same census-strike-rounds machinery — plus one instrument correction named at the end that matters more than any single move.

**`nock/` nests to `glow/nock/`.** Fourteen tracked files of real interpreter code with three-plus tool witnesses reading its paths. Nock is seated as interop backend only, so it belongs beside the language that fronts it — the placement states the architecture. Second-level, exactly as you asked.

**The keys art joins `keys/`.** Five files (`keys_menlo_*.png`, `keys_xykj61_*.svg`), one archived reference. The cheapest five entries on the shelf.

**The three licenses move to `LICENSES/`.** `LICENSE-MIT`, `LICENSE-APACHE`, `LICENSE-CC-BY` — one archived reference among them all. `LICENSES/` is the REUSE convention's own folder, so this reads as adopting a standard rather than hiding the terms. Filenames stay as they are in the move; SPDX renaming inside the folder is a separate small lap if ever wanted. Named tradeoff: the forges' automatic license badge may dim without a root `LICENSE` file — counsel judges a clean shelf worth it, and the README's licensing sentence carries the truth either way. Your call rides with the strike list.

**The GLOW templates move to `getting-started/`; the filled copies never move.** `GLOW_HOST.bron` and `GLOW_PROFILE.bron` are gitignored, tool-read at root, and invisible on any forge — six-plus tools read them there and not one needs touching. Only the two tracked templates relocate, and the eight documents that point at them turn in the same round.

**`getting-started/` becomes the front hall: `SOURCE.md`, both templates, `PUBKEYS.template.md`, and the prompt cards.** SOURCE carries 41 inbound links and no forge convention pins it to root, so it moves cleanly under ROUND MODE. The prompt cards are the genuinely new piece and a lovely one: small markdown files, each a single fenced block an Acme reader pastes verbatim into a fresh Cursor agent — *fill my host template*, *fill my profile*, *walk me through Part One*, *introduce me to this tree in plain words*. The front door stops describing the path and starts handing the reader the words that walk it. `STEWARDS.md` re-points its pier-paper row in the same round.

**`MAP.md` lands now, not next season.** It travels with this create — one playful page, the human twin of `llms.txt`, "you are here" for the Acme reader. It is pure addition with nothing to break, its links are ordinary relative links the witness now guards, and when breach two moves the rooms, MAP re-points in the same rounds as everything else. The scroll problem eases today instead of eventually.

**The dotfiles consolidation is refused, and the refusal is the breach law working.** `.cursor/`, `.claude/`, `.vscode/`, `CLAUDE.md`, and the git trio are **convention-pinned paths whose outside consumers already exist** — the editors and the forges themselves read those exact locations. For them the breach window is already closed; moving them breaks tools we do not control. `.brix` stays too: it is the tree's own descriptor wearing its own extension. This is the expiry clause doing its job on day one.

**`external-research/yonder/strengthening-compiler/` yonders; it is never deleted.** One hundred fifteen entries of fork-era study, and the fork is a deferred horizon — dormant-yet-alive is the textbook `yonder/` case, so it moves whole to `external-research/yonder/strengthening-compiler/`. Deletion would break both the accrete law and the breach's second promise for the sake of bytes that cost nothing where they cannot be seen. One live consumer exists and the round must carry it: `tools/enrich_strengthening_docs.rish` and `tools/enrich/crosswalk.rye` walk that folder, so they re-point and run green in the same round, alongside the roughly dozen living documents (`STEWARDS`, `ORGANIZING`, `rye/README`, three context specs, one active brief, four counsels) whose references turn.

**The instrument correction, and it is load-bearing: the link witness reads only markdown.** Breach two moves folders that *tools* read — nock's witnesses, the enrich pair, the GLOW consumers — and a green markdown gate would say nothing about a `.rish` path left dangling. So breach two's census gains a **tool-consumer column** (a grep across `tools/`, `*.rish`, `*.sh` for each moving path), and each round's close adds one step: run every witness whose paths that round touched, green, before the commit. The markdown witness guards the prose; the touched witnesses guard themselves.

**The far side, counted honestly:** 68 root entries fall to roughly **57**. The remaining weight is the module ring itself — twenty-plus code homes — and folding those under a `modules/` umbrella is a genuinely large breach across code paths and witness suites. Counsel names it **horizon only**, deliberately undesigned here: MAP.md and the front hall buy most of the readability at a fiftieth of the risk, and the module breach can be judged on its own day if that day ever earns itself.

## Awaiting Keaton

The two strike lists — work-in-progress and the 247 — one sitting, seating rounds one through six. The monocypher repair word (it rides in this relay; striking AA holds it). The breach-two word, next season, after this one closes. The breach law and its expiry, still unseated in `context/BREACH.md`'s formal sense. The license-badge tradeoff. The `xykj61` mirror-or-retire word. The Pond seven. The Acme audience line. The lap-kinds table. The Brix ladder name — unblocked at last once F runs green. Data dignity, succession trustees, Mand ring-3's reach.

---

*May the pin return to its seat and the seat stay proven. May the shelf grow short enough that the welcome shows above the fold. And may every room we move carry its witnesses with it, green on both sides of the door.*
