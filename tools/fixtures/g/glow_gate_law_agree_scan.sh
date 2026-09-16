#!/bin/sh
# tools/fixtures/g/glow_gate_law_agree_scan.sh -- does a Glow gate's wall still say what Rye says?
#
# WHY THIS EXISTS. A Glow gate desk decides a module's law at the door: `gate-tally-name-len-bound-u32`
# answers 1 while a name fits and 0 past the wall. It does so by MEMORIZING the number --
# `?:  (gth sample 31)  0  1` -- while `tally/gardens.rye` holds the real declaration,
# `pub const max_name_len: u32 = 32`. The desk also states the law a second time, in the `invariant`
# line of its own head. That is three copies of one number in two languages.
#
# EVERY GUARD OVER THESE DESKS PROVES THE WRONG HALF. tools/t/tally_name_len_a1_gate_bound_witness.rish
# and its eleven siblings run the desk twice -- 12 answers 1, 40 answers 0 -- which proves the gate
# DECIDES on both sides of the wall it carries. Move `max_name_len` to 48 in Rye and every one of
# those witnesses stays green, because a wall at 31 still decides on both sides of itself. The Glow
# door would answer for a law the Rye module no longer holds, and nothing in this tree would say so.
#
# THE AGREEMENT IS REAL TODAY AND STORED WHERE A CHECK CANNOT STAND. Measured 20260915.183946 over
# seven desks and re-read 20260915.191259 over ELEVEN, each matches its Rye constant exactly. That is
# REDS %532's lesson one room over: three enumerations of one fact agreed perfectly, and the
# agreement lived in a person's memory. RUN the scan rather than trusting either figure -- the count
# is free and rises whenever a lane links one of its own.
#
# WHAT DECLARES THE LINK, and why the desk has to declare it rather than the scan guessing.
# `max_name_len` is declared in THIRTY-ONE tracked Rye modules at four different values -- 200 in
# amphora/manifest_entry.rye, 48 across caravan/, 64 in glow/tokens.rye, 32 in tally/gardens.rye --
# so a bare constant name identifies nothing. `wire_capacity` is sharper still: the only PUBLIC one
# reads 528 in comlink/wire_format.rye, while the gate named `aurora` mirrors the private
# `const wire_capacity: usize = 512` in aurora/src/posted.rye. A scan resolving by name alone would
# have reported that correct gate as a disagreement. So a desk names its own law, in its head, once:
#
#   ::  law        tally/gardens.rye max_name_len below
#
# Three fields: the file that declares it, the constant's name, and the RELATION the wall keeps to it.
# Everything else -- the constant's value, the head's restatement, the body literal -- is derived.
# One declaration, three derived readings, rather than three statements nobody compares.
#
# THE THREE RELATIONS, each present in the corpus today rather than invented for symmetry.
#
#   below    `?: (gth face N)` with N = const - 1. A capacity: the const counts slots, so the last
#            lawful value is one under it. Eight linked desks, among them name_len=32 walled at 31
#            and Skate's event ring, whose 128 seats wall at 127.
#   atmost   `?: (gth face N)` with N = const. A width: the const is itself lawful. Three linked
#            desks -- Skate's max_kind=8 and the two Lantern faces at max_face_text=38.
#   exact    `?: (eq face N)` with N = const. A count that must be met, never merely reached --
#            the shape the `-eq-u32` desks keep, among them mantra store dirs = 3. NO desk in this
#            tree declares it yet, since every eq desk's law is a field or variant count rather than
#            a constant; it is proven from both sides in the control's pen, and it is here so the
#            grammar answers the eq family on the lap one of them finds a constant to name.
#
# Two `gth` conventions live in this corpus and only the desk knows which it keeps, which is why the
# relation is declared rather than read off the operator. A scan deriving `below` from `gth` alone
# would refuse gate-comlink-addr-width-u32 for being right.
#
# WHAT IT READS. Every tracked *.glow whose first `?:` line compares a face against a NON-ZERO
# literal -- the fault shape read off the code rather than off the filename. A name-derived
# population (`*-bound-u32`, `*-eq-u32`) misses gate-comlink-addr-width-u32, which memorizes sixteen
# and matches neither pattern; reading the body finds it. A literal ZERO is passed over: `gth face 0`
# is the structural question "is this non-empty", which mirrors no module constant.
#
#   walls           gate desks memorizing a non-zero literal -- the whole population
#   linked          those carrying a `law` head line
#   unlinked        the remainder                                       -- RATCHET
#   law_unresolved  a linked desk whose named file or const is absent   -- GATED AT ZERO
#   law_malformed   a `law` line that is not <file> <const> <relation>  -- GATED AT ZERO
#   head_disagree   the head `invariant` number against the const       -- GATED AT ZERO
#   body_disagree   the body literal against what the relation implies  -- GATED AT ZERO
#   head_unstated   a linked desk whose invariant line states no number -- reported, never gated
#
# WHY unlinked IS A RATCHET AND THE OTHER FOUR ARE GATES. A wall that reds on a backlog no single
# lap can clear is a wall somebody turns off. The four gates read zero the moment this lands, so
# nothing has to be repaired for them to hold, and they make the fault unwritable from here: a desk
# linked tomorrow agrees with its Rye constant or reds on the lap it arrives.
#
# AND THE RATCHET IS AT ITS FLOOR, WHICH IS NOT ZERO. The seating lap called the remainder a
# backlog and priced it at "twenty-seven" while its own reading said eighteen -- a number written
# from memory beside a meter that was already answering. Read one desk at a time on 20260915.191259,
# after four more were linked, the remaining FOURTEEN sort into three kinds and NOT ONE of them can
# carry a `law` line as the grammar above stands:
#
#   five are not gate desks at all. glow/gen/i/{if-cue,if-gth,if-lent}.glow are generated language
#   examples whose `?:` compares a sample against 32, and tools/fixtures/g/gate-count-malformed.glow
#   and glow_core_unclosed_refuses.glow are planted fixtures another control reads. Each mirrors no
#   module law, so each is permanent floor. They stand in the population because the wall is read
#   off the BODY rather than off the path, which is the same choice that finds
#   gate-comlink-addr-width-u32; narrowing the reach to src/gate/ would buy a lower floor by
#   blinding the scan to a gate desk written anywhere else.
#
#   four are already held, against a law that is a struct's field count rather than a constant.
#   src/gate/gate-mantra-{line,weave,diff}-fields-eq-u32.glow and gate-mantra-store-dirs-eq-u32.glow
#   are each compared against their Rye struct by tools/fixtures/m/mantra_gate_constant_scan.sh over
#   tools/fixtures/r/rye_struct_fields_scan.sh, under tools/m/mantra_a1_equality_witness.rish. So
#   `unlinked` counts desks this scan does not hold, never desks nothing holds -- a distinction the
#   word itself invites a reader to miss.
#
#   five name a law with no plain-integer constant to point at. gate-comlink-addr-width-u32 mirrors
#   a seated shape and no Rye module declares an ipv6 address length at all; the two aurora length
#   desks mirror tally/kumara.rye's `seed_length` and `signature_length`, which are Ed25519
#   EXPRESSIONS that const_value returns empty for on purpose; gate-aurora-living-stages-eq-u32 and
#   gate-caravan-exit-meanings-eq-u32 mirror enum variant counts.
#
# So the ratchet falls again only when the law grammar learns a second kind of home -- a struct's
# field count, an enum's variant count, or a const whose value is an expression. That is a lap with
# a design behind it rather than a sweep, and naming the three shapes here is what a future lap
# builds against.
#
# WHY head_unstated IS REPORTED RATHER THAN GATED. An invariant line may state its law in words --
# "stays within sixteen bytes" -- which is honest English and carries no digits to compare. Refusing
# it would buy a rewrite of prose in exchange for nothing the body check does not already hold.
#
# WHAT IT DOES NOT REACH. Whether the Rye constant is the RIGHT law for that desk to mirror -- the
# `law` line is a declaration and this scan proves the three copies agree with it, never that the
# declaration names the correct home. And a law that is a field count rather than a constant stays
# unlinked by construction; see the ratchet above.
#
#   sh tools/fixtures/g/glow_gate_law_agree_scan.sh
#   sh tools/fixtures/g/glow_gate_law_agree_scan.sh --explain <desk.glow>

