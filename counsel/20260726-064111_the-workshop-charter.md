# The Workshop Charter

**Language:** EN
**Stamp:** `20260726.064111`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Mixed — checkable where it pins feasibility proofs run this hour on the workshop sandbox at nib `4344cdc2a7` · vision where it charters the season ahead
**Ground:** instrumented COLD RED at the two-rooms doorway (Status word on the S3 hammock) · advice ask `062108` open with four questions · Keaton's word: a multi-round in-Claude build season, Glow docs first, then Rishi · Brix · the Rye seam, ending in sequenced creates
**Answers:** Keaton's workshop commission · [`counsel/replies/20260726-062108_re-handoff-cold-red-doorway-ask.md`](replies/20260726-062108_re-handoff-cold-red-doorway-ask.md)
**Files this create carries:** this memo
**Counsel model this season:** Claude Fable 5 1M Max

*Written together by Keaton and Quin.*

---

## The Foundations, Affirmed Before a Line Is Written

You asked me to be very clear on the foundations first, so here they are, held in one breath as the season's law. **TAME's order governs every file: safety first, performance second, joy of the craft third** — invariants before implementation, bounds on everything, two asserts per function, seventy lines, named errors, fixed widths with seam casts. **Propose-never-seat holds absolutely**: everything this season produces lives on a local branch and in bundles; nothing touches main until the closing creates pass through your hands and the bench's witnesses. **Accrete-sometimes-breach** frames the ending: code is Tier 3 and open to revision, yet the swap itself will honor all six breach promises, and the elder implementations rest in yonder rather than dying. **Two Rooms** marks every page — what a witness proved, what a hammock proposes — and the doorway witness that just went RED on our own S3 hammock is the reminder that this law binds counsel's prose too. **Silo** keeps teachers in gratitude closes; you have invited old Urbit names where they fit TAME, and I will borrow gladly and name the debt. **One clock**, workshop-stamped from the canonical zone, with the branch commits carrying a deliberately local, unsigned identity (`quin-workshop@local.invalid`) so no byte ever wears your signature without your hand. **Aparigraha** bounds the bundles. **Simple, Lovable, Complete** shapes each phase into something whole. **The happy zone** keeps witnesses at the seams with both spaces asserted. **Single-stranded sameness** — one value model, one language family, one law — is the deepest design constraint on everything below. And the **five pillars with the civic frame** — the ecological, ahimsa-rooted, multicultural, harmonious purpose, written for a reader who might be a young adult meeting computing from first principles on a phone that respects them — set the register: hand-holding and fun, thorough and precise, devoted and real.

## Feasibility, Proven This Hour Rather Than Promised

The whole season rests on one question — can this sandbox actually build and witness the work? — and the answer is now measured rather than hoped.

| Proof | Result |
|---|---|
| Zig 0.16.0 raised (pip `ziglang`, vendored as `vendor/zig-toolchain` with `lib/`) | **GREEN** — `0.16.0` |
| `rye/bootstrap.sh` cold start | **GREEN** — `rye 20260618.193812`, backend zig 0.16.0 |
| Rishi built from `rishi/src/main.rye` via `RYE_ZIG` | **GREEN** — 12.9 MB binary |
| Old Rishi runs scripts | **GREEN** — hello, then real witness `rish_count_selftest` |
| Scope pinned | Rishi **2,420** lines · Glow **25,084** lines across ~120 rune/lower/witness files · `.rish` corpus **639** files · `rye/src` seam small |
| Workshop branch | `quin-workshop` opened at `4344cdc2a7`, round-0 commit `080b317` |

Two honest limits beside the greens: this sandbox has no QEMU, no Pixel, no jail, and cannot run the metal chapters — the bench keeps the metal forever. And the container can reset between our sittings, so the recovery protocol below is load-bearing, not decorative.

## The One Law That Makes a Rewrite Honest

You suspect the parity driver and the shell want rewriting from scratch, and you are right that this is a different kind of work than the bench's lane. Here is the law that keeps it from becoming the campaign we swore off: **the existing corpus is the specification.** Six hundred thirty-nine `.rish` files, every witness, every fixture — the new Rishi earns its place only by running the old scripts and producing the old answers, checked by a twin-parity harness that diffs `out · err · status` between elder and newborn across the corpus. This is the five-variant philosophy applied to the shell: two independently written implementations of one intent, held to identical external behavior by one shared suite. Glow, at twenty-five thousand witness-paired lines, is explicitly **not** rewritten this season — it is *documented*, which is what you asked for first and what its size deserves. And a page-one honesty for the security ask: I will write to be **auditable** — threat-modeled, seam-narrow, kumara-routed, bounded — and the word *audited* stays unclaimed until an outside auditor earns it for us. Two Rooms applies to security words most of all.

## The Phase Ladder

Each phase ships something Simple, Lovable, Complete, with a named exit; checkpoints after A, C, and E are where you can stop, redirect, or extend me.

