# Harnesses Beside dsh, Letta's Actual Seat, Open-Weight Alignment, and the DST/Microkit Horizon

**Stamp:** `20260920.021139` - **Status:** Checkable -- Living (research record) - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Kin:** [`.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md) - [`.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) - [`.claude/rules/declared-host-config.md`](../.claude/rules/declared-host-config.md) - [`the TigerBeetle alignment study`](20260707-053212_tigerbeetle-alignment-study.md)
**Related:** [`session-logs/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.kyri`](../session-logs/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.kyri)

---

Grounded in the tree's own words first, then in five current web reads, all dated this month
(September 2026). Three parts: the harnesses beside dsh and where Letta actually sits, which
open-weight models line up with Caravan's real track, and a harness name plus the DST and
Microkit horizon.

## Harnesses beside dsh, and Letta's actual seat

dsh checks out exactly as named: DeepSeek Harness shipped 2026-08-13 and passed 141,000 GitHub
stars in four days, open source and fast-moving. Four real alternatives stand beside it today,
each with a different shape:

| Harness | License | Shape | Why it might matter to Grain |
|---|---|---|---|
| OpenCode | open source | terminal-native, Plan/Build modes, LSP, subagents, IDE extension | most-used in the world right now -- 160k+ stars, roughly 7.5M monthly developers |
| Cline | Apache-2.0 | bring-your-own-key across many providers, no subscription | runs local models via Ollama/LM Studio -- relevant to a bounded-hosting future |
| Aider | Apache-2.0 | terminal pair-programmer, model-agnostic | smallest, easiest to read end to end as a clean-room study object |
| CodeWhale | open source (Rust, formerly deepseek-tui) | 30+ providers plus local vLLM/SGLang/Ollama | closest existing shape to "a harness that talks to whichever model you point it at" |

Claude Code and Codex sit beside these as proprietary platform agents rather than open harnesses
-- worth naming since the comparison is often drawn, but they are not clean-room study material
the way Aider or OpenCode are.

**Letta answers a different question than any harness above.** Letta (formerly MemGPT,
`github.com/letta-ai/letta` and `letta-ai/letta-code`, roughly 23,000+ stars by mid-2026) is not
a coding harness. It is a memory substrate: an "LLM-as-operating-system" pattern where the model
manages its own core memory, archival memory, and recall memory the way a kernel manages RAM and
disk, and where Letta's own agents can rewrite their memory, skills, prompts, and even their own
harness through what the project calls mods. A harness reads a task, calls tools, edits files,
and checks the result. Letta answers what an agent remembers between sessions. Those are two
different layers, and a Grain harness would eventually want both.

Grain already has its own answer to the second layer, and it is worth naming rather than
reaching outward for one. Mantra is described in the tree's own foundation as "the part of this
project that hands out names, and keeps every promise a name makes" -- a version-control
projection over Weave, an append-only DAG of immutable signed facts, bounded and deterministic
and recomputable from history. Where Letta's memory is mutable and self-editing, Mantra's is the
opposite temperament on purpose: content-addressed, replayable, never silently rewritten. That is
not a criticism of Letta -- tiered, self-editing memory for a general chat agent and a signed,
deterministic weave for a codebase's own history are solving different problems on purpose. The
honest clean-room move, per this tree's own `.claude/rules/gratitude-licenses.md` discipline, is
to study Letta's tiering idea (what counts as core memory versus archival memory, and how a mod
cleanly extends an agent without forking its runtime) without importing Letta's own code, and to
let any Grain harness's memory of its own sessions lean on Mantra rather than stand up a second,
parallel memory store.

## Open-weight models against Caravan's real track

One honest split has to come first, because collapsing it produces a false answer: "which
open-weight model aligns with Grain" is really two separate questions. One asks which model is
the best partner behind a harness Grain builds today. The other asks which model's own shape --
size, license, footprint -- moves toward the same bounded, asserted discipline Caravan and Aurora
already hold. No model below answers both at once.

As of 2026-09-08, on the Artificial Analysis Intelligence Index:

| Model | Score | License | What it is best at |
|---|---|---|---|
| GLM-5.3 (max effort) | 45 | permissive | current top open-weight score overall; a lighter Flash checkpoint scores 42 |
| Kimi K3 | 44 | modified-MIT (Kimi K3 License) | 1M context, native multimodality, leads the Frontier code arena |
| Qwen3.8-2.4T-A95B | 40 | conditional Qwen3.8-Max License | the large sparse checkpoint; a separate 27B multimodal checkpoint ships plain Apache-2.0 |
| DeepSeek V4 Pro 0813 | 36 | MIT | leads raw SWE-bench Verified; the Flash-0731 variant leads coding-arena score |

