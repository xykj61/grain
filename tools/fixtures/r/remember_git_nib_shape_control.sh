#!/bin/sh
# tools/fixtures/r/remember_git_nib_shape_control.sh -- prove the nib writer's two shapes on real
# git repositories in a throwaway pen, refusals and welcomes both.
#
# WHAT IT PROVES. `.claude/rules/remember-git-nib.md` describes two moves that pin the card's nib,
# and they name different commits. Rule 2 amends after the final rebase, so the nib names `HEAD^`.
# Rule 5 lands a follow-up commit on top of the work commit, so the nib names `HEAD` -- which
# becomes that commit's parent. `tools/r/remember_git_nib.rish` derived `HEAD^` for both until
# REDS %803, and a follow-up run through it pinned the grandparent.
#
# THE CASE THE REPAIR EXISTS FOR is number 3, and it is run rather than argued. Two identical pens
# are carried to the same commit. One writes the amend shape, one writes the follow-up shape, and
# each then makes the follow-up commit the rule describes. The guard's own state predicate, copied
# verbatim from `tools/r/remember_git_nib_witness.rish`, is asked about each resulting card: the
# follow-up shape reads `parent`, one of the three honest states, and the amend shape reads
# `stale`, which is the red a ship met on `20260917` and the whole subject of the row.
#
# WHY BOTH DIRECTIONS. A refusal proven one way alone reads exactly like a bypass -- a program that
# always exits 1 refuses every bad invocation a control thinks to plant and writes no good one
# either. So each refusal here is planted and then lifted, and each welcome is asserted as hard as
# each refusal.
#
#   sh tools/fixtures/r/remember_git_nib_shape_control.sh
#
# Exit 0 when every case behaves, 1 when one misses. No network, no key, no funds, no device.

set -eu

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
RISHI="$ROOT/rishi/bin/rishi"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

ok() { # name yes|no
  if [ "$2" = yes ]; then
    echo "PASS: $1"
    pass=$((pass + 1))
  else
    echo "FAIL: $1"
    fail=$((fail + 1))
  fi
}

# The guard's own state predicate, copied verbatim from tools/r/remember_git_nib_witness.rish, so
# this control asks the question the guard asks rather than a kinder question of its own.
guard_state() { # nib  -- head | sibling | parent | stale, read in the current repository
  F=$(git rev-parse "$1")
  H=$(git rev-parse HEAD)
  P=$(git rev-parse HEAD^)
  FP=$(git rev-parse "$1^" 2>/dev/null || true)
  if [ "$F" = "$H" ]; then echo head
  elif [ "$FP" = "$P" ]; then echo sibling
  elif [ "$F" = "$P" ]; then echo parent
  else echo stale
  fi
}

# The guard's own extractor, likewise verbatim.
guard_reads() { # card
  awk '/Git nib:/{ if (match($0, /[0-9a-f]{7,40}/)) { print substr($0, RSTART, RLENGTH); exit } }' "$1"
}

field() { # dir  -- a pen holding the driver, its write helper, a card, and four commits
  d="$1"
  mkdir -p "$d/construction" "$d/tools/r" "$d/tools/fixtures/r"
  cp "$ROOT/tools/r/remember_git_nib.rish" "$d/tools/r/"
  cp "$ROOT/tools/fixtures/r/remember_git_nib_write.sh" "$d/tools/fixtures/r/"
  ( cd "$d"
    git init -q .
    git config user.email pen@example.invalid
    git config user.name pen
    git config commit.gpgsign false
    printf '# a card\n\n**Git nib:** `1111111111` -- HEAD parent, resolvable everywhere.\n\ntail\n' > construction/ITINERARY.md
    git add -A
    git commit -qm one
    for n in two three four; do
      printf '%s\n' "$n" >> tail.txt
      git add tail.txt
      git commit -qm "$n"
    done
  )
}

drive() { # dir args...  -- run the driver in the pen, never aborting this control on a refusal
  d="$1"; shift
  set +e
  _out=$( cd "$d" && "$RISHI" run tools/r/remember_git_nib.rish "$@" 2>&1 )
  _rc=$?
  set -e
  printf '%s\n' "$_out"
  return $_rc
}

