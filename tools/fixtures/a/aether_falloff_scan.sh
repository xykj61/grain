#!/bin/sh
# tools/fixtures/a/aether_falloff_scan.sh -- does the standing roster have a gradient to fall off?
#
# WHAT THIS ANSWERS. Row 4 of active-designing/20260910-060204_the-bounded-torus-moonshots.md
# proposes an "aether as falloff field": wake only the roster rows within path-distance R of a
# touched row, intensity falling with distance. Its own falsifier reads -- the woken set at any
# useful R covers most of the roster, which would show the roster is dense and a radius buys the
# same work under a new name. That falsifier names a measurement nobody had taken, and this takes
# it: the woken count as a function of R, over the paths real commits actually changed.
#
# THE COORDINATE, AND WHERE IT STOPS. A falloff field grades a DISTANCE, so the roster must carry
# one. The only coordinate this tree owns is the filesystem path tree, read through
# tools/fixtures/s/standing_equipment_scope_map.sh: each mapped guard's watch words anchor it to
# directories, and the distance between two directories is the number of hops up to their common
# ancestor and back down. A guard the map leaves out carries NO coordinate at all, and the map's
# own ABSENCE rule runs it on every pass -- so it wakes at every radius including zero. That set is
# the FLOOR, and it is reported first, because a floor covering most of the roster answers row 4's
# falsifier before any radius is chosen.
#
# WHY DISTANCE RATHER THAN REACH. tools/fixtures/s/standing_equipment_scope_rank.sh already prices
# the BINARY question -- does this watch-set reach this path -- and ranks the rows worth writing
# next. Two instruments over one population is the waste this tree names, so this one asks only
# what that one cannot: whether the reach is GRADED. Read them together; the cost figures live
# there, and this file spends none of its own on them.
#
# THE ANCHOR RULE, spelled once. A word ending in `/` anchors to its own room. Every other word
# anchors to the deepest leading directory holding no glob character, which is the deepest
# directory the word is certainly inside -- `tools/*/ales_*_witness.rish` anchors at `tools`,
# `tools/fixtures/s/scope_match.sh` at `tools/fixtures/s`, and a bare `README.md` at the root.
# The anchor is a FLOOR on depth rather than a guess: widening it would only ever shrink a
# distance, so every distance printed here is an upper bound on the true one.
#
# WHAT IT PRINTS. Population counts; the floor share; the mean woken count at each radius from 0
# to the bound; and the smallest radius at which the mapped guards themselves saturate.
#
# Run from anywhere -- the root is found by upward walk:
#   sh tools/fixtures/a/aether_falloff_scan.sh [--window N] [--radius N] [--list]

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

# BOUNDS, each named and checked at the edge (TAME). The window is the one that matters: the walk
# is commits times mapped rows times that commit's paths, so an unbounded window is an unbounded
# run. The radius bound is smaller than any tree depth this repository holds, so a curve that has
# not saturated by then has genuinely not saturated.
max_window=500
max_radius=12
max_guards=1024
max_paths=4096

window=40
radius=8
want_list=no
while [ $# -gt 0 ]; do
  case "$1" in
    --window) window=${2:-}; shift 2 ;;
    --radius) radius=${2:-}; shift 2 ;;
    --list)   want_list=yes; shift ;;
    *) echo "refused: unknown argument '$1' -- takes --window N, --radius N, --list" >&2; exit 2 ;;
  esac
done
case "$window" in ''|*[!0-9]*) echo "refused: --window wants a whole number of commits" >&2; exit 2 ;; esac
case "$radius" in ''|*[!0-9]*) echo "refused: --radius wants a whole number of hops" >&2; exit 2 ;; esac
[ "$window" -ge 1 ] && [ "$window" -le "$max_window" ] \
  || { echo "refused: --window $window outside 1..$max_window" >&2; exit 2; }
[ "$radius" -ge 0 ] && [ "$radius" -le "$max_radius" ] \
  || { echo "refused: --radius $radius outside 0..$max_radius" >&2; exit 2; }

cd "$_fd_root"

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
scope_map="${STANDING_SCOPE_MAP:-tools/fixtures/s/standing_equipment_scope_map.sh}"

