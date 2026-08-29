#!/usr/bin/env sh
# pond_seal_gate_control.sh -- pond_seal_gate_scan.sh proven on planted git repositories.
#
# WHAT THIS PROVES. Every refusal the scan can make, shown from BOTH sides: the plant refuses, and
# the same pen with the plant removed returns to green. A refusal proven only in the passing
# direction cannot be told from a bypass, so the removal leg is what makes the rest mean anything.
# The bound is proven from both sides too, one file past and one file under, so no override exists
# and none is wanted.
#
# WHY A REAL GIT REPOSITORY RATHER THAN A DIRECTORY. The scan discovers its candidates with
# `git grep` over tracked files, on purpose (REDS %301, %326). A pen that is not a repository would
# make the scan read differently here than on the tree, and a guard proven under a different
# reading than the one it ships is proven of nothing. Each pen is `git init` plus `git add`; no
# commit is taken, since `git ls-files` and `git grep` read the index.
#
# WHY A PEN RATHER THAN THE LIVE TREE. Planting into the live launchers would move the tree a
# roster run is measuring, and a pen can also carry a launcher this pier would never ship.
#
#   sh tools/fixtures/p/pond_seal_gate_control.sh
set -eu
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
SCAN="$ROOT/tools/fixtures/p/pond_seal_gate_scan.sh"
SEAL_REL="tools/p/pond_exit_bron_master_seal.sh"

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM
pass=0
fail=0

echo "pond_seal_gate_control v1"

# new_pen -- a fresh repository carrying the seal and the three live launchers, indexed.
new_pen() {
  _p="$pen_root/$1"
  mkdir -p "$_p/tools/p" "$_p/tools/ag" "$_p/tools/cu" "$_p/tools/e" "$_p/tools/l" "$_p/rishi/bin" "$_p/tools/fixtures"
  cp "$ROOT/$SEAL_REL" "$_p/$SEAL_REL"
  cp "$ROOT/tools/e/enclosure_gate.sh" "$_p/tools/e/enclosure_gate.sh"
  cp "$ROOT/tools/ag/agent-jail.sh" "$_p/tools/ag/agent-jail.sh"
  cp "$ROOT/tools/cu/cursor-jail.sh" "$_p/tools/cu/cursor-jail.sh"
  cp "$ROOT/tools/l/launch-zed.sh.example" "$_p/tools/l/launch-zed.sh.example"
  ( cd "$_p" && git init -q . && git add -A ) >/dev/null 2>&1
  printf '%s' "$_p"
}

# reindex -- a plant is only visible to `git grep` once the index carries it.
reindex() { ( cd "$1" && git add -A ) >/dev/null 2>&1; }

# expect <name> <want-exit> <want-text> <pen>
expect() {
  _name=$1; _code=$2; _text=$3; _pen=$4
  set +e
  _out=$(sh "$SCAN" --root "$_pen" 2>&1)
  _got=$?
  set -e
  if [ "$_got" -eq "$_code" ] && printf '%s' "$_out" | grep -q -- "$_text"; then
    echo "ok: $_name"
    pass=$((pass + 1))
  else
    echo "no: $_name -- want exit $_code with '$_text', got exit $_got"
    printf '%s\n' "$_out" | sed 's/^/    /'
    fail=$((fail + 1))
  fi
}

# ---- the live seam, unplanted ------------------------------------------------------------------
p=$(new_pen live)
expect live_green 0 "verdict=green" "$p"
# 1 is the control's OWN construction -- new_pen copies the one admission door into the pen
# beside the three launchers that enter through it (the elder shape carried the gate in each
# launcher, and this line read sealed_gates=3 until 20260829) -- so this number can never go
# stale against the tree the way a copied tree-count would.
expect live_one_door 0 "sealed_gates=1" "$p"
expect live_no_ungated 0 "ungated_pond=0" "$p"
expect live_no_unrefused 0 "unrefused_seal=0" "$p"
expect live_no_unnamed 0 "unnamed_callers=0" "$p"

# ---- a fourth launcher admitting pond with no seal at all --------------------------------------
p=$(new_pen ungated)
cat > "$p/tools/l/launch-fourth.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  echo "pond it is"
fi
PLANT
reindex "$p"
expect ungated_bites 1 "verdict=ungated_pond" "$p"
expect ungated_named 1 "never reaches $SEAL_REL" "$p"
rm -f "$p/tools/l/launch-fourth.sh"; reindex "$p"
expect ungated_freed 0 "verdict=green" "$p"

