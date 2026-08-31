#!/bin/sh
# tools/fixtures/p/pond_spool_cloth_glow_tend_control.sh -- the spool-cloth name-bound scan, proven
# both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading here
# is shown from both sides: planted and refused, then removed and welcomed. Nineteen verdict cases
# and five reading checks run in a throwaway pen holding just the two files the scan reads.
#
# Case 2 is the one this guard exists for. An elder Tend witness greps for the literal number in
# both rooms, so raising a bound honestly -- moving it in the Rye AND on the pedestal, in both the
# shape line and the example -- still reds until a hand edits the guard. Here that raise walks free,
# because the scan compares the two rooms rather than remembering a value.
#
# Case 15 is REDS %354's own lesson, planted. A third byte joins the wall in the Rye alone and the
# LENGTH reading stays perfectly quiet -- 48 equals 48 on both sides -- because a length bound and a
# grammar wall were never the same fact. Case 3 is its welcome: the same byte added to the wall and
# to the desk together walks free.
#
# Cases 18 and 19 are the two edges, and they are here as two rather than one because they fire
# apart. Delete the store call and the manifest edge still stands; delete the manifest check and the
# store edge still stands. The reading checks beside each prove exactly that, so a future hand
# folding them into one reading has to argue with a measurement rather than with a preference.
#
# Case 19 is the sharper of the two. The store edge refuses a policy; the manifest edge guards an
# array's end, because a parsed entry's name lands in a fixed [max_name]u8 field. With that check
# gone a hand-authored manifest carrying a sixty-byte name is copied past the end of the array --
# a refusal downgraded to a panic.
#
# Cases 20 through 23 hold the sixth placard line, which no desk in this room has ever had checked.
# A module version that moves while its desk keeps the elder nib is a desk saying it shows a value
# from a release the module has left, and case 21 is that drift planted. Case 20 is its welcome: a
# version bumped in the Rye and on the desk together walks free.
#
# EXPECTED: control_verdict=ok, with welcomes=4, refusals=19, and readings=6.
#
# Driven by tools/p/pond_spool_cloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh"
desk_src="$root/src/shape/shape-spool-cloth-name-bound.glow"
capacity_src="$root/src/shape/shape-spool-cloth-catalog-capacity.glow"
rye_src="$root/pond/apps/spool_cloth.rye"
keyed_src="$root/pond/apps/spool_keyed.rye"
beading_src="$root/mantra/beading.rye"
spool_src="$root/mantra/spool.rye"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
readings=0
wrong=0

# pen -- a fresh copy of exactly the two files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/pond/apps" "$work/pen/mantra"
  cp "$desk_src" "$work/pen/src/shape/shape-spool-cloth-name-bound.glow"
  cp "$capacity_src" "$work/pen/src/shape/shape-spool-cloth-catalog-capacity.glow"
  cp "$rye_src" "$work/pen/pond/apps/spool_cloth.rye"
  cp "$keyed_src" "$work/pen/pond/apps/spool_keyed.rye"
  cp "$beading_src" "$work/pen/mantra/beading.rye"
  cp "$spool_src" "$work/pen/mantra/spool.rye"
}

# check <label> <want-verdict> <want refuse|welcome>
check() {
  label=$1
  want=$2
  side=$3
  code=0
  out=$(sh "$scan" "$work/pen" 2>/dev/null) || code=$?
  got=$(printf '%s\n' "$out" | sed -n 's/^verdict=//p' | head -1)
  if [ "$side" = refuse ]; then
    if [ "$got" = "$want" ] && [ "$code" -ne 0 ]; then
      refusals=$((refusals + 1))
      echo "  refused $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a refusal, got $got exit $code"
    fi
  else
    if [ "$got" = "$want" ] && [ "$code" -eq 0 ]; then
      welcomes=$((welcomes + 1))
      echo "  welcome $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a welcome, got $got exit $code"
    fi
  fi
}