[ -f "$roster" ] || { echo "refused: no roster at $roster" >&2; exit 1; }
[ -f "$scope_map" ] || { echo "refused: no scope map at $scope_map" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

# --- the population: one line per seated guard ---------------------------------------------------
awk '$1 == "guard" { print $2 }' "$roster" | sort -u > "$pen/roster"
guards=$(grep -c . "$pen/roster" || true)
[ "$guards" -ge 1 ] || { echo "refused: the roster seats no guards" >&2; exit 1; }
[ "$guards" -le "$max_guards" ] \
  || { echo "refused: roster names $guards guards, past the bound of $max_guards" >&2; exit 1; }

# --- the map: run rather than read, for the build edge its rows share ----------------------------
sh "$scope_map" > "$pen/mapraw" || { echo "refused: the scope map fixture failed" >&2; exit 1; }

# A row whose guard the roster never seated buys nothing here and is read past, exactly as the
# runner reads it past; standing_equipment_scope_rank.sh is the instrument that GATES that fault,
# and duplicating its gate would be a second reading of one law.
awk '
  NR == FNR { seated[$1] = 1; next }
  { if (!($1 in seated)) next; print }
' "$pen/roster" "$pen/mapraw" > "$pen/map"

discovery=$(awk '$2 == "DISCOVERY" { n++ } END { print n + 0 }' "$pen/map")
mapped=$(awk '$2 != "DISCOVERY" { n++ } END { print n + 0 }' "$pen/map")
absent=$((guards - mapped - discovery))

# --- the anchors: one line per mapped guard, its name and one anchor directory --------------------
awk '
  function anchor(w,   parts, n, i, out, comp) {
    if (w ~ /\/$/) { sub(/\/+$/, "", w); return (w == "" ? "." : w) }
    n = split(w, parts, "/")
    out = ""
    # Stop at the first component carrying a glob, and drop the final component always: a word
    # naming a file anchors to the directory holding it.
    for (i = 1; i < n; i++) {
      comp = parts[i]
      if (comp ~ /[*?[]/) break
      out = (out == "" ? comp : out "/" comp)
    }
    return (out == "" ? "." : out)
  }
  $2 == "DISCOVERY" { next }
  {
    name = $1
    for (i = 2; i <= NF; i++) print name "\t" anchor($i)
  }
' "$pen/map" | sort -u > "$pen/anchors"

# --- the window: which paths each recent commit changed ------------------------------------------
git -c core.quotePath=false log --no-merges -n "$window" --format='%x01%H' --name-only \
  > "$pen/log" 2>/dev/null || : > "$pen/log"
commits_read=$(awk '/^\001/ { c++ } END { print c + 0 }' "$pen/log")
[ "$commits_read" -ge 1 ] || { echo "refused: the window read no commits" >&2; exit 1; }
awk -v cap="$max_paths" '
  /^\001/ { n++; seen = 0; next }
  NF {
    if (n == 0) next
    seen++
    if (seen > cap) next
    print n "\t" $0
  }
' "$pen/log" | sort -u > "$pen/commitpaths"
paths_unique=$(cut -f2 "$pen/commitpaths" | sort -u | grep -c . || true)

# --- the curve -----------------------------------------------------------------------------------
# For each commit, each mapped guard's distance is the minimum over its anchors and that commit's
# changed directories. The histogram is over commits, so the printed count is a mean per commit
# rather than a total -- a total would grow with the window and say nothing about one change.
awk -v radius="$radius" -v commits="$commits_read" -v mapped="$mapped" \
    -v floor_count="$((absent + discovery))" -v guards="$guards" -v want_list="$want_list" '
  function depth(d,   parts) { return (d == "." ? 0 : split(d, parts, "/")) }
  function dist(a, b,   pa, pb, na, nb, i, common) {
    if (a == b) return 0
    na = (a == "." ? 0 : split(a, pa, "/"))
    nb = (b == "." ? 0 : split(b, pb, "/"))
    common = 0
    for (i = 1; i <= na && i <= nb; i++) {
      if (pa[i] != pb[i]) break
      common++
    }
    return (na - common) + (nb - common)
  }
  function dirof(p,   i) { i = length(p); while (i > 0 && substr(p, i, 1) != "/") i--; \
                           return (i == 0 ? "." : substr(p, 1, i - 1)) }

  FILENAME == anchorfile {
    g = $1; a = $2
    an[g, ++ancount[g]] = a
    if (!(g in ancount_seen)) { ancount_seen[g] = 1; guardname[++gn] = g }
    next
  }
  {
    c = $1
    d = dirof($2)
    if (!((c SUBSEP d) in seendir)) { seendir[c, d] = 1; cdir[c, ++cdn[c]] = d; if (!(c in cseen)) { cseen[c] = 1; cn++ } }
  }
  END {
    for (ci in cseen) {
      for (gi = 1; gi <= gn; gi++) {
        g = guardname[gi]
        best = -1
        for (ai = 1; ai <= ancount[g]; ai++) {
          for (di = 1; di <= cdn[ci]; di++) {
            v = dist(an[g, ai], cdir[ci, di])
            if (best < 0 || v < best) best = v
            if (best == 0) break
          }
          if (best == 0) break
        }
        if (best < 0) continue
        if (best > radius) best = radius + 1
        hist[best]++
        if (want_list == "yes") sum[g] += best
      }
    }
    printf "commits_walked=%d\n", cn
    cum = 0
    for (r = 0; r <= radius; r++) {
      cum += hist[r] + 0
      mean_mapped = (cn > 0 ? cum / cn : 0)
      woken = mean_mapped + floor_count
      printf "woken_r%d_mapped=%.2f woken_r%d_total=%.2f woken_r%d_share=%.3f\n", \
        r, mean_mapped, r, woken, r, (guards > 0 ? woken / guards : 0)
      if (sat == "" && mapped > 0 && mean_mapped / mapped >= 0.8) sat = r
    }
    printf "mapped_saturation_radius=%s\n", (sat == "" ? "none_within_bound" : sat)
    if (want_list == "yes") {
      for (gi = 1; gi <= gn; gi++) {
        g = guardname[gi]
        printf "mean_distance %s %.2f\n", g, (cn > 0 ? sum[g] / cn : 0)
      }
    }
  }
' anchorfile="$pen/anchors" "$pen/anchors" "$pen/commitpaths" > "$pen/curve"

printf 'guards_total=%d\n' "$guards"
printf 'mapped=%d\n' "$mapped"
printf 'discovery=%d\n' "$discovery"
printf 'absent=%d\n' "$absent"
printf 'floor_count=%d\n' "$((absent + discovery))"
awk -v f="$((absent + discovery))" -v g="$guards" 'BEGIN { printf "floor_share=%.3f\n", (g > 0 ? f / g : 0) }'
printf 'window_commits=%d\n' "$commits_read"
printf 'paths_unique=%d\n' "$paths_unique"
printf 'radius_bound=%d\n' "$radius"
cat "$pen/curve"
echo "verdict=ok"
