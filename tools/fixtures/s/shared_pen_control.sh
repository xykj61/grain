#!/bin/sh
# tools/fixtures/s/shared_pen_control.sh -- prove the shared-pen reading from both sides.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass.
#
# The pen this control builds is itself named by mktemp -- the law it exists to prove, kept by the
# file that proves it.
#
#   sh tools/fixtures/s/shared_pen_control.sh

set -u
root=$(pwd -P)
scan="$root/tools/fixtures/s/shared_pen_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: the scan under test is absent" >&2; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/shared_pen_control.XXXXXX") || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

faults=0
behaviors=0
say() { echo "$1"; }
claim() { # name expected actual
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then say "$1=yes"; else say "$1=no ($3, wanted $2)"; faults=$((faults + 1)); fi
}

newtree() {
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/tools/f" "$d/tools/date/20260101"
  ( cd "$d" && git init -q . && git config user.email c@example.invalid && git config user.name c )
  printf '#!/bin/sh\necho clean\n' > "$d/tools/f/clean.sh"
  ( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm seed >/dev/null 2>&1 )
}

readout() { # tree key -> value
  ( cd "$pen/$1" && SHARED_PEN_ROOT=. SHARED_PEN_FILES_CEILING=${C_FILES:-99} SHARED_PEN_WIPE_CEILING=${C_WIPE:-99} sh "$scan" ${3:-} 2>/dev/null ) \
    | sed -n "s/^$2=//p" | head -1
}
runs_ok() { ( cd "$pen/$1" && SHARED_PEN_ROOT=. SHARED_PEN_FILES_CEILING=${C_FILES:-99} SHARED_PEN_WIPE_CEILING=${C_WIPE:-99} sh "$scan" >/dev/null 2>&1 ); }

# --- 1. a clean tree reads zero and passes free -------------------------------------------------
newtree clean
claim clean_reads_zero 0 "$(readout clean constant_pen_files)"
runs_ok clean && claim clean_free yes yes || claim clean_free yes no

# --- 2-3. a planted constant pen is counted and named --------------------------------------------
newtree planted
printf '#!/bin/sh\nmkdir -p /tmp/my_fixed_pen\n' > "$pen/planted/tools/f/planted.sh"
( cd "$pen/planted" && git add -A >/dev/null 2>&1 && git commit -qm plant >/dev/null 2>&1 )
claim planted_counted 1 "$(readout planted constant_pen_files)"
listed=$( ( cd "$pen/planted" && SHARED_PEN_ROOT=. SHARED_PEN_FILES_CEILING=99 SHARED_PEN_WIPE_CEILING=99 sh "$scan" --list 2>/dev/null ) | grep -c 'my_fixed_pen' )
claim planted_named 1 "$listed"

# --- 4-8. the five free rules, each planted and each read as zero --------------------------------
free_case() { # name body
  newtree "$1"
  printf '%s' "$2" > "$pen/$1/tools/f/case.sh"
  ( cd "$pen/$1" && git add -A >/dev/null 2>&1 && git commit -qm case >/dev/null 2>&1 )
  claim "$1" 0 "$(readout "$1" constant_pen_files)"
}
free_case mktemp_free      '#!/bin/sh
d=$(mktemp -d /tmp/case.XXXXXX)
'
free_case template_free    '#!/bin/sh
d=/tmp/case.XXXXXX
'
free_case pid_free         '#!/bin/sh
d=/tmp/case_$$
'
free_case interpolate_free '#!/bin/sh
d="/tmp/case_${USER}"
'
free_case comment_free     '#!/bin/sh
# the elder wrote /tmp/case_home and that is why this rule exists
echo ok
'

