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

# An empty or non-numeric pid file is a lock caught mid-creation, so it is waited on rather than
# reaped -- reaping there would hand two holders the same lock.
mkdir -p "$lk"; : > "$lk/pid"
( lock_acquire "$lk" 1 ) && bad "an empty pid file is waited on rather than reaped" || ok "an empty pid file is waited on rather than reaped"
mkdir -p "$lk"; printf 'not-a-pid\n' > "$lk/pid"
( lock_acquire "$lk" 1 ) && bad "a non-numeric pid file is waited on rather than reaped" || ok "a non-numeric pid file is waited on rather than reaped"
rm -rf "$lk"

# Releasing a lock nobody holds costs nothing, so a caller may release on every exit path.
lock_release "$pen/never-held.d" && ok "releasing an unheld lock is harmless" || bad "releasing an unheld lock is harmless"

# --- search_text -------------------------------------------------------------------------------
# The helper is grep, so a green here is the reading the two roster reds (dated_pattern,
# equinox_e123) were waiting on. Written when this pier carried no ripgrep; ripgrep arrived on
# `20260905` and the legs are unchanged by that, which is the point -- a helper that only reads
# right on the bench that happens to lack a tool is not a portable helper.
printf 'alpha\nbeta\n' > "$pen/hay.txt"
search_text -q alpha "$pen/hay.txt" && ok "search_text finds a match" || bad "search_text finds a match"
search_text -q missing "$pen/hay.txt" && bad "search_text misses a missing needle" || ok "search_text misses a missing needle"
search_text -q -i ALPHA "$pen/hay.txt" && ok "search_text -i matches across case" || bad "search_text -i matches across case"
printf 'a|b\n' > "$pen/pipe.txt"
search_text -q -F 'a|b' "$pen/pipe.txt" && ok "search_text -F treats a pipe as literal" || bad "search_text -F treats a pipe as literal"
search_text -q 'al|zz' "$pen/hay.txt" && ok "search_text alternation matches without -F" || bad "search_text alternation matches without -F"
printf 'hello\n' | search_text -q hello && ok "search_text reads stdin when no file is given" || bad "search_text reads stdin when no file is given"
search_text -z alpha "$pen/hay.txt" >/dev/null 2>&1 && bad "search_text refuses an unknown flag" || ok "search_text refuses an unknown flag"


# --- have_tool and require_tool ------------------------------------------------------------------
# The reflex: a guard that cannot run its instrument refuses, and says which instrument. Proven from
# both sides, because a refusal shown only in the passing direction cannot be told from a bypass.
# The absent name is one no bench carries and no PATH shim can accidentally supply.
absent=grain-no-such-instrument-20260905

have_tool grep && ok "have_tool finds a tool this bench carries" || bad "have_tool finds a tool this bench carries"
have_tool "$absent" && bad "have_tool refuses a tool no bench carries" || ok "have_tool refuses a tool no bench carries"
# A silent predicate must stay silent, or a caller branching on it pollutes the reading it prints.
[ -z "$(have_tool "$absent" 2>&1)" ] && ok "have_tool says nothing either way" || bad "have_tool says nothing either way"
ht_rc=0; ( have_tool ) >/dev/null 2>&1 || ht_rc=$?
[ "$ht_rc" -eq 2 ] && ok "have_tool with no name is misuse, not absence" || bad "have_tool with no name is misuse, not absence"

require_tool grep >/dev/null 2>&1 && ok "require_tool passes a tool that is present" || bad "require_tool passes a tool that is present"
[ -z "$(require_tool grep 2>&1)" ] && ok "require_tool prints nothing when the tool is there" || bad "require_tool prints nothing when the tool is there"

rt_out=$(require_tool "$absent" 2>/dev/null || true)
rt_rc=0; require_tool "$absent" >/dev/null 2>&1 || rt_rc=$?
[ "$rt_rc" -eq 127 ] && ok "require_tool refuses with the shell's own not-found status" \
  || bad "require_tool refuses with the shell's own not-found status (rc=$rt_rc)"
printf '%s\n' "$rt_out" | grep -q "^instrument=$absent\$" && ok "the refusal NAMES the instrument" \
  || bad "the refusal NAMES the instrument"
printf '%s\n' "$rt_out" | grep -q '^verdict=instrument_absent$' && ok "the refusal carries its own verdict" \
  || bad "the refusal carries its own verdict"
# On stdout rather than stderr: the reading that sent a lap to the wrong file was on stderr, which a
# witness reading `run` output does not keep. This leg reads stdout ALONE, so a helper that printed
# to stderr would miss it.
[ -n "$(require_tool "$absent" 2>/dev/null || true)" ] && ok "the refusal reaches stdout, where a witness reads" \
  || bad "the refusal reaches stdout, where a witness reads"

rt_use=$(require_tool "$absent" 'the roots row read' 2>/dev/null || true)
printf '%s\n' "$rt_use" | grep -q '^instrument_for=the roots row read$' && ok "an optional purpose is carried through" \
  || bad "an optional purpose is carried through"
printf '%s\n' "$rt_out" | grep -q '^instrument_for=' && bad "no purpose means no purpose line" \
  || ok "no purpose means no purpose line"
rq_rc=0; ( require_tool ) >/dev/null 2>&1 || rq_rc=$?
[ "$rq_rc" -eq 2 ] && ok "require_tool with no name is misuse, not absence" \
  || bad "require_tool with no name is misuse, not absence"

# THE REPAIR ITSELF, on the guard that taught the lesson. Run the e122 scan with the ripgrep
# directory taken off PATH and nothing else changed: before this lap it answered
# `verdict=misread / control_gate=failed`, accusing a control that had just printed verdict=ok.
e122=tools/fixtures/e/equinox_e122_roots_bench_kinds_scan.sh
if [ -f "$root/$e122" ] && have_tool rg; then
  # Drop whichever PATH entries actually hold an executable rg, rather than guessing at a directory
  # name. The first draft matched `/ripgrep-*/bin` and skipped on this pier, where the Nix store
  # prefixes that with a hash -- a skip is what a vacuous pass looks like from the outside, which is
  # the fault this whole file was written to refuse.
  norg=$(printf '%s' "$PATH" | tr ':' '\n' | while IFS= read -r d; do
    [ -n "$d" ] || continue
    [ -x "$d/rg" ] || printf '%s\n' "$d"
  done | paste -sd: -)
  if [ -n "$norg" ] && ! ( PATH=$norg; export PATH; command -v rg >/dev/null 2>&1 ); then
    e122_out=$( cd "$root" && PATH=$norg sh "$e122" 2>/dev/null || true )
    printf '%s\n' "$e122_out" | grep -q '^instrument=rg$' \
      && ok "a real guard without its instrument names rg rather than a file" \
      || bad "a real guard without its instrument names rg rather than a file"
    printf '%s\n' "$e122_out" | grep -q '^verdict=misread$' \
      && bad "the elder misread verdict is gone" || ok "the elder misread verdict is gone"
  else
    note "e122 without rg (no PATH entry to remove)"
  fi
else
  note "e122 without rg (scan absent, or this bench carries no rg to remove)"
fi
echo "have_readlink_f=$have_rl"
echo "pass=$pass"
echo "skip=$skip"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=behavior_missed"; exit 1; fi
