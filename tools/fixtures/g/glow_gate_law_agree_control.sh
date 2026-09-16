#!/bin/sh
# tools/fixtures/g/glow_gate_law_agree_control.sh -- prove the law-agreement scan on planted desks.
#
# Builds miniature desk rooms in a throwaway pen and asserts every reading of
# tools/fixtures/g/glow_gate_law_agree_scan.sh from BOTH sides: each refusal is planted and then
# lifted, and each welcome is asserted as hard as each refusal. A refusal proven only in the
# passing direction cannot be told from a bypass.
#
#   sh tools/fixtures/g/glow_gate_law_agree_control.sh

LC_ALL=C
export LC_ALL

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_gc_steps=0
while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/src" ]; do
  _gc_steps=$((_gc_steps + 1))
  if [ "$_gc_steps" -gt 8 ] || [ "$ROOT" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

SCAN_SRC="$ROOT/tools/fixtures/g/glow_gate_law_agree_scan.sh"
pen=$(mktemp -d "${TMPDIR:-/tmp}/glow_gate_law_pen.XXXXXX") || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() { # leg <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg ok      $1"
  else
    failed=$((failed + 1))
    echo "leg FAILED  $1 -- wanted '$2', read '$3'"
  fi
}

# The pen needs the two directories the scan walks up to find, so a copy of the scan run from
# inside it resolves its own root rather than this tree's.
mkdir -p "$pen/tools/fixtures/g" "$pen/src" "$pen/mod"

# The scan is COPIED into the pen rather than called out of the tree. Its root is found by walking
# up from its own $0, so a tree copy invoked with the pen as the working directory resolves to this
# repository and measures it -- which is what the first draft of this control did, reading walls=25
# from a pen holding nothing. A copy at the same relative depth walks up to the pen instead.
cp "$SCAN_SRC" "$pen/tools/fixtures/g/glow_gate_law_agree_scan.sh"
SCAN="tools/fixtures/g/glow_gate_law_agree_scan.sh"

# The two sibling readers ride in for the same reason. A `law` line naming `<Type>.fields` or
# `<Type>.variants` sends the scan to rye_struct_fields_scan.sh or rye_enum_variants_scan.sh
# through its OWN root, which inside the pen is the pen -- so a pen missing them would read every
# such law as unresolved and the legs below would pass for the wrong reason.
mkdir -p "$pen/tools/fixtures/r"
cp "$ROOT/tools/fixtures/r/rye_struct_fields_scan.sh"  "$pen/tools/fixtures/r/"
cp "$ROOT/tools/fixtures/r/rye_enum_variants_scan.sh"  "$pen/tools/fixtures/r/"

read_key() { # read_key <output> <key>
  printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1
}

# desk <path> <op> <literal> [<law line body>] [<invariant number>]
desk() {
  _d_path=$pen/$1
  mkdir -p "$(dirname "$_d_path")"
  {
    echo "::  name       planted gate"
    if [ -n "${5-}" ]; then
      echo "::  invariant  answers 1 while it stays within wall=$5; answers 0 past it"
    else
      echo "::  invariant  answers 1 while it stays within the stated wall; answers 0 past it"
    fi
    [ -n "${4-}" ] && echo "::  law        $4"
    echo "::  readers    planted"
    echo "|=  sample=@u32"
    echo "?:  ($2 sample $3)  0  1"
  } > "$_d_path"
}

run_scan() {
  ( cd "$pen" && GLOW_GATE_UNLINKED_CEILING="${1:-0}" sh "$SCAN" 2>&1 )
}

# ---- 1. an empty room reads zero everywhere, and passes ----------------------
out=$(run_scan 0); code=$?
leg "empty room walls"           0  "$(read_key "$out" walls)"
leg "empty room verdict"         ok "$(read_key "$out" verdict)"
leg "empty room exit"            0  "$code"

# ---- 2. the population is read off the BODY, not the filename ----------------
# A file named nothing like a gate still counts when it memorizes a literal; a desk comparing two
# faces (the pair-bound cure) never does; and a literal zero is a structural question, not a law.
desk mod/nothing-like-a-gate.glow gth 31
desk src/pair.glow gth cap
mkdir -p "$pen/src"
{
  echo "::  name       planted zero gate"
  echo "::  invariant  answers 1 while non-empty"
  echo "|=  sample=@u32"
  echo "?:  (gth sample 0)  0  1"
} > "$pen/src/zero.glow"
out=$(run_scan 1)
leg "wall read off body"         1 "$(read_key "$out" walls)"
leg "face-vs-face is no wall"    1 "$(read_key "$out" unlinked)"
rm -f "$pen/src/pair.glow" "$pen/src/zero.glow" "$pen/mod/nothing-like-a-gate.glow"

# ---- 3. a wall with no law line is unlinked, and the ratchet bites both ways --
desk src/unlinked.glow gth 31
out=$(run_scan 1)
leg "unlinked counted"           1  "$(read_key "$out" unlinked)"
leg "unlinked under ceiling ok"  ok "$(read_key "$out" verdict)"
out=$(run_scan 0); code=$?
leg "unlinked over ceiling"      unlinked_over "$(read_key "$out" verdict)"
leg "unlinked over exits 1"      1  "$code"
rm -f "$pen/src/unlinked.glow"

# ---- 4. below: a linked desk agreeing, and each way it can disagree ----------
printf 'pub const wall: u32 = 32;\n' > "$pen/mod/law.rye"
desk src/below.glow gth 31 "mod/law.rye wall below" 32
out=$(run_scan 0)
leg "below agrees linked"        1  "$(read_key "$out" linked)"
leg "below agrees body"          0  "$(read_key "$out" body_disagree)"
leg "below agrees head"          0  "$(read_key "$out" head_disagree)"
leg "below agrees verdict"       ok "$(read_key "$out" verdict)"

# The Rye constant moves and the desk does not -- the whole reason this scan exists. Every
# sibling gate witness stays green through this, because a wall at 31 still decides on both
# sides of itself.
printf 'pub const wall: u32 = 48;\n' > "$pen/mod/law.rye"
out=$(run_scan 0); code=$?
leg "const moved: body reds"     1  "$(read_key "$out" body_disagree)"
leg "const moved: head reds"     1  "$(read_key "$out" head_disagree)"
leg "const moved: verdict"       body_disagree "$(read_key "$out" verdict)"
leg "const moved: exits 1"       1  "$code"
printf 'pub const wall: u32 = 32;\n' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "lifted: back to ok"         ok "$(read_key "$out" verdict)"

# The body alone drifts, head still right.
desk src/below.glow gth 30 "mod/law.rye wall below" 32
out=$(run_scan 0)
leg "body drift counted"         1 "$(read_key "$out" body_disagree)"
leg "body drift leaves head"     0 "$(read_key "$out" head_disagree)"
leg "body drift verdict"         body_disagree "$(read_key "$out" verdict)"

# The head alone drifts, body still right.
desk src/below.glow gth 31 "mod/law.rye wall below" 48
out=$(run_scan 0)
leg "head drift counted"         1 "$(read_key "$out" head_disagree)"
leg "head drift leaves body"     0 "$(read_key "$out" body_disagree)"
leg "head drift verdict"         head_disagree "$(read_key "$out" verdict)"

# An invariant stating its law in words carries no digits: reported, never refused.
desk src/below.glow gth 31 "mod/law.rye wall below"
out=$(run_scan 0)
leg "head in words reported"     1  "$(read_key "$out" head_unstated)"
leg "head in words passes"       ok "$(read_key "$out" verdict)"
rm -f "$pen/src/below.glow"

# ---- 5. atmost and exact, each proven from both sides ------------------------
# Two gth conventions live in the corpus, so the relation is declared rather than read off the
# operator. atmost with the SAME operator and const wants a different literal than below.
desk src/atmost.glow gth 16 "mod/law.rye wall atmost" 16
printf 'pub const wall: u32 = 16;\n' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "atmost agrees"              ok "$(read_key "$out" verdict)"
desk src/atmost.glow gth 15 "mod/law.rye wall atmost" 16
out=$(run_scan 0)
leg "atmost refuses below form" body_disagree "$(read_key "$out" verdict)"
rm -f "$pen/src/atmost.glow"

desk src/exact.glow eq 3 "mod/law.rye wall exact" 3
printf 'pub const wall: u32 = 3;\n' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "exact agrees"               ok "$(read_key "$out" verdict)"
desk src/exact.glow gth 3 "mod/law.rye wall exact" 3
out=$(run_scan 0)
leg "exact refuses gth"          body_disagree "$(read_key "$out" verdict)"
rm -f "$pen/src/exact.glow"

# ---- 6. the law line itself refuses when it cannot be read -------------------
printf 'pub const wall: u32 = 32;\n' > "$pen/mod/law.rye"
desk src/mal.glow gth 31 "mod/law.rye wall" 32
out=$(run_scan 0)
leg "law missing relation"       law_malformed "$(read_key "$out" verdict)"
desk src/mal.glow gth 31 "mod/law.rye wall sideways" 32
out=$(run_scan 0)
leg "law unknown relation"       law_malformed "$(read_key "$out" verdict)"
desk src/mal.glow gth 31 "mod/law.rye wall below extra" 32
out=$(run_scan 0)
leg "law trailing word"          law_malformed "$(read_key "$out" verdict)"
rm -f "$pen/src/mal.glow"

desk src/unres.glow gth 31 "mod/absent.rye wall below" 32
out=$(run_scan 0)
leg "absent law file"            law_unresolved "$(read_key "$out" verdict)"
desk src/unres.glow gth 31 "mod/law.rye nosuch below" 32
out=$(run_scan 0)
leg "absent law const"           law_unresolved "$(read_key "$out" verdict)"

# A const whose value is an expression rather than a plain integer cannot be compared, and reads
# unresolved rather than being guessed at. This is what keeps the scan off kumara's
# `pub const seed_length = Ed25519.KeyPair.seed_length;`.
printf 'pub const wall: u32 = Other.length;\n' > "$pen/mod/law.rye"
desk src/unres.glow gth 31 "mod/law.rye wall below" 32
out=$(run_scan 0)
leg "derived const unresolved"   law_unresolved "$(read_key "$out" verdict)"
rm -f "$pen/src/unres.glow"

# ---- 7. the const reader takes each declaration spelling this tree writes ----
# pub with a type, bare const with a type, and an underscored literal.
printf 'pub const wall: u32 = 32;\n' > "$pen/mod/law.rye"
desk src/spell.glow gth 31 "mod/law.rye wall below" 32
out=$(run_scan 0)
leg "pub const with type"        ok "$(read_key "$out" verdict)"
printf 'const wall: usize = 32;\n' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "bare const with type"       ok "$(read_key "$out" verdict)"
printf 'pub const wall: u64 = 9_000_000_001;\n' > "$pen/mod/law.rye"
desk src/spell.glow gth 9000000000 "mod/law.rye wall below" 9000000001
out=$(run_scan 0)
leg "underscored literal"        ok "$(read_key "$out" verdict)"
# A near-miss name must not answer for the one asked about.
printf 'pub const wall_other: u32 = 99;\npub const wall: u32 = 32;\n' > "$pen/mod/law.rye"
desk src/spell.glow gth 31 "mod/law.rye wall below" 32
out=$(run_scan 0)
leg "prefix name not matched"    ok "$(read_key "$out" verdict)"
rm -f "$pen/src/spell.glow"

# ---- 8. the second home: a struct's field count -----------------------------
# `<Type>.fields` sends the law to rye_struct_fields_scan.sh. A dot can never appear in a Zig
# identifier, so the suffix can never be mistaken for a constant's own name -- proven below by
# a const named `Shape` standing beside the struct and never answering for `Shape.fields`.
cat > "$pen/mod/law.rye" <<'RYE'
pub const Shape = struct {
    text: []const u8,
    gen: u32,
    pos: u32,
};
RYE
desk src/fields.glow eq 3 "mod/law.rye Shape.fields exact" 3
out=$(run_scan 0)
leg "struct fields linked"       ok "$(read_key "$out" verdict)"
leg "struct fields counted"      1  "$(read_key "$out" linked)"

# The struct grows a field and the desk does not -- the whole reason the home exists. Every
# sibling gate witness stays green through this, because a wall at 3 still decides on both sides.
cat > "$pen/mod/law.rye" <<'RYE'
pub const Shape = struct {
    text: []const u8,
    gen: u32,
    pos: u32,
    site: u32,
};
RYE
out=$(run_scan 0)
leg "struct grew, body reds"     body_disagree "$(read_key "$out" verdict)"

# A `///` doc comment between fields is read past rather than ending the block, so a documented
# struct counts the same as a bare one. Without this the reader answers 1 and the desk reds.
cat > "$pen/mod/law.rye" <<'RYE'
pub const Shape = struct {
    text: []const u8,
    /// Why this one exists, as TAME asks of a surprising field.
    gen: u32,
    pos: u32,
};
RYE
out=$(run_scan 0)
leg "doc comment read past"      ok "$(read_key "$out" verdict)"

# An absent struct resolves to nothing rather than to zero, and lands in law_unresolved.
printf 'pub const Other = struct {
    a: u32,
};
' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "absent struct unresolved"   law_unresolved "$(read_key "$out" verdict)"
rm -f "$pen/src/fields.glow"

