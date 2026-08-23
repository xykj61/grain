#!/bin/sh
# tools/fixtures/seed_link_control.sh -- prove the seed-link reading by doing, on real repositories.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). This control builds git repositories
# in a temporary pen, each with its own small manifest, plants one condition in each, runs
# tools/fixtures/seed_link_scan.sh inside them, and checks the refusals bite and the honest
# readings stay free. Nothing here touches the tree it is run from.
#
# The ceiling is proven from BOTH sides by planting 849 dead links against a ceiling of 848 --
# one document carrying them all, so the pen stays small. There is no flag that lowers the
# ceiling, because a wall with a door beside it is a habit rather than a wall.
#
# USAGE
#   sh tools/fixtures/seed_link_control.sh
#
# Driven by tools/seed_link_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/seed_link_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A pen ships `shipped/` and README.md, and withholds `withheld/` by simply never allowing it.
build() {
  name=$1; doc=$2; body=$3
  d=$pen/$name
  mkdir -p "$d/shipped" "$d/withheld" "$d/$(dirname "$doc")" 2>/dev/null
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf 'allow README.md\nallow shipped\nallow SECURITY.md\n' > pen-manifest.bron \
    && printf '# shipped\n' > shipped/here.md \
    && printf '# withheld\n' > withheld/there.md \
    && printf '# front\n' > README.md \
    && printf '%s\n' "$body" > "$doc" \
    && git add -A && git commit -qm 'pen: one shipped room and one withheld' ) >/dev/null 2>&1
  echo "$d"
}

verdict_of() { ( cd "$1" && SEED_LINK_MANIFEST=pen-manifest.bron sh "$scan" 2>/dev/null; ) }

# 1. The agreeing tree -- the front door links only into the shipped room. Free, reading zero.
d=$(build agreeing README.md 'see [here](shipped/here.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "agreeing_free=yes" || echo "agreeing_free=no"
echo "$out" | grep -q 'front_door_links_outside_seed=0' && echo "clean_reads_zero=yes" || echo "clean_reads_zero=no"

# 2. The regression itself -- the front door links into a withheld room. Refused, counted, named.
d=$(build front_dead README.md 'see [there](withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=link_outside_seed' && echo "front_dead_refused=yes" || echo "front_dead_refused=no"
echo "$out" | grep -q 'front_door_links_outside_seed=1' && echo "front_dead_counted=yes" || echo "front_dead_counted=no"
echo "$out" | grep -q 'gated: README.md -> withheld/there.md' && echo "front_dead_named=yes" || echo "front_dead_named=no"

# 3. A document the seed never ships cannot break a link for a reader who never sees it. Free.
d=$(build unshipped withheld/note.md 'see [there](there.md)')
verdict_of "$d" | grep -q 'verdict=ok' && echo "unshipped_doc_free=yes" || echo "unshipped_doc_free=no"

# 4. A shipped NON-front-door document counts as a ratchet rather than a gate.
d=$(build ratchet shipped/note.md 'see [there](../withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=1' && echo "ratchet_counted=yes" || echo "ratchet_counted=no"
echo "$out" | grep -q 'front_door_links_outside_seed=0' && echo "ratchet_not_gated=yes" || echo "ratchet_not_gated=no"
echo "$out" | grep -q 'verdict=ok' && echo "ratchet_under_ceiling_free=yes" || echo "ratchet_under_ceiling_free=no"

# 5. Dated testimony keeps every reference it ever wrote. Free, and not even counted.
d=$(build testimony shipped/20260101-000000_a-dated-note.md 'see [there](../withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=0' && echo "dated_testimony_free=yes" || echo "dated_testimony_free=no"

# 6. An external link and an anchor name no path in this tree. Free.
d=$(build external README.md 'see [web](https://example.invalid/x) and [top](#heading) and [mail](mailto:a@b.invalid)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "external_link_free=yes" || echo "external_link_free=no"
echo "$out" | grep -q 'relative_links_checked=0' && echo "external_not_counted=yes" || echo "external_not_counted=no"

# 7. The ceiling, from both sides -- 848 free, 849 refused, with no flag involved.
d=$(build ceiling_under shipped/many.md 'placeholder')
( cd "$d" && i=1; : > shipped/many.md
  while [ "$i" -le 848 ]; do printf 'see [x%s](../withheld/there.md)\n' "$i" >> shipped/many.md; i=$((i + 1)); done
  git add -A && git commit -qm 'pen: 848 dead links, exactly at the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=848' && echo "ceiling_edge_counted=yes" || echo "ceiling_edge_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "ceiling_edge_free=yes" || echo "ceiling_edge_free=no"

( cd "$d" && printf 'see [x849](../withheld/there.md)\n' >> shipped/many.md \
  && git add -A && git commit -qm 'pen: one over the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=849' && echo "ceiling_over_counted=yes" || echo "ceiling_over_counted=no"
echo "$out" | grep -q 'verdict=link_outside_seed' && echo "ceiling_over_refused=yes" || echo "ceiling_over_refused=no"

echo "control_verdict=ok"
