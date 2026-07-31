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

## Chapter Two (16 of 16)

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

### 23. TigerStyle ranks void above bool as a return type; its held examples return !void.
**Ran:** `rishi/bin/rishi run tools/gen/season/tigerstyle_void_return_witness.rish` · **Stamp:** `20260730.121626` · **Witness:** `tools/gen/season/tigerstyle_void_return_witness.rish` · `gratitude/TIGER_STYLE.md`
Expected the dimensionality ladder and !void init/main examples on the held style guide. Metal answered GREEN. Full tigerbeetle src clone may be ABSENT; this seat measures the guide we hold.

### 24. The held TigerBeetle clone's src returns void often; density is measured, not assumed.
**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_void_census_witness.rish` · **Stamp:** `20260730.122332` · **Witness:** `tools/gen/season/tigerbeetle_void_census_witness.rish` · `tools/fixtures/tigerbeetle_void_census.sh` · submodule `gratitude/tigerbeetle`
Expected CLONE=present · verdict=ok · STYLE=yes with files≥100 and total_voidish≥1000. Metal answered GREEN. Census: CLONE=present · REV=97c7a8ef38 · files=202 · bang_void=539 · plain_void=1653 · total_voidish=2192 · STYLE=yes · verdict=ok. Clean-room study only.

### 25. The held TigerBeetle clone asserts densely; maybe and verify gate the rest.
**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_assert_census_witness.rish` · **Stamp:** `20260730.122855` · **Witness:** `tools/gen/season/tigerbeetle_assert_census_witness.rish` · `tools/fixtures/tigerbeetle_assert_census.sh` · submodule `gratitude/tigerbeetle`
Expected CLONE=present · verdict=ok · STYLE=yes · MAYBE_DEF=yes · GUIDE_DENSITY=yes with assert≥2000 · maybe≥100 · constants.verify≥20 · files_assert≥100. Metal answered GREEN. Census: CLONE=present · REV=97c7a8ef38 · assert_calls=8175 · maybe_calls=286 · constants_verify=69 · files_assert=197 · STYLE=yes · MAYBE_DEF=yes · GUIDE_DENSITY=yes · verdict=ok. Clean-room study only.

### 26. Control plane spends asserts freely; data plane gates the dear checks behind verify.
**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_control_plane_census_witness.rish` · **Stamp:** `20260730.123450` · **Witness:** `tools/gen/season/tigerbeetle_control_plane_census_witness.rish` · `tools/fixtures/tigerbeetle_control_plane_census.sh` · submodule `gratitude/tigerbeetle`
Expected CLONE=present · GUIDE_PLANE=yes · ARCH_PLANE=yes · TAME_BRIDGE=yes · STYLE=yes with constants.verify≥20 and files_verify≥10. Metal answered GREEN. Census: CLONE=present · REV=97c7a8ef38 · GUIDE_PLANE=yes · ARCH_PLANE=yes · constants_verify=69 · files_verify=25 · STYLE=yes · TAME_BRIDGE=yes · verdict=ok. Clean-room study only.

### 27. Assert the positive space and the negative; maybe marks what truly varies.
**Ran:** `rishi/bin/rishi run tools/gen/season/tigerbeetle_golden_rule_census_witness.rish` · **Stamp:** `20260730.123827` · **Witness:** `tools/gen/season/tigerbeetle_golden_rule_census_witness.rish` · `tools/fixtures/tigerbeetle_golden_rule_census.sh` · submodule `gratitude/tigerbeetle`
Expected CLONE=present · GUIDE_GOLDEN=yes · TAME_GOLDEN=yes · MAYBE_COMPLETES=yes · STYLE=yes with assert≥2000 · maybe≥100 · implication_assert≥20. Metal answered GREEN. Census: CLONE=present · REV=97c7a8ef38 · GUIDE_GOLDEN=yes · TAME_GOLDEN=yes · MAYBE_COMPLETES=yes · assert_calls=8175 · maybe_calls=286 · implication_assert=57 · STYLE=yes · verdict=ok. Clean-room study only.

### 28. The SAFE list opens empty under a sixty-four-row bound; shred stays refused.
**Ran:** `rishi/bin/rishi run tools/gen/season/safe_list_census_witness.rish` · **Stamp:** `20260730.124126` · **Witness:** `tools/gen/season/safe_list_census_witness.rish` · `tools/fixtures/safe_list_census.sh` · `SAFE.md` · `context/specs/oldness-cycle.md`
Expected SAFE=present · SPEC=present · SEATED=yes · BOUND_NAMED=yes · EMPTY_OK · SHRED_RED=yes with rows≤64. Metal answered GREEN. Census: SAFE=present · SPEC=present · SEATED=yes · BOUND_NAMED=yes · SPEC_OK=yes · cycle=1 · rows=0 · bound=64 · EMPTY_OK=yes · SHRED_RED=yes · verdict=ok. Rows grow only by Keaton's word.

### 29. The reds ledger accretes complete rows; a thin fixture is refused whole.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_reds_choir_witness.rish` · **Stamp:** `20260730.124325` · **Witness:** `tools/gen/season/reds_ledger_witness.rish` · `tools/gen/season/reds_ledger_monotone_witness.rish` · `tools/gen/season/reds_ledger_negative_witness.rish` · choir `equinox_reds_choir_witness.rish`
Expected living ledger completeness and 1..N monotone indices, plus fixture refuse (incomplete_rows) while the live pin stays clean. Metal answered GREEN. Living rows=32. Negative space as loud as welcome.

