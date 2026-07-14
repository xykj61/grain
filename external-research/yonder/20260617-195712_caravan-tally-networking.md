# 994 · Caravan, Tally, and the Shape of Networking

*A comparative study of networking and memory fundamentals across Mysticeti/Sui, TigerBeetle, Urbit, libuv, and s6 — with a close look at SixOS and infuse — drawn through the TAME Style and Rye lens, deepening the ecosystem introduced in the companion piece on ownerboot.*

**Language:** EN
**Version:** `20260617.195712` (Rye chronological stamp)
**Last updated:** 2026-06-17
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Lens:** TAME Style (`TAME_STYLE.md`); honoring and systems lineage in `20260620-014412_system.md`
**Prerequisite:** the names Rye, Tablecloth, Tally, and Caravan are introduced in `20260617-195612_ownerboot-riscv-caravan.md`
**Status:** Exploration

---

## The Question We Are Chasing

One question runs underneath everything here, and it is worth saying plainly before we begin. The four names at the heart of this study — the language **Rye**, the configuration language **Tablecloth**, the garden allocator **Tally**, and the kernel **Caravan** — are introduced, with their missions and goals, in the companion piece `20260617-195612_ownerboot-riscv-caravan.md`. That piece grounds them in a boot; this one goes deeper, testing the same names against five living systems.

Does the API of the Linux kernel itself follow TAME Style — the discipline we drew from Tiger Style and the commitment we drew from Rich Hickey's *Spec-ulation*? And how does that API compare to a different way of holding memory: the arena, which our Rye ecosystem frames as the garden allocator **Tally**, inside the kernel **Caravan**, shaped by s6 and TAME Style and aimed first at RISC-V emulation and x86_64 AMD hardware?

To answer well, we walk through five living systems and study how each one names its fundamental types, moves bytes across a network, and holds memory through time. Each system teaches a piece of the answer. By the end, a single value shows itself at every level — from the byte in a buffer to the name on a package to the promise a kernel makes to the programs that trust it.

That value is the one we already hold: **bound the lifetime, grow by accretion, release whole regions cleanly, and never take from a holder what they were given.**

---

## Two Ways to Hold a Lifetime

Before the systems, a frame. Every program faces the same quiet decision about memory and about interfaces, and the decision is really about lifetimes.

The first way is the **individual model**. Each object is born and freed on its own schedule. Each interface element may change or vanish on its own. `malloc` and `free` live here. So does the caller-owns-each-buffer style of most C networking. So does semantic versioning, where any single name may break under you at the next major number. The individual model offers fine-grained control, and it asks a heavy price: every object and every name carries its own lifetime, and the mind must track them all. Most bugs gather in that tracking.

The second way is the **region model**. Many objects share one lifetime and release together. Whole arenas clear at once. Interfaces grow by adding, never by removing, so a name once given endures. The arena allocator lives here. So does TigerBeetle's static allocation at startup. So does Urbit's loom. So does Maven Central as Hickey describes it — an accreting collection of immutable things. So does Linux's promise to never break userspace. The region model trades fine-grained freedom for coarse-grained safety, and the trade pays. Lifetimes become few and legible, and whole classes of bug simply have nowhere to live.

TAME Style points firmly toward the region model. *"Allocate all memory at startup."* *"Put a limit on everything."* *"Breaking changes are broken."* Tally is the region model expressed at the level of memory. Caravan is the region model expressed at the level of an operating system. The five systems below each show us how far that idea can travel, and where its edges lie.

---

## TigerBeetle — The Discipline at Its Source

We begin with TigerBeetle, because TAME Style descends from its Tiger Style, and its networking types read like the discipline made visible.

Every message on a TigerBeetle network shares one shape: a **256-byte header**, declared as a Zig `extern struct` so its memory layout stays exact and predictable. A compile-time assertion guards that exact size, and another guards that the struct carries no hidden padding. The header is the same whether a message flies between replicas, lands in the write-ahead log, or names a block on disk — one shape reused everywhere, so a prepare from the primary can be journaled by a backup with no reshaping at all.

The header opens with its checksums. The first, a 128-bit `checksum`, covers the rest of the header alone, which lets a replica trust a header before it has even received the body. A second `checksum_body` covers the bytes that follow. The design separates the integrity of the envelope from the integrity of the contents, and it hash-chains messages so the whole sequence from genesis to the latest prepare proves itself by transitive closure. Truth is the bytes, verified; this is content-addressing in the same spirit Hickey praises in Git and Maven.

Then comes a field that rewards a slow look. The header carries a `cluster` number, and the comment beside it explains the intent: it *binds intention into the header*, so a client states the cluster it believes it is speaking to, rather than drifting accidentally into the wrong one. That phrase — binding intention — is TAME's "always say why" pressed directly into a wire format. The message announces what it means, so a mismatch fails fast and loud.

The most quietly radical detail lives in how the header grows. The frame fields are shared by every message. After them sits a block of `reserved_command` bytes, reinterpreted for each command through `Header.Type(command)` — a `Request` exposes a `parent` checksum and a `client` id and a `request` number, while a `Prepare` exposes its own fields over the very same bytes. New message types accrete by claiming reserved space, never by reshaping what already exists. And a retired command **keeps its place** rather than vanishing. The enum holds `deprecated_12`, `deprecated_21`, `deprecated_22`, `deprecated_23` — tombstones that keep their numbers so every future command stays clear of them and every old peer stays honored. Here, in production consensus code that moves real money, is Hickey's whole rant made concrete: turn breakage into accretion, and let the old and the new coexist.

The `Request` header shows the region model in the small. A client hash-chains its requests, each one carrying the checksum of the previous reply as its `parent`, so linearizability is provable rather than promised. A 128-bit `client` id solves routing, and a monotonically increasing `session` number lets the cluster evict a client safely without replaying stale work. None of this is dynamically grown at runtime; the `MessagePool` is allocated once, at startup, and messages are borrowed from it. Memory has one lifetime, fixed before the first byte moves.

