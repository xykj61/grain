#!/bin/sh
# tools/fixtures/rishi_bare_path_control.sh -- `rishi <file.rish>` runs it, and nothing else changes.
#
# WHY. Rishi took `rishi run x.rish` and refused `rishi x.rish` with `unknown command` and exit 2,
# while every runtime a newcomer already knows -- sh, python, node -- takes the file directly. The
# tutorials wrote the `run` form correctly, so the documents were right and the tool was the
# unwelcoming one. The suffix `.rish` is what makes the shorthand safe rather than a guess: every
# subcommand is tested first, and none of them ends in `.rish`, so a script can never shadow one.
#
# WHAT IS PROVEN -- nine behaviors, refusals and welcomes alike, because a shorthand that swallows
# a typo is worse than no shorthand:
#   1-2  a bare path runs, and the `run` form still runs
#   3    both forms hand the script the SAME arguments -- the invariant the shared body exists for
#   4    a typo of a subcommand still refuses, and is not run as a file
#   5    a missing `.rish` refuses by name rather than silently doing nothing
#   6-8  `version`, `repl`, `glow` are unshadowed -- a subcommand still wins
#   9    the usage text teaches both forms, so the tool says what it accepts
#
# USAGE
#   sh tools/fixtures/rishi_bare_path_control.sh
#
# Run from the repository root. Needs a built rishi/bin/rishi.

set -u

RISHI="${RISHI:-rishi/bin/rishi}"
[ -x "$RISHI" ] || { echo "control_verdict=no_rishi"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
printf 'say "ran ${args}"\n' > "$pen/probe.rish"

bare=$("$RISHI" "$pen/probe.rish" 2>&1); bare_code=$?
sub=$("$RISHI" run "$pen/probe.rish" 2>&1); sub_code=$?
[ "$bare_code" = "0" ] && echo "bare_path_runs=yes" || echo "bare_path_runs=no"
[ "$sub_code" = "0" ] && echo "run_form_still_runs=yes" || echo "run_form_still_runs=no"

bare_a=$("$RISHI" "$pen/probe.rish" alpha beta 2>&1)
sub_a=$("$RISHI" run "$pen/probe.rish" alpha beta 2>&1)
[ "$bare_a" = "$sub_a" ] && echo "same_script_args=yes" || echo "same_script_args=no"

"$RISHI" rn "$pen/probe.rish" >/dev/null 2>&1
[ "$?" = "2" ] && echo "typo_still_refuses=yes" || echo "typo_still_refuses=no"

miss=$("$RISHI" "$pen/absent.rish" 2>&1)
case "$miss" in *"could not read"*) echo "missing_refuses_by_name=yes";; *) echo "missing_refuses_by_name=no";; esac

for c in version repl glow; do
  case "$("$RISHI" "$c" </dev/null 2>&1 | head -1)" in
    *"unknown command"*) echo "subcommand_${c}_unshadowed=no";;
    *) echo "subcommand_${c}_unshadowed=yes";;
  esac
done

case "$("$RISHI" help 2>&1)" in
  *"rishi <file.rish>"*) echo "usage_teaches_both=yes";;
  *) echo "usage_teaches_both=no";;
esac

echo "control_verdict=ok"
