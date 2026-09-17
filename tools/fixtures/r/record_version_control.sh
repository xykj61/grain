#!/bin/sh
# tools/fixtures/r/record_version_control.sh -- the record-version reading, proven on real Rye
# sources in a throwaway pen.
#
# WHY A CONTROL. tools/fixtures/r/record_version_scan.sh ratchets the count of record families
# whose header still carries a counted version, and the whole instrument is its DISCRIMINATOR: a
# record version is a string reaching stored bytes as a format or header field, and a string that
# merely looks like one is no version at all. A classifier nobody has tried to fool is a hope. So
# every class is shown from both sides -- the honest form is counted, the look-alike is planted and
# declines, and each load-bearing step is removed to prove it bites.
#
# THE PEN IS A REAL GIT REPOSITORY, because the scan reads its corpus with `git ls-files`. A pen of
# loose files would read as an empty tree, which is a refusal the scan already gives for its own
# reason -- so the pen would agree with the guard for the wrong reason.
#
# THE MUTATIONS, and each is a step a reader would call decoration:
#   M1  the trailing-newline fold. A header written into a buffer carries `\n` inside its literal,
#       and that write is the site that puts bytes in a store. Remove the fold and the chronological
#       family is seen at its COMPARE and missed at its WRITE.
#   M2  the comment strip. Remove it and a version named in prose is counted as a live header.
#   M3  the unclassified decline. Fold look-alikes back in and the family count rises on strings
#       that reach no store at all -- REDS %765's own figure, re-derived.
#   M4  the fixtures exclusion. Remove it and a pen plant's deliberate `amphora-v2` becomes a real
#       record family, so the guard would red on a control doing its job.
#
# Run from the repository root.

set -f

root="$(pwd)"
scan="$root/tools/fixtures/r/record_version_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=broken"; echo "detail: $scan is absent"; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

legs=0
fail=0
ok() { legs=$((legs + 1)); echo "$1 -- ok"; }
no() { legs=$((legs + 1)); fail=$((fail + 1)); echo "$1 -- FAILED"; }

make_pen() {
  _pen="$1"
  mkdir -p "$_pen/room" "$_pen/.lap"
  ( cd "$_pen" && git init -q . && git config user.email pen@example.invalid \
      && git config user.name pen ) >/dev/null 2>&1
}

stage() { ( cd "$1" && git add -A ) >/dev/null 2>&1; }

read_scan() { ( cd "$1" && sh "$2" 2>&1 ); }

field() { printf '%s\n' "$1" | sed -n "s/.*$2=\([0-9]*\).*/\1/p" | head -1; }

# A scan copy whose ceiling is set to a named number, so a pen never argues with the tree's own.
pen_scan() {
  sed "s/^CEILING=.*/CEILING=$2/" "$scan" > "$1/scan.sh"
  echo "$1/scan.sh"
}

# ---------------------------------------------------------------------------
# The one pen, holding every class at once: three honest record sites in three counted families,
# one chronological family written and compared, one domain tag, and four look-alikes.
pen="$work/pen"
make_pen "$pen"

cat > "$pen/room/declared.rye" <<'EOF'
const std = @import("std");
pub const vessel_format = "penvessel-v1";
EOF

cat > "$pen/room/written.rye" <<'EOF'
const std = @import("std");
fn write_it(out: *Buf, off: *u32) !void {
    try append_kv(out, off, "format", "penlisting-v2");
}
EOF

cat > "$pen/room/compared.rye" <<'EOF'
const std = @import("std");
fn read_it(format: ?[]const u8) !void {
    if (!std.mem.eql(u8, format.?, "penfact-v1")) return error.BadFormat;
}
EOF

cat > "$pen/room/chrono.rye" <<'EOF'
const std = @import("std");
fn write_head(out: *Buf, allocator: Alloc) !void {
    try out.appendSlice(allocator, "penweave-20260917.045550\n");
}
fn read_head(header: []const u8) bool {
    return std.mem.eql(u8, header, "penweave-20260917.045550");
}
EOF

cat > "$pen/room/domain.rye" <<'EOF'
const std = @import("std");
pub const berth_domain = "pen-berth-v1";
EOF

cat > "$pen/room/lookalike.rye" <<'EOF'
const std = @import("std");
// the elder header was "penprose-v1" and this comment must never count
const body = "penbody-v1";
fn probe() void {
    const sig = "pensig-v1";
    _ = sig;
}
EOF

mkdir -p "$pen/tools/fixtures/plants"
cat > "$pen/tools/fixtures/plants/a.rye" <<'EOF'
pub const vessel_format = "penplant-v9";
EOF

stage "$pen"
s="$(pen_scan "$pen" 4)"
out="$(read_scan "$pen" "$s")"

[ "$(field "$out" counted_families)" = 3 ] \
  && ok "counted_families reads 3 -- the declared, written and compared families and no other" \
  || no "counted_families reads $(field "$out" counted_families), wanted 3"

[ "$(field "$out" chronological_families)" = 1 ] \
  && ok "chronological_families reads 1" \
  || no "chronological_families reads $(field "$out" chronological_families), wanted 1"

[ "$(field "$out" chronological_sites)" = 2 ] \
  && ok "chronological_sites reads 2 -- the write and the compare, so the newline fold holds" \
  || no "chronological_sites reads $(field "$out" chronological_sites), wanted 2"

[ "$(field "$out" domain_families)" = 1 ] \
  && ok "domain_families reads 1 -- reported apart, never a record family" \
  || no "domain_families reads $(field "$out" domain_families), wanted 1"