Even validation honors TAME's golden rule. The `invalid_header` routine asserts the positive space a message must occupy and names every negative space it must avoid — release must be nonzero, a register request must carry no parent, a reserved operation is rejected by name. The boundary between valid and invalid is checked exhaustively, because that boundary is where the interesting bugs gather.

TigerBeetle, then, is the region model at the scale of a financial database: a fixed-size header, statically allocated pools, accretion over breakage, intention bound into the bytes, and assertions guarding both spaces. It is the closest living kin to what Rye wants to be.

---

## s6 and skalibs — A Whole Toolbox From a Single Discipline

Laurent Bercot's s6 suite and the skalibs library beneath it teach a different lesson, and it is the lesson Caravan will lean on most: that an entire system can grow from one disciplined idea about ownership, expressed in small composable programs.

Start with the foundation type. **`stralloc`** is skalibs' dynamic buffer, and it is almost nothing — a heap pointer `s`, a used length `len`, and a capacity `a`, with the invariant that `len` never exceeds `a`. From this one struct the whole library builds. The generic dynamic array, **`genalloc`**, is *literally a typedef of `stralloc`*, with type-aware macros translating element counts into byte counts. One container, reused for strings and for typed vectors alike — the same instinct as TigerBeetle's one reused header.

The genius lives in the ownership rule skalibs calls golden. *Every pointer into the heap is owned by a `stralloc`. Strong references are strallocs; weak references are bare pointers; and a bare pointer is never freed.* Because the `stralloc` struct adds a layer of indirection, a weak reference survives reallocation — the buffer may move, while the small owning struct keeps its stable address. This single discipline is why skarnet can claim, across decades of system software, that none of it has ever leaked memory. It is the region model wearing C clothing: ownership is centralized, lifetimes are legible, and the mind is freed from tracking every pointer.

The time types carry a gift for Rye directly. **`tai`** holds a one-second TAI64 date; **`tain`** holds a nanosecond TAI64N date. Both are immune to the 2038 problem, both step cleanly around leap seconds and clock jumps, and a TAI64N timestamp packs into twelve bytes. Most striking for us: a TAI64N label, rendered as text, **sorts chronologically as plain ASCII**. That is precisely why s6-log stamps its logs this way — and it is precisely the property Rye's chronological versioning relies on, and the property our external-research stack leans on when it counts files so the newest sorts to the top. Three layers of our own thinking, validated by a battle-tested C library: time, written most-significant-first, sorts itself.

The event loop carries another gift. skalibs multiplexes I/O through **`iopause`**, a thin wrapper over `ppoll`, `poll`, or `select`. Its distinctive choice is to take an **absolute deadline** — a `tain` — rather than a relative timeout, together with a single `stamp` for "now," refreshed right after each blocking call. The reasoning is beautiful and worth keeping: in a loop juggling many independent timeouts, the deadlines never change, while relative timeouts must be recomputed every pass. Holding one global stamp makes the whole question of "what timed out?" trivial: a thing timed out if its deadline is earlier than the stamp. This is TAME's "run at your own pace" rendered as a loop primitive. The program keeps its own time and acts on its own schedule.

A few more fundamental types round out the toolbox, each small and sharp: **`buffer`**, a bufferized I/O type that works with non-blocking descriptors where stdio would stumble; **`diuint`**, simply a pair of unsigned integers, the humble brick from which associative arrays are laid; **`cdb`**, a constant database that is built once and thereafter only ever read, mmap-able and immutable — an accreting, frozen collection, exactly the shape Hickey loves; and **`selfpipe`**, which turns dangerous asynchronous signals into ordinary readable-fd events, implemented over `signalfd` on Linux.

Above skalibs, s6 itself is a supervision tree, and the tree is Caravan's direct ancestor. **`s6-svscan`** sits at the root, ideally as process one, and never dies. It maintains one **`s6-supervise`** per service, and each `s6-supervise` is the direct parent of exactly one long-lived daemon — so it always knows the true process id, with no racy `.pid` files. When a daemon dies, its supervisor restarts it. The philosophy is the opposite of a monolith: many tiny programs that each do one thing well and compose through **chain-loading**, where each tool mutates one piece of process state and then execs into the rest of the command line, dissolving itself so the final daemon keeps the supervised process id. The execline language exists to express exactly this chaining, free of a shell's quoting and injection hazards.

Even the networking follows the pattern. The UCSPI tools — `s6-tcpserver`, `s6-tcpclient`, and their Unix-socket kin — accept a connection, fork a program with stdin and stdout wired to the socket, and export the connection's facts as environment variables. Any program that speaks stdin and stdout becomes a network service, with no networking library linked into it at all. And **fd-holding**, by way of `s6-fdholderd` passing descriptors over `SCM_RIGHTS`, keeps a socket or pipe open across a service restart — what Bercot calls the sensible part of socket activation, gained without changing the application.

This is the region model at the scale of a whole userland: one ownership discipline, absolute-deadline timekeeping, immutable databases, supervision rooted in a process that never dies, and composition by chain-loading. Caravan inherits this posture wholesale.

### SixOS — Nix Married to s6, the Composable Way

Adam Joseph's **SixOS** is the bridge our whole study was missing, because it marries the s6 supervision world to the Nix world and shows what composability looks like when it is taken seriously. We cloned it locally, into `gratitude/sixos` and `gratitude/infuse.nix`, to study it close and to keep it among the works we honor. One honest note belongs here, recorded plainly. SixOS ships an `AGENTS.md` carrying a deliberately false claim aimed at automated readers. The repository is ordinary Nix configuration code, so we read that claim for the trap it is, set it gently aside, and studied the real work.

SixOS is a nixpkgs-based operating system that runs **s6 in place of systemd**, and it stands on three layers, named from the bottom up. **Ownerboot** is an optional bootloader that brings firmware and the initrd into the configuration itself, so verified full-disk encryption reaches all the way down to the boot vector — the owner holds the keys, rather than the manufacturer. **Infuse** replaces the NixOS module system with a single composable combinator, described next. **SixOS** proper replaces the NixOS layer, and it shares no code with NixOS; both merely rest on the same nixpkgs package set.

