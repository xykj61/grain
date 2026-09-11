#!/bin/sh
# tools/fixtures/p/port_band_control.sh -- prove tools/fixtures/p/port_band_scan.sh from both sides.
#
# WHY A PEN. The scan reads the tree's own port declarations, so every claim it makes is a claim
# about a population a lap may change. A refusal proven only in the passing direction reads exactly
# like a bypass. So each reading is planted, read as a refusal, then lifted and read as zero -- on
# real git repositories in a throwaway pen, and never against the tree.
#
# THE FAULT THIS CONTROL CAUGHT FIRST. The lock reading compared a lock's edge band against every
# port its room declares, and a lock is taken on the LOW port of a pair. So it reported
# tools/fixtures/m/mantra_delivery_port_lock.sh as refusing 38491, a number the lock is never
# handed. A guard reporting a fault against a correct file costs more than a guard that misses one,
# because the repair it instructs breaks something sound. Both directions are planted below, as
# `lock_pair_high_free` and `lock_uncovered_counted`.
#
# USAGE, from the repository root:
#   sh tools/fixtures/p/port_band_control.sh
#
# Driven by tools/p/port_band_witness.rish.
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

SCAN="$ROOT/tools/fixtures/p/port_band_scan.sh"
[ -f "$SCAN" ] || { echo "$0: the scan under test is absent -- $SCAN" >&2; exit 2; }

# A PEN THIS SHIP OWNS, named at run time. Eight checkouts share one /tmp on this pier, so a name
# fixed at write time is a name every ship chose (REDS %601, %618).
pen=$(mktemp -d "${TMPDIR:-/tmp}/grain-port-band-XXXXXX") || { echo "$0: no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

legs=0
fails=0
say_leg() {
  legs=$((legs + 1))
  printf '%s=%s\n' "$1" "$2"
  [ "$2" = yes ] || fails=$((fails + 1))
}

# A tree the scan can read: a git checkout holding tracked Rye sources.
make_tree() {
  t="$pen/$1"
  rm -rf "$t"
  mkdir -p "$t/rishi/bin" "$t/tools/fixtures" "$t/comlink" "$t/mantra" "$t/amphora"
  (
    cd "$t" || exit 1
    git init -q .
    git config user.email pen@example.invalid
    git config user.name pen
    git config commit.gpgsign false
  ) || return 1
  printf 'const wire_port: u16 = 38472;\n' > "$t/comlink/hosted_wire.rye"
}

commit_tree() {
  (
    cd "$pen/$1" || exit 1
    git add -A >/dev/null 2>&1
    git commit -q -m pen >/dev/null 2>&1
  )
}

read_scan() {
  PORT_BAND_ROOT="$pen/$1" sh "$SCAN" ${2:-} 2>/dev/null
}

field() { printf '%s\n' "$1" | awk -F= -v k="$2" '$1 == k { print $2; exit }'; }

# ---------------------------------------------------------------- the clean read
make_tree clean || { echo "control_verdict=no_pen"; exit 2; }
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" ports_outside_band)" = 0 ] && say_leg clean_reads_zero yes || say_leg clean_reads_zero no
[ "$(field "$out" ports_double_claimed)" = 0 ] && say_leg clean_no_double yes || say_leg clean_no_double no
[ "$(field "$out" verdict)" = ok ] && say_leg clean_verdict_ok yes || say_leg clean_verdict_ok no
[ "$rc" -eq 0 ] && say_leg clean_free yes || say_leg clean_free no
[ "$(field "$out" ports_constant)" = 1 ] && say_leg inside_band_counted yes || say_leg inside_band_counted no

# ---------------------------------------------------------------- outside the band
printf 'const admin_port: u16 = 8080;\n' > "$pen/clean/comlink/stray.rye"
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" ports_outside_band)" = 1 ] && say_leg outside_band_counted yes || say_leg outside_band_counted no
[ "$rc" -ne 0 ] && say_leg outside_band_refused yes || say_leg outside_band_refused no
[ "$(field "$out" verdict)" = outside_band ] && say_leg outside_band_named yes || say_leg outside_band_named no
printf '%s\n' "$out" | grep -q 'comlink/stray.rye' && say_leg outside_file_named yes || say_leg outside_file_named no
rm -f "$pen/clean/comlink/stray.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" ports_outside_band)" = 0 ] && say_leg outside_band_lifted yes || say_leg outside_band_lifted no

