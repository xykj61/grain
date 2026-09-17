#!/bin/sh
# tools/fixtures/a/assert_evidence_scan.sh -- when a Rishi assertion refuses, does it print the
# command's own words, or a constant?
#
#   sh tools/fixtures/a/assert_evidence_scan.sh [--list] [--classes] [--explain <path>]
#
# THE SHAPE. Rishi's `run` returns one record, and TAME states its fields by name: `run` ->
# `{ out, err, code, ok }`, check `ok` before trusting `out`. A witness therefore refuses like this:
#
#   let build = run ["rye" "build" "lotus/pan.rye"]
#   assert build.ok else "Lattice build failed"
#
# The `err` field holds the compiler's own sentence. The message discards it, so the operator reads
# four words and the reason is gone. The healthy form is one interpolation the tree already writes:
#
#   assert build.ok else "Lattice build failed -- ${build.err_brief}"
#
# WHAT THIS COSTS, MEASURED RATHER THAN ARGUED. REDS %734 ran 239 lotus witnesses under parallel
# load and captured thirteen failures. Ten named their own reason -- `unable to load 'pan.zig'` --
# and those ten are what identified the cause: two concurrent `rye build` runs generate the same
# ephemeral `.zig` shadow names beside the source, and one clears them while the other is still
# compiling. THE OTHER THREE SAID ONLY `Lattice build failed`, and that silence is why a fortnight
# of these left nothing to read. The evidence existed in every one of the thirteen; three asserts
# threw it away.
#
# THE FOUR ANSWERS, and why they are counted apart rather than summed. Each names a different
# distance between the operator and the reason:
#
#   names_err    -- the message interpolates the asserted record's own `err` or `err_brief`. The
#                   cure, and this tree's own idiom: `err_brief` is the bounded excerpt, which is
#                   what keeps a refusal readable rather than dumping a compiler's whole output.
#   names_field  -- it interpolates that record's `out`, `out_brief`, or `code` instead. Partial:
#                   real evidence, from the wrong stream, since a tool that failed speaks on stderr.
#   names_path   -- it interpolates something that is no field of the record -- `see ${outfile}`.
#                   Honest deferral: the evidence is on disk and the message says where.
#   said_above   -- the message interpolates nothing, AND a `say` line within six lines above it
#                   already printed a field of the same record. The reason reaches the operator by
#                   another road, so counting these as silent would be false.
#   mute         -- a constant sentence, with the record's own words discarded and printed nowhere.
#
# WHY A RATCHET RATHER THAN A WALL. The repair is one interpolation per site and the sites stand in
# every lane of the fleet, so the sweep's timing belongs to the fleet rather than to one ship --
# the same reasoning REDS %788 wrote for a sweep of one word across 164 files. A wall at zero would
# red eight ships at once for work none of them chose this hour. The ceiling only falls, so each
# lane sweeps its own files at its own pace and the fleet-wide property is provable the lap the
# last one lands.
#
# THE SECOND READING, WHICH NOTHING HOLDS. A cure can only be written where the field exists, so
# each asserted record is traced to what bound it, and the binding decides whether `err_brief` is
# there to name:
#
#   run     -- `run`, `wait-for`, or a locally defined `fn` whose body reaches one of them. The
#              interpreter builds this record at `rishi/src/main.rye:1563` with six fields by name
#              -- `out`, `err`, `code`, `ok`, `out_brief`, `err_brief` -- so the cure is writable.
#   path    -- `run-bounded`, or a `fn` reaching it. Its record names stream PATHS and byte counts
#              rather than carrying the text, so `${x.err_brief}` there would name a field that is
#              not present. These want a different repair and are counted apart for that reason.
#   unseen  -- this scan cannot find the binding in the same file.
#
# `cure_unwritable` sums the second and third. Reported rather than gated: a site whose record is
# path-shaped is not doing anything wrong, and a binding this reading cannot see is a limit of the
# reading rather than a fault in the file.
#
# One level deep, within one file, which is the reach a static reading honestly has. The function
# trace matters more than it sounds: `fn git-run tail: run (git_argv + tail)` and
# `fn build_guest src elf: run [...]` return run records through a call, and without the trace 183
# sites read as unbound where 101 of them carry `err` and can take the cure today.
#
# THIS SCAN IS NOT IN ITS OWN GATED POPULATION, on purpose and provably. The population is tracked
# `*.rish` alone, because the shape is Rishi's: twenty tracked `*.sh` files carry the characters,
# and every one is a control either QUOTING an assertion as a string it requires a launcher to hold
# or PLANTING one into a pen. Neither executes. This scan and its control are shell, so neither can
# enter the count; the control asserts that by reading this scan's own output rather than by
# trusting the sentence.
#
# WHAT IT DOES NOT REACH. An assertion whose message spans more than one physical line is unread --
# measured `20260917`, every one of the 10,234 in this tree is written on one line, and a second
# line would UNDERCOUNT rather than mislead. A message naming the reason in prose it composed
# itself, rather than by interpolation, reads as mute; that is a deliberate floor, since a sentence
# a person wrote cannot carry what the command said on the day it failed. The `say` lookback is six
# lines, chosen because a reason printed further above a refusal is separated from it by other
# output; a wider window would count a `say` belonging to an earlier step. A binding whose
# right-hand side opens on a conditional rather than on a verb or a call reads `unseen` rather than
# being followed into its branches -- two sites in `tools/c/chatgpt-mind.rish` stand there, both
# path-shaped in truth, so the miss is toward saying less rather than toward claiming more.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"
cd "$_fd_root" || exit 2

