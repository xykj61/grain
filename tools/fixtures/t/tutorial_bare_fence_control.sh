#!/bin/sh
# tools/fixtures/t/tutorial_bare_fence_control.sh -- the pen for
# tools/fixtures/t/tutorial_bare_fence_scan.sh.
#
# Every refusal is planted and then lifted, so a leg that passes in one direction alone cannot be
# told from a bypass. Real git repositories in a throwaway pen; the scan reads `git ls-files`, so a
# pen whose pages are merely on disk would read every script as untracked and every leg would pass
# for the wrong reason.
#
# THE MUTATIONS, each asserted to bite. A guard whose mutation changes no reading is a guard that
# reads nothing:
#
#   m1  reading a fence's label from the CLOSE rather than the opener
#   m2  treating `run_roster_why`'s pass answer as `no_command_line` -- the fall-through that hid
#       the whole population on the first draft of this reading
#   m3  dropping the lone/paired split, so a fence with a block beneath reads as safe to tag
#
# Run from the repository root:  sh tools/fixtures/t/tutorial_bare_fence_control.sh

set -u

ROOT=$(pwd)
# `sed -i` is GNU-only; the portable helper writes through the original inode on every host.
. "$(pwd)/tools/fixtures/s/shell_portable.sh"
SCAN="$ROOT/tools/fixtures/t/tutorial_bare_fence_scan.sh"
ROSTER="$ROOT/tools/fixtures/t/tutorial_run_roster.sh"

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$1" = "$2" ]; then
    printf 'leg %s ok (%s)\n' "$3" "$1"
  else
    failed=$((failed + 1))
    printf 'leg %s FAILED -- wanted %s, read %s\n' "$3" "$2" "$1"
  fi
}

# A pen holding one real git repository, one tracked script, and whatever pages the caller writes.
new_pen() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/docs-geode/tutorials" "$pen/tree/tools/fixtures/t"
  cd "$pen/tree" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/t/tutorial_bare_fence_scan.sh
  cp "$ROSTER" tools/fixtures/t/tutorial_run_roster.sh
  printf '#!/bin/sh\necho hello\n' > tools/fixtures/t/pen_scan.sh
}

seal_pen() {
  cd "$pen/tree" || exit 1
  git add -A >/dev/null 2>&1
  git commit -qm pen >/dev/null 2>&1
  cd "$ROOT" || exit 1
}

read_field() {
  # read_field <field> [env assignment ...]
  _f=$1; shift
  ( cd "$pen/tree" && env "$@" TUTORIAL_BARE_CORPUS='docs-geode/*.md' \
      sh tools/fixtures/t/tutorial_bare_fence_scan.sh 2>/dev/null ) |
    awk -F= -v f="$_f" '$1 == f { print $2; exit }'
}

# ---- 1. a lone untagged fence holding a tracked script refuses ---------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

Run this:

```
sh tools/fixtures/t/pen_scan.sh
```

Prose, and no block beneath.
MD
seal_pen
leg "$(read_field bare_runnable_lone)" 1 1a_lone_counted
leg "$(read_field bare_runnable_paired)" 0 1b_paired_zero
leg "$(cd "$pen/tree" && env TUTORIAL_BARE_CORPUS='docs-geode/*.md' \
        sh tools/fixtures/t/tutorial_bare_fence_scan.sh >/dev/null 2>&1; echo $?)" 1 1c_wall_bites

# ---- 2. tagging that same fence lifts the refusal -----------------------------------------------
cd "$pen/tree" || exit 1
sed_inplace 's/^```$/```sh/' docs-geode/tutorials/page.md
seal_pen
leg "$(read_field bare_runnable_lone)" 0 2a_tag_clears
leg "$(cd "$pen/tree" && env TUTORIAL_BARE_CORPUS='docs-geode/*.md' \
        sh tools/fixtures/t/tutorial_bare_fence_scan.sh >/dev/null 2>&1; echo $?)" 0 2b_wall_lifts

