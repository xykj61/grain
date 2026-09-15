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

cd "$root"
echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=failed"; exit 1; fi
