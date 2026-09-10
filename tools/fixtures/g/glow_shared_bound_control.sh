#!/bin/sh
# glow_shared_bound_control.sh -- prove the shared-bound census refuses and welcomes on real trees.
#
#   sh tools/fixtures/g/glow_shared_bound_control.sh
#
# Every leg builds a real git repository in a throwaway pen holding the scan at its own relative
# path, because the scan resolves its root from its own location and would otherwise read the tree
# it was copied out of. Each refusal is planted and then lifted, so a counter is seen at more than
# one value -- a counter only ever seen at one value cannot be told from a constant.
set -u

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
scan_src="$root/tools/fixtures/g/glow_shared_bound_scan.sh"
[ -f "$scan_src" ] || {
  echo "glow_shared_bound_control: REFUSED -- the scan is absent at $scan_src" >&2; exit 2; }

pen=$(mktemp -d) || { echo "glow_shared_bound_control: REFUSED -- no pen" >&2; exit 2; }
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
mkdir -p "$pen/tools/fixtures/g" "$pen/glow"
cp "$scan_src" "$pen/tools/fixtures/g/glow_shared_bound_scan.sh"
cd "$pen" || exit 2
git init -q .
git config user.email pen@example.invalid
git config user.name pen

run_scan() { sh tools/fixtures/g/glow_shared_bound_scan.sh "$@" 2>&1; }
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

printf 'legs_pass=%s\n' "$pass"
printf 'legs_fail=%s\n' "$fail"
[ "$fail" -eq 0 ] || exit 1