# ---- 3. a block beneath makes it PAIRED rather than lone ---------------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```
sh tools/fixtures/t/pen_scan.sh
```

```
hello
```
MD
seal_pen
leg "$(read_field bare_runnable_paired)" 1 3a_paired_counted
leg "$(read_field bare_runnable_lone)" 0 3b_not_lone
leg "$(cd "$pen/tree" && env TUTORIAL_BARE_CORPUS='docs-geode/*.md' \
        sh tools/fixtures/t/tutorial_bare_fence_scan.sh >/dev/null 2>&1; echo $?)" 0 3c_ratchet_holds
leg "$(read_field bare_runnable_paired PEN=x TUTORIAL_BARE_PAIRED_CEILING=0)" 1 3d_still_one
leg "$(cd "$pen/tree" && env TUTORIAL_BARE_CORPUS='docs-geode/*.md' TUTORIAL_BARE_PAIRED_CEILING=0 \
        sh tools/fixtures/t/tutorial_bare_fence_scan.sh >/dev/null 2>&1; echo $?)" 1 3e_ratchet_bites_at_zero

# ---- 4. the block must stand within MAX_GAP to pair ---------------------------------------------
new_pen
{
  printf '# A page\n\n```\nsh tools/fixtures/t/pen_scan.sh\n```\n\n'
  i=0; while [ "$i" -lt 14 ]; do printf 'filler line\n'; i=$((i + 1)); done
  printf '\n```\nhello\n```\n'
} > docs-geode/tutorials/page.md
seal_pen
leg "$(read_field bare_runnable_lone)" 1 4a_far_block_is_lone

# ---- 5. the roster's three refusals, each planted and each named --------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```
sh tools/fixtures/t/pen_scan.sh | grep hello
```

```
env FOO=1 tools/fixtures/t/pen_scan.sh
```

```
sh tools/fixtures/t/absent_scan.sh
```

```
Host github.com
```
MD
seal_pen
leg "$(read_field bare_runnable_lone)" 0 5a_none_runnable
classes=$( cd "$pen/tree" && env TUTORIAL_BARE_CORPUS='docs-geode/*.md' \
             sh tools/fixtures/t/tutorial_bare_fence_scan.sh 2>/dev/null |
           awk '/^off_roster_class:/ { print $2 }' | sort | tr '\n' ' ' )
leg "$classes" "metacharacter=1 off_roster=2 untracked=1 " 5b_classes_named

# ---- 6. an untracked script is untracked even when it sits on disk ------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```
sh tools/fixtures/t/untracked_scan.sh
```
MD
printf '#!/bin/sh\necho hi\n' > tools/fixtures/t/untracked_scan.sh
cd "$pen/tree" || exit 1
git add docs-geode tools/fixtures/t/tutorial_bare_fence_scan.sh tools/fixtures/t/tutorial_run_roster.sh tools/fixtures/t/pen_scan.sh >/dev/null 2>&1
git commit -qm pen >/dev/null 2>&1
cd "$ROOT" || exit 1
leg "$(read_field bare_runnable_lone)" 0 6a_disk_is_not_tracked

# ---- 7. a TAGGED fence is never a candidate, whatever it holds ----------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```sh
sh tools/fixtures/t/pen_scan.sh
```

```bash
sh tools/fixtures/t/pen_scan.sh
```
MD
seal_pen
leg "$(read_field untagged_fences)" 0 7a_tagged_invisible

# ---- 8. an empty untagged fence promises nothing ------------------------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```
```
MD
seal_pen
leg "$(read_field untagged_fences)" 1 8a_counted_as_a_fence
leg "$(read_field bare_runnable_lone)" 0 8b_never_runnable

# ---- 9. a trailing comment is a reader's aside, not a refusal ------------------------------------
new_pen
cat > docs-geode/tutorials/page.md <<'MD'
# A page

```
sh tools/fixtures/t/pen_scan.sh    # what this does
```
MD
seal_pen
leg "$(read_field bare_runnable_lone)" 1 9a_comment_carried

# ---- 10. no git tree refuses rather than reading zero --------------------------------------------
rm -rf "$pen/bare"; mkdir -p "$pen/bare"
out=$( cd "$pen/bare" && sh "$SCAN" 2>/dev/null | head -1 )
leg "$out" "verdict=not_a_git_tree" 10a_refuses_without_a_tree

# ---- 11. the mutations, each asserted to APPLY and then to bite ----------------------------------
# A mutation that fails to apply reads exactly like a mutation a guard survives, so each one is
# checked against the file's own bytes before its reading is taken. The first draft of this pen had
# two mutations whose patterns never matched, and both legs simply read the unmutated answer.
PAGE_PAIRED='# A page

```
sh tools/fixtures/t/pen_scan.sh
```

```
hello
```
'
PAGE_TAGGED='# A page

```sh
sh tools/fixtures/t/pen_scan.sh
```

```
hello
```
'

mutate_and_read() {
  # mutate_and_read <page body> <sed program> <file> <field> <leg name>
  new_pen
  printf '%s' "$1" > docs-geode/tutorials/page.md
  seal_pen
  cd "$pen/tree" || exit 1
  cp "$3" "$pen/pre.txt"
  sed_inplace "$2" "$3"
  if cmp -s "$pen/pre.txt" "$3"; then
    legs=$((legs + 1)); failed=$((failed + 1))
    printf 'leg %s FAILED -- the mutation matched nothing; the reading below would be the unmutated one\n' "$5"
  fi
  cd "$ROOT" || exit 1
  read_field "$4"
}

# m1 -- read the label from the CLOSE rather than the opener. Every close is a bare ```, so a
# TAGGED fence reads untagged and floods in. It bites only on a page holding a tagged fence, which
# is why this mutation carries its own page.
new_pen
printf '%s' "$PAGE_TAGGED" > docs-geode/tutorials/page.md
seal_pen
leg "$(read_field bare_runnable_paired)" 0 11a_tagged_page_reads_zero
got=$(mutate_and_read "$PAGE_TAGGED" 's/^      inside = 0$/      inside = 0; tag = substr($0, 4)/' \
        tools/fixtures/t/tutorial_bare_fence_scan.sh bare_runnable_paired 11b_m1)
leg "$got" 1 11b_m1_label_from_close_bites

# m2 -- the fall-through that hid the whole population on this reading's first draft: a block that
# PASSES answers `no_command_line`, so every runnable fence reads as empty.
got=$(mutate_and_read "$PAGE_PAIRED" 's/\[ "\$_rw_seen" -gt 0 \]/[ "$_rw_seen" -lt 0 ]/' \
        tools/fixtures/t/tutorial_run_roster.sh bare_runnable_paired 11c_m2)
leg "$got" 0 11c_m2_pass_reads_empty_bites

# m3 -- drop the lone/paired split, so a fence with a block beneath reads as safe to tag.
got=$(mutate_and_read "$PAGE_PAIRED" 's/elif \[ "${hasblock:-0}" -eq 1 \]; then/elif false; then/' \
        tools/fixtures/t/tutorial_bare_fence_scan.sh bare_runnable_lone 11d_m3)
leg "$got" 1 11d_m3_split_dropped_bites

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
