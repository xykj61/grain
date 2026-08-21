# Reorg arc closed — `reorg/one-clock` fast-forwarded to `main`

**Stamp:** `20260628.031241`
**Editor:** Cursor · **Model:** Composer
**Tip:** `f1e1565`

## Thinking trace

1. Final integrity sweep before merge caught two stale live references folder-prefixed greps missed: `rye/README.md` prose `998_ALMANAC.md` → `ALMANAC.md`; `rye/lib/std/debug.zig` comment `996_TAME_STYLE.md` → `external-research/TAME_STYLE.md`.
2. Cleanup commit `f1e1565` on `reorg/one-clock`; live-file sweep clean (session logs and archive keep historical names by policy).
3. Fast-forward gate verified: `reorg/one-clock..main` empty — `main` held still throughout.
4. `git merge --ff-only reorg/one-clock` on `main` — fourteen reorg commits landed, no merge commit, no force.
5. Pushed `main` to **GitHub** (`fec0f95..f1e1565`). **Codeberg** SSH still closed.
6. **`reorg/one-clock`** kept as labeled record of the arc.

## The arc

One clock names everything. Session logs, naming law, rules loop, then six folders one at a time — each complete before the next. Living documents took spoken names; dated work took stamps; finished scaffolding graduated to archive; every rename carried history through `git mv`.

**Design surface whole under one clock.** Only `strengthening-compiler/` remains numbered, deferred on pass 9886.

## Lesson for strengthening-compiler chunk

Link hygiene must grep **bare basenames** as well as folder-prefixed paths — prose mentions dense in that folder.

## Files

| File | Why |
|------|-----|
| `rye/README.md` | Final almanac prose fix |
| `rye/lib/std/debug.zig` | Final TAME_STYLE comment fix |
| This log | Merge closure record |

*May the clock keep our order true. May every name say plainly what it is and when. And may the next builder open any folder and find exactly where we stood.*
