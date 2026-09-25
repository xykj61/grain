#!/bin/sh
# tools/fixtures/b/build_target_scan.sh -- where does a rostered guard's build output land?
#
#   sh tools/fixtures/b/build_target_scan.sh           # the counts
#   sh tools/fixtures/b/build_target_scan.sh --list    # the counts, plus every site named
#
# WHY THIS EXISTS. A guard that builds a binary has to put it somewhere, and nothing in this tree
# ever asked where. The first reading on `20260912` found 110 fixed emit sites and 6 shared paths.
# Moving the 18 Amphora guards into their own pens lowered those ratchets to 51 and 2; the live
# scan prints the current population rather than asking this comment to keep count.
#
# WHY A FIXED PATH COSTS SOMETHING. A build into a fixed tree path is a write to a file whose name
# no other reader knows is busy. So two readings of one tree that overlap in time write the same
# bytes: a roster pass building `amphora/bin/vessel-seal` while a hand runs one of that family's
# guards by name, which is a thing this tree's own baton tells every ship to do. The second reader
# gets a half-written binary and a red that vanishes on the next run.
#
# TWO LOCKS ALREADY STAND AND NEITHER IS ON THIS AXIS. `standing_equipment_run.sh` refuses a second
# roster pass over the first. `rye build` holds `.rye-build.lock` so two builds cannot stage one
# shadow (REDS %281). The first serializes pass against pass, the second build against build, and
# nothing anywhere serializes a build against a RUN -- which is the only pairing that needs it here.
# Measured on metal by the race probe beside this file: a reader whose own path is being written by
# ONE build, with no build race whatever, fails 335 executions in 400.
#
# THE SHARPEST READING IS `shared_paths`, AND IT IS NOT THE BIGGEST NUMBER. One guard writing one
# path collides only with itself, which needs the same guard run twice at once. A path written by
# TWO guards collides whenever EITHER runs beside the pass. The first `20260912` reading found 51
# distinct fixed paths and 6 shared paths. Three were Amphora binaries written by 18 guards apiece,
# and moving those builds into per-run pens left 2. `20260915` took the Mantra half: the two guards
# writing `mantra/bin/snapshot-export-delivery` -- `mantra_snapshot_hosted` and
# `mantra_udp_reuseaddr` -- each build into their own pen now, so the live reading is 1. What made
# that pair worth taking first is that a port lock already serialized their two RUN legs and left
# their builds free of each other, which is build-against-run with nothing between it.
#
# WHAT IS INFERENCE HERE, SAID PLAINLY. REDS %700 records a rostered guard reading red and then
# green on one unchanged tree, and names two builds into fixed tree paths as the suspicion. No run
# has caught that guard in the act, and this scan does not catch it either. What this scan proves
# is the SHAPE of the exposure and its size. Whether %700 is this fault or another one stays open.
#
# TWO WALLS THAT ALREADY HOLD, AND THEY ARE CHEAP. `emit_tracked` is a build output that is a file
# the repository carries -- a lap could commit a binary. `emit_unignored` is one git would show in
# `git status` -- it moves the tree digest `standing_equipment_run.sh` takes at open and close, so
# a pass would refuse itself under `tree_moved`. Both read ZERO today, which is what makes them
# walls rather than ratchets: a zero held from the day it is measured costs nothing and refuses the
# first arrival.
#
# AND TWO RATCHETS THAT DO REFUSE NEW WORK OF THE OLD KIND, ON PURPOSE. `emit_fixed` and
# `shared_paths` sit under ceilings that only fall, so a new guard building into a fixed tree path
# reds on the lap it lands. That is the convention this file seats: A NEW GUARD BUILDS INTO A
# DIRECTORY IT MADE FOR ITSELF. The named escape is `d=$(mktemp -d)` and `-femit-bin=$d/<name>`,
# which 12 sites already spell. Lower a ceiling when a lap moves a site; never raise one.
#
# A PLACEHOLDER IN PROSE IS NOT A BUILD TARGET (`20260916.080424`). A guard's own comment often
# spells the shape of the command it drives -- `rye build -femit-bin=<path>` -- and the extraction
# below reads a source line by line without asking whether it is code. Two such mentions stood in
# the population, one of them the whole of that lap's ceiling breach: a doc comment naming
# `<path>` read as a forty-eighth fixed emit site against a ceiling of forty-seven. A target
# carrying `<` or `>` is a placeholder, never a path any filesystem will hold, so it is counted as
# `prose` and reaches neither the fixed count nor the shared one. It is REPORTED rather than
# dropped, because a reading that silently discards a line cannot be told from one that never saw
# it.
#
# THE REPAIR FREED EXACTLY THE ROOM A PEER'S REAL ARRIVAL NEEDED, and the ceiling therefore does
# not fall. Read on the rebased tree: 49 under the elder rule, **47** real sites and 3 placeholders
# under this one, against a ceiling that stood at 47 while two of its number were phantoms. So the
# number is unchanged and its MEANING is not -- 47 now bounds 47 builds into fixed tree paths,
# where before it bounded 45 and two sentences. A swap of that shape is invisible in the total
# alone, which is why `emit_prose` prints beside it.
#
# WHAT THE COUNTS CANNOT SEE. `emit_unresolved` is a site whose target is a variable this scan
# cannot follow to either a literal or a `mktemp`. It is REPORTED rather than gated, and while it
# stands above zero `emit_fixed` is a FLOOR rather than a total -- a reading that says so is worth
# more than one that quietly rounds down.
#
# A CEILING OVERRIDE IS LEGIBLE, NEVER SILENT. The two ceilings are spelled here, in the shape the
# rest of this tree's ratchets wear -- the constant carries its own environment default and is what
# the comparison names, so `tools/fixtures/r/ratchet_slack_scan.sh` can see the ceiling being
# compared rather than a local copy of it. A control needs to cross them inside a pen, so the
# environment may name its own -- and the scan then prints `ceiling_source=env`, which
# `tools/b/build_target_witness.rish` refuses on a live reading. A bypass nobody can see is a
# bypass; one the reading announces is a pen.
set -u

