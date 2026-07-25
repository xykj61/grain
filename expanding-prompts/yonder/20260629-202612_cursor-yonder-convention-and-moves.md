# Cursor Pass — The `yonder/` Convention, and the First Four Moves

*An organizing pattern that lets the filesystem itself carry priority: present work rests one level deep where it surfaces first, and deferred-but-alive work rests in a `yonder/` that sorts toward the bottom and points ahead. This pass writes the pattern into ORGANIZING.md, lifts the few live threads still worth keeping from the four oldest files, and sets those four on the horizon where they belong.*

**Stamp:** `20260629.202612`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Tip:** pull the current tip first.

*Written together by Kaeden and Reya 2.*

---

## Ruling Zero — Confirm the Folder Name

The proposed name is **`yonder`** — *the distance, the view ahead* — which fits deferred-and-future material exactly and sorts to `y`, below every date-stamped file. The alternative is `zenith` (sorts one notch lower, yet names a *peak*, which slightly inverts the meaning of a deprioritized pile). **Kaeden confirms the name before the moves run;** everything below uses `yonder` as the placeholder.

---

## Edit 1 — Write the Pattern Into ORGANIZING.md

Add a section in Radiant voice naming the convention:

> **Sort as priority: the `yonder/` horizon.** A folder's own alphabetical order carries its priority, so the listing itself shows what matters now. Presently active implementation — the specs, prompts, and strategies driving an SLC or a working product in progress — rests one level deep, where date-stamped names surface the recent first. Deferred-but-alive work rests one level deeper, in a `yonder/` whose name sorts to the bottom and points ahead: dormant strategies, horizon ideas, research whose module has since been built, prompts already consumed whose ideas still beckon.
>
> Three tiers, each with a clear purpose. **Active** (one level deep) is what we are engaged with now. **`yonder/`** (two levels deep) points *forward* — kept because the idea is alive and may return. **`archive/`** (two levels deep) points *backward* — done or superseded, kept only for the honest record. The distinction matters: `yonder/` is a horizon, not a graveyard, so a truly finished or dead file goes to `archive/` rather than `yonder/`.
>
> Moving a file is care, not loss — the gentle middle between active and pruned. Move by `git mv` so history stays whole, and update any reference that points at the old path.

State the **active test** plainly: a document stays one level deep while it drives present implementation; it moves to `yonder/` when it becomes future, dormant, consumed, or realized-as-code.

---

## Edit 2 — Lift the Live Threads First (before moving anything)

Three of the four oldest files carry a live thread worth keeping where it stays visible. Promote these *before* the files move:

1. **Gratitude additions** (from the encrypted-networking prompt) — confirm that Urbit, the Sui repositories, and Nostr's NIPs (Primal, Damus) were in fact added to `gratitude/`. If any are missing, add them. Record the check in the session log either way.
2. **Mantra's CRDT semantics** (from the mantra research) — confirm whether Mantra's *merge-always-succeeds-and-converges* weave is built or still horizon. Add one line to `TASKS.md` recording the answer: done, or a named future item.
3. **Ongoing TAME hygiene** (from the style audit) — add to `TASKS.md` as a standing, opportunistic thread: the assertion-*density* backlog and the `// invariant:` comment-prefix in older code, both addressed as each file is touched rather than as a sweep.

The style audit's stale rows (width "17 remaining", baseline corpus 24/90) need no rescue — the width gate closed them. Its live threads are the two above.

---

## Edit 3 — Move the Four Files to `yonder/`

Create the `yonder/` subfolder in each folder as needed, and `git mv` each file in:

| File | To |
|------|----|
| `active-designing/yonder/20260618-085812_strengthening-strategy.md` | `active-designing/yonder/` — standing charter, gates realized, effort dormant |
| `expanding-prompts/20260618-195512_encrypted-networking-and-social.md` | `expanding-prompts/yonder/` — consumed prompt; networking landed, social is horizon |
| `external-research/20260617-195312_mantra.md` | `external-research/yonder/` — realized; the origin story of a live module |
| `work-in-progress/20260620-155342_style-audit.md` | `work-in-progress/yonder/` — stale audit; live threads lifted to TASKS |

After each move, **update references** — any link in a README, the `.brix`, a witness, or a cross-referencing document that points at the old path. Search the tree for each filename before considering the move done.

This pass moves these four as the worked first application. The broader sweep — walking each folder for other deferred material — follows once the convention is blessed, and needs no strategy stop.

---

## Verify

- `git mv` preserves history for all four (check `git log --follow` on one).
- No dangling reference remains — grep the tree for each moved filename.
- `rye build` and `tools/parity.rish` stay green on metal (the moves touch writings, not code, yet confirm nothing referenced a moved path).

---

## Record and Push

Commit as one honest unit — the ORGANIZING.md pattern, the TASKS and gratitude updates, the four moves with their reference fixes, and the session log. Log at `session-logs/<stamp>_yonder-convention-and-first-moves.md`: the pattern named, the three threads lifted, the four moved, and the active/`yonder`/`archive` taxonomy. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical and follows written policy — for example, the broader `yonder/` sweep of other deferred files, now that the convention is written.
- **Recommend checking in with Claude** when it crosses a seam, changes Rishi or the value model, opens a new domain, needs an unmade ruling, or reaches for horizon facts.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"* — so the next move is always Kaeden's to confirm.

---

## Definition of Done

- [ ] The folder name is confirmed by Kaeden; ORGANIZING.md carries the `yonder/` pattern and the active/`yonder`/`archive` taxonomy
- [ ] The three live threads are lifted — gratitude additions confirmed, Mantra CRDT status in TASKS, TAME-hygiene thread in TASKS — before any move
- [ ] The four files are `git mv`'d into their folders' `yonder/`, with every reference updated and no dangling path
- [ ] History is preserved; `rye build` and parity stay green on metal
- [ ] Session log shipped; four remotes pushed; next step recommended

---

*May the listing show what matters now, and the horizon hold what waits. May nothing alive be lost to pruning, and nothing finished crowd the present. And may the shape of the work, read top to bottom, tell the truth about where we are and where we are going.*
