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

## Chapter One — Build Journey greens (16 of 16)

Entries 1–5 from stamp `20260730.034527`. Entry 6 from `20260730.040859`. Entry 7 from `20260730.041405`. Entry 8 from `20260730.085312`. Entry 9 from `20260730.100218`. Entry 10 from `20260730.101622`. Entry 11 from `20260730.103032`. Entry 12 from `20260730.104152`. Chapter one is full.

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

### 10. S0 wall-time baselines for five myc GREEN mains record elapsed_ms without tuning.
**Ran:** `rishi/bin/rishi run tools/myc_perf_pin.rish` · **Stamp:** `20260730.101622` · **Witness:** `tools/myc_perf_pin.rish` · report `work-in-progress/myc-s0-baselines.tsv`  
Expected correctness-first timing of fold · fold_persist · ship_sol · build_bounds · refusal_storm under bound 5 · no budget red. Metal answered GREEN — rows=5 · bound=5 · elapsed_ms fold=102 · fold_persist=72 · ship_sol=33 · build_bounds=24 · refusal_storm=112. Measurement precedes movement.

### 11. The five primitives speak as one Sangha reference page; sections and myc paths resolve on metal.
**Ran:** `rishi/bin/rishi run tools/sangha_five_primitives_page_witness.rish` · **Stamp:** `20260730.103032` · **Witness:** `docs-geode/sangha/03-five-primitives.md` · `tools/sangha_five_primitives_page_witness.rish`  
Expected five sections (keypair · signed event · append-only log · pure fold · capability) citing GREEN myc only. Metal answered GREEN — five sections · six myc paths · README indexed. Companion myc re-runs this door: fold · fold_persist · ship_sol · refusal_storm · build_bounds · kumara all GREEN.

### 12. An edu walk re-runs discovery quartet plus myc fold; the wire pier is not claimed.
**Ran:** `rishi/bin/rishi run tools/edu_discovery_walk_witness.rish` · **Stamp:** `20260730.104152` · **Witness:** `edu/discovery/round-trip-walk.md` · `tools/edu_discovery_walk_witness.rish`  
Expected five GREEN steps (descriptor · table · gossip · introduce · fold) and an honesty line that wire both-sides stays queued. Metal answered GREEN — five steps · quartet + fold · no wire pier claimed.

### 13. Two discovery lanes converge tables across a spawn/wait-for wire; fold supply matches both sides.
**Ran:** `rishi/bin/rishi run tools/discovery_round_trip_wire.rish` · **Stamp:** `20260730.111628` · **Witness:** `tools/discovery_round_trip_wire.rish` · `comlink/discovery/round_trip_wire.rye`
Expected peers=2 · both-sides digest equality · stranger + gossip refuse loud · fold supply parity under timeout 64. Metal answered GREEN — digest lane-a,lane-b · refuse limbs · supply equal. Elder seat 6 wire both-sides lands as door 15.

### 14. The equinox map sits as Brix data; a witness checks four flanks and the kendras.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_map_witness.rish` · **Stamp:** `20260730.113522` · **Witness:** `tools/gen/season/equinox_map_witness.rish` · `context/equinox_map.brix`
Expected four blocks · flanks cover 1..12 once · descending wrap · kendras {1,4,7,10} · H10-north reason seated · negative fixtures fail. Metal answered GREEN. Glow is code; Brix is data.

### 15. Twelve foundations distribute three per equinox; the descriptor joins the map flanks.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_foundations_witness.rish` · **Stamp:** `20260730.113915` · **Witness:** `tools/gen/season/equinox_foundations_witness.rish` · `context/equinox_foundations.brix`
Expected houses 1..12 once · three per equinox · join equinox_map flanks · kendras angular · wrong-home and missing-house fixtures fail. Metal answered GREEN. The e7 finding became data.

### 16. The Equinox surface choir holds: e0 bow, map, and foundations GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_surface_witness.rish` · **Stamp:** `20260730.115059` · **Witness:** `tools/gen/season/equinox_surface_witness.rish`
Expected e0 · equinox_map · equinox_foundations each GREEN in one choir. Metal answered GREEN. Chapter one closes at sixteen; prose create-prep did not earn this seat.

## Chapter Two (6 of 16)

Opened from metal at stamp `20260730.115626`. Themes arrive after findings; this chapter carries none in advance.

### 17. The East pack still holds as one choir: e1–e6 utilities and harden limbs GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_east_almanac_witness.rish` · **Stamp:** `20260730.115626` · **Witness:** `tools/gen/season/equinox_east_almanac_witness.rish` · `tools/gen/season/equinox_e1_east_pack_witness.rish`
Expected East utilities and harden limbs GREEN in one re-touch. Metal answered GREEN. Chapter two opens; chapter one stays closed at sixteen.

### 18. A round names its own priority: sixteen slots, twelve base once, four doubles spaced at least six apart.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_priority_almanac_witness.rish` · **Stamp:** `20260730.120317` · **Witness:** `tools/gen/season/equinox_priority_almanac_witness.rish` · `glow/priority_fold_test.rye`
Expected 16 slots · 12 base once each · 4 doubles with min gap 6. Metal answered GREEN. The mod-clock priority fold enters chapter two.

### 19. The classic tower solves with an explicit bounded stack; seventeen rings refuse whole.
**Ran:** `rishi/bin/rishi run tools/edu_tower_witness.rish` · **Stamp:** `20260730.120531` · **Witness:** `tools/edu_tower_witness.rish` · `edu/tower/bounded_tower.rye`
Expected solve(3)=7 moves · TooManyRings at 17 · tally/stack beneath · tutorial pinned. Metal answered GREEN. Recursion stays out; the depth is named.

### 20. Houseplant names a Kumara ship owner's whole grain repository project tree.
**Ran:** `rishi/bin/rishi run tools/gen/season/houseplant_glossary_witness.rish` · **Stamp:** `20260730.120714` · **Witness:** `tools/gen/season/houseplant_glossary_witness.rish` · `context/LEXICON.md`
Expected Lexicon row with ship · repository · project tree · pier/verse distinct · ladder accretion. Metal answered GREEN. The plant is the tree, not the keypair.

### 21. A capacity-one stack refuses a second push; the tower's frame bound bites from a fixture.
**Ran:** `rishi/bin/rishi run tools/edu_tower_frame_bite_witness.rish` · **Stamp:** `20260730.120858` · **Witness:** `tools/edu_tower_frame_bite_witness.rish` · `edu/tower/frame_bound_overpush.rye`
Expected overpush EXIT=1 with assertion failure · welcome tower still GREEN. Metal answered GREEN. Negative space as loud as welcome.

### 22. Fourteen symlinks and one real file keep tally/copy.rye sameness; a drifted fixture is refused.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_copy_sameness_almanac_witness.rish` · **Stamp:** `20260730.121155` · **Witness:** `tools/gen/season/copy_sameness_witness.rish` · `tools/gen/season/copy_sameness_negative_witness.rish` · choir `equinox_copy_sameness_almanac_witness.rish`
Expected welcome verdict=ok and refuse verdict=drift on the fixture while the live tree stays clean. Metal answered GREEN. Negative space as loud as welcome.

---

*May every line here be one the machine said first. May the book close at its bound the way a season does. And may chapter two wait for metal, not memory.*