[ "$(field "$out" unclassified)" = 2 ] \
  && ok "unclassified reads 2 -- the two look-alikes, and the comment is not among them" \
  || no "unclassified reads $(field "$out" unclassified), wanted 2"

printf '%s\n' "$out" | grep -q 'unclassified: penbody-v1' \
  && ok "the look-alike is named by its own literal and site" \
  || no "the look-alike is not named"

printf '%s\n' "$out" | grep -q 'penprose-v1' \
  && no "a version named in a comment reached the reading" \
  || ok "a version named in a comment reaches no reading at all"

printf '%s\n' "$out" | grep -q 'penplant-v9' \
  && no "a fixtures-room plant was read as a record family" \
  || ok "the fixtures room is read past -- a plant keeps the shape it plants"

printf '%s\n' "$out" | grep -q 'verdict=counted_families_under_ceiling' \
  && ok "three families under a ceiling of four walk free" \
  || no "the honest pen did not walk free"

# --- the ceiling, from both sides -----------------------------------------
s3="$(pen_scan "$pen" 3)"
out3="$(read_scan "$pen" "$s3")"
printf '%s\n' "$out3" | grep -q 'verdict=counted_families_under_ceiling' \
  && ok "three families at a ceiling of three walk free -- the ratchet has no slack and no bite" \
  || no "a reading exactly at its ceiling was refused"

s2="$(pen_scan "$pen" 2)"
out2="$(read_scan "$pen" "$s2")"
printf '%s\n' "$out2" | grep -q 'verdict=over_ceiling' \
  && ok "three families over a ceiling of two refuse by name" \
  || no "a reading over its ceiling walked free"
( cd "$pen" && sh "$s2" >/dev/null 2>&1 ) && no "the over-ceiling refusal exited zero" \
  || ok "the over-ceiling refusal exits non-zero"

# --- a new counted family is the thing this guard exists to catch ----------
cp -r "$pen" "$work/grown"
cat > "$work/grown/room/new.rye" <<'EOF'
pub const slip_format = "penslip-v1";
EOF
stage "$work/grown"
sg="$(pen_scan "$work/grown" 3)"
outg="$(read_scan "$work/grown" "$sg")"
[ "$(field "$outg" counted_families)" = 4 ] \
  && ok "a newly written counted header raises the family count" \
  || no "a newly written counted header did not raise the family count"
printf '%s\n' "$outg" | grep -q 'verdict=over_ceiling' \
  && ok "and refuses against the standing ceiling -- the lap it is written" \
  || no "a new counted family walked free"

# --- a molt lowers it -----------------------------------------------------
cp -r "$pen" "$work/molted"
cat > "$work/molted/room/declared.rye" <<'EOF'
const std = @import("std");
pub const vessel_format = "penvessel-20260917.045551";
EOF
stage "$work/molted"
sm="$(pen_scan "$work/molted" 3)"
outm="$(read_scan "$work/molted" "$sm")"
[ "$(field "$outm" counted_families)" = 2 ] \
  && ok "a molted family leaves the counted reading" \
  || no "a molted family did not leave the counted reading"
[ "$(field "$outm" chronological_families)" = 2 ] \
  && ok "and arrives in the chronological one -- a molt is visible as a movement" \
  || no "a molted family did not arrive in the chronological reading"

# --- an unreadable tree refuses rather than reporting a comfortable zero ---
bare="$work/bare"
make_pen "$bare"
sb="$(pen_scan "$bare" 3)"
outb="$(read_scan "$bare" "$sb")"
printf '%s\n' "$outb" | grep -q 'verdict=unreadable' \
  && ok "a tree holding no tracked Rye answers unreadable" \
  || no "an empty tree did not answer unreadable"

# --- mutations ------------------------------------------------------------
mutate() {
  _name="$1"; _expr="$2"; _want="$3"; _field="$4"
  sed "s/^CEILING=.*/CEILING=4/" "$scan" > "$pen/base.sh"
  sed "$_expr" "$pen/base.sh" > "$pen/mut.sh"
  # A mutation that removes nothing reads as a passing leg, so the edit is asserted before the
  # reading is trusted -- the trap this lane met one instrument over on `20260917.040203`.
  if cmp -s "$pen/base.sh" "$pen/mut.sh"; then
    no "$_name -- the mutation edited nothing, so the leg below would prove nothing"
    return
  fi
  _o="$(read_scan "$pen" "$pen/mut.sh")"
  _got="$(field "$_o" "$_field")"
  [ "$_got" != "$_want" ] \
    && ok "$_name bites -- $_field reads $_got where the honest scan reads $_want" \
    || no "$_name did not bite -- $_field still reads $_want"
}

# M1: the trailing-newline fold. Removing it loses the WRITE site of the one chronological family.
mutate "M1 removing the newline fold" '/gsub(/d' 2 chronological_sites

# M2: the comment strip. Removing it counts a version named in prose.
mutate "M2 removing the comment strip" 's/^    line = strip(\$0)$/    line = $0/' 2 unclassified

# M3: the unclassified decline. Folding look-alikes in raises the family count.
mutate "M3 counting unclassified as a record" 's/^  \$1 == "unclassified" { un++ }$/  $1 == "unclassified" { cs++; cf[$3] = 1; un++ }/' 3 counted_families

# M4: the fixtures exclusion. Removing it admits a pen plant as a real family.
mutate "M4 removing the fixtures exclusion" "s|grep -v '\^tools/fixtures/' | cat |" 3 counted_families

echo "control_legs=$legs control_failed=$fail"
[ "$fail" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=broken"
[ "$fail" -eq 0 ]
