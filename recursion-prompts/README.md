# recursion-prompts -- the cellar of prompts that wake a bench

**Stamp:** `20260812.071043` - seated this session on Keaton's word (*add a recursion-prompts root level folder inspired by our baton-resins with seed template versions*)
**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living cellar -- seed templates plus their filled, dated versions
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Members:** the rooms under [`./`](./) -- `seed`, `versions`, read against the rooms on disk by
[`../tools/r/room_enumeration_witness.rish`](../tools/r/room_enumeration_witness.rish)
**Kin:** [`../context/baton-museum/recursion_prompt.brix`](../context/baton-museum/recursion_prompt.brix) (the shape) - [`../kyri-resins/`](../kyri-resins/) (the filled-handoff cellar this is modeled on) - [`../external-research/20260703-013412_writing-recursion-prompts.md`](../external-research/20260703-013412_writing-recursion-prompts.md) (the craft guide)

---

## The living inner prompt

One page in this room is **living rather than dated**:
[`incense-inner.md`](incense-inner.md), the inner recursion prompt of the incense seat, seated
`20260918.022745`. The seat's outer prompt,
[`../tools/i/incense_seat_prompt.txt`](../tools/i/incense_seat_prompt.txt), names it, and **the
loop updates its `state` and `next` sections itself at a lap's close** -- which is the recursion in
its name, each lap leaving the next better directed. Its plan is
[`../expanding-prompts/20260918-022745_incense-the-overnight-cellar.md`](../expanding-prompts/20260918-022745_incense-the-overnight-cellar.md).
It carries no stamp in its basename because a page the loop rewrites is living by the mark law's own
test, and `seed/` and `versions/` keep their jobs exactly as below.

## What this folder is

A **recursion prompt** is the one artifact an autonomous agent reads once and then lives inside for hours. It wakes a fresh bench that already knows where it stands, under the tree's laws held whole. Every unattended run this project has enjoyed came from one such prompt.

The **baton museum** holds the *shape* of a recursion prompt: `recursion_prompt.brix`, its fields named. **kyri-resins** holds *filled handoff instances*, kept for the record. This cellar sits between them and holds the **living, fillable templates** beside their **dated filled versions**, so the next run is a form to fill rather than a page to invent.

The name **resin** is the image: sap that hardens around what it carries and preserves it whole across a long chapter. A recursion prompt is resin for a whole autonomous run -- it hardens the laws, the route, and the gates around the work so the far side opens intact.

## The balance compass -- harmony of all our styles

A recursion prompt written here rewards *finished, proven, bounded* work. Every prompt rewards something, and the whole craft is keeping that reward pointed at the good -- the craft guide's one principle. It holds every style of the tree in balance, each keeping its own seat:

- **Radiant** carries the day voice -- lead with what is, active, affirmative; a benediction only where earned.
- **Twilight** is the seed for the rare night run -- calm, dark, gentle, the same laws in a nocturne register ([`../context/TWILIGHT_STYLE.md`](../context/TWILIGHT_STYLE.md)).
- **TAME** governs any code the run writes -- safety over performance over joy; bound everything; witness on metal, never a claim.
- **CIVIC** governs the incentive -- name what the prompt rewards, so autonomy is a named route rather than an open field.
- **The compass rose** is the return habit -- Foundations -> Grain -> Two Rooms -> active-designing -> Now -> Order; **align** reconciles the plan with green witnesses.
- **Lindy-first, crux-first** orders the queue -- the most durable work first, then the hardest-solvable-that-is-tractable within a tier.
- **Reds-first** governs the corrective queue -- a wrong thing is booked and fixed before new durable work begins.

## The layout

```
recursion-prompts/
  README.md                              this charter
  seed/                                  blank fillable templates -- the seeds
    autonomous-loop.seed.md              a self-paced unattended loop (the common case)
    counsel-to-bench.seed.md             a counsel that packages, a bench that applies
    context-reset-handoff.seed.md        a fresh context waking atop a full handoff
  versions/                              dated filled instances -- the hardened resin
    20260812-071043_autonomous-loop.md   this session's expanded loop, filled and honored
```