# --- 8b. text inside single quotes is text, and the same token in double quotes still counts ------
# Proven from both sides in one tree, because a free rule shown only in the freeing direction
# cannot be told from a hole. The quoted plant is written the way this control writes every plant,
# which is what made the rule necessary: without it this file counted its own fixture text.
newtree quoting
# The single quote is built from its octal code so that this control's OWN copy of the token stays
# inside single quotes and stays freed -- otherwise the file proving the rule would break it.
q=$(printf '\047')
printf '#!/bin/sh\nprintf %srm -rf /tmp/quoted_only\\n%s > "$out"\n' "$q" "$q" > "$pen/quoting/tools/f/q.sh"
printf '#!/bin/sh\nmkdir -p "/tmp/double_quoted_pen"\n' > "$pen/quoting/tools/f/d.sh"
( cd "$pen/quoting" && git add -A >/dev/null 2>&1 && git commit -qm quoting >/dev/null 2>&1 )
claim single_quoted_free 1 "$(readout quoting constant_pen_files)"
qlist=$( ( cd "$pen/quoting" && SHARED_PEN_ROOT=. SHARED_PEN_FILES_CEILING=99 SHARED_PEN_WIPE_CEILING=99 sh "$scan" --list 2>/dev/null ) )
claim single_quoted_absent 0 "$(printf '%s\n' "$qlist" | grep -c 'quoted_only')"
claim double_quoted_counted 1 "$(printf '%s\n' "$qlist" | grep -c 'double_quoted_pen')"

# --- 8c-8e. the TMPDIR default spelling is read, and a lock is told from a pen -------------------
# `${TMPDIR:-/tmp}/name` holds no literal `/tmp/` -- the text reads `/tmp}` -- so the four elder
# spellings passed straight over it while `tlb_reach_census.sh` wiped a pen written that way. The
# `.lock` rule beside it must not become a hole, so the same token is planted on a wiping line and
# proven still counted: a lock is released with `rm -f`, and a pen wearing `.lock` behaves like a
# pen the moment it is wiped.
newtree tmpdefault
printf '#!/bin/sh\nmkdir -p "${TMPDIR:-/tmp}/default_spelled_pen"\n' > "$pen/tmpdefault/tools/f/d.sh"
( cd "$pen/tmpdefault" && git add -A >/dev/null 2>&1 && git commit -qm d >/dev/null 2>&1 )
claim tmpdir_default_counted 1 "$(readout tmpdefault constant_pen_files)"

newtree lockheld
printf '#!/bin/sh\nlock_acquire "${TMPDIR:-/tmp}/grain-port-38494.lock"\n' > "$pen/lockheld/tools/f/l.sh"
( cd "$pen/lockheld" && git add -A >/dev/null 2>&1 && git commit -qm l >/dev/null 2>&1 )
claim lock_free 0 "$(readout lockheld constant_pen_files)"

newtree lockwiped
printf '#!/bin/sh\nrm -rf "${TMPDIR:-/tmp}/grain-port-38494.lock"\n' > "$pen/lockwiped/tools/f/l.sh"
( cd "$pen/lockwiped" && git add -A >/dev/null 2>&1 && git commit -qm l >/dev/null 2>&1 )
claim lock_wiping_counted 1 "$(readout lockwiped constant_pen_files)"

# --- 9. dated testimony keeps every word it wrote -------------------------------------------------
newtree dated
printf '#!/bin/sh\nmkdir -p /tmp/dated_pen\n' > "$pen/dated/tools/date/20260101/20260101-000000_old.sh"
( cd "$pen/dated" && git add -A >/dev/null 2>&1 && git commit -qm dated >/dev/null 2>&1 )
claim dated_testimony_free 0 "$(readout dated constant_pen_files)"

# --- 10-11. the wiping subset is told from the holding one ---------------------------------------
newtree wiping
printf '#!/bin/sh\nrm -rf /tmp/wiped_pen\nmkdir -p /tmp/wiped_pen\n' > "$pen/wiping/tools/f/w.sh"
printf 'let x = run ["mkdir" "-p" "/tmp/held_pen"]\n' > "$pen/wiping/tools/f/h.rish"
( cd "$pen/wiping" && git add -A >/dev/null 2>&1 && git commit -qm wipe >/dev/null 2>&1 )
claim wiping_counted 1 "$(readout wiping wiping_files)"
claim holding_not_wiping 2 "$(readout wiping constant_pen_files)"

