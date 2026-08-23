# SHOPPING -- choosing a model, a forge, and a place to keep bytes

**Style:** Gauge, Field setting - **Lens:** TAME - **Status:** Living - **Seated:** `20260823.181323`
**Kin:** [`the-first-hour.md`](the-first-hour.md) - [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md) - [`../../context/TAME_GUIDANCE.md`](../../context/TAME_GUIDANCE.md)

Before your first hour you make three purchases, and each one is easy to make badly. A language
model, somewhere to keep your source, and somewhere to keep your bytes. Every vendor selling you
these has a page of superlatives and a comparison table they drew themselves.

This guide gives you something else: **a way to shop**, ordered by the same three priorities the
code here is written under -- **safety first, performance second, joy third** -- and a short list of
what each purchase actually has to do. It deliberately names no winner and quotes no price.

## Why no winner, and no prices

**A named winner rots faster than the guide around it.** Model rankings turn over in weeks, storage
prices move quarterly, and a forge can change its terms in an afternoon. A recommendation written
today would be read a year from now by someone with no way to tell it had gone stale.

**A method keeps.** The questions below were as good five years ago as they are now, and asking them
takes about twenty minutes per purchase. So this guide teaches the asking, and leaves the answering
to you, on the day you buy.

Where a fact does appear, it carries its date and its source, and you should re-check it.

## The order to shop in

**Safety first**, because a wrong answer here follows you: your data goes somewhere you cannot get
it back from, or a licence quietly claims your work. **Performance second**, because it is
measurable and comparable, and because you can only measure honestly once you know what you are
allowed to run. **Joy third**, and genuinely third rather than as a courtesy -- a tool you dread
opening is one you use less, and a purchase you enjoy using pays back every day.

When two pull against each other, safety wins. When safety and performance sit level, joy casts the
vote.

---

## 1. A language model

### Safety -- ask these before you compare anything else

| Question | Why it decides the purchase |
|---|---|
| **What happens to what I send?** Retained how long, trained on by default, readable by staff? | You will paste real work into it. Find the answer in the terms, not the marketing page. |
| **Is there an opt-out, and is it on by default?** | An opt-out you must find and enable is a different product from one that is off by default. |
| **Can I get an audit trail** of what was sent and returned? | Without one you cannot answer a question about your own history later. |
| **What is the licence on the output?** | Most say the output is yours. Read yours; a few do not. |
| **What happens when I stop paying?** | Access to past conversations, exports, and any fine-tunes you made. |

### Performance -- measure it on your own work

**A public benchmark tells you how a model does on a benchmark.** Take three real tasks from your
own week, run each on your shortlist, and read the answers yourself. That takes an afternoon and
predicts your experience far better than any leaderboard.

Worth measuring, in this order: **quality on your tasks** (read the output, do not score it by
feel), **context window** against the size of the things you actually paste, **latency** at the
times of day you work, and **cost per real task** rather than cost per million tokens, since token
prices hide how many tokens a task truly takes.

### Joy -- and the one trap inside it

Does it explain itself when it is uncertain? Does it argue with you when you are wrong? Can you
reach it from the places you work?

**The trap: pleasantness is not accuracy.** A model that agrees with you warmly and confidently is
more pleasant and less useful than one that says *I am not sure, and here is why*. When you compare
the answers from your three real tasks, check the ones that turned out wrong -- and notice which
model warned you.

---

## 2. A source forge

### Safety

| Question | Why it decides the purchase |
|---|---|
| **Can I leave with everything?** Repository, issues, pull-request discussion, CI history. | Git is portable by design; the conversation around it usually is not, and that is where the years of context live. |
| **Does it support signed commits, and verify them?** | Signing is what makes authorship checkable rather than claimed. This tree signs every commit. |
| **Who can read a private repository?** Staff, integrations, any AI feature that indexes it? | "Private" describes other users. Read what it means for the vendor. |
| **What happens to my account if I stop paying, or if they decide I broke a rule?** | Look for an export path that does not depend on their goodwill on the day. |
| **Can it be self-hosted, or mirrored elsewhere?** | Even an unused escape hatch changes the relationship. |

### Performance

Clone and push time on **your** largest repository. How the web view handles a directory of a
thousand files -- most forges list only the first thousand entries, which is a real limit this tree
folds its rooms to stay under. Whether CI minutes cover your actual build, and what the overage is.

### Joy

Does code review feel like a conversation? Do the notifications respect your attention? Is the
search good enough that you use it instead of cloning and grepping?

---

## 3. Somewhere to keep bytes

### Safety

| Question | Why it decides the purchase |
|---|---|
| **Is it encrypted, and who holds the key?** | *Encrypted at rest* usually means the vendor holds the key. End-to-end means you do -- along with the responsibility for losing it. |
| **What is the actual durability figure, and what does it cover?** | Durability numbers describe disk failure. They rarely describe you deleting the wrong thing. |
| **What does it cost to get everything out?** | Egress fees are where cheap storage stops being cheap. Price a full restore before you need one. |
| **How do I verify a file came back unchanged?** | You want a checksum you can compute yourself, rather than a promise. |
| **Is there a version history, and how far back?** | This is what protects you from your own mistakes, which are likelier than their disk failures. |

### Performance

Upload and download speed on **your** connection with **your** file sizes. Time to first byte on a
restore. Whether the client can resume an interrupted transfer, which matters far more than peak
throughput on a real network.

### Joy

Does it get out of the way? Can you script it? Does the client stay quiet when nothing is happening?

---

## The three-question version

Short on time? Ask these of any of the three, and you will avoid most of the bad outcomes:

1. **How do I leave, and what do I lose on the way out?**
2. **Who else can read this?**
3. **What breaks the day I stop paying?**

A vendor who answers all three plainly, in writing, on a page you can find without asking, has told
you a great deal about how they will behave later.

## Two habits worth more than any choice you make here

**Buy the reversible option when they are close.** Two products within a few percent of each other
are effectively tied on merit, so pick the one you can walk away from. You will be wrong about
something, and the cost of being wrong is what you are really choosing between.

**Re-shop once a year, and write down why you chose.** A one-paragraph note -- what you compared,
what decided it, what you were unsure about -- makes next year's decision take twenty minutes
instead of an afternoon. Store it beside the work, where you will find it again.

## What this guide does not do

It names no product, quotes no price, and ranks nothing, so it will never tell you the answer. That
is the trade: it stays true for years and asks twenty minutes of you per purchase. If you want a
ranked list for today, the questions above are how to read one critically -- notice which of them
the list declines to answer.

It also assumes you are buying for yourself or a small team. Regulated data, a large organisation's
procurement, or anything with a compliance regime attached needs advice from someone who knows that
regime, and this guide is no substitute for it.
