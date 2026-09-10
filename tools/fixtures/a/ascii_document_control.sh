#!/bin/sh
# tools/fixtures/a/ascii_document_control.sh -- prove the document ASCII reading by doing.
#
# WHY. A guard that cannot red guards nothing. This control builds real git repositories in a
# throwaway pen, plants one condition in each, runs the scan and the converter inside them, and
# checks that every refusal bites and every honest reading walks free. Each refusal is also LIFTED
# in its own pen, because a refusal proven only in the failing direction cannot be told from a
# guard that refuses everything. Nothing here touches the tree it is run from.
#
# THE ONE READING THIS FAMILY OWES ITSELF. The first draft of the scan carried an awk comment
# between a trailing `||` and its continuing newline; awk refused the whole program, the scan
# discarded the complaint, and it answered a clean zero for all 5,529 documents in the tree. So a
# file the instrument cannot read is planted here, and the scan must SAY SO rather than count it
# zero -- the meter's own subject, turned back on the meter.
#
# USAGE
#   sh tools/fixtures/a/ascii_document_control.sh
#
# Driven by tools/a/ascii_document_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/a/ascii_document_scan.sh
conv=$(pwd)/tools/fixtures/a/ascii_document_convert.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }
[ -f "$conv" ] || { echo "control_verdict=convert_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

EM=$(printf '\342\200\224')      # em dash -- on the rule's table
DOT=$(printf '\302\267')         # middle dot -- on the table, and two bytes rather than three
SEC=$(printf '\302\247')         # section sign -- NOT on the table, so a reader chooses
CHK=$(printf '\342\234\246')     # four-pointed star -- not on the table either

# A repository with a rule room, a Cursor room, and a documents room. Every pen starts clean.
build() {
  d=$pen/$1
  mkdir -p "$d/.claude/rules" "$d/.cursor/rules" "$d/docs"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf '# a rule, plainly written\n' > .claude/rules/one.md \
    && printf '# the twin, plainly written\n' > .cursor/rules/one.mdc \
    && printf '# a document, plainly written\n' > docs/GUIDE.md \
    && git add -A \
    && git commit -qm 'pen: one rule, one twin, one document' ) >/dev/null 2>&1
  echo "$d"
}

# Commit whatever the caller just planted, so `git ls-files` can see it.
seal() { ( cd "$1" && git add -A && git commit -qm 'pen: the plant' ) >/dev/null 2>&1; }

run_scan() { ( cd "$1" && shift && sh "$scan" "$@" 2>/dev/null; ) }
run_scan_env() { d=$1; shift; ( cd "$d" && env "$@" sh "$scan" 2>/dev/null; ) }

say() { echo "$1=$2"; }
holds() { # holds <name> <output> <pattern>
  case "$2" in *"$3"*) say "$1" yes ;; *) say "$1" no ;; esac
}

# --- 1. the enforce roster, from both sides -------------------------------------------------

d=$(build clean_rules)
out=$(run_scan "$d")
holds enforce_clean_free "$out" 'enforce=honored'
holds enforce_clean_zero "$out" 'enforce_chars=0'

d=$(build dirty_claude)
printf '# a rule %s written carelessly\n' "$EM" > "$d/.claude/rules/one.md"
seal "$d"
out=$(run_scan "$d")
holds enforce_claude_refuses "$out" 'enforce=failed'
holds enforce_claude_named "$out" 'detail_path=.claude/rules/one.md'
# lift the plant in the same pen: the refusal must let go, or it is a latch rather than a reading
printf '# a rule -- written carefully\n' > "$d/.claude/rules/one.md"
seal "$d"
holds enforce_lift_returns_green "$(run_scan "$d")" 'enforce=honored'

d=$(build dirty_cursor)
printf '# the twin %s written carelessly\n' "$DOT" > "$d/.cursor/rules/one.mdc"
seal "$d"
out=$(run_scan "$d")
holds enforce_reaches_cursor "$out" 'detail_path=.cursor/rules/one.mdc'

# A rule page born tomorrow is governed the day it lands, because the roster is a glob.
d=$(build newborn_rule)
printf '# a rule born today %s\n' "$EM" > "$d/.claude/rules/two.md"
seal "$d"
holds enforce_is_a_glob_not_a_list "$(run_scan "$d")" 'detail_path=.claude/rules/two.md'

