#!/bin/sh
# tools/fixtures/i/ignored_walk_control.sh -- proves tools/fixtures/i/ignored_walk_scan.sh on real
# git repositories in a throwaway pen, every refusal planted and then lifted.
#
# Run from the repository root:
#   sh tools/fixtures/i/ignored_walk_control.sh
#
# A refusal proven only in the passing direction cannot be told from a bypass, so each plant is
# lifted and the reading asserted back. The two mutations at the end remove a check the scan relies
# on and assert the reading MOVES -- a check nobody has watched fail is a check nobody has proven.
set -eu

# The scan under test is the tree's own by default. `IGNORED_WALK_SCAN` names another copy, which
# is how a mutated copy is driven below and how this control proves a scan before it is in place.
SCAN=${IGNORED_WALK_SCAN:-$PWD/tools/fixtures/i/ignored_walk_scan.sh}
[ -f "$SCAN" ] || { echo "control_verdict=no_scan"; echo "detail: the scan under test was not found"; exit 2; }

PEN=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 2; }
trap 'rm -rf "$PEN"' EXIT INT TERM
fail=0
legs=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "$1=yes"; else echo "$1=no"; echo "detail: $1 wanted [$3] read [$2]"; fail=$((fail + 1)); fi
}

fresh() {
  rm -rf "$PEN/t"
  mkdir -p "$PEN/t/tools/fixtures/z"
  cd "$PEN/t"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  printf '%s\n' '# a tracked page' > tools/fixtures/z/keep.md
  # A second tracked source carrying no walk, so removing the walker leaves a corpus rather than
  # an empty one -- the ceiling's lift leg must read a clean tree, never a refused instrument.
  printf '%s\n%s\n' '#!/bin/sh' 'echo quiet' > tools/fixtures/z/quiet_scan.sh
}
commit_all() { git add -A >/dev/null 2>&1; git commit -q -m 'pen' >/dev/null 2>&1 || true; }
read_key() { sh "$SCAN" 2>/dev/null | grep "^$1=" | cut -d= -f2 | tail -1; }
read_all() { sh "$SCAN" 2>/dev/null; }

# --- a walk rooted in the tree, in a file that never asks git, is unfiltered ---------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md' | sort
EOF
commit_all
leg plain_walk_counts "$(read_key unfiltered)" 1
leg plain_walk_is_tree "$(read_key walks_tree)" 1
leg plain_walk_not_filtered "$(read_key git_filtered)" 0

# --- the cure: the same walk in a file that asks git check-ignore ------------------------------
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md' | while read -r f; do
  git check-ignore -q "$f" && continue
  echo "$f"
done
EOF
commit_all
leg cure_lifts_unfiltered "$(read_key unfiltered)" 0
leg cure_counts_filtered "$(read_key git_filtered)" 1

# --- a commented-out find is not a walk --------------------------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
# find tools -name '*.md' -- the elder spelling, kept as testimony
echo none
EOF
commit_all
leg comment_counts_nothing "$(read_key sites)" 0

# --- prose holding the word find is not a walk -------------------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
echo "a reader will find tools useful here"
EOF
commit_all
leg prose_counts_nothing "$(read_key unfiltered)" 0

# --- command position: after a pipe, a substitution, a semicolon and an opening paren -----------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
n=$(find tools -type f | wc -l)
true; find tools -name '*.x'
( find tools -name '*.y' )
echo "$n"
EOF
commit_all
leg substitution_counts "$(read_key unfiltered)" 3

# --- a leading -L option is stepped past to reach the root -------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find -L tools -type f
EOF
commit_all
leg leading_option_stepped "$(read_key unfiltered)" 1

# --- a variable root is REPORTED rather than guessed at ----------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
pen=$(mktemp -d)
find "$pen" -type f
EOF
commit_all
leg variable_root_unresolved "$(read_key unresolved_root)" 1
leg variable_root_not_gated "$(read_key unfiltered)" 0
leg variable_root_named "$(read_all | grep -c 'detail: unresolved-root')" 1

