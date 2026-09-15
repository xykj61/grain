#!/bin/sh
# shared_build_path_control.sh -- the shared-build-path reading, shown answering every way it can.
#
#   sh tools/fixtures/s/shared_build_path_control.sh
#
# Builds real git repositories in a throwaway pen and plants each shape the scan must tell apart.
# Every refusal is planted and then LIFTED, because a refusal proven only in the failing direction
# cannot be told from an instrument that always refuses.
#
# THE MUTATION THAT CARRIES THE WEIGHT is `resolution_required`. The scan's whole reason for
# existing is that it follows `let bin = "lotus/bin/thing"` to its value; a reader that stops at the
# dollar sign calls the dominant spelling unresolved and reports a tiny count over a large hazard.
# Two hand counts did exactly that, reading 304 and then 51 where the tree holds 1,853. So the
# control breaks the resolution on purpose and asserts the count COLLAPSES.
set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
# One shell dialect on both piers: GNU `sed -i` takes no argument and BSD's REQUIRES one, so
# the mutation below would fail on the macOS clone and its leg would pass vacuously.
. "$root/tools/fixtures/s/shell_portable.sh"
scan=$root/tools/fixtures/s/shared_build_path_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
legs=0
faults=0

note() { # note <name> <want> <got>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "leg $1=ok"
  else echo "leg $1=FAULT want=$2 got=$3"; faults=$((faults + 1)); fi
}

new_pen() { # new_pen <dir>
  mkdir -p "$1/tools/fixtures/s" "$1/tools/x"
  cp "$scan" "$1/tools/fixtures/s/shared_build_path_scan.sh"
  ( cd "$1" && git init -q . && git config user.email a@b && git config user.name t )
}

read_key() { grep "^$2=" "$1" | cut -d= -f2; }

# ---- a literal path behind a Rishi binding is the shape this exists to catch
p=$pen/a; new_pen "$p"
cat > "$p/tools/x/one_witness.rish" <<'W'
let bin = "lotus/bin/thing"
let build = run ["sh" "-c" "rye build lotus/thing.rye -femit-bin=${bin}"]
W
( cd "$p" && git add -A >/dev/null 2>&1 )
( cd "$p" && sh tools/fixtures/s/shared_build_path_scan.sh > out.txt 2>/dev/null ) || :
note literal_counted 1 "$(read_key "$p/out.txt" sites_fixed_tree_path)"
note literal_file 1 "$(read_key "$p/out.txt" files_with_fixed)"

# ---- the same site penned on its own line is NOT the hazard
p=$pen/b; new_pen "$p"
cat > "$p/tools/x/two_witness.rish" <<'W'
let build = run ["sh" "-c" "d=$(mktemp -d); rye build lotus/thing.rye -femit-bin=$d/thing"]
W
( cd "$p" && git add -A >/dev/null 2>&1 )
( cd "$p" && sh tools/fixtures/s/shared_build_path_scan.sh > out.txt 2>/dev/null ) || :
note penned_not_counted 0 "$(read_key "$p/out.txt" sites_fixed_tree_path)"
note penned_counted_penned 1 "$(read_key "$p/out.txt" sites_penned)"

# ---- a shell variable this pass cannot follow is reported apart, never as clean
p=$pen/c; new_pen "$p"
cat > "$p/tools/x/three_witness.rish" <<'W'
let build = run ["sh" "-c" "rye build lotus/thing.rye -femit-bin=$OUT"]
W
( cd "$p" && git add -A >/dev/null 2>&1 )
( cd "$p" && sh tools/fixtures/s/shared_build_path_scan.sh > out.txt 2>/dev/null ) || :
note unresolved_apart 1 "$(read_key "$p/out.txt" sites_unresolved)"
note unresolved_not_fixed 0 "$(read_key "$p/out.txt" sites_fixed_tree_path)"

# ---- the ceiling, proven from BOTH sides on one pen
p=$pen/d; new_pen "$p"
i=1; while [ $i -le 3 ]; do
  printf 'let bin = "lotus/bin/t%s"\nlet b = run ["sh" "-c" "rye build x.rye -femit-bin=${bin}"]\n' "$i" \
    > "$p/tools/x/n${i}_witness.rish"
  i=$((i + 1))
done
( cd "$p" && git add -A >/dev/null 2>&1 )
( cd "$p" && SHARED_BUILD_PATH_CEILING=3 sh tools/fixtures/s/shared_build_path_scan.sh > at.txt 2>/dev/null ) || :
( cd "$p" && SHARED_BUILD_PATH_CEILING=2 sh tools/fixtures/s/shared_build_path_scan.sh > over.txt 2>/dev/null ) || :
note ceiling_at_passes ok "$(read_key "$p/at.txt" verdict)"
note ceiling_over_refuses over_ceiling "$(read_key "$p/over.txt" verdict)"
note ceiling_count 3 "$(read_key "$p/at.txt" sites_fixed_tree_path)"

# ---- an empty tree reads zero rather than refusing
p=$pen/e; new_pen "$p"
( cd "$p" && git add -A >/dev/null 2>&1 )
( cd "$p" && sh tools/fixtures/s/shared_build_path_scan.sh > out.txt 2>/dev/null ) || :
note empty_zero 0 "$(read_key "$p/out.txt" sites_fixed_tree_path)"
note empty_ok ok "$(read_key "$p/out.txt" verdict)"

# ---- THE MUTATION: break the variable resolution and watch the count collapse
p=$pen/f; new_pen "$p"
cat > "$p/tools/x/one_witness.rish" <<'W'
let bin = "lotus/bin/thing"
let build = run ["sh" "-c" "rye build lotus/thing.rye -femit-bin=${bin}"]
W
( cd "$p" && git add -A >/dev/null 2>&1 )
sed_inplace 's/if (k in val) resolved = val\[k\]/if (0) resolved = val[k]/' "$p/tools/fixtures/s/shared_build_path_scan.sh"
( cd "$p" && sh tools/fixtures/s/shared_build_path_scan.sh > out.txt 2>/dev/null ) || :
note resolution_required 0 "$(read_key "$p/out.txt" sites_fixed_tree_path)"

echo "legs=$legs"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=fault"; fi
