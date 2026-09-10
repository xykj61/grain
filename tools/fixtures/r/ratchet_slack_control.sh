#!/bin/sh
# ratchet_slack_control.sh -- prove the ratchet-slack census refuses and welcomes on real trees.
#
#   sh tools/fixtures/r/ratchet_slack_control.sh
#
# Every leg builds a throwaway pen holding the census at its own relative path and a pairing table
# of the pen's own, because the census resolves both from its own location and would otherwise read
# the tree it was copied out of. Each refusal is planted and then lifted, so every counter is seen
# at more than one value -- a counter only ever seen at one value cannot be told from a constant.
set -u

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
scan_src="$root/tools/fixtures/r/ratchet_slack_scan.sh"
[ -f "$scan_src" ] || { echo "ratchet_slack_control: REFUSED -- the census is absent at $scan_src" >&2; exit 2; }

pen=$(mktemp -d) || { echo "ratchet_slack_control: REFUSED -- no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0
check() {
  legs=$((legs + 1))
  if [ "$3" = "$2" ]; then printf 'ok   %s\n' "$1"; else
    failed=$((failed + 1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2
  fi
}
field() { printf '%s\n' "$2" | sed -n "s|^$1=||p" | head -1; }

mkdir -p "$pen/tools/fixtures/r" "$pen/tools/fixtures/p"
cp "$scan_src" "$pen/tools/fixtures/r/ratchet_slack_scan.sh"
cd "$pen" || exit 2

pairs() { printf '%s\n' "$@" > tools/fixtures/r/ratchet_slack_pairs.txt; }
run() { sh tools/fixtures/r/ratchet_slack_scan.sh "$@" 2>&1; }

# A planted scan: declares a ceiling, prints a reading beside it, and compares the two.
plant_held() {  # file, ceiling key, ceiling value, reading key, reading value
  cat > "$1" <<EOF
#!/bin/sh
$2=$3
echo "$4=$5"
echo "${2}=\$$2"
if [ "$5" -le "\$$2" ]; then echo "verdict=ok"; else echo "verdict=over"; exit 1; fi
EOF
}

# -- leg 1: one scan whose ceiling is compared reads one ceiling, held, and welcomes -------------
plant_held tools/fixtures/p/pen_one_scan.sh CEILING 10 chars 4
pairs 'pen_one|CEILING|chars'
out=$(run)
check one_ceiling 1 "$(field ceilings "$out")"
check one_compared 1 "$(field ceilings_compared "$out")"
check one_uncompared 0 "$(field ceilings_uncompared "$out")"
check one_stale 0 "$(field stale_pairs "$out")"
check one_verdict ok "$(field verdict "$out")"

# -- leg 1b: the census does not read its own bookkeeping as a tree ceiling ---------------------
# invariant: this census names a counter `ceilings=`, which its own discovery pattern matches, so
# excluding itself is load-bearing rather than tidy -- planted here so a future edit cannot drop it.
check self_excluded no "$(case "$(run --names)" in *"ratchet ratchet_slack "*) echo yes ;; *) echo no ;; esac)"

# -- leg 1c: a control's planted ceiling is test material, never a tree ceiling ------------------
# invariant: only a `_scan.sh` is read. This control declares `CEILING=3` in the here-document
# below, and the census counted it as a tree ceiling on its first live run (REDS %519, one room
# over: a control's plants are literal lines of the module it breaks).
cat > tools/fixtures/p/pen_two_control.sh <<'EOF'
#!/bin/sh
CEILING=3
echo "chars=99"
EOF
out=$(run)
check control_not_counted 1 "$(field ceilings "$out")"
check control_verdict_free ok "$(field verdict "$out")"
rm -f tools/fixtures/p/pen_two_control.sh

# -- leg 2: a ceiling declared, printed, and never compared is a gate that cannot refuse ---------
# invariant: the census refuses a ceiling no branch reads, since such a ceiling is decoration.
cat > tools/fixtures/p/pen_loose_scan.sh <<'EOF'
#!/bin/sh
CEILING=3
echo "chars=99"
echo "CEILING=$CEILING"
echo "verdict=ok"
EOF
out=$(run)
check loose_uncompared 1 "$(field ceilings_uncompared "$out")"
check loose_verdict ceiling_unheld "$(field verdict "$out")"
run >/dev/null 2>&1; check loose_exit 1 "$?"

# -- leg 3: lifting the plant returns the reading, so the counter is seen at two values ----------
rm -f tools/fixtures/p/pen_loose_scan.sh
out=$(run)
check lifted_uncompared 0 "$(field ceilings_uncompared "$out")"
check lifted_verdict ok "$(field verdict "$out")"

# -- leg 4: a table row naming a ceiling no scan declares is the second copy going stale ---------
# invariant: the pairing table is the census's own hand-kept copy of a name, so it is checked
# against the tree rather than trusted -- the fault a second copy of a name always has.
pairs 'pen_one|CEILING|chars' 'pen_gone|CEILING|chars'
out=$(run)
check stale_counted 1 "$(field stale_pairs "$out")"
check stale_named yes "$(case "$out" in *"stale_pair pen_gone CEILING"*) echo yes ;; *) echo no ;; esac)"
check stale_verdict ceiling_unheld "$(field verdict "$out")"

# -- leg 5: a row whose ceiling key was renamed under it reads stale for the same reason ---------
pairs 'pen_one|OLD_CEILING|chars'
out=$(run)
check renamed_stale 1 "$(field stale_pairs "$out")"
check renamed_verdict ceiling_unheld "$(field verdict "$out")"
pairs 'pen_one|CEILING|chars'
out=$(run)
check renamed_lifted 0 "$(field stale_pairs "$out")"

# -- leg 6: --live reads the reading beside the ceiling and subtracts ----------------------------
out=$(run --live)
check live_reading yes "$(case "$out" in *"ratchet pen_one CEILING ceiling=10 reading=4 slack=6"*) echo yes ;; *) echo no ;; esac)"
check live_with_slack 1 "$(field with_slack "$out")"
check live_zero_slack 0 "$(field zero_slack "$out")"
check live_over 0 "$(field over_ceiling "$out")"

# -- leg 7: a reading standing exactly at its ceiling is zero slack, not slack -------------------
# invariant: zero slack is counted apart from slack, because it is the state where the next
# arrival reds -- the whole question this census was built to answer.
plant_held tools/fixtures/p/pen_one_scan.sh CEILING 10 chars 10
out=$(run --live)
check tight_slack yes "$(case "$out" in *"ceiling=10 reading=10 slack=0"*) echo yes ;; *) echo no ;; esac)"
check tight_zero_slack 1 "$(field zero_slack "$out")"
check tight_with_slack 0 "$(field with_slack "$out")"

# -- leg 8: a wall already at zero over an empty population is counted apart from both -----------
plant_held tools/fixtures/p/pen_one_scan.sh CEILING 0 chars 0
out=$(run --live)
check wall_counted 1 "$(field wall_at_zero "$out")"
check wall_not_zero_slack 0 "$(field zero_slack "$out")"

# -- leg 9: a reading above its ceiling is counted over, and named ------------------------------
plant_held tools/fixtures/p/pen_one_scan.sh CEILING 5 chars 9
out=$(run --live)
check over_counted 1 "$(field over_ceiling "$out")"
check over_slack yes "$(case "$out" in *"ceiling=5 reading=9 slack=-4"*) echo yes ;; *) echo no ;; esac)"

# -- leg 10: a ceiling with no table row is counted unread rather than dropped -------------------
# invariant: no silent caps -- a reading the census cannot take is printed as one it did not take.
pairs '# every row removed'
out=$(run --live)
check unread_counted 1 "$(field unread "$out")"
check unread_named yes "$(case "$out" in *"reads=unpaired"*) echo yes ;; *) echo no ;; esac)"
check unread_read 0 "$(field read "$out")"

# -- leg 10b: a reading key may name the line it is read from ------------------------------------
# invariant: a scan printing one key name twice under two ceilings is read on the right line.
cat > tools/fixtures/p/pen_two_scan.sh <<'EOF'
#!/bin/sh
FIRST_CEILING=10
SECOND_CEILING=20
echo "HEAD_ONE chars=4 ceiling=$FIRST_CEILING"
echo "HEAD_TWO chars=17 ceiling=$SECOND_CEILING"
if [ 4 -le "$FIRST_CEILING" ] && [ 17 -le "$SECOND_CEILING" ]; then echo "verdict=ok"; fi
EOF
pairs 'pen_two|FIRST_CEILING|HEAD_ONE@chars' 'pen_two|SECOND_CEILING|HEAD_TWO@chars'
out=$(run --live)
check anchor_first yes "$(case "$out" in *"FIRST_CEILING ceiling=10 reading=4 slack=6"*) echo yes ;; *) echo no ;; esac)"
check anchor_second yes "$(case "$out" in *"SECOND_CEILING ceiling=20 reading=17 slack=3"*) echo yes ;; *) echo no ;; esac)"
rm -f tools/fixtures/p/pen_two_scan.sh
pairs '# every row removed'
out=$(run --live)

# -- leg 10c: an overridable ceiling names every value a tracked runner passes ------------------
# invariant: the slack is read against the FILE default and each caller's value is listed beside
# it, because only some passes are the living reading -- `tame_reach_witness` passes 0 to show its
# gate refusing, and a census choosing that value called a green guard 24 over its ceiling.
mkdir -p tools/w
cat > tools/fixtures/p/pen_one_scan.sh <<'EOF'
#!/bin/sh
CEILING=${PEN_CEILING:-10}
echo "chars=1"
echo "CEILING=$CEILING"
if [ 1 -le "$CEILING" ]; then echo "verdict=ok"; else echo "verdict=over"; exit 1; fi
EOF
pairs 'pen_one|CEILING|chars'
printf 'let scan = run ["env" "PEN_CEILING=4" "sh" "tools/fixtures/p/pen_one_scan.sh"]\n' > tools/w/pen_witness.rish
out=$(run --live)
check caller_listed yes "$(case "$out" in *"callers=4"*) echo yes ;; *) echo no ;; esac)"
check caller_slack_from_file yes "$(case "$out" in *"ceiling=10 reading=1 slack=9"*) echo yes ;; *) echo no ;; esac)"
check caller_overridable 1 "$(field ceilings_overridable "$out")"

# -- leg 10d: a control's planted value is not a caller ------------------------------------------
# invariant: REDS %519 -- a control's plants are literal lines of the thing it breaks, so reading
# them as callers made one ceiling look like three callers disagreeing.
printf 'PEN_CEILING=99 sh tools/fixtures/p/pen_one_scan.sh\n' > tools/fixtures/p/pen_one_control.sh
out=$(run --live)
check plant_not_caller yes "$(case "$out" in *"callers=4"*) echo yes ;; *) echo no ;; esac)"
rm -f tools/fixtures/p/pen_one_control.sh

# -- leg 10e: two callers are both listed, in order ----------------------------------------------
# invariant: a census that picks one of two lawful values prints a slack nobody can check.
printf 'let two = run ["env" "PEN_CEILING=9" "sh" "tools/fixtures/p/pen_one_scan.sh"]\n' > tools/w/pen_two_witness.rish
out=$(run --live)
check two_callers_listed yes "$(case "$out" in *"callers=4,9"*) echo yes ;; *) echo no ;; esac)"
rm -f tools/w/pen_two_witness.rish tools/w/pen_witness.rish

# -- leg 10e2: a reading over the file default is counted apart when a caller could explain it ----
# invariant: an over reading on an overridable ceiling may be a green guard read at the wrong
# number, so the two counts are separate and a reader is sent to the caller.
cat > tools/fixtures/p/pen_one_scan.sh <<'EOF'
#!/bin/sh
CEILING=${PEN_CEILING:-0}
echo "chars=3"
echo "CEILING=$CEILING"
if [ 3 -le "$CEILING" ]; then echo "verdict=ok"; else echo "verdict=over"; exit 1; fi
EOF
printf 'let one = run ["env" "PEN_CEILING=5" "sh" "tools/fixtures/p/pen_one_scan.sh"]\n' > tools/w/pen_witness.rish
out=$(run --live)
check over_with_caller_counted 1 "$(field over_ceiling_with_callers "$out")"
check over_counted_too 1 "$(field over_ceiling "$out")"
rm -f tools/w/pen_witness.rish
out=$(run --live)
check over_without_caller 0 "$(field over_ceiling_with_callers "$out")"
plant_held tools/fixtures/p/pen_one_scan.sh CEILING 10 chars 4
pairs 'pen_one|CEILING|chars'

# -- leg 10f: a scan that does not answer inside the bound is named, never read as unpaired ------
# invariant: no silent caps -- `unanswered` is a reading the census could not take, and `unread` is
# a ceiling nobody paired. Dropping the first into the second hides a whole scan.
cat > tools/fixtures/p/pen_slow_scan.sh <<'EOF'
#!/bin/sh
CEILING=10
sleep 5
echo "chars=1 CEILING=$CEILING"
[ 1 -le "$CEILING" ] && echo "verdict=ok"
EOF
pairs 'pen_one|CEILING|chars' 'pen_slow|CEILING|chars'
out=$(RATCHET_SLACK_TIMEOUT=1 run --live)
check slow_unanswered 1 "$(field unanswered "$out")"
check slow_not_unread 0 "$(field unread "$out")"
check slow_named yes "$(case "$out" in *"pen_slow CEILING ceiling=10 reading=unanswered"*) echo yes ;; *) echo no ;; esac)"
out=$(run --live)
check slow_answered yes "$(case "$out" in *"pen_slow CEILING ceiling=10 reading=1 slack=9"*) echo yes ;; *) echo no ;; esac)"
rm -f tools/fixtures/p/pen_slow_scan.sh
pairs 'pen_one|CEILING|chars'

# -- leg 11: --live prints no verdict line, so it can never be read as a gate --------------------
# invariant: the live half is a census; a verdict word beside it would invite a roster seat that
# costs minutes of every lap.
check live_no_verdict '' "$(field verdict "$out")"

# -- leg 12: an absent pairing table refuses rather than reading every ceiling as unpaired -------
rm -f tools/fixtures/r/ratchet_slack_pairs.txt
out=$(run)
check no_table_verdict table_missing "$(field verdict "$out")"
run >/dev/null 2>&1; check no_table_exit 2 "$?"

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] || { echo "control_verdict=failed"; exit 1; }
echo "control_verdict=ok"
