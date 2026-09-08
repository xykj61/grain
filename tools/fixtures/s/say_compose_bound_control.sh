#!/bin/sh
# tools/fixtures/s/say_compose_bound_control.sh -- prove the compose-bound scan on planted Rishi
# scripts in real git repositories inside a throwaway pen, refusals and welcomes both.
#
# WHY BOTH DIRECTIONS. A ceiling proven only in the passing direction cannot be told from a ceiling
# never applied: a scan that always exits 0 satisfies every "clean tree" case a control thinks to
# write. So each ratchet is shown from BOTH sides -- planted one past and then lifted back -- and
# every welcome is asserted as hard as every refusal.
#
#   sh tools/fixtures/s/say_compose_bound_control.sh
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

# THE SCAN IS COPIED INTO EACH PEN RATHER THAN CALLED WHERE IT LIVES. Its root walk climbs from its
# own `$0` until it finds `tools/fixtures` beside `rishi`, which is exactly right in the field and
# exactly wrong from a pen: called at its real path it walks back into the real tree and reads the
# real population, so every pen case would measure this repository instead of the plant. The first
# draft of this control did that and read 502 eager sites inside a pen holding three files.
SCAN_SRC="$(cd "$(dirname "$0")" && pwd)/say_compose_bound_scan.sh"
pen="$(mktemp -d)"
SCAN="$pen/r/tools/fixtures/s/say_compose_bound_scan.sh"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check_field() { # name field expected actual
  _n="$1"; _f="$2"; _want="$3"; _got="$4"
  _have=$(printf '%s\n' "$_got" | sed -n "s/^$_f=//p")
  if [ "$_have" = "$_want" ]; then
    echo "PASS: $_n ($_f=$_want)"; pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted $_f=$_want, got $_f=$_have"; fail=$((fail + 1))
  fi
}

check_exit() { # name expected actual
  if [ "$3" = "$2" ]; then echo "PASS: $1 (exit $2)"; pass=$((pass + 1))
  else echo "FAIL: $1 -- wanted exit $2, got $3"; fail=$((fail + 1)); fi
}

# A pen the scan's own root walk can find: it needs tools/fixtures and rishi beside each other, and
# a git repository, since the population is `git ls-files` rather than `find` -- an untracked
# scratch file is not something a tree promises anybody.
newpen() {
  rm -rf "$pen/r"; mkdir -p "$pen/r/tools/fixtures" "$pen/r/rishi/src"
  cd "$pen/r"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  printf 'const StrBuf = struct {\n    bytes: [4096]u8 = undefined,\n};\n' > rishi/src/main.rye
  mkdir -p tools/fixtures/s
  cp "$SCAN_SRC" tools/fixtures/s/say_compose_bound_scan.sh
}

commit_pen() { git add -A; git commit -q -m "pen"; }

# The ceilings are SHARES in per mille, so a pen's numbers are chosen against its own three-shape
# population rather than against a raw count. A pen of three files holding one of each shape reads
# 333 for each, so 999 welcomes everything and 0 refuses whatever is present.
run_scan() { SAY_COMPOSE_EAGER_CEILING="$1" SAY_COMPOSE_DEFERRED_CEILING="$2" sh "$SCAN" 2>/dev/null || true; }

echo "== 1. each shape is counted as its own kind =="
newpen
{ echo 'let r = run ["sh" "-c" "echo hi"]'
  echo 'say "reading -- ${r.out}"'
} > a.rish
{ echo 'let r = run ["sh" "-c" "echo hi"]'
  echo 'assert r.ok else "it refused -- ${r.err}"'
} > b.rish
{ echo 'let r = run ["sh" "-c" "echo hi"]'
  echo 'say "reading --"'
  echo 'say r.out'
} > c.rish
commit_pen
out=$(run_scan 999 999)
check_field "an eager say is counted eager" eager 1 "$out"
check_field "an assert else is counted deferred" deferred 1 "$out"
check_field "a bare say is counted safe" safe 1 "$out"
check_field "the safe shape is neither hazard" scripts 3 "$out"
check_field "the width is read off the Rishi source" strbuf_bytes 4096 "$out"

