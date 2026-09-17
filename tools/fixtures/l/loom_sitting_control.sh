#!/bin/sh
# tools/fixtures/l/loom_sitting_control.sh -- prove the cross-sitting reading on a planted corpus.
#
#   sh tools/fixtures/l/loom_sitting_control.sh
#
# Every reading `tools/fixtures/l/loom_sitting_scan.sh` prints is asserted here against a corpus
# whose right answer was worked out by hand before the scan ran, and every refusal is shown from
# BOTH sides -- planted so it fires, then lifted so the same pen walks free. A refusal proven only
# in the passing direction cannot be told from a bypass.
#
# THE PEN IS A REAL GIT REPOSITORY, because the read is `git ls-files` and a directory walk would
# prove a different instrument than the one that ships.
#
# MUTATIONS RUN EVERY PASS rather than being recorded once, and each is preceded by a check that
# its own marker still stands in the source -- a mutation that removes nothing reads as a passing
# leg, which is the fault a sibling lane booked this week.
#
# No network, no key, no funds, no device. Writes only inside a temporary pen it removes.

set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
pen=$(mktemp -d "${TMPDIR:-/tmp}/loom-sitting-pen.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() { # leg NAME WANT GOT
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $1 ok want=$2"
  else
    failed=$((failed + 1))
    echo "leg $1 FAILED want=$2 got=$3"
  fi
}

# A log carrying loom lines, born on a day shelf.
plant() { # plant CORPUS DAY NAME LINE...
  c=$1; d=$2; n=$3; shift 3
  mkdir -p "$c/session-logs/date/$d"
  f="$c/session-logs/date/$d/$d-000000_$n.kyri"
  {
    echo "format session-log-v1"
    echo "stamp $d.000000"
    for l in "$@"; do echo "$l"; done
  } > "$f"
}

newcorpus() { # newcorpus NAME -> path
  c="$pen/$1"
  mkdir -p "$c"
  ( cd "$c" && git init -q . && git config user.email pen@example.invalid && git config user.name pen ) >/dev/null
  echo "$c"
}

commitall() { ( cd "$1" && git add -A && git -c commit.gpgsign=false commit -qm pen ) >/dev/null; }

scan() { # scan CORPUS KEY [MODE]
  LOOM_ROOT="$1" sh "$root/tools/fixtures/l/loom_sitting_scan.sh" "$2" "${3-summary}" 2>&1 || true
}

field() { printf '%s\n' "$1" | grep -E "^$2=" | head -1 | cut -d= -f2- | cut -d' ' -f1; }

# ---------------------------------------------------------------- the reference corpus
# Worked by hand BEFORE the scan ran:
#   20260101: 10 12 14   median 12  spread 4   ppt 333.3
#   20260102: 20 22      median 21  spread 2   ppt  95.2
#   20260103: 100        median 100 spread --  singleton, UNMEASURED rather than zero
#   sitting medians 12 21 100 -> median 21, spread 88, across = 88*1000/21 = 4190.5
#   withins 95.2 333.3 -> even count, mean of the two = 214.3
A=$(newcorpus ref)
plant "$A" 20260101 one "loom probe=p v=10"
plant "$A" 20260101 two "loom probe=p v=12"
plant "$A" 20260101 three "loom probe=p v=14"
plant "$A" 20260102 four "loom probe=p v=20"
plant "$A" 20260102 five "loom probe=p v=22"
plant "$A" 20260103 six "loom probe=p v=100"
commitall "$A"
out=$(scan "$A" v)

leg values "6" "$(field "$out" values)"
leg numeric "6" "$(field "$out" numeric)"
leg sittings "3" "$(field "$out" sittings)"
leg sittings_multi "2" "$(field "$out" sittings_multi)"
leg sittings_singleton "1" "$(field "$out" sittings_singleton)"
leg within_ppt "214.3" "$(field "$out" within_ppt)"
leg across_ppt "4190.5" "$(field "$out" across_ppt)"
leg resolution_ppt "214.3" "$(field "$out" resolution_ppt)"
leg ratio "19.56" "$(field "$out" ratio)"
leg spread_class "suspect_mixed" "$(field "$out" spread_class)"
# The scale is its own fact. These medians are 12, 21 and 100, so the median of medians is 21 and
# a ppt reading over it means something.
leg scale "21" "$(field "$out" scale)"
leg scale_class "fine" "$(field "$out" scale_class)"
leg verdict "across_exceeds_noise" "$(field "$out" verdict)"

