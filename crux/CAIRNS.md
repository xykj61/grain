# Cairns — the walk-back markers before every debride

**Language:** EN
**Status:** Living ledger — append-only
**Voice:** Kyri
**Rule:** [`../.claude/rules/cairn.md`](../.claude/rules/cairn.md) · [`../.cursor/rules/cairn.mdc`](../.cursor/rules/cairn.mdc)
**Kin:** **debride** removes; a **cairn** marks the way back before it does.

---

A **cairn** is a stacked-stone trail marker. In this tree it is one row recorded **before a seated debride sweeps a living card** — the git nib and the live stamp at that moment, plus one honest line naming what stood there. Where **remember** reprints the *current* card, a cairn pins the *departing* one, so a good idea folded into an old REMEMBER, THREADS, or work-in-progress file is never truly lost — it waits at a named commit, one `git show` away.

**How to walk back to a cairn:**

```
git show <nib>:work-in-progress/REMEMBER.md      # read the whole departing card
git show <nib>:work-in-progress/THREADS.md
git log --oneline <nib>                          # browse the tree as it stood
```

The nib is the HEAD **before** the debride's own commit — so the old files live at that commit and every commit before it.

---

## The ledger (newest first)

### `20260817.171714` -- REMEMBER Today arc condensed (the done-work wall folded to a pointer)

