#!/usr/bin/env sh
# standing_equipment_scope_map.sh -- which files each STATIC guard actually watches.
#
# The fusion build's map (design active-designing/20260825-173153_reprove-only-what-moved.md;
# the skip word given 20260828). A `--scoped` roster pass reads this and runs, by name, the
# guards a change can reach. One line per guard: the name, then watch words as shell patterns --
# a word ending in / watches its whole room, and tools/fixtures/s/standing_equipment_run.sh
# matches every word against each changed path with case-glob semantics.
#
# CURATED BY A HAND, for the judgment inside it: a row follows the guard's GATED readings, so an
# advisory ratchet the witness merely prints leaves the watch-set where it is. That call lives in
# a reader's head rather than in a grep, so the map is a tracked fixture, measured into being on
# 20260829 by a survey of all 111 rostered guards (59 static, 41 discovery, 11 env/clock; the
# survey and per-guard extractions rest in that day's session logs).
#
# ABSENCE RUNS, and this file leans on that: a guard the map leaves out runs on every pass,
# exactly as the roster's capability tier holds. So a newborn guard is covered before anyone maps
# it, a typo in a name here buys a run, and DISCOVERY guards (whole-tree censuses, git-grep
# discoverers, reference sweeps) stay unmapped on purpose.
#
# A ROW GROWS WITH ITS GUARD, in the same commit (.claude/rules/docs-implementation-sync.md). A
# static row naming less than its guard gates is the one direction that skips real work, and on
# 20260906 thirteen rows stood in it: each named a guard whose own `<name>_control.sh` no watch
# word reached, while every one of those thirteen witnesses asserts on that control between 2 and
# 42 times, which the map's own gated-readings rule already required. `prose_register` reached
# none of the twelve-document DOOR roster it gates. Adding a watch word only ever makes a guard
# run more often, so a row grows freely.
#
# THE BUILD EDGE: a guard that compiles Rye watches the compiler too -- rye/, rishi's source and
# binary, the copy shim, and the vendored toolchain -- so the map stays true the day the
# toolchain moves. Rows carry [build] and the expansion happens below, spelled once.

set -eu

build_edge="rye/ rishi/src/ rishi/bin/ tally/copy.rye vendor/zig-toolchain/"

