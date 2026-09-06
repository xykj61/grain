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

echo "elf-machine-control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
