#!/bin/sh
# tools/fixtures/l/link_text_promise_control.sh -- prove the link-text reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Two mutations
# of the scan itself are asserted to bite, so a leg that would pass with the check removed is named
# here rather than trusted.
#
# USAGE
#   sh tools/fixtures/l/link_text_promise_control.sh
#
# Driven by tools/l/link_text_promise_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/l/link_text_promise_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg_ok: $1"
  else
    failed=$((failed + 1))
    echo "leg_no: $1 -- wanted $3, read $2"
  fi
}

# Build one repository holding every planted shape at once, so one reading proves many legs.
mk_repo() {
  d="$pen/$1"
  mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$d"
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2 }'; }

repo=$(mk_repo one)
cd "$repo"
mkdir -p room shelf room/date/20260101 room/archive room/yonder room/sub/deep vendor
: > room/real.md
: > room/sub/deep/leaf.md
: > shelf/target.md
: > room/date/20260101/20260101-010101_folded.md

# --- the welcomes: every one of these must stay uncounted ---
cat > room/welcomes.md <<'MD'
Anchor equals target: [`../shelf/target.md`](../shelf/target.md).
Anchor root-relative naming the same file: [`shelf/target.md`](../shelf/target.md).
Anchor naming a tracked directory: [`shelf/`](../shelf/target.md).
Anchor holding a space: [`not a path.md`](../shelf/target.md).
Anchor holding a fragment: [`gone/x.md#top`](../shelf/target.md).
Anchor holding a glob: [`gone/*.md`](../shelf/target.md).
Anchor with no slash: [`gone.md`](../shelf/target.md).
Anchor with an extension this tree does not write: [`gone/x.pdf`](../shelf/target.md).
Target on the web: [`gone/x.md`](https://example.invalid/x.md).
Target resolving nowhere is the lint's reading: [`gone/x.md`](../shelf/absent.md).
MD

# The one anchor only the PAGE-RELATIVE try can keep: `deep/leaf.md` stands under room/sub/ and
# nowhere at the root, so a reader reaching from this page finds it and a reader reaching from the
# root does not. Both spellings are honest, which is why the scan tries both.
cat > room/sub/page.md <<'MD'
Page-relative and honest: [`deep/leaf.md`](deep/leaf.md).
MD

# --- the one refusal, planted plainly ---
cat > room/promise.md <<'MD'
The visible path names a file this tree does not carry: [`room/gone.md`](../shelf/target.md).
MD

# --- testimony, counted apart and never gated ---
cat > room/20260101-010101_stamped.md <<'MD'
A stamped basename is testimony: [`room/gone.md`](../shelf/target.md).
MD
cat > room/date/20260101/20260101-010101_shelved.md <<'MD'
A day shelf is testimony: [`room/gone.md`](../../../shelf/target.md).
MD
cat > room/archive/kept.md <<'MD'
An archive shelf is testimony: [`room/gone.md`](../../shelf/target.md).
MD
cat > room/yonder/deferred.md <<'MD'
A yonder shelf is testimony: [`room/gone.md`](../../shelf/target.md).
MD
cat > vendor/held.md <<'MD'
A vendored page is read past entirely: [`room/gone.md`](../shelf/target.md).
MD

git add -A >/dev/null && git commit -qm pen

out=$(LINK_TEXT_PROMISE_CEILING=99 sh "$scan" 2>/dev/null || true)
leg "ten welcome shapes stay uncounted and one plant is read" "$(printf '%s\n' "$out" | read_key living)" 1
leg "four testimony shapes are counted apart" "$(printf '%s\n' "$out" | read_key testimony)" 4
leg "the vendored page is read past, so eleven of the twelve pages are read" "$(printf '%s\n' "$out" | read_key pages)" 11
leg "one page carries the living hit" "$(printf '%s\n' "$out" | read_key living_pages)" 1
leg "under its ceiling the scan is ok" "$(printf '%s\n' "$out" | read_key verdict)" ok

listed=$(LINK_TEXT_PROMISE_CEILING=99 sh "$scan" --list 2>/dev/null | grep -c 'room/promise.md shows room/gone.md' || true)
leg "--list names the page, what it shows, and what it opens" "$listed" 1

# --- the ceiling, proven from both sides with no slack ---
out=$(LINK_TEXT_PROMISE_CEILING=1 sh "$scan" 2>/dev/null || true)
leg "standing exactly at the ceiling walks free" "$(printf '%s\n' "$out" | read_key ceiling_ok)" yes
out=$(LINK_TEXT_PROMISE_CEILING=0 sh "$scan" 2>/dev/null || true)
leg "one over the ceiling refuses" "$(printf '%s\n' "$out" | read_key verdict)" over_ceiling
code=0
LINK_TEXT_PROMISE_CEILING=0 sh "$scan" >/dev/null 2>&1 || code=$?
leg "a refusal exits nonzero" "$code" 1

# --- lift the plant: the reading returns to zero ---
rm room/promise.md
git add -A >/dev/null && git commit -qm lift
out=$(LINK_TEXT_PROMISE_CEILING=0 sh "$scan" 2>/dev/null || true)
leg "with the plant lifted the living reading is zero" "$(printf '%s\n' "$out" | read_key living)" 0
leg "with the plant lifted a ceiling of zero walks free" "$(printf '%s\n' "$out" | read_key verdict)" ok

# --- tracked, never the filesystem: an untracked file does not answer for a promise ---
cat > room/promise.md <<'MD'
The visible path names an untracked file: [`room/untracked.md`](../shelf/target.md).
MD
git add -A >/dev/null && git commit -qm replant
: > room/untracked.md   # on disk, and in no commit
out=$(LINK_TEXT_PROMISE_CEILING=99 sh "$scan" 2>/dev/null || true)
leg "an untracked file on disk keeps the promise broken" "$(printf '%s\n' "$out" | read_key living)" 1
git add -A >/dev/null && git commit -qm track
out=$(LINK_TEXT_PROMISE_CEILING=99 sh "$scan" 2>/dev/null || true)
leg "tracking that same file keeps the promise" "$(printf '%s\n' "$out" | read_key living)" 0

# --- a fragment on the target is stripped before the target is resolved ---
cat > room/promise.md <<'MD'
A target fragment is stripped: [`room/gone.md`](../shelf/target.md#a-heading).
MD
git add -A >/dev/null && git commit -qm fragment
out=$(LINK_TEXT_PROMISE_CEILING=99 sh "$scan" 2>/dev/null || true)
leg "a target carrying a fragment still resolves and is read" "$(printf '%s\n' "$out" | read_key living)" 1

# --- refusals that are about the instrument rather than the tree ---
bare="$pen/bare"
mkdir -p "$bare"
out=$( cd "$bare" && sh "$scan" 2>/dev/null || true )
leg "outside a repository the scan refuses rather than answering" "$(printf '%s\n' "$out" | read_key verdict)" no_repo

# --- two mutations of the scan itself, each asserted to bite ---
# The scan reaches its portable-xargs helper through its own $0, so a mutant copy lives in a pen
# that mirrors the fixture layout rather than beside the pen's repository.
mkdir -p "$pen/fixtures/l" "$pen/fixtures/s"
cp "$root/tools/fixtures/s/shell_portable.sh" "$pen/fixtures/s/shell_portable.sh"
mut="$pen/fixtures/l/mut.sh"

sed 's|    if (here(norm(dir "/" txt))) continue|    if (0) continue|' "$scan" > "$mut"
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$mut" 2>/dev/null || true )
mutliving=$(printf '%s\n' "$out" | read_key living)
leg "dropping the page-relative anchor try makes honest links read as broken" \
  "$( [ "${mutliving:-0}" -gt 1 ] && echo bit || echo quiet )" bit

sed 's|    if (!here(norm(dir "/" tgt))) continue|    if (0) continue|' "$scan" > "$mut"
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$mut" 2>/dev/null || true )
mutliving=$(printf '%s\n' "$out" | read_key living)
leg "dropping the target-resolves check pulls in the lint's own reading" \
  "$( [ "${mutliving:-0}" -gt 1 ] && echo bit || echo quiet )" bit

# --- the batch fault this scan was born with, planted back ---
# `awk -f /dev/stdin` reads an exhausted stream from the second xargs batch on, which awk takes as
# an empty program -- so three quarters of this tree passed in silence and the reading read 9 of 69.
sed 's|xargs_lines "$work/pages.txt" awk -f "$work/read.awk"|xargs_lines_batched 1 "$work/pages.txt" awk -f /dev/stdin|' "$scan" > "$mut"
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$mut" < /dev/null 2>/dev/null || true )
mutliving=$(printf '%s\n' "$out" | read_key living)
leg "reading the program from an exhausted stdin makes the tree pass in silence" \
  "$( [ "${mutliving:-1}" -eq 0 ] && echo bit || echo quiet )" bit

# --- the --tsv reading, which is the converter's whole roster ---
# One reading printed two ways. If these part, the sweep and the meter read two populations.
cat > room/promise.md <<'MD'
The visible path names a file this tree does not carry: [`room/gone.md`](../shelf/target.md).
MD
git add -A >/dev/null && git commit -qm replant2

tsv=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$scan" --tsv 2>/dev/null || true )
leg "--tsv prints one row for the one living hit" "$(printf '%s\n' "$tsv" | grep -c .)" 1
leg "--tsv row is page, shown, opened" "$tsv" "$(printf 'room/promise.md\troom/gone.md\t../shelf/target.md')"
leg "--tsv keeps every summary line off stdout" "$(printf '%s\n' "$tsv" | grep -c '=' || true)" 0
leg "--tsv still sends its summary to stderr" \
  "$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$scan" --tsv 2>&1 >/dev/null | read_key living )" 1
code=0
( cd "$repo" && LINK_TEXT_PROMISE_CEILING=0 sh "$scan" --tsv >/dev/null 2>&1 ) || code=$?
leg "--tsv does not quietly skip the ceiling" "$code" 1
code=0
( cd "$repo" && sh "$scan" --nonsense >/dev/null 2>&1 ) || code=$?
leg "an unknown flag refuses rather than reading as no flag" "$code" 1

# --- the converter: the same roster, applied and proven ---
conv="$root/tools/fixtures/l/link_text_promise_convert.sh"
[ -f "$conv" ] || { echo "control_verdict=no_convert"; exit 1; }
cp "$scan" "$pen/fixtures/l/link_text_promise_scan.sh"
cp "$conv" "$pen/fixtures/l/conv.sh"
penconv="$pen/fixtures/l/conv.sh"

before=$(cat room/promise.md)
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" --dry 2>/dev/null || true )
leg "--dry names the one substitution" "$(printf '%s\n' "$out" | read_key substitutions)" 1
leg "--dry writes nothing" "$(cat room/promise.md)" "$before"

chmod +x room/promise.md
git update-index --chmod=+x room/promise.md >/dev/null 2>&1 || true
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" 2>/dev/null || true )
leg "the apply rewrites one anchor" "$(printf '%s\n' "$out" | read_key substitutions)" 1
leg "the apply re-derives that page from its committed bytes" "$(printf '%s\n' "$out" | read_key rederived)" 1
leg "nothing disagreed" "$(printf '%s\n' "$out" | read_key disagreed)" 0
leg "the apply's verdict names the proof" "$(printf '%s\n' "$out" | read_key verdict)" derived
leg "the anchor now shows the path the link opens" \
  "$(grep -c '\[`../shelf/target.md`\](../shelf/target.md)' room/promise.md)" 1
leg "the mode a page carried survives the write" "$( [ -x room/promise.md ] && echo yes || echo no )" yes
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=0 sh "$scan" 2>/dev/null || true )
leg "after the sweep the reading is zero at a ceiling of zero" "$(printf '%s\n' "$out" | read_key verdict)" ok
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" 2>/dev/null || true )
leg "a swept tree gives the converter nothing to do" "$(printf '%s\n' "$out" | read_key verdict)" nothing_to_do