# --- 1b. the derived canon: a page the law NAMES is walled like the law ----------------------
#
# The wall was two directory globs while the law is a graph, so a rule page stood at zero while
# the page it told a reader to read first stood in the ratchet behind seven characters of slack.
# Every leg here is shown from both sides, because a wall proven only where it bites cannot be
# told from a wall that bites everything.

# A page the rule room names in a BACKTICK -- how the law writes canon most of the time.
d=$(build cited_backtick)
printf '# a rule\n\nRead `docs/GUIDE.md` first.\n' > "$d/.claude/rules/one.md"
printf '# a document %s written carelessly\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
out=$(run_scan_env "$d" ASCII_DOC_CEILING=99)
holds derived_backtick_refuses "$out" 'detail_path=docs/GUIDE.md'
holds derived_backtick_is_enforced "$out" 'enforce=failed'
holds derived_backtick_counted "$out" 'enforce_derived=1'
# lift the plant in the same pen: the refusal must let go, or it is a latch
printf '# a document -- written carefully\n' > "$d/docs/GUIDE.md"
seal "$d"
holds derived_backtick_lift_green "$(run_scan_env "$d" ASCII_DOC_CEILING=99)" 'enforce=honored'

# The same page, cited as a MARKDOWN LINK with a `../../` prefix, which is the other shape.
d=$(build cited_link)
printf '# a rule\n\nSee [the guide](../../docs/GUIDE.md).\n' > "$d/.claude/rules/one.md"
printf '# a document %s written carelessly\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
holds derived_link_refuses "$(run_scan_env "$d" ASCII_DOC_CEILING=99)" 'detail_path=docs/GUIDE.md'

# THE OTHER SIDE, and the one that keeps the widening honest: a page NO rule names stays in the
# ratchet, where a ceiling prices it rather than a gate refusing it.
d=$(build uncited_stays_ratchet)
printf '# a rule, naming nothing\n' > "$d/.claude/rules/one.md"
printf '# a document %s written carelessly\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
out=$(run_scan_env "$d" ASCII_DOC_CEILING=99)
holds uncited_not_enforced "$out" 'enforce=honored'
holds uncited_derived_empty "$out" 'enforce_derived=0'
holds uncited_is_ratcheted "$out" 'ratchet_dirty_files=1'

# A CITED PAGE IS PRICED ONCE. Counted in both rosters it would pay twice, and a ceiling could
# then fall for a repair the gate had already required.
d=$(build cited_counted_once)
printf '# a rule\n\nRead `docs/GUIDE.md` first.\n' > "$d/.claude/rules/one.md"
printf '# a document %s written carelessly\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
holds cited_left_the_ratchet "$(run_scan_env "$d" ASCII_DOC_CEILING=99)" 'ratchet_dirty_files=0'

# The law cites paths this repository does not carry -- examples, fossils, other trees. Only a
# TRACKED page can be held to anything, so an untracked citation is read past rather than guessed.
d=$(build cited_untracked)
printf '# a rule\n\nRead `docs/ABSENT.md` first.\n' > "$d/.claude/rules/one.md"
seal "$d"
printf '# never committed %s\n' "$EM" > "$d/docs/ABSENT.md"
out=$(run_scan_env "$d" ASCII_DOC_CEILING=99)
holds cited_untracked_read_past "$out" 'enforce=honored'
holds cited_untracked_uncounted "$out" 'enforce_derived=0'

# A rule citing DATED testimony leaves it alone: accrete-never-break outranks the wall, and the
# ratchet reads the same basename past for the same reason.
d=$(build cited_testimony)
mkdir -p "$d/docs"
printf '# a rule\n\nSee `docs/20260906-131411_a-note.md`.\n' > "$d/.claude/rules/one.md"
printf 'testimony %s kept\n' "$EM" > "$d/docs/20260906-131411_a-note.md"
seal "$d"
out=$(run_scan_env "$d" ASCII_DOC_CEILING=0)
holds cited_testimony_read_past "$out" 'verdict=ok'
holds cited_testimony_uncounted "$out" 'enforce_derived=0'

