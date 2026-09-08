#!/bin/sh
# process_reach_scan.sh -- which tracked scripts reach the one namespace eight ships share.
#
#   sh tools/fixtures/p/process_reach_scan.sh [--sites]
#
# WHY THIS GUARD EXISTS. `pkill -f <pattern>` matches the whole command line of every process on
# the host, and this pier runs eight ships out of eight sibling checkouts that run the same program
# names. One writer per checkout (REDS %291) is a rule about FILES, enforced by `cd`, by `git`, and
# by the jail -- and a process-name pattern steps over all three, because the kernel's process table
# is the one resource the fleet genuinely shares. REDS %569 and %587 are the same act twice: a lap
# reaching for `pkill -f` to stop its own runaway pass, killing peers' passes in trees it has never
# seen. A kill leaves no receipt, so no wall in this tree was ever going to see it -- every wall
# here watches files, and this act touches none.
#
# The safe form is already built and near: `tools/f/fleet_call.sh` resolves each candidate's
# working directory and signals only what sits under this tree's own root, refusing the rest out
# loud. What was missing is the reading -- nothing named the sites that already carry the unsafe
# form, so the next hand under time pressure reaches for `pkill -f` exactly as the last one did.
#
# WHAT COUNTS AS A REACH. A line, outside a comment, whose command is `pkill`, `killall`, or
# `pgrep`, where the selector is a command-line or program-name pattern. Both the kill and the READ
# are counted: `pgrep -f standing_equipment_run` answered 22 processes across seven peer trees on
# this pier `20260907.213806`, so a lap reading that count concludes something false about its own
# tree as surely as a kill reaches past it.
#
# WHAT DOES NOT COUNT, and each exclusion is proven from both sides in the control:
#
#   * `-P <pid>` -- bounded by parent, which is a local boundary by construction. Caravan's two
#     supervisor probes use exactly this and are correct.
#   * a comment line -- a line whose first non-blank character is `#`. This file, `%587`'s ledger
#     row, and `fleet_call.sh`'s own header all DISCUSS `pkill -f` at length; a guard that read a
#     mention as a promise would red hardest on the pages teaching the law (REDS %585's shape).
#   * the word `ripgrep`, which contains `pgrep`. Nine tracked files name ripgrep in prose and one
#     scan matches it in code; the command test is anchored at a fragment's start, so `ripgrep`
#     can never open one.
#   * a quoted mention on a code line -- `grep -c 'pkill \|killall '` in `fleet_call_witness.rish`
#     is a search string rather than a command, and a fragment that begins with `grep` is not a
#     fragment that begins with `pkill`.
#   * a DECLARED site -- see below.
#
# THE DECLARATION, rather than a growing exclusion list. Some reaches are correct and argued: the
# fleet watch asks the process table for a seat's loop by a name the roster makes unique across the
# whole fleet, which is a boundary even though it is not a directory. A guard that could not tell
# that from a bare `pkill -f` would either red on correct work or need a hand-maintained list of
# paths -- and a hand-maintained list is a second copy of a judgment, drifting from the first. So a
# site declares its own boundary, on the line or the line above:
#
#     # process-reach: bounded -- <the boundary, in words>
#
# Declared sites are counted apart and printed by name, so the declaration stays readable and a
# reader can disagree with one. Undeclared sites are the ratchet.
#
# Reads TRACKED sources only, `.sh` and `.rish`, which are the two extensions this tree writes
# shell in. Bounded: 4096 files, 64 sites.
set -u

here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
cd "$here" || exit 1

max_files=4096   # bound: this tree tracks ~3,000 shell and Rishi sources; 4096 is the next power
max_sites=64     # bound: six sites stood when this guard was written; 64 is far past any real day

# THE RATCHET'S CEILING ONLY EVER FALLS, and it is a ceiling rather than a wall because two of the
# six sites found on `20260907.213806` are correct-as-written in lanes this seat does not hold:
#
#   tools/h/hawm0_stop.sh:37   `pkill -f "avd hawm0"` -- the Android emulator is a HOST singleton
#                              living outside every checkout, so the cwd boundary `fleet_call.sh`
#                              draws would refuse it as foreign. Its own lane decides the shape.
#   tools/fixtures/p/prin_matrix.sh:76  `pgrep -af 'rishi|rye build|timeout 300'` -- a status board
#                              printing every ship's workers under the heading "live". This is the
#                              READING side of %587 and the sharper half: a kill that misses is at
#                              least loud, where a board mislabeling seven peers' work as this
#                              tree's is quietly wrong every time it is read.
#
# Lower it when a repair lands. A ceiling of zero would be a wall on writing rather than a ratchet
# on drift, and a wall that reds for a lane that cannot repair it is a wall someone turns off.
ceiling=2

want_sites=no
[ "${1:-}" = "--sites" ] && want_sites=yes

# THE INSTRUMENT IS PROVEN PRESENT BEFORE IT IS TRUSTED (REDS %413). A scan whose file list is
# empty must refuse loudly; a clean zero out of an unreadable corpus reads exactly like a pass.
files=$(git ls-files '*.sh' '*.rish' 2>/dev/null) || {
  echo "process_reach: REFUSED -- git would not list tracked sources" >&2; exit 2; }
[ -n "$files" ] || { echo "process_reach: REFUSED -- no tracked shell or Rishi source" >&2; exit 2; }

nfiles=$(printf '%s\n' "$files" | wc -l | tr -d ' ')
[ "$nfiles" -le "$max_files" ] || {
  echo "process_reach: REFUSED -- $nfiles tracked sources over the bound of $max_files" >&2; exit 2; }

