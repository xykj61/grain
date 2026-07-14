# Aurora — the dawn a machine wakes into

**Version:** `20260619.035912` (Rye chronological stamp)
**Last updated:** 2026-07-10 (Radiant Style pass round 3)
**Style:** Radiant prose (see `../context/RADIANT_STYLE.md`); code in TAME Guidance (`../external-research/TAME_GUIDANCE.md`)
**Status:** Checkable — freestanding boot and wire seed

---

## What Aurora Is

Aurora is the dawn a machine wakes into: the boot, the first light between a cold
processor and a living system. The fuller vision — RISC-V cohesion, a flow of
named values, content-addressed stages, owner keys — lives in
`../external-research/yonder/20260617-195812_aurora-boot-riscv.md`, read forward through the rethink
in `../external-research/yonder/20260618-190312_decided-design-aurora-mantra.md`. This folder holds
the part that already breathes.

## The First Seed

Following Gall's Law — a working complex system grows from a working simple one —
Aurora begins with the smallest boot that runs. In `src/seed.rye`, one hart wakes
on a freestanding RISC-V machine, gives itself a stack, speaks a single line over
the console, and asks the machine to rest. Bare metal alone: Rye's own toolchain
aimed at the hart, and an emulator to wake in.

It is also the step where Rye and Aurora meet. Rye's north star asks it to cohere
with open hardware (`../context/specs/rye-as-its-own-language.md`); a freestanding
RISC-V binary, built by Rye and run on a real emulator, is that coherence made
concrete — and the same artifact is Aurora's first living stage. One step, two
roots fed.

## The Second Stage — a Relay

The seed grows by one true step into the first *relay*. In `src/relay.rye`, the
boot becomes a flow of named values: stage one wakes and reads the machine's
identity, packing it into a small `Machine` value; stage two receives that value,
proves an invariant of it — the base integer ISA must be present for this code
to run — and speaks what it found; stage three rests. Each handoff is a
tail call, and a value travels with it: the boot-as-flow-of-named-values idea
(`../external-research/yonder/20260617-195812_aurora-boot-riscv.md`, `/986`) at its smallest honest
size. It reads real registers (`mhartid`, `misa`), proves what it must, and hands
off — the shape every later stage will take.

## The Third Stage — Naming on the Bare Hart

The relay carried a value; this stage proves the boot can *name* one — with cryptography, on the bare metal. In `src/named.rye`, a freestanding hart hashes a message with SHA3-512, the very function we strengthened first, and speaks the content-name over the console. There is no operating system beneath the hash and no allocator either; the strengthened `std` crypto runs on the bare hart exactly as it does in a hosted test. This is where Aurora's bare-metal reach meets Mantra's content-addressing — and the proof that unlocks the rest: if the hash runs freestanding, so will the key agreement, the seal, and the signature that compose an encrypted, content-named datagram (`../external-research/yonder/20260618-195512_encrypted-networking-riscv.md`, `/982`).

## The Fourth Stage — the Sealed Datagram

The named hart proved the hash runs freestanding; this proves the *whole sealed message* does. In `src/sealed.rye`, one bare-metal hart plays both sides of a conversation: Alice seals a message to Bob — key agreement (X25519, from their Ed25519 identities), the seal (AEAD), the content-name (SHA3-512), the attestation (Ed25519) — and Bob verifies the attestation, checks the name against the bytes, derives the same secret, and opens it. The opened message is spoken over the console, with no operating system beneath any of it.

The quiet proof hides in the content-name: it is *byte-for-byte the same* on the bare hart as in the hosted test (`../rye/tests/sealed_message_test.rye`). One value model, hosted or freestanding — the same sealed message either way. All that remained for an encrypted datagram *between* two harts was the wire to carry it.

## The Fifth Stage — the Wire

The sealed stage left one thing for a datagram to travel *between* harts: a wire. Following Gall's Law, the smallest wire that works comes first — so this stage proves two harts can pass *any* value before they pass a sealed one. In `src/wire.rye`, the machine wakes with two harts (`-smp 2`). Each gives itself its own stack; hart 0 writes a message into a mailbox in shared RAM and raises a ready flag; hart 1 waits on the flag, reads the message, and speaks it. A memory fence on each side keeps the order honest: the buffer is published before the flag, and read only after it. This is the wire at its most elemental — shared memory and a flag, the mailbox a sealed datagram will ride.

## The Sixth Stage — a Sealed Datagram, Posted

