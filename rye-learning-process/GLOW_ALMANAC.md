# The Glow Almanac

**Language:** EN · **Voice:** Kyri · **Status:** Living reference — chartered empty on purpose
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

## Chapter Six (16 of 16)

Opened from metal at stamp `20260730.220543`. Themes arrive after findings; this chapter carries none in advance.

### 81. IronBeetle ep021 writes through one Grid; the queue borrows memory from its callers.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep021_choir_witness.rish` · **Stamp:** `20260730.220543` · **Witness:** `tools/gen/season/ironbeetle_ep021_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep021_census.sh` · choir `equinox_ironbeetle_ep021_choir_witness.rish`
Expected IRON=present · EP021 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter six opens; clean-room study only.

### 82. IronBeetle ep022 delivers a proven block; local disk may fail while the read still succeeds.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep022_choir_witness.rish` · **Stamp:** `20260730.222615` · **Witness:** `tools/gen/season/ironbeetle_ep022_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep022_census.sh` · choir `equinox_ironbeetle_ep022_choir_witness.rish`
Expected IRON=present · EP022 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 83. IronBeetle ep025 stores the tree's map as a list of changes; persistence means add, never erase.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep025_choir_witness.rish` · **Stamp:** `20260730.223644` · **Witness:** `tools/gen/season/ironbeetle_ep025_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep025_census.sh` · choir `equinox_ironbeetle_ep025_choir_witness.rish`
Expected IRON=present · EP025 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 84. IronBeetle ep028 stages a freed block until the next checkpoint; reserve then acquire keeps addresses deterministic.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep028_choir_witness.rish` · **Stamp:** `20260730.224645` · **Witness:** `tools/gen/season/ironbeetle_ep028_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep028_census.sh` · choir `equinox_ironbeetle_ep028_choir_witness.rish`
Expected IRON=present · EP028 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 85. IronBeetle ep030 asks which manifest-log entry owns a reused address; table_extent answers what an address alone cannot.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep030_choir_witness.rish` · **Stamp:** `20260730.224932` · **Witness:** `tools/gen/season/ironbeetle_ep030_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep030_census.sh` · choir `equinox_ironbeetle_ep030_choir_witness.rish`
Expected IRON=present · EP030 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 86. IronBeetle ep031½ keeps a durable fact in one coherent form; journal and checkpoint must truly copy the same thing.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep031_choir_witness.rish` · **Stamp:** `20260730.225826` · **Witness:** `tools/gen/season/ironbeetle_ep031_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep031_census.sh` · choir `equinox_ironbeetle_ep031_choir_witness.rish`
Expected IRON=present · EP031 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 87. IronBeetle ep032 orders engineering values: safety first, then performance, then experience — programming integrated over time.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep032_choir_witness.rish` · **Stamp:** `20260730.225955` · **Witness:** `tools/gen/season/ironbeetle_ep032_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep032_census.sh` · choir `equinox_ironbeetle_ep032_choir_witness.rish`
Expected IRON=present · EP032 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 88. IronBeetle ep033 prefetches a whole batch of accounts before executing any transfer; load before decide.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep033_choir_witness.rish` · **Stamp:** `20260730.232243` · **Witness:** `tools/gen/season/ironbeetle_ep033_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep033_census.sh` · choir `equinox_ironbeetle_ep033_choir_witness.rish`
Expected IRON=present · EP033 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 89. IronBeetle ep034 forbids half-sync callbacks; asynchronous always means the next tick, and prefetch stays parallel while commit stays sequential.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep034_choir_witness.rish` · **Stamp:** `20260730.232630` · **Witness:** `tools/gen/season/ironbeetle_ep034_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep034_census.sh` · choir `equinox_ironbeetle_ep034_choir_witness.rish`
Expected IRON=present · EP034 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 90. IronBeetle ep035 makes the internal key a logical clock; resubmission of an identical transfer is success, not error.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep035_choir_witness.rish` · **Stamp:** `20260730.233337` · **Witness:** `tools/gen/season/ironbeetle_ep035_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep035_census.sh` · choir `equinox_ironbeetle_ep035_choir_witness.rish`
Expected IRON=present · EP035 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 91. IronBeetle ep036 keeps a cache that always hits via stash: a promise with a batch-sized deadline, plus an undo log for linked transfers.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep036_choir_witness.rish` · **Stamp:** `20260730.235319` · **Witness:** `tools/gen/season/ironbeetle_ep036_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep036_census.sh` · choir `equinox_ironbeetle_ep036_choir_witness.rish`
Expected IRON=present · EP036 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 92. IronBeetle ep037½ folds compaction into each commit: garbage collection at allocation so replicas stay byte-identical.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep037_choir_witness.rish` · **Stamp:** `20260731.002155` · **Witness:** `tools/gen/season/ironbeetle_ep037_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep037_census.sh` · choir `equinox_ironbeetle_ep037_choir_witness.rish`
Expected IRON=present · EP037 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 93. IronBeetle ep038 routes a whole compaction round from one beat number; even levels, then odd, from a single modulo.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep038_choir_witness.rish` · **Stamp:** `20260731.002402` · **Witness:** `tools/gen/season/ironbeetle_ep038_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep038_census.sh` · choir `equinox_ironbeetle_ep038_choir_witness.rish`
Expected IRON=present · EP038 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 94. IronBeetle ep040 overlaps read, merge, and write in three pipeline slots; bar and beat clocks pace one compaction round.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep040_choir_witness.rish` · **Stamp:** `20260731.003616` · **Witness:** `tools/gen/season/ironbeetle_ep040_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep040_census.sh` · choir `equinox_ironbeetle_ep040_choir_witness.rish`
Expected IRON=present · EP040 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 95. IronBeetle ep042 crosses the Alps into the merge loop itself; table_builder writes checksummed blocks from what the loop produces.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep042_choir_witness.rish` · **Stamp:** `20260731.005353` · **Witness:** `tools/gen/season/ironbeetle_ep042_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep042_census.sh` · choir `equinox_ironbeetle_ep042_choir_witness.rish`
Expected IRON=present · EP042 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only.

