#!/bin/sh
# tools/fixtures/am/amphora_roster_scan.sh -- every authored Amphora module answers to a rostered
# guard, or is counted.
#
# WHAT THIS READS. `amphora/` is the vessel room: pour, carry, restore, and the seal and stamp
# beneath them. `construction/standing-equipment.kyri` is the one roster the cold and hot endurance runs
# read. This scan asks the coverage question those two documents can only answer together -- for
# each authored `.rye` module in the room, does at least one ROSTERED guard name it?
#
# WHY IT EXISTS (`20260907.223214`). The Sound lane has carried this reading for its own room since
# `20260826` (`tools/fixtures/t/tally_roster_scan.sh`, *every tally module answers to a witness, or
# is counted*). Amphora had no twin, so its coverage lived in a roster comment a hand typed and
# re-typed: the block above the vessel rows carried `7 modules and 3,603 lines` on `20260906` and
# the line count had drifted 273 by the next morning with nothing listening (the row booked
# `20260907.215529`), and `amphora/README.md` read *twelve standing witnesses run every lap*
# against 15 rostered rows, 13 of them on the lap clock. A count in prose is a claim with no
# instrument -- REDS `%360`'s family -- and this is the instrument for this room.
#
# THAT SENTENCE THEN DRIFTED HERE (`20260908`). It was written in the present tense and the roster
# grew past it: 15 rows became 16, and the README's own guard LIST drifted from whole to 11 of 16
# in the same span. So the paragraph diagnosing a stale count went stale, inside the instrument
# built to stop stale counts. It reads as history now, and `readme_unnamed` below holds the list
# the way `guards` holds the count.
#
# THE READINGS:
#   modules           authored `.rye` under the room, symlinks excluded
#   linked            symlinks into another lane's room                    reported
#   guards            roster rows whose path sits under the guard room
#   lap_guards        of those, `tier lap` or no tier -- run every pass
#   cadence_guards    of those, `tier cadence` -- run on the fifth round
#   orphan_rows       a roster row naming a guard file the room lacks      GATED at zero
#   uncovered         a module no rostered guard names                     GATED at zero
#   singly_covered    a module exactly one rostered guard names            reported
#   readme_unnamed    a rostered guard the room's front door never names    GATED at zero
#   readme_unrostered a guard named at that door which no roster row seats  ratchet, only falls
#   own_lines         how many lines the room's own modules carry           reported
#   readme_spelled_lines  a line count spelled in digits at the front door  GATED at zero
#   readme_spelled_words  the same count spelled in letters at that door    reported
#
# A LINE COUNT SPELLED AT THE DOOR IS STALE BEFORE ITS OWN COMMIT LANDS (`20260908`). This room's
# front door read *`purchase_delivery.rye`, `vessel_fetch_wire.rye` and `vessel_fetch_delivery.rye`
# are 1,160 lines*. That figure was true at `0ee5c8171` and was written into `05c87d3d0`, the very
# commit that grew `vessel_fetch_delivery.rye` by 109 changed lines -- so it shipped 77 lines stale
# inside the commit that made it stale, and stood 161 short two days later. The hand did not slip:
# it measured, and then kept working. So `own_lines` and the `detail_lines` listing answer the
# weight question on every run, and the door is held at zero spelled counts, which is the same
# repair `guards` and `readme_unnamed` already took one reading over.
#
# THE FRONT DOOR IS PART OF THE ROSTER'S REACH. `amphora/README.md` lists the guards that stand
# over this room, and a reader reaches for that list before reaching for the roster. It was hand
# typed, so it drifted exactly as the counts beside it did: on `20260908` it named 11 of the 16
# rostered guards, missing `amphora_roster` -- the guard this scan serves -- and `amphora_mark_wreck`,
# both seated after the list was last written. A count read off an instrument and a LIST typed by
# hand is half a repair, so the list is held here too.
#
# AND THAT HOLD READ ONE DIRECTION ONLY (`20260911.083000`). `readme_unnamed` walks the ROSTER and
# asks the door about each row. Nothing walked the DOOR and asked the roster about each name, and
# `readme_named` was never counted at all -- it was printed as `guards - readme_unnamed`, a number
# describing the door derived entirely from the roster. So a name at this door that no roster row
# seats was invisible to the instrument built to keep the two in step. Proven in a pen rather than
# argued: a room whose door names `room_a` and `room_ghost`, with only `room_a` rostered, answers
# `readme_named=1`, `readme_unnamed=0`, `verdict=ok`.
#
# THE SIBLING ROOM IN THIS LANE ALREADY READS BOTH WAYS, which is how the asymmetry showed.
# `tools/fixtures/b/bron_resins_catalog_scan.sh` prints `uncatalogued` beside `orphan_entries` and
# `unsealed` beside `orphan_seals` -- each list checked against the other. This scan carried
# `orphan_rows` for the roster-to-file direction and had no door-to-roster twin.
#
# WHAT IT FOUND ON THE LAP IT LANDED, which is the only reason it earns a row:
# `amphora_device_wire`. The door named it, no roster row seated it, and the door's own sentence
# said why -- it *drives a virtio lab this pier has no qemu for, and refuses honestly at exit 1
# rather than pretending*. That is REDS `%646` exactly: a hard refusal on an absent optional
# dependency makes a witness unrostable, and an unrostered witness runs nowhere, so its red is one
# nobody will ever hear. The roster's own `capability qemu_riscv` answers it -- seated `20260910`,
# and measured in that probe's own comment as **26 witnesses reaching a wire lab, 0 of 26 on this
# roster**. This room held one of the 26. It is rostered under that capability now, so a bench
# carrying the emulator runs it and this pier reads its name in `skipped_capability` rather than
# losing it.
#
# A NAME IS A CLAIM ONLY WHEN A FILE ANSWERS IT, and a path mention is never a claim. The token
# stands with no `/` before it, so `tools/am/amphora_pour_witness.rish` credits nothing, and a file
# of that name exists under the guard room, so `amphora_lap3_tree` -- a pour fixture this door names
# in passing -- is read past rather than reported. Both rules were measured against the living door
# before they were written: without the first the reading names 24 path components, without the
# second it names a fixture that is no witness at all.
#
# A RATCHET RATHER THAN A GATE, and the reason is measured rather than cautious. With
# `amphora_device_wire` rostered the living door still names `amphora_lap1`, inside the dated
# sentence `amphora_lap1/2/3` -- and this door declares its hand witnesses honestly, in a section
# whose own words are *run by name, on no clock*. A wall at zero would refuse that sentence, and a
# wall that reds on honest prose is a wall somebody turns off. The ceiling only falls, so a name
# arriving at this door tomorrow with no roster row reds on the lap it lands, which is the class
# `amphora_device_wire` sat in unheard.
#
# GATED rather than ratcheted, and the counter-argument is named. `singly_covered` is reported
# because a module born today is named by one guard on the day it lands, which is ordinary work; a
# guard seated today is a roster row a hand writes, and naming it at the room's door is the same
# hand, the same lap, one line. So a wall refuses nothing anyone does on purpose. The wall was
# arrived at by REPAIR rather than by decree -- the two missing names were written the lap this
# reading landed -- so it has never refused work already done.
#
# A NAME IS MATCHED AT ITS BOUNDARIES, never as a substring. `amphora_pour` sits inside
# `amphora_pour_negative` and inside its own path `amphora_pour_witness.rish`, so a plain `grep -F`
# would credit a door that names only the negative twin. The token is bounded by non-word
# characters on both sides, and underscore counts as a word character -- which is what keeps
# `amphora_pour_witness` from answering for `amphora_pour`.
#
# AN ABSENT FRONT DOOR ANSWERS `absent`, never zero -- the same rule the absent room and roster
# take. A room with no README and a room whose README is whole must never read alike, so the count
# is a word rather than a number there and the gate stands down. The witness asserts this room's
# door BY PATH, so `amphora/` cannot go quiet by deleting it.
#
# A SYMLINK IS NOT THIS LANE'S MODULE. `amphora/kumara.rye`, `tally_copy.rye` and `wire_format.rye`
# are links into `tally/` and `comlink/`, and a coverage reading that counted them would hold this
# lane to account for another lane's witnesses. The room is read off the filesystem with `! -type l`
# rather than off `git ls-files`, which lists a link exactly like a file -- the same reading that
# overstated this room 10 against 7 -- and a filesystem read is also what lets the control point
# this scan at a throwaway pen, which is no git repository at all.
#
# A SHIM IS FOLLOWED ONE HOP. Nine files under `tools/am/` are accrete shims that run a target under
# `tools/gen/amphora/` and exit its code, so the module names live in the target rather than in the
# rostered path. Every `.rish` literal a guard names, that exists and is not the guard itself, is
# read alongside it -- bounded at four per guard, since a guard reaching further than that is
# orchestration rather than a shim and should be read for itself.
#
# WHAT IT DOES NOT REACH, named rather than implied. Whether a guard that names a module PROVES
# anything about it: naming is what a text can show, and a claim's worth is a hand's reading. And
# whether a guard runs green -- the standing roster answers that every pass, and this one asks only
# whether the roster is pointed at the whole room. The two spelled readings carry four nouns between
# them, so a door spelling a byte count or a percentage can drift exactly the same way and neither
# reading speaks: a wall drawn around every number a door might spell would refuse the tables this
# page is mostly made of. And this is ONE room's door. Measured `20260908` across the 113 living
# module front doors outside the closed stacks, 36 pages carry 63 lines of the letter form, so the
# shape is tree-wide and this scan walls one door of it.
#
#   sh tools/fixtures/am/amphora_roster_scan.sh [<room>] [<roster>] [<guard_room>] [<readme>]
#
# Exit 0 when the room is covered, 1 when it parts, and 2 when the scan cannot read what it was
# pointed at. An absent room or roster answers `misread`, since zero is the reading a covered room
# gives and the two must never look alike.
set -eu

