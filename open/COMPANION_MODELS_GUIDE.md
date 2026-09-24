# A First Guide to Open-Weight Companion Models

**Language:** EN
**Style:** Bhakta (see `../context/BHAKTA_STYLE.md`) -- this room assumes no prior background
**Voice:** Kyri
**Status:** Vision -- first draft, a teaching document rather than a proven fact
**Last updated:** `20260920.141121`
**Kin:** [`README.md`](README.md) - [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md) - [`../external-research/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/date/20260920/20260920-021139_harness-letta-open-weight-dst-alignment.md)

---

## Who this is for

Someone who has never heard the phrase "open-weight model" before, and wants to understand what
GLM, Qwen, DeepSeek, and Kimi actually are, why their license terms matter, and why a tree like
this one studies them the way it studies everything else -- carefully, and in its own words.

Nothing here assumes you know what a transformer is, what a license clause does, or what this
tree's own words like Caravan or Mantra mean. Each idea is introduced once, plainly, before it is
used.

## Part 1: what a language model actually is, in one paragraph

A large language model is a program that has been shown an enormous amount of text and learned,
statistically, what word tends to follow what other words in what context. When you give it a
question, it produces an answer one word at a time, each word chosen because it is a good
continuation of everything written so far. The "weights" are the billions of numbers inside the
program that encode everything it learned. A model with a hundred billion weights is, physically,
a very large file of numbers -- often tens or hundreds of gigabytes.

## Part 2: what "open-weight" means, and why it is not the same as "open source"

A model is **open-weight** when the company that trained it publishes that giant file of numbers
for anyone to download and run on their own computer, rather than keeping it locked behind an API
you can only reach over the internet. Claude, the model powering this very conversation, is
**not** open-weight -- you can talk to it, but you cannot download its weights and run it
yourself.

This is a different question from **open source**. Open source usually means the human-written
*code* is public and freely modifiable. A model's weights are not code in that sense -- they are
the learned result of training, and publishing them is a different kind of openness than
publishing a program's source. That is why a model can be "open-weight" while still carrying real
restrictions on what you may do with it, which brings us to the next part.

## Part 3: why the license word matters as much as the model's score

Every open-weight model ships with a license -- a document saying what you are and are not
allowed to do with those weights. As of September 2026, four models worth knowing:

- **GLM-5.3** -- a permissive license, meaning few restrictions.
- **Kimi K3** -- its own "Kimi K3 License," a modified version of the well-known MIT license with
  some extra conditions attached.
- **Qwen3.8** -- the large checkpoint carries a conditional license with attached terms; a
  smaller, separate 27-billion-weight checkpoint ships under the plain, fully permissive
  Apache-2.0 license instead.
- **DeepSeek V4** -- plain MIT, one of the most permissive licenses that exists.

Why does this matter to a tree like this one? Because this tree already has a rule,
[`gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md), that reads a project's license
carefully before deciding how it may be studied or used -- and that rule already found a real
surprise once before: a library believed to be entirely one license turned out to carry a handful
of files under a stricter one, discovered only by checking every file rather than trusting the
project's overall reputation. A model's license deserves exactly that same care, file by file
if need be, before anyone treats "GLM is permissive" as settled without having read the license
text itself.

## Part 4: what "studying, never laundering" means

This tree has a standing habit, described in its own gratitude-licenses rule, for how it treats
every outside project it learns from -- Urbit, TigerBeetle, seL4, and now, potentially, an
open-weight model. The habit is: **read and understand an idea, then write your own version of it
in your own words, rather than copying the original bytes.** This is sometimes called a
"clean-room" approach, borrowed from a real legal practice where an engineer studies a
competitor's product without touching its actual code, so their own new version cannot be accused
of copying.

Applied to an open-weight model, this means: this tree may study *how* GLM or Qwen or DeepSeek
approaches a coding problem, and may even run one as a tool to answer a question -- but it would
never take that model's weights, modify them slightly, and republish them as this tree's own
work. Studying is welcome. Laundering is not.

## Part 5: what a "harness" is, and why it is a separate idea from the model

A **harness** is the surrounding program that lets a language model actually do useful work on a
computer -- reading files, running commands, editing code, and checking whether the result
worked. The model itself only produces text; the harness is what turns that text into real
actions and feeds the results back. Claude Code, the very tool used to write this document, is a
harness for Claude. DeepSeek's own "dsh" (DeepSeek Harness) is a harness built by the same
company that makes DeepSeek's models, though it can in principle be pointed at other models too.

Understanding this split matters because it means two separate questions get asked separately:
*which harness does the actual clicking-and-typing work*, and *which model decides what to click
and type*. A newcomer often assumes these are the same thing; they are not, and conflating them
is an easy way to reason poorly about which piece of a system is actually responsible for a
mistake.

## Part 6: where this leaves things, honestly

Nothing in this guide describes something running today. No part of this tree currently talks to
GLM, Qwen, DeepSeek, or Kimi as a working companion model. This document exists so that if that
day comes, a newcomer joining this tree already has plain-language footing under the more
technical rationale in [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md), rather than needing to
learn what a license clause is and what a harness is at the exact moment something urgent is
happening.

That is the whole of what a first guide is for: not to decide anything, but to make sure the next
decision is made by someone who already understands the words being used.