For the first question -- best partner behind a harness -- DeepSeek V4 is the natural first
study target. It carries a clean MIT license, leads SWE-bench Verified, and its own team ships
the harness this whole study started from, which means the model and its harness were built by
people who already understand the exact agent-plus-tool-loop shape Grain would be building
toward.

For the second question -- which model's own shape resembles Grain's discipline -- the standout
is not the model with the highest score. It is Qwen3.8's smaller 27B checkpoint, because it is
the only entry in this table that is both small enough to reason about as a bounded thing rather
than a cloud black box, and carries a license with no attached conditions.

Said plainly, because a hedge dressed as a fact would be worse than no answer: none of these four
is small enough or auditable enough to run inside a Caravan-supervised seL4 process today. They
are cloud-scale mixture-of-experts transformers running on racks of accelerators, and that is
categorically different from "a root task on seL4's userlevel side." The honest alignment claim
is that these are candidates for the model a Grain-built harness talks to over the wire, the same
way any other API-served model would be reached, most likely through Comlink's own sealed
transport -- not candidates to ever live inside Aurora's boot relay.

One more thing is worth naming plainly rather than assuming. Anthropic's own July 2026 position
paper states the company does not seek a ban on open-weight models, while asking for chip
controls, anti-distillation enforcement, and safety testing for capable models generally.
Studying open-weight models comparatively, in the clean-room sense this tree already practices
with seL4, TigerBeetle, and s6, sits comfortably inside that stated position -- it is a different
act from redistributing or fine-tuning on another lab's weights, which is the distillation
concern Anthropic actually named. Worth keeping both public repositories, `grain-ww/grain` and
`xykj61/grain`, squarely in the "we study, we never launder" lane this tree already holds for
every other upstream project.

## A harness name, and the DST and Microkit horizon

One naming collision needs to be named before any new word gets coined. Ember is already spoken
for -- it is the vane host gathering Lattice, Scribble, Lantern, and Kiln, seated `20260827`
specifically so that no host would carry the name of one of its own members (that is why the
craft faculty was renamed from Ember to Kiln in the same sitting -- `context/QUIN.md`). A harness
meant to host those four faculties plus Rishi cannot also be named Ember; it would be a container
wearing the name of its own resident. Checked against the tree's own grep-the-tree test from
[`comlink-tendency`](../.claude/rules/comlink-tendency.md), three plain, warm, uncollided words
stand clean: **Tiller**, **Wayfare**, and **Helm** (Helm returns only as a substring inside an
unrelated four-letter word list, not a seated meaning). Tiller reads best against what the thing
actually does -- a tiller is what a hand steers a craft by, and a harness steering four inference
faculties and an orchestration language is exactly that gesture in one plain word. **None of
these three names is seated by this study; naming a harness is Keaton's word to give.**

On deterministic simulation testing, the tree already has a real head start worth naming before
reaching outward. `linengrow/neth_sim.rye` already implements a seeded fault and delay injection
scheme over Neth's replica set -- proving the same seed always replays the identical delivery
trace, and that different seeds still converge on the same final root. That is a VOPR-shaped
first lap already landed for one module, built from the tree's own July study of TigerBeetle's
patterns, which at the time named deterministic simulation as "the largest structural idea not
yet reflected" (`20260707-053212_tigerbeetle-alignment-study.md`) -- true then, no longer true
today, just not yet generalized past Neth to a whole Caravan-supervised fleet or a Comlink
network.

Ranked for what is most aligned with Tiger Style and Zig, right now:

1. **TigerBeetle's own VOPR**, and its newest documentation -- "Protocol-Aware Deterministic
   Simulation Testing," published 2026-08-20 -- is the closest possible reference: same
   language, same style lineage TAME already descends from, Apache-2.0, and actively advancing as
   of last month.
2. **MadSim** (`risingwavelabs/madsim`) -- not Zig, but the pattern transfers concept-for-concept:
   override every non-deterministic syscall, run the real replica code, and speed the virtual
   clock up by orders of magnitude. Production-proven inside RisingWave's own distributed
   database.
