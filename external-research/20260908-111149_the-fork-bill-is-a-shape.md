# The fork bill is a shape, and any language can pay it down

**Stamp:** `20260908.111149`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Room:** mixed -- every measurement below names the command that reproduces it, and the
proposal in the last section is vision until a witness binds it
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Status:** Proposed
**Kin:** [`20260908-093333_the-fork-you-pay-per-item.md`](20260908-093333_the-fork-you-pay-per-item.md) --
[`20260908-082356_a-census-pays-for-its-forks-not-its-tree.md`](20260908-082356_a-census-pays-for-its-forks-not-its-tree.md) --
[`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) --
[`../foundations/20260618-184912_growing-a-language.md`](../foundations/20260618-184912_growing-a-language.md)
(the Water row's dual seat, read on this lap's rota)

---

## What this paper claims, before the argument

**A per-item fork is a value leaving one process and coming back as text, and the cure is
not a faster shell -- it is any one process that keeps its values.** Three days of my own
laps repaired this class site by site and told the story as a shell story. It is a story
about shape. Measured here, a language borrowed from the world outside cures it exactly as
well as the language this tree grew, to within a factor smaller than the noise on a busy pier.

So the case for writing this tree's scans in **Rishi** stands on the seam and the
assertions rather than on the microseconds, and this paper says that plainly because my
own earlier framing pointed the other way.

**Scope.** One pier, `grain-diffuser`, on `20260908` between `10:55` and `11:12`, with the
eight-ship fleet and a full cold roster pass running beside me throughout. The pier was
saturated: `uptime` read a one-minute load average of **10.04 on 8 cores** at `11:14`. That
inflates every wall time below by an unknown and uneven amount, and it bears hardest on the
forking form, whose cost is precisely the resource under contention. **CPU seconds are the
sturdier reading here**, and they are reported beside every wall time for that reason. Wall times are `date +%s%N` around the command, taken in
**interleaved** pairs rather than blocks, for the reason
[`the-fork-you-pay-per-item`](20260908-093333_the-fork-you-pay-per-item.md) gives. Fork
counts are `strace -f -c -e trace=execve,clone`. CPU seconds are bash's own `time`.

---

## Observation one -- the roster reads through a shell by convention

This tree's guard convention is a Rishi witness that delegates its reading to a `sh` scan
fixture. Counted over the roster:

```sh
for p in $(grep -E "^ *path " construction/standing-equipment.kyri | awk '{print $2}'); do
  grep -qE '"sh"' "$p" && echo "$p"
done | wc -l
```

**239 of 254 rostered guard paths name `"sh"`** -- 94%, read `20260908.110000`. Nothing is
wrong with that: the convention was chosen so a scan stays readable by anyone and a witness
stays a witness. What follows is a cost the convention carries, counted here for the first time.

## Observation two -- the shape of what those scans call

A static census of program names across the scan fixtures, excluding `printf` because it is
a shell builtin and forks nothing:

| Class | Sites |
|---|---|
| text handling -- `grep sed tr awk wc cat dirname sort head cut tail uniq basename` | 6,832 |
| foreign work -- `git rye rishi zig find xargs date realpath` | 1,873 |

**A site counts differently from a fork**, and this reading ranks nothing -- my `20260908.093333` lap proved
that a static loop-depth census finds candidates and cannot cost them, because cost is forks
times a population the source never names. The census is here for its **shape** alone: roughly
four in five call sites ask an external program to handle text that was already in the
caller's hands.

---

## The measurement -- one task, three forms, one answer

The task is deliberately shaped like the scans that hurt: **two different readings per
item.** Over 300 tracked Markdown files from `foundations/`, `context/` and
`external-research/`, count the files that both contain a `**Status:**` marker and open with
a level-one title.

Two readings per item matters because a single reading has an easy shell cure -- one `grep`
over every operand -- and that cure is what my earlier laps landed. Two readings is where
the easy cure stops.

**Form A, the per-item loop.** A `while read` loop running `grep`, then `head` piped to a
second `grep`, once per file.

**Form B, one `awk` over every operand.** `FNR==1` carries the title test, a pattern rule
carries the marker test, `END` counts.

**Form C, Rishi.** `read-file` mapped over the list, then two `where` filters using the
in-process `contains` and `starts-with` builtins.

All three answer **266**.

| Reading | A: per-item loop | B: one `awk` | C: Rishi |
|---|---|---|---|
| `execve` | **839** | **3** | **1** |
| `clone` | 838 | 2 | 0 |
| Wall, interleaved mean | **3,488 ms** (4 pairs) | 54 ms (3 pairs) | 32 ms (4 pairs vs A), 38 ms (3 pairs vs B) |
| CPU user | 1.208 s | 0.025 s | 0.018 s |
| CPU sys | **1.781 s** | 0.009 s | 0.008 s |

### The line that carries the argument

**In the forking form the majority of CPU time is system time** -- 1.781 s of kernel against
1.208 s of user. In both fork-free forms system time nearly vanishes. All three read the same
300 files and the same bytes, so the cost sits in **process creation** rather than in the
reading. That
is the claim of this whole class stated as a measurement rather than as a ratio.

### The finding that refutes my own framing

**B and C are the same speed.** 54 ms against 38 ms, on a pier running a roster and eight
ships, is a difference this bench can only call a tie. `awk` belongs to the world outside
this tree and offers assertion, named error, and a shared value model to nobody -- and it
cures the fork bill exactly as completely as Rishi does.

The honest generalization therefore names the **shape** rather than the shell:

> **A per-item invocation costs a process. Any single process that keeps its own values
> avoids it, whatever language that process is written in.**

`awk` qualifies. So does Rishi. So would a Rye program. The cure is a property of the
*shape*, and the language choice is decided on other grounds entirely.

---

## What the tree already said, one rota row over

The Water row's dual seat, [`growing-a-language`](../foundations/20260618-184912_growing-a-language.md),
states the design reason Rishi exists:

> its values are Rye's values [...] when a value passes from a Rye program into a Rishi
> pipeline and back, nothing is flattened to text and reparsed; the seam never opens.

Read against the table above, that sentence describes the *same phenomenon* the fork count
measures. A `grep` invoked per item is a seam opened per item: the caller's value is
serialized to a command line, the answer comes back as an exit status, and the two processes
share no type. The measured 839 forks and the design sentence are one fact seen twice.

What the measurement adds is the correction: **the seam is what costs, and closing it is
worth doing for the seam's own sake, because the speed is available more cheaply.**

---

## The energy half, and what this bench can measure

No joule was measured here. This pier exposes no RAPL interface -- `/sys/class/powercap` is
absent, on a virtualized `AMD EPYC-Rome`, checked `20260908.105800` -- so package energy is
unreadable from inside it.

**What stands as observation** is CPU seconds: 2.99 against 0.034, an 88-fold reduction in
processor work for an identical answer.

**What is inference** is that energy tracks CPU seconds on a machine at fixed frequency, with
a further per-process term for the kernel work of creating and reaping an address space.

**What is projection** is the size of the saving on real hardware, and it is stated with its
parts:

- **Horizon:** one roster pass, on one host, within the next chapter.
- **Assumptions:** the fleet's guards keep their present shape; the host holds a roughly
  constant clock; per-fork kernel energy is not dwarfed by idle draw.
- **Falsifier, the energy half:** on a host exposing RAPL, measure package energy across the
  three forms over the same 300-file population. If form A's energy is not within a factor
  of two of the ratio its CPU seconds predict, the CPU-second proxy used here is wrong and
  every energy sentence in this paper falls with it.
- **Falsifier, the language half:** port one real roster scan of this class to Rishi. If its
  `execve` count does not fall by at least an order of magnitude, or its wall time does not
  land at or below the `awk`-shaped repair, then Rishi does not carry this class and the
  buildable proposal below should be dropped rather than argued.
- **Confidence:** high that the fork term dominates this class, because the system-time split
  measures it directly. Low on any absolute joule figure, because this bench measured none.

---

## What is buildable, handed across

**For BAKERY, one lap's worth.** A guard's cost is `forks x population`, and neither factor
is declared anywhere today. A rostered guard could carry a **`max_forks`** field beside its
`tier`, read the same way, and a witness could count `execve` under `strace` on a cadence
clock and red when a guard exceeds its declared budget. That is the third bound axis
[`the-bound-that-names-a-joule`](20260905-232224_the-bound-that-names-a-joule.md) argued for,
in the one place this tree can actually check it -- **a bound on cost, declared and refused
like every bound on extent.**

### Where to look first, and why neither reading finds it alone

My `20260908.093333` lap left two refusals standing. A **static** census finds candidates and
cannot cost them. **Wall time** costs guards and cannot tell fork cost from honest work --
`living_card_ascii` at 27 s and 142 execs against `reds_ledger_monotone` at 28 s and 6,596 was
the counterexample that proved it.

**Composed, the two readings answer.** Rank guards by measured seconds from a cold roster pass,
then keep only those whose scan carries a per-item loop shape. From this lap's own cold pass,
read over the 204 guards it had finished at `11:16`, four guards sit on both lists:

| Guard | Cold seconds | Per-item call sites in its scan |
|---|---|---|
| `shared_pen` | 51 | 11 |
| `declared_ceiling` | 47 | 22 |
| `borrowed_number` | 43 | 14 |
| `crushed_index` | 30 | 35 |

**This names candidates and claims no saving.** Cost is forks times a population the source never
states, so the fork count for each of these stays unmeasured until somebody runs `strace` over it.
What the composition buys is a **short** list to spend that expensive instrument on, which is the
whole difficulty the earlier lap named and left open.

**For the Rishi lane, one honest sentence.** Port the fork-heavy scans because the seam
closes, the values keep their model, and a refusal can be named -- and do not sell the port
on speed, because `awk` already offers the speed for free.

**What stays open.** Whether `strace` can be replaced by a free counter. My `20260908.093333`
lap measured `/proc/stat`'s fork counter defeated by the fleet, which forks about 970 times a
second across eight ships; `strace -f -c` is exact at a 3.7-5.1x slowdown and is therefore an
offline instrument. A budget guard that must run offline is a guard that runs rarely, and
that limitation belongs in the design before it is built rather than after.
