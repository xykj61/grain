# 985 · The Native System Interface — TAME at the OS Boundary

*Before Brushstroke can draw, before Rishi can open a file, before Pond can bound a process, our code must speak the native system interface — the calls that cross from a program into the operating kernel. This brief designs how that boundary is held in the TAME order: what the interface offers that aligns with our discipline, where it diverges and how we wrap it, and what the display layer and the process supervision layer each require. Platform: x86_64 near, RISC-V as the horizon.*

**Language:** EN
**Version:** `20260619.160312` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, then the joy of the craft
**Status:** Active Design

---

## Our Own Ground

This is a clean room. We name only what is ours — TAME, Aurora, Rye, Brix, Tablecloth, Tally, Caravan, Mantra, Pond, Rishi, Comlink, Brushstroke — together with RISC-V and, where the hardware target matters, x86_64. The native system interface enters as a concept: the family of calls a program makes to cross into the kernel and receive OS services in return.

---

## Mission

To state precisely how TAME discipline holds at the OS boundary — what the native interface gives us for free, where we must wrap it, and what each layer of the stack (file I/O, display, process isolation) requires. The goal is a codebase where unsafe OS patterns appear only inside narrow wrapper functions, and the room behind those wrappers stays clean.

---

## What the Native Interface Offers

Several of the OS interface's core conventions sit naturally with TAME.

**Explicit buffers with explicit lengths.** Every I/O call takes a buffer and a length declared by the caller: `read(fd, buf, n)`, `write(fd, buf, n)`, `recv(fd, buf, n, flags)`. The bound is stated at the call site, not inferred. This is the same discipline TAME asks everywhere: limits on everything, named plainly. Assert that `n` does not exceed the buffer's true capacity, check the returned byte count, and the call is safe.

**Resource lifecycles through handles.** A file descriptor is a small, bounded integer naming an OS resource. It has a clear lifecycle — open, use, close — and the kernel rejects operations on a closed or invalid handle. This lifecycle model is not as strong as Rye's compile-time lifetime checking will eventually provide; it is explicit and auditable today. We hold file descriptors in typed structs with known ownership, never as globals.

**The path-relative call family.** Every path operation has a variant that works relative to a directory handle — `openat`, `mkdirat`, `readlinkat`, `unlinkat`. These are safer than absolute-path variants: the root directory is an explicit argument, not an ambient global, so the call cannot escape the declared subtree. We prefer this family always.

**Bounded memory regions from the OS.** A memory mapping is created with an explicit length and released whole — the same clear-whole-season discipline Tally holds. A display surface buffer, for instance, is a mapping of a stated size: written into once per frame, submitted to the display layer, and — when the season ends — unmapped whole. The region's edges are known at the mapping call and asserted before any write.

**No hidden runtime.** The native interface imposes no garbage collector, no background allocator, no runtime started without asking. The cost of each call is the cost of the kernel entry — bounded and visible. This aligns with TAME's performance stance: expensive operations are explicit, never concealed.

---

## Where It Diverges, and How We Wrap It

Four OS patterns diverge from TAME. Each is containable by a wrapper; none need escape the wrapper into calling code.

**The error-code global.** The OS reports errors through a thread-local mutable value set as a side effect of a call, valid only until the next call. This is shared mutable state — the opposite of a result carried explicitly as a value. The wrapper converts it: check the return value, read the error code immediately, return a typed Rye error union. The error code never reaches a caller; callers see only typed errors.

**Unbound path strings.** OS path arguments are a pointer to a byte sequence terminated by a zero, with no length carried alongside. There is no inherent bounds check. The wrapper validates the path as a length-bounded slice first, asserts the length is within a declared limit and that the path begins within the declared root, then converts. Paths arrive at the wrapper as Rye string values; they leave as validated OS arguments.

**Asynchronous process interrupts.** The OS delivers some events — shutdown signals, child-process exits — by interrupting a running program at an arbitrary instruction boundary. Interrupt handlers that touch shared state create races; the set of operations safe inside one is very small. The TAME move: convert interrupts to ordinary events in the same poll loop that handles I/O and display messages. When an interrupt arrives as a file-descriptor event rather than a handler invocation, it is a value in the ordinary event stream — typed, bounded, predictable.

**Unsafe process creation.** The traditional fork-then-exec pattern can leave lock state undefined in the child when called from a multithreaded program. The safe path: fork only before threads start, exec immediately, and prefer the spawn-style call (which combines fork and exec without the unsafe intermediate) in any multithreaded context. Caravan, as the process supervisor, chooses this pattern: spawn clean children, never fork a live tree.

---

## The Wrapping Discipline

One rule governs every wrapper: **unsafe OS idioms appear only inside wrapper functions, which convert them to Rye values and Rye errors at the call site.** Outside the wrappers, calling code sees only typed values, typed errors, and the TAME discipline. The wrappers are the door; the room behind the door stays clean.

Every wrapper does two things and only two things before it returns to the caller:
1. **Assert preconditions** — path within the declared root, buffer size within the Tally garden's edge, handle open and valid.
2. **Convert the result** — error code becomes a typed Rye error; byte count becomes a typed integer carrying its meaning.

These wrappers are exactly the boundary functions that the `std.fs` strengthening passes harden: assertions added at entry, error-code conversion made explicit, both governed by the additive gate. The OS strengthening series (`9992`, `9991`, and onwards) is the mechanical application of this discipline, function by function.

