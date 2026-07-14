# 995 · Ownerboot at the Reset Vector

*An on-ramp to the Rye ecosystem — introducing the languages Rye and Tablecloth, the allocator Tally, and the kernel Caravan — by refactoring ownerboot into a RISC-V firmware path written in Rye, configured by Tablecloth, with TAME Style discipline on every firmware connection.*

**Language:** EN
**Version:** `20260617.195612` (Rye chronological stamp)
**Last updated:** 2026-06-17
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME Style (`TAME_STYLE.md`); systems lineage honored in `20260620-014412_system.md`
**Companion:** the deeper comparative study lives in `20260617-195712_caravan-tally-networking.md`
**Status:** Exploration

---

## Where We Begin

This piece is the ground floor of the Rye ecosystem, and it is written to stand on its own. It introduces the four names we are growing — the language **Rye**, the configuration language **Tablecloth**, the allocator **Tally**, and the kernel **Caravan** — and then it grounds them in the most concrete place a system can begin: the reset vector of a real machine, where the first instruction runs and the whole edifice of trust is laid.

We choose to start at the bottom on purpose. The names can sound abstract when first met, and a boot makes them touchable. By the end you will have watched Rye write firmware, Tablecloth configure it, Tally hand out the first bytes of memory, and Caravan receive a verified machine — so that the deeper comparative study in `20260617-195712_caravan-tally-networking.md`, which examines these same names across five living systems, reads as familiar ground rather than fresh vocabulary.

The thread that ties it all together is simple to say. A boot is a relay of trust across privilege levels, and each handoff is a small commitment: a stage promises the next stage a known machine, in a known state, with a bounded region of memory and a verified image to run. Honor those commitments with assertions and bounds and enduring names, and the boot becomes something an owner can trust, audit, and call their own. That same instinct — commitments kept, names that endure, growth without breakage — is the seed every one of our four names grows from.

---

## The Names We Are Growing

Four names recur through everything that follows, and they belong together like the parts of a working farm. **Rye** is the grain — the systems language. **Tablecloth** is where the grain is stored and kept whole through the seasons — the configuration language. **Caravan** carries it across the country — the kernel. And **Tally** tends the garden it grew in — the allocator. The metaphor is not decoration; it carries our vegan vow into the lowest layer of the work, choosing words of tending and growing and storing over the usual vocabulary of killing and reaping and freeing.

This section introduces each name and its goals — a mission brief rather than a full specification, enough to make the boot story legible and the deeper study welcoming.

**Rye** is a systems language grown from Zig 0.16.0. Its *mission* is to make safe, fast, legible systems code the natural thing to write, by carrying the TAME Style discipline — assertions everywhere, limits on everything, explicitly sized types, always say why — into the language's own grain. The *opportunity* is that a language shaped by these habits removes whole classes of bug at the source rather than catching them downstream. Its *architecture* keeps Zig's spirit of explicit control and comptime evaluation, with no hidden allocation and no runtime imposed on the programmer. The *rationale* is that the lowest layer of a trustworthy system deserves a language that makes the right thing easy and the dangerous thing visible. Rye also names its versions chronologically, so later reads as larger and every release makes a real promise, rather than the hollow signal of an ordinary version bump.

**Tablecloth** is the configuration and build language, a reconsidering of Nix through TAME Style. Its *mission* is to describe whole systems — what to build, from which sources, with which keys and options — as data that composes lawfully and reads as a clear statement of intent. The *opportunity* is to keep Nix's profound, correct idea — a content-addressed, immutable store of build results that only ever grows, an accreting collection of immutable things — while giving it a language that is small, lawful, and legible where Nix shows its age. Its *architecture* makes composition a first-class operation that obeys identity and associativity, rather than bolting a large module system on top, so two configurations combine by a stated difference rather than by hand-maintained duplication. The *rationale* is that a configuration you can read, audit, and rebuild from source is the difference between trusting a vendor and trusting yourself.