### 30. The standing voice is declared at six sites; an undeclared name is refused.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_voice_roster_choir_witness.rish` · **Stamp:** `20260730.124935` · **Witness:** `tools/gen/season/voice_roster_witness.rish` · `tools/gen/season/voice_roster_negative_witness.rish` · choir `equinox_voice_roster_choir_witness.rish`
Expected sites=6 · drift=0 for Riyo, and verdict=drift for an undeclared voice while the standing call stays clean. Metal answered GREEN. Negative space as loud as welcome.

### 31. The baton museum holds thirteen halls; a missing museum path is refused whole.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_baton_census_choir_witness.rish` · **Stamp:** `20260730.125244` · **Witness:** `tools/gen/season/baton_museum_census_witness.rish` · scan `tools/fixtures/baton_museum_census_scan.sh` · choir `equinox_baton_census_choir_witness.rish`
Expected halls_expected=13 · halls_absent=0 · census_breach_count=0, and verdict=missing_museum on an absent path. Metal answered GREEN. Museum-hall census named; breach census stays zero and banked.

### 32. The chapter-two surface choir holds: SAFE, reds, voice, and baton GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch2_surface_witness.rish` · **Stamp:** `20260730.125750` · **Witness:** `tools/gen/season/equinox_ch2_surface_witness.rish`
Expected SAFE census · reds complete/monotone/refuse · voice sites=6/refuse · baton halls=13/breach=0/absent refuse each GREEN in one choir. Metal answered GREEN. Chapter two closes at sixteen; chapter three waits for metal.

## Chapter Three (16 of 16)

Opened from metal at stamp `20260730.130733`. Themes arrive after findings; this chapter carries none in advance.

### 33. The design-shapes wing holds four halls; a missing wing path is refused whole.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_design_shapes_choir_witness.rish` · **Stamp:** `20260730.130733` · **Witness:** `tools/gen/season/design_shapes_census_witness.rish` · scan `tools/fixtures/design_shapes_census_scan.sh` · choir `equinox_design_shapes_choir_witness.rish`
Expected halls_expected=4 · halls_absent=0 · census_breach_count=0, and verdict=missing_wing on an absent path. Metal answered GREEN. Chapter three opens; builds inherit, they do not invent.