# The explain mode names each sitting, and the singleton's own ppt reads `na` rather than 0.
ex=$(scan "$A" v --explain)
leg explain_rows "3" "$(printf '%s\n' "$ex" | grep -c "^sitting$(printf '\t')")"
leg explain_singleton_na "na" "$(printf '%s\n' "$ex" | grep '20260103' | sed 's/.*ppt=//')"
leg explain_first_ppt "333.3" "$(printf '%s\n' "$ex" | grep '20260101' | sed 's/.*ppt=//')"

# ---------------------------------------------------------------- the singleton is excluded
# Give the singleton day a second value and the within reading MUST move. If a singleton's zero
# were averaged in, this pen's within would already be dragged below 214.3.
B=$(newcorpus excl)
plant "$B" 20260101 one "loom probe=p v=10"
plant "$B" 20260101 two "loom probe=p v=12"
plant "$B" 20260101 three "loom probe=p v=14"
plant "$B" 20260102 four "loom probe=p v=20"
plant "$B" 20260102 five "loom probe=p v=22"
plant "$B" 20260103 six "loom probe=p v=100"
plant "$B" 20260103 seven "loom probe=p v=100"
commitall "$B"
outb=$(scan "$B" v)
leg excl_singleton_gone "0" "$(field "$outb" sittings_singleton)"
leg excl_within_moved "95.2" "$(field "$outb" within_ppt)"

# ---------------------------------------------------------------- noise dominates
# Three sittings wandering widely inside themselves and landing on near-identical medians.
C=$(newcorpus dom)
plant "$C" 20260101 one "loom probe=p v=50"
plant "$C" 20260101 two "loom probe=p v=150"
plant "$C" 20260102 three "loom probe=p v=40"
plant "$C" 20260102 four "loom probe=p v=160"
plant "$C" 20260103 five "loom probe=p v=45"
plant "$C" 20260103 six "loom probe=p v=157"
commitall "$C"
outc=$(scan "$C" v)
leg dom_verdict "noise_dominates" "$(field "$outc" verdict)"
leg dom_class "one_population" "$(field "$outc" spread_class)"

# ---------------------------------------------------------------- a count is not a measurement
# A key running 0 to 3 reads as the noisiest thing in the journal for a purely arithmetic reason:
# one whole unit of a median of 1 is 1,000 ppt. The scan names the scale rather than letting the
# spread speak for it.
CS=$(newcorpus coarse)
plant "$CS" 20260101 one "loom probe=p v=0"
plant "$CS" 20260101 two "loom probe=p v=3"
plant "$CS" 20260102 three "loom probe=p v=1"
plant "$CS" 20260102 four "loom probe=p v=2"
commitall "$CS"
outcs=$(scan "$CS" v)
leg coarse_scale_class "coarse_integer" "$(field "$outcs" scale_class)"
leg coarse_scale "1.5" "$(field "$outcs" scale)"

# ---------------------------------------------------------------- unmeasured is not zero
# Every sitting holds one value. The noise floor is UNMEASURED, and a confident 0 here would make
# every key on the pier look infinitely sharp.
D=$(newcorpus lone)
plant "$D" 20260101 one "loom probe=p v=10"
plant "$D" 20260102 two "loom probe=p v=20"
plant "$D" 20260103 three "loom probe=p v=30"
commitall "$D"
outd=$(scan "$D" v)
leg lone_within_na "na" "$(field "$outd" within_ppt)"
leg lone_resolution_na "na" "$(field "$outd" resolution_ppt)"
leg lone_verdict "insufficient_within" "$(field "$outd" verdict)"
leg lone_across_read "1000.0" "$(field "$outd" across_ppt)"
leg lone_singletons "3" "$(field "$outd" sittings_singleton)"

# ---------------------------------------------------------------- one sitting cannot cross
E=$(newcorpus onesit)
plant "$E" 20260101 one "loom probe=p v=10"
plant "$E" 20260101 two "loom probe=p v=12"
commitall "$E"
oute=$(scan "$E" v)
leg onesit_verdict "insufficient_sittings" "$(field "$oute" verdict)"
leg onesit_across_na "na" "$(field "$oute" across_ppt)"

