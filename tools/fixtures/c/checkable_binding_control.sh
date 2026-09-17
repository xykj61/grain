#!/bin/sh
# checkable_binding_control.sh -- prove the binding reading on real git repositories in a pen.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal:
# a refusal proven only in the passing direction cannot be told from a bypass.
#
# The pen builds a tiny tree carrying its own roster helper, so the scan reads a population this
# control wrote rather than the field's 1,351 pages. That is what makes each leg's expected number
# exact.
set -eu

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT

legs=0
failed=0

leg() {
  name=$1; want=$2; got=$3
  legs=$((legs+1))
  if [ "$want" = "$got" ]; then
    echo "leg $name = $got"
  else
    echo "leg $name = $got  WANT $want  FAILED"
    failed=$((failed+1))
  fi
}

read_key() { grep -oE "(^| )$2=[^ ]*" "$1" | tail -1 | sed 's/.*=//'; }

# The scan is resolved from the control's OWN directory through git, never from the caller's cwd:
# a control invoked from a pen would otherwise resolve to the pen's root and refuse.
CTL_DIR=$(cd "$(dirname "$0")" && pwd)
# `A && B || C && D` groups as `((A && B) || C) && D`, so a fallback spelled with `||` on one line
# runs its tail either way and returns two paths joined. The branches are separated here.
SCAN_ROOT=$(cd "$CTL_DIR" && git rev-parse --show-toplevel 2>/dev/null) || SCAN_ROOT=""
if [ -z "$SCAN_ROOT" ]; then SCAN_ROOT=$(cd "$CTL_DIR/../../.." && pwd); fi
SCAN=${CHECKABLE_BINDING_SCAN:-$SCAN_ROOT/tools/fixtures/c/checkable_binding_scan.sh}

# One shell dialect on both piers: GNU `sed -i` takes no argument and BSD `sed -i` requires a backup
# suffix, so the tree answers that question once rather than in every guard.
. "$SCAN_ROOT/tools/fixtures/s/shell_portable.sh"
if [ ! -f "$SCAN" ]; then
  echo "detail=RED_scan_absent path=$SCAN"
  echo "control_verdict=cannot_run"
  exit 1
fi

pen_init() {
  rm -rf "$PEN/t"; mkdir -p "$PEN/t"
  cd "$PEN/t"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  mkdir -p tools/fixtures/t tools/x room construction mod
  # The pen's own roster helper: the scan reads THIS rather than a second spelling of the rule.
  cat > tools/fixtures/t/two_rooms_doorway_roster.sh <<'R'
#!/bin/sh
git ls-files 'room/*.md'
R
  chmod +x tools/fixtures/t/two_rooms_doorway_roster.sh
  # A real tracked instrument, a real tracked module source, a real tracked pin.
  printf '#!/bin/sh\necho ok\n' > tools/x/pen_thing_scan.sh
  printf 'const std = @import("std");\n' > mod/module.rye
  printf '# pin\n' > construction/PEN_PIN.md
}

pen_commit() { git add -A >/dev/null 2>&1; git commit -qm "$1" >/dev/null 2>&1 || true; }

page() {
  # page <name> <status-line> <body>
  printf '# %s\n\n**Status:** %s\n\n%s\n' "$1" "$2" "$3" > "room/$1.md"
}

run() { sh "$SCAN" "$@" > "$PEN/out.txt" 2>&1 || true; }

# ---------------------------------------------------------------- 1: the reading works at all
pen_init
page a "Living -- **checkable room**: bound here" 'Proven by `tools/x/pen_thing_scan.sh`.'
pen_commit one
run
leg reading_runs read "$(read_key "$PEN/out.txt" verdict)"
leg roster_reaches_page 1 "$(read_key "$PEN/out.txt" roster_pages)"
leg checkable_counted 1 "$(read_key "$PEN/out.txt" checkable)"
leg settled_counted 1 "$(read_key "$PEN/out.txt" settled)"
leg instrument_binds 1 "$(read_key "$PEN/out.txt" bound_instrument)"
leg bound_page_is_not_unbound 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 2: the finding, planted
page b "Living -- **checkable room**: nothing named" 'A settled claim naming no evidence at all.'
pen_commit two
run
leg unbound_counted 1 "$(read_key "$PEN/out.txt" settled_unbound)"
leg unbound_named yes "$(sh "$SCAN" list 2>/dev/null | grep -q 'settled_unbound: room/b.md' && echo yes || echo no)"

# ---------------------------------------------------------------- 3: lifted
rm -f room/b.md
pen_commit two_lifted
run
leg unbound_lifted 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 4: a proposal walks free
page c "Design -- **checkable room**: the witness comes next week" 'No evidence yet, and the door says so.'
pen_commit three
run
leg proposal_not_settled 0 "$(read_key "$PEN/out.txt" settled_unbound)"
leg proposal_counted 1 "$(read_key "$PEN/out.txt" proposed_unbound)"

