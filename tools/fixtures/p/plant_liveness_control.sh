#!/bin/sh
# tools/fixtures/p/plant_liveness_control.sh -- the liveness meter, proven on real repositories.
#
# WHY A CONTROL. `tools/fixtures/p/plant_liveness_scan.sh` gates `plants_dead` at zero, and a gate
# nobody has tried to fool is a claim rather than a wall. So every refusal below is planted and
# then lifted, and every welcome is asserted as hard as every refusal -- a refusal proven only in
# the passing direction cannot be told from a bypass.
#
# THE PENS ARE REAL GIT REPOSITORIES, because the scan resolves a path by asking `git ls-files`
# rather than by reading a spelling. A pen of loose files would let a control-authored path resolve
# as tracked and the resolution legs would prove nothing.
#
# THE LOAD-BEARING PHASE IS `dead_bites`. A meter answering "live" about every plant passes every
# welcome leg above it and catches nothing at all -- which is REDS %519's own fault wearing the
# instrument's clothes. So one pen carries a plant naming a line its source does not hold, and the
# scan must refuse it BY NAME.
#
# EXPECTED: every behavior below satisfied, faults=0, exit 0.
#
# Driven by tools/p/plant_liveness_witness.rish. Run from anywhere -- the root is found by walk.

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

SCAN="$_fd_root/tools/fixtures/p/plant_liveness_scan.sh"
mkdir -p "$_fd_root/session-output"
PEN="$(mktemp -d "$_fd_root/session-output/plant-control.XXXXXX")"
trap 'rm -rf "$PEN"' EXIT

behaviors=0
faults=0

note() {
  _label=$1; _got=$2; _want=$3
  behaviors=$((behaviors + 1))
  if [ "$_got" = "$_want" ]; then
    echo "OK   $_label ($_got)"
  else
    echo "FAULT $_label -- got '$_got', owed '$_want'"
    faults=$((faults + 1))
  fi
}

# make_pen NAME -- a real repository holding one module and one control directory.
make_pen() {
  d="$PEN/$1"
  mkdir -p "$d/tools/fixtures/x" "$d/mod"
  printf 'pub const all_checks = [_]Check{ .argument, .range };\nvar deletes: u32 = 0;\n' > "$d/mod/edge.rye"
  ( cd "$d" && git init -q . && git config user.email a@b.c && git config user.name t )
  echo "$d"
}

commit_pen() { ( cd "$1" && git add -A && git commit -qm pen ); }

read_field() { printf '%s\n' "$2" | sed -n "s/^$1=\\(.*\\)\$/\\1/p"; }

echo "plant-liveness-control: the gate shown from both sides, in $PEN"
echo

# --- 1. A LIVE PLANT WALKS FREE -----------------------------------------------------------------
echo "== 1. a plant whose line its source still holds reads live =="
d=$(make_pen live)
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
src="mod/edge.rye"
copy="$1/broken.rye"
sed 's/var deletes: u32 = 0;/var deletes: LineId = 0;/' "$src" > "$copy"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "live_verdict"    "$(read_field verdict "$out")"          "ok"
note "live_resolved"   "$(read_field plants_resolved "$out")"  "1"
note "live_counted"    "$(read_field plants_live "$out")"      "1"
note "live_dead_zero"  "$(read_field plants_dead "$out")"      "0"

echo
# --- 2. THE GATE BITES A DEAD PLANT -------------------------------------------------------------
echo "== 2. a plant naming a line its source does not hold refuses BY NAME =="
d=$(make_pen dead)
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
src="mod/edge.rye"
copy="$1/broken.rye"
sed 's/var deletes: usize = 0;/var deletes: LineId = 0;/' "$src" > "$copy"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>/dev/null ) && rc=0 || rc=$?
note "dead_verdict"      "$(read_field verdict "$out")"       "plant_dead"
note "dead_counted"      "$(read_field plants_dead "$out")"   "1"
note "dead_live_zero"    "$(read_field plants_live "$out")"   "0"
note "dead_exit_nonzero" "$([ "$rc" -ne 0 ] && echo refused || echo welcomed)" "refused"
note "dead_names_the_file" "$(printf '%s\n' "$out" | grep -c 'dead_plant tools/fixtures/x/thing_control.sh')" "1"
note "dead_names_the_source" "$(printf '%s\n' "$out" | grep -c 'mod/edge.rye')" "1"