# A rule naming a page in a CLOSED STACK leaves it alone too -- an archived shelf is immutable, so
# gating one would price a repair the law forbids.
d=$(build cited_archive)
mkdir -p "$d/docs/archive"
printf '# a rule\n\nSee `docs/archive/plain.md`.\n' > "$d/.claude/rules/one.md"
printf 'shelved %s kept\n' "$EM" > "$d/docs/archive/plain.md"
seal "$d"
holds cited_archive_read_past "$(run_scan_env "$d" ASCII_DOC_CEILING=0)" 'verdict=ok'

# A rule citing ITSELF or a sibling adds nothing: those pages are already walled by the glob, and
# counting them twice would make `enforce_derived` a number nobody could read.
d=$(build cited_sibling)
printf '# a rule\n\nSee `.claude/rules/two.md`.\n' > "$d/.claude/rules/one.md"
printf '# the sibling, plainly written\n' > "$d/.claude/rules/two.md"
seal "$d"
holds cited_sibling_uncounted "$(run_scan "$d")" 'enforce_derived=0'

# THE MEMBERSHIP IS REPORTED, which is the one thing derivation owes that a glob does not: a page
# can leave this wall by an edit made somewhere else, and a number nobody prints is a drop nobody
# sees.
d=$(build derived_membership_printed)
printf '# a rule\n\nRead `docs/GUIDE.md` first.\n' > "$d/.claude/rules/one.md"
seal "$d"
out=$(run_scan "$d")
holds derived_membership_reported "$out" 'enforce_derived=1'
holds globbed_membership_reported "$out" 'enforce_globbed=2'
# and the drop is legible: the rule stops citing, the count falls
printf '# a rule, naming nothing\n' > "$d/.claude/rules/one.md"
seal "$d"
holds derived_drop_is_visible "$(run_scan "$d")" 'enforce_derived=0'

# --- 2. the ratchet ceiling, from both sides -------------------------------------------------

d=$(build at_ceiling)
printf 'one %s here\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
holds ceiling_at_bound_free "$(run_scan_env "$d" ASCII_DOC_CEILING=1)" 'verdict=ok'
holds ceiling_over_refuses "$(run_scan_env "$d" ASCII_DOC_CEILING=0)" 'detail=ratchet_rose_above_ceiling'
# removing the plant returns the reading to green under the tighter ceiling
printf 'one -- here\n' > "$d/docs/GUIDE.md"
seal "$d"
holds ceiling_removed_returns_green "$(run_scan_env "$d" ASCII_DOC_CEILING=0)" 'verdict=ok'

# --- 3. what the ratchet reads past, each for its own reason ---------------------------------

skips() { # skips <name> <relative path>
  d=$(build "skip_$1")
  mkdir -p "$d/$(dirname "$2")"
  printf 'testimony %s kept\n' "$EM" > "$d/$2"
  seal "$d"
  holds "$1" "$(run_scan_env "$d" ASCII_DOC_CEILING=0)" 'verdict=ok'
}
skips stamped_basename_read_past       docs/20260906-131411_a-note.md
skips sprigless_stamp_read_past        docs/20260906-131411.md
skips date_room_read_past              docs/date/20260906/plain.md
skips archive_room_read_past           docs/archive/plain.md
skips yonder_room_read_past            docs/yonder/plain.md
skips fixtures_room_read_past          tools/fixtures/plain.md
skips vendor_read_past                 vendor/plain.md
skips gratitude_read_past              gratitude/plain.md
skips seed_read_past                   seed/plain.md

# And a living document in an ordinary room IS counted, or every reading above proves nothing.
d=$(build living_counted)
printf 'living %s counted\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
holds living_document_counted "$(run_scan_env "$d" ASCII_DOC_CEILING=0)" 'detail=ratchet_rose_above_ceiling'

# --- 4. the named / unnamed split, and the unit ----------------------------------------------

d=$(build split)
printf 'named %s and unnamed %s\n' "$EM" "$SEC" > "$d/docs/GUIDE.md"
seal "$d"
out=$(run_scan "$d")
holds named_counted "$out" 'ratchet_named=1'
holds unnamed_counted "$out" 'ratchet_unnamed=1'