# reading <label> <key> <want-value> -- one named reading of the pen as it currently stands, so a
# case can prove what the OTHER readings said while one refused.
reading() {
  label=$1
  key=$2
  want=$3
  out=$(sh "$scan" "$work/pen" 2>/dev/null || true)
  got=$(printf '%s\n' "$out" | sed -n "s/^$key=//p" | head -1)
  if [ "$got" = "$want" ]; then
    readings=$((readings + 1))
    echo "  reading $label ($key=$got)"
  else
    wrong=$((wrong + 1))
    echo "  WRONG   $label -- wanted $key=$want, got $key=$got"
  fi
}

# edit <file> <sed-script> -- rewrite in place through the original inode, so a pen file keeps the
# mode it was copied with (.claude/rules/exec-bit.md).
edit() {
  f=$1
  sed "$2" "$f" > "$f.t" && cat "$f.t" > "$f" && rm -f "$f.t"
}

deskf="$work/pen/src/shape/shape-spool-cloth-name-bound.glow"
capf="$work/pen/src/shape/shape-spool-cloth-catalog-capacity.glow"
ryef="$work/pen/pond/apps/spool_cloth.rye"
keyedf="$work/pen/pond/apps/spool_keyed.rye"
beadf="$work/pen/mantra/beading.rye"
spoolf="$work/pen/mantra/spool.rye"

# 1 -- the tree as it stands.
pen
check "the pedestal as written" agree welcome

# 2 -- an honest raise, moved in every room that spells it. The case this guard exists for.
pen
edit "$deskf" 's/, bound 48/, bound 64/; s/^::  example    48$/::  example    64/'
edit "$ryef" 's/^pub const max_name: u32 = 48;$/pub const max_name: u32 = 64;/'
check "a bound raised in the Rye and on the desk together" agree welcome

# 3 -- a third byte joins the wall, and the desk says so in the same breath.
pen
edit "$ryef" "s/if (name\[i\] == ' ' or name\[i\] == '\\\\n') return false;/if (name[i] == ' ' or name[i] == '\\\\n' or name[i] == '\\\\t') return false;/"
edit "$deskf" 's/^::    space - newline$/::    space - newline - tab/'
check "a byte added to the wall and to the desk together" agree welcome

# 4 -- no pedestal at all.
pen
rm -f "$deskf"
check "the pedestal missing" desk_missing refuse

# 5 -- no Rye to check against.
pen
rm -f "$ryef"
check "the Rye source missing" rye_missing refuse

# 6 -- the placard's six lines out of their seated order.
pen
edit "$deskf" 's/^::  invariant  /::  zinvariant /'
check "the placard out of seated order" placard_wrong refuse

# 7 -- a number with nowhere to be checked against.
pen
edit "$deskf" 's|pond/apps/spool_cloth.rye|the module|g'
check "the desk naming no source" citation_missing refuse

# 8 -- the displayed value written in words rather than as a literal. Deleting the line outright
# would be caught one reading earlier, by the placard order, so this plants the fault the example
# reading actually owns: the keyword stands in its seated place and the value cannot be read.
pen
edit "$deskf" 's/^::  example    48$/::  example    forty-eight/'
check "the desk showing no readable example" desk_example_missing refuse

# 9 -- the published bound gone.
pen
edit "$ryef" '/^pub const max_name: u32 = 48;$/d'
check "the Rye publishing no bound" rye_bound_missing refuse

# 10 -- the desk spells its number twice, and the two part inside one file.
pen
edit "$deskf" 's/, bound 48/, bound 64/'
check "the desk disagreeing with its own shape line" desk_self_disagree refuse

# 11 -- the desk raised alone.
pen
edit "$deskf" 's/, bound 48/, bound 64/; s/^::  example    48$/::  example    64/'
check "the desk raised and the Rye left behind" disagree refuse