echo
# --- 3. THE REFUSAL LIFTS -----------------------------------------------------------------------
# A gate proven only in the refusing direction cannot be told from one that refuses everything. So
# the same pen is repaired -- the pattern aimed at the line the source actually carries -- and the
# scan must walk it free.
echo "== 3. repairing the pattern lifts the refusal on the same pen =="
sed 's/usize/u32/' "$d/tools/fixtures/x/thing_control.sh" > "$d/tools/fixtures/x/thing_control.new"
cat "$d/tools/fixtures/x/thing_control.new" > "$d/tools/fixtures/x/thing_control.sh"
rm -f "$d/tools/fixtures/x/thing_control.new"
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "repaired_verdict" "$(read_field verdict "$out")"      "ok"
note "repaired_dead"    "$(read_field plants_dead "$out")"  "0"
note "repaired_live"    "$(read_field plants_live "$out")"  "1"

echo
# --- 4. A PEN FILE THE CONTROL AUTHORED IS UNRESOLVED, NEVER DEAD -------------------------------
# This is the reading that bounds the population. A plant aimed at a file the control itself wrote
# cannot go stale, because one hand moves both the line and the pattern. Counting such a plant as
# dead would red the tree for a fault that cannot happen.
echo "== 4. a plant aimed at an untracked pen file reads unresolved =="
d=$(make_pen penfile)
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
PEN="$1"
printf 'hello\n' > "$PEN/scratch.txt"
sed 's/no_such_line/x/' "$PEN/scratch.txt" > "$PEN/out.txt"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "penfile_verdict"    "$(read_field verdict "$out")"            "ok"
note "penfile_unresolved" "$(read_field plants_unresolved "$out")"  "1"
note "penfile_resolved"   "$(read_field plants_resolved "$out")"    "0"

echo
# --- 5. A READ-ONLY SED IS NOT A PLANT ----------------------------------------------------------
# `sed -n ... p` reading a file into a variable mutates nothing. Counting one as an unresolved
# plant would inflate the reported number with lines that were never plants, which is the fault of
# measuring a resemblance rather than the thing.
echo "== 5. a sed that writes nothing is counted as no plant at all =="
d=$(make_pen readonly)
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
src="mod/edge.rye"
count=$(sed -n 's/^var .*$/&/p' "$src" | wc -l)
echo "$count"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "readonly_resolved"   "$(read_field plants_resolved "$out")"    "0"
note "readonly_unresolved" "$(read_field plants_unresolved "$out")"  "0"
note "readonly_verdict"    "$(read_field verdict "$out")"            "ok"

echo
# --- 6. A COMMENTED PLANT IS DOCUMENTATION ------------------------------------------------------
# Every control in this tree explains its plants in prose above them, and a header quoting a sed
# program is teaching rather than planting. Reading one as a plant would red a tree whose only
# fault was that somebody wrote a good comment.
echo "== 6. a sed program inside a comment plants nothing =="
d=$(make_pen commented)
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
# The elder form was: sed 's/var deletes: usize = 0;/x/' "$src" > "$copy"
src="mod/edge.rye"
echo "$src"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "commented_resolved" "$(read_field plants_resolved "$out")"  "0"
note "commented_verdict"  "$(read_field verdict "$out")"          "ok"