sed -e "s|\[build\]|$build_edge|g" <<'MAP'
ales_roster tools/al/ales_roster_witness.rish tools/fixtures/a/ales_roster_bijection_scan.sh tools/al/ tools/*/ales_*_witness.rish
ales_suite tools/al/ales_suite_witness.rish tools/fixtures/a/ tools/al/ lotus/ tools/*/ales_*_witness.rish [build]
caravan_ladder_roster tools/ca/caravan_ladder_roster_witness.rish tools/fixtures/c/caravan_ladder_roster_scan.sh caravan/ tools/ca/ tools/fixtures/c/caravan_ladder_roster_control.sh
caravan_suite tools/ca/caravan_suite_witness.rish tools/fixtures/c/ tools/ca/ caravan/ vendor/sel4/ tools/*/caravan_*_witness.rish [build]
comlink_topology tools/co/comlink_topology_witness.rish comlink/ [build]
comlink_turn_route tools/co/comlink_turn_route_witness.rish comlink/ [build]
comlink_handshake_turn tools/co/comlink_handshake_turn_witness.rish comlink/ [build]
comlink_rehearsal_wire tools/co/comlink_rehearsal_wire_witness.rish comlink/ [build]
constel_module_roster tools/co/constel_module_roster_witness.rish tools/fixtures/m/module_roster_scan.sh constel/
crypto_count_guard tools/cr/crypto_count_guard_witness.rish crypto/ tools/cr/
crypto_module_roster tools/cr/crypto_module_roster_witness.rish tools/fixtures/m/module_roster_scan.sh crypto/
crypto_suite tools/cr/crypto_suite_witness.rish crypto/ tools/cr/ vendor/pqclean/ vendor/monocypher/ [build]
custody_gate_instruction tools/cu/custody_gate_instruction_witness.rish tools/fixtures/c/custody_gate_instruction_scan.sh recursion-prompts/ tools/l/launch-* tools/fixtures/c/custody_gate_instruction_control.sh
equinox_e123_living_pin_guard tools/equinox/witness/equinox_e123_living_pin_guard_witness.rish tools/fixtures/e/equinox_e123_living_pin_guard_scan.sh tools/fixtures/l/living_pin_max_bytes.sh construction/ session-logs/README.md tools/equinox/witness/ gratitude/ironbeetle/
fixture_depth tools/f/fixture_depth_witness.rish tools/fixtures/ tools/t/tool_path_resolve.rish
fora_socket tools/f/fora_socket_witness.rish constel/ comlink/ [build]
glow_choir tools/g/glow_choir_witness.rish glow/ tools/g/glow_* tools/au/aurora_glow_* tools/m/mantra_glow_* tools/t/tally_glow_* active-designing/docs/glow/ [build]
glow_compose_after_inc tools/g/glow_compose_after_inc_witness.rish tools/g/glow_run.rish glow/ src/gate/ [build]
glow_shop_gate_pair_faces tools/g/glow_shop_gate_pair_faces_witness.rish tools/g/glow_tend_a2_suite.rish glow/ tools/g/ [build]
glow_shop_gate_pair_select tools/g/glow_shop_gate_pair_select_witness.rish tools/g/glow_run.rish glow/ [build]
glow_shop_gate_horizon tools/g/glow_shop_gate_horizon_witness.rish glow/ tools/g/ [build]
glow_tally_pair_bound tools/g/glow_tally_pair_bound_witness.rish tools/g/glow_run.rish tools/g/glow_run_worker.sh glow/ [build]
glow_vane_pair_mirrors tools/g/glow_vane_pair_mirrors_witness.rish tools/g/glow_run_worker.sh glow/ [build]
image_module_roster tools/i/image_module_roster_witness.rish tools/fixtures/m/module_roster_scan.sh image/
index_fold tools/i/index_fold_witness.rish tools/fixtures/i/index_fold_scan.sh tools/rye/session_logs_archive.rye session-logs/ counsel/ active-designing/ expanding-prompts/ waymarks/ active-development/ tools/fixtures/i/index_fold_control.sh
index_row_bound tools/in/index_row_bound_witness.rish tools/fixtures/i/index_row_bound_scan.sh session-logs/README.md tools/fixtures/i/index_row_bound_control.sh
lattice_suite tools/l/lattice_suite_witness.rish lattice/ tools/l/lattice_*_witness.rish [build]
log_has_a_row tools/l/log_has_a_row_witness.rish tools/fixtures/l/log_has_a_row_scan.sh session-logs/ tools/fixtures/l/log_has_a_row_control.sh
loop_prompt_parse tools/l/loop_prompt_parse_witness.rish tools/fixtures/l/loop_prompt_parse_scan.sh recursion-prompts/ tools/l/launch-claude-chapter.rish tools/fixtures/l/loop_prompt_parse_control.sh
lotus_module_roster tools/l/lotus_module_roster_witness.rish tools/fixtures/m/module_roster_scan.sh lotus/
mycelium_map_roster tools/m/mycelium_map_roster_witness.rish tools/fixtures/m/mycelium_map_roster_scan.sh mycelium/ tools/fixtures/m/mycelium_map_roster_control.sh
pond_display_gate tools/p/pond_display_gate_witness.rish tools/fixtures/p/pond_display_gate_control.sh tools/fixtures/p/pond_build_drawn_terminal.rish pond/ [build]
pond_enclosure_policy tools/p/pond_enclosure_policy_witness.rish tools/fixtures/p/pond_enclosure_policy_scan.sh pond/ [build]
pond_policy_launcher tools/p/pond_policy_launcher_witness.rish tools/fixtures/p/ pond/enclosure_policy.kyri tools/ag/agent-jail.sh
pond_enclosure_built tools/p/pond_enclosure_built_witness.rish tools/fixtures/p/ pond/ tools/ag/agent-jail.sh
pond_enclosure_state tools/p/pond_enclosure_state_witness.rish tools/fixtures/p/pond_enclosure_state_scan.sh tools/ag/agent-jail.sh tools/e/enclosure.conf* tools/fixtures/p/pond_enclosure_state_control.sh
prose_register tools/p/prose_register_witness.rish tools/fixtures/p/prose_register_scan.sh docs-geode/ manual/ docs-geode/edu/yonder/ CONTRIBUTING.md SOURCE.md ORGANIZING.md MAP.md tools/fixtures/p/prose_register_control.sh README.md docs/README.md foundations/README.md caravan/README.md mycelium/README.md image/README.md lotus/README.md crypto/README.md constel/README.md
radiant_negation tools/r/radiant_negation_witness.rish tools/fixtures/r/radiant_negation_scan.sh foundations/ context/RADIANT_STYLE.md context/TWILIGHT_STYLE.md context/KYRI.md
reds_fold tools/r/reds_fold_witness.rish tools/fixtures/r/reds_fold.sh tools/fixtures/r/reds_fold_control.sh tools/fixtures/r/reds_fold_reanchor.sh construction/
reds_ledger_headline tools/r/reds_ledger_headline_witness.rish construction/REDS.md construction/archive/REDS-* tools/fixtures/r/reds_ledger_headline_control.sh
reds_ledger_monotone tools/gen/chapter/reds_ledger_monotone_witness.rish tools/fixtures/r/reds_ledger_monotone_scan.sh construction/REDS.md construction/archive/REDS-*
reds_pin_capacity tools/r/reds_pin_capacity_witness.rish tools/fixtures/r/reds_pin_capacity_scan.sh tools/fixtures/r/reds_pin_capacity_rows.awk tools/fixtures/r/reds_pin_capacity_control.sh tools/fixtures/l/living_pin_max_bytes.sh construction/
reds_row_present tools/r/reds_row_present_witness.rish tools/fixtures/r/reds_row_present.sh tools/fixtures/r/reds_spine_grep.sh construction/ tools/fixtures/r/reds_row_present_control.sh
reds_status_consistency tools/r/reds_status_consistency_witness.rish tools/fixtures/r/reds_status_consistency_scan.sh tools/fixtures/r/reds_status_consistency_control.sh tools/fixtures/r/reds_spine_files.sh construction/
rish_join_split tools/r/rish_join_split_witness.rish rishi/ tools/p/pleac_strings_witness.rish [build]
rishi_bare_path tools/r/rishi_bare_path_witness.rish tools/fixtures/r/rishi_bare_path_control.sh rishi/ [build]
rule_twin tools/r/rule_twin_witness.rish tools/fixtures/r/rule_twin_scan.sh .claude/rules/ .cursor/rules/ tools/fixtures/r/rule_twin_control.sh
rye_bridge_cycle tools/r/rye_bridge_cycle_witness.rish tools/fixtures/r/rye_bridge_cycle_control.sh rye/ [build]
ryekey tools/r/ryekey_witness.rish tools/fixtures/r/ryekey_control.sh rye/ [build]
sha3_file tools/s/sha3_file_witness.rish tools/fixtures/s/sha3_file_control.sh crypto/ tools/rye/ [build]
skate_macos_choice tools/s/skate_macos_choice_witness.rish tools/fixtures/s/skate_macos_choice_scan.sh skate/ tools/fixtures/s/skate_macos_choice_control.sh
sow_lock tools/s/sow_lock_witness.rish tools/fixtures/s/sow_lock_control.sh tools/fixtures/s/sow_project.sh
tally_bud tools/t/tally_bud_witness.rish tally/ [build]
tally_roster tools/t/tally_roster_witness.rish tools/fixtures/t/tally_roster_scan.sh tally/ tools/t/tally_*
tame_style_check tools/t/tame_style_check.rish tools/t/tame_style_scan_bans.rish tools/t/tame_style_scan_advise.rish mantra/ caravan/ linengrow/ comlink/ rishi/src/ tally/ aurora/ pond/ brushstroke/ image/ mikrophone/ rye/src/ amphora/ glow/ mycelium/ constel/ lattice/ ember/ lantern/ scribble/
wire_lab_fn_drift tools/w/wire_lab_fn_drift_witness.rish tools/fixtures/w/wire_lab_fn_drift_scan.sh tools/fixtures/w/wire_lab_fn_drift_control.sh tools/co/comlink_*_wire_lab.rish
MAP