# ---------------------------------------------------------------- 5: both words reads as proposed
rm -f room/c.md
page d "Living design -- **checkable room**: a shape still forming" 'No evidence named.'
pen_commit four
run
leg both_words_read_proposed 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 6: artifact and record bind
rm -f room/d.md
page e "Living -- **checkable room**: the program is the evidence" 'The module `mod/module.rye` carries it.'
page f "Living -- **checkable room**: the ledger records it" 'Each stop lands in `construction/PEN_PIN.md`.'
pen_commit five
run
leg artifact_binds 1 "$(read_key "$PEN/out.txt" bound_artifact)"
leg record_binds 1 "$(read_key "$PEN/out.txt" bound_record)"
leg neither_is_unbound 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 7: the INDEX decides, not the disk
# The removals are STAGED. A page deleted on disk with its removal unstaged stays in the roster and
# is absent from it, which is its own leg below rather than incidental state here.
git rm -q room/e.md room/f.md >/dev/null 2>&1 || rm -f room/e.md room/f.md
printf '#!/bin/sh\necho untracked\n' > tools/x/pen_ghost_scan.sh   # on disk, never committed
page g "Living -- **checkable room**: names a file no clone receives" 'Proven by `tools/x/pen_ghost_scan.sh`.'
git add room/g.md >/dev/null 2>&1; git commit -qm six >/dev/null 2>&1 || true
run
leg untracked_path_does_not_bind 1 "$(read_key "$PEN/out.txt" settled_unbound)"
git add -A >/dev/null 2>&1; git commit -qm six_tracked >/dev/null 2>&1 || true
run
leg tracked_path_binds 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 8: delegation, landing and dry
pen_init
page hub "Living -- **checkable room**: bound below" 'Proven by `tools/x/pen_thing_scan.sh`.'
page bare "Living -- **checkable room**: no instrument here" 'The vision alone.'
page deleg "Living -- **checkable room**: bound by a witness the page below names" 'See [the hub](hub.md).'
pen_commit deleg
run
leg delegation_counted 1 "$(read_key "$PEN/out.txt" settled_delegated)"
leg delegation_landing_is_not_dry 0 "$(read_key "$PEN/out.txt" settled_hop_dry)"
leg delegation_is_not_unbound 1 "$(read_key "$PEN/out.txt" settled_unbound)"

# the hop goes dry when the page it names carries no instrument either
sed_inplace 's|\[the hub\](hub.md)|[the bare page](bare.md)|' room/deleg.md
pen_commit deleg_dry
run
leg dry_hop_counted 1 "$(read_key "$PEN/out.txt" settled_hop_dry)"
leg dry_hop_still_delegated 1 "$(read_key "$PEN/out.txt" settled_delegated)"
leg dry_hop_is_reported_never_gated 1 "$(read_key "$PEN/out.txt" settled_unbound)"

# a link leaving the tracked tree is no delegation at all
sed_inplace 's|\[the bare page\](bare.md)|[nowhere](no-such-page.md)|' room/deleg.md
pen_commit deleg_absent
run
leg absent_link_is_not_delegation 0 "$(read_key "$PEN/out.txt" settled_delegated)"
leg absent_link_falls_to_unbound 2 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 9: a bare instrument name binds
pen_init
page h "Living -- **checkable room**: named without its path" 'Held by pen_thing_scan, which stands in tools.'
pen_commit bare_name
run
leg bare_instrument_name_binds 0 "$(read_key "$PEN/out.txt" settled_unbound)"

# a bare name resolving to nothing this tree carries does NOT bind
page i "Living -- **checkable room**: names a guard nobody wrote" 'Held by pen_phantom_witness.'
pen_commit bare_phantom
run
leg phantom_bare_name_does_not_bind 1 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 10: a door outside the roster is silent
pen_init
page j "Living -- **checkable room**: inside" 'No evidence.'
mkdir -p elsewhere
printf '# k\n\n**Status:** Living -- **checkable room**: outside\n\nNo evidence.\n' > elsewhere/k.md
pen_commit roster_bound
run
leg roster_bounds_the_subject 1 "$(read_key "$PEN/out.txt" settled_unbound)"

# ---------------------------------------------------------------- 11: the door is read at the head only
pen_init
printf '# l\n\n**Status:** Living -- vision room\n\n' > room/l.md
i=0; while [ $i -lt 40 ]; do printf 'filler line\n' >> room/l.md; i=$((i+1)); done
printf '\n**Status:** Living -- **checkable room**: far below the door\n' >> room/l.md
pen_commit head_bound
run
leg door_read_at_head_only 0 "$(read_key "$PEN/out.txt" checkable)"

