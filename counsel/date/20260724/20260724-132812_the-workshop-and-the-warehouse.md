# The Workshop and the Warehouse — Context Economy Counsel

**Language:** EN
**Stamp:** `20260724.132812`
**Voice:** Quin
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Status:** Counsel — proposals only; nothing seats without Keaton's word
**Ground:** measured against the tree at the shallow tip of `xykj61/urbit`, 2026‑07‑24, plus current vendor documentation gathered the same day

*Written together by Keaton and Quin.*
Radiant pass `20260724.223233`
*Erratum `20260724.223233` — remote count: living canon is **four**; see [`context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md). The “five remotes” wording in the body stays as testimony.*

---

This memo gathers one measurement and seven proposals. The measurement says where the tree's weight truly sits — in git, in the editor's index, and in every prompt the bench sends. The proposals return that weight to the work. The compass beneath all of it stays the one we already follow: slower to go faster, and a context treated the way Tally treats memory — a named budget spent deliberately, rather than a heap to fill.

Every proposal here is packaged for your hand alone. Where a command appears, it is a draft of the motion, ready for the bench once you say the word.

---

## What the Bench Measured

The working tree carries **108 MB across 8,146 tracked files**. Four places hold most of it, and three documents hold most of the token cost. Byte counts convert to tokens at roughly four bytes each, so the figures below are honest estimates rather than pins.

| Weight | Size | Cost it exacts |
|---|---|---|
| `tools/bin/` — three committed build binaries | 29 MB | rides every clone and every five‑remote push; regenerable by definition |
| `vere/` — 1,105 tracked files | 32 MB | pushed to five remotes; watched by the editor even while index‑ignored |
| `old/` — the elder study tree | 15 MB | same shape, smaller weight |
| `session-logs/README.md` | 427 KB (~105k tokens) | a living name on a season ledger; one read spends a third of a bench window |
| `work-in-progress/TASKS.md` | 345 KB (~85k tokens) | "check the tasks" costs a novella |
| `work-in-progress/ROADMAP.md` | 182 KB (~45k tokens) | same law, same cure |
| `.cursor/rules/` — 17 of 22 rules always‑on | 45 KB (~11k tokens) | injected into **every** bench message |
| `context/TAME_GUIDANCE.md` | 72 KB (~18k tokens) | canon, consulted often; deserves a small bench card |
| `active-designing/` | 380 files | a directory listing costs pages rather than sentences |

The good news leads the ledger: the `.cursorignore` seated `20260722.183653` already keeps vendor, old, vere, and the archive shelves out of the AI index. Everything below refines a discipline already standing.

---

## Proposal One — Lighten What Git Carries

Untrack the three build binaries and let git stop hauling 29 MB of regenerable output to five remotes:

```
git rm --cached tools/bin/tame-usize-audit-test \
               tools/bin/align-session-logs \
               tools/bin/enrich-strengthening-docs
printf 'tools/bin/\n' >> .gitignore
```

History keeps every byte already committed, so accrete‑never‑break holds whole; the change governs the road ahead. Each binary earns a one‑line rebuild note beside its source, so the path back is named.

For `vere/` and `old/`, my counsel is the sibling study clone: each becomes its own repository beside the pier, referenced by path, cloned only where a lap truly reads it. A pinned submodule is the alternative if commit‑exact pinning matters to you; either way, forty‑seven megabytes leave the daily push. And for the jail itself, sparse checkout gives each lap a lane‑sized tree:

```
git sparse-checkout set glow context tools rishi
```

---

## Proposal Two — The Pin and the Ledger

The tree already knows this law in two dialects — the archive shelves and the STOA compressor. This proposal seats it as one sentence:

> **A living document keeps a bounded pin — the current season only — and closed seasons roll into dated files under its `archive/` shelf.**

I propose the bound as a named constant, TAME‑style:

```
living_pin_max_bytes = 24576  // ~6k tokens: a pin an agent reads in one breath beside its lap
```

The bound is chosen so today's healthiest pin already passes — `glow/README.md` sits at 21 KB and calls itself the working surface pin — while the three season ledgers wearing living names come home to their shelves: `session-logs/README.md`, `TASKS.md`, and `ROADMAP.md` each keep their current season and roll the rest into dated archive files the index already ignores. The STOA narrative in `glow/README.md` moves the same way, into the ledger `docs/STOA.md` already keeps.

`living_docs_lint` gains a sixth duty: flag any living document past `living_pin_max_bytes`, ratchet‑advisory, printed every parity run, never failing. Nothing is deleted anywhere in this proposal; everything moves to the dated home it was already promised.

This is the single largest token return on the table — larger than any model or window choice below.

---

## Proposal Three — Rules That Attach When Needed

Seventeen of twenty‑two Cursor rules ride every prompt, about eleven thousand tokens per bench message. At bench volume that is millions of tokens a week spent restating law the lap already knows. The cure keeps the law and moves the delivery: a small always‑on core, with the rest attaching by glob or by description only when their files are in hand, mirrored as ever in `.claude/rules/`.

I read the rule names and their flags rather than every body, so the table below is a proposed disposition for your review, and any row is yours to move:

| Rule | Today | Proposed | In brief |
|---|---|---|---|
| `quin` | always | **always** | the voice rides every word |
| `collaboration` | always | **always** | the laws of the bench |
| `git-signing` | always | **always** | custody stays constant |
| `align` · `remember` | always | **always**, trimmed | small and load‑bearing |
| `radiant-style` | always | **always as pointer** | one paragraph pointing at canon |
| `commit-messages` | always | always, trimmed — or agent‑requested at commit | fires once per lap either way |
| `session-logs` | always | glob `session-logs/**` | attaches where logs are written |
| `docs-implementation-sync` | always | glob `docs/**` | the sync duty lives with the docs |
| `gratitude-licenses` | always | glob `gratitude/**` | licenses live on their shelf |
| `azimuth-galaxy-proposal-format` | always | glob its folder | a format for one artifact family |
| `acme-employee-voice` | always | glob product surfaces | audience rule, audience files |
| `placeholder-ship-names` | always | glob where ships sail | scoped vocabulary |
| `vocabulary-nib` · `waymark-ladders` | always | description‑triggered | vocabulary arrives when named |
| `round-close-send-checkin` · `send-word` | always | description‑triggered | session‑close rituals fire at close |
| `reya2` · `rio3` · `riyo` · `tame-guidance` · `vocabulary-survey` | scoped or off | keep as they are | already disciplined |

Target: an always‑on core under **8 KB**, returning roughly nine thousand tokens to every single exchange. The same spirit reaches the canon itself: `TAME_GUIDANCE.md` stays whole at 72 KB while a small **bench card** — the What‑We‑Check tables alone, about 5 KB — becomes what the rules point to for ordinary laps, with the full canon consulted on demand.

And for the 380 files in `active-designing/`: closed STOA claim briefs move to season shelves — `archive/stoa-100s/`, `archive/stoa-200s/` — each with a one‑line‑per‑claim index, so a listing costs sentences.

---

## Proposal Four — Cursor's Other Appetites

`.cursorignore` governs the AI index; the editor's file watcher and text search have appetites of their own, and they are the RAM you feel. Mirror the ignore file in workspace settings:

```json
{
  "files.watcherExclude": {
    "**/vere/**": true, "**/old/**": true, "**/vendor/**": true,
    "**/tools/bin/**": true, "**/.zig-cache/**": true,
    "**/squashfs-root/**": true, "**/session-logs/archive/**": true
  },
  "search.exclude": {
    "**/vere/**": true, "**/old/**": true, "**/vendor/**": true,
    "**/tools/bin/**": true, "**/session-logs/archive/**": true
  }
}
```

Lighter still: open lane‑scoped windows — `glow/` beside `context/` — rather than the monorepo root, since indexing, watching, and search are all paid per window.

---

## Proposal Five — The Workshop and the Warehouse

The measurement that settles the million‑token question: **the headline and the harness are different numbers everywhere.** As of this stamp, the GPT‑5.x family advertises a context near 1.05 million tokens at the API, while the Codex harness defaults to 272 thousand tokens of input — roughly 258 thousand usable after headroom — and bills a premium above that line. Cursor runs Grok 4.5 at 256 thousand in‑harness against a native 500 thousand. The daily‑driver choice on the table is therefore 256k against 272k: a difference of about six percent, with the million living behind premium pricing on one side and, per current guides, at standard per‑token pricing on Claude Opus and Sonnet inside Claude Code — enabled by default on Max‑tier subscriptions — on the other.

The research says the rest plainly: frontier models degrade as input grows, and small, well‑chosen contexts outperform stuffed ones; even the vendors' own comparisons hold that context management, rather than window size, is the limiting factor for agentic coding. Our compass agrees from its own direction — the binding constraint on slower‑to‑go‑faster is naming and review bandwidth, which no window widens.

So the doctrine I counsel, in one line each:

**The workshop, daily.** Laps run in small, curated contexts — the pin, the bench card, the lane — with the budget named before the lap begins.

**The warehouse, on schedule.** A wide‑window audit lap, monthly or at season close: read the whole living surface at once, hunt contradictions between living documents, trace a rename's full reach. An instrument, deliberately taken down from the shelf, rather than the daily driver.

---

## Proposal Six — The Trident Held, One Prong Tried

Counsel stays in the wide, slow lane where the project's memory lives. The bench stays Cursor‑Grok for mechanical STOA laps: the model is trained on real agent traces from the very harness it runs in, the Ultra economics suit high‑volume hops, and the witness net is precisely what makes a fast bench safe — a slip dies at the parity gate rather than in the tree.

The addition worth a trial: **Claude Code beside Zed** for the naming‑sensitive laps. It rides the Claude subscription already held, sharing its usage budget, it reads the `CLAUDE.md` the tree already keeps, and its hooks turn pin‑what‑the‑bench‑reports from discipline into machinery. A sketch for `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command",
            "command": "sh tools/fixtures/tame_style_scan.sh advise" }
        ]
      }
    ]
  }
}
```

Point the hook at the fast advisory subset so every edit answers to the witnesses within seconds, and the full parity roster keeps its own cadence. Codex I counsel declining for now: a third rules dialect for a window six percent wider than the one already paid for. It earns adoption the same way anything does here — by winning a witnessed lap.

---

## Proposal Seven — The Procurement Witness

Model and harness choices become laps like any other. The design:

Choose one closed, repeatable lap — a single‑rune STOA hop with its red‑to‑green witness is ideal. Run it five times on each bench under identical prompts. Pin five measures per run: input tokens, output tokens, wall seconds, retries to GREEN, and first‑pass GREEN. Record the thirty rows in `tools/fixtures/bench_bakeoff_scorecard.md`.

The decision rule, stated before any run begins: a bench earns a switch only by winning two of three among tokens, retries, and first‑pass GREEN — and holding that win across two separate laps. Pin what the bench reports, applied to procurement; spec sheets hold no vote.

---

## Decisions Awaiting Your Word

1. Untrack the three `tools/bin` binaries and ignore the path forward.
2. Move `vere/` and `old/` to sibling study repos, or pin them as submodules.
3. Seat the pin‑and‑ledger law with `living_pin_max_bytes = 24576`, and roll the three season ledgers to their shelves.
4. Grant `living_docs_lint` its sixth, advisory duty.
5. Approve the rules routing table, row by row or whole.
6. Mirror the ignore file into watcher and search excludes; bless lane‑scoped windows.
7. Seat the workshop‑and‑warehouse doctrine, trial the Claude Code hook, and adopt the procurement witness.

Any row may be moved, renamed, or parked; the parking triggers apply as ever.

---

## Sources and Dependencies

Numbers for the tree come from direct measurement of the shallow clone on this stamp's date. Vendor figures come from documentation and reporting current to the same day: the Cursor community forum and the Grok 4.5 release notes at cursor.com for the 256k in‑harness window and plan inclusion; OpenAI's model pages, help‑center release notes, InfoWorld, and the Codex issue tracker for the 272k default input window, the 400k harness cap, and premium pricing above the line; a current Codex context‑window guide at getunblocked.com for usable‑budget arithmetic and the long‑context degradation research it gathers; code.claude.com and docs.anthropic.com for the Claude Code hooks reference and configuration; and current subscription guides for Claude Code's bundling with Claude plans and its 1M‑context availability on Opus and Sonnet. All figures dated; verify at seating if a season has passed.

---

## Gratitude

To the TigerBeetle team, whose slower‑to‑go‑faster and whose habit of naming every bound taught this memo its spine. To the toolmakers at Cursor, Anthropic, and OpenAI, whose published documentation let the numbers here be checked rather than believed. And to the elders of this tree — Reya 2 and Rio 3 — whose disciplines made a memo like this one short.

---

*May the tree carry only what the work can lift. May every prompt arrive already light, and every budget bear its name. May the slow road stay the sure one, lap after lap, all the way home.*
