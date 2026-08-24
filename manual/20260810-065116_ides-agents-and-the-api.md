# IDEs, Agents, and the API

**Language:** EN
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Audience:** an Acme Corporation employee working on this template with a modern editor and a coding agent -- beginner-welcome, developer-precise
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Status:** Living -- describes the general pattern for working on this tree with editors, agents, and a hosted model; horizons named as horizons. No vendor secrets, no accounts, no keys.

---

Welcome. This guide is for the person who wants to work on this template the way
modern software is written today -- with a capable editor at hand and a coding
agent doing some of the typing. It teaches the *pattern*, not any one product:
how an editor and an agent sit beside this tree, how you prompt an agent against
the template to grow a module and prove it green, and how a hosted model fits
into that loop. Everything here works with whatever editor and whatever model
provider you choose; nothing here asks you to name one.

The template holds the same promise everywhere: **every claim is checked on
metal, and the witness is the arbiter.** An agent is a fast, tireless pair of
hands -- yet a module is done only when its witness runs green, exactly as it is
when a human writes every line. That promise is what keeps agents safe to use
here: the agent proposes, the witness disposes, and the green line is the same
green line either way.

---

## 1. The general shape: editor, agent, model

Three pieces cooperate when you work this way. Learn the boundaries between them
first; the tools slot into these roles interchangeably.

| Piece | Role | What it is |
|-------|------|------------|
| **Editor** | Where you read and write | A code editor that opens the folder and shows you the tree |
| **Agent** | The hands that type | A program that reads your intent, edits files, runs commands, and reports back |
| **Model** | The reasoning behind the hands | A large language model, reached over an API, that the agent consults to decide what to do |

A short way to hold it: **the editor shows, the agent acts, the model reasons.**
The editor is where you sit. The agent is a loop -- it reads the task, proposes an
edit or a command, carries it out, reads the result, and repeats until the work
is done or it needs you. The model is the intelligence the agent calls on for
each of those steps, over a network API. You supply the intent and the judgment;
the three pieces supply the speed.

None of these three is special to this template. The template is an ordinary git
repository of plain text files -- `.rye`, `.rish`, `.brix`, `.kyri`, and Markdown.
Any editor can open it, any agent can act on it, and any model can reason about
it. What *is* special is the discipline the tree keeps (TAME) and the way it
proves itself (witnesses) -- and those hold no matter whose tools you bring.

---

## 2. Editors and agents -- the four families

Modern editors and coding agents come in a few recognizable families. You will
meet all of them named in the wild; here is the shape of each, described so the
pattern is clear without pinning it to a product.

### The editor with an agent panel

The most common shape today is a familiar code editor with an **agent panel**
beside the file view. You type a request in plain language -- *"add a bounds
assert to this function"* -- and the agent proposes an edit as a diff you accept
or reject, keeping you in the loop at every step. The editor holds the files; the
panel holds the conversation. This family is the gentlest starting point: you see
every change before it lands, and you can stop at any diff.

### The terminal-driven coding agent

A second shape lives entirely in the terminal -- a **command-line coding agent**
you launch from the shell inside the repository. You describe a task, and it
works in a loop: reading files, running builds and witnesses, and editing source,
narrating as it goes. It has no window of its own; the repository and the shell
*are* its window. This family suits the person who already lives at a prompt, and
it composes naturally with the two commands this tree already uses -- `rye` to
build and `rishi` to run witnesses.

### The autonomous, workspace-centered IDE

A third shape is a fuller **agent-centered development environment**, where the
agent is not a panel bolted onto an editor but the center of the surface. You
hand it a larger task, and it plans, edits across many files, runs the project's
checks, and presents the result as a reviewable whole. This family leans toward
longer, more autonomous runs -- you give it a well-specified goal up front and
review the finished work, rather than approving each small diff.

### The hosted agent on a server

A fourth shape does not run on your machine at all. A **hosted agent** runs on a
server -- you give it the task and a pointer to the repository, and it works in a
container the provider operates, streaming its progress back to you. This is the
shape to reach for when a task is long-running, when you want it to continue while
your laptop sleeps, or when you want the work to happen in a clean, reproducible
environment rather than on your own machine.

**They are interchangeable for this tree.** Whichever family you use, the work it
produces meets the same bar: a module with its opening triad, its invariant
asserts, its named bounds, its explicit widths -- and a witness that runs green.
The family changes how much you review and where the compute runs; it never
changes what "done" means here.

---

## 3. Prompting an agent against this template