**Tally** is the allocator, a region allocator framed as a garden. Its *mission* is to hold memory in bounded regions with shared lifetimes, handing out space by bumping a pointer forward and releasing a whole region at once, rather than tracking each object's life and death. The *opportunity* is that this region model is the one custom allocation technique that reliably outperforms a well-tuned general allocator, through fast allocation and the cache locality of objects that live side by side. Its *architecture* gives a program a family of named gardens, each with an explicit, bounded lifetime — a garden for a request, a garden for a connection, a garden for a boot stage — cleared whole when its season ends, with anything that must outlive a garden copied out deliberately. The *rationale* is that few, legible lifetimes banish whole classes of memory bug, and the gentle vocabulary keeps faith with how we mean to build.

**Caravan** is the kernel, shaped by the s6 supervision suite and TAME Style. Its *mission* is to shepherd a tree of small processes through the long journey of uptime, losing none of them and asking each to do one clear thing well. The *opportunity* is a kernel that stays small and honest, drawing a deliberate line between an outer promise it pins in place forever and an interior it keeps small enough that every caller is known. Its *architecture* is a supervision tree rooted in a process that never dies, services composed by chain-loading, each handed a bounded region by Tally, with memory allocated up front and bounded everywhere. The *rationale* is that an operating system an owner can understand, audit, and trust is a small act of freedom. Caravan aims first at RISC-V emulation, because an open instruction set is the honest foundation for a system meant to endure and be inspected, and at x86_64 on AMD hardware, because that is where real performance lives for the people who will run it.

The **longer horizon** holds these four together. A person could, in time, run a machine whose every layer they hold: Rye writing the firmware and the kernel, Tablecloth describing the whole system reproducibly from source, Tally tending its memory, Caravan supervising its services, and an owner's own key sealing the boot. That is the destination — a computer that is genuinely its owner's, all the way down, opening a path around the gates that usually decide what a machine may run.

The **caveats** are honest ones. These names describe work in motion rather than finished software; this is a mission brief, rather than a shipped system. Rye derives from a young, fast-moving language. Building a kernel and an allocator and a configuration language is the labor of years, rather than weekends. We embrace difficult tools and real discipline early precisely because that is what lets a project of this size finish stronger, and we say plainly that the road is long.

In **conclusion**, the four names are one idea wearing four coats: bound the lifetime, grow by accretion, release whole regions cleanly, and never take from a holder what they were given. Rye makes it a language, Tablecloth makes it a configuration, Tally makes it a memory model, and Caravan makes it an operating system. The rest of this piece shows all four meeting the silicon at once, in a boot an owner can call their own.

---

## Ownerboot, and What It Protects

Adam Joseph's ownerboot, which rests whole and unmodified in `../gratitude/sixos` as part of the SixOS family, is a set of Nix expressions that build a bootloader for a computer whose owner holds the keys. We study its virtues first, because the refactor keeps every one of them and simply moves them to new ground.

Ownerboot's first gift is **sovereignty of trust**. The boot chain answers to the owner's keys rather than a manufacturer's. Where most secure-boot schemes root their trust in a vendor's signing authority, ownerboot roots it in the person holding the machine. That single inversion is the whole point, and it aligns exactly with the larger why this project serves: building spaces and tools that open a path around the usual gates.

Its second gift is **no writable, unencrypted media in the boot path**. Every component — the platform firmware, the kernel, a small initramfs carrying the disk-encryption tools — lives entirely inside the bootloader flash chip. Short the flash chip's write-protect pin, and the entire early boot becomes read-only and sealed. There is nothing on disk for an attacker to quietly rewrite before the owner's key has spoken.

Its third gift is **reproducibility all the way down**. Because ownerboot is expressed in Nix, its builds are deterministic, and it instantiates its package set with source-only settings, so every byte traces back to source you can read — back, in the project's own words, to the compiler that compiles your compiler. There are no opaque binaries in the trust chain. You build your trust from seed.