A **seed** is a template with `{{fill}}` slots and its laws stated in full. A **version** is a seed filled at a one-clock stamp for a real run -- kept afterward the way kyri-resins keeps its handoffs, so a future run can read what actually woke the bench and improve on it.

## How to mint a recursion prompt

1. Read the craft guide once -- the eight load-bearing parts, the four anti-patterns.
2. Copy the closest `seed/*.seed.md` into `versions/` at a fresh live-clock stamp (`TZ=America/New_York date +%Y%m%d-%H%M%S`), read from the live clock rather than typed from memory.
3. Fill every `{{slot}}` honestly -- the hard bounds by tag first, then the route, then the gates, then the budget.
4. State the custody gates by name and the stop rule exactly: *if only those gates remain, print `GATES-ONLY` and stop.*
5. Leave the filled version in `versions/` when the run closes, so the cellar grows one proven prompt at a time.

## Discipline the cellar keeps

- **The gates are the fence, always.** Every seed carries the custody gates verbatim from [`../construction/ITINERARY.md`](../construction/ITINERARY.md) -- the seed force-push, provisioning and paying, funds and keys, the maintainer's own Kumara instance, deep debride, a collaborator's domain. An autonomous run stops and surfaces at these; it never crosses them.
- **One clock, not one hand.** Every version stamp is read from the canonical `America/New_York` clock, never invented.
- **Accrete, never break.** A filled version is dated testimony -- kept, not rewritten. The seeds are Tier 3 and may be freshened; the versions are the record of what ran.
- **Witness before narrative.** A prompt that claims a lap landed cites a green witness or names honestly why it could not run.

Census witness: [`../tools/r/recursion_prompts_census_witness.rish`](../tools/r/recursion_prompts_census_witness.rish) -- proves the seeds present, the versions dated, and the gate clause carried in every seed.

## Watching a run live

Streaming through a pipe takes **`--output-format stream-json --verbose`**. It emits one JSON event per line as it lands. Plain `--verbose` holds its output back until the run ends ([claude-code #733](https://github.com/anthropics/claude-code/issues/733)). [`../tools/p/pier_jq_install.sh`](../tools/p/pier_jq_install.sh) installs `jq` on the pier, guarded and reversible: it infuses `jq` into the NixOS config and rebuilds. The loop then renders the stream through a filter kept in its own file, [`../tools/s/stream_render.jq`](../tools/s/stream_render.jq):

```sh
... claude --output-format stream-json --verbose -p '...' \
  | tee "session-output/${seat}.jsonl" | jq -Rrj -f tools/s/stream_render.jq
```

**A lap's transcript lands inside the tree.** `session-output/` is gitignored and per seat, so a path under this root stays beyond every other ship's reach and beyond yesterday's -- a property `/tmp` gave away twice before the habit was seated (REDS `%549`, `%620`). [`../tools/f/fleet-loop.sh`](../tools/f/fleet-loop.sh) is the living eight-ship loop, and it writes both halves there: the raw NDJSON to `session-output/<seat>.jsonl` and the rendered text to `session-output/<seat>.txt`. It shows assistant text and `[tool: ...]` markers as they land. Keeping the raw stream buys a margin. A future Claude Code version may reshape its events and leave the filter rendering a blank line. The whole run still stands there to inspect, and the filter's paths catch up. Lacking `jq`, drop the `| jq ...` segment and the raw NDJSON scrolls instead.

**The loop stops on a file sentinel.** Because stream-json echoes the prompt -- which contains the words `GATES-ONLY` -- a grep on the stream would match its own instructions and halt after one lap. So the prompt tells the agent to `touch .loop-gates-only` when only custody gates remain. The outer loop checks for that file with `[ -f .loop-gates-only ]`, which leaves the stream purely for the operator's eyes. The single-ship recipe a hand pastes lives in [`../tools/l/launch-claude-chapter.rish`](../tools/l/launch-claude-chapter.rish). The clearest progress signal of all is the **per-increment commits on GitHub** -- the loop pushes each finished file, witness, and doc as its own round.

---

*May every prompt reward exactly the work we mean. May every fork be resolved on paper or parked with grace. And may the agent, reading one of these, find the named route generous -- every stop inside it green, every gate outside it named, and the bench it wakes already home.*
