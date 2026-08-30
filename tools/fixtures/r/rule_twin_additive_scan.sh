#!/usr/bin/env sh
# rule_twin_additive_scan.sh -- which drifted rule pairs one word can lawfully sync.
#
# Gate %7's middle door (granted on Keaton's word 20260829): the pair-by-pair reconciliation
# stays a reading, but a pair whose drift is STRICTLY ADDITIVE ON ONE SIDE -- every normalized
# line of one twin present in the other -- can sync mechanically without deleting a live safety
# rule, which is the whole danger the gate exists for. This scan CLASSIFIES; it writes nothing.
#
# Normalization mirrors tools/fixtures/r/rule_twin_scan.sh's declared transform exactly: the
# twin's leading frontmatter block drops, `.mdc` link targets read as `.md`, the mutual
# twin-pointer lines drop from both, and blank lines drop. The containment test then runs over
# LINE SETS: subset means nothing would be lost by adopting the superset's body.
#
#   identical      normalized bodies equal (the scan's own green)
#   additive:SIDE  SIDE holds every line of its twin plus more -- one word syncs it
#   two_way        each side holds lines the other lacks -- stays at the gate, a reading each
#
#   sh tools/fixtures/r/rule_twin_additive_scan.sh
set -eu

normalize() {
  # $1 file; frontmatter dropped only when line 1 is exactly ---
  awk '
    NR == 1 && $0 == "---" { fm = 1; next }
    fm == 1 && $0 == "---" { fm = 0; next }
    fm == 1 { next }
    /^Canonical (Claude|Cursor) twin/ { next }
    { gsub(/\.mdc\)/, ".md)"); gsub(/\.mdc`/, ".md`") }
    /^[[:space:]]*$/ { next }
    { print }
  ' "$1"
}

identical=0
additive_claude=0
additive_cursor=0
two_way=0
missing_twin=0

for md in .claude/rules/*.md; do
  base=$(basename "$md" .md)
  mdc=".cursor/rules/$base.mdc"
  if [ ! -f "$mdc" ]; then
    missing_twin=$((missing_twin + 1))
    echo "detail: $base has no cursor twin"
    continue
  fi
  a="$(normalize "$md")"
  b="$(normalize "$mdc")"
  if [ "$a" = "$b" ]; then
    identical=$((identical + 1))
    continue
  fi
  # Line-set containment, order-free: sort -u both, comm answers what each side alone holds.
  onlya=$(printf '%s\n' "$a" | sort -u > /tmp/rt_a.$$; printf '%s\n' "$b" | sort -u > /tmp/rt_b.$$; comm -23 /tmp/rt_a.$$ /tmp/rt_b.$$ | grep -c . || true)
  onlyb=$(comm -13 /tmp/rt_a.$$ /tmp/rt_b.$$ | grep -c . || true)
  rm -f /tmp/rt_a.$$ /tmp/rt_b.$$
  if [ "$onlya" -gt 0 ] && [ "$onlyb" -eq 0 ]; then
    additive_claude=$((additive_claude + 1))
    echo "additive:claude $base (+$onlya lines the twin lacks)"
  elif [ "$onlyb" -gt 0 ] && [ "$onlya" -eq 0 ]; then
    additive_cursor=$((additive_cursor + 1))
    echo "additive:cursor $base (+$onlyb lines the twin lacks)"
  else
    two_way=$((two_way + 1))
    echo "two_way $base (claude+$onlya cursor+$onlyb)"
  fi
done

echo "pairs_identical=$identical"
echo "pairs_additive_claude=$additive_claude"
echo "pairs_additive_cursor=$additive_cursor"
echo "pairs_two_way=$two_way"
echo "missing_twin=$missing_twin"
echo "verdict=classified"