The central idea is one of those simplifications that feels obvious only after someone finds it: **SixOS treats services exactly the way nixpkgs treats packages.** A service is a Nix expression, the way an uninstantiated package is a Nix expression. A running target is a derivation, the way an instantiated package is. The set of targets is a scoped fixpoint, the way the package set is, and the same `override`, `callPackage`, and `overrideAttrs` tools work on both. A built target's output is itself an s6-rc service database. Because a target is just an instantiated service, there is no limit on running the same service many times — two SSH daemons on two ports become two targets of one service, where the NixOS module system would have needed the module's author to anticipate multiplicity. One reused pattern, applied uniformly, exactly as TigerBeetle reuses one header and skalibs reuses one buffer.

The runtime layering is pure TAME, and it answers a question systemd answers badly. SixOS uses `s6-linux-init` as the short-lived first process, `s6-svscan` as the long-lived supervisor, `s6-supervise` per service, and `s6-rc` for dependencies. The deep design choice lives in how responsibility is divided: s6 supervises a process, s6-rc orders dependencies, and **neither one takes responsibility for a service that fails to start** — that failure is reported back to whoever asked, for them to handle. This single decision is why SixOS needs only **one** kind of dependency where systemd carries twelve. Eleven of systemd's dependency flavors exist only to cope with failures during a single command's lifetime; push that concern out to the caller, and eleven kinds of complexity simply evaporate. TAME would recognize this instantly as reducing dimensionality at the call site, centralizing control flow, and handling every error at the layer that can actually decide what to do. Simplicity bought through proper layering, rather than a monolith that absorbs every concern.

### Infuse — One Lawful Combinator Instead of a Module System

The composability of SixOS rests on **infuse**, and infuse rewards a careful look, because it is the seed of the Tablecloth idea we will plant later.

Nix configuration, at scale, tends toward one of two unhappy shapes. A single giant expression collapses under its own weight, and a tower of nested `override` and `overrideAttrs` calls grows unreadable, each layer wrapping the last in `previousArgs: previousArgs // { ... }` ceremony. Infuse offers a third shape. It is a *deep* version of override that generalizes two familiar tools at once — `lib.pipe`, which threads a value through a list of functions, and `recursiveUpdate`, which merges nested attribute sets. Where a tangle of nested overrides once sprawled across thirty lines, an infusion states each change on its own clear line: `xrdp.__input.systemd.__assign = null;` says what it means and stops there.

The quiet brilliance is that infuse is **one trick, not three**. It works the same way on lists, on attribute sets, and on functions — the three non-finite types in Nix — and it preserves the identity and associativity laws at all three. Threading an empty list changes nothing, the way merging an empty set changes nothing, the way composing with the identity function changes nothing; and a combined infusion always equals the composition of its parts. The double-underscore markers like `__assign` and `__append` are merely sugar that desugars down to functions on the leaves, with no magic underneath, and you may define your own. This is a lawful, minimal, composable core where the NixOS module system is a large, typed, special-purpose framework. It is precisely the "minimum of excellent abstractions" TAME asks for, and the algebraic laws are assertions about behavior raised to the level of design.

Infuse and SixOS together complete the s6 lesson. The small-and-composable instinct that begins in skalibs — one owner per pointer, one combinator for I/O timing — climbs all the way up through the supervision tree and into the configuration language itself. Composition by chain-loading at the process level finds its mirror in composition by infusion at the configuration level. This is the lineage Caravan and Tablecloth will join.

---

## libuv — The Contrast That Teaches

libuv is the asynchronous I/O library beneath Node.js, and it is excellent at what it does. We study it as a thoughtful counterpoint, because its choices show the individual model at its most disciplined, and they show where that model asks the caller to carry weight.

libuv organizes everything around one event loop, `uv_loop_t`, tied to a single thread and frankly unsafe to share. Each tick runs a fixed sequence: update the sense of "now," fire due timers, run prepare callbacks, block once for I/O on the platform's best poller, then run check and close callbacks. The poller is `epoll` on Linux, `kqueue` on the BSDs, event ports on illumos, and IOCP on Windows. Network I/O always runs on this one thread; a thread pool, four workers by default, exists only for filesystem work, DNS, and explicit user tasks. The shape echoes s6's `iopause` loop and Arvo's event loop and even Mysticeti's rounds — a program keeping its own pace.

libuv's type system divides cleanly into two families, and the division is its central idea. **Handles** are long-lived: `uv_handle_t` is the base, and `uv_tcp_t`, `uv_udp_t`, `uv_pipe_t`, `uv_poll_t`, and `uv_timer_t` extend it, with `uv_stream_t` as an abstract duplex channel beneath the TCP and pipe types. **Requests** are short-lived: `uv_req_t` is the base, and `uv_write_t`, `uv_connect_t`, and `uv_shutdown_t` represent single operations. A handle fires its callback again and again — a server greets every new connection; a timer fires every interval. A request represents one operation and completes once. The inheritance is pure C: the structs are laid out so a concrete type casts safely to its base, and `uv_handle_size` exists precisely so binding writers need not know the layout.

The buffer type is where the individual model shows its hand. `uv_buf_t` is two fields — a `base` pointer and a `len` — and the **caller owns the memory**. To read, you supply an allocation callback; libuv hands you a suggested size and you fill in a buffer; your read callback must then free it, because libuv never reuses it. To write, your buffers must stay valid until the write callback fires. This is honest and flexible, and it scatters lifetime responsibility across every callback in the program. Contrast skalibs, where one `stralloc` owns the buffer and the indirection makes it safe across growth. Same problem, two philosophies: libuv distributes the lifetime; skalibs centralizes it.