echo
echo "== 2. a comment teaching against the shape is not the shape =="
newpen
{ echo '# never write say "x -- ${r.out}" here; it composes every run'
  echo '# and assert r.ok else "${r.err}" composes when it fails'
  echo 'let r = run ["sh" "-c" "echo hi"]'
  echo 'say r.out'
} > a.rish
commit_pen
out=$(run_scan 999 999)
check_field "a commented eager mention counts nothing" eager 0 "$out"
check_field "a commented deferred mention counts nothing" deferred 0 "$out"
check_field "and the real bare say beside them still counts" safe 1 "$out"

echo
echo "== 3. an untracked script is invisible =="
newpen
echo 'say "x"' > kept.rish
commit_pen
{ echo 'let r = run ["sh" "-c" "echo hi"]'
  echo 'say "loose -- ${r.out}"'
} > loose.rish
out=$(run_scan 999 999)
check_field "an untracked script is not counted" eager 0 "$out"
check_field "and the tracked population is what it says" scripts 1 "$out"

echo
echo "== 4. the eager ratchet, from both sides =="
newpen
i=1
while [ "$i" -le 3 ]; do
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "n -- ${r.out}"'; } > "e$i.rish"
  i=$((i + 1))
done
commit_pen
# Three eager files and nothing else, so the shaped population is three and the share is 1000 per
# mille exactly. At the ceiling it welcomes; one per mille under it refuses.
set +e; out=$(SAY_COMPOSE_EAGER_CEILING=1000 SAY_COMPOSE_DEFERRED_CEILING=999 sh "$SCAN" 2>/dev/null); rc_at=$?
out_over=$(SAY_COMPOSE_EAGER_CEILING=999 SAY_COMPOSE_DEFERRED_CEILING=999 sh "$SCAN" 2>/dev/null); rc_over=$?
set -e
check_exit "at the eager ceiling it welcomes" 0 "$rc_at"
check_field "and the count is whole" eager 3 "$out"
check_exit "one past it refuses" 1 "$rc_over"
check_field "refusing by its own name" verdict over_eager_ceiling "$out_over"

echo
echo "== 5. the deferred ratchet, from both sides =="
newpen
i=1
while [ "$i" -le 3 ]; do
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'assert r.ok else "no -- ${r.out}"'; } > "d$i.rish"
  i=$((i + 1))
done
commit_pen
set +e; out=$(SAY_COMPOSE_EAGER_CEILING=999 SAY_COMPOSE_DEFERRED_CEILING=1000 sh "$SCAN" 2>/dev/null); rc_at=$?
out_over=$(SAY_COMPOSE_EAGER_CEILING=999 SAY_COMPOSE_DEFERRED_CEILING=999 sh "$SCAN" 2>/dev/null); rc_over=$?
set -e
check_exit "at the deferred ceiling it welcomes" 0 "$rc_at"
check_field "and the count is whole" deferred 3 "$out"
check_exit "one past it refuses" 1 "$rc_over"
check_field "refusing by its own name" verdict over_deferred_ceiling "$out_over"

echo
echo "== 6. the two ratchets are named apart and do not fire together =="
newpen
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "a -- ${r.out}"'; } > a.rish
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'assert r.ok else "b -- ${r.out}"'; } > b.rish
commit_pen
set +e
eager_only=$(SAY_COMPOSE_EAGER_CEILING=0 SAY_COMPOSE_DEFERRED_CEILING=999 sh "$SCAN" 2>/dev/null); rc_e=$?
def_only=$(SAY_COMPOSE_EAGER_CEILING=999 SAY_COMPOSE_DEFERRED_CEILING=0 sh "$SCAN" 2>/dev/null); rc_d=$?
set -e
check_field "an eager-only breach names eager" verdict over_eager_ceiling "$eager_only"
check_field "a deferred-only breach names deferred" verdict over_deferred_ceiling "$def_only"
check_exit "each refuses on its own" 1 "$rc_e"
check_exit "and so does the other" 1 "$rc_d"

