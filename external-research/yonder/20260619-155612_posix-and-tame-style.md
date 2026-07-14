# 977 · POSIX at the Door — What the OS Interface Asks of TAME, and How River and Ghostty Show the Way

*POSIX is the oldest interface to the operating system — a standard that names what a program may ask the kernel to do. Before Brushstroke can draw, before Rishi can open a file, before a Pond enclosure can bound a process, our code must speak POSIX. This piece asks whether POSIX compliance is TAME style, reads the answer with care, and shows what River and Ghostty demonstrate about how to use the OS interface in the Zig grain — which is our grain.*

**Language:** EN
**Version:** `20260619.155612` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME priority — safety, performance, then the joy of the craft
**Status:** Research

---

## The Question

Is POSIX compliance TAME style?

The quick answer is: **parts of it are, parts of it are not, and the discipline is in knowing which is which and wrapping the rest at our own boundary.** The longer answer is what this piece is.

POSIX is a family of interfaces rather than a single design. File descriptors and bounded read/write calls are safe by construction when used with discipline; the errno global and raw signal handlers are not. Our work is not to adopt POSIX wholesale or to refuse it wholesale. It is to use exactly the parts that sit with the TAME order — safety first, performance second, joy third — wrap the rest at a narrow boundary we control, and keep that boundary the only place in our code where POSIX's unsafe idioms appear.

---

## What POSIX Gets Right

**Explicit buffers, explicit lengths.** Every POSIX I/O call takes a buffer and a length: `read(fd, buf, n)`, `write(fd, buf, n)`, `sendmsg(fd, msg, flags)`. The buffer size is stated at the call site, not inferred. This is the same discipline TAME asks everywhere: bounds on everything, stated plainly. A bounded `read` is a bounded `read`; the danger lies in failing to assert that `n` does not exceed the buffer's true capacity, and in failing to check the returned byte count. Assert both, and the call is safe.

**File descriptors as bounded resources.** A file descriptor is a small integer naming a kernel resource. It has a clear lifecycle — open, use, close — and the kernel refuses operations outside that lifecycle with EBADF. This is not as safe as Rye's lifetime system will eventually be; it is an explicit lifecycle model, which is closer to TAME than to hidden allocation.