### 96. IronBeetle ep043 makes the Manifest the moment of truth: written tables stay unacknowledged until apply; snapshots defer erasure.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep043_choir_witness.rish` · **Stamp:** `20260731.005634` · **Witness:** `tools/gen/season/ironbeetle_ep043_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep043_census.sh` · choir `equinox_ironbeetle_ep043_choir_witness.rish`
Expected IRON=present · EP043 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter six fills at sixteen.

## Chapter Seven (16 of 16)

Opened from metal at stamp `20260731.114927`. Themes arrive after findings; this chapter carries none in advance. Ch5 and ch6 surface closes parked per e92 ruling D until close-seat; e119 answers close-seat — surfaces as tools, park lifted, no chapter-close seats spent.

### 97. IronBeetle ep044 traces everything we know from the first byte: two jobs of consensus, and honesty about unfinished code.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep044_choir_witness.rish` · **Stamp:** `20260731.114927` · **Witness:** `tools/gen/season/ironbeetle_ep044_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep044_census.sh` · choir `equinox_ironbeetle_ep044_choir_witness.rish`
Expected IRON=present · EP044 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Chapter seven opens under e76 law; clean-room study only.

### 98. IronBeetle ep045 restates the whole machine in one breath: await by hand, one sequential core, prefetch before decide, DST as the quiet reason.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ironbeetle_ep045_choir_witness.rish` · **Stamp:** `20260731.115725` · **Witness:** `tools/gen/season/ironbeetle_ep045_census_witness.rish` · scan `tools/fixtures/ironbeetle_ep045_census.sh` · choir `equinox_ironbeetle_ep045_choir_witness.rish`
Expected IRON=present · EP045 · HONORS · SOURCE · TEACH · RHYME · CLEAN · MATKLAD_OK, and verdict=absent on a missing iron shelf. Metal answered GREEN. Clean-room study only. Chapter seven advances to two of sixteen.

### 99. Census control seats planted positives and a planted negative: no total until the control reads; naive H1 refuses.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_census_control_choir_witness.rish` · **Stamp:** `20260731.120704` · **Witness:** `tools/gen/season/census_control_witness.rish` · scan `tools/fixtures/census_control_scan.sh` · choir `equinox_census_control_choir_witness.rish`
Expected duties_honored=3 · true=1 · naive=4 · marker stamp in shape · glow cache untracked, and prove-red (naive-as-total) exits non-zero. Metal answered GREEN. Commence arc fills chapter seven after the IronBeetle written shelf ended; invent none.

