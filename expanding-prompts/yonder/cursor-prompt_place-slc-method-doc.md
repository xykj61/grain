# Cursor prompt — Place the Simple, Lovable, Complete method in `context/`

**Goal:** Welcome one new living document — our own-voice distillation of the Simple, Lovable, Complete method — onto the `context/` shelf beside `RADIANT_STYLE.md` and `TAME_STYLE.md`, and wire the few links that make it discoverable. This is pure addition: nothing is renamed, nothing is removed.

Work in Radiant Style. Gate every change behind propose-then-confirm. Touch no other work.

---

## Step 0 — Footing check

Before anything, confirm and report back:

- Current branch is `main`, working tree clean, and you are level with `github/main`.
- These anchors exist as expected: `context/RADIANT_STYLE.md`, `context/TAME_STYLE.md`, `context/REYA2.md`, `gratitude/README.md`, and the direction memo `active-designing/20260628-043542_thin-frontend-slc-direction.md`.
- Report whether `context/` carries an index file (a `README.md` or similar). If one exists, note its shape; if none exists, say so.

Stop after Step 0 and show me what you found before proceeding.

---

## Step 1 — Place the document

Create the file **`context/SIMPLE_LOVABLE_COMPLETE.md`** with the exact content in the fenced block below. It is a permanent context file, so it carries the plain header block and omits any dated co-author credit line, matching `RADIANT_STYLE.md` and `REYA2.md`.

````markdown
# Simple, Lovable, Complete

**Language:** EN
**Last updated:** 2026-06-28
**Style:** Radiant (see `RADIANT_STYLE.md`)

**Purpose:** Name how we ship — so that every release, at every size, is something a person can use today and genuinely love.

---

## The Three Words

Simple, Lovable, Complete. Three words name a way to release work into the world. We build something small in scope, delightful to use, and whole within the bounds it sets for itself — and we offer that at every step, from the first running thing to the full machine.

This method comes to us from Jason Cohen, who named it as the warmer sibling of the minimum-viable habit. The source essay rests in our `gratitude/` directory, among the teachers we keep close. Here we silo the idea in our own voice and bind it to how Rye OS grows.

---

## Lead with Simple

Simple means narrow on purpose. We choose one thing to do, and we draw the edge of that scope honestly, so the work stays quick to build and easy to hold in the mind. A small tool finishes; a sprawling one lingers. When the scope is small and named plainly, the people who use it forgive everything it never claimed to be, because it kept the promise it actually made.

Simplicity is the doorway to the other two. A thing kept small can be finished, and a thing finished can be loved.

---

## Let It Be Lovable

Lovable means someone genuinely wants it. The work delights at its own small scale — it feels good in the hand, it runs on your own machine, it belongs to the one who holds it. Care announces itself in every use, and love grows from completeness met with craft, rather than from a long list of features still waiting to arrive.

A modest thing made with devotion earns affection that a grand, unfinished thing rarely does. We aim for the affection first.

---

## Make It Complete

Complete means the loop closes. Whatever the work claims to do, it does fully, from beginning to end, within the bounds it set. A small program that finishes its one task earns trust. A larger program that almost works spends trust it has yet to earn. Completeness is honesty about scope: do the narrow thing wholly, and claim only what the work can already make true.

---

## Why This, Rather Than the Minimum

The minimum-viable habit ships the smallest thing that proves a point, and asks the people who use it to forgive what is still missing. We choose a different stance. We ship the smallest thing that is *whole* — complete at its scope, lovable in its use — and we ask nothing to be forgiven.

A release that stays modest forever is still a good and finished thing. A grand release that never quite arrives is the costly one. So a promise we can keep is worth more than a grander promise we cannot, and a small, finished, beloved thing is worth more than a large, half-built one. A tool that carries a fraction of another's features can still be complete and cherished, as long as it does its one chosen thing beautifully and claims no more. Smallness here is no apology; it is the shape of something finished early.

---

## How Rye OS Grows by This Method

Each ring of Rye OS is a simple, lovable, complete thing, grown from the running seed before it. This weaves directly with Gall's Law: the working whole grows from a smaller working whole, never from a grand design imposed at once.

The first such whole is the Rishi-and-Mantra shell — a place to type a command, watch it run, keep its history, and call it back. Simple, for it is one loop. Lovable, for it is yours, on your own metal, and it already works. Complete, for the circle closes: type, run, version, recall. The Pond GUI is the next ring, grown from that one when Skate and the window stand ready. Ring by ring, the whole machine arrives by degrees.

This method keeps company with the others we hold. Gall's Law tells us to grow from working simples. Aparigraha tells us to carry only what we use. Simple, Lovable, Complete tells us that each step we carry should already be worth loving. Together they keep the path light and the work alive at every stage.

---

## Three Questions Before Release

Hold each new thing up to three plain questions:

- **Simple** — does it hold one clear scope, honestly bounded?
- **Lovable** — would a person genuinely want to use it today?
- **Complete** — does the loop close fully within that scope?

When all three hold, the work is ready to share, whatever its size.

---

*May each thing we ship be whole at its own scale. May the small and the finished be loved more than the large and the unready. And may every ring we grow be a joy to run on the very day it arrives.*
````

After writing it, confirm the file matches: first line is `# Simple, Lovable, Complete`, and the closing line is the three-clause benediction beginning "May each thing we ship be whole."

---

## Step 2 — Propose the link wiring (then wait)

Do not edit these yet. **Propose** a small, honest set of cross-links, show me the exact diffs, and wait for my confirmation:

1. **`gratitude/README.md`** — beside the existing note on the SLC source essay, add one line pointing to our distillation: that the method now lives in our own voice at `context/SIMPLE_LOVABLE_COMPLETE.md`.
2. **`context/` index**, if one exists — add a single entry for the new document, in the same shape as the surrounding entries. If no index exists, propose nothing here and say so.
3. **`active-designing/20260628-043542_thin-frontend-slc-direction.md`** and **`ROADMAP.md`** — only where the words "Simple, Lovable, Complete" or "SLC" already appear, offer to add a link to `context/SIMPLE_LOVABLE_COMPLETE.md` on first mention. Light touch; first mention only.

Show the diffs and stop.

---

## Step 3 — Apply and commit (after I confirm)

Once I approve the wiring, apply the confirmed diffs and commit everything in one commit.

Radiant commit message:

```
context: silo the Simple, Lovable, Complete method in our own voice

Welcome SIMPLE_LOVABLE_COMPLETE.md onto the context shelf beside
RADIANT_STYLE and TAME_STYLE — our own-voice distillation of the
method Jason Cohen named. Source essay stays in gratitude; this is
our binding of it to how Rye OS grows, ring by ring.

Written together by Kaeden and Reya 2.
```

Report the commit hash. Leave the push to GitHub to me unless I ask otherwise.
