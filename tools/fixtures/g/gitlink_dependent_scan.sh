#!/bin/sh
# gitlink_dependent_scan.sh -- a guard that reds on a dependency a correct clone may lack
# can never be rostered, so its refusal is one nobody will ever hear.
#
# WHY. This tree holds twelve gitlinks -- submodules recorded as a commit in the index and checked
# out only when a hand asks. Two kinds sit there, and the difference is a seated law rather than a
# preference. `vendor/` holds what the tree LINKS: the operator card names `vendor/{microkit,
# monocypher,pqclean,sel4}` a precondition every clone initialises before its first lap, so a red
# from an empty one is an environment fact. `gratitude/` holds a READING LIBRARY -- the
# gratitude-licenses law is explicit that we study concepts and never copy code -- so a clone that
# never initialised `gratitude/tigerbeetle` is a CORRECT clone, and a witness that hard-asserts on
# its contents reds on a healthy machine.
#
# WHAT THAT COSTS. REDS %646 found the shape by sampling: 40 of the unreached witnesses ran 35 green
# and 5 red, and among the five were preconditions -- `gratitude/tigerbeetle/src ABSENT`. Its lesson
# is that a hard assert on an optional precondition buys a red nobody hears, because it makes the
# witness unrostable and an unrostered witness runs nowhere. The row closed one witness as a worked
# example and left the class as a sample rather than a count. This is the count.
#
# THE CURE ALREADY STANDS, WHICH IS THE SECOND FINDING. REDS %460, one lane over, named the roster's
# `capability` field as the mechanism for exactly this and called seating it a design act. That field
# was built `20260829` and carries six probes from `20260908.224618` -- `ipv6`, `jail_nesting`,
# `trace_instrument`, `seed_projection`, `day_shelf`, and `tigerbeetle_clone`, the sixth drawn for
# this very family. Two of the elder five (`seed_projection`, `day_shelf`) already answered this
# same question for a different absent thing. So the two open rows are one gate, the gate has a
# door, and from `20260908.224618` the door is walked through.
#
#   sh tools/fixtures/g/gitlink_dependent_scan.sh          # measure and gate
#   sh tools/fixtures/g/gitlink_dependent_scan.sh list     # one line per dependent
#
# WHAT A DEPENDENT IS, exactly. A tracked runner whose basename carries `witness` or `suite`, naming
# a gitlink path on a line that is NOT a comment. Comments are read past because a header saying
# *Requires gratitude/tigerbeetle submodule present* is documentation rather than a dependency -- and
# every one of the twenty in that family carries such a header beside the assert that does the work.
#
# WHY THE READING IS A LOWER BOUND, and why that is the safe direction. A dependent reaching the
# clone through a scan script rather than naming the path itself reads as clean here. So the count
# under-reports and can never invent one, which is the direction a gate wants.
#
# THE GATE, and why it is this one. `rostered_undeclared` -- a guard the standing roster names, whose
# refusal depends on an OPTIONAL gitlink, carrying no `capability` line in its roster record -- is
# held at zero. That single row would red the whole fleet on every machine that studies rather than
# clones, which is the blast radius REDS %646 names. Everything else is reported: the unrostable
# population is a fact about the tree, and rostering it is a hand's decision with a probe attached.
#
# BOUNDS: at most 64 gitlinks, at most 4,000 runners read, at most 200 dependents reported.
set -eu

root=${GITLINK_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-measure}
MAX_GITLINKS=64
MAX_RUNNERS=4000
MAX_REPORT=200

roster=${GITLINK_ROSTER:-construction/standing-equipment.kyri}

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT HUP TERM

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=not_a_repository"; exit 1; }

# Gitlinks are mode 160000 in the index. Reading the index rather than `.gitmodules` is deliberate:
# a submodule declared in `.gitmodules` and never added carries no gitlink, and a gitlink is what a
# witness can actually find empty on disk.
git ls-files -s | awk '$1 == "160000" { print $4 }' | sort > "$work/gitlinks.txt"
gitlinks=$(wc -l < "$work/gitlinks.txt" | tr -d ' ')
if [ "$gitlinks" -eq 0 ]; then
  echo "verdict=no_gitlinks"
  echo "refused: this checkout records no submodule, so the reading has no subject" >&2
  exit 1
fi
if [ "$gitlinks" -gt "$MAX_GITLINKS" ]; then
  echo "verdict=gitlinks_over_bound"
  echo "refused: $gitlinks gitlinks against a bound of $MAX_GITLINKS" >&2
  exit 1
fi

