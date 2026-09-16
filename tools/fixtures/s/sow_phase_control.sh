#!/bin/sh
# sow_phase_control.sh -- prove tools/fixtures/s/sow_phase_scan.sh reads what it says.
#
# Every refusal is planted and then LIFTED, so a leg proving a refusal is followed by one
# proving the same pen walks free once the plant is gone. A refusal shown only in the refusing
# direction cannot be told from a scan that refuses everything.
#
# The pen is a real git repository holding a miniature field: a manifest with allow rows, a
# publisher, the two drivers, and the projector the drivers call. Names match the field's,
# because the scan reads the projector and the witness by name.
#
#   sh tools/fixtures/s/sow_phase_control.sh
set -eu

SCAN=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)/tools/fixtures/s/sow_phase_scan.sh
[ -f "$SCAN" ] || { echo "control: scan missing at $SCAN" >&2; exit 2; }

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
fails=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    printf 'leg %-2d ok    %-38s %s\n' "$legs" "$1" "$2"
  else
    fails=$((fails + 1))
    printf 'leg %-2d FAIL  %-38s want=%s got=%s\n' "$legs" "$1" "$3" "$2"
  fi
}

read_key() { printf '%s\n' "$1" | tr ' ' '\n' | sed -n "s/^$2=//p" | head -1; }

build_pen() {
  rm -rf "$PEN/field"
  mkdir -p "$PEN/field/tools/s" "$PEN/field/tools/fixtures/s" "$PEN/field/room" "$PEN/field/other"
  cd "$PEN/field"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false

  cat > template-manifest.bron <<'EOF'
allow room
allow other
allow vendor
personal secrets
EOF
  printf 'one\n' > room/a.md
  printf 'two\n' > room/b.md
  printf 'three\n' > other/c.md

  cat > tools/fixtures/s/sow_project.sh <<'EOF'
#!/bin/sh
echo "SOW_OK copied=3 scrubbed=0 withheld=0"
EOF
  cat > tools/s/sow.rish <<'EOF'
# the thin driver -- the heavy work is tools/fixtures/s/sow_project.sh
let proj = run ["sh" "tools/fixtures/s/sow_project.sh"]
EOF
  cat > tools/s/sow_witness.rish <<'EOF'
# duty 2 projects fresh
let proj = run ["sh" "tools/fixtures/s/sow_project.sh"]
EOF
  cat > publish-seed.sh <<'EOF'
#!/bin/sh
rishi/bin/rishi run tools/s/sow.rish
rishi/bin/rishi run tools/s/sow_witness.rish
EOF
  chmod +x publish-seed.sh tools/fixtures/s/sow_project.sh
  git add -A
  # The base commit is dated in the past ON PURPOSE: the churn reading asks git for the newest
  # commit before a span, and a pen whose whole history is seconds old answers `unread` for every
  # span a reader would actually pass. A fixed date rather than a computed one, so the pen plants
  # the same history on every host.
  GIT_AUTHOR_DATE="2026-01-01T00:00:00 +0000" GIT_COMMITTER_DATE="2026-01-01T00:00:00 +0000" \
    git commit -q -m "pen: the miniature field"
}

run_scan() { ( cd "$PEN/field" && sh "$SCAN" "$@" 2>&1 | tr '\n' ' ' ); }

# ---- 1. the clean pen reads two projections and walks free -----------------------------------
build_pen
out=$(run_scan)
leg "clean verdict"            "$(read_key "$out" verdict)"                 ok
leg "clean projections"        "$(read_key "$out" projections_per_publish)" 2
leg "clean ceiling"            "$(read_key "$out" ceiling)"                 2
leg "publisher seen"           "$(read_key "$out" publisher_present)"       yes

# ---- 2. the candidate set is the allow rows, and vendor is not one of them --------------------
leg "allow paths counted"      "$(read_key "$out" allow_paths)"             2
leg "candidates counted"       "$(read_key "$out" candidates)"              3

# ---- 3. a third projection site refuses, and lifting it frees the pen ------------------------
printf 'let again = run ["sh" "tools/fixtures/s/sow_project.sh"]\n' >> "$PEN/field/tools/s/sow.rish"
out3=$(run_scan)
leg "third site refuses"       "$(read_key "$out3" verdict)"                over_ceiling
leg "third site counted"       "$(read_key "$out3" projections_per_publish)" 3
build_pen
out=$(run_scan)
leg "lifted, free again"       "$(read_key "$out" verdict)"                 ok

# ---- 4. a site inside a comment is prose, never a call ---------------------------------------
printf '# see tools/fixtures/s/sow_project.sh for the heavy work\n' >> "$PEN/field/tools/s/sow_witness.rish"
outc=$(run_scan)
leg "comment is not a site"    "$(read_key "$outc" projections_per_publish)" 2
leg "comment leaves it free"   "$(read_key "$outc" verdict)"                 ok

# ---- 5. the witness is in the closure even with the publisher absent -------------------------
build_pen
rm -f "$PEN/field/publish-seed.sh"
outp=$(run_scan)
leg "publisher absent named"   "$(read_key "$outp" publisher_present)"      no
leg "witness still counted"    "$(read_key "$outp" projections_per_publish)" 1