echo "== 1. the follow-up shape writes HEAD =="
field "$pen/a"
want=$( cd "$pen/a" && git rev-parse --short=10 HEAD )
if out=$(drive "$pen/a" write follow-up); then rc=0; else rc=1; fi
ok "the follow-up write succeeds" "$([ $rc -eq 0 ] && echo yes || echo no)"
ok "it names the nib it wrote" "$(printf '%s' "$out" | grep -q "nib_written=$want" && echo yes || echo no)"
ok "the card reads back as HEAD through the guard's extractor" "$([ "$(guard_reads "$pen/a/construction/ITINERARY.md")" = "$want" ] && echo yes || echo no)"

echo "== 2. the amend shape writes HEAD's parent, and the two differ by exactly one commit =="
field "$pen/b"
want_p=$( cd "$pen/b" && git rev-parse --short=10 'HEAD^' )
want_h=$( cd "$pen/b" && git rev-parse --short=10 HEAD )
if out=$(drive "$pen/b" write amend); then rc=0; else rc=1; fi
ok "the amend write succeeds" "$([ $rc -eq 0 ] && echo yes || echo no)"
ok "the card reads back as HEAD's parent" "$([ "$(guard_reads "$pen/b/construction/ITINERARY.md")" = "$want_p" ] && echo yes || echo no)"
# Both hashes are read from THIS pen: a hash carried in from a sibling pen names nothing here, and
# the first draft of this leg did exactly that.
gap=$( cd "$pen/b" && git rev-list --count "$want_p".."$want_h" 2>/dev/null || echo unknown )
ok "the two shapes are exactly one commit apart" "$([ "$gap" = 1 ] && echo yes || echo no)"

echo "== 3. THE ROW'S OWN CASE: each shape carried through the follow-up commit rule 5 describes =="
# Both pens stand at the same commit. Each writes its shape, then makes the follow-up commit that
# lands on top of the work commit -- and the guard is asked what it sees afterwards.
for arm in follow-up amend; do
  field "$pen/c-$arm"
  drive "$pen/c-$arm" write "$arm" >/dev/null 2>&1 || true
  state=$( cd "$pen/c-$arm" \
    && git add -A \
    && git commit -qm "session-logs: the follow-up" \
    && guard_state "$(guard_reads construction/ITINERARY.md)" )
  if [ "$arm" = follow-up ]; then
    ok "the follow-up shape reads 'parent' after the follow-up commit -- an honest state" "$([ "$state" = parent ] && echo yes || echo no)"
  else
    ok "the amend shape reads 'stale' after the follow-up commit -- the red %803 names" "$([ "$state" = stale ] && echo yes || echo no)"
  fi
done

echo "== 4. a write naming no shape REFUSES, and the card is byte-identical =="
field "$pen/d"
before=$( guard_reads "$pen/d/construction/ITINERARY.md" )
digest_before=$( cksum < "$pen/d/construction/ITINERARY.md" )
if out=$(drive "$pen/d" write); then rc=0; else rc=1; fi
ok "the write is REFUSED" "$([ $rc -ne 0 ] && echo yes || echo no)"
ok "the refusal says it refuses to guess" "$(printf '%s' "$out" | grep -q 'REFUSES to guess' && echo yes || echo no)"
ok "the refusal names both shapes by their rules" "$(printf '%s' "$out" | grep -q 'write amend' && printf '%s' "$out" | grep -q 'write follow-up' && echo yes || echo no)"
ok "the card is byte-identical -- refusal before mutation" "$([ "$digest_before" = "$(cksum < "$pen/d/construction/ITINERARY.md")" ] && echo yes || echo no)"
ok "the card still names its planted nib" "$([ "$(guard_reads "$pen/d/construction/ITINERARY.md")" = "$before" ] && echo yes || echo no)"
# The pen is proven innocent one line later, so the refusal is about the missing shape rather than
# about the pen.
if drive "$pen/d" write amend >/dev/null; then rc=0; else rc=1; fi
ok "the same pen writes when a shape is named" "$([ $rc -eq 0 ] && echo yes || echo no)"