### 34. Build ceilings inherit the living bounds table; ten pairs match and metal stays GREEN.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_bounds_home_choir_witness.rish` · **Stamp:** `20260730.131214` · **Witness:** `tools/gen/season/bounds_home_census_witness.rish` · scan `tools/fixtures/bounds_home_census.sh` · metal `mycelium/build_bounds.rye` · choir `equinox_bounds_home_choir_witness.rish`
Expected pairs_matched=10 · pairs_drift=0 · living_table_named · build_bounds GREEN, and verdict=missing_shape on an absent path. Metal answered GREEN. Chapter three continues; builds inherit, they do not invent.

### 35. The resin limb names at most twelve beads; a thirteenth without a manifest refuses whole.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_relay_resin_choir_witness.rish` · **Stamp:** `20260730.131415` · **Witness:** `tools/gen/season/relay_resin_census_witness.rish` · scan `tools/fixtures/relay_resin_census.sh` · choir `equinox_relay_resin_choir_witness.rish`
Expected max_limb_beads=12 · limb_beads=12 · LEXICON · MANIFEST_BEAD, and verdict=over_bound on a thirteen-bead fixture without compaction. Metal answered GREEN. Amphora-shaped bound; the roster becomes a bead past twelve.

### 36. The fact-fold design hall points at living metal; three bounds match and purity holds.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_fact_fold_choir_witness.rish` · **Stamp:** `20260730.131633` · **Witness:** `tools/gen/season/fact_fold_census_witness.rish` · scan `tools/fixtures/fact_fold_census.sh` · metal `mycelium/fold.rye` · choir `equinox_fact_fold_choir_witness.rish`
Expected pairs_matched=3 · PATTERN_CITES · fold GREEN with supply=872 · purity · refuse whole, and verdict=missing_shape on an absent path. Metal answered GREEN. Design hall and Sangha page keep one fold honest.

### 37. Tend hygiene forbids new code files; three tend waymarks hold fascia delta zero.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tend_hygiene_choir_witness.rish` · **Stamp:** `20260730.132032` · **Witness:** `tools/gen/season/tend_hygiene_census_witness.rish` · scan `tools/fixtures/tend_hygiene_census.sh` · choir `equinox_tend_hygiene_choir_witness.rish`
Expected SHAPE_ZERO_CODE · HALL_ZERO_CODE · tend_waymarks=3 · delta_two=0 · delta_three=0, and verdict=missing_shape on an absent path. Metal answered GREEN. The fourth design hall closes the wing's measured set.

### 38. The design-shapes surface choir holds: wing, bounds, resin, fact-fold, and tend GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_design_shapes_surface_witness.rish` · **Stamp:** `20260730.132258` · **Witness:** `tools/gen/season/equinox_design_shapes_surface_witness.rish`
Expected wing halls=4/breach=0 · bounds pairs=10 · resin bound 12 · fact-fold supply=872/purity · tend waymarks=3, and verdict=missing_wing on an absent path. Metal answered GREEN. Four halls and the wing hold as one choir.