# One em dash is ONE character, not the three bytes it is stored in. The sibling meters paid for
# this twice: an awk that iterates bytes read 3 where one that reads characters read 1, and one
# tree carried two readings of itself.
d=$(build unit)
printf '%s%s%s\n' "$EM" "$EM" "$EM" > "$d/docs/GUIDE.md"
seal "$d"
holds one_char_is_one "$(run_scan "$d")" 'ratchet_named=3'

# --- 5. the instrument says so when it cannot read --------------------------------------------

d=$(build unreadable)
printf 'a document %s here\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
chmod 000 "$d/docs/GUIDE.md"
out=$(run_scan "$d")
chmod 644 "$d/docs/GUIDE.md"
holds unreadable_file_refuses "$out" 'instrument=failed'
holds unreadable_file_named "$out" 'detail_path=docs/GUIDE.md'

# Outside a git work tree there is no index to read, and silence must not read as cleanliness.
plain=$pen/not_a_repo
mkdir -p "$plain"
holds outside_a_repo_refuses "$(cd "$plain" && sh "$scan" 2>/dev/null)" 'instrument=failed'

# A path in the index that is gone from the working tree is skipped and COUNTED, never fatal.
# A sibling scan died `fatal: cannot open file` on exactly this during a rebase, which is the one
# moment a reading is worth having.
d=$(build absent)
rm -f "$d/docs/GUIDE.md"
out=$(run_scan "$d")
holds absent_path_skipped "$out" 'ratchet_absent=1'
holds absent_path_not_fatal "$out" 'verdict=ok'

# A tracked path carrying a space is one path. This tree holds one, and a `for f in $LIST` would
# read it as two -- skipping one and counting the other absent.
d=$(build spaced)
printf 'spaced %s here\n' "$EM" > "$d/docs/a guide (1).md"
seal "$d"
out=$(run_scan "$d")
holds spaced_path_read_whole "$out" 'ratchet_absent=0'
holds spaced_path_counted "$out" 'ratchet_named=1'

# An untracked document is not this tree's to measure yet. The scan reads the INDEX.
d=$(build untracked)
printf 'untracked %s here\n' "$EM" > "$d/docs/DRAFT.md"
holds untracked_not_counted "$(run_scan "$d")" 'ratchet_named=0'

# --- 6. the converter: the table, the remainder, the mode, and the proof ----------------------

d=$(build convert)
printf 'named %s and unnamed %s and dot %s\n' "$EM" "$SEC" "$DOT" > "$d/docs/GUIDE.md"
seal "$d"
( cd "$d" && sh "$conv" docs/GUIDE.md ) >/dev/null 2>&1
body=$(cat "$d/docs/GUIDE.md")
holds convert_applies_em_dash "$body" 'named -- and'
holds convert_applies_middle_dot "$body" 'dot -'
case "$body" in *"$SEC"*) say convert_leaves_unnamed yes ;; *) say convert_leaves_unnamed no ;; esac
holds convert_reaches_zero_named "$(run_scan "$d")" 'ratchet_named=0'

# The verify leg re-derives the transform from the committed bytes, so the proof is a computation
# rather than a careful reading of a diff.
holds convert_verify_proves "$( cd "$d" && sh "$conv" --verify HEAD docs/GUIDE.md 2>/dev/null )" 'verify=honored'
printf 'a hand also edited this line\n' >> "$d/docs/GUIDE.md"
holds convert_verify_catches_a_hand "$( cd "$d" && sh "$conv" --verify HEAD docs/GUIDE.md 2>/dev/null )" 'verify=failed'

# A mode is tracked content, and a rewrite preserves it (`.claude/rules/exec-bit.md`).
d=$(build mode)
printf 'named %s here\n' "$EM" > "$d/docs/GUIDE.md"
chmod 755 "$d/docs/GUIDE.md"
seal "$d"
( cd "$d" && sh "$conv" docs/GUIDE.md ) >/dev/null 2>&1
if [ -x "$d/docs/GUIDE.md" ]; then say convert_keeps_the_mode yes; else say convert_keeps_the_mode no; fi

# A file already plain is left alone -- the converter does no work where none is owed.
d=$(build plain)
printf 'already -- plain\n' > "$d/docs/GUIDE.md"
seal "$d"
holds convert_leaves_plain_alone "$( cd "$d" && sh "$conv" docs/GUIDE.md 2>/dev/null )" 'unchanged=1'

