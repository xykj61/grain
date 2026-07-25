# Cursor Round — Amber Specified, the Deep Archive Verified, the Ledger Kept True

*One round in the docs lane, run before the Ring 3 bench. It places the verified deep-archive blueprint beside its companion, seats Amber in the family with its revised functional specification, records the rulings so they are not lost, amends the held Ring 3 prompt against the code as it truly stands, and leaves the live rung exactly where it is. Nothing here is built; everything here is designed, named honestly as designed.*

**Stamp:** `20260701.221512` (carried; revised within the session after the outside reading and a whole-tree verification — the blueprint itself carries `20260701.213412`)
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Order:** this round first; the SLC-2a Ring 3 prompt (`20260701-205712_cursor-slc-2a-ring-three.md`) runs after, carrying the amendments of Edit 6.

*Written together by Kaeden and Reya 2.*

---

## Edit 1 — Place the blueprint and its companion together

The whole-tree verification found the companion memo absent from the snapshot along with the blueprint, so the two travel together now. Bridge the OCuLink server-workstation research memo (Kaeden supplies it) and `20260701-213412_deep-archive-and-sovereign-host-blueprint.md` (provided) into `external-research/`, where sourced research memos live, and register both in the folder's living README index and in `ORGANIZING.md`.

Confirm the companion's true six-digit filename from the file in hand, and correct the blueprint's **Companion to** line to that exact name. The line currently reads a five-digit time (`20260701-21113_…`), one digit short of the one-clock convention, and a dangling companion reference is precisely what this round's verify step exists to catch.

The blueprint supersedes an unverified draft from the same evening. The snapshot shows no such draft anywhere in the tree, so the expected case is *never present*: confirm against the live tree and note which case held. If it somehow entered, `git mv` it to the folder's `yonder/` with every inbound reference repointed, noting in its vicinity that the verified blueprint replaces it.

## Edit 2 — Place the revised Amber functional specification

Bridge the revised spec (provided; same stamp, its Status line naming the same-evening revision) to `context/specs/20260701-221512_amber-functional-spec.md` — the path proposed for it, honored. The revision seals four findings from the outside reading: verification lives as its own record kind, so the archive record is truly immutable once signed; the recovery custody of the unlock material is named, with the paper passphrase resting in the firebox and with the offsite rotation; the first ring signs through the host's OpenPGP tooling at a named seam, with Kumara as the sovereign horizon; and the scrub runs cold, the key warm only for the seconds of the batch signature. Register the spec in `ORGANIZING.md` and in the context home's map of what lives in `context/`.

## Edit 3 — Seat Amber in the family, seam-honest

In `context/LEXICON.md`, add a Radiant one-liner:

- **Amber** — preservation; the resin that seals a moment whole: signed, encrypted, bit-faithful archives on deep storage, recorded in an append-only log and verified by folding. Where Mantra holds the living history, Amber seals the moment and sets it aside.

In `active-designing/20260630-001812_the-stack-and-the-surface.md`, seat Amber with a **light affirmation touch** — one woven sentence beside Mantra and Comlink: Mantra is a projection over Weave; Comlink moves signed facts hot between nodes; Amber seals state cold to disconnected storage, signing through the host's OpenPGP seam with Kumara as its sovereign horizon, and leaning on Tally for its bounded working memory. Refresh the `Last updated` line. No restructure, no rename; the record is cited and keeps its stable name.

Update `context/README.md` and `ORGANIZING.md` so both stay truthful.

## Edit 4 — Record the rulings and the horizons in TASKS

In `work-in-progress/TASKS.md`:

- Record the **invocation ruling** so it is not lost: Amber is an explicit shell command with a manual unlock of the sandbox key; the docked bare drive is the precondition, never the trigger; the shell may notice and offer, never act. The scrub runs cold, and the key is warm only for the seconds of the seal or the batch signature.
- Record the **custody rule** in one line with its anchors: master `0646 2132 D3E6 3B83 4F97 6E03 A81D 720B 9235 FA7A` cold and certifying; sandbox `DBF8 5343 7A93 7B4E 36B9 3611 D949 807A C26B 2B99` signing and revocable; the drive passphrase on paper in the firebox and offsite; any other fingerprint is an error on sight.
- Add the **Amber build** as a horizon, not a Now item: designed and specified; first ring when its season comes — seal one directory to one drive, one signed record, one verifying fold, and one hand-verified golden so the oracle is never checking itself.
- Add the **deep-archive hardware** as a horizon of procurement rather than code: the small rack, the powered dock, the bare enterprise drives, the front-door tunnel — researched and costed in the blueprint, waiting on the dedicated machine.
- Confirm **SLC-2a Ring 3** remains the live rung, its bench prompt now carrying the amendments of Edit 6.

## Edit 5 — The docs-lane witness (gated on Kaeden's ruling)

The outside reading names the one unbounded buffer in the project: the queue of designed-unbuilt specifications. If Kaeden rules for the bound, record it in two places; if he rules otherwise, skip this edit whole and note the ruling in the session log.

