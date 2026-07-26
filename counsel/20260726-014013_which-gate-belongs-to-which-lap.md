# Which Gate Belongs to Which Lap

**Language:** EN
**Stamp:** `20260726.014013`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Checkable — the additive proof below was written and exercised on both a known-good and a known-bad path against the tree at nib `c5598b9eda`
**Ground:** J · D1 · D2 · K · E landed and verified · F in flight past seventy-three minutes on chapter one · G stopped on `markdown_structure` heading signature · SOURCE restored to HEAD · guides drafted and held
**Answers:** [`counsel/replies/20260725-235531_re-relay-stop-g-heading-signature.md`](replies/20260725-235531_re-relay-stop-g-heading-signature.md)
**Extends:** [`counsel/20260725-223409_the-tool-the-door-the-rung-and-the-lane.md`](20260725-223409_the-tool-the-door-the-rung-and-the-lane.md) · [`counsel/20260725-224641_the-gate-that-caught-me.md`](20260725-224641_the-gate-that-caught-me.md)
**Counsel model this sitting:** Claude Opus 5 1M High

*Written together by Keaton and Quin.*

---

## Three Stops, One Cause

The bench has stopped three times today and every stop was correct. The first found missing files. The second found claim drift the relay swore was absent. The third found a heading signature a content lap cannot hold still. Two of those three trace to the same root, and the root is in my hand rather than the bench's: **I keep naming pass-gates as the guard for laps that are not passes.**

`claim_preserve` freezes claim tokens so a Radiant pass cannot quietly move a fact. `markdown_structure` freezes the heading signature so a Radiant pass cannot quietly restructure a page. Both are exactly right for what they were built to guard. Both are the wrong instrument for a lap whose entire purpose is to add a section or correct a stale figure — and asking for a green from a gate designed to forbid the thing you were told to do produces either a false green or an honest stop. The bench chose the honest stop, twice, and restored the file both times. That is the loop working.

The cure is not another exception written one lap at a time. The cure is naming, once, which gate belongs to which kind of lap.

## The Ruling for G

**Seat the exception, and prove more than the witness asked.** SOURCE's Part One is a content lap by seating, so `markdown_structure`'s heading check cannot apply and the witness stays untouched this sitting. What replaces it is a stronger claim, and one the frozen-signature check never made: **the heading growth is purely additive.** Every original heading survives at its original level with its original text, in its original order, and everything new is new.

Counsel wrote that check and exercised it both ways against the tree — clean on an unchanged SOURCE, clean on a mock Part One insertion, and red the moment a single existing heading was reworded. It ships in the relay as a heredoc rather than as a new file in `tools/`, because one lap does not earn a permanent tool. The bench runs it unpiped so its exit code lands, pastes both signatures into the reply, and runs the seated `markdown_structure` witness alongside it so the expected single `FAIL heading levels changed` is recorded in the open rather than hidden. Tables, fences, and links keep their ordinary blocking force; if any of those three go red, the lap stops as usual.

One correction to my own G specification makes the additive claim true: **no existing heading text changes.** Part One and Part Two arrive as new banner headings, C0 through C5 as new children beneath Part One, and every `## Step N` line stays exactly as it reads today. The earlier word "retitle" invited a rewrite it never needed.

## What the Signature Also Counts

Exercising the check surfaced something the tree should know. `markdown_structure`'s heading signature runs over raw text and never masks fenced blocks, so **every shell comment inside a code fence counts as a heading** — SOURCE's `# SHA256:EXAMPLE…` and `# macOS (Homebrew qrencode…)` lines are, to that gate, level-one headings. This sits crosswise with the TAME lint that counts one `# Title` per markdown *with fences ignored*, and it means any lap adding a commented command block moves the signature even when the document's real structure never budges. The additive check in the relay masks fences, so it speaks about real headings; the seated witness does not, and its output should be read with that in mind.

## Two Parked Laps, Better as One

The claim_preserve `WORD` and `IDENT` token classes are parked. An additive-heading mode for `markdown_structure` now parks beside them. They are the same lap wearing two hats, so counsel proposes they land together as **one gates-for-content-laps lap** once the finishing edge clears — a single sitting that adds the two token classes, masks fences in the heading signature, adds an explicit additive mode gated by an environment word, and carries a known-good fixture beside a known-bad one for each of the four changes. One lap, four fixtures, every widening witnessed. Nothing widens before then.

## The Standing Table, Proposed

Offered as a small addition to [`context/TWO_ROOMS.md`](../context/TWO_ROOMS.md), so a future relay reaches for the right instrument without rediscovering today's lesson. This is a compass edit, so it waits for Keaton's word in the ordinary way.

| Lap kind | What it may move | Gates that bind | Gates that stay in the holster |
|---|---|---|---|
| **Radiant pass** | wording only | `claim_preserve` · `markdown_structure` · `radiant_lint` | — |
| **Status correction** | a named figure or name, with its evidence | `markdown_structure` · `living_docs_lint`; each correction named in the commit body | `claim_preserve` — the lap exists to move a claim |
| **Content lap** | new sections, new pages | tables · fences · links · `living_docs_lint` · `radiant_lint`; additive-heading proof | `claim_preserve` · heading signature |
| **Code lap** | code and its witnesses | the module's own witnesses · parity chapter | the prose gates |

The discipline underneath it is one sentence: **a gate proves what its assertions say, so name the lap before you name the gate.**

## Two Observations, Reported Once

Full parity has been running past seventy-three minutes on chapter one against a counsel estimate of thirty to forty. That may be an honest measurement of a suite that has grown, or it may be a chapter that wants a look; either way the number belongs in the record now rather than in a memory later, and the first full green will say which. Separately, the send-after-every-round default seated at `20260726.010659` reads well against the accrete law — more, smaller sends leave a finer-grained record and shrink what any single stop can strand.

---

*May each gate guard the lap it was built for. May every heading we add leave the ones before it standing. And may the third stop be the one that teaches the rule, so a fourth of its kind never comes.*
