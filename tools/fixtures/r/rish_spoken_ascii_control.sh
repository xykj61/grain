#!/bin/sh
# tools/fixtures/r/rish_spoken_ascii_control.sh -- the spoken/pattern line is proven, not assumed.
#
# WHY. This meter names a population of 11,154 characters that no guard had ever read, and the line
# it draws is finer than its comment siblings'. Those exclude "program content" wholesale; this one
# must let a `say` sentence through while holding back a `run [...]` grep pattern -- and the tree's
# own guards search for the very characters this meter counts, so a pattern read as prose would ask
# them to stop being able to find what they guard. Sixteen such patterns stand. Every reading is
# therefore planted in a throwaway git repository and proven from both sides.
#
# WHAT IS PROVEN -- the pen prints twenty-four keyed readings across the behaviors below, and each
# one is a claim the scan makes out loud. Nineteen are affirmative and five are refusals, and the
# refusals are proven exactly as hard, since a refusal shown only in the passing direction cannot
# be told from a bypass:
#    1  a `say` line with non-ASCII is counted -- Rishi's plainest way of speaking to a reader
#    2  an `assert ... else "..."` message is counted -- what a guard says when it refuses
#    3  an indented spoken line is counted, so leading whitespace does not hide prose
#    4  a `#` COMMENT is NOT counted -- the sibling meter's room, and charging one character to two
#       ceilings would make each reading depend on the other
#    5  a `run [...]` argument is NOT counted -- a grep pattern searching for an em dash must
#       CONTAIN one, and this meter must never ask a guard to go blind
#    6  a `let` binding is NOT counted -- a value may be fed onward, and following it is parsing
#    7  an `assert` with no `else "` message is NOT counted -- nothing is said
#    8  `say x` naming a variable counts nothing -- the named undercount, since following a value
#       is interpretation rather than scanning
#    9  the vendored rooms are left out, since those files are not ours to convert
#   10  a SYMLINK to a counted source is not counted a second time (REDS %340)
#   11  and its target is still counted on its own row, so the skip drops a duplicate, not a file
#   12  the planted total is exact -- one character per planted spoken file and nothing else
#   13  the SIX forms the rule's table names land in `table_forms`, which is the sweepable number
#   14  and notation outside that table lands in `notation`, which is a reader's judgment
#   15  a clean pen reads under the ceiling
#   16  one character past the ceiling REFUSES -- a refusal proven only in the passing direction
#       cannot be told from a bypass, and there is no override
#   17  removing the plant returns the reading to green, so the refusal is a gate rather than a latch
#   18  a BROKEN INSTRUMENT is named rather than counted as a clean zero (REDS %513)
#   19  and a broken instrument never answers `under_ceiling=yes`
#   20  a path `git ls-files` lists and the working tree no longer holds is skipped and COUNTED,
#       never fatal -- a rename staged mid-rebase is ordinary
#   21  the SPOKEN GATE is load-bearing: strip `if (!spoken) next` from a copy and the same pen
#       counts the grep pattern, so the exclusion is a mechanism rather than a lucky fixture
#   22  and that stripped copy counts the `let` binding too, from the same one deleted line
#
# SIXTEEN MORE, seated `20260910.180158` with the minus row and the converter:
#   23  a typographic minus in a spoken line is counted at all
#   24  and it lands in `table_forms`, since the rule's own table spells it -- the row this meter
#       lacked for its whole life while `tools/fixtures/a/ascii_document_scan.sh` carried it
#   25  and it therefore LEAVES `notation`, which means *a reader must choose* and was answering for
#       103 characters the law answers one way
#   26  `--check` reports and changes nothing, read off the bytes rather than off the report
#   27  a `say` line is converted -- the subject
#   28  an `assert ... else` message is converted -- what a guard says when it refuses
#   29  a minus is converted, so the converter and the scan carry ONE table
#   30  a `#` comment is NOT converted -- the sibling meter's room and its own ceiling
#   31  a `run [...]` grep pattern is NOT converted -- a guard hunting an em dash has to contain one
#   32  an assert's CONDITION survives whole
#   33  while its `else` message on the SAME LINE is still reached, so the two halves part at the
#       last ` else "` rather than at the first
#   34  a COUPLED SAYING is held back -- a spoken line another runner matches on. Rye's `print` and
#       Glow's `::` each speak to a person and to nobody else; a Rishi `say` is also a wire between
#       guards, and converting one end breaks the other
#   35  and a held line is NAMED out loud, since a silent hold reads as a clean sweep
#   36  the tracked exec bit survives the rewrite, which is what `cat "$tmp" > "$f"` buys
#   37  and the two instruments AGREE: after the sweep this pen reads exactly the five characters
#       whose reasons for standing are each nameable, and no others
#
# USAGE
#   sh tools/fixtures/r/rish_spoken_ascii_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/r/rish_spoken_ascii_scan.sh
OWN_ROOT=$PWD
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p room vendor/theirs

