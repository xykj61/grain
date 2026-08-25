#!/bin/sh
# tools/fixtures/witness_reach_control.sh -- prove the reach meter from both sides, on planted repos.
#
# WHY. This meter's whole difficulty is telling a CALL from a MENTION, and the tree cannot show it
# the shapes it needs. A refusal proven only in the passing direction cannot be told from a bypass,
# so every reading below is planted in a throwaway git repository and asked the same question a real
# room asks. Three of the free readings reproduce sources that exist here and would otherwise be
# read wrong; two reproduce shapes this tree has never written and might tomorrow.
#
# WHAT IT PROVES -- thirty-one behaviors: nine calls heard, five mentions refused, four readings
# kept apart, seven band checks, three steps of one promotion, and the ceiling from three positions:
#
#   REFUSED (stays unheard)                       HEARD (counts as sung)
#   1  a path in a # comment                      1  run ["rishi/bin/rishi" "run" "<path>"]
#   2  a path as a grep argument                  2  run ["sh" "-c" "rishi/bin/rishi run <path>"]
#   3  a path inside a printed string             3  a choir's let ... = [ ... ] list literal
#   4  a path in a comment's usage line           4  sh <path> in a shell command position
#   5  an untracked file, never counted           5  a roster row, which also makes it standing
#                                                 6  a witness sung by a choir that is itself
#                                                    off the roster: sung yes, standing no
#                                                 7  a roster row at `tier cadence`, which is heard
#                                                    on the fifth lap: cadence yes, standing NO --
#                                                    proven both ways, since a cadence row read as
#                                                    standing would claim an every-lap promise the
#                                                    runner never makes
#                                                 8  a call after a ; separator
#                                                 9  a call inside $( ) substitution
#
#   AND THE BANDS, added 20260825.162410 with REDS %224, because the ceiling moved onto `unreached`.
#   Seven readings, each naming one thing a band must hold:
#
#     a witness sung only by an off-roster choir reads `unclocked`, never `unheard`
#     the same witness reads `unreached`, so the gate can see it
#     the off-roster choir itself reads `unreached` -- nothing names it either
#     a standing witness is never unreached; a cadence witness is never unreached
#     the bands partition: unreached == unclocked + unheard, counted
#     the identity holds: unreached == total - standing - cadence, counted
#
#   AND THE PROMOTION, in three steps, which is what the gate exists to require. Give the
#   off-roster choir a roster row, and its member leaves `unclocked` for `standing` while
#   `unreached` falls by exactly the two files that moved. Writing the choir alone moved nothing;
#   rostering it moved both. The count is the load-bearing step: the first cut of it read 7 -> 6 for
#   a promotion of two files, because its `git add -A` tracked the untracked plant sitting one
#   check above it and raised `total` by one. A control's own plants are state, and a step that
#   stages everything walks through them.
#
#   AND THE CEILING, from three positions, now on `unreached`: one past it must read
#   under_ceiling=no, exactly at it must read yes, and removing one plant must carry a refusing
#   reading back to green. A refusal proven only in the passing direction cannot be told from a
#   bypass. No override exists.
#
# USAGE
#   sh tools/fixtures/witness_reach_control.sh
#
# Driven by tools/w/witness_reach_witness.rish. Run from the repository root; it reads only the
# scan script from there and touches nothing else.

set -u

