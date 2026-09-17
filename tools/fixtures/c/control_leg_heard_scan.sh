#!/bin/sh
# tools/fixtures/c/control_leg_heard_scan.sh -- a control emits a named verdict, and the witness
# beside it hears that verdict only by quoting the name in an assert.
#
#   sh tools/fixtures/c/control_leg_heard_scan.sh [--list] [--explain <control path>]
#
# WHY. A control proves a behavior by printing one named leg per behavior -- `plant_refused=yes`,
# `boundary_frees=no`. The witness reads that output and quotes each name it cares about. So a leg
# the witness never quotes is a leg nothing hears: it may flip from `yes` to `no` on any lap and
# every named assert still passes, every gate stays green, and the only visible effect is that a
# count somewhere stops rising. A refusal proven only in the passing direction cannot be told from
# a bypass, and a leg proven in NEITHER direction cannot be told from a leg that was never written.
#
# THE CLASS IS BOOKED TWICE ALREADY. `ascii_document_control.sh` spoke 82 readings to a gate that
# heard 46, and the repair gave that witness a generic wall -- it derives every control line
# carrying `=no` and asserts the set is empty, so a leg added tomorrow is heard the day it lands.
# `qa_report_card_witness.rish` carried the same hole until `20260916` and took the same cure.
# A lantern that fires twice becomes a loom.
#
# WHAT IS COUNTED. For every tracked `tools/fixtures/*_control.sh` carrying a sibling witness at
# `tools/*/<stem>_witness.rish`:
#
#   generic_wall -- the witness hears every leg, named or not, in one of two spellings: it derives
#     the control's `=no` lines and asserts that set is empty, or the control tallies its own
#     parted legs and the witness asserts that tally is zero. Such a pair contributes zero unheard
#     and is counted apart rather than silently passing.
#
#   unheard -- a leg the control emits and the witness names nowhere. This is the first gated
#     reading.
#
#   masked -- a leg the witness NAMES and still cannot tell apart, gated under its own ceiling.
#     `contains` in Rishi is a raw substring test, proven in a two-line pen on `20260916`, so the
#     assert `control.out contains "debt_paid=yes"` is satisfied by the line
#     `ledger_debt_paid=yes` standing alone. A leg whose name ends a sibling leg's name may
#     therefore read `no` on any lap while its own assert passes on the sibling -- named, asserted,
#     and as unheard as if nobody had written it. Counted as DISTINCT short legs rather than
#     sibling pairs, since a leg two siblings answer for is one hole and one rename closes it.
#     The cure available today is a NAME: rename either leg so neither ends the other. A Rishi
#     string literal carries no newline and no `\n` escape, both tried on metal, so no assert in
#     this tree can anchor a leg to its line start.
#
#   unpaired -- a control with no sibling witness. A different fault with a different cure, so it
#     is reported by name rather than folded into the number above.
#
# WHAT A LEG IS, stated because the whole reading rests on it. A leg is a name emitted inside an
# `echo` or `printf` string argument in the form `<name>=<value>`, where the value is the literal
# `yes` or `no`, or a shell variable the same control assigns `yes` or `no` somewhere. That second
# arm is what reaches `echo "over_named_by_room=$over_named"`, which is how most controls in this
# tree emit. A diagnostic field -- `actual=$x`, `max_legs=$n` -- carries no yes/no anywhere and
# stays out of the denominator on purpose: a number a control prints for a reader is not a verdict
# a witness owes an assert. A COMPOSITE line -- `leg=<name> agree=yes exit=1` -- carries its
# identity in the `leg=` field and its verdict beside it, so the trailing fields are read past and
# the pair is heard through the identity the witness actually quotes.
#
# THE GENERIC WALL IS NOT A UNIVERSAL CURE, which first residency taught rather than argument.
# `standing_equipment_witness.rish` asserts several legs read `no` ON A GREEN RUN -- a refusal that
# must NOT fire, such as `detach_stale_lock_refuses=no`. A wall asserting no `=no` line stands would
# red that pair on every lap. So the per-pair cure is naming the leg in an assert, and the wall is
# available only to a control whose every leg reads `yes` when the tree is clean. This scan credits
# a wall where one stands and asks for nothing where one cannot.
#
# TWO BOUNDS, both stated because neither is fixable from here.
#
#   Upper, on hearing: a witness quoting a leg's name is credited with hearing it, whatever the
#     assert around it actually says. A name quoted inside a `say` line rather than an `assert`
#     counts as heard here and reddens nothing on metal. So the true unheard count is at or above
#     this one, and this reading is a floor. `masked` is one sharp edge of that bound made
#     countable -- a leg credited as heard whose assert another line answers -- and it is the only
#     edge of it this scan reaches.
#
#   Lower, on pairing: control and witness are paired by basename stem, which is a NAMING
#     CONVENTION rather than a fact. A control named for a family and a witness named for a tool
#     never meet here, and such a pair is reported `unpaired` rather than measured. The true
#     denominator is at or above this one.
#
# MEASURED `20260916` after the masked reading landed: 285 pairs, `generic_wall=43`, `unheard=33`
# in ONE pair, `masked=14` across three. `generated_page_freshness` closed both its readings on
# that touch -- two legs named in the witness, and `ledger_debt_paid` and `ledger_dirty_refused`
# renamed to `ledger_debt_settled` and `ledger_unstaged_refused` so neither ends `debt_paid` or
# `dirty_refused`. Elder reading, kept for the arc: 283 pairs, `generic_wall=41`, `unheard=39`
# across 6 pairs, **33 of them in
# `standing_equipment_control.sh`** -- the control for the guard that runs every rostered guard --
# beside 48 controls carrying no sibling witness at all. The wall figure is the one first residency
# moved most: reading for the derived spelling alone, this scan first answered `generic_wall=1` and
# called forty walls holes. Every figure is FREE and rises with each control this tree writes; RUN
# the scan rather than reading this line.