LC_ALL=C
export LC_ALL

# Root by upward walk (seated 20260828): the letter fold moves this script's depth, so fixed
# ../.. arithmetic breaks. Git-free, so a pen copy outside a repository still resolves.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_gl_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/src" ]; do
  _gl_steps=$((_gl_steps + 1))
  if [ "$_gl_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs tools/fixtures and src)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

EXPLAIN=
if [ "${1-}" = "--explain" ]; then
  EXPLAIN=${2-}
  [ -n "$EXPLAIN" ] || { echo "$0: --explain wants a desk path" >&2; exit 2; }
fi

# Bound: 451 tracked .glow files stood in the tree on 20260915 and the corpus grows by hand, a few
# desks a round. 4096 is a power of two an order of magnitude above that -- high enough never to
# refuse honest growth, low enough that a generator writing desks in a loop is named rather than
# scanned forever. The sibling reach scan carries the same bound for the same reason.
MAX_DESKS=4096

# The ratchet ceiling. It only falls: a lane that links one of its own desks lowers this in the
# same commit. Seated at 18 on 20260915.183946: 25 wall-memorizing desks minus the 7 linked on that
# lap. Lowered to 14 on 20260915.191259, when the two Skate walls and the two Lantern face walls
# took law lines and all three relations were proven to bite from the Rye side on metal.
UNLINKED_CEILING=${GLOW_GATE_UNLINKED_CEILING:-14}

work=$(mktemp -d "${TMPDIR:-/tmp}/glow_gate_law.XXXXXX") || exit 2
trap 'rm -rf "$work"' EXIT INT TERM

if [ -n "$EXPLAIN" ]; then
  printf '%s\n' "$EXPLAIN" > "$work/files.txt"
elif [ -n "${GLOW_GATE_DESK_LIST-}" ]; then
  cat "$GLOW_GATE_DESK_LIST" > "$work/files.txt"
else
  # Tracked files where a repository stands; a plain walk in a pen that has none.
  if git rev-parse --git-dir >/dev/null 2>&1; then
    git ls-files '*.glow' > "$work/files.txt"
  else
    # A walk reads every path standing on the disk, including the rooms git disowns -- `.lap/`
    # scratch, a parked worktree, `session-output/` -- so it can count a desk no clone will ever
    # hold (REDS %722's class). Ask git which of them it disowns rather than spelling a list; where
    # no repository stands the call answers nothing and the walk stands whole, which is the only
    # state this branch runs in.
    find . -name '*.glow' -type f | sed 's|^\./||' | sort > "$work/walk.txt"
    git check-ignore --stdin < "$work/walk.txt" > "$work/disowned.txt" 2>/dev/null || true
    # Read the disowned set in BEGIN rather than as a first FILENAME: an empty first file leaves
    # NR==FNR true on the SECOND file's first record, which swallows the whole walk and reads as a
    # tree holding no desks at all. That is the shape the pen caught, 23 legs at once.
    awk -v disowned="$work/disowned.txt" '
      BEGIN { while ((getline line < disowned) > 0) drop[line] = 1 }
      !($0 in drop)
    ' "$work/walk.txt" > "$work/files.txt"
  fi
fi

count=$(wc -l < "$work/files.txt" | tr -d ' ')
if [ "$count" -gt "$MAX_DESKS" ]; then
  echo "glow_gate_law_agree: $count .glow files past the bound of $MAX_DESKS" >&2
  exit 2
fi

# Read the value of `const <name>` or `pub const <name>` out of a Rye module. The declaration may
# carry a type (`pub const max_gardens: u32 = 8;`) or omit one (`const wire_capacity: usize = 512;`),
# and either way the value is what stands between `=` and `;`. A value that is not a plain decimal
# integer -- an expression, another constant, a std lookup -- returns empty and reads as unresolved,
# since comparing a Glow literal against `Ed25519.KeyPair.seed_length` is a question this scan
# cannot answer and must not guess at.
const_value() {
  _cv_file=$1
  _cv_name=$2
  [ -f "$_cv_file" ] || return 1
  awk -v name="$_cv_name" '
    {
      line = $0
      sub(/^[ \t]*/, "", line)
      if (line !~ /^(pub[ \t]+)?const[ \t]/) next
      probe = line
      sub(/^(pub[ \t]+)?const[ \t]+/, "", probe)
      decl = probe
      sub(/[ \t]*[:=].*$/, "", decl)
      if (decl != name) next
      rest = probe
      sub(/^[^=]*=[ \t]*/, "", rest)
      sub(/[ \t]*;.*$/, "", rest)
      gsub(/[ \t]/, "", rest)
      gsub(/_/, "", rest)
      if (rest ~ /^[0-9]+$/) { print rest; exit }
      exit
    }
  ' "$_cv_file"
}

walls=0
linked=0
unlinked=0
law_unresolved=0
law_malformed=0
head_disagree=0
body_disagree=0
head_unstated=0

while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue

  # The wall: the first `?:` line comparing a face against a literal. Read the operator and both
  # operands out of the one paren group, so a desk comparing two faces (the pair-bound family, which
  # takes its cap as a runtime argument and memorizes nothing) is passed over by the same reading
  # that finds the memorizers.
  body=$(grep -E '^\?:' "$f" | head -1)
  [ -n "$body" ] || continue
  parts=$(printf '%s\n' "$body" | sed -n 's/.*(\([a-z][a-z]*\)[ ][ ]*\([^ )][^ )]*\)[ ][ ]*\([^ )][^ )]*\)).*/\1 \2 \3/p')
  [ -n "$parts" ] || continue
  op=$(printf '%s' "$parts" | awk '{print $1}')
  rhs=$(printf '%s' "$parts" | awk '{print $3}')
  case "$rhs" in ''|*[!0-9]*) continue ;; esac
  [ "$rhs" != 0 ] || continue

  walls=$((walls + 1))

  law_line=$(grep -E '^::[ ]+law[ ]' "$f" | head -1)
  if [ -z "$law_line" ]; then
    unlinked=$((unlinked + 1))
    [ -n "$EXPLAIN" ] && echo "unlinked $f -- wall $op $rhs, no law line"
    continue
  fi
  linked=$((linked + 1))

  law_file=$(printf '%s\n' "$law_line" | awk '{print $3}')
  law_const=$(printf '%s\n' "$law_line" | awk '{print $4}')
  law_rel=$(printf '%s\n' "$law_line" | awk '{print $5}')
  law_extra=$(printf '%s\n' "$law_line" | awk '{print $6}')

  if [ -z "$law_file" ] || [ -z "$law_const" ] || [ -z "$law_rel" ] || [ -n "$law_extra" ]; then
    law_malformed=$((law_malformed + 1))
    echo "law_malformed $f -- wants: ::  law  <file> <const> below|atmost|exact"
    continue
  fi
  case "$law_rel" in
    below|atmost|exact) ;;
    *)
      law_malformed=$((law_malformed + 1))
      echo "law_malformed $f -- relation '$law_rel' is not below|atmost|exact"
      continue
      ;;
  esac

  law_value=$(const_value "$law_file" "$law_const")
  if [ -z "$law_value" ]; then
    law_unresolved=$((law_unresolved + 1))
    echo "law_unresolved $f -- $law_file declares no plain-integer const $law_const"
    continue
  fi

  case "$law_rel" in
    below)  want=$((law_value - 1)); want_op=gth ;;
    atmost) want=$law_value;         want_op=gth ;;
    exact)  want=$law_value;         want_op=eq  ;;
  esac

  if [ "$op" != "$want_op" ] || [ "$rhs" != "$want" ]; then
    body_disagree=$((body_disagree + 1))
    echo "body_disagree $f -- wall is ($op face $rhs); $law_file $law_const=$law_value $law_rel wants ($want_op face $want)"
  fi

  # The head's own restatement. The invariant line carries the law as <word>=<digits>; a line that
  # states it in words instead carries no digits and is reported rather than refused.
  head_value=$(grep -E '^::[ ]+invariant' "$f" | head -1 | sed -n 's/.*[a-zA-Z_-]=\([0-9][0-9]*\).*/\1/p')
  if [ -z "$head_value" ]; then
    head_unstated=$((head_unstated + 1))
  elif [ "$head_value" != "$law_value" ]; then
    head_disagree=$((head_disagree + 1))
    echo "head_disagree $f -- invariant says $head_value; $law_file $law_const=$law_value"
  fi

  [ -n "$EXPLAIN" ] && echo "linked $f -- $law_file $law_const=$law_value $law_rel; wall ($op face $rhs); head ${head_value:-unstated}"
done < "$work/files.txt"

verdict=ok
[ "$law_malformed" -eq 0 ] || verdict=law_malformed
[ "$law_unresolved" -eq 0 ] || verdict=law_unresolved
[ "$head_disagree" -eq 0 ] || verdict=head_disagree
[ "$body_disagree" -eq 0 ] || verdict=body_disagree
[ "$unlinked" -le "$UNLINKED_CEILING" ] || verdict=unlinked_over

echo "walls=$walls"
echo "linked=$linked"
echo "unlinked=$unlinked"
echo "unlinked_ceiling=$UNLINKED_CEILING"
echo "law_malformed=$law_malformed"
echo "law_unresolved=$law_unresolved"
echo "head_disagree=$head_disagree"
echo "body_disagree=$body_disagree"
echo "head_unstated=$head_unstated"
echo "verdict=$verdict"

[ "$verdict" = ok ] || exit 1
exit 0