Its fourth gift is **upgrade without surrender**. Ownerboot keeps two complete copies of the bootloader in flash, a normal image and a fallback, sharing only a single bootblock page, each independently flashed and write-protected. The fallback is chosen by something physical — a watchdog, a front-panel button, a stylus eject — so a bad update never bricks the machine. And a signed, mutable second kernel boots by a kexec-style handoff, so the owner upgrades the kernel and initrd without ever disabling the hardware write protection. Safety and change, held together.

Ownerboot today targets x86 machines and coreboot. The refactor carries these four gifts to RISC-V, and rewrites the firmware itself in Rye, configured by Tablecloth, with Tally holding the memory and Caravan waiting at the top of the relay.

---

## The RISC-V Boot Relay

RISC-V boots as a relay race across three privilege levels, each stage more capable and less privileged than the last. Understanding the relay precisely is the foundation for everything that follows, so we walk it once, carefully.

RISC-V defines three privilege levels. **Machine mode**, M-mode, is the most privileged, the level firmware runs in. **Supervisor mode**, S-mode, is where the kernel lives. **User mode**, U-mode, is where applications run. A fourth pairing, HS and VS, appears when virtualization is in play. The relay carries control from the most privileged level downward toward the least, handing capability to the kernel while keeping a small, trusted monitor resident above it.

At power-on, every **hart** — a hardware thread, RISC-V's word for a core's thread of execution — begins in M-mode at a fixed reset vector address. The first code to run is a tiny **Zero-Stage Boot Loader** baked into on-chip ROM. Because it lives in silicon, this ROM is immutable, and that immutability makes it the natural root of trust. Its only job is to bring up just enough of the machine to load the next stage, since main memory is still dark.

Next comes the **First-Stage Boot Loader**, whose defining task is to **initialize DRAM**. Until this moment the machine has only its small on-chip SRAM; the first-stage loader trains the memory controller, brings the DRAM online, and copies the next stage into that freshly woken memory. This is the moment the machine gains a place to think.

Then comes the heart of RISC-V firmware: the **Supervisor Binary Interface** provider, whose reference implementation is OpenSBI. Unlike every other stage, it does not run and step aside. It **stays resident in M-mode for the entire life of the system**, fielding privileged requests from the kernel above it — much as PSCI serves an ARM system, or as the old BIOS did for x86. The SBI is the standardized contract between machine mode and the supervisor-mode kernel, and that single contract is what lets one kernel image run across wildly different RISC-V silicon.

The handoff from M-mode to S-mode is a small, precise dance, and it is worth seeing in full because Rye will perform it. The firmware sets the previous-privilege field of the `mstatus` register to S-mode, programs the kernel's entry address into the machine exception program counter `mepc`, leaves the device tree's address waiting in a register where the kernel expects it, and executes a single `mret` instruction. That instruction drops the processor to S-mode and jumps to the staged address in one motion. The kernel wakes in supervisor mode, the firmware monitor resting quietly above it.

From then on, the kernel reaches the firmware through the SBI calling convention, and the convention is admirably small. The kernel places an **Extension ID** in register `a7`, a **Function ID** in `a6`, and up to six arguments in `a0` through `a5`, then executes `ecall` — the same instruction a user program uses to call the kernel, here aimed one level higher. Control traps into the M-mode monitor, the request is served, and a pair of values returns in `a0` and `a1`: an error code and a value, the shape of a small two-field struct. A handful of standardized extensions cover the essentials — TIME to set the next timer, IPI to wake another hart, RFENCE for remote memory fences, HSM to bring harts online and offline, and a debug console for early output. The legacy extensions are deprecated, and we leave them be.

