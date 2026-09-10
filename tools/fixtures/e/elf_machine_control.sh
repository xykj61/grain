#!/bin/sh
# tools/fixtures/e/elf_machine_control.sh -- prove the ELF machine reader on planted headers in a
# throwaway pen, refusals and welcomes both.
#
#   sh tools/fixtures/e/elf_machine_control.sh
#
# WHY PLANTED HEADERS RATHER THAN BUILT BINARIES. The reading under test is twenty bytes of a
# published format, so a header written by hand is a COMPLETE specimen -- no toolchain, no
# cross-compiler, no emulator. That is the happy zone the tree already names: a pure reading
# proven without the world, where the binaries it will meet live at the thin edge
# (foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md). It also lets this control
# plant machines and byte orders nothing on this pier can build.
#
# WHY BOTH DIRECTIONS, AND WHY FOUR DIFFERENT MACHINES. A refusal proven only in the passing
# direction cannot be told from a bypass -- and a reader that always answered "AArch64" would
# satisfy any single welcome. So four architectures are read back distinctly, and the same two
# bytes are planted under both byte orders, which is the one case that proves EI_DATA is genuinely
# consulted rather than assumed: 0x00b7 little-endian is AArch64, and those same bytes big-endian
# are 0xb700, a machine no one names.
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

SCAN="$(cd "$(dirname "$0")" && pwd)/elf_machine_scan.sh"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check() { # name expected_verdict actual_output
  _n="$1"; _want="$2"; _got="$3"
  if printf '%s\n' "$_got" | grep -q "^verdict=$_want$"; then
    echo "PASS: $_n (verdict=$_want)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted verdict=$_want, got:"
    printf '%s\n' "$_got" | sed 's/^/       /'
    fail=$((fail + 1))
  fi
}

check_says() { # name needle actual_output
  _n="$1"; _needle="$2"; _got="$3"
  if printf '%s\n' "$_got" | grep -q -- "$_needle"; then
    echo "PASS: $_n ($_needle)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted output carrying '$_needle', got:"
    printf '%s\n' "$_got" | sed 's/^/       /'
    fail=$((fail + 1))
  fi
}

check_exit() { # name expected_code actual_code
  _n="$1"; _want="$2"; _got="$3"
  if [ "$_got" = "$_want" ]; then
    echo "PASS: $_n (exit=$_want)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted exit $_want, got $_got"
    fail=$((fail + 1))
  fi
}

# An ELF header, written byte by byte: magic, EI_CLASS, EI_DATA, the nine bytes of padding that
# finish e_ident, a two-byte e_type, and e_machine at offset 18 where the reader looks.
plant() { # path class data machine_two_bytes
  printf '\177ELF'      >  "$1"
  printf "$2"           >> "$1"
  printf "$3"           >> "$1"
  printf '\0\0\0\0\0\0\0\0\0\0' >> "$1"
  printf '\002\0'       >> "$1"
  printf "$4"           >> "$1"
  printf '\0\0\0\0'     >> "$1"
}

run_scan() { out=$("$SCAN" "$@" 2>&1) && rc=0 || rc=$?; }

# -- the welcomes, four machines and two byte orders --------------------------------------------
plant "$pen/aarch64" '\002' '\001' '\267\0'
run_scan "$pen/aarch64"
check      "little-endian AArch64 reads"      read      "$out"
check_says "  ... and names AArch64"          "machine=AArch64" "$out"
check_says "  ... and reads its class"        "class=64" "$out"
check_exit "  ... and exits clean"            0 "$rc"

plant "$pen/x86_64" '\002' '\001' '\076\0'
run_scan "$pen/x86_64"
check_says "little-endian x86-64 reads"       "machine=x86-64" "$out"

plant "$pen/arm32" '\001' '\001' '\050\0'
run_scan "$pen/arm32"
check_says "32-bit ARM reads"                 "machine=ARM" "$out"
check_says "  ... and reads class 32"         "class=32" "$out"

plant "$pen/riscv_be" '\002' '\002' '\0\363'
run_scan "$pen/riscv_be"
check      "big-endian RISC-V reads"          read "$out"
check_says "  ... and names RISC-V"           "machine=RISC-V" "$out"
check_says "  ... and names its byte order"   "endian=big" "$out"