In `work-in-progress/TASKS.md`, one line under Ground: functional specs in designed-not-built flight are bounded at **one** — a second module spec lands only when the first's first ring runs green.

In `context/TAME_GUIDANCE.md`, one row in the enforced-now table of **What We Check, and When**: count the Status lines reading designed-not-yet-built among `context/specs/*.md`; assert at most one. A plain textual check in the family's own idiom, with its witness joining the lint gates when the next tooling pass runs.

## Edit 6 — Amend the held Ring 3 prompt before the bench

The held prompt (`20260701-205712_cursor-slc-2a-ring-three.md`) rests on the bench outside the tree; apply these three amendments to it wherever it lives, and if it enters the tree first, edit it there. Each is grounded against the code as it stands today.

**First, the entry point, said honestly.** The prompt asks the executor to publicize a per-input entry named `runOneInput`, and no function of that name exists. What exists is `runInputLine` in `rishi/src/main.rye` (line 282 at this writing) — private, and covering plain evaluation lines only, while the meta-command dispatch (`:version`, `:recall`, `:history`, `:quit`, and the `!` recall) lives inline in `runRepl`. Amend the instruction to name the true work: extract the full per-line step, meta-commands included, into one public function returning a continue-or-quit signal, as a behavior-preserving refactor, with the four SLC-1 witnesses (`slc1_repl_step1`, `slc1_version_step2`, `slc1_recall_step3`, `slc1_accept`) as the net that proves nothing moved.

**Second, the loop, kept alive.** A drawn terminal that blocks on standard input starves the compositor: a ping arrives, no pong answers, and the desktop marks the window unresponsive. Amend the loop instruction to poll standard input and the display's file descriptor together, dispatching display events whenever they arrive. The machinery already sits in `brushstroke/wayland_seed.rye` — the display fd is fetched and polled with a timeout at lines 350 through 357, and the pong stands ready in the ping callback — so the amendment composes what runs rather than inventing anything new.

**Third, the ceiling, witnessed.** The transcript's bound is `max_transcript_bytes = 65536`, and at that edge today the shell prints an invitation to `:version` and drops the bytes. In a drawn terminal that renders the transcript, the same edge becomes a surface that quietly stops changing — alive underneath, frozen to the eye. Amend the prompt to define the drawn behavior at the ceiling (the invitation rendered in the window itself, with a checkpoint path or a tail view that keeps drawing) and to add a witness that fills past the ceiling and asserts the surface still updates — the silent freeze made loud, then made impossible.

## Verify

- The blueprint and its companion rest together in `external-research/`; the **Companion to** line carries the companion's true six-digit filename and resolves; the superseded draft's case (moved, or never present) is confirmed and noted; no dangling reference anywhere the round touched.
- The revised Amber spec rests at `context/specs/20260701-221512_amber-functional-spec.md`; lexicon, stack record (light touch), context home, and `ORGANIZING.md` all registered and resolving.
- TASKS carries the invocation ruling, the custody line, and the two horizons; Edit 5's case (recorded, or ruled against) is noted; the live rung is unchanged.
- The held Ring 3 prompt carries all three amendments of Edit 6.
- `rye build` and `tools/parity.rish` stay green on metal — this round is docs only, and nothing it touches is load-bearing for code.

## Propose, Then Confirm

Gate the irreversible as always — especially any `yonder/` move of the superseded draft, since it may carry inbound references, and any edit to the held prompt if it has already entered the tree. Show the diff and wait for Kaeden's word.

## Record and Push

Commit as honest units — the blueprint-and-companion placement (with any yonder move), then the Amber seating (spec, lexicon, stack touch, TASKS, and Edit 5 if ruled for), then the Ring 3 amendments if the prompt lives in the tree (otherwise note in the session log that they were applied on the bench) — with the session log at `session-logs/archive/20260701/20260701-221512_amber-and-deep-archive.md`: the blueprint placed beside its companion and verified, Amber specified and seated seam-honest, the rulings recorded, the prompt amended, the rung held. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line: *"Recommend: run the amended Ring 3 prompt next — the drawn terminal's closing ring — with Amber's first ring queued as the following season's spine."*

---

## Definition of Done

- [ ] Blueprint and companion placed together in `external-research/`; the Companion line corrected to the true six-digit name; superseded-draft case confirmed (moved with repoints, or never present); indexes registered
- [ ] Revised Amber spec at `context/specs/20260701-221512_amber-functional-spec.md`; lexicon one-liner; stack record seated seam-honest with a light affirmation touch; context home and `ORGANIZING.md` truthful
- [ ] TASKS carries the invocation ruling, the custody anchors, the Amber-build horizon (with its golden), and the hardware horizon; Edit 5's ruling honored either way; SLC-2a Ring 3 unchanged as the live rung
- [ ] The held Ring 3 prompt carries the three amendments: the honest extraction with the four witnesses named, the polled loop, the witnessed ceiling
- [ ] `rye build` and parity green on metal; gated propose-then-confirm honored; session log shipped; four remotes pushed; the amended Ring 3 recommended next
