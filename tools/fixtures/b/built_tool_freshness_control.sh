#!/bin/sh
# tools/fixtures/b/built_tool_freshness_control.sh -- prove the freshness reading by doing, on
# real repositories with real files and real modification times.
#
# WHY. A guard that cannot red guards nothing (REDS %59). This control builds git repositories in
# a temporary pen, plants one condition in each, runs
# tools/fixtures/b/built_tool_freshness_scan.sh inside them, and checks that the refusals bite and
# the honest readings stay free. Nothing here touches the tree it is run from.
#
# Every refusal is shown from BOTH sides -- planted, then lifted -- because a refusal proven only
# in the failing direction cannot be told from a scan that refuses everything.
#
# USAGE
#   sh tools/fixtures/b/built_tool_freshness_control.sh
#
# Driven by tools/b/built_tool_freshness_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/b/built_tool_freshness_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = yes ]; then echo "$1=yes"; else echo "$1=no"; failed=$((failed + 1)); fi
}
saw() { echo "$1" | grep -q "$2" && echo yes || echo no; }

# A repository carrying both modules: tracked sources, and binaries in the gitignored bin rooms.
# `age` seconds in the past is where each file's mtime is set, so ordering is exact rather than
# dependent on how fast this pen builds.
build() {
  name=$1
  d=$pen/$name
  mkdir -p "$d/rye/src" "$d/rye/bin" "$d/rishi/src" "$d/rishi/bin"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf 'pub fn main() void {}\n' > rye/src/main.rye \
    && printf 'pub fn main() void {}\n' > rishi/src/main.rye \
    && printf 'rye/bin/\nrishi/bin/\n' > .gitignore \
    && git add -A \
    && git commit -qm 'pen: two modules and their sources' ) >/dev/null 2>&1
  printf 'binary\n' > "$d/rye/bin/rye"
  printf 'binary\n' > "$d/rishi/bin/rishi"
  echo "$d"
}

# Set one file's modification time to a stamp this many seconds in the past.
age() { touch -d "@$(( $(date +%s) - $2 ))" "$1" 2>/dev/null || touch -t "$(date -r $(( $(date +%s) - $2 )) +%Y%m%d%H%M.%S)" "$1"; }

run_in() { ( cd "$1" && sh "$scan" 2>/dev/null; ) }

# 1. The agreeing tree -- every binary built after its own source. Free, and reading zero.
d=$(build agreeing)
age "$d/rye/src/main.rye" 600;   age "$d/rye/bin/rye" 300
age "$d/rishi/src/main.rye" 600; age "$d/rishi/bin/rishi" 200
out=$(run_in "$d")
leg fresh_tree_free           "$(saw "$out" 'verdict=ok')"
leg fresh_tree_reads_zero     "$(saw "$out" 'tools_stale=0')"
leg fresh_tree_counts_both    "$(saw "$out" 'tools_fresh=2')"
leg fresh_tree_declares_two   "$(saw "$out" 'tools_declared=2')"
leg fresh_rye_named_fresh     "$(saw "$out" 'tool=rye .*verdict=fresh')"
leg fresh_rishi_named_fresh   "$(saw "$out" 'tool=rishi .*verdict=fresh')"

# 2. The regression itself -- a source newer than the binary built from it. Refused, counted,
#    and the source that outran it named, so the repair is one line away.
d=$(build stale_rishi)
age "$d/rye/src/main.rye" 600;   age "$d/rye/bin/rye" 300
age "$d/rishi/bin/rishi" 600;    age "$d/rishi/src/main.rye" 200
out=$(run_in "$d")
leg stale_refused             "$(saw "$out" 'verdict=stale_tool')"
leg stale_counted             "$(saw "$out" 'tools_stale=1')"
leg stale_tool_named          "$(saw "$out" 'tool=rishi .*verdict=stale')"
leg stale_source_named        "$(saw "$out" 'newest_source=rishi/src/main.rye')"
leg stale_distance_counted    "$(saw "$out" 'behind_seconds=[1-9]')"
leg stale_repair_printed      "$(saw "$out" 'repair: rishi is .* rye/bin/rye build')"
leg stale_peer_stays_fresh    "$(saw "$out" 'tool=rye .*verdict=fresh')"
( cd "$d" && sh "$scan" >/dev/null 2>&1 ); leg stale_exit_nonzero "$([ $? -ne 0 ] && echo yes || echo no)"

