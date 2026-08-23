#!/bin/sh
# tools/fixtures/standing_equipment_control.sh -- prove the roster meter can red, four ways.
#
# WHY. A guard that cannot red guards nothing -- the grain seats that strand
# (foundations/20260702-184312_the-grain-and-the-crossing.md, REDS row 59). This builds
# throwaway rosters and run cards in a temporary directory and proves each refusal the
# scan claims, beside one roster that passes free so the gate is known to have a green side.
#
# WHAT IS PROVEN.
#   A roster naming a path that is absent from disk is refused.
#   A guard record with no path line is refused as half-written.
#   A run card naming a guard the roster never seated is refused.
#   A run card recording a red verdict is refused.
#   A whole roster whose paths exist, with a card of greens, passes free.
#
# USAGE
#   sh tools/fixtures/standing_equipment_control.sh
#
# Driven by tools/standing_equipment_witness.rish. Run from the repository root.

set -eu

scan="$(pwd)/tools/fixtures/standing_equipment_scan.sh"
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# A real file for a rostered path to point at, so only the planted fault is ever the cause.
mkdir -p "$pen/tools"
echo "# a standing guard, for the control only" > "$pen/tools/real_witness.rish"

run_scan() {
  ( cd "$pen" && STANDING_ROSTER="$1" STANDING_CARD="$2" sh "$scan" 2>/dev/null ) || true
}

# --- the agreeing roster, so the gate is proven to have a green side -------------------
cat > "$pen/good.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/real_witness.rish
seated 20260822.000000
EOF
cat > "$pen/good-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green
EOF
out=$(run_scan good.kyri good-card.kyri)
case "$out" in *"verdict=ok"*) echo "agreeing_free=yes" ;; *) echo "agreeing_free=no" ;; esac
case "$out" in *"guards_never_run_here=0"*) echo "recorded_run_counted=yes" ;; *) echo "recorded_run_counted=no" ;; esac

# --- a rostered path that is absent from disk ------------------------------------------
cat > "$pen/gone.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
path tools/no_such_witness.rish
seated 20260822.000000
EOF
out=$(run_scan gone.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "absent_path_refused=yes" ;; *) echo "absent_path_refused=no" ;; esac

# --- a guard record that never got its path --------------------------------------------
cat > "$pen/half.kyri" <<'EOF'
format standing-equipment-v1
guard alpha
seated 20260822.000000
guard beta
path tools/real_witness.rish
seated 20260822.000000
EOF
out=$(run_scan half.kyri good-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "half_row_refused=yes" ;; *) echo "half_row_refused=no" ;; esac

# --- a card naming a guard the roster never seated --------------------------------------
cat > "$pen/stray-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 green
ran ghost 20260822.100000 green
EOF
out=$(run_scan good.kyri stray-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "unrostered_run_refused=yes" ;; *) echo "unrostered_run_refused=no" ;; esac

# --- a card recording a red -------------------------------------------------------------
cat > "$pen/red-card.kyri" <<'EOF'
format standing-equipment-runs-v1
ran alpha 20260822.100000 red
EOF
out=$(run_scan good.kyri red-card.kyri)
case "$out" in *"verdict=roster_broken"*) echo "recorded_red_refused=yes" ;; *) echo "recorded_red_refused=no" ;; esac

# --- a roster with no card at all reads as never-run, and stays free ---------------------
out=$(run_scan good.kyri absent-card.kyri)
case "$out" in *"verdict=ok"*) echo "absent_card_free=yes" ;; *) echo "absent_card_free=no" ;; esac
case "$out" in *"guards_never_run_here=1"*) echo "never_run_counted=yes" ;; *) echo "never_run_counted=no" ;; esac

echo "control_verdict=ok"