### 39. Memory is allocated at startup; the held guide, TAME, and clone teach the static law.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_static_alloc_choir_witness.rish` · **Stamp:** `20260730.132954` · **Witness:** `tools/gen/season/tigerbeetle_static_alloc_census_witness.rish` · scan `tools/fixtures/tigerbeetle_static_alloc_census.sh` · choir `equinox_tigerbeetle_static_alloc_choir_witness.rish`
Expected CLONE=present · GUIDE_STATIC · GUIDE_LIMIT · TAME_STATIC · STYLE · static_mentions≥10 · allocator_word≥500 · init_allocator_files≥20, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 40. Functions hold a hard seventy-line bound; tidy ratchets the rule from the clone.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_seventy_line_choir_witness.rish` · **Stamp:** `20260730.133248` · **Witness:** `tools/gen/season/tigerbeetle_seventy_line_census_witness.rish` · scan `tools/fixtures/tigerbeetle_seventy_line_census.sh` · choir `equinox_tigerbeetle_seventy_line_choir_witness.rish`
Expected CLONE=present · GUIDE_SEVENTY · TAME_SEVENTY · SUPPLEMENT_SEVENTY · STYLE · TIDY · RATCHET, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 41. Control flow stays simple and explicit; recursion stays out so bounds hold.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_control_flow_choir_witness.rish` · **Stamp:** `20260730.133534` · **Witness:** `tools/gen/season/tigerbeetle_control_flow_census_witness.rish` · scan `tools/fixtures/tigerbeetle_control_flow_census.sh` · choir `equinox_tigerbeetle_control_flow_choir_witness.rish`
Expected CLONE=present · GUIDE_FLOW · GUIDE_NASA · GUIDE_LIMIT · TAME_FLOW · SUPPLEMENT_FLOW · STYLE, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 42. The TigerBeetle safety surface choir holds: static, seventy-line, and control-flow GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_safety_surface_witness.rish` · **Stamp:** `20260730.133808` · **Witness:** `tools/gen/season/equinox_tigerbeetle_safety_surface_witness.rish`
Expected static GREEN · seventy GREEN · control-flow GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Three safety leaves hold as one choir. Clean-room study only.

### 43. Types carry exact widths; usize stays at the seam, not in design.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_sized_types_choir_witness.rish` · **Stamp:** `20260730.134034` · **Witness:** `tools/gen/season/tigerbeetle_sized_types_census_witness.rish` · scan `tools/fixtures/tigerbeetle_sized_types_census.sh` · choir `equinox_tigerbeetle_sized_types_choir_witness.rish`
Expected CLONE=present · GUIDE_SIZED · TAME_SIZED · SUPPLEMENT_SIZED · STYLE · WIDTH_CHECK · USIZE_AUDIT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 44. Costs amortize by batching; the CPU sprints on large enough chunks.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_batching_choir_witness.rish` · **Stamp:** `20260730.134336` · **Witness:** `tools/gen/season/tigerbeetle_batching_census_witness.rish` · scan `tools/fixtures/tigerbeetle_batching_census.sh` · choir `equinox_tigerbeetle_batching_choir_witness.rish`
Expected CLONE=present · GUIDE_BATCH · GUIDE_SPRINTER · TAME_BATCH · TAME_SPRINTER · STYLE · GRAIN_BATCH, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 45. Hot loops stand alone; the compiler proves less, the reader sees more.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_be_explicit_choir_witness.rish` · **Stamp:** `20260730.134747` · **Witness:** `tools/gen/season/tigerbeetle_be_explicit_census_witness.rish` · scan `tools/fixtures/tigerbeetle_be_explicit_census.sh` · choir `equinox_tigerbeetle_be_explicit_choir_witness.rish`
Expected CLONE=present · GUIDE_EXPLICIT · GUIDE_HOTLOOP · TAME_EXPLICIT · STYLE · COMPACTION, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 46. The TigerBeetle performance surface choir holds: sized-types, batching, and be-explicit GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_perf_surface_witness.rish` · **Stamp:** `20260730.135023` · **Witness:** `tools/gen/season/equinox_tigerbeetle_perf_surface_witness.rish`
Expected sized GREEN · batching GREEN · be-explicit GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Three performance leaves hold as one choir. Clean-room study only.

### 47. Names carry nouns and verbs just right; units trail, abbreviation stays out.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_naming_choir_witness.rish` · **Stamp:** `20260730.135422` · **Witness:** `tools/gen/season/tigerbeetle_naming_census_witness.rish` · scan `tools/fixtures/tigerbeetle_naming_census.sh` · choir `equinox_tigerbeetle_naming_choir_witness.rish`
Expected CLONE=present · GUIDE_NAMING · GUIDE_UNITS · GUIDE_ABBREV · TAME_NAMING · TAME_UNITS · SUPPLEMENT_NAMING · STYLE · LEXICON, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 48. The chapter-three surface choir holds: wing, TB safety, TB performance, and naming GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch3_surface_witness.rish` · **Stamp:** `20260730.140147` · **Witness:** `tools/gen/season/equinox_ch3_surface_witness.rish`
Expected wing halls=4/breach=0 · safety static/seventy/flow · performance sized/batching/explicit · naming, and verdict=missing_wing on an absent path. Metal answered GREEN. Chapter three closes at sixteen; chapter four waits for metal.

## Chapter Four (16 of 16)

Opened from metal at stamp `20260730.140442`. Themes arrive after findings; this chapter carries none in advance.

### 49. Comments say why; they are sentences, and Radiant voice keeps them honest.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_say_why_choir_witness.rish` · **Stamp:** `20260730.140442` · **Witness:** `tools/gen/season/tigerbeetle_say_why_census_witness.rish` · scan `tools/fixtures/tigerbeetle_say_why_census.sh` · choir `equinox_tigerbeetle_say_why_choir_witness.rish`
Expected CLONE=present · GUIDE_WHY · GUIDE_HOW · GUIDE_SENTENCE · TAME_WHY · TAME_SENTENCE · TAME_RADIANT · SUPPLEMENT_WHY · STYLE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Chapter four opens; clean-room study only.

