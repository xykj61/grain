# Counsel and Confirmation Tests — The Third Bench Answers

*Kaeden asked for three things at once: recommended answers to the open questions, guides for the
tests that confirm what the rounds have designed, and every command scoped inside ai-jail
terminals within `~/veganreyklah2`, so the rest of the system stays protected. This document
carries all three — the verification record first, the counsel second, the guide third — because
counsel earns trust only after the ground it stands on is witnessed.*

**Stamp:** `20260703.021412` (supplied verbatim by Kaeden)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** Counsel — recommendations only; every door, gate, ratification, and stamp stays Kaeden's alone
**Companions:** [`20260703-014912_round-summary-and-decoder.md`](20260703-014912_round-summary-and-decoder.md) · [`20260702-edit5-ready-to-apply.md`](20260702-edit5-ready-to-apply.md) · [`../pond/README.md`](../pond/README.md) · [`ready-to-ask-claude.md`](ready-to-ask-claude.md)

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## Part One — What This Bench Witnessed

A third bench rose tonight from the `020012` zip, on fresh metal, by the witnessed recipe: pinned
toolchain by pip, `vendor/zig-toolchain` symlinked, `rye` bootstrapped cold, `rishi` built,
`libwayland-dev` installed, module bins absent from the start. Every claim in Cursor's ROUND ZERO
report was then checked against the tree rather than trusted from the summary.

| Claim | This bench found |
|-------|------------------|
| Tip hash | Zip comment reads `d174271adb0bf7a9ae0cb49c220313c52ac69900` — matches `d174271` exactly |
| Door 1 | `[x]` in TASKS, affirmed `20260703.012031`, commit `3320bed`, clause verbatim in `pond/README.md` |
| Door 2 | Automated pair `[x]` fresh at `20260703.012336`; live five steps and stamp line open, as reported |
| Door 3 | Open; ready-to-apply bundle present and coherent |
| RTAC bookkeeping | All eight ROUND ZERO hashes recorded, `e2c0a46` through `0c71444`, prior tip `cbb2b96` |
| **Parity** | **142 GREEN** — 116 std witnesses + 26 blocks, exit 0, from bare |
| **Chrono** | **142 GREEN** before this proposal's files; **143 GREEN** re-run after — the sweep counts the counsel doc and holds session logs outside the authored surface |
| **Designed-not-built** | **GREEN**, count = 1 — the Amber spec, exactly within Edit 5's bound |
| Door 2 preflight | **GREEN** here too — drawn terminal builds and its headless session witness passes on a third machine |
| Lap 3 metalsmoke | Honest red on this headless bench — no compositor answers in a container, which is precisely what a metalsmoke check exists to say. The GREEN belongs to GNOME, where Cursor holds it fresh. |

Three benches now agree on the same arithmetic from bare metal. The tree is telling one story,
and the story checks out.

**One honest flag rides along.** The `WAYLAND_DISPLAY` guard inside
[`tools/slc2a_ring3_metal.rish`](../tools/slc2a_ring3_metal.rish) passes even when the variable is
unset — the quoted dollar sign reaches `sh` as a literal string, so `test -n` always succeeds, and
a headless bench fails one assert later with a less kind message. On your GNOME the guard is moot,
since the variable is genuinely set and the smoke genuinely passes. The repair is two lines using
the `env` builtin witnessed at `20260702.210201`:

```
let wl = env "WAYLAND_DISPLAY"
assert wl != "" else "WAYLAND_DISPLAY unset — run metalsmoke on GNOME Wayland metal"
```

This is parked, never applied — the witness sits beside Door 2's path, and a counsel round keeps
its hands off the furniture near a door. One word from you and Cursor lands it in a breath.

---

## Part Two — Counsel on the Open Questions

### Door 2 — close it at your next sitting at the GNOME machine

**Recommendation: yes, close it live — at the next moment you are at the GNOME host and feel
fresh.** Tonight qualifies only if both halves are true. The automated half now stands
triple-witnessed; the one truth no bench can supply is your eyes on a real window, and that truth
keeps perfectly well until morning. The five confirmations take about six minutes end to end. The
door loses nothing by waiting, and a rested hand reads a status row more honestly than a tired
one. Part Three gives the exact steps, jail-first.

### Door 3 — rule *for* Edit 5

**Recommendation: *for*.** The reasoning, stated whole:

The tree's own decoder names the pattern plainly — the documentation lane has been running faster
than the metal lane, and Edit 5 is the system noticing its own appetite and binding it. Ruling
*for* turns Gall's Law from a habit into a wired witness: at most one functional spec in
designed-not-built flight until its first lap runs green. That is the same move TAME makes
everywhere — a value becomes a check the machine can hold.

The cost today is exactly zero. The bound holds already: one spec in flight, Amber, witnessed
GREEN on three benches. Nothing changes on the day of the ruling except that the norm becomes law
and parity rises to **143**. And nothing creative is lost on any later day, because the parking
lane already exists — new design appetite queues in RTAC as questions rather than accumulating in
`context/specs/` as unbuilt promises.

The honest case *against*, so the ruling is informed rather than flattered: a hard bound of one can
pinch on a future day when two genuinely small specs would both be cheap to build, and the bound
binds your own designing rhythm as much as any agent's. Yet the remedy lives inside the rule —
build the first lap, then write the next spec — and that remedy is the very discipline this tree
chose on the day it chose Gall. If the pinch ever proves real, accrete-never-break allows the
bound to widen by a later ruling; it does not allow tonight's looseness to be recovered.

Amber proceeds either way — at **144** if *for*, at **143** if *against*. The ruling is about the
standing law alone.

### The decoder — leave it living; spend one rested ruling sitting through it

