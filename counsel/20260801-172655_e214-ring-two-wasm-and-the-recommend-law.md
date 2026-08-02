# e214 — ring two's Wasm cut, and a law the bench writes against itself

**Stamp:** `20260801.172655` (by construction) · **Voice:** Riyo · **Word:** "approve recs" · **Status:** GREEN + one seam named + one hold

**The hold, first and briefly:** the approved recommendation pointed at
seat 128, and seat 128 does not open that way — it is yours alone, by the
same law that held three bare kgs this morning. The fault in the collision
is the bench's: a gate word should never have ridden a Recommend line
where an "approve recs" could reach for it. **Standing practice from this
seat on: Recommend lines carry only non-gate work; gate words live solely
in their own block, as your words, never as counsel's suggestions.**
Owned, seated, done.

**The engineering the word does cover, delivered:** ring two's Wasm cut
**builds clean** — `linengrow/bin/retting.wasm`, 1,510,809 bytes — and
**runs under a WASI runtime**: argv arrives, env arrives, main executes,
and the refusal path exits nonzero speaking `HomeUnavailable` by name,
exactly as authored. What stops short is the filesystem: this rye std's Io
layer carries **no preopen walk** (measured — zero `prestat` mentions in
the tree), so `Dir.cwd().openDir` cannot reach WASI-granted directories
yet, under absolute or relative mappings alike, three shapes tried. The
seam is now named precisely for its own seat: *the WASI dir road in the
rye std* — pier or design lane, Keaton's ordering. The witness meanwhile
accretes a ring-two build leg with a 4 MiB roof, so the Wasm target can
never silently rot while the seam waits.

**Djin page one** still waits your one line (which fund, which lesson).

---

**Migration note (`20260802.142103`, e207-tidy):** the two correction blocks below were appended on 20260801 to a stray literal-glob filename (`counsel/*e214-ring-two*.md`) — an unexpanded glob in the append chain, caught by the pier at a0 landing. Content migrates here whole; the stray is removed in the same commit.

**Correction (`20260801.172719`):** the seat above says *zero* prestat mentions; the measured count is **one** — a single reference at the site the grep names, still short of a working preopen walk (three runtime shapes refused). The finding stands; the word "zero" was wrong and is corrected here the moment it was caught.

**Ring two closes GREEN (`20260801.172801`):** the correction's own grep held the key — under WASI, cwd is fd 3, *the first preopen* (Dir.zig:91's comment). Preopen the season home first and set RETTING_HOME to `.`, and the module runs whole: start writes the log through WASI, status folds it — `wasmbatch day 1 of 7`, log line on disk written by the wasm itself. Harness shape recorded here for the pier; the 1.5 MB artifact stands ready for the Codeberg post by your hands. A wrong word owned in the hour it happened turned into the road home — the day's law, keeping itself.
