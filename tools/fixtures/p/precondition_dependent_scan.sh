#!/bin/sh
# precondition_dependent_scan.sh -- a witness that refuses when a precondition it cannot satisfy is
# absent buys a red nobody will ever hear, because the refusal makes it unrostable and an unrostered
# witness runs nowhere.
#
# WHY. REDS %646 found this shape by sampling: 40 of the unreached witnesses ran 35 green and 5 red,
# and the five were three different things wearing one colour -- a genuine finding, a choir whose
# member fails, and PRECONDITIONS. Two preconditions appeared in that sample. One was
# `gratitude/tigerbeetle/src ABSENT`, an optional submodule, and `gitlink_dependent` counted and
# walled that family on `20260908.214427`. The other was `build wayland_seed first`, which is not a
# submodule at all, and nothing has counted it. This is that count.
#
# THE TWO PRECONDITIONS THIS READS, and why they belong in one instrument. An ARTIFACT precondition
# wants a built file the tree does not track, so a correct clone lacks it until something builds it.
# A DISPLAY precondition wants `WAYLAND_DISPLAY` set, so a headless host lacks it and no amount of
# building helps. Different absences, one consequence: the runner exits non-zero on a healthy
# machine, which is the only property a roster cares about.
#
# THE CURE STANDS THREE TIMES IN THIS TREE ALREADY, which is the second finding and the harder one.
# (1) REDS %173 seated `pond_display_gate` for exactly the screenless case -- *a machine with no
# screen is a machine, never a red* -- and its build fixture exits 3 naming the absent seam. (2) The
# roster's `capability` field, built `20260829` and carrying six probes, is the tier for what a host
# CAN DO, and `ipv6` and `qemu_riscv` are two hosts' absences already spoken. (3)
# `tools/equinox/witness/equinox_season_e0_witness.rish` BUILDS its own `glow/bin/mod-clock` rather
# than requiring one, and says so in its own comment: *the rung builds its own binary the same way
# and keeps the reading it always wanted*. Measured `20260911`, it is the ONE green of eleven
# dependents probed on this tree. So the cure is not a design question; it is a habit that reached
# one room and stopped, and no guard ever asked which witnesses still refuse.
#
#   sh tools/fixtures/p/precondition_dependent_scan.sh          # measure and gate, statically
#   sh tools/fixtures/p/precondition_dependent_scan.sh list     # one line per dependent
#   sh tools/fixtures/p/precondition_dependent_scan.sh probe    # RUN each one and gate on what it does
#
# A BUILD IS NOT A PRECONDITION, and reading it as one is the mistake this scan is built to avoid.
# `equinox_season_e0` probes `glow/bin/mod-clock`, a path git does not track -- and it ran `rye build
# ... -femit-bin=glow/bin/mod-clock` two lines above. A scan reading the probe alone charges that
# file with the fault it is the worked example of the cure for. So a probed path whose own runner
# names it in a build invocation reads `builds_own` and leaves the population. That reading is
# printed rather than dropped, because the count of runners that already build what they need is the
# measure of how far the cure reached.
#
# WHY THE READING IS A LOWER BOUND, and why that is the safe direction. A probe whose path is
# assembled from two variables, or reached through a scan script, reads as clean here. So the count
# under-reports and can never invent a dependent, which is the direction a gate wants.
#
# THE TWO GATES. `rostered_undeclared` -- a guard the standing roster names, whose refusal depends on
# a precondition, carrying no `capability` line in its roster record -- is held at ZERO. That one row
# would red the whole fleet on every machine lacking the artifact or the screen, which is the blast
# radius %646 names and the reason an unrostable witness stays unrostered. `probe_red` is held under
# a CEILING THAT ONLY FALLS, rather than at zero, and the difference is honest: measured
# `20260911.190817` on this tree, 10 of 11 probed dependents refuse, so a wall at zero would refuse
# ordinary work on the lap it landed and a wall that refuses ordinary work is a wall somebody turns
# off. The ceiling falls each time a dependent learns to build what it needs or to skip and say so.
#
# THE HAZARD, named rather than hidden: a probe RUNS a runner, and a runner may write. Every
# dependent read here refuses at a precondition before it reaches anything expensive, and the
# standing runner digests the tree at open and close, so a probe that writes surfaces as `tree_moved`
# rather than in silence -- a net under this, rather than a wall.
#
# BOUNDS: at most 4,000 runners read, at most 200 dependents reported, at most 32 probed -- the
# population is 11 and a bound placed at the cliff fails on the day it matters.
set -eu

root=${PRECOND_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-measure}
MAX_RUNNERS=4000
MAX_REPORT=200
MAX_PROBE=32