set -u
root=${CONTROL_LEG_ROOT:-.}
cd "$root" || { echo "verdict=unreadable_root"; exit 2; }

# invariant: the ceiling only falls, and it is spelled once so a lowering reaches one line.
CEILING=33
# invariant: the masked ceiling only falls, spelled once for the same reason as the one above.
MASK_CEILING=14
# invariant: a bound on the pairs read, well above the 283 standing, so a runaway enumeration
# stops rather than running the tree out of time.
MAX_PAIRS=4096

list=no
explain=
while [ $# -gt 0 ]; do
  case $1 in
    --list) list=yes ;;
    --explain) shift; explain=${1:-} ;;
    *) echo "verdict=unknown_flag ($1)"; exit 2 ;;
  esac
  shift
done

# A leg name emitted by a control: read the echo/printf command regions, take the quoted strings
# inside them, and keep a `<name>=` whose value is a yes/no literal or a variable the control
# assigns yes/no. Bare assignment at line start is NOT emission, which is the distinction that
# keeps a local `over_named=yes` out of the count while its `echo "over_named_by_room=$over_named"`
# stays in.
emit_of() {
  # Read the echo/printf command regions, take the quoted strings inside them, and keep a
  # `<name>=` whose value is a yes/no literal or a variable the control assigns yes/no. A bare
  # assignment at line start is NOT emission, which keeps a local `over_named=yes` out of the
  # count while its `echo "over_named_by_room=$over_named"` stays in.
  #
  # AN AWK REWRITE OF THIS FUNCTION WAS TRIED AND PUT BACK on `20260916`. It ran 20s against 30s
  # and answered `unheard=38` where this shape answers 35 -- a performance change that moves a
  # measured reading is a different instrument rather than a faster one, and ten seconds is not
  # worth a number nobody has proven. The tier below is what pays for the cost instead.
  _c=$1
  _bool=$(grep -hoE '\b[a-z][a-z0-9_]*=(yes|no)\b' "$_c" 2>/dev/null | sed 's/=.*//' | sort -u)
  grep -hoE '(echo|printf)[^|;&]*' "$_c" 2>/dev/null \
  | grep -hoE '"[^"]*"' \
  | grep -vE '\b(leg|name|case|label)=' \
  | grep -hoE '(^|[^$a-zA-Z0-9_])[a-z][a-z0-9_]{3,}=(yes\b|no\b|\$[a-zA-Z_][a-zA-Z0-9_]*)' \
  | sed 's/^[^a-z]//' \
  | while IFS= read -r _m; do
      _n=${_m%%=*}; _v=${_m#*=}
      case $_v in
        yes|no) echo "$_n" ;;
        \$*) echo "$_bool" | grep -qx "${_v#\$}" && echo "$_n" ;;
      esac
    done | sort -u
}