# --- an edit beyond the rule refuses to re-derive ---
git checkout -q -- room/promise.md
printf 'A line the committed bytes never held.\n' >> room/promise.md
code=0
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" 2>/dev/null ) || code=$?
leg "a page carrying an unrelated edit fails to re-derive" "$(printf '%s\n' "$out" | read_key disagreed)" 1
leg "and the tool refuses rather than reporting success" "$code" 1
git checkout -q -- room/promise.md

# --- the name that proves the ./ prefix, planted as a page ---
# awk reads a bare argument holding an equals sign as a VARIABLE ASSIGNMENT rather than a file, so a
# page named this way would be read as a setting, produce no error, and leave the tree untouched --
# or, worse, hand awk an empty program and truncate what it wrote.
# It must sit at the ROOT: awk reads an argument as an assignment only when the name left of the
# equals sign is a valid identifier, and `room/eq` holds a slash, so a page one directory down is
# already safe by accident. The root is where the accident runs out.
cat > 'eq=1.md' <<'MD'
An equals sign in the page name: [`room/gone.md`](shelf/target.md).
MD
git add -A >/dev/null && git commit -qm oddname
leg "the scan sees a root page whose name holds an equals sign" \
  "$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$scan" 2>/dev/null | read_key living )" 2
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" < /dev/null 2>/dev/null || true )
leg "a page whose name holds an equals sign is swept like any other" \
  "$(grep -c '\[`shelf/target.md`\](shelf/target.md)' 'eq=1.md')" 1