# THE CEILING, and why it is this number. It is the reading taken the lap this scan was seated,
# with no slack: a ceiling carrying room is a ceiling that welcomes the next silent refusal. Lower
# it in the same commit that sweeps a file.
CEILING=7403

# BOUNDS. A tree this size holds a few thousand Rishi sources and some tens of thousands of
# assertions; both limits sit an order above the live reading, so a wildly wrong enumeration meets
# a named refusal rather than an unbounded read.
MAX_SOURCES=20000
MAX_ASSERTS=100000

MODE=count
TARGET=
case "${1:-}" in
  '')        ;;
  --list)    MODE=list ;;
  --classes) MODE=classes ;;
  --explain) MODE=explain; TARGET=${2:-} ;;
  *) echo "$0: unknown argument '$1' (want --list, --classes, or --explain <path>)" >&2; exit 2 ;;
esac
if [ "$MODE" = explain ] && [ -z "$TARGET" ]; then
  echo "$0: --explain wants a path" >&2
  exit 2
fi

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files -- '*.rish' > "$work/sources.txt" || exit 2
sources=$(wc -l < "$work/sources.txt" | tr -d ' ')
if [ "$sources" -gt "$MAX_SOURCES" ]; then
  echo "$0: $sources tracked Rishi sources past the bound of $MAX_SOURCES" >&2
  exit 2
fi

# Candidates first, so the classifier reads the files carrying the shape rather than all of them.
# The path list reaches grep through `xargs_lines`, which is newline-delimited on both piers -- a
# bare `$(cat ...)` splits a path on a space and hands grep two broken paths that match nothing.
xargs_lines "$work/sources.txt" \
  grep -lE '^[[:space:]]*assert[[:space:]]+[A-Za-z_][A-Za-z0-9_]*\.ok[[:space:]]+else' \
  > "$work/candidates.txt" 2>/dev/null || true

# One assertion per line: `<path>\t<line>\t<class>\t<record>\t<binding>`.
: > "$work/asserts.txt"
if [ "$MODE" = explain ]; then
  if ! grep -qxF "$TARGET" "$work/sources.txt"; then
    echo "$0: '$TARGET' is not a tracked Rishi source" >&2
    exit 2
  fi
  printf '%s\n' "$TARGET" > "$work/candidates.txt"
fi

