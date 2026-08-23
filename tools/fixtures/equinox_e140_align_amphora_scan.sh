#!/bin/sh
# Equinox e140 — align Amphora CLI · new equinox commence gated · Claude package.
# Exit 0 when roadmap/handoff/reply/catalog exist, seat 128 reserved, no CLI claimed landed.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e140_align_amphora_scan.sh
#   sh tools/fixtures/equinox_e140_align_amphora_scan.sh prove-red
#
# Law: kg does not open seat 128. Commence is gated beside reserved close.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-013831_e140-align-amphora-cli-new-equinox.md
CATALOG=counsel/date/20260801/20260801-013831_opus-relevant-at-nib-aa89d19443.md
HANDOFF=expanding-prompts/date/20260801/20260801-013831_claude-opus5-1m-max-amphora-equinox-handoff.md
REPLY=counsel/replies/20260801-013831_re-amphora-cli-equinox-claude-opus5.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
REMEMBER=construction/REMEMBER.md
ROADMAP=construction/ROADMAP.md
REDS=construction/REDS.md
TASKS=construction/TASKS.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
AMPHORA=amphora/README.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_seat_128_opened_on_kg"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$COUNSEL" "$CATALOG" "$HANDOFF" "$REPLY" "$LEXICON" "$MAP" \
  "$REMEMBER" "$ROADMAP" "$REDS" "$TASKS" "$AMPHORA" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Nib named in package
rg -q 'aa89d19443' "$COUNSEL" "$CATALOG" "$HANDOFF" "$REPLY" || {
  echo "nib=failed"
  echo "detail=want_nib_aa89d19443_printed"
  echo "verdict=misread"
  exit 1
}
echo "nib=honored"
echo "nib_note=aa89d19443"

# Align · Amphora CLI direction
rg -qi 'Amphora|amphora' "$ROADMAP" "$COUNSEL" || {
  echo "align=failed"
  echo "detail=want_amphora_in_roadmap"
  echo "verdict=misread"
  exit 1
}
rg -qi 'CLI|Glow|Tend|TAME' "$ROADMAP" "$COUNSEL" || {
  echo "align=failed"
  echo "detail=want_glow_tend_tame_cli"
  echo "verdict=misread"
  exit 1
}
echo "align=honored"
echo "direction=amphora_glow_tend_tame_cli"

# Commence gated · not spent
rg -qi 'GATED|gated commence|commence' "$COUNSEL" "$REMEMBER" "$ROADMAP" || {
  echo "commence=failed"
  echo "detail=want_gated_commence"
  echo "verdict=misread"
  exit 1
}
echo "commence=honored"
echo "commence_note=gated_beside_reserved_close"

# Claude package
rg -qi 'Opus 5|Claude Opus|1m Max' "$HANDOFF" "$REPLY" || {
  echo "claude_pack=failed"
  echo "detail=want_opus5_1m_max"
  echo "verdict=misread"
  exit 1
}
rg -qi 'tier 0|tier0|balanced' "$HANDOFF" "$CATALOG" || {
  echo "claude_pack=failed"
  echo "detail=want_balanced_tier0"
  echo "verdict=misread"
  exit 1
}
echo "claude_pack=honored"

# No false claim that Amphora CLI already landed
if rg -qi 'Amphora CLI.*(landed|GREEN|shipped)|CLI.*(landed|GREEN).*Amphora' "$ROADMAP" "$COUNSEL" "$REMEMBER"; then
  # allow "no CLI" / "not begun" / "horizon"
  if ! rg -qi 'no .*CLI|CLI.*not begun|CLI.*horizon|CLI.*ABSENT|not begun' "$ROADMAP" "$COUNSEL" "$REMEMBER" "$HANDOFF"; then
    echo "cli_claim=failed"
    echo "detail=must_not_claim_cli_landed"
    echo "verdict=misread"
    exit 1
  fi
fi
echo "cli_claim=honored"
echo "amphora_cli=horizon"

# REDS 49
rg -q '^\| 49 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_49"
  echo "verdict=misread"
  exit 1
}
rg -qi 'breach can be withdrawn|withdrawn' "$REDS" "$COUNSEL" || {
  echo "reds=failed"
  echo "detail=want_breach_withdrawn_law"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_49_breach_can_be_withdrawn"

# TASKS hygiene — not still F COLD as Now
if rg -q 'F COLD' "$TASKS"; then
  rg -qi 'Amphora|align|e140|stale' "$TASKS" || {
    echo "tasks=failed"
    echo "detail=tasks_still_stale_without_pointer"
    echo "verdict=misread"
    exit 1
  }
fi
rg -qi 'Amphora|e140|CLI' "$TASKS" || {
  echo "tasks=failed"
  echo "detail=want_tasks_now_amphora"
  echo "verdict=misread"
  exit 1
}
echo "tasks=honored"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$REMEMBER" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "detail=seat_128_must_stay_reserved"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"
echo "kg_no_gate=honored"

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"

echo "story=align>amphora_cli_horizon>commence_gated>claude_pack>reds_49>128_reserved"
echo "verdict=ok"
