#!/bin/sh
# tools/fixtures/r/rye_spoken_ascii_control.sh -- the spoken/fed-onward line is proven, not assumed.
#
# WHY IT IS FINER THAN ITS SIBLINGS'. The two comment meters ask one question of a line: does it
# start with `//`, or with `#`. This meter has to tell three populations apart INSIDE one file, and
# two of them look alike from a line's distance:
#   * a `print(...)` region, which may run four lines as a chain of string literals joined by `++`,
#     and every one of those lines is prose;
#   * a `const src = \\...` raw string, whose bytes are fed onward to a parser and are behavior;
#   * a `//` comment, which belongs to the sibling meter and its own ceiling.
# So the scan reads parenthesis depth outside string literals, and the reading is planted in real
# git repositories and proven from both sides. A refusal shown only in the passing direction cannot
# be told from a bypass.
#
# THE TWO SHARPEST LEGS, both bought on the lap this was written:
#   * `fingerprint(` must never certify itself. `crypto/bip32.rye` documents a
#     `parent_fingerprint(4)` field, and a pattern matching `print\(` anywhere finds it. Three such
#     lines stand in the tree today, and the numerator fault they would cause is the one the fleet
#     booked one room over the same day: a guard counting something the rule does not turn on.
#   * A CONTINUATION LINE must be counted. Measured before this meter existed, 2,480 characters
#     stand on lines holding a `print(` call and 2,235 more on its continuation lines -- so a
#     line-oriented reading would have missed very nearly half its own subject and called the
#     remainder the tree.
#
# WHAT IS PROVEN -- the pen prints keyed readings, each a claim the scan or the converter makes out
# loud, and the refusals are proven exactly as hard as the affirmations.
#
# USAGE
#   sh tools/fixtures/r/rye_spoken_ascii_control.sh
#
# Run from the repository root; it reads only the scan and the converter from there.

set -u

scan=$PWD/tools/fixtures/r/rye_spoken_ascii_scan.sh
conv=$PWD/tools/fixtures/r/rye_spoken_ascii_convert.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }
[ -r "$conv" ] || { echo "control_verdict=no_convert"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p room vendor/theirs

em='\xe2\x80\x94'
sec='\xc2\xa7'

# One non-ASCII character in each position, so the total itself names which readings fired.
printf 'fn f() void { print("a spoken line %b one\\n", .{}); }\n' "$em"     > room/spoken.rye
printf 'fn f() void {\n    print("head " ++\n        "tail %b one\\n", .{});\n}\n' "$em" > room/continued.rye
printf 'fn f() void {\n        print("indented %b one\\n", .{});\n}\n' "$em" > room/indented.rye
printf '// a comment %b one\nfn f() void {}\n' "$em"                        > room/comment.rye
printf 'fn f() void { print("x\\n", .{}); } // trailing %b one\n' "$em"     > room/trailing.rye
printf 'const s = "a value %b one";\n' "$em"                                > room/binding.rye
printf 'const src =\n    \\\\a raw line %b one\n;\n' "$em"                  > room/raw.rye
printf 'fn f() void { const p = parent_fingerprint("%b one"); _ = p; }\n' "$em" > room/fingerprint.rye
printf 'fn f() void { std.debug.print("qualified %b one\\n", .{}); }\n' "$em"   > room/qualified.rye
printf 'fn f() void {\n    print("said\\n", .{});\n    const after = "%b one";\n    _ = after;\n}\n' "$em" > room/after.rye
printf 'fn f() void {\n    const open = %s(%s);\n    _ = open;\n    const later = "%b one";\n    _ = later;\n}\n' "'('" "'x'" "$em" > room/charlit.rye
printf 'fn f() void { print("notation %b one\\n", .{}); }\n' "$sec"         > room/notation.rye
printf 'fn f() void { print("theirs %b one\\n", .{}); }\n' "$em"            > vendor/theirs/x.rye

# A link beside its target -- `git ls-files` lists both, and following each counts one set of bytes
# twice. The Rye comment meter reported a rise nobody had written that way (REDS %340), and this
# tree's own `mantra/kumara.rye` is exactly such a link.
ln -s spoken.rye room/link_to_spoken.rye
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^RYE_SPOKEN_ASCII'

# COUNTED -- the three ways this tree puts a Rye sentence in front of a reader, plus the notation
# tail that must land in its own column.
for name in spoken continued indented qualified notation; do
  echo "$out" | grep -q "room/$name.rye" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done

# NOT COUNTED -- each line drawn where counting would be wrong rather than merely hard.
for name in comment trailing binding raw fingerprint after charlit; do
  echo "$out" | grep -q "room/$name.rye" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac

case "$out" in *"room/link_to_spoken.rye"*) echo "symlink_skipped=no";; *) echo "symlink_skipped=yes";; esac
case "$out" in *"room/spoken.rye"*) echo "symlink_target_kept=yes";; *) echo "symlink_target_kept=no";; esac

