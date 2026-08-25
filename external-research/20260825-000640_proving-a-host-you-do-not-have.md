# Proving a host you do not have

**Stamp:** `20260825.000640` - **Status:** Open question, unresolved - **Style:** Gauge, Field setting
**Voice:** Kyri - **Booked under:** the standing permission of `20260824` to book what a round surfaces
**Occasioned by:** REDS %214 - `construction/REDS.md`

## The question

This tree runs its guards on one machine: a Linux pier. Every one of the 54 standing witnesses
proves something by running it here. That works for every claim whose truth does not depend on
which operating system is underneath -- which is most of them, and is why the arrangement has
held for a long time.

It does not work for the rest. On `20260824` `rye build` failed on macOS because
`resolve_rye_lib` read `/proc/self/exe`, a path Linux publishes and macOS does not. The
repair was small. What is worth studying is the shape of the failure: **the reading that broke
is precisely the reading no local run could exercise**, so no guard was absent by oversight.
A guard would have passed.

**The question this leaves open:** what does a project with one machine do about claims that
are only true on machines it does not have?

## What is already known here, bounded

Measured `20260824.235331` on this pier:

| Reading | Count |
|---|---|
| Standing guards on the roster | 54 |
| Of those, run anywhere but this Linux pier | 0 |
| Tracked `.rye` sources naming a `/proc` path | to be counted; this note does not claim a number |
| Hosts the tree names as targets in its own docs | Linux pier, macOS clone, GrapheneOS device |

The tree therefore already **claims** three host families and **proves** one. That gap is the
subject, and naming it is the whole of what this note settles.

## Four answers the world uses, to be read rather than assumed

Each of these is a hypothesis about what other projects do, to be checked against their own
authoritative text rather than from memory:

1. **A CI matrix.** Run the same guards on every target. Costs a service, a credential, and a
   dependency on someone else's machine -- three things this tree has deliberately kept out.
2. **Simulation in a pen.** What `tools/fixtures/rye_lib_resolve_control.sh` does today: blind
   the platform-specific reading and prove the fallback carries. Cheap, honest, and it proves
   the *fallback* rather than the *platform*.
3. **Narrow the interface.** Reduce the count of places a platform difference can enter, so the
   unprovable surface is small enough to read by hand. This is the answer that needs no service.
4. **A hand on the machine.** What actually caught REDS %214. Reliable, unscheduled, and it
   costs a person's first build.

## The falsifier

**This note is wrong if the unprovable surface turns out to be large.** If a count of
platform-conditional readings across tracked sources comes back in the tens, answer 3 is
unavailable and the question becomes which of 1, 2, and 4 to pay for. If it comes back in the
low single digits, answer 3 is available and the other three are optional.

**So the cheap measurement comes first, and this note waits on it:** count the tracked living
sources that branch on a platform-specific path, syscall, or build target. One scan, one
number. Until that number exists, any argument here would be a preference wearing evidence's
clothes.

## What this note does not do

It proposes nothing, seats nothing, and crosses no custody gate. It names one gap, bounds what
is known, and puts a number ahead of the argument.