# A leg name the witness hears: any `contains "<name>=` it quotes. Credited whatever the assert
# around it says -- see the upper bound in the header.
asrt_of() {
  grep -hoE 'contains "[a-z][a-z0-9_]*=' "$1" 2>/dev/null | sed 's/contains "//; s/=$//' | sort -u
}

# A MASKED leg: one the witness names in an assert and still cannot tell apart. `contains` in
# Rishi is a RAW SUBSTRING test -- proven in a two-line pen on `20260916` -- so
# `contains "debt_paid=yes"` is satisfied by the line `ledger_debt_paid=yes` standing alone. A leg
# whose name ends another leg's name is therefore named and indistinguishable: it may read `no` on
# any lap while its own assert passes on the sibling. Reads the emitted set and the heard set as
# two sorted files and prints `<short> <long>` per masking sibling.
#
# A leg the witness quotes that the control never emits is left alone here: with no such leg there
# is no hole, and a name quoted for a diagnostic field is a different question. A generic-wall pair
# is skipped by the caller, because a wall derives whole `=no` LINES and no substring reaches it.
masked_of() { # masked_of <emitted file> <heard file>
  comm -12 "$1" "$2" | while IFS= read -r _h; do
    grep -E "[a-z0-9_]${_h}\$" "$1" 2>/dev/null | while IFS= read -r _l; do
      echo "$_h $_l"
    done
  done
}

# The generic wall: the witness derives the control lines carrying `=no` and asserts that set is
# empty. Both halves are required -- deriving the set without asserting it is a report, and the
# assert without the derivation is some other zero.
# TWO SPELLINGS, both of which hear every leg, and crediting only the first would report a hole
# where a wall stands. The witness may DERIVE the control's `=no` lines and assert the set is
# empty; or the control may tally its own parted legs and the witness assert that tally is zero.
# `ascii_resident_agree` taught the second shape by carrying `legs_fail=0` while this scan, reading
# for the first shape alone, called it unwalled.
has_wall() {
  grep -qE 'l contains "=no"' "$1" 2>/dev/null && grep -qE '\(length [a-z_]+\) == 0' "$1" 2>/dev/null && return 0
  grep -qE 'contains "(legs_fail|control_failed|failing|legs_failed|fail_count)=0"' "$1" 2>/dev/null
}

# The witness roster is enumerated ONCE. Asking git per pair cost 283 subprocesses and 24s of a
# lap-tier budget; one listing answers every pair in a grep.
WITNESSES=$(git ls-files 'tools/*/*_witness.rish' 2>/dev/null)
witness_for() {
  echo "$WITNESSES" | grep -E "/$1_witness\.rish\$" | head -1
}

