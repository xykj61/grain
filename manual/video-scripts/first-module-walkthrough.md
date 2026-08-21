# Video Script -- "Build Your First Module" (Walkthrough, ~3:20)

**Purpose:** the second video. A newcomer, fresh clone in hand, builds a module and watches it go green -- the whole heartbeat of Grain in one sitting.
**Voice:** Kyri -- warm, plain, radiant civic. Second person ("you"), never a named person.
**Render notes:** built for **Remotion** (code-driven terminal captures) or **HeyGen** (narration over the same captures). Each scene gives `[VISUAL]`, `[ON-SCREEN]`, `[VOICEOVER]`. Every command is real and runs green against a fresh clone -- record the captures live so the GREEN banner is genuine.
**License:** original script, this project's own. No third-party footage, music, or text.

---

### Scene 1 -- Where we are (0:00-0:20)
`[VISUAL]` A clean desktop, a terminal already open in a freshly-cloned `grain` directory.
`[ON-SCREEN]` *You have the code. Now let's make something prove itself.*
`[VOICEOVER]` In the last video, you saw what Grain is. Now you'll do the thing every Grain module does: build it, run its selftest, and run its witness -- and watch it go green. This is the whole rhythm. Once you have it, you have the system.

### Scene 2 -- The three tools (0:20-0:50)
`[VISUAL]` Three labels fade in beside small icons.
`[ON-SCREEN]` *rye builds - rishi runs - a witness proves*
`[VOICEOVER]` You'll meet three friends. **Rye** is the builder -- it turns a module's source into a running program. **Rishi** is the runner -- it drives witnesses, the small scripts that check a claim. And a **witness** is the proof itself: a script that asks a module hard questions and reports green only if every answer holds.

### Scene 3 -- Build a module (0:50-1:30)
`[VISUAL]` The terminal. One command types itself and completes.
`[ON-SCREEN]`
```
env RYE_ZIG="$PWD/vendor/zig-toolchain/zig" rye/bin/rye build scribe/reader.rye -femit-bin=scribe/bin/reader
```
`[VOICEOVER]` Let's build Scribe's reader -- the piece that reads Grain's own records. One command: `rye build`, the source file, and where to put the built program. The first time, Rye fetches its toolchain, so give it a moment. When the prompt returns, you have a real, runnable module. Nothing hidden, nothing remote.

### Scene 4 -- Run its selftest (1:30-2:05)
`[VISUAL]` The built binary runs; lines of plain-language checks scroll, ending in a green banner.
`[ON-SCREEN]`
```
scribe/bin/reader selftest
```
`[VOICEOVER]` Every module carries its own selftest -- the checks it makes on itself before it asks you to trust it. Run it, and read the lines: it parses a document, keeps each field as a slice into the source without copying, and tells one kind of record from another. At the end, one word you'll come to love: **GREEN**.

### Scene 5 -- Run its witness (2:05-2:45)
`[VISUAL]` Rishi runs the witness; a final GREEN line prints.
`[ON-SCREEN]`
```
rishi/bin/rishi run tools/scribe_dashboard_witness.rish
```
`[VOICEOVER]` The selftest is the module checking itself; the **witness** is a separate script checking the module from outside -- a second opinion you can read and re-run any time. Rishi drives it. When it prints green, you've proven not just that the code runs, but that it does what it claims. That gap -- between *runs* and *proven* -- is the whole point of Grain.

### Scene 6 -- What just happened (2:45-3:05)
`[VISUAL]` The three commands from Scenes 3-5 stack on screen, each with a green check.
`[ON-SCREEN]` *build - prove - green*
`[VOICEOVER]` Build, prove, green. You just ran the heartbeat of every module in the system -- the same loop that made the identity layer, the vault, and the whole toolchain trustworthy. There's no other magic. There's just this, repeated, honestly.

### Scene 7 -- Your turn (3:05-3:20)
`[VISUAL]` The manual's table of contents on screen; a cursor rests on "The Developer Guide."
`[ON-SCREEN]` *Pick a module. Build it. Watch it go green.*
`[VOICEOVER]` Now do it with another module. Open the developer guide, pick any piece, and run the same three steps. When you're ready to build your *own*, the guide walks you through it -- the opening lines, the asserts, the witness. Welcome to Grain. It's yours to build on.

---

## Production checklist
- **Live captures:** record real runs against a fresh clone; the first `rye build` will pause to fetch the toolchain -- trim that wait in the edit, but keep the real GREEN banners.
- **Remotion path:** the `[ON-SCREEN]` code blocks become `<CodeBlock>` components; the green banner is a captured frame, not a re-typeset graphic, so it's genuine.
- **Pace:** let each GREEN sit on screen for a beat -- it's the emotional payoff.
- **Music:** original or licensed-for-reuse only.