**Walk-back nib:** `3b8b0d4858`
**Swept:** the `## Today 20260811 -- a full arc` section of `crux/REMEMBER.md` (lines 228-306), a wall of ~160 dated done-work bullets -- 116 `LANDED`, 24 `OPENED`, 17 `COMPLETE`, 7 `CLOSED`, 5 `SEATED` -- condensed to a single lean pointer that names the big landed arcs and defers every detail to the session logs and git history. Done on Keaton's word so the operator card stays single-stranded: the live work-front, never a second copy of the log index. No other section touched; the INNER LOOP directives, the Compass Season table, Waymarks, gates, and open doors all stand.
**What waits there, worth recalling:** at nib `3b8b0d4858` and every commit before it, the full arc reads whole -- `git show 3b8b0d4858:crux/REMEMBER.md`. Every bullet it held (Mandate, the Acme DX season, CION labeling, the AHOY front door and WADE surface, the Singularity, the Twilight palette, BUHR's MCP surface, the 1,024-round itinerary, TACT Journeys 1/2/4, the recursion cellar, Season A / HUNK, Constel and Testament) is also recorded in `session-logs/` as its own dated `.bron`/`.kyri` log. Nothing landed is lost; the wall simply moved to where the record belongs.

### `20260816.220634` -- work-in-progress -> crux rename EXECUTED (the breach the 20260815 cairn pre-planted)

**Walk-back nib:** `947c592333`
**Swept:** the `work-in-progress/` directory renamed to `crux/` via `git mv`, so the living pins (REMEMBER, REDS, CAIRNS, SHRED_PREP, ROADMAP, TASKS) now sort high alphabetically as Keaton seated. A back-compat symlink `work-in-progress -> crux` is committed so the 2,000+ dated session logs and counsel that cite `work-in-progress/...` still resolve unchanged -- accrete-never-break without rewriting one dated artifact. Only the loop paths (the seed and `tools/launch-claude-season.rish`) and the living rules that name the ledgers were repointed to `crux/`; the dated-bearing ledgers kept their historical `work-in-progress` wording and resolve through the symlink.
**What waits there, worth recalling:** at nib `947c592333` and every commit before it, the tree still holds a real `work-in-progress/` directory -- every path in dated logs is literal there, not a symlink. A future full repoint of living references (dropping the symlink) would be its own ratchet round.

### `20260815.175524` — Decision-wave breach queue: Bron→Kyri and work-in-progress→crux (prep, no cut yet)

**Walk-back nib:** `9e3c2dccfa`
**Swept:** *nothing yet* — planted **ahead** of two newly approved breaches so each keeps its walk-back before it cuts: **Bron → Kyri** (unify the notation entirely under Kyri — `.kyri` takes the responsibility of `.bron`; Kyri is voice · notation · *compressed receipts* · preferred Grain variant, named in gratitude after Kyrie Irving) and **`work-in-progress/` → `crux/`** (a higher-sorting priority folder — `crux/REMEMBER.md`, etc.; 902 files reference `work-in-progress/`, every one repointed in the rename round). Each executes as its own signed loop round; the dated `.bron` logs' deep rename stays a separate circled step under the one-clock law.
**What waits there, worth recalling:** the whole tree under the elder folder name `work-in-progress/` and the elder notation name `.bron` — every REMEMBER/CAIRNS/TASKS path, every `.bron` session log, and the pre-rename reference graph. Walk back with `git show 9e3c2dccfa:work-in-progress/REMEMBER.md` or `git log --oneline 9e3c2dccfa`. Decisions + flags: [`../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md).

### `20260813.020035` — Double-seat expansion breach queue (prep, no cut yet)

**Walk-back nib:** `0a074d5059`
**Swept:** *nothing yet* — this cairn is planted **ahead** of a queue of four approved breaches so each has its walk-back before it cuts: **Dimeroll → Dimeroll** (bought `dimeroll.com`), **`.myc` → `.kres`** (Kresfa, supersedes `.myc` + Sui Move), **council sky → constel sky** (bought `constel.net`), and the **deep debride + seed force-push** (*initial public seed*, again — depersonalized, `twilight/` kept). The last rewrites history and loses its own walk-back, so this nib is where the whole pre-breach tree lives.
**What waits there, worth recalling:** every module, doc, and notation under its elder name — `dimeroll/`, `.myc` contracts, "council sky" prose — plus the whole signed commit history before any rewrite. Walk back with `git show 0a074d5059:<path>` or `git log --oneline 0a074d5059`. Queue + gate flags: [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md).

### `20260810.160511` — Expanding-prompts archive-fold (Option B, safe subset)

**Walk-back nib:** `663b778b38`
**Swept:** moved the **67 zero-inbound-reference** spent recursion-prompts and fusion-batons from `expanding-prompts/` (top level) into `expanding-prompts/archive/`. This is an **accrete-safe move, not a debride** — every byte stays in the tree and in git history; nothing is deleted. Only files with zero external citations moved, so no dated testimony's links break and no dated file is edited. The 169 still-referenced spent files stay in place (their citations are load-bearing history).
**What waits there, worth recalling:** the moved files are per-round recursion-prompts and closed-arc fusion-batons — spent working prompts, superseded by their rounds' landed work and session logs. Walk back with `git show 663b778b38:expanding-prompts/<name>` or read them at the new `archive/` path.

### `20260809.024851` — The Compass Season living-card debride

**Walk-back nib:** `bc90f7fdb0`
**Swept:** `work-in-progress/REMEMBER.md` (471 → ~75 lines), `THREADS.md`, `TASKS.md`, `ROADMAP.md` — all rewritten from the elder Equinox-season e-number ladder to the four-equinox Compass Season.
**What waits there, worth recalling:** the full e-number GREEN ladder (e7–e302), the Amphora CLI log (e140–e177), the twelve RESTED nested seasons with their pointers (Equinox · Fascia · Voice · Nona · Kiln · Surface · Generator · MUR · Inner Scope · Constellation · Keeh), the guide 0–2 walk detail, and the old Open-Doors GREEN table. Every green also stands in the code and in the dated counsel; this cairn is the fast path to the *shape* of the old cards.

### The Haunted Mound deep debride (recorded after the fact)

**Walk-back nib:** *not preserved on the branch* — this deep debride rewrote all 37,264 commits with `git-filter-repo` and force-pushed, so no pre-debride commit is reachable. **This is the lesson that seated the cairn pattern:** a deep debride that rewrites history must drop a cairn *first*, or the walk-back is gone. The tribute content itself was intentionally removed at Keaton's word; what a future cairn would have preserved is the surrounding season's card state, now readable only from local reflog if it survived (`git reflog` · dangling commits), not from the shared remotes.

---

*Leave a stone before you cut. The trail you mark today is the one you can walk back tomorrow.*
