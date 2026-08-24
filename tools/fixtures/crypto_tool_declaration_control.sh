#!/bin/sh
# tools/fixtures/crypto_tool_declaration_control.sh -- prove the tool declaration bites, on real trees.
#
# WHY. tools/fixtures/crypto_tool_declaration_scan.sh excuses a crypto/*.rye from the suite bijection.
# An exemption proven only in the passing direction cannot be told from a bypass with a comment over
# it, so every refusal is planted here and watched to fire, and every honest reading is planted and
# watched to pass free.
#
# HOW. Each case builds a throwaway pen holding its own declaration, its own crypto directory, and
# its own roster, points the scan at them through CRYPTO_TOOL_DECL, CRYPTO_TOOL_DIR, and
# CRYPTO_TOOL_ROSTER, and reads the verdict. Nothing outside the pen is touched.
#
# USAGE
#   sh tools/fixtures/crypto_tool_declaration_control.sh
#
# Run from the repository root.
set -eu

SCAN="$(pwd)/tools/fixtures/crypto_tool_declaration_scan.sh"
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0

# build <name> <decl-body> <modules-to-create> <roster-guards>
build() {
  d="$PEN/$1"; mkdir -p "$d/crypto" "$d/construction"
  printf '%s\n' "$2" > "$d/decl.txt"
  for m in $3; do [ "$m" = "-" ] || : > "$d/crypto/$m.rye"; done
  : > "$d/construction/roster.kyri"
  for g in $4; do [ "$g" = "-" ] || echo "guard $g" >> "$d/construction/roster.kyri"; done
  # a witness file the declaration can point at, unless the case wants it absent
  mkdir -p "$d/tools"; : > "$d/tools/real_witness.rish"
  echo "$d"
}

check() { # check <label> <dir> <want-verdict>
  got=$(cd "$2" && CRYPTO_TOOL_DECL=decl.txt CRYPTO_TOOL_DIR=crypto CRYPTO_TOOL_ROSTER=construction/roster.kyri \
        sh "$SCAN" 2>/dev/null | sed -n 's/^verdict=//p') || got="refused"
  if [ "$got" = "$3" ]; then pass=$((pass+1)); echo "ok    $1 -> $got"
  else fail=$((fail+1)); echo "FAIL  $1 -> $got (wanted $3)"; fi
}

# --- the honest readings, which must pass free ---
d=$(build clean          "sha3_digest tools/real_witness.rish sha3_file" "sha3_digest" "sha3_file")
check "a sound row passes free"                    "$d" ok

d=$(build empty          "# only a comment" "-" "sha3_file")
check "an empty declaration is sound"              "$d" ok

d=$(build blanks         "
# comment after a blank

sha3_digest tools/real_witness.rish sha3_file
" "sha3_digest" "sha3_file")
check "blank lines and comments are skipped"       "$d" ok

d=$(build two_rows       "sha3_digest tools/real_witness.rish sha3_file
other_tool tools/real_witness.rish sha3_file" "sha3_digest other_tool" "sha3_file")
check "two sound rows pass free"                   "$d" ok

d=$(build extra_guards   "sha3_digest tools/real_witness.rish sha3_file" "sha3_digest" "sha3_file exec_bit room_bound")
check "a roster holding other guards is fine"      "$d" ok

# --- the refusals, each planted and watched to bite ---
d=$(build ghost          "never_written tools/real_witness.rish sha3_file" "-" "sha3_file")
check "a module nobody wrote is refused"           "$d" declaration_unsound

d=$(build no_witness     "sha3_digest tools/absent_witness.rish sha3_file" "sha3_digest" "sha3_file")
check "a redirect to no file is refused"           "$d" declaration_unsound

d=$(build off_roster     "sha3_digest tools/real_witness.rish sha3_file" "sha3_digest" "exec_bit")
check "a guard off the roster is refused"          "$d" declaration_unsound

d=$(build two_fields     "sha3_digest tools/real_witness.rish" "sha3_digest" "sha3_file")
check "a two-field row is refused"                 "$d" declaration_unsound

d=$(build four_fields    "sha3_digest tools/real_witness.rish sha3_file extra" "sha3_digest" "sha3_file")
check "a four-field row is refused"                "$d" declaration_unsound

d=$(build near_name      "sha3_digest tools/real_witness.rish sha3_fil" "sha3_digest" "sha3_file")
check "a guard name one letter short is refused"   "$d" declaration_unsound

d=$(build substring      "sha3_digest tools/real_witness.rish sha3" "sha3_digest" "sha3_file")
check "a guard name that is only a prefix is refused" "$d" declaration_unsound

d=$(build many_faults    "never_written tools/absent.rish nowhere" "-" "sha3_file")
check "three faults in one row are refused"        "$d" declaration_unsound

# a declaration file that is absent at all refuses rather than reading clean over nothing
d="$PEN/absent"; mkdir -p "$d/crypto" "$d/construction"; : > "$d/construction/roster.kyri"
check "an absent declaration refuses"              "$d" no_declaration

echo "cases_pass=$pass"
echo "cases_fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; exit 1; fi