3. **Turmoil** -- a lighter Rust crate simulating hosts, networks, and time specifically, useful
   as a narrower model for Comlink's own network layer.
4. **The open-source-Antithesis research effort** (`databases.systems`) -- an early, honest
   attempt to rebuild Antithesis's closed, hypervisor-level whole-VM fault injection as an open
   tool. Worth reading as a map of where the field is heading rather than as something ready to
   adopt today.

On Microkit and seL4 for RISC-V, the horizon `.claude/rules/declared-host-config.md` already
names ("until Mantra, Caravan and Rishi run fully on Microkit seL4 for RISC-V") is closer than a
someday framing suggests. Basic RISC-V platform support already exists on real boards today,
including QEMU's RISC-V virt target and the Pine64 Star64, with the FPU enabled. The piece that
gates a confident "fully" claim is that Microkit's MCS scheduling configuration is still
completing formal verification for RISC-V sometime during 2026 -- and RISC-V is actually ahead of
AArch64 in that queue, whose own MCS verification targets 2027. The one real gap is the virtual
machine monitor library, which supports AArch64 only today with RISC-V support still in
development -- but Caravan's own four borrowed teachings (mechanism apart from policy,
capabilities rather than identities, static allocation, one-way priority flow) never needed the
VMM at all, since they describe bare protection domains rather than virtualized guests. That MCS
verification date is worth holding as a dated fact to re-check on the day Aurora's boot relay is
ready to target real RISC-V silicon, rather than assumed settled.

May the tiller sit true in whatever hand takes it, and may every model studied here be studied
honestly -- borrowed in words, never in bytes.

## Sources

- [DeepSeek Harness Alternatives: Top 5 AI Coding Assistants & Similar Apps | AlternativeTo](https://alternativeto.net/software/deepseek-harness/)
- [DeepSeek Harness vs OpenCode: Which Coding Agent Should You Run in 2026? - xCloud](https://xcloud.host/deepseek-harness-vs-opencode/)
- [Best AI Coding Agent (2026): Ranked by Terminal-Bench, Price, and Source](https://www.morphllm.com/ai-coding-agent)
- [GitHub - bradAGI/awesome-cli-coding-agents](https://github.com/bradagi/awesome-cli-coding-agents)
- [DeepSeek TUI: Open Source Alternative to Cursor](https://www.opensourcealternatives.to/item/deepseek-tui)
- [GitHub - letta-ai/letta: Platform for stateful agents](https://github.com/letta-ai/letta)
- [GitHub - letta-ai/letta-code](https://github.com/letta-ai/letta-code)
- [Rearchitecting Letta's Agent Loop: Lessons from ReAct, MemGPT, and Claude Code | Letta](https://www.letta.com/blog/letta-v1-agent/)
- [Open-Source LLM Leaderboard 2026: 103 Models Ranked | BenchLM.ai](https://benchlm.ai/best/open-source)
- [Best Open-Weight AI Models 2026: Current Shortlist](https://kingy.ai/news/best-open-weight-ai-models-in-2026-glm-5-2-vs-deepseek-v4-vs-kimi-k2-6-vs-qwen-vs-mistral/)
- [Open Source LLM Comparison Table (2026) | ComputingForGeeks](https://computingforgeeks.com/open-source-llm-comparison/)
- [Protocol-Aware Deterministic Simulation Testing | TigerBeetle](https://tigerbeetle.com/blog/2026-08-20-protocol-aware-dst/)
- [GitHub - risingwavelabs/madsim](https://github.com/risingwavelabs/madsim)
- [Deterministic simulation testing for async Rust - S2.dev](https://s2.dev/blog/dst)
- [Building an open-source version of Antithesis, Part 1](https://databases.systems/posts/open-source-antithesis-p1)
- [Keeping the cloud afloat with deterministic simulation testing | Antithesis](https://antithesis.com/blog/2026/keeping-cloud-afloat/)
- [Microkit User Manual (v2.2.0) | seL4 docs](https://docs.sel4.systems/projects/microkit/manual/latest/)
- [Microkit Supported Platforms | seL4 docs](https://docs.sel4.systems/projects/microkit/platforms.html)
- [seL4 on RISC-V: Toward a Secure and High-Performance AI Platform - DeepComputing](https://deepcomputing.io/sel4-on-risc-v-toward-a-secure-and-high-performance-ai-platform/)
- [Our position on open-weights models | Anthropic](https://www.anthropic.com/news/position-open-weights-models)