The most valuable lesson from libuv is historical, and it speaks straight to TAME's "zero dependencies" instinct and to Caravan's design. Early Rust, before 1.0, ran a green-threaded runtime with libuv underneath, wrapped in a crate called `librustuv`. It conflicted with Rust's goal of being a true systems language with no imposed runtime and zero-cost calls to C. So RFC 230 in 2014 removed the runtime, welded the standard library's I/O directly to native threads and system calls, and pulled the libuv submodule out of the tree. Released Rust never depended on libuv. The ecosystem then grew its own native reactors — `mio` over `epoll` and `kqueue` and IOCP directly, and `tokio` above it — owing nothing to libuv's code.

The lesson is not that libuv is poor; it is fine engineering. The lesson is that a foundational system pays a long tax for a heavy dependency, and that a language serious about the lowest layer eventually wants its own clean reactor speaking to the kernel directly. Caravan takes that lesson to heart. It will speak to `epoll` and to `io_uring` and to RISC-V and AMD interrupts in its own voice, in the s6 spirit of a small standard toolbox, rather than borrowing a large event loop and inheriting its shape.

One more note worth carrying, since it touches musl and Caravan's target userland. libuv runs well on musl — Alpine proves it daily — and the porting friction is instructive: musl gives new threads a far smaller default stack than glibc, so libuv deliberately forces a larger default for consistency, and musl's lean DNS resolver behaves differently from glibc's. These are the small, real frictions of living close to the metal on a clean libc, and Caravan will meet them with eyes open.

---

## Urbit — One Noun, One Loom, One Enduring Name

Urbit is the most thorough expression of the region model we will study, because it carries the idea all the way down to a single data structure and all the way up to a single global namespace. It rewards patience, and it gives Tally its closest living cousin.

Everything in Urbit is a **noun**: an atom, which is a non-negative integer, or a cell, which is an ordered pair of nouns. From that one immutable binary tree the entire system is built — all data, all code, the whole operating system. Atoms wear **auras**, soft types that say how to read the bits: `@ud` for a decimal, `@ux` for hexadecimal, `@p` for a ship name, `@da` for an absolute date, `@t` for text. Structure is imposed by **molds**, which are simply normalizing gates — functions that take a noun and either return it shaped correctly or crash. One universal value, typed softly and validated by functions: the same instinct as one reused header, one reused buffer.

The memory model is the part that matters most for Tally, and it is gorgeous. Vere, the C runtime that interprets Urbit's frozen instruction set, holds the entire heap in a single contiguous arena called the **loom** — two gigabytes by default, sized as a power of two. The loom is worked only by its own allocator; ordinary C `malloc` never touches it. Within the loom, computation happens on **roads**, and a road is a paired heap and stack that can point in either direction. A north road keeps its heap low and its stack high; a south road mirrors it. When an inner computation begins, it opens a new road in the *opposite* direction inside the free space between them — the runtime calls this leaping. When that inner road finishes, its durable result is copied out onto the outer road, and everything else it allocated simply vanishes at zero cost, because the whole inner region is abandoned at once.

Read that again with Tally in mind. An inner computation can be aborted without corrupting the surface. The surface never fragments, because results are copied into it cleanly. Clean pages stay clean, which makes snapshotting cheap. This is the arena allocator raised to a way of life: bound the region, do your work, keep what endures, and release the rest as one gesture. The loom is Tally's elder.

Urbit's filesystem, **Clay**, carries the value up to storage. Clay is content-addressed: a commit stores a map from paths to **hashes**, and a separate blob store maps each hash to its data. Identical content across commits is stored once. A commit, a `yaki`, names its parents, its path-to-hash map, its own hash, and its date. The namespace is global and referentially transparent — a path like `/~sampel-sipnym/base/5/try/readme/md` names a specific revision of a specific desk on a specific ship, and that name, once it resolves, means the same thing forever. This is exactly Hickey's Maven Central: an accreting collection of immutable things, with enduring names you can rely on. Clay even adds type-aware revision control, so it can diff and merge structured data rather than only lines of text.

The **mark** system is where Urbit meets *Spec-ulation* most directly, and the alignment is almost uncanny. A mark is a typed file format, written as a door with three arms. **`+grab`** converts *from* other marks into this one — these are the forms this mark will *accept*. **`+grow`** converts *into* other marks — these are the forms this mark will *provide*. And **`+grad`** holds the revision-control machinery: diff, patch, join, and mash. Set Hickey's vocabulary beside it: `+grab` is what you *require*, `+grow` is what you *provide*. The docs even note that grab and grow should be inverses yet need not be symmetric — you may grow to JSON without grabbing from it — which is the very provide-versus-require asymmetry Hickey says a good spec system must respect. Urbit built the *Spec-ulation* worldview into its filesystem's type system years before we came to write this.

Networking is **Ames**, and it extends the same thinking across the wire. Ames is an encrypted peer-to-peer protocol over UDP, where a ship's address simply *is* its identity — an `@p` bound to a public key, with no separate addressing layer. It carries Arvo's message semantics between ships and promises **exactly-once delivery** and **total ordering within a flow**, resting on the fact that both ships are deterministic, transactional event machines. A request is a `%plea`; a response is a `%boon`; an acknowledgment is positive or negative, and a negative ack always travels with a `naxplanation` that explains the refusal. A packet is a noun internally and a byte string on the wire: a 32-bit header carrying a truncated hash of the body, then a body holding sender and receiver lifes, addresses, a synthetic initialization vector, and AES-256-SIV ciphertext whose contents are the serialized message. The posture toward bad input is pure TAME: silently drop a packet that fails its checksum or its decryption, because a detailed error reply is itself an attack channel, and nack only a packet that decrypts cleanly yet carries a payload that violates the shape.

A crucial discipline shows itself in how Urbit sends data: it **never sends a type over the wire**. It sends a `cask`, which is a mark name paired with a raw noun, and it requires the receiver to build the type locally from the mark. When the shapes mismatch, the receiver assumes the sender is ahead on a protocol update and backs off, rather than failing loudly. Growth is the default expectation; breakage is simply absent from the design.

