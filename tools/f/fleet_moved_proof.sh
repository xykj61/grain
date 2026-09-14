#!/bin/sh
# fleet_moved_proof.sh -- price the proof owed after the second pull.
#
# The round base names the tree read at lap-open. UPSTREAM_BEFORE is xy/main as
# it stood before the send fetch; UPSTREAM_AFTER is xy/main after that fetch.
# The script maps each side's changed paths through the standing scope map. A
# shared guard means the changes can affect one proof and the full roster is
# owed. An unreadable ref, absent map, or path with no static watch row also
# chooses the full roster: silence in the map cannot prove independence.
set -eu

usage() {
  echo "usage: sh tools/f/fleet_moved_proof.sh ROUND_BASE UPSTREAM_BEFORE UPSTREAM_AFTER" >&2
  exit 2
}

[ "$#" -eq 3 ] || usage
round_base=$1
upstream_before=$2
upstream_after=$3
tool_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
scope_map=${FLEET_SCOPE_MAP:-$tool_root/tools/fixtures/s/standing_equipment_scope_map.sh}
matcher=$tool_root/tools/fixtures/s/scope_match.sh

full() {
  echo "proof_scope=full"
  echo "proof_reason=$1"
  exit 0
}

[ -r "$scope_map" ] || full map_absent
[ -r "$matcher" ] || full matcher_absent
for ref in "$round_base" "$upstream_before" "$upstream_after" HEAD; do
  git rev-parse --verify "$ref^{commit}" >/dev/null 2>&1 || full ref_unreadable
done

pen=$(mktemp -d "${TMPDIR:-/tmp}/fleet-moved-proof.XXXXXX") || exit 2
trap 'rm -rf "$pen"' EXIT HUP INT TERM

git diff --name-only "$round_base..HEAD" | sort -u > "$pen/local.paths"
git diff --name-only "$upstream_before..$upstream_after" | sort -u > "$pen/upstream.paths"
sh "$scope_map" > "$pen/map" || full map_unreadable
. "$matcher"

map_side() {
  side=$1
  : > "$pen/$side.guards"
  : > "$pen/$side.unknown"
  while IFS= read -r changed; do
    [ -n "$changed" ] || continue
    matched=no
    while IFS=' ' read -r guard watchset; do
      [ -n "$guard" ] || continue
      [ "$watchset" = DISCOVERY ] && continue
      if scope_match_row "$watchset" "$changed"; then
        echo "$guard" >> "$pen/$side.guards"
        matched=yes
      fi
    done < "$pen/map"
    [ "$matched" = yes ] || echo "$changed" >> "$pen/$side.unknown"
  done < "$pen/$side.paths"
  sort -u "$pen/$side.guards" -o "$pen/$side.guards"
}

map_side local
map_side upstream
comm -12 "$pen/local.guards" "$pen/upstream.guards" > "$pen/shared.guards"

echo "local_changed=$(grep -c . "$pen/local.paths" || true)"
echo "upstream_changed=$(grep -c . "$pen/upstream.paths" || true)"
echo "local_proofs=$(grep -c . "$pen/local.guards" || true)"
echo "upstream_proofs=$(grep -c . "$pen/upstream.guards" || true)"
echo "shared_proofs=$(grep -c . "$pen/shared.guards" || true)"
echo "local_guard_names=$(tr '\n' ' ' < "$pen/local.guards" | sed 's/ $//')"
echo "upstream_guard_names=$(tr '\n' ' ' < "$pen/upstream.guards" | sed 's/ $//')"

if [ -s "$pen/local.unknown" ] || [ -s "$pen/upstream.unknown" ]; then
  echo "unknown_paths=$(cat "$pen/local.unknown" "$pen/upstream.unknown" | sort -u | tr '\n' ' ' | sed 's/ $//')"
  full map_unknown
fi
if [ -s "$pen/shared.guards" ]; then
  echo "shared_guard_names=$(tr '\n' ' ' < "$pen/shared.guards" | sed 's/ $//')"
  full proof_overlap
fi

echo "proof_scope=scoped"
echo "proof_reason=independent"