em='\xe2\x80\x94'
sec='\xc2\xa7'

# One non-ASCII character in each position, so the total itself names which readings fired.
printf "say \"a spoken line $em one\"\n"                          > room/spoken.rish
printf "assert x == y else \"a refusal $em one\"\n"               > room/refusal.rish
printf "  say \"indented $em one\"\n"                             > room/indented.rish
printf "# a comment $em one\n"                                    > room/comment.rish
printf "let bad = run [\"grep\" \"-c\" \"$em\" \"f\"]\n"           > room/pattern.rish
printf "let s = \"a value $em one\"\n"                            > room/binding.rish
printf "assert x == y\nassert a contains \"b\"\n"                 > room/no_message.rish
printf "let m = \"text $em one\"\nsay m\n"                        > room/via_variable.rish
printf "say \"notation $sec one\"\n"                              > room/notation.rish
printf "say \"theirs $em one\"\n"                                 > vendor/theirs/x.rish

# A link beside its target -- `git ls-files` lists both, and following each counts one set of bytes
# twice. The Rye meter reported a rise nobody had written that way (REDS %340).
ln -s spoken.rish room/link_to_spoken.rish
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
echo "$out" | grep '^RISH_SPOKEN_ASCII'

for name in spoken refusal indented notation; do
  echo "$out" | grep -q "room/$name.rish" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done
for name in comment pattern binding no_message via_variable; do
  echo "$out" | grep -q "room/$name.rish" && echo "${name}_counted=yes" || echo "${name}_counted=no"
done
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac

case "$out" in *"room/link_to_spoken.rish"*) echo "symlink_skipped=no";; *) echo "symlink_skipped=yes";; esac
case "$out" in *"room/spoken.rish"*) echo "symlink_target_kept=yes";; *) echo "symlink_target_kept=no";; esac

# Four spoken files, one character each, and nothing else -- five would mean the link was followed
# or a pattern was read as prose.
case "$out" in *"chars=4 "*) echo "total_is_four=yes";; *) echo "total_is_four=no";; esac
# Three of the four are em dashes from the rule's own table; the fourth is a section sign, which is
# notation a reader must choose a word for. The split is the whole reason both numbers are printed.
case "$out" in *"table_forms=3 "*) echo "table_split=yes";; *) echo "table_split=no";; esac
case "$out" in *"notation=1 "*) echo "notation_split=yes";; *) echo "notation_split=no";; esac
case "$out" in *"under_ceiling=yes"*) echo "clean_pen_under_ceiling=yes";; *) echo "clean_pen_under_ceiling=no";; esac

