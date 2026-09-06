# PLEAC 1.2 — The Gate That Speaks

**Language:** EN
**Stamp:** `20260727.141617`
**Chapter:** one — gates
**Desk:** `gate-say-u32.glow` · **Witness:** `tools/p/pleac_ch01_2_witness.rish`

*Written together by Keaton and Quin.*

---

**The task.** Recipe 1.1 discovered that a built gate answers by exiting clean — the value stayed inside the exit code rather than reaching stdout, so no witness could assert what a gate computed. This recipe gives the gate a voice: an answer spoken aloud, so from today every witness in the tree may assert a value rather than only an exit.

**The desk, four lines.** The same bartis shape, one new body word: `%-  say  sample`. In Glow, `say` is now a closed call gate; the lowerer answers it with a **speaking main** — the sample is parsed, the gate runs, and the answer streams to stdout through the exact idiom the shell's own `do_say` uses: `std.Io.File.stdout()` with the two-argument `writeStreamingAll(io, line)`. `say` is argv-only by design; the fixture road refuses it honestly.

**What accreted to the kitchen, three touches, all additive.** The bartis parser's closed-gate roster learned `say` (and its barket twin learned it too, for symmetry's day); the lowerer gained `emit_argv_speaking_main` beside — never inside — the existing mains, so recipe 1.1 and the whole 530-strong collection regress green untouched; and the runner's stem roster admitted `gate-say-u32`.

**Run it.**

```
rishi/bin/rishi run tools/g/glow_run.rish edu/pleac/ch01/gate-say-u32.glow 21
./glow/bin/gate-say-u32 21        # prints: 21
rishi/bin/rishi run tools/p/pleac_ch01_2_witness.rish
```

**The green line.** `GREEN: pleac 1.2 — the gate speaks; every future witness may now assert a value.`

**Findings for the kitchen.** One, and it is a door: `say` speaks the *sample* today because a bartis body holds one call. **Composition — speak the answer of another gate, `say (double sample)` — is recipe 1.3's whole subject**, and it will teach the lowerer its first nested body.

*May every value that matters have a voice, every voice cost one small accretion — and the next recipe teach the gates to sing in twos.*