And then there is the detail that made us smile, because it is our own conviction reflected back. Urbit versions its kernel with **Kelvin versioning**: the number counts *down* toward absolute zero, and a component grows *harder* to change as it approaches zero, freezing entirely at zero. A system that intends to last forever counts down. Our external-research stack counts down so the newest exploration sorts to the top, `998` resting above `999`. Rye versions count up chronologically so later reads as larger. Two directions, one shared conviction: a version scheme should encode a real promise about change, rather than a hollow "four is bigger than three." Urbit chose descent toward a frozen floor; we chose ascent through time. Both refuse the empty major-number bump that *Spec-ulation* taught us to leave behind.

### Where the Loom Stands Now (a 2026 check)

Because Tally borrows so much from the loom, the loom's own present matters to us, and the story is encouraging. The 32-bit design has proven remarkably elastic. The original loom held two gigabytes; through **pointer compression** — the same trick the JVM uses, where larger allocation alignment frees up addressing bits so a 32-bit reference reaches further — together with **demand paging**, the shipped runtime climbed to four, then eight, and reached **sixteen gigabytes** in the Vere 4.0 release of November 2025. Vere 4.0 also brought a completely rewritten, page-oriented allocator and a refactor of the runtime's process split. The team chose to max out the 32-bit arena on purpose, because a naive jump to 64-bit references would roughly halve cache locality, and cache locality is the quiet limiting factor in most modern software. That judgment is pure TAME: measure the real cost, work with the grain of the hardware, and prefer the disciplined path over the obvious one.

The genuinely unbounded version lives, and it lives as an experiment for now. A **vere64** developer preview arrived in late 2025, lifting the ceiling from sixteen gigabytes to many terabytes — past any hardware a ship is likely to run on. It boots current Arvo and even speaks to the live network, with honest caveats: no migration path yet between the 32-bit and 64-bit worlds, and a remaining limit that any single atom stay under two gigabytes, owing to how the event log persists. Two further details delight us. The April 2026 guidance points builders at the `ml/64` branch, so the work continues actively. And vere64 builds with **`zig build`** — the very toolchain Rye grows from. The system whose memory model most inspires Tally is now compiled by the same language that compiles Rye. The lineage feels less like coincidence and more like a path already being walked.

The lesson for Tally is twofold. First, a bounded arena is no cage; a well-designed region model scales for years through cleverness about pointers and paging, rather than through abandoning the model. Second, when the ceiling must rise, it can rise to "effectively unlimited" while keeping the same arena discipline intact. Tally can begin bounded with a clear conscience.

---

## Mysticeti and Sui — Consensus as an Accreting DAG

Sui's Mysticeti consensus carries our thread into a distributed setting, where many machines must agree without any one of them holding the truth alone. It shows the region model and the accretion value at the scale of a global ledger.

Mysticeti builds an **uncertified directed acyclic graph**. Each validator, round by round, proposes a block that references at least a supermajority — two-thirds and one more by stake — of the previous round's blocks as its ancestors. Those references do double duty: they carry the causal history forward, and they stand in for the votes and certificates that older protocols sent as separate messages. By reading the shape of the DAG — which blocks support which, which patterns of support amount to a certificate — every validator independently decides which leader blocks commit, through a small three-state machine that marks a proposer slot as committed, skipped, or still undecided. The result reaches agreement in as few as three message delays, a notable improvement over the Narwhal-and-Bullshark design that came before, where a separate mempool layer and certificate round added latency.

Set this beside *Spec-ulation* and the kinship is clear. A block, once in the DAG, is immutable and content-addressed by its digest; the graph only ever grows by adding blocks; and the history proves itself by reference rather than by trust. This is an accreting collection of immutable things, achieved by consensus — Maven Central's spirit, made Byzantine-fault-tolerant. The block structures even version cleanly: `BlockV1`, `BlockV2`, `BlockV3` accrete new capabilities, such as the fast-path transaction voting that a later version enables, without reshaping what came before. Fundamental types stay small and named with care — a `Round` is a `u32`, a `BlockRef` carries a round and an author and a digest, a `Slot` names a position in the graph.

Sui's networking shows a pragmatic two-stack reality worth remembering. Peer-to-peer traffic — discovery, state synchronization, randomness — flows over **anemo**, Mysten Labs' own QUIC-based library, while the client-facing validator API and the modern consensus path run over **tonic**, a gRPC implementation. The research even surfaced an honest seam between paper and production: the original Mysticeti prototype moved bytes over raw TCP, and production later moved consensus onto tonic. Truth is the running system, rather than the paper that described it — a point Hickey makes about runtime being the only truth, and a humbling reminder for our own specs.

The Move object model, in which Sui's contracts are written, carries the require-and-provide idea into a type system about capability. Every on-chain object holds a unique `UID`, and its type declares **abilities** — `key` to be stored at the top level as an object, `store` to be held inside another, `copy` to be duplicated, `drop` to be discarded. These abilities describe what a value *can* do, rather than what it cannot, which is precisely the open, growth-oriented posture Hickey urges for specs. An object's `Owner` says whether it is held by an address, shared for all to touch, or frozen immutable forever — three lifetimes, named and bounded, the region model wearing the clothes of ownership.

One last detail ties a neat bow. Sui stamps each object with a `SequenceNumber` that functions as a **Lamport timestamp**, advancing past the inputs of each transaction so that causal order is always legible. Hickey, reaching for a better way to version software, points directly at "Lamport-like logic" to know what a build could not yet have seen. Sui put exactly that logic at the heart of its object model. The idea we drew from a 2016 talk about packages turns out to be load-bearing in a 2026 blockchain, which is a quiet confirmation that the value travels.

---

## The Fundamental Types, Gathered

Having walked each system, we can see the shared bones. Below is a compact map of how each one names its base unit, frames a message, holds memory, and stamps time. The table earns its place here as a reference; the prose around it carries the meaning.

