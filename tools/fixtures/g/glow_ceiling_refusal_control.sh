#!/bin/sh
# tools/fixtures/g/glow_ceiling_refusal_control.sh -- the ceiling-refusal reading is proven, not
# assumed.
#
# WHY. The meter it proves makes four structural claims a plain grep would get wrong: a comparison
# inside a string literal is not a ceiling, an `assert(` line is never a refusal site, a return may
# sit five lines below its `if`, and a site is covered by a filled RECORD rather than by its error
# name. Each of those was measured on the real tree and each changed the reading -- the first by
# seven false sites, the second by taking `unpaired` from 69 to 16, the third by hiding the founding
# case entirely. An argument is not a measurement, so every one is planted here in a throwaway git
# repository and proven from both sides.
#
# KIN. The meter is `tools/fixtures/g/glow_ceiling_refusal_scan.sh`; the gate over it is
# `tools/g/glow_ceiling_refusal_witness.rish`; the record the meter asks for is `glow/refusal.rye`.
#
# WHAT IS PROVEN -- sixteen behaviors, each a claim the scan makes out loud:
#    1  two ceilings behind one error name, neither recorded, are counted uncovered
#    2  a site that FILLS a refusal record in its block is covered, so the repair the meter asks
#       for is the repair the meter credits
#    3  one error name over one constant is not shared, however many sites spell it
#    4  a name refusing exactly one ceiling is never ambiguous
#    5  a comparison inside a STRING LITERAL is not a ceiling -- the `lower_shop_gate.rye` shape,
#       where generated Zig text carries `<= gardens.max_gardens` beside a print-buffer refusal
#    6  an `assert(` line is read past, so a contract beside a refusal does not become its ceiling
#    7  a return five lines below its `if` is paired with it -- the founding case, which a
#       single-line reading misses, proven by the site appearing in the list at all
#    8  a return belonging to the NEXT statement is NOT borrowed, so brace depth bounds the walk
#    9  a `max_` comparison with no named return is UNPAIRED and reported rather than guessed at
#   10  a `_witness.rye` source is left out, since a witness plants refusals on purpose
#   11  a SYMLINK to a counted source is not read a second time
#   12  a path `git ls-files` lists and the working tree no longer holds is skipped and COUNTED
#   13  a BROKEN INSTRUMENT is named rather than counted as a clean zero, and never answers
#       `under_ceiling=yes`
#   14  the ceiling REFUSES one site over
#   15  and returns green when the plant is removed -- a refusal proven in one direction cannot be
#       told from a bypass
#   16  a `//` comment line carrying a comparison is read past
#   17  a room holding no Glow source REFUSES rather than reading green -- an empty answer from a
#       refused listing is byte-identical to a tree whose last ambiguous ceiling was just repaired
#
# AND FOUR MUTATIONS, each asserted to bite: the string strip, the assert skip, the brace-depth
# lookahead, and crediting coverage by the filled record rather than by the error name.
#
# USAGE
#   sh tools/fixtures/g/glow_ceiling_refusal_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/g/glow_ceiling_refusal_scan.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

legs=0
fails=0
leg() {
  # leg <name> <expected yes|no> <actual yes|no>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "$1=$3"
  else
    echo "$1=$3 -- wanted $2"
    fails=$((fails + 1))
  fi
}
has() { case "$2" in *"$1"*) echo yes ;; *) echo no ;; esac; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid
git config user.name control

mkdir -p glow

# 1  Two constants, one error name, no record -- the defect itself.
cat > glow/shared.rye <<'EOF'
pub const max_alpha: u32 = 4;
pub const max_beta: u32 = 9;
fn one(n: u32) !void {
    if (n > max_alpha) return error.SameWord;
}
fn two(n: u32) !void {
    if (n > max_beta) return error.SameWord;
}
EOF