# ---------------------------------------------------------------- the cure is not the fault
printf 'const ephemeral_port: u16 = 0;\n' > "$pen/clean/mantra/kernel_choice.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" ports_kernel_chosen)" = 1 ] && say_leg zero_port_named yes || say_leg zero_port_named no
[ "$(field "$out" ports_constant)" = 1 ] && say_leg zero_port_uncharged yes || say_leg zero_port_uncharged no
[ "$(field "$out" ports_outside_band)" = 0 ] && say_leg zero_port_free yes || say_leg zero_port_free no

# ---------------------------------------------------------------- port as a whole component
printf 'pub const max_report: u32 = 256;\nconst max_reportable: u16 = 99;\n' > "$pen/clean/mantra/report.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" port_declarations)" = 2 ] && say_leg substring_free yes || say_leg substring_free no
printf 'pub const lane_port: u16 = 38530;\n' > "$pen/clean/mantra/pub.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" ports_constant)" = 2 ] && say_leg pub_counted yes || say_leg pub_counted no

# ---------------------------------------------------------------- testimony keeps its words
mkdir -p "$pen/clean/mantra/date/20260101"
printf 'const old_port: u16 = 9999;\n' > "$pen/clean/mantra/date/20260101/elder.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" ports_outside_band)" = 0 ] && say_leg testimony_free yes || say_leg testimony_free no
printf '%s\n' "$(read_scan clean --list)" | grep -q 'date/20260101' && say_leg testimony_absent no || say_leg testimony_absent yes

# ---------------------------------------------------------------- one number, two modules
printf 'const source_port: u16 = 38530;\n' > "$pen/clean/amphora/twin.rye"
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" ports_double_claimed)" = 1 ] && say_leg double_counted yes || say_leg double_counted no
printf '%s\n' "$(read_scan clean --list)" | grep -q 'double: 38530' && say_leg double_named yes || say_leg double_named no
[ "$rc" -eq 0 ] && say_leg double_at_ceiling_free yes || say_leg double_at_ceiling_free no
out=$(PORT_BAND_ROOT="$pen/clean" PORT_BAND_DOUBLE_CEILING=0 sh "$SCAN" 2>/dev/null); rc=$?
[ "$rc" -ne 0 ] && say_leg double_over_ceiling_refused yes || say_leg double_over_ceiling_refused no
[ "$(field "$out" verdict)" = over_ceiling ] && say_leg double_over_named yes || say_leg double_over_named no

# ---------------------------------------------------------------- a free number is never a claimed one
out=$(read_scan clean --list)
printf '%s\n' "$out" | grep '^free: ' | grep -qw 38530 && say_leg free_excludes_claimed no || say_leg free_excludes_claimed yes
printf '%s\n' "$out" | grep '^free: ' | grep -qw 38473 && say_leg free_includes_unclaimed yes || say_leg free_includes_unclaimed no

# ---------------------------------------------------------------- a base that counts up is named
printf 'const base_port: u16 = 38540;\n' > "$pen/clean/comlink/rehearsal.rye"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" counting_bases)" = 1 ] && say_leg base_reported yes || say_leg base_reported no

# ---------------------------------------------------------------- the lock and its own room
make_tree lock || { echo "control_verdict=no_pen"; exit 2; }
printf 'const fetcher_port: u16 = 38478;\nconst source_port: u16 = 38479;\n' > "$pen/lock/mantra/a.rye"
printf 'const fetcher_port: u16 = 38480;\nconst source_port: u16 = 38481;\n' > "$pen/lock/mantra/b.rye"
mkdir -p "$pen/lock/tools/fixtures/m"
cat > "$pen/lock/tools/fixtures/m/mantra_delivery_port_lock.sh" <<'LOCK'
#!/bin/sh
if [ "$low_port" -lt 38478 ] || [ "$low_port" -gt 38480 ]; then
  echo outside >&2
