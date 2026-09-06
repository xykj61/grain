#!/bin/sh
# shell_portable_control.sh -- the newest portable helpers, proven by doing.
#
# WHY A CONTROL RATHER THAN A READING. `resolve_path`, `sed_inplace`, and `search_text` exist so a
# guard reads the same on both piers, and the only honest proof of that is behaviour: resolve a real
# symlink and compare against the tool this bench does have, edit a real file and read its bytes
# and its mode back, search a real file with grep on a pier that ships no ripgrep. A count of call
# sites says a spelling changed; this says the spelling still works.
#
#   sh tools/fixtures/s/shell_portable_control.sh
#
# `resolve_path` is compared against `readlink -f` wherever this host carries a GNU one. On a bench
# without it the comparison is SKIPPED and said so out loud, because a comparison against a missing
# tool proves nothing and a silent skip is the vacuous pass this whole family was booked for.
set -eu

root=$(pwd)
. "$root/tools/fixtures/s/shell_portable.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
skip=0
ok()   { pass=$((pass + 1)); echo "  ok   $1"; }
bad()  { fail=$((fail + 1)); echo "  MISS $1"; }
note() { skip=$((skip + 1)); echo "  skip $1"; }

echo "shell-portable-control: resolve_path, sed_inplace, the build lock, and search_text, proven on real files"

mkdir -p "$pen/a/b" "$pen/other"
echo hello > "$pen/a/b/file.txt"
echo spaced > "$pen/other/two words.txt"
ln -s "$pen/a/b" "$pen/link-to-dir"
ln -s "$pen/a/b/file.txt" "$pen/link-to-file"

# Does this bench carry a readlink that answers -f? The parity cases need one.
if readlink -f "$pen/a/b/file.txt" >/dev/null 2>&1; then have_rl=yes; else have_rl=no; fi

parity() { # $1 label, $2 path
  if [ "$have_rl" = no ]; then note "$1 (no readlink -f on this host)"; return; fi
  _a=$(readlink -f "$2" 2>/dev/null || echo NONE)
  _b=$(resolve_path "$2" 2>/dev/null || echo NONE)
  if [ "$_a" = "$_b" ]; then ok "$1"; else bad "$1 (readlink=$_a resolve=$_b)"; fi
}

parity "a plain file resolves as readlink -f does"        "$pen/a/b/file.txt"
parity "a symlink to a file follows one hop"              "$pen/link-to-file"
parity "a symlink to a directory follows one hop"         "$pen/link-to-dir"
parity "a path carrying a space resolves whole"           "$pen/other/two words.txt"
parity "a directory resolves"                             "$pen/a/b"

# Relative input, resolved against the working directory the way readlink -f does.
( cd "$pen/a" && if [ "$have_rl" = yes ]; then
    _a=$(readlink -f b/file.txt); _b=$(resolve_path b/file.txt)
    [ "$_a" = "$_b" ] || exit 1
  fi ) && ok "a relative path resolves against the working directory" \
        || bad "a relative path resolves against the working directory"

# An absent directory has no absolute answer, so the helper refuses rather than inventing one.
resolve_path "$pen/nowhere/at/all/x" >/dev/null 2>&1 && bad "an absent directory refuses" || ok "an absent directory refuses"
resolve_path "" >/dev/null 2>&1 && bad "an empty path refuses" || ok "an empty path refuses"

# --- sed_inplace -------------------------------------------------------------------------------
printf 'alpha\nbeta\n' > "$pen/edit.txt"
chmod 755 "$pen/edit.txt"
before_mode=$(ls -l "$pen/edit.txt" | cut -c1-10)
sed_inplace 's|alpha|ALPHA|' "$pen/edit.txt"
[ "$(head -1 "$pen/edit.txt")" = ALPHA ] && ok "sed_inplace edits the file" || bad "sed_inplace edits the file"
[ "$(tail -1 "$pen/edit.txt")" = beta ] && ok "sed_inplace leaves untouched lines alone" || bad "sed_inplace leaves untouched lines alone"
after_mode=$(ls -l "$pen/edit.txt" | cut -c1-10)
[ "$before_mode" = "$after_mode" ] && ok "sed_inplace keeps the file's mode ($after_mode)" || bad "sed_inplace keeps the file's mode ($before_mode -> $after_mode)"
[ -z "$(find "$pen" -name '*.sp.*' 2>/dev/null)" ] && ok "sed_inplace leaves no temporary behind" || bad "sed_inplace leaves no temporary behind"

