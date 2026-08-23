#!/bin/sh
# tools/fixtures/document_mirror_control.sh -- the mirror check, proven from both sides.
#
# A sameness guard that only ever says "same" is indistinguishable from a guard that reads nothing,
# so this pen plants divergence and watches it bite, then plants agreement and watches it pass.
#
# WHAT IS PROVEN
#   identical_free      -- two homes holding the same bytes pass
#   drift_bitten        -- one byte different in a mirror is refused
#   drift_named         -- and the refusal names which path drifted
#   absent_mirror       -- a declared home that is not there is refused, distinctly from drift
#   absent_canonical    -- a canonical that is not there is refused too
#   comment_free        -- a `#` line naming a path declares nothing
#   write_repairs       -- `write` copies canonical over the mirror and the report then passes
#   two_sets_counted    -- two mirror blocks are read as two, so the parser is not reading one
#
# USAGE
#   sh tools/fixtures/document_mirror_control.sh
#
# Driven by tools/d/document_mirror_witness.rish. Run from the repository root.

set -u

SCAN=$(pwd)/tools/fixtures/document_mirror_scan.sh
faults=0
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

check() {
  _n=$1; _w=$2; _g=$3
  if [ "$_w" = "$_g" ]; then echo "case=$_n ok ($_g)"
  else echo "case=$_n FAULT want=$_w got=$_g"; faults=$((faults + 1)); fi
}

verdict_of() { printf '%s\n' "$1" | sed -n 's/^verdict=//p'; }

mkdir -p "$pen/a" "$pen/b"
printf 'one\ntwo\n' > "$pen/a/doc.md"
printf 'one\ntwo\n' > "$pen/b/doc.md"

# 1 -- identical homes pass, and a comment naming a path declares nothing.
cat > "$pen/same.brix" <<EOF
# at $pen/a/never-declared.md
mirror doc
canonical $pen/a/doc.md
at $pen/b/doc.md
EOF
out=$(sh "$SCAN" report "$pen/same.brix" 2>&1)
check identical_free ok "$(verdict_of "$out")"
case "$out" in *"mirrors_declared=1"*) check comment_free ok ok ;; *) check comment_free ok counted ;; esac

# 2 -- one byte apart is refused, and the refusal names the path.
printf 'one\nTWO\n' > "$pen/b/doc.md"
out=$(sh "$SCAN" report "$pen/same.brix" 2>&1)
check drift_bitten mirror_drift "$(verdict_of "$out")"
case "$out" in *"$pen/b/doc.md differs"*) check drift_named ok ok ;; *) check drift_named ok unnamed ;; esac

# 3 -- `write` repairs the drift, and the report then passes.
sh "$SCAN" write "$pen/same.brix" >/dev/null 2>&1
out=$(sh "$SCAN" report "$pen/same.brix" 2>&1)
check write_repairs ok "$(verdict_of "$out")"

# 4 -- a declared home that is not there is refused, distinctly from drift.
cat > "$pen/gone.brix" <<EOF
mirror doc
canonical $pen/a/doc.md
at $pen/b/absent.md
EOF
out=$(sh "$SCAN" report "$pen/gone.brix" 2>&1)
check absent_mirror path_absent "$(verdict_of "$out")"

# 5 -- an unreadable canonical is refused too.
cat > "$pen/nocanon.brix" <<EOF
mirror doc
canonical $pen/a/absent.md
at $pen/b/doc.md
EOF
out=$(sh "$SCAN" report "$pen/nocanon.brix" 2>&1)
check absent_canonical path_absent "$(verdict_of "$out")"

# 6 -- two blocks read as two sets, so the parser is genuinely walking the descriptor.
printf 'x\n' > "$pen/a/two.md"; printf 'x\n' > "$pen/b/two.md"
cat > "$pen/pair.brix" <<EOF
mirror one
canonical $pen/a/doc.md
at $pen/b/doc.md
mirror two
canonical $pen/a/two.md
at $pen/b/two.md
EOF
out=$(sh "$SCAN" report "$pen/pair.brix" 2>&1)
case "$out" in *"mirror_sets=2"*) check two_sets_counted ok ok ;; *) check two_sets_counted ok miscounted ;; esac

if [ "$faults" -eq 0 ]; then echo "control=ok"; exit 0; fi
echo "control=faults faults=$faults"
exit 2
