#!/bin/sh
# tools/fixtures/r/rye_compile_reach_control.sh -- prove the compile-reach census on real git
# repositories in a throwaway pen, refusals and welcomes both.
#
#   sh tools/fixtures/r/rye_compile_reach_control.sh
#
# WHY A REAL REPOSITORY RATHER THAN A DIRECTORY. The census reads `git ls-files -s` for the corpus
# and `git cat-file` for link text, so it asks the repository rather than the filesystem -- which is
# how it resolves symlinks without `readlink`, a utility POSIX does not carry. A pen of loose files
# would exercise none of that, so each pen here is `git init`, `git add`, and a real index.
#
# WHY THE SYMLINK CASE IS THE ONE THAT EARNS ITS PLACE. Measured on the field before resolution was
# written, 17 symlinks read as never-compiled and 16 of them pointed at a file that IS compiled:
# sixteen confident false accusations of healthy code from one missing step. A census that accuses
# the innocent is worse than no census, so the pen plants a symlink to a built module and asserts it
# is absent from `never` -- the reading that would have caught all sixteen.
#
# WHY THE CEILING IS PLANTED AS A RATIO. A pen that plants an absolute tests a snapshot of the law;
# one that reads the ceiling out of the scan and plants ceiling+1 tests the law itself, and keeps
# passing the day the ceiling falls.
#
# WHY THE PEN IS PROVEN INNOCENT. Every refusal below could also be produced by a pen that simply
# does not work. So the last phase patches the scan to always answer `asserted=0` and asserts the
# control CATCHES it -- if a broken census walks free here, none of the passes above mean anything.
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
SCAN="$HERE/rye_compile_reach_scan.sh"
PORTABLE="$HERE/../s/shell_portable.sh"
[ -f "$SCAN" ] || { echo "control: scan missing at $SCAN"; exit 1; }
[ -f "$PORTABLE" ] || { echo "control: shell_portable.sh missing at $PORTABLE"; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check() { # name expected actual
  if [ "$2" = "$3" ]; then pass=$((pass + 1)); echo "  ok   $1"
  else fail=$((fail + 1)); echo "  FAIL $1 -- wanted [$2] got [$3]"; fi
}
check_says() { # name needle haystack
  case "$3" in
    *"$2"*) pass=$((pass + 1)); echo "  ok   $1" ;;
    *) fail=$((fail + 1)); echo "  FAIL $1 -- [$2] absent"; echo "$3" | sed 's/^/       | /' ;;
  esac
}
check_lacks() { # name needle haystack
  case "$3" in
    *"$2"*) fail=$((fail + 1)); echo "  FAIL $1 -- [$2] present and should not be" ;;
    *) pass=$((pass + 1)); echo "  ok   $1" ;;
  esac
}