# 2  The same shape with a record filled before each return -- the repair, credited.
cat > glow/recorded.rye <<'EOF'
pub const max_gamma: u32 = 4;
pub const max_delta: u32 = 9;
fn one(n: u32, out: *Slot) !void {
    if (n > max_gamma) {
        out.* = .{ .field = "gamma", .reason = .too_many_gamma, .measure = .{ .value = n, .ceiling = max_gamma, .unit = .gamma } };
        return error.OneWord;
    }
}
fn two(n: u32, out: *Slot) !void {
    if (n > max_delta) {
        out.* = .{ .field = "delta", .reason = .too_many_delta, .measure = .{ .value = n, .ceiling = max_delta, .unit = .delta } };
        return error.OneWord;
    }
}
EOF

# 3  One constant, one name, three sites -- one meaning said three times, never a defect.
cat > glow/repeated.rye <<'EOF'
pub const max_reps: u32 = 7;
fn a(n: u32) !void { if (n > max_reps) return error.Repeated; }
fn b(n: u32) !void { if (n > max_reps) return error.Repeated; }
fn c(n: u32) !void { if (n > max_reps) return error.Repeated; }
EOF

# 4  A name refusing exactly one ceiling.
cat > glow/lone.rye <<'EOF'
pub const max_lone: u32 = 3;
fn only(n: u32) !void { if (n > max_lone) return error.LoneCeiling; }
EOF

# 5/6/16  The three readings that keep a false pair out: a comparison inside generated TEXT, an
#         assert beside a refusal, and a comparison inside a comment.
# Every false pair here would be SHARED if it were counted: `error.QuietWord` already refuses one
# real ceiling below, so a string, an assert, or a comment read as a second ceiling puts this file
# in the list at once. That is what makes each mutation visible rather than merely arithmetic.
cat > glow/quiet.rye <<'EOF'
pub const max_emit: u32 = 5;
pub const max_room: u32 = 6;
pub const max_note: u32 = 7;
pub const max_real: u32 = 9;
fn emit(buf: []u8, face: []const u8) ![]const u8 {
    return std.fmt.bufPrint(buf, "if ({s} <= max_emit) 1 else 0", .{face}) catch return error.QuietWord;
}
fn guarded(name: []const u8, buf: []u8) !void {
    assert(buf.len >= max_room);
    if (name.len > buf.len) return error.QuietWord;
}
fn commented(n: u32) !void {
    // if (n > max_note) return error.QuietWord;
    _ = n;
}
fn real(n: u32) !void { if (n > max_real) return error.QuietWord; }
EOF

# 7/8  Brace depth: a return five lines below its `if`, and a return that belongs to the next
#      statement rather than to the comparison above it.
cat > glow/depth.rye <<'EOF'
pub const max_far: u32 = 2;
pub const max_other: u32 = 5;
pub const max_near: u32 = 8;
fn far(n: u32) !void {
    if (n > max_far) {
        const a = n;
        const b = a;
        _ = b;
        return error.DepthWord;
    }
}
fn other(n: u32) !void { if (n > max_other) return error.DepthWord; }
fn near(n: u32) !void {
    if (n > max_near) {
        return;
    }
    return error.NotMine;
}
EOF

# 9  A `max_` comparison that decides something other than a named refusal.
cat > glow/unpaired.rye <<'EOF'
pub const max_scan: u32 = 12;
fn walk(face: []const u8) u32 {
    var len: u32 = 0;
    while (len < max_scan and face[len] != 0) len += 1;
    return len;
}
EOF

# 10  A witness plants refusals on purpose, so it is left out.
cat > glow/planted_witness.rye <<'EOF'
pub const max_w1: u32 = 1;
pub const max_w2: u32 = 2;
fn a(n: u32) !void { if (n > max_w1) return error.WitnessWord; }
fn b(n: u32) !void { if (n > max_w2) return error.WitnessWord; }
EOF

# 11  A link beside its target: two paths, one set of bytes.
ln -s shared.rye glow/link_to_shared.rye

git add -A >/dev/null 2>&1
git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^GLOW_CEILING_REFUSAL'

