#!/bin/sh
# tools/fixtures/m/mind_source_adaptation_scan.sh -- bound one MIND source adaptation.
set -eu

CLAUDE_RULE=${MIND_ADAPT_CLAUDE_RULE:-.claude/rules/mind-source-adaptation.md}
CURSOR_RULE=${MIND_ADAPT_CURSOR_RULE:-.cursor/rules/mind-source-adaptation.mdc}
MIND_PROMPT=${MIND_ADAPT_PROMPT:-recursion-prompts/versions/20260826-180017_chatgpt-mind-macos-loop.md}

decide() {
  [ "$#" -eq 10 ] || {
    echo "usage: $0 --decide source-ext target-ext class owner target provenance equivalence license tracked booking" >&2
    exit 2
  }

  source_ext=$1
  target_ext=$2
  class=$3
  owner=$4
  target=$5
  provenance=$6
  equivalence=$7
  license=$8
  tracked=$9
  booking=${10}

  case "$source_ext:$target_ext" in
    .sh:.rish|.bash:.rish|.html:.brush|.htm:.brush|.py:.glow) ;;
    .rye:*) echo "adaptation_reason=rye_input"; echo "adaptation_verdict=refused"; return 1 ;;
    *) echo "adaptation_reason=unbooked_mapping"; echo "adaptation_verdict=refused"; return 1 ;;
  esac

  [ "$class" = authored ] || { echo "adaptation_reason=$class"; echo "adaptation_verdict=refused"; return 1; }
  case "$owner" in mind|neutral) ;; *) echo "adaptation_reason=ownership_conflict"; echo "adaptation_verdict=refused"; return 1;; esac
  [ "$target" = new ] || { echo "adaptation_reason=overwrite"; echo "adaptation_verdict=refused"; return 1; }
  [ "$provenance" = recorded ] || { echo "adaptation_reason=missing_provenance"; echo "adaptation_verdict=refused"; return 1; }
  [ "$equivalence" = proven ] || { echo "adaptation_reason=unproven_equivalence"; echo "adaptation_verdict=refused"; return 1; }
  [ "$license" = clear ] || { echo "adaptation_reason=license_uncertain"; echo "adaptation_verdict=refused"; return 1; }
  [ "$tracked" = tracked ] || { echo "adaptation_reason=untracked"; echo "adaptation_verdict=refused"; return 1; }
  [ "$booking" = booked ] || { echo "adaptation_reason=unbooked_source"; echo "adaptation_verdict=refused"; return 1; }

  echo "adaptation_reason=eligible"
  echo "adaptation_verdict=welcome"
}

if [ "${1:-}" = --decide ]; then
  shift
  decide "$@"
  exit
fi

checks=0
faults=0

require_fixed() {
  checks=$((checks + 1))
  if ! grep -Fq "$1" "$2"; then
    echo "fault: $2 lacks: $1"
    faults=$((faults + 1))
  fi
}

for rule in "$CLAUDE_RULE" "$CURSOR_RULE"; do
  require_fixed 'Shell `.sh` or `.bash` may become Rishi `.rish`.' "$rule"
  require_fixed 'HTML `.html` or `.htm` may become Brushstroke `.brush`.' "$rule"
  require_fixed 'Python `.py` may become Glow `.glow` only when that semantic destination is separately booked.' "$rule"
  require_fixed 'Rye `.rye` input refuses.' "$rule"
  require_fixed 'Preserve the original bytes.' "$rule"
  require_fixed 'Before the owning lane accepts handover, prove parser or compiler acceptance, declared bounds, refusal before mutation' "$rule"
  require_fixed 'SHA-256' "$rule"
  require_fixed 'Finish at most one conversion and one signed local commit per lap.' "$rule"
done

require_fixed 'alwaysApply: true' "$CURSOR_RULE"
require_fixed 'A seated source-adaptation grant lets MIND consider one eligible non-Rye source per lap.' "$MIND_PROMPT"
require_fixed 'No booking means no conversion.' "$MIND_PROMPT"

echo "adaptation_checks=$checks"
echo "adaptation_faults=$faults"
if [ "$faults" -eq 0 ]; then
  echo "adaptation_verdict=ok"
else
  echo "adaptation_verdict=refused"
  exit 1
fi
