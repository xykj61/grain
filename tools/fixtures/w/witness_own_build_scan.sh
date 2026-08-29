#!/bin/sh
# tools/fixtures/w/witness_own_build_scan.sh -- a witness builds what it runs, or it proves nothing
# on a clone.
#
# WHY. comlink/bin/ is gitignored (.gitignore:185), so a fresh clone carries no Comlink binary at
# all. tools/co/comlink_handshake_turn_witness.rish and tools/co/comlink_turn_route_witness.rish
# each named their build in a HEADER COMMENT -- "Build first:  rye build ..." -- and then invoked
# the path directly with `run ["comlink/bin/handshake-turn" "selftest"]`. A comment builds nothing.
# On this pier both passed, because a lap in August left binaries behind; on a clone both died on a
# missing file rather than on a handshake fact.
#
# Their sibling tools/co/comlink_topology_witness.rish already carries the repair, and its own
# comment records the same discovery in this tree's words: "on any clone without that build it died
# with a bare CommandFailed naming no cause -- a refusal a reader cannot act on is the fault this
# tree calls a guard that guards nothing." One of three was repaired; the other two were left, and
# nothing counted them. This is the meter that counts them.
#
# WHAT IS READ. Every tracked *_witness.rish, for paths in DIRECT invocation position -- the first
# quoted element of a `run [ ... ]` array, on a non-comment line. For each such path that GIT ITSELF
# ignores, the witness is asked whether it also carries a build naming that artifact on a
# non-comment line of its own.
#
#   witnesses            every tracked *_witness.rish on disk
#   invoked_ignored      (witness, artifact) pairs where the artifact is a path git ignores
#   self_built           of those, the pairs whose witness builds the artifact itself
#   delegated_built      of the rest, the pairs whose witness RUNS a tracked script that builds the
#                        artifact -- one hop, and only one. Counted apart from self_built rather
#                        than folded into it: a delegated build is a real build resting on a second
#                        file staying honest, and one number for both would hide which promise a
#                        witness actually makes.
#   unbuilt_pairs        the rest. THIS IS THE RATCHETED NUMBER, under a ceiling that only falls
#   unbuilt_witnesses    distinct witnesses in the unbuilt set, reported
#   absent_now           unbuilt artifacts missing from THIS filesystem right now, reported and
#                        never gated: it is a fact about one machine, and a machine that has been
#                        building for weeks reads lower than a clone. Gating it would make the
#                        guard answer differently on two honest trees.
#   built_elsewhere      unbuilt artifacts some OTHER tracked file builds -- a file this witness
#                        does NOT run, since one it does run is counted as delegated above.
#                        Reported. A build kept by a stranger is real, and it is still not the
#                        promise a witness makes: every one of these headers tells a reader to run
#                        the witness directly.
#
# WHAT PASSES FREE, by named rule.
#   rishi/bin/rishi and rye/bin/rye -- the interpreter running the witness and the compiler that
#     builds everything else. If either is absent nothing runs at all, so their presence is a
#     bootstrap fact (SOURCE.md) rather than a promise any single witness makes.
#   vendor/** -- submodules and the toolchain, provisioned by `git submodule update` and the
#     toolchain fetch. The same rule tools/fixtures/p/phantom_path_scan.sh keeps, for the same reason.
#   A path the repository TRACKS. The clone carries it, so nobody has to build it.
#   COMMENT lines, on both sides. A comment naming a build is documentation, and the gap between
#     documentation and a build is exactly the defect this scan reads.
#
# THE HONEST LIMIT. Only a DIRECT invocation is read -- `run ["path" ...]`. A binary reached through
# `run ["sh" "-c" "... path ..."]` is invisible here, and so is one a suite builds before calling
# this witness. Both are named rather than guessed: `built_elsewhere` reports the second, and the
# first is left to the reader. A narrow reading that is exactly right beats a wide one that argues.
#
# THE LIMIT THAT RAN THE OTHER WAY. Under-counting is safe -- a defect this scan cannot see is a
# defect left standing. Over-counting is not, and on 20260829 this reading was doing both. Five Pond
# ring witnesses build pond/bin/drawn-terminal by running tools/fixtures/p/pond_build_drawn_terminal.sh,
# and five Glow witnesses build their gate binary by running tools/g/glow_run_worker.sh -- each
# script tracked, each named in the witness's own `run [ ... ]` line, each carrying a real build.
# All ten were counted as defects, and they were UNREPAIRABLE ones: the only edit that satisfies a
# basename grep is a second build line beside a build that already runs. Ten of fourteen entries sat
# under a ratchet that could never reach zero, and a ratchet whose population nobody can repair has
# stopped being a ratchet and become a floor.
#
# The sharpest reading was inside one file. tools/p/pond_ring_drawn_terminal_witness.rish builds
# pond/bin/customs INLINE at its line 23 and pond/bin/drawn-terminal BY FIXTURE at its line 27, and
# the scan credited the first and faulted the second, on one run, for one witness.
#
# THE HOP, IN ONE SENTENCE. A build the witness CAUSES is a build the witness makes: the witness
# runs a tracked script, the script carries a build line, and the script names the artifact. Three
# strict conditions and no loose one, because a fourth reading -- the artifact named in the
# witness's own arguments -- credits nearly every pair once you notice that the invocation line
# names it too. Both real families satisfy the three: the Pond fixture assigns
# BIN="pond/bin/drawn-terminal", and the Glow worker lists all 56 of its gate stems in one case
# pattern.
#
# ITS OWN LIMIT, named rather than guessed. One hop, so a build two scripts deep is invisible. And
# a truly generic builder that never spells its targets is invisible too -- a real shape, and one
# no grep can tell from a helper that merely runs something. Both stay uncounted rather than
# credited on a resemblance, which is the same discipline as THE HONEST LIMIT above, kept in the
# other direction.
#
# USAGE
#   sh tools/fixtures/w/witness_own_build_scan.sh
#   sh tools/fixtures/w/witness_own_build_scan.sh --list    # the unbuilt pairs, one per line
#
# Driven by tools/w/witness_own_build_witness.rish. Run from the repository root.