ROOM=${1:-amphora}
ROSTER=${2:-construction/standing-equipment.kyri}
GUARD_ROOM=${3:-tools/am}
README=${4:-$ROOM/README.md}

# Bound: the detail listing stops here and says so. An unbounded print is an unbounded allocation
# (TAME), and a room past this wants a fold rather than a longer printout.
MAX_DETAIL=64
# The door-to-roster ratchet. It only falls: repair a name and lower this in the same commit.
# 1 `20260911.083000` -- `amphora_lap1`, inside the dated sentence `amphora_lap1/2/3`, which the
# door's Hand witnesses section already declares as running on no clock. `amphora_device_wire` was
# the other and took a roster row instead.
README_UNROSTERED_CEILING="${README_UNROSTERED_CEILING:-1}"
# Bound: how far one guard is followed. Four covers a shim and its target with room to spare.
MAX_HOPS=4

if ! test -d "$ROOM"; then
  echo "verdict=misread"
  echo "detail=room_absent"
  echo "detail_room=$ROOM"
  exit 2
fi
if ! test -f "$ROSTER"; then
  echo "verdict=misread"
  echo "detail=roster_absent"
  echo "detail_roster=$ROSTER"
  exit 2
fi

echo "room=$ROOM"
echo "roster=$ROSTER"
echo "guard_room=$GUARD_ROOM"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/amphora_roster.XXXXXX") || exit 2
trap 'rm -rf "$TMP"' EXIT