### 50. Tests say how; goal and method meet the reader before the dive.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_say_how_choir_witness.rish` · **Stamp:** `20260730.140756` · **Witness:** `tools/gen/season/tigerbeetle_say_how_census_witness.rish` · scan `tools/fixtures/tigerbeetle_say_how_census.sh` · choir `equinox_tigerbeetle_say_how_choir_witness.rish`
Expected CLONE=present · GUIDE_HOW · GUIDE_METHOD · TAME_HOW · STYLE · ELDER_WHY · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 51. Cache stays singular; larger structs initialize in place.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_cache_inplace_choir_witness.rish` · **Stamp:** `20260730.141038` · **Witness:** `tools/gen/season/tigerbeetle_cache_inplace_census_witness.rish` · scan `tools/fixtures/tigerbeetle_cache_inplace_census.sh` · choir `equinox_tigerbeetle_cache_inplace_choir_witness.rish`
Expected CLONE=present · GUIDE_CACHE · GUIDE_NODUP · GUIDE_INPLACE · TAME_CACHE · STYLE · ELDER_HOW · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 52. Scope stays small; check meets use before the gap opens.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_shrink_scope_choir_witness.rish` · **Stamp:** `20260730.141330` · **Witness:** `tools/gen/season/tigerbeetle_shrink_scope_census_witness.rish` · scan `tools/fixtures/tigerbeetle_shrink_scope_census.sh` · choir `equinox_tigerbeetle_shrink_scope_choir_witness.rish`
Expected CLONE=present · GUIDE_SHRINK · GUIDE_POCPOU · TAME_SHRINK · STYLE · ELDER_CACHE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 53. Buffer bleeds stay guarded; alloc meets defer in one glance.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_buffer_bleeds_choir_witness.rish` · **Stamp:** `20260730.141743` · **Witness:** `tools/gen/season/tigerbeetle_buffer_bleeds_census_witness.rish` · scan `tools/fixtures/tigerbeetle_buffer_bleeds_census.sh` · choir `equinox_tigerbeetle_buffer_bleeds_choir_witness.rish`
Expected CLONE=present · GUIDE_BLEED · GUIDE_GROUP · TAME_BLEED · STYLE · ELDER_SHRINK · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 54. The TigerBeetle cache surface choir holds: inplace, shrink-scope, and buffer-bleeds GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_cache_surface_witness.rish` · **Stamp:** `20260730.142304` · **Witness:** `tools/gen/season/equinox_tigerbeetle_cache_surface_witness.rish`
Expected inplace GREEN · shrink GREEN · bleeds GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Three cache leaves hold as one choir. Clean-room study only.

