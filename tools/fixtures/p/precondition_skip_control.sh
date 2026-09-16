#!/bin/sh
# precondition_skip_control.sh -- prove precondition_skip_scan.sh from both sides, on real
# git repositories in a throwaway pen, and prove the swept witnesses still refuse when the
# precondition IS met.
#
#   sh tools/fixtures/p/precondition_skip_control.sh
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every leg
# below is planted and then lifted, and two mutations of the scan are asserted to bite.
set -u

root=$(git rev-parse --show-toplevel)
scan="$root/tools/fixtures/p/precondition_skip_scan.sh"
# The pen edits its copy of the scan in place, and `sed -i` has no spelling both piers run --
# GNU takes no argument where BSD reads the next word as a backup suffix. The tree's own helper
# writes through a temporary and copies back, which every host runs. Sourced here, before any
# `cd` into the pen, because `root` is the only path to it once the pen is the working directory.
. "$root/tools/fixtures/s/shell_portable.sh"

legs=0
failed=0
leg() {
  legs=$((legs+1))
  if [ "$1" = "$2" ]; then
    echo "leg $3=ok"
  else
    echo "leg $3=FAILED want=$1 got=$2"
    failed=$((failed+1))
  fi
}

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkpen() {
  rm -rf "$pen/r"
  mkdir -p "$pen/r"
  cd "$pen/r" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  mkdir -p tools/w bin
  printf '/bin/\n' > .gitignore
  cp "$scan" ./scan.sh
  chmod +x ./scan.sh
}

# A file whose precondition REFUSES on a gitignored artifact.
plant_hard() {
  cat > tools/w/"$1".rish <<'EOF'
let seed_bin = "bin/seed"
let have = run ["test" "-x" seed_bin]
assert have.ok else "pen: build seed first"
EOF
}

# The same file, swept to the honest skip.
plant_skip() {
  cat > tools/w/"$1".rish <<'EOF'
let seed_bin = "bin/seed"
let have = run ["test" "-x" seed_bin]
if (have.ok == false) then say "pen: SKIP -- bin/seed is not built here"
if (have.ok == false) then exit 0
EOF
}

read_field() { grep '^precondition sites=' | sed "s/.*$1=\([0-9]*\).*/\1/"; }

# --- 1. a hard site is counted hard -------------------------------------------------
mkpen
plant_hard a
git add -A >/dev/null 2>&1; git commit -qm p
out=$(sh ./scan.sh 2>&1)
leg 1 "$(printf '%s\n' "$out" | read_field hard)" hard_counted

# --- 2. the swept form is counted skip, and hard falls to zero -----------------------
mkpen
plant_skip a
git add -A >/dev/null 2>&1; git commit -qm p
out=$(sh ./scan.sh 2>&1)
leg 1 "$(printf '%s\n' "$out" | read_field skip)" skip_counted
leg 0 "$(printf '%s\n' "$out" | read_field hard)" skip_is_not_hard

# --- 3. a TRACKED target is no precondition at all -----------------------------------
mkpen
mkdir -p held
cat > tools/w/a.rish <<'EOF'
let held_bin = "held/thing"
let have = run ["test" "-x" held_bin]
assert have.ok else "pen: held/thing missing"
EOF
echo x > held/thing
git add -A >/dev/null 2>&1; git commit -qm p
out=$(sh ./scan.sh 2>&1)
leg 0 "$(printf '%s\n' "$out" | read_field hard)" tracked_target_uncounted

# --- 4. an unresolved variable is UNRESOLVED, never hard -----------------------------
# This is the leg that holds the root-deny trap: a `.gitignore` denying the root answers YES
# to every bare word, so a scan trusting check-ignore alone reads a variable name as a
# gitignored build output.
mkpen
printf '/*\n!/tools/\n!/.gitignore\n!/scan.sh\n' > .gitignore
cat > tools/w/a.rish <<'EOF'
let have = run ["test" "-x" rishi_bin]
assert have.ok else "pen: rishi missing"
EOF
git add -A >/dev/null 2>&1; git commit -qm p
out=$(sh ./scan.sh 2>&1)
leg 0 "$(printf '%s\n' "$out" | read_field hard)" bare_name_not_hard
leg 1 "$(printf '%s\n' "$out" | read_field unresolved)" bare_name_unresolved

# --- 5. a display site is read ------------------------------------------------------
mkpen
cat > tools/w/a.rish <<'EOF'
let display = run ["sh" "-c" "test x$WAYLAND_DISPLAY != x"]
assert display.ok else "pen: WAYLAND_DISPLAY unset"
EOF
git add -A >/dev/null 2>&1; git commit -qm p
out=$(sh ./scan.sh 2>&1)
leg 1 "$(printf '%s\n' "$out" | read_field hard)" display_counted

# --- 6. the ceiling refuses from both sides -----------------------------------------
mkpen
plant_hard a
plant_hard b
plant_hard c
git add -A >/dev/null 2>&1; git commit -qm p
sed_inplace 's/^CEILING=.*/CEILING=3/' ./scan.sh
sh ./scan.sh >/dev/null 2>&1
leg 0 "$?" at_ceiling_passes
sed_inplace 's/^CEILING=.*/CEILING=2/' ./scan.sh
sh ./scan.sh >/dev/null 2>&1
leg 1 "$?" over_ceiling_refuses

# --- 7. mutation: drop the slash guard and the bare name reads as hard ---------------
mkpen
printf '/*\n!/tools/\n!/.gitignore\n!/scan.sh\n' > .gitignore
cat > tools/w/a.rish <<'EOF'
let have = run ["test" "-x" rishi_bin]
assert have.ok else "pen: rishi missing"
EOF
git add -A >/dev/null 2>&1; git commit -qm p
sed_inplace 's|^      \*/\*) : ;;|      */*) : ;;\
      pen_mutant) : ;;|' ./scan.sh
sed_inplace 's|^      \*) echo x >> "\$tmp.unres"; continue ;;|      *) : ;;|' ./scan.sh
out=$(sh ./scan.sh 2>&1)
leg 1 "$(printf '%s\n' "$out" | read_field hard)" mutation_bites_slash_guard

# --- 8. the swept witnesses still refuse when the precondition IS met ----------------
# A skip that always fires proves nothing. Plant an executable where the artifact belongs and
# confirm the witness walks PAST the skip and refuses on its own first real claim.
cd "$root" || exit 1
pen_bin="$pen/bin"
mkdir -p "$pen_bin"
cat > "$pen_bin/brushstroke-wayland-seed" <<'EOF'
#!/bin/sh
echo "pen stand-in -- no frame here"
exit 3
EOF
chmod +x "$pen_bin/brushstroke-wayland-seed"
if [ -e brushstroke/bin/brushstroke-wayland-seed ]; then
  echo "leg met_precondition_refuses=SKIPPED -- the real artifact is built on this clone"
else
  mkdir -p brushstroke/bin
  cp "$pen_bin/brushstroke-wayland-seed" brushstroke/bin/brushstroke-wayland-seed
  WAYLAND_DISPLAY=pen-display rishi/bin/rishi run tools/gen/chapter/surface_season_p49_witness.rish >/dev/null 2>&1
  rc=$?
  rm -f brushstroke/bin/brushstroke-wayland-seed
  rmdir brushstroke/bin 2>/dev/null
  leg 1 "$rc" met_precondition_still_refuses
fi

echo "control legs=$legs failed=$failed"
[ "$failed" -eq 0 ] || exit 1
echo "control_verdict=ok"