SCAN=$(cd "$(dirname "$0")" && pwd)/witness_reach_scan.sh
[ -r "$SCAN" ] || { echo "control_verdict=no_scan"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/witness-reach-control.XXXXXX") || exit 1
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
note() {
  if [ "$1" = ok ]; then pass=$((pass + 1)); echo "ok   $2"
  else fail=$((fail + 1)); echo "FAIL $2"; fi
}

cd "$PEN" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid
git config user.name control

mkdir -p tools/fixtures tools/w construction

# --- the plants -------------------------------------------------------------------------------
# Each witness below is named exactly once, in exactly one shape, so a reading names its own cause.

for n in called_direct called_dashc called_choir called_shell called_roster called_cadence \
         choir_only after_semi in_subst \
         mentioned_comment mentioned_grep mentioned_string mentioned_usage named_by_nobody; do
  echo "say \"$n\"" > "tools/w/${n}_witness.rish"
done

# A caller that makes five calls, each in a different shape the meter must hear.
cat > tools/w/caller_witness.rish <<'EOF'
let a = run ["rishi/bin/rishi" "run" "tools/w/called_direct_witness.rish"]
let b = run ["sh" "-c" "rishi/bin/rishi run tools/w/called_dashc_witness.rish 2>&1"]
let c = run ["sh" "tools/fixtures/caller_scan.sh"]
EOF

cat > tools/fixtures/caller_scan.sh <<'EOF'
sh tools/w/called_shell_witness.rish
echo hi ; rishi/bin/rishi run tools/w/after_semi_witness.rish
out=$(rishi/bin/rishi run tools/w/in_subst_witness.rish)
EOF

# A choir: it hands a VARIABLE to rishi run, so its list literal is sung.
cat > tools/w/choir_witness.rish <<'EOF'
let witnesses = [ "tools/w/called_choir_witness.rish" ]
for-each witnesses as w do assert (run ["rishi/bin/rishi" "run" w]).ok else "choir: red"
EOF

# A SECOND choir, itself named by nobody -- its member is sung, and neither is standing.
cat > tools/w/orphan_choir_witness.rish <<'EOF'
let witnesses = [ "tools/w/choir_only_witness.rish" ]
for-each witnesses as w do assert (run ["rishi/bin/rishi" "run" w]).ok else "orphan: red"
EOF

# The five mentions. Not one of these is a call, and each looked like one before it was read.
cat > tools/fixtures/mentions_scan.sh <<'EOF'
# a comment naming tools/w/mentioned_comment_witness.rish teaches; it does not call
#   rishi/bin/rishi run tools/w/mentioned_usage_witness.rish
grep -c say tools/w/mentioned_grep_witness.rish
echo "**Ran:** \`rishi/bin/rishi run tools/w/mentioned_string_witness.rish\`"
EOF

# The roster: one row, which the runner invokes, so that witness is standing.
cat > construction/standing-equipment.kyri <<'EOF'
format standing-equipment-v1
guard caller
path tools/w/caller_witness.rish
guard choir
path tools/w/choir_witness.rish
guard mentions
path tools/fixtures/mentions_scan.sh
guard called_roster
path tools/w/called_roster_witness.rish
tier lap
guard called_cadence
path tools/w/called_cadence_witness.rish
tier cadence
EOF

git add -A >/dev/null 2>&1
git commit -qm plant >/dev/null 2>&1

# Planted AFTER the commit, so git ls-files never sees it.
echo 'say "untracked"' > tools/w/untracked_two_witness.rish

read_field() { echo "$1" | sed -n "s/.*[[:space:]]$2=\([^[:space:]]*\).*/\1/p"; }

out=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" 2>/dev/null)
sung=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --sung 2>/dev/null | awk '{print $2}')
standing=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --standing 2>/dev/null | awk '{print $2}')
cadence=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --cadence 2>/dev/null | awk '{print $2}')
unheard=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --list 2>/dev/null | awk '{print $2}')
unclocked=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --unclocked 2>/dev/null | awk '{print $2}')
unreached=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --unreached 2>/dev/null | awk '{print $2}')

echo "$out"

is_in() { echo "$2" | grep -qx "tools/w/$1_witness.rish"; }

# HEARD -- eight call shapes
for n in called_direct called_dashc called_choir called_shell called_roster called_cadence choir_only after_semi in_subst; do
  if is_in "$n" "$sung"; then note ok "heard: $n"; else note no "heard: $n"; fi
done

# REFUSED -- four mention shapes stay unheard
for n in mentioned_comment mentioned_grep mentioned_string mentioned_usage; do
  if is_in "$n" "$unheard"; then note ok "refused: $n"; else note no "refused: $n"; fi
done

# REFUSED -- an untracked file is never counted at all, in either column
if ! echo "$sung$unheard" | grep -q untracked_two; then note ok "refused: untracked_two never counted"
else note no "refused: untracked_two never counted"; fi

# The distinction the meter exists for: sung by an orphan choir, yet not standing.
if is_in choir_only "$sung" && ! is_in choir_only "$standing"; then
  note ok "sung yet not standing: choir_only"
else note no "sung yet not standing: choir_only"; fi

# A roster row makes its witness standing.
if is_in called_roster "$standing"; then note ok "standing: called_roster"
else note no "standing: called_roster"; fi

# A cadence row is heard, and is NOT standing. Both halves, because a tier read as an every-lap
# promise would report a guard as sung each lap on the strength of a row that runs once in five.
if is_in called_cadence "$cadence"; then note ok "cadence: called_cadence"
else note no "cadence: called_cadence"; fi
if ! is_in called_cadence "$standing"; then note ok "cadence is not standing: called_cadence"
else note no "cadence is not standing: called_cadence"; fi