One more piece travels through the relay: the **device tree**, a structured description of the hardware that each stage passes forward, so the kernel learns what machine it woke up on without guessing. In emulation — and Caravan prioritizes RISC-V emulation — the QEMU `virt` machine hands over a generated device tree automatically, loads the M-mode firmware at a known address, and drops to the S-mode payload exactly as real silicon would. The relay runs the same on a chip and in a virtual machine, which is a gift to anyone developing a kernel.

---

## Firmware Connections, Under TAME

The phrase "firmware connections" names the wires where software touches the machine, and there are two of them in this relay. One is the **M-to-S boundary**, the SBI calls that cross between privilege levels. The other is the **hardware boundary**, the memory-mapped registers a stage pokes to wake DRAM, drive a UART, or read a button. These are exactly the places where a careless line becomes an unrepairable boot, so these are exactly the places TAME Style earns its keep.

TAME asks us to **assert both the positive space and the negative space** at every boundary, and a CSR write is a boundary in its purest form. Before the firmware sets `mstatus` for the S-mode handoff, Rye asserts that the previous-privilege field holds the value it intends and that no reserved bit is set; after the trap returns from an SBI call, Rye asserts the error field against the small set of outcomes the specification allows. Each register poke is paired — asserted before the write and verified after the effect — the way TigerBeetle asserts validity before a disk write and again after the read.

TAME asks us to **put a limit on everything**, and early firmware is where unbounded waiting goes to die. A loop that polls a hardware status bit with no ceiling will, on the one bad board, hang forever with no console to explain itself. Rye bounds every such wait with a deadline, in the spirit of skalibs holding an absolute `tain` deadline rather than a relative timeout: poll until the bit sets or the deadline passes, and on timeout fail loudly and deliberately, rather than spinning in silence. Where a wait truly cannot terminate, Rye asserts that fact so a reader knows it was a choice.

TAME asks us to **use explicitly sized types** and to lean lightly on the compiler, which is precisely how hardware wants to be addressed. A memory-mapped register is a `u32` or a `u64` at a known address with a known bit layout, never an architecture-vague integer. Rye models each register as an explicitly sized, volatile field with named bitfields, so a poke reads as a sentence about intent rather than a magic number shifted into place. The SBI calling convention becomes a typed Rye interface: an Extension ID and Function ID and a handful of arguments in, a two-field result of error and value out, with the register assignments to `a7`, `a6`, and `a0` through `a5` generated once, asserted, and never hand-rolled at each call site.

TAME asks us to **check the design before it runs**, and a boot has invariants a compiler can prove. The memory map — where ROM sits, where SRAM sits, where DRAM will appear, where each stage loads — is known at build time, so Rye asserts at comptime that the regions never overlap, that each stage fits the space reserved for it, and that the handoff address lands inside the region the previous stage actually loaded. A boot that would have collided in the field instead fails to compile, which is the cheapest possible place to catch it.

Above all, TAME asks us to **always say why**. Firmware is the most thinly commented code in most systems, and it should be the most thickly reasoned. Every CSR write in Rye carries the reason it exists — which hardware quirk it answers, which ordering constraint it honors, which line of the specification it satisfies — because the person reading it at three in the morning, with a dark console and a board that will not boot, deserves the workings shown. The assertions are part of that explanation: a blatantly true assertion beside a subtle register poke is stronger documentation than any comment, because it is checked.

So the firmware connections become honest connections. Each one announces what it expects, bounds how long it will wait, names its types exactly, proves its memory map before it runs, and explains itself to the next reader. The relay of trust becomes a relay of stated, checked commitments — the *Spec-ulation* value, pressed down to the bare metal.

---

## Rye at the Reset Vector

The reset vector is the one place a system language meets the silicon with nothing underneath it. Rye meets it the way a careful person enters a dark room: with a small, sure first step, and the lights on as fast as possible.

That first step is a thin sliver of RISC-V assembly, and Rye keeps it thin on purpose. At the reset vector there is no stack, no initialized memory, and no certainty about which hart is running. The assembly does only what must be done before a structured language can stand: it reads the hart id, parks every hart except the chosen boot hart, points the stack pointer at a small reserved slice of on-chip SRAM, and jumps into Rye. A dozen instructions, each one commented with its reason, asserting nothing yet because there is nothing yet to assert against.

