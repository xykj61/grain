# The Two Grains — A Template Breach and a Code-Distillation Plan

**Language:** EN
**Last updated:** `20260808.045124`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Riyo
**Status:** Mixed -- **Proposal** — a *designed, unbegun breach* per [`../context/BREACH.md`](../context/BREACH.md). Nothing here moves a file until the maintainer speaks the word.

---

## What this plan is

This is a plan for an expanded prompt. It answers one request in two movements, because the request has two halves that deserve to be held apart cleanly.

The first movement is a **breach**: separate one grain into two, so that any person can hold a *private, personal* Grain of their own and, beside it, contribute to a *public, general* Grain — a template repository built for community development. The second movement is a **ratchet**: distill the implemented code so it reads as clean, human-readable, TAME-guided civic prose, rather than as a diary of numbered laps and seasons.

Both movements are shaped for a generic reader. Where this plan says *you*, it means whoever picks the work up — the maintainer today, a contributor tomorrow, an Acme Corporation employee reading this a year from now to understand how the split was reasoned. The breach itself waits for a single word from the person who owns the tree.

---

## Movement I — The Two Grains

### The question, answered plainly

*Can a personal-versus-public split be done with gitignore alone?* **No.** A `.gitignore` decides what a working tree tracks from here forward. It cannot un-track what is already committed, it cannot reach into git history, and it cannot rewrite prose that names one person throughout. The split you want is a **repository-topology** decision with a **generation boundary**, not an ignore-rule toggle. Three facts settle it:

1. **The personal content is tracked on purpose, not ignored.** The session logs, the counsel decision records, the compressed reasoning trails in `bron-resins/`, and the living operator cards in `work-in-progress/` are all committed deliberately — they *are* the honest record of one maintainer's season. A template must ship these empty or absent, and gitignore cannot retroactively make a tracked tree forget them.

2. **The history carries identity.** Every commit is authored under a real name and email, many commit messages turn on *"on the maintainer's word,"* and the tree's own history records a real name change as a declared event. Real cryptographic material and identity artifacts live in the history too. None of that is reachable by `.gitignore`; only a fresh history or a filtered one removes it.

3. **The prose is personalized far past the config files.** Even setting session logs and counsel aside, the maintainer's name appears in **955 tracked files** — heaviest in `expanding-prompts/`, `waymarks/`, `active-designing/`, `tools/`, and `context/`. The decision-authority voice (*"the maintainer asked," "on the maintainer's word"*) is woven through the design corpus. Generalizing that is editorial work, not an ignore rule.

So the honest verdict matches the instinct behind the request: **treat the whole of the current tree as personal, and grow the public template beside it** rather than trying to subtract your way to a clean template in place.

### The seam is already half-seated

The good news is that the tree was built with this day in mind. The conventions that a split needs already exist and simply need to be extended:

- **Template files for every personal fill-in.** `GLOW_HOST.template.bron`, `GLOW_PROFILE.template.bron`, and `PUBKEYS.template.md` are committed; their filled-in siblings are gitignored. `tools/enclosure.conf.example` and the key-card example follow the same shape. The pattern — *ship the template, withhold the fill-in* — is proven.
- **The Acme-employee voice.** The reader-facing docs already address a generic Acme Corporation employee rather than a named person (`../.claude/rules/acme-employee-voice.md`). The de-personalizing convention for prose is written and in force.
- **Placeholder ship names.** Example `@p` names are structurally invalid on the live network by design (`../.claude/rules/placeholder-ship-names.md`), so the template already refuses to leak a real address.
- **An allowlist `.gitignore`.** The root ignores everything and allows the project back in folder by folder — the exact posture a template wants.

What is *not* yet seated is a boundary that covers whole **content directories** (not just config files), a **tool** that projects the template from the personal tree, and a **decision about history**. That is the breach.

### The classification — which grain is which

From a full root audit, the tree divides cleanly. The proportion is roughly four-fifths shareable, one-fifth personal.

**Personal — stays in the private Grain only:**