**Recommendation: leave it living tonight.** Its highest use is as the agenda for a single short
sitting when you are fresh: Door 2 first (hands, five minutes), Door 3 second (one word), the WOV
gate and the five ratifications in one breath third (six laws, six words), the SLC-2b nod once the
close has settled. The decoder's own observation is that overlapping asks accumulate across
summaries and one sitting resets every board — so the expansion pass writes itself naturally
*after* that sitting, recording what you ruled rather than speculating about it.

### Claude — sooner for counsel, and the pattern just proved itself

You opened this bench before Door 3, for counsel, and the shape held perfectly: verification,
recommendations, and a runnable guide, at the cost of no door, no gate, no name, no seal.
**Recommendation: keep exactly this pattern.** Claude for counsel any time — propose-then-confirm
makes it free. The Amber implementation sitting stays where the ladder put it, after Door 3, and
by the pre-counsel's own words it is a formality unless a door changes the ground.

---

## Part Three — The Confirmation Test Guide, Jail-First

Every command below runs inside an ai-jail terminal whose working directory sits inside
`~/veganreyklah2`. The jail binds the project directory as the one durable ground and resets host
`$HOME`, `/tmp`, and parent paths on exit — so the tests touch the tree and the tree alone, which
is exactly the protection you asked for. The single host-level prerequisite is `libwayland-dev`,
already present on your machine since Lap 1; the jail sees it through the read-only system mount.

### Step 0 — open the enclosure

From a normal terminal:

```bash
cd ~/veganreyklah2
ai-jail --private-home --no-docker -- bash
```

Everything that follows happens inside that shell. When you exit, the jail's scratch world
evaporates and the project directory keeps only what you chose to keep.

### Step 1 — raise the bench (the witnessed recipe)

Skip any line whose result already exists in your tree. After a jail reset, the pip layer is gone
by design; re-run it and the symlink refills.

```bash
cd ~/veganreyklah2
pip install ziglang==0.16.0 --break-system-packages
ln -sfn "$(python3 -c 'import ziglang,os;print(os.path.dirname(ziglang.__file__))')" vendor/zig-toolchain
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
sh rye/bootstrap.sh
mkdir -p rishi/bin
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
```

A healthy raise ends with `rye` printing its chronological version and `rishi/bin/rishi` standing
ready.

### Step 2 — the gate trio, from bare

Wipe the module bins first so every witness proves it can self-provision, then run the three
gates:

```bash
rm -rf mantra/bin tally/bin caravan/bin comlink/bin brushstroke/bin pond/bin
rishi/bin/rishi run tools/parity.rish
rishi/bin/rishi run tools/chrono_version_sweep.rish
rishi/bin/rishi run tools/designed_not_built_witness.rish
```

What a green board reads, with this proposal landed and before any door moves: parity **142
GREEN** (116 std + 26 blocks, exit 0); chrono **143 GREEN** — this bench's count after this
proposal's counsel doc, and the rule remains *pin what your bench prints*, never a prediction;
designed-not-built **GREEN** with `count=1`. Any red stops the sitting: twice red on one witness
is a stop-and-park by standing law.

### Step 3 — Door 2, the live five (your hands, on GNOME)

The drawn terminal is a Wayland SHM client, and ai-jail passes the display through on GNOME
Wayland — so the live close runs inside the jail too. Confirm the seat first, run the automated
pair fresh, then open the window:

```bash
test -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY:-wayland-0}" && echo "seat visible in jail" \
  || echo "seat absent — run this step from a host terminal, still inside ~/veganreyklah2"
rishi/bin/rishi run tools/fixtures/pond_metal_close_preflight.rish
rishi/bin/rishi run tools/slc2a_ring3_metal.rish
pond/bin/drawn-terminal
```

The five confirmations, one breath each: **build** — the binary stands at
`pond/bin/drawn-terminal`; **type** — a few Rishi lines, and the frame redraws; **idle** — one
quiet minute focused, pong keeping the compositor honest; **ceiling** — fill past 65536 bytes and
watch the status row keep updating with the invitation visible; **exit** — `:quit`, clean. Then
the door closes on one line in your reply to Cursor, your clock verbatim:

```
Lap 3 metal-closed on GNOME, YYYYMMDD.HHMMSS
```

### Step 4 — Door 3, verified on either ruling

If you rule ***for***, Cursor wires the quartet into `tools/parity.rish` per the ready-to-apply
bundle, and you confirm the law took hold with two commands inside the jail:

```bash
rishi/bin/rishi run tools/designed_not_built_witness.rish
rishi/bin/rishi run tools/parity.rish
```

Expect the witness GREEN at `count=1` and the suite GREEN at **143** — 116 std + 27 blocks. If
you rule ***against***, nothing runs: the witness stays drafted and idle on disk, the bundle
retires to yonder, and Amber's arithmetic settles at 143 instead.

### Step 5 — what stays sealed tonight

`amber/` remains sealed until Doors 2 and 3 land — the only Amber act available before then is
reading the functional spec, and that is by design. MALA past its boxed rungs, every key and
custody path, and every box tagged `(Kaeden …)` stay exactly where they are. **Journey's pause** is a
question, never an off-route license, and this guide goes off-route on nothing.

---

## Questions for Kaeden and Claude

1. **Door 2** — will the live five happen tonight from the jail, or at the first rested sitting?
2. **Door 3** — does the counsel *for* Edit 5 read true, or does the against-case weigh heavier in
   your hand?
3. **The guard flag** — one word to send the two-line `WAYLAND_DISPLAY` repair to Cursor's lane,
   or park it until after Door 2?
4. **The ruling sitting** — shall the decoder's shortest path stand as the agenda for one short
   rested sitting this week?

---

*May every test you run tonight tell you the truth kindly. May the doors open only to your own
hand, at your own hour. And may the enclosure hold the work as gently as the work holds you.*