# The ceiling, from the refusing side. The scan's own ceiling is read rather than spelled here, so
# this stays true when a lap lowers it.
ceiling=$(printf '%s' "$out" | sed -n 's/.* ceiling=\([0-9][0-9]*\) .*/\1/p')
over=$((ceiling + 1))
{ printf 'say "'; i=0; while [ "$i" -lt "$over" ]; do printf "$em"; i=$((i + 1)); done; printf '"\n'; } > room/over.rish
git add -A >/dev/null 2>&1
loud=$(sh "$scan" 2>/dev/null)
case "$loud" in *"under_ceiling=no"*) echo "over_ceiling_refuses=yes";; *) echo "over_ceiling_refuses=no";; esac

rm -f room/over.rish
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
printf 'say "ghost $em one"\n' > room/ghost.rish
git add -A >/dev/null 2>&1
rm -f room/ghost.rish
ghost=$(sh "$scan" 2>/dev/null)
case "$ghost" in *"absent=1"*) echo "absent_counted=yes";; *) echo "absent_counted=no";; esac
case "$ghost" in *"instrument=failed"*) echo "absent_is_fatal=yes";; *) echo "absent_is_fatal=no";; esac
git rm -q --cached room/ghost.rish >/dev/null 2>&1

# 21  THE SPOKEN GATE IS LOAD-BEARING, proven by removing it. Every refusal above could also be
#     explained by a plant the meter simply never met, and a refusal proven only in the passing
#     direction cannot be told from a bypass. So the gate is stripped from a copy -- `if (!spoken)
#     next` deleted, nothing else touched -- and the same pen is read again. That copy counts the
#     grep pattern and the binding it must never see, which is what makes the gate a mechanism
#     rather than a coincidence of these particular fixtures.
sed 's/^      if (!spoken) next$//' "$scan" > ungated_scan.sh
ungated=$(sh ./ungated_scan.sh --list 2>/dev/null)
case "$ungated" in *"room/pattern.rish"*) echo "gate_is_load_bearing=yes";; *) echo "gate_is_load_bearing=no";; esac
case "$ungated" in *"room/binding.rish"*) echo "gate_holds_bindings=yes";; *) echo "gate_holds_bindings=no";; esac
rm -f ungated_scan.sh


# -- THE MINUS ROW (`20260910.180158`) -------------------------------------------------------------
#
# `.claude/rules/ascii-first.md` has spelled the typographic minus since it was seated, and both
# spoken meters classified it as `notation` -- a reader's judgment -- about a form the law answers
# one way. 103 of this meter's 365 notation characters were minus signs standing in arithmetic
# prose a reader writes plainly. The same disagreement was found and closed one meter over, in the
# document scan, and the lesson there is the lesson here: **a law and its instrument agreeing is a
# thing to measure rather than assume.**
minus='\xe2\x88\x92'
printf "say \"a minus $minus one\"\n" > room/minus.rish
git add -A >/dev/null 2>&1
mout=$(sh "$scan" 2>/dev/null)
case "$mout" in *"chars=5 "*) echo "minus_counted=yes";; *) echo "minus_counted=no";; esac
case "$mout" in *"table_forms=4 "*) echo "minus_is_named=yes";; *) echo "minus_is_named=no";; esac
case "$mout" in *"notation=1 "*) echo "minus_leaves_notation=yes";; *) echo "minus_leaves_notation=no";; esac