fi
LOCK
commit_tree lock
out=$(read_scan lock); rc=$?
[ "$(field "$out" locks_read)" = 1 ] && say_leg lock_found yes || say_leg lock_found no
[ "$(field "$out" lock_band_uncovered)" = 0 ] && say_leg lock_pair_high_free yes || say_leg lock_pair_high_free no
[ "$rc" -eq 0 ] && say_leg lock_covering_free yes || say_leg lock_covering_free no

# A pair OPENING past the band -- the fault the reading exists for.
printf 'const fetcher_port: u16 = 38486;\nconst source_port: u16 = 38487;\n' > "$pen/lock/mantra/c.rye"
commit_tree lock
out=$(read_scan lock); rc=$?
[ "$(field "$out" lock_band_uncovered)" = 1 ] && say_leg lock_uncovered_counted yes || say_leg lock_uncovered_counted no
[ "$rc" -ne 0 ] && say_leg lock_uncovered_refused yes || say_leg lock_uncovered_refused no
[ "$(field "$out" verdict)" = lock_uncovered ] && say_leg lock_uncovered_named yes || say_leg lock_uncovered_named no
printf '%s\n' "$out" | grep -q '38486' && say_leg lock_uncovered_port_named yes || say_leg lock_uncovered_port_named no
rm -f "$pen/lock/mantra/c.rye"
commit_tree lock
out=$(read_scan lock)
[ "$(field "$out" lock_band_uncovered)" = 0 ] && say_leg lock_uncovered_lifted yes || say_leg lock_uncovered_lifted no

# A lock bounding no range refuses nothing, so it is passed over rather than guessed at.
make_tree noedge || { echo "control_verdict=no_pen"; exit 2; }
printf 'const source_port: u16 = 38495;\n' > "$pen/noedge/amphora/vessel.rye"
mkdir -p "$pen/noedge/tools/fixtures/a"
printf '#!/bin/sh\n# binds 38495\nport_lock="/tmp/g-38495.lock"\n' > "$pen/noedge/tools/fixtures/a/amphora_vessel_port_lock.sh"
commit_tree noedge
out=$(read_scan noedge); rc=$?
[ "$(field "$out" lock_band_uncovered)" = 0 ] && say_leg lock_no_edge_free yes || say_leg lock_no_edge_free no
[ "$(field "$out" lock_claims_unbound)" = 0 ] && say_leg lock_own_number_free yes || say_leg lock_own_number_free no
[ "$rc" -eq 0 ] && say_leg lock_no_edge_verdict_ok yes || say_leg lock_no_edge_verdict_ok no

# A number the lock names that its own room let go -- read against the ROOM, so a sibling room
# declaring it does not launder the claim.
printf '#!/bin/sh\n# binds UDP 38494 and 38495\nport_lock="/tmp/g-38494.lock"\n' > "$pen/noedge/tools/fixtures/a/amphora_vessel_port_lock.sh"
printf 'const record_port: u16 = 38494;\n' > "$pen/noedge/comlink/elsewhere.rye"
commit_tree noedge
out=$(read_scan noedge); rc=$?
[ "$(field "$out" lock_claims_unbound)" = 1 ] && say_leg lock_unbound_counted yes || say_leg lock_unbound_counted no
printf '%s\n' "$(read_scan noedge --list)" | grep -q 'unbound: .*38494' && say_leg lock_unbound_named yes || say_leg lock_unbound_named no
[ "$rc" -eq 0 ] && say_leg lock_unbound_reported_not_gated yes || say_leg lock_unbound_reported_not_gated no
printf 'const source_port: u16 = 38495;\nconst record_port: u16 = 38494;\n' > "$pen/noedge/amphora/vessel.rye"
commit_tree noedge
out=$(read_scan noedge)
[ "$(field "$out" lock_claims_unbound)" = 0 ] && say_leg lock_unbound_lifted yes || say_leg lock_unbound_lifted no

