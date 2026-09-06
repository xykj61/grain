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
# Each plant BUILDS the path it assembles, because a script that assembles one and builds nothing
# is no longer this reading's subject -- proven in its own pen further down. The ceiling stands at
# one, so one sits free and two refuse.
p=$(pen ceiling); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf '#!/bin/sh\nrye/bin/rye build "$UD1/$um1.rye"\n' > "$p/tools/u/u1.sh"
check "one unreadable shape sits at the ceiling, free"   "$p" ok  "unresolved=1"
printf '#!/bin/sh\nrye/bin/rye build "$UD2/$um2.rye"\n' > "$p/tools/u/u2.sh"
check "two refuses, so the ceiling only ever falls"      "$p" red "verdict=unresolved_over_ceiling"


# The residue NAMED, not merely counted. The consumer's credit is conditional on the assembling
# script compiling anything, and until this landed the residue beside that credit was a bare number,
# so the consumer could not tell a doubt that reaches it from one that cannot (the residue row `20260906.113130`). Three
# claims: the site is named, the two variable names ride with it so a reader can find the shape, and
# the marker says this copy names them at all.
p=$(pen residue); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf '#!/bin/sh\nrye/bin/rye build "$UD/$um.rye"\n' > "$p/tools/u/compiles.sh"
check "--paths names the site it could not read"         "$p" ok  "harness_unresolved tools/u/compiles.sh UD um" --paths
check "  ... and counts it too"                          "$p" ok  "unresolved=1" --paths
check "  ... and marks that this copy names them"        "$p" ok  "unresolved_named=1" --paths

# The marker rides even when there is nothing to name, which is the whole of its job: zero named
# sites beside zero counted is a tree with no residue, and zero named beside ten counted is a copy
# too old to name them. Without the marker those two read identically, and only one is a fault.
p=$(pen residue_none); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
check "the marker rides on a tree with no residue at all" "$p" ok "unresolved_named=1" --paths
check "  ... beside a residue of zero"                   "$p" ok "unresolved=0" --paths
# --- --paths, the answer a consumer reads ------------------------------------------------------
# The compile-reach census asks this scan for the paths a harness assembles, because those paths are
# written nowhere and a census reading for filenames called all of them unbuilt (REDS %466). Two
# claims are proven here: that the answer names the real path a stem stands for, and that it carries
# the marker a consumer separates "no harness here" from "this copy cannot answer" by.
p=$(pen paths); programs "$p" rye/tests a_test b_test; harness "$p" rye/tests a_test b_test
check "--paths spells the path a stem stands for"        "$p" ok  "harness_path tools/p/pen_harness.rish rye/tests/a_test.rye" --paths
check "  ... every stem, not the first"                  "$p" ok  "harness_path tools/p/pen_harness.rish rye/tests/b_test.rye" --paths
check "  ... counted"                                    "$p" ok  "harness_units=2" --paths
check "  ... and marked, so a silent answer is not read as an empty tree" "$p" ok "paths_mode=1" --paths

# An empty tree still carries the marker before it refuses, so a consumer reads "none here" as the
# lawful answer it is rather than as a broken instrument. Both halves are asserted: the refusal, and
# the marker riding ahead of it.
p=$(pen paths_empty); programs "$p" rye/tests a_test
check "--paths on a harnessless tree refuses"            "$p" red "verdict=empty_corpus" --paths
check "  ... yet still marks its answer"                 "$p" red "paths_mode=1" --paths

# An unknown flag refuses rather than falling back to count mode, since a flag read past is a
# question read as answered -- the exact silence the marker above exists to prevent.
check "an unknown flag refuses by name"                  "$p" red "verdict=bad_argument" --nope

# --- A HARNESS BUILDS: the narrowing, proven by changing ONE line and nothing else -------------
# The two pens below hold the same script under the same name in the same place, differing only in
# whether the assembled path is handed to the rye driver. Anything else varying between them would
# leave the reading attributable to the difference rather than to the rule.
p=$(pen builds_nothing); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf '#!/bin/sh\n# a census: subject=$(resolve "$d/$m.rye")\nprintf %%s "$d/$m.rye"\n' > "$p/tools/u/census.sh"
check "a script that assembles and builds nothing is not unresolved" "$p" ok "unresolved=0"
check "  ... it is counted in the open instead"          "$p" ok  "assemblers_not_harnesses=1"
check "  ... and named, so the decline can be questioned" "$p" ok \
      "not_a_harness: tools/u/census.sh assembles a .rye path and hands none to the rye driver" --list

p=$(pen builds_it); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf '#!/bin/sh\nrye/bin/rye build "$d/$m.rye"\n' > "$p/tools/u/census.sh"
check "the same shape handed to the driver IS unresolved" "$p" ok  "unresolved=1"
check "  ... and is no longer counted as a non-harness"  "$p" ok  "assemblers_not_harnesses=0"

# --- both spellings: a Rishi build is a build --------------------------------------------------
# Shell writes `rye/bin/rye build x.rye`; Rishi writes `run ["env" rye "build" "x.rye"]`. The elder
# program stripped quotes from the driver token and not from the verb, so it read the first and
# walked past the second -- and the pen harness above is spelled the Rishi way, which is how the
# blind spot surfaced at all.
p=$(pen rishi_build); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf 'let rye = "rye/bin/rye"\nlet r = run ["env" rye "build" "rye/tests/a_test.rye"]\n' > "$p/tools/u/pen_rishi.rish"
check "a Rishi-spelled build is read as a build site"    "$p" ok  "sites_literal=1"

# --- the three site classes are disjoint -------------------------------------------------------
# One build site whose target is BOTH assembled and .rye-suffixed. Counted independently it lands in
# two classes and the leftover goes negative; counted in order it lands in one and the three add up.
p=$(pen disjoint); programs "$p" rye/tests a_test; harness "$p" rye/tests a_test
mkdir -p "$p/tools/u"
printf '#!/bin/sh\nrye/bin/rye build "$d/$m.rye"\n' > "$p/tools/u/one.sh"
# Two assembled sites, since the pen harness itself assembles one -- named here so the number is
# read rather than guessed at.
check "an assembled .rye target is counted as assembled" "$p" ok  "sites_assembled=2"
check "  ... and not a second time as literal"           "$p" ok  "sites_literal=0"
check "  ... so the residue stands at zero, never below" "$p" ok  "sites_unparsed=0"

echo "cases=$n"
echo "control_failures=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=misread"
exit 1