Here is the loop that matters most -- how you actually get a coding agent to build
something in this tree. The pattern is the same across every editor and agent
family, because it follows the template's own rhythm rather than any tool's.

The loop has four beats: **describe -> let it build -> let the witness judge ->
send.**

### Beat one -- describe the module, in the tree's own terms

An agent does its best work when your intent carries the template's disciplines
inside it. Rather than *"write a module that counts things,"* prompt with the
shape the tree expects:

> Grow a small module named `tally` that counts occurrences of a key in a `.kyri`
> document. Open the `.rye` file with the standard triad. Bound the maximum key
> count with a named constant and assert it. Use `u32` for the count. Give every
> function at least two invariant asserts. Have the binary answer `selftest` with
> a green line. Then write a `tally_count_witness.rish` in `tools/` that builds
> the binary, runs it, inspects the run-record, and closes on a `GREEN:` line.

That single description hands the agent the whole standard: the opening triad, a
named bound, explicit width, invariant asserts, a self-testing binary, and a
witness. A well-formed prompt is not a wish -- it is a specification the agent can
satisfy and the witness can check. The clearer the goal up front, the better and
the more autonomously an agent works; a vague prompt draped over many follow-up
messages tends to wander.

The template already carries the reference an agent needs to get the shape right.
Point it at these when it drifts:

- **[`the-developer-guide.md`](20260810-065116_the-developer-guide.md)** -- the
  four languages, the TAME discipline, and the build-and-witness rhythm in one
  place. This is the single best file to hand an agent as context before a task.