# --- 12. a Rishi list wipe is read as a wipe, since that is how this tree spells it ---------------
newtree rishwipe
printf 'let sweep = run ["rm" "-rf" "/tmp/rish_pen"]\n' > "$pen/rishwipe/tools/f/r.rish"
( cd "$pen/rishwipe" && git add -A >/dev/null 2>&1 && git commit -qm rw >/dev/null 2>&1 )
claim rishi_wipe_counted 1 "$(readout rishwipe wiping_files)"

# --- 12b-12e. a pen held in a variable and wiped on another line ---------------------------------
# The shape REDS `%544` found: the assignment and the `rm -rf` are separate lines, so a line-scoped
# reading called the file a hold. Proven in both spellings this tree writes -- a shell `"$pen"` and
# a Rishi bare word in a list -- and the tracker is proven NOT to be a hole from both sides: a
# variable named by `mktemp` is not a pen, and a wipe of some other name in a file that also holds
# one is not a wipe of the pen.
newtree varwipe
printf '#!/bin/sh\npen="/tmp/held_shell_pen"\nmkdir -p "$pen"\nrm -rf "$pen"\n' > "$pen/varwipe/tools/f/v.sh"
( cd "$pen/varwipe" && git add -A >/dev/null 2>&1 && git commit -qm vw >/dev/null 2>&1 )
claim var_wipe_counted 1 "$(readout varwipe wiping_files)"

newtree rishvarwipe
printf 'let home = "/tmp/held_rish_pen"\nlet sweep = run ["rm" "-rf" home]\n' > "$pen/rishvarwipe/tools/f/v.rish"
( cd "$pen/rishvarwipe" && git add -A >/dev/null 2>&1 && git commit -qm rvw >/dev/null 2>&1 )
claim rishi_var_wipe_counted 1 "$(readout rishvarwipe wiping_files)"

newtree varmktemp
printf '#!/bin/sh\npen=$(mktemp -d /tmp/case.XXXXXX)\nrm -rf "$pen"\n' > "$pen/varmktemp/tools/f/v.sh"
( cd "$pen/varmktemp" && git add -A >/dev/null 2>&1 && git commit -qm vm >/dev/null 2>&1 )
claim var_mktemp_free 0 "$(readout varmktemp wiping_files)"

newtree varunheld
printf '#!/bin/sh\npen="/tmp/only_written_pen"\nmkdir -p "$pen"\nrm -rf "$scratch"\n' > "$pen/varunheld/tools/f/v.sh"
( cd "$pen/varunheld" && git add -A >/dev/null 2>&1 && git commit -qm vu >/dev/null 2>&1 )
claim var_wipe_unheld_free 0 "$(readout varunheld wiping_files)"
claim var_unheld_still_counted 1 "$(readout varunheld constant_pen_files)"

# --- 12f-12k. the sixth spelling, and the two tightenings that shipped with it --------------------
# A removal without an `r` flag is still a removal. `tools/fixtures/s/shipped_binary_claim_scan.sh`
# truncated a constant name, appended to it, counted it and `rm -f`d it, and read RED in company
# and GREEN alone on the cold pass of `20260907.150519`. Both spellings are planted here, the
# literal and the held variable, because the elder predicate missed both.
newtree plainwipe
printf '#!/bin/sh\n: > /tmp/plain_hits.txt\nrm -f /tmp/plain_hits.txt\n' > "$pen/plainwipe/tools/f/p.sh"
( cd "$pen/plainwipe" && git add -A >/dev/null 2>&1 && git commit -qm pw >/dev/null 2>&1 )
claim nonrecursive_wipe_counted 1 "$(readout plainwipe wiping_files)"

newtree plainvarwipe
printf '#!/bin/sh\nscratch="/tmp/held_plain.txt"\n: > "$scratch"\nrm -f "$scratch"\n' > "$pen/plainvarwipe/tools/f/p.sh"
( cd "$pen/plainvarwipe" && git add -A >/dev/null 2>&1 && git commit -qm pvw >/dev/null 2>&1 )
claim nonrecursive_var_wipe_counted 1 "$(readout plainvarwipe wiping_files)"