# --- an absolute root and an untracked name are off the tree -----------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find /var/tmp -type f
find nowhere_at_all -type f
EOF
commit_all
leg absolute_root_off_tree "$(read_key off_tree)" 2
leg off_tree_not_gated "$(read_key unfiltered)" 0

# --- exposure: an ignored path under the walked root, and the same tree without one -------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md'
EOF
commit_all
leg latent_before_plant "$(read_key exposed)" 0
leg latent_named "$(read_all | grep -c 'detail: latent')" 1
printf '%s\n' 'tools/.build/' > .gitignore
mkdir -p tools/.build && printf '%s\n' 'x' > tools/.build/out.md
commit_all
leg exposed_after_plant "$(read_key exposed)" 1
leg exposed_named "$(read_all | grep -c 'detail: exposed')" 1
leg exposed_keeps_unfiltered "$(read_key unfiltered)" 1
printf '%s\n' '' > .gitignore
commit_all
leg exposure_lifts "$(read_key exposed)" 0

# --- a dot walk in a file that changes directory to a variable is named, and still counted -------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
SRC=$1
cd "$SRC"
find . -name '*.md'
EOF
commit_all
leg cd_relocated_named "$(read_key cd_relocated)" 1
leg cd_relocated_still_counted "$(read_key unfiltered)" 1
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find . -name '*.md'
EOF
commit_all
leg no_cd_not_relocated "$(read_key cd_relocated)" 0

# --- the ceiling, from both sides --------------------------------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md'
EOF
commit_all
leg at_ceiling_green "$(IGNORED_WALK_CEILING=1 sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" ok
leg over_ceiling_refuses "$(IGNORED_WALK_CEILING=0 sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" over_ceiling
rm -f tools/fixtures/z/a_scan.sh
commit_all
leg removed_returns_green "$(IGNORED_WALK_CEILING=0 sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" ok

# --- the instrument itself: no git, and an empty corpus ----------------------------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md'
EOF
commit_all
rm -rf .git
leg no_git_refuses "$(sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" no_git
fresh
rm -f tools/fixtures/z/quiet_scan.sh
commit_all
leg empty_corpus_refuses "$(sh "$SCAN" 2>/dev/null | grep '^verdict=' | cut -d= -f2)" empty_corpus

# --- mutation one: drop the command-position anchor and prose must be counted ------------------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
echo "a reader will find tools useful here"
EOF
commit_all
leg mutation_anchor_applied "$(read_key unfiltered)" 0
sed "s/^FIND_AT_COMMAND=.*/FIND_AT_COMMAND='find[[:space:]]'/" "$SCAN" > "$PEN/mut1.sh"
if cmp -s "$SCAN" "$PEN/mut1.sh"; then
  leg mutation_anchor_bites changed unchanged
else
  leg mutation_anchor_bites "$(sh "$PEN/mut1.sh" 2>/dev/null | grep '^unfiltered=' | cut -d= -f2)" 1
fi

# --- mutation two: drop the check-ignore test and the cured file must read unfiltered ----------
fresh
cat > tools/fixtures/z/a_scan.sh <<'EOF'
#!/bin/sh
find tools -name '*.md' | while read -r f; do
  git check-ignore -q "$f" && continue
  echo "$f"
done
EOF
commit_all
leg mutation_cure_applied "$(read_key unfiltered)" 0
sed 's/^filtered_file() {.*/filtered_file() { false; }/' "$SCAN" > "$PEN/mut2.sh"
if cmp -s "$SCAN" "$PEN/mut2.sh"; then
  leg mutation_cure_bites changed unchanged
else
  leg mutation_cure_bites "$(sh "$PEN/mut2.sh" 2>/dev/null | grep '^unfiltered=' | cut -d= -f2)" 1
fi

cd /
echo "control_legs=$legs"
echo "control_failed=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=failed"; exit 1; fi
echo "control_verdict=ok"