# ---------------------------------------------------------------- a tree that cannot answer refuses
out=$(PORT_BAND_ROOT="$pen/nowhere" sh "$SCAN" 2>/dev/null); rc=$?
[ "$(field "$out" verdict)" = no_root ] && [ "$rc" -ne 0 ] && say_leg no_root_refused yes || say_leg no_root_refused no
mkdir -p "$pen/plain"
out=$(PORT_BAND_ROOT="$pen/plain" sh "$SCAN" 2>/dev/null); rc=$?
[ "$(field "$out" verdict)" = no_git ] && [ "$rc" -ne 0 ] && say_leg no_git_refused yes || say_leg no_git_refused no
make_tree empty || { echo "control_verdict=no_pen"; exit 2; }
rm -f "$pen/empty/comlink/hosted_wire.rye"
commit_tree empty
out=$(PORT_BAND_ROOT="$pen/empty" sh "$SCAN" 2>/dev/null); rc=$?
[ "$(field "$out" verdict)" = no_sources ] && [ "$rc" -ne 0 ] && say_leg no_sources_refused yes || say_leg no_sources_refused no

# ---------------------------------------------------------------- the mutations
# A RULE REMOVED MUST BITE ITS OWN LEG. A reading nothing depends on is a reading that may quietly
# stop working, so each rule is deleted from a copy of the scan and the leg it protects is read
# again. Two rules, two mutations, each proven to fail alone.
mutate() {
  sed "$1" "$SCAN" > "$pen/mutant.sh"
}

# Without the pair-high rule, the lock reading reports the correct file. This is the fault the
# control caught before it shipped.
mutate "/grep -qx \"\$((p - 1))\" && continue/d"
out=$(PORT_BAND_ROOT="$pen/lock" sh "$pen/mutant.sh" 2>/dev/null)
[ "$(field "$out" lock_band_uncovered)" != 0 ] && say_leg mutation_pair_high_bites yes || say_leg mutation_pair_high_bites no

# Without the whole-component rule, `max_report` is read as a port.
# The baseline is READ rather than spelled, so a plant added to the clean pen later cannot make
# this leg pass by arithmetic instead of by the rule.
base_out=$(read_scan clean)
base_decls=$(field "$base_out" port_declarations)
mutate '/name !~/d'
out=$(PORT_BAND_ROOT="$pen/clean" sh "$pen/mutant.sh" 2>/dev/null)
mut_decls=$(field "$out" port_declarations)
[ "$mut_decls" -gt "$base_decls" ] && say_leg mutation_substring_bites yes || say_leg mutation_substring_bites no
# And the extra reading is a FAULT rather than a harmless count: `max_reportable: u16 = 99` sits
# outside the band, so the mutant reds a pen the scan reads clean.
[ "$(field "$out" ports_outside_band)" -gt 0 ] && say_leg mutation_substring_reds_clean yes || say_leg mutation_substring_reds_clean no


# ---------------------------------------------------------------- THE DEVICE BAND
# A SECOND ROOM IN A SECOND LANGUAGE. The readings above see Rye; the wire labs declare their ports
# in Rishi, as the default half of an environment override. Every leg below is planted, read as a
# refusal, then lifted and read as zero, on the same real repositories.
make_lab() {
  mkdir -p "$pen/$1/tools/co"
  cat > "$pen/$1/tools/co/comlink_$2_wire_lab.rish" <<LAB
let port_request_raw = env "$3"
if port_request_raw == "" then let port_request = "$4" else let port_request = port_request_raw
LAB
}

# A tree holding Rye and no lab at all: reported, never refused. The labs are a room this tree grew,
# and every tree before they landed held none.
out=$(read_scan clean); rc=$?
[ "$(field "$out" device_labs)" = 0 ] && say_leg device_no_lab_counted yes || say_leg device_no_lab_counted no
[ "$(field "$out" device_declarations)" = 0 ] && say_leg device_no_lab_zero yes || say_leg device_no_lab_zero no
[ "$rc" -eq 0 ] && say_leg device_no_lab_free yes || say_leg device_no_lab_free no