- **[`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)** -- the full
  discipline, every rule with its reasoning.
- **[`../tools/`](../tools/)** -- the living collection of witnesses. Every file there
  is a worked example of green-before-claim; an agent reading two or three near
  the module it means to touch will match the house style closely.

### Beat two -- let it build

Once the agent has the task, it works the loop: it writes the `.rye` source,
compiles it with `rye`, reads any compiler error, fixes it, and repeats. This is
exactly the loop a human runs -- build, read the error, adjust -- carried out
quickly. You watch, and you steer when it heads somewhere you would not.

```
rye build tally/count.rye -femit-bin=tally/bin/count
```

An agent will iterate here on its own until the build is clean. Your job in this
beat is judgment, not typing: is the module bounded, is each width explicit, does
each function assert its own contract? These are the things a witness cannot see
from outside, and they are where your eye earns its keep.

### Beat three -- let the witness judge

This is the beat that makes agents safe to use in this tree. When the agent
believes the module works, it does not get to *say* so -- it runs the witness, and
the witness decides.

```
rishi/bin/rishi run tools/tally_count_witness.rish
```

Green means the module holds, proven on this machine, right now. Red means a
named assertion failed and the message says which one -- and the agent's next move
is to read that message and fix the specific claim that broke, not to guess. The
witness is the arbiter of truth here whether a human or an agent wrote the code,
and that single fact is what lets you accept an agent's work without re-deriving
it by hand: **the green line is the proof, and it is the same green line either
way.**

Hold the agent to green-before-claim exactly as the tree holds everyone. If an
agent reports "done" without a green witness line, the work is not done -- it is a
claim awaiting proof. Ask for the witness output; trust the green line, not the
prose around it.

### Beat four -- send

When the witness is green, the work is ready to **send** -- commit, push, and (when
clean) fast-forward to the main branch, in the same CONTRIBUTING-style discipline
[`the-developer-guide.md`](20260810-065116_the-developer-guide.md) describes. An
agent can draft the commit for you: a component-prefixed subject under fifty
characters, a short Radiant body naming what changed and why, and a `Related`
section. Read it before it lands -- a commit message is a small piece of prose,
and it should sound like the rest of the tree.

Two disciplines ride along, exactly as they do for a human:

- **Green before send.** The witness runs green first, or the commit honestly
  names why it could not. A document changed alongside code lands in the *same*
  commit, so a doc never describes behavior the code no longer has.
- **A record rides along.** A session log -- a `.kyri` file capturing the
  reasoning behind the change -- ships in the same send whenever possible. When an
  agent did the reasoning, the log records that plainly.

---

## 4. Where the model runs -- hosted inference, in general terms

The model an agent reasons with runs somewhere, and you have a real choice about
where. This matters for a custody-first system: *where the reasoning happens* is
a decision you own, the same way you own where your identity and your secrets
live.

Two general shapes are worth knowing. Neither requires anything to be written
into this template -- the choice lives in your own environment, never in the tree.

### The model-provider API

The common shape is a **model-provider API**: a company runs a large language
model behind a network endpoint, and your agent sends it the task and receives
the model's reasoning back. You reach it over HTTPS with a credential the provider
issues you. Anthropic's API is one example of this shape; there are several. From
the template's point of view this is entirely external -- the agent on your
machine talks to the provider; the template is just the files the agent edits.

### The inference host

A second shape is an **inference host** -- a platform that runs a model (often an
open-weights one) on hardware it operates, and gives you an endpoint to reach it.
Baseten is one example of this shape; there are others. The difference from a
model-provider API is mostly *whose* model runs and on whose terms; the agent's
side of the conversation looks the same. This shape appeals when you want a
particular open model, or more control over the deployment, than a first-party
provider offers.

### What stays out of the template -- always

However you reach a model, the credential to reach it is a secret, and it is
governed by the same custody-first discipline as every other secret in this
world:

- **No API keys in the tree.** A model credential is read from your own
  environment -- an environment variable, a secrets manager, a login your editor
  or agent already holds -- and *never* written into a file that is committed.
  This is not a style preference; a key in a public template is a leaked key.
- **No accounts, no provider names, no endpoints baked in.** Which provider you
  use, which account, which region -- all of that lives in your environment, not
  in the template. The tree stays provider-neutral so anyone who clones it can
  bring their own.
- **The witness never needs the network.** A model helps *write* a module; it
  plays no part in *proving* one. Witnesses run entirely on your own metal against
  the built binary -- they call no model and reach no endpoint. The proof is local,
  reproducible, and yours, whatever wrote the code it checks.

This is the same boundary the whole system keeps between reading and building:
the agent and its model are how the work gets *written*; the witness on your own
machine is how the work gets *proven*. Keeping the reasoning external and the
proof local is exactly what custody-first asks -- you decide where the thinking
happens, and the truth is always checkable in your own hands.

---

## 5. A worked pass, start to finish

Here is the whole loop in one short pass, so the shape is concrete. Every command
is one you have already met.

1. **Open the tree** in your editor of choice, with whatever agent it offers, and
   point the agent at
   [`the-developer-guide.md`](20260810-065116_the-developer-guide.md) for context.

2. **Describe the module** in the tree's own terms -- name it plainly, name the
   bound, name the widths, ask for invariant asserts, a self-testing binary, and
   a witness. Hand the specification, not a wish.

3. **Let it build.** The agent writes the `.rye` source and runs
   `rye build <module>/<file>.rye -femit-bin=<module>/bin/<name>`, reading and
   fixing compiler errors in a loop. You watch the bounds, the widths, and the
   asserts.

4. **Let the witness judge.** The agent runs
   `rishi/bin/rishi run tools/<module>_..._witness.rish`. Green proves the module;
   red names the broken claim for the agent to fix. Do not accept "done" without
   the green line.

5. **Send.** With the witness green, the agent drafts a CONTRIBUTING-style commit;
   you read it, sign it, and send it -- the code, the doc it touches, and a `.kyri`
   session log together in one commit.

That is the full rhythm, unchanged from the hand-written path in
[`the-developer-guide.md`](20260810-065116_the-developer-guide.md): **build,
prove, send.** An agent changes who holds the keyboard and how fast the beats go.
It never changes what proves the work true.

---

## 6. Where to look next

- **[`the-developer-guide.md`](20260810-065116_the-developer-guide.md)** -- the
  four languages, the TAME discipline, and the build-and-witness rhythm the agent
  loop is built on. Read this first, and hand it to your agent.
- **[`your-first-hour-with-grain.md`](20260810-065116_your-first-hour-with-grain.md)**
  -- clone, build, and prove a module by hand, so you know the loop the agent is
  running for you.
- **[`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)** -- the full
  discipline, every rule with its reasoning; the best single context file for an
  agent working on this tree.
- **[`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md)** -- the voice
  this tree writes in, so an agent's prose and commits sound like the rest of it.
- **[`../tools/`](../tools/)** -- the living collection of witnesses. Every one is a
  worked example of green-before-claim; the fastest way to teach an agent the
  house style is to point it at a few near the module it means to touch.

---

You now have the whole shape of working on this template with modern tools: an
editor to sit in, an agent to hold the keyboard, and a model -- reached however
you choose -- to reason behind it. The pattern is provider-neutral and the
disciplines are unchanged: describe the module in the tree's own terms, let the
agent build it, let the witness prove it green, and send the proven work. The
agent makes the beats faster; the green line keeps them honest. Bring whatever
tools you love -- the tree will prove their work true exactly as it proves your
own.
