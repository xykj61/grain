# Loom — a Scribe-and-Tally monitor for process, activity, and memory

**Language:** EN
**Status:** Mixed -- Active-designing — a design brief, no code yet
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Riyo
**Kin:** [`../caravan/README.md`](../caravan/README.md) · [`../scribe/README.md`](../scribe/README.md) · [`../tally/README.md`](../tally/README.md)
**Discipline:** TAME (`../context/TAME_GUIDANCE.md`) · accrete-never-break · custody first

Caravan already owns the running child — it spawns, it waits, it reaps, it restarts, it names the exit code. Scribe already reads a `.kyri` record zero-copy and tells one format from another. Tally already gives a bounded, named region that clears whole. **Loom is the thin layer that stands between them and simply watches** — it samples what is running, what has just happened, and how much memory is held, folds each reading into a bounded ring, and writes that ring out as a `.kyri` document Scribe can read straight back. It observes; it barely orchestrates; and everything it touches names a maximum before it starts.

This is a brief, not an implementation. It names the module home, the bounded state Loom keeps, the first witnessed lap, and how Loom composes Caravan and Tally without ever taking ownership away from either.

## The name — proposed, and honestly encumbered

**Loom is the *proposed* name, and it must not be seated until a whole-tree grep and Keaton's word clear it.** The comlink-tendency asks for a clear, warm, safe word that collides with nothing already loved — and here the grep tells an honest story that a reader deserves up front:

- **`loom` is already spoken in the tree, three times, as a live metaphor.** The reds-first rule (`.claude/rules/reds-first.md`) closes with *"a lantern that fires twice should become a loom"* — a **loom** there is a caught, recurring failure promoted into a permanent guard. A prior collision-check (`session-logs/20260808-201635_...bron`) flagged `Loom (3 — reds-first metaphor)` and *set it aside* for exactly this reason, and the civic-loom research (`external-research/20260808-200709_...md`) names "Loom" only to decline it, since reusing it would blur the seated image.
- **Using "Loom" for a monitoring module risks two meanings for one word** — the reds-first *promoted-guard* sense and a new *watcher* sense. That is precisely the blur the comlink-tendency exists to prevent.

Yet the weaving image genuinely fits a monitor: a loom holds many threads under even tension and shows, at a glance, when one breaks — which is what jidoka's original loom did, and what this module does for processes and memory. So the name is offered here **as a proposal to weigh, not a decision to adopt**, with the encumbrance named plainly rather than hidden.

**Consent-gated alternatives**, each needing its own grep before it is trusted (these are candidates, not clearances):

| Candidate | Why it might fit | What to check first |
|---|---|---|
| **Tender** | one who tends and keeps watch; warm, plain, active | `Tender` appears only as ordinary English in the tree today — grep `\bTender\b` across `.rye`/`.rish`/`.md` and confirm no seated module or Lexicon term claims it |
| **Vigil** | a kept watch; safe, evocative, short | grep `\bVigil\b` — clear at the code level in this scan, still owed a full-tree pass |
| **Warden** | one who guards a bounded ward | grep `\bWarden\b` — clear at the code level here; confirm against Lexicon |
| **Loom** | the weaving image, jidoka lineage | **encumbered** — collides with the reds-first metaphor (3 hits); adopt only if Keaton decides the watcher sense and the promoted-guard sense can share the word |

The brief writes "Loom" throughout for readability, since it is the target's proposed handle. **Every path below is provisional and moves with the final name.** No file is created by this brief; the grep and the word come first.

## Module home

**`loom/`** — a sibling directory to `caravan/`, `scribe/`, and `tally/`, holding hosted `.rye` and its witnesses, with `loom/bin/` for built binaries exactly as `scribe/bin/` and `caravan/bin/` already do. Loom imports Tally's marks through its own symlinks (`loom/tally_copy.rye -> ../tally/copy.rye`, and `parse_int` / `no_padding` as the samplers need them), matching the seam map in `tally/README.md`. It imports Scribe's reader for its round-trip witness only. It never imports Caravan's supervision internals — the two meet across a file, not across a symbol, which is the whole point of the boundary (see **Composition** below).

Loom sits at Caravan's altitude, not above Pond's policy layer — the same self-imposed ceiling Caravan's own README draws. It watches; it does not decide what a family may run.

## The bounded monitored-state model

Loom keeps exactly three kinds of reading, and **every one names its maximum at construction and asserts the bound at the edge** — TAME's "bound on everything," and the shape Scribe's own `[max_fields]Field` and Tally's `max_gardens = 8` already model in this tree.

### 1. Processes — who is being watched, and their last known state

A fixed table of **watched slots**, sized by a named constant, each naming one process Loom observes:

```
pub const max_watched: u32 = 32;   // the most processes one Loom watches at once

pub const ProcState = enum(u8) {
    unknown = 0,   // never yet sampled
    running = 1,   // present and runnable/sleeping
    stopped = 2,   // present, stopped
    zombie  = 3,   // exited, not yet reaped by its owner (Caravan)
    gone    = 4,   // no longer present
};

pub const Watched = struct {
    pid:        u32,          // the observed pid (0 = empty slot)
    state:      ProcState,    // last sampled state
    rss_pages:  u32,          // resident pages at last sample (from statm)
    samples:    u32,          // how many times this slot has been read
    // invariant, at every mutation: samples never exceeds the ring's own capacity's lifetime count is bounded by u32; pid==0 iff slot empty.
};
```

Loom **reads** process state from the stable `/proc` surface confirmed present on this host — `/proc/<pid>/stat` (state field), `/proc/<pid>/statm` (resident pages). It never sends a signal and never calls `waitpid`; reaping and restarting belong to Caravan alone. Loom's `zombie` reading is therefore a *hint to the owner*, never an action — if Loom sees a zombie, the honest thing is a recorded observation that Caravan's own reap has not yet run, not an intervention.

### 2. Activity — a bounded ring of what just happened

The heart of the first lap: a **fixed-capacity ring of samples**, oldest overwritten, so memory is constant no matter how long Loom runs — the same discipline `settlement/constellation.rye` already uses for its own ring, and the same shape Vere's loom uses when it abandons an inner road whole.

```
pub const ring_capacity: u32 = 256;   // samples retained; older readings fall off the tail

pub const Sample = struct {
    seq:        u64,   // monotonic sample number, never reused (wire-persistent → u64)
    at_ns:      u64,   // capture time, nanoseconds (wire-persistent → u64)
    watched:    u32,   // how many slots held a live pid at this sample
    running:    u32,   // how many were running
    mem_held:   u64,   // total resident pages across watched slots (cross-target → u64)
};

pub const Ring = struct {
    samples: [ring_capacity]Sample,
    head:    u32,   // next write index, wraps at ring_capacity
    filled:  u32,   // count of live samples, saturates at ring_capacity
    next_seq: u64,  // the seq the next sample will carry

    // invariant, at construction:  head == 0 and filled == 0 and next_seq == 0.
    // invariant, at every push:     head < ring_capacity  (asserted before write).
    // invariant, at every push:     filled <= ring_capacity (saturates, never exceeds).
    // invariant, postcondition:     the pushed sample's seq == the pre-push next_seq.
};
```

`push` writes at `head`, advances `head` modulo `ring_capacity`, saturates `filled`, and increments `next_seq` — five lines, each guarded by a `// invariant:` assert. The width choices follow the supplement exactly: **`u32`** for in-memory counts and indices bounded by `ring_capacity` and `max_watched`; **`u64`** for `seq`, `at_ns`, and `mem_held`, which are wire-persistent or cross-target quantities that a later Comlink reader on another machine must read identically.

### 3. Memory — the held total, and Loom's own footprint

Loom reads system-wide memory from `/proc/meminfo` (MemTotal, MemAvailable — both confirmed present) into a small bounded record, and — the honest self-measure — it names **its own** resident set from its own `/proc/self/statm`, so a reader can see that the watcher's constant-memory claim is true rather than asserted. A monitor that cannot show its own footprint is asking for trust it has not earned; Loom shows it.

All three live inside **one Tally garden**, sized once and cleared whole — never `std.heap.ArenaAllocator` directly, always `const garden = init.arena.allocator()` per season memory. The ring, the table, and the meminfo record are the garden's whole tenancy, so Loom's total memory is a named constant plus the source text it borrows.

## The first witnessed lap

**Lap 1 — a bounded ring of samples, proven, and read back through Scribe.**

The smallest thing that is genuinely Loom and genuinely GREEN:

1. **Construct** a `Ring` (empty; construction invariants assert).
2. **Push** more samples than `ring_capacity` — deliberately overflow — and prove the ring stays exactly `ring_capacity` full, that `head` wrapped, that `seq` kept climbing monotonically past the wrap, and that the oldest samples fell off the tail while the newest survived. This is the invariant that matters: **constant memory under unbounded time.**
3. **Render** the current ring (or its newest N) as a `.kyri` document — `format loom-ring-v1`, one `sample` field per retained reading, plus a header naming `ring_capacity`, `filled`, and `next_seq`.
4. **Read it back** with Scribe's `parse`, confirm `count_key("sample")` equals `filled`, and confirm a chosen field round-trips byte-for-byte. This closes the loop: **Loom writes what Scribe reads**, one notation, many formats — the exact discipline Scribe's counsel already seated.

The witness is a hosted selftest (`loom/ring.rye selftest`) plus a Rishi runner (`tools/loom_ring_witness.rish`) that builds the binary, runs the selftest, and greps the GREEN line — the same witness shape `scribe_reader_witness.rish` and `caravan`'s witnesses already use. Definition of done follows the SLC Rye checklist verbatim: opening triad on the file, at least two contract asserts per `fn`, no new `@memcpy` (use `copy_disjoint` if any bytes move), `tame_style_check` GREEN before the claim.

