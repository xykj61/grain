#!/bin/sh
# shared_bound_control.sh -- prove the shared-bound census refuses and welcomes on real trees.
#
#   sh tools/fixtures/s/shared_bound_control.sh
#
# Every leg builds a real git repository in a throwaway pen holding the scan at its own relative
# path, because the scan resolves its root from its own location and would otherwise read the tree
# it was copied out of. Each refusal is planted and then lifted, so a counter is seen at more than
# one value -- a counter only ever seen at one value cannot be told from a constant.
set -u

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
scan_src="$root/tools/fixtures/s/shared_bound_scan.sh"
[ -f "$scan_src" ] || {
  echo "shared_bound_control: REFUSED -- the scan is absent at $scan_src" >&2; exit 2; }

pen=$(mktemp -d) || { echo "shared_bound_control: REFUSED -- no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
check() {
  if [ "$3" = "$2" ]; then pass=$((pass + 1)); else
    fail=$((fail + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}
field() { printf '%s\n' "$2" | sed -n "s|^$1=||p"; }

# -- the pen: the scan three directories down, exactly as it sits in the tree ---------------------
mkdir -p "$pen/tools/fixtures/s" "$pen/glow"
cp "$scan_src" "$pen/tools/fixtures/s/shared_bound_scan.sh"
cd "$pen" || exit 2
git init -q .
git config user.email pen@example.invalid
git config user.name pen

run_scan() { sh tools/fixtures/s/shared_bound_scan.sh "$@" 2>&1; }
stage() { git add -A >/dev/null 2>&1; }

# -- leg 1: two modules publishing one name at one value read as an agreement --------------------
printf 'pub const max_name_len: u32 = 64;\n' > glow/a.rye
printf 'pub const max_name_len: u32 = 64;\n' > glow/b.rye
stage
out=$(run_scan)
check agree_verdict ok "$(field verdict "$out")"
check agree_shared 1 "$(field shared_names "$out")"
check agree_divergent 0 "$(field divergent_names "$out")"
check agree_decls 2 "$(field declarations "$out")"

# -- leg 2: the same name at two values reds, and the counter rises ------------------------------
printf 'pub const max_name_len: u32 = 48;\n' > glow/b.rye
stage
out=$(run_scan)
check diverge_verdict divergent "$(field verdict "$out")"
check diverge_count 1 "$(field divergent_names "$out")"

# -- leg 3: lifting the plant returns the counter to zero ----------------------------------------
printf 'pub const max_name_len: u32 = 64;\n' > glow/b.rye
stage
out=$(run_scan)
check lifted_verdict ok "$(field verdict "$out")"
check lifted_count 0 "$(field divergent_names "$out")"

# -- leg 4: a break in the THIRD module is caught, not only in the second -------------------------
printf 'pub const max_name_len: u32 = 96;\n' > glow/c.rye
stage
out=$(run_scan)
check third_verdict divergent "$(field verdict "$out")"
check third_count 1 "$(field divergent_names "$out")"
rm -f glow/c.rye

# -- leg 5: one declaration is not a shared name --------------------------------------------------
printf 'pub const max_lonely_len: u32 = 12;\n' > glow/b.rye
stage
out=$(run_scan)
check single_shared 0 "$(field shared_names "$out")"
check single_verdict ok "$(field verdict "$out")"

# -- leg 6: a file-private constant is invisible, however it disagrees ----------------------------
# invariant: only a published name reaches another module, so a private one cannot drift a seam.
printf 'const max_name_len: u32 = 48;\n' > glow/b.rye
stage
out=$(run_scan)
check private_shared 0 "$(field shared_names "$out")"
check private_decls 1 "$(field declarations "$out")"

# -- leg 7: an indented declaration belongs to its own scope ---------------------------------------
printf 'pub const Holder = struct {\n    pub const max_name_len: u32 = 48;\n};\n' > glow/b.rye
stage
out=$(run_scan)
check indented_shared 0 "$(field shared_names "$out")"
check indented_decls 1 "$(field declarations "$out")"

# -- leg 8: a non-numeric published constant is not a bound ----------------------------------------
printf 'pub const max_name_len: u32 = some_other_name;\n' > glow/b.rye
stage
out=$(run_scan)
check nonnumeric_decls 1 "$(field declarations "$out")"

# -- leg 9: a comment naming the constant is a mention rather than a promise ------------------------
printf '/// max_name_len: u32 = 48 -- prose about the other module.\n' > glow/b.rye
stage
out=$(run_scan)
check comment_decls 1 "$(field declarations "$out")"
check comment_shared 0 "$(field shared_names "$out")"

# -- leg 10: a path git has never seen is not read, and staging it brings it in ----------------------
# invariant: the scan lists TRACKED paths and reads their working-tree bytes, so it sees an edit
# before it is staged. That is the direction a round-open guard wants -- it reads the tree a lap
# stands on rather than the tree a lap last committed.
rm -f glow/b.rye
stage
printf 'pub const max_name_len: u32 = 48;\n' > glow/untracked.rye
out=$(run_scan)
check untracked_shared 0 "$(field shared_names "$out")"
stage
out=$(run_scan)
check tracked_shared 1 "$(field shared_names "$out")"
check tracked_divergent 1 "$(field divergent_names "$out")"
git rm -q --cached glow/untracked.rye
rm -f glow/untracked.rye
printf 'pub const max_name_len: u32 = 64;\n' > glow/b.rye
stage

# -- leg 11: spacing leaves the value, so one expression spelled two ways agrees ---------------------
printf 'pub const max_src_len: u32 = 64 * 1024;\n' > glow/a.rye
printf 'pub const max_src_len: u32 = 64*1024;\n' > glow/b.rye
stage
out=$(run_scan)
check spacing_verdict ok "$(field verdict "$out")"
check spacing_shared 1 "$(field shared_names "$out")"

# -- leg 12: the honest limit, proven rather than merely written down --------------------------------
# invariant: the scan compares written expressions, so one number spelled two ways reads DIVERGENT.
# The leg exists so the header's admission is a measurement instead of a claim.
printf 'pub const max_src_len: u32 = 65536;\n' > glow/b.rye
stage
out=$(run_scan)
check spelling_limit divergent "$(field verdict "$out")"

# -- leg 13: --names prints the group, and its absence keeps the census quiet ------------------------
check names_absent no "$(case "$(run_scan)" in *"name "*) echo yes ;; *) echo no ;; esac)"
check names_present yes "$(case "$(run_scan --names)" in *DIVERGENT*) echo yes ;; *) echo no ;; esac)"

# -- leg 14: a declaration count past the bound refuses rather than truncating -----------------------
rm -f glow/a.rye glow/b.rye
i=0
: > glow/many.rye
while [ "$i" -lt 1025 ]; do printf 'pub const bound_%s: u32 = 1;\n' "$i" >> glow/many.rye; i=$((i + 1)); done
stage
run_scan >/dev/null 2>&1
check decl_bound_refuses 2 "$?"
printf 'pub const max_name_len: u32 = 64;\n' > glow/many.rye
stage
run_scan >/dev/null 2>&1
check decl_bound_lifted 0 "$?"

# -- leg 15: a room with no tracked sources refuses rather than reading zero as clean ----------------
git rm -q --cached glow/many.rye
rm -f glow/many.rye
run_scan >/dev/null 2>&1
check empty_room_refuses 2 "$?"

# -- leg 16: a tracked room publishing NO bound refuses rather than reading zero as clean -----------
# invariant: zero declarations and a clean tree print the same three counters, so the instrument
# refuses instead of reporting. This is the leg the witness's specimen-named canary used to stand in
# for, and it belongs here, where a plant can be lifted.
printf '// prose only, and no published bound in sight\n' > glow/quiet.rye
stage
run_scan >/dev/null 2>&1
check no_decls_refuses 2 "$?"
printf 'pub const max_name_len: u32 = 64;\n' >> glow/quiet.rye
stage
run_scan >/dev/null 2>&1
check no_decls_lifted 0 "$?"
# -- leg 17: the room is a parameter, and the named room is the room that answers -------------------
# invariant: the elder legs above pass no --room and therefore read the default, so the default is
# asserted here rather than assumed. A default that drifted would move every leg above it silently.
# leg 15 left glow with no tracked source, so the room is restored before the default is read.
printf 'pub const max_name_len: u32 = 64;\n' > glow/a.rye
printf 'pub const max_name_len: u32 = 64;\n' > glow/b.rye
mkdir -p mantra
printf 'pub const max_resin_bytes: u32 = 512;\n' > mantra/a.rye
printf 'pub const max_resin_bytes: u32 = 512;\n' > mantra/b.rye
stage
check default_room glow "$(field room_read "$(run_scan)")"
out=$(run_scan --room mantra)
check named_room mantra "$(field room_read "$out")"
check named_room_shared 1 "$(field shared_names "$out")"
check named_room_verdict ok "$(field verdict "$out")"

# -- leg 18: a divergence in one room leaves another room green ------------------------------------
# invariant: the wall is per room, so a break in mantra must not red glow and the reverse. This is
# the whole reason the roster carries a witness per room rather than one sweep.
printf 'pub const max_resin_bytes: u32 = 1024;\n' > mantra/b.rye
stage
check split_mantra divergent "$(field verdict "$(run_scan --room mantra)")"
check split_glow ok "$(field verdict "$(run_scan --room glow)")"
printf 'pub const max_resin_bytes: u32 = 512;\n' > mantra/b.rye
stage

# -- leg 19: the room glob crosses a slash, so a nested source is read with the flat ones -----------
# invariant: a room is the unit rather than a directory. mantra/src/ holds the weave and the store,
# and a reading blind to them would call the room clean while its deepest bounds drifted.
mkdir -p mantra/src
printf 'pub const max_resin_bytes: u32 = 999;\n' > mantra/src/deep.rye
stage
check nested_seen divergent "$(field verdict "$(run_scan --room mantra)")"
printf 'pub const max_resin_bytes: u32 = 512;\n' > mantra/src/deep.rye
stage
check nested_lifted ok "$(field verdict "$(run_scan --room mantra)")"

# -- leg 20: a room the tree has never tracked refuses rather than reading zero as clean ------------
run_scan --room nosuchroom >/dev/null 2>&1
check absent_room_refuses 2 "$?"

# -- leg 21: an unknown argument refuses, and --room with no value refuses --------------------------
# invariant: a flag misspelled at a call site must never be read past in silence, because a scan
# that ignores an argument answers for a room nobody asked about.
run_scan --bogus >/dev/null 2>&1
check unknown_arg_refuses 2 "$?"
run_scan --room >/dev/null 2>&1
check room_without_value_refuses 2 "$?"

# -- leg 22: --all censuses every room and prints NO verdict ----------------------------------------
# invariant: a census is a reading rather than a gate, and `verdict=` is the word a witness reaches
# for. Withholding it is what keeps a reported number from being mistaken for a walled one.
printf 'pub const max_resin_bytes: u32 = 1024;\n' > mantra/b.rye
stage
out=$(run_scan --all)
check all_no_verdict "" "$(field verdict "$out")"
check all_rooms_sharing 2 "$(field rooms_sharing "$out")"
check all_holds 1 "$(field rooms_premise_holds "$out")"
check all_fails 1 "$(field rooms_premise_fails "$out")"
check all_names_room yes "$(case "$out" in *"room mantra shared_names=1 divergent_names=1"*) echo yes ;; *) echo no ;; esac)"
printf 'pub const max_resin_bytes: u32 = 512;\n' > mantra/b.rye
stage
out=$(run_scan --all)
check all_holds_lifted 2 "$(field rooms_premise_holds "$out")"
check all_fails_lifted 0 "$(field rooms_premise_fails "$out")"

# -- leg 23: a room sharing no name is absent from the census's own room lines ----------------------
# invariant: rooms_sharing counts rooms that share a name, so a room publishing one bound apiece is
# read and then passed over. A census printing every room would bury the seventeen that matter.
mkdir -p tally
printf 'pub const max_pen: u32 = 8;\n' > tally/only.rye
stage
out=$(run_scan --all)
check quiet_room_read 3 "$(field rooms_read "$out")"
check quiet_room_sharing 2 "$(field rooms_sharing "$out")"
check quiet_room_absent no "$(case "$out" in *"room tally "*) echo yes ;; *) echo no ;; esac)"
git rm -q --cached tally/only.rye
rm -rf tally mantra
stage

printf 'legs_pass=%s\n' "$pass"
printf 'legs_fail=%s\n' "$fail"
[ "$fail" -eq 0 ] || exit 1