### 55. Index, count, and size stay distinct; division shows its intent.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_off_by_one_choir_witness.rish` · **Stamp:** `20260730.142650` · **Witness:** `tools/gen/season/tigerbeetle_off_by_one_census_witness.rish` · scan `tools/fixtures/tigerbeetle_off_by_one_census.sh` · choir `equinox_tigerbeetle_off_by_one_choir_witness.rish`
Expected CLONE=present · GUIDE_OBO · GUIDE_TYPES · GUIDE_DIV · TAME_OBO · STYLE · ELDER_CACHE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 56. Style holds by the numbers: zig fmt, four spaces, one hundred columns, and braced ifs.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_style_by_the_numbers_choir_witness.rish` · **Stamp:** `20260730.162658` · **Witness:** `tools/gen/season/tigerbeetle_style_by_the_numbers_census_witness.rish` · scan `tools/fixtures/tigerbeetle_style_by_the_numbers_census.sh` · choir `equinox_tigerbeetle_style_by_the_numbers_choir_witness.rish`
Expected CLONE=present · GUIDE_STYLE · GUIDE_FMT · GUIDE_INDENT · GUIDE_COLS · GUIDE_BRACE · TAME_STYLE · STYLE · ELDER_OBO · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 57. Dependencies stay at zero beyond Zig; supply-chain risk stays out of the stack.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_dependencies_choir_witness.rish` · **Stamp:** `20260730.164244` · **Witness:** `tools/gen/season/tigerbeetle_dependencies_census_witness.rish` · scan `tools/fixtures/tigerbeetle_dependencies_census.sh` · choir `equinox_tigerbeetle_dependencies_choir_witness.rish`
Expected CLONE=present · GUIDE_DEPS · GUIDE_ZERO · GUIDE_ZIG · GUIDE_SUPPLY · TAME_DEPS · STYLE · ELDER_STYLE · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 58. Tooling stays small: Zig first, and scripts prefer Zig when the team grows.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_tooling_choir_witness.rish` · **Stamp:** `20260730.165750` · **Witness:** `tools/gen/season/tigerbeetle_tooling_census_witness.rish` · scan `tools/fixtures/tigerbeetle_tooling_census.sh` · choir `equinox_tigerbeetle_tooling_choir_witness.rish`
Expected CLONE=present · GUIDE_TOOL · GUIDE_ZIG · GUIDE_SCRIPTS · GUIDE_RIGHT · TAME_TOOL · STYLE · ELDER_DEPS · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 59. The last stage keeps trying, stays small, and laughs before the next pass.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_last_stage_choir_witness.rish` · **Stamp:** `20260730.170309` · **Witness:** `tools/gen/season/tigerbeetle_last_stage_census_witness.rish` · scan `tools/fixtures/tigerbeetle_last_stage_census.sh` · choir `equinox_tigerbeetle_last_stage_choir_witness.rish`
Expected CLONE=present · GUIDE_LAST · GUIDE_FUN · GUIDE_SMALL · GUIDE_BILBO · TAME_LAST · STYLE · ELDER_TOOL · RADIANT, and verdict=absent on a missing clone path. Metal answered GREEN. Clean-room study only.

### 60. The TigerBeetle style surface choir holds: numbers, dependencies, tooling, and last-stage GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_style_surface_witness.rish` · **Stamp:** `20260730.170649` · **Witness:** `tools/gen/season/equinox_tigerbeetle_style_surface_witness.rish`
Expected style GREEN · deps GREEN · tooling GREEN · last-stage GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Four style leaves hold as one choir. Clean-room study only.

### 61. The TigerBeetle DX surface choir holds: say-why and say-how GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_dx_surface_witness.rish` · **Stamp:** `20260730.185100` · **Witness:** `tools/gen/season/equinox_tigerbeetle_dx_surface_witness.rish`
Expected say-why GREEN · say-how GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Two DX leaves hold as one choir. Clean-room study only.