# OPTIONAL vs REQUIRED is derived from the room, never from a list kept here. `gratitude/` is a
# reading library by the gratitude-licenses law; `vendor/` is what the tree links and the operator
# card requires. A gitlink in some third room reads OPTIONAL, which is the safe direction: it lands
# in the reported population rather than being silently excused.
: > "$work/optional.txt"
: > "$work/required.txt"
while read -r g; do
  case "$g" in
    vendor/*) echo "$g" >> "$work/required.txt" ;;
    *)        echo "$g" >> "$work/optional.txt" ;;
  esac
done < "$work/gitlinks.txt"
optional_gitlinks=$(wc -l < "$work/optional.txt" | tr -d ' ')
required_gitlinks=$(wc -l < "$work/required.txt" | tr -d ' ')

opt_pat=$(paste -sd'|' - < "$work/optional.txt")
req_pat=$(paste -sd'|' - < "$work/required.txt")

git ls-files 'tools/*' 'rye/*' 'glow/*' 2>/dev/null \
  | grep -E '_(witness|suite)\.(rish|rye)$' \
  | head -"$MAX_RUNNERS" > "$work/runners.txt"
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')

: > "$work/dependents.txt"
while read -r f; do
  [ -f "$f" ] || continue
  # A `#` line in Rishi and a `//` line in Rye are comments. The header of every member of the
  # tigerbeetle family names the submodule in exactly such a line, so reading them as dependencies
  # would count the documentation twice and call the assert beside it a second finding.
  kind=$(awk -v opt="$opt_pat" -v req="$req_pat" '
    /^[[:space:]]*#/  { next }
    /^[[:space:]]*\/\// { next }
    opt != "" && $0 ~ opt { o = 1 }
    req != "" && $0 ~ req { r = 1 }
    END { if (o) print "optional"; else if (r) print "required"; else print "" }
  ' "$f")
  [ -n "$kind" ] || continue
  printf '%s\t%s\n' "$kind" "$f" >> "$work/dependents.txt"
done < "$work/runners.txt"

dependents=$(wc -l < "$work/dependents.txt" | tr -d ' ')
optional_dependents=$(awk -F'\t' '$1 == "optional"' "$work/dependents.txt" | wc -l | tr -d ' ')
required_dependents=$(awk -F'\t' '$1 == "required"' "$work/dependents.txt" | wc -l | tr -d ' ')

# The roster is read as records: a `path` line opens one, and every line until the next `path`
# belongs to it. Asking whether the FILE holds the word `capability` anywhere would let one declared
# row excuse every undeclared one, which is the drift a per-record read cannot make.
if [ -f "$roster" ]; then
  roster_present=yes
  awk '
    /^path / { p = $2; cap[p] = 0; order[++n] = p; next }
    /^capability / { if (p != "") cap[p] = 1; next }
    END { for (i = 1; i <= n; i++) printf "%s\t%d\n", order[i], cap[order[i]] }
  ' "$roster" > "$work/roster.txt"
  rostered=$(wc -l < "$work/roster.txt" | tr -d ' ')
else
  roster_present=no
  : > "$work/roster.txt"
  rostered=0
fi

rostered_undeclared=0
optional_unrostable=0
: > "$work/report.txt"
while IFS="$(printf '\t')" read -r kind f; do
  [ "$kind" = optional ] || continue
  line=$(awk -F'\t' -v want="$f" '$1 == want { print $2 }' "$work/roster.txt")
  if [ -z "$line" ]; then
    optional_unrostable=$((optional_unrostable + 1))
    printf 'unrostable\t%s\n' "$f" >> "$work/report.txt"
  elif [ "$line" = "0" ]; then
    rostered_undeclared=$((rostered_undeclared + 1))
    printf 'undeclared\t%s\n' "$f" >> "$work/report.txt"
  fi
done < "$work/dependents.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/report.txt" | while IFS="$(printf '\t')" read -r kind f; do
    case "$kind" in
      unrostable) printf 'unrostable: %s reds when an optional submodule is absent, and no roster row hears it\n' "$f" ;;
      undeclared) printf 'undeclared: %s is rostered, depends on an optional submodule, and names no capability\n' "$f" ;;
    esac
  done
fi

echo "gitlinks=$gitlinks"
echo "optional_gitlinks=$optional_gitlinks"
echo "required_gitlinks=$required_gitlinks"
echo "runners=$runners"
echo "dependents=$dependents"
echo "optional_dependents=$optional_dependents"
echo "required_dependents=$required_dependents"
echo "roster_present=$roster_present"
echo "rostered=$rostered"
echo "rostered_undeclared=$rostered_undeclared"
echo "optional_unrostable=$optional_unrostable"
if [ "$rostered_undeclared" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=undeclared_dependency"
fi