echo
# --- 7. A PREFIXED ASSIGNMENT RESOLVES ----------------------------------------------------------
# `SCAN="$ROOT/tools/fixtures/x/y.sh"` names a tracked source behind a root variable, and this is
# the shape twelve of the tree's own resolvable plants wear. Missing it would leave the plants
# most likely to rot -- the ones aimed at another lane's scan -- outside the gate.
echo "== 7. a target named behind a root variable resolves =="
d=$(make_pen prefixed)
printf '#!/bin/sh\necho "verdict=ok"\n' > "$d/tools/fixtures/x/subject_scan.sh"
cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
#!/bin/sh
ROOT="$1"
SUBJECT="$ROOT/tools/fixtures/x/subject_scan.sh"
LIAR="$2/liar.sh"
sed 's/echo "verdict=ok"/echo "verdict=drifted"/' "$SUBJECT" > "$LIAR"
EOF
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "prefixed_resolved" "$(read_field plants_resolved "$out")"  "1"
note "prefixed_live"     "$(read_field plants_live "$out")"      "1"
note "prefixed_verdict"  "$(read_field verdict "$out")"          "ok"

echo
# --- 8. THE PEN IS PROVEN INNOCENT --------------------------------------------------------------
# A pen holding no control at all must read zero rather than refuse, or every count above could be
# an artifact of the pen rather than of the plants in it.
echo "== 8. a repository with no controls reads zero and welcomes =="
d=$(make_pen empty)
commit_pen "$d"
out=$( cd "$d" && sh "$SCAN" 2>&1 ) || true
note "empty_controls"  "$(read_field controls "$out")"         "0"
note "empty_resolved"  "$(read_field plants_resolved "$out")"  "0"
note "empty_verdict"   "$(read_field verdict "$out")"          "ok"


# A tracked path named in a redirect or a longer variable is not the input.
for mode in output_target variable_prefix; do
  d=$(make_pen "$mode")
  if [ "$mode" = output_target ]; then
    cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
src="mod/edge.rye"
sed 's/absent/changed/' "$scratch" > "$src"
EOF
  else
    cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
src="mod/edge.rye"
sed 's/absent/changed/' "$src_extra" > "$copy"
EOF
  fi
  commit_pen "$d"
  out=$(cd "$d" && sh "$SCAN" 2>/dev/null) || true
  note "${mode}_unresolved" "$(read_field plants_unresolved "$out")" "1"
  note "${mode}_resolved_zero" "$(read_field plants_resolved "$out")" "0"
done


# The scan keeps sed's reading flags while removing its in-place write flag.
for mode in quiet extended; do
  d=$(make_pen "$mode")
  if [ "$mode" = quiet ]; then
    cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
src="mod/edge.rye"
sed -n 'p' "$src" > "$copy"
EOF
    expected=plant_dead
  else
    cat > "$d/tools/fixtures/x/thing_control.sh" <<'EOF'
src="mod/edge.rye"
sed -E 's/(var deletes)/changed/' "$src" > "$copy"
EOF
    expected=ok
  fi
  commit_pen "$d"
  out=$(cd "$d" && sh "$SCAN" 2>/dev/null) || true
  note "${mode}_flag_kept" "$(read_field verdict "$out")" "$expected"
done

# Failed programs cannot count as live mutations. Sandboxed commands also leave
# their named output files absent; proving that keeps the scan read-only.
for mode in invalid write execute read; do
  d=$(make_pen "$mode")
  case "$mode" in
    invalid) program='s/[//' ;;
    write) program='w side-effect' ;;
    execute) program='e touch side-effect' ;;
    read) program='r mod/edge.rye' ;;
  esac
  printf 'src="mod/edge.rye"\nsed '\''%s'\'' "$src" > "$copy"\n' "$program" > "$d/tools/fixtures/x/thing_control.sh"
  commit_pen "$d"
  out=$(cd "$d" && sh "$SCAN" 2>/dev/null) && rc=0 || rc=$?
  note "${mode}_verdict" "$(read_field verdict "$out")" "plant_failed"
  note "${mode}_failed" "$(read_field plants_failed "$out")" "1"
  note "${mode}_live_zero" "$(read_field plants_live "$out")" "0"
  note "${mode}_exit" "$rc" "1"
  note "${mode}_writes_nothing" "$([ -e "$d/side-effect" ] && echo changed || echo intact)" "intact"
