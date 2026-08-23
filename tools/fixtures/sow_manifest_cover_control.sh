#!/bin/sh
# sow_manifest_cover_control.sh -- prove the seed-boundary cover check from both sides.
#
# WHY. On `20260823.134057` the cover check's gating logic changed: a `personal` row naming an
# absent path became permitted rather than refused. Changing what a guard refuses is the moment
# that guard most needs proving, because a loosening and a repair look identical from the outside
# -- both make a red go away. So each gate is exercised here by building a manifest and a root
# list that genuinely fail it.
#
# WHAT IT BUILDS, each a throwaway manifest and root list under a mktemp root, swept on exit.
#
#   clean         every root classified, no ghost shipping row, nothing doubled -- M1_OK
#   defence       a `personal` row naming an absent path -- M1_OK, and the path REPORTED
#   unclassified  a tracked root with no verdict at all -- M1_BAD
#   ghost         a `template` row naming a path the tree does not have -- M1_BAD
#   doubled       one path carrying two verdicts -- M1_BAD, the reading the elder `sort -u`
#                 silently collapsed for the whole life of the file
#
# The `doubled` case is the one worth watching: it passed the elder check and fails this one, so
# it proves the pass got stricter in the same hand that made it permit defence in depth.
#
# USAGE
#   sh tools/fixtures/sow_manifest_cover_control.sh
#
# Prints one `key=value` line per proven behavior and `control_verdict=ok` on the tail. Exit is
# non-zero the moment a behavior fails, so a witness gates on the run itself.
#
# Kin: tools/fixtures/sow_manifest_cover.sh (the check under test) - tools/sow_witness.rish.
#
# Run from the repository root.

set -eu

cover="tools/fixtures/sow_manifest_cover.sh"
[ -f "$cover" ] || { echo "refused: no cover check at $cover" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

proven=0

verdict() { sh "$cover" "$1" "$2" | head -1; }
reported() { sh "$cover" "$1" "$2" | tail -1; }

printf 'alpha\nbeta\n' > "$pen/roots"

# ---- clean: every root classified, nothing absent, nothing doubled ---------------------------
printf 'template  alpha  # a room that ships\npersonal  beta   # a room withheld\n' > "$pen/clean.bron"
[ "$(verdict "$pen/clean.bron" "$pen/roots")" = "M1_OK" ] || { echo "control: a clean manifest must read M1_OK" >&2; exit 1; }
echo "clean_manifest=rests"
proven=$((proven + 1))

# ---- defence: a `personal` row for a path the tree does not carry -----------------------------
# The `twilight` shape. Permitted, and named on the tail so it stays visible.
printf 'template  alpha  # a room that ships\npersonal  beta   # a room withheld\npersonal  gone   # debrided, kept as defence in depth\n' > "$pen/defence.bron"
[ "$(verdict "$pen/defence.bron" "$pen/roots")" = "M1_OK" ] || { echo "control: a personal row for an absent path must be permitted" >&2; exit 1; }
[ "$(reported "$pen/defence.bron" "$pen/roots")" = "gone" ] || { echo "control: a permitted defence-in-depth row must still be reported by name" >&2; exit 1; }
echo "defence_in_depth=permitted_and_reported"
proven=$((proven + 1))

# ---- unclassified: a tracked root with no verdict ---------------------------------------------
printf 'template  alpha  # a room that ships\n' > "$pen/unclassified.bron"
[ "$(verdict "$pen/unclassified.bron" "$pen/roots")" = "M1_BAD" ] || { echo "control: an unclassified tracked root must read M1_BAD" >&2; exit 1; }
echo "unclassified_root=reds"
proven=$((proven + 1))

# ---- ghost: a SHIPPING row naming a path the tree does not have --------------------------------
printf 'template  alpha  # a room that ships\npersonal  beta   # a room withheld\ntemplate  ghost  # a promise to ship what is not there\n' > "$pen/ghost.bron"
[ "$(verdict "$pen/ghost.bron" "$pen/roots")" = "M1_BAD" ] || { echo "control: a shipping row naming an absent path must read M1_BAD" >&2; exit 1; }
echo "ghost_shipping_row=reds"
proven=$((proven + 1))

# ---- doubled: one path carrying two verdicts ---------------------------------------------------
# The elder check ran `sort -u` on both sides, so this collapsed to one entry and passed. It is
# the most dangerous of the five, because which verdict wins depends on read order.
printf 'template  alpha  # ships\npersonal  alpha  # withheld -- which one wins?\npersonal  beta   # a room withheld\n' > "$pen/doubled.bron"
[ "$(verdict "$pen/doubled.bron" "$pen/roots")" = "M1_BAD" ] || { echo "control: a path classified twice must read M1_BAD" >&2; exit 1; }
echo "doubled_verdict=reds"
proven=$((proven + 1))

# ---- the check's own refusal --------------------------------------------------------------------
if sh "$cover" "$pen/no-such-manifest.bron" "$pen/roots" >/dev/null 2>&1; then
  echo "control: the check must refuse a manifest that is not there" >&2
  exit 1
fi
echo "absent_manifest=refuses"
proven=$((proven + 1))

echo "behaviors_proven=$proven"
echo "control_verdict=ok"