# ---- 9. the third home: an enum's variant count ------------------------------
printf 'pub const Meaning = enum { answered, stopped, fallen };
' > "$pen/mod/law.rye"
desk src/variants.glow eq 3 "mod/law.rye Meaning.variants exact" 3
out=$(run_scan 0)
leg "enum variants linked"       ok "$(read_key "$out" verdict)"

# The enum grows a variant and the desk does not.
printf 'pub const Meaning = enum { answered, stopped, fallen, deferred };
' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "enum grew, body reds"       body_disagree "$(read_key "$out" verdict)"

# The many-line spelling counts the same as the one-line one.
cat > "$pen/mod/law.rye" <<'RYE'
pub const Meaning = enum {
    /// The dependent answered.
    answered,
    stopped,
    fallen,
};
RYE
out=$(run_scan 0)
leg "many-line enum counted"     ok "$(read_key "$out" verdict)"

# A tagged enum's backing type is not a variant, and a `= <n>` tag value is not a name.
printf 'pub const Meaning = enum(u8) { answered = 1, stopped = 2, fallen = 4 };
' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "tagged enum counted"        ok "$(read_key "$out" verdict)"

# An absent enum resolves to nothing rather than to zero.
printf 'pub const Other = enum { a, b, c };
' > "$pen/mod/law.rye"
out=$(run_scan 0)
leg "absent enum unresolved"     law_unresolved "$(read_key "$out" verdict)"

# A kind suffix pointed at the wrong kind refuses rather than reaching for the other reader:
# the enum is really an enum, so `.fields` finds no struct and the law stays unresolved.
printf 'pub const Meaning = enum { answered, stopped, fallen };
' > "$pen/mod/law.rye"
desk src/wrongkind.glow eq 3 "mod/law.rye Meaning.fields exact" 3
out=$(run_scan 0)
leg "wrong kind unresolved"      law_unresolved "$(read_key "$out" verdict)"
rm -f "$pen/src/wrongkind.glow" "$pen/src/variants.glow"

echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=failed"
exit 1
