# A Proposal to Urbit, Not a Fork Against It

**Language:** EN
**Version:** `20260714.024800` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — the authoritative reframing; a sibling to the Keaton-name and Glow-OS-umbrella markers, sealing how "fork" is read across the tree.

---

## The Decision, Sealed Here

Glow OS is developed as a **collaborative pull-request proposal to Urbit** — a downstream research repository whose intent is to grow ideas, prove them with witnesses, and offer the ones that earn their place back upstream. It is **not** a competitive fork breaking away from the project. The technical fact is unchanged and stated plainly: this repository descends from `urbit/urbit` as a downstream clone, sharing its `.git` history. What changes is the **register** — from divergence-against to contribution-toward, from a finite game one side wins to an infinite game played together (the spirit named in [`../../gratitude/TechnoOptimistManifesto.md`](../../gratitude/TechnoOptimistManifesto.md): a collaborative, ethical accelerationism).

## Why the Reframe

The word "fork," in open source, carries two meanings that had quietly merged in this tree's own prose:

- The **neutral technical** one — a downstream clone that descends from an upstream repository. True, and kept.
- The **competitive social** one — a project breaking away, defining itself against the parent. Not our intent, and set down.

Radiant Style asks us to affirm what we build rather than define ourselves against an opponent. Ethical acceleration, for us, means accelerating *toward* the good and offering the work as a gift, not accelerating *against* a foe. So the living voice of this tree speaks of a **proposal** and a **downstream research repository**, and reserves "fork" for the plain technical fact when that fact is what is meant.

## How the Reframe Is Applied (per this tree's own law)

The same marker-seals-history discipline already used for `Kaeden → Keaton` and `Rye OS → Glow OS`:

- **Living files migrate on touch.** The root `README.md`, `CONTRIBUTING.md`, `manual/glow-os/README.md`, `PUBKEYS.md`, `ORGANIZING.md`, and the `old/` / `vere/old/` predecessor notes (renamed `FORK_NOTES.md → PROPOSAL_NOTES.md`) are reframed to the proposal register as they are next edited. Done alongside this marker.
- **Commit messages are rewritten once, deliberately.** Unlike the Kaeden and Rye-OS transitions (where the pushed history was left sealed), Keaton explicitly asked that the "fork" wording in this repository's own **commit messages** be rewritten to the proposal register and force-pushed. This is a bounded, owner-requested history rewrite over this repository's own **57 commits only** (from the founding downstream commit forward — never the inherited `urbit/urbit` history beneath it), each re-signed with the same key, protected by a backup branch (`backup/pre-proposal-rewrite`) and a bundle in `~/backups/` made before the rewrite. It is the one deliberate exception to "we do not rewrite pushed history," made on explicit word.
- **Dated artifacts stay as written.** Session logs and dated specs stamped before this marker keep their original wording (including "fork") per `dated_guard` and accrete-never-break. This marker tells the reader how to read them: **"fork" in a dated artifact denotes this same downstream-proposal repository**, in whichever sense its sentence meant.
- **The neutral technical use survives.** Where a sentence genuinely means "a downstream git clone that descends from upstream," "fork" (or "downstream clone") stays correct and is kept. The reframe removes the competitive register, not the technical fact.

## What This Does Not Change

- The identity, keys, and Azimuth points (`PUBKEYS.md`) are unchanged.
- The inherited Urbit `CONTRIBUTING.md` strictness is unchanged — if anything, the proposal register strengthens the reason for it: keeping the work small, legible, and in Urbit's own house style is exactly what makes an eventual upstream pull request welcome.
- The technical lineage is unchanged and openly stated: a downstream repository over `urbit/urbit` and `urbit/vere`.

---

*May the work read as the gift it means to be, may the record stay honest about the ground it grew from, and may every idea that earns its place find its way home upstream.*
