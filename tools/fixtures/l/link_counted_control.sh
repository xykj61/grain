#!/bin/sh
# tools/fixtures/l/link_counted_control.sh -- prove the loom on real repositories in a pen.
#
# WHAT THIS IS FOR. `link_counted_scan.sh` refuses a runner that counts tracked paths through a
# glob a symlink answers. A refusal proven only in the passing direction cannot be told from a
# bypass, so every refusal below is planted and then LIFTED, and every welcome is asserted as hard
# as every refusal. The pen holds real git repositories with real symlinks; nothing here reads the
# tree's own tools.
#
#   sh tools/fixtures/l/link_counted_control.sh
#
# Exit 0 when every case behaves, 1 otherwise. One line per case, then a verdict.
set -eu

SCAN=tools/fixtures/l/link_counted_scan.sh
[ -f "$SCAN" ] || { echo "control: run from the repository root; $SCAN is not here" >&2; exit 2; }
ROOT=$(pwd)
GIT=${GIT:-git}

pen=$(mktemp -d "${TMPDIR:-/tmp}/link-counted-pen.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
ok()  { pass=$((pass + 1)); echo "case: $1 = yes"; }
bad() { fail=$((fail + 1)); echo "case: $1 = NO"; }

# A repository holding one real module, one symlink onto it, and one runner.
build() { # build <dir> <runner-body-file>
  d=$1; body=$2
  rm -rf "$d"; mkdir -p "$d/mantra" "$d/comlink" "$d/tools/fixtures/l"
  printf 'const std = @import("std");\n' > "$d/mantra/one.rye"
  printf 'const std = @import("std");\n' > "$d/mantra/two.rye"
  ( cd "$d/comlink" && ln -sf ../mantra/one.rye one.rye )
  printf '# a page\n' > "$d/notes.md"
  cp "$body" "$d/tools/counter.sh"
  ( cd "$d" \
    && "$GIT" init -q . \
    && "$GIT" config user.email pen@example.invalid \
    && "$GIT" config user.name pen \
    && "$GIT" add -A \
    && "$GIT" -c commit.gpgsign=false commit -qm 'pen: one module, one link, one runner' ) >/dev/null 2>&1
}

run_scan() { # run_scan <dir> [mode]
  ( cd "$ROOT" && env LINK_COUNTED_ROOT="$1" sh "$SCAN" "${2:-count}" 2>&1 ) || true
}
run_status() { # run_status <dir> -> exit code on stdout
  s=0
  ( cd "$ROOT" && env LINK_COUNTED_ROOT="$1" sh "$SCAN" >/dev/null 2>&1 ) || s=$?
  echo "$s"
}

# --- 1. the defective form over a glob a symlink answers refuses ---
cat > "$pen/defective.sh" <<'BODY'
#!/bin/sh
n=$(git ls-files '*.rye' | wc -l | tr -d ' ')
echo "modules=$n"
BODY
build "$pen/a" "$pen/defective.sh"
out=$(run_scan "$pen/a")
case "$out" in *"link_counted_sites=1"*) ok "a path count over a linked glob is found" ;;
  *) bad "a path count over a linked glob is found ($out)" ;; esac
case "$out" in *"verdict=link_counted"*) ok "the refusal names itself" ;;
  *) bad "the refusal names itself ($out)" ;; esac
[ "$(run_status "$pen/a")" = 0 ] && ok "the scan reports rather than exiting non-zero (the witness gates)" \
  || bad "the scan reports rather than exiting non-zero"
out=$(run_scan "$pen/a" list)
case "$out" in *"3 tracked paths, 1 of them symlinks"*) ok "the report carries both numbers -- 3 paths, 1 link" ;;
  *) bad "the report carries both numbers -- 3 paths, 1 link ($out)" ;; esac
case "$out" in *"tools/counter.sh"*) ok "the report names the file" ;;
  *) bad "the report names the file ($out)" ;; esac

# --- 2. the cured form over the same glob walks free ---
cat > "$pen/cured.sh" <<'BODY'
#!/bin/sh
n=$(git ls-files -s '*.rye' | awk '$1 != "120000"' | wc -l | tr -d ' ')
echo "modules=$n"
BODY
build "$pen/b" "$pen/cured.sh"
out=$(run_scan "$pen/b")
case "$out" in *"link_counted_sites=0"*) ok "the mode-filtered form walks free" ;;
  *) bad "the mode-filtered form walks free ($out)" ;; esac