# THE BANDS (REDS %224). The gate moved onto `unreached`, so each band is read for what it holds
# and the whole set is checked to partition -- a band nobody counts is a band that can drift.
if is_in choir_only "$unclocked" && ! is_in choir_only "$unheard"; then
  note ok "unclocked: choir_only is named, and by nobody the roster reaches"
else note no "unclocked: choir_only is named, and by nobody the roster reaches"; fi

if is_in choir_only "$unreached"; then note ok "unreached: carries choir_only"
else note no "unreached: carries choir_only"; fi

if echo "$unreached" | grep -qx "tools/w/orphan_choir_witness.rish"; then
  note ok "unreached: carries the off-roster choir itself"
else note no "unreached: carries the off-roster choir itself"; fi

if ! is_in called_roster "$unreached"; then note ok "unreached: never a standing witness"
else note no "unreached: never a standing witness"; fi

if ! is_in called_cadence "$unreached"; then note ok "unreached: never a cadence witness"
else note no "unreached: never a cadence witness"; fi

# The partition and the identity, counted rather than reasoned about.
count() { echo "$1" | grep -c . ; }
if [ "$(read_field "$out" unreached)" -eq $(( $(read_field "$out" unclocked) + $(read_field "$out" unheard) )) ]; then
  note ok "bands partition: unreached == unclocked + unheard"
else note no "bands partition: unreached == unclocked + unheard"; fi

if [ "$(read_field "$out" unreached)" -eq $(( $(read_field "$out" total) - $(read_field "$out" standing) - $(read_field "$out" cadence) )) ]; then
  note ok "identity: unreached == total - standing - cadence"
else note no "identity: unreached == total - standing - cadence"; fi

# THE PROMOTION. Writing the orphan choir moved nothing; giving it a roster row must move both it
# and its member out of `unreached` and carry the member into `standing`. This is the whole reason
# the gate sits where it now sits, so it is proven by doing rather than by argument.
before_unreached=$(read_field "$out" unreached)
cat >> construction/standing-equipment.kyri <<'EOF'
guard orphan_choir
path tools/w/orphan_choir_witness.rish
EOF
# Only the roster moves. `git add -A` here would sweep in tools/w/untracked_two_witness.rish, which
# is planted after the first commit precisely to stay untracked -- and tracking it raises `total`
# by one, so this reading came back 7 -> 6 for a promotion that genuinely moved two files.
git add construction/standing-equipment.kyri >/dev/null 2>&1
git commit -qm roster-the-orphan >/dev/null 2>&1

after=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" 2>/dev/null)
after_standing=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --standing 2>/dev/null | awk '{print $2}')
after_unclocked=$(WITNESS_REACH_CEILING=9999 sh "$SCAN" --unclocked 2>/dev/null | awk '{print $2}')

if is_in choir_only "$after_standing"; then note ok "promotion: rostering the choir makes its member standing"
else note no "promotion: rostering the choir makes its member standing"; fi

if ! is_in choir_only "$after_unclocked"; then note ok "promotion: the member leaves unclocked"
else note no "promotion: the member leaves unclocked"; fi

after_unreached=$(read_field "$after" unreached)
if [ "$after_unreached" -eq $((before_unreached - 2)) ]; then
  note ok "promotion: unreached falls by exactly the two files that moved"
else note no "promotion: unreached falls by exactly the two files that moved -- ${before_unreached} -> ${after_unreached}"; fi

# THE CEILING, FROM BOTH SIDES, on the gated number as it now stands.
u=$(read_field "$after" unreached)
tight=$((u - 1))
over=$(WITNESS_REACH_CEILING=$tight sh "$SCAN" 2>/dev/null)
if [ "$(read_field "$over" under_ceiling)" = no ]; then note ok "ceiling: one past it refuses"
else note no "ceiling: one past it refuses"; fi

exact=$(WITNESS_REACH_CEILING=$u sh "$SCAN" 2>/dev/null)
if [ "$(read_field "$exact" under_ceiling)" = yes ]; then note ok "ceiling: exactly at it passes"
else note no "ceiling: exactly at it passes"; fi

# Remove one unreached plant and the same tight ceiling must return to green -- the other side.
git rm -q -f tools/w/mentioned_comment_witness.rish >/dev/null 2>&1
git commit -qm remove >/dev/null 2>&1
back=$(WITNESS_REACH_CEILING=$tight sh "$SCAN" 2>/dev/null)
if [ "$(read_field "$back" under_ceiling)" = yes ]; then note ok "ceiling: removing the plant returns green"
else note no "ceiling: removing the plant returns green"; fi

echo "control_pass=$pass control_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