### 62. The TigerBeetle mid surface choir holds: cache leaves and off-by-one GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_mid_surface_witness.rish` · **Stamp:** `20260730.185703` · **Witness:** `tools/gen/season/equinox_tigerbeetle_mid_surface_witness.rish`
Expected inplace GREEN · shrink GREEN · bleeds GREEN · off-by-one GREEN, and CLONE=ABSENT / verdict=absent on a missing clone path. Metal answered GREEN. Off-by-one joins the cache three. Clean-room study only.

### 63. The TigerBeetle surfaces hold with IronBeetle beside them: DX, mid, style, and the lesson shelf GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_tigerbeetle_surfaces_hold_witness.rish` · **Stamp:** `20260730.190140` · **Witness:** `tools/gen/season/equinox_tigerbeetle_surfaces_hold_witness.rish` · iron `tools/fixtures/ironbeetle_shelf_census.sh`
Expected say-why GREEN · off-by-one GREEN · style-numbers GREEN · IRON present · COUNT≥34 · ep001 · ep045, and ABSENT refuses on a missing iron shelf or clone. Metal answered GREEN. Surfaces hold toward chapter-four close. Clean-room study only.

### 64. The chapter-four surface choir holds: DX, mid, style, and IronBeetle GREEN together.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch4_surface_witness.rish` · **Stamp:** `20260730.190447` · **Witness:** `tools/gen/season/equinox_ch4_surface_witness.rish`
Expected dx why/how · mid inplace/shrink/bleeds/obo · style numbers/deps/tooling/last · iron COUNT≥34, and ABSENT refuses on a missing clone or iron shelf. Metal answered GREEN. Chapter four closes at sixteen; chapter five waits for metal.

## Chapter Five (16 of 16)

Opened from metal at stamp `20260730.191221`. Themes arrive after findings; this chapter carries none in advance.

### 65. IronBeetle ep001 teaches the wire that needs no parser; checksum meets cast before trust.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep001_choir_witness.rish` · **Stamp:** `20260730.191221` · **Witness:** `tools/gen/season/ironbeetle_ep001_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep001_census.sh` · choir `equinox_ironbeetle_ep001_choir_witness.rish`
Expected IRON=present · EP001 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter five opens; clean-room study only.

### 66. IronBeetle ep002 keeps two columns; money cannot silently appear.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep002_choir_witness.rish` · **Stamp:** `20260730.191731` · **Witness:** `tools/gen/season/ironbeetle_ep002_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep002_census.sh` · choir `equinox_ironbeetle_ep002_choir_witness.rish`
Expected IRON=present · EP002 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 67. IronBeetle ep004 refuses to shard the ledger; one serial core, pipelined rest.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep004_choir_witness.rish` · **Stamp:** `20260730.192532` · **Witness:** `tools/gen/season/ironbeetle_ep004_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep004_census.sh` · choir `equinox_ironbeetle_ep004_choir_witness.rish`
Expected IRON=present · EP004 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Ep003 gap stays open. Clean-room study only.

### 68. IronBeetle ep005 limits everything; back-pressure arrives as consequence.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep005_choir_witness.rish` · **Stamp:** `20260730.203917` · **Witness:** `tools/gen/season/ironbeetle_ep005_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep005_census.sh` · choir `equinox_ironbeetle_ep005_choir_witness.rish`
Expected IRON=present · EP005 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 69. IronBeetle ep006 chooses Zig where never-frees make temporal bugs rare.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep006_choir_witness.rish` · **Stamp:** `20260730.204306` · **Witness:** `tools/gen/season/ironbeetle_ep006_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep006_census.sh` · choir `equinox_ironbeetle_ep006_choir_witness.rish`
Expected IRON=present · EP006 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Ep003 and ep007 gaps stay open. Clean-room study only.

### 70. IronBeetle ep008 runs many ballots so everyone may lead and one truth holds.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep008_choir_witness.rish` · **Stamp:** `20260730.204539` · **Witness:** `tools/gen/season/ironbeetle_ep008_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep008_census.sh` · choir `equinox_ironbeetle_ep008_choir_witness.rish`
Expected IRON=present · EP008 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Ep003 and ep007 gaps stay open. Clean-room study only.

