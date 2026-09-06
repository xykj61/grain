#!/bin/sh
# tools/fixtures/r/rye_harness_roster_control.sh -- the harness-roster guard, proven from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. This pen builds
# real directories holding real .rye files and a real harness script, plants one fault at a time,
# and asks tools/fixtures/r/rye_harness_roster_scan.sh what it reads -- so every gate is shown
# biting and every honest shape is shown passing free.
#
# The case that carries the rule is file_unlisted. A .rye program added to a harness's directory
# and left out of its list is never run, and the suite it belongs to still reports GREEN, because
# the suite asserts over the list it holds rather than over the directory it names. That failure is
# open, silent, and looks exactly like success -- so it is planted here, counted, refused, and named.
#
# Each case prints one line naming what was planted and whether it was bitten or left free. The
# tally at the end is what the witness asserts on.
#
# Run from the repository root:  sh tools/fixtures/r/rye_harness_roster_control.sh
set -eu

SCAN=tools/fixtures/r/rye_harness_roster_scan.sh
PORTABLE=tools/fixtures/s/shell_portable.sh
[ -f "$SCAN" ] || { echo "control: no scan at $SCAN"; exit 2; }
[ -f "$PORTABLE" ] || { echo "control: no portable helper at $PORTABLE"; exit 2; }
SCAN_ABS=$(CDPATH= cd -- "$(dirname "$SCAN")" && pwd)/$(basename "$SCAN")
PORTABLE_ABS=$(CDPATH= cd -- "$(dirname "$PORTABLE")" && pwd)/$(basename "$PORTABLE")

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM
n=0
fail=0

# pen <name> -- a tree root the scan's upward walk will accept: rishi/bin and tools/fixtures.
pen() {
  d="$PEN/$1"
  rm -rf "$d"
  mkdir -p "$d/rishi/bin" "$d/tools/fixtures/r" "$d/tools/fixtures/s"
  cp "$SCAN_ABS" "$d/tools/fixtures/r/rye_harness_roster_scan.sh"
  cp "$PORTABLE_ABS" "$d/tools/fixtures/s/shell_portable.sh"
  echo "$d"
}

# programs <pen> <dir> <stems...> -- real .rye files on disk.
programs() {
  d="$1/$2"; shift 2
  mkdir -p "$d"
  for m in "$@"; do printf '//! %s.rye -- a pen program\nconst std = @import("std");\n' "$m" > "$d/$m.rye"; done
}

# harness <pen> <dir> <stems...> -- a Rishi harness naming its directory and its stem list.
harness() {
  p="$1"; dir="$2"; shift 2
  list=""
  for m in "$@"; do list="$list \"$m\""; done
  mkdir -p "$p/tools/p"
  {
    echo '# a pen harness -- assembles its paths from a directory and a stem list'
    echo "let rye = \"rye/bin/rye\""
    echo "let dir = \"$dir\""
    echo "let witnesses = [$list ]"
    echo 'let runs = map witnesses as s: run ["env" rye "run" "${dir}/${s}.rye"]'
  } > "$p/tools/p/pen_harness.rish"
}

# check <label> <pen> <ok|red> <key=value that must appear> [--list]
check() {
  n=$((n + 1))
  label="$1"; p="$2"; want="$3"; key="$4"; extra="${5:-}"
  out=$( (cd "$p" && sh tools/fixtures/r/rye_harness_roster_scan.sh $extra) 2>&1 ) && code=0 || code=$?
  bad=0
  if [ "$want" = ok ]; then [ "$code" -eq 0 ] || bad=1; else [ "$code" -ne 0 ] || bad=1; fi
  case "$out" in *"$key"*) ;; *) bad=1 ;; esac
  if [ "$bad" -eq 0 ]; then
    if [ "$want" = ok ]; then echo "$n free: $label"; else echo "$n bitten: $label"; fi
  else
    fail=$((fail + 1))
    echo "$n MISREAD: $label -- wanted $want with $key, read code=$code"
    echo "$out" | sed 's/^/      /'
  fi
}

