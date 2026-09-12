#!/bin/sh
# tools/fixtures/r/rye_module_door_scan.sh -- every authored Rye module opens at its door.
# Gated by tools/r/rye_module_door_witness.rish. Proven by tools/fixtures/r/rye_module_door_control.sh.
#
# WHY THIS EXISTS. Gauge sets the dial by reader, and it runs through the code: METER beside a
# bound, where the comment says why the number is that number, and DOOR at the head of a module,
# where somebody arriving cold deserves a plain sentence about what the thing is for
# (`.claude/rules/gauge-style.md`). Zig, and Rye after it, writes that setting into the grammar:
# `//!` is a module-level doc comment the compiler accepts only at the top of a file, so the door
# is a position the language itself reserves rather than a habit a reader has to infer.
#
# `tools/fixtures/c/comment_dial_scan.sh` has counted the form since `20260824` and gates nothing,
# by its own header's deliberate choice -- it was built to answer one question about the dial's
# distribution and it says a measurement is finished when its question is answered. So the reading
# stands and no lap meets it. Measured `20260912.035749` over 1,973 tracked authored modules:
# 1,963 open with `//!`, nine open with an ordinary `//` block, and one opens with code.
#
# THE NINE WERE NOT DOORLESS, WHICH IS THE FINDING. Eight of the nine carry real Door prose --
# `comlink/query_wire_retention_cost.rye` opens with a WHY paragraph naming the design question it
# settles, `linengrow/retting_timer.rye` names its two commands and its append-only log -- written
# in the form the compiler does not reserve. So a reader met a door and every tool read a wall.
# The tenth, `rye/tests/version_test.rye`, carried its prose INSIDE `main`, where the sentence
# explains the statement below it and answers nobody arriving at the file.
#
# WHAT THIS GATES. `silent` is held at ZERO -- a wall rather than a ratchet -- for the reason the
# two-rooms doorway guard gave when its two halves came apart: nothing structural holds a living
# module's head silent, so a floor above zero would be slack rather than a fact. The repair is one
# character on an existing line for the common shape.
#
# WHAT IS EXEMPT, each by a named reason rather than by convenience:
#
#   TESTIMONY. A module whose own basename carries a one-clock stamp is dated testimony, and
#   accrete-never-break keeps every word it wrote (`.claude/rules/stamp-and-name.md`). The
#   two-rooms doorway guard draws its living and dated halves on this same line.
#
#   PEN FIXTURE. A module under a `fixtures/` path is a planted control, and a control must be
#   free to carry the fault it plants -- the ASCII document family reads `fixtures/` past for
#   exactly this reason, since its own mojibake control must keep its high bytes.
#
# Both exempt classes are COUNTED and printed, so a roster that quietly widened one of them shows
# the widening as a number rather than as a cleaner tree.
#
# THE REACH FLOOR. A gate held at zero cannot tell a clean collection from a dead instrument, since
# both answer zero (REDS %416). So the population must clear a floor, and each exempt class must
# stand at one or more: a roster narrowed to nothing, or an exemption that stopped matching, refuses
# here rather than reporting a tree with no silent door in it.
#
# WHAT IT DOES NOT READ. Whether the sentence behind the door is any good. A `//!` line restating
# the filename counts here exactly like a paragraph that welcomes a stranger; the position is
# checkable and the welcome stays a reader's judgment. `sh tools/fixtures/q/qa_report_card.sh` is
# what grades the prose.
#
# USAGE
#   sh tools/fixtures/r/rye_module_door_scan.sh          # the tree reading
#   sh tools/fixtures/r/rye_module_door_scan.sh names    # one line per silent module
#
# Root override for the pen: RYE_DOOR_ROOT=<dir>. Floors: RYE_DOOR_MIN_MODULES, RYE_DOOR_CEILING.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu

# `xargs_lines` runs a command over a newline-delimited path list in a spelling GNU and BSD
# userland both accept. It is sourced from the tree's own helper when this script stands inside a
# tree, found by an upward walk from `$0` bounded at 8 steps rather than by fixed `../..` depth
# arithmetic, which is what breaks when a room folds.
#
# THE FALLBACK IS FOR THE PEN. This scan's own control drives MUTATED COPIES of it, written into a
# throwaway directory outside any tree, and a copy that cannot find the helper exits before it
# reads a line -- which reads exactly like a mutation that did not bite. So the helper is defined
# locally when the walk finds no tree, and `helper=` says which branch ran, because a fallback
# nobody can see is a fallback nobody can tell from the real thing.
_rd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_rd_steps=0
while [ ! -d "$_rd_root/tools/fixtures/s" ]; do
  _rd_steps=$((_rd_steps + 1))
  if [ "$_rd_steps" -gt 8 ] || [ "$_rd_root" = "/" ] || [ -z "$_rd_root" ]; then
    _rd_root=""
    break
  fi
  _rd_root=$(dirname "$_rd_root")
