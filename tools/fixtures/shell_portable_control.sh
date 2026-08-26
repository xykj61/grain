#!/bin/sh
# shell_portable_control.sh -- the two newest portable helpers, proven by doing.
#
# WHY A CONTROL RATHER THAN A READING. `resolve_path` and `sed_inplace` exist so a guard reads the
# same on both piers, and the only honest proof of that is behaviour: resolve a real symlink and
# compare against the tool this bench does have, edit a real file and read its bytes and its mode
# back. A count of call sites says a spelling changed; this says the spelling still works.
#
#   sh tools/fixtures/shell_portable_control.sh
#
# `resolve_path` is compared against `readlink -f` wherever this host carries a GNU one. On a bench
# without it the comparison is SKIPPED and said so out loud, because a comparison against a missing
# tool proves nothing and a silent skip is the vacuous pass this whole family was booked for.
set -eu

root=$(pwd)
. "$root/tools/fixtures/shell_portable.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
skip=0
ok()   { pass=$((pass + 1)); echo "  ok   $1"; }
bad()  { fail=$((fail + 1)); echo "  MISS $1"; }
note() { skip=$((skip + 1)); echo "  skip $1"; }

echo "shell-portable-control: resolve_path and sed_inplace, proven on real files"

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

echo "have_readlink_f=$have_rl"
echo "pass=$pass"
echo "skip=$skip"
echo "fail=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=behavior_missed"; exit 1; fi
