# REDS -- the law named a field the language refuses

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri
**Folded:** `20260908.101112`
**Rows:** `%632` (`20260908.101112`) -- CLOSED

The row folds on the lap it was booked, for the reason the shelves beside it record: the living pin
stands at its bound and every other row on it reads OPEN or BOOKED to another ship, so a finished
row goes where finished rows belong and the pin keeps a pointer.

What it holds is a correction that was written down and never carried. `context/TAME_GUIDANCE.md`
recorded on `20260729.214600` that Rishi's `run` record has no `status` field; forty days later the
two Claude-side pages still named it, one of them twice, and one of them disagreed with its own
paragraph eight lines above. An erratum records a correction and moves nothing. A guard carries it.

**REDS %632 (`20260908.101112`) -- the agent rule told every lap to check a field the language answers `NoSuchField` to, forty days after the erratum that killed it.** *What went wrong:* Rishi's `run` builtin returns a record built in one function, `run_result_record` in `rishi/src/main.rye`, whose four fields are `out`, `err`, `code`, and `ok`. `.claude/rules/tame-guidance.md` -- the page every unattended Claude lap in this fleet loads -- said in its cheatsheet table that `run` "always returns `{ status, out, err }`" and told the reader to "check `status` before trusting `out`". There is no `status`: asked for one on metal, the interpreter answers `NoSuchField` and exits 1. `context/TAME_CORE.md` carried the dead field too, inside the same sentence that gave the right record -- "check `status`/`.ok`" -- and the rule page disagreed with **itself**, its TAME Core block reading `{ ok, out, code }` eight lines above the table reading `{ status, out, err }`. *What caught it:* the aether rota row, whose instruction is to listen for the claim a page keeps repeating and for the silence where a claim used to be. Pressing TAME Core's Rishi line the way the prior lap pressed its Rye reflexes, then reading the shelf: `context/TAME_GUIDANCE.md` holds an erratum stamped `20260729.214600` saying exactly this -- the field is `ok`, `status` does not exist, `say r.status` answers `NoSuchField`. Proven again on metal this lap in a `mktemp` pen: `r.out`, `r.code`, `r.ok`, `r.err` all answer; `r.status` refuses with exit 1. *What it taught:* **an erratum is a record of a correction, and nothing carried it to the pages repeating the retired claim.** The correction reached the page that recorded it and the Cursor twin, and stopped -- so for forty days the two Claude-side pages were the wrong ones, which is the one seat where being wrong is read every lap. The fault was self-limiting in *code*, since a script written by that instruction refuses at runtime and no `.rish` source in the tree reads `.status`; its whole cost was paid in the agent's head. *Repaired:* four sites now spell one record, `{ out, err, code, ok }`, with `ok` as the field to check. *Gated:* `tools/r/rishi_run_record_witness.rish` over `tools/fixtures/r/rishi_run_record_scan.sh` derives the field set from `rishi/src/main.rye` rather than spelling it, asks each derived field of a real `run` result through the interpreter, proves an absent field REFUSES so the probe is known able to make a sound, and holds living law pages at **zero** claims naming a field outside the set -- 108 pages read, 20 claim sites, 3.1s, `tier lap`. An erratum line is read past by name, and the control proves that rule is not a door. 31 behaviors in a throwaway pen, every refusal planted and lifted. **CLOSED** on that witness GREEN.

*Booked `%629` and renumbered to `%632` on this send's rebase: three peers published `%629`, `%630` and `%631` while this lap ran. The stamp is the key, so the move cost one line ([`derived-spine`](../../.claude/rules/derived-spine.md)).*