# The room's own modules: every authored .rye at any depth, links left to the lane that owns them.
find "$ROOM" -name '*.rye' -type f ! -type l | LC_ALL=C sort > "$TMP/modules"
find "$ROOM" -name '*.rye' -type l | LC_ALL=C sort > "$TMP/linked"
modules=$(grep -c '' "$TMP/modules" || true)
linked=$(grep -c '' "$TMP/linked" || true)
echo "modules=$modules"
echo "linked=$linked"

# How much the room actually carries. REPORTED rather than gated: a module grows every lap, so a
# ceiling here would refuse the ordinary work of the room. It exists so the front door can NAME this
# instrument where it used to spell a number.
own_lines=0
: > "$TMP/lines"
while IFS= read -r m; do
  n=$(grep -c '' "$m" || true)
  own_lines=$((own_lines + n))
  echo "$m $n" >> "$TMP/lines"
done < "$TMP/modules"
echo "own_lines=$own_lines"

# The roster's rows for this guard room, each carrying the tier it was seated at. A row with no
# tier line runs every lap, which is the roster's own default, so absence is spelled `lap` here.
# The name rides along as a third field, which every reader below is free to ignore: the two `awk`
# tier filters key on field 2 and the two `read` loops name only the fields they use.
awk -v room="$GUARD_ROOM/" '
  /^guard /  { if (path != "") print path, tier, name; path = ""; tier = "lap"; name = $2; next }
  /^path /   { if (index($2, room) == 1) path = $2; next }
  /^tier /   { if (path != "") tier = $2; next }
  END        { if (path != "") print path, tier, name }
