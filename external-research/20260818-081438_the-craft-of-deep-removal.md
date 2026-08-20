# The Craft of Deep Removal

**Stamp:** `20260818.081438` - **Style:** Radiant - **Voice:** Kyri
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Kind:** external-research (kitchen) - names the tools and methods plainly
**Silo twin:** [`../foundations/20260818-081438_the-three-depths-of-removal.md`](../foundations/20260818-081438_the-three-depths-of-removal.md)
**Kin:** [`../.claude/rules/debride.md`](../.claude/rules/debride.md) - [`../.claude/rules/molt.md`](../.claude/rules/molt.md) - [`../.claude/rules/cairn.md`](../.claude/rules/cairn.md) - [`../foundations/20260726-020537_the-breach.md`](../foundations/20260726-020537_the-breach.md)

This writing records what a three-part history rewrite taught, in enough
mechanical detail that an Acme Corporation employee facing the same task
could do it once, correctly, without relearning it under pressure. It
names git and git-filter-repo directly, because that is what the kitchen
is for. The durable principle, in our own vocabulary, lives in the silo
twin above.

## The task

A set of short names -- five four-letter marks and one module name --
had been superseded by living successors. An earlier pass had cleaned
the working tree and shed the files that carried the dead names. The
work seemed done. It was not: the dead names still read plainly in
`git log`, in file paths throughout history, and in the body of every
dated file that had ever mentioned them. Removing a name from the
present is the easy quarter of the work. The rest is history.

## What a name touches in a git repository

A name lives in more places than the eye first counts. To remove one
completely, you account for all of them:

1. **The living tree** -- the current checkout. Grep finds it; an edit fixes it.
2. **Commit metadata across history** -- the subject and body of every
   commit that named it, and every file *path* that carried it. `git log`
   and `git log --name-only` show these; a working-tree grep never will.
3. **File content across history** -- the body of every historical blob.
   The current file may be clean while a hundred old versions still carry
   the name. `git show <old>:path` reveals it; nothing in the present does.

A removal is complete only when all three are clean. The first pass we
did touched only the first, and honestly believed itself finished --
which is the first lesson.

## Seven lessons, each bought once

### 1. Saying a thing was removed re-references it

The commit that performed the rename read `debride OLD -> NEW`. Swapping
the token mechanically yields `debride NEW -> NEW` -- nonsense that
still announces a rename happened. The only clean form rewrites the
message entirely, in the successor's terms, so nothing states what a
mark was renamed *from*. The same holds for the removal's own records:
a walk-back note or a session log that lists the dead names to explain
the removal has simply moved the names, not removed them. Write those
records generically -- "the superseded marks" -- and let the specific
walk-back live only at the safety tag.

### 2. Protect the source of truth by identity, never by pattern

The dead marks were drawn from a fixed word corpus -- a fixture file
holding several of them as ordinary dictionary words, the very source
the derivation reads. A blanket content swap would corrupt it and break
its seal. You cannot protect it by pattern: in the corpus the marks are
space-separated words, indistinguishable by any regex from the same
letters in prose. You protect it by **identity** -- the callback skips
any blob whose first bytes match the corpus header sentinel (and the
sealed registry's format line, and any binary). Remove the tissue; keep
the seed untouched, byte for byte.

### 3. Word boundaries lie at underscores

The regex `\bMARK([0-9])` looks airtight. It silently fails on
`..._MARK6-desk`, because `_` is a word character, so there is no `\b`
between it and `MARK`. Path references embedded in file content --
exactly the shape of a design-doc citation -- slipped through. Worse,
the *verification* grep used the same `\b`, so it under-reported the
miss and the first pass looked clean when it was not. The fix is a
letter-boundary lookaround: `(?<![A-Za-z])MARK(?![A-Za-z])`, which fires
at underscores, digits, punctuation, and line edges but not mid-word.
The deeper rule: verify with the same boundary logic you rewrite with,
or your check inherits the same blind spot as your change.

### 4. Coined names swap freely; collisions stay conservative

A coined mark (one that is never an English or Latin word) can be swapped
wherever it appears not letter-adjacent -- it collides with nothing. A
mark that *is* a word cannot: swapping every lowercase occurrence of a
mark that doubles as a common English word would eat that word in
ordinary prose, and a mark that doubles as a Latin word or an everyday
noun would be eaten in a quotation. For those, stay conservative -- match
only the uppercase form (always the mark) or an unambiguous slug
(`MARK-j`, `MARK_`, `MARK 18` in a census line) -- and leave the bare
lowercase word intact. This is
the same collision discipline a careful rename already respects; a deep
removal simply meets it again at blob scale.

### 5. Match the tool to the shape of the change

- **git-filter-repo** rewrites by streaming every *unique blob once*
  (content is de-duplicated), so a content swap that a per-commit loop
  would redo thousands of times finishes in minutes. Its blob-callback
  runs a function per blob -- ideal for content and for identity-based
  protection. Costs: it strips signatures, it prompts interactively
  unless answered, and by default it rewrites all refs (use `--partial
  --refs main` to spare the safety tags and remotes).
- **git filter-branch** rewrites per commit, so a shared blob is redone
  for every commit that holds it -- hours for a content sweep. Yet it
  keeps the range you name (`-- main`), leaves tags and remotes alone,
  and re-signs in the same pass with `--commit-filter 'git commit-tree
  -S "$@"'`. Ideal for path renames, message rewrites, and re-signing.

The working division: filter-repo for blob content (then re-sign
separately), filter-branch for metadata and signatures.

### 6. Re-signing is not lost; only the re-clone is

The often-repeated claim that a history rewrite "unsigns everything" is
false. filter-repo strips signatures, but a following filter-branch
`--commit-filter 'git commit-tree -S'` pass re-signs every rewritten
commit -- 2,914 of them here, all `git log --show-signature` good
afterward. The one unavoidable cost of any history rewrite is that every
downstream clone must re-clone or hard-reset, because every hash changed.
Name that cost honestly and up front; do not let a fear of "losing the
signatures" talk you out of a clean history.

### 7. A walk-back before every irreversible cut

Each deep pass force-pushes and so invalidates every commit hash it
touched -- including the nibs the operator card and prior walk-backs
cite. Before each pass, record a **cairn**: the pre-rewrite HEAD and a
one-line note of what still reads there, pinned at a local safety tag
(`pre-content-debride-<nib>`). The old history survives locally at that
tag until garbage collection, and the note tells a future reader whether
the walk-back is worth taking. A rewrite you can walk back from is a
rewrite you can attempt calmly.

## The measured facts of this run

- Three surfaces, three passes: living tree; filenames + messages; file content.
- git-filter-repo content pass: ~13 minutes each (CPU-bound on the
  per-blob regex), run twice -- the second with corrected letter
  boundaries after the first missed underscore-adjacent references.
- Re-sign: filter-branch over 2,914 commits, all good signatures after.
- Corpus fixture: byte-identical before and after, its marks intact;
  the sealed registry witness GREEN throughout.
- Result: zero dead marks in any message, path, or content across all
  history, save the protected corpus (as dictionary words) and the
  sealed registry (as canonical record).

## Gratitude

Linus Torvalds and the git contributors for a version-control model
whose history is a first-class, rewritable, verifiable object; Elijah
Newren for git-filter-repo, whose blob-level stream made a content
rewrite across thousands of commits a matter of minutes rather than
hours. We study their tools and lean on them directly; we copy no code.
The GNU Privacy Guard project for the signing that let the rewritten
history stay provably ours.