### 100. Commence M5 re-cuts every green behind the proven census control: glow desk, baton museum, rune alphabet, hygiene, prin-scope, advisory-11, and tracked inventory.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m5_choir_witness.rish` · **Stamp:** `20260731.122121` · **Witness:** `tools/gen/season/commence_m5_recut_witness.rish` · scan `tools/fixtures/commence_m5_recut_scan.sh` · choir `equinox_commence_m5_choir_witness.rish`
Expected control_gate=honored · advisory 11/11 · inventory behind control · baton breach 0 · glow · alphabet · hygiene · prin-scope GREEN. Pinned meters (sundial · fascia · shred) stay pinned. Metal answered GREEN. Commence arc fills chapter seven; invent none.

### 101. Commence M6 see: eyes census behind the proven census control — almanac seats, waymarks, IronBeetle shelf end, museum, inventory.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m6_choir_witness.rish` · **Stamp:** `20260731.124416` · **Witness:** `tools/gen/season/commence_m6_see_witness.rish` · scan `tools/fixtures/commence_m6_see_scan.sh` · choir `equinox_commence_m6_choir_witness.rish`
Expected control_gate=honored · see_almanac seats 97–100 · see_waymarks e93–e96 · see_shelf_end=ep045 · see_ep046=absent · baton breach 0 · inventory behind control. See != run. Metal answered GREEN. Invent none.

### 102. Commence M7 weave: shed census behind proven control — C1 keeps reachable, C2 exposes unreachable; orphan floor informs Class O propose.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_shed_census_choir_witness.rish` · **Stamp:** `20260731.125153` · **Witness:** `tools/gen/season/shed_census_witness.rish` · scan `tools/fixtures/shed_census_scan.sh` · choir `equinox_shed_census_choir_witness.rish`
Expected control_gate · tracked planted controls · C1=REFERENCED · C2=ORPHAN · controls 2 of 2 · orphan floor · fascia_health_now/if_shed · shred=RED · prove-red refuses. Class O propose-never-seat. Metal answered GREEN. Invent none.

### 103. Commence M8 saga: the ordered commence-arc story behind the proven control — eight waymark beats, seats 97–102, shelf end ep045.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m8_choir_witness.rish` · **Stamp:** `20260731.130318` · **Witness:** `tools/gen/season/commence_m8_saga_witness.rish` · scan `tools/fixtures/commence_m8_saga_scan.sh` · choir `equinox_commence_m8_choir_witness.rish`
Expected control_gate · saga_home · saga_beats=8 · saga_almanac seats 97–102 · saga_shelf_end=ep045 · saga_ep046=absent · baton breach 0. Saga != see != weave. Metal answered GREEN. Invent none.

### 104. Commence M9 ascent: handbacks consumed outward, nested return_surface_p59 waiting, commence-arc prose saga PROPOSED — nine waymark beats, seats 97–103, shelf end ep045.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_m9_choir_witness.rish` · **Stamp:** `20260731.131436` · **Witness:** `tools/gen/season/commence_m9_ascent_witness.rish` · scan `tools/fixtures/commence_m9_ascent_scan.sh` · choir `equinox_commence_m9_choir_witness.rish`
Expected control_gate · ascent_saga PROPOSED · ascent_beats=9 · ascent_handbacks · ascent_nested=return_surface_p59 not_consumed · ascent_almanac seats 97–103 · ascent_shelf_end=ep045 · ascent_ep046=absent · baton breach 0. Ascent != saga != weave. Metal answered GREEN. Invent none.