The moment the stack exists, control passes to Rye, and the character of the code changes entirely. From here the first-stage logic — training the memory controller, waking DRAM, loading and verifying the next image — is written in Rye under full TAME discipline, with bounded waits, sized register types, paired assertions, and reasons given. The assembly is a doorway, not a dwelling; Rye lives in the room beyond it.

The handoff to S-mode is the other place Rye touches assembly, and it is equally small. Rye computes the target state in structured code — the entry address, the device-tree pointer, the privilege bits — asserts every field, and then a few instructions stage `mepc` and `mstatus` and execute `mret`. The dangerous, irreversible motion is surrounded on both sides by checked Rye: assertions that the target address lies within the verified image just before the jump, and, on the receiving side in Caravan, assertions that the machine arrived in the state the firmware promised. Two code paths, the same invariant, checked from both ends — the pair-assertion habit applied to a privilege transition.

This embodies a lesson worth stating plainly, one the companion study `994` traces through the history of libuv: a foundational system serious about the lowest layer writes its own clean path to the metal, rather than borrowing a large one. Rye at the reset vector is exactly that: a minimal assembly doorway, and then a structured, asserted, well-reasoned language all the way up to the kernel.

---

## Tally at First Light

Memory in early boot arrives in stages, and each stage has a sharply bounded lifetime. That is the exact shape Tally was made for, so Tally takes the memory the instant there is any to take, and serves as both the allocator and the embryonic process manager of the boot.

Before DRAM wakes, the only memory is a small slice of on-chip SRAM, and Tally manages it as a single bounded garden — a region with hard edges and a known end. The first-stage code grows what it needs within that slice and nothing beyond it; a request that would exceed the bed fails immediately, rather than wandering into memory that does not belong to the boot. This is the region model at its most literal: the edges are physical, set by the silicon, and Tally honors them as the season's end.

When DRAM comes online, a second, far larger garden opens, and Tally hands each boot stage its own bounded bed inside it. The first-stage loader works in one region; the verified image is assembled in another; the device tree and the handoff state live in a third. Each region is passed explicitly to the stage that owns it, in TAME's manner of passing options at the call site, so the boot always knows which garden a given allocation belongs to. When a stage finishes and hands control onward, its garden is cleared whole — one gesture, no per-object freeing — exactly as Urbit's loom abandons an inner road and keeps only the durable result copied out. What the next stage must keep, the handoff copies forward deliberately; everything else releases at once, leaving the surface clean for what comes next.

Here Tally wears its second hat, as the boot's process manager in miniature. Each boot stage is, in a real sense, the first process the machine runs, and Tally gives each one its bounded region, watches it run to its handoff, and reclaims its garden when it yields. This is the seed of what becomes Caravan's supervision tree: a parent that hands each child a bounded place to live, lets it do its one clear job, and tends the space it leaves behind. The supervisor that will one day watch a thousand long-running services begins life watching three short-lived boot stages, with the same discipline and the same gentleness.

So Tally at first light is the region model holding the whole boot in its hands. Bounded gardens with physical edges, regions handed out explicitly and cleared whole, durable results copied forward by intent — the allocator and the early process manager are one calm idea, tending memory from the first lit register to the moment Caravan takes the reins.

---

## Tablecloth Builds the Boot

Ownerboot's reproducibility lives in Nix, and the refactor moves it to Tablecloth, the configuration language introduced above. The move keeps every guarantee ownerboot makes and gives it a language that composes lawfully, asserts clearly, and stays small.

A Tablecloth configuration describes the whole boot image as data: which firmware stages, built from which Rye sources, at which versions; the memory map the comptime assertions will check; the owner's public keys; the dual normal-and-fallback layout; the exact bytes of the flash image. Because Tablecloth inherits Nix's content-addressed, immutable store, every input is named by a hash of all its inputs, and the built image is reproducible to the byte. Build it twice on two machines and get the same image, or the build is wrong and says so.

