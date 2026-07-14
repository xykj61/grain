# Wire hardening and Rishi Ring 3 Edit 1

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260702.021845`
**Prompt:** Kaeden — save Yes progress, continue mechanical No's, report when to check in with Claude.

---

## Thinking trace

Yes already on remotes at `5115cc8`. Continued without Claude on two mechanical items from TASKS:

**Wire hardening** — `comlink/hosted_wire.rye`: pinned unpredictable witness fixture seeds; `freshNonce()` via monotonic counter hashed through SHA3 (unique per message; CSPRNG deferred to production horizon). Version `20260702.014112`. Comlink hosted wire witness green.

**Ring 3 Edit 1** — `rishi/src/main.rye`: extracted `pub runOneInput` (meta-commands + plain lines), `pub sessionLines`, `Transcript.full` with invariant, pub `Env`/`History`/`Transcript`/`max_transcript_bytes`. `runRepl` thinned to loop over `runOneInput`. SLC-1 four witnesses green; TH-5 fixed by keeping `sessionLines` indices in u32.

Edits 2–6 (drawn-terminal app, witness 139, metal) **blocked** on Kaeden's nod for `pond/apps/drawn_terminal.rye` per bench prompt.

Parity **138 GREEN** after rebuild.

## Files

- `comlink/hosted_wire.rye` — wire hardening
- `rishi/src/main.rye` — Ring 3 Edit 1 extraction
- `work-in-progress/TASKS.md` — wire hardening checked; Ring 3 split Edit 1 vs app

*Recommend: nod `pond/apps/drawn_terminal.rye` to finish Ring 3; rule Edit 5 before the next counsel-sized sitting.*