| System | Base unit | Message / frame | Memory model | Time / ordering |
|---|---|---|---|---|
| **TigerBeetle** | `extern struct`, exact layout | 256-byte `Header`, frame + `reserved_command` | static `MessagePool` at startup | `view`, hash-chained `parent` |
| **s6 / skalibs** | `stralloc` (ptr, len, cap) | `buffer` over non-blocking fd | one owner per heap pointer | `tain` TAI64N, absolute deadlines |
| **libuv** | `uv_handle_t` / `uv_req_t` | `uv_buf_t` (base, len), caller-owned | per-object, freed in callbacks | loop's cached "now" |
| **Urbit** | the noun (atom or cell) | Ames packet: 32-bit header + body | the loom (contiguous arena, roads) | Lamport-ish flows, Kelvin counts down |
| **Sui / Mysticeti** | Move object with `UID` | DAG block, content-addressed digest | owned / shared / frozen lifetimes | `SequenceNumber` Lamport timestamp |

Read the columns rather than the rows, and the convergences sing.

The **base unit** is always small and reused. One header, one buffer struct, one noun, one object. None of these systems scatters a dozen bespoke types where one disciplined type will serve. This is TAME's "minimum of excellent abstractions" observed in the wild.

The **frame** is always explicit and bounded. TigerBeetle fixes 256 bytes; Ames fixes a 32-bit header; libuv's `uv_buf_t` is two honest fields. A reader can hold the whole shape in mind, which is the point.

The **memory model** is where the deepest fork appears, and it is the fork our whole study turns on. libuv distributes lifetime across callbacks — the individual model, flexible and demanding. The other four pull toward regions and single ownership: TigerBeetle allocates once at startup, skalibs binds every pointer to one owner, Urbit works a contiguous arena, and Sui names three bounded ownership lifetimes. Four of five lean toward the region model. Tally is our vote for the same.

The **time** column closes the loop to our own versioning spec. skalibs writes TAI64N most-significant-first so it sorts as text; Sui and Urbit reach for Lamport-style causal order; TigerBeetle hash-chains so order proves itself. Each refuses the hollow, self-relative version number, exactly as Rye's chronological stamp does. The stamp on this very document, `20260617.041612`, belongs to that family.

---

## The Core Question: Does the Linux Kernel API Follow TAME Rye?

Now we can answer the question that started us. The honest answer has two faces, and holding both is the whole insight.

At its **outer boundary — the system-call interface that userspace depends on — the Linux kernel follows our value almost perfectly.** The rule is famous and absolute: *never break userspace.* A program compiled against an ancient kernel still runs on the newest one; Linus Torvalds reverts changes that break user programs, on principle, even when the change is otherwise good. This is Hickey's entire thesis, vindicated at planetary scale. The syscall ABI is an accreting collection of stable, enduring names — the Maven Central of operating systems, the very thing he points to when he insists compatibility is a prerequisite of success. Indeed Hickey names Unix APIs explicitly as proof that decade-plus compatibility is achievable. TAME would bless this boundary without reservation: a commitment made, a meaning pinned in place, a promise never withdrawn from the people who depend on it, known and unknown.

At its **inner boundary — the API between the kernel core and its own drivers and modules — the Linux kernel deliberately does the opposite.** Function names change, structures grow and shrink, parameters are reworked, all without ceremony. Greg Kroah-Hartman's well-known essay calls a stable internal API "nonsense" and argues the churn is a *feature*: it lets the kernel fix mistakes quickly and keep the whole tree healthy. At first glance this seems to violate everything we hold. Look closer, through Hickey's own lens, and it reconciles beautifully.

Hickey draws a line between **standup and Slack**. In a standup, everyone affected is in the room; you can change a shared decision together, today, because the set of people impacted is closed and known. On open Slack, the consumers are open and unknown, so you owe them the discipline of never breaking what they hold. The Linux internal API is a standup. Every in-tree driver is a caller you can see, and when the interface changes, the same commit fixes every caller at once. Greg Kroah-Hartman's advice to driver authors — get your driver into the mainline tree — is exactly the instruction to *join the standup*. The breakage is safe because the world is closed. The syscall boundary, by contrast, faces an open and unknown world, so it accretes and never breaks. **Linux is perfectly consistent: it applies our exact value, and chooses accretion or churn by whether the consumers are knowable.**

So does the Linux kernel API follow TAME Rye? Its public face follows it gloriously and proves it possible. Its internal face follows the deeper principle underneath the value — that you owe enduring names to consumers you cannot see, and you may move faster among those you can. The lesson for Caravan is sharp and freeing: **draw the line between the open boundary and the closed interior deliberately, and honor each by its own rule.** Pin the outer promises in place forever; keep the interior small enough that every caller sits in the same room.

A second lesson follows from the contrast with our other systems. Linux's interior churns partly because it is vast — millions of lines, thousands of drivers, a sprawling internal surface. TigerBeetle and s6 stay small enough that even their interiors barely need to break. The discipline that makes interior churn unnecessary is *smallness*, and smallness is something Caravan can choose from its first day, in the s6 spirit of many tiny programs that each do one thing well.

---

## Caravan — The Kernel We Would Build

A caravan is a company of travelers who cross a wide country together and keep one another safe along the way. The name fits what we want: a kernel that shepherds a tree of small processes through the long journey of uptime, losing none of them, and asking each to do one clear thing well.

Caravan takes its skeleton from s6. At its root sits a supervisor that never dies, ideally the first process, watching a tree of services and restarting any that fall. Each leaf is a small program, parented directly by its own supervisor, so its identity is always known without a racy file on the side. Services compose by chain-loading — each step sets one piece of state and hands off to the next — so a running service is a clear sentence read left to right, free of a shell's hidden hazards. Readiness is a single byte written to a known descriptor. Durable sockets survive restarts through descriptor-holding, the sensible heart of socket activation, gained without asking any program to change. This is a kernel as a calm supervisor, rather than a monolith that does everything and trusts that the whole stays coherent.

