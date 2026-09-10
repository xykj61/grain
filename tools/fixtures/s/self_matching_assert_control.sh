#!/bin/sh
# Exercise operand-matching diagnostics on tracked Rishi files in isolated repositories.
# Each passing and refusing case supplies a concrete command form. Real utilities
# then demonstrate which default outputs carry a filename and which options remove it.
# The file-format shim models output; it makes no claim about an installed file utility.
# Static cases stay active when an optional output probe is unavailable.
# Exit 0 when every check passes, 1 when a check fails. All pens stay under TMPDIR.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
SCAN="$HERE/self_matching_assert_scan.sh"
PORTABLE="$HERE/shell_portable.sh"
[ -f "$SCAN" ] || { echo "control: scan missing at $SCAN"; exit 1; }
[ -f "$PORTABLE" ] || { echo "control: shell_portable.sh missing at $PORTABLE"; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT
trap 'rm -rf "$pen"; exit 130' INT
trap 'rm -rf "$pen"; exit 143' TERM

pass=0
fail=0
mechanism_skipped=0
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

new_pen() { # name -> echoes the pen root
  _p="$pen/$1"
  mkdir -p "$_p/rishi/bin" "$_p/tools/fixtures/s" "$_p/tools/a"
  cp "$PORTABLE" "$_p/tools/fixtures/s/shell_portable.sh"
  cp "$SCAN" "$_p/tools/fixtures/s/self_matching_assert_scan.sh"
  ( cd "$_p" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$_p"
}
seal() { ( cd "$1" && git add -A . >/dev/null 2>&1 && true ); }
run_pen() { # pen [args...]
  _r=$1; shift
  out=$( cd "$_r" && sh tools/fixtures/s/self_matching_assert_scan.sh "$@" 2>&1 ) && rc=0 || rc=$?
}

ceiling=$(sed -n 's/^ceiling=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
max_runners=$(sed -n 's/^max_runners=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
min_needle=$(sed -n 's/^min_needle=\([0-9][0-9]*\)$/\1/p' "$SCAN" | head -1)
[ -n "$ceiling" ] || { echo "control: could not read the ceiling out of the scan"; exit 1; }
[ -n "$max_runners" ] || { echo "control: could not read max_runners out of the scan"; exit 1; }
[ -n "$min_needle" ] || { echo "control: could not read min_needle out of the scan"; exit 1; }
echo "self-matching-assert-control: ceiling=$ceiling max_runners=$max_runners min_needle=$min_needle"

# -- 1. the REDS %460 shape, spelled literally --------------------------------------------------
p=$(new_pen the_shape)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file bin/seva_witness_aarch64"]
assert shape.out contains "aarch64" else "cross-built binary is not aarch64"
R
seal "$p"; run_pen "$p"
check      "the %460 shape is accused"                     1 "$rc"
check_says "  ... verdict names the gate"                  "verdict=gated_over_ceiling" "$out"
check_says "  ... and the site is named"                   "tools/a/w.rish:2" "$out"

# -- 2. the same fault reached through a variable ------------------------------------------------
# `glow_mobile_target_witness.rish` bound the path in a `let` and interpolated it, which is why the
# scan resolves one level of literal binding rather than reading the run line alone.
p=$(new_pen through_a_let)
cat > "$p/tools/a/w.rish" <<'R'
let bin = "linengrow/bin/seva_session_core_witness_aarch64"
let shape = run ["sh" "-c" "file ${bin}"]
assert shape.out contains "aarch64" else "cross-built binary is not aarch64"
R
seal "$p"; run_pen "$p"
check      "a needle reached through a let is accused"     1 "$rc"
check_says "  ... gated counts one"                        "gated=1" "$out"

# -- 3. hawm1's real margin: one hyphen ----------------------------------------------------------
p=$(new_pen margin_hyphen)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file linengrow/bin/seva_witness_android_x86_64"]
assert shape.out contains "x86-64" else "cross-built binary is not x86-64"
R
seal "$p"; run_pen "$p"
check      "x86-64 against a path spelling x86_64 walks free" 0 "$rc"
check_says "  ... and nothing is gated"                    "gated=0" "$out"

# -- 4. hawm3's real margin: one space ------------------------------------------------------------
p=$(new_pen margin_space)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file linengrow/bin/seva_witness_android_aarch64"]
assert shape.out contains "ARM aarch64" else "cross-built binary is not aarch64"
R
seal "$p"; run_pen "$p"
check      "ARM aarch64 against a path spelling _aarch64 walks free" 0 "$rc"

# -- 5. the compound the first draft accused ------------------------------------------------------
p=$(new_pen compound)
cat > "$p/tools/a/w.rish" <<'R'
let unheard = run ["sh" "-c" "d=$(mktemp -d); for f in $(find tools/a -name '*_witness.rish'); do : > $d/$(basename $f); done; : > $d/a_unregistered_witness.rish; sh scan.sh"]
assert unheard.out contains "a_unregistered_witness" else "want the unheard witness named"
R
seal "$p"; run_pen "$p"
check      "a compound ending in a scan is not accused"    0 "$rc"
check_says "  ... it is reported instead"                  "reported=1" "$out"

# -- 6. a silent command ---------------------------------------------------------------------------
p=$(new_pen silent)
cat > "$p/tools/a/w.rish" <<'R'
let body = run ["sh" "-c" "cat caravan/.allays/plan.settled"]
assert body.out contains "settled" else "want settled"
R
seal "$p"; run_pen "$p"
check      "cat does not echo its operand, so it is reported" 0 "$rc"
check_says "  ... reported counts one"                     "reported=1" "$out"

# -- 7. the direct list form, no sh -c -------------------------------------------------------------
p=$(new_pen direct_list)
cat > "$p/tools/a/w.rish" <<'R'
let names = run ["stat" "bin/seva_witness_aarch64"]
assert names.out contains "aarch64" else "want aarch64"
R
seal "$p"; run_pen "$p"
check      "an echoing utility in the list form is accused" 1 "$rc"

# -- stderr remains a review lead -----------------------------------------------------------------
p=$(new_pen err_side)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file bin/thing_aarch64"]
assert shape.err contains "aarch64" else "want aarch64"
R
seal "$p"; run_pen "$p"
check      "the err channel remains a reported match"      0 "$rc"

# -- 9. a needle no path token carries ---------------------------------------------------------------
p=$(new_pen not_in_path)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file bin/thing_aarch64"]
assert shape.out contains "ELF 64-bit" else "want an ELF"
R
seal "$p"; run_pen "$p"
check      "a needle no path token carries walks free"     0 "$rc"
check_says "  ... and it is not even reported"             "reported=0" "$out"

# -- 10. a needle under the minimum length ------------------------------------------------------------
# Planted as a ratio against the scan's own minimum, so this leg keeps testing the law after it moves.
p=$(new_pen short_needle)
short=; i=1
while [ "$i" -lt "$min_needle" ]; do short=${short}a; i=$((i + 1)); done
{ printf 'let shape = run ["sh" "-c" "file bin/%s_thing"]\n' "$short"
  printf 'assert shape.out contains "%s" else "want it"\n' "$short"; } > "$p/tools/a/w.rish"
seal "$p"; run_pen "$p"
check      "a needle under the minimum length walks free"  0 "$rc"

# -- 11. an interpolation this scan cannot bind --------------------------------------------------------
p=$(new_pen unresolved)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file ${somewhere_else}"]
assert shape.out contains "aarch64" else "want aarch64"
R
seal "$p"; run_pen "$p"
check      "an unbindable interpolation is not accused"    0 "$rc"
check_says "  ... it is published as residue"              "unresolved=1" "$out"

# -- 12. the ceiling, from both sides ------------------------------------------------------------------
p=$(new_pen at_ceiling)
# One honest runner first, so the corpus is never empty. At a ceiling of zero the loop below plants
# nothing, and a pen holding no `.rish` at all refuses `empty_corpus` -- a true reading of a
# different question, which would leave the ceiling untested from the passing side.
cat > "$p/tools/a/honest.rish" <<'R'
let shape = run ["sh" "-c" "file bin/thing_aarch64"]
assert shape.out contains "ELF 64-bit" else "want an ELF"
R
i=0
while [ "$i" -lt "$ceiling" ]; do
  { printf 'let s%s = run ["sh" "-c" "file bin/thing_aarch64"]\n' "$i"
    printf 'assert s%s.out contains "aarch64" else "want it"\n' "$i"; } > "$p/tools/a/w$i.rish"
  i=$((i + 1))
done
seal "$p"; run_pen "$p"
check      "exactly at the ceiling exits 0"                0 "$rc"
{ printf 'let over = run ["sh" "-c" "file bin/thing_aarch64"]\n'
  printf 'assert over.out contains "aarch64" else "want it"\n'; } > "$p/tools/a/over.rish"
seal "$p"; run_pen "$p"
check      "ceiling+1 exits 1"                             1 "$rc"

# -- 13. misuse refuses by name ------------------------------------------------------------------------
p=$(new_pen misuse)
printf 'let a = run ["sh" "-c" "echo hi"]\n' > "$p/tools/a/w.rish"
seal "$p"
run_pen "$p" --list; check      "--list with no set refuses"      2 "$rc"
run_pen "$p" --list nowhere; check "an unknown set refuses"       2 "$rc"
run_pen "$p" --clever; check    "an unknown argument refuses"     2 "$rc"
run_pen "$p" --list reported; check "a known set is welcome"      0 "$rc"

# -- 14. a tree with no runners refuses rather than reporting a clean zero --------------------------------
p=$(new_pen no_runners)
printf 'nothing here\n' > "$p/README.md"
seal "$p"; run_pen "$p"
check      "a tree with no .rish refuses"                  2 "$rc"
check_says "  ... by name"                                 "verdict=empty_corpus" "$out"

# -- 15. the mechanism, on metal ---------------------------------------------------------------------------
# Compare path output with file content; the gated defaults are checked below.
m="$pen/mechanism"; mkdir -p "$m"; printf 'hello\n' > "$m/needlepath_aarch64.txt"
lsout=$(ls "$m/needlepath_aarch64.txt" 2>&1 || true)
check_says "ls reprints its operand"                       "needlepath_aarch64" "$lsout"
catout=$(cat "$m/needlepath_aarch64.txt" 2>&1 || true)
check_lacks "  ... and cat does not, which is why it is absent from the set" "needlepath_aarch64" "$catout"
# A format shim keeps this baseline runnable when file is outside PATH. It speaks
# `path: description`, the format used by the recovered log to demonstrate the fault.
mkdir -p "$m/bin"
printf '#!/bin/sh\nprintf "%%s: ELF 64-bit LSB executable, x86-64\\n" "$1"\n' > "$m/bin/file"
chmod +x "$m/bin/file"
fileout=$(PATH="$m/bin:$PATH" file "$m/needlepath_aarch64.txt" 2>&1 || true)
check_says "file prints its operand before its description" "needlepath_aarch64.txt: ELF" "$fileout"
case "$fileout" in
  *aarch64*) pass=$((pass + 1)); echo "  ok   ... so 'contains aarch64' passes on an x86-64 binary -- the fault, reproduced" ;;
  *) fail=$((fail + 1)); echo "  FAIL the shim did not reproduce the fault" ;;
esac

# Command options, channels, and syntax keep their own reading.
case_read() { # name run-expression expected-gate needle [channel]
  p=$(new_pen "$1")
  printf 'let result = run %s\nassert result.%s contains "%s" else "want subject"\n' "$2" "${5:-out}" "$4" > "$p/tools/a/w.rish"
  seal "$p"; run_pen "$p"
  check "$1 exit" "$3" "$rc"
  check_says "$1 gated count" "gated=$3" "$out"
  if [ "$3" = 0 ]; then check_says "$1 stays reported" 'reported=1' "$out"; fi
}
case_read stat_default '["stat" "bin/needlepath.txt"]' 1 needlepath.txt
case_read stat_format '["stat" "--format=%s" "bin/needlepath.txt"]' 0 needlepath.txt
case_read stat_shell_format '["sh" "-c" "stat --format=%s bin/needlepath.txt"]' 0 needlepath.txt
case_read stat_short_format '["stat" "-c" "%s" "bin/needlepath.txt"]' 0 needlepath.txt
case_read file_brief '["file" "-b" "bin/needlepath.txt"]' 0 needlepath.txt
case_read file_shell_brief '["sh" "-c" "file -b bin/needlepath.txt"]' 0 needlepath.txt
case_read stderr_default '["stat" "bin/needlepath.txt"]' 0 needlepath.txt err
case_read shell_redirect '["sh" "-c" "stat bin/needlepath.txt > result.txt"]' 0 needlepath.txt
case_read shell_subshell '["sh" "-c" "stat bin/needlepath.txt | cat"]' 0 needlepath.txt
case_read directory_listing '["ls" "bin/needlepath"]' 0 needlepath
case_read basename_parent '["basename" "needlepath/file.txt"]' 0 needlepath
case_read dirname_leaf '["dirname" "bin/needlepath.txt"]' 0 needlepath
case_read find_printf '["find" "bin/needlepath" "-printf" "%s"]' 0 needlepath
case_read checksum_status '["sha256sum" "--status" "-c" "bin/needlepath.txt"]' 0 needlepath
case_read unresolved_operand '["stat" "bin/needlepath_${unknown}"]' 0 needlepath
case_read extra_operand '["stat" "bin/needlepath.txt" "bin/other.txt"]' 0 needlepath
case_read path_command '["/usr/bin/stat" "bin/needlepath.txt"]' 1 needlepath
case_read shell_path_command '["sh" "-c" "/usr/bin/stat bin/needlepath.txt"]' 1 needlepath
for command in file stat du wc sha256sum sha1sum sha512sum md5sum cksum; do
  case_read "default_$command" "[\"$command\" \"bin/needlepath.txt\"]" 1 needlepath
  case_read "option_$command" "[\"$command\" \"--help\" \"bin/needlepath.txt\"]" 0 needlepath
done

# Comments and later bindings cannot contribute an earlier command result.
p=$(new_pen comments)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["stat" "bin/needlepath.txt"]
# assert shape.out contains "needlepath" else "comment"
say "assert shape.out contains needlepath"
R
seal "$p"; run_pen "$p"
check 'comment-only assertions pass' 0 "$rc"
check_says 'comment-only assert count' 'asserts=0' "$out"
p=$(new_pen rebound_run)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["stat" "bin/needlepath.txt"]
let shape = another_result
assert shape.out contains "needlepath" else "new result"
R
seal "$p"; run_pen "$p"
check 'rebound result drops old command' 0 "$rc"
p=$(new_pen rebound_literal)
cat > "$p/tools/a/w.rish" <<'R'
let path = "bin/needlepath.txt"
let path = another_path
let shape = run ["stat" "${path}"]
assert shape.out contains "needlepath" else "new path"
R
seal "$p"; run_pen "$p"
check 'rebound literal drops old value' 0 "$rc"
check_says 'rebound literal reports unresolved' 'unresolved=1' "$out"

# A tracked path must remain readable; reader errors cannot become a clean census.
p=$(new_pen unreadable_corpus)
printf 'say "present"\n' > "$p/tools/a/w.rish"
seal "$p"
rm "$p/tools/a/w.rish"
run_pen "$p"
check 'missing tracked source refuses' 2 "$rc"
check_says 'reader failure has its own verdict' 'verdict=reader_failed' "$out"

# The corpus and assertion bounds are checked at the limit and one beyond it.
p=$(new_pen corpus_bound)
printf 'say "present"\n' > "$p/tools/a/w.rish"
sed 's/^max_runners=.*/max_runners=1/' "$p/tools/fixtures/s/self_matching_assert_scan.sh" > "$p/bounded.sh"
cat "$p/bounded.sh" > "$p/tools/fixtures/s/self_matching_assert_scan.sh"
seal "$p"; run_pen "$p"
check 'runner count at bound passes' 0 "$rc"
printf 'say "second"\n' > "$p/tools/a/other.rish"
seal "$p"; run_pen "$p"
check 'runner count above bound refuses' 2 "$rc"
check_says 'runner bound verdict' 'verdict=runners_over_bound' "$out"
p=$(new_pen assertion_bound)
printf 'assert answer.out contains "body" else "check"\n' > "$p/tools/a/w.rish"
sed 's/^max_asserts=.*/max_asserts=1/' "$p/tools/fixtures/s/self_matching_assert_scan.sh" > "$p/bounded.sh"
cat "$p/bounded.sh" > "$p/tools/fixtures/s/self_matching_assert_scan.sh"
seal "$p"; run_pen "$p"
check 'assertion count at bound passes' 0 "$rc"
printf 'assert answer.out contains "body" else "check"\n' >> "$p/tools/a/w.rish"
seal "$p"; run_pen "$p"
check 'assertion count above bound refuses' 2 "$rc"
check_says 'assertion bound verdict' 'verdict=asserts_over_bound' "$out"

# Default stdout and stderr are measured independently on this host.
for command in stat du wc sha256sum sha1sum sha512sum md5sum cksum; do
  if command -v "$command" >/dev/null 2>&1; then
    "$command" "$m/needlepath_aarch64.txt" > "$m/stdout" 2> "$m/stderr" && mechanism_rc=0 || mechanism_rc=$?
    check "$command default succeeds" 0 "$mechanism_rc"
    check_says "$command default stdout names operand" needlepath_aarch64 "$(cat "$m/stdout")"
    check_lacks "$command default stderr is separate" needlepath_aarch64 "$(cat "$m/stderr")"
  else
    mechanism_skipped=$((mechanism_skipped + 1))
    echo "mechanism_skip=$command -- utility absent on this host"
  fi
done
# Probe the GNU formatting capability separately from the file under test.
if command -v stat >/dev/null 2>&1 && stat --format=%s /dev/null >/dev/null 2>&1; then
  stat --format=%s "$m/needlepath_aarch64.txt" > "$m/stdout" && mechanism_rc=0 || mechanism_rc=$?
  check 'size-only stat succeeds' 0 "$mechanism_rc"
  check 'size-only stat prints measured bytes' "$(wc -c < "$m/needlepath_aarch64.txt" | tr -d ' ')" "$(cat "$m/stdout")"
  check_lacks 'size-only stat omits operand' needlepath_aarch64 "$(cat "$m/stdout")"
  echo 'probe_stat_format=read'
else
  echo 'probe_stat_format=unavailable -- GNU formatting absent; static option cases still ran'
fi
echo "mechanism_skipped=$mechanism_skipped"
echo 'mechanism_probes=accounted'
mkdir -p "$m/needlepath_directory"
ls "$m/needlepath_directory" > "$m/stdout"
check_lacks 'directory ls omits operand' needlepath "$(cat "$m/stdout")"
check_lacks 'basename removes parent needle' needlepath "$(basename needlepath/file.txt)"
check_lacks 'dirname removes leaf needle' needlepath "$(dirname bin/needlepath.txt)"

# -- 16. the pen proven innocent -----------------------------------------------------------------------------
p=$(new_pen innocence)
cat > "$p/tools/a/w.rish" <<'R'
let shape = run ["sh" "-c" "file bin/seva_witness_aarch64"]
assert shape.out contains "aarch64" else "cross-built binary is not aarch64"
R
seal "$p"
scan_in_pen="$p/tools/fixtures/s/self_matching_assert_scan.sh"
awk '{ if ($0 ~ /^gated=\$\(wc/) print "gated=0"; else print }' "$scan_in_pen" > "$p/patched.sh"
cmp -s "$p/patched.sh" "$scan_in_pen" && { echo "  FAIL the innocence patch matched nothing"; fail=$((fail + 1)); }
cat "$p/patched.sh" > "$scan_in_pen"
run_pen "$p"
check      "a scan that always answers zero walks free"    0 "$rc"
check_says "  ... on the same pen phase 1 refused"         "gated=0" "$out"
echo "  ok   the pen is innocent -- identical plants, opposite answers, so phase 1 proved the scan"
pass=$((pass + 1))

# One nested control proves the absent-utility path. Its PATH contains the
# support tools required by the scan; stat and checksum programs stay absent.
# invariant: the child flag bounds this check to one nested control invocation.
if [ "${SELF_MATCHING_PROBE_CHILD:-0}" != 1 ]; then
  support="$pen/support"; mkdir -p "$support"
  for tool in awk basename cat chmod cmp cp cut dirname du git grep head ls mkdir mktemp rm sed sh sort tr wc xargs; do
    tool_path=$(command -v "$tool")
    ln -s "$tool_path" "$support/$tool"
  done
  # xargs invokes an external printf; this wrapper carries the shell builtin.
  printf '#!%s\nprintf "$@"\n' "$(command -v sh)" > "$support/printf"
  chmod +x "$support/printf"
  child_out=$(SELF_MATCHING_PROBE_CHILD=1 PATH="$support" "$support/sh" "$HERE/self_matching_assert_control.sh" 2>&1) && child_rc=0 || child_rc=$?
  check 'absent optional utilities keep the control runnable' 0 "$child_rc"
  check_says 'absent stat format is named' 'probe_stat_format=unavailable' "$child_out"
  check_says 'absent utility probes are counted' 'mechanism_skipped=6' "$child_out"
  check_says 'static command cases survive absent utilities' 'control_verdict=ok' "$child_out"
fi

echo "self-matching-assert-control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || { echo "control_verdict=broken"; exit 1; }
echo "control_verdict=ok"