**The `*at` syscall family.** `openat`, `mkdirat`, `readlinkat`, `fchownat` — every pathname operation has a variant that works relative to a directory file descriptor rather than an absolute path. This matters for two TAME reasons: it prevents path traversal (the file can only be reached within the given directory's subtree), and it makes the path boundary auditable (the root directory is an explicit argument, not an implicit global). We prefer the `*at` variants always.

**`mmap` with stated bounds.** `mmap(NULL, length, PROT, FLAGS, fd, 0)` creates a mapping of an explicit, stated length. When the season ends, `munmap(addr, length)` releases it whole — the same clear-whole-season discipline Tally holds. A Wayland shared memory pool is an `mmap`; Brushstroke's frame garden maps naturally onto it. Bounded at creation, released at submission — the frame season in the OS's own terms.

**Direct syscalls, no hidden runtime.** POSIX calls are thin wrappers over kernel entry points. There is no garbage collector, no hidden allocation, no runtime started without asking. The cost of a POSIX call is the cost of a context switch — known, and bounded. This aligns with TAME's performance stance: the expensive operations are visible, not concealed.

---

## Where POSIX Diverges from TAME

**The errno global.** POSIX error reporting is a mutable global variable, `errno`, set as a side effect of a syscall and valid only until the next syscall. This is the exact opposite of what TAME asks: a result is a value, carried explicitly, not a shared mutable state read on the side. Zig converts errno to typed error unions at the call site — `!void`, `!usize`, `error.AccessDenied` — which is the TAME move. Our discipline: errno never escapes the wrapper function. The wrapper converts it to a Rye error union and returns; callers see typed errors, not a global.

**Null-terminated C strings.** POSIX path arguments are `const char *` — a pointer to memory terminated by a zero byte, with no length carried alongside. There is no bounds check; the caller must ensure termination and must know the length to validate it. Zig makes this visible by requiring an explicit conversion (`std.posix.toPosixPath`) and offering the slice-based `*at` variants that do not require null termination. Our discipline: validate paths as Zig slices (with explicit lengths) before converting; assert the length is within a stated bound.

**Signal handlers.** POSIX signals interrupt a running program asynchronously — a signal handler may run at any point between instructions, touching whatever memory it can reach. In a multithreaded program, this is a deep source of data races; even in a single-threaded one, it constrains which functions are safe to call inside the handler to a small, explicitly-named set. Signal handlers are hidden shared-state channels — the opposite of TAME values flowing explicitly. Our discipline: avoid signal handlers where possible. On Linux, `signalfd` converts signals into file descriptor events — the same poll/epoll loop that handles Wayland messages handles signals, with no shared mutable state. Where a signal handler is unavoidable (SIGTERM for process shutdown), it sets one `volatile` flag and does nothing else.

**`fork` in multithreaded programs.** `fork()` copies the process and carries only the calling thread into the child, leaving the other threads' locks in unknown states. This is unsafe by construction in a multithreaded program. Our discipline: if we use `fork`, we use it only before threads are started, or we use `posix_spawn` (which is closer to the `execve` pattern and safer in threaded contexts). Caravan, supervising a tree of processes, chooses the safe fork/exec pattern: fork in a single-threaded context, exec immediately in the child, never fork a multithreaded process.

---

## The Wrapping Discipline

The principle is simple: **POSIX's unsafe idioms appear in our codebase only inside wrapper functions that convert them to Rye values and Rye errors at the call site.** Outside those wrappers, the calling code sees only typed values, typed errors, and the TAME discipline. The wrappers are the door; assertions and type conversion live at the door, and the room behind it stays clean.

This is not new. It is what the strengthening strategy (`998`) already asks for the `std.fs` calls Mantra needs: boundary assertions at entry (path non-empty, within root, within the declared buffer size), error conversion to Rye error unions, an integration test that exercises the full round-trip. The pattern holds for every POSIX surface we touch.

Two things the wrappers must always do:
1. **Assert preconditions before the call** — the path is within the declared root, the buffer is large enough, the file descriptor is open.
2. **Convert the result before returning** — error code becomes a typed Rye error; the returned byte count is checked against the requested length and returned as a typed value.

Two things the wrappers must never do:
1. Let `errno` escape to the caller.
2. Accept a C string without a length-bounded Zig slice first.

---

## River: POSIX and Wayland in the Zig Grain

River is a Wayland compositor — the display server for a family of tiling windows — written in Zig. It speaks POSIX for every Wayland interaction, and it does so in a way that is as close to TAME as the POSIX interface allows. Studying River teaches us what Brushstroke's Wayland client must speak.

A Wayland connection is a POSIX Unix domain socket. The client calls `socket(AF_UNIX, SOCK_STREAM, 0)` — bounded, typed, explicit. The compositor's socket path comes from the `WAYLAND_DISPLAY` environment variable, validated before use. The connection is established once at startup and held for the session — a resource with a clear, stated lifecycle. River's implementation shows the pattern in Zig's own idiom: the socket is a file descriptor passed through a typed struct, never a global; its error path returns typed Zig errors, never raw errno.

Wayland messages pass between client and compositor over that socket using `sendmsg` and `recvmsg` — the variants that can carry file descriptors as ancillary data (`SCM_RIGHTS`). This is how a compositor hands a client a shared memory file descriptor, which the client `mmap`s as its framebuffer. River shows the fd-passing pattern in Zig: `std.posix.sendmsg` with a `std.posix.msghdr` whose `control` field carries a `cmsg` with the file descriptors — explicit, bounded, typed. No implicit globals, no hidden state.

The shared memory pool is an `mmap` of a stated length — which is the exact Brushstroke frame garden pattern. River creates and destroys these pools as compositor-managed resources; the client (Brushstroke, in our case) will hold its own pool and write a frame into it each render cycle. The pool's lifecycle maps to Tally's season: created at startup, written into once per frame, released at shutdown or when the window's size changes.

River's output — the visible image on screen — is the composition of client surfaces into a scanout buffer. For Brushstroke as a *client* (a Wayland application, not a compositor), we need only the client side: `wl_surface`, `wl_buffer`, `xdg_surface`, `xdg_toplevel`, `wl_keyboard`, `wl_pointer`. River shows how these are managed in Zig and what POSIX calls underlie each step.

---

## Ghostty: a Terminal in the Zig Grain

Ghostty is a GPU-accelerated terminal emulator written in Zig. It is the existing system that most closely resembles what Rishi needs as its presentation layer: GPU-rendered text, a VT100/ANSI terminal state machine, scrollback, a keyboard input model, and a multi-backend rendering seam (Wayland + X11 on Linux, Metal on macOS, WebGL in the browser). Each backend draws through one abstraction; the terminal state machine above it is independent of the backend below.

Two things Ghostty teaches Brushstroke directly.

**The backend seam.** Ghostty's rendering interface is a small, explicit surface: `create a surface at (x, y, width, height)`, `resize`, `draw a frame`, `handle an input event`. The terminal above this surface does not know whether the frame lands on a GPU via Metal, a GPU via Vulkan, or a canvas in a browser tab. This is the seam Brushstroke designs — one interface, many surfaces. Ghostty proves it works at production quality.

**The text-area widget.** A terminal is a text-area widget at its core: a grid of cells, each holding a glyph and a color, rendered at a given pixel offset. Ghostty's cell buffer (indexed by row and column, updated on cursor movement and escape sequences) is the model for Brushstroke's own text-area widget — the most critical widget for a Rishi REPL. The TAME reading: each cell is a value at a known position; the grid has a stated size (columns × rows); the cursor position is bounded by the grid dimensions and asserted.

Ghostty also exposes `libghostty`, a C API that lets another program embed a Ghostty surface. This is the "thin costume first" move for Brushstroke: rather than growing a complete terminal state machine from scratch, Brushstroke's seed embeds `libghostty` via Zig's C interop, giving Rishi an immediate, GPU-accelerated text surface. The Brushstroke seam holds `libghostty` as a backend behind it, the way it will later hold a native surface backend. When we grow our own text-area widget, we remove the `libghostty` backend and keep the seam.

---

## The Design Implications, Stated Plainly

**POSIX compliance is TAME-compatible, not TAME-native.** It demands discipline at the boundary — wrapping errno, validating paths, preferring the `*at` family, avoiding signal handlers, bounding every buffer — and the boundary is where the strengthening passes live. Past the boundary, the calling code is clean.

**Brushstroke's Wayland backend speaks minimal POSIX.** Four syscalls at startup (socket, connect, mmap, optional signalfd); sendmsg/recvmsg in the event loop; munmap at shutdown. Each is wrapped; each asserts at entry; none exposes errno. River shows the pattern; Ghostty proves the pattern produces a working GPU-rendered window.

**Ghostty's thin costume is the right seed for Brushstroke.** The `libghostty` C backend lets Rishi's text surface exist before Brushstroke grows its own text-area widget. The seam is Brushstroke's design; the rendering is Ghostty's. When the native text-area widget arrives, the seam holds and the backend swaps out. This is the method in practice: stand on proven ground, wear a thin costume first.

**River is the full Pond compositor design reference.** If Pond becomes the complete OS — its own compositor, no borrowed display server — River's architecture is what Caravan's display management grows from. Not yet near work; the study should happen before Brushstroke's native backend hardens, so the compositor interface it speaks is designed with the full Pond OS in mind.

---

## Sources and Gratitude

- **River** — Wayland compositor in Zig; `codeberg.org/river/river`. MIT license. To be cloned into `../gratitude/river`.
- **Ghostty** — GPU-accelerated terminal emulator in Zig; `github.com/ghostty-org/ghostty`. MIT license. To be cloned into `../gratitude/ghostty`.
- **POSIX.1-2024** — the IEEE standard itself; the specification of every syscall family studied here.
- **The Wayland protocol specification** — the reference for `wl_surface`, `wl_buffer`, `xdg_surface`, `SCM_RIGHTS` fd-passing, and the SHM pool model.

---

*May the OS boundary be narrow, clean, and well-asserted. May errno stop at the door, and may every buffer and every path be bounded before the kernel sees them. May River show us the compositor we are growing toward, and may Ghostty lend Brushstroke its first true surface while we grow our own. May POSIX serve us faithfully — as a floor, not as a ceiling.*
