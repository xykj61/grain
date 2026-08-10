# Video Script — "How to Contribute" (Walkthrough, ~3:30)

**Purpose:** the third video, closing the trilogy. A newcomer who can build and prove a module now learns to write one the Grain way and send it back.
**Voice:** Kyri — warm, plain, radiant civic. Second person ("you"), never a named person.
**Render notes:** built for **Remotion** (code-driven captures) or **HeyGen** (narration over them). Each scene gives `[VISUAL]`, `[ON-SCREEN]`, `[VOICEOVER]`. Every command and code shape is real to the project. Record captures live so the GREEN banners are genuine.
**License:** original script, this project's own. No third-party footage, music, or text.

---

### Scene 1 — You're ready (0:00–0:20)
`[VISUAL]` A terminal beside an open editor showing a small `.rye` file.
`[ON-SCREEN]` *You can build one. You can prove one. Now write one.*
`[VOICEOVER]` You've built a module and watched it go green. The last step is the fun one: writing your own, the Grain way, and sending it back so it belongs to everyone. There's a discipline to it — and once you see it, it feels less like rules and more like care.

### Scene 2 — TAME, in one breath (0:20–0:55)
`[VISUAL]` Three words stack, each with a short line beside it.
`[ON-SCREEN]` *Safety first · Performance second · Joy third*
`[VOICEOVER]` The discipline is called TAME, and its priority is fixed: **safety first, performance second, joy third** — and when they pull against each other, safety wins. Safety here isn't a feeling; it's structural. Everything is **bounded** — every collection names its maximum. Everything is **asserted** — you state what must be true and check it. And every width is **explicit** — a `u32` says exactly what it holds. Code you can trust because it proves itself, not because it promises.

### Scene 3 — The shape of a module (0:55–1:40)
`[VISUAL]` The editor. The opening lines type in, then an assert with a comment above it.
`[ON-SCREEN]`
```
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

// invariant: a basin never holds more than its bound.
assert(self.count < capacity);
```
`[VOICEOVER]` Every module opens the same way — three lines that pull in the standard library, the assert, and print. Then, wherever something must be true, you say so: an `assert`, with a comment above it that names *why*. That comment is the discipline's heart — every assertion, every bound, every surprising choice earns a line that says the reason. You're not just writing code; you're writing down what you know.

### Scene 4 — Prove it before you claim it (1:40–2:10)
`[VISUAL]` The terminal runs a witness; a green banner prints.
`[ON-SCREEN]`
```
rishi/bin/rishi run tools/your_module_witness.rish
```
`[VOICEOVER]` A module isn't done when it compiles. It's done when its **witness** goes green. You write that witness alongside the module — a small script that asks your module the hard questions and reports green only when every one holds. Green before you claim it. Always. This is how the whole tree stays trustworthy: nothing is believed until something proves it.

### Scene 5 — The send (2:10–2:55)
`[VISUAL]` A commit message on screen: a short prefixed subject, a plain paragraph, a "Related" line.
`[ON-SCREEN]`
```
basin: a circular buffer, not a ring

A short, honest paragraph on what changed and why.

Related
The witness stays green; the doc updates in the same commit.
```
`[VOICEOVER]` When you send your work, the commit is a small piece of writing. The subject names the area it touches and stays short. The body says, plainly, what changed and why — no filler, no hedging. You keep the docs and the code in step, in the same commit. And you sign your work, so anyone can see it's really yours. Green before send; clear message; signed. That's the whole ceremony.

### Scene 6 — The flow (2:55–3:15)
`[VISUAL]` Four steps light up in sequence, each with a check.
`[ON-SCREEN]` *fork · build · prove green · send*
`[VOICEOVER]` So the path is short: fork the template, write your module and its witness, build it, prove it green, and send it — a clear, signed commit or a pull request. Four steps, the same four every existing module walked.

### Scene 7 — Welcome, builder (3:15–3:30)
`[VISUAL]` The repository page; the contributor list gains one more.
`[ON-SCREEN]` *Write it. Prove it. It's ours now.*
`[VOICEOVER]` That's it. The disciplines aren't a wall; they're the reason a stranger can trust what you wrote, and the reason you can trust theirs. Write a module, prove it green, and it belongs to everyone who runs Grain. Welcome — we're glad you're building.

---

## Production checklist
- **Live captures:** the witness run and the commit should be real from a genuine contribution branch.
- **Remotion path:** the `[ON-SCREEN]` code and commit blocks become `<CodeBlock>` components; the GREEN banner is a captured frame.
- **Tone:** frame the discipline as care, never as gatekeeping — the closing line does the emotional work.
- **Music:** original or licensed-for-reuse only.
- **Series bumper:** end with the same three-title card as videos one and two (What Is Grain · Build a Module · How to Contribute).