# 12 -- the Rye raised alone, which is the same fault from the other side.
pen
edit "$ryef" 's/^pub const max_name: u32 = 48;$/pub const max_name: u32 = 64;/'
check "the Rye raised and the desk left behind" disagree refuse

# 13 -- the alphabet's delimited region gone, so the desk shows a length and nothing else.
pen
edit "$deskf" '/^::  the bytes the manifest grammar reserves/,/^::  that is the whole alphabet the wall removes\.$/d'
check "the desk listing no alphabet" alphabet_missing refuse

# 14 -- the wall standing with nothing in it.
pen
edit "$ryef" "s/if (name\[i\] == ' ' or name\[i\] == '\\\\n') return false;/if (name[i] == name[i]) return false;/"
check "the wall comparing no byte" rye_wall_missing refuse

# 15 -- REDS %354, planted: a third byte in the wall alone, with both lengths still agreeing.
pen
edit "$ryef" "s/if (name\[i\] == ' ' or name\[i\] == '\\\\n') return false;/if (name[i] == ' ' or name[i] == '\\\\n' or name[i] == '\\\\t') return false;/"
check "a byte added to the wall alone" bytes_disagree refuse
reading "the length reading stays quiet while the alphabet drifts" rye_max_name 48

# 16 -- the same drift from the other side: a byte dropped from the desk's list.
pen
edit "$deskf" 's/^::    space - newline$/::    space/'
check "a byte dropped from the desk's list" bytes_disagree refuse

# 17 -- a byte the name table does not know. It must read as a literal rather than vanish.
pen
edit "$ryef" "s/if (name\[i\] == ' ' or name\[i\] == '\\\\n') return false;/if (name[i] == ' ' or name[i] == '\\\\n' or name[i] == 'x') return false;/"
check "a byte the name table has never met" bytes_disagree refuse
reading "the unknown byte reads as a literal rather than passing quietly" rye_wall_bytes "newline space unnamed:x"

# 18 -- the store edge unwired: the wall stands, refuses exactly the right bytes, and nobody asks.
pen
edit "$ryef" '/if (!name_is_one_field(name)) return error\.NameHasSeparator;/d'
check "the store edge no longer consulting the wall" store_unwired refuse
reading "the manifest edge still stands while the store edge is gone" parse_wired yes

# 19 -- the manifest edge unwired, where the refusal is what keeps a copy inside the array.
pen
edit "$ryef" '/if (name.len > max_name) return error\.BadManifest;/d'
check "the manifest edge no longer reading the bound" parse_unwired refuse
reading "the store edge still stands while the manifest edge is gone" store_wired yes
reading "the alphabet still agrees while the manifest edge is gone" rye_wall_bytes "newline space"

# 20 -- an honest version bump, moved in every room that displays it. Two desks show this module's
# version now, so a bump costs three lines rather than two -- which is what a pedestal displaying a
# value AT a nib means once a module has more than one pedestal.
pen
edit "$ryef" 's/^pub const spool_cloth_version = "20260812.192400";$/pub const spool_cloth_version = "20260901.000000";/'
edit "$deskf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1 at 20260901.000000/'
edit "$capf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1 at 20260901.000000/'
check "a version bumped in the Rye and on both desks together" agree welcome

# 21 -- the module moves and the desk keeps the elder nib.
pen
edit "$ryef" 's/^pub const spool_cloth_version = "20260812.192400";$/pub const spool_cloth_version = "20260901.000000";/'
check "the module version moved and the desk's nib stayed" nib_disagree refuse
reading "every bound reading stays quiet while the nib drifts" desk_example 48

# 22 -- the nib line carrying no stamp to compare.
pen
edit "$deskf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1/'
check "the nib naming no version" desk_nib_missing refuse

# 23 -- the module publishing no version at all.
pen
edit "$ryef" '/^pub const spool_cloth_version = "20260812.192400";$/d'
check "the module publishing no version" rye_version_missing refuse