echo
echo "== 7. list prints every hazard site and nothing else =="
newpen
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "a -- ${r.out}"'; } > a.rish
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'assert r.ok else "b -- ${r.out}"'; } > b.rish
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say r.out'; } > c.rish
commit_pen
listed=$(sh "$SCAN" list 2>/dev/null)
n_lines=$(printf '%s\n' "$listed" | grep -c . || true)
n_eager=$(printf '%s\n' "$listed" | grep -c '^eager    a.rish:2$' || true)
n_def=$(printf '%s\n' "$listed" | grep -c '^deferred b.rish:2$' || true)
n_safe=$(printf '%s\n' "$listed" | grep -c 'c.rish' || true)
if [ "$n_lines" -eq 2 ] && [ "$n_eager" -eq 1 ] && [ "$n_def" -eq 1 ] && [ "$n_safe" -eq 0 ]; then
  echo "PASS: list prints the two hazard sites by file and line, and no safe site"
  pass=$((pass + 1))
else
  echo "FAIL: list printed $n_lines lines (eager:$n_eager deferred:$n_def safe:$n_safe)"
  printf '%s\n' "$listed" | sed 's/^/       /'
  fail=$((fail + 1))
fi

echo
echo "== 8. an unreadable width is reported, never guessed =="
newpen
echo 'say "x"' > a.rish
rm -f rishi/src/main.rye
commit_pen
out=$(run_scan 999 999)
check_field "a Rishi source with no StrBuf reads unreadable rather than a number" strbuf_bytes absent "$out"
check_exit "and the shape counts still answer" 0 "$( (run_scan 999 999 >/dev/null 2>&1); echo $? )"

echo
echo "== 9. misuse exits differently from a refusal =="
newpen
echo 'say "x"' > a.rish
commit_pen
set +e; sh "$SCAN" nonsense >/dev/null 2>&1; rc_m=$?; sh "$SCAN" list extra >/dev/null 2>&1; rc_x=$?; set -e
check_exit "an unknown argument exits 2" 2 "$rc_m"
check_exit "a trailing argument exits 2" 2 "$rc_x"

echo
echo "== 10. a tree with no tracked scripts says so rather than reading clean =="
newpen
echo "not a script" > README.md
commit_pen
# Called directly rather than through run_scan, whose trailing `|| true` is there so a refusing
# case can still be read for its fields -- and would swallow the very exit this leg is asserting.
set +e
out=$(SAY_COMPOSE_EAGER_CEILING=999 SAY_COMPOSE_DEFERRED_CEILING=999 sh "$SCAN" 2>/dev/null)
rc_none=$?
set -e
check_field "an empty population is named" verdict no_scripts "$out"
check_exit "and refuses as misuse rather than passing" 2 "$rc_none"

echo
echo "== 11. the reading is a habit, so ordinary growth does not move it =="
# THIS IS THE WHOLE REASON THE CEILINGS ARE SHARES. A raw count rises whenever the fleet writes new
# guards, which is the most ordinary act on this pier, so a ratchet on the count refuses work nobody
# did wrong -- and this control's own first draft watched that happen inside one rebase. A share
# asks about the HABIT instead: a pen that doubles in size without changing how it writes reads the
# same number, and only a pen that writes worse moves it.
newpen
i=1
while [ "$i" -le 2 ]; do
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "n -- ${r.out}"'; } > "g$i.rish"
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say r.out'; } > "s$i.rish"
  i=$((i + 1))
done
commit_pen
small=$(run_scan 999 999)
check_field "a small pen, half eager" eager_per_mille 500 "$small"
i=3
while [ "$i" -le 8 ]; do
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "n -- ${r.out}"'; } > "g$i.rish"
  { echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say r.out'; } > "s$i.rish"
  i=$((i + 1))
done
commit_pen
grown=$(run_scan 999 999)
check_field "four times the files, the same habit" eager_per_mille 500 "$grown"
check_field "and the raw count did rise, which is why it is not the gate" eager 8 "$grown"
{ echo 'let r = run ["sh" "-c" "echo hi"]'; echo 'say "n -- ${r.out}"'; } > worse.rish
commit_pen
worse=$(run_scan 999 999)
worse_pm=$(printf '%s\n' "$worse" | sed -n 's/^eager_per_mille=//p')
if [ "$worse_pm" -gt 500 ]; then
  echo "PASS: a pen that writes worse moves the share (eager_per_mille=$worse_pm)"; pass=$((pass + 1))
else
  echo "FAIL: a worse pen read eager_per_mille=$worse_pm, wanted above 500"; fail=$((fail + 1))
fi

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
