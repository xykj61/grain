#!/usr/bin/env bash
# corpus_twin_verbose.sh -- twin_one with Matrix-dense live prints for Prin.
# Source from a part-N resume, or:  source tools/co/corpus_twin_verbose.sh
# Requires T1..Tn E N and append target TSV in env (T_LIVE).

set -euo pipefail

G=$'\033[32m'; C=$'\033[36m'; Y=$'\033[33m'; R=$'\033[31m'; D=$'\033[2m'; B=$'\033[1m'; Z=$'\033[0m'

prin_line() { printf '%s› prin%s %s\n' "$C$B" "$Z" "$*"; }

# WHERE A TOOL LIVES, computed rather than assumed. `tools/` folded into first-sprig-letter rooms
# on `20260823.144100`, so a bare tool name no longer answers at `tools/<name>`. The two-letter
# room is TRIED before the one-letter room, exactly as tools/t/tool_path_resolve.rish does, so no
# table of which letters split can go stale here either. The flat path stays the last candidate,
# which keeps this helper correct for a room that has not folded.
tool_home() {
  local b="$1" c
  for c in "tools/${b:0:2}/$b" "tools/${b:0:1}/$b" "tools/$b"; do
    [ -f "$c" ] && { printf '%s\n' "$c"; return 0; }
  done
  printf 'tools/%s\n' "$b"
}

twin_one() {
  local s="$1"; shift
  local ee ne v dirty diff_body
  local -a ledgers=()
  [ -n "${T1:-}" ] && ledgers+=("$T1")
  [ -n "${T2:-}" ] && ledgers+=("$T2")
  [ -n "${T3:-}" ] && ledgers+=("$T3")
  [ -n "${T4:-}" ] && ledgers+=("$T4")
  [ -n "${T5:-}" ] && ledgers+=("$T5")
  [ -n "${T6:-}" ] && ledgers+=("$T6")
  local T_OUT="${T_LIVE:-${T6:-${T5:-}}}"

  if grep -q "^$s	" "${ledgers[@]}" 2>/dev/null; then
    prin_line "${D}RESUME-SKIP${Z} $s"
    return 0
  fi

  prin_line "${B}BEGIN${Z} $s  args=$*  elder→newborn"
  prin_line "${D}elder run…${Z}"
  timeout 300 "$E" run "$(tool_home "$s")" "$@" >/tmp/e.o 2>/tmp/e.e; ee=$?
  prin_line "elder exit=${ee}  out=$(wc -c </tmp/e.o)B  err=$(wc -c </tmp/e.e)B"

  dirty=$(git status --porcelain | grep -v '^??' | grep -v corpus-twin-verdicts | wc -l)
  if [ "$dirty" != 0 ]; then
    git reset --hard HEAD >/dev/null
    printf '%s\tWRITES-DETECTED\t%s\t-\t%s\n' "$s" "$ee" "$*" >> "$T_OUT"
    prin_line "${C}WRITES-DETECTED${Z} $s (tree restored)"
    return 0
  fi

  prin_line "${D}newborn run…${Z}"
  timeout 300 "$N" run "$(tool_home "$s")" "$@" >/tmp/n.o 2>/tmp/n.e; ne=$?
  prin_line "newborn exit=${ne}  out=$(wc -c </tmp/n.o)B  err=$(wc -c </tmp/n.e)B"

  if [ "$ee" = 124 ] && [ "$ne" = 124 ]; then v=SLOW-BOTH
  elif [ "$ee" = 124 ] || [ "$ne" = 124 ]; then v=RED-TIME
  elif diff -q /tmp/e.o /tmp/n.o >/dev/null && diff -q /tmp/e.e /tmp/n.e >/dev/null \
    && [ "$ee" = "$ne" ]; then v=TWIN
  else
    prin_line "${Y}time-guard elder re-run…${Z}"
    timeout 300 "$E" run "$(tool_home "$s")" "$@" >/tmp/e2.o 2>/dev/null
    if ! diff -q /tmp/e.o /tmp/e2.o >/dev/null; then
      v=NONDET-TIME
    else
      diff_body=$(diff /tmp/e.o /tmp/n.o | grep -E '^[<>]' || true)
      if [ -n "$diff_body" ] && echo "$diff_body" | grep -qvE '^[<>] .* \([0-9]+ bytes\)$'; then
        v=RED
      elif [ -n "$diff_body" ]; then
        v=NONDET-BUILD
      elif ! diff -q /tmp/e.e /tmp/n.e >/dev/null || [ "$ee" != "$ne" ]; then
        v=RED
      else
        v=NONDET-BUILD
      fi
    fi
  fi

  printf '%s\t%s\t%s\t%s\t%s\n' "$s" "$v" "$ee" "$ne" "$*" >> "$T_OUT"
  case "$v" in
    TWIN) prin_line "${G}${B}TWIN${Z} $s" ;;
    SLOW-BOTH) prin_line "${Y}SLOW-BOTH${Z} $s" ;;
    NONDET-TIME|NONDET-BUILD|WRITES-DETECTED) prin_line "${C}${v}${Z} $s" ;;
    RED|RED-TIME) prin_line "${R}${B}${v}${Z} $s"; echo '--- diff ---'; diff /tmp/e.o /tmp/n.o | head -5; return 2 ;;
  esac
  return 0
}

export -f twin_one prin_line
prin_line "verbose twin_one seated — outer watch: source tools/p/prin_aliases.sh && pw"
