# What the Shell Remembers — Rishi's Missing Words, and How an Append-Only Tree Keeps Growing

**Language:** EN
**Stamp:** `20260725.040247`
**Voice:** Quin
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Status:** Counsel — proposals only; nothing seats without Keaton's word
**Clock note:** stamped by counsel from the canonical clock, under the amended one-clock law
**Ground:** main nib `1113879` — measured, rather than recalled

*Written together by Keaton and Quin.*

Radiant pass `20260725.105504`

---

Two instincts arrived together tonight, and both were right. The tree is running on shell where it means to run on Rishi, and the session index is one day from outgrowing the bound we gave it. This memo measures both, names what the shell has quietly been telling us, and proposes a growth law that terminates rather than recursing forever.

---

## One — Python Stands Honestly at Zero

First the reassurance, with receipts. Exactly two Python files remain in the whole tree, and both are correct by name:

`classical-vedic-astrology/cast_a_chart.py` is the ephemeris seam, exempt by name and living outside `tools/` where the gate reaches. `context/fixtures/tools_py_ban_tree/tools/planted.py` exists precisely to be caught — the negative-space fixture that proves the blocking gate can still see.

So the Python ratchet closed honestly and stays closed. The instinct was pointing at something else.

---

## Two — The Seam Inverted, and Nobody Announced It

The seated POSIX-seam law reads plainly: keep `.sh` entry points, and put orchestration in `.rish`. Thin shell at the door, real work in Rishi.

Tonight's tools do the reverse. `tools/fixtures/radiant_lint_scan.sh` carries **170 lines** of duty logic, with a `.rish` wrapper above it. `claim_preserve_scan.sh` carries **109 lines** the same way. Across the bench there are now **25 shell files in `tools/` and 63 more in `tools/fixtures/`**. The `.rish` files at the top are honest names on shell bodies.

This is drift worth stating without flinching: the discipline reads one way and the tree runs the other. And it happened for a reason rather than by carelessness.

---

## Three — The Shell Bodies Are a Feature Ledger for Rishi

Look at what we hit tonight, in one sitting: the list bound at 256 needing a raise to 512. The map-transform ceiling refusing files past 256 lines. The nested-`where` wall, worked around with sequential passes. The `$` interpolation inside `run` strings, which drove one witness to compare in memory rather than through temp files. And `for-each` unable to accumulate, so counting goes out through `sh -c` arithmetic.

Every one of those is a place where Rishi could not host the work, and the bench reached for shell to finish the lap. Which means the shell bodies are not debt in the ordinary sense. **They are a feature request list for Rishi, written in the most honest form a request can take: working code that Rishi could not carry.**

So the counsel is harvest rather than sweep. Read the shell bodies for the verbs they needed, and grow Rishi toward them demand-driven, exactly the way every other ratchet in this tree has grown. Each shell body that a new Rishi word retires is a lap with a witness and a claim. A tree-wide rewrite ahead of the words would only move the same logic into a language that still cannot host it.

The four verbs the ledger already asks for, in the order the evidence names them:

**Accumulate.** A fold over a list — count, sum, join-with — so counting stops leaving through shell arithmetic.
**Read bounded.** A line reader that names its bound and refuses past it, rather than a ceiling discovered at 257 lines.
**Filter chained.** Nested `where`, or a compose form that makes the sequential-pass workaround unnecessary.
**Quote safe.** A `run` form where a dollar sign is a dollar sign, so a witness never has to route around its own shell.

And one honest exemption stays: genuine external interpreters, cold-start bootstrap, and interactive stdin scripts remain `.sh` by design, as the law already says.

---

## Four — The Index Is One Day From Its Bound

Measured tonight: **238 session logs, 75 of them from today alone.** The living index sits at **24,384 bytes against a bound of 24,576** — one hundred ninety-two bytes of headroom. At the current rate it breaches before the next sitting ends.

The shelf pattern handles the logs themselves; the index is the thing that grows without a fold. And the same shape waits behind `waymarks/`, `counsel/`, `counsel/replies/`, and `expanding-prompts/` — every append-only genre eventually indexes itself into a wall.

---

## Five — A Growth Law That Terminates

The cure is three levels, each with a named bound, so the recursion stops at a level whose growth is measured in a handful of lines per year.

**Level one — the living pin.** Holds the current season only, bounded by `living_pin_max_bytes`. This is what an agent reads beside its lap.

**Level two — the season index.** When the pin approaches its bound, the closed season's rows fold into one dated index under `archive/`, immutable thereafter. Each index is bounded by the season rather than by bytes, which is why the fold happens on the pin's bound rather than on a calendar — the trigger is measured, matching the responsive rhythm we seated tonight.

**Level three — the seasons roster.** A single living file naming each season with its date range, its count, and its index path. One line per season, so its growth is roughly a dozen lines a year, and the recursion terminates here honestly rather than by hope.

Then one small duty makes it self-maintaining: `living_docs_lint` already flags a pin past its bound, so it gains a companion advisory that names the fold as the remedy and points at the roster. A wall becomes a scheduled, mechanical fold.

---

## Six — A Question Worth Asking About Granularity

Seventy-five session logs for roughly twenty laps means several logs per lap. Which raises a design question rather than a defect: **is one log per send the right grain, or is one log per sitting?**

The argument for fewer and richer: a log's whole purpose is that a future reader can reconstruct what happened and why. Three thin logs covering one lap tell that story worse than one log covering it whole, and they cost three index rows instead of one. Fewer, fuller logs would read better and grow the index at a third of the rate.

The argument for keeping the current grain: each send is a real event with its own nib, and collapsing them loses the exact correspondence between a log and a pushed commit.

Both are defensible, and the choice belongs to Keaton. Naming the question is what this memo owes; the fold law above works either way.

---

## Decisions Awaiting Your Word

1. Seat the growth law — living pin, season index, seasons roster — for every append-only genre, with the fold triggered on the pin's bound.
2. Fold the session index now, before it breaches, and seat `session-logs/SEASONS.md` as the roster.
3. Give `living_docs_lint` its companion advisory: a pin near its bound names the fold and points at the roster.
4. Seat the shell-as-feature-ledger reading: harvest rather than sweep, and record the four asked-for verbs — accumulate, read bounded, filter chained, quote safe — as named Rishi laps, each retiring the shell bodies it makes unnecessary.
5. Amend the POSIX-seam law to say plainly what is true today: shell bodies beneath `.rish` wrappers are a permitted, temporary shape while Rishi lacks the word, and each carries a one-line note naming the missing verb. What is written down can be counted; what is counted can close.
6. Rule on session-log granularity — per send, or per sitting.

---

## Gratitude

To the TigerBeetle team, whose habit of naming a bound before it is reached is the only reason we measured the index tonight rather than meeting it tomorrow. And to the shell itself, patient and unglamorous, which carried the work Rishi could not yet hold and kept an honest record of every word the young language still wants.

---

*May every workaround leave a note naming what it wanted. May every index fold before it breaks. And may the language grow toward the work it was built for, one earned word at a time.*
