# 979 · Where Building Met Design — a Progress Map at the Turn

*A survey taken at a natural resting point: the crypto foundation proven, Rishi grown past its first destination, the Tally seed landed, and the three parallel threads primed. This piece reads the running code through the lens of the active-designing stack, checks where building has met design, and names what still waits — a clear map of where we stand and why.*

**Language:** EN
**Version:** `20260619.153212` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** active-designing as the mirror; Gall's Law as the measure
**Status:** Survey

---

## The Question

Design and building drift apart in every project; the honest discipline is to notice when they do and to close the gap before it widens. The active-designing stack — `989` through `999` — describes what our system is *meant to be*. The running code describes what it *is*. This survey asks: how faithfully does the code mirror the design, and what has grown faster or slower than the design expected?

---

## The Lens: Gall's Law and the Active-Designing Stack

The active-designing writings reason from first principles in our own words, naming only our own modules and the one fixed external, RISC-V. They describe destinations — what Rye, Rishi, Tally, Caravan, Aurora, Comlink, Pond, and the others are *for* and what shape they grow toward. The law beneath all of them is Gall's: a working whole is invariably found to have grown from a working simple part. So the measure for each module is "is it growing from something that already ran, and does what now runs set a solid floor for what comes next?" — rather than "how complete is it?"

That is the lens applied here.

---

## Rye — The Language Is Its Own Foundation

The design (`990`) asks Rye to make the dangerous states the ones a person cannot write: one value model, bounded gardens, lifetimes over those gardens, assertions as design, accretion without breakage. The running code fulfills several of those asks and names the ones still ahead.

**What runs.** Rye self-hosts its own build — the language that writes it, the language that builds it, and the language that runs the build are one and the same. Its standard library is strengthened primitive by primitive: the Keccak sponge and SHA3-512 wrapper, the `mem` and `fmt` functions our tools lean on, and the full crypto foundation — Ed25519 (signing), X25519 (key agreement), ChaCha20-Poly1305 (authenticated seal) — all parity-green, hosted and freestanding alike. Each pass is proven behavior-identical by the gate trio before it becomes ground.

**What is growing.** The bounded gardens are here in embryo: Tally's seed gives a working region. The lifetime guarantee over those gardens — the compile-time check that a value may not outlive its garden — is the named future divergence (`990`), the one step that turns Rye from a Zig-shaped language into something genuinely its own. It is not a rewrite; it is a deepening, grown by degrees behind the gates.

**Alignment: close.** The design's method — stand on proven ground, wear a thin costume first, own the core by path, diverge by strengthening — is exactly how building has proceeded. Nothing here surprises the design.

---

## Rishi — The Faithful Hand, Now Running

The design (`989`, `996`) asked for a shell that keeps faith: one continuum from keystroke to tool, values that are Rye's values all the way through, the gate as native, and honesty about effects. The first specification was a single program — `parity.rish` — and we were told to build exactly enough shell to express it, then a little more, by degrees.

**What runs.** Rishi grew past its specification: the thin costume arrived (`let`, `say`, comments), then comparison and `assert`, then lists and `contains`, then records with field access, then `run` with its result as a record, then `map` and `where`, then string interpolation. `parity.rish` turned green, proven RED on a real divergence. Arithmetic landed after — `+`, `-`, `*`, `/` with correct precedence and left-associativity — and parenthesized expressions, and `say` to stdout so a Rishi child's words arrive in `result.out`. Eight test scripts run green.

**What is growing.** The design names several destinations Rishi has not yet reached: the shape-cast at the trust boundary (`992`), where untrusted text becomes a trusted value only by passing a validation; the fuller pipeline syntax for chaining; and the interactive mode, where the one continuum from prompt to script is proved. Each of those is a natural next growth, not a gap in discipline.