Lap 1 reads from **no** live `/proc` yet — it proves the ring's mathematics on synthetic samples first, so the invariant is pinned before any real sampler introduces host variability. This is the reds-first habit: prove the line that stops itself before you point it at the firehose.

## Later laps, named so the first stays small

Each is its own accretion over the ring, never a rewrite of it — Caravan's own laddered README is the model:

- **Lap 2 — the live process sampler.** Read `/proc/<pid>/stat` and `statm` for a handful of pids into the `Watched` table; fold one real `Sample` per tick. Bounded by `max_watched`; a missing `/proc/<pid>` reads `gone`, never an error that halts the watch.
- **Lap 3 — the memory reading.** `/proc/meminfo` and `/proc/self/statm` into the memory record; Loom's own footprint printed beside the total it watches.
- **Lap 4 — Caravan composition, across a file.** Loom reads the pids Caravan is supervising from a small `.kyri` roster Caravan writes (or that a launcher writes for both), and Caravan reads Loom's `stop_requested`-shaped hint through the **exact sentinel-file convention Caravan already owns** (`supervisor_exit.rye` / `supervisor_signal.rye`). No new IPC is invented; the two speak through files and exit codes, which Caravan already does natively.
- **Lap 5 — light orchestration, still observing-first.** Loom may *ask* Caravan to stop a watched child by creating Caravan's own stop sentinel — the one gesture that is orchestration rather than observation, and even it uses Caravan's existing vocabulary rather than a new authority. Loom never spawns, never kills, never reaps directly.
- **Horizon — observe over Mycelium/Comlink.** A second machine reads Loom's `loom-ring-v1` `.kyri` over the sealed Comlink wire and watches a remote host's ring, `u64` seq and `mem_held` reading identically across the link because the widths were chosen wire-persistent from lap 1. Custody-first: a remote reader sees only what the watched host consents to publish.
- **Horizon — Glow/Rishi/Rye RISC-V bindings.** The `/proc` seam is the one platform-specific surface; behind a small reader interface, a RISC-V target substitutes its own source. Named here so lap 1's ring stays platform-free and the binding work is a later, bounded seam rather than a rewrite.

## Composition — how Loom meets Caravan and Tally without taking ownership

**Loom and Caravan meet across a file, never across a symbol.** This is the load-bearing design choice, and it is deliberate:

- **Caravan owns the process.** It holds the `std.process.Child`, calls `waitpid`, applies `cycle_ok` / `stop_requested` / fall-restart, and creates or deletes stop sentinels. All of that stays exactly where it is; Loom imports none of it.
- **Loom owns the observation.** It reads `/proc` (a source Caravan does not touch) and keeps the ring. It never holds a `Child`, never waits, never signals.
- **The seam is a `.kyri` file and a sentinel path** — both conventions Caravan already speaks. Caravan writes (or a shared launcher writes) the roster of supervised pids; Loom reads it. Loom, when asked to, creates Caravan's stop sentinel; Caravan reads it, as it already reads a manual `touch` or its own signal handler's sentinel. Neither module reaches into the other's memory, which means neither can corrupt the other's invariants — a property you get for free from the file boundary and cannot get from a shared pointer.

**Loom composes Tally the way every hosted module does.** One garden via `init.arena.allocator()`, named `garden`; the ring, table, and meminfo record are its whole tenancy; `copy_disjoint` for any bytes that move (rendering a sample line may format into a bounded buffer — no `@memcpy`); `no_padding` on any `extern struct` if a wire form is ever pinned for the Comlink horizon. Tally imports `std` only and stays unaware of Loom; Loom reaches Tally through symlinks, per the seam map.

The result is a monitor that is **safe first** (it cannot break what it watches, because it cannot reach into it), **bounded second** (constant memory under unbounded time, proven in lap 1), and **a joy to read third** (three kinds of reading, one ring, one `.kyri` voice Scribe already speaks).

## Custody, consent, and honesty

- **No real key, no real person, in the tree.** Loom watches pids and memory pages — no identity, no secret. Any future Comlink publication of a ring is opt-in by the watched host; a remote reader sees only what is consented.
- **The observer's own cost is shown, not claimed.** Loom prints its own resident set beside the totals it watches, so its constant-memory promise is witnessed.
- **Zombie is a hint, never an action.** Where Loom sees state Caravan should act on, it records the observation and leaves the action to the owner — the reds-first discipline that a watcher names what it sees and books the fix to the owner, rather than reaching past its boundary.
- **The name waits for the grep and the word.** "Loom" is proposed and encumbered; nothing seats until a whole-tree grep and Keaton's decision. Custody first applies to names as much as to keys: this brief builds nothing and claims no clearance.

---

*A loom holds many threads under one even tension and shows the instant one breaks — Sakichi's did, and jidoka was born from it. Whether this watcher earns that name or a plainer one, may it hold its threads at constant tension and constant memory, show a broken one at a glance, and never once reach past the file that keeps it honest.*