cp "$pen/edit.txt" "$pen/same.txt"
sed_inplace 's|nothing-matches-this|x|' "$pen/edit.txt"
cmp -s "$pen/edit.txt" "$pen/same.txt" && ok "a script matching nothing leaves the file byte-identical" || bad "a script matching nothing leaves the file byte-identical"

sed_inplace 's|a|b|' "$pen/absent.txt" >/dev/null 2>&1 && bad "sed_inplace refuses a missing file" || ok "sed_inplace refuses a missing file"

# --- lock_acquire / lock_release ---------------------------------------------------------------
# The lock replaces `flock -w`, which macOS does not ship at all (REDS %279), so what has to be
# proven is behaviour rather than a spelling: one holder at a time, a bounded refusal rather than a
# hang, and the one property a descriptor lock has for free -- release when its owner dies.
lk="$pen/build.lock.d"

lock_acquire "$lk" 2 && ok "an unheld lock is taken" || bad "an unheld lock is taken"
[ -d "$lk" ] && ok "the lock is a directory" || bad "the lock is a directory"
[ "$(cat "$lk/pid" 2>/dev/null)" = "$$" ] && ok "the holder writes its own pid inside" || bad "the holder writes its own pid inside"

# A SECOND acquire against a live holder waits its bound and refuses by return code. This is the
# refusal proven from the failing side: a lock that never refuses is not a lock.
held_start=$(date +%s)
( lock_acquire "$lk" 1 ) && bad "a held lock refuses a second holder" || ok "a held lock refuses a second holder"
held_end=$(date +%s)
[ "$((held_end - held_start))" -ge 1 ] && ok "the refusal waited its bound rather than failing instantly" \
  || bad "the refusal waited its bound rather than failing instantly"

lock_release "$lk"
[ -d "$lk" ] || ok "release frees the lock"
[ -d "$lk" ] && bad "release frees the lock"
lock_acquire "$lk" 2 && ok "a released lock is takeable again" || bad "a released lock is takeable again"
lock_release "$lk"

# A lock whose owner has gone is reaped rather than waited out. A pid that no process carries is
# what a killed build leaves behind, and waiting out the bound for it would turn one crash into
# every later run refusing.
mkdir -p "$lk"
# Reap a pid that has certainly exited: a child run and waited on.
( exit 0 ) & dead=$!
wait "$dead" 2>/dev/null || true
printf '%s\n' "$dead" > "$lk/pid"
lock_acquire "$lk" 2 && ok "a lock whose owner has died is reaped" || bad "a lock whose owner has died is reaped"
lock_release "$lk"

# An empty or non-numeric pid file is a lock caught mid-creation, so INSIDE the grace it is waited
# on rather than reaped -- reaping there would hand two holders the same lock. Both bounds below
# are shorter than the default grace, so both still refuse exactly as they did when this pair was
# seated.
mkdir -p "$lk"; : > "$lk/pid"
( lock_acquire "$lk" 1 ) && bad "an empty pid file is waited on rather than reaped" || ok "an empty pid file is waited on rather than reaped"
mkdir -p "$lk"; printf 'not-a-pid\n' > "$lk/pid"
( lock_acquire "$lk" 1 ) && bad "a non-numeric pid file is waited on rather than reaped" || ok "a non-numeric pid file is waited on rather than reaped"

