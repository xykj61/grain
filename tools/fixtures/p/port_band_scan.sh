#!/bin/sh
# tools/fixtures/p/port_band_scan.sh -- the room's port numbers, counted off the sources.
#
# WHY. A port is a name on the MACHINE, and this pier stands eight checkouts deep. REDS %700 is
# what that costs when nobody counts. A rostered witness read red on one cold roster pass and green
# on a re-run over an unchanged tree, and the cause took a fortnight to name: two ships' lawful runs
# reached one compiled-in UDP port and each read the other's replies. Measured `20260911` at load
# 14, eight at once -- the elder binary 39 of 80 red, the repaired binary 0 of 80, and both 0 of 120
# run serially. A fault that appears only in company is a fault one run alone will always miss.
#
# THE ROOM ALREADY HAD AN ANSWER AND WROTE IT IN A SENTENCE. Two lock scripts serialize the runs
# that share a pair -- tools/fixtures/m/mantra_delivery_port_lock.sh and
# tools/fixtures/a/amphora_vessel_port_lock.sh -- and each spells its room's roster in its own
# header: *seven modules under mantra/ bind 38478/38479 through 38490/38491*, and
# *amphora/vessel_fetch_delivery.rye binds UDP 38494 and 38495*. Both were true when typed. A
# sentence holding a roster is a roster a hand must re-type, and this tree's own law already names
# the cure: COUNT, NEVER NUMBER (`.claude/rules/stamp-and-name.md`). So the roster is read off the
# declarations here, and each sentence points at this reading.
#
# WHAT IS COUNTED. A `const <name>: u16 = <number>;` in any living tracked `.rye`, where `port` is
# a whole component of the identifier -- `(^|_)port(_|$)`. So `wire_port`, `base_port` and
# `ephemeral_port` all count, and `max_report` is read past. A `pub` prefix leaves the question of
# who holds the number exactly where it was. A port of **0** is the CURE: it asks the kernel for a
# number nobody else holds, which is what the bind-to-zero handshake at `20260911.105415` landed,
# so it is named apart and charged to nothing.
#
# THE READINGS
#   ports_outside_band    a constant outside the room's seated band              ZERO, ENFORCED
#   lock_band_uncovered   a lock's numeric edge check refusing a port its own
#                         room declares -- the next module past the band meets
#                         a closed door at the lock meant to protect it         ZERO, ENFORCED
#   ports_double_claimed  one number, two modules                               ratchet, only falls
#   lock_claims_unbound   a number a lock names that its own room let go        reported
#   counting_bases        a base a module counts UP from, whose span a literal
#                         census reads past                                     reported
#   band_free             numbers inside the band standing open                 reported
#
# THE BAND, AND WHAT IT BUYS. Floor 38472 is the first number this room seated
# (comlink/hosted_wire.rye). The ceiling 38600 leaves the counting-up convention room to grow, so a
# module reaching for 8080 at random reds on the lap it arrives. That makes the band OURS BY
# CONVENTION, and there the guarantee stops: read on this pier `20260911`,
# `/proc/sys/net/ipv4/ip_local_port_range` answers `32768 60999` and `ip_local_reserved_ports` is
# EMPTY. So every number in the band is one the kernel may hand any client socket on this machine at
# any moment. The convention orders our own modules; the host remains free. Printing that reading is
# how it stays known.
#
# WHAT THIS PROVES, AND WHERE THE OTHER HALF IS PROVEN. This reading proves the SHAPE that lets two
# modules meet on a number, which is the whole of what a reading of the source can prove. Whether
# they ever do meet depends on which ships run which guard at which second, and that half is proven
# in company at tools/fixtures/m/mantra_delivery_port_control.sh.
#
# AND THE SHARED NUMBER IS NOT THE WHOLE EXPOSURE (`20260911.203000`). Of the three doubles below,
# only ONE side of one pair is rostered, so a roster pass never runs both claimants of any of them.
# What a roster pass does run is the SAME guard, on eight checkouts, against one machine. That
# reading is tools/fixtures/p/port_runner_lock_scan.sh, which counts which rostered guards actually
# EXECUTE a binder and which of those runs holds a lock -- the cell where an unlocked run meets a
# module that sets SO_REUSEADDR being a wall at zero, since that collision is silent.
#
# USAGE
#   sh tools/fixtures/p/port_band_scan.sh
#   sh tools/fixtures/p/port_band_scan.sh --list          # every declaration, number and file
#   PORT_BAND_ROOT=<dir> sh tools/fixtures/p/port_band_scan.sh    # a pen's own tree
#
# Driven by tools/p/port_band_witness.rish. Run from the repository root.

