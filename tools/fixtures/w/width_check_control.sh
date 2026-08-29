#!/bin/sh
# tools/fixtures/w/width_check_control.sh -- proves the width meter on planted repositories.
#
# WHY A CONTROL. `tools/w/width-check.rish` reported green for its whole life while reading nothing
# (REDS %285), so a green from its successor is worth exactly what its refusals are worth. Every
# reading below is shown from BOTH sides: the shape that must refuse is planted and watched to
# refuse, and the shape that must pass free is planted beside it and watched to pass. A wall proven
# only in the passing direction cannot be told from a bypass.
#
# Each pen is a real git repository in a throwaway directory, because the scan reads its corpus
# with `git ls-files` and its roster out of a real `tools/w/width-check.rish`.
#
# USAGE
#   sh tools/fixtures/w/width_check_control.sh
#
# Driven by tools/w/width-check.rish. Run from the repository root.

set -u

SCAN=$(CDPATH= cd "$(dirname "$0")" && pwd)/width_check_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent" >&2; exit 1; }

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM

fails=0
note() { echo "$1"; }
want() { # want <name> <expected ok|refuse> <actual exit>
  if [ "$2" = "ok" ] && [ "$3" -eq 0 ]; then note "$1=yes"; return; fi
  if [ "$2" = "refuse" ] && [ "$3" -ne 0 ]; then note "$1=yes"; return; fi
  note "$1=no"; fails=$((fails + 1))
}

