#!/bin/sh
# tools/fixtures/l/law_guard_heard_control.sh -- the law-guard reading, proven on planted trees.
#
# WHAT IT PROVES. tools/fixtures/l/law_guard_heard_scan.sh, on real git repositories built in a
# throwaway pen, welcomes asserted as hard as refusals. A refusal proven only in the passing
# direction cannot be told from a bypass, so every gate here is planted and then lifted.
#
# WHY THE SIBLING IS A STUB HERE. The scan decides "heard" by asking
# tools/fixtures/u/unheard_guard_scan.sh, whose reach rules -- transitivity, the roster seed, the
# comment rule, the fixture-pen exclusion -- carry fifty-two pen legs of their own. Re-proving them
# here would spell one rule twice and let the two come to disagree. The pen hands the scan a stub
# sibling through LAW_GUARD_SIBLING and proves what THIS reading does with the answer.
#
# WHY EVERY PLANTED PATH IS INVENTED. The sibling census credits a real guard path named on any
# non-comment line as run. A file whose subject is what nothing runs must therefore spell no real
# guard path outside a comment (REDS %486, booked by that census against itself). Every path below
# is a pen name that exists in no tree.
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
SCAN="$root/tools/fixtures/l/law_guard_heard_scan.sh"
[ -f "$SCAN" ] || { echo "refused: scan missing" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT

pass=0; fail=0
ok()  { pass=$((pass+1)); echo "ok   $1"; }
bad() { fail=$((fail+1)); echo "FAIL $1"; }
check() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1 -- want [$3] got [$2]"; fi; }

# A pen tree: a law room, a tools room, and a stub sibling that names whatever it is given.
build() {
  d="$pen/$1"; shift
  rm -rf "$d"; mkdir -p "$d/.claude/rules" "$d/tools/zz" "$d/tools/stub"
  ( cd "$d" && git init -q . && git config user.email pen@pen && git config user.name pen )
  cat > "$d/tools/stub/sibling.sh" <<'STUB'
#!/bin/sh
# a stub standing in for the reach census: it reads its own list and prints it back.
[ "${1:-}" = "list" ] || { echo "verdict=ok"; exit 0; }
cat "$(dirname "$0")/unheard.txt" 2>/dev/null
echo "verdict=ok"
STUB
  chmod +x "$d/tools/stub/sibling.sh"
  : > "$d/tools/stub/unheard.txt"
}
run_pen() {
  d="$pen/$1"; shift
  ( cd "$d" && LAW_GUARD_ROOMS='.claude/rules/*.md' LAW_GUARD_SIBLING=tools/stub/sibling.sh "$@" sh "$SCAN" ${MODE:-} 2>&1 ) || true
}
field() { echo "$1" | sed -n "s/^$2=//p" | head -1; }

# ---- 1. the three citation forms, and one path cited twice counted once ----
build one
mkdir -p "$pen/one/tools/zz"
for g in alpha beta gamma; do printf '#!/bin/sh\n' > "$pen/one/tools/zz/${g}_witness.rish"; done
cat > "$pen/one/.claude/rules/a.md" <<'MD'
# a rule page

Held by [the alpha guard](tools/zz/alpha_witness.rish), and by `tools/zz/beta_witness.rish`,
and by tools/zz/gamma_witness.rish standing bare in this sentence.
MD
cat > "$pen/one/.claude/rules/b.md" <<'MD'
# a second page citing tools/zz/alpha_witness.rish again
MD
printf 'unheard tools/zz/beta_witness.rish\n' > "$pen/one/tools/stub/unheard.txt"
( cd "$pen/one" && git add -A && git commit -qm pen )
out=$(run_pen one)
check "all three citation forms are read -- link, backticks, and bare" "$(field "$out" citations)" "3"
check "one path cited on two pages counts once" "$(field "$out" law_pages)" "2"
check "the guard the stub calls unheard is counted" "$(field "$out" unheard)" "1"
check "the two the stub leaves out are not" "$(field "$out" guard_citations)" "3"
check "a tree whose reading sits at its ceiling passes" "$(field "$out" verdict)" "ok"

# ---- 2. the ceiling, from both sides, on the same pen ----
out=$(LAW_GUARD_UNHEARD_CEILING=0 run_pen one)
check "a ceiling one under the reading refuses" "$(field "$out" verdict)" "over_ceiling"
out=$(LAW_GUARD_UNHEARD_CEILING=1 run_pen one)
check "and exactly at the reading it passes -- the ceiling is what did the work" "$(field "$out" verdict)" "ok"

# ---- 3. a runner wearing neither word is counted outside, never unheard ----
build two
mkdir -p "$pen/two/tools/zz"
printf '#!/bin/sh\n' > "$pen/two/tools/zz/alpha_witness.rish"
printf '#!/bin/sh\n' > "$pen/two/tools/zz/resolve_path.rish"
cat > "$pen/two/.claude/rules/a.md" <<'MD'
# a page citing a guard and a helper
`tools/zz/alpha_witness.rish` holds the line; `tools/zz/resolve_path.rish` is run by a hand.
MD
printf 'unheard tools/zz/alpha_witness.rish\nunheard tools/zz/resolve_path.rish\n' > "$pen/two/tools/stub/unheard.txt"
( cd "$pen/two" && git add -A && git commit -qm pen )
out=$(run_pen two)
check "a cited runner wearing neither word lands outside the population" "$(field "$out" outside_population)" "1"
check "and is never counted unheard, even when the sibling names it" "$(field "$out" unheard)" "1"

# ---- 4. absent: a cited path the repository does not carry ----
build three
mkdir -p "$pen/three/tools/zz"
printf '#!/bin/sh\n' > "$pen/three/tools/zz/alpha_witness.rish"
cat > "$pen/three/.claude/rules/a.md" <<'MD'
# a page citing a guard that was never written
`tools/zz/alpha_witness.rish` and `tools/zz/ghost_witness.rish`.
MD
printf 'unheard tools/zz/alpha_witness.rish\n' > "$pen/three/tools/stub/unheard.txt"
( cd "$pen/three" && git add -A && git commit -qm pen )
out=$(LAW_GUARD_UNHEARD_CEILING=9 run_pen three)
check "a cited path the repository does not carry is absent" "$(field "$out" absent)" "1"
check "and it gates under its own name, apart from the ceiling" "$(field "$out" verdict)" "absent_citation"
case "$out" in *"absent_citation tools/zz/ghost_witness.rish"*) ok "the absent path is named, so a reader can repair it" ;;
  *) bad "the absent path must be named" ;; esac