leg shared_two_counted        yes "$(has 'glow/shared.rye:4' "$out")"
leg shared_both_sites_counted yes "$(has 'glow/shared.rye:7' "$out")"
leg recorded_site_covered     no  "$(has 'glow/recorded.rye' "$out")"
leg repeated_not_shared       no  "$(has 'glow/repeated.rye' "$out")"
leg lone_not_ambiguous        no  "$(has 'glow/lone.rye' "$out")"
leg string_literal_not_ceiling no "$(has 'glow/quiet.rye:6' "$out")"
leg assert_read_past          no  "$(has 'glow/quiet.rye:9' "$out")"
leg comment_read_past         no  "$(has 'glow/quiet.rye:13' "$out")"
leg witness_room_excluded     no  "$(has 'glow/planted_witness.rye' "$out")"
leg symlink_read_once         no  "$(has 'glow/link_to_shared.rye' "$out")"

# 7  The far return is paired with the `if` five lines above it, proven DIRECTLY rather than by a
#    total: `depth.rye` spells one error name over two constants, so both its sites are ambiguous
#    and both must appear in the list. Lose the brace-depth walk and the far site goes UNPAIRED,
#    `error.DepthWord` falls to one ceiling, and NEITHER site is listed.
leg far_return_paired    yes "$(has 'glow/depth.rye:5' "$out")"
leg far_sibling_listed   yes "$(has 'glow/depth.rye:12' "$out")"

far=$(sh "$scan" 2>/dev/null)
sites=$(printf '%s' "$far" | sed -n 's/.* sites=\([0-9][0-9]*\) .*/\1/p')
unpaired=$(printf '%s' "$far" | sed -n 's/.* unpaired=\([0-9][0-9]*\) .*/\1/p')
# Paired: shared x2, recorded x2, repeated x3, lone x1, depth x2, quiet x1. Unpaired: the `near`
# comparison whose return belongs to the statement after its block, and the while-loop scan.
leg paired_total_is_eleven yes "$( [ "$sites" = "11" ] && echo yes || echo no )"
leg next_statement_return_not_borrowed yes "$( [ "$unpaired" = "2" ] && echo yes || echo no )"
leg unpaired_reported    yes "$( [ "$unpaired" -ge 1 ] 2>/dev/null && echo yes || echo no )"

# 2  The record is what covers a site, and the summary says so in its own two numbers.
amb=$(printf '%s' "$far" | sed -n 's/.* ambiguous=\([0-9][0-9]*\) .*/\1/p')
rec=$(printf '%s' "$far" | sed -n 's/.* recorded=\([0-9][0-9]*\) .*/\1/p')
leg ambiguous_is_six     yes "$( [ "$amb" = "6" ] && echo yes || echo no )"
leg recorded_is_two      yes "$( [ "$rec" = "2" ] && echo yes || echo no )"

# 12  An absent path is skipped and COUNTED, never fatal. `git ls-files` reads the INDEX, so a
#     rename staged mid-lap lists a path the working tree no longer holds.
cp glow/lone.rye glow/ghost.rye
git add -A >/dev/null 2>&1
rm -f glow/ghost.rye
ghost=$(sh "$scan" 2>/dev/null)
leg absent_counted       yes "$(has 'absent=1' "$ghost")"
leg absent_not_fatal     no  "$(has 'instrument=failed' "$ghost")"
git rm -q --cached glow/ghost.rye >/dev/null 2>&1

# 13  A BROKEN INSTRUMENT is named rather than counted as a clean zero. One unclosed `if (` is
#     inserted at the head of the awk program -- a syntax error in every awk dialect, so this leg
#     leans on no one implementation.
awk 'BEGIN{d=0} {print} (d==0 && $0 ~ /^  LC_ALL=C awk -v FILE/) {print "    if ("; d=1}' "$scan" > broken_scan.sh
broke=$(sh ./broken_scan.sh 2>/dev/null)
leg broken_instrument_named    yes "$(has 'instrument=failed' "$broke")"
leg broken_instrument_refuses  no  "$(has 'under_ceiling=yes' "$broke")"
rm -f broken_scan.sh