CEILING_FIXED=${BUILD_TARGET_CEILING_FIXED:-47}
CEILING_SHARED=${BUILD_TARGET_CEILING_SHARED:-1}

root=${BUILD_TARGET_ROOT:-.}
roster=${BUILD_TARGET_ROSTER:-construction/standing-equipment.kyri}
ceiling_source=seated
if [ -n "${BUILD_TARGET_CEILING_FIXED:-}" ] || [ -n "${BUILD_TARGET_CEILING_SHARED:-}" ]; then
  ceiling_source=env
fi

list=no
for arg in "$@"; do
  case "$arg" in
    --list) list=yes ;;
    *) echo "detail: unknown argument $arg" >&2; echo "verdict=bad_argument"; exit 2 ;;
  esac
done

cd "$root" 2>/dev/null || { echo "detail: no such root $root" >&2; echo "verdict=no_root"; exit 2; }

if [ ! -f "$roster" ]; then
  echo "detail: no roster at $roster" >&2
  echo "verdict=no_roster"
  exit 2
fi

pen=$(mktemp -d) || { echo "verdict=no_pen"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# ONE RECORD PER ROSTERED GUARD: name and the path a runner invokes. A `guard` line opens a record
# and the `path` line inside it names the source, so the name is carried forward rather than
# re-derived from the filename -- two guards may live in one file.
awk '/^guard /{n=$2} /^path /{if (n != "") print n" "$2}' "$roster" > "$pen/roster"
guards_rostered=$(wc -l < "$pen/roster" | tr -d ' ')

# EVERY EMIT SITE, ONE PER LINE: guard, source, and the raw target as written. A whole-line
# comment is a prose mention, not a build; keep it in the receipt as prose so the reading names
# what it saw without turning documentation into a fixed path.
: > "$pen/sites"
while read -r name src; do
  [ -f "$src" ] || continue
  awk -v name="$name" -v src="$src" '
    {
      line = $0
      line_kind = ($0 ~ /^[[:space:]]*#/) ? "prose" : "fixed"
      while (match(line, /-femit-bin=[^" ]+/)) {
        target = substr(line, RSTART + 11, RLENGTH - 11)
        printf "%s\t%s\t%s\t%s\n", line_kind, name, src, target
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$src" >> "$pen/sites"
done < "$pen/roster"

# RESOLVE A VARIABLE TARGET, AND REFUSE TO GUESS. A target naming a variable is followed three
# ways and no further. Rishi makes a pen in two bindings -- `let made = run ["sh" "-c" "mktemp -d
# ..."]` and then `let pen = trim made.out` -- so the chain is walked rather than the first line
# read, which is what a single-binding reading got wrong on its first pass: ten amphora sites
# reaching a real pen through `${home}` read as fixed tree paths. Shell makes one inline, and a
# `let` to a literal string is the third. Anything else is unresolved and says so.
resolve_kind() {
  # resolve_kind <file> <var> <depth>; prints "pen", "literal <path>", or "unknown"
  rk_file=$1; rk_var=$2; rk_depth=$3
  [ "$rk_depth" -le 4 ] || { echo unknown; return; }
  if grep -qE "(^|[^A-Za-z0-9_])${rk_var}=\\\$\\(mktemp" "$rk_file" 2>/dev/null; then
    echo pen; return
  fi
  rk_line=$(grep -E "^let[[:space:]]+${rk_var}[[:space:]]*=" "$rk_file" 2>/dev/null | head -1)
  case "$rk_line" in
    *mktemp*) echo pen; return ;;
  esac
  rk_next=$(printf '%s' "$rk_line" | sed -n 's/^let[[:space:]][[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=[[:space:]]*trim[[:space:]][[:space:]]*\([A-Za-z_][A-Za-z0-9_]*\)\..*/\1/p')
  if [ -n "$rk_next" ]; then
    resolve_kind "$rk_file" "$rk_next" $((rk_depth + 1))
    return
  fi
  rk_lit=$(printf '%s' "$rk_line" | sed -n 's/^let[[:space:]][[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p')
  if [ -n "$rk_lit" ]; then
    echo "literal $rk_lit"
    return
  fi
  echo unknown
}

: > "$pen/resolved"
while IFS="$(printf '\t')" read -r line_kind name src target; do
  if [ "$line_kind" = prose ]; then
    printf '%s\t%s\t%s\t%s\n' prose "$name" "$src" "$target" >> "$pen/resolved"
    continue
  fi
  # A LITERAL MAY ITSELF HOLD A VARIABLE, so the classification iterates rather than substituting
  # once: `${elder_dir}` binds to the string `${home}/elder`, and `${home}` binds to a pen. One
  # step read ten amphora sites as fixed tree paths that reach a real pen. Bounded at four hops,
  # and a target still wearing a `$` when the hops run out is unresolved rather than guessed at.
  kind=fixed
  # A placeholder wears a bracket; no path does. Decided before the variable walk, since a
  # placeholder holds no variable to follow and would otherwise land in `fixed` by default.
  case "$target" in
    *'<'*|*'>'*) printf '%s\t%s\t%s\t%s\n' prose "$name" "$src" "$target" >> "$pen/resolved"; continue ;;
  esac
  path="$target"
  hop=0
  while [ "$hop" -lt 4 ]; do
    case "$path" in
      \$*) : ;;
      *) break ;;
    esac
    var=${path#\$}
    var=${var#\{}
    var=${var%%\}*}
    var=${var%%/*}
    answer=$(resolve_kind "$src" "$var" 0)
    case "$answer" in
      pen) kind=pen; break ;;
      literal\ *)
        lit=${answer#literal }
        case "$path" in
          *\}*) path="$lit${path#*\}}" ;;
          *) path="$lit${path#\$$var}" ;;
        esac
        ;;
      *) kind=unresolved; break ;;
    esac
    hop=$((hop + 1))
  done
  case "$kind" in
    fixed)
      case "$path" in
        \$*) kind=unresolved ;;
      esac
      ;;
  esac
  printf '%s\t%s\t%s\t%s\n' "$kind" "$name" "$src" "$path" >> "$pen/resolved"
done < "$pen/sites"

emit_sites=$(wc -l < "$pen/resolved" | tr -d ' ')
emit_pen=$(awk -F'\t' '$1=="pen"' "$pen/resolved" | wc -l | tr -d ' ')
emit_fixed=$(awk -F'\t' '$1=="fixed"' "$pen/resolved" | wc -l | tr -d ' ')
emit_unresolved=$(awk -F'\t' '$1=="unresolved"' "$pen/resolved" | wc -l | tr -d ' ')
emit_prose=$(awk -F'\t' '$1=="prose"' "$pen/resolved" | wc -l | tr -d ' ')
guards_emitting=$(awk -F'\t' '{print $2}' "$pen/resolved" | sort -u | wc -l | tr -d ' ')

awk -F'\t' '$1=="fixed"{print $4}' "$pen/resolved" | sort -u > "$pen/fixed_paths"
fixed_paths=$(wc -l < "$pen/fixed_paths" | tr -d ' ')

# A PATH AND ITS DISTINCT WRITERS. Two emit sites inside ONE guard are that guard writing twice and
# collide with nobody new, so the pair is made unique before it is counted.
awk -F'\t' '$1=="fixed"{print $4"\t"$2}' "$pen/resolved" | sort -u > "$pen/path_guard"
awk -F'\t' '{c[$1]++; g[$1]=g[$1]" "$2} END{for (p in c) print c[p]"\t"p"\t"g[p]}' "$pen/path_guard" | sort -rn > "$pen/writers"
shared_paths=$(awk -F'\t' '$1>1' "$pen/writers" | wc -l | tr -d ' ')
max_writers=$(awk -F'\t' 'NR==1{print $1}' "$pen/writers")
[ -n "$max_writers" ] || max_writers=0

# THE TWO WALLS. A build output the repository carries, and one git would show. Both ask git rather
# than spelling a path list, since a `.gitignore` line is the only thing that decides either.
emit_tracked=0
emit_unignored=0
: > "$pen/tracked"
: > "$pen/unignored"
if [ -d .git ] || git rev-parse --git-dir >/dev/null 2>&1; then
  while read -r p; do
    if git ls-files --error-unmatch "$p" >/dev/null 2>&1; then
      emit_tracked=$((emit_tracked + 1))
      echo "$p" >> "$pen/tracked"
    fi
    if ! git check-ignore -q "$p" 2>/dev/null; then
      emit_unignored=$((emit_unignored + 1))
      echo "$p" >> "$pen/unignored"
    fi
  done < "$pen/fixed_paths"
  git_read=yes
else
  git_read=no
fi

if [ "$list" = yes ]; then
  awk -F'\t' '{printf "site %s %s %s %s\n", $1, $2, $3, $4}' "$pen/resolved" | sort
  awk -F'\t' '$1>1{printf "shared %s writers=%s --%s\n", $2, $1, $3}' "$pen/writers"
  while read -r p; do echo "tracked $p"; done < "$pen/tracked"
  while read -r p; do echo "unignored $p"; done < "$pen/unignored"
fi

echo "roster=$roster"
echo "ceiling_source=$ceiling_source"
echo "git_read=$git_read"
echo "guards_rostered=$guards_rostered"
echo "guards_emitting=$guards_emitting"
echo "emit_sites=$emit_sites"
echo "emit_pen=$emit_pen"
echo "emit_fixed=$emit_fixed"
echo "emit_unresolved=$emit_unresolved"
echo "emit_prose=$emit_prose"
echo "fixed_paths=$fixed_paths"
echo "shared_paths=$shared_paths"
echo "max_writers=$max_writers"
echo "emit_tracked=$emit_tracked"
echo "emit_unignored=$emit_unignored"
echo "ceiling_fixed=$CEILING_FIXED"
echo "ceiling_shared=$CEILING_SHARED"

# ONE VERDICT, MOST SEVERE FIRST, AND THE ORDER IS STATED RATHER THAN LEFT TO THE LAST ASSIGNMENT.
# A tracked output is necessarily an unignored one, so the two readings fire together and the word
# has to name the worse of them: a binary the repository CARRIES outranks one git merely shows.
verdict=ok
if [ "$emit_tracked" -ne 0 ]; then
  verdict=tracked_output
elif [ "$emit_unignored" -ne 0 ]; then
  verdict=unignored_output
elif [ "$emit_fixed" -gt "$CEILING_FIXED" ]; then
  verdict=fixed_over_ceiling
elif [ "$shared_paths" -gt "$CEILING_SHARED" ]; then
  verdict=shared_over_ceiling
fi
echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
