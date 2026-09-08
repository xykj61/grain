# The clock nobody chose -- falsifier one run against the roadmap, and the suspend decision already made sixteen times

**Stamp:** `20260908.025249`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **research for understanding**, with one checkable exhibit: every figure below is a count taken on this tree at this stamp, and the paper states which readings are counts and which are my classification
**Parent:** [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) -- this runs its **first** falsifier, the last of the three left unrun
**Kin:** [`20260908-021719_the-layer-was-already-there.md`](20260908-021719_the-layer-was-already-there.md) (second falsifier) -- [`20260908-005732_the-share-that-is-not-a-property-of-the-parts.md`](20260908-005732_the-share-that-is-not-a-property-of-the-parts.md) (third)

## What was asked, and the one-line answer

The parent paper argued that a bound naming a joule -- a maximum on how often a component may
wake -- is worth writing, and named three ways it could be wrong. The first:

> **The target might be plugged in.** *Falsifier: name the deployment. Given a roadmap holding
> only mains-powered targets, this paper is enthusiasm.*

**It fails.** Of the 33 living and hand-seated waymark ladders in
[`../construction/waymark-registry.bron`](../construction/waymark-registry.bron) at this stamp,
**13 name a hardware deployment target, and 7 of those are battery-primary** by my reading of the
ladders' own seated descriptions. The roadmap holds battery targets, so the first falsifier fails on its own terms.

That answer took twenty minutes and is worth one paragraph. **The reading that took the rest of the
lap is the one the falsifier did not ask for**, and it is below.

## Observation: the census

The registry is the sealed record of every mark ever drawn -- 28 `living`, 5 `hand-seated`,
4 `abandoned`, counted from `grep "^mark"` at this stamp. The seated descriptions are in
[`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md). Twenty of the 33 name language, ledger, naming, or front-door work rather than hardware; a power argument reaches them only through whatever runs them.

The 13 that do name hardware, with the ladder's own words quoted and my classification marked as
such:

| Mark | The ladder's own words | My reading |
|---|---|---|
| **HAWM** | "Pixel / GrapheneOS SLC" | battery |
| **ZETA** | "Glass English QWERTY keyboard" -- rides HAWM's glass | battery |
| **HUNK** | "Hardware & Right-to-Repair ... beneath the parts marketplace and Photos app" | battery |
| **DREY** | "the Mikrophone firmware ... a bounded capture held only while powered, provably dissolved on power-down" | battery |
| **TACT** | "Ship-Pilot - publishing - Grainphone - commerce" | battery |
| **LOCA** | "the macOS native surface ... and the iOS door" | battery |
| **SETU** | "USB hearth carry Glass<->Desk" (hand-seated) | battery, one side |
| **LULU** | "glass hearth display - short home - Wired Glass" | mixed |
| **ALES** | "Lotus creative suite ... XLR - USB-C - guitar" | mixed |
| **JARL** | "Kumara - d12/d60 topology - Comlink - settlement" | mixed |
| **WADE** | "Vultr SEA IaC ... Swift macOS Dock shell" | mains-leaning |
| **BUHR** | "Realidream - Quin voices - MCP-in-Bron" | mains-leaning |
| **FORA** | "sandbox/testnet/localhost Comlink p2p constellations ... run from inside the jailed pier" | mains |

**DREY is the sharpest single entry**, and it needs no classification from me: a capture "held only
while powered, provably dissolved on power-down" is a device whose power is expected to go away.
A mains-only roadmap leaves that sentence unwritten.

## Observation: what actually runs today

[`../construction/ITINERARY.md`](../construction/ITINERARY.md) line 303 names this pier's two
hosts: **a Mac**, and **Vultr Dallas** (`45.32.204.176`, AMD 4/8/180). One laptop, one rented
server. So the roadmap is battery-heavy and the running deployment is a laptop and a mains VPS --
which is the ordinary shape of a project whose targets are ahead of it, and worth saying plainly beside the roadmap census.

## The thing the falsifier did not ask

A wake bound is a *policy about suspension*. So the question underneath "is the target plugged in"
is: **when this code rests, what does it think a second is?** That question has an answer in the tree already, written sixteen times, and my greps found the explanation missing.

**Every `std.Io.sleep` call in authored Rye passes the same clock.** Counted tree-wide at this
stamp, excluding `vendor/`:

```
grep -rn "std.Io.sleep" --include=*.rye . | grep -v vendor | sed 's/.*), //' | sort | uniq -c
     16 .awake) catch {};