# ---- a launcher reaching the seal in the weaker --policy mode ----------------------------------
p=$(new_pen weakmode)
cat > "$p/tools/l/launch-weak.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! bash "tools/p/pond_exit_bron_master_seal.sh" --policy; then exit 1; fi
fi
PLANT
reindex "$p"
expect weakmode_bites 1 "verdict=ungated_pond" "$p"
expect weakmode_named 1 "rather than --require" "$p"
rm -f "$p/tools/l/launch-weak.sh"; reindex "$p"
expect weakmode_freed 0 "verdict=green" "$p"

# ---- a seal call whose exit code nobody reads --------------------------------------------------
p=$(new_pen unrefused)
cat > "$p/tools/l/launch-loose.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  bash "tools/p/pond_exit_bron_master_seal.sh" --require || true
fi
PLANT
reindex "$p"
expect unrefused_bites 1 "verdict=unrefused_seal" "$p"
expect unrefused_named 1 "nothing reads its exit code" "$p"
rm -f "$p/tools/l/launch-loose.sh"; reindex "$p"
expect unrefused_freed 0 "verdict=green" "$p"

# ---- the case-statement spelling of admitting pond ---------------------------------------------
p=$(new_pen caseform)
cat > "$p/tools/l/launch-case.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
case "$ENCLOSURE" in
  pond) echo "pond" ;;
  *) echo "jail" ;;
esac
PLANT
reindex "$p"
expect caseform_bites 1 "verdict=ungated_pond" "$p"
rm -f "$p/tools/l/launch-case.sh"; reindex "$p"
expect caseform_freed 0 "verdict=green" "$p"

# ---- a properly sealed fourth caller the header does not name ----------------------------------
p=$(new_pen unnamed)
cat > "$p/tools/l/launch-sealed.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! bash "tools/p/pond_exit_bron_master_seal.sh" --require; then exit 1; fi
fi
PLANT
reindex "$p"
expect unnamed_bites 1 "verdict=unnamed_caller" "$p"
expect unnamed_counted 1 "unnamed_callers=1" "$p"
rm -f "$p/tools/l/launch-sealed.sh"; reindex "$p"
expect unnamed_freed 0 "verdict=green" "$p"

# ---- the header losing a name it carries -------------------------------------------------------
p=$(new_pen headerloss)
sed 's|tools/e/enclosure_gate.sh||' "$p/$SEAL_REL" > "$p/seal.tmp" && cat "$p/seal.tmp" > "$p/$SEAL_REL" && rm -f "$p/seal.tmp"
reindex "$p"
expect headerloss_bites 1 "verdict=unnamed_caller" "$p"
cp "$ROOT/$SEAL_REL" "$p/$SEAL_REL"; reindex "$p"
expect headerloss_freed 0 "verdict=green" "$p"

# ---- the .example equivalence, proven by removing the bare name --------------------------------
# The real launchers enter through the door since 20260829, so the elder direct-call gate is
# planted back into the pen's example -- the bare-name rule needs a live subject to prove.
p=$(new_pen exampleref)
cat > "$p/tools/l/launch-zed.sh.example" <<'PLANT'
#!/usr/bin/env sh
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! sh "${REPO_ROOT}/tools/p/pond_exit_bron_master_seal.sh" --require; then
    exit 1
  fi
elif [ "$ENCLOSURE" != "ai-jail" ]; then
  echo "REFUSE: ENCLOSURE must be ai-jail or pond (got: ${ENCLOSURE})" >&2
  exit 1
fi
PLANT
reindex "$p"
expect exampleref_green_first 0 "verdict=green" "$p"
sed 's|tools/l/launch-zed.sh|tools/l/nothing-here|' "$p/$SEAL_REL" > "$p/seal.tmp" && cat "$p/seal.tmp" > "$p/$SEAL_REL" && rm -f "$p/seal.tmp"
reindex "$p"
expect exampleref_bites 1 "launch-zed.sh.example calls the seal" "$p"
cp "$ROOT/$SEAL_REL" "$p/$SEAL_REL"; reindex "$p"
expect exampleref_freed 0 "verdict=green" "$p"

# ---- the numbers this control leans on, read off a run rather than spelled ---------------------
# A control that spells a number goes stale the lap the truth moves, so the live site count, the
# live pond count and the bound all come from the scan's own report.
p=$(new_pen readings)
base=$(sh "$SCAN" --root "$p" 2>&1 | awk -F= '/^selector_sites=/{print $2}')
live_pond=$(sh "$SCAN" --root "$p" 2>&1 | awk -F= '/^pond_admitting=/{print $2}')
ceiling=$(sh "$SCAN" --root "$p" 2>&1 | awk -F= '/^max_sites=/{print $2}')
echo "control_reads: selector_sites=$base pond_admitting=$live_pond max_sites=$ceiling"