### 105. Commence-arc saga Seated + fork named: Keaton approve seats the narrative; nested return_surface_p59 stays unconsumed (RETURN or EXTEND +128).
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_commence_saga_seat_choir_witness.rish` · **Stamp:** `20260731.132459` · **Witness:** `tools/gen/season/commence_saga_seat_fork_witness.rish` · scan `tools/fixtures/commence_saga_seat_fork_scan.sh` · choir `equinox_commence_saga_seat_choir_witness.rish`
Expected control_gate · seat_saga SEATED 20260731.131240 · seat_m9 complement · seat_fork not_consumed · seat_almanac seats 97–104 · seat_shelf_end=ep045 · baton breach 0. Seating != consuming the fork. Metal answered GREEN. Invent none.

### 106. Equinox e102 fascia chase: re-cut meters; clear memcpy app and signal-1 prose; hold Class A paper lean at 4; fascia 85→92.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e102_fascia_chase_choir_witness.rish` · **Stamp:** `20260731.134253` · **Witness:** `tools/gen/season/equinox_e102_fascia_chase_witness.rish` · scan `tools/fixtures/equinox_e102_fascia_chase_scan.sh` · choir `equinox_e102_fascia_chase_choir_witness.rish`
Expected control_gate · chase_saga SEATED · chase_memcpy · chase_fascia_grade=92 · chase_class_a=4 paper lean · chase_fork not_consumed · seats 97–105 · shelf end ep045 · baton breach 0. Pins reform when a round re-cuts. Metal answered GREEN. Invent none.

### 107. Equinox e103 Class A refine + window_min: fascia metric i7 excludes four honest Siya-turn anchors; fall baseline is window_min; fascia 92→100.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e103_class_a_window_choir_witness.rish` · **Stamp:** `20260731.135111` · **Witness:** `tools/gen/season/equinox_e103_class_a_window_witness.rish` · scan `tools/fixtures/equinox_e103_class_a_window_scan.sh` · choir `equinox_e103_class_a_window_choir_witness.rish`
Expected control_gate · refine_memcpy paid · metric_rev=i7 · class_a=0 · class_a_honest_excluded=4 · baseline_kind=window_min · fascia=100 · fork not_consumed · seats 97–106 · shelf end ep045 · baton breach 0. A signal that penalizes an honest record is measuring the wrong thing. Metal answered GREEN. Invent none.

### 108. Equinox e104 hold Class A disclosed + Class O rooms: fascia metric i8 holds four honest anchors with reason named (not excluded); Class O room home in SHRED_PREP; fascia 100→92; window_min kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e104_hold_class_o_choir_witness.rish` · **Stamp:** `20260731.135935` · **Witness:** `tools/gen/season/equinox_e104_hold_class_o_witness.rish` · scan `tools/fixtures/equinox_e104_hold_class_o_scan.sh` · choir `equinox_e104_hold_class_o_choir_witness.rish`
Expected control_gate · metric_rev=i8 · class_a=4 · class_a_held_disclosed=4 · law=hold_not_exclude · baseline_kind=window_min · fascia=92 · Class O rooms · no paths seated · fork not_consumed · seats 97–107 · shelf end ep045 · baton breach 0. Exclusion hides; holding discloses. Metal answered GREEN. Invent none.

### 109. Equinox e105 window carry + M3/M4 home land: fascia metric i9 carries the window across revisions and restores the arc fall 100/85/92 (−15); M3 oldness census and M4 radiant H1 fence land from named paths; Class A i8 hold kept; fascia 92.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e105_window_m3_m4_choir_witness.rish` · **Stamp:** `20260731.140842` · **Witness:** `tools/gen/season/equinox_e105_window_m3_m4_witness.rish` · scan `tools/fixtures/equinox_e105_window_m3_m4_scan.sh` · choir `equinox_e105_window_m3_m4_choir_witness.rish`
Expected control_gate · metric_rev=i9 · window_carry=honored · window_min=85 · window_arc_fall=-15 · class_a held 4 · hold_not_exclude · fascia=92 · M3 four_fifths · SAFE 0/64 · M4 fence-aware · governing template · fork not_consumed · seats 97–108 · shelf end ep045 · baton breach 0. A revision carries its window. Metal answered GREEN. Invent none.

### 110. Equinox e106 REDS zero-view: ledger row 33 records that a zero names the instrument's view, never the world; planted empty-view + archive-fall control; M3/M4 home land already consumed on e105; fascia i9 hold kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e106_reds_zero_view_choir_witness.rish` · **Stamp:** `20260731.141409` · **Witness:** `tools/gen/season/equinox_e106_reds_zero_view_witness.rish` · scan `tools/fixtures/equinox_e106_reds_zero_view_scan.sh` · choir `equinox_e106_reds_zero_view_choir_witness.rish`
Expected control_gate · REDS rows=33 · monotone expect_next=34 · zero_view planted · prove-red refuses · m3_m4 e105_consumed · metric_rev=i9 · hold_not_exclude · fascia=92 · fork not_consumed · seats 97–109 · shelf end ep045 · baton breach 0. Look where the thing would be before calling it gone. Metal answered GREEN. Invent none.

