# The field's remotes -- public, seed, and private

**Stamp:** `20261017.184544` (one clock, America/New_York)
**Status:** Living -- a record of what each remote is, and what DJINN collaboration needs
**Room:** checkable for the remote facts (GitHub visibility, the tips named below); the collaboration
options are design, and stay proposals until Keaton's word.
**Visibility of this page:** private repo only. It is not pushed to `xy`, which is public.

## The four remotes

| Remote | Repo | Visibility | What it holds | Tip at writing |
|---|---|---|---|---|
| `xy` | `xykj61/grain` | public | the living field, full history | `e3218a2fd8` |
| `ww-private` | `grain-ww/20260618-grain-private` | private | the same field, full history | `e3218a2fd8` |
| seed door | `grain-ww/grain` | public | a projection: one unsigned anonymous root commit, the depersonalized seed | `d00204acc` |
| `grain-ww/20260618-grain` | public | a dated public seed, not a projection of this field | not checked this round |

The seed door is not a remote of this tree. `seed/` is a gitignored repo that `publish-seed.sh` builds,
so its history never joins the field's.

## Are `xy` and `ww-private` the same thing?

**The same content, different visibility.** At writing both tips are `e3218a2fd8`, so every byte of
history is identical. They differ only in who can read them.

They will diverge the moment one repo takes a push the other does not. Keep them honest by pushing
the same commits to both, or by deciding one of them is the record and the other a mirror.

**What is already public stays public.** Everything that reached `xy` before the private copy existed
can be cloned, forked, or cached by anyone, and a private repo cannot recall it. Making
`ww-private` private protects future pushes, not past ones.

## What DJINN collaboration needs

A collaborator who should see the field but not the public should be added to `ww-private` as a
GitHub collaborator, and must never be given the seed door or be asked to push to `xy`. Until the
DJINN-confidential material is named, nothing can be routed by subject: a page is private only if it
lives where a private push sends it.

**Open question for Keaton:** name the files or subjects DJINN should see that are not yet on `xy`,
and the ones that are already on `xy` and should not be. Without that list, this page cannot say what
to move.

## Molt, breach, and deep debride -- options

These are proposals, each with its own word. None has run.

1. **Route, do not rewrite (recommended first).** Keep `xy` as the public field and treat
   `ww-private` as the place for DJINN work. New private material is committed only to the private
   remote. Cost: nothing is undone; the public history stays as it is.
2. **Breach the confidential paths going forward.** Under the breach doctrine
   (`foundations/20260726-020537_the-breach.md`), move a named set of living files to a private-only
   path and stop publishing that path, keeping every elder byte. The elder files on `xy` remain.
   Cost: the public history still shows them.
3. **Molt the living pages that name DJINN material.** A dated page that DJINN should not see is
   molted into a private mutant, leaving a fossil on `xy`. Under `rules/molt.md` the fossil is
   prepared, not cut.
4. **Deep debride of `xy` history.** Only path that removes material from the public record: rewrite
   history with `git filter-repo` and force-push `xy`. Requirements from `rules/debride.md` and
   `rules/checkpoint.md`: a named target and Keaton's explicit word; a checkpoint row recorded before
   the rewrite; every clone and every commit hash in the ledger (REDS and the session logs) breaks.
   Recommendation: do not do this for collaboration convenience. Do it only for material that is
   genuinely harmful if public, and only after option 1 and 2 are in place.

## Recommendation

Route new DJINN work to `ww-private` now (option 1). Breach the named confidential paths going forward
(option 2) once the list exists. Hold option 4 for a named harm, not for collaboration.

## Not decided here

Whether `ww-private` becomes the record and `xy` a mirror. That is a choice about custody, and it
waits on Keaton.