# ---- 5. present on disk, outside the repository: the promise must travel ----
printf '#!/bin/sh\n' > "$pen/three/tools/zz/ghost_witness.rish"
out=$(LAW_GUARD_UNHEARD_CEILING=9 run_pen three)
check "a file on this machine and outside the repository stays absent" "$(field "$out" absent)" "1"
( cd "$pen/three" && git add -A && git commit -qm track )
out=$(LAW_GUARD_UNHEARD_CEILING=9 run_pen three)
check "and tracking it lifts the refusal -- the tracked tree is what was asked" "$(field "$out" verdict)" "ok"

# ---- 6. an untracked law page is not law anybody receives ----
build four
mkdir -p "$pen/four/tools/zz"
printf '#!/bin/sh\n' > "$pen/four/tools/zz/alpha_witness.rish"
cat > "$pen/four/.claude/rules/a.md" <<'MD'
# a tracked page citing tools/zz/alpha_witness.rish
MD
cat > "$pen/four/.claude/rules/untracked.md" <<'MD'
# an untracked page citing tools/zz/ghost_witness.rish
MD
printf 'unheard tools/zz/alpha_witness.rish\n' > "$pen/four/tools/stub/unheard.txt"
( cd "$pen/four" && git add .claude/rules/a.md tools && git commit -qm pen )
out=$(run_pen four)
check "an untracked law page is read past -- it is law nobody receives" "$(field "$out" citations)" "1"

# ---- 7. the vacuums, each refusing under its own name ----
build five
( cd "$pen/five" && git add -A && git commit -qm pen )
out=$(run_pen five)
check "a tree with no law pages refuses rather than printing a green zero" "$(field "$out" verdict)" "no_law_pages"

build six
cat > "$pen/six/.claude/rules/a.md" <<'MD'
# a law page naming no tool at all
MD
( cd "$pen/six" && git add -A && git commit -qm pen )
out=$(run_pen six)
check "a law citing no tool refuses rather than reading zero unheard" "$(field "$out" verdict)" "no_citations"

out=$(LAW_GUARD_SIBLING=tools/stub/gone.sh sh -c "cd '$pen/one' && LAW_GUARD_ROOMS='.claude/rules/*.md' LAW_GUARD_SIBLING=tools/stub/gone.sh sh '$SCAN'" 2>&1 || true)
check "a missing sibling refuses rather than calling every guard heard" "$(field "$out" verdict)" "no_sibling"

: > "$pen/one/tools/stub/unheard.txt"
out=$(run_pen one)
check "a sibling that names nothing refuses -- an empty answer is a broken reading" "$(field "$out" verdict)" "sibling_empty"
printf 'unheard tools/zz/beta_witness.rish\n' > "$pen/one/tools/stub/unheard.txt"

# ---- 8. outside a repository ----
bare="$pen/bare"; mkdir -p "$bare"
out=$( cd "$bare" && sh "$SCAN" 2>&1 || true )
case "$out" in *"not a git repository"*) ok "outside a git repository the scan refuses rather than reading the filesystem" ;;
  *) bad "want the no-repository refusal -- got [$out]" ;; esac

# ---- 9. the list mode names what it counted, and carries no verdict of its own ----
MODE=list
out=$(run_pen one)
case "$out" in *"unheard_law_guard tools/zz/beta_witness.rish"*) ok "list names each unheard law-cited guard" ;;
  *) bad "list must name the unheard guard -- got [$out]" ;; esac
MODE=pages
out=$(run_pen one)
case "$out" in *"law_page .claude/rules/a.md cites=3"*) ok "pages names each citing page and how many it cites" ;;
  *) bad "pages must name the citing page -- got [$out]" ;; esac
MODE=

echo "pass=$pass"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=control_green"; else echo "verdict=control_red"; exit 2; fi