# A lawful lab inside the seated device band.
make_lab clean sync COMLINK_SYNC_LAB_PORT 15561
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" device_labs)" = 1 ] && say_leg device_lab_found yes || say_leg device_lab_found no
[ "$(field "$out" device_declarations)" = 1 ] && say_leg device_inside_counted yes || say_leg device_inside_counted no
[ "$(field "$out" device_ports_outside_band)" = 0 ] && say_leg device_inside_free yes || say_leg device_inside_free no
[ "$rc" -eq 0 ] && say_leg device_lawful_lab_free yes || say_leg device_lawful_lab_free no

# A device port outside the seated band.
make_lab clean stray COMLINK_STRAY_LAB_PORT 9099
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" device_ports_outside_band)" = 1 ] && say_leg device_outside_counted yes || say_leg device_outside_counted no
[ "$rc" -ne 0 ] && say_leg device_outside_refused yes || say_leg device_outside_refused no
[ "$(field "$out" verdict)" = device_outside_band ] && say_leg device_outside_named yes || say_leg device_outside_named no
printf '%s\n' "$out" | grep -q 'comlink_stray_wire_lab.rish' && say_leg device_outside_file_named yes || say_leg device_outside_file_named no
rm -f "$pen/clean/tools/co/comlink_stray_wire_lab.rish"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" device_ports_outside_band)" = 0 ] && say_leg device_outside_lifted yes || say_leg device_outside_lifted no

# ONE NUMBER, TWO LABS -- the shape that stood five times unread in the tree.
make_lab clean twoway COMLINK_TWOWAY_LAB_PORT 15561
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" device_double_claimed)" = 1 ] && say_leg device_double_counted yes || say_leg device_double_counted no
[ "$rc" -ne 0 ] && say_leg device_double_refused yes || say_leg device_double_refused no
[ "$(field "$out" verdict)" = device_over_ceiling ] && say_leg device_double_named yes || say_leg device_double_named no
printf '%s\n' "$out" | grep -q 'comlink_twoway_wire_lab.rish' && say_leg device_double_claimant_named yes || say_leg device_double_claimant_named no
PORT_BAND_DEVICE_DOUBLE_CEILING=1 PORT_BAND_ROOT="$pen/clean" sh "$SCAN" >/dev/null 2>&1 && say_leg device_double_at_ceiling_free yes || say_leg device_double_at_ceiling_free no
rm -f "$pen/clean/tools/co/comlink_twoway_wire_lab.rish"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" device_double_claimed)" = 0 ] && say_leg device_double_lifted yes || say_leg device_double_lifted no

# ONE OVERRIDE NAME, TWO LABS -- the escape hatch sharing the collision it exists to escape. The
# numbers differ here on purpose, so this leg can only pass by reading the NAME.
make_lab clean twin COMLINK_SYNC_LAB_PORT 15590
commit_tree clean
out=$(read_scan clean); rc=$?
[ "$(field "$out" device_double_claimed)" = 0 ] && say_leg device_override_numbers_differ yes || say_leg device_override_numbers_differ no
[ "$(field "$out" device_override_shared)" = 1 ] && say_leg device_override_counted yes || say_leg device_override_counted no
[ "$rc" -ne 0 ] && say_leg device_override_refused yes || say_leg device_override_refused no
[ "$(field "$out" verdict)" = device_override_shared ] && say_leg device_override_named yes || say_leg device_override_named no
printf '%s\n' "$out" | grep -q 'COMLINK_SYNC_LAB_PORT' && say_leg device_override_name_named yes || say_leg device_override_name_named no
printf '%s\n' "$out" | grep -q 'comlink_twin_wire_lab.rish' && say_leg device_override_site_named yes || say_leg device_override_site_named no
rm -f "$pen/clean/tools/co/comlink_twin_wire_lab.rish"
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" device_override_shared)" = 0 ] && say_leg device_override_lifted yes || say_leg device_override_lifted no