roster=${PRECOND_ROSTER:-construction/standing-equipment.kyri}
# The runner the probe hands each dependent to. Overridable for the same reason PRECOND_ROOT is: a
# pen holds planted witnesses and no interpreter, so the control aims this at the real tree's rishi
# and keeps the subject in the pen.
rishi=${PRECOND_RISHI:-rishi/bin/rishi}
probe_ceiling=${PRECOND_PROBE_CEILING:-10}

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT HUP TERM

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=not_a_repository"; exit 1; }

git ls-files 'tools/*' 'rye/*' 'glow/*' 2>/dev/null \
  | grep -E '_(witness|suite)\.(rish|rye)$' \
  | head -"$MAX_RUNNERS" > "$work/runners.txt"
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')
if [ "$runners" -eq 0 ]; then
  echo "verdict=no_runners"
  echo "refused: this checkout tracks no witness, so the reading has no subject" >&2
  exit 1
fi

# Every tracked path, once, so a probed path is decided by a lookup rather than by a `git ls-files`
# call per probe. 16,000 paths against 4,000 runners is the whole reason.
git ls-files > "$work/tracked.txt"

: > "$work/dependents.txt"
: > "$work/buildsown.txt"
: > "$work/required.txt"
while read -r f; do
  [ -f "$f" ] || continue
  # Comments are read past. A header saying *Rebuild wayland_seed first if brushtest is missing* is
  # documentation, and the assert beside it is the dependency -- counting both would report one
  # finding twice. Rishi comments open with `#`, Rye's with `//`.
  awk '
    /^[[:space:]]*#/    { next }
    /^[[:space:]]*\/\// { next }
    { print }
  ' "$f" > "$work/body.txt"

  # The probed paths, in ONE pass: a `let NAME = "literal"` binding is remembered as it is read, and
  # a `test -x`/`test -f` whose subject is a literal or a bound name is emitted as `name<TAB>path`,
  # with `-` for a literal. Rishi runs top to bottom, so a binding always precedes its use.
  #
  # ONE PASS RATHER THAN TWO, and the reason is a real fault this pen caught. The first draft read
  # bindings into one file and bodies in a second awk over `NR == FNR`. When the first file is EMPTY
  # -- a runner probing a literal path and binding nothing -- FNR and NR both count the second file,
  # so `NR == FNR` holds for every line of it and the whole body is swallowed as bindings. The real
  # tree read ten dependents under that draft and every one of them happened to carry a binding, so
  # the fault was invisible in the population it was measured on.
  awk '
    /^[[:space:]]*let [A-Za-z_][A-Za-z_0-9]* *= *"[^"]*"[[:space:]]*$/ {
      name = $2
      line = $0
      sub(/^[^=]*= *"/, "", line)
      sub(/"[[:space:]]*$/, "", line)
      bind[name] = line
      next
    }
    {
      line = $0
      while (match(line, /run \["test" "-[xf]" ("[^"]+"|[A-Za-z_][A-Za-z_0-9]*)/)) {
        piece = substr(line, RSTART, RLENGTH)
        line = substr(line, RSTART + RLENGTH)
        sub(/^run \["test" "-[xf]" /, "", piece)
        if (piece ~ /^"/) { sub(/^"/, "", piece); sub(/"$/, "", piece); p = piece; v = "-" }
        else { p = bind[piece]; v = piece }
        if (p != "" && p !~ /\$/) print v "\t" p
      }
    }
  ' "$work/body.txt" | sort -u > "$work/probed.txt"

  has_artifact=0
  has_display=0
  built=0
  required=0
  while IFS="$(printf '\t')" read -r v p; do
    [ -n "$p" ] || continue
    grep -qxF "$p" "$work/tracked.txt" && continue
    # REQUIRED vs OPTIONAL is derived from the room, exactly as `gitlink_dependent` derives it, and
    # for the same seated reason: `construction/ITINERARY.md` names `vendor/` a precondition every
    # clone initialises before its first lap, so a red from an empty one is an environment fact
    # rather than a tree red. A probe on `vendor/zig-toolchain/zig` is therefore a required
    # dependency -- the toolchain -- and leaves this population.
    case "$p" in vendor/*) required=$((required + 1)); continue ;; esac
    # The e0 rule: a runner that BUILDS the path it probes is the cure rather than the fault. The
    # test is two reads rather than one regex -- every line naming the path, then whether any of them
    # is a build. A path is a literal from the file, so interpolating it into a pattern would let a
    # dot or a slash in a filename change what the pattern means.
    # The path may be spelled two ways in one file: `equinox_season_e0` binds
    # `let bin = "glow/bin/mod-clock"` and builds `-femit-bin=${bin}`, so a search for the literal
    # path finds only the binding line and never the build. Both spellings are asked, and a file
    # whose build names the VARIABLE is the worked example of the cure rather than a fault -- which
    # is the one accusation this scan most needed to not make.
    if { grep -F -- "$p" "$work/body.txt"
         [ "$v" = "-" ] || grep -F -- "\${$v}" "$work/body.txt"
       } | grep -qE 'build|emit-bin'; then
      built=1
      continue
    fi
    has_artifact=1
    break
  done < "$work/probed.txt"

  # A display precondition: the runner tests WAYLAND_DISPLAY for presence and asserts on it. Read
  # INDEPENDENTLY of the artifact reading rather than after it, because eight of this tree's
  # dependents carry both and a first-match classification would report the second kind as zero.
  if grep -qE 'test +x?\$\{?WAYLAND_DISPLAY|test +-n +"?\$\{?WAYLAND_DISPLAY' "$work/body.txt"; then
    has_display=1
  fi

  if [ "$has_artifact" -eq 1 ] || [ "$has_display" -eq 1 ]; then
    kind=artifact
    if [ "$has_artifact" -eq 1 ] && [ "$has_display" -eq 1 ]; then kind=both
    elif [ "$has_display" -eq 1 ]; then kind=display
    fi
    printf '%s\t%s\t%s\t%s\n' "$has_artifact" "$has_display" "$kind" "$f" >> "$work/dependents.txt"
  elif [ "$built" -eq 1 ]; then
    printf '%s\n' "$f" >> "$work/buildsown.txt"
  elif [ "$required" -gt 0 ]; then
    printf '%s\n' "$f" >> "$work/required.txt"
  fi
done < "$work/runners.txt"

dependents=$(wc -l < "$work/dependents.txt" | tr -d ' ')
# The two kinds OVERLAP on purpose: a runner wanting both a built binary and a screen is counted in
# both, and `dependents` stays the distinct population. Reading them as a partition is what made the
# display count read zero in this scan's first draft.
artifact_dependents=$(awk -F'\t' '$1 == 1' "$work/dependents.txt" | wc -l | tr -d ' ')
display_dependents=$(awk -F'\t' '$2 == 1' "$work/dependents.txt" | wc -l | tr -d ' ')
both_dependents=$(awk -F'\t' '$1 == 1 && $2 == 1' "$work/dependents.txt" | wc -l | tr -d ' ')
builds_own=$(wc -l < "$work/buildsown.txt" | tr -d ' ')
required_dependents=$(wc -l < "$work/required.txt" | tr -d ' ')

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
unrostered=0
: > "$work/report.txt"
while IFS="$(printf '\t')" read -r ha hd kind f; do
  line=$(awk -F'\t' -v want="$f" '$1 == want { print $2 }' "$work/roster.txt")
  if [ -z "$line" ]; then
    unrostered=$((unrostered + 1))
    printf 'unrostered\t%s\t%s\n' "$kind" "$f" >> "$work/report.txt"
  elif [ "$line" = "0" ]; then
    rostered_undeclared=$((rostered_undeclared + 1))
    printf 'undeclared\t%s\t%s\n' "$kind" "$f" >> "$work/report.txt"
  fi
done < "$work/dependents.txt"

# One word per kind, written once: the list mode said *a artifact* in its first draft, and a sentence
# a reader trips over is a sentence a reader stops reading.
phrase() {
  case "$1" in
    artifact) printf 'a built artifact it does not build' ;;
    display)  printf 'a screen' ;;
    both)     printf 'a built artifact it does not build, and a screen' ;;
  esac
}

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/report.txt" | while IFS="$(printf '\t')" read -r verd kind f; do
    case "$verd" in
      unrostered) printf 'unrostered: %s wants %s, and no roster row names it\n' "$f" "$(phrase "$kind")" ;;
      undeclared) printf 'undeclared: %s is rostered, wants %s, and names no capability\n' "$f" "$(phrase "$kind")" ;;
    esac
  done
fi

# THE PROBE. Static shape above, measured behavior here. `gitlink_dependent` learned this the hard
# way on `20260911`: its reading named a behavior nothing had ever run, and when the run came, 38 of
# 38 exited clean. A shape and a behavior are two populations, so this one asks.
probe_green=0
probe_red=0
probe_unread=0
if [ "$MODE" = probe ]; then
  # An instrument that cannot answer refuses. Without the runner every dependent would read `red`,
  # which is a bench fact wearing a finding's colour.
  if [ ! -x "$rishi" ] && ! command -v "$rishi" >/dev/null 2>&1; then
    echo "verdict=no_runner"
    echo "refused: the probe wants $rishi and this bench carries none" >&2
    exit 1
  fi
  probed=0
  : > "$work/probe.txt"
  while IFS="$(printf '\t')" read -r ha hd kind f; do
    [ "$probed" -lt "$MAX_PROBE" ] || break
    probed=$((probed + 1))
    # A dependent is probeable only where its precondition is actually UNMET here. A built artifact
    # standing on disk, or a display that is set, makes the absence unobservable -- and removing
    # either to look is the one move a meter may never make.
    unmet=no
    [ "$hd" -eq 1 ] && [ -z "${WAYLAND_DISPLAY:-}" ] && unmet=yes
    if [ "$ha" -eq 1 ]; then
        awk '
          /^[[:space:]]*#/    { next }
          /^[[:space:]]*\/\// { next }
          { print }
        ' "$f" > "$work/pbody.txt"
        # One pass, for the reason written at its twin above.
        awk '
          /^[[:space:]]*let [A-Za-z_][A-Za-z_0-9]* *= *"[^"]*"[[:space:]]*$/ {
            name = $2; line = $0
            sub(/^[^=]*= *"/, "", line); sub(/"[[:space:]]*$/, "", line)
            bind[name] = line
            next
          }
          {
            line = $0
            while (match(line, /run \["test" "-[xf]" ("[^"]+"|[A-Za-z_][A-Za-z_0-9]*)/)) {
              piece = substr(line, RSTART, RLENGTH)
              line = substr(line, RSTART + RLENGTH)
              sub(/^run \["test" "-[xf]" /, "", piece)
              if (piece ~ /^"/) { sub(/^"/, "", piece); sub(/"$/, "", piece); p = piece; v = "-" }
              else { p = bind[piece]; v = piece }
              if (p != "" && p !~ /\$/) print v "\t" p
            }
          }
        ' "$work/pbody.txt" | sort -u > "$work/pprobed.txt"
        while IFS="$(printf '\t')" read -r v p; do
          [ -n "$p" ] || continue
          grep -qxF "$p" "$work/tracked.txt" && continue
          case "$p" in vendor/*) continue ;; esac
          [ -e "$p" ] || unmet=yes
        done < "$work/pprobed.txt"
    fi
    if [ "$unmet" = no ]; then
      probe_unread=$((probe_unread + 1))
      printf 'unread\t%s\n' "$f" >> "$work/probe.txt"
      continue
    fi
    if "$rishi" run "$f" >/dev/null 2>&1; then
      probe_green=$((probe_green + 1))
      printf 'green\t%s\n' "$f" >> "$work/probe.txt"
    else
      probe_red=$((probe_red + 1))
      printf 'red\t%s\n' "$f" >> "$work/probe.txt"
    fi
  done < "$work/dependents.txt"
  # The per-dependent detail goes to STDERR and the counts to stdout, so a caller that captures the
  # reading gets a sayable card rather than forty lines. A hand at a terminal sees both streams.
  while IFS="$(printf '\t')" read -r verd f; do
    case "$verd" in
      green)  printf 'probe green: %s runs and exits clean with its precondition absent\n' "$f" >&2 ;;
      red)    printf 'probe RED: %s refuses over a precondition a correct checkout may lack\n' "$f" >&2 ;;
      unread) printf 'probe unread: %s wants a precondition this bench MEETS, so absence cannot be observed\n' "$f" >&2 ;;
    esac
  done < "$work/probe.txt"
fi

echo "runners=$runners"
echo "dependents=$dependents"
echo "artifact_dependents=$artifact_dependents"
echo "display_dependents=$display_dependents"
echo "both_dependents=$both_dependents"
echo "builds_own=$builds_own"
echo "required_dependents=$required_dependents"
echo "roster_present=$roster_present"
echo "rostered=$rostered"
echo "rostered_undeclared=$rostered_undeclared"
echo "unrostered=$unrostered"
if [ "$MODE" = probe ]; then
  echo "probe_green=$probe_green"
  echo "probe_red=$probe_red"
  echo "probe_unread=$probe_unread"
  echo "probe_ceiling=$probe_ceiling"
  if [ "$probe_red" -le "$probe_ceiling" ]; then echo "probe_under_ceiling=yes"; else echo "probe_under_ceiling=no"; fi
fi
if [ "$rostered_undeclared" -ne 0 ]; then
  echo "verdict=undeclared_precondition"
elif [ "$MODE" = probe ] && [ "$probe_red" -gt "$probe_ceiling" ]; then
  echo "verdict=probe_over_ceiling"
else
  echo "verdict=ok"
fi