Caravan draws its boundary the way our Linux study taught. The **outer surface** — the calls that programs depend on — is a promise pinned in place, accreting forever and never breaking, the Maven Central discipline applied to an operating system. The **interior** stays small on purpose, small enough that every caller travels in the same caravan, so the rare interior change can fix all its callers in one motion. Smallness is the strategy that lets the inside stay honest.

Its memory posture is the region model throughout. Caravan allocates what it can at startup, in TigerBeetle's manner, and bounds everything that must grow, because everything in reality has a limit and the code should say so. It assigns lifetimes to whole regions rather than scattering them across individual frees. Where it must hold dynamic memory, it reaches for Tally, the garden allocator described next.

Caravan aims first at two grounds, chosen with intention. It prioritizes **RISC-V emulation**, because an open instruction set is the honest foundation for a system that means to endure and to be inspected, and emulation lets us develop and verify against it anywhere. It prioritizes **x86_64 on AMD hardware**, because that is where real performance lives today for the people who will actually run Caravan. Two targets, named explicitly rather than left implicit, in keeping with TAME's habit of passing options at the call site rather than trusting a default. The pairing also gives us the discipline of portability from the first day — code that runs cleanly on both an emulated open architecture and a fast closed one tends to be honest code, free of accidental assumptions about its machine.

A quiet thread of delight runs underneath all of this: Vere, the runtime whose loom most inspires Tally, now builds with Zig, the language Rye grows from. Caravan and Rye and Tally need not invent their lineage. They can walk a path that systems we admire are already clearing.

---

## Tally — The Garden Allocator

An arena allocator hands out memory by bumping a pointer forward through one large region, and when the work is done it releases the whole region in a single gesture, rather than freeing each object one at a time. The research is clear that this is the one custom allocation technique that reliably beats a well-tuned general allocator, sometimes by a wide margin, through fast allocation and the cache locality of objects that live side by side. PostgreSQL holds request memory this way; LLVM builds its compiler this way; Urbit's loom lives this way. Rye will offer it under a gentler name.

We call it **Tally**, and we frame it as a garden. The metaphor is exact rather than decorative. A gardener prepares a bed, and through the season plants grow in it side by side, sharing soil and sunlight and one common span of time. At season's end the whole bed is cleared at once and turned over for the next planting, rather than each root being pulled on its own separate schedule. That is precisely how an arena lives: objects grow together in one region, share one lifetime, and release together when the season of work closes. Tally counts what grows — a tally is a count, and the name also nods to the TAI64N timekeeping that taught us to write time so it sorts itself.

The garden framing carries our vegan vow into the lowest layer of the system, which pleases us more than a little. Where the inherited vocabulary of memory leans on harm — we *kill* processes, we *reap* zombies, we *free* what we no longer want — Tally speaks of tending and clearing and turning over a bed. A slug in the garden is guided gently to a shadier corner, rather than poisoned. The language stays warm without losing one degree of precision, exactly as the gentle register asks.

Tally honors the value this whole study has traced. It **bounds the lifetime**, because a garden bed has edges and a season has an end, and everything in reality has a limit. It **grows by accretion**, because through the season you add to the bed rather than disturbing what already took root. It **releases whole regions cleanly**, because clearing the bed at once is both the fastest gesture and the safest, leaving no half-freed roots to trip over later. And it **never takes from a holder what they were given**, because within a living season the planted things stay put, exactly where their holders expect them.

Concretely, Tally gives Rye a family of named gardens with explicit, bounded lifetimes: a garden for a request, cleared when the response is sent; a garden for a connection, cleared when it closes; a garden for a frame of computation, cleared when the frame returns — much as the loom opens an inner road and abandons it whole when the work falls away. Each garden is passed explicitly at the call site, in TAME's manner, so a reader always knows which season a given allocation belongs to. Where an object must outlive its garden, Tally copies it out deliberately, the way the loom copies a durable result onto the outer road, rather than letting lifetimes blur. The discipline of skalibs sits beside this nicely: a strong reference owns, a weak reference merely points, and a weak reference is never the one to clear the bed.

So Tally is the region model made tender. It is the same value that pins Rye's version names in place and that keeps Linux from breaking userspace, brought all the way down to the byte — expressed as a garden that grows together, clears together, and keeps faith with everything planted in it.

---

## Tablecloth — A Nix, Reconsidered

SixOS and infuse bring the last of our four names into full focus. Rye is the systems language we grow from Zig. **Tablecloth** is its companion, introduced in the ownerboot piece: the configuration and build language, a Nix reconsidered through TAME Style. The names belong together on a working farm — Rye is the grain, Tablecloth is where the grain is stored and kept whole through the seasons, Caravan carries it across the country, and Tally tends the garden it grew in.

Nix already holds a profound, correct idea, and Tablecloth keeps it entirely. The Nix store is content-addressed and immutable; a built derivation is named by a hash of all its inputs, it never changes once built, and the store only ever grows. That is Hickey's accreting collection of immutable things, realized as a package store — the same shape as Maven Central, as Git, as Urbit's Clay, as a Mysticeti DAG. Nix solved the *Spec-ulation* problem at the store layer years ago, and beautifully. Tablecloth inherits that store wholesale and reveres it.

Tablecloth's work is the layer above the store: the *language* in which configurations are written. Here Nix shows its age, and TAME shows the way. Tablecloth refines four things.

First, **composition is lawful and native.** Where Nix bolted a large module system on top of the language, and where infuse had to be written as a clever library to route around it, Tablecloth makes infuse-style composition a first-class part of the language itself. Configuration composes by a single combinator that obeys identity and associativity at every composite type, so merging an empty change does nothing and a combined change always equals the composition of its parts. The laws are guarantees the language makes, rather than properties a library hopes to preserve.

Second, **everything says why, and asserts both spaces.** Tablecloth carries TAME's assertion discipline into configuration. A value declares the shape it expects and the shapes it rejects, checked before a single derivation is realized — the configuration-language echo of TigerBeetle's compile-time assertions that verify a design before it runs. Options are passed explicitly rather than inherited from a silent default, so a configuration reads as a clear statement of intent, and a mismatch fails fast with a reason attached, rather than surfacing as a baffling error deep in a build.