| Path | Why it is personal |
|---|---|
| `keys/`, `keys_*.png`, `keys_*.svg` | Identity QR cards and key material for one person. |
| `PUBKEYS.md`, `.ssh/`, `.gnupg-rye/`, `.gh/` | Real fingerprints, private keys, forge auth. (Most already gitignored.) |
| `GLOW_HOST.bron`, `GLOW_PROFILE.bron` | One host's paths; one contributor's identity. (Templates already exist.) |
| `session-logs/` | Years of reasoning traces that name the maintainer by design. |
| `counsel/` | Decision records — one person's deliberations, *"on the maintainer's word."* |
| `bron-resins/` | Compressed personal reasoning trails. |
| `work-in-progress/REMEMBER.md`, `TASKS.md`, `ROADMAP.md` | The live, real-time work queue of one maintainer. |
| `press/` | Personal announcements — a name change, a fund, local ventures. |
| `classical-vedic-astrology/` | A personal-life study library, privacy-gated. |
| `foundations/` (resume, personal-ontology, name-announcement essays) | Personal biography and philosophy. |
| `SAFE.md`, `STEWARDS.md` | Custodianship and steward mappings by real name. |
| Licenses' copyright line | Names a real copyright holder. |

**Template — belongs to the public Grain:** all of the language and system code (`rye/`, `rishi/`, `glow/`, `tally/`, `caravan/`, `comlink/`, `mantra/`, `aurora/`, `mand/`, `mandi/`, `mycelium/`, `nock/`, `granary/`, `pond/`, `lattice/`, `lantern/`, `scribble/`, `kiln/`, `amphora/`, `bron-resins/` *code*, `brushstroke/`, `cellar/`, `linengrow/`, `dimeroll/`, `src/`); the disciplines (`context/` — TAME, Radiant, Lexicon, the specs; the `.template` files; `CLAUDE.md`; `ORGANIZING.md`; `CONTRIBUTING.md`); the teaching (`manual/`, `edu/`, `docs/`, `docs-geode/`, `nixos-guide/`); the study library (`gratitude/`, `external-research/`, `vendor/`); and the tooling (`tools/`, minus the gitignored secrets).

**Mixed — template after a scrubbing pass:** `SOURCE.md`, `STEWARDS.md`, `context/RIYO.md` and `context/QUIN.md`, parts of `foundations/` and `active-designing/`, and a handful of `.claude`/`.cursor` rules (`session-logs.md`, `collaboration.md`) that name the maintainer as decision authority. The scrub is exactly what the Acme-voice rule already prescribes: replace the name with the generic reader or a role — *"the steward," "the maintainer"* — and keep the structure.

### The topology — a seed and a standing field

Picture the public template as the **seed**: the clean thing anyone plants. Picture the private repository as the **standing field**: one person's grown season, full of their own record. The seed comes *from* the field, yet carries none of the field's private harvest.

Two options reach this. They differ in how they treat history.

**Option A — Filter the existing history (subtractive).** Run a history rewrite (`git filter-repo`) over a copy of the tree: drop personal files, scrub names, rewrite the author identity to a generic contributor, and publish the result. This keeps the code's authorship lineage, yet it is surgically demanding — every key, every name, every private file across the entire history must be caught, and a single miss publishes something private. History rewriting is a Tier-crossing act and unforgiving of error.

**Option B — Grow a fresh seed (additive).** Declare the whole current tree **personal**, and create a *new* public repository whose history begins clean. Project the template set forward into it with generic-authored commits. No personal commit ever enters the public history, because the public history starts empty and receives only the template. This is the safest posture for privacy, and it matches the request's own instinct — *consider the entire repo personal, and seat a breach for a new templated general structure.*

**Recommendation: Option B.** A privacy boundary you build additively cannot leak what it never received. Option A asks you to prove a negative across years of commits; Option B asks you only to prove that what you *copy forward* is clean, which a witness can check file by file.

### The mechanism — a projection tool and a manifest

Option B wants three seated things:

1. **A classification manifest** — a Bron file (proposed `template-manifest.bron`) that records, for every root path, one verdict: `template`, `personal`, or `scrub`. This is the single source of truth for the boundary, checkable and diffable, far more robust than a scattering of ignore lines. It supersedes nothing; it *names* what the `.gitignore` and `.template` files already imply.