# ---- 6. the second hop is walked: a script the publisher never names ---------------------
build_pen
cat > "$PEN/field/tools/s/sow_deep.rish" <<'EOF'
let proj = run ["sh" "tools/fixtures/s/sow_project.sh"]
EOF
printf 'rishi/bin/rishi run tools/s/sow_deep.rish\n' >> "$PEN/field/tools/s/sow.rish"
( cd "$PEN/field" && git add -A && git commit -q -m "pen: a second hop" )
outd=$(run_scan)
leg "second hop reached"       "$(read_key "$outd" projections_per_publish)" 3
case " $(run_scan) " in *sow_deep.rish*) hop=named ;; *) hop=missing ;; esac
leg "second hop named"         "$hop"                                        named

# ---- 7. the third hop is invisible, which the header calls a proxy --------------------------
build_pen
cat > "$PEN/field/tools/s/sow_far.rish" <<'EOF'
let proj = run ["sh" "tools/fixtures/s/sow_project.sh"]
EOF
cat > "$PEN/field/tools/s/sow_mid.rish" <<'EOF'
rishi/bin/rishi run tools/s/sow_far.rish
EOF
printf 'rishi/bin/rishi run tools/s/sow_mid.rish\n' >> "$PEN/field/tools/s/sow.rish"
outf=$(run_scan)
leg "third hop unread"         "$(read_key "$outf" projections_per_publish)" 2

# ---- 8. churn is read from the field's own history -------------------------------------------
build_pen
outz=$(run_scan --span "50 years")
leg "churn before all history" "$(read_key "$outz" churn_changed)"          unread
leg "churn ref named none"     "$(read_key "$outz" churn_ref)"              none

printf 'changed\n' >> "$PEN/field/room/a.md"
printf 'new\n' > "$PEN/field/other/d.md"
( cd "$PEN/field" && git add -A && git commit -q -m "pen: two candidates move" )
outy=$(run_scan --span "1 day")
leg "churn counts two"         "$(read_key "$outy" churn_changed)"          2
leg "churn candidates grew"    "$(read_key "$outy" candidates)"             4
leg "churn pct computed"       "$(read_key "$outy" churn_pct)"              50.00
leg "cache hit is the rest"    "$(read_key "$outy" cache_hit_pct)"          50.00

# ---- 9. a change outside the allow rows is not churn ------------------------------------------
mkdir -p "$PEN/field/secrets"
printf 'private\n' > "$PEN/field/secrets/x.md"
( cd "$PEN/field" && git add -A && git commit -q -m "pen: a personal path moves" )
outs=$(run_scan --span "1 day")
leg "personal path not churn"  "$(read_key "$outs" churn_changed)"          2
leg "personal path no candidate" "$(read_key "$outs" candidates)"           4

# ---- 9b. a zero from a quiet span and a zero from a busy one are different facts ---------------
#
# Both print `churn_changed=0`. Only `churn_quiet` tells them apart: a span holding no commit at
# all resolves to HEAD and can only read zero, where a busy span's zero says the allow rooms
# genuinely stood still. Planted as a PAIR, because either leg alone passes under a scan that
# always answers the same word.
build_pen
outq=$(run_scan --span "1 second")
leg "quiet span reads zero"    "$(read_key "$outq" churn_changed)"          0
leg "quiet span named quiet"   "$(read_key "$outq" churn_quiet)"            yes
leg "quiet ref is head"        "$(read_key "$outq" churn_ref)"              "$( cd "$PEN/field" && git rev-parse --short=10 HEAD )"

mkdir -p "$PEN/field/secrets"
printf 'private\n' > "$PEN/field/secrets/q.md"
( cd "$PEN/field" && git add -A && git commit -q -m "pen: a commit that moves no candidate" )
outb=$(run_scan --span "1 day")
leg "busy span reads zero too" "$(read_key "$outb" churn_changed)"          0
leg "busy span not quiet"      "$(read_key "$outb" churn_quiet)"            no
leg "an unread span is neither" "$(read_key "$(run_scan --span "50 years")" churn_quiet)" unread

# ---- 10. the instrument refuses rather than guessing ------------------------------------------
build_pen
rm -f "$PEN/field/template-manifest.bron"
rc=0; ( cd "$PEN/field" && sh "$SCAN" >/dev/null 2>&1 ) || rc=$?
leg "no manifest refuses"      "$rc"                                        2

build_pen
rm -f "$PEN/field/tools/fixtures/s/sow_project.sh"
rc=0; ( cd "$PEN/field" && sh "$SCAN" >/dev/null 2>&1 ) || rc=$?
leg "no projector refuses"     "$rc"                                        2

build_pen
rc=0; ( cd "$PEN/field" && sh "$SCAN" --nonsense >/dev/null 2>&1 ) || rc=$?
leg "unknown argument refuses" "$rc"                                        2

echo "legs=$legs failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; fi
[ "$fails" -eq 0 ]