```

Sixteen sites across seven files, and the third argument is `.awake` at every one. The two
`std.Io.Timestamp.now` calls in the tree (`caravan/harvest.rye:519` and `:557`) pass `.awake` too.

**`.awake` names a clock rather than a wakefulness policy.** Zig's own documentation in
[`../vendor/zig-toolchain/lib/std/Io.zig`](../vendor/zig-toolchain/lib/std/Io.zig) lines 721-762
says what it selects:

- **`.awake`** -- "expresses intent to **exclude** time that the system is suspended." Linux
  `CLOCK_MONOTONIC`; macOS `CLOCK_UPTIME_RAW`.
- **`.boot`** -- "Identical to `awake` except it expresses intent to **include** time that the
  system is suspended." Linux `CLOCK_BOOTTIME`; macOS `CLOCK_MONOTONIC_RAW`.

So the third parameter of every rest in this tree is a decision about suspended time, and the
decision is: **do not count it.** A 2 ms rest on a device that suspends for an hour mid-rest
resumes and waits out its own remaining milliseconds.

**That is very likely the right choice.** A supervisor's rest paces work rather than measuring wall
time, and pacing should stop when the work stops. The finding is its **silence** rather than its correctness:

- **`Clock.boot` appears nowhere in authored Rye.** The alternative stands untaken and unrefused. (`grep -rn "\.boot\b"` returns fourteen hits, every one `constel.boot(...)`, most in `mycelium/` --
  a different function entirely, which is its own small lesson about grep as evidence.)
- **The choice stays unnamed in prose.** `grep -rni "monotonic|suspend|clock_boottime|wall.clock"` over
  `caravan/**.rye` returns **zero**. Sixteen sites, zero sentences.
- **TAME asks for the opposite.** *Say why: every named constant and every surprising design choice
  earns a comment that names the reason.* `note_rest_ms = 2` in `caravan/entrust.rye:145` carries
  its reasoning; the clock it is measured against waits for its own.

**And two sites leave the choice to the platform.** `caravan/subscribe_poll_service.rye:105` and
`:247` call `c.nanosleep` directly, which takes a `timespec` and no clock. Those two rests inherit
whatever the platform's libc picks. *This host leaves the answer unavailable: `man 2 nanosleep` returns nothing on this pier, so I state only what I measured -- the platform chooses, rather than the caller -- and leave the rest as an open reading rather than reciting it from memory.*

## Inference

**The suspend question is already decided in this tree, uniformly, and by default rather than by
argument.** Sixteen sites reached for the same enum value, which reads far more like the first call being copied than like sixteen deliberations. On a mains server the consequence stays below measurement. On six of the seven battery ladders above it becomes visible, and DREY's
firmware -- whose whole thesis is a buffer that dissolves on power-down -- is the place a clock
that ignores suspended time is most likely to surprise somebody.

**This strengthens the parent paper on a narrower footing than it claimed.** The parent argued for
a *new* bound naming a joule. What the tree actually shows is that the relevant decisions are being
made already, in the argument slot of an existing call, without a word. A comment costs one sentence and buys the reader the question; a bound costs a design round. **The cheap thing first.**

## Projection

**Horizon:** the first battery target that runs Caravan's rest loop -- HAWM's glass or DREY's
firmware, both of which reach it later.
**Assumption:** the seven battery ladders reach real hardware in the order the chapters name.
**Projection:** the clock choice will be revisited at that moment, under time pressure, by someone
reading sixteen identical call sites and no explanation.
**Falsifier:** a comment lands at the `note_rest_ms` declaration naming the clock and its reason,
before any battery target runs the loop. Then this projection is void and the cost is one sentence.
**Confidence:** moderate. The pattern -- a decision made in a parameter and explained nowhere -- is
what this lane has now found three laps running, in three different rooms.

## What is buildable, and what is not

**Buildable, for BAKERY, one sentence of code and one of prose:** a `// invariant:`-style comment at
`caravan/entrust.rye:145` beside `note_rest_ms`, naming `.awake` as `CLOCK_MONOTONIC`, saying that
a rest paces work rather than wall time, and naming `.boot` as the alternative deliberately left aside. Sixteen call sites then have one place to read.

**Buildable, and larger:** a guard holding the clock argument uniform -- every `std.Io.sleep` in
authored Rye passes the same clock, and a new site passing `.boot` reds until the comment above is
amended to say why. That is a one-leg scan over a grep this paper already wrote, and it is the
shape this tree calls a wall rather than a habit. I name it; I do not build it, because a guard over sixteen clean sites has yet to be proven able to bite, and its own control would have to plant the violation first.

**Not buildable from here:** the two `c.nanosleep` sites. Replacing them with `std.Io.sleep` is a change to a running poll service in another ship's lane, and the clock they currently use is the one fact this paper left unmeasured. That is a reading for whoever owns `subscribe_poll_service`,
handed over rather than guessed at.

## How this paper could be wrong

**The `.awake` uniformity might be deliberate and recorded in a room I left unread.** *Falsifier:
a design note, session log, or counsel piece stating the clock choice and its reason. My greps covered `caravan/**.rye` comments and code, and stopped short of the design rooms.*

**Sixteen might be too small a population to matter.** *Falsifier: show that the rest sites are
bounded by something upstream -- a single scheduler call, a supervisor tick -- so the clock is
chosen once in effect even though it is typed sixteen times.*

**The battery ladders might rest through another path entirely.** *Falsifier: a reading showing Caravan's rest
loop is host-side only by design, with the on-device surface resting through a different path.
The one measured link today is capability-table reuse in `linengrow/`, which imports
`caravan/capabilities.rye` and none of the resting modules -- so this falsifier stands closer to firing than the other two, and the honest reading is that the exposure is future rather than present.*

---

*May every parameter that decides something say so, and may the cheap sentence land before the
expensive round.*