2. **A projection tool** — a Rishi script (proposed `tools/sow.rish`, *sow the seed from the standing field*) that reads the manifest and produces the template tree: copying `template` paths verbatim, running `scrub` paths through the name-to-role and Acme-voice transform, and refusing to copy any `personal` path. Its own witness proves the negative that matters most: **no personal path, and no real key or name, ever appears in the projected seed.** That witness is the heart of the breach — a fix is closed by a witness on metal, never by a claim (`../.claude/rules/reds-first.md`).

3. **A history decision, declared.** The public seed starts fresh (Option B). The private field keeps its full, signed, faithful history exactly as it stands — accrete-never-break holds; nothing is rewritten on the personal side.

*The names `sow.rish` and `template-manifest.bron` are proposals, not seatings.* Per the counsel-cell discipline, a proposed name stays proposed until the maintainer speaks it; the Lexicon and the waymark ladder own the final word.

### The breach, written first (the six promises)

Per `../context/BREACH.md`, a breach declares its scope, reason, and far-side shape before the first file moves:

- **Scope.** Create one new public repository (the seed). Add `template-manifest.bron` and `tools/sow.rish` (+ its witness) to the private field. Move nothing personal; the private tree is unchanged but for these additive tools.
- **Reason.** Let any person hold a private Grain and contribute to a public one, without ever risking personal identity, keys, or decision records crossing into the public history.
- **Far-side shape.** Two repositories: a public `grain` template with clean history and generic voice, and the maintainer's private downstream — the standing field — which can pull template updates as an upstream and never pushes its harvest back.
- **Every byte kept.** The private history is untouched. The public history is new, not carved from the old.
- **Simpler far side.** A newcomer clones the seed, copies the `.template` files to their own fill-ins, and grows their own field. One clone, one gesture.
- **Waits for a word.** Nothing runs until the maintainer says so.

---

## Movement II — Distilling the code to clean civic Glow

### The finding

Your instinct is right, and it is also industry-standard: a comment should say *why the code is the way it is* — the invariant, the bound, the reason — not *which numbered lap or season produced it*. TAME's own "say why" rule already asks for exactly this. The codebase is split cleanly by this measure:

- **Already clean** — `tally/`, `nock/`, `caravan/`, and the `rye/` bridge carry the full opening triad, invariant-named asserts, explicit bounds, and prose that reads plainly to a stranger. Their lap/season vocabulary is minimal or metaphorical only.
- **Laden** — `glow/` is the heaviest: across 85-plus files its multi-line comments lead with waypoint numbers (*"STOA127: kind-mold call body…"*) where a clean line would state the invariant (*"payload faces fit within the three-face ceiling"*). `mantra/` carries lap headers (*"NS-L3 lap 3w-3b"*) and dated stamps throughout; `comlink/` is moderate.

The distillation rule is simple and preserves the record: **the invariant moves into the prose; the waypoint stamp moves into a structured header or a ledger.** Dated session logs keep their shorthand untouched — accrete-never-break protects the testimony. Only the *living code comments* are swept, and only in files you are already touching.

### Rye — start with the load-bearing, already-clean modules

*Finish the first-draft implementation in clean Glow, with runes and comments*, starting where the win is largest and the risk smallest:

1. **`tally/` first.** It is the allocator foundation every other module rests on — the bounded memory garden, `copy_disjoint`, the universal marks. It is roughly 95% there and already TAME-clean, so the remaining work is a Radiant prose pass over the docstrings: make each invariant read cleanly to a human. Finishing Tally radiates confidence through everything that depends on it.
2. **`nock/` second.** The bounded Nock interpreter (opcodes 0–11, depth and cell bounds asserted before every recursion) is a TAME exemplar. The remaining work is finalizing the witness prose so each opcode's rule reads plainly without a waypoint reference.
3. **`caravan/` third.** Process supervision, ring by ring, with clean section markers already in place. A final Radiant pass lets each ring's composition story read naturally.