# ---------------------------------------------------------------- 12: mutations must bite
pen_init
page m "Living -- **checkable room**: nothing named" 'No evidence.'
pen_commit mutation_base
run
base_unbound=$(read_key "$PEN/out.txt" settled_unbound)
leg mutation_base_reads_one 1 "$base_unbound"

mut=$PEN/mutant.sh

# MUTATION A -- drop the tracked test, so a path on disk alone binds.
sed 's|grep -qxFf - "\$tmp/tracked.txt" 2>/dev/null|true|' "$SCAN" > "$mut"
leg mutation_a_marker_stands "$( [ "$(grep -c 'grep -qxFf - "\$tmp/tracked.txt"' "$SCAN")" -gt 0 ] && echo yes || echo no )" yes
rm -rf "$PEN/t2"; cp -r "$PEN/t" "$PEN/t2"; cd "$PEN/t2"
printf '#!/bin/sh\n' > tools/x/pen_disk_only_scan.sh
sed_inplace 's|No evidence.|Proven by `tools/x/pen_disk_only_scan.sh`.|' room/m.md
git add room/m.md >/dev/null 2>&1; git commit -qm disk_only >/dev/null 2>&1 || true
sh "$SCAN" > "$PEN/o1.txt" 2>&1 || true
sh "$mut" > "$PEN/o2.txt" 2>&1 || true
leg mutation_a_bites "1/0" "$(read_key "$PEN/o1.txt" settled_unbound)/$(read_key "$PEN/o2.txt" settled_unbound)"
cd "$PEN/t"

# MUTATION B -- read the lifecycle word as settled whatever the door says, so a proposal reds.
sed 's|if (pr\[f\]) { print f "\\tproposed" }|if (0) { print f "\\tproposed" }|' "$SCAN" > "$mut"
leg mutation_b_marker_stands "$( [ "$(grep -c 'if (pr\[f\]) { print f' "$SCAN")" -gt 0 ] && echo yes || echo no )" yes
rm -rf "$PEN/t3"; cp -r "$PEN/t" "$PEN/t3"; cd "$PEN/t3"
page n "Living design -- **checkable room**: a witness comes next week" 'No evidence yet.'
git add -A >/dev/null 2>&1; git commit -qm proposal >/dev/null 2>&1 || true
sh "$SCAN" > "$PEN/o3.txt" 2>&1 || true
sh "$mut" > "$PEN/o4.txt" 2>&1 || true
leg mutation_b_bites "1/2" "$(read_key "$PEN/o3.txt" settled_unbound)/$(read_key "$PEN/o4.txt" settled_unbound)"
cd "$PEN/t"

# MUTATION C -- stop following the hop, so every delegation reads dry.
sed 's|      hop_bound=yes|      hop_bound=no|' "$SCAN" > "$mut"
leg mutation_c_marker_stands "$( [ "$(grep -c 'hop_bound=yes' "$SCAN")" -gt 0 ] && echo yes || echo no )" yes
rm -rf "$PEN/t4"; cp -r "$PEN/t" "$PEN/t4"; cd "$PEN/t4"
page hub2 "Living -- **checkable room**: bound" 'Proven by `tools/x/pen_thing_scan.sh`.'
page deleg2 "Living -- **checkable room**: bound by the page below" 'See [hub2](hub2.md).'
git add -A >/dev/null 2>&1; git commit -qm hop >/dev/null 2>&1 || true
sh "$SCAN" > "$PEN/o5.txt" 2>&1 || true
sh "$mut" > "$PEN/o6.txt" 2>&1 || true
leg mutation_c_bites "0/1" "$(read_key "$PEN/o5.txt" settled_hop_dry)/$(read_key "$PEN/o6.txt" settled_hop_dry)"
cd "$PEN/t"

# ------------------------------------------- 13: a tracked-but-absent page silences nothing
# The pen found this in the scan rather than the other way round: `awk ... $(cat roster)` handed one
# path the disk lacks ABORTS the whole run, so every page after it went unread and the reading
# printed a clean zero. The absent entry is counted and the present pages still read.
pen_init
page p1 "Living -- **checkable room**: nothing named" 'No evidence.'
page p2 "Living -- **checkable room**: also nothing" 'No evidence.'
pen_commit absent_base
rm -f room/p1.md          # tracked, gone from disk, removal unstaged
run
leg absent_entry_counted 1 "$(read_key "$PEN/out.txt" roster_absent)"
leg absent_entry_silences_nothing 1 "$(read_key "$PEN/out.txt" settled_unbound)"
leg present_count_excludes_absent 1 "$(read_key "$PEN/out.txt" roster_present)"

# ---------------------------------------------------------------- 13: a tree with no roster helper refuses
pen_init
rm -f tools/fixtures/t/two_rooms_doorway_roster.sh
pen_commit no_roster
run
leg absent_roster_refuses cannot_read "$(read_key "$PEN/out.txt" verdict)"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