### 111. Equinox e107 seat map: corrected close path after seat 110 spent on e106; proposes seat 112 CLOSE CHOIR as check·test·prepare; bundle as crossing mode; shred Keaton-gated; ch5+ch6 close-seat row still parked.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e107_seat_map_choir_witness.rish` · **Stamp:** `20260731.141952` · **Witness:** `tools/gen/season/equinox_e107_seat_map_witness.rish` · scan `tools/fixtures/equinox_seat_map_scan.sh` · pin `work-in-progress/EQUINOX_SEAT_MAP.md`
Expected control_gate · seat_map 110 spent · 112 close choir proposed · bundle crossing mode · shred Keaton-gated · fork not_consumed · seats 97–110 · shelf end ep045 · baton breach 0. Look at spent seats before naming the remaining map. Metal answered GREEN. Invent none.

### 112. Equinox e108 Chapter Seven close choir: check·test·prepare on seat 112; REDS rows 34–37 cross (find→git ls-files · verify a zero · fence-aware H1 · no backtick); bundle as crossing mode; shred opens Chapter Eight; ch5+ch6 close-seat row still parked.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e108_ch7_close_choir_witness.rish` · **Stamp:** `20260731.142604` · **Witness:** `tools/gen/season/equinox_e108_ch7_close_witness.rish` · scan `tools/fixtures/equinox_e108_ch7_close_scan.sh` · pin `work-in-progress/EQUINOX_SEAT_MAP.md`
Expected control_gate · seat_map 112 close choir this sitting · shred opens Chapter Eight · REDS rows=37 · expect_next=38 · M3/M4 kept · zero_view · fascia i9 hold 92 · fork not_consumed · seats 97–111 → 112 · shelf end ep045 · baton breach 0. A chapter-close choir is a check. Metal answered GREEN. Chapter seven fills at sixteen. Invent none.

## Chapter Eight (15 of 16)

Opened from metal at stamp `20260731.143548`. Themes arrive after findings; this chapter carries none in advance. Bundle and shred stay itinerary modes; Class O paths await Keaton's word.

### 113. Equinox e109 chapter-seven surface: fifteen limbs (seats 97–111) GREEN together; itinerary refined so bundle and shred are modes (not seats); only the close choir was a seat; ch5+ch6 close-seat row still parked.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_ch7_surface_witness.rish` · **Stamp:** `20260731.143548` · **Witness:** `tools/gen/season/equinox_ch7_surface_witness.rish` · scan `tools/fixtures/equinox_ch7_surface_scan.sh` · pin `work-in-progress/EQUINOX_SEAT_MAP.md`
Expected shelf ep044/ep045 · commence control/M5/M6/shed/M8/M9/saga-seat · meter e102–e105 · zero-view · REDS monotone · itinerary modes · fork not_consumed · shelf end ep045 · ABSENT refuses · baton breach 0. A duty is not a seat unless the almanac says so. Metal answered GREEN. Chapter eight opens; invent none.

### 114. Equinox e110: e92-shaped surface census finds four (ch2·ch3·ch4·ch7); ch7 close is findable as equinox_ch7_surface_witness; Chapter Eight reserves seat 128 for the close choir on day one (content fills 114–127).
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e110_ch8_reserve_choir_witness.rish` · **Stamp:** `20260731.144219` · **Witness:** `tools/gen/season/equinox_e110_ch8_reserve_witness.rish` · scan `tools/fixtures/equinox_e110_ch8_reserve_scan.sh` · pin `work-in-progress/EQUINOX_SEAT_MAP.md`
Expected control_gate · surface_count=4 · chapters 2,3,4,7 · ch5/ch6 absent · seat_128 reserved_close_choir · ch8 span 113–128 · fork not_consumed · shelf end ep045 · baton breach 0. A record that cannot be found by the census that will look for it is not yet a record. Metal answered GREEN. Invent none.

### 115. Equinox e111 date dialect: eleven context Last updated values compact (hyphenated day -> YYYYMMDD in backticks); 17 of 17 compact; zero hyphenated; seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e111_date_dialect_choir_witness.rish` · **Stamp:** `20260731.145236` · **Witness:** `tools/gen/season/equinox_e111_date_dialect_witness.rish` · scan `tools/fixtures/equinox_e111_date_dialect_scan.sh`
Expected control_gate · dialect_transformed=11 · hyphenated_last_updated=0 · 17_of_17_compact · lint label-only dep · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. Carry the transformation, never the claim that it was done. A format change claims no review. Metal answered GREEN. Invent none.