# 3. The same plant lifted -- rebuild the binary and the refusal goes away. A refusal proven only
#    from the failing side cannot be told from a scan that refuses everything.
age "$d/rishi/bin/rishi" 100
out=$(run_in "$d")
leg stale_lifted_free         "$(saw "$out" 'verdict=ok')"
leg stale_lifted_reads_zero   "$(saw "$out" 'tools_stale=0')"

# 4. The compiler half, so the reading is proven on each tool rather than on one of them.
d=$(build stale_rye)
age "$d/rishi/src/main.rye" 600; age "$d/rishi/bin/rishi" 300
age "$d/rye/bin/rye" 600;        age "$d/rye/src/main.rye" 200
out=$(run_in "$d")
leg stale_rye_refused         "$(saw "$out" 'verdict=stale_tool')"
leg stale_rye_named           "$(saw "$out" 'tool=rye .*verdict=stale')"
leg stale_rye_repair_printed  "$(saw "$out" 'repair: rye is .* rye/bootstrap.sh')"

# 5. Both stale at once -- the count is a count rather than a flag.
d=$(build both_stale)
age "$d/rye/bin/rye" 600;     age "$d/rye/src/main.rye" 200
age "$d/rishi/bin/rishi" 600; age "$d/rishi/src/main.rye" 200
out=$(run_in "$d")
leg both_stale_counted        "$(saw "$out" 'tools_stale=2')"
leg both_stale_no_fresh       "$(saw "$out" 'tools_fresh=0')"

# 6. An ABSENT binary is reported and left free. A fresh clone has none, and the bootstrap is the
#    documented first step -- a guard refusing there would red on the state the tree expects.
d=$(build absent)
rm -f "$d/rishi/bin/rishi"
age "$d/rye/src/main.rye" 600; age "$d/rye/bin/rye" 300
out=$(run_in "$d")
leg absent_free               "$(saw "$out" 'verdict=ok')"
leg absent_counted            "$(saw "$out" 'tools_absent=1')"
leg absent_named              "$(saw "$out" 'tool=rishi .*verdict=absent')"
leg absent_not_stale          "$(saw "$out" 'tools_stale=0')"

# 7. UNTRACKED scratch newer than the binary must be read past. This is the mutation that bites
#    hardest: a reading built on `find` alone rather than on `git ls-files` reds a healthy tree
#    every time a lap leaves an editor swap file beside a source.
d=$(build scratch)
age "$d/rye/src/main.rye" 600;   age "$d/rye/bin/rye" 300
age "$d/rishi/src/main.rye" 600; age "$d/rishi/bin/rishi" 300
printf 'scratch\n' > "$d/rishi/src/main.rye.swp"
age "$d/rishi/src/main.rye.swp" 10
out=$(run_in "$d")
leg untracked_scratch_free    "$(saw "$out" 'verdict=ok')"
leg untracked_scratch_zero    "$(saw "$out" 'tools_stale=0')"
# and the same file TRACKED must be seen, so the exemption is about tracking rather than about
# the reading being blind.
( cd "$d" && git add -f rishi/src/main.rye.swp && git commit -qm 'pen: track the scratch' ) >/dev/null 2>&1
age "$d/rishi/src/main.rye.swp" 10
out=$(run_in "$d")
leg tracked_scratch_seen      "$(saw "$out" 'tools_stale=1')"

# 8. The compiler chain -- reported, never gated. A `rye` newer than `rishi` means a codegen change
#    has yet to reach the interpreter; both tools are still fresh against their own sources.
d=$(build chain)
age "$d/rishi/src/main.rye" 900; age "$d/rishi/bin/rishi" 600
age "$d/rye/src/main.rye" 400;   age "$d/rye/bin/rye" 200
out=$(run_in "$d")
leg chain_reported            "$(saw "$out" 'rishi_older_than_compiler=yes')"
leg chain_not_gated           "$(saw "$out" 'verdict=ok')"
leg chain_tools_fresh         "$(saw "$out" 'tools_fresh=2')"
# lifted: rebuild rishi after rye and the chain reading clears, so the key means what it says.
age "$d/rishi/bin/rishi" 60
out=$(run_in "$d")
leg chain_clears              "$(saw "$out" 'rishi_older_than_compiler=no')"

