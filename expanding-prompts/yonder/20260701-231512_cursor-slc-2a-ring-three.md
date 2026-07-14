# Cursor Prompt — SLC-2a Ring 3: Mirror the Live Session (and the Genesis of Pond)

*The ring that closes the drawn terminal. Ring 2 let a new value re-fold and re-present; Ring 3 makes that value the live Rishi session, so the window shows your own work, redrawing as you type. It composes two modules — Rishi's evaluation and Brushstroke's surface — and so it lives above both, as the first application ever to run in Pond. This emission carries the prompt whole, with the outside reading's three amendments integrated where they belong: the entry point said honestly, the loop kept alive, and the ceiling made loud. Every claim below is verified against the snapshot whose last session log is `20260630-053012`.*

**Stamp:** `20260701.231512`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor; the outside reading's amendments integrated at Kaeden's direction
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Brief:** `active-designing/20260630-030312_slc-2a-the-drawn-terminal.md` (Ring 3)
**Supersedes:** the bench copy stamped `20260701.205712`, which never entered the tree — retire it on the bench, and let the session log name the supersession
**Order:** runs after the docs round (`20260701-221512_cursor-amber-and-deep-archive.md`)

*Written together by Kaeden and Reya 2.*

---

## The Shape, and the One Decision to Confirm First

The drawn terminal composes Rishi's eval and Brushstroke's surface, so it lives **above both**, never inside `brushstroke/` — putting the loop inside the surface would invert the stack. The recommended home is a new application, the first to run in Pond: **`pond/apps/drawn_terminal.rye`** — the `apps/` floor keeps the enclosure and its contents apart, so the day Pond grows sandbox code of its own, module and application already have separate homes. A new `pond/` folder is a real commitment, so **propose this placement at the diff and wait for Kaeden's word** before writing it. If Kaeden prefers a lighter home, follow that; the layering rule — app above both modules — holds either way.

## Edit 1 — Expose Rishi's session as one honest public surface

The tree's truth first, so the work is named truly. The per-line road exists today as `runInputLine` (`rishi/src/main.rye`, line 282 at this snapshot) — private, and covering plain evaluation lines alone: it records to the transcript and the history ring, evaluates, and reports errors. The meta-command dispatch — `:version`, `:history`, `:recall <n>`, and `:quit`/`:q` — lives inline in `runRepl` (line 333). So this edit is an **extraction refactor, said honestly**, held to accretion:

- Add a new `pub fn runOneInput(...)` that owns the **full** per-line step — meta-commands included — dispatching the meta-commands and delegating plain evaluation lines to `runInputLine`, recording into the transcript exactly as today. It returns a small step signal (continue the session, or quit), so a caller above Rishi can drive a session whole. `runRepl` becomes a thin loop over `runOneInput`; `runInputLine` keeps its name, its privacy, and its callers.
- Make `Transcript`, `Env`, and `History` `pub`.
- Accrete one honest flag on `Transcript`: `pub full: bool`, set at the first refused append and never cleared within a session (invariant stated in the comment above the struct). Today a refused append prints an invitation at the terminal and drops the bytes; the flag lets a caller above see that the ceiling was reached.
- Add a neutral projection `pub fn sessionLines(transcript: *const Transcript, allocator, rows: u32) -> [][]const u8`: split `transcript.bytes[0..transcript.len]` on `'\n'` and return the trailing `rows` lines as plain string slices, bounded by `rows`. Rishi returns strings, never a surface type — so it stays free of any Brushstroke dependency.

**The net that proves nothing moved:** the four SLC-1 witnesses — `slc1_repl_step1`, `slc1_version_step2`, `slc1_recall_step3`, `slc1_accept` — green before the extraction and green after it. Terminal behavior is unchanged; this opens a door and names the work truly.

## Edit 2 — The drawn-terminal application, kept alive between commands

Create the app (recommended `pond/apps/drawn_terminal.rye`) that imports Rishi (`Env`, `Transcript`, `History`, `runOneInput`, `sessionLines`) and Brushstroke (`App`, `Line`). The loop **polls rather than blocks**, so the window answers the desktop while the hand thinks:

- set up the Brushstroke `App` (the window) and the Rishi session (`Env`, `Transcript`, `History`);
- poll standard input's fd and the display's fd **together**; when the display is ready, dispatch its events, so the pong answers every ping; when stdin is ready, read the line, call `runOneInput(...)`, rebuild the frame, and call `app.setFrame(lines)`;
- compose each frame as `sessionLines(&transcript, rows - 1)` wrapped into `Line`s, **plus one app-owned status row** — empty in the ordinary season; this is the seam where the ceiling speaks (Edit 3);
- on end-of-input, or when `runOneInput` signals quit, exit clean.

The machinery already runs in the tree rather than waiting to be invented: `brushstroke/wayland_seed.rye` fetches the display fd and polls it with a timeout (`dispatchOnce`, lines 343–357 at this snapshot), and the pong stands ready in the ping callback (`xdgWmBasePing`, registered at line 283). Compose what runs. State the design plainly in the file's doc-comment: display events are serviced between commands, and keyboard input **from the window** stays deferred to SLC-2b.