if [ -n "$explain" ]; then
  [ -f "$explain" ] || { echo "verdict=absent ($explain)"; exit 2; }
  stem=$(basename "$explain" _control.sh)
  w=$(witness_for "$stem")
  echo "control=$explain"
  if [ -z "$w" ]; then echo "witness=none"; echo "verdict=unpaired"; exit 0; fi
  echo "witness=$w"
  if has_wall "$w"; then echo "generic_wall=yes"; echo "verdict=hears_everything"; exit 0; fi
  echo "generic_wall=no"
  echo "emitted=$(emit_of "$explain" | grep -c .)"
  echo "heard=$(asrt_of "$w" | grep -c .)"
  # `mktemp`, never a derived `/tmp` name: a fixed name is shared across eight checkouts and a
  # pid-varied one is found again by globbing, which returned yesterday's file once already.
  xt=$(mktemp -d)
  emit_of "$explain" > "$xt/e"; asrt_of "$w" > "$xt/a"
  comm -23 "$xt/e" "$xt/a" | sed 's/^/unheard_leg /'
  n=$(comm -23 "$xt/e" "$xt/a" | grep -c .)
  masked_of "$xt/e" "$xt/a" | sed 's/^/masked_leg /'
  mn=$(masked_of "$xt/e" "$xt/a" | awk '{print $1}' | sort -u | grep -c .)
  rm -rf "$xt"
  echo "unheard=$n"
  echo "masked=$mn"
  if [ "$n" -gt 0 ]; then echo "verdict=unheard"
  elif [ "$mn" -gt 0 ]; then echo "verdict=masked"
  else echo "verdict=heard"; fi
  exit 0
fi

pairs=0; wall=0; unpaired=0; unheard=0; with=0; read_pairs=0; masked=0; masked_pairs=0
tmp=$(mktemp); trap 'rm -f "$tmp" "$tmp.e" "$tmp.a"' EXIT

for c in $(git ls-files 'tools/fixtures/*_control.sh' 2>/dev/null); do
  read_pairs=$((read_pairs + 1))
  [ "$read_pairs" -gt "$MAX_PAIRS" ] && { echo "verdict=over_pair_bound"; exit 2; }
  stem=$(basename "$c" _control.sh)
  w=$(witness_for "$stem")
  if [ -z "$w" ]; then unpaired=$((unpaired + 1)); echo "unpaired_control $c" >> "$tmp"; continue; fi
  pairs=$((pairs + 1))
  if has_wall "$w"; then wall=$((wall + 1)); continue; fi
  emit_of "$c" > "$tmp.e"
  asrt_of "$w" > "$tmp.a"
  n=$(comm -23 "$tmp.e" "$tmp.a" | grep -c .)
  if [ "$n" -gt 0 ]; then
    with=$((with + 1)); unheard=$((unheard + n))
    comm -23 "$tmp.e" "$tmp.a" | sed "s|^|unheard $stem |" >> "$tmp"
  fi
  # The masked reading counts DISTINCT short legs rather than sibling pairs: a leg two siblings can
  # answer for is one hole, and one name fixes it.
  m=$(masked_of "$tmp.e" "$tmp.a" | awk '{print $1}' | sort -u | grep -c .)
  if [ "$m" -gt 0 ]; then
    masked_pairs=$((masked_pairs + 1)); masked=$((masked + m))
    masked_of "$tmp.e" "$tmp.a" | sed "s|^|masked $stem |" >> "$tmp"
  fi
done

if [ "$list" = yes ]; then
  sort "$tmp" 2>/dev/null
  echo "list_total=$(grep -c . "$tmp" 2>/dev/null || echo 0)"
fi

echo "pairs=$pairs"
echo "generic_wall=$wall"
echo "unpaired=$unpaired"
echo "pairs_with_unheard=$with"
echo "unheard=$unheard"
echo "ceiling=$CEILING"
echo "pairs_with_masked=$masked_pairs"
echo "masked=$masked"
echo "mask_ceiling=$MASK_CEILING"
[ "$unheard" -le "$CEILING" ] && echo "unheard_ok=yes" || echo "unheard_ok=no"
[ "$masked" -le "$MASK_CEILING" ] && echo "masked_ok=yes" || echo "masked_ok=no"
if [ "$unheard" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
elif [ "$masked" -gt "$MASK_CEILING" ]; then
  echo "verdict=over_mask_ceiling"
else
  echo "verdict=ok"
fi
