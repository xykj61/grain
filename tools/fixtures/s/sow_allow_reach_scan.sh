#!/bin/sh
# Count allowed rooms in a completed seed projection from these tracked inputs.
# A receipt binds the copy to its commit, index, and working bytes. Stale copies
# refuse before any missing room is counted. An announced withholding is reported
# separately from a room that vanished silently.
# The scan reports counts; tools/s/sow_allow_reach_witness.rish gates empty at zero.
# --capability reads only the receipt: absent skips, unknown runs the guard.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
root=${SOW_ROOT:-$(CDPATH= cd -- "$here/../../.." && pwd)}
cd "$root"

MANIFEST=${SOW_MANIFEST:-template-manifest.bron}
SEED=${SOW_SEED:-seed}

if [ "${1:-}" = --capability ] && [ ! -d "$SEED" ]; then echo absent; exit 0; fi
# A scan that reads nothing must refuse rather than report clean (REDS %170).
[ -d "$SEED" ] || { echo "refused: no projection at $SEED/ -- run tools/s/sow.rish first"; exit 2; }

# A completed projection carries its commit and tracked-input digest. Read these
# before comparing allowed rooms: a stale copy cannot answer for current inputs.
# The capability form serves the roster from this same check. Missing or stale
# evidence means absent; an unreadable or malformed receipt means unknown and runs.
projection_check() {
  RECEIPT="$SEED/.sow-projection.log"
  [ -f "$RECEIPT" ] || { echo "refused: no receipt at $RECEIPT"; return 2; }
  projected_from=$(awk '$1 == "projected_from" { print $2 }' "$RECEIPT") || return 3
  [ -n "$projected_from" ] || { echo "refused: the receipt at $RECEIPT names no commit"; return 3; }
  case "$projected_from" in *[!0-9a-f]*) echo "refused: malformed receipt commit"; return 3;; esac
  case "${#projected_from}" in 40|64) :;; *) echo "refused: malformed receipt commit"; return 3;; esac
  projected_basis=$(awk '$1 == "projected_basis" { print $2 }' "$RECEIPT") || return 3
  [ -n "$projected_basis" ] || { echo "refused: receipt names no tracked-input digest"; return 3; }
  case "$projected_basis" in *[!0-9a-f]*) echo "refused: malformed receipt digest"; return 3;; esac
  case "${#projected_basis}" in 40|64) :;; *) echo "refused: malformed receipt digest"; return 3;; esac
  head_now=$(git rev-parse --verify HEAD) || return 3
  if [ "$projected_from" != "$head_now" ]; then
    echo "refused: projection is stale -- taken at $projected_from, tree now at $head_now"
    return 2
  fi
  basis_now=$(sh "$here/sow_projection_basis.sh") || return 3
  if [ "$projected_basis" != "$basis_now" ]; then
    echo "refused: projection is stale -- tracked inputs changed at commit $head_now"
    return 2
  fi
}
if [ "${1:-}" = --capability ]; then
  rc=0
  projection_check >/dev/null 2>&1 || rc=$?
  case "$rc" in 0) echo present;; 2) echo absent;; *) echo unknown;; esac
  exit 0
fi
[ -f "$MANIFEST" ] || { echo "refused: no manifest at $MANIFEST"; exit 2; }
projection_check || exit 2

SUBEX=$(grep -E '^sub_exclude ' "$MANIFEST" | awk '{print $2}' || true)
is_subex() {
  for x in $SUBEX; do
    case "$1" in "$x"|"$x"/*) return 0;; esac
  done
  return 1
}

allows=0
shipped=0
withheld=0
empty=0

# The projector's own logs, which are what tell a LOUD absence from a silent one.
LOGGED=""
for lg in "$SEED/.sow-withheld.log" "$SEED/.sow-excluded.log"; do
  [ -f "$lg" ] && LOGGED="$LOGGED
$(cat "$lg")"
done
is_logged() {
  printf '%s\n' "$LOGGED" | grep -qxF "$1"
}

for p in $(grep -E '^allow ' "$MANIFEST" | awk '{print $2}'); do
  allows=$((allows + 1))
  is_subex "$p" && continue                       # withheld whole, on purpose
  tracked=$(git ls-files -- "$p" | head -400)
  [ -n "$tracked" ] || continue                   # the field does not carry it

  # every tracked file withheld by sub-path is a room that ships nothing by design
  any_shippable=no
  for f in $tracked; do
    is_subex "$f" || { any_shippable=yes; break; }
  done
  [ "$any_shippable" = yes ] || continue

  if [ -f "$SEED/$p" ] || [ -n "$(find "$SEED/$p" -type f -print -quit 2>/dev/null)" ]; then
    shipped=$((shipped + 1))
  else
    # absent -- now ask whether the projector SAID so. A logged absence is the fail-safe.
    loud=no
    for f in $tracked; do
      is_logged "$f" && { loud=yes; break; }
    done
    if [ "$loud" = yes ]; then
      withheld=$((withheld + 1))
      echo "withheld: $p -- absent, and the projector logged why (defence in depth)"
    else
      empty=$((empty + 1))
      echo "empty: $p -- allowed, shippable, and absent with nothing logged"
    fi
  fi
done

echo "allows=$allows"
echo "shipped=$shipped"
echo "withheld_by_design=$withheld"
echo "empty=$empty"