# ONE awk PROCESS over every candidate rather than one per file. A file's classification needs two
# passes -- the `run` bindings first, then the assertions -- so each file's lines are buffered and
# flushed when `FILENAME` changes and again at `END`. Two thousand four hundred process starts cost
# twenty seconds on this pier against under two for the single pass, and this guard runs at lap
# tier on every ship. `xargs_lines` may hand awk the paths in several batches; a batch boundary
# falls between files, never inside one, so the flush sees each file whole.
if [ -s "$work/candidates.txt" ]; then
  xargs_lines "$work/candidates.txt" awk '
    function body_kind(b) {
      # `run-bounded` is asked FIRST: its name begins with `run`, so a test for `run` alone would
      # claim it. Its record names stream PATHS rather than carrying their text, so a message
      # interpolating `err_brief` there would name a field that is not present.
      if (b ~ /run-bounded[ \t]*[\[{(]/) return "path"
      if (b ~ /(^|[^A-Za-z0-9_-])run[ \t]*[\[(]/) return "run"
      if (b ~ /(^|[^A-Za-z0-9_-])wait-for[ \t]/) return "run"
      return ""
    }
    function flush(  n, j, s, piece, rhs, k, nm, L, v, m, cls, bind) {
      if (path == "") return

      # Locally defined functions first. `fn git-run tail: run (git_argv + tail)` returns a run
      # record, so a name bound by calling it carries `err` and the cure is writable; `fn
      # write-phase value: ... run-bounded {...}` returns the path-shaped record and does not.
      # One level deep, within one file, which is the reach a static reading honestly has.
      for (n = 1; n <= held; n++) {
        if (line[n] !~ /^[[:space:]]*fn[ \t]+[A-Za-z_][A-Za-z0-9_-]*/) continue
        nm = line[n]
        sub(/^[[:space:]]*fn[ \t]+/, "", nm)
        sub(/[^A-Za-z0-9_-].*$/, "", nm)
        k = body_kind(line[n])
        if (k != "") fnkind[nm] = k
      }

      # Then every binding. The right-hand side decides, and a call to a known function inherits
      # the kind of that function.
      for (n = 1; n <= held; n++) {
        s = line[n]
        while (match(s, /[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*[^ \t=][^\n]*/)) {
          piece = substr(s, RSTART, RLENGTH)
          rhs = piece
          sub(/^[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*/, "", rhs)
          nm = piece
          sub(/[ \t]*=.*$/, "", nm)
          k = body_kind(rhs)
          if (k == "") {
            head = rhs
            sub(/[^A-Za-z0-9_-].*$/, "", head)
            if (head in fnkind) k = fnkind[head]
          }
          if (k != "") bound[nm] = k
          s = substr(s, RSTART + RLENGTH)
        }
      }

      for (n = 1; n <= held; n++) {
        L = line[n]
        if (L !~ /^[[:space:]]*assert[[:space:]]+[A-Za-z_][A-Za-z0-9_]*\.ok[[:space:]]+else[[:space:]]+"/) continue
        match(L, /assert[[:space:]]+[A-Za-z_][A-Za-z0-9_]*\.ok/)
        v = substr(L, RSTART, RLENGTH)
        sub(/assert[[:space:]]+/, "", v)
        sub(/\.ok$/, "", v)
        m = L
        sub(/^.*else[[:space:]]+"/, "", m)
        if (m ~ /"/) sub(/"[^"]*$/, "", m)
        if (index(m, "${" v ".err}") || index(m, "${" v ".err_brief}"))            cls = "names_err"
        else if (index(m, "${" v ".out}") || index(m, "${" v ".out_brief}") \
              || index(m, "${" v ".code}"))                                        cls = "names_field"
        else if (index(m, "${"))                                                   cls = "names_path"
        else {
          cls = "mute"
          for (j = n - 1; j >= 1 && j >= n - 6; j--) {
            if (line[j] ~ /^[[:space:]]*say/ && index(line[j], "${" v ".")) { cls = "said_above"; break }
          }
        }
        bind = (v in bound) ? bound[v] : "unseen"
        printf "%s\t%d\t%s\t%s\t%s\n", path, n, cls, v, bind
      }

      for (j in bound)  delete bound[j]
      for (j in fnkind) delete fnkind[j]
      for (j = 1; j <= held; j++) delete line[j]
      held = 0
    }
    FILENAME != path { flush(); path = FILENAME }
    { line[++held] = $0 }
    END { flush() }
  ' >> "$work/asserts.txt" 2>/dev/null || true
fi

asserts=$(wc -l < "$work/asserts.txt" | tr -d ' ')
if [ "$asserts" -gt "$MAX_ASSERTS" ]; then
  echo "$0: $asserts assertions past the bound of $MAX_ASSERTS" >&2
  exit 2
fi

count_class() { awk -F'\t' -v c="$1" '$3 == c { n++ } END { print n + 0 }' "$work/asserts.txt"; }

names_err=$(count_class names_err)
names_field=$(count_class names_field)
names_path=$(count_class names_path)
said_above=$(count_class said_above)
mute=$(count_class mute)
cure_unwritable=$(awk -F"\t" '$5 != "run" { n++ } END { print n + 0 }' "$work/asserts.txt")
bind_path=$(awk -F"\t" '$5 == "path" { n++ } END { print n + 0 }' "$work/asserts.txt")
bind_unseen=$(awk -F"\t" '$5 == "unseen" { n++ } END { print n + 0 }' "$work/asserts.txt")
files=$(wc -l < "$work/candidates.txt" | tr -d ' ')

case "$MODE" in
  list)
    awk -F'\t' '$3 == "mute" { printf "%s:%s\t%s\n", $1, $2, $4 }' "$work/asserts.txt"
    ;;
  classes)
    awk -F'\t' '{ printf "%s:%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5 }' "$work/asserts.txt"
    ;;
  explain)
    echo "explain=$TARGET"
    awk -F'\t' '{ printf "line=%s class=%s record=%s binding=%s\n", $2, $3, $4, $5 }' "$work/asserts.txt"
    echo "asserts_here=$asserts"
    ;;
esac

echo "sources=$sources"
echo "files_with_asserts=$files"
echo "asserts=$asserts"
echo "names_err=$names_err"
echo "names_field=$names_field"
echo "names_path=$names_path"
echo "said_above=$said_above"
echo "mute_asserts=$mute"
echo "cure_unwritable=$cure_unwritable"
echo "bind_path=$bind_path"
echo "bind_unseen=$bind_unseen"
echo "ceiling=$CEILING"

if [ "$MODE" = explain ]; then
  echo "verdict=explained"
  exit 0
fi

if [ "$mute" -gt "$CEILING" ]; then
  echo "verdict=over"
  exit 1
fi
echo "verdict=within"
exit 0
