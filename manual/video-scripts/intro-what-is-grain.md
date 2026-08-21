# Video Script -- "What Is Grain OS?" (Intro, ~2:40)

**Purpose:** the first video a newcomer watches. Zero prior knowledge assumed.
**Voice:** Kyri -- warm, plain, radiant civic. Second person ("you"), never a named person.
**Render notes:** built for **Remotion** (code-driven, on-brand terminal captures) or **HeyGen** (talking-head narration over the same captures). Each scene gives `[VISUAL]`, `[ON-SCREEN]` text, and `[VOICEOVER]`. Timings are targets. Every command shown is real and runs green in the template.
**License:** original script, this project's own. No third-party footage, music, or text.

---

### Scene 1 -- The hook (0:00-0:15)
`[VISUAL]` Black screen, a single cursor blinking. It types the word **grain** and the screen blooms into a field of small glowing points.
`[ON-SCREEN]` *What if the software running your life belonged to you?*
`[VOICEOVER]` Most of the software in your life is rented. It watches, it phones home, it can be taken away. Grain asks a different question: what if it were *yours*?

### Scene 2 -- What Grain is (0:15-0:45)
`[VISUAL]` A calm diagram: a single laptop, a phone, a small server, all connected by soft lines to one glowing point labeled "you."
`[ON-SCREEN]` *A personal operating system you own.*
`[VOICEOVER]` Grain OS is a personal operating system, written in a small language called Glow. It runs on your own machines -- a laptop, a phone, a little server -- and it keeps your identity, your data, and your keys in your own hands. It descends from Urbit's ideas about owned identity, and walks its own road: custody first, civic by design.

### Scene 3 -- The three promises (0:45-1:20)
`[VISUAL]` Three cards flip in one at a time.
`[ON-SCREEN]` *1. Bounded & proven - 2. Custody first - 3. Plain text*
`[VOICEOVER]` Grain makes three promises. First -- it is *bounded and proven*: every module names its limits and asserts them, and a witness proves each one runs correctly before you trust it. Second -- *custody first*: your keys are yours, sharded and kept by your own hand, never uploaded to someone else's cloud. Third -- *plain text*: your records are simple, readable files you can open in any editor, today and in ten years.

### Scene 4 -- See it work (1:20-1:55)
`[VISUAL]` A real terminal. Three commands type themselves; the last prints a green **GREEN** banner.
`[ON-SCREEN]`
```
env RYE_ZIG="$PWD/vendor/zig-toolchain/zig" rye/bin/rye build scribe/reader.rye -femit-bin=scribe/bin/reader
scribe/bin/reader selftest
rishi/bin/rishi run tools/scribe_dashboard_witness.rish
```
`[VOICEOVER]` Here's the whole rhythm. You build a module. You run its selftest. You run its witness -- and it goes green. Build, prove, green. That loop is the heartbeat of the whole system, and you'll run it in your first hour.

### Scene 5 -- A tour of the modules (1:55-2:20)
`[VISUAL]` The field of points from Scene 1; a few light up and name themselves as spoken.
`[ON-SCREEN]` *kumara - vault - scribe - basin - comlink - pond*
`[VOICEOVER]` Grain is many small, warmly-named pieces. **Kumara** is who you are -- your keys. **Vault** keeps your secrets safe across fire and decades. **Scribe** reads your records. **Basin** watches the system's health. **Comlink** is the wire between your machines. **Pond** runs your apps. Each is small enough to understand, and each proves itself.

### Scene 6 -- Why it's built this way (2:20-2:35)
`[VISUAL]` A slow pull-back: the single point becomes one of many, each glowing independently -- a quiet constellation.
`[ON-SCREEN]` *For families, collectives, and civic builders.*
`[VOICEOVER]` This isn't built to scale a platform. It's built for a person, a family, a small collective -- people who want the thing they run every day to actually belong to them.

### Scene 7 -- Call to action (2:35-2:40)
`[VISUAL]` Terminal: `git clone` of the public template; the repo name on screen.
`[ON-SCREEN]` *Clone it. Build a module. Watch it go green.*
`[VOICEOVER]` Clone the template, open the manual, and build your first module. Everything you need is in there, and it's yours.

---

## Production checklist
- **Terminal captures:** record real runs of the commands in Scene 4 against a fresh clone, so the GREEN banner is genuine.
- **Remotion path:** generate the scene components from this script; the on-screen code blocks become `<CodeBlock>` fills, the field-of-points is a simple particle component.
- **HeyGen path:** feed each `[VOICEOVER]` block as narration; overlay the terminal captures as B-roll.
- **Music:** original or licensed-for-reuse only -- never a copyrighted track.
- **Length:** trim to ~2:30 for retention; the three promises (Scene 3) are the keeper if you must cut.
