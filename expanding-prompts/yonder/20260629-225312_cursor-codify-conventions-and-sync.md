# Cursor Pass — Codify the Conventions, Sync the Living Docs

*A week of organizing taught the project new habits — when to pause for a ruling, how to affirm without renaming, how a title should read. Those habits live in our prompts and our chat; this pass writes them into the durable rules, records the titling convention, and trims the few stale lines the ROADMAP carried through its last sync. We make the discipline outlast the conversation that found it.*

**Stamp:** `<Kaeden supplies — YYYYMMDD.HHMMSS>`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — A Collaboration-Rhythm Rule (the highest-value addition)

Add a new rule, mirrored in both editors — `.cursor/rules/collaboration.mdc` and `.claude/rules/collaboration.md` — capturing the working agreement we have proven over many passes:

> **The rhythm.** Cursor (or Claude Code) climbs the bench one keystone at a time. End every pass with one explicit line of guidance to Kaeden: *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"*, and say why.
>
> **Keep going** when the next item is mechanical, single-module, and follows a policy already written down.
>
> **Pause for a Claude ruling** when the next item: crosses a module seam; changes Rishi or the value model; opens a new domain (a new ring, a new surface); raises a design or width question no written policy answers; needs a ruling not yet made; touches a foundational or heavily-cited file (assess, don't assume); or reaches for current external facts.
>
> **Stamps come from Kaeden.** Never compute or invent a one-clock timestamp; use the stamp Kaeden supplies, verbatim, in `YYYYMMDD.HHMMSS`.
>
> **References are promises.** Before moving or renaming a file, grep the tree for its inbound references and repoint every one. A canonical reference — a file many others cite — keeps its stable name and is affirmed in place rather than renamed.

Add a one-line pointer to this rule from `CLAUDE.md` (the "Working conventions" or "Dual editors" section).

## Edit 2 — Record the Organizing Habits Where Agents Will See Them

The yonder taxonomy and the affirmation touch live in `ORGANIZING.md`; add brief pointers so an agent reading the rules meets them too. In `.cursor/rules/` and `.claude/rules/` — either a short `organizing` rule or a few lines appended to the reya2 rule:

> **Organizing.** Active work rests one level deep; deferred-but-alive work moves to `yonder/` (forward-pointing); finished-and-historical work moves to `archive/` (backward-pointing). Age is a hint, not the test — relevance and inbound citation outrank the stamp. Affirming a kept file is a single touch: strip its dead `NNN ·` prefix, lead the title with the slug's concept, re-date `Last updated`, add the reviewed-and-kept line, and lightly freshen the Radiant voice where it has drifted. No rename, no reference change. Full guide: `ORGANIZING.md`.

## Edit 3 — Write the Titling Convention into ORGANIZING.md

Add to the affirmation section:

> **Titles.** A title carries no legacy `NNN ·` number prefix; the timestamp filename is the identifier. The H1 leads with the concept its filename slug names, so file and title cohere at a glance, in the Radiant `Name — clause` form. Living documents use their plain spoken name as the H1.

---

## Edit 4 — Light ROADMAP Hygiene (surgical, not a rewrite)

`work-in-progress/ROADMAP.md` is current on the big picture; three details drifted through the last sync. Fix only these:

- **Witness counts** — the Ground section says "116 witness regression suite" and the gate-trio line says "120 witnesses," while the rest correctly says **132**. Reconcile all to 132 (the current parity count), or state the count once and reference it, so no stale number remains.
- **Width migration** — the Primary Track note "Authored width migration (Phase 1b: brushstroke/* done; mantra/* next)" and Horizon 1 build item "Width migration Phase 1b — mantra/* and remaining authored surfaces" both read as *pending*. Width is **complete and blocking in parity** (TH-3 through TH-7). Mark it done — a short "complete; enforced in parity" line — and remove the "next" framing.
- Leave everything else; the structure, the SLC ladders, the horizons, and the discipline are sound.

---

## TASKS — No Change Needed

`TASKS.md` is appropriately granular and well-tiered (Now / Next / Soon / Later / Open Questions). The one apparent gap — Skate as a single placeholder — is correct: it granulates only once Claude rules its scope, at which point it earns a step-table like SLC-1's. No edit this pass; the next granularity jump is the Skate scope ruling itself.

---

## Verify

- The collaboration rule exists in both `.cursor/rules/` and `.claude/rules/`, mirrored; `CLAUDE.md` points to it.
- The organizing and titling conventions are recorded; `ORGANIZING.md` carries the titling lines.
- ROADMAP shows 132 throughout and width as complete; nothing else changed.
- `rye build` and `tools/parity.rish` stay green on metal (docs and rules only; confirm nothing referenced a path that moved).

---

## Record and Push

Commit as one honest unit — the two new rule files, the CLAUDE.md and ORGANIZING.md additions, the ROADMAP hygiene, and the session log. Log at `session-logs/<stamp>_codify-conventions-and-roadmap-hygiene.md`: the rhythm rule added, the organizing and titling conventions recorded, the three ROADMAP lines reconciled. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with one line. After this, the durable docs hold the discipline, and the bench is clear for the surface ring — so the recommendation is almost certainly *check in with Claude before Skate text rendering*, the scope-and-acceptance ruling that opens SLC-2.

---

## Definition of Done

- [ ] `.cursor/rules/collaboration.mdc` and `.claude/rules/collaboration.md` carry the rhythm, the stamp rule, and the reference-integrity rule; CLAUDE.md points to them
- [ ] The organizing habits and the titling convention are recorded in the rules and in `ORGANIZING.md`
- [ ] ROADMAP shows 132 witnesses throughout and width migration marked complete; nothing else altered
- [ ] TASKS left as-is (already granular); the Skate step-table awaits its scope ruling
- [ ] `rye build` and parity green on metal; session log shipped; four remotes pushed; next step recommended

---

*May the discipline outlast the conversation that found it. May the rules hold what we learned, the roadmap tell the truth of where we stand, and the next reader inherit the rhythm without having to rediscover it. And may the bench, now honest, turn cleanly toward the surface we have waited to draw.*