# Every pen is a repository carrying the two markers the scan's root walk looks for, the portable
# helper it sources, and the scan itself at its own letter-room path.
new_pen() { # name  -> echoes the pen root
  _p="$pen/$1"
  mkdir -p "$_p/rishi/bin" "$_p/tools/fixtures/s" "$_p/tools/fixtures/r"
  cp "$PORTABLE" "$_p/tools/fixtures/s/shell_portable.sh"
  cp "$SCAN" "$_p/tools/fixtures/r/rye_compile_reach_scan.sh"
  ( cd "$_p" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$_p"
}
seal() { ( cd "$1" && git add -A . >/dev/null 2>&1 && true ); }
run_pen() { # pen [args...]
  _r=$1; shift
  out=$( cd "$_r" && sh tools/fixtures/r/rye_compile_reach_scan.sh "$@" 2>&1 ) && rc=0 || rc=$?
}

# The ceiling and the corpus bound are read from the scan rather than spelled here, so this control
# keeps testing the law after either number moves.
ceiling=$(sed -n 's/^ceiling=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
max_corpus=$(sed -n 's/^max_corpus=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
[ -n "$ceiling" ] || { echo "control: could not read the ceiling out of the scan"; exit 1; }
[ -n "$max_corpus" ] || { echo "control: could not read max_corpus out of the scan"; exit 1; }
echo "rye-compile-reach-control: ceiling=$ceiling max_corpus=$max_corpus"

# -- 1. a clean tree: one built root, one module it imports ------------------------------------
p=$(new_pen clean)
mkdir -p "$p/app" "$p/tools/a"
printf 'const helper = @import("helper.rye");\npub fn main() void {}\n' > "$p/app/main.rye"
printf 'pub fn help() void {}\n' > "$p/app/helper.rye"
printf '#!/bin/sh\nrye/bin/rye build app/main.rye\n' > "$p/tools/a/build.sh"
seal "$p"; run_pen "$p"
check      "a clean tree exits 0"                          0 "$rc"
check_says "  ... verdict ok"                              "verdict=ok" "$out"
check_says "  ... the root is a root"                      "roots=1" "$out"
check_says "  ... the imported module is built too"        "built=2" "$out"
check_says "  ... and nothing is never-compiled"           "never=0" "$out"

# -- 2. reach is transitive, three deep --------------------------------------------------------
p=$(new_pen transitive)
mkdir -p "$p/app" "$p/tools/a"
printf 'const b = @import("b.rye");\npub fn main() void {}\n' > "$p/app/main.rye"
printf 'const c = @import("c.rye");\n' > "$p/app/b.rye"
printf 'pub fn c() void {}\n' > "$p/app/c.rye"
printf '#!/bin/sh\nrye/bin/rye build app/main.rye\n' > "$p/tools/a/build.sh"
seal "$p"; run_pen "$p"
check_says "an import chain three deep is all built"       "built=3" "$out"
check_says "  ... and the edges are counted"               "edges=2" "$out"

# -- 3. the asserted refusal, planted as ceiling+1 ---------------------------------------------
p=$(new_pen asserted_over)
mkdir -p "$p/lib" "$p/tools/a"
printf '#!/bin/sh\nrye/bin/rye build lib/root.rye\n' > "$p/tools/a/build.sh"
printf 'pub fn main() void {}\n' > "$p/lib/root.rye"
i=0
while [ "$i" -le "$ceiling" ]; do
  printf 'pub fn orphan() void {}\n' > "$p/lib/orphan$i.rye"
  printf '#!/bin/sh\ngrep -q pub lib/orphan%s.rye\n' "$i" > "$p/tools/a/claim$i.sh"
  i=$((i + 1))
done
seal "$p"; run_pen "$p"
check      "ceiling+1 asserted files exit 1"               1 "$rc"
check_says "  ... by name"                                 "verdict=asserted_over_ceiling" "$out"
check_says "  ... counting them"                           "asserted=$((ceiling + 1))" "$out"
check_says "  ... and naming one"                          "asserted -- lib/orphan0.rye" "$out"

# -- 4. and exactly at the ceiling it walks free, so the bound is proven from both sides -------
rm -f "$p/lib/orphan$ceiling.rye" "$p/tools/a/claim$ceiling.sh"
( cd "$p" && git rm -q --cached "lib/orphan$ceiling.rye" "tools/a/claim$ceiling.sh" >/dev/null 2>&1 || true )
seal "$p"; run_pen "$p"
check      "exactly at the ceiling exits 0"                0 "$rc"
check_says "  ... counting the survivors"                  "asserted=$ceiling" "$out"

# -- 5. a symlink to a built module is not accused ---------------------------------------------
# The reading that would have caught sixteen false accusations on the field.
p=$(new_pen symlink_innocent)
mkdir -p "$p/app" "$p/alias" "$p/tools/a"
printf 'const helper = @import("helper.rye");\npub fn main() void {}\n' > "$p/app/main.rye"
printf 'pub fn help() void {}\n' > "$p/app/helper.rye"
( cd "$p/alias" && ln -s ../app/helper.rye helper.rye )
printf '#!/bin/sh\nrye/bin/rye build app/main.rye\n' > "$p/tools/a/build.sh"
printf '#!/bin/sh\ngrep -q pub alias/helper.rye\n' > "$p/tools/a/claim.sh"
seal "$p"; run_pen "$p"
check_says "the symlink is seen as a symlink"              "symlinks=1" "$out"
check_says "  ... and collapses into one distinct file"    "distinct=2" "$out"
check      "  ... so a link to a built module is innocent" 0 "$rc"
check_says "  ... nothing never-compiled"                  "never=0" "$out"
run_pen "$p" --list never
check_lacks "  ... and the alias is absent from never"     "alias/helper.rye" "$out"

# -- 6. a runner naming the symlink credits the target -----------------------------------------
p=$(new_pen symlink_named)
mkdir -p "$p/app" "$p/alias" "$p/tools/a"
printf 'pub fn main() void {}\n' > "$p/app/prog.rye"
( cd "$p/alias" && ln -s ../app/prog.rye prog.rye )
printf '#!/bin/sh\nrye/bin/rye build alias/prog.rye\n' > "$p/tools/a/build.sh"
seal "$p"; run_pen "$p"
check_says "building through an alias credits the target"  "roots=1" "$out"
check_says "  ... and nothing is never-compiled"           "never=0" "$out"

# -- 7. a plant under fixtures/ is a specimen, never an accusation ------------------------------
p=$(new_pen specimen)
mkdir -p "$p/lib" "$p/tools/fixtures/t" "$p/tools/a"
printf 'pub fn main() void {}\n' > "$p/lib/root.rye"
printf 'const x: usize = 0;\n' > "$p/tools/fixtures/t/bad_plant.rye"
printf '#!/bin/sh\nrye/bin/rye build lib/root.rye\n' > "$p/tools/a/build.sh"
printf '#!/bin/sh\ngrep -q usize tools/fixtures/t/bad_plant.rye\n' > "$p/tools/a/style.sh"
seal "$p"; run_pen "$p"
check      "a planted specimen does not accuse"            0 "$rc"
check_says "  ... it is counted as a specimen"             "specimen=1" "$out"
check_says "  ... and asserted stays empty"                "asserted=0" "$out"

# -- 8. Rishi's list form reaches the compiler --------------------------------------------------
# `let rye = "rye/bin/rye"` then `run [... rye "run" prog_src]` puts a variable between the command
# and the verb, so a pattern wanting them adjacent reads the file as a pure reader and accuses every
# path it names. This is the spelling tools/p/parity-selftest.rish actually uses.
p=$(new_pen listform)
mkdir -p "$p/lib" "$p/tools/a"
printf 'pub fn main() void {}\n' > "$p/lib/prog.rye"
printf 'let rye = "rye/bin/rye"\nlet prog_src = "lib/prog.rye"\nlet r = run ["env" rye "run" prog_src]\n' > "$p/tools/a/selftest.rish"
seal "$p"; run_pen "$p"
check      "the Rishi list form counts as compiling"       0 "$rc"
check_says "  ... crediting its literal as a root"         "roots=1" "$out"
check_says "  ... so nothing is never-compiled"            "never=0" "$out"

# -- 9. RYE_ZIG marks a runner that drives the compiler ----------------------------------------
p=$(new_pen ryezig)
mkdir -p "$p/lib" "$p/tools/a"
printf 'pub fn main() void {}\n' > "$p/lib/prog.rye"
printf '#!/bin/sh\nenv RYE_ZIG=vendor/zig-toolchain/zig sh worker.sh lib/prog.rye\n' > "$p/tools/a/gate.sh"
seal "$p"; run_pen "$p"
check_says "RYE_ZIG marks a compiling runner"              "roots=1" "$out"
check_says "  ... so nothing is never-compiled"            "never=0" "$out"

# -- 10. a grep-only runner alone does not credit anything --------------------------------------
p=$(new_pen greponly)
mkdir -p "$p/lib" "$p/tools/a"
printf 'pub fn orphan() void {}\n' > "$p/lib/orphan.rye"
printf '#!/bin/sh\ngrep -q pub lib/orphan.rye\n' > "$p/tools/a/claim.sh"
seal "$p"; run_pen "$p"
check_says "a grep-only runner credits nothing"            "roots=0" "$out"
check_says "  ... the file is never-compiled"              "never=1" "$out"
check_says "  ... and it is asserted"                      "asserted=1" "$out"

# -- 11. never-compiled and unclaimed is reported, never accused --------------------------------
p=$(new_pen unclaimed)
mkdir -p "$p/lib" "$p/tools/a"
printf 'pub fn lonely() void {}\n' > "$p/lib/lonely.rye"
printf '#!/bin/sh\necho nothing\n' > "$p/tools/a/idle.sh"
seal "$p"; run_pen "$p"
check      "a file nobody claims exits 0"                  0 "$rc"
check_says "  ... yet it is reported never-compiled"       "never=1" "$out"
check_says "  ... and accused of nothing"                  "asserted=0" "$out"

# -- 12. a dangling import is named; an untracked one is told apart -----------------------------
p=$(new_pen dangling)
mkdir -p "$p/app" "$p/tools/a"
printf 'const g = @import("gone.rye");\nconst u = @import("here.rye");\npub fn main() void {}\n' > "$p/app/main.rye"
printf 'pub fn here() void {}\n' > "$p/app/here.rye"
printf '#!/bin/sh\nrye/bin/rye build app/main.rye\n' > "$p/tools/a/build.sh"
seal "$p"
# here.rye exists on disk yet leaves the index, so the two unknown targets differ by one `test -e`.
( cd "$p" && git rm -q --cached app/here.rye >/dev/null 2>&1 )
run_pen "$p"
check_says "an import of an absent file is dangling"       "dangling=1" "$out"
check_says "  ... an untracked-but-present one is not"     "untracked_targets=1" "$out"
run_pen "$p" --list dangling
check_says "  ... and the dangling one is named"           "app/gone.rye" "$out"

# -- 13. misuse and empty corpus refuse by name -------------------------------------------------
p=$(new_pen empty)
mkdir -p "$p/tools/a"
printf '#!/bin/sh\necho hi\n' > "$p/tools/a/idle.sh"
seal "$p"; run_pen "$p"
check      "a tree with no Rye refuses"                    2 "$rc"
check_says "  ... by name"                                 "verdict=empty_corpus" "$out"

run_pen "$p" --list nonsense
check      "an unknown set refuses"                        2 "$rc"
check_says "  ... by name"                                 "verdict=bad_set" "$out"
run_pen "$p" --bogus
check      "an unknown argument refuses"                   2 "$rc"
check_says "  ... by name"                                 "verdict=bad_argument" "$out"

# -- 14. the corpus bound bites, planted as max_corpus+1 ----------------------------------------
p=$(new_pen corpus_bound)
mkdir -p "$p/lib" "$p/tools/a"
i=0
while [ "$i" -le "$max_corpus" ]; do printf 'pub fn f() void {}\n' > "$p/lib/m$i.rye"; i=$((i + 1)); done
printf '#!/bin/sh\necho hi\n' > "$p/tools/a/idle.sh"
seal "$p"; run_pen "$p"
check      "a corpus past its bound refuses"               2 "$rc"
check_says "  ... by name"                                 "verdict=corpus_over_bound" "$out"

# -- 15. a symlink cycle terminates rather than spinning ----------------------------------------
p=$(new_pen link_cycle)
mkdir -p "$p/lib" "$p/tools/a"
( cd "$p/lib" && ln -s b.rye a.rye && ln -s a.rye b.rye )
printf '#!/bin/sh\necho hi\n' > "$p/tools/a/idle.sh"
seal "$p"; run_pen "$p"
check      "a symlink cycle terminates"                    0 "$rc"
check_says "  ... counting both links"                     "symlinks=2" "$out"

# -- 16. the pen proven innocent ----------------------------------------------------------------
# A census that always answers "nothing is accused" must fail the accusation case above. If it walks
# free here, every pass in this file is a pass of the pen rather than of the scan.
p=$(new_pen innocence)
mkdir -p "$p/lib" "$p/tools/a"
i=0
while [ "$i" -le "$ceiling" ]; do
  printf 'pub fn orphan() void {}\n' > "$p/lib/orphan$i.rye"
  printf '#!/bin/sh\ngrep -q pub lib/orphan%s.rye\n' "$i" > "$p/tools/a/claim$i.sh"
  i=$((i + 1))
done
seal "$p"
scan_in_pen="$p/tools/fixtures/r/rye_compile_reach_scan.sh"
awk '{ if ($0 ~ /^asserted=\$\(wc/) print "asserted=0"; else print }' "$scan_in_pen" > "$p/patched.sh"
cmp -s "$p/patched.sh" "$scan_in_pen" && { echo "  FAIL the innocence patch matched nothing"; fail=$((fail + 1)); }
cat "$p/patched.sh" > "$scan_in_pen"
run_pen "$p"
check      "a census that always answers zero walks free"    0 "$rc"
check_says "  ... on the same pen phase 3 refused"           "asserted=0" "$out"
echo "  ok   the pen is innocent -- identical plants, opposite answers, so phase 3 proved the scan"
pass=$((pass + 1))

echo "rye-compile-reach-control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || { echo "control_verdict=broken"; exit 1; }
echo "control_verdict=ok"