leg "and it is not emptied" "$( [ -s 'eq=1.md' ] && echo yes || echo no )" yes
git checkout -q -- 'eq=1.md' room/promise.md

mutc="$pen/fixtures/l/mutconv.sh"
sed 's|"\$work/roster.tsv" "\./\$page"|"$work/roster.tsv" "$page"|g' "$penconv" > "$mutc"
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$mutc" < /dev/null 2>/dev/null || true )
penswept=$(grep -c '\[`shelf/target.md`\](shelf/target.md)' 'eq=1.md' || true)
leg "dropping the ./ prefix lets awk read that page name as an assignment" \
  "$( [ "$penswept" -eq 0 ] && echo bit || echo quiet )" bit
git checkout -q -- 'eq=1.md' room/promise.md

# The scan's own ./ prefix, asserted to bite on the same plant. Without it awk reads the root page
# as a setting, so the scan under-reports and the converter is handed a roster that never named it.
awk '/s\|\^\|\.\/\|/ { print "  > \"$work/pages.txt\" || true"; next } { print }' "$scan" > "$mut"
mutliving=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$mut" 2>/dev/null | read_key living )
leg "dropping the scan's ./ prefix hides that page from the reading" \
  "$( [ "${mutliving:-9}" -eq 1 ] && echo bit || echo quiet )" bit

# --- a roster that is not three fields refuses rather than being swept past ---
sed 's|^say() {|say() { echo "$@";|' "$penconv" > /dev/null 2>&1 || true
mutscan="$pen/fixtures/l/link_text_promise_scan.sh"
cp "$scan" "$mutscan.keep"
sed 's|say "pages=\$pages"|echo "pages=$pages"|' "$scan" > "$mutscan"
out=$( cd "$repo" && LINK_TEXT_PROMISE_CEILING=99 sh "$penconv" < /dev/null 2>/dev/null || true )
leg "a summary line leaking into the roster refuses the converter" \
  "$(printf '%s\n' "$out" | read_key verdict)" bad_roster
cp "$mutscan.keep" "$mutscan"

code=0
( cd "$bare" && sh "$penconv" >/dev/null 2>&1 ) || code=$?
leg "outside a repository the converter refuses" "$code" 1
code=0
( cd "$repo" && sh "$penconv" --nonsense >/dev/null 2>&1 ) || code=$?
leg "the converter refuses an unknown flag" "$code" 1

cd "$root"
echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
