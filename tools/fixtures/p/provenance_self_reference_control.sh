#!/bin/sh
# Proves provenance_self_reference_scan.sh on real git repositories in a throwaway pen -- every
# refusal shown from BOTH sides, planted and then removed, because a refusal proven only in the
# passing direction cannot be told from a bypass. The welcomes are asserted as hard as the
# refusals: seven honest sibling rosters read zero on this pier, and a guard that could not tell
# them from the fault would be turned off within a week.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/provenance_self_reference_scan.sh
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { # ck <name> <expected-substring> <actual>
  if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
    fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi
}

root="$pen/tree"
mkdir -p "$root/tools/fixtures/p" "$root/foundations" "$root/session-logs/date/20260905" "$root/foundations/date/20260901"
git init -q "$root" 2>/dev/null
git -C "$root" config user.email pen@example.invalid
git -C "$root" config user.name Pen
cp "$src" "$root/tools/fixtures/p/"
scan="$root/tools/fixtures/p/provenance_self_reference_scan.sh"
add() { git -C "$root" add -A >/dev/null 2>&1; }

# A clean room: an honest page with no self-reference at all.
cat > "$root/foundations/20260901-010101_plain.md" <<'EOF'
# Plain
**Stamp:** `20260901.010101` -- a Gauge molt of [`20260101-000000_elder.md`](20260101-000000_elder.md)
EOF
add
out=$(sh "$scan" 2>&1)
ck "clean tree welcomed"        "verdict=no_page_is_its_own_elder" "$out"
ck "clean tree counts zero"     "living_self_provenance=0"         "$out"
ck "clean tree read documents"  "documents_scanned=1"              "$out"

# 4-6. THE FAULT, planted: a page named as its own elder on a provenance line.
cat > "$root/foundations/20260902-020202_mutant.md" <<'EOF'
# Mutant
**Stamp:** `20260902.020202` -- a Gauge reimagining of [`20260902-020202_mutant.md`](20260902-020202_mutant.md), which stays whole as the fossil
EOF
add
out=$(sh "$scan" 2>&1)
ck "self-provenance refused"    "verdict=self_provenance"                   "$out"
ck "self-provenance counted"    "living_self_provenance=1"                  "$out"
ck "self-provenance named"      "20260902-020202_mutant.md:2"               "$out"

# 7-8. THE SAME FAULT REMOVED: the reading returns to green, so the refusal is not a bypass.
cat > "$root/foundations/20260902-020202_mutant.md" <<'EOF'
# Mutant
**Stamp:** `20260902.020202` -- a Gauge reimagining of the elder `20260618-182412_elder.md`, shed on `20260826`
EOF
add
out=$(sh "$scan" 2>&1)
ck "repair returns to green"    "verdict=no_page_is_its_own_elder" "$out"
ck "repair counts zero"         "living_self_provenance=0"         "$out"

# 9-11. A SIBLING ROSTER IS NOT THE FAULT. A Kin line naming every voice includes the page you
# stand on, the link resolves, and the sentence is true. This is the welcome that keeps the guard.
cat > "$root/foundations/20260903-030303_lattice.md" <<'EOF'
# Lattice
**Kin:** the four voices: [Lattice](20260903-030303_lattice.md) - [Scribble](20260903-030304_scribble.md)
EOF
add
out=$(sh "$scan" 2>&1)
ck "sibling roster welcomed"    "verdict=no_page_is_its_own_elder" "$out"
ck "sibling roster not counted" "living_self_provenance=0"         "$out"
ck "sibling roster was read"    "documents_scanned=3"              "$out"

# 12-13. THE PHRASE ALONE IS NOT THE FAULT either -- a provenance line naming a DIFFERENT page is
# the ordinary, correct shape and every molted page in the tree carries one.
cat > "$root/foundations/20260904-040404_honest.md" <<'EOF'
# Honest
**Stamp:** `20260904.040404` -- a Gauge molt of [`20260801-080808_older.md`](20260801-080808_older.md), which stays whole as the fossil
EOF
add
out=$(sh "$scan" 2>&1)
ck "honest provenance welcomed" "verdict=no_page_is_its_own_elder" "$out"
ck "honest provenance uncounted" "living_self_provenance=0"        "$out"

# 14-16. TESTIMONY IS REPORTED, NEVER GATED. The same planted fault inside a session log and a
# dated shelf keeps every word it wrote, so the verdict stays green and the count is separate.
cat > "$root/session-logs/date/20260905/20260905-050505_log.md" <<'EOF'
a Gauge molt of [`20260905-050505_log.md`](20260905-050505_log.md), which stays whole as the fossil
EOF
cat > "$root/foundations/date/20260901/20260901-060606_shelved.md" <<'EOF'
a Gauge reimagining of [`20260901-060606_shelved.md`](20260901-060606_shelved.md)
EOF
add
out=$(sh "$scan" 2>&1)
ck "testimony stays green"      "verdict=no_page_is_its_own_elder" "$out"
ck "testimony counted apart"    "testimony_self_provenance=2"      "$out"
ck "testimony not gated"        "living_self_provenance=0"         "$out"

# 17. A ./ SPELLING OF THE SAME LINK IS THE SAME FAULT.
cat > "$root/foundations/20260906-060606_dotted.md" <<'EOF'
**Stamp:** a Gauge molt of [`x`](./20260906-060606_dotted.md), which stays whole as the fossil
EOF
add
out=$(sh "$scan" 2>&1)
ck "dot-slash spelling caught"  "living_self_provenance=1"         "$out"

# 18. THE INSTRUMENT REFUSES rather than printing a clean zero when it cannot read a checkout.
mkdir -p "$pen/bare/tools/fixtures/p"
cp "$src" "$pen/bare/tools/fixtures/p/"
out=$(sh "$pen/bare/tools/fixtures/p/provenance_self_reference_scan.sh" 2>&1 || true)
ck "no checkout refuses"        "REFUSED"                          "$out"

echo "provenance_self_reference_control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