case "$out" in *"verdict=ok"*) ok "a clean tree reads ok" ;;
  *) bad "a clean tree reads ok ($out)" ;; esac
# and the cure is not merely tolerated -- it returns the honest number
n=$( cd "$pen/b" && sh tools/counter.sh )
[ "$n" = "modules=2" ] && ok "the cured form counts 2 modules where 3 paths stand" \
  || bad "the cured form counts 2 modules where 3 paths stand ($n)"

# --- 3. the defective form over a glob NO symlink answers walks free ---
cat > "$pen/mdcount.sh" <<'BODY'
#!/bin/sh
n=$(git ls-files '*.md' | wc -l | tr -d ' ')
echo "pages=$n"
BODY
build "$pen/c" "$pen/mdcount.sh"
out=$(run_scan "$pen/c")
case "$out" in *"link_counted_sites=0"*) ok "a path count over an unlinked glob is honest arithmetic" ;;
  *) bad "a path count over an unlinked glob is honest arithmetic ($out)" ;; esac

# --- 4. and it BECOMES a finding on the lap a link lands under it ---
( cd "$pen/c" && ln -sf notes.md alias.md \
  && "$GIT" add -A && "$GIT" -c commit.gpgsign=false commit -qm 'pen: a link lands' ) >/dev/null 2>&1
out=$(run_scan "$pen/c")
case "$out" in *"link_counted_sites=1"*) ok "the same line reds once a link answers its glob" ;;
  *) bad "the same line reds once a link answers its glob ($out)" ;; esac

# --- 5. lift the plant and the reading returns to zero ---
( cd "$pen/a" && cp "$pen/cured.sh" tools/counter.sh \
  && "$GIT" add -A && "$GIT" -c commit.gpgsign=false commit -qm 'pen: the cure lands' ) >/dev/null 2>&1
out=$(run_scan "$pen/a")
case "$out" in *"link_counted_sites=0"*) ok "lifting the plant returns the reading to zero" ;;
  *) bad "lifting the plant returns the reading to zero ($out)" ;; esac

# --- 6. an untracked runner is not read: the reading is of the tree, never of the disk ---
build "$pen/d" "$pen/cured.sh"
cp "$pen/defective.sh" "$pen/d/tools/untracked.sh"
out=$(run_scan "$pen/d")
case "$out" in *"link_counted_sites=0"*) ok "an untracked runner is read past" ;;
  *) bad "an untracked runner is read past ($out)" ;; esac

# --- 7. a `.rish` runner is read too, so the reading is not shell-only ---
build "$pen/e" "$pen/cured.sh"
cp "$pen/defective.sh" "$pen/e/tools/counter.rish"
( cd "$pen/e" && "$GIT" add -A && "$GIT" -c commit.gpgsign=false commit -qm 'pen: a rish counter' ) >/dev/null 2>&1
out=$(run_scan "$pen/e")
case "$out" in *"link_counted_sites=1"*) ok "a .rish runner is read as well as a .sh" ;;
  *) bad "a .rish runner is read as well as a .sh ($out)" ;; esac

# --- 8. a repository with no runner at all reads zero rather than refusing ---
build "$pen/f" "$pen/cured.sh"
( cd "$pen/f" && "$GIT" rm -q --cached tools/counter.sh >/dev/null 2>&1 && rm -f tools/counter.sh \
  && "$GIT" -c commit.gpgsign=false commit -qm 'pen: no runner' ) >/dev/null 2>&1
out=$(run_scan "$pen/f")
case "$out" in *"candidate_lines=0"*) ok "a tree with no counting runner reads zero candidates" ;;
  *) bad "a tree with no counting runner reads zero candidates ($out)" ;; esac
case "$out" in *"verdict=ok"*) ok "and reads ok rather than refusing" ;;
  *) bad "and reads ok rather than refusing ($out)" ;; esac

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || { echo "verdict=refused"; exit 1; }
echo "verdict=ok"
