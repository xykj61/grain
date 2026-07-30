# The Glow Almanac

**Language:** EN · **Voice:** Riyo · **Status:** Living reference — chartered empty on purpose
**Chartered:** `20260730.021034` (Voice v28 · slot 12 · opening_lines_and_silo) · home movable on Keaton's word
**Elder:** [`archive/ALMANAC.md`](archive/ALMANAC.md) — the Rye almanac, 310 lines, every one earned; this book inherits its law and none of its text

---

## The entry law — the opening line, on purpose

**An entry is earned by running code only.** A finding enters this almanac the day a witness proved it on metal, with the command that ran and the stamp it ran at — never from reasoning, never from documentation, never from memory of how another language behaves. The elder earned all 310 of its lines this way; the one time this house wrote a contract from belief instead, the field did not exist and seven witnesses went red at once. That erratum is this book's founding story.

## The shape — powers of two, bounded before it grows

**Four chapters × sixteen entries = sixty-four findings**, one chapter per equinox of the season that fills it. The bound is the book's own: at sixty-four, the almanac closes and a successor is chartered, exactly as seasons close. Chapters carry no themes in advance — findings arrive in the order the code runs, and the order is part of the record.

## The entry form

```
### N. <the finding, one sentence, plain>
**Ran:** <the command> · **Stamp:** <copied from the clock> · **Witness:** <path>
<two to five lines: what was expected, what the metal answered, what it teaches>
```

## Chapter One — Build Journey greens (9 of 16)

Entries 1–5 from stamp `20260730.034527`. Entry 6 from `20260730.040859`. Entry 7 from `20260730.041405`. Entry 8 from `20260730.085312`. Entry 9 from `20260730.100218`. Seven seats remain.

### 1. A descriptor that fits 512 bytes is welcome; one that does not is refused whole.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/descriptor_test.rye` · **Stamp:** `20260730.034527` · **Witness:** `comlink/discovery/descriptor.rye` · `descriptor_test.rye`  
Expected the seated ceiling to bite both ways. Metal answered GREEN — bound 512 welcome and refuse. Discovery carries length-prefixed self-description and nothing past the door.

### 2. The peer table claims and reaches both ways inside 256 slots, stack LIFO untouched.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/table.rye` · **Stamp:** `20260730.034527` · **Witness:** `comlink/discovery/table.rye`  
Expected claim↔reach, bound bitten, free-list LIFO. Metal answered GREEN — max_peers 256 · staleness 4096 inherited from the brix. The table finds peers and never orders them.

### 3. Gossip fans out at most eight peers; malformed arrival refuses whole and never trims quiet.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/gossip.rye` · **Stamp:** `20260730.034527` · **Witness:** `comlink/discovery/gossip.rye`  
Expected fanout 8 and refuse-whole on bad shape. Metal answered GREEN. What travels is a value under a named ceiling.

### 4. Introduce arrives at hops ≤ 2 with kumara identity; wrong shape is turned away as loudly as welcome.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run comlink/discovery/introduce.rye` · **Stamp:** `20260730.034527` · **Witness:** `comlink/discovery/introduce.rye`  
Expected Aparigraha arrival and negative space. Metal answered GREEN — hops_max 2 · kumara seam. A stranger with the wrong seal does not enter.

### 5. Myc supply equals issued minus taxed at every prefix; overdraw and unknown kinds refuse whole.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold.rye` · **Stamp:** `20260730.034527` · **Witness:** `mycelium/fold.rye`  
Expected purity (fresh = resumed), star uniqueness, and loud refuse. Metal answered GREEN — supply=872 · stars=1 · purity · refuse whole. The fold stays pure; policy numbers stay parked.

### 6. A ship `.sol` proof fits 1024 bytes, verifies under kumara, and refuses tamper and over-bound whole.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/ship_sol.rye` · **Stamp:** `20260730.040859` · **Witness:** `mycelium/ship_sol.rye`  
Expected bound · seal · shape · purity with cadence parked. Metal answered GREEN — bound 1024 · seal · refuse whole · purity. SNS liveness hours stay Keaton's word.

### 7. Build Journey ceilings on metal match the seated brix; discovery seats stay pinned as data.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/build_bounds.rye` · **Stamp:** `20260730.041405` · **Witness:** `mycelium/build_bounds.rye`  
Expected myc+ship pubs equal recursion_block seats; discovery literals pinned (module-path law). Metal answered GREEN — design-shapes · myc+ship metal · discovery seats pinned. Builds inherit; they do not invent.

### 8. Fold state that sleeps as bounded bytes wakes equal to a fresh fold of the same log.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/fold_persist.rye` · **Stamp:** `20260730.085312` · **Witness:** `mycelium/fold_persist.rye`  
Expected Amber-shaped snapshot · restore · fold remainder equals fresh; unknown version, truncate, trailing, and over-bound refuse whole. Metal answered GREEN — sleep·wake equal · supply=1072 · refuse whole · bound=4096. Accrete-never-break holds across the nap.

### 9. Five primitives refuse loudly in one storm; each refuse is named and leaves the log untouched.
**Ran:** `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run mycelium/refusal_storm.rye` · **Stamp:** `20260730.100218` · **Witness:** `mycelium/refusal_storm.rye`  
Expected keypair tamper · unknown kind · append-only unchanged · overdraw · seam truncate/ship tamper — five cases under bound 5. Metal answered GREEN — cases=5 · bound=5 · log.len=3. Negative space gathers without inventing a sixth primitive.

---

*May every line here be one the machine said first. May the book close at its bound the way a season does. And may the remaining seven seats wait for metal, not memory.*