# PORT AS A WHOLE COMPONENT, in this language too. A lab timeout carrying a banded-looking number
# holds no port, and a variable merely carrying the letters is read past.
cat > "$pen/clean/tools/co/comlink_timeout_wire_lab.rish" <<'LAB'
let passport_raw = env "COMLINK_TIMEOUT_LAB_PASSPORT"
if passport_raw == "" then let passport = "15599" else let passport = passport_raw
LAB
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" device_declarations)" = 1 ] && say_leg device_substring_free yes || say_leg device_substring_free no
[ "$(field "$out" device_labs)" = 2 ] && say_leg device_lab_counted_anyway yes || say_leg device_lab_counted_anyway no

# The free list answers the repair it instructs.
out=$(read_scan clean --list)
printf '%s\n' "$out" | grep -q '^device free:.*15590' && say_leg device_free_includes_unclaimed yes || say_leg device_free_includes_unclaimed no
printf '%s\n' "$out" | grep -E '^device free:' | grep -qw 15561 && say_leg device_free_excludes_claimed no || say_leg device_free_excludes_claimed yes
printf '%s\n' "$out" | grep -q '^device: 15561' && say_leg device_listed yes || say_leg device_listed no
rm -f "$pen/clean/tools/co/comlink_timeout_wire_lab.rish"
commit_tree clean

# ---------------------------------------------------------------- the device mutations
# TWO MORE RULES, EACH DELETED AND READ AGAIN. A reading nothing depends on is a reading that may
# quietly stop working.

# The whole-component rule is written ONCE and read by both halves, so the mutation that removes it
# must be shown biting BOTH. Without it the lab's `passport` default is read as a port -- and it
# sits outside the seated device band, so the mutant reds a pen the scan reads clean.
make_lab clean sync COMLINK_SYNC_LAB_PORT 15561
cat > "$pen/clean/tools/co/comlink_timeout_wire_lab.rish" <<'LAB'
let passport_raw = env "COMLINK_TIMEOUT_LAB_PASSPORT"
if passport_raw == "" then let passport = "15599" else let passport = passport_raw
LAB
commit_tree clean
base_out=$(read_scan clean)
base_device=$(field "$base_out" device_declarations)
mutate '/name !~/d'
out=$(PORT_BAND_ROOT="$pen/clean" sh "$pen/mutant.sh" 2>/dev/null)
[ "$(field "$out" device_declarations)" -gt "$base_device" ] && say_leg mutation_substring_bites_device yes || say_leg mutation_substring_bites_device no

# ONE LAB NAMING ITS OWN VARIABLE TWICE IS NOT TWO LABS. `grep -oE` returns every occurrence, so the
# `sort -u` inside the override harvest is what keeps a lab from colliding with itself. Delete it
# and a single honest lab reads as a shared override -- a fault against a correct file, which is the
# one failure a guard cannot afford.
cat > "$pen/clean/tools/co/comlink_selfnamer_wire_lab.rish" <<'LAB'
let port_request_raw = env "COMLINK_SELFNAMER_LAB_PORT"
if port_request_raw == "" then let port_request = "15591" else let port_request = port_request_raw
let port_again_raw = env "COMLINK_SELFNAMER_LAB_PORT"
if port_again_raw == "" then let port_again = "15592" else let port_again = port_again_raw
LAB
commit_tree clean
out=$(read_scan clean)
[ "$(field "$out" device_override_shared)" = 0 ] && say_leg device_self_named_free yes || say_leg device_self_named_free no
mutate '/^    sort -u |$/d'
cmp -s "$pen/mutant.sh" "$SCAN" && say_leg mutation_override_dedupe_applied no || say_leg mutation_override_dedupe_applied yes
out=$(PORT_BAND_ROOT="$pen/clean" sh "$pen/mutant.sh" 2>/dev/null)
[ "$(field "$out" device_override_shared)" != 0 ] && say_leg mutation_override_dedupe_bites yes || say_leg mutation_override_dedupe_bites no
rm -f "$pen/clean/tools/co/comlink_selfnamer_wire_lab.rish" "$pen/clean/tools/co/comlink_timeout_wire_lab.rish"
commit_tree clean

echo "behaviors=$legs"
echo "control_failed=$fails"
if [ "$fails" -eq 0 ]; then
  echo "control_verdict=proven"
  exit 0
fi
echo "control_verdict=failed"
exit 1
