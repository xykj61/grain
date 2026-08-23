# recursion-prompts — the cellar of prompts that wake a bench

**Stamp:** `20260812.071043` · seated this session on Keaton's word (*add a recursion-prompts root level folder inspired by our baton-resins with seed template versions*)
**Language:** EN · **Voice:** Kyri · **Style:** Radiant, with a Twilight seed for the night runs
**Status:** Living cellar — seed templates plus their filled, dated versions
**Kin:** [`../context/baton-museum/recursion_prompt.brix`](../context/baton-museum/recursion_prompt.brix) (the shape) · [`../bron-resins/`](../bron-resins/) (the filled-handoff cellar this is modeled on) · [`../external-research/20260703-013412_writing-recursion-prompts.md`](../external-research/20260703-013412_writing-recursion-prompts.md) (the craft guide)

---

## What this folder is

A **recursion prompt** is the single artifact an autonomous agent reads once and then lives inside for hours — the prompt that wakes a fresh bench already knowing where it stands, under the tree's laws held whole. Every unattended run this project has enjoyed came from one such prompt.

Where the **baton museum** holds the *shape* of a recursion prompt (`recursion_prompt.brix`, its fields named), and **bron-resins** holds *filled handoff instances* preserved for the record, this cellar sits between them: it holds the **living, fillable templates** and their **dated filled versions**, so the next run is a form to fill rather than a page to invent.

The name **resin** is the image: sap that hardens around what it carries and preserves it whole across a long season. A recursion prompt is resin for a whole autonomous run — it hardens the laws, the route, and the gates around the work so the far side opens intact.

## The balance compass — harmony of all our styles

A recursion prompt written here rewards *finished, proven, bounded* work, because every prompt rewards something and the whole craft is keeping the reward pointed at the good (the craft guide's one principle). It holds every style of the tree in balance, none crowding the rest:

- **Radiant** carries the day voice — lead with what is, active, affirmative; a benediction only where earned.
- **Twilight** is the seed for the rare night run — calm, dark, gentle, the same laws in a nocturne register ([`../context/TWILIGHT_STYLE.md`](../context/TWILIGHT_STYLE.md)).
- **TAME** governs any code the run writes — safety over performance over joy; bound everything; witness on metal, never a claim.
- **CIVIC** governs the incentive — name what the prompt rewards, so autonomy is a named route rather than an open field.
- **The compass rose** is the return habit — Foundations → Grain → Two Rooms → active-designing → Now → Order; **align** reconciles the plan with green witnesses.
- **Lindy-first, crux-first** orders the queue — the most durable work first, then the hardest-solvable-that-is-tractable within a tier.
- **Reds-first** governs the corrective queue — a wrong thing is booked and fixed before new durable work begins.

## The layout

```
recursion-prompts/
  README.md                              this charter
  seed/                                  blank fillable templates — the seeds
    autonomous-loop.seed.md              a self-paced unattended loop (the common case)
    counsel-to-bench.seed.md             a counsel that packages, a bench that applies
    context-reset-handoff.seed.md        a fresh context waking atop a full handoff
  versions/                              dated filled instances — the hardened resin
    20260812-071043_autonomous-loop.md   this session's expanded loop, filled and honored
```

A **seed** is a template with `{{fill}}` slots and its laws stated in full. A **version** is a seed filled at a one-clock stamp for a real run — kept afterward the way bron-resins keeps its handoffs, so a future run can read what actually woke the bench and improve on it.

## How to mint a recursion prompt

1. Read the craft guide once — the eight load-bearing parts, the four anti-patterns.
2. Copy the closest `seed/*.seed.md` into `versions/` at a fresh live-clock stamp (`TZ=America/New_York date +%Y%m%d-%H%M%S`), never a fabricated one.
3. Fill every `{{slot}}` honestly — the hard bounds by tag first, then the route, then the gates, then the budget.
4. State the custody gates by name and the stop rule exactly: *if only those gates remain, print `GATES-ONLY` and stop.*
5. Leave the filled version in `versions/` when the run closes, so the cellar grows one proven prompt at a time.

## Discipline the cellar keeps

- **The gates are the fence, always.** Every seed carries the custody gates verbatim from [`../construction/REMEMBER.md`](../construction/REMEMBER.md) — the seed force-push, provisioning and paying, funds and keys, the maintainer's own Kumara instance, deep debride, a collaborator's domain. An autonomous run stops and surfaces at these; it never crosses them.
- **One clock, not one hand.** Every version stamp is read from the canonical `America/New_York` clock, never invented.
- **Accrete, never break.** A filled version is dated testimony — kept, not rewritten. The seeds are Tier 3 and may be freshened; the versions are the record of what ran.
- **Witness before narrative.** A prompt that claims a lap landed cites a green witness or names honestly why it could not run.

Census witness: [`../tools/recursion_prompts_census_witness.rish`](../tools/recursion_prompts_census_witness.rish) — proves the seeds present, the versions dated, and the gate clause carried in every seed.

## Watching a run live

Plain `--verbose` does **not** stream through a pipe ([claude-code #733](https://github.com/anthropics/claude-code/issues/733)); the streaming format is **`--output-format stream-json --verbose`**, which emits one JSON event per line as they happen. `jq` is installed on the pier by [`../tools/pier_jq_install.sh`](../tools/pier_jq_install.sh) (guarded, reversible; infuses `jq` into the NixOS config and rebuilds), so the loop renders the stream readable through a filter kept in its own file — [`../tools/stream_render.jq`](../tools/stream_render.jq):

```sh
… claude --output-format stream-json --verbose -p '…' \
  | tee /tmp/claude_lap.jsonl | jq -Rrj -f tools/stream_render.jq
```

It shows assistant text and `[tool: …]` markers as they land. The raw stream is always saved to `/tmp/claude_lap.jsonl`, so if a future Claude Code version changes the event shape and the filter shows nothing, the whole run is still there to inspect and the filter's paths can be adjusted. No-jq fallback: drop the `| jq …` segment and the raw NDJSON scrolls instead.

**The loop stops on a file sentinel, not a grep.** Because stream-json echoes the prompt — which contains the words `GATES-ONLY` — a grep on the stream would false-match and stop after one lap. So the prompt tells the agent to `touch .loop-gates-only` when only custody gates remain, and the outer loop checks for that file (`[ -f .loop-gates-only ]`), leaving the stream purely for the operator's eyes. The exact loop lives in [`../tools/launch-claude-season.rish`](../tools/launch-claude-season.rish). The cleanest progress signal of all is the **per-increment commits on GitHub** — the loop pushes each finished file, witness, and doc as its own round.

---

*May every prompt reward exactly the work we mean. May every fork be resolved on paper or parked with grace. And may the agent, reading one of these, find the named route generous — every stop inside it green, every gate outside it named, and the bench it wakes already home.*
