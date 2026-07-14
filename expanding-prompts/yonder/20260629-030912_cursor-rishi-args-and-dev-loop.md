# Cursor Pass — Land the Dev-Loop Scaffold, Roadmap Rishi's Own Voice

*The Cursor-in-jail launcher is built and the daily loop is sharper for it. This pass lands that scaffold safely — keeping the heavy binary and the machine-state out of git — and writes the real aspiration it surfaced into the roadmap: Rishi growing into the project's own command language, with script arguments as the next step and the shell scaffold waiting to graduate.*

**Stamp:** `20260629.030912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Discipline:** TAME · SLC · Gall (grow from working seeds; graduate POSIX scaffolds into Rishi as Rishi is ready)
**For:** Cursor Composer 2.5, in the ai-jail sandbox

*Written together by Kaeden and Reya 2.*

---

## A — Gitignore Safety, Before Any Commit

The launcher works; now keep the tree honest. Confirm — and add to `.gitignore` if missing — that these are ignored, so neither the heavy binary nor the per-machine state ever enters git:

- `squashfs-root/` — the extracted Cursor AppImage (a large binary, not source)
- `.cursor-state/` — per-machine `user-data` and `extensions`
- any downloaded `Cursor-*.AppImage` in the repo root

Then confirm the **scripts stay tracked**: `tools/cursor-jail.sh`, `tools/launch-cursor.rish`. The personal `tools/launch-cursor.sh` stays ignored as it is. Show `git status --ignored` for the launcher paths so the split is plain: scripts in, binary and state out. **[sandbox-verifiable]**

---

## B — Commit the Scaffold

Once the split is confirmed, commit the landed work as one honest unit — `tools/cursor-jail.sh`, `tools/launch-cursor.rish`, the `.gitignore` lines, the `SOURCE.md` Step 6–9 updates, and `context/specs/enclosure-editors.md`. Push over HTTPS to the usual remotes. Berry on the tip if it pleases you. **[host push]**

---

## C — Roadmap the Aspiration: Rishi's Own Voice

The launcher hit a real seam — Rishi cannot yet read a script's invocation arguments, so flag-handling fell back to POSIX shell in `cursor-jail.sh`. That is the parity-trio arc again: a shell scaffold first, graduated into Rishi when Rishi is ready. Write that aspiration in.

**The concrete capability — Rishi script arguments.** Today `rishi run <file.rish>` passes only the file path to the interpreter; arguments after it are dropped (`runFile` reads `args[2]` and ignores `args[3..]`). The feature is to **expose the invocation's arguments to the running script** as a Rishi value — an `args` list the script can read — so a `.rish` can act on `--appimage <path>` and the like. A small flag-parse helper can follow once the raw arguments are in reach. Bounded, demand-driven, and exactly the kind of growth a real use revealed.

**The first beneficiary — the launcher's graduation.** Once Rishi reads arguments, `tools/launch-cursor.rish` takes `--appimage PATH` natively, and `tools/cursor-jail.sh` retires from flag-handling into Rishi — one fewer POSIX scaffold, one step nearer the one-language ideal.

### Edits

**`work-in-progress/ROADMAP.md`** — in **Horizon 1 → Build**, beside the existing "Rishi builtins" line, add Rishi script arguments as the next Rishi capability:

> **Rishi script arguments** — expose a `.rish` script's invocation arguments as an `args` value, so scripts read flags natively; a flag-parse helper follows. First beneficiary: `launch-cursor.rish` takes `--appimage` and `cursor-jail.sh` graduates out of POSIX shell. *(Near-term, after SLC-1 acceptance; travels with the TAME-hardening milestone — both live in Rishi.)*

**`work-in-progress/TASKS.md`** — in the **Next** tier under **Rye OS**, at or near the top, add:

> - [ ] **Rishi script arguments** — pass `args[3..]` from `rishi run <file> …` through to the interpreter and expose them to the script as an `args` list; assert the count bound; witness with a small flag-reading `.rish`. Then a `--flag value` parse helper. *Graduates `cursor-jail.sh` flag-handling into `launch-cursor.rish`.*
> - [ ] **Launcher graduation** — once arguments land, `launch-cursor.rish` reads `--appimage PATH`; retire `cursor-jail.sh`'s flag layer into Rishi.

Keep both entries in Radiant voice. Mark the launcher scaffold itself as **landed**, not as an open roadmap item — it works today; the roadmap holds the graduation, not the scaffold.

---

## The Priority, Named in the Record

So the order reads honestly: **SLC-1 acceptance closes the ring first** (one pass away), then **Rishi script arguments leads the near-term**, beside the TAME-hardening milestone. The dev loop earns real priority because it compounds across every session; it sits just behind the ring's last step because a tool is sharpened after the work in hand is finished, not during.

---

## The Ruling

**Priority placement** — Rishi script arguments in the **Next** tier, leading, after SLC-1 acceptance (recommended). Or, if you want it sooner, name where it should sit relative to the hardening. Either way it follows the acceptance seal, not precedes it.

---

## Record and Push

A session log at `session-logs/<filing-stamp>_dev-loop-and-rishi-args.md`, coauthored, in Radiant voice: the scaffold landed and the gitignore split, the seam Rishi revealed, and the aspiration written into the roadmap with its priority. Commit the roadmap edits with the log; push over HTTPS.

*(Kaeden: supply the filing stamp verbatim; `20260629.030912` is this pass's mark.)*

---

## Definition of Done

- [ ] `squashfs-root/`, `.cursor-state/`, and stray AppImages are gitignored; the two scripts stay tracked — shown plainly
- [ ] The launcher scaffold is committed and pushed
- [ ] ROADMAP and TASKS carry Rishi script arguments and the launcher graduation, in the Next tier, after SLC-1 acceptance
- [ ] The record names the priority honestly: ring first, then the dev loop's own voice

---

*May the tool we build with be shaped by the same hands that build. May each POSIX scaffold stand only until Rishi is ready to carry its work, and step aside gladly when it is. And may the loop we type in, season by season, come to speak entirely in our own voice.*