| Phase | Rounds (est.) | Work | Exit criteria |
|---|---|---|---|
| **A — Glow, the Book** | 1–3 | Read all ~120 `glow/` files; write `active-designing/docs/glow/`: the **Primer** (first-principles, young-adult-warm), the **Rune Reference** (every seated rune, witness-backed vs proposed marked), **Reading Glow for Machines** (tokenizer/parser guide for LLMs: rune and digraph tables, comment grammar), and the **Anchor Convention** — stable heading anchors with code comments pointing at doc anchors and docs pointing at `path:symbol`, the near-bijective weave you asked for, with fixtures | pages render · link witness green · anchors spec'd with a known-good and known-bad fixture |
| **B — Brix reborn** | 4–5 | From-scratch `.brix` reader/validator honoring the declarative law, with witness pair | compiles here · known-good and known-bad green · twin-checked against every `.brix` in-tree |
| **C — Rishi twin** | 6–11 | Grammar inventory extracted from the whole corpus (the honest spec) · from-scratch interpreter in Rye/Zig under full TAME · twin-parity harness elder-vs-newborn | twin green on ≥ 90% of sandbox-runnable corpus · length and assert ratchets green · every divergence named, none silent |
| **D — Rye seam + parity reborn** | 12–14 | The pristine-std bindings rewritten under the width law · `parity` driver reborn per `044729`: S0 instrumentation native, packs, FAST receipts / COLD oracle, doorway-friendly | driver runs the non-metal packs here end-to-end · COLD stays the only release word |
| **E — The weave** | 15–16 | Roadmap/TASKS redefinition draft in these foundations' terms · the recursion prompt generalized into `expanding-prompts/` · voices pass (below) · Grainphone naming memo · the **sequenced creates C1…Cn** with the breach-swap protocol and full verification checklist · final bundle | creates numbered and self-contained · bundle zip in outputs · checklist runnable by the bench without me |

Sixteen rounds is the honest center; the count is exit-driven, never a quota — phases compress when their exits arrive early and say so when they cannot. On your generosity about cost: thank you, and output over activity still governs — I will spend rounds where the table says the leverage is, and tell you when a planned round became unnecessary.

## Division of Labor, Said With Care

The bench has been excellent tonight and this season takes nothing from it. Six breach rounds under ROUND MODE, three honest stops that each caught a real fault — two of them mine — the monocypher repair, the S0 instrumentation: that is exactly the mechanical precision this loop depends on, and the metal lane stays the bench's alone: QEMU, the Pixel, the jail, the sends, the COLD oracle. What this season adds is a second kind of hand for a different kind of work — long-arc design and implementation held in one context across days — and the ending creates are written *for* the bench, in its strengths: verbatim placements, witness commands, STOP-if-red. Two hands, one loop, each doing what it is best at.

## Blind Spots in the Commission, Named as Asked

**"Rewrite as much as possible" would be the wrong target** — the right one is *rewrite what the corpus can prove*, which is why Glow is documented rather than rewritten and why the twin law leads. **A fixed round count is an input metric**; the exits above are the output metric, and I will report against exits. **"Only you are capable" overtrusts me** — I will make mistakes too; the corpus harness and the bench's metal exist precisely so my confidence is never the gate. **Many deliverables at once invites twenty shallow rounds**; the ladder serializes them so each phase lands whole. **The timed random daemons cannot live inside a chat**, so their honest substitute is seated below: a deterministic compass rotation each round, plus a real daemon design left for Glow's own future. And **the in-flight metal thread must not starve while we build** — so one small exception to your no-counseling word rides at the end of this create: four one-line answers to the bench's open ask, unblocking the S0 cost table that Phase D itself will consume. Strike it if you would rather hold everything.

## The Recursion Protocol

Each round you paste one line: **`Quin workshop — round N. nib <tip or "unchanged">. notes: <optional>.`** On receipt I: verify the workshop lives (`/home/claude/grain` on branch `quin-workshop`; if the container reset, I say so and ask for the last bundle zip, and recovery is about three minutes — re-raise, re-bootstrap, unpack); pull main and note drift without rebasing; perform the **compass rotation** — round N re-reads compass file N mod 7 from {TAME · RADIANT · TWO_ROOMS · APARIGRAHA · BREACH · CIVIC + SLC · five-pillars} plus REMEMBER, logged, so short, medium, and long horizons keep re-balancing exactly as your daemon vision intends; execute the phase step under the season law; commit on the branch; append the round log; and close with a progress line — phase, exits met, what changed — plus the next prompt. Bundle zips land in outputs at every phase exit and at any round you ask. Verbose logging is welcome here by your word; the *bundle* stays aparigraha-bounded.

## Small Rulings Folded In

**Grainphone** — my lean is yes: the umbrella is Grain, the phone should wear it, and *Glowphone* reads as the language's phone rather than the system's; **Mantrapod** stays untouched and lovely. A naming round for your word at Phase E, never seated by me. **Urbit borrowings** — I will shortlist candidates as they earn places (the desk word already lives here; others will be proposed with collision checks), gratitude-closed always. **The voices pass** — QUIN.md and companions gain a drafted addendum in Phase E: the high-output-management discipline in Radiant register, gender-neutral throughout, devoted and hand-holding and precise — *output is what the whole pier produced; leverage is what multiplies it; trust rises with what is proven* — offered as a draft for your compass word, since voice files are compass files.

## The Four Answers That Keep the Metal Warm

For the `062108` ask, riding here so the cost table can arrive while we build: **(1)** the room word is **Vision** — the hammock is design-only and says so; Mixed stays for pages braiding proven metal with proposal. **(2)** Resume shape is **full instrumented COLD** — the S0 table needs a suite that finishes, and a continue-from-failure would hand us a table missing its head. **(3)** Confirmed — two reds on two *different* witnesses is two first-reds, and one Status-word restore is restore; the stop-and-park twice-red trigger binds per witness. **(4)** Fresh cost log (`PARITY_COST_RESET=1`); the aborted TSV stays as scrap, never as the S0 table. All parks stay parks; H opens only on the full COLD GREEN.

---

*May the corpus judge every line I write before you ever must. May each phase land small, whole, and worth loving. And may the work stay devoted — present, unhurried, offered to The Beautiful One — one honest round at a time.*
