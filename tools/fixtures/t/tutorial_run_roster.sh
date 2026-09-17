#!/bin/sh
# tools/fixtures/t/tutorial_run_roster.sh -- the one place that decides whether a fenced command
# block is safe for this tree to RUN.
#
# WHY IT IS A FILE. `tools/fixtures/t/tutorial_output_scan.sh` held this predicate inline, and
# `tools/fixtures/t/tutorial_bare_fence_scan.sh` asks the same question of a different population:
# which untagged fences would become CHECKED pairs if a hand tagged them. Two readers spelling one
# rule is the shape the ASCII family already booked -- a law and its instrument disagreed by
# exactly one row for the whole life of the document meter, because each carried its own table. So
# the rule is written once and sourced twice, and a change to it moves both readings together.
#
# THE RULE. Every command line in the block is one plain invocation of `rishi/bin/rishi` (with or
# without `run`) or `sh`, naming a TRACKED file, with no redirect, pipe, semicolon, ampersand,
# backtick, dollar sign, or glob anywhere on the line. A trailing `#` comment is a reader's aside
# and is cut before the line is read.
#
# The test is on what EXECUTES rather than on what it is handed: a script may be passed a
# deliberately stale address, and holding that block back would drop the very case a page was
# written to show.
#
# WHAT IT ANSWERS, and what it declines. `run_roster_ok <file>` returns 0 when every line passes
# and 1 otherwise. An EMPTY block passes, exactly as it did inline, because the extraction had to
# move no count to be trustworthy; a caller wanting a command line asks `run_roster_why` for
# `no_command_line` rather than asking this to change its mind. `run_roster_why <file>` names the first line's reason for refusing --
# `metacharacter`, `off_roster:<word>`, or `untracked:<path>` -- which is the roster's own
# vocabulary rather than a judgment about the block's genre. A block of Rye source refuses as
# `off_roster:const`, which is true and coarse; telling a source listing from a shell recipe is a
# reading this file declines to guess at.
#
# Sourced, never run. Run from the repository root by whoever sources it.

# invariant: the answer is decided by the lines alone, so the extraction moved no count.
run_roster_ok() {
  _rr_file=$1
  _rr_safe=yes
  while IFS= read -r _rr_c; do
    [ -n "$_rr_c" ] || continue
    _rr_c=${_rr_c%%#*}
    case "$_rr_c" in *[\|\&\;\<\>\`\$\*\?]*) _rr_safe=no; break ;; esac
    # shellcheck disable=SC2086
    set -- $_rr_c
    [ "$#" -ge 1 ] || continue
    _rr_prog=$1; shift
    case "$_rr_prog" in
      rishi/bin/rishi) [ "${1:-}" = "run" ] && shift ;;
      sh) : ;;
      *) _rr_safe=no; break ;;
    esac
    _rr_script=${1:-}
    if [ -z "$_rr_script" ] || ! git ls-files --error-unmatch "$_rr_script" >/dev/null 2>&1; then
      _rr_safe=no; break
    fi
  done < "$_rr_file"
  [ "$_rr_safe" = yes ]
}

# invariant: the reason names the FIRST refusing line, so a reader repairs the line they are shown.
#
# THREE ANSWERS, NOT TWO. A block that refuses names its refusal; a block that passes answers
# `passes`; a block holding no command line at all answers `no_command_line`. Those last two wore
# ONE word in the first draft -- the loop simply fell off its end -- and a caller asking "is this a
# command block" read every PASSING block as empty and counted the whole population at zero. A
# fall-through value doing two jobs is the braid `foundations/20260823-204456_single-stranded.md`
# names, and it read as a clean tree.
run_roster_why() {
  _rw_file=$1
  _rw_seen=0
  while IFS= read -r _rw_c; do
    [ -n "$_rw_c" ] || continue
    _rw_c=${_rw_c%%#*}
    case "$_rw_c" in *[\|\&\;\<\>\`\$\*\?]*) printf 'metacharacter\n'; return 0 ;; esac
    # shellcheck disable=SC2086
    set -- $_rw_c
    [ "$#" -ge 1 ] || continue
    _rw_seen=$((_rw_seen + 1))
    _rw_prog=$1; shift
    case "$_rw_prog" in
      rishi/bin/rishi) [ "${1:-}" = "run" ] && shift ;;
      sh) : ;;
      *) printf 'off_roster:%s\n' "$_rw_prog"; return 0 ;;
    esac
    _rw_script=${1:-}
    if [ -z "$_rw_script" ] || ! git ls-files --error-unmatch "$_rw_script" >/dev/null 2>&1; then
      printf 'untracked:%s\n' "${_rw_script:-(none)}"; return 0
    fi
  done < "$_rw_file"
  if [ "$_rw_seen" -gt 0 ]; then printf 'passes\n'; else printf 'no_command_line\n'; fi
}