# Five spoken files, one character each, and nothing else -- six would mean the link was followed,
# a raw string was read as prose, or `fingerprint(` certified itself.
case "$out" in *"chars=5 "*) echo "total_is_five=yes";; *) echo "total_is_five=no";; esac
# Four of the five are em dashes from the rule's own table; the fifth is a section sign, which is
# notation a reader must choose a word for. The split is the whole reason both numbers are printed.
case "$out" in *"table_forms=4 "*) echo "table_split=yes";; *) echo "table_split=no";; esac
case "$out" in *"notation=1 "*) echo "notation_split=yes";; *) echo "notation_split=no";; esac
case "$out" in *"under_ceiling=yes"*) echo "clean_pen_under_ceiling=yes";; *) echo "clean_pen_under_ceiling=no";; esac

# THE CEILING, FROM THE REFUSING SIDE. The scan's own ceiling is read rather than spelled here, so
# this leg stays true when a lap lowers it.
ceiling=$(printf '%s' "$out" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
over=$((ceiling + 1 - 5))
{ printf 'fn f() void { print("'; i=0; while [ "$i" -lt "$over" ]; do printf "$em"; i=$((i + 1)); done; printf '\\n", .{}); }\n'; } > room/over.rye
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
case "$loud" in *"under_ceiling=no"*) echo "over_ceiling_refuses=yes";; *) echo "over_ceiling_refuses=no";; esac

rm -f room/over.rye
git add -A >/dev/null 2>&1
back=$(sh "$scan" 2>/dev/null)
case "$back" in *"under_ceiling=yes"*) echo "removed_returns_green=yes";; *) echo "removed_returns_green=no";; esac

# -- THE INSTRUMENT ITSELF (REDS %513) ------------------------------------------------------------
#
# Every reading above asks what the meter COUNTED; none asks whether it READ anything. An empty
# answer from a refused read is byte-identical to an empty answer from a clean file, and the second
# is the one everyone hopes for. One unclosed `if (` is a syntax error in every awk dialect, so this
# leg leans on no single implementation.
awk 'BEGIN{d=0} {print} (d==0 && $0 ~ /^  LC_ALL=C awk/) {print "    if ("; d=1}' "$scan" > broken_scan.sh
broke=$(sh ./broken_scan.sh 2>/dev/null)
case "$broke" in *"instrument=failed"*) echo "broken_instrument_named=yes";; *) echo "broken_instrument_named=no";; esac
case "$broke" in *"under_ceiling=yes"*) echo "broken_instrument_refuses=no";; *) echo "broken_instrument_refuses=yes";; esac
rm -f broken_scan.sh

# An absent path is skipped and COUNTED, never fatal. `git ls-files` reads the INDEX, so a rename
# staged mid-lap lists a path the working tree no longer holds, and a rebase is exactly when a
# reading is worth having.
printf 'fn f() void { print("ghost %b one\\n", .{}); }\n' "$em" > room/ghost.rye
git add -A >/dev/null 2>&1
rm -f room/ghost.rye
ghost=$(sh "$scan" 2>/dev/null)
case "$ghost" in *"absent=1"*) echo "absent_counted=yes";; *) echo "absent_counted=no";; esac
case "$ghost" in *"instrument=failed"*) echo "absent_is_fatal=yes";; *) echo "absent_is_fatal=no";; esac
git rm -q --cached room/ghost.rye >/dev/null 2>&1

