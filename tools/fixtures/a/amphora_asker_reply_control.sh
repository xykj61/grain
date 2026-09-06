#!/usr/bin/env sh
# tools/fixtures/a/amphora_asker_reply_control.sh -- plant the compiled-in reply port, watch it bite.
#
# WHAT IT PLANTS, AND WHY BY TRANSFORM RATHER THAN BY HISTORY. The elder shape carried two separate
# faults, and each gets its own plant, edited into a pen copy of today's module -- so the control
# tests the PROPERTY rather than whatever one commit happened to contain. A plant survives a history
# rewrite; a pinned hash does not.
#
#   PORT   the source answers a number written in its own file, and the asker binds that same number
#   SPLIT  the asker sends its request from a fresh socket and listens on another, so the return
#          address the source reads names a port the asker is not holding
#
# THE FIVE READINGS, AND THE ONE THAT CORRECTED THIS SCRIPT'S OWN FIRST DRAFT. That draft expected a
# repaired source to refuse a PORT-planted asker, and measured the opposite: a source that answers
# whoever asked answers a fixed-port asker too, because such an asker still speaks and listens
# through one socket. The reading stands as leg 3 and it is a welcome asserted as hard as a refusal
# -- the repair is a superset of the elder, rather than merely different from it. What a repaired
# source genuinely cannot answer is a SPLIT asker, which is leg 4 and the fault that actually bit
# during the repair. A planted pair talking to itself is answered, which proves the pen, the pour,
# and the fixture innocent.
#
# WHAT IT COSTS, and why that is the subject rather than the price. Each crossed leg spends the
# module's own bound -- three attempts of ten seconds -- because the thing being proven is that
# nothing arrives, and nothing takes as long to establish as the bound says it does.
#
# Run from the repository root; the caller holds nothing, this script takes the port lock itself:
#   sh tools/fixtures/a/amphora_asker_reply_control.sh
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
. "$ROOT/tools/fixtures/s/shell_portable.sh"

zig="$ROOT/vendor/zig-toolchain/zig"
repaired="$ROOT/amphora/bin/vessel-fetch-delivery"
[ -x "$repaired" ] || { echo "control: build amphora/bin/vessel-fetch-delivery first" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
mkdir -p "$pen/amphora" "$pen/split"
# `-L` resolves the three symlinks into tally/ and comlink/, so the pen holds real files and a bare
# `@import` inside it never reaches out of its own directory -- which Zig refuses anyway.
cp -L "$ROOT"/amphora/*.rye "$pen/amphora/" || { echo "control: could not stage the pen" >&2; exit 2; }

cp -L "$ROOT"/amphora/*.rye "$pen/split/" 2>/dev/null || true

port_plant="$pen/amphora/vessel_fetch_delivery.rye"
# `sed_inplace` rather than `sed -i`: GNU takes no argument and BSD requires a backup suffix, so the
# two spellings have no overlap and `shell_portable.sh` writes neither (REDS %282's family). The
# helper copies back through the original inode, which also keeps the mode the repository tracks.
# PORT, half one: the asker binds the written number rather than asking the kernel for a free one.
sed_inplace 's/^const ephemeral_port: u16 = 0;$/const ephemeral_port: u16 = 38494;/' "$port_plant"
# PORT, half two: the source answers that written number rather than the address the request came
# from. A module-level address is the shortest honest way to say it -- a parameter cannot be
# shadowed -- and it is APPENDED rather than inserted, because `\n` in a sed replacement is a GNU
# extension BSD sed does not read. A file-scope const is legal wherever it stands.
printf 'const planted_reply_addr: sockaddr_in = localhost_addr(38494);\n' >> "$port_plant"
sed_inplace 's/send_resin_response(fd, \&resp, \&asker)/send_resin_response(fd, \&resp, \&planted_reply_addr)/g' "$port_plant"

split_plant="$pen/split/vessel_fetch_delivery.rye"
# SPLIT: the request leaves by a socket the asker is not listening on, so the return address the
# source reads correctly names a port with nobody reading it.
sed_inplace 's/try send_from(fd, \&service, wire_out/try send_from(try open_socket(), \&service, wire_out/' "$split_plant"

plants_ok=0
grep -q '^const ephemeral_port: u16 = 38494;$' "$port_plant" \
  && grep -q 'planted_reply_addr' "$port_plant" \
  && grep -q 'send_from(try open_socket()' "$split_plant" && plants_ok=1
[ "$plants_ok" -eq 1 ] || { echo "control: a plant did not take -- the module's shape moved"; echo "control_verdict=plant_missed"; exit 1; }

echo "control: building the two planted modules..."
for pair in "port:$port_plant" "split:$split_plant"; do
  tag=${pair%%:*}; srcfile=${pair#*:}
  if ! env RYE_ZIG="$zig" "$ROOT/rye/bin/rye" build "$srcfile" -lc -femit-bin="$pen/vfd-$tag" >"$pen/build-$tag.out" 2>&1; then
    sed -n '1,12p' "$pen/build-$tag.out"
    echo "control_verdict=plant_would_not_build plant=$tag"
    exit 1
  fi
done

leg() {
  name=$1; src=$2; fet=$3; want=$4
  out=$(sh "$ROOT/tools/fixtures/a/amphora_vessel_port_lock.sh" \
        sh "$ROOT/tools/fixtures/a/amphora_asker_reply.sh" "$src" "$fet" 2>&1)
  got=$(printf '%s\n' "$out" | sed -n 's/^asker_reply=//p' | tail -n 1)
  if [ "$got" = "$want" ]; then
    echo "leg $name: $got (as it must)"
    return 0
  fi
  echo "leg $name: read '$got', wanted '$want'"
  printf '%s\n' "$out" | sed -n '1,6p'
  return 1
}

fails=0
leg port_plant_pair_innocent      "$pen/vfd-port"  "$pen/vfd-port"  every_asker_answered     || fails=$((fails + 1))
leg port_source_repaired_asker    "$pen/vfd-port"  "$repaired"      an_asker_went_unanswered || fails=$((fails + 1))
leg repaired_source_port_asker    "$repaired"      "$pen/vfd-port"  every_asker_answered     || fails=$((fails + 1))
leg repaired_source_split_asker   "$repaired"      "$pen/vfd-split" an_asker_went_unanswered || fails=$((fails + 1))
leg repaired_pair                 "$repaired"      "$repaired"      every_asker_answered     || fails=$((fails + 1))

echo "legs=5 failed=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=a_leg_read_wrong"
exit 1