### 71. IronBeetle ep009 hash-chains prepares so the ledger remembers its parent.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep009_choir_witness.rish` · **Stamp:** `20260730.204730` · **Witness:** `tools/gen/season/ironbeetle_ep009_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep009_census.sh` · choir `equinox_ironbeetle_ep009_choir_witness.rish`
Expected IRON=present · EP009 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 72. IronBeetle ep010 lets the disk lie; repair asks by checksum and verifies the answer.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep010_choir_witness.rish` · **Stamp:** `20260730.204939` · **Witness:** `tools/gen/season/ironbeetle_ep010_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep010_census.sh` · choir `equinox_ironbeetle_ep010_choir_witness.rish`
Expected IRON=present · EP010 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 73. IronBeetle ep011 walks five layers to the kernel; checksum never trusts the read alone.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep011_choir_witness.rish` · **Stamp:** `20260730.205130` · **Witness:** `tools/gen/season/ironbeetle_ep011_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep011_census.sh` · choir `equinox_ironbeetle_ep011_choir_witness.rish`
Expected IRON=present · EP011 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 74. IronBeetle ep012 runs one ring for asking and one for answering; deadlines refuse to wait twice.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep012_choir_witness.rish` · **Stamp:** `20260730.205510` · **Witness:** `tools/gen/season/ironbeetle_ep012_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep012_census.sh` · choir `equinox_ironbeetle_ep012_choir_witness.rish`
Expected IRON=present · EP012 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 75. IronBeetle ep013 holds Op · commit_min · commit_max apart; repair reads the break in the chain.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep013_choir_witness.rish` · **Stamp:** `20260730.205720` · **Witness:** `tools/gen/season/ironbeetle_ep013_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep013_census.sh` · choir `equinox_ironbeetle_ep013_choir_witness.rish`
Expected IRON=present · EP013 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 76. IronBeetle ep014 trusts the primary's view and verifies every other header claim.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep014_choir_witness.rish` · **Stamp:** `20260730.210447` · **Witness:** `tools/gen/season/ironbeetle_ep014_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep014_census.sh` · choir `equinox_ironbeetle_ep014_choir_witness.rish`
Expected IRON=present · EP014 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 77. IronBeetle ep015 proves a negative with nacks; a stuck view change stays honestly stuck.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep015_choir_witness.rish` · **Stamp:** `20260730.211417` · **Witness:** `tools/gen/season/ironbeetle_ep015_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep015_census.sh` · choir `equinox_ironbeetle_ep015_choir_witness.rish`
Expected IRON=present · EP015 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 78. IronBeetle ep018 replays the same bug byte for byte; two correct rules can still stall liveness.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep018_choir_witness.rish` · **Stamp:** `20260730.212636` · **Witness:** `tools/gen/season/ironbeetle_ep018_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep018_census.sh` · choir `equinox_ironbeetle_ep018_choir_witness.rish`
Expected IRON=present · EP018 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 79. IronBeetle ep019 reduces storage to a sorted array; tables are index plus value blocks.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep019_choir_witness.rish` · **Stamp:** `20260730.212920` · **Witness:** `tools/gen/season/ironbeetle_ep019_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep019_census.sh` · choir `equinox_ironbeetle_ep019_choir_witness.rish`
Expected IRON=present · EP019 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 80. IronBeetle ep020 shadows rather than overwrites; LSM levels and the Manifest keep the stack searchable.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep020_choir_witness.rish` · **Stamp:** `20260730.215259` · **Witness:** `tools/gen/season/ironbeetle_ep020_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep020_census.sh` · choir `equinox_ironbeetle_ep020_choir_witness.rish`
Expected IRON=present · EP020 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter five fills at sixteen.

---

*May every line here be one the machine said first. May the book close at its bound the way a season does. And may the rest of chapter five wait for metal, not memory.*