done


# Valid looping programs must also terminate, with bounded output storage.
for mode in loop output_loop; do
  d=$(make_pen "$mode")
  case "$mode" in
    loop) program=':again; bagain' ;;
    output_loop) program=':again; p; bagain' ;;
  esac
  printf 'src="mod/edge.rye"\nsed '\''%s'\'' "$src" > "$copy"\n' "$program" > "$d/tools/fixtures/x/thing_control.sh"
  commit_pen "$d"
  out=$(cd "$d" && sh "$SCAN" 2>/dev/null) && rc=0 || rc=$?
  note "${mode}_verdict" "$(read_field verdict "$out")" "plant_failed"
  note "${mode}_failed" "$(read_field plants_failed "$out")" "1"
  note "${mode}_live_zero" "$(read_field plants_live "$out")" "0"
  note "${mode}_exit" "$rc" "1"
done

# A host lacking the sed capability gets an explicit unavailable result.
d=$(make_pen unavailable)
mkdir -p "$d/bin"
real_sed=$(command -v sed)
printf '#!/bin/sh\n[ "$1" = --sandbox ] && exit 2\nexec "%s" "$@"\n' "$real_sed" > "$d/bin/sed"
printf '#!/bin/sh\nexit 2\n' > "$d/bin/gsed"
chmod +x "$d/bin/sed" "$d/bin/gsed"
commit_pen "$d"
out=$(cd "$d" && PATH="$d/bin:$PATH" sh "$SCAN" 2>/dev/null) && rc=0 || rc=$?
note "unavailable_verdict" "$(read_field verdict "$out")" "unavailable_safe_sed"
note "unavailable_exit" "$rc" "2"
# Restore sed while withholding the deadline tool, proving the second dependency.
printf '#!/bin/sh\nexec "%s" "$@"\n' "$real_sed" > "$d/bin/sed"
real_gsed=$(command -v gsed || true)
if [ -n "$real_gsed" ]; then
  printf '#!/bin/sh\nexec "%s" "$@"\n' "$real_gsed" > "$d/bin/gsed"
fi
printf '#!/bin/sh\nexit 2\n' > "$d/bin/timeout"
printf '#!/bin/sh\nexit 2\n' > "$d/bin/gtimeout"
chmod +x "$d/bin/timeout" "$d/bin/gtimeout"
out=$(cd "$d" && PATH="$d/bin:$PATH" sh "$SCAN" 2>/dev/null) && rc=0 || rc=$?
note "deadline_unavailable_verdict" "$(read_field verdict "$out")" "unavailable_safe_sed"
note "deadline_unavailable_exit" "$rc" "2"


# Read the runner's actual capability function and prove it delegates to the same
# scan. This keeps a capability name from drifting from the program it protects.
sed -n '/^capability_state() {/,/^}/p' "$_fd_root/tools/fixtures/s/standing_equipment_run.sh" > "$PEN/capability.sh"
. "$PEN/capability.sh"
out=$(cd "$_fd_root" && capability_state sed_sandbox)
note "roster_capability_present" "$out" "present"
out=$(cd "$_fd_root" && PATH="$d/bin:$PATH" capability_state sed_sandbox)
note "roster_capability_absent" "$out" "absent"
out=$(cd "$d" && capability_state sed_sandbox)
note "roster_capability_unknown" "$out" "unknown"

echo
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -ne 0 ]; then
  echo "control_verdict=faulted"
  exit 1
fi
echo "control_verdict=ok"
exit 0
