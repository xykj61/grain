#!/bin/sh
# tools/fixtures/p/prose_count_table_control.sh -- the pen for
# tools/fixtures/p/prose_count_table_scan.sh.
#
# Every refusal is planted and then lifted, so a leg that passes in one direction alone cannot be
# told from a bypass. Real git repositories in a throwaway pen, because the scan reads
# `git ls-files`: a pen whose pages merely sat on disk would read an empty corpus and every leg
# would pass for the wrong reason -- which is exactly what `prove-vacuum` exists to refuse.
#
# THE MUTATIONS, each asserted to bite. A guard whose mutation moves no reading reads nothing:
#
#   m1  drop the NEXT-BLOCK rule and count any table within reach, so prose about something else
#       three paragraphs up is read as a claim about the table
#   m2  drop the noun-in-header test, so a number standing near a table is read as a count of it
#   m3  drop the hyphen rule, so a section number (`### 6 - The Workrooms`) is read as a count
#   m4  read a fenced block as prose, so a count inside a code sample becomes a claim
#
# Run from the repository root:  sh tools/fixtures/p/prose_count_table_control.sh

set -u

ROOT=$(pwd)
# `sed -i` is GNU-only; the portable helper writes through the original inode on every host.
. "$(pwd)/tools/fixtures/s/shell_portable.sh"
SCAN="$ROOT/tools/fixtures/p/prose_count_table_scan.sh"

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

new_pen() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/docs-geode" "$pen/tree/tools/fixtures/p" "$pen/tree/tools/fixtures/s"
  cd "$pen/tree" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/p/prose_count_table_scan.sh
  cp "$ROOT/tools/fixtures/s/shell_portable.sh" tools/fixtures/s/shell_portable.sh
}

seal_pen() {
  cd "$pen/tree" || exit 1
  git add -A >/dev/null 2>&1
  git commit -qm pen >/dev/null 2>&1
  cd "$ROOT" || exit 1
}

read_field() {
  _f=$1
  ( cd "$pen/tree" && env PROSE_COUNT_CORPUS='docs-geode/*.md' \
      sh tools/fixtures/p/prose_count_table_scan.sh 2>/dev/null ) |
    awk -F= -v f="$_f" '$1 == f { print $2; exit }'
}

rc_of() {
  ( cd "$pen/tree" && env PROSE_COUNT_CORPUS='docs-geode/*.md' \
      sh tools/fixtures/p/prose_count_table_scan.sh >/dev/null 2>&1; echo $? )
}

mutate_and_read() {
  # mutate_and_read <sed expression> <field>
  _expr=$1; _field=$2
  cp tools/fixtures/p/prose_count_table_scan.sh "$pen/keep.sh" 2>/dev/null || \
    cp "$pen/tree/tools/fixtures/p/prose_count_table_scan.sh" "$pen/keep.sh"
  ( cd "$pen/tree" && sed_inplace "$_expr" tools/fixtures/p/prose_count_table_scan.sh )
  _got=$(read_field "$_field")
  cp "$pen/keep.sh" "$pen/tree/tools/fixtures/p/prose_count_table_scan.sh"
  echo "$_got"
}

# ---- 1. a count agreeing with the table beneath it ---------------------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Three rooms stand here, and the table says which.

| Room | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
leg "$(read_field pages)" 1 1a_one_page
leg "$(read_field sites)" 1 1b_site_seen
leg "$(read_field agree)" 1 1c_agrees
leg "$(read_field drift)" 0 1d_no_drift
leg "$(rc_of)" 0 1e_wall_lifts

# ---- 2. a row added under the same sentence drifts, and the wall bites --------------------------
cd "$pen/tree" || exit 1
printf '| d | four |\n' >> docs-geode/page.md
seal_pen
leg "$(read_field drift)" 1 2a_row_added_drifts
leg "$(read_field agree)" 0 2b_agree_falls
leg "$(rc_of)" 1 2c_wall_bites

# ---- 3. correcting the sentence lifts the refusal -----------------------------------------------
cd "$pen/tree" || exit 1
sed_inplace 's/^Three rooms/Four rooms/' docs-geode/page.md
seal_pen
leg "$(read_field drift)" 0 3a_sentence_repaired
leg "$(read_field agree)" 1 3b_agrees_again
leg "$(rc_of)" 0 3c_wall_lifts_again

# ---- 4. a heading carries the same claim -- MAP.md's own shape ----------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

## The Seven Rooms

| Room | Doors |
|---|---|
| 1 | a |
| 2 | b |
| 3 | c |
| 4 | d |
| 5 | e |
| 6 | f |
| 7 | g |
MD
seal_pen
leg "$(read_field sites)" 1 4a_heading_is_a_claim
leg "$(read_field agree)" 1 4b_heading_agrees