# IDEMPOTENCE IS A SECOND RUN, AND THE ELDER CASE HERE NEVER REACHED ONE. It handed the converter a
# file that was ALREADY plain and read `unchanged=1` off a FIRST run that did nothing --
# `tools/c/convergence_prove.sh` calls that reading `inert`, and it prints the same `unchanged=1` a
# genuinely converged second run prints, so the two could not be told apart. Proven from the failing
# side in a pen (`20260908.190000`): a converter correct on a file needing no work, yet re-appending
# its sweep marker on every later run, reads `unchanged=1` under the elder case and `unchanged=0`
# here. The sibling `tools/fixtures/r/reds_ledger_headline_control.sh` had the shape right all along
# -- its case 1 repairs a drifted headline and its case 3 re-runs on that repaired file.
#
# The claim is `foundations/20260823-222019_what-brix-infuse-is.md`: infusion(world') -> world'.
# BOTH THE REPORT AND THE BYTES ARE READ, because a tool may print `unchanged=1` and still write.
d=$(build idempotent)
printf 'named %s here\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
( cd "$d" && sh "$conv" docs/GUIDE.md ) >/dev/null 2>&1
settled=$(cat "$d/docs/GUIDE.md")
holds convert_is_idempotent "$( cd "$d" && sh "$conv" docs/GUIDE.md 2>/dev/null )" 'unchanged=1'
if [ "$settled" = "$(cat "$d/docs/GUIDE.md")" ]; then say convert_second_run_moves_no_bytes yes; else say convert_second_run_moves_no_bytes no; fi

# AND THE CASE ABOVE IS PROVEN FROM THE FAILING SIDE, because a property asserted only where it
# holds cannot be told from a case that cannot fail -- which is exactly what the elder case was.
# A stand-in converter is planted that is CORRECT on a file needing no work and diverges only once
# it has done some: it applies the table, then re-appends its own sweep marker on every later run.
# The elder case's sample would have read `unchanged=1` from it and passed; the second run reads
# `unchanged=0` and moves bytes, so the repaired case bites.
d=$(build diverging)
cat > "$d/diverging_conv.sh" <<'SHIM'
#!/bin/sh
f=$1
before=$(cat "$f")
tmp=$(mktemp)
sed 's/\xe2\x80\x94/--/g' "$f" > "$tmp"
# The bug: the marker is re-appended whenever work was done OR a marker already stands, so the
# tool is correct on a file needing nothing and diverges forever once it has touched one.
if ! cmp -s "$f" "$tmp" || grep -q 'swept' "$f"; then printf '<!-- swept -->\n' >> "$tmp"; fi
cat "$tmp" > "$f"; rm -f "$tmp"
[ "$before" = "$(cat "$f")" ] && echo unchanged=1 || echo unchanged=0
SHIM
printf 'named %s here\n' "$EM" > "$d/docs/GUIDE.md"
seal "$d"
( cd "$d" && sh diverging_conv.sh docs/GUIDE.md ) >/dev/null 2>&1
settled=$(cat "$d/docs/GUIDE.md")
holds diverging_second_run_caught "$( cd "$d" && sh diverging_conv.sh docs/GUIDE.md 2>/dev/null )" 'unchanged=0'
if [ "$settled" = "$(cat "$d/docs/GUIDE.md")" ]; then say diverging_bytes_move no; else say diverging_bytes_move yes; fi
# The same stand-in, handed the ELDER case's already-plain sample, walks free -- which is the whole
# reason the elder case proved nothing.
printf 'already -- plain\n' > "$d/docs/GUIDE.md"
holds diverging_passes_elder_sample "$( cd "$d" && sh diverging_conv.sh docs/GUIDE.md 2>/dev/null )" 'unchanged=1'

# A star this table does not name survives the converter, exactly like the section sign.
d=$(build star)
printf 'a star %s stays\n' "$CHK" > "$d/docs/GUIDE.md"
seal "$d"
( cd "$d" && sh "$conv" docs/GUIDE.md ) >/dev/null 2>&1
case "$(cat "$d/docs/GUIDE.md")" in *"$CHK"*) say convert_leaves_the_star yes ;; *) say convert_leaves_the_star no ;; esac

echo "control_verdict=ok"
