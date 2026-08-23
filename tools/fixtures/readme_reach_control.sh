#!/bin/sh
# tools/fixtures/readme_reach_control.sh -- the front-door crawl, proven from both sides.
#
# A reachability guard that only ever says "all doors open" cannot be told from a guard that never
# walked. This pen builds small trees in a temporary directory and checks eight behaviors.
#
# WHAT IS PROVEN
#   clean_free          -- a tree whose links all resolve passes
#   living_bitten       -- a broken link in a LIVING file is refused
#   living_named        -- and the refusal names the file and the target
#   testimony_ratchets  -- the same break inside a DATED file is counted, never gated
#   ceiling_bitten      -- testimony over its ceiling is refused, so the ratchet is real
#   unreached_free      -- a break in a document README does not reach is out of scope
#   external_free       -- an http target is never followed or counted
#   depth_walked        -- the crawl follows links through several levels, not just one
#
# USAGE
#   sh tools/fixtures/readme_reach_control.sh
#
# Driven by tools/r/readme_reach_witness.rish. Run from the repository root.

set -u

SCAN=$(pwd)/tools/fixtures/readme_reach_scan.sh
faults=0
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

check() {
  _n=$1; _w=$2; _g=$3
  if [ "$_w" = "$_g" ]; then echo "case=$_n ok ($_g)"
  else echo "case=$_n FAULT want=$_w got=$_g"; faults=$((faults + 1)); fi
}

# The scan reads paths relative to the working directory, so each case runs inside its own tree.
build() {
  rm -rf "$pen/t"; mkdir -p "$pen/t"; cd "$pen/t"
}

verdict_of() { printf '%s\n' "$1" | sed -n 's/^verdict=//p'; }
value_of() { printf '%s\n' "$1" | sed -n "s/^$2=//p"; }

# 1 -- every link resolves, and the crawl walks more than one level deep.
build
printf '# root\n[a](a.md)\n' > README.md
printf '# a\n[b](b.md)\n' > a.md
printf '# b\ndone\n' > b.md
out=$(sh "$SCAN" 2>&1); check clean_free ok "$(verdict_of "$out")"
check depth_walked 3 "$(value_of "$out" documents_reached)"

# 2 -- a broken link in a LIVING file is refused, and the refusal names it.
build
printf '# root\n[gone](missing.md)\n' > README.md
out=$(sh "$SCAN" 2>&1); code=$?
check living_bitten living_link_broken "$(verdict_of "$out")"
case "$out" in *"living: README.md -> missing.md"*) check living_named ok ok ;; *) check living_named ok unnamed ;; esac

# 3 -- the same break inside DATED testimony is counted rather than gated.
build
printf '# root\n[log](20260101-010101_a-log.md)\n' > README.md
printf '# log\n[gone](missing.md)\n' > 20260101-010101_a-log.md
out=$(sh "$SCAN" 2>&1)
if [ "$(verdict_of "$out")" = "ok" ] && [ "$(value_of "$out" broken_in_testimony)" = "1" ]; then
  check testimony_ratchets ok ok
else
  check testimony_ratchets ok "$(verdict_of "$out")/$(value_of "$out" broken_in_testimony)"
fi

# 4 -- and the ratchet is real: over its ceiling, testimony is refused too.
out=$(sh "$SCAN" README.md 2>&1)   # default ceiling is the tree's, far above 1
# force a ceiling of zero by running the scan body with the pen's own ceiling
sed 's/^ceiling=.*/ceiling=0   # pen/' "$SCAN" > "$pen/zero.sh"
out=$(sh "$pen/zero.sh" 2>&1)
check ceiling_bitten testimony_over_ceiling "$(verdict_of "$out")"

# 5 -- a break in a document README never reaches is out of scope.
build
printf '# root\nnothing here\n' > README.md
printf '# orphan\n[gone](missing.md)\n' > orphan.md
out=$(sh "$SCAN" 2>&1); check unreached_free ok "$(verdict_of "$out")"

# 6 -- an http target is never followed and never counted.
build
printf '# root\n[out](https://example.invalid/nothing.md)\n' > README.md
out=$(sh "$SCAN" 2>&1)
if [ "$(verdict_of "$out")" = "ok" ] && [ "$(value_of "$out" broken_total)" = "0" ]; then
  check external_free ok ok
else
  check external_free ok "$(verdict_of "$out")/$(value_of "$out" broken_total)"
fi

cd "$(dirname "$SCAN")/../.." 2>/dev/null || cd /
if [ "$faults" -eq 0 ]; then echo "control=ok"; exit 0; fi
echo "control=faults faults=$faults"
exit 2