### 116. Equinox e112 planted date-dialect witness: C1 hyphenated control counted; C2 compact control not counted as hyphen; library 17 of 17 compact (one_dialect); prove-red refuses; seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e112_date_dialect_choir_witness.rish` · **Stamp:** `20260731.150232` · **Witness:** `tools/gen/season/equinox_e112_date_dialect_witness.rish` · standing `tools/gen/season/date_dialect_witness.rish` · scan `tools/fixtures/date_dialect_scan.sh` · equinox scan `tools/fixtures/equinox_e112_date_dialect_witness_scan.sh`
Expected control_gate · controls_honored=2 · hyphenated=0 · compact=17 · verdict=one_dialect · prove-red RED_C2-compact · elder e111 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. A duty with no witness has no seat, and a duty with no seat never lands. Carry the transformation, never the claim that it was done. Metal answered GREEN. Invent none.

### 117. Equinox e113 fascia-health v1: live surface over total tracked surface behind planted live + dated controls; REDS row 38 records that on-disk is not in-the-tree (presence via git ls-files); seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e113_fascia_health_choir_witness.rish` · **Stamp:** `20260731.150834` · **Witness:** `tools/gen/season/equinox_e113_fascia_health_witness.rish` · standing `tools/gen/season/fascia_health_witness.rish` · scan `tools/fixtures/fascia_health_scan.sh` · equinox scan `tools/fixtures/equinox_e113_fascia_health_scan.sh`
Expected control_gate · instruments_tracked · controls_honored=2 · fascia_health=41 · prove-red RED_on_disk_is_not_in_the_tree · REDS rows=38 · expect_next=39 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. On-disk is not in-the-tree. Metal answered GREEN. Invent none.

### 118. Equinox e114 thing-not-name: planted emitter proves a value can live without its key in the filename; shed emits fascia_health_now and standalone emits fascia_health (two roofs); REDS row 39 records look for the thing, not for the name of the thing; seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e114_thing_not_name_choir_witness.rish` · **Stamp:** `20260731.151651` · **Witness:** `tools/gen/season/equinox_e114_thing_not_name_witness.rish` · standing `tools/gen/season/thing_not_name_witness.rish` · scan `tools/fixtures/thing_not_name_scan.sh` · equinox scan `tools/fixtures/equinox_e114_thing_not_name_scan.sh`
Expected control_gate · instruments_tracked · demo_meter=7 · name_hits_demo_meter=0 · roofs=2 · prove-red RED_looked_for_name_not_thing · REDS rows=39 · expect_next=40 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. Look for the thing, not for the name of the thing. Metal answered GREEN. Invent none.

### 119. Equinox e115 instrument-season suite: counsel's nine meters plus thing-not-name as tenth run together (pass=10 fail=0); prove-red refuses a manufactured suite pass; remaining work is Keaton-gated (fork · breach · shred · names); seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e115_instrument_suite_choir_witness.rish` · **Stamp:** `20260731.152749` · **Witness:** `tools/gen/season/equinox_e115_instrument_suite_witness.rish` · standing `tools/gen/season/instrument_suite_witness.rish` · scan `tools/fixtures/instrument_suite_scan.sh` · equinox scan `tools/fixtures/equinox_e115_instrument_suite_scan.sh`
Expected control_gate · instruments_tracked · pass=10 · fail=0 · prove-red RED_manufactured_suite_pass · remaining=keaton_gated · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. Seat the suite; do not manufacture meters. Metal answered GREEN. Invent none.