# A LOCK IS STILL RELEASED WITH `rm -f`, so the widening had to leave that rule standing. This is
# the case the sixth spelling could most easily have broken, which is why it is planted rather than
# argued: the exemption now asks whether the removal was RECURSIVE, and `lock_wiping_counted` above
# proves the other side, that a pen wearing `.lock` is counted the moment it is destroyed like one.
newtree lockreleased
printf '#!/bin/sh\nrm -f "${TMPDIR:-/tmp}/grain-port-38494.lock"\n' > "$pen/lockreleased/tools/f/l.sh"
( cd "$pen/lockreleased" && git add -A >/dev/null 2>&1 && git commit -qm lr >/dev/null 2>&1 )
claim lock_release_free 0 "$(readout lockreleased constant_pen_files)"

# A PATH BEGINS AT A BOUNDARY. `/data/local/tmp/<name>` is an Android device path this pier never
# opens, and the token class alone matched its tail -- two HAWM witnesses were charged for it the
# moment the wipe reading widened.
newtree devicetmp
printf '#!/bin/sh\nadb shell rm -f /data/local/tmp/device_pen\n' > "$pen/devicetmp/tools/f/d.sh"
( cd "$pen/devicetmp" && git add -A >/dev/null 2>&1 && git commit -qm dt >/dev/null 2>&1 )
claim device_tmp_free 0 "$(readout devicetmp constant_pen_files)"

# A REMOVAL IS CHARGED TO THE PATH IT NAMES. One line of `tools/l/launch-claude-chapter.rish`
# removes a sentinel and, several commands later on the same line, tees a constant pen; the pen is
# a hold. Counted as a file and NOT as a wipe, so the tightening is proven to keep its teeth.
newtree segment
printf '#!/bin/sh\nrm -f .loop-gates-only && printf ok > /tmp/segment_pen\n' > "$pen/segment/tools/f/s.sh"
( cd "$pen/segment" && git add -A >/dev/null 2>&1 && git commit -qm sg >/dev/null 2>&1 )
claim separator_stops_the_wipe 0 "$(readout segment wiping_files)"
claim separator_still_counted 1 "$(readout segment constant_pen_files)"

# --- 13-14. the files ceiling, proven from both sides ---------------------------------------------
C_FILES=1 runs_ok planted && claim files_at_ceiling_free yes yes || claim files_at_ceiling_free yes no
C_FILES=0 runs_ok planted && claim files_over_ceiling_refused yes no || claim files_over_ceiling_refused yes yes
claim files_over_named over_ceiling "$(C_FILES=0 readout planted verdict)"

# --- 15-16. the wipe ceiling, proven from both sides ----------------------------------------------
C_WIPE=1 runs_ok wiping && claim wipe_at_ceiling_free yes yes || claim wipe_at_ceiling_free yes no
C_WIPE=0 runs_ok wiping && claim wipe_over_ceiling_refused yes no || claim wipe_over_ceiling_refused yes yes

# --- 17. only .sh and .rish are read -------------------------------------------------------------
newtree othertype
printf 'const p = "/tmp/rye_pen";\n' > "$pen/othertype/tools/f/x.rye"
( cd "$pen/othertype" && git add -A >/dev/null 2>&1 && git commit -qm other >/dev/null 2>&1 )
claim other_extension_free 0 "$(readout othertype constant_pen_files)"

# --- 18. an empty tools/ refuses rather than reading zero -----------------------------------------
newtree bare
( cd "$pen/bare" && git rm -q -r tools >/dev/null 2>&1 && git commit -qm bare >/dev/null 2>&1 )
claim no_sources_refused no_sources "$(readout bare verdict)"

# --- 19. a root that is not a git checkout refuses -------------------------------------------------
mkdir -p "$pen/nogit"
nogit=$( cd "$pen/nogit" && SHARED_PEN_ROOT=. sh "$scan" 2>/dev/null | sed -n 's/^verdict=//p' | head -1 )
claim no_git_refused no_git "$nogit"

# COUNTED RATHER THAN SPELLED. This line read `behaviors=24` while the control ran twenty-seven,
# because three cases were added and the tally was not -- a number carried in prose drifts from
# the thing it counts on the first lap nobody edits both. `claim` raises this on every call.
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "control_verdict=proven"; else echo "control_verdict=faulted"; exit 1; fi