pen=$(mktemp -d) || { echo "process_reach: REFUSED -- no pen" >&2; exit 2; }
# invariant: the pen is unique per run. A constant /tmp path is a pen two ships share, and a
# compare that reads one tree's snapshot against another's answers GREEN while a fault stands.
trap 'rm -rf "$pen"' EXIT INT TERM

# THE INSTRUMENT INSIDE ITS OWN READING (REDS %578, one room over, and it bit here the moment the
# control was STAGED rather than merely written). `process_reach_control.sh` PLANTS bare `pkill -f`
# lines to prove this scan counts them, so the scan counted its own plants: `bare_sites` read 2 with
# the control untracked and 10 with it tracked, and a guard whose reading changes when its own
# fixture is staged is a guard nobody can trust either way. Excluded by EXACT PATH -- never by a
# `*control*` pattern, which would blind this guard to a real reach in every control in the tree --
# and the exclusion is COUNTED AND PRINTED, because an exclusion nobody can see is a claim rather
# than a measurement.
self_excluded=tools/fixtures/p/process_reach_control.sh
excluded=0
if printf '%s\n' "$files" | grep -qxF "$self_excluded"; then
  files=$(printf '%s\n' "$files" | grep -vxF "$self_excluded")
  excluded=1
fi

printf '%s\n' "$files" > "$pen/files"
nfiles=$(wc -l < "$pen/files" | tr -d ' ')   # what was actually read, after the exclusion

# The reader, in awk: split each code line into fragments at the shell separators, and ask whether
# a fragment's own first word is one of the three commands. A fragment is where a command may
# begin, so a token anywhere else -- inside quotes, mid-word, in `ripgrep` -- can never open one.
awk '
  function is_decl(s) { return (s ~ /process-reach:[ \t]*bounded/) }
  FNR == 1 { p1 = ""; p2 = ""; p3 = "" }
  {
    line = $0
    stripped = line
    sub(/^[ \t]*/, "", stripped)
    if (substr(stripped, 1, 1) == "#") { p3 = p2; p2 = p1; p1 = line; next }   # a comment discusses, never calls

    frag = line
    # invariant: quoted spans are blanked BEFORE the split, because a separator inside a string is
    # not a separator. `grep -c '\''pkill \\|killall '\''` in fleet_call_witness.rish is one search
    # string; split naively, its `|` opens a fragment whose first word is `killall`, and the guard
    # names the very witness that proves the safe helper never reaches for one. A command token
    # always sits OUTSIDE its own quotes, so blanking the contents can only lose a false match.
    gsub(/'\''[^'\'']*'\''/, "Q", frag)
    gsub(/"[^"]*"/, "Q", frag)
    gsub(/[;|&(){}`]/, "\n", frag)                                   # every place a command may begin
    n = split(frag, parts, "\n")
    hit = ""
    for (i = 1; i <= n; i++) {
      p = parts[i]
      sub(/^[ \t]*/, "", p)
      # leading words that precede a command without being one
      while (p ~ /^(if|then|else|elif|do|while|until|!|exec|command|sudo|time)[ \t]+/) {
        sub(/^[a-z!]+[ \t]+/, "", p)
      }
      if (p ~ /^pkill([ \t]|$)/ || p ~ /^killall([ \t]|$)/ || p ~ /^pgrep([ \t]|$)/) {
        if (p ~ /(^|[ \t])-[A-Za-z]*P([ \t]|$)/) continue            # -P: bounded by parent
        hit = p
        break
      }
    }
    if (hit != "") {
      # invariant: the window is three lines rather than one. A declaration names a boundary in
      # words, and a sentence wraps -- the reason written above the fleet watch takes two lines,
      # and a marker readable only on the line immediately above counted it bare while it stood
      # written and true. Three is the bound: past that, a marker is no longer near its site.
      d = (is_decl(line) || is_decl(p1) || is_decl(p2) || is_decl(p3)) ? "declared" : "bare"
      printf "%s\t%s:%d\t%s\n", d, FILENAME, FNR, hit
    }
    p3 = p2; p2 = p1; p1 = line
  }
' $(cat "$pen/files") > "$pen/sites" 2>/dev/null || true

bare=$(grep -c '^bare' "$pen/sites" 2>/dev/null || true)
declared=$(grep -c '^declared' "$pen/sites" 2>/dev/null || true)
[ -n "$bare" ] || bare=0
[ -n "$declared" ] || declared=0
total=$((bare + declared))

[ "$total" -le "$max_sites" ] || {
  echo "process_reach: REFUSED -- $total sites over the bound of $max_sites" >&2; exit 2; }

if [ "$want_sites" = yes ]; then
  sort "$pen/sites" | while IFS="$(printf '\t')" read -r kind where what; do
    printf 'site %s %s -- %s\n' "$kind" "$where" "$what"
  done
fi

# REPORTED, NEVER GATED beside the ratchet: the safe form's own reach, so a reader can see that the
# near form exists rather than take this scan's word for it.
helper=no
[ -f tools/f/fleet_call.sh ] && helper=yes

echo "files_read=$nfiles"
echo "self_excluded_sources=$excluded"
echo "declared_sites=$declared"
echo "bare_sites=$bare"
echo "bare_ceiling=$ceiling"
echo "safe_helper_present=$helper"
# invariant: the comparison is `-le` rather than `-eq`. A floor spelled as an equality refuses the
# rise it exists to reward, which cost this fleet seven hand-raises in one day (REDS %584); a
# ceiling spelled as an equality is the same fault upside down -- it would red on a repair.
if [ "$bare" -le "$ceiling" ]; then echo "verdict=under_ceiling"; else echo "verdict=over_ceiling"; fi