' "$ROSTER" > "$TMP/rows"

guards=$(grep -c '' "$TMP/rows" || true)
lap_guards=$(awk '$2 == "lap"' "$TMP/rows" | grep -c '' || true)
cadence_guards=$(awk '$2 == "cadence"' "$TMP/rows" | grep -c '' || true)
other_tier_guards=$(awk '$2 != "lap" && $2 != "cadence"' "$TMP/rows" | grep -c '' || true)
echo "guards=$guards"
echo "lap_guards=$lap_guards"
echo "cadence_guards=$cadence_guards"
echo "other_tier_guards=$other_tier_guards"

# A row naming a file the guard room lacks: the roster promising a guard nobody can run.
: > "$TMP/orphans"
while read -r p _t; do
  test -f "$p" || echo "$p" >> "$TMP/orphans"
done < "$TMP/rows"
orphan_rows=$(grep -c '' "$TMP/orphans" || true)
echo "orphan_rows=$orphan_rows"

# Every guard's own text, plus the text of the .rish files it delegates to -- one hop, bounded.
: > "$TMP/texts"
while read -r p _t; do
  test -f "$p" || continue
  echo "$p" >> "$TMP/texts"
  hops=0
  for d in $(grep -o '[A-Za-z0-9_./-]*\.rish' "$p" 2>/dev/null | LC_ALL=C sort -u); do
    [ "$hops" -ge "$MAX_HOPS" ] && break
    [ "$d" = "$p" ] && continue
    test -f "$d" || continue
    echo "$d" >> "$TMP/texts"
    hops=$((hops + 1))
  done
done < "$TMP/rows"
LC_ALL=C sort -u "$TMP/texts" > "$TMP/texts_uniq"

# A module is covered when a rostered guard's text names its path. The whole relative path is the
# token, so `vessel_seal.rye` can never credit a guard that only ever named `vessel_seal_demo.rye`.
: > "$TMP/uncovered"
: > "$TMP/singly"
while read -r m; do
  n=0
  if [ -s "$TMP/texts_uniq" ]; then
    n=$(grep -lF "$m" $(cat "$TMP/texts_uniq") 2>/dev/null | grep -c '' || true)
  fi
  if [ "$n" -eq 0 ]; then
    echo "$m" >> "$TMP/uncovered"
  elif [ "$n" -eq 1 ]; then
    echo "$m" >> "$TMP/singly"
  fi
done < "$TMP/modules"

uncovered=$(grep -c '' "$TMP/uncovered" || true)
singly_covered=$(grep -c '' "$TMP/singly" || true)
covered=$((modules - uncovered))
echo "covered=$covered"
echo "uncovered=$uncovered"
echo "singly_covered=$singly_covered"