# THE CASE THAT PROVES EI_DATA IS CONSULTED. The same two bytes that spell AArch64 little-endian
# spell 0xb700 big-endian, which nothing names. A reader assuming little-endian passes every case
# above and fails this one.
plant "$pen/order_matters" '\002' '\002' '\267\0'
run_scan "$pen/order_matters"
check      "the same bytes big-endian are not AArch64" unknown_machine "$out"
check_says "  ... and it says which number"   "e_machine=46848" "$out"

# -- the refusals, each shown from the failing side ---------------------------------------------
plant "$pen/unnamed" '\002' '\001' '\231\0'
run_scan "$pen/unnamed"
check      "an unnamed machine refuses"       unknown_machine "$out"
check_says "  ... and names the number"       "e_machine=153" "$out"
check_exit "  ... and exits 1"                1 "$rc"

plant "$pen/bad_data" '\002' '\007' '\267\0'
run_scan "$pen/bad_data"
check      "an undecodable byte order refuses" not_elf "$out"
check_says "  ... and names EI_DATA"          "ei_data=7" "$out"

printf 'not an ELF at all, just some plain text here' > "$pen/plain"
run_scan "$pen/plain"
check      "a non-ELF file refuses"           not_elf "$out"
check_says "  ... on its magic"               "reason=magic" "$out"

printf 'ELF' > "$pen/tiny"
run_scan "$pen/tiny"
check      "a file too short refuses"         not_elf "$out"
check_says "  ... as truncated"               "reason=truncated" "$out"

run_scan "$pen/nothing-here"
check      "an absent path refuses"           absent "$out"
check_exit "  ... and exits 1"                1 "$rc"

out=$("$SCAN" 2>&1) && rc=0 || rc=$?
check      "no path at all refuses"           no_path "$out"
check_exit "  ... and exits 2, misuse"        2 "$rc"

# -- a batch reads every member, and refuses if any one does ------------------------------------
run_scan "$pen/aarch64" "$pen/riscv_be"
check      "two good paths read together"     read "$out"
check_says "  ... counting both"              "read=2" "$out"

run_scan "$pen/aarch64" "$pen/nothing-here"
check      "one absent member refuses a batch" absent "$out"
check_says "  ... while still reading the good one" "machine=AArch64" "$out"


# -- THE CENSUS'S COUNTING RULE, proven from both sides on a real repository ---------------------
#
# WHY IT IS HERE. The sibling census counts the sites that still prove an architecture by reading
# `file`'s prose, and until `20260910.035630` nothing checked what it counts. It read every line of
# every tracked runner, so the thirteen plants inside `tools/fixtures/s/self_matching_assert_control.sh`
# -- the literal REDS %460 shape that control exists to prove a guard against -- counted as thirteen
# live sites the hour that control landed. The census went 3 -> 16 against a ceiling of 3, refused,
# and `standing_equipment` refused the whole roster behind it.
#
# Both clauses of the repair are shown from the failing side as well as the passing one, and the
# ELDER reading is run over the same plants and asserted to DISAGREE -- a repair proven only in the
# passing direction cannot be told from a coincidence.
#
# A REAL REPOSITORY, because the census draws its population with `git ls-files`, and at the depth
# the census's own root walk expects: it climbs from its own directory to the first ancestor holding
# `rishi/bin` and `tools/fixtures`.
cpen="$(mktemp -d)"
trap 'rm -rf "$pen" "$cpen"' EXIT INT TERM
here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../../.." && pwd)"
t="$cpen/tree"
mkdir -p "$t/rishi/bin" "$t/tools/fixtures/e" "$t/tools/fixtures/s" "$t/tools/fixtures/l" "$t/tools/x"
cp "$here/elf_machine_census_scan.sh" "$t/tools/fixtures/e/"
cp "$root/tools/fixtures/s/shell_portable.sh" "$t/tools/fixtures/s/"
cp "$root/tools/fixtures/l/live_lines.sh" "$t/tools/fixtures/l/"
: > "$t/rishi/bin/.keep"
( cd "$t" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )

cplant() { mkdir -p "$(dirname -- "$t/$1")"; printf '%s\n' "$2" > "$t/$1"; }

# 1. A LIVE SITE -- the shape the census exists to count, on a line nothing encloses.
cplant tools/x/live_site.rish 'let shape = run ["sh" "-c" "file bin/thing_aarch64"]'
# 2. THE SAME TEXT INSIDE A HEREDOC this file writes into a pen. It is a Rishi program handed to
#    another interpreter, so it is data rather than a call.
cplant tools/x/heredoc_plant.sh 'cat > "$p/w.rish" <<'"'"'R'"'"'
let shape = run ["sh" "-c" "file bin/thing_aarch64"]
R'
# 3. THE SAME TEXT INSIDE A CONTROL, in the printf form the live-line walk cannot see: the line is
#    live at its start and the site sits inside a single-quoted argument on it.
cplant tools/x/planted_control.sh "printf 'let shape = run [\"sh\" \"-c\" \"file bin/thing_aarch64\"]\\n'"
( cd "$t" && git add -A >/dev/null && git commit -q -m "pen: planted sites" )

csites() { ( cd "$t" && sh tools/fixtures/e/elf_machine_census_scan.sh --list 2>&1 ); }
cnamed() { csites | sed -n "s|^site count=[0-9]* path=.*/\\($1\\)\$|yes|p" | head -1; }
cnamed_or_no() { _r=$(cnamed "$1"); [ -n "$_r" ] && echo yes || echo no; }

cleg() { # cleg <name> <want> <got>
  if [ "$2" = "$3" ]; then echo "PASS: $1 ($3)"; pass=$((pass + 1))
  else echo "FAIL: $1 -- wanted $2, read $3"; fail=$((fail + 1)); fi
}

cleg "a live site is counted"                  yes "$(cnamed_or_no 'live_site\.rish')"
cleg "a heredoc plant is not a call"           no  "$(cnamed_or_no 'heredoc_plant\.sh')"
cleg "a control's plant is not the practice"   no  "$(cnamed_or_no 'planted_control\.sh')"

# THE ELDER READING, spelled here as it stood: every line of every tracked runner, controls
# included. It must COUNT both plants, or the two legs above pass on the elder predicate alone.
elder() { # elder <basename-regex>
  ( cd "$t" && git ls-files '*.rish' '*.sh' | while IFS= read -r ef; do
      awk '{ l = $0; sub(/#.*/, "", l)
             if (l ~ /(^|[;&|(]|"-c" ")[ \t]*file[ \t]+[^=|)]/) c++ }
           END { if (c > 0) print FILENAME }' "$ef"
    done ) | grep -qE "/$1\$" && echo yes || echo no
}
cleg "the elder counted the heredoc plant"     yes "$(elder 'heredoc_plant\.sh')"
cleg "the elder counted the control's plant"   yes "$(elder 'planted_control\.sh')"

# 4. THE CEILING BITES, shown from both sides, since a ceiling proven only under it is a ceiling
#    nobody has seen refuse. The census's own ceiling is 3.
cplant tools/x/live_two.rish 'let a = run ["sh" "-c" "file bin/two"]'
cplant tools/x/live_three.rish 'let a = run ["sh" "-c" "file bin/three"]'
( cd "$t" && git add -A >/dev/null && git commit -q -m "pen: three live sites" )
cout=$(csites) && crc=0 || crc=$?
cleg "three live sites stand at the ceiling"   under_ceiling "$(printf '%s\n' "$cout" | sed -n 's/^verdict=//p')"
cleg "  ... and exit 0"                        0 "$crc"

cplant tools/x/live_four.rish 'let a = run ["sh" "-c" "file bin/four"]'
( cd "$t" && git add -A >/dev/null && git commit -q -m "pen: a fourth live site" )
cout=$(csites) && crc=0 || crc=$?
cleg "a fourth live site crosses the ceiling"  over_ceiling "$(printf '%s\n' "$cout" | sed -n 's/^verdict=//p')"
cleg "  ... and exit 1"                        1 "$crc"


echo "elf-machine-control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
