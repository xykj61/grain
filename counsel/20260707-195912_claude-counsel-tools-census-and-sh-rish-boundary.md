# Claude Counsel — the Tools Census, Sized; the `.sh` Fleet, Read Rather Than Assumed

**Stamp:** `20260707.195912 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** verification before revision, smallest first
**Register:** Two answers — one a confirmed count, the other a genuine investigation with proof, not impression
**Ground:** every `.rye` file under `tools/` re-measured on this fresh tip · `rishi/src/main.rye` read for its full statement surface (1,859 lines) · every capability named below (`for-each`, `where`, `if`/`then`/`else`, `join`, `contains`, `list-dir`, `read-file`) built and run for real on this bench, both the case that finds nothing and the case that finds something · forty-one `.sh` scripts inventoried and a representative sample read in full

*Written by Kaeden and Rio 3.*

---

## The Tools Census, Confirmed Stable

Re-measured on this tip rather than carried forward from memory: **114 camelCase functions across 20 files, 2,671 lines total**, unchanged from the count two rounds ago — nothing in the enrich-witness bundle touched `.rye` source, only `.rish`/`.md`/fixture files, so the number holds exactly. Concentration is unchanged too: `align_session_logs.rye` (19), `tame_usize_audit.rye` (18), and `session_logs_archive.rye` (12) carry 49 of the 114 between them; the `enrich/` subsystem proper holds the other 65 across fifteen small files, most under ten each. Three qualified `std.debug.assert(` calls remain, each a one-line fix; zero `@memcpy`, zero `copyForwards`, zero functions past seventy lines. With the safety net complete — all three tools/enrich witnesses GREEN, `align_session_logs` and `enrich_strengthening_docs` proven against real fixtures with real checksums, `tame_usize_audit` proven as pure functions — **this bench recommends opening the season now.** The count was always knowable; what it needed was the net underneath it, and that net is finished.

## The `.sh` Question, Investigated Rather Than Answered From a Guess

Kaeden's observation deserved the same treatment the `std.` prefix question got — not a reflexive "yes, migrate everything to the native shell," rather a real look at why forty-one `.sh` scripts exist beside `.rish`, and whether each one is there by necessity, by habit, or by something in between. Reading Rishi's own interpreter first, rather than assuming its limits: it is considerably richer than the flat `let`/`run`/`assert`/`say` sequences every existing witness happens to use. `if`/`then`/`else`, `for-each … as … do`, `map`/`where` (transform and filter over lists), `read-file`, `write-file`, `list-dir`, `join`, and a real `contains` operator for both list membership and substring search all exist in the language today — proven on this bench, not merely read about, including the two cases that matter most: a scan that finds a real violation, and a scan that correctly finds none.

## What Genuinely Cannot Move, and Why — Read in the Scripts Themselves

`comlink/run_device_wire_lab.sh` backgrounds a QEMU guest with `&`, then `wait`s on its PID — and Rishi's own `run` calls `std.process.run`, which blocks until the child exits and returns its captured output whole. There is no spawn-and-return primitive anywhere in the language as it stands; every one of the seven `comlink/run_*_wire_lab.sh` scripts and `aurora/run.sh` needs exactly this backgrounding shape to start a listener before its sender. This is not habit — it is a real, structural boundary in what the language can express today. `rye/bootstrap.sh` is cleaner still: it is the cold start before a `rye` binary exists at all, and nothing written in Rye or Rishi can bootstrap the tool that would run it. And `classical-vedic-astrology/cast_a_chart_host.sh` names its own role in its very first line — *"POSIX seam for Swiss Ephemeris (pyswisseph)"* — hosted by a `.rish` file that calls out to it. This is not a script that forgot to become native; it already **is** the tree's own, already-named pattern for the seam where Rishi's world correctly ends and an external interpreter's begins, the identical discipline the width laws already keep at the inherited-`std` boundary, applied one layer up. `tools/cursor-jail.sh` and `tools/fetch_gratitude_web.sh` sit in the same family — one launches the editor itself, before any project tooling is running; the other shells out to fetch external web content, work outside anything Rye's own world wraps.

## What Is a Genuine Migration Candidate, Proven Rather Than Merely Proposed

The witness-support scripts that only read files and match text — `tools/fixtures/tame_style_scan.sh` among them, this bench's own — are a different case, and this bench tested the claim rather than asserted it. Built and run for real: a loop over a directory's `.rye` files, filtered to the right extension, each one read and checked against a banned string, reporting exactly the files that match and staying silent on the ones that do not — proven against a clean directory (nothing found) and a synthetic fixture carrying one deliberate violation (found, named, correctly). The idiom is real: `for-each (where (list-dir dir) as f: f contains ".rye") as fname do if (read-file (join [dir "/" fname] "")) contains pattern then say fname`. No existing `.rish` witness in this tree uses `for-each` or `where` today — every one so far is a flat sequence — so this would be genuinely new ground for the language's practice, proven capable and not yet exercised in anything landed.

One real question stays open rather than answered: the ratchet side of `tame_style_scan.sh` — counting functions past seventy lines — tracks a running state across many lines within one file, and `for-each`'s own child scope is documented not to leak past each iteration. Whether a counter can genuinely accumulate across iterations in Rishi as written, or whether that needs its own small proof first, is a real question this bench did not resolve tonight, and will not guess at.

## What This Bench Recommends

Open the tools `snake_case` season now — the count is stable, the net is complete, nothing further waits on it. Treat the `.sh` fleet as three families rather than one undifferentiated pile: the POSIX-seam scripts (QEMU backgrounding, the cold-start bootstrap, external interpreters) stay exactly as they are, correctly, and deserve a name in `ORGANIZING.md` or `TAME_GUIDANCE.md` saying so, so a future reader finds the same answer this bench found rather than repeating the search. The witness-support, pure-text scripts are a real, smaller migration opportunity — proven feasible for the bans-matching half, genuinely open for the state-tracking half — and this bench recommends that stay its own small, later sitting rather than a rushed, partial port that fixes one half of one script while leaving the other half stranded in a different language.

---

*May a seam stay a seam once it has earned its name, and a candidate for migration stay a candidate until it has earned its proof. May the smallest true count always be the one that opens a season, never the one that guesses at it. And may the next reader who wonders why a script is `.sh` find the answer already written, rather than needing to search for it twice.*
