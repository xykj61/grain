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
rye_src="$root/pond/apps/spool_cloth.rye"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
readings=0
wrong=0

# pen -- a fresh copy of exactly the two files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/pond/apps"
  cp "$desk_src" "$work/pen/src/shape/shape-spool-cloth-name-bound.glow"
  cp "$rye_src" "$work/pen/pond/apps/spool_cloth.rye"
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
ryef="$work/pen/pond/apps/spool_cloth.rye"

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

# 20 -- an honest version bump, moved in both rooms.
pen
edit "$ryef" 's/^pub const spool_cloth_version = "20260812.192400";$/pub const spool_cloth_version = "20260901.000000";/'
edit "$deskf" 's/^::  nib        spool-cloth-v1 at 20260812.192400$/::  nib        spool-cloth-v1 at 20260901.000000/'
check "a version bumped in the Rye and on the desk together" agree welcome

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

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "readings=$readings"
echo "wrong=$wrong"

if [ "$welcomes" -eq 4 ] && [ "$refusals" -eq 19 ] && [ "$readings" -eq 6 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