## Edit 3 — The ceiling, spoken in the window

The transcript's bound is `max_transcript_bytes = 65536`. At that edge today, `transcriptAppend` prints an invitation at the terminal and drops the bytes — graceful at a console, a quiet freeze in a window that renders the transcript: alive underneath, frozen to the eye. So the ceiling speaks in the frame itself. When `transcript.full` holds, the app writes the status row — one short honest line naming the ceiling and the way onward (for example: `transcript full — earlier lines still ran; :quit to close`) — so the surface keeps changing and the eye is told. Bound the status row's length like everything else, with the bound named.

## Edit 4 — The scripted-session witness, with a golden

Add a headless witness — `tools/slc2a_ring3_session.rish` or a headless test — that drives a **bounded scripted session** through `runOneInput` (a fixed handful of lines, including a `:recall`), building the real `Transcript`. Assert, in order:

- the composed final lines equal **hand-written expected lines, string for string** — the golden, pinned by hand, so the oracle is never only checking itself;
- `sig_final` equals the signature of that same expected rendering — the mirror reflects the session correctly;
- `sig_1 != sig_2` across the first two steps — the mirror tracked the session as it grew;
- **the ceiling phase:** feed inputs past `max_transcript_bytes` and assert the composed frame still changes — the status row appears, and the frame's signature differs from the frozen-transcript frame. The silent freeze made loud, then made impossible.

Reuse `signatureFromLines` from the Ring 2 surface. Bound the script — no open loop. Wire it into `tools/parity.rish` (138 → 139).

## Edit 5 — The metal confirmation

Running the drawn-terminal app on GNOME Wayland: type commands at the terminal and watch the window mirror the growing session live; leave it idle for a long minute and watch it stay responsive, the pong flowing; fill past the ceiling and watch the status row speak; exit clean on end-of-input.

## Edit 6 — Hold the discipline

- The app lives above the modules; Brushstroke gains no dependency on Rishi, and Skate stays in `brushstroke/`.
- TAME: unqualified `assert`; fixed widths with the bound asserted before any `@intCast`; `sessionLines` bounded by `rows`; the poll loop bounded by end-of-input and the quit signal; the transcript bounded at `max_transcript_bytes`; the status row bounded and named; the `full` flag's invariant stated where the struct lives.

## Verify

- The four SLC-1 witnesses are green after the extraction — nothing moved.
- The Ring 3 witness is green: golden lines match string for string, `sig_final` matches, `sig_1 != sig_2`, the ceiling phase is loud; bounded.
- `rye build` clean; `tools/parity.rish` green on metal at 139.
- On GNOME Wayland: the drawn terminal mirrors a live typed session, stays responsive through idle, speaks at the ceiling, and exits clean; the terminal `rishi`, default, and selftest paths are unchanged.

## Propose, Then Confirm

Gate every irreversible step — especially the **Pond genesis** (`pond/apps/drawn_terminal.rye`, a new folder), the **Rishi public surface**, and the **extraction diff** itself. Show the diff and wait for Kaeden's word before writing.

## Record and Push

Commit as one honest unit — the Rishi extraction and projection, the drawn-terminal app, the witness, the parity wiring, and the session log. Log at `session-logs/archive/20260701/20260701-231512_slc-2a-ring-3-session-mirror.md`: the live session mirrored in the window, the window answering the desktop between commands, the ceiling speaking, the scripted-session witness green at 139 with its golden, Pond born from its first application, and the supersession of the `205712` bench copy named. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

## Before You Move On — Recommend the Next Step

End with one line: *"Recommend: check in with Claude — Amber's first ring as the coming season's spine (one directory, one drive, one signed record, one verifying fold, one hand-verified golden), with SLC-2b and the kernel-direction ruling weighed once that spine beats."*

---

## Definition of Done

- [ ] Rishi accretes `pub runOneInput` (meta-commands included, delegating plain lines to `runInputLine`), `pub` `Transcript`/`Env`/`History`, the `Transcript.full` flag with its invariant, and `pub sessionLines` (neutral strings, bounded by `rows`); the four SLC-1 witnesses green before and after — terminal behavior unchanged
- [ ] The drawn-terminal app composes Rishi and Brushstroke above both, at the placement confirmed with Kaeden at the diff (recommended `pond/apps/drawn_terminal.rye`); the loop polls stdin and the display fd together, dispatching display events between commands; each frame is session lines plus one app-owned status row
- [ ] The ceiling speaks: at `max_transcript_bytes` the status row names the ceiling and the way onward, and the surface keeps changing
- [ ] The scripted-session witness green and wired to parity (138 → 139): golden lines match string for string, `sig_final` matches, step signatures differ, ceiling phase loud, bounded
- [ ] Metal: live session mirrors in the window on GNOME, stays responsive through a long idle, speaks at the ceiling, exits clean; terminal/default/selftest unchanged
- [ ] Brushstroke gains no dependency on Rishi; Skate stays in `brushstroke/`; TAME held
- [ ] `rye build` clean; parity green on metal; propose-then-confirm honored on the Pond genesis, the Rishi surface, and the extraction diff; session log shipped; four remotes pushed; next step recommended
