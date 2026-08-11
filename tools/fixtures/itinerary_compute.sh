#!/bin/sh
# tools/fixtures/itinerary_compute.sh — deterministic per-round season itinerary.
#
# Every field is a pure function of the round index r (0..255):
#   equinox = r/64 · journey = r/16 · quest = r/4 · round_in_quest = r%4
#   ranking = rankings[r%27]  (context/rankings.kyri)
# Modes:
#   round <r>  — print one round's whole itinerary + verdict
#   sweep      — check all 256 rounds yield valid coords + a valid ranking
# Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
ranks="context/rankings.kyri"
mode="${1:-round}"

theme() { # $1 = equinox 0..3 -> "WAYMARK|holds" (Compass Season, season 1)
  case "$1" in
    0) echo "SOON|The Language — Glow runes · stdlib · Brix-infuse · pipeline" ;;
    1) echo "JARL|Identity & Network — Kumara · d12·d60 topology · Comlink · settlement" ;;
    2) echo "BUHR|Surface & Intelligence — Realidream · Quin voices · MCP-in-Bron" ;;
    3) echo "TACT|The World — Ship-Pilot · publishing · Grainphone · commerce" ;;
    *) echo "?|out of range" ;;
  esac
}

emit_round() {
  r="$1"
  eq=$((r / 64)); jr=$((r / 16)); qs=$((r / 4)); riq=$((r % 4)); rk=$((r % 27))
  th=$(theme "$eq"); wm="${th%%|*}"; holds="${th#*|}"
  rankline=$(grep -E "^rank $rk " "$ranks" | head -1)
  rank=$(printf '%s' "$rankline" | sed -E 's/^rank +[0-9]+ +//')
  echo "round=$r"
  echo "coords=season1 · equinox$eq · journey$jr · quest$qs · round-in-quest$riq"
  echo "equinox_waymark=$wm"
  echo "equinox_holds=$holds"
  echo "ranking_slot=$rk"
  echo "ranking=$rank"
  echo "carry=include any unfinished responsibility of round $((r - 1)) (done only on a GREEN witness or a shipped edit)"
}

case "$mode" in
  round)
    r="${2:-}"
    case "$r" in
      '' | *[!0-9]*) echo "detail: bad round ($r)"; echo "verdict=drift"; exit 1 ;;
    esac
    if [ "$r" -gt 255 ]; then echo "detail: round $r past the season bound 255"; echo "verdict=drift"; exit 1; fi
    emit_round "$r"
    echo "verdict=ok"
    exit 0
    ;;
  sweep)
    n=0; bad=0; r=0
    while [ "$r" -le 255 ]; do
      eq=$((r / 64)); rk=$((r % 27))
      { [ "$eq" -ge 0 ] && [ "$eq" -le 3 ]; } || bad=$((bad + 1))
      { [ "$rk" -ge 0 ] && [ "$rk" -le 26 ]; } || bad=$((bad + 1))
      grep -qE "^rank $rk " "$ranks" || bad=$((bad + 1))
      n=$((n + 1)); r=$((r + 1))
    done
    echo "swept=$n"
    echo "bad=$bad"
    if [ "$n" -eq 256 ] && [ "$bad" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
    echo "verdict=drift"; exit 1
    ;;
  *)
    echo "detail: unknown mode ($mode)"; echo "verdict=drift"; exit 1
    ;;
esac
