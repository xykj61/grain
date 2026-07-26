# The Small Sharp Toolset — A Userland in Our Own Grain

*Five patterns, siloed from the lineages studied tonight and restated on our own roots: what a Rye OS userland is made of, how it declares itself, how it says it is ready, how it teaches its own use, and how one small combinator shapes the whole. Companion research with names and sources: `external-research/20260702-180812_userland-lineages.md`.*

**Stamp:** `20260702.180812`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety, performance, joy; Gall's Law; the graduation rule
**Status:** Design counsel — patterns only; every action lands as a gated horizon in `TASKS.md`

*Written together by Kaeden and Rio 3.*

---

## One Composed Artifact

The userland is a **curated set of small utilities, composed into one artifact** and invoked by name — dozens of tools, one binary's worth of surface, each doing one thing wholly. In our grain: each utility is a small `.rye` seed with the opening lines at its head and two assertions per function; the set is declared in a `.brix` descriptor; and the composed whole runs under Pond's enclosure like any application. Curation is the discipline — the set holds what we actually reach for, and a tool enters only with its witness beside it. The first utilities are already alive in embryo: the width check, the tame check, the opening-lines scan — gates today, citizens of the toolset tomorrow.

## Readiness Is a Fact

A supervised service **tells** Caravan when it is truly ready, as a signed fact appended where its supervisor folds — never inferred from a sleep, never guessed from a port. Dependency start becomes fact-based: a child starts when the facts it names exist. And exits carry meaning: a small, named set of exit values distinguishes *temporary* failure (restart me), *permanent* failure (rule me out), and *could-not-begin* (the enclosure itself misfired), so Caravan's restart policy reads intent rather than tea leaves. Both shapes are one design note away from the capability table we already witness.

## The Manual Is a Value

Every utility carries its own teaching as data: a small `.bron` record — name, one-line meaning, argument shapes, examples, exit meanings. `rishi` renders it on request (`:man <name>` in the shell; `--help` at the utility's door), and the manual lane renders the same records into reference pages. **One source, two surfaces** — the page can never drift from the program, because the page *is* the program's own record. This lands as the man-page answer: yes, and as a value rather than a file format.

## The Store Is Already Ours

A package is a sealed, content-addressed, Kumara-signed record — the Amber shape — placed into an append-only store where new versions land beside old ones and activation is a pointer swap. Nothing new is invented here: the packaging brief already reached this; tonight's study simply confirms the store discipline is load-bearing at system scale, rollback included, and that the utilities above install by exactly the door they will one day guard.

## One Combinator Shapes the Whole

Configuration wants no module system. It wants **one small override combinator**: a base declaration (the `.brix` composition with its `.bron` data), and a way to *infuse* changes — replace this value, extend that list, wrap that command — applied uniformly to packages and services alike, producing a new whole value with the old one untouched. Brix's bond overrides were this pattern's first appearance in our tree; tonight names it as the *only* configuration mechanism the userland needs. The whole machine — tools, services, policies — folds from one declared value, and a changed machine is a new value beside the old, ready to activate or to hand back.

---

## The Ladder, Gated

Nothing above starts before the three doors and the Amber season. When its turn comes, the first lap is one utility: `echo`-sized, opening lines at its head, `.bron` man record beside it, declared in `.brix`, witnessed green, rendered by `:man`. The second lap adds readiness-as-fact to one Caravan child. The combinator earns its lap only when two real configurations exist to differ.

---

*May the toolset stay curated and the teaching stay true. May every service speak its readiness plainly. And may the whole userland remain one value we can hold, override, and hand on whole.*