**Defer `glow/` and `mantra/` to a dedicated later pass.** Glow's 26k lines of compiler work are precious and precise; distilling 85-plus files of STOA-laden comments at once risks losing the very precision those numbers pin. It deserves its own focused *"waypoint → clean rule descriptor"* session, not a rushed sweep beside the easy wins.

### Rishi — start with the Tend pattern that repeats most

*"Tend"* is this project's stewardship-and-traceability discipline: a **Tend limb** is a small witness that locks one named Rye constant to a Glow shape pedestal in the museum and proves it lowers cleanly. Because the pattern repeats across dozens of witnesses, cleaning the template radiates:

1. **The Tend-limb witness family first** — `tools/aurora_glow_tend_limb1_witness.rish` and its Caravan/Mantra/Tally kin. Standardize the header (one structured metadata block instead of three loose `say` lines), extract the shared placard/example/elder checks into a reusable library, and write the discipline plainly at the top: *"A Tend limb proves a named constant locks its Rye definition to a Glow shape pedestal, and lowers cleanly."* One clean template propagates to forty-plus copies.
2. **`tools/waymark_derive.rish` second** — the highest-stakes script (deterministic four-letter naming by SHA3-512, with digest pins guarding naming-grade integrity). It is already exemplary in its status-checking; the distillation moves its deep context into a brief *why* header and lifts the seated-draws table into a `.bron` ledger, leaving the prose clean.
3. **The suite orchestrators third** — `tools/glow_tend_a1_suite.rish` and kin. Name each sub-witness explicitly in the progress lines for traceability, and clarify the two-lap (pure / metal) discipline in a structured header.

The witnesses that gate the build — `width-check.rish`, `tame_style_check.rish`, `tame-check.rish`, `one_clock_witness.rish` — are already clean and need no distillation; they can stand as the reference style the rest is brought up to.

---

## The expanded prompt this becomes

When the maintainer gives the word, this plan files forward as a dated prompt in `../expanding-prompts/` (`YYYYMMDD-HHMMSS_short-slug.md`, per that stack's one-clock naming), with milestones a witness can gate:

1. **M1 — Manifest.** Seat `template-manifest.bron` classifying every root path. Witness: every tracked root path has exactly one verdict.
2. **M2 — Projection.** Seat `tools/sow.rish` + its witness. Witness GREEN: the projected seed contains no `personal` path, no real key, no real name.
3. **M3 — Scrub pass.** Bring the `scrub` set to Acme-voice. Witness: no maintainer name in the projected seed.
4. **M4 — Seed repository.** Grow the fresh public history from the projection (Option B). Verify no personal commit is present.
5. **M5 — Tally finished.** Radiant prose pass; module witness GREEN.
6. **M6 — Nock and Caravan finished.** Same bar.
7. **M7 — Tend-limb template + waymark_derive distilled.** `tame_style_check` and each module witness GREEN.
8. **Deferred horizon — Glow and Mantra distillation**, as their own gated pass.

Each milestone is one keystone; each closes on a witness, not a claim.

### Galaxy Pitch (draft, to ride the eventual expanded prompt)

Per `../.claude/rules/azimuth-galaxy-proposal-format.md`, the outward-facing expanding-prompt should carry:

> **For:** any Urbit-adjacent builder who wants a rigorously-disciplined project template — TAME code style, Radiant prose, witness-gated hygiene — without inheriting one maintainer's personal record.
> **Ask:** none; informational only, until the public seed exists and community contribution is actually invited.
> **Scope:** a season-long undertaking on the tooling and history side; the code-distillation half is a series of small, independently-shippable module passes.

---

## What waits for a word

Two gates stay closed until the maintainer speaks:

- **The breach itself** — creating the public seed and its history. Designed here; unbegun by law.
- **The history posture** — Option B (fresh seed) is recommended, yet the choice between a fresh history and a filtered one is the maintainer's to make, because it decides what the public lineage says forever.

Everything else — the manifest, the projection tool, the module distillation — is ordinary constructive work that can begin the moment the direction is confirmed. The plan is written; the field stands ready; the seed waits only for a hand to sow it.