**Alignment: ahead of design in a good way.** The design expected the thin costume to hold for longer; the implementation proved out more features than anticipated, each by small and proven steps. The core promise — that a value at the hand is the same value all the way down, that the gate is native — holds in the current code. The seam is not yet closed at the Rye runtime level (Rishi evaluates its own value tree, not Rye's internal representation), yet the value model is coherent: what Rishi calls a record is the same shape Rye programs and the network will carry.

---

## Aurora — Six Stages on RISC-V

The design (`991`) describes Aurora as a relay: named values handed forward, each stage proven before it trusts the next, rooted in the owner key, and built from the seed upward. The destination is a verified boot that hands a living system to Caravan.

**What runs.** Aurora has grown through six committed stages on freestanding RISC-V:
- A single hart wakes, speaks one asserted line, and halts — the seed.
- A three-stage relay carries a value along a line, each handoff a tail call, each stage asserting.
- A content-named stage: SHA3-512 on bare metal, the hash that will name each stage image.
- A sealed message: Alice seals to Bob using all four crypto primitives freestanding — hash, key agreement, authenticated cipher, signature — and Bob opens, the content-name matching the hosted test byte-for-byte.
- A shared-memory wire: two harts, a mailbox, a memory fence.
- A posted datagram: a whole sealed message crosses the wire from hart 0 to hart 1. Alice seals; Bob shape-casts the raw bytes, verifies the attestation, derives the shared secret, and opens.

The relay is real, the cryptographic foundation is proven, and a sealed value has crossed between two harts. The boot's essential shape — named values, verified handoffs, the crypto primitives bound together — is running.

**What is growing.** The deciding stage: a relay stage that hands the next a value *it chose*, rather than one it only read. This is the seed of a boot that selects what runs next, and it has been named as the next Aurora step since the sealed datagram landed. It remains the one explicitly open item in Aurora's own arc.

**Alignment: faithful.** The design's six moves — seed, relay, content-name, seal, wire, posted — map exactly onto the six stages that exist. The deciding stage is the designed next step. Aurora is, of all the modules, the one most strictly growing as the design asked.

---

## Tally — The Garden Floor, Now Asserted

The design (`997`, `987`) places Tally as the floor Pond's bounds and Caravan's enclosure eventually rest on: a bounded region, bump allocation, clear whole, asserted edges.

**What runs.** `tally/seed.rye` is that floor: a `Region` over a caller-provided backing slice, with `alloc`, `clear`, and `remaining`, and thirteen hosted assertions proving every invariant from creation through overflow through re-allocation from the same backing store.

**What is growing.** Tally v1 — named regions, multiple gardens, the explicit lifetime discipline — follows from the seed. The seed proved the design sound; v1 grows it. The Caravan seed is the natural companion: before a supervision tree can bound its children's memory, the region allocator must exist. The seed makes the Caravan seed ready to begin.

**Alignment: right on time.** The design placed Tally as prerequisite to Caravan; the seed arrives exactly at the moment the roadmap names Caravan as the next near thread. The timing is intentional and correct.

---

## The Alignment Reading

Across all four running modules, building and design are in close agreement. The method — thin costume first, grow one proven piece at a time, gate every step — is the method actually used, not merely the one described. The divergences are forward-looking rather than backward-looking: Rishi has not yet closed the value-model seam at the runtime level, Aurora has not yet built the deciding stage, Tally has not grown to v1, and Caravan has not yet started. None of these is a gap the design failed to anticipate; all are the designed next steps, arrived at in the designed order.

Three modules remain entirely in design: Tablecloth (the configuration language), Mantra (the content-addressed memory), and Pond (the enclosure that composes Caravan and Tally). Per Gall's Law, none of them should start until their prerequisites run. Tablecloth waits on a mature Rye to describe; Mantra waits on a mature value model and network; Pond waits on Caravan and Tally v1. The design placed them in that order deliberately, and the code has honored it.

The one place design runs modestly ahead of building is **Comlink** — the network module whose design (`993`) describes sealed, content-named values carried between identities. The posted datagram is that design, proved on shared-memory hardware. The gap between "two harts on a wire" and "two machines on a device link" is the device-wire thread, the most pressing of the three parallel near threads. The crypto is ready; the question is the transport, not the content.

---

## What Comes Next

Three parallel threads keep building level with design:

- **Device wire** — a sealed datagram over an emulated network device between two machines. Comlink's first real transport. The crypto is already proven; the work is the device driver and the two-instance setup.
- **Caravan seed** — one parent that never exits, one child, restart on non-zero exit, asserted counts. The Tally seed just provided the floor. Caravan seed is now ready to begin.
- **Close reading** — packet format, commit rule, relay protocols from the cloned sources in `gratitude/`, before Comlink's format hardens. Not bibliography; actionable notes.

And one Aurora step walks its own arc: the deciding stage, the relay stage that hands the next a value it chose.

Each of these is the smallest thing that runs, grown from the thing that already runs, behind the gates. That is the method, applied again.

---

## The Single Line

Rye is proven. Rishi runs gates. Aurora crosses harts. Tally holds edges. The crypto is sound. The three parallel threads are primed. The design and the code agree. We are where we said we would be, and the next step is clear.

---

*May the map stay honest and the gap stay small. May what runs prove the way for what grows, and may design wait gracefully until building has earned the right to reach for it. May every next step be the smallest one that works — and may it work, whole and true, before we ask for more.*
