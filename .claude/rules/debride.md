# debride — the sanctioned break of accrete-never-break

**Seated:** `20260809.012200` on Keaton's word · **Status:** Living

When Keaton says **"debride,"** deliberately **break accrete-never-break**: **redact and shred named dead history** — from living docs *and* from session logs, counsel, and dated testimony alike — so the **fascia heals and reattaches**. This is the one word that overrides "keep every byte." From medicine: debridement is the removal of dead, damaged, or foreign tissue so the living tissue can heal — exactly the act here.

## Accrete-sometimes-breach — debride is *mutable on purpose*

Accrete-never-break is the **default**, not an absolute. The tree's fuller law is **accrete-sometimes-breach**: accrete by default, and **breach or debride on Keaton's explicit word**. A **breach** renames or supersedes while keeping the elder in history; a **debride** goes further and removes the dead tissue outright. Both are sanctioned exceptions — the default bends to them, it does not forbid them.

**This means no artifact's immutability can make a debride "self-defeating."** A debride is licensed to remake *anything*, precisely because remaking dead tissue is its whole purpose:

- A **SHA3-sealed** file (e.g. `construction/waymark-registry.bron`): a debride may **remove the dead rows and re-seal** — the seal protects against *accidental* edits, not against a *circled* debride.
- The **REDS ledger** ("rows are never edited or removed") and the **append-only CHECKPOINTS**: a debride may rewrite or drop their dead-tissue rows — that law is the accrete *default*, which the debride word overrides.
- **One-clock dated logs / testimony**: a debride may shed or rewrite them; the one-clock law protects them from *casual* edits, not from a named debride.

The correct reading is never "this is immutable, so we cannot debride it." It is always "this is the default-immutable, so it takes an **explicit circled debride** to remake it — and then the debride **re-seals / re-makes** what it touched." Immutability is a lock, and debride is Keaton's key; the lock is not a reason the key won't turn.

**Re-signing is part of the remake, not a lost cost.** A deep debride *can* re-sign every rewritten commit — proven `20260817` when the urbit-lineage drop re-signed 2,901 commits via `filter-branch --commit-filter 'git commit-tree -S'` (1,774 previously unsigned came out signed). So a history rewrite need not leave the tree unsigned; the honest cost is only the re-clone every downstream must take.

## What debride is, against its neighbors

- **molt** preps a fossil onto the shred-prep list; opens no cut.
- **shred** cuts files that already have a living mutant, keeping the record.
- **debride** is stronger than both: it says *this history is dead tissue — remove it, do not archive it.* It is the deliberate override of the preserve-history default.

## Two depths

1. **Working-tree debride** — remove or redact the named content from the tree and commit. Immediate; gone from the living tree going forward. It remains in git history and on the remotes until a deep debride.
2. **Deep debride** — rewrite the entire git history (`git filter-repo --replace-text` / path removal, or `filter-branch` for a reroot) so the content is stripped from every commit, then **force-push** both remotes. Truly gone. **Cost, named honestly:** a history rewrite changes every hash, so every downstream clone must re-clone or hard-reset — the one unavoidable cost. Re-signing is **not** lost: the rewritten commits *can* be re-signed in the same pass (`filter-branch --commit-filter 'git commit-tree -S'`), proven `20260817` when the urbit-lineage drop re-signed 2,901 commits (see *Accrete-sometimes-breach* above).

## Discipline

- **Leave a checkpoint first.** Before a debride rewrites a living card, record a walk-back **checkpoint** — the git nib and stamp of HEAD before the debride's commit — in `construction/CHECKPOINTS.md`, so the departing card stays one `git show` away. Mandatory before a deep debride, whose walk-back is otherwise lost with the rewrite. Rule: [`checkpoint.md`](checkpoint.md).
- **Named target, explicit word.** debride is destructive by design and runs only on Keaton's word naming *what* to remove. Never a default; never a sweep beyond the named target.
- **Deep debride force-pushes.** After the rewrite, both remotes are force-updated; the living ITINERARY git nib and any git-nib citations are refreshed after.
- **Fascia is the point.** debride raises **fascia health** and **reattaches fascia** — the tree's connective references heal once the dead tissue is gone.

Canonical Cursor twin: `.cursor/rules/debride.mdc`.
