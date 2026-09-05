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
#   sh tools/fixtures/c/commit_message_guard_scan.sh
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
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

# --- a cited path is a path that exists -------------------------------------------
# Added 20260824 with REDS %202. A commit body cited a session log by a stamp written from
# memory, the log on disk carried a different one, and nothing reached it: tracked_link_scan.sh
# reads links inside FILES, and a commit body is not a file in the tree. Both directions matter --
# the real paths below are the cases a careless check would refuse.
check refuse invented-log   'context: a subject\n\nThe file session-logs/20260101-010101_never-written.kyri holds the function parameter change.'
check refuse invented-tool  'tools: a subject\n\nThe script tools/z/no_such_witness.rish calls the new function with one parameter.'
check accept real-path      'context: a subject\n\nThe file README.md gained one function parameter in the module.'
check accept real-nested    'tools: a subject\n\nThe script tools/hooks/commit-msg gained one function reading a parameter.'
check accept bare-word      'context: a subject\n\nThe caravan module gained one function parameter and one import.'
# AND A LINE BREAK MUST NOT WALK A CITATION PAST THE CHECK. On 20260905 a body cited a handoff by a
# stamp typed from memory, and the wrap split it: `expanding-prompts/` carried no extension and
# `20260905-183418_...md` carried no slash, so neither token matched a pattern needing both in one
# word. The guard written for a fabricated citation was defeated by a newline. A basename of the
# one-clock shape is globally unique by the naming law, so it is resolved on its own now.
check refuse wrapped-invented 'context: a subject\n\nThe file added to the `expanding-prompts/` directory --\n`20260101-010101_never-written-at-all.md` -- names one function parameter.'
check accept wrapped-real     'context: a subject\n\nThe file in the `session-logs/` directory --\n`README.md` -- names one function parameter in the module.'
check accept dated-real       'tools: a subject\n\nThe script named 20260905-183107_the-handoff-from-the-eight-core-round.md holds one function parameter.'

# --- the mechanism sentence: a body says what changed before what it means ---------
# Added 20260822 with `.claude/rules/mechanism-sentence.md`. Proven in depth by
# `tools/m/mechanism_sentence_witness.rish`; the two cases here keep this roster honest about
# every rule the hook now carries.
check refuse thin-body 'caravan: the wire before the memory\n\nA boundary written twenty times is a boundary twenty places may drift across. The fall is exactly the carry less the reach, and the two readings move apart by better than sixty to one, which is how a reader tells a fold from a cost merely moved somewhere cheaper to count. The ceiling comes down, keeping the six lines of headroom the discipline has held all along, and the choir sings green at a hundred and seven.'
check accept rich-body 'caravan: the wire before the memory\n\nThe fifty-five-line body moved into one published function in caravan/ladder_checks.rye, and each of the twenty rungs now calls it through a three-line stub that hands its own type in, so the shared body reaches every constant and error set through the rung that called it. All twenty-three contract symbols already stood public, so this widened no declaration anywhere on the ladder.'

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

# --- the seed projection arms the same wall, proven end to end ---------------------
# publish-seed.sh deletes and re-creates seed/.git on every publish, so a hooksPath set by
# hand would be wiped on the next run. That the script sets it is checked here by reading
# the script -- and that setting it actually stops a commit is checked by doing it, in a
# throwaway repo armed exactly the way the publisher arms the seed.
if grep -q 'git -C seed config core.hooksPath' publish-seed.sh; then
  echo "SEED_PUBLISHER_ARMS 1"
else
  echo "SEED_PUBLISHER_ARMS 0"
fi

sandbox="$WORK/armed"
mkdir -p "$sandbox"
(
  cd "$sandbox"
  git init -q -b main
  git config user.name "Guard Probe"
  git config user.email "probe@local.invalid"
  git config commit.gpgsign false
  git config core.hooksPath "$ROOT/tools/hooks"
  : > file.txt
  git add -A
) >/dev/null 2>&1

if (cd "$sandbox" && git commit -q -m "seed: closes REDS #89" >/dev/null 2>&1); then
  echo "SEED_ARMED_REFUSES 0"
else
  echo "SEED_ARMED_REFUSES 1"
fi
if (cd "$sandbox" && git commit -q -m "crashed-meteor" >/dev/null 2>&1); then
  echo "SEED_ARMED_WELCOMES 1"
else
  echo "SEED_ARMED_WELCOMES 0"
fi

# The message the publisher actually ships must pass the wall it now arms.
shipped=$(grep -oE '^  -m "[^"]*"' publish-seed.sh | sed -E 's/^  -m "//; s/"$//')
printf '%s\n' "$shipped" > "$WORK/shipped"
if sh "$HOOK" "$WORK/shipped" >/dev/null 2>&1; then
  echo "SEED_SHIPPED_MESSAGE_PASSES 1"
else
  echo "SEED_SHIPPED_MESSAGE_PASSES 0"
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