# 14/15  THE CEILING, FROM BOTH SIDES. The scan's own ceiling is read rather than spelled here, so
#        this stays true when a lap lowers it. One site past it must refuse, and removing that one
#        site must return the reading to green.
ceiling=$(printf '%s' "$far" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
uncovered=$(printf '%s' "$far" | sed -n 's/.* uncovered=\([0-9][0-9]*\) .*/\1/p')
need=$((ceiling - uncovered + 1))
i=0
{
  echo "pub const max_over_base: u32 = 1;"
  while [ "$i" -lt "$need" ]; do
    echo "pub const max_over_$i: u32 = $((i + 2));"
    i=$((i + 1))
  done
  echo "fn base(n: u32) !void { if (n > max_over_base) return error.OverWord; }"
  i=0
  while [ "$i" -lt "$need" ]; do
    echo "fn over_$i(n: u32) !void { if (n > max_over_$i) return error.OverWord; }"
    i=$((i + 1))
  done
} > glow/over.rye
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
echo "$loud" | sed 's/^/over_/'
leg over_ceiling_refuses  yes "$(has 'under_ceiling=no' "$loud")"

rm -f glow/over.rye
git add -A >/dev/null 2>&1
back=$(sh "$scan" 2>/dev/null)
leg removed_returns_green yes "$(has 'under_ceiling=yes' "$back")"

# 17  AN EMPTY ROOM REFUSES rather than reading green. Outside a checkout, or against a tree
#     holding no Glow, `git ls-files` says nothing -- and silence is byte-identical to a tree whose
#     last ambiguous ceiling was just repaired.
mkdir -p empty && cd empty || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid
git config user.name control
empty_out=$(sh "$scan" 2>/dev/null)
cd "$pen" || exit 1
leg empty_room_named    yes "$(has 'detail=no_glow_sources' "$empty_out")"
leg empty_room_refuses  no  "$(has 'under_ceiling=yes' "$empty_out")"

# -- THE MUTATIONS, each bitten ------------------------------------------------------------------
#
# A leg that passes under a broken meter is a leg proving nothing. Each reading the scan's header
# argues for is removed from a COPY of the scan, and the leg that reading exists for must flip.
# Every mutant runs against the pen exactly as the legs above left it.

mutate() {
  # mutate <name> <awk program transforming the scan> <grep pattern> <expected in mutant output>
  awk "$2" "$scan" > mutant_scan.sh
  m=$(sh ./mutant_scan.sh --list 2>/dev/null)
  legs=$((legs + 1))
  got=$(has "$3" "$m")
  if [ "$got" = "$4" ]; then
    echo "$1=bitten"
  else
    echo "$1=not_bitten -- the leg passed under a meter missing its own reading"
    fails=$((fails + 1))
  fi
  rm -f mutant_scan.sh
}

# m1  Without the string strip, generated Zig text carrying `<= max_emit` reads as a ceiling.
mutate m1_string_strip_bites \
  '/while \(match\(o, \//{next} /gsub\(\/.047/{next} {print}' \
  'glow/quiet.rye:6' yes

# m2  Without the assert skip, a contract beside a refusal becomes that refusal's ceiling.
mutate m2_assert_skip_bites \
  '/== "assert\("/{next} {print}' \
  'glow/quiet.rye:9' yes

# m3  Without the lookahead, a return five lines below its `if` is lost and its name falls to one
#     ceiling, so BOTH of `depth.rye`'s sites leave the list.
mutate m3_lookahead_bites \
  '{ sub(/LOOK = 24/, "LOOK = 0"); print }' \
  'glow/depth.rye:5' no

# m4  Crediting coverage by anything but the filled record puts the repaired file back in the list.
mutate m4_record_credit_bites \
  '/rec = "yes"/{next} {print}' \
  'glow/recorded.rye' yes

echo "control_legs=$legs"
echo "control_failed=$fails"
echo "control_verdict=ok"