# THE DEPTH GATE IS LOAD-BEARING, proven by removing it. Every refusal above could also be explained
# by a plant the meter never met. So `depth > 0` is stripped from a copy -- the one condition that
# makes a region spoken, nothing else touched -- and the same pen is read again. That copy counts
# the raw parser source and the plain binding it must never see, which is what makes the gate a
# mechanism rather than a coincidence of these particular fixtures.
sed 's/if (depth > 0 \&\& c ~ \/\[\\300-\\377\]\/)/if (c ~ \/[\\300-\\377]\/)/' "$scan" > ungated_scan.sh
ungated=$(sh ./ungated_scan.sh --list 2>/dev/null)
case "$ungated" in *"room/raw.rye"*) echo "gate_is_load_bearing=yes";; *) echo "gate_is_load_bearing=no";; esac
case "$ungated" in *"room/binding.rye"*) echo "gate_holds_bindings=yes";; *) echo "gate_holds_bindings=no";; esac
rm -f ungated_scan.sh

# -- THE CONVERTER, held to the same line ---------------------------------------------------------
#
# A sweep is only safe if it reaches exactly what the meter reads. So the converter is run over the
# same pen and its result is read from the BYTES, never from its own report.
sh "$conv" --apply room/spoken.rye room/comment.rye room/raw.rye room/notation.rye >/dev/null 2>&1
# The bytes are read with `tr`, never with a bracket class: `grep '[\300-\377]'` spells a range
# grep reads as literal characters, so that test answers the same on a clean file and a dirty one --
# a leg that cannot fail, which is the shape this tree booked twice on `20260908`.
high() { LC_ALL=C tr -d '\000-\177' < "$1" | wc -c | tr -d ' '; }
grep -q -- '--' room/spoken.rye && echo "convert_reaches_spoken=yes" || echo "convert_reaches_spoken=no"
[ "$(high room/spoken.rye)" = 0 ] && echo "convert_leaves_spoken_clean=yes" || echo "convert_leaves_spoken_clean=no"
[ "$(high room/comment.rye)" -gt 0 ] && echo "convert_spares_comment=yes" || echo "convert_spares_comment=no"
[ "$(high room/raw.rye)" -gt 0 ] && echo "convert_spares_raw=yes" || echo "convert_spares_raw=no"
[ "$(high room/notation.rye)" -gt 0 ] && echo "convert_spares_notation=yes" || echo "convert_spares_notation=no"

# IDEMPOTENCE REACHES A SECOND RUN, on a file that OWED WORK on the first. A converter correct only
# where nothing is owed passes a first-run check and re-appends forever after; this tree booked that
# exact shape one room over on `20260908`. So the bytes are compared across a genuine second pass.
cp room/continued.rye second.before
sh "$conv" --apply room/continued.rye >/dev/null 2>&1
cp room/continued.rye second.once
sh "$conv" --apply room/continued.rye >/dev/null 2>&1
cmp -s second.before second.once && echo "convert_first_pass_moved=no" || echo "convert_first_pass_moved=yes"
cmp -s second.once room/continued.rye && echo "convert_is_idempotent=yes" || echo "convert_is_idempotent=no"
rm -f second.before second.once

# A MODE IS TRACKED CONTENT (`.claude/rules/exec-bit.md`): the rewrite goes through the original
# inode, so an executable source stays executable.
printf 'fn f() void { print("moded %b one\\n", .{}); }\n' "$em" > room/moded.rye
chmod +x room/moded.rye
sh "$conv" --apply room/moded.rye >/dev/null 2>&1
[ -x room/moded.rye ] && echo "convert_keeps_mode=yes" || echo "convert_keeps_mode=no"

# `--check` reports and writes nothing -- a dry run that edits is worse than no dry run.
printf 'fn f() void { print("dry %b one\\n", .{}); }\n' "$em" > room/dry.rye
cp room/dry.rye dry.before
sh "$conv" --check room/dry.rye >/dev/null 2>&1
cmp -s dry.before room/dry.rye && echo "check_writes_nothing=yes" || echo "check_writes_nothing=no"
rm -f dry.before

echo "control_verdict=ok"