# -- THE CONVERTER (`20260910.180158`) -------------------------------------------------------------
#
# The scan says what stands; the converter is what lowers it. Its reach must be exactly the scan's,
# or a file it changes moves one meter and not the other. Every leg below is planted in this same
# pen and read off the BYTES afterward rather than off the converter's own report.
conv=$OWN_ROOT/tools/fixtures/r/rish_spoken_ascii_convert.sh
if [ -r "$conv" ]; then
  # A coupled saying: one runner matches on what another says. Convert one side of that wire and
  # the other side stops matching, so the line is held back whole. This exclusion has no sibling --
  # Rye's `print` and Glow's `::` each speak to a person and to nobody else.
  printf "say \"a wired sentence $em one\"\n"                        > room/coupled.rish
  printf "assert w.out contains \"a wired sentence $em one\" else \"held\"\n" > room/reader.rish
  git add -A >/dev/null 2>&1

  before=$(cat room/spoken.rish room/comment.rish room/pattern.rish room/coupled.rish)
  sh "$conv" --check room/spoken.rish room/comment.rish room/pattern.rish room/coupled.rish >/dev/null 2>&1
  after=$(cat room/spoken.rish room/comment.rish room/pattern.rish room/coupled.rish)
  [ "$before" = "$after" ] && echo "check_changes_nothing=yes" || echo "check_changes_nothing=no"

  creport=$(sh "$conv" --apply room/spoken.rish room/comment.rish room/pattern.rish room/coupled.rish room/minus.rish room/refusal.rish 2>/dev/null)
  grep -q -- '--' room/spoken.rish && echo "convert_say=yes" || echo "convert_say=no"
  grep -q -- '--' room/refusal.rish && echo "convert_refusal_message=yes" || echo "convert_refusal_message=no"
  grep -q 'a minus - one' room/minus.rish && echo "convert_minus=yes" || echo "convert_minus=no"
  high() { LC_ALL=C awk '/[\300-\377]/ { f = 1 } END { exit (f ? 0 : 1) }' "$1"; }
  high room/comment.rish && echo "convert_comment=no" || echo "convert_comment=yes"
  high room/pattern.rish && echo "convert_pattern=no" || echo "convert_pattern=yes"
  high room/coupled.rish && echo "convert_coupled=no" || echo "convert_coupled=yes"
  case "$creport" in *"held_coupled=1 "*) echo "coupled_reported=yes";; *) echo "coupled_reported=no";; esac

  # An assert's CONDITION is a match pattern and its `else` message is prose, on one line. The two
  # part at the LAST ` else "`, never the first, since a condition may itself hold those bytes and
  # reading the last converts less rather than more.
  printf "assert a.out contains \"target $em one\" else \"message $em two\"\n" > room/split.rish
  git add -A >/dev/null 2>&1
  sh "$conv" --apply room/split.rish >/dev/null 2>&1
  grep -q "target $(printf "$em") one" room/split.rish && echo "condition_held=yes" || echo "condition_held=no"
  grep -q -- 'message -- two' room/split.rish && echo "message_converted=yes" || echo "message_converted=no"

  # THE TRACKED MODE SURVIVES THE REWRITE. `cat "$tmp" > "$f"` writes through the original inode;
  # `mv` would carry the temporary file's mode instead (`.claude/rules/exec-bit.md`).
  printf "say \"executable $em one\"\n" > room/exec.rish
  chmod +x room/exec.rish
  git add -A >/dev/null 2>&1
  sh "$conv" --apply room/exec.rish >/dev/null 2>&1
  [ -x room/exec.rish ] && echo "mode_survives=yes" || echo "mode_survives=no"

  # AND THE TWO INSTRUMENTS AGREE, which is the whole claim. The scan's reading after the sweep
  # falls by exactly the characters the converter removed, and by no others.
  git add -A >/dev/null 2>&1
  aout=$(sh "$scan" 2>/dev/null)
  achars=$(printf '%s' "$aout" | sed -n 's/.* chars=\([0-9][0-9]*\) .*/\1/p')
  # FIVE is what an honest sweep leaves standing in this pen, and each one names a reason the
  # converter declined: the indented say and the notation say were never handed to it; the coupled
  # saying was held; its reader's line is spoken and its condition holds the wire's other end; and
  # the split line keeps its condition. Everything handed over and free went to zero.
  case "$achars" in
    5) echo "scan_falls_with_convert=yes" ;;
    *) echo "scan_falls_with_convert=no achars=$achars" ;;
  esac
else
  echo "converter_absent=yes"
fi
echo "control_verdict=ok"
