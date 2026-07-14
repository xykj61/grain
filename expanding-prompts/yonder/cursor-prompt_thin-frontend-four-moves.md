# Cursor Composer 2.5 Prompt — Thin Frontend: Four Moves

**Paste into a fresh Cursor agent on `main`.** Read fully before running. Propose each move; wait for Kaeden's word before destructive changes. Push only when Kaeden says.

---

## Environment

```bash
export HOME=/home/xy
cd /home/xy/veganreyklah2
git branch --show-current    # expect main
git status                   # report state
```

Only `/home/xy/veganreyklah2` persists. Strengthening **sweep is retired**; pass 9886 does **not** resume as chronicle continuation.

**Adopted direction:** `active-designing/20260628-043542_thin-frontend-slc-direction.md`

---

## Identity (hold throughout)

- **Thin frontend:** pristine symlinked `std`; safety in authored `.rye` at call sites.
- **Strengthening arc completes** — chronicle is record; no new assertions in `std`.
- **Width migration continues** — Phase 1b (`mantra/*` etc.) decoupled from compiler fork; `width-check.rish` stays.
- **First SLC:** Rishi + Mantra hosted shell in terminal. **Second SLC:** Pond GUI.
- **Tradeoff named:** Rye does not ship a safer `std` by construction.

---

## Move 1 — Welcome the teachers into `gratitude/`

Files already on disk:

- `gratitude/HammockDrivenDev.md` (Rich Hickey, Clojure/conj 2010)
- `gratitude/Your customers hate MVPs. Make a SLC instead..html` (Jason Cohen / Longform Smarter Bear)

**Task:** Add entries to `gratitude/README.md` beside Tiger, Hickey, Gall — attribution, what we learn, where it is honored. Note Hammock slide images live in `gratitude/HammockDrivenDev/` if present.

**Also:** Add one-line pointers in `external-research/20260620-014412_system.md` gratitude section if appropriate.

Show diff; commit in Radiant voice on Kaeden's word.

---

## Move 2 — Call-site harvest list (not overlay graduation)

**Purpose:** Name which invariants from the chronicle are worth re-asserting at **seed call sites** when those seeds are next touched — not which files stay in a forked `std`.

**Method:**

1. Scan authored `.rye`/`.rish` under seeds (`rye/tests`, `rishi`, `caravan`, `aurora`, `mantra`, `tally`, `brushstroke`, `tools`, etc.) for `std.*` usage.
2. Crosswalk to `strengthening-compiler/0000_STRENGTHENING_LEXICON.md` surfaces.
3. For each seed-used surface, note: pass doc, whether pass matches real strengthened fn (flag mismatches like `9941`), suggested call-site assertion (one line).
4. Write `work-in-progress/20260628-<STAMP>_call-site-harvest.md` — table: surface | seeds that call it | pass doc | verify? | harvest when touched.

**Do not** modify `rye/lib/std` in this move.

Show the list; wait for Kaeden before any code changes.

---

## Move 3 — Std re-fork (pure subtraction)

**Goal:** `rye/lib/std/` matches pinned `vendor/zig-toolchain/lib/std` for untouched files; only deliberate divergences remain as real files (expect **near-zero** after adoption — any survivor must be justified in the harvest list).

**Propose first:**

```bash
# inventory: diff rye/lib/std vs vendor/zig-toolchain/lib/std
# count files that differ from pristine
```

Plan:

1. Backup inventory of current divergences (list paths + one-line why each existed).
2. Reset to pristine (copy or symlink strategy matching how `rye/lib/` already symlinks `compiler_rt`, `libc`, etc.).
3. Re-apply **only** divergences Kaeden approves from harvest list (likely none in `std` — invariants move to seeds).
4. Run `tools/parity.rish` — expect behavior change; document what gates now mean under pristine `std` (parity may need redefinition; propose, do not silently break).
5. Update `rye/README.md`, `rye-learning-process/ALMANAC.md` to state pristine overlay policy.

**This is the highest-risk move.** Print full plan and diff stats; **no execution until Kaeden confirms.**

---

## Move 4 — TAME supplement migration (honest accretion)

**File:** `context/TAME_STYLE.md` (operational supplement). Mirror a sentence in `external-research/TAME_STYLE.md` voiced canon if needed.

**Rewrite `usize` section** from ban+fork to Tiger alignment:

- Prefer `u32`/`u64`; **avoid** `usize` in authored Rye.
- Assert bound + `@intCast` at inherited-std seam is **correct**, not DEBT awaiting F3.
- `tools/width-check.rish` enforces authored corpus — keep.
- F1–F5 and F3 std rewrite → **deferred horizon** (link `active-designing/20260628-043542_thin-frontend-slc-direction.md`), not "the plan."

**Also update** `work-in-progress/ROADMAP.md` spine:

- Primary track → compose SLC wholes (Rishi/Mantra shell first, Pond GUI second).
- Fork → Horizon 3 deliberation.
- Remove "continue strengthening series" as sweep; keep gates/lint.
- Keep width Phase 1b (`mantra/*`) explicit and decoupled from fork.

Show full diff; commit on Kaeden's word.

---

## Session log

After moves land (or after each approved commit), write `session-logs/<STAMP>_thin-frontend-four-moves.md` and prepend `session-logs/README.md`.

---

## Do not (unless Kaeden explicitly asks)

- Resume strengthening pass 9886 or stamp-rename `strengthening-compiler/`
- Add assertions back into `std` "demand-driven"
- Run std re-fork without approved plan
- Silent-flip supplement without migration framing

---

*May the work read purposeful in every corner. May Rye keep the promise it can keep. And may the first small, lovable, complete thing run on your machine soon.*

---

*Written together by Kaeden and Reya 2.*