### 120. Equinox e116 one dated definition: shared dated_classify seats living-vs-dated once in code; shed and fascia-health both source it; divergence witness goes RED while dated_testimony differs; REDS row 40 records when two roofs carry one name, either they agree or the name is doing two jobs; seat 128 stays reserved; surface census four kept.
**Ran:** `rishi/bin/rishi run tools/gen/season/equinox_e116_dated_one_definition_choir_witness.rish` · **Stamp:** `20260731.154603` · **Witness:** `tools/gen/season/equinox_e116_dated_one_definition_witness.rish` · standing `tools/gen/season/dated_pattern_witness.rish` · `tools/gen/season/dated_roof_divergence_witness.rish` · scan `tools/fixtures/dated_pattern_scan.sh` · `tools/fixtures/dated_roof_divergence_scan.sh` · equinox scan `tools/fixtures/equinox_e116_dated_one_definition_scan.sh`
Expected control_gate · instruments_tracked · definition=one · divergence=absent · roofs_agree · prove-red RED_dated_definition_blind · RED_roofs_diverge · REDS rows=40 · expect_next=41 · seat_128 reserved · surface_count=4 · fork not_consumed · shelf end ep045 · baton breach 0. When two roofs carry one name, either they agree or the name is doing two jobs. Metal answered GREEN. Invent none.

### 121. Equinox e117 fork EXTEND + breach let-close: Keaton's word (fuse kg approving all breaches forks recommendations) seats THE FORK as EXTEND +128 with nested return_surface_p59 held not consumed; seats THE BREACH as let close — census_breach_count=0 banked approval closed unspent; roof reconciliation already e116; geode stays APPROVED GATED; shred RED; seat 128 stays reserved; surface census four kept.
**Ran:** `sh tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh` · **Stamp:** `20260731.170541` · **Witness:** `tools/gen/season/equinox_e117_fork_extend_breach_close_witness.rish` · counsel `counsel/date/20260731/20260731-170354_e117-fork-extend-breach-let-close.md` · scan `tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh`
Expected control_gate · instruments_tracked · fork_word=EXTEND · handback_status=not_consumed · breach_status=closed_unspent · geode APPROVED_GATED · seat_128 reserved · surface_count=4 · prove-red RED_approve_all_consumed_handback · roof e116 kept · shelf end ep045 · baton breach 0. Approve-all seats recommended yes/no leans; hard lines still refuse shred. Metal answered GREEN. Invent none.

### 122. Equinox e118 metal corrections: roofs agree CLOSED — dated_testimony matches on both roofs while fascia_health (live/total) and fascia_health_now (orphan-share) keep two jobs under lookalike names; stale Cloud-blocked baton debt retires — each bench re-cuts tool presence (binaries gitignored); seat 128 stays reserved; surface census four kept; fork EXTEND and breach closed unspent kept.
**Ran:** `sh tools/fixtures/equinox_e118_metal_corrections_scan.sh` · **Stamp:** `20260731.173310` · **Witness:** `tools/gen/season/equinox_e118_metal_corrections_witness.rish` · counsel `counsel/date/20260731/20260731-172902_e118-metal-corrections.md` · scan `tools/fixtures/equinox_e118_metal_corrections_scan.sh`
Expected control_gate · instruments_tracked · roofs_status=CLOSED · divergence=absent · dated_testimony agrees · stale_cloud_blocked=retired · tool_presence=per_bench_recut · prove-red RED_claimed_diverge_while_agree · seat_128 reserved · surface_count=4 · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. When two roofs carry one name, either they agree or the name is doing two jobs. Metal answered GREEN. Invent none.

### 123. Equinox e119 close-seat surfaces: close-seat row answered — a surface witness claims no seat of its own; ch5 and ch6 surfaces land as tools (equinox_ch5_surface_witness.rish · equinox_ch6_surface_witness.rish) over already-GREEN limbs with no chapter-close almanac row and no seat displaced; e92-shaped census finds six (ch2·ch3·ch4·ch5·ch6·ch7); e92 park lifted by Keaton fuse kg on the measured answer; seat 128 stays reserved.
**Ran:** `sh tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh` · **Stamp:** `20260731.174712` · **Witness:** `tools/gen/season/equinox_e119_close_seat_surfaces_witness.rish` · counsel `counsel/date/20260731/20260731-214426_e119-close-seat-surfaces.md` · scan `tools/fixtures/equinox_e119_close_seat_surfaces_scan.sh`
Expected control_gate · instruments_tracked · ch5+ch6 surface scans ok · surface_count=6 · e92_park=lifted · no_almanac_seat honored · prove-red RED_claimed_four_while_six · seat_128 reserved · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. A surface witness claims no seat of its own. Metal answered GREEN. Invent none.