# ---------------------------------------------------------------- a key nobody wrote
outf=$(scan "$A" nosuchkey)
leg neverwritten_verdict "key_never_written" "$(field "$outf" verdict)"
leg neverwritten_values "0" "$(field "$outf" values)"
leg neverwritten_within_na "na" "$(field "$outf" within_ppt)"

# ---------------------------------------------------------------- a name is not a measurement
G=$(newcorpus mixedvals)
plant "$G" 20260101 one "loom probe=p v=10"
plant "$G" 20260101 two "loom probe=p v=14"
plant "$G" 20260102 three "loom probe=p v=20"
plant "$G" 20260102 four "loom probe=p v=22"
plant "$G" 20260102 five "loom probe=p v=standing_equipment_run"
commitall "$G"
outg=$(scan "$G" v)
leg nonnumeric_counted "5" "$(field "$outg" values)"
leg nonnumeric_named "1" "$(field "$outg" non_numeric)"
leg nonnumeric_skipped "4" "$(field "$outg" numeric)"

# ---------------------------------------------------------------- no scale to be a fraction of
H=$(newcorpus zeroes)
plant "$H" 20260101 one "loom probe=p v=0"
plant "$H" 20260101 two "loom probe=p v=0"
plant "$H" 20260102 three "loom probe=p v=0"
plant "$H" 20260102 four "loom probe=p v=0"
commitall "$H"
outh=$(scan "$H" v)
leg zeroscale_verdict "refused_no_scale" "$(field "$outh" verdict)"
leg zeroscale_across_na "na" "$(field "$outh" across_ppt)"

# ---------------------------------------------------------------- the family filter
I=$(newcorpus fam)
plant "$I" 20260101 one "loom roster=cold v=10"
plant "$I" 20260101 two "loom roster=cold v=14"
plant "$I" 20260102 three "loom probe=other v=900"
plant "$I" 20260102 four "loom probe=other v=1000"
commitall "$I"
outi=$(LOOM_FAMILY=roster scan "$I" v)
leg family_values "2" "$(field "$outi" values)"
leg family_sittings "1" "$(field "$outi" sittings)"
outi2=$(scan "$I" v)
leg family_off_values "4" "$(field "$outi2" values)"

# ---------------------------------------------------------------- a corpus of zero is a red
J=$(newcorpus empty)
commitall "$J" 2>/dev/null || true
outj=$(scan "$J" v)
leg emptycorpus_refuses "1" "$(printf '%s\n' "$outj" | grep -c 'refused -- no tracked session logs')"

# ---------------------------------------------------------------- the sitting bound
outk=$(LOOM_MAX_SITTINGS=2 scan "$A" v)
leg bound_refuses "refused_over_bound" "$(field "$outk" verdict)"