# ---- ENCLOSURE_CONF is a different variable ----------------------------------------------------
p=$(new_pen confvar)
cat > "$p/tools/l/launch-conf.sh" <<'PLANT'
#!/usr/bin/env sh
CONF="${ENCLOSURE_CONF:-/dev/null}"
SECRETS="${ENCLOSURE_SECRETS:-/dev/null}"
echo "$CONF $SECRETS"
PLANT
reindex "$p"
expect confvar_not_a_site 0 "selector_sites=$base" "$p"
expect confvar_green 0 "verdict=green" "$p"

# ---- a mention inside a comment is not code ----------------------------------------------------
p=$(new_pen commentonly)
cat > "$p/tools/l/launch-comment.sh" <<'PLANT'
#!/usr/bin/env sh
# ENCLOSURE=pond would be admitted here one day, and this line is only a comment.
echo hello
PLANT
reindex "$p"
expect commentonly_not_a_site 0 "selector_sites=$base" "$p"
expect commentonly_green 0 "verdict=green" "$p"

# ---- a real selector site whose pond branch is commented out -----------------------------------
p=$(new_pen commentpond)
cat > "$p/tools/l/launch-cpond.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
# if [ "$ENCLOSURE" = "pond" ]; then echo pond; fi
echo "$ENCLOSURE"
PLANT
reindex "$p"
expect commentpond_is_a_site 0 "selector_sites=$((base + 1))" "$p"
expect commentpond_not_admitting 0 "pond_admitting=$live_pond" "$p"
expect commentpond_green 0 "verdict=green" "$p"

# ---- the bound, from both sides ----------------------------------------------------------------
p=$(new_pen boundunder)
i=0
while [ "$i" -lt $((ceiling - base)) ]; do
  printf '#!/usr/bin/env sh\nENCLOSURE="${ENCLOSURE:-ai-jail}"\necho "$ENCLOSURE"\n' > "$p/tools/l/filler-$i.sh"
  i=$((i + 1))
done
reindex "$p"
expect bound_at_ceiling 0 "selector_sites=$ceiling" "$p"
printf '#!/usr/bin/env sh\nENCLOSURE="${ENCLOSURE:-ai-jail}"\necho "$ENCLOSURE"\n' > "$p/tools/l/filler-over.sh"
reindex "$p"
expect bound_over 1 "verdict=unbounded" "$p"
rm -f "$p/tools/l/filler-over.sh"; reindex "$p"
expect bound_freed 0 "verdict=green" "$p"

# ---- a guard instrument's own plants are not launchers, and only in the fixtures room ----------
# Both conditions proven: the same bytes are skipped as tools/fixtures/x/plant_control.sh and bite
# as tools/l/plant_control.sh, so the exemption is the pair rather than the filename alone.
p=$(new_pen guardplant)
mkdir -p "$p/tools/fixtures/x"
cat > "$p/tools/fixtures/x/plant_control.sh" <<'PLANT'
#!/usr/bin/env sh
ENCLOSURE="${ENCLOSURE:-ai-jail}"
if [ "$ENCLOSURE" = "pond" ]; then
  echo "a control plants this on purpose"
fi
PLANT
reindex "$p"
expect guardplant_skipped 0 "verdict=green" "$p"
expect guardplant_uncounted 0 "selector_sites=$base" "$p"
cp "$p/tools/fixtures/x/plant_control.sh" "$p/tools/l/plant_control.sh"
rm -f "$p/tools/fixtures/x/plant_control.sh"
reindex "$p"
expect guardplant_outside_room_bites 1 "verdict=ungated_pond" "$p"

# ---- a root git cannot read is unreadable rather than empty ------------------------------------
p=$(new_pen gitless)
rm -rf "$p/.git"
expect gitless_unreadable 1 "verdict=unreadable" "$p"
expect gitless_named 1 "not a git repository" "$p"
( cd "$p" && git init -q . && git add -A ) >/dev/null 2>&1
expect gitless_freed 0 "verdict=green" "$p"

# ---- the seal itself absent --------------------------------------------------------------------
p=$(new_pen sealless)
rm -f "$p/$SEAL_REL"; reindex "$p"
expect sealless_unreadable 1 "verdict=unreadable" "$p"
cp "$ROOT/$SEAL_REL" "$p/$SEAL_REL"; reindex "$p"
expect sealless_freed 0 "verdict=green" "$p"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -ne 0 ]; then
  echo "control_verdict=red"
  exit 1
fi
echo "control_verdict=ok"