done
if [ -n "$_rd_root" ] && [ -f "$_rd_root/tools/fixtures/s/shell_portable.sh" ]; then
  . "$_rd_root/tools/fixtures/s/shell_portable.sh"
  helper=tree
else
  xargs_lines() {
    _sp_list=$1
    shift
    [ -s "$_sp_list" ] || return 0
    tr '\n' '\0' < "$_sp_list" | xargs -0 "$@"
  }
  helper=local
fi

mode=${1:-tree}
root=${RYE_DOOR_ROOT:-.}
ceiling=${RYE_DOOR_CEILING:-0}
min_modules=${RYE_DOOR_MIN_MODULES:-500}

if ! ( cd "$root" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1 ); then
  echo "modules=0"
  echo "verdict=no_git"
  echo "detail: the corpus is the tracked listing, so without git this reading declines rather than calling every module clean"
  exit 2
fi

pen=$(mktemp -d) || { echo "modules=0"; echo "verdict=no_scratch"; echo "detail: the scratch this reading is assembled in could not be made"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# The corpus is the tracked listing rather than a walk: a walk reads whatever stands on this disk,
# including a worktree parked under an ignored room, and that is the class `ignored_walk` reads.
if ! ( cd "$root" && git ls-files -- '*.rye' ) > "$pen/all.txt"; then
  echo "modules=0"
  echo "verdict=listing_refused"
  echo "detail: the tracked listing refused, and a broken instrument reads exactly like a clean tree"
  exit 2
fi

# Somebody else's dial. Vendored and read-only libraries are held unmodified by the gratitude
# discipline, and `old/` is a snapshot.
grep -vE '^(vendor|gratitude|old)/' "$pen/all.txt" > "$pen/corpus.txt" || true

# A path carrying whitespace is refused by name rather than read short: every loop below splits on
# newlines, and a name that opens nothing would shrink the reading in silence.
spaced=$(grep -c '[[:space:]]' "$pen/corpus.txt" || true)
if [ "${spaced:-0}" -gt 0 ]; then
  grep '[[:space:]]' "$pen/corpus.txt" | while IFS= read -r sp; do echo "detail: spaced-path $sp"; done
  echo "modules=0"
  echo "verdict=spaced_path"
  echo "detail: ${spaced} tracked module paths carry whitespace, and this reading refuses rather than counting short"
  exit 2
fi

modules=$(wc -l < "$pen/corpus.txt" | tr -d ' ')

# A module under a `fixtures/` path is a planted control, and a control must stay free to carry the
# fault it plants. A module whose own basename carries a one-clock stamp -- YYYYMMDD-HHMMSS, the
# sprig optional (REDS %175) -- is dated testimony, which accrete-never-break keeps as written.
STAMP_RE='(^|/)[0-9]{8}-[0-9]{6}([_.]|$)'
#
# EACH RULE IS SPELLED ONCE and its complement is taken rather than written again. An inverse grep
# beside a grep is one rule in two places, and the two drift apart the first time somebody widens
# only one of them -- which this scan's own mutation caught when it was written that way.
# NO `|| true` ON A `comm` OR AN `awk`. Neither answers "nothing matched" by exiting 1 the way a
# grep does, so a non-zero status from either is an instrument that could not run -- and swallowing
# it hands the reading an empty file, which is byte-identical to a tree with no silent door in it.
# `set -eu` above refuses instead. `grep` keeps its guard, because there exit 1 IS the answer.
sort "$pen/corpus.txt" > "$pen/corpus_s.txt"
grep -E '(^|/)fixtures/' "$pen/corpus_s.txt" > "$pen/fixture.txt" || true
comm -23 "$pen/corpus_s.txt" "$pen/fixture.txt" > "$pen/rest.txt"
grep -E "$STAMP_RE" "$pen/rest.txt" > "$pen/testimony.txt" || true
comm -23 "$pen/rest.txt" "$pen/testimony.txt" > "$pen/gated.txt"

exempt_fixture=$(wc -l < "$pen/fixture.txt" | tr -d ' ')
exempt_testimony=$(wc -l < "$pen/testimony.txt" | tr -d ' ')
gated=$(wc -l < "$pen/gated.txt" | tr -d ' ')

# ONE AWK OVER THE WHOLE GATED CORPUS rather than one grep per module. A per-file process costs 27
# seconds over this tree's 1,911 gated modules and under a second in one pass, and a guard on the
# lap tier has to be affordable or it quietly becomes a cadence tier -- which is the shape this
# reading exists to refuse, since a stranger five rounds later repairs somebody else's door.
#
# The door is the FIRST NON-BLANK line. `//!` anywhere else is a different claim, and the compiler
# refuses a module doc comment below the first token anyway, so a meter reading it anywhere would
# pass a file that cannot build. `nextfile` is a GNU extension this tree walls at zero
# (`shell_dialect`), so the per-file flag does that work in POSIX awk.
# THE POSITION GATE IS ONE NAMED LINE, `seen[FILENAME] { next }`, so the control can flip it and
# watch the reading move. With it, only the first non-blank line of a module can open its door;
# without it, a `//!` anywhere in the file would count -- and the compiler refuses a module doc
# comment below the first token, so that reading would pass a file which cannot build.
#
# `nextfile` is a GNU extension this tree walls at zero (`shell_dialect`), so the per-file flag does
# that work in POSIX awk. The pass emits TWO records rather than one: `read` at the first line of
# every file it opens, and `door` where the first non-blank line carries the form. Silence is then
# the difference of two sets rather than a third printf, which is what lets the position gate be
# mutated on its own -- a mutant that also had to rewrite the silent printf would be proving the
# sed rather than the check.
: > "$pen/seen.txt"
if [ -s "$pen/gated.txt" ]; then
  ( cd "$root" && xargs_lines "$pen/gated.txt" awk '
    FNR == 1 { seen[FILENAME] = 0; printf "read\t%s\n", FILENAME }
    seen[FILENAME] { next }
    /^[ \t]*$/ { next }
    {
      seen[FILENAME] = 1
      if ($0 ~ /^\/\/!/) printf "door\t%s\n", FILENAME
    }
  ' ) > "$pen/seen.txt" || true
fi

# A module holding no line at all never reaches awk, so it is absent from the pass rather than
# clean. An unread module is neither a door nor a wall, and this refuses rather than counting it as
# one: a clean reading produced by an instrument that opened nothing is the answer everybody hopes
# for and the one nobody can act on.
awk -F'\t' '$1 == "read" { print $2 }' "$pen/seen.txt" | sort -u > "$pen/read.txt"
awk -F'\t' '$1 == "door" { print $2 }' "$pen/seen.txt" | sort -u > "$pen/door.txt"
sort "$pen/gated.txt" > "$pen/want.txt"
comm -13 "$pen/read.txt" "$pen/want.txt" > "$pen/unread.txt"
read_refused=$(wc -l < "$pen/unread.txt" | tr -d ' ')

comm -23 "$pen/read.txt" "$pen/door.txt" > "$pen/silent.txt"
silent=$(wc -l < "$pen/silent.txt" | tr -d ' ')

if [ "$mode" = "names" ]; then
  while IFS= read -r s; do [ -n "$s" ] && echo "detail: silent $s"; done < "$pen/silent.txt"
  while IFS= read -r u; do [ -n "$u" ] && echo "detail: unread $u"; done < "$pen/unread.txt"
fi

echo "helper=$helper"
echo "modules=$modules"
echo "gated_modules=$gated"
echo "exempt_testimony=$exempt_testimony"
echo "exempt_fixture=$exempt_fixture"
echo "read_refused=$read_refused"
echo "silent=$silent"
echo "ceiling=$ceiling"

if [ "$modules" -lt "$min_modules" ]; then
  echo "verdict=reach_short"
  echo "detail: $modules tracked authored modules stand against a floor of $min_modules -- a narrowed corpus reports a cleaner tree than the tree is"
  exit 1
fi
if [ "$exempt_testimony" -lt 1 ] || [ "$exempt_fixture" -lt 1 ]; then
  echo "verdict=exempt_unreached"
  echo "detail: testimony=$exempt_testimony fixture=$exempt_fixture -- an exemption that matches nothing has stopped being an exemption, and the reading below it cannot be trusted either way"
  exit 1
fi
if [ "$read_refused" -gt 0 ]; then
  echo "verdict=read_refused"
  echo "detail: $read_refused modules could not be read, and an unread module is neither a door nor a wall"
  exit 1
fi
if [ "$silent" -gt "$ceiling" ]; then
  echo "verdict=silent_door"
  echo "detail: $silent authored modules open outside the door form against a ceiling of $ceiling -- run this scan with the 'names' argument for the list"
  exit 1
fi

echo "verdict=ok"