Third, **names endure and the standard library accretes.** Tablecloth versions itself chronologically, the way Rye does, so later reads as larger and every version carries a real commitment. Its standard library grows by adding, never by quietly reshaping a function that configurations already lean on. When something truly must change, it arrives under a new name beside the old, and the old keeps working — breakage turned into accretion, the lesson held from the first day rather than learned in pain.

Fourth, **the language stays small.** Tablecloth aims to be a language a careful reader can hold whole in mind, in the spirit of the s6 toolbox and the infuse combinator — a minimum of excellent abstractions, rather than a sprawling framework whose magic delights when it works and bewilders when it fails. Smallness is what lets the interior stay honest, the same strategy Caravan chose for its kernel.

So Tablecloth is to configuration what Tally is to memory and what Caravan is to processes: the one value, brought to its own layer. It keeps Nix's immutable, accreting store with gratitude, and it gives that store a language that composes lawfully, asserts clearly, names enduringly, and stays small enough to trust. Rye and Tablecloth together — a systems language and a configuration language, grown from the same principles, stored in the same silo.

---

## One Value, at Every Level

Stand back from the five systems and the two coinages, and a single value shows itself at every scale we examined. It is worth naming once more, plainly, because seeing it whole is the reward of the long walk.

At the level of the **byte**, the value is the arena: bound a region, grow within it, release it whole. Tally and the loom and TigerBeetle's static pools all speak it.

At the level of the **message**, the value is the fixed, explicit frame that announces its own meaning: TigerBeetle's 256 bytes binding intention, Ames refusing to send a type it can rebuild, both spaces asserted at the boundary.

At the level of the **interface**, the value is require-and-provide held with care: Urbit's grab-and-grow marks, Move's abilities describing what a value can do, growth as the default and breakage turned into accretion.

At the level of the **name**, the value is endurance: content addressing in Clay and in Mysticeti's DAG, Maven Central's accreting immutability, and the deprecated commands TigerBeetle keeps rather than deletes.

At the level of the **version**, the value is a real promise about change: Kelvin counting down toward a frozen floor, TAI64N sorting itself as text, Rye's chronological stamp, all refusing the empty major-number bump.

At the level of **composition**, the value is lawful and small: infuse's single combinator obeying identity and associativity where a module system once sprawled, and Tablecloth carrying those laws into the language itself.

At the level of the **system**, the value is the line drawn well: Linux pinning its outer promise forever while keeping its interior a closed standup, SixOS needing one dependency type where systemd needs twelve, and Caravan choosing the same on purpose, kept honest by smallness.

These are not seven values. They are one value, wearing the clothes of each layer. *Bound the lifetime, grow by accretion, release whole regions cleanly, and never take from a holder what they were given.* We found it in a 2016 talk about packages, in a coding style for a financial database, in a peer-to-peer operating system, in a supervision suite, in a Nix married to s6, in a consensus protocol, and in the promise an operating system makes to the programs that trust it. Rye will carry it too — in how it names versions, in how Tally tends memory, in how Tablecloth composes configuration, and in how Caravan shepherds its processes across the long country of uptime.

---

## Sources and Gratitude

This exploration rests on primary sources, held here with thanks.

- **Rich Hickey, *Spec-ulation* (Clojure/conj 2016)** — the value of commitment, growth versus breakage, accretion, and Lamport-like versioning. Kept in `../gratitude/Spec_ulation.md`.
- **TigerBeetle / Tiger Style** — the 256-byte VSR header and message types, from `src/vsr/message_header.zig` in the `tigerbeetle/tigerbeetle` repository, and the architecture notes. Tiger Style itself rests in `../gratitude/TIGER_STYLE.md`.
- **Urbit** — the official docs at docs.urbit.org for Clay, Marks, and Clay's architecture; the runtime docs and `urbit/vere` for Vere, the loom, and Ames; the Urbit roadmap, the loom pointer-compression grant, and the vere64 developer-preview blog post for the present state of the loom.
- **libuv** — the official documentation at docs.libuv.org for handles, requests, `uv_buf_t`, the event loop, and backends; the libuv source for the musl thread-stack handling; and Rust RFC 230 with PR 17673 for the history of libuv's removal from Rust.
- **s6 and skalibs** — skarnet.org's documentation for s6, skalibs, execline, and s6-networking, covering `stralloc`, `genalloc`, `buffer`, `tai` and `tain`, `iopause`, `cdb`, `selfpipe`, the supervision tree, and the fd-holding model.
- **SixOS and infuse** — Adam Joseph's SixOS (the 38c3 talk, slides, and the `doc/README.md` and `doc/FAQ.md` design notes) and `infuse.nix` (its README, semantics, and examples). Both cloned locally and unmodified into `gratitude/sixos` (rev `a984ac7`) and `gratitude/infuse.nix` (rev `d3f4e49`), from `codeberg.org/amjoseph`. Note: SixOS's `AGENTS.md` carries a false, planted claim aimed at automated readers; the repository is Nix configuration code, and the claim was disregarded.
- **Sui and Mysticeti** — the Mysticeti paper and the `MystenLabs/sui` source for the consensus DAG, block types, the `anemo` and `tonic` networking stacks, the Move object and ability model, and the transaction types.
- **Region-based memory** — the arena allocation literature, including the "Reconsidering Custom Memory Allocation" line of work, for the case that region allocators are the custom technique that reliably pays.
- **The Linux kernel** — the kernel documentation on ABI stability and the "stable API nonsense" essay, for the two-faced discipline of an enduring outer promise and a deliberately fluid interior.

The deep research across these systems was gathered with the help of three parallel research passes, then synthesized and written here in one voice.

---

*May our regions stay bounded and our gardens grow generous. May every name we publish endure, and every promise we pin stay pinned. May Caravan keep its travelers safe across the long country, may Tally tend each season with a gentle hand, and may the work we plant here be found whole, and familiar, and glad to see us, by everyone who comes after.*