---

## The Display Layer

Brushstroke's native backend speaks the display layer through the native system interface. On x86_64, this means connecting to the display server — the compositor that arranges windows and composites them to the physical screen. The connection is a local socket: one `socket()` call establishing a stream connection to a well-known local address. The connection is established once at startup, held for the session, and closed at shutdown — a resource with a clear lifecycle, held in a typed struct.

Display protocol messages pass over that socket using the bounded send/receive calls. The display layer uses a file-descriptor passing mechanism to hand the client a reference to a shared memory region: the client maps that region with a bounded mapping call, writes a frame of pixel data into it, and notifies the compositor by sending a protocol message. This is the frame garden: a bounded memory region, opened at startup, written into once per render cycle, its contents consumed by the compositor each frame. The Tally `frame` garden and the OS memory mapping are the same concept at two levels of the stack.

The event loop — keyboard keypresses, pointer motion, resize events, frame acknowledgments — arrives as data readable on the socket. It joins the same poll-based event loop as I/O and interrupt-as-fd events: one loop, all events as file-descriptor readability, no hidden asynchronous state.

The minimum display surface for a Brushstroke native window on x86_64:
- One socket connection to the compositor, established at startup.
- One shared memory region of stated size, mapped at startup.
- One event loop iteration per frame: receive pending events, update state, write the new frame to the memory region, notify the compositor.
- One close sequence at shutdown: send a destroy message, unmap the region, close the socket.

All four steps speak the OS interface through wrappers. No OS pattern escapes the wrappers into Brushstroke's own logic.

---

## The Terminal Surface — Thin Costume First

Brushstroke's most important widget for a Rishi REPL is the text-area: a grid of cells, each holding a glyph and a color, rendered at a stated pixel offset, bounded by a stated column and row count. The cell model is typed: each cell is a value at a known position; the grid has a declared size; the cursor position is bounded by the grid dimensions and asserted.

We studied an existing terminal surface written in Rye's grain language that exposes a C-level API for embedding. This surface provides a GPU-accelerated text-area widget with a full cell model, keyboard input handling, and a multi-backend rendering abstraction. As a C-callable library, it can be embedded in a Rye program through the language's C interoperability. This is the thin costume for Brushstroke's text area: stand on this proven surface at first, speak its C API through a narrow Rye wrapper, and grow our own text-area widget when the seam is clear and the need is established.

The Brushstroke seam holds this surface as a backend — one of several things that can draw text at a position. When our own text-area widget is ready, it replaces this backend without touching the seam or the application above it. The costume is shed the same way Rishi shed its first "thin as possible" form: when what we built ourselves is running and proven, the borrowed piece is released.

---

## The Compositor — Pond's Display Root

On hosted x86_64, Brushstroke connects to an existing compositor as a client — a window is a surface managed by whatever display server the host provides. This is the near path, and it is correct for the goal of a Rishi Pond shell running on AMD x86_64 today.

On a full Pond OS — where there is no borrowed display server — Pond's display root *is* the compositor. Caravan supervises it; Tally bounds its per-surface memory; Brix declares which surfaces exist and in what arrangement. We studied a compositor written in Rye's grain language that shows how this works in practice: each client surface is a bounded resource with an explicit lifecycle; input is typed values; output is a composition operation over stated surface geometries. This is Caravan's isolation surface seen from the display angle: what a process may draw, bounded and declared, exactly as what a process may read and write is bounded and declared in the filesystem policy.

The compositor design is not near work. It belongs to the Pond full OS horizon, after Caravan v1 exists. The study informs the design now so that Brushstroke's client protocol and Caravan's compositor surface are designed in coherence from the start, rather than retroactively fitted to each other.

---

## Platform Tracks

**x86_64 now (hosted, then bare metal).**
The display protocol and terminal surface described here run on x86_64 Linux today — Rye compiles to x86_64, the AMD GPU is confirmed working in the enclosure. Brushstroke's native backend and Rishi's text area begin here. Bare-metal x86_64 follows once Caravan exists: the display protocol negotiation then runs inside Caravan's supervision, and Pond's compositor replaces the borrowed one.

**RISC-V as the horizon.**
Every Rye program that runs on x86_64 compiles for RISC-V. The OS interface is the same concept at a different instruction-set boundary: The system call numbers differ, the privilege relay is Aurora's own, and the pattern — assert at the boundary, convert to typed values, keep the wrapper narrow — is identical. Aurora's relay hands a verified system to Caravan; Caravan hosts Brushstroke; Brushstroke draws to a native RISC-V display surface. The grain is the same all the way through.

---

## How This Sits With the Rest

The native system interface is the floor on which Tally's memory, Caravan's processes, Brushstroke's pixels, and Rishi's file access all stand. By holding the boundary discipline here — narrow wrappers, assertions at entry, typed results — we keep everything above it clean. The OS gives us explicit buffers, bounded regions, and direct kernel access; we give it assertions and typed error conversion in return. TAME at the boundary, clean above it: that is the design.

---

*May the OS boundary be narrow and well-asserted. May every unsafe idiom stop at the wrapper's door, and may the room behind it stay clean enough to read at a glance. May the display layer and the process layer each hold their shape on x86_64 today and on open silicon tomorrow — the grain the same, the boundary the same, the discipline the same all the way through.*