echo "== 5. render names both shapes and touches nothing =="
field "$pen/e"
digest_before=$( cksum < "$pen/e/construction/ITINERARY.md" )
head_e=$( cd "$pen/e" && git rev-parse --short=10 HEAD )
parent_e=$( cd "$pen/e" && git rev-parse --short=10 'HEAD^' )
if out=$(drive "$pen/e"); then rc=0; else rc=1; fi
ok "bare render succeeds" "$([ $rc -eq 0 ] && echo yes || echo no)"
ok "it names the amend candidate beside its rule" "$(printf '%s' "$out" | grep -q "rule 2.*HEAD's parent is $parent_e" && echo yes || echo no)"
ok "it names the follow-up candidate beside its rule" "$(printf '%s' "$out" | grep -q "rule 5.*HEAD is $head_e" && echo yes || echo no)"
ok "render leaves the card byte-identical" "$([ "$digest_before" = "$(cksum < "$pen/e/construction/ITINERARY.md")" ] && echo yes || echo no)"

echo "== 6. a shape word standing alone renders that shape and only that shape =="
if out=$(drive "$pen/e" amend); then rc=0; else rc=1; fi
ok "'amend' alone renders" "$([ $rc -eq 0 ] && echo yes || echo no)"
ok "'amend' alone names the rule 2 candidate" "$(printf '%s' "$out" | grep -q "HEAD's parent is $parent_e" && echo yes || echo no)"
ok "'amend' alone withholds the rule 5 candidate" "$(! printf '%s' "$out" | grep -q 'rule 5' && echo yes || echo no)"
if out=$(drive "$pen/e" follow-up); then rc=0; else rc=1; fi
ok "'follow-up' alone names the rule 5 candidate" "$(printf '%s' "$out" | grep -q "HEAD is $head_e" && echo yes || echo no)"
ok "'follow-up' alone withholds the rule 2 candidate" "$(! printf '%s' "$out" | grep -q 'rule 2' && echo yes || echo no)"
ok "a rendering shape word leaves the card byte-identical" "$([ "$digest_before" = "$(cksum < "$pen/e/construction/ITINERARY.md")" ] && echo yes || echo no)"

echo "== 7. an unknown word refuses rather than falling through to a default =="
if out=$(drive "$pen/e" sideways); then rc=0; else rc=1; fi
ok "an unknown verb is REFUSED" "$([ $rc -ne 0 ] && echo yes || echo no)"
ok "the refusal names the words it takes" "$(printf '%s' "$out" | grep -q 'say render, write, amend, or follow-up' && echo yes || echo no)"
if out=$(drive "$pen/e" write sideways); then rc=0; else rc=1; fi
ok "an unknown SHAPE is REFUSED" "$([ $rc -ne 0 ] && echo yes || echo no)"
ok "the shape refusal names both shapes" "$(printf '%s' "$out" | grep -q 'amend (rule 2' && printf '%s' "$out" | grep -q 'follow-up (rule 5' && echo yes || echo no)"
if out=$(drive "$pen/e" write amend extra); then rc=0; else rc=1; fi
ok "a third word is REFUSED" "$([ $rc -ne 0 ] && echo yes || echo no)"
ok "the card survived every refusal byte-identical" "$([ "$digest_before" = "$(cksum < "$pen/e/construction/ITINERARY.md")" ] && echo yes || echo no)"

echo "== 8. each shape is idempotent =="
field "$pen/f"
drive "$pen/f" write follow-up >/dev/null
if out=$(drive "$pen/f" write follow-up); then rc=0; else rc=1; fi
ok "a second follow-up write succeeds" "$([ $rc -eq 0 ] && echo yes || echo no)"
ok "a second follow-up write reports the card unchanged" "$(printf '%s' "$out" | grep -q 'card_changed=no' && echo yes || echo no)"
if out=$(drive "$pen/f" write amend); then rc=0; else rc=1; fi
ok "switching shape reports the card changed" "$(printf '%s' "$out" | grep -q 'card_changed=yes' && echo yes || echo no)"

echo "== 9. the mode the repository tracks survives a shaped write =="
field "$pen/g"
chmod +x "$pen/g/construction/ITINERARY.md"
drive "$pen/g" write follow-up >/dev/null
ok "an executable card is still executable" "$([ -x "$pen/g/construction/ITINERARY.md" ] && echo yes || echo no)"

echo "legs_pass=$pass"
echo "legs_fail=$fail"
[ "$fail" -eq 0 ] || { echo "control_verdict=failed"; exit 1; }
echo "control_verdict=ok"