set -u

mode=${1:-count}
root=${PORT_BAND_ROOT:-.}

# The band, named here so the reason travels with the number. See the header above.
band_floor=${PORT_BAND_FLOOR:-38472}
band_ceiling=${PORT_BAND_CEILING:-38600}

# The ceiling only falls. Measured `20260911` over 21 files and 35 declarations: three numbers --
# 38495, 38496 and 38497 -- are each declared by two modules, six declarations across four files.
# 38495 is amphora/vessel_fetch_delivery.rye's source_port beside
# linengrow/neth_serial_core_delivery.rye's root_port; 38496 and 38497 are
# granary/resin_serve_delivery.rye's guest and host pair beside
# linengrow/seva_broadcast_delivery.rye's event and root pair. Each is a lawful number for its own
# module and a collision for the pier, and each repair is a choice of number inside another lane --
# so they are NAMED here for their owners rather than edited blind. This falls to zero when the
# three lanes pick from band_free.
double_ceiling=${PORT_BAND_DOUBLE_CEILING:-3}

cd "$root" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root is not a directory" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads git ls-files" >&2; exit 1; }

# A refusal rather than a zero when nothing can be read. A tree holding no Rye source cannot
# honestly report a clean port band, and %646's lesson is that a guard answering green on an
# unreadable subject is a guard reporting nothing.
sources_n=$(git ls-files '*.rye' | grep -c . || true)
if [ "$sources_n" -eq 0 ]; then
  echo "sources_read=0"
  echo "verdict=no_sources"
  echo "refused: no tracked .rye source to read a port declaration from" >&2
  exit 1
fi