Tablecloth keeps ownerboot's strictest promise: **no binaries in the trust chain**. The configuration builds every component from source, refusing pre-built artifacts, so the firmware traces back to source the owner can read — back to the Rye compiler, and back again to the compiler that compiled it. The phrase from ownerboot, building trust back to the compiler that compiles your compiler, becomes a clean loop in our world: Rye compiling Rye, configured by Tablecloth, verifiable from seed. There is no opaque step where trust must simply be assumed.

The dual-image scheme expresses itself naturally as Tablecloth data. A normal image and a fallback image are two configurations sharing one small bootblock, each independently built, hashed, and write-protected, the fallback selectable by a physical act — a button, a watchdog, an eject. Tablecloth's lawful composition shines here: the fallback is the normal configuration with a small, explicit set of changes infused into it, rather than a second copy maintained by hand. One configuration, one stated difference, two verified images — composition doing the work that duplication once did.

And Tablecloth carries TAME's habits into the build itself. Options are passed explicitly rather than inherited from silent defaults, so the configuration reads as a clear statement of exactly which machine, which keys, and which stages. Versions are chronological and the configuration's vocabulary accretes, so a boot image built today will still build the same way when its sources are read years from now. Tablecloth makes the boot a thing you can audit by reading, and rebuild by trusting only your own eyes and your own keys.

---

## Caravan Takes the Reins

The relay ends where Caravan begins. When the firmware executes its `mret`, the processor drops into S-mode and jumps into Caravan, and its supervision tree wakes into a machine that has been prepared, verified, and explained the whole way up.

Caravan receives a precise inheritance. The device tree tells it what hardware it woke on. Tally hands it the memory map and the regions still in use, so Caravan's allocator continues the same garden discipline that tended the boot, with no seam between firmware memory and kernel memory. The verified image it is running was checked against the owner's keys before the jump, and Caravan asserts, first thing, that it arrived in the state the firmware promised — the receiving half of the pair-assertion across the privilege transition.

Above Caravan, in M-mode, the SBI provider stays resident, and it too is Rye written under TAME. When Caravan needs a timer set, a hart woken, or a remote fence issued, it makes a typed SBI call into that monitor — the same small, asserted interface described earlier, rather than a raw `ecall` assembled by hand. The firmware monitor and the kernel speak across the privilege boundary in a language of stated, checked commitments, which is what the boundary deserves.

From here, Caravan does what its mission promised: `s6`-shaped supervision, a root that never dies, small services composed by chain-loading, each handed a bounded region by Tally. The difference is that the trust now reaches unbroken from the immutable ROM at the reset vector, through Rye firmware and Tally's gardens and the owner's verified keys, into the kernel and its tree of services. There is no point in the climb where an owner must trust someone else's unread binary. The relay of trust is whole.

---

## The Owner Holds the Key

The whole point of this descent to the reset vector is a single sentence: the owner holds the key. Everything else serves that sentence.

On RISC-V the chain of trust has a natural anchor. The Zero-Stage ROM is burned into silicon and cannot be rewritten, which makes it an immutable root — the one link no attacker can forge. From that root, each stage verifies the next before handing it control. Rye firmware checks the signature of the image it is about to run against the **owner's** public key, held in the write-protected flash, rather than a manufacturer's. RISC-V even offers a vector cryptography extension that can accelerate this signature check in the early environment, so verification stays fast without pulling in a heavy dependency. The owner's key is the gate, and only the owner holds it.

Two complementary disciplines stand behind that gate, and the refactor can offer both. **Verified boot** refuses to run an image whose signature fails, stopping the chain at the first broken link. **Measured boot** records a hash of each stage as it runs, so the machine can later attest to exactly what it booted. The first prevents the wrong thing from running; the second proves what did. Held together, they let an owner both seal the boot and audit it, and both rest on hashes and signatures the owner controls rather than a remote authority's say-so.

