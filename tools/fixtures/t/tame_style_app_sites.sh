#!/bin/sh
# tools/fixtures/t/tame_style_app_sites.sh -- count a pattern in PROGRAM position only.
#
# WHY. The TAME advise ratchets ask a lap to migrate an application site on touch --
# `parseInt(` to `tally/parse_int.rye`, `Ed25519` to `tally/kumara.rye`. Until 20260908 each
# was one `grep -hF <pattern> | wc -l`, which counts a LINE rather than a call, so it counted
# text a program prints and prose a comment writes.
#
# WHAT THAT COST, measured 20260908 across the twenty rooms in tame_style_rooms.txt:
#
#   pattern       printed   program   emitted text   comment
#   @memcpy(          137       138              0         0
#   parseInt(         125        46             79         0
#   Ed25519            26        18              0        29
#
# `glow/` is this tree's own language implementation, so its source contains the TEXT of the
# code it emits: `append_print(out, &used, "    const amount = std.fmt.parseInt(u32, argv[2],
# 10) catch return 2;\n", ...)` is a compiler writing Rye, and the witnesses beside it assert
# `std.mem.indexOf(u8, rye_argv, "parseInt(u32") != null` on that emitted text. All 79 sit
# there. A ratchet asking a lap to migrate them is asking for a wrong edit: there is no call to
# migrate, and rewriting the literal would change what Glow generates.
#
# `@memcpy(` measures the same under both rules -- 0 emitted, 0 comment -- so the 137 that
# 20260908 corrected from 1 stands whole, and its caller is left on its own two independent
# readings, which is the one count the parity selftest compares numerically.
#
# WHAT COUNTS AS PROGRAM POSITION. The occurrence is not on a `//` comment line, not on a `\\`
# Zig multiline-string continuation, and not inside a string literal earlier on its own line.
# The third is decided by quote parity before the match, with `\"` and the `'"'` character
# literal removed first so neither flips it.
#
# WHERE IT IS WRONG, IN BOTH DIRECTIONS, AND BOUNDED. Deciding a string properly is parsing
# rather than scanning, so tools/fixtures/r/rye_comment_ascii_scan.sh drew the same line here and
# for the same reason. The residue is two shapes, each named rather than implied:
#
#   * A TRAILING comment after code on the same line reads as program position, so the count can
#     run HIGH. It costs exactly one line today, and reading it is what found it: the whole
#     Ed25519 remainder is `glow/nock/nock_glow_mirror_witness.rye`'s
#     `const exact: u64 = 32; // ... Ed25519 seed length`, a comment rather than a call. Excluding
#     it needs to know whether that `//` sits inside a string, which is the parsing this declines.
#   * A quote earlier on the line that belongs to something else can flip parity and hide a real
#     call, so the count can run LOW. `\"` and `'"'` are removed first, which are the two forms
#     this tree actually writes.
#
# A line holding the pattern in code AND in a string counts once, which is the unit the elder
# greps already used. Read the sites before trusting a number: `--detail` prints the split, and
# the awk body above is short enough to run by hand over one room.
#
# ONE EXCLUSION IS CARRIED RATHER THAN INVENTED. `--exclude <text>` drops a line holding that
# text, case-insensitively, before any of the above. The Ed25519 ratchet has always excluded
# `fromEd25519` -- ten lines in the twenty rooms today -- because `X25519.KeyPair.fromEd25519` is
# an X25519 conversion rather than a signing site, so migrating it to `tally/kumara.rye` would be
# the wrong edit. The flag exists so that exemption stays visible at the call site instead of
# disappearing into a rewrite.
#
# USAGE
#   sh tools/fixtures/t/tame_style_app_sites.sh [--detail] [--exclude TEXT] <pattern> <file>...
#
# Prints one integer; `--detail` prints `program emitted comment` instead. Run from the root.

set -u

mode=count
exclude=""
while :; do
  case "${1:-}" in
    --detail) mode=detail; shift ;;
    --exclude) shift; exclude="${1:-}"; shift ;;
    *) break ;;
  esac
done
if [ $# -lt 2 ]; then echo "$0: usage: [--detail] [--exclude TEXT] <pattern> <file>..." >&2; exit 2; fi

pattern="$1"
shift

LC_ALL=C awk -v P="$pattern" -v MODE="$mode" -v X="$exclude" '
index($0, P) {
  if (X != "" && index(tolower($0), tolower(X))) next
  line = $0
  # A `\\` line is Zig multiline STRING content -- what a program prints, never what it calls.
  if (line ~ /^[ \t]*\\\\/) { emitted++; next }
  i = index(line, P)
  before = substr(line, 1, i - 1)
  # A `//` comment line is prose. `///` and `//!` are covered by the same leading match.
  if (before ~ /^[ \t]*\/\//) { comment++; next }
  # Neutralize an escaped quote and the character literal, so neither flips parity.
  gsub(/\\"/, "", before)
  gsub(/'"'"'"'"'"'/, "", before)
  n = gsub(/"/, "\"", before)
  if (n % 2 == 1) emitted++; else program++
}
END {
  if (MODE == "detail") printf "%d %d %d\n", program, emitted, comment
  else printf "%d\n", program
}' "$@"
