#!/bin/sh
# tools/fixtures/p/pending_decision_control.sh -- prove the four-place reading by doing, on a
# throwaway tree.
#
# WHY. A reading that cannot tell "waits for Keaton's word" from "seated on Keaton's word" would
# count every closed decision as still open. This control plants one line of each shape -- parked,
# granted, yours, doors -- plus a dated shelf carrying a parked marker and a page carrying neither,
# and asks tools/fixtures/p/pending_decision_scan.sh to tell them apart. Nothing here touches the
# tree it is run from.
#
# USAGE
#   sh tools/fixtures/p/pending_decision_control.sh
#
# Driven by tools/p/pending_decision_witness.rish. Run from the repository root.
set -u

scan=$(pwd)/tools/fixtures/p/pending_decision_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

git init -q "$pen"
(
  cd "$pen" \
  && git config user.email pen@example.invalid \
  && git config user.name Pen
) >/dev/null 2>&1

# invariant: each planted file names its own case in a comment, so a failing leg is one grep away
mkdir -p "$pen/active-designing" "$pen/active-designing/date/20260101" "$pen/construction"

cat > "$pen/parked-case.md" <<'EOF'
# a parked decision
This waits for Keaton's word before it moves; the shape stays open until then.
EOF

cat > "$pen/granted-case.md" <<'EOF'
# a granted decision
**Seated** `20260101.000000` on Keaton's word -- the row is closed and the number is final.
EOF

cat > "$pen/construction/ITINERARY.md" <<'EOF'
# operator card
- YOURS: does an account earn its own shelf from birth, or wait for the next crossing?

## Open doors for Keaton

- The receipt contract awaits a scheme name.
- The four borrowed ceilings await one reason each.
EOF

cat > "$pen/active-designing/date/20260101/20260101-000000_dated-parked.md" <<'EOF'
# testimony, not an open question
This page once waited for Keaton's word, and the word landed the day this was written.
EOF

cat > "$pen/clean-case.md" <<'EOF'
# neither
This page names no decision at all, and stays exactly as plain as that.
EOF

(cd "$pen" && git add -A && git commit -qm 'pen: four places and a clean read') >/dev/null 2>&1

out=$(sh "$scan" --root "$pen" 2>&1)

parked=$(printf '%s\n' "$out" | grep -c '^parked ')
granted=$(printf '%s\n' "$out" | grep -c '^granted ')
yours=$(printf '%s\n' "$out" | grep -c '^yours ')
doors=$(printf '%s\n' "$out" | grep -c '^doors ')

echo "parked_bites=$([ "$parked" -eq 1 ] && echo yes || echo no) count=$parked"
echo "granted_bites=$([ "$granted" -eq 1 ] && echo yes || echo no) count=$granted"
echo "yours_bites=$([ "$yours" -eq 1 ] && echo yes || echo no) count=$yours"
echo "doors_bites=$([ "$doors" -eq 2 ] && echo yes || echo no) count=$doors"

dated_free=no
printf '%s\n' "$out" | grep -q 'dated-parked' || dated_free=yes
echo "dated_shelf_free=$dated_free"

clean_free=no
printf '%s\n' "$out" | grep -q 'clean-case' || clean_free=yes
echo "clean_case_free=$clean_free"

verdict_line=$(printf '%s\n' "$out" | grep '^verdict=' || true)
echo "$verdict_line" | grep -q 'verdict=reported' && reports=yes || reports=no
echo "reports_never_gates=$reports"

if [ "$parked" -eq 1 ] && [ "$granted" -eq 1 ] && [ "$yours" -eq 1 ] && [ "$doors" -eq 2 ] \
  && [ "$dated_free" = yes ] && [ "$clean_free" = yes ] && [ "$reports" = yes ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=fail"
exit 1
