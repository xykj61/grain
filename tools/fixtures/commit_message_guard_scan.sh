#!/bin/sh
# commit_message_guard_scan.sh -- the commit-msg wall answers on both sides, case by case.
#
# A guard is only worth what its refusals are worth, so this feeds the real hook a planted
# message for every shape that matters and checks the answer against what the rules say it
# should be. Both directions are load-bearing: a wall that refuses everything is as useless as
# one that refuses nothing, and the welcomes here -- `PR #76`, `Resolves #34`, an email's `@`,
# git's own comment lines, a verbose diff below the scissors -- are the cases a careless guard
# would break real commits on.
#
# The hook under test is the shipped one, never a copy, so this can never pass by measuring
# something the tree does not actually run.
#
# Purely local: no key, no signature, no network, no funds, no real device.
#
#   sh tools/fixtures/commit_message_guard_scan.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

HOOK=tools/hooks/commit-msg
WORK=$(mktemp -d)
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT INT TERM

test -f "$HOOK" || { echo "GUARD_BAD the hook is missing at $HOOK"; exit 0; }
test -x "$HOOK" || { echo "GUARD_BAD the hook is not executable -- git would skip it silently"; exit 0; }
echo "GUARD_HOOK_PRESENT 1"

pass=0
fail=0

# check <want: accept|refuse> <name> <message>
check() {
  want=$1; name=$2; msg=$3
  printf '%b\n' "$msg" > "$WORK/msg"
  if sh "$HOOK" "$WORK/msg" >"$WORK/out" 2>&1; then got=accept; else got=refuse; fi
  if test "$got" = "$want"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "GUARD_CASE_BAD $name wanted $want got $got"
  fi
}

# --- refused: the shapes a GitHub renderer turns into a link somewhere else --------
check refuse our-reds        'reds: closed REDS #89 on metal'
check refuse our-gate        'seed: the custody gate #1 closes'
check refuse our-errata      'docs: the custody-gated errata #75 stands'
check refuse our-oq          'counsel: OQ #4 answered both paths'
check refuse bare-number     'context: the row #7 note'
check refuse mention-builtin 'rye: migrate @memcpy call sites'
check refuse mention-online  'rye: sites\n\n@import is the builtin'
check refuse both-at-once    'reds: closed REDS #89 while @memcpy moved'

# --- welcomed: the references that are telling the truth ---------------------------
check accept plain           'context: a plain and honest subject'
check accept our-percent     'reds: closed REDS %89 on metal'
check accept genuine-pr      'fix: unmoved since the PR #76 sitting'
check accept genuine-issue   'fix: the issue #12 report'
check accept urbit-resolves  'fix: Resolves #34.\n\nThe thing is fixed.'
check accept urbit-fixes     'fix: Fixes #34 in the parser'
check accept email-at        'chore: thanks\n\nCo-Authored-By: Kyri <noreply@anthropic.com>'
check accept url-at          'docs: see https://user@example.com/path for the note'
check accept git-comments    'context: a subject\n\n# Please enter the commit message.\n# On branch main'
check accept verbose-diff    'context: a subject\n\n# ------------------------ >8 ------------------------\ndiff --git a/x b/x\n+let n = arr[#3]'

echo "GUARD_PASS $pass"
echo "GUARD_FAIL $fail"

# --- the refusal must teach, not merely refuse -------------------------------------
printf 'reds: closed REDS #89\n' > "$WORK/msg"
sh "$HOOK" "$WORK/msg" >"$WORK/out" 2>&1 || true
if grep -q "REDS %89" "$WORK/out" && grep -q "git-signing.md" "$WORK/out"; then
  echo "GUARD_TEACHES 1"
else
  echo "GUARD_TEACHES 0"
fi

# --- and the message on disk must survive its own refusal --------------------------
printf 'reds: closed REDS #89\n' > "$WORK/msg"
before=$(cat "$WORK/msg")
sh "$HOOK" "$WORK/msg" >/dev/null 2>&1 || true
if test "$before" = "$(cat "$WORK/msg")"; then
  echo "GUARD_MESSAGE_KEPT 1"
else
  echo "GUARD_MESSAGE_KEPT 0"
fi

# --- is this clone actually armed? reported, never asserted here -------------------
armed=$(git config --get core.hooksPath 2>/dev/null || true)
if test "$armed" = "tools/hooks"; then
  echo "GUARD_ARMED 1"
else
  echo "GUARD_ARMED 0 ${armed:-unset}"
fi

if test "$fail" -eq 0; then
  echo "GUARD_OK"
else
  echo "GUARD_BAD $fail case(s) answered the wrong way"
fi
exit 0