new_pen() { # new_pen <name> -- prints the pen path, with a roster naming nothing yet
  p=$pen_root/$1
  mkdir -p "$p/tools/w"
  ( cd "$p" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  printf '# pen roster\n\nlet files = [%s]\n' "$2" > "$p/tools/w/width-check.rish"
  echo "$p"
}

stage() { ( cd "$1" && git add -A . >/dev/null 2>&1 ); }
run_scan() { sh "$SCAN" --root "$1" >"$1/.out" 2>"$1/.err"; echo $?; }

# ---- Reading one: the declared roster is gated at zero, and a seam cast passes free.
pen=$(new_pen roster '"a.rye" "b.rye"')
printf 'const x: u32 = 0;\n' > "$pen/a.rye"
printf 'const n: usize = @intCast(k);\nconst m = @as(usize, k);\n' > "$pen/b.rye"
stage "$pen"; want roster_clean_and_seam_pass ok "$(run_scan "$pen")"

printf 'var i: usize = 0;\n' >> "$pen/a.rye"
stage "$pen"; want roster_authored_usize_refused refuse "$(run_scan "$pen")"
grep -q 'roster_flag: ' "$pen/.out" && note "roster_flag_named=yes" || { note "roster_flag_named=no"; fails=$((fails + 1)); }

# ---- Reading two: a roster naming a file that is not there refuses rather than skipping.
pen=$(new_pen missing '"a.rye" "gone.rye"')
printf 'const x: u32 = 0;\n' > "$pen/a.rye"
stage "$pen"; want roster_missing_file_refused refuse "$(run_scan "$pen")"

# ---- Reading three: the named exemption is PINNED, so it stands at its count and a sixth refuses.
pen=$(new_pen exempt '"rishi/src/main.rye"')
mkdir -p "$pen/rishi/src"
i=1; : > "$pen/rishi/src/main.rye"
while [ "$i" -le 5 ]; do printf 'var v%s: usize = 0;\n' "$i" >> "$pen/rishi/src/main.rye"; i=$((i + 1)); done
stage "$pen"; want exempt_at_pin_passes ok "$(run_scan "$pen")"

printf 'var v6: usize = 0;\n' >> "$pen/rishi/src/main.rye"
stage "$pen"; want exempt_sixth_refused refuse "$(run_scan "$pen")"
grep -q 'exempt_moved: ' "$pen/.out" && note "exempt_move_named=yes" || { note "exempt_move_named=no"; fails=$((fails + 1)); }

# ---- Reading four: aurora, vendor, gratitude and dated testimony are outside the corpus.
pen=$(new_pen excluded '"a.rye"')
printf 'const x: u32 = 0;\n' > "$pen/a.rye"
mkdir -p "$pen/aurora" "$pen/vendor/x" "$pen/gratitude"
printf 'var p: usize = 0;\n' > "$pen/aurora/boot.rye"
printf 'var p: usize = 0;\n' > "$pen/vendor/x/lib.rye"
printf 'var p: usize = 0;\n' > "$pen/gratitude/read.rye"
printf 'var p: usize = 0;\n' > "$pen/20260101-010101_dated.rye"
stage "$pen"; want excluded_rooms_pass ok "$(run_scan "$pen")"
c=$(sed -n 's/^corpus_flagged_files=//p' "$pen/.out")
[ "$c" = "0" ] && note "excluded_not_counted=yes" || { note "excluded_not_counted=no ($c)"; fails=$((fails + 1)); }

# ---- Reading five: a corpus file outside the roster IS counted, so discovery genuinely reaches.
printf 'var p: usize = 0;\n' > "$pen/stranger.rye"
stage "$pen"; run_scan "$pen" >/dev/null
c=$(sed -n 's/^corpus_flagged_files=//p' "$pen/.out")
[ "$c" = "1" ] && note "corpus_discovers_stranger=yes" || { note "corpus_discovers_stranger=no ($c)"; fails=$((fails + 1)); }

# ---- Reading six: the corpus ceilings, from both sides.
ceil_files=$(sed -n 's/^corpus_files_ceiling=//p' "$pen/.out")
ceil_lines=$(sed -n 's/^corpus_lines_ceiling=//p' "$pen/.out")
pen=$(new_pen ceiling '"a.rye"')
printf 'const x: u32 = 0;\n' > "$pen/a.rye"
i=1
while [ "$i" -le "$ceil_files" ]; do printf 'var p: usize = 0;\n' > "$pen/f$i.rye"; i=$((i + 1)); done
stage "$pen"; want corpus_at_files_ceiling_passes ok "$(run_scan "$pen")"

printf 'var p: usize = 0;\n' > "$pen/f$((ceil_files + 1)).rye"
stage "$pen"; want corpus_over_files_ceiling_refused refuse "$(run_scan "$pen")"

rm -f "$pen/f$((ceil_files + 1)).rye"
# f1 is rewritten, so the other files carry ceil_files-1 lines; one past the ceiling needs +2.
over=$((ceil_lines - ceil_files + 2))
i=1; : > "$pen/f1.rye"
while [ "$i" -le "$over" ]; do printf 'var p%s: usize = 0;\n' "$i" >> "$pen/f1.rye"; i=$((i + 1)); done
stage "$pen"; want corpus_over_lines_ceiling_refused refuse "$(run_scan "$pen")"

# ---- Reading eight: the three sharpenings of 20260828, each shown from BOTH sides. Every case
# plants into the DECLARED roster, which is gated at zero, so a pass and a refusal are the same
# reading rather than a ratchet's arithmetic.
#
# A comment carrying the word says nothing about width; the same text as code does.
pen=$(new_pen comment '"a.rye"')
printf '//! the answer this seam writes for `usize` and builds in\n/// a usize by any other name\n// var i: usize = 0;\n' > "$pen/a.rye"
stage "$pen"; want comment_usize_free ok "$(run_scan "$pen")"
printf 'var i: usize = 0;\n' >> "$pen/a.rye"
stage "$pen"; want comment_uncommented_refused refuse "$(run_scan "$pen")"

# An extern declaration must match the C ABI, so its width is not ours to choose. The same
# signature without `extern` is ours, and refuses.
pen=$(new_pen externfn '"a.rye"')
printf 'pub extern fn CGBitmapContextCreate(data: ?*anyopaque, width: usize, height: usize) ?*anyopaque;\n' > "$pen/a.rye"
stage "$pen"; want extern_fn_seam_free ok "$(run_scan "$pen")"
printf 'pub fn our_own(width: usize, height: usize) void {}\n' >> "$pen/a.rye"
stage "$pen"; want extern_fn_without_extern_refused refuse "$(run_scan "$pen")"

# An identifier merely containing the five letters carries no type; a real annotation does.
pen=$(new_pen wholeword '"a.rye"')
printf 'const slice = self.cells[base..][0..n_usize];\nconst also = my_usize_total + usize_count;\n' > "$pen/a.rye"
stage "$pen"; want identifier_substring_free ok "$(run_scan "$pen")"
printf 'var n_usize: usize = 0;\n' >> "$pen/a.rye"
stage "$pen"; want identifier_with_real_type_refused refuse "$(run_scan "$pen")"

# ---- Reading seven: a tree with no roster file at all refuses rather than reading zero.
pen=$pen_root/noroster
mkdir -p "$pen"
( cd "$pen" && git init -q . )
want no_roster_refused refuse "$(sh "$SCAN" --root "$pen" >/dev/null 2>&1; echo $?)"

echo "control_checks=19"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=behavior_missing" >&2
exit 1
