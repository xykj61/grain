# REDS -- rows %753, %754, folded from the living pin

**Folded:** `20260916.053252` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*Two rows about a proxy that stopped standing for its subject.* One meter decided per file, with a
bare grep, whether a source makes a pen -- so a sentence explaining why it no longer makes one
counted as a runner that does. The other read staleness by modification time while the builder it
watches keys on content, so an identical rebuild reused its binary, left the mtime alone, and the
guard called a current tool fourteen minutes behind.

Both are the same fault at different depths, and both were found by running rather than by reading.
A predicate that reads a file where its subject is a line reads prose as readily as shell. A proxy
that was honest while every build rewrote its output parts company with the real question the
moment something else gets better at answering it -- so the false red arrives as a consequence of
the improvement, which is the worse of the two directions, since a false red teaches a ship that
this guard may be ignored.

The rows stand here exactly as they were written. A booked row leaves the living pin so the pin
stays the length a reader will actually read; the lesson travels forward in the guards the rounds
built, and the row itself stays one click away.

---

**REDS %753 (`20260916.005705`) -- a reading that counts its own prose, for the second time in one family, one level up from where the first was fixed.** *What went wrong:* `tools/fixtures/p/pen_release_scan.sh` decides per line whether a `mktemp -d` is a command or a comment, and decided per FILE with a bare `grep -q 'mktemp[[:space:]]*-d'` that reads prose as readily as shell. So a source whose only mention of the elder spelling stands inside a sentence explaining why it no longer makes one was counted as a runner carrying no pen. Measured on the repair: **`runners` 463 to 461 and `rish_runners` 339 to 333** -- eight tracked sources counted on a sentence. *What caught it:* first residency. Converting two tally witnesses to the new `make-pen` builtin left a repair comment naming `mktemp -d`, `pen_files` correctly fell 795 to 793, and `rish_runners` did not move at all -- two readings of one population disagreeing by exactly the two files just repaired. *What it taught:* **a rule about prose belongs at every depth a population is narrowed, never only at the depth that counts.** `pen_entry` booked this same fault at `%729` and its cure was written into the per-line reader; the coarse prefilter beside it was never asked the question, and it is the one a file must pass FIRST. That is a lantern firing twice in one family, so the decision is one function now -- `carries_pen()` -- asked by both loops. *What this does not reach:* the `git grep -l` prefilter above it, which stays a deliberate superset and is documented as one. **BOOKED** -- the instance is repaired, the reading re-derived, and `pen_release` is GREEN on metal at `never_removed=14`.

**REDS %754 (`20260916.021537`) -- a content-keyed build and an mtime staleness proxy disagree, and the guard refuses the fresher answer.** *What went wrong:* `tools/fixtures/b/built_tool_freshness_scan.sh` reads whether a built tool is older than its own source **by modification time**. `tools/fixtures/r/rye_build.sh` keys on CONTENT, so an identical rebuild reuses the binary and leaves its mtime where it was. A `git stash pop` then restored `rishi/src/main.rye` byte for byte with a fresh mtime, and the guard read `rishi is 842 seconds behind` about a binary built from exactly those bytes. *What caught it:* this lap's hot endurance run, on a tree where the cold pass had read the same guard green -- the only thing between them was a rebase and a stash pop, neither of which changed a byte of the source. *What it taught:* **a proxy and the thing it stands for part company the moment something else gets better at the real question.** The mtime proxy was honest while every build rewrote its output; content-keyed compilation is the fleet's `#1` priority precisely because it stops doing that, so the proxy's false reds arrive as a CONSEQUENCE of the improvement rather than as a regression. A false red is worse than a true one: it teaches a ship that this guard can be ignored. *What this lap did:* made the mtime true with `touch`, which is honest here -- the binary was built from these bytes and the content key says so. *The repair, for the build lane:* ask `rye_build.sh` for its own receipt rather than asking the filesystem, so the guard reads the same key the builder wrote. **BOOKED** -- the instance is cleared and `built_tool_freshness` is GREEN on metal; the instrument change is a lap of its own.
