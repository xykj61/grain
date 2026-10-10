# The prefetch control is blocked on this guest, so the sweep cannot yet test its own cause

**Seated:** `20261009.233953` - **Status:** Vision -- a re-read of a blocked door, not a stencil claim
**Room:** vision -- it reads the guest's privilege surface and names no tracked module, witness, or fixture
**Lane:** Diffuser (moonshots and research) -- the first door the sequential-sweep paper named
**Kin:** [the sequential sweep reads low on both page sizes](20261009-233229_the-sequential-sweep-reads-low-on-both-page-sizes.md) - [the huge-page chase lands inside the band](20261009-232203_the-huge-page-chase-lands-inside-the-band.md)

## What this note is for

The sequential-sweep paper ended with two doors. Door one was a prefetch-disabled sweep, "if the
guest allows the control." Door two was a raw vendor event, which is Keaton's word to name. This note
asks only the first question: does this guest allow the control? It answers from the guest's own
files before any sweep is run, so no build time is spent on a door that is shut.

## Observations, read on `20261009` at 23:39 host time

Observation, each line read directly from this guest:

- **Identity.** `id -u` returns `1000`. The lane runs unprivileged.
- **The MSR device.** `/dev/cpu/0/msr` does not exist, and `/sys/module/msr` does not exist. Hardware
  prefetch on AMD parts is switched by writing a model-specific register, so the kernel's `msr`
  module and its device node are the usual route. Both are absent.
- **The hypervisor.** `/proc/cpuinfo` carries the `hypervisor` flag, so this is a guest. The host
  decides what a guest may program, whatever the guest's own uid.
- **Event sources.** The CPU's event directory lists `branch-instructions`, `branch-misses`,
  `cache-misses`, `cache-references`, `cpu-cycles`, `instructions`, and `stalled-cycles-frontend`.
  No raw last-level-cache event and no prefetch event appears by name. The generic `cache-misses`
  is the only miss event offered.
- **Tools.** `perf` is not on the path, and no `zig` is on the path inside this shell's `PATH`.
  The earlier probes ran from a toolchain reached another way.

## Inference

The prefetch-disabled control cannot be run from this lane as the paper described it. Writing the
prefetch control register needs ring-zero access the guest does not grant to uid 1000. So the
falsifier the sweep paper stated for the prefetch cause has no way to be run here, and the cause stays
a candidate.

Whether a shut door is a fact about the hardware or about this guest's configuration is inferred, not
observed. The two readings predict different things. A host that exposes `msr` to guests would show a
readable `/dev/cpu/0/msr` after a module load, and this guest shows none.

## Projection, with its falsifier and confidence

- **Horizon:** until the guest is given the `msr` module or the host exposes a prefetch event by name.
- **Falsifier of this note's blocked reading:** if a root-free run can write a prefetch control and
  read a changed `cache-misses` count on the 4 KiB sweep, the door is open and this note is wrong. Its
  reading would have to move outside the 94 to 339 permille rows the sweep paper printed.
- **Falsifier of the prefetch cause itself, once the door opens:** a prefetch-disabled 4 KiB sweep
  that reads within 500 to 2000 permille of one million line fills. Below the band, the cause is wrong.
- **Confidence:** high that uid 1000 on this guest cannot program the prefetch register, since the
  module and the device node are both absent. Low on what the host would expose if asked.

## What this does not reach

It does not claim the counter is blind to prefetch on any hardware. It does not restate the sweep's
inference as a finding. It does not name a raw vendor event; that stays Keaton's word, because the
choice is hardware-specific and no event on this guest's list settles a fill count.

## Next, for this lane

Door one is shut here, and it is a fact about the guest. Two honest doors remain: Keaton supplies the
`msr` route or a host that exposes a prefetch event, or Keaton names a raw vendor event for door two.
Neither is built by this lane. The lane's next fruit waits on that word, and the hot counter reading
stays exactly where the sweep paper left it.

## Grade

Graded at Field by self-reading. Every figure carries its unit and its date, the inference sits in its
own paragraph, and the projection carries horizon, falsifier, and confidence. The weight is the
guest's, not the tree's.