# The front door names every guard that stands over the room, or the one it passes over is counted.
: > "$TMP/readme_unnamed"
if test -f "$README"; then
  echo "readme=$README"
  while read -r _p _t n; do
    test -n "$n" || continue
    # Bounded on both sides by a non-word character, so `amphora_pour` is never credited by
    # `amphora_pour_negative` or by its own `amphora_pour_witness.rish` path.
    grep -qE "(^|[^A-Za-z0-9_])$n([^A-Za-z0-9_]|\$)" "$README" || echo "$n" >> "$TMP/readme_unnamed"
  done < "$TMP/rows"
  readme_unnamed=$(grep -c '' "$TMP/readme_unnamed" || true)
  echo "readme_named=$((guards - readme_unnamed))"
  echo "readme_unnamed=$readme_unnamed"

  # A digit group carrying the word `line` or `lines`. The case is folded first, so `1,160 Lines`
  # is caught too, and a word character after `lines` ends the match, so `own_lines`,
  # `detail_lines`, and this reading's own name pass free -- as does `thirty lines down`, which
  # spells its number and therefore cannot go stale silently.
  awk 'tolower($0) ~ /[0-9][0-9,]*[ -]lines?([^a-z]|$)/ { print FNR }' "$README" > "$TMP/spelled"
  readme_spelled_lines=$(grep -c '' "$TMP/spelled" || true)
  echo "readme_spelled_lines=$readme_spelled_lines"

  # A COUNT SPELLED IN LETTERS GOES STALE THE SAME WAY, and this room proved it within the day.
  # The digit reading above lets `thirty lines down` walk free, on the reasoning that a number
  # spelled as a word cannot go stale in silence. It can. This door read *Those eight build three
  # modules* -- written into `05c87d3d0` when twelve guards stood over the room, and read again
  # after `amphora_mark_wreck` made sixteen, one more of which builds all three. The digit gate
  # watched that sentence drift and had no letter in its pattern.
  #
  # REPORTED, NEVER GATED, and the reason is measured rather than cautious. On the day this landed
  # the door carried two such lines: the drifted count, and `three modules -- src/main.rye,
  # vessel_core.rye, vessel_seal.rye`, which enumerates what it counts and is self-checking. A wall
  # at zero would refuse the second along with the first, and a wall that reds on honest prose is a
  # wall somebody turns off. So the reading names its lines and leaves the judgment to a hand.
  #
  # The nouns are the four this instrument itself measures -- `own_lines`, `modules`, `guards`, and
  # the `witness` a guard is called at this door -- so the reading never reaches a noun no number
  # here could be checked against. A word character after the noun ends the match, so `eight
  # guardrails` walks free, and a letter before the number ends it too, so `someone-line` does.
  awk 'tolower($0) ~ /(^|[^a-z])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|forty|fifty)[ -](line|module|guard|witness)(s|es)?([^a-z]|$)/ { print FNR }' "$README" > "$TMP/spelledword"
  readme_spelled_words=$(grep -c '' "$TMP/spelledword" || true)
  echo "readme_spelled_words=$readme_spelled_words"

  # THE OTHER DIRECTION. Every basename in the guard room is a name this door could claim; the
  # candidates come off the filesystem rather than a typed list, so a witness written tomorrow is a
  # candidate the day it lands. A name counts as CLAIMED when the door writes it with no `/` before
  # it -- which is what separates `amphora_device_wire` said plainly from
  # `tools/am/amphora_device_wire.rish` cited as a path -- and it is UNROSTERED when no roster row
  # seats it. `readme_claims` counts the door's own names rather than deriving them from the roster,
  # which `readme_named` above cannot do by construction.
  : > "$TMP/readme_unrostered"
  claims=0
  : > "$TMP/candidates"
  for f in "$GUARD_ROOM"/*; do
    test -f "$f" || continue
    b=$(basename "$f"); b=${b%.*}
    echo "$b" >> "$TMP/candidates"
    # A guard is named `amphora_pour` and its file is `amphora_pour_witness.rish`, so the file
    # basename alone would never be the name the door writes. Both forms are candidates, because
    # this roster seats both spellings -- `amphora_pour` from `_witness.rish`, and
    # `amphora_bounds_agree` from a file of its own name. Taking only the first left a hole in the
    # gate rather than merely undercounting: a door claim spelled as the guard name, backed by a
    # `_witness.rish` file and seated by no roster row, was no candidate and so no finding.
    case $b in *_witness) echo "${b%_witness}" >> "$TMP/candidates" ;; esac
  done
  LC_ALL=C sort -u "$TMP/candidates" -o "$TMP/candidates"
  while read -r b; do
    test -n "$b" || continue
    grep -qE "(^|[^/A-Za-z0-9_])$b([^A-Za-z0-9_]|\$)" "$README" || continue
    claims=$((claims + 1))
    grep -qE "^guard $b\$" "$ROSTER" && continue
    echo "$b" >> "$TMP/readme_unrostered"
  done < "$TMP/candidates"
  readme_claims=$claims
  readme_unrostered=$(grep -c '' "$TMP/readme_unrostered" || true)
  echo "readme_claims=$readme_claims"
  echo "readme_unrostered=$readme_unrostered"
  echo "readme_unrostered_ceiling=$README_UNROSTERED_CEILING"

  # AND THE BLIND SPOT THIS READING CARRIES, PRINTED RATHER THAN LEFT SILENT. The candidates above
  # are files, so a door claim naming a guard with NO file under the guard room cannot be a
  # candidate at all. That second population is read here off the room's own namespace -- the first
  # segment every rostered guard name shares -- and REPORTED with names, never gated, because it
  # holds two honest kinds at once: a real promise of a witness nobody wrote, and a plain noun that
  # merely starts with the room's name. The living door carries one, `amphora_lap3_tree`, which is a
  # pour fixture rather than a witness. A reader can tell those apart and a pattern cannot, which is
  # why this half reports and the half above ratchets. Named here because a blind spot nobody prints
  # reads exactly like an empty one -- the lesson `tools/fixtures/g/glow_comment_ascii_scan.sh` set
  # down when it published its own `trailing_unread` and the sibling beside it read 1,319.
  : > "$TMP/readme_fileless"
  prefix=$(awk '{print $NF}' "$TMP/rows" | awk -F_ 'NF>1{print $1}' | LC_ALL=C sort -u)
  if [ "$(printf '%s\n' "$prefix" | grep -c '')" -eq 1 ] && [ -n "$prefix" ]; then
    echo "readme_namespace=$prefix"
    grep -oE "(^|[^/A-Za-z0-9_])${prefix}_[a-z0-9_]+" "$README" \
      | sed "s/^[^A-Za-z0-9_]*//" | LC_ALL=C sort -u > "$TMP/doortokens"
    while read -r t; do
      test -n "$t" || continue
      # The two populations are disjoint by construction rather than by care: a token already a
      # candidate above has a file under one of the two spellings, so it belongs to the ratchet and
      # never to this report. Counted in both, one name would be one finding wearing two numbers.
      grep -qx "$t" "$TMP/candidates" && continue
      grep -qE "^guard $t\$" "$ROSTER" && continue
      echo "$t" >> "$TMP/readme_fileless"
    done < "$TMP/doortokens"
    echo "readme_claims_fileless=$(grep -c '' "$TMP/readme_fileless" || true)"
  else
    # More than one namespace among the rostered names, so no single prefix is this room's own.
    echo "readme_namespace=mixed"
    echo "readme_claims_fileless=unread"
  fi