# THE DECLARATIONS. `git grep -h` would drop the path, which is the one field a repair needs, so the
# path is kept and the awk below splits it off. A `date/`, `archive/` or `yonder/` shelf holds
# testimony, and testimony keeps every word it wrote -- it binds no port on this pier.
decls=$(git grep -n -E '^[[:space:]]*(pub )?const [A-Za-z0-9_]*[Pp]ort[A-Za-z0-9_]*:[[:space:]]*u16[[:space:]]*=[[:space:]]*[0-9]+;' -- '*.rye' 2>/dev/null |
  awk -F: '
    {
      path = $1; line = $2
      rest = $0
      sub(/^[^:]*:[0-9]+:/, "", rest)
      if (path ~ /(^|\/)(date|archive|yonder)\//) next
      if (match(rest, /const [A-Za-z0-9_]+:/) == 0) next
      name = substr(rest, RSTART + 6, RLENGTH - 7)
      # PORT AS A WHOLE COMPONENT, never as a substring. `max_report` carries the letters and holds
      # no port; the control plants it and reads zero.
      if (name !~ /(^|_)[Pp]ort(_|$)/) next
      if (match(rest, /=[[:space:]]*[0-9]+;/) == 0) next
      num = substr(rest, RSTART, RLENGTH)
      gsub(/[^0-9]/, "", num)
      print num "\t" path "\t" line "\t" name
    }
  ' | sort -n -k1,1)

decl_n=$(printf '%s\n' "$decls" | grep -c . || true)
files_n=$(printf '%s\n' "$decls" | grep . | cut -f2 | sort -u | grep -c . || true)

# A ZERO PORT IS THE CURE. It asks the kernel for a number nobody holds, so it is neither in the
# band nor a claim on one, and charging it would instruct a repair the file has already made.
constants=$(printf '%s\n' "$decls" | grep . | awk -F'\t' '$1 != 0')
kernel_chosen=$(printf '%s\n' "$decls" | grep . | awk -F'\t' '$1 == 0' | grep -c . || true)
constant_n=$(printf '%s\n' "$constants" | grep -c . || true)

outside=$(printf '%s\n' "$constants" | grep . | awk -F'\t' -v lo="$band_floor" -v hi="$band_ceiling" '$1 < lo || $1 > hi')
outside_n=$(printf '%s\n' "$outside" | grep -c . || true)

# A NUMBER TWO MODULES DECLARE. Counted per NUMBER rather than per declaration: 38496 claimed twice
# is one collision to resolve, and two files to tell about it.
doubles=$(printf '%s\n' "$constants" | grep . | awk -F'\t' '{ n[$1]++; f[$1] = f[$1] " " $2 ":" $3 " " $4 } END { for (k in n) if (n[k] > 1) print k "\t" f[k] }' | sort -n -k1,1)
double_n=$(printf '%s\n' "$doubles" | grep -c . || true)

# THE LOCKS. Found by the name shape this room writes rather than by a typed list, so a lock added
# tomorrow is read on the lap it lands. Each lock's numeric literals are compared two ways: does
# its edge check turn away a port its own room declares, and does it name a number no module
# declares at all.
locks=$(git ls-files 'tools/fixtures/*/*_port_lock.sh' 2>/dev/null)
lock_n=$(printf '%s\n' "$locks" | grep -c . || true)

uncovered=""
unbound=""
for lock in $locks; do
  [ -f "$lock" ] || continue
  # THE ROOM A LOCK SPEAKS FOR is read off its own basename -- `mantra_delivery_port_lock.sh` speaks
  # for `mantra/`, `amphora_vessel_port_lock.sh` for `amphora/` -- since the first component of the
  # name is the module room in every spelling this tree writes.
  room=$(basename "$lock" | sed 's/_.*//')
  room_ports=$(printf '%s\n' "$constants" | grep . | awk -F'\t' -v r="$room/" 'index($2, r) == 1 { print $1 }' | sort -n)
  [ -n "$room_ports" ] || continue

  # THE EDGE CHECK, read as the pair of numbers a `-lt`/`-gt` refusal names. A lock that bounds no
  # range refuses nothing and is passed over here rather than guessed at.
  #
  # A LOCK IS TAKEN ON THE LOW PORT OF A PAIR, and the first draft of this reading forgot it: the
  # mantra lock's own usage line reads `38490 mantra/bin/snapshot-export-delivery selftest`, so
  # 38491 is never handed to it and an edge band of 38478-38490 turns nothing away. That draft
  # reported a fault against a correct file, which is the one failure a guard cannot afford. So the
  # comparison is against each room port that OPENS a pair -- a declared `p` whose `p-1` its own
  # room does not declare -- read off the declarations rather than from a list of pairs nobody
  # writes down. The control plants both directions.
  lo=$(grep -oE '\-lt[[:space:]]+[0-9]{4,5}' "$lock" | head -1 | grep -oE '[0-9]{4,5}' || true)
  hi=$(grep -oE '\-gt[[:space:]]+[0-9]{4,5}' "$lock" | head -1 | grep -oE '[0-9]{4,5}' || true)
  if [ -n "$lo" ] && [ -n "$hi" ]; then
    for p in $room_ports; do
      printf '%s\n' $room_ports | grep -qx "$((p - 1))" && continue
      if [ "$p" -lt "$lo" ] || [ "$p" -gt "$hi" ]; then
        uncovered="${uncovered}${lock}	${p}	edge ${lo}-${hi}
"
      fi
    done
  fi

  # A NUMBER THE LOCK NAMES THAT ITS OWN ROOM DOES NOT DECLARE. Measured against the ROOM rather
  # than against the tree, which is the sharper reading and the one that fires: the amphora lock's
  # header opens *amphora/vessel_fetch_delivery.rye binds UDP 38494 and 38495*, and that module
  # declares 38495 and a kernel-chosen 0 -- 38494 moved to `linengrow/neth_serial_core_delivery.rye`
  # when the fetcher side took the kernel's choice. Read tree-wide the number is declared and the
  # sentence looks sound; read against the room it is a lock naming a port its module let go.
  # Reported rather than gated: a lock whose module moved to bind-to-zero keeps a correct lock path
  # and a stale sentence, and which of the two to repair is the owning lane's reading.
  for n in $(grep -ohE '\b3[0-9]{4}\b' "$lock" | sort -u); do
    [ "$n" -ge "$band_floor" ] && [ "$n" -le "$band_ceiling" ] || continue
    printf '%s\n' $room_ports | grep -qx "$n" && continue
    unbound="${unbound}${lock}	${n}
"
  done
done
uncovered_n=$(printf '%s' "$uncovered" | grep -c . || true)
unbound_n=$(printf '%s' "$unbound" | grep -c . || true)

# A BASE A MODULE COUNTS UP FROM claims a span no literal census can see -- comlink/rehearsal_wire's
# `base_port` is *one per ship*, so 38498 claims 38498 and the two numbers above it. Printed so a
# reader never mistakes band_free for a number that is truly free.
bases=$(printf '%s\n' "$constants" | grep . | awk -F'\t' '$4 ~ /^base_port$/ { print $1 "\t" $2 }' | sort -n -k1,1)
base_n=$(printf '%s\n' "$bases" | grep -c . || true)

claimed=$(printf '%s\n' "$constants" | grep . | cut -f1 | sort -un)
free_list=""
p=$band_floor
while [ "$p" -le "$band_ceiling" ]; do
  printf '%s\n' "$claimed" | grep -qx "$p" || free_list="${free_list}${p} "
  p=$((p + 1))
done
free_n=$(printf '%s\n' $free_list | grep -c . || true)


# ---------------------------------------------------------------- THE DEVICE BAND
# A SECOND ROOM, AND THE READING THAT COULD NOT SEE IT. Everything above reads Rye. The wire labs
# that carry these same capabilities onto virtio declare their ports in RISHI, as the default half
# of an environment override -- `if port_request_raw == "" then let port_request = "15561"` -- and a
# reading of `const <name>: u16` passes over every one of them. So `ports_outside_band=0` was true
# of Rye and blind to a room of twenty-nine declarations sitting twenty-three thousand numbers
# below the seated band. A roster that reads one language reports the language, never the tree.
#
# WHAT THE BLINDNESS COST, measured `20260911`. Fifteen labs claimed twenty-two numbers, and FIVE
# numbers carried two or three claimants: 15561, 15562 and 15563 between the open-asks lap-5 ladder
# and three recall labs, and 15565 with 15566 between catch-up and subscribe-poll. Two labs
# proving DIFFERENT capabilities held byte-identical pairs, because each was made by copying a
# sibling and editing the capability name while the port block travelled unread.
#
# AND THE ESCAPE HATCH SHARED THE COLLISION. `recall_two_way_sync` reads `COMLINK_SYNC_LAB_PORT`,
# the same name `recall_sync` reads; `subscribe_poll` reads `COMLINK_CATCHUP_LAB_PORT` beside
# `catch_up`. So a hand meeting the clash and reaching for the documented override moved both labs
# at once and met it again. `device_override_shared` is that reading, and it is the one no census
# of numbers alone would have taken.
#
# WHY THIS HALF REPORTS WHERE THE RYE HALF REFUSES. A tree with no tracked Rye source cannot
# honestly report a clean port band, so the reading above exits rather than answering zero. A tree
# with no wire lab is a different thing: the labs are a room this tree GREW, and every tree before
# they landed held none. So `device_labs=0` is reported and the verdict is left alone.
device_band_floor=${PORT_BAND_DEVICE_FLOOR:-15555}
device_band_ceiling=${PORT_BAND_DEVICE_CEILING:-15600}

# BOTH DEVICE CEILINGS STAND AT ZERO, which makes each a wall rather than a ratchet. They were five
# and four on the morning of `20260911` and the repair that lap took them down, so nothing holds a
# lab silent: the next lab copied from a sibling without editing its port block reds on the lap it
# lands. That is the whole reason to spend a repair before seating a number.
device_double_ceiling=${PORT_BAND_DEVICE_DOUBLE_CEILING:-0}
device_override_ceiling=${PORT_BAND_DEVICE_OVERRIDE_CEILING:-0}

labs=$(git ls-files 'tools/co/comlink_*_wire_lab.rish' 2>/dev/null)
lab_n=$(printf '%s\n' "$labs" | grep -c . || true)

# THE DECLARATION SHAPE, and why the name test is the same one the Rye half uses. `port` must be a
# whole component of the identifier, so `port_request` and `port_hold` count while a variable
# merely carrying the letters is read past. The number is the DEFAULT half of the override, which
# is the value the lab binds when nobody sets the variable -- and nobody does, on any pier here.
device_decls=$(printf '%s\n' "$labs" | grep . | while IFS= read -r lab; do
  [ -f "$lab" ] || continue
  grep -n -E '^[[:space:]]*if [A-Za-z0-9_]+ == "" then let [A-Za-z0-9_]+ = "[0-9]+"' "$lab" 2>/dev/null |
    awk -F: -v path="$lab" '
      {
        line = $1
        rest = $0
        sub(/^[0-9]+:/, "", rest)
        if (match(rest, /then let [A-Za-z0-9_]+ =/) == 0) next
        name = substr(rest, RSTART + 9, RLENGTH - 11)
        if (name !~ /(^|_)[Pp]ort(_|$)/) next
        if (match(rest, /= "[0-9]+"/) == 0) next
        num = substr(rest, RSTART, RLENGTH)
        gsub(/[^0-9]/, "", num)
        print num "\t" path "\t" line "\t" name
      }'
done | sort -n -k1,1)

device_decl_n=$(printf '%s\n' "$device_decls" | grep -c . || true)
device_labs_declaring=$(printf '%s\n' "$device_decls" | grep . | cut -f2 | sort -u | grep -c . || true)

device_outside=$(printf '%s\n' "$device_decls" | grep . |
  awk -F'\t' -v lo="$device_band_floor" -v hi="$device_band_ceiling" '$1 < lo || $1 > hi')
device_outside_n=$(printf '%s\n' "$device_outside" | grep -c . || true)

device_doubles=$(printf '%s\n' "$device_decls" | grep . |
  awk -F'\t' '{ n[$1]++; f[$1] = f[$1] " " $2 ":" $3 " " $4 } END { for (k in n) if (n[k] > 1) print k "\t" f[k] }' |
  sort -n -k1,1)
device_double_n=$(printf '%s\n' "$device_doubles" | grep -c . || true)

# ONE OVERRIDE NAME READ BY TWO LABS. Counted per NAME, since one shared variable is one repair
# whichever lab moves, and both sites are printed so the repair is one edit away in each.
device_overrides=$(printf '%s\n' "$labs" | grep . | while IFS= read -r lab; do
  [ -f "$lab" ] || continue
  grep -oE 'env "[A-Z][A-Z0-9_]*PORT[A-Z0-9_]*"' "$lab" 2>/dev/null |
    sed 's/^env "//; s/"$//' |
    sort -u |
    while IFS= read -r name; do
      [ -n "$name" ] && printf '%s\t%s\n' "$name" "$lab"
    done
done | sort)
device_shared=$(printf '%s\n' "$device_overrides" | grep . |
  awk -F'\t' '{ n[$1]++; f[$1] = f[$1] " " $2 } END { for (k in n) if (n[k] > 1) print k "\t" f[k] }' | sort)
device_shared_n=$(printf '%s\n' "$device_shared" | grep -c . || true)

device_claimed=$(printf '%s\n' "$device_decls" | grep . | cut -f1 | sort -un)
device_free_list=""
p=$device_band_floor
while [ "$p" -le "$device_band_ceiling" ]; do
  printf '%s\n' "$device_claimed" | grep -qx "$p" || device_free_list="${device_free_list}${p} "
  p=$((p + 1))
done
device_free_n=$(printf '%s\n' $device_free_list | grep -c . || true)

if [ "$mode" = "--list" ]; then
  printf '%s\n' "$decls" | grep . | awk -F'\t' '{ print "port: " $1 "\t" $2 ":" $3 "\t" $4 }'
  printf '%s' "$doubles" | grep . | sed 's/^/double: /'
  printf '%s' "$uncovered" | grep . | sed 's/^/uncovered: /'
  printf '%s' "$unbound" | grep . | sed 's/^/unbound: /'
  printf '%s\n' "$bases" | grep . | sed 's/^/base: /'
  echo "free: $free_list"
  printf '%s\n' "$device_decls" | grep . | awk -F'\t' '{ print "device: " $1 "\t" $2 ":" $3 "\t" $4 }'
  printf '%s' "$device_doubles" | grep . | sed 's/^/device double: /'
  printf '%s' "$device_shared" | grep . | sed 's/^/device override: /'
  echo "device free: $device_free_list"
fi

echo "sources_read=$sources_n"
echo "port_declarations=$decl_n"
echo "port_files=$files_n"
echo "ports_constant=$constant_n"
echo "ports_kernel_chosen=$kernel_chosen"
echo "band=$band_floor-$band_ceiling"
echo "ports_outside_band=$outside_n"
echo "ports_double_claimed=$double_n"
echo "double_ceiling=$double_ceiling"
echo "locks_read=$lock_n"
echo "lock_band_uncovered=$uncovered_n"
echo "lock_claims_unbound=$unbound_n"
echo "counting_bases=$base_n"
echo "band_free=$free_n"
echo "device_labs=$lab_n"
echo "device_labs_declaring=$device_labs_declaring"
echo "device_declarations=$device_decl_n"
echo "device_band=$device_band_floor-$device_band_ceiling"
echo "device_ports_outside_band=$device_outside_n"
echo "device_double_claimed=$device_double_n"
echo "device_double_ceiling=$device_double_ceiling"
echo "device_override_shared=$device_shared_n"
echo "device_override_ceiling=$device_override_ceiling"
echo "device_free=$device_free_n"

verdict=ok
if [ "$outside_n" -gt 0 ]; then
  printf '%s' "$outside" | grep . | awk -F'\t' '{ print "over: " $2 ":" $3 " declares " $4 " = " $1 ", outside the seated band -- count up from band_free instead" }'
  verdict=outside_band
fi
if [ "$uncovered_n" -gt 0 ]; then
  printf '%s' "$uncovered" | grep . | awk -F'\t' '{ print "over: " $1 " would refuse port " $2 " (" $3 "), which its own room declares" }'
  verdict=lock_uncovered
fi
if [ "$double_n" -gt "$double_ceiling" ]; then
  echo "over: ports_double_claimed=$double_n past its ceiling of $double_ceiling -- one number, two modules, one machine"
  verdict=over_ceiling
fi
if [ "$device_outside_n" -gt 0 ]; then
  printf '%s' "$device_outside" | grep . | awk -F'\t' '{ print "over: " $2 ":" $3 " declares " $4 " = " $1 ", outside the seated device band -- count up from device_free instead" }'
  verdict=device_outside_band
fi
if [ "$device_double_n" -gt "$device_double_ceiling" ]; then
  printf '%s' "$device_doubles" | grep . | awk -F'\t' '{ print "over: device port " $1 " is claimed by" $2 }'
  echo "over: device_double_claimed=$device_double_n past its ceiling of $device_double_ceiling -- one number, two labs, one machine"
  verdict=device_over_ceiling
fi
if [ "$device_shared_n" -gt "$device_override_ceiling" ]; then
  printf '%s' "$device_shared" | grep . | awk -F'\t' '{ print "over: override " $1 " is read by" $2 }'
  echo "over: device_override_shared=$device_shared_n past its ceiling of $device_override_ceiling -- moving one lab moves the other"
  verdict=device_override_shared
fi
echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