set -eu

# WHY THIS NUMBER. 19 is the reading on 20260829 after Sundial's witness took its own build. The
# prior reading was 20 after Kumara's bind witness took its own build, and 21 after Amphora's eight
# witnesses took their own
# builds -- pour, pour_negative, carry, carry_negative, restore, restore_negative, grand_round and
# first_resident, seventeen pairs over amphora/bin/{amphora,vessel-core,vessel-seal}, every one
# GREEN from an emptied amphora/bin/.
#
# THAT REPAIR IS WIDER THAN THIS READING, and the gap is worth naming here rather than rediscovering.
# Patching each witness to build only the artifacts THIS SCAN lists left four of the eight still
# dead on an emptied bin: they name `amphora` alone in run position, and amphora/src/main.rye:138
# and :176 resolve vessel-seal and vessel-core as SIBLING SUBPROCESSES at runtime. So a witness can
# satisfy this meter exactly and still die on a clone. The reading is a floor on the promise rather
# than the whole of it -- see THE HONEST LIMIT above, which says the same thing from the other side.
# All eight carry all three builds now, and each was proven alone from a wiped directory.
#
# A SECOND GAP, measured the same way: rye build refuses an absent -femit-bin directory with
# "unable to open output directory", so every build line makes amphora/bin/ first. The line already
# standing in amphora_first_resident_witness.rish lacked that mkdir and would have failed on a
# clone even though the scan credited it.
#
# THE ELDER READINGS, kept so the fall stays followable. 38 was the reading earlier on 20260829,
# after Mandate's seven witnesses took the
# build their Comlink sibling already carried -- store, serve, bucket, wal, keyed, named_serve
# and comlink_serve, every one GREEN from an emptied mandate/bin/. Seven repairs and one
# rename: amphora_dogfood_witness left the tree carrying three pairs and
# amphora_first_resident_witness arrived carrying two, so 46 fell to 38 rather than to 39.
# It read 46 on 20260828 and 48 before the two Comlink witnesses. It only ever falls: a
# witness repaired lowers it, and a new witness invoking an unbuilt artifact raises it past
# the ceiling on the lap it arrives.
CEILING=0
# AND WHY IT FELL THE LAST FOUR. 0 is the reading on 20260829 once Kumara's contact, Settlement's
# constellation and names, and the nakshatra seat each took the build their Comlink sibling
# already carried. Every one was proven from an ABSENT artifact rather than from a bench that
# had been building for weeks -- all four were missing on the macOS clone this repair ran on,
# which is the machine state the meter was written about. The reading is now a WALL rather
# than a ratchet: a witness invoking a path the repository declines to carry reds on the lap
# it arrives, and there is no population left to grandfather.
# AND WHY IT FELL TEN IN ONE LAP WITHOUT A WITNESS BEING TOUCHED. 4 is the reading on 20260829 once
# this scan learned to follow ONE HOP. Ten of the fourteen it had been counting were honest -- five
# Pond ring witnesses and five Glow witnesses, each building through a tracked script it runs -- and
# the four that remain are real: Kumara's contact, Settlement's constellation and names, and the
# nakshatra seat. Every one of those four artifacts is PRESENT on this pier, which is the whole
# reason the meter exists: they read green here and die on a clone.

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: not inside a git repository" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