### 124. Equinox e120 Lexicon roots: seats **roots** as the general category of client surfaces — Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS; distinct from Bench · pier · Pond · digest/Tilak roots; seat 128 stays reserved; surface census six kept; close-seat answered kept.
**Ran:** `sh tools/fixtures/equinox_e120_lexicon_roots_scan.sh` · **Stamp:** `20260731.175418` · **Witness:** `tools/gen/season/equinox_e120_lexicon_roots_witness.rish` · counsel `counsel/date/20260731/20260731-215300_e120-lexicon-roots.md` · Lexicon `context/LEXICON.md`
Expected control_gate · instruments_tracked · roots=honored · four members · Bench/pier/Pond distinctions · prove-red RED_claimed_roots_absent_while_seated · seat_128 reserved · surface_count=6 · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. Look for the thing, not for the name of the thing. Metal answered GREEN. Invent none.

### 125. Equinox e121 roots bench amend: Lexicon **roots** amended — surfaces through which work reaches the tree; members add Framework and counsel container beside Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS; a root that holds a raise is a **Bench**, and only a bench runs witnesses; name the root when a measurement is reported; Bench row accretes kinship; seat 128 stays reserved; surface census six kept.
**Ran:** `sh tools/fixtures/equinox_e121_roots_bench_amend_scan.sh` · **Stamp:** `20260731.180617` · **Witness:** `tools/gen/season/equinox_e121_roots_bench_amend_witness.rish` · counsel `counsel/date/20260731/20260731-220432_e121-roots-bench-amend.md` · Lexicon `context/LEXICON.md`
Expected control_gate · roots=honored · bench_kinship=honored · six members · prove-red RED_claimed_bench_not_raised_root · seat_128 reserved · surface_count=6 · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. Name the root when a measurement is reported. Metal answered GREEN. Invent none.

### 126. Equinox e122 roots bench kinds: Lexicon **roots** restored to four client surfaces (Claude web · Claude iOS · Cursor AppImage desktop · Cursor iOS) — where the hand sits to send words; **Bench** kept a different kind — where claims become evidence; e121 blur that made Bench a raised root is refused; hard line corrected to name the **Bench** when a measurement is reported; seat 128 stays reserved; surface census six kept.
**Ran:** `sh tools/fixtures/equinox_e122_roots_bench_kinds_scan.sh` · **Stamp:** `20260731.181541` · **Witness:** `tools/gen/season/equinox_e122_roots_bench_kinds_witness.rish` · counsel `counsel/date/20260731/20260731-221131_e122-roots-bench-kinds.md` · Lexicon `context/LEXICON.md`
Expected control_gate · roots=honored · kinds=honored · four members · prove-red RED_claimed_bench_is_raised_root · name_the_bench law · seat_128 reserved · surface_count=6 · remember non-empty · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. When two roofs carry one name, either they agree or the name is doing two jobs. Metal answered GREEN. Invent none.

### 127. Equinox e123 living-pin guard: content guard for rostered living pins — non-empty · header present · tracked via git ls-files · bound enforce or hold_over disclose; planted emptied fixture must be caught (prove-red RED_living_pin_emptied_caught); would have named the e121 REMEMBER wipe; no git-history walk; e122 roots≠Bench kinds kept; seat 128 stays reserved; surface census six kept. Approve-all seated this lean; shred · SAFE · geode stay Keaton-gated.
**Ran:** `sh tools/fixtures/equinox_e123_living_pin_guard_scan.sh` · **Stamp:** `20260731.182809` · **Witness:** `tools/gen/season/equinox_e123_living_pin_guard_witness.rish` · counsel `counsel/date/20260731/20260731-222426_e123-living-pin-guard.md` · roster `tools/fixtures/living_pin_guard_roster.txt` · emptied `tools/fixtures/living_pin_emptied_control.md`
Expected control_gate · pins=honored · emptied_control=honored · kinds=honored · history_independence · prove-red RED_living_pin_emptied_caught · seat_128 reserved · surface_count=6 · fork EXTEND · handback not_consumed · shelf end ep045 · baton breach 0. A duty with no witness never lands. Metal answered GREEN. Invent none.

---

*May every line here be one the machine said first. May the book close at its bound the way a season does. And may the rest of chapter eight wait for metal, not memory — shred only by Keaton's word.*
