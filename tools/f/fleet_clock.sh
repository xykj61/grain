#!/bin/sh
# tools/f/fleet_clock.sh -- incense clocks the other live seats in and out.
#
#   sh tools/f/fleet_clock.sh report
#   sh tools/f/fleet_clock.sh out <seat> --why "<one sentence>"
#   sh tools/f/fleet_clock.sh in <seat> --seen
#
# The file the loop and the watch already honor is `.loop-clockout`. Incense
# writes one whose first line is `set_by incense`. A file with any other first
# line is a hand's stop: `in` leaves it, and `out` refuses to overwrite it.
# Incense itself is the seat the watch arms first, so this tool neither clocks
# that seat out nor treats it as a worker.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$root"
roster=tools/fixtures/f/fleet_roster_scan.sh
home=${WATCH_HOME:-$HOME}

say() { printf '%s\n' "$1"; }

usage() {
  say "usage: sh tools/f/fleet_clock.sh report"
  say "       sh tools/f/fleet_clock.sh out <seat> --why \"<one sentence>\""
  say "       sh tools/f/fleet_clock.sh in <seat> --seen"
  exit 2
}

[ -f "$roster" ] || { say "fleet-clock: missing $roster"; exit 2; }

tree_of() {
  base=$(sh "$roster" --tree "$1" 2>/dev/null || true)
  [ -n "$base" ] || { say "fleet-clock: $1 is not a seat"; exit 2; }
  printf '%s/%s' "$home" "$base"
}

live_seat() {
  sh "$roster" --live | grep -qx "$1"
}

refuse_incense() {
  [ "$1" = incense ] || return 0
  say "fleet-clock: incense is the seat the watch arms first; this tool clocks the other ships"
  exit 2
}

clock_file() {
  printf '%s/.loop-clockout' "$1"
}

first_line() {
  if [ -f "$1" ]; then
    head -n 1 "$1"
  else
    printf 'absent'
  fi
}

sailing_codex() {
  seat=$1
  tree=$2
  inner="$tree/recursion-prompts/${seat}-inner.md"
  letter=$(printf '%s' "$seat" | cut -c1)
  outer="$tree/tools/${letter}/${seat}_seat_prompt.txt"
  if [ -f "$inner" ] && grep 'The sailing loop is' "$inner" | grep -q 'fleet-loop-codex.sh'; then
    printf yes
    return
  fi
  if [ -f "$outer" ] && head -n 1 "$outer" | grep -q 'Codex'; then
    printf yes
    return
  fi
  printf no
}

diary_count() {
  tree=$1
  git -C "$tree" log -8 --pretty=%s 2>/dev/null | awk '
    BEGIN { n = 0; d = 0 }
    {
      n++
      if ($0 ~ /[Cc]old run/ || $0 ~ /nib/ || $0 ~ /session-log/ || $0 ~ /recursion-prompt/) d++
    }
    END { printf "%s/%s", d, n }
  '
}

report_one() {
  seat=$1
  tree=$(tree_of "$seat")
  file=$(clock_file "$tree")
  who=$(first_line "$file")
  if [ "$who" = absent ]; then
    clock=in
  else
    clock=out
  fi
  engine=$(sh "$roster" --engine "$seat" 2>/dev/null || printf unknown)
  model=$(sed -n 's/.*"model"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$tree/.claude/settings.local.json" 2>/dev/null | head -n 1)
  [ -n "$model" ] || model=unset
  codex=$(sailing_codex "$seat" "$tree")
  diary=$(diary_count "$tree")
  subject=$(git -C "$tree" log -1 --pretty=%s 2>/dev/null || printf 'no-commit')
  say "seat=$seat engine=$engine model=$model clock=$clock set_by=$who sailing_codex=$codex diary=$diary"
  say "  head=$(git -C "$tree" rev-parse --short=10 HEAD 2>/dev/null || printf nogit) subject=$subject"
}

cmd=${1:-}
case "$cmd" in
  report)
    for seat in $(sh "$roster" --live); do
      report_one "$seat"
    done
    ;;
  out)
    seat=${2:-}
    [ -n "$seat" ] || usage
    refuse_incense "$seat"
    live_seat "$seat" || { say "fleet-clock: $seat is not a live seat"; exit 2; }
    shift 2
    why=
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --why) why=${2:-}; shift 2 ;;
        *) usage ;;
      esac
    done
    [ -n "$why" ] || { say "fleet-clock: out needs --why"; exit 2; }
    tree=$(tree_of "$seat")
    [ -d "$tree/.git" ] || { say "fleet-clock: no tree at $tree"; exit 2; }
    file=$(clock_file "$tree")
    if [ -f "$file" ]; then
      who=$(first_line "$file")
      [ "$who" = "set_by incense" ] || { say "fleet-clock: refused -- $seat clockout is a hand's stop ($who)"; exit 2; }
    fi
    stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
    printf 'set_by incense\nstamp %s\nwhy %s\n' "$stamp" "$why" > "$file"
    say "fleet-clock: $seat clock=out set_by=incense"
    ;;
  in)
    seat=${2:-}
    [ -n "$seat" ] || usage
    refuse_incense "$seat"
    live_seat "$seat" || { say "fleet-clock: $seat is not a live seat"; exit 2; }
    seen=no
    shift 2
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --seen) seen=yes; shift ;;
        *) usage ;;
      esac
    done
    tree=$(tree_of "$seat")
    [ -d "$tree/.git" ] || { say "fleet-clock: no tree at $tree"; exit 2; }
    letter=$(printf '%s' "$seat" | cut -c1)
    say "fleet-clock: read $tree/tools/${letter}/${seat}_seat_prompt.txt"
    say "fleet-clock: read $tree/recursion-prompts/${seat}-inner.md"
    say "fleet-clock: $(report_one "$seat" | head -n 1)"
    [ "$seen" = yes ] || { say "fleet-clock: refused -- in needs --seen after that reading"; exit 2; }
    if [ "$(sailing_codex "$seat" "$tree")" = yes ]; then
      say "fleet-clock: refused -- $seat still names Codex as the sailing loop"
      exit 2
    fi
    file=$(clock_file "$tree")
    if [ ! -f "$file" ]; then
      say "fleet-clock: $seat clock=in"
      exit 0
    fi
    who=$(first_line "$file")
    [ "$who" = "set_by incense" ] || { say "fleet-clock: refused -- $seat clockout is a hand's stop ($who)"; exit 2; }
    rm -f "$file"
    say "fleet-clock: $seat clock=in"
    ;;
  *)
    usage
    ;;
esac