# ---------------------------------------------------------------- the sibling reads what the elder read
# The value read moved into a sourced sibling this lap. Prove the move on the pen rather than on a
# claim: run the elder pipeline and the sibling over one corpus and compare the bytes.
elder="$pen/elder.txt"
( cd "$A" && git ls-files 'session-logs/date/*/*.kyri' | head -4000 > "$pen/logs.txt"
  : > "$elder"
  while IFS= read -r f; do
    b=${f##*/}
    stamp=$(printf '%s' "$b" | cut -c1-15)
    grep '^loom ' "$f" 2>/dev/null | tr ' ' '\n' | grep -E "^v=" | cut -d= -f2- \
      | while IFS= read -r vv; do printf '%s\t%s\t%s\n' "$stamp" "$vv" "$f"; done
  done < "$pen/logs.txt" | sort > "$elder" )
. "$root/tools/fixtures/l/loom_values.sh"
( cd "$A" && loom_values v "$pen/sib-raw.txt" )
sort "$pen/sib-raw.txt" > "$pen/sib.txt"
leg sibling_bytes_identical "same" "$(cmp -s "$elder" "$pen/sib.txt" && echo same || echo differs)"
leg sibling_rows "6" "$(grep -c . "$pen/sib.txt")"

# ---------------------------------------------------------------- mutations, run every pass
# Each takes the SOURCE it edits, the MARKER whose presence is asserted first, the field it must
# move, and that field's honest value. A mutation removing a line that has already been renamed away
# would edit nothing and read as a passing leg, so the marker check is a leg of its own.
. "$root/tools/fixtures/s/shell_portable.sh"

mutate() { # mutate NAME SRC MARKER SED_EXPR FIELD CORPUS KEY HONEST_VALUE
  mname=$1; msrc=$2; marker=$3; expr=$4; fld=$5; corp=$6; mkey=$7; base=$8
  legs=$((legs + 1))
  if ! grep -q -- "$marker" "$msrc"; then
    failed=$((failed + 1)); echo "leg mutation_marker_$mname FAILED -- the line it removes is gone: $marker"; return
  fi
  echo "leg mutation_marker_$mname ok want=present"
  cp "$msrc" "$pen/orig.$mname"
  sed_inplace "$expr" "$msrc"
  got=$(LOOM_ROOT="$corp" LOOM_FAMILY="${MUT_FAMILY:-}" sh "$root/tools/fixtures/l/loom_sitting_scan.sh" "$mkey" 2>&1 || true)
  cat "$pen/orig.$mname" > "$msrc"
  legs=$((legs + 1))
  gotv=$(printf '%s\n' "$got" | grep -E "^$fld=" | head -1 | cut -d= -f2- | cut -d' ' -f1)
  if [ "$gotv" = "$base" ]; then
    failed=$((failed + 1)); echo "leg mutation_$mname FAILED -- removing it moved nothing; $fld still reads $base"
  else
    echo "leg mutation_$mname ok want=bitten got=$gotv"
  fi
}

SCANSRC="$root/tools/fixtures/l/loom_sitting_scan.sh"
SIBSRC="$root/tools/fixtures/l/loom_values.sh"

# M1 -- average the singleton in. The floor must move, which is the whole reason it is excluded.
mutate singleton_excluded "$SCANSRC" 'if (n >= 2) {' \
  's/if (n >= 2) {/if (n >= 1) {/' within_ppt "$A" v 214.3
# M2 -- let the UNMEASURED floor print as a confident number. Line 193's printf is the only one
# pairing within with resolution and no across, which is what makes it addressable on its own.
mutate unmeasured_is_na "$SCANSRC" 'printf "within_ppt=na\\nresolution_ppt=na' \
  's|printf "within_ppt=na\\nresolution_ppt=na\\n"|printf "within_ppt=0.0\\nresolution_ppt=0.0\\n"|' \
  within_ppt "$D" v na
# M3 -- take the first value instead of the middle one.
mutate median_is_middle "$SCANSRC" 'if (n % 2) return arr' \
  's|if (n % 2) return arr\[(n + 1) / 2\]|if (n % 2) return arr[1]|' across_ppt "$A" v 4190.5
# M4 -- drop the family filter in the SIBLING, and read it through the scan that sources it.
MUT_FAMILY=roster
mutate sibling_family "$SIBSRC" 'index(line, fam) == 0' \
  's/if (fam != "" && index(line, fam) == 0) continue//' values "$I" v 2
MUT_FAMILY=
# M5 -- stop counting singletons apart, so the trap becomes invisible in the report.
mutate singletons_counted "$SCANSRC" 'else singles++' \
  's/else singles++//' sittings_singleton "$A" v 1
# M6 -- call every scale fine, so a count of 0 to 3 reads as a measurement.
mutate scale_named "$SCANSRC" 'amid < coarse ? "coarse_integer"' \
  's/amid < coarse ? "coarse_integer" : "fine"/"fine"/' scale_class "$CS" v coarse_integer

# THE LEG TALLY RIDES BESIDE THE VERDICT. A control reaching its last line says only that it
# reached it, so a leg written tomorrow and counted by nobody would ride under a green witness.
EXPECTED_LEGS=56
echo "control_legs=$legs"
echo "control_expected=$EXPECTED_LEGS"
echo "control_failed=$failed"
echo "control_verdict=$([ "$failed" -eq 0 ] && [ "$legs" -eq "$EXPECTED_LEGS" ] && echo ok || echo red)"
