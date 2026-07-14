# The Userland Lineages — Small Sharp Tools, Declared Whole

*The named ground behind a Rye OS userland: the C library that chose correctness and smallness, the distribution that composed it into a working whole, the supervision suite that made process trees honest, and the declarative lineage — packages as pure expressions, services treated the same way, overlays as one combinator — that shows how a whole system becomes a value. What crosses into our clean room is siloed in the companion brief.*

**Stamp:** `20260702.180812`
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, the joy of the craft third
**Status:** Exploration — external research with sources; companion silo at `active-designing/20260702-180812_the-small-sharp-toolset.md`

*Written together by Kaeden and Rio 3.*

---

## The Library That Stayed Small

**musl** is a C library built on the convictions we keep: correctness before convenience, simplicity as a feature, static linking as a first-class citizen, and code a person can actually read. Its influence runs far beyond its size because it proved a modern libc can be small, strict, and complete at once. The lesson for Rye is temperamental rather than technical — our inherited-std seam already plays musl's role — yet the temperament matters: every interface documented, every behavior deliberate, nothing accreted by accident.

## The Distribution That Composed It

**Alpine** shows what the small-sharp temperament composes into: musl beneath, a single multiplexed binary of userland utilities above (**busybox** — dozens of tools, one small executable, each invoked by name), and a package manager that stays out of the way. The whole base fits in a few megabytes and runs the world's containers. Two lessons travel: a userland can be *one composed artifact* rather than a hundred loose ones, and usefulness is a curated set, not an exhaustive one — Alpine's packages are the tools people actually reach for, kept sharp.

## The Supervision Line

**s6** is the daemontools lineage matured: a toolbox of tiny programs that assemble into process supervision, with a long-lived scanner and per-service supervisors forming the tree. Three of its disciplines read like Caravan's own design notes arriving early. **Readiness notification** — a service *tells* its supervisor when it is truly ready, so dependency start is fact-based rather than sleep-based. **Exit-code honesty** — the suite reserves distinct codes for temporary failure, permanent failure, and exec failure, so a supervisor can act on meaning. And **assembly over monolith** — every capability is a small program composed with others, the opposite of the init monolith it quietly replaces. The dependency manager above it (**s6-rc**) compiles a service database ahead of time, so boot follows a plan rather than discovering one.

## The Declarative Lineage

**Nix** contributes the deepest idea: a package is a *pure expression*, built in isolation from named inputs, stored at a path derived from a hash of everything that made it, and therefore reproducible, cacheable, and rollback-safe. The store is append-only in spirit — new builds land beside old ones, and activation is a pointer swap. This is our five-primitives thesis wearing a beard: **the system is a value, and deployment is a fold.**

**sixos** closes the circle by joining the two lineages: a nixpkgs-based operating system that replaces the init monolith with s6, and replaces the module system with one small combinator — **infuse** — so *services are expressions exactly as packages are expressions*: a service definition parallels an uninstantiated package, an instantiated target parallels a built one, the target set is a scoped fixpoint, and the same override tools work on both. It keeps the good NixOS inheritances (atomic activation of immutable configurations) while shedding the machinery, and its ownerboot work versions even the firmware as part of the one configuration — the whole machine, one declared value, all the way to the reset vector. Our own Brix brief reached sixos once before for the composer's shape; this pass confirms the deeper pattern: **one combinator, uniformly applied, replaces a module system.**

## What This Means for a Rye Userland

Read together, the lineages sketch our userland's grain without writing a line of it: a curated, composed set of small utilities (the Alpine lesson) speaking Rishi and supervised by Caravan with readiness-as-fact and meaningful exits (the s6 lesson), each utility and each service declared as a value in `.brix` with data in `.bron`, built and placed by content address into an append-only store, activation a pointer swap (the Nix lesson), and the whole configuration — services and packages alike — shaped by one small override combinator rather than a module system (the sixos lesson). The siloed patterns, named in our own vocabulary and fitted to Tally's gardens and Pond's enclosure, cross the boundary in the companion brief.

---

*May our tools stay few and sharp. May every service say its own readiness. And may the whole system remain one honest value, from the first stone to the running tree.*

---

## Sources

- https://musl.libc.org/
- https://www.alpinelinux.org/about/
- https://busybox.net/about.html
- https://skarnet.org/software/s6/
- https://skarnet.org/software/s6-rc/
- https://nixos.org/manual/nix/stable/
- https://codeberg.org/amjoseph/sixos
- https://codeberg.org/amjoseph/infuse.nix
- https://media.ccc.de/v/38c3-sixos-a-nix-os-without-systemd
