# Harness Rationale -- what a companion model would need to earn

**Language:** EN
**Style:** Gauge, Field setting -- Civic register (name what a convention rewards), TAME lens (safety > performance > joy)
**Voice:** Kyri
**Status:** Vision -- proposed reasoning, nothing here is witnessed
**Last updated:** `20260920.141121`
**Kin:** [`README.md`](README.md) - [`../external-research/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.md) - [`../.claude/rules/open-weight-companions.md`](../.claude/rules/open-weight-companions.md) - [`../context/TAME_CORE.md`](../context/TAME_CORE.md) - [`../context/CIVIC_STYLE.md`](../context/CIVIC_STYLE.md)

---

## The question, stated plainly

This bench today runs on Claude, through Claude Code. Nothing about that is broken, and nothing
in this room proposes replacing it. The honest question this room answers is narrower: **if a
companion model -- GLM, Qwen, DeepSeek, Kimi, or another open-weight checkpoint -- ever sat beside
Claude at this bench, what would this tree need to see before it trusted that model's work the
way it trusts a Caravan-supervised process?**

Civic style asks one question before any other: *what does the convention actually reward?* A
harness that merely produces more diffs faster rewards throughput. This tree's own TAME discipline
already names the order that should govern instead: **safety first, performance second, joy
third.** A companion-model harness earns its place by meeting that order, not by beating a
benchmark.

## What the research already found, read for what it means here

The dated study this room adapts,
[`20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.md),
found four things worth carrying forward into this bench's own discipline:

1. **A harness and a model are two different questions.** DeepSeek's own dsh, OpenCode, Cline,
   and Aider are harnesses -- the tool loop that reads a task, calls tools, edits files, and
   checks the result. GLM, Qwen, DeepSeek V4, and Kimi K3 are models -- what answers inside that
   loop. A rule about *which harness* a companion model runs inside is a different rule from *how
   this tree verifies that model's own output*, and conflating the two is how a review checklist
   ends up checking the wrong thing.
2. **License terms are load-bearing, not decorative.** DeepSeek V4 ships MIT. Qwen3.8's smaller
   27B checkpoint ships Apache-2.0. GLM-5.3 and Kimi K3 each carry their own named, conditional
   licenses. `gratitude-licenses.md` already teaches this tree to read a license before trusting
   intent -- the seL4 userlevel sweep found GPL-tagged files inside a BSD-licensed library once
   already. The same per-file discipline would apply to any companion model's own weights or
   fine-tuning terms before this tree cited or built against them.
3. **A memory substrate is not a harness, and this tree already has an answer for it.** Letta's
   tiered, self-editing memory is a real, useful idea to study -- and Mantra's signed, append-only
   weave is this tree's own answer to the same question, built on the opposite temperament on
   purpose. A companion model's session memory should lean on Mantra rather than stand up a second,
   parallel memory store, the same way Caravan supervises a process rather than trusting it to
   supervise itself.
4. **Deterministic simulation testing is the honest bar for trusting an agent's own tool calls.**
   `linengrow/neth_sim.rye` already proves a Grain module's behavior is reproducible under seeded
   fault injection. A companion-model harness that cannot be run the same way -- proving the same
   seed replays the same tool calls -- has not yet earned the trust a Caravan-supervised process
   already has.

## What a companion-model session would need to satisfy, named plainly

Civic style asks that a reward point at the actual outcome wanted. Here, the outcome wanted is
**work this tree can verify was done honestly, by a named model, under this tree's own
discipline** -- not merely work that arrived fast. So the bar is the same bar every session
already meets, read through TAME's own priority order:

- **Safety first.** Every commit stays GPG-signed under the pier's own key, exactly as
  [`git-signing.md`](../.claude/rules/git-signing.md) already requires of every session
  regardless of which model wrote it. A companion model earns no exception.
- **Say why, name the mechanism.** [`mechanism-sentence.md`](../.claude/rules/mechanism-sentence.md)'s
  wall already refuses a commit body written purely in image. A companion model's commits meet
  the same wall, in whatever voice it writes -- the mechanism sentence is a property of the
  commit, not of the model.
- **Provenance is honest, never borrowed.** A companion-model session records its own real
  `provider`, `product`, and `model` fields, per
  [`session-log-provenance.md`](../.claude/rules/session-log-provenance.md) -- never Claude's
  identity worn as a courtesy. The same rule already asks this of every Codex-authored log; a
  GLM- or Qwen-authored log asks nothing new of the convention, only a new value in an existing
  field.
- **Bound everything, prove on metal.** [`reds-first.md`](../.claude/rules/reds-first.md) and
  this tree's whole witness discipline apply exactly as written. A companion model's claim that
  its own code is correct is worth exactly as much as any other unwitnessed claim: nothing, until
  a witness runs GREEN on metal.

## What this rationale does not claim

**Not that any of the four models named above is ready today.** The research this room adapts
says so directly: none is small enough or auditable enough to run inside a Caravan-supervised
seL4 process, and the honest alignment is as a wire-served model behind Comlink's own transport,
not as a resident of Aurora's boot relay.

**Not that a harness name is settled.** Tiller is a proposed word from the research this room
draws on, checked against comlink-tendency's own naming table and found clean of collision --
and it stays unseated until Keaton says otherwise.

**Not that this is urgent.** This room exists so the reasoning is written down before it is
needed, the same reason [`checkpoint.md`](../.claude/rules/checkpoint.md) asks a walk-back marker
be recorded before a debride rather than reconstructed after one.