cd "$pen/tree" || exit 1
sed_inplace 's/^## The Seven Rooms/## The Six Rooms/' docs-geode/page.md
seal_pen
leg "$(read_field drift)" 1 4c_heading_drifts
leg "$(rc_of)" 1 4d_heading_wall_bites

# ---- 5. prose three paragraphs up is NOT a claim about the table --------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Two rooms stand apart in this tree, and which you want follows from who you are.

New here? Take three doors, in this order.

Two words on this shelf are our own.

| Room | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
leg "$(read_field sites)" 0 5a_distant_prose_is_not_a_claim
leg "$(rc_of)" 0 5b_no_false_refusal

# ---- 6. a count whose noun the header does not name is near_block, never a site -----------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Four places name it, and the table says where.

| Site | Reads |
|---|---|
| a | one |
| b | two |
| c | three |
| d | four |
MD
seal_pen
leg "$(read_field sites)" 0 6a_synonym_declined
leg "$(read_field near_block)" 1 6b_decline_is_visible

# ---- 7. a section number is not a count ---------------------------------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

### 6 - The Workrooms

| Workroom | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
leg "$(read_field sites)" 0 7a_section_number_declined
leg "$(rc_of)" 0 7b_no_false_refusal

# ---- 8. a compound adjective is not a count ------------------------------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

### Bar 6 -- three-door bus

| Door | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
leg "$(read_field sites)" 0 8a_compound_adjective_declined

# ---- 9. a count inside a fenced block is a code sample, never a claim ----------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Run this:

```sh
# Four rooms answer here
| Room | Role |
|---|---|
| a | one |
```

Prose after.
MD
seal_pen
leg "$(read_field sites)" 0 9a_fenced_count_declined
leg "$(rc_of)" 0 9b_no_false_refusal

# ---- 10. a count above a LIST is counted apart and never gated -----------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Three questions open this room:

- one
- two
MD
seal_pen
leg "$(read_field listform)" 1 10a_list_counted
leg "$(read_field sites)" 0 10b_list_is_not_a_site
leg "$(read_field drift)" 0 10c_list_never_gates
leg "$(rc_of)" 0 10d_list_disagreement_walks_free

# ---- 11. an empty corpus refuses rather than reading clean ---------------------------------------
new_pen
seal_pen
leg "$(rc_of)" 2 11a_vacuum_refuses
leg "$(read_field pages)" 0 11b_vacuum_names_itself

# ---- 12. the four mutations, each asserted to bite ------------------------------------------------
new_pen
cat > docs-geode/page.md <<'MD'
# A page

Two rooms stand apart in this tree, and which you want follows from who you are.

New here? Take three doors, in this order.

Two words on this shelf are our own.

| Room | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
# m1 -- drop the next-block rule: walk forward past intervening paragraphs to the first table.
leg "$(read_field sites)" 0 12a_next_block_holds
got=$(mutate_and_read 's#raw\[b\] ~ /\^\[ .t\]\*\$/#raw[b] !~ /^[ \\t]*[|]/#' sites)
leg "$([ "${got:-0}" -gt 0 ] && echo bit || echo silent)" bit 12b_m1_next_block_bites

new_pen
cat > docs-geode/page.md <<'MD'
# A page

Four places name it, and the table says where.

| Site | Reads |
|---|---|
| a | one |
| b | two |
| c | three |
| d | four |
MD
seal_pen
# m2 -- drop the noun-in-header test: a number near a table becomes a count of it.
leg "$(read_field sites)" 0 12c_header_test_holds
got=$(mutate_and_read 's#if (names(u, hdr))#if (1)#' sites)
leg "$([ "${got:-0}" -gt 0 ] && echo bit || echo silent)" bit 12d_m2_header_test_bites

new_pen
cat > docs-geode/page.md <<'MD'
# A page

### Bar 6 -- three-door bus

| Door | Role |
|---|---|
| a | one |
| b | two |
| c | three |
MD
seal_pen
# m3 -- drop the plural rule. The page is the one standing in docs/ENCLOSURE.md: a compound
# adjective parts into `three` and `door`, the table beneath happens to hold three rows, and the
# reading would call a coincidence a claim. Only the plural rule declines it.
leg "$(read_field sites)" 0 12e_plural_rule_holds
got=$(mutate_and_read 's#if (u !~ /(s|es|ies)$/) continue#if (0) continue#' sites)
leg "$([ "${got:-0}" -gt 0 ] && echo bit || echo silent)" bit 12f_m3_plural_bites

new_pen
cat > docs-geode/page.md <<'MD'
# A page

Run this:

```sh
Four rooms answer here

| Room | Role |
|---|---|
| a | one |
```

Prose after.
MD
seal_pen
# m4 -- read a fenced block as prose: a count inside a code sample becomes a claim.
got=$(mutate_and_read 's#      if (fence) continue#      if (0) continue#' sites)
leg "$([ "${got:-0}" -gt 0 ] && echo bit || echo silent)" bit 12g_m4_fence_bites

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