# --- the agreeing tree, which must pass free AND read zero ------------------------------------
p=$(pen agree); programs "$p" rye/tests a_test b_test; harness "$p" rye/tests a_test b_test
check "an agreeing harness passes free"                  "$p" ok  "verdict=ok"
check "and reads zero rather than merely passing"        "$p" ok  "stems_absent=0"
check "with no unlisted file either"                     "$p" ok  "files_unlisted=0"
check "the harness is found, so the reading is not empty" "$p" ok  "harnesses=1"
check "and its units are counted off the list"           "$p" ok  "harness_units=2"

# --- a stem naming nothing: the harness claims a program that is not there ---------------------
p=$(pen absent); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test b_test
check "a stem naming no file is counted"                 "$p" red "stems_absent=1"
check "a stem naming no file is refused"                 "$p" red "verdict=roster_disagrees"
check "and the refusal names the path"                   "$p" red "stem_absent: tools/p/pen_harness.rish names rye/tests/b_test.rye" --list

# --- the silent one: a program on disk that no stem names -------------------------------------
p=$(pen unlisted); programs "$p" rye/tests a_test b_test c_test; harness "$p" rye/tests a_test b_test
check "a program no stem names is counted"               "$p" red "files_unlisted=1"
check "a program no stem names is refused"               "$p" red "verdict=roster_disagrees"
check "and the refusal names the file nobody runs"       "$p" red "file_unlisted: rye/tests/c_test.rye" --list

# --- a seam symlink is a program ---------------------------------------------------------------
p=$(pen link); programs "$p" rye/tests a_test; programs "$p" other shared
(cd "$p/rye/tests" && ln -s ../../other/shared.rye shared.rye)
harness "$p" rye/tests a_test shared
check "a symlinked program listed by its stem passes free" "$p" ok  "verdict=ok"
p=$(pen link_unlisted); programs "$p" rye/tests a_test; programs "$p" other shared
(cd "$p/rye/tests" && ln -s ../../other/shared.rye shared.rye)
harness "$p" rye/tests a_test
check "a symlinked program no stem names is refused"     "$p" red "files_unlisted=1"

# --- an empty corpus must refuse rather than read clean ---------------------------------------
p=$(pen empty); programs "$p" rye/tests a_test
check "a tree holding no harness refuses"                "$p" red "verdict=empty_corpus"

# --- the build-site census ---------------------------------------------------------------------
p=$(pen sites); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/x"
printf '#!/bin/sh\nrye/bin/rye build encoding/hex.rye\n' > "$p/tools/x/literal.sh"
check "a literal build target is read as literal"        "$p" ok  "sites_literal=1"
printf '#!/bin/sh\nrye/bin/rye build \\\n  encoding/pem.rye -lc\n' > "$p/tools/x/joined.sh"
check "a target on a continuation line is still read"    "$p" ok  "sites_literal=2"
printf '#!/bin/sh\necho "rye build failed for RW-2"\n' > "$p/tools/x/prose.sh"
check "prose after the driver name is not a literal site" "$p" ok "sites_literal=2"
check "and the residue is published rather than dropped" "$p" ok  "sites_unparsed=1"

# --- the unresolved ratchet, proven from both sides --------------------------------------------
p=$(pen ceiling); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
i=1; while [ "$i" -le 10 ]; do
  printf '#!/bin/sh\n# builds "$UD%s/$um%s.rye" from parts bound at runtime\n' "$i" "$i" > "$p/tools/u/u$i.sh"
  i=$((i + 1))
done
check "ten unreadable shapes sit at the ceiling, free"   "$p" ok  "unresolved=10"
printf '#!/bin/sh\n# builds "$UD11/$um11.rye" from parts bound at runtime\n' > "$p/tools/u/u11.sh"
check "eleven refuses, so the ceiling only ever falls"   "$p" red "verdict=unresolved_over_ceiling"

echo "cases=$n"
echo "control_failures=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=misread"
exit 1