# PAST the grace the same lock is reaped, because an owner that never wrote its pid never lived to
# release it. This is the half the seated pair could not reach, and the cost of not reaching it was
# measured rather than imagined: a lock left at 17:16 with a zero-byte pid blocked every Glow build
# on this pier for five hours and forty-five minutes, and the roster guard waiting behind it read
# `lantern_face green 1454s` against the 9.5s its own row declares (REDS %445).
mkdir -p "$lk"; : > "$lk/pid"
reap_start=$(date +%s)
lock_acquire "$lk" 30 3 && ok "an empty pid file past the grace is reaped" || bad "an empty pid file past the grace is reaped"
reap_end=$(date +%s)
[ "$((reap_end - reap_start))" -ge 2 ] && [ "$((reap_end - reap_start))" -lt 10 ] \
  && ok "the reap waited the grace out, and the grace rather than the bound" \
  || bad "the reap waited the grace out, and the grace rather than the bound"
lock_release "$lk"

mkdir -p "$lk"; printf 'not-a-pid\n' > "$lk/pid"
lock_acquire "$lk" 30 3 && ok "a non-numeric pid file past the grace is reaped" || bad "a non-numeric pid file past the grace is reaped"
lock_release "$lk"

# The DEFAULT grace is the one the Glow build lock actually gets -- glow_run_worker.sh passes a
# wait and no grace at all -- so it is proven by running rather than read off the assignment.
# BOTH timing legs carry an upper bound as well as a lower one, and that is what makes them bites
# rather than votes: against the elder function the acquire simply failed after its whole 30-second
# bound, so `elapsed >= 2` and `elapsed >= 4` were both trivially true and neither leg could tell
# the repair from the defect. The upper bound is what says the wait was the GRACE.
mkdir -p "$lk"; : > "$lk/pid"
def_start=$(date +%s)
lock_acquire "$lk" 30 && ok "the default grace reaps too, which is the grace the Glow build lock is given" \
  || bad "the default grace reaps too, which is the grace the Glow build lock is given"
def_end=$(date +%s)
[ "$((def_end - def_start))" -ge 4 ] && [ "$((def_end - def_start))" -lt 15 ] \
  && ok "the default grace is five observations -- longer than none, far shorter than the bound" \
  || bad "the default grace is five observations -- longer than none, far shorter than the bound"
lock_release "$lk"
rm -rf "$lk"

# Releasing a lock nobody holds costs nothing, so a caller may release on every exit path.
lock_release "$pen/never-held.d" && ok "releasing an unheld lock is harmless" || bad "releasing an unheld lock is harmless"

# --- search_text -------------------------------------------------------------------------------
# Proven on this pier, which ships no ripgrep: the helper is grep, so a green here is the
# reading the two roster reds (dated_pattern, equinox_e123) were waiting on.
printf 'alpha\nbeta\n' > "$pen/hay.txt"
search_text -q alpha "$pen/hay.txt" && ok "search_text finds a match" || bad "search_text finds a match"
search_text -q missing "$pen/hay.txt" && bad "search_text misses a missing needle" || ok "search_text misses a missing needle"
search_text -q -i ALPHA "$pen/hay.txt" && ok "search_text -i matches across case" || bad "search_text -i matches across case"
printf 'a|b\n' > "$pen/pipe.txt"
search_text -q -F 'a|b' "$pen/pipe.txt" && ok "search_text -F treats a pipe as literal" || bad "search_text -F treats a pipe as literal"
search_text -q 'al|zz' "$pen/hay.txt" && ok "search_text alternation matches without -F" || bad "search_text alternation matches without -F"
printf 'hello\n' | search_text -q hello && ok "search_text reads stdin when no file is given" || bad "search_text reads stdin when no file is given"
search_text -z alpha "$pen/hay.txt" >/dev/null 2>&1 && bad "search_text refuses an unknown flag" || ok "search_text refuses an unknown flag"

echo "have_readlink_f=$have_rl"
echo "pass=$pass"
echo "skip=$skip"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=behavior_missed"; exit 1; fi
