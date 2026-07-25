# Cursor Composer 2.5 Prompt — Reorg Chunk 1: Open the Branch, Take the Easy Win

**Paste this into a fresh Cursor Composer 2.5 agent.** It carries one safe, complete chunk of the one-clock reorganization. Read it fully before running anything. Check before you change. Push the branch over SSH only once the work is committed and Kaeden gives the word.

---

## Environment — set this first, every run

```bash
export HOME=/home/xy
cd /home/xy/veganreyklah2
```

Two truths about this sandbox, true throughout:

- Only `/home/xy/veganreyklah2` persists across resets. Keep every change inside it — which is exactly where the reorganization belongs.
- The jail reaches the forges over SSH. The `.ssh` keys and config live inside the project directory, so commits, fetches, and pushes all work from here. `HOME=/home/xy` is the jail's own default; we set it explicitly only to start from a known shell.

Confirm a clean starting point and report — change nothing yet:

```bash
git status
git branch --show-current
git rev-parse HEAD
git rev-list --all --count
```

---

## Step 0 — Verify the freeze (a hard gate; change nothing until cleared)

Run inside the jail and report:

```bash
git rev-parse HEAD            # expect fec0f95…
git rev-list --all --count    # expect 259
ls -la ~/archives/veganreyklah2-20260627-191712.bundle 2>/dev/null \
  && git bundle verify ~/archives/veganreyklah2-20260627-191712.bundle \
  || echo "Bundle absent in this sandbox (expected if the sandbox reset). The GitHub archive is the authoritative seal."
```

Then check the remote seal over SSH and report. Both GitHub refs should read `fec0f95…`:

```bash
git ls-remote git@github.com:veganreyklah2/veganreyklah2-20260627-191712.git refs/heads/main
git ls-remote git@github.com:veganreyklah2/veganreyklah2.git refs/heads/main
```

Codeberg's deferred push waits on their outage, so `origin` may lag or be unreachable; the GitHub refs above are the authoritative seal for now.

**Proceed only when** HEAD reads `fec0f95…`, the count reads `259`, and both GitHub refs match. If any check falls short, stop and tell Kaeden before going on.

---

## Step 1 — Open the reorg branch

Check first, then act:

```bash
git branch --list reorg/one-clock
```

If it is absent and the tree is clean on `main`:

```bash
git switch -c reorg/one-clock
```

If it already exists, `git switch reorg/one-clock` and confirm it sits on the verified tip (`git rev-parse HEAD` reads `fec0f95…`).

---

## Step 2 — Promote the naming-law memo to an adopted spec

Target path: `context/specs/20260627-102012_one-clock-naming-law.md`.

Check first:

```bash
ls context/specs/20260627-102012_one-clock-naming-law.md 2>/dev/null
```

- **If it already lives there:** open it and ensure the status line reads `Adopted`. If it reads an earlier value (Proposed/Draft), change only that one field. Print the before/after of the status line.
- **If it is absent:** search the tracked tree for the source memo with `git grep`, which reads only tracked files and stays clear of anything untracked or vendored:

```bash
git grep -l "One Clock" -- '*.md'
git grep -l "20260627-102012" -- '*.md'
```

  If found elsewhere in the tree, move it into place with history preserved and set the status to `Adopted`:

```bash
git mv "<found-path>" context/specs/20260627-102012_one-clock-naming-law.md
```

  If no source exists in the tree, **pause and ask Kaeden to hand you the memo text**, then create the file at the target path with status `Adopted`.

---

## Step 3 — Session logs: drop the countdown prefix (the easy win)

List the folder and infer the pattern:

```bash
ls -1 session-logs/
```

Each filename carries a countdown prefix ahead of its real stamp, shaped like `<countdown>_<YYYYMMDD-HHMMSS>_<slug>.md`. Dropping the leading `<countdown>_` leaves `<YYYYMMDD-HHMMSS>_<slug>.md`, which sorts honestly by time alone.

**Print the full proposed old→new mapping, one line per file, for Kaeden to scan.** If every filename matches the expected shape, apply with history-preserving renames:

```bash
git mv "<old>" "<new>"
```

If any filename departs from the shape, stop on that one and ask Kaeden before touching it.

---

## Step 4 — Build `session-logs/README.md` as a living index

Create or rewrite `session-logs/README.md` as a **living document** — no stamp in its own name. Give it a short Radiant header, then a **reverse-chronological table, newest first**, one row per log: stamp, title, and one line of meaning drawn from each file's header. Read each log's top matter to fill the row honestly. Keep the prose affirmative and the table clean.

---

## Step 5 — Confirm the allow-list still welcomes the folder

```bash
git check-ignore session-logs/README.md || echo "tracked — good"
git status
```

`.gitignore` follows an allow-list design: it ignores everything at root, then welcomes each project directory back by name. `session-logs/` should already be welcomed. If anything new sits ignored, add it back by name in `.gitignore`.

---

## Step 6 — Commit the work (in the jail, Radiant voice)

Stage and commit in Radiant voice — affirmative framing, active voice. A single coherent commit is fine for this chunk, or split if it reads cleaner. Hold the push until the session log in Step 7 is written, so one push carries the whole chunk.

Suggested message body:

> *Open reorg/one-clock and let one clock name the order. Promote the naming-law memo to an adopted spec, drop the countdown prefixes from the session logs so the sort reads true, and give the folder a living index.*

---

## Step 7 — Write a stamped session log of this work

Add `session-logs/<STAMP>_reorg-chunk-1-one-clock.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form. Write it in Radiant voice: what this chunk settled, what waits next (the first design folder, fully and alone), and a three-clause benediction to close. Add its row to the README index, then commit it with the rest.

With the whole chunk committed, push the branch over SSH once Kaeden gives the word:

```bash
git push -u origin reorg/one-clock      # Codeberg, when the outage clears
git push github reorg/one-clock         # GitHub
```

When Codeberg returns green at `status.codeberg.org`, its deferred archive catch-up and this branch both reach it the same way, over SSH. Never force-push.

---

## Hold to these throughout

- **Aparigraha at the file level** — one folder complete before the next, the smallest lovable complete artifact each time.
- **Every rename uses `git mv`** — history and blame carry forward intact.
- **No force-push, ever.** The branch merges to `main` later by ordinary fast-forward.
- **Check before you change.** For anything needing judgment, print the proposed mapping and wait for Kaeden's word before applying.

---

*May the clock keep our order true. May each rename carry its history forward. May this chunk land complete, and leave the next folder waiting on firm ground.*

---

*Written together by Kaeden and Reya 2.*