else
  # A word rather than a number: an absent door and a whole one must never read alike.
  echo "readme=absent"
  echo "readme_named=absent"
  echo "readme_unnamed=absent"
  echo "readme_spelled_lines=absent"
  echo "readme_spelled_words=absent"
  echo "readme_claims=absent"
  echo "readme_unrostered=absent"
  echo "readme_unrostered_ceiling=$README_UNROSTERED_CEILING"
  echo "readme_namespace=absent"
  echo "readme_claims_fileless=absent"
  : > "$TMP/readme_unrostered"
  : > "$TMP/readme_fileless"
  : > "$TMP/spelled"
  : > "$TMP/spelledword"
  readme_unnamed=0
  readme_spelled_lines=0
  readme_unrostered=0
fi

# Name every one of them. A count nobody can act on is the complaint the dated-path census made of
# itself: it printed no list, so nobody could name the thing it was refusing over.
name_them() { # name_them <key> <file>
  shown=0
  while IFS= read -r n; do
    if [ "$shown" -ge "$MAX_DETAIL" ]; then
      echo "${1}_truncated_at=$MAX_DETAIL"
      break
    fi
    echo "detail_${1}=$n"
    shown=$((shown + 1))
  done < "$2"
}
name_them uncovered "$TMP/uncovered"
name_them singly "$TMP/singly"
name_them orphan_row "$TMP/orphans"
name_them readme_unnamed "$TMP/readme_unnamed"
name_them readme_unrostered "$TMP/readme_unrostered"
name_them readme_fileless "$TMP/readme_fileless"
name_them linked "$TMP/linked"
name_them lines "$TMP/lines"
name_them spelled_line "$TMP/spelled"
name_them spelled_word "$TMP/spelledword"

if [ "$uncovered" -eq 0 ] && [ "$orphan_rows" -eq 0 ] && [ "$readme_unnamed" -eq 0 ] \
   && [ "$readme_spelled_lines" -eq 0 ] \
   && [ "$readme_unrostered" -le "$README_UNROSTERED_CEILING" ]; then
  echo "verdict=ok"
  exit 0
fi

echo "verdict=drifted"
exit 1
