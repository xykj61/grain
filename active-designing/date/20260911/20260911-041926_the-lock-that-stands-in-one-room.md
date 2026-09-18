# The lock that stands in one room

**Stamp:** `20260911.041926`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every number below is read by
[`../tools/fixtures/r/rye_build_lock_reach_scan.sh`](../tools/fixtures/r/rye_build_lock_reach_scan.sh) and gated by
[`../tools/r/rye_build_lock_reach_witness.rish`](../tools/r/rye_build_lock_reach_witness.rish)
**Kin:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) - REDS `%281` (the shadow race) - REDS `%700` (the guard that flapped)

## The mechanism, in plain words

`rye build` and `rye run` compile a `.rye` source by bridging it. The driver copies the root file
and every local `.rye` module it imports to adjacent `.zig` files -- `mantra/diff.rye` becomes
`mantra/diff.zig` -- hands those to the toolchain, and deletes them all on the way out. Those
adjacent files are **shadows**: real files in the tracked tree, alive for the length of one build.

Two builds staging the same shadow delete each other's bridge mid-compile. `rye/src/main.rye`
answers that with one lock, taken in `build_lock_acquire` and released in `build_lock_release`,
held from the first shadow write to the last delete and around the cache-hit path too, since the
bridge stages shadows before any receipt is consulted. It landed `20260827.023156` and closed REDS
`%281`.

**The lock directory is `.rye-build.lock`, opened against `std.Io.Dir.cwd()`.** So the lock's scope
is the caller's working directory. A shadow's path is its source's path with `.rye` traded for
`.zig`. So the shadow's scope is the tree. Two callers standing in two directories take two
different locks over one shared namespace, and neither waits for the other.

That is a boundary drawn on one axis over a hazard that lives on another.

## What the tree reads today

Measured `20260911.041926` by the scan named above, over every tracked `rye build` and `rye run`
invocation under `tools/`:

| Reading | Value | What holds it |
|---|---|---|
| `build_roots` | 1,314 | free -- rises with every witness |
| `shadow_paths` | 1,696 | free |
| `shared_paths` -- claimed by two or more roots | 907 | free, and **safe**: one lock stands over them |
| `lock_scopes` reaching the tree | 2 -- `.` and `glow/.cache` | walled |
| `cross_scope_collisions` | **0** | **walled, enforced** |
| busiest shadow | `lotus/wire.zig`, claimed by 217 roots | free |

Read the numbers by running the scan rather than by trusting this table; four of the six are free.

**The 907 are the lock working, rather than a fault.** Fifty-three percent of this tree's shadow
paths are reached by more than one build root, which is what a shared standard library looks like
from the bridge's side. One lock stands over all of them, so they are reported and gated at
nothing.

**The zero is a coincidence, and that is exactly why it earns a guard.** The second working
directory belongs to two Glow lowering witnesses that run `cd glow/.cache && ... rye build
lib_core_double_use.rye`, and both of those closures stay inside `glow/.cache`. Nothing in the tree
arranges that. It is true this morning because of where two files happen to sit, and it stops being
true the first time a witness reaches for `cd <dir> && rye build ...` to shorten a path.

## What this closes, and what it leaves open

**It closes the arrival of the next cross-scope caller**, in the lap it is typed. The gate reads
`cross_scope_collisions`, the scan's `--explain` names every offending shadow path and the two
scopes claiming it, and eighteen control legs prove the reading from both sides on real git
repositories in a throwaway pen -- the guilty case planted, read, and then lifted back to green
inside one pen, so a refusal stays tellable from a bypass. Four mutations of the scan bite eight,
two, three, and two legs respectively.

One of those legs is the `..` case, and it earns its place. An import may reach above its root
file's directory, and one in this tree does: `tools/rye/enrich/blocks_audit.rye` imports
`../tame_usize_audit.rye`. The walk normalizes `..` before claiming a shadow, so a root in one
directory and a root above it meet on the shadow they share; leave the normalization out and the
path is claimed under two spellings and the collision goes unseen. No build root reaches that
particular file today, so the shape stands in the tree's sources and outside every measured
closure -- which is precisely why it is proven in a pen rather than relied on in the field.

**It leaves the driver alone.** Moving the lock from the working directory to the tree, or moving
the shadows out of the tree into a pen, are both changes to the Rye build driver, which is a
language custody ruling and waits on Keaton's word. The measurement is here for when that word
comes, and the honest note beside it is that an import may escape its root file's directory -- one
does today, `@import("../tame_usize_audit.rye")` -- so "lock the root file's directory" is not
sufficient as a rule, and any repair has to say what *the tree* means.

**It does not explain REDS `%700`.** That row records a rostered Mantra guard answering red and then
green over one unchanged tree, and its repair asked for two things: a repeat count under load, and
the two builds moved into a pen. This lap pressed the fence that stands nearest to it and found this
gap instead. What can be said now that could not be said before: the lock is real, it is present in
the shipped `rye/bin/rye` binary rather than only in source (checked by byte grep after `strings`
wrongly reported it absent), and no cross-scope shadow collision stands in the tree today. So
whatever `%700` flapped on, it was not two callers in two rooms. The row stays OPEN.

## Why the air row found it

The rota's air lap reads law and boundary through touch, and touch works only at a surface -- you
meet a thing where it ends. The row's own instruction is to close a hand around one part and pull:
if other things move with it, the boundary exists on the diagram and nowhere under the hand.

Here the diagram said *one tree, one toolchain spawn*, in the lock's own commit subject. The hand
found a lock that stands in one room while the shadows are spread through the house.

*May every fence in this tree be one a hand can find, and may the ones that hold by luck be told
from the ones that hold by construction.*