# ---- the capacity pedestal ---------------------------------------------------------------------
#
# Nineteen more plantings, three more welcomes, and four more named readings. The capacity desk
# shows a number whose companion is DERIVED two levels deep across two modules, and the bound it
# displays sizes three fixed arrays in two of them -- so the plants below have to move a value in as
# many as three rooms at once to reach the reading they are aimed at.

# 24 -- both pedestals as written.
pen
check "the capacity pedestal as written" agree welcome

# 25 -- an honest raise of the seats, moved in the Rye and on the desk together.
pen
edit "$capf" 's/, bound 4 --/, bound 8 --/; s/^::  example    4$/::  example    8/'
edit "$ryef" 's/^pub const max_large_artifacts: u32 = 4;$/pub const max_large_artifacts: u32 = 8;/'
check "the seats raised in the Rye and on the desk together" agree welcome

# 26 -- an honest raise of the STORE, which moves a derived number: the guarantee goes 2 to 4, and
# the desk carries both the constant and the guarantee it decides.
pen
edit "$beadf" 's/^pub const max_store_beads: u32 = 256;$/pub const max_store_beads: u32 = 512;/'
edit "$capf" 's/^::    max_store_beads 256$/::    max_store_beads 512/; s/^::  the guarantee is 2 ceiling artifacts/::  the guarantee is 4 ceiling artifacts/'
check "the store raised in Mantra and on the desk together" agree welcome
reading "the seats stay where they were while the guarantee moves" rye_max_large_artifacts 4

# 27 -- no capacity pedestal at all.
pen
rm -f "$capf"
check "the capacity pedestal missing" capacity_desk_missing refuse

# 28 -- the room that decides three of the four constants, gone.
pen
rm -f "$beadf"
check "mantra/beading.rye missing" beading_missing refuse

# 29 -- the room that decides the fourth, gone.
pen
rm -f "$spoolf"
check "mantra/spool.rye missing" spool_missing refuse

# 30 -- the module holding the third array, gone.
pen
rm -f "$keyedf"
check "pond/apps/spool_keyed.rye missing" keyed_missing refuse

# 31 -- the capacity placard out of its seated order.
pen
edit "$capf" 's/^::  invariant  /::  zinvariant /'
check "the capacity placard out of seated order" capacity_placard_wrong refuse

# 32 -- a desk citing no room, so its arithmetic can be checked nowhere.
pen
edit "$capf" 's|mantra/beading.rye|the bead room|g'
check "the capacity desk naming no deciding room" capacity_citation_missing refuse

# 33 -- the displayed value in words. Deleting the line lands one reading earlier at the placard
# order, which is the shadow this family met once already, so the keyword keeps its seated place.
pen
edit "$capf" 's/^::  example    4$/::  example    four/'
check "the capacity desk showing no readable example" capacity_desk_example_missing refuse

# 34 -- the published seats gone.
pen
edit "$ryef" '/^pub const max_large_artifacts: u32 = 4;$/d'
check "the Rye publishing no seat bound" rye_seats_missing refuse

# 35 -- the capacity desk spells its number twice and the two part inside one file.
pen
edit "$capf" 's/, bound 4 --/, bound 6 --/'
check "the capacity desk disagreeing with its own shape line" capacity_desk_self_disagree refuse

# 36 -- the seats raised in the Rye alone.
pen
edit "$ryef" 's/^pub const max_large_artifacts: u32 = 4;$/pub const max_large_artifacts: u32 = 8;/'
check "the seats raised and the capacity desk left behind" capacity_disagree refuse

# 37 -- the constants region gone, so a derived number stands with no arithmetic under it.
pen
edit "$capf" '/^::  the constants that decide it, each published one room away:$/,/^::  that is the whole budget behind the guarantee\.$/d'
check "the capacity desk listing no constants" capacity_inputs_missing refuse

# 38 -- one constant misquoted on the desk while the guarantee still happens to agree.
pen
edit "$capf" 's/^::    max_resins 64$/::    max_resins 32/'
check "a constant misquoted on the desk" capacity_inputs_disagree refuse
reading "the guarantee itself still agrees while an input drifts" rye_guarantee 2