git ls-files > "$pen/tracked"
grep -E '_witness\.rish$' "$pen/tracked" > "$pen/wits" || : > "$pen/wits"
witnesses=$(wc -l < "$pen/wits" | tr -d ' ')
grep -E '^tools/.*\.(rish|sh)$' "$pen/tracked" > "$pen/runners" || : > "$pen/runners"

# The first quoted element of each `run [ ... ]`, on a non-comment line, when it looks like a path.
# One awk over the whole population: 1,729 interpreter starts cost more than the reading does.
: > "$pen/pairs"
if [ -s "$pen/wits" ]; then
  xargs awk '
    FNR == 1 { F = FILENAME }
    /^[[:space:]]*#/ { next }
    {
      s = $0
      while (match(s, /run[[:space:]]*\[[[:space:]]*"[^"]+"/)) {
        seg = substr(s, RSTART, RLENGTH); s = substr(s, RSTART + RLENGTH)
        if (match(seg, /"[^"]+"/)) {
          t = substr(seg, RSTART + 1, RLENGTH - 2)
          sub(/^\.\//, "", t)
          if (t ~ /\//) print F "\t" t
        }
      }
    }' < "$pen/wits" | sort -u > "$pen/pairs"
fi

# Ask git which artifacts it ignores, in one batch rather than one call per token.
cut -f2 "$pen/pairs" | sort -u > "$pen/toks"
git check-ignore --stdin < "$pen/toks" > "$pen/ignored" 2>/dev/null || :

# A READING OF ZERO IS A BROKEN READING, not a clean tree. This scan printed verdict=ok over an
# empty extraction on 20260828, because `xargs -a` is a GNU flag and this bench carries a BSD
# xargs: the pipeline died, every count read 0, and the guard passed. A guard reading nothing
# passes as readily as a guard reading everything, so the empty case refuses instead.
path_tokens=$(wc -l < "$pen/toks" | tr -d ' ')
if [ "$witnesses" -gt 0 ] && [ "$path_tokens" -eq 0 ]; then
  echo "verdict=extraction_empty"
  echo "refused: $witnesses witnesses and not one invoked path -- the reading is broken" >&2
  exit 1
fi

: > "$pen/invoked"
while IFS="$(printf '\t')" read -r w tok; do
  [ -n "${tok:-}" ] || continue
  case "$tok" in
    rishi/bin/rishi|rye/bin/rye) continue ;;
    vendor/*) continue ;;
  esac
  grep -qxF -- "$tok" "$pen/tracked" && continue
  grep -qxF -- "$tok" "$pen/ignored" || continue
  printf '%s\t%s\n' "$w" "$tok" >> "$pen/invoked"
done < "$pen/pairs"
invoked=$(sort -u "$pen/invoked" | wc -l | tr -d ' ')

# max_delegates bounds the helper scripts one witness may hand work to before this reading stops
# following. The widest witness in the tree hands work to two, so sixteen leaves room for a witness
# to quadruple its helpers twice while keeping a generated file from walking this loop unbounded.
max_delegates=16

# delegated_build <witness> <artifact> -- true when the witness RUNS a tracked tools/ script that
# carries a real build line and names this artifact in its own non-comment text. A witness is never
# its own delegate, or a witness building one artifact would credit itself for every other. Every
# branch is an explicit if: this function is called from a condition, where a bare `test && act`
# carries its own failure out under set -e.
delegated_build() {
  _w=$1; _base=$(basename "$2")
  grep -v '^[[:space:]]*#' "$_w" | grep -E 'run[[:space:]]*\[' > "$pen/runlines" 2>/dev/null || return 1
  grep -oE 'tools/[A-Za-z0-9_./-]*\.(rish|sh)' "$pen/runlines" \
    | sort -u | head -n "$max_delegates" > "$pen/hops" 2>/dev/null || return 1
  while read -r _s; do
    if [ -z "${_s:-}" ]; then continue; fi
    if [ "$_s" = "$_w" ]; then continue; fi
    grep -qxF -- "$_s" "$pen/tracked" || continue
    [ -f "$_s" ] || continue
    grep -v '^[[:space:]]*#' "$_s" > "$pen/dbody" 2>/dev/null || continue
    grep -qE "(rye build|zig build|emit-bin)" "$pen/dbody" || continue
    if grep -qF -- "$_base" "$pen/dbody"; then return 0; fi
  done < "$pen/hops"
  return 1
}

: > "$pen/unbuilt"; : > "$pen/self"; : > "$pen/delegated"
while IFS="$(printf '\t')" read -r w tok; do
  [ -n "${tok:-}" ] || continue
  grep -v '^[[:space:]]*#' "$w" | grep -E "(rye build|zig build|emit-bin)" > "$pen/bl" 2>/dev/null || : > "$pen/bl"
  if grep -qF -- "$(basename "$tok")" "$pen/bl"; then
    printf '%s\t%s\n' "$w" "$tok" >> "$pen/self"
  elif delegated_build "$w" "$tok"; then
    printf '%s\t%s\n' "$w" "$tok" >> "$pen/delegated"
  else
    printf '%s\t%s\n' "$w" "$tok" >> "$pen/unbuilt"
  fi
done < "$pen/invoked"

sort -u "$pen/unbuilt" > "$pen/unbuilt.s"; mv "$pen/unbuilt.s" "$pen/unbuilt"
self_built=$(sort -u "$pen/self" | wc -l | tr -d ' ')
delegated_built=$(sort -u "$pen/delegated" | wc -l | tr -d ' ')
unbuilt=$(wc -l < "$pen/unbuilt" | tr -d ' ')
unbuilt_witnesses=$(cut -f1 "$pen/unbuilt" | sort -u | wc -l | tr -d ' ')

absent=0
cut -f2 "$pen/unbuilt" | sort -u > "$pen/targets"
while IFS= read -r t; do
  [ -n "$t" ] || continue
  [ -e "$t" ] || absent=$((absent + 1))
done < "$pen/targets"

# built_elsewhere: some OTHER tracked runner carries a build for this artifact. Real, and still not
# the promise the witness itself makes -- reported so the number is visible rather than argued.
# Every build line in the tree is collected once; asking per target would be a grep per pair.
elsewhere=0
xargs grep -hv '^[[:space:]]*#' < "$pen/runners" 2>/dev/null \
  | grep -E "(rye build|zig build|emit-bin)" > "$pen/buildlines" 2>/dev/null || : > "$pen/buildlines"
while IFS= read -r t; do
  [ -n "$t" ] || continue
  grep -qF -- "$(basename "$t")" "$pen/buildlines" && elsewhere=$((elsewhere + 1))
done < "$pen/targets"

if [ "${1:-}" = "--list" ]; then cat "$pen/unbuilt"; fi

echo "witnesses=$witnesses"
echo "invoked_ignored=$invoked"
echo "self_built=$self_built"
echo "delegated_built=$delegated_built"
echo "unbuilt_pairs=$unbuilt ceiling=$CEILING"
echo "unbuilt_witnesses=$unbuilt_witnesses"
echo "absent_now=$absent"
echo "built_elsewhere=$elsewhere"
if [ "$unbuilt" -le "$CEILING" ]; then
  echo "verdict=ok"
else
  echo "verdict=witness_without_build"
  exit 1
fi