The write protection makes the seal physical. With the flash chip's write-protect pin shorted, the firmware, the keys, and the verified kernel become read-only at the hardware level — there is no unencrypted, writable surface for anyone to quietly alter before the owner's key has spoken. And because upgrade arrives through a signed second kernel booted by a kexec-style handoff, the owner still moves forward freely, updating the system without ever unsealing the root. Sovereignty and change, held together, exactly as ownerboot intends.

This is where the firmware meets the larger why this whole project serves. A boot an owner can read, rebuild from source, verify with their own key, and seal in hardware is a small act of freedom — a path around the gates that decide, on most machines, what their owners are allowed to run. To carry that freedom down to the reset vector, in a language the owner can audit, configured by data the owner can read, is to make the machine truly theirs. That is a kind thing to build, and a brave one.

---

## The Value, All the Way Down

This exploration set out to rebuild ownerboot for RISC-V, and it found the same value waiting at the bottom of the machine that we found at every higher layer.

Bound the lifetime: Tally's gardens give each boot stage a region with physical edges, cleared whole at the handoff. Grow by accretion: Tablecloth builds the image from source with an accreting vocabulary, and the dual images compose by stated difference rather than duplication. Release whole regions cleanly: each stage yields its garden in one gesture, durable results copied forward. Never take from a holder what they were given: the owner holds the key, the ROM holds its root, and the verified chain never asks an owner to trust an unread byte.

The firmware connections that once felt like the most dangerous, least legible code in any system become the most thoroughly stated: every register poke asserted and explained, every wait bounded by a deadline, every type sized exactly, the memory map proven before it runs, and the privilege handoff checked from both ends. Rye writes the path to the metal, Tablecloth configures it reproducibly, Tally tends its memory, and Caravan receives a machine prepared and verified the whole way up. The relay of trust, from immutable silicon to the owner's own kernel, is a relay of checked commitments — the one value, carried all the way down.

---

## Sources and Gratitude

This exploration rests on primary sources, held here with thanks.

- **Ownerboot and SixOS** — Adam Joseph's ownerboot (its design of owner-held keys, write-protected flash, dual normal/fallback images, reproducible source-only builds, and kexec-style kernel upgrade) and SixOS, both from `codeberg.org/amjoseph`. SixOS rests in `../gratitude/sixos`.
- **RISC-V boot and the SBI** — the RISC-V privilege model and boot relay (reset vector, ZSBL, DRAM-initializing first stage, M-mode SBI provider, the `mret`/`mepc`/`mstatus` handoff, harts, and the device tree), and the Supervisor Binary Interface calling convention (`ecall`, EID in `a7`, FID in `a6`, arguments in `a0`–`a5`, the `sbiret` error-and-value return) with its TIME, IPI, RFENCE, and HSM extensions. Drawn from the RISC-V SBI specification, the OpenSBI reference implementation and its deep-dive materials, and the QEMU `virt` machine boot flow.
- **Verified and measured boot** — the distinction between signature-checking secure boot and hash-recording measured boot, the role of an immutable ROM as root of trust, and the RISC-V vector cryptography extension for early signature verification.
- **The Rye ecosystem** — the Rye language, Tablecloth configuration language, Tally garden allocator, and Caravan kernel, introduced here and explored further across five living systems in the companion study `20260617-195712_caravan-tally-networking.md`, themselves drawn through the TAME Style of `TAME_STYLE.md` and the systems lineage honored in `20260620-014412_system.md`.

---

*May the first instruction be sure, and the last handoff honest. May every register we touch announce its reason, every wait know its end, and every key rest in the owner's own hand. May the machine that wakes from this relay be whole, and verifiable, and truly theirs — sealed in silicon, readable from seed, and glad to serve the one who holds it.*