# 39 -- the guarantee line carrying no number.
pen
edit "$capf" 's/^::  the guarantee is 2 ceiling artifacts, derived rather than spelled:$/::  the guarantee is derived rather than spelled:/'
check "the capacity desk stating no guarantee" capacity_guarantee_missing refuse

# 40 -- the store raised in Mantra and on the desk's list, and the guarantee left at the elder
# number. This is the fault the recomputation exists for: every literal agrees with its own room.
pen
edit "$beadf" 's/^pub const max_store_beads: u32 = 256;$/pub const max_store_beads: u32 = 512;/'
edit "$capf" 's/^::    max_store_beads 256$/::    max_store_beads 512/'
check "the store raised and the guarantee left behind" capacity_guarantee_disagree refuse

# 41 -- the derivation respelled as a literal, with every number still agreeing.
pen
edit "$ryef" 's|^pub const guaranteed_full_artifacts: u32 = beading.max_store_beads / full_artifact_beads;$|pub const guaranteed_full_artifacts: u32 = 2;|'
check "the guarantee spelled rather than derived" capacity_derivation_unwired refuse
reading "every constant still agrees while the derivation is gone" capacity_desk_inputs "max_bead_bytes=256 max_resin_bytes=512 max_resins=64 max_store_beads=256"

# 42 -- the catalog edge unwired, which panics two arrays in two modules rather than one.
pen
edit "$ryef" '/if (cat.count >= max_large_artifacts) return error\.CatalogFull;/d'
check "store_large no longer refusing a full catalog" capacity_store_unwired refuse
reading "the manifest edge still stands while the catalog edge is gone" capacity_parse_wired yes
reading "the keyed array still names this bound while the catalog edge is gone" capacity_keyed_wired yes

# 43 -- the manifest edge unwired.
pen
edit "$ryef" '/if (man.count >= max_large_artifacts) return error\.CatalogFull;/d'
check "parse_manifest no longer refusing an overlong manifest" capacity_parse_unwired refuse
reading "the catalog edge still stands while the manifest edge is gone" capacity_store_wired yes

# 44 -- the third array given a literal of its own, one module over.
pen
edit "$keyedf" 's/^    owners: \[cloth.max_large_artifacts\]u32,$/    owners: [4]u32,/'
check "spool_keyed sizing its owners array by a literal" capacity_keyed_unwired refuse
reading "both walls still stand while the third array leaves the bound" capacity_store_wired yes

# 45 -- the store raised past the catalog, consistently in every room. Nothing disagrees, and the
# invariant the module's own selftest asserts has gone false.
pen
edit "$beadf" 's/^pub const max_store_beads: u32 = 256;$/pub const max_store_beads: u32 = 1024;/'
edit "$capf" 's/^::    max_store_beads 256$/::    max_store_beads 1024/; s/^::  the guarantee is 2 ceiling artifacts/::  the guarantee is 8 ceiling artifacts/'
check "the store paying for more artifacts than the catalog seats" capacity_order_wrong refuse

# 46 -- the capacity nib naming no version.
pen
edit "$capf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1/'
check "the capacity nib naming no version" capacity_nib_missing refuse

# 47 -- the module moves and the capacity desk keeps the elder nib. The name desk's nib moves with
# the module here, so this reaches the capacity reading rather than its neighbour's.
pen
edit "$ryef" 's/^pub const spool_cloth_version = "20260812.192400";$/pub const spool_cloth_version = "20260901.000000";/'
edit "$deskf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1 at 20260901.000000/'
check "the module version moved and the capacity desk's nib stayed" capacity_nib_disagree refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "readings=$readings"
echo "wrong=$wrong"

if [ "$welcomes" -eq 7 ] && [ "$refusals" -eq 40 ] && [ "$readings" -eq 13 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