# 9. A tree with no binaries at all -- the fresh-clone state. Every tool absent, nothing refused.
d=$(build bare)
rm -f "$d/rye/bin/rye" "$d/rishi/bin/rishi"
out=$(run_in "$d")
leg bare_clone_free           "$(saw "$out" 'verdict=ok')"
leg bare_clone_counts_two     "$(saw "$out" 'tools_absent=2')"

# 10. Outside a repository the reading cannot know which files are the module's sources, so it
#     REFUSES. `git ls-files` answers nothing there, and a reading built on that silence would call
#     every tool fresh -- a green on the one state where it knows least.
bare=$pen/nogit
mkdir -p "$bare/rye/src" "$bare/rye/bin"
printf 'src\n' > "$bare/rye/src/main.rye"
printf 'binary\n' > "$bare/rye/bin/rye"
out=$( cd "$bare" && sh "$scan" 2>/dev/null )
leg no_repo_refused           "$(saw "$out" 'verdict=no_repository')"
leg no_repo_not_green         "$([ "$(saw "$out" 'verdict=ok')" = no ] && echo yes || echo no)"

# 11. THE MARK, BESIDE THE CLOCK. `rye build -femit-bin=<path>` writes `<path>.ryekey`, whose
#     second line is the emitted binary's own SHA-256. So one hash says whether the receipt beside
#     a tool speaks for the tool standing there. Five of the pier's eight ships carried one that
#     did not, measured `20260916.064500` -- a rename-over-a-busy-executable leaves the receipt at
#     the elder name. REPORTED rather than gated, so the plant below must leave `verdict=ok`.
pen_digest() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else echo no-sha-tool
  fi
}
zeros=0000000000000000000000000000000000000000000000000000000000000000

d=$(build receipts)
age "$d/rye/src/main.rye" 600;   age "$d/rye/bin/rye" 300
age "$d/rishi/src/main.rye" 600; age "$d/rishi/bin/rishi" 200
printf '%s\n%s\n' "$zeros" "$(pen_digest "$d/rishi/bin/rishi")" > "$d/rishi/bin/rishi.ryekey"
out=$(run_in "$d")
leg receipt_speaks_named      "$(saw "$out" 'tool=rishi .*receipt=speaks')"
leg receipt_speaks_counted    "$(saw "$out" 'receipts_speaking=1')"
leg receipt_absent_named      "$(saw "$out" 'tool=rye .*receipt=absent')"
leg receipt_absent_counted    "$(saw "$out" 'receipts_absent=1')"

# The orphan planted: the binary moves on and the receipt keeps its elder word.
printf 'a different binary\n' > "$d/rishi/bin/rishi"
age "$d/rishi/bin/rishi" 200
out=$(run_in "$d")
leg orphan_named              "$(saw "$out" 'tool=rishi .*receipt=orphan')"
leg orphan_counted            "$(saw "$out" 'receipts_orphaned=1')"
leg orphan_repair_printed     "$(saw "$out" 'repair: .*rishi.ryekey speaks for another binary')"
leg orphan_never_gates        "$(saw "$out" 'verdict=ok')"

# The same plant lifted -- the receipt re-stamped over the binary standing there.
printf '%s\n%s\n' "$zeros" "$(pen_digest "$d/rishi/bin/rishi")" > "$d/rishi/bin/rishi.ryekey"
out=$(run_in "$d")
leg orphan_lifts              "$(saw "$out" 'receipts_orphaned=0')"

# A stamp-shaped file that has grown into something else reads `malformed` rather than matching.
printf '%s\nnot-a-hash\n' "$zeros" > "$d/rishi/bin/rishi.ryekey"
out=$(run_in "$d")
leg malformed_named           "$(saw "$out" 'tool=rishi .*receipt=malformed')"
leg malformed_not_orphan      "$(saw "$out" 'receipts_orphaned=0')"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=legs_failed" >&2
exit 1