The wire carries a value; the sealed hart sealed and opened one. This stage unites them. In `src/posted.rye`, the machine wakes with two harts again. Hart 0 (Alice) seals a message to hart 1 (Bob) — key agreement, the seal, the content-name, the attestation — serializes the whole datagram into the shared-memory wire, and raises the flag. Hart 1 reads the raw bytes off the wire and, before trusting any of them, *shape-casts* them: a datagram shorter than its header or longer than the wire is refused at the edge (`../active-designing/yonder/20260618-224812_shape-casting.md`). Only then does Bob verify the attestation, confirm the content-name binds the bytes, derive the shared secret from *his own secret and Alice's public key off the wire*, and open the seal.

This is a sealed value crossing the wire between two harts — the smallest honest seed of Comlink (`../active-designing/yonder/20260618-224712_bounded-network.md`; `../external-research/yonder/20260618-212112_content-centric-messaging.md`, `/985`). The wire here is shared memory between two harts; the next wire is a device between two machines.

## Build and Run

```sh
aurora/run.sh                 # the seed (the default stage)
aurora/run.sh relay           # the second stage: the first relay
aurora/run.sh named           # the third stage: content-naming, with crypto, on the bare hart
aurora/run.sh sealed          # the fourth stage: a whole sealed message, sealed and opened on bare metal
RYE_SMP=2 aurora/run.sh wire   # the fifth stage: two harts pass a value across shared memory
RYE_SMP=2 aurora/run.sh posted # the sixth stage: a sealed datagram posted across the wire between two harts
```

`aurora/run.sh` is a thin delegate to `tools/aurora_run.rish` — the interface above is unchanged. Direct invocation: `rishi/bin/rishi run tools/aurora_run.rish [stage]`.

`RYE_SMP` chooses how many harts the machine wakes with (it defaults to one); the
two-hart stages need `RYE_SMP=2`.

`run.sh` asks `rye build` to emit a freestanding RISC-V ELF for the chosen stage
— Rye building its own bare-metal artifact, against its own standard library —
and then wakes it on `qemu-system-riscv64 -machine virt`. The seed prints:

```
Aurora seed: a hart woke on RISC-V, spoke this line, and halted.
```

and the relay prints what it learned and proved along its three stages:

```
Aurora relay:
  stage 1 -> woke hart 0
  stage 2 -> proved RV with base integer + compressed
  stage 3 -> resting.
```

and the named stage proves the strengthened SHA3 runs with no OS beneath it:

```
Aurora: content-named on the bare hart.
  message = named on the bare hart
  name = 9c9f6b69ba766938dda360b25638dc54...
```

and the sealed stage opens a whole sealed message on bare metal — its
content-name byte-for-byte the same as the hosted test:

```
Aurora: a sealed datagram, opened on the bare hart.
  attestation verified, content-name matches.
  opened = Meet me where the rye grows.
  name = ef825a25550a090da510a46461178d73...
```

the wire passes a value between two harts across shared memory:

```
Aurora wire: hart 1 received from hart 0, across shared memory:
  "a word from hart zero"
```

and the posted stage carries a whole sealed datagram across that wire — Bob
opening, on his own hart, what Alice sealed on hers:

```
Aurora posted: hart 1 opened a sealed datagram from hart 0.
  attestation verified, content-name matches.
  opened = Meet me where the rye grows.
  name = ef825a25550a090da510a46461178d73...
```

All end with a clean exit (status 0), because the last stage writes the
machine's test finisher to power itself down. The script uses the vendored Zig
0.16.0 toolchain beside the project, so it needs no extra setup; an emulator
(`qemu-system-riscv64`) is the one thing it expects to find.

## The Shape of the Folder

```
aurora/
  README.md          <- this introduction
  src/
    seed.rye         <- the first seed: a hart wakes, speaks, and halts
    relay.rye        <- the second stage: a value flows across asserted stages
    named.rye        <- the third stage: SHA3 content-naming, with crypto, on bare metal
    sealed.rye       <- the fourth stage: a whole sealed message, freestanding
    wire.rye         <- the fifth stage: two harts pass a value across shared memory
    posted.rye       <- the sixth stage: a sealed datagram posted across the wire
  layout.ld          <- where a stage lives in memory (RAM base, _start first)
  run.sh             <- build a stage with rye, wake it in qemu (RYE_SMP for harts)
  .build/            <- the emitted ELFs (built on demand, untracked)
```

## How It Grows

Each stage grew from the one before, never bolted on — and a sealed datagram now
crosses the wire between two harts. That wire is shared memory; the next wire is a
real device (an emulated `virtio-net` to start) carrying a sealed datagram between
two *machines*, where Comlink fully begins. In parallel: a stage that hands the next a
value *it chose*; and, as the other modules ripen, Tally's bounded gardens for the
boot's own memory, Caravan's hand on what runs next, and Tablecloth describing the stages
as values. The roadmap that holds these steps lives in `../work-in-progress/ROADMAP.md`.

---

*May the first light be gentle and sure: a hart waking, a single true line
spoken, and a clean rest — the dawn the rest of the system grows into.*
