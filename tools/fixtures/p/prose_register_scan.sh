#!/bin/sh
# tools/fixtures/p/prose_register_scan.sh -- prose that measures, measured.
#
# WHY. On 20260823 a freshly written front door was labelled Radiant and read as its opposite.
# Counted: 46% of README sentences and 54% of a founding statement's carried a negative, against
# 29% in RADIANT_STYLE.md itself -- a founding statement twice as negative as the guide it claimed
# to follow. The reading grade sat inside target the whole time, which is why nobody caught it.
#
# The meter that existed, tools/fixtures/r/radiant_negation_scan.sh, counts NEGATION WORDS across
# `.claude/rules/*.md` alone. Two gaps, both honest: the front door was never on its roster, and
# negative FRAMING -- fails, broken, lost, refused, stale, problem -- was never counted at all.
# This scan reads the second thing, on the tier where it does the most damage. The two meters are
# siblings rather than rivals: one guards the rules, one guards the door.
#
# WHAT IS GATED, hard. Every document on the DOOR roster keeps its negative-sentence share at or
# under 20%. The roster is named below rather than discovered, so a new file cannot join the
# enforced tier by accident and red on work it never agreed to cover.
#
# WHAT THE GATED TIER LEAVES OUT, counted on every run rather than written down once. A green
# door_over_ceiling=0 says THE DOORS THAT AGREED ARE INSIDE, rather than every door in the tree
# is -- the same distinction a roster-shaped guard owes its reader anywhere. So the scan reads
# every tracked README.md, holds it to the same eight-sentence floor, and prints the ones the
# roster leaves out that stand above the door ceiling: `front_doors`, `front_doors_readable`,
# `front_doors_unrostered_over` and a `candidate:` line naming each. A room joins by paying its
# way in -- sweep the page under the ceiling, then add its path to DOOR in the same commit --
# and its `candidate:` line goes away as it does. amphora/README.md did exactly that on
# 20260907, 29% of 41 sentences to 14%, six sentences restated to lead with what is and every
# claim, number and path held.
#
# THE POPULATION IS REPORTED AND NEVER GATED, for the reason the roster exists at all: a page
# that has agreed to nothing must not red the tree. What the reading buys is that the blind spot
# carries a live number and a list of names instead of a sentence somebody typed once. The elder
# form of this paragraph carried `80` and `30` measured 20260907, and a figure held in prose
# drifts the first lap nobody edits both -- which is the habit `.claude/rules/session-logs.md`
# already names: count them rather than quoting a number.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. The teaching tier --
# docs-geode/, docs/, manual/, docs-geode/edu/yonder/, and the root guides a newcomer opens -- counted as documents sitting
# above the Field target of 30%. Repair is a rewrite per document rather than a substitution, so
# these fall on touch. Measured at seating, the beginner tutorial itself read 59%.
#
# WHAT PASSES FREE, by named rule. Dated testimony keeps every word it wrote, so a file whose own
# basename carries a one-clock stamp is read past -- except where the DOOR roster names one
# outright, which is a deliberate choice to hold a founding statement to the front-door standard.
# Ledger rows, witness headers, and commit bodies are the Meter setting of context/GAUGE_STYLE.md
# and carry no ceiling; refusal-first is correct there, because refusal is the subject.
#
# WHAT IS NOT PROVEN. That the prose is GOOD. This counts negation density, which is one honest
# proxy among several, and the second number to read is always the prose itself. A page can pass
# this meter and still fail a reader.
#
# USAGE
#   sh tools/fixtures/p/prose_register_scan.sh
#
# Driven by tools/p/prose_register_witness.rish. Run from the repository root.

set -u

DOOR="README.md bat/README.md docs/README.md encoding/README.md foundations/README.md foundations/20260823-034321_the-return-that-feeds-everyone.md docs-geode/tutorials/the-first-hour.md docs-geode/demos/README.md caravan/README.md mycelium/README.md image/README.md lotus/README.md crypto/README.md constel/README.md amphora/README.md mikrophone/README.md"
DOOR_MAX=20
FIELD_MAX=30
# A share needs a denominator big enough to mean something. Below this many sentences the reading is
# arithmetic on a rounding error: one negative sentence out of one reads 100%, and one out of two
# reads 50%, neither of which says anything about how a page is written. The teaching tier has
# applied this floor since it was written; naming it here rather than spelling it inside the loop is
# what lets tools/fixtures/q/qa_report_card.sh CITE the number instead of copying it, the same way it
# already cites measure(). One floor, two readings, and no way for them to drift apart.
REGISTER_MIN_SENTENCES=8
# The candidate listing stops here and says so. Forty holds every front door this tree has ever
# read over the ceiling with room to spare, and an unbounded printout is an unbounded allocation.
FRONT_DETAIL_MAX=40
# THE CEILING ONLY EVER FALLS FOR A GIVEN READING, and on 20260906 the reading changed: measure()
# began reading the body paragraphs the `*` branch had been dropping (REDS %451), which is roughly
# twice the page on a Gauge document. A number the new reading produces and a number the old one
# produced are different measurements, so holding the first to the second's ceiling would refuse
# the tree for a repair that made the meter honest -- and a guard that reds on a correctness fix is
# a guard somebody turns off.
#
# So the ceiling is RE-SEATED at what the honest reading finds, with every number kept: 16 when the
# meter was seated 20260823, swept to 0 that day under the elder reading, and 5 under the reading
# from 20260906. The five are NAMED rather than counted, the way the DOOR roster already is, so the
# ceiling carries a population rather than an abstraction -- a lane sweeping one takes its name off
# and the number falls by one.
#
#   document                                   elder        now
#   docs-geode/wiki/README.md                  57% of 7     50% of 10   (under the 8-sentence floor, so unread)
#   manual/guides/macos-ai-jail-setup.md       22% of 49    37% of 70
#   docs-geode/edu/yonder/funds/gren-creating-one-of-twelve.md   22% of 18    35% of 28
#   manual/guides/self-hosted-vpn-setup.md     26% of 15    33% of 18
#   manual/guides/walking-the-rounds.md        30% of 53    31% of 66
#
# None of the five got worse. Each page has read over the Field target the whole time; the elder
# meter was reading a part of it, and the sentence counts beside each are how much of a part.
#
# THE CEILING FELL 5 TO 4 ON 20260910, and the byte it gave back was never a page. The list above
# names five and its own first row says docs-geode/wiki/README.md sits under the eight-sentence
# floor, so the reading has never counted it and the tier has read 4 since the day it was seated.
# The ceiling was set by counting the prose list rather than by asking the meter, which bought one
# slot for a page no lane could ever sweep off it. Four is what the reading answers.
ceiling=4

# THE COMPRESSOR SHELF JOINED THE TEACHING TIER ON 20260910, and it arrived by the road the ASCII
# wall took through the same room that morning. docs/ is where MAP.md sends a newcomer after the
# front door, and no register meter had ever read it: the DOOR roster names docs/README.md alone,
# and the teaching glob reached docs-geode/ and manual/ straight past the rest. A room held by
# nothing is a room that drifts in the one place everybody looks.
#
# MEASURED BEFORE THE CHANGE, over the 11 of 15 pages clearing the eight-sentence floor: exactly
# two stood above the Field target, and both were pages whose SUBJECT is refusal --
# docs/WITNESS_PATTERNS.md at 52% of 17 sentences and docs/ENCLOSURE.md at 31% of 47. The room paid
# its way in rather than buying a raise: WITNESS_PATTERNS reads 29% and ENCLOSURE 27% from this
# commit, four sentences restated in the first and two in the second, every claim, path, stamp and
# verdict word held. The ceiling stays 4, and docs/ joins clean. A room brought under a guard while
# it is clean stays clean; the same room brought under it later is a repair somebody has to
# schedule -- docs-geode/README.md wrote that sentence about itself two days earlier.
#
# WHAT THE SWEEP LEFT STANDING is the reading worth carrying forward. WITNESS_PATTERNS keeps five
# counted sentences and every one of them is what the page is about: a candidate artifact ABSENT,
# the negative-space assert, the paired-refuse law, and the policy verdict REFUSE itself. The four
# that left were incidental -- `not duplicated here`, `never delete the stage`, `one green without
# its pair`, `landing probes opens no season`. docs/CRYPTO.md sits at exactly 30 and stays there,
# and its negatives are the claims a crypto page exists to make: no libc, no real identity key, no
# network, no funds. A target is a ceiling rather than a goal, and a page about refusal spends more
# of it honestly.
#
# WHAT THIS READING DOES NOT SETTLE, named rather than left for a reader to trip on. Three pages
# now sit on the DOOR roster AND inside the teaching glob -- docs/README.md, docs-geode/demos and
# docs-geode/tutorials/the-first-hour.md -- so a page over 30% would count once under each. The two
# tiers hold different ceilings and keep separate counters, so nothing is priced twice inside one
# total; the shape is named here because the ASCII wall met the same double membership in the same
# room on 20260910 and it was a fault there, where one number carried both memberships.

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# One awk, so the reading of a Door file and a teaching file is the same reading by construction.
#
# WHAT IS READ PAST, each named separately rather than folded into one character class. The elder
# form was `/^[ \t]*[-*>#]/` under the comment "bullets, headings, quotes", and the `*` in it was
# reading the wrong half of this tree's prose (REDS %451). A CommonMark bullet is `-`, `*`, or `+`
# FOLLOWED BY WHITESPACE; `**What went wrong:**` is a bold span, and Gauge writes its paragraphs
# that way constantly. Not one asterisk bullet exists anywhere in docs-geode/, so that branch kept
# nothing it was aimed at and dropped body paragraphs instead: of docs-geode's 537 readable lines,
# 239 fell to it and none was a bullet, 85 of them body paragraphs on the twelve gated doors.
#
# FRONT MATTER IS DROPPED ON PURPOSE, where it used to fall to the same accident. Position and
# shape are required together, because neither alone is enough: `**Stamp:** ...` and
# `**What went wrong:** ...` are the same shape, and a body paragraph can open a page -- a rule
# keyed on shape alone ate real prose on 77 of 703 living documents when it was tried. So the block
# must be the FIRST one after the title, AND its opening line must carry a short bold key holding
# no `*` and no inner `:`. A wrapped value rides with it to the blank line that ends the block,
# which is what finally drops the shared `**Where this sits:**` navigation line -- twelve words
# carrying one negation, counted as prose on 111 front doors.
#
# WHY THE BLOCK EARNS ITS PLACE, measured 20260906. Without it `docs/README.md` reads 50% on two
# sentences of pure front matter and refuses the door gate on a page whose body is a link list,
# and `constel/README.md` reads 22% against a 20% ceiling on metadata alone rather than on prose.
# With it they read 0% and 18%. Of 892 living documents 676 carry such a block, and the six
# largest a prose-shaped audit flagged are all metadata with long values.
measure() {
  awk -v explain="${2:-0}" -v detail_max="${3:-80}" '
    BEGIN {
      # POSIX boundary classes, since \< is gawk-only and BSD awk matched nothing
      # (the control leg caught the zero-read on the first macOS run, 20260825)
      neg = "(^|[^a-z0-9_])(not|no|never|none|nothing|nobody|cannot|without|fails?|failed|failure|broken|breaks?|broke|wrong|lost|lose|loses|losing|stale|rot|rots|rented|dead|blind|refuses?|refused|refusal|error|bug|stopped|worse|worst|difficult|disappoint|pessimis|problem|risk|danger|threat|lying|lies|merely|nor|neither|hollow|empty|missing|absent|useless|wasted|corrupt)($|[^a-z0-9_])"
      infence = 0
      head = 1        # the title, then the metadata block, then the body begins
      inmeta = 0
    }
    # A front-matter key: `**Stamp:**`, `**Where this sits:**`. No interval quantifier anywhere in
    # this file -- BSD awk read nothing from \< once already, and an interval is the same risk --
    # so the length bound is taken from RLENGTH rather than spelled in the pattern. Forty holds the
    # longest key this tree writes and refuses a sentence that happens to carry a colon.
    # THE WORDS THAT COUNTED A SENTENCE, named rather than left to a reader to guess.
    # Bounded at eight per sentence: a printout is an allocation (TAME), and no sentence in this
    # tree has ever carried eight negations. The advance keeps the trailing boundary character,
    # because it is the leading boundary of whatever match comes next.
    function matched(t,   rest, out, w, k) {
      rest = t; out = ""; k = 0
      while (k < 8 && match(rest, neg)) {
        w = substr(rest, RSTART, RLENGTH)
        gsub(/[^a-z0-9_]/, "", w)
        out = (out == "" ? w : out " " w)
        rest = substr(rest, RSTART + RLENGTH - 1)
        k++
      }
      return out
    }
    function trim(t) { sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t); return t }
    function frontmatter_key(l) {
      if (l !~ /^[ \t]*\*\*[^*:]*:\*\*/) return 0
      match(l, /^[ \t]*\*\*[^*:]*:\*\*/)
      return (RLENGTH <= 40)
    }
    /^```/ { infence = 1 - infence; head = 0; next }
    infence { next }
    head {
      if ($0 ~ /^[ \t]*$/) { if (inmeta) { inmeta = 0; head = 0 } ; next }
      if (!inmeta && $0 ~ /^[ \t]*#/) next                       # the title
      if (!inmeta && frontmatter_key($0)) { inmeta = 1; next }   # the block opens
      if (inmeta) next                                           # a wrapped value rides with it
      head = 0                                                   # the body begins
    }
    /^[ \t]*\|/ { next }                       # tables
    /^[ \t]*[-*_][-*_ \t]*$/ { next }          # a rule line, or a marker with nothing after it
    /^[ \t]*[-*+][ \t]/ { next }               # a bullet: the marker THEN whitespace
    /^[ \t]*[>#]/ { next }                     # quotes, headings
    /^[ \t]*$/ { next }
    {
      # The substitutions run on the ORIGINAL case and the lowercasing follows, so `line` is
      # byte-for-byte what the elder form produced -- every pattern here holds letters nowhere,
      # so the regions they match cannot move when the case does. What that buys is `rawbuf`:
      # the same string with its capitals, split by the same delimiter at the same offsets, so
      # sentence i of one is sentence i of the other and --explain can print prose a reader
      # recognises. Splitting the untouched file instead would part company at the first link,
      # whose URL carries the dots the splitter reads as sentence ends.
      raw = $0
      gsub(/\[[^]]*\]\([^)]*\)/, " link ", raw)
      gsub(/`[^`]*`/, " code ", raw)
      gsub(/[*_]/, "", raw)
      line = tolower(raw)
      buf = buf " " line
      rawbuf = rawbuf " " raw
    }
    END {
      n = split(buf, s, /[.!?]+[ ]/)
      split(rawbuf, r, /[.!?]+[ ]/)
      sent = 0; negsent = 0; shown = 0
      for (i = 1; i <= n; i++) {
        w = split(s[i], t, /[ ]+/)
        if (w < 4) continue
        sent++
        if (s[i] ~ neg) {
          negsent++
          if (explain && shown < detail_max) {
            shown++
            printf "neg %d [%s] %s\n", sent, matched(s[i]), trim(r[i])
          }
        }
      }
      if (explain) {
        printf "explain_listed=%d\n", shown
        if (negsent > shown) printf "explain_truncated_at=%d\n", detail_max
      }
      if (sent == 0) { print "0 0 0"; exit }
      printf "%d %d %d\n", sent, negsent, int(negsent * 100 / sent)
    }
  ' "$1"
}

# --explain <path> [max]: the repair-grade reading, for the hand that has to sweep the page.
#
# WHY IT EXISTS. Every tier above names a document and its share -- `law: .claude/rules/git-signing.md
# 55% (32 of 58 sentences)` -- and stops there. A lane told that thirty-two sentences carry a
# negative, and never told WHICH thirty-two, reads the page and guesses; the guess is what makes a
# register sweep expensive enough to defer. This tree has booked the same complaint twice in other
# rooms, each time as a count naming no site.
#
# WHY IT IS A MODE RATHER THAN A TOOL. It calls measure() -- the same regex, the same line filters,
# the same sentence splitter, the same four-word floor -- with one flag set. A second program
# reading the same page its own way would be a second reading, free to drift from the gate by a
# word, and a listing that disagrees with the count it explains is worse than no listing.
#
# WHAT IT PRINTS, and the one thing to know about it. Each counted sentence, with the words that
# counted it, AS THE METER READS IT: links and code spans stand as ` link ` and ` code `, and
# emphasis marks are gone. Capitals are kept, so the sentence is recognisable in the file, yet it
# is a normalised reading rather than a literal quote -- match it by its content rather than by
# pasting it into a search.
if [ "${1:-}" = "--explain" ]; then
  target="${2:-}"
  [ -n "$target" ] || { echo "explain_verdict=no_path_given" >&2; exit 1; }
  [ -f "$target" ] || { echo "explain_verdict=absent" >&2; exit 1; }
  detail="${3:-80}"
  explained=$(measure "$target" 1 "$detail")
  reading=$(echo "$explained" | grep -vE '^(neg |explain_)')
  echo "explain_path=$target"
  echo "explain_sentences=$(echo "$reading" | awk '{print $1}')"
  echo "explain_negative=$(echo "$reading" | awk '{print $2}')"
  echo "explain_percent=$(echo "$reading" | awk '{print $3}')"
  echo "explain_field_target=$FIELD_MAX"
  echo "explain_door_target=$DOOR_MAX"
  echo "explain_floor=$REGISTER_MIN_SENTENCES"
  echo "$explained" | grep -E '^(neg |explain_)' || true
  echo "verdict=ok"
  exit 0
fi

door_over=0
: > "$work/door.txt"
for f in $DOOR; do
  if [ -f "$f" ]; then
    set -- $(measure "$f")
    pct=$3
    printf 'door: %s %s%% (%s of %s sentences)\n' "$f" "$pct" "$2" "$1" >> "$work/door.txt"
    [ "$pct" -le "$DOOR_MAX" ] || { door_over=$((door_over + 1)); printf 'over: %s reads %s%% against a %s%% door ceiling\n' "$f" "$pct" "$DOOR_MAX" >> "$work/door.txt"; }
  else
    door_over=$((door_over + 1))
    printf 'over: %s is named on the door roster and absent\n' "$f" >> "$work/door.txt"
  fi
done

# The teaching tier: what a newcomer opens after the front door.
git ls-files 'docs-geode/*.md' 'docs/*.md' 'manual/*.md' 'docs-geode/edu/yonder/*.md' CONTRIBUTING.md SOURCE.md ORGANIZING.md MAP.md 2>/dev/null \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$work/teaching.txt"

teaching_over=0
: > "$work/teaching_over.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  set -- $(measure "$f")
  [ "$1" -ge "$REGISTER_MIN_SENTENCES" ] || continue   # too short to read a share from honestly
  if [ "$3" -gt "$FIELD_MAX" ]; then
    teaching_over=$((teaching_over + 1))
    printf 'teaching: %s %s%%\n' "$f" "$3" >> "$work/teaching_over.txt"
  fi
done < "$work/teaching.txt"


# THE LAW TIER: `.claude/rules/*.md`, the prose every ship loads ahead of its first token.
#
# WHY IT ARRIVES HERE, when this scan's own header hands that room to a sibling. The sibling
# stands: tools/fixtures/r/radiant_negation_scan.sh is rostered and enforcing over exactly these
# files. It reads a DIFFERENT number -- negation WORDS per file against that file's own
# 20260821 baseline -- so it is a ratchet with no floor. A law page may sit at 63% negative
# sentences forever and stay green, provided it never reads worse than the day it was measured.
# No page in this room had ever been compared against the ceiling context/GAUGE_STYLE.md writes
# down, which is the one number the law itself states.
#
# Measured 20260910 by the reading below: 54 pages, 38 clearing the eight-sentence floor, and
# 18 of the 38 above the Field target of 30% -- azimuth-galaxy-proposal-format at 63%,
# comlink-tendency 58%, git-signing 55% of 58 sentences, the-baton 46% of 86. The room that
# teaches the register runs the most negative prose this meter reads. That is the same shape the
# scan was seated for one room over -- a warm label over a cold page -- and the sibling could not
# see it, because a baseline compares a page to its own past rather than to the law.
#
# FIELD RATHER THAN DOOR, named plainly because the choice is arguable. Gauge seats Meter for
# ledger rows, witness headers, and commit bodies; a rule page is none of the three, and reads as
# documentation addressed to a working agent, which is Field. Whether the law room should be held
# tighter is Keaton's word, and holding it to Field costs that word nothing.
#
# A RATCHET UNDER A CEILING THAT ONLY FALLS, gating beside the teaching tier for the same reason:
# these pages are living Tier 3 prose that a lane repairs by rewriting, one page at a time. A
# sweep takes a name off the printout and lowers the ceiling in the same commit.
#
# THE SEATING NUMBER IS WHAT THE READING ANSWERS ON THE COMMIT THAT SHIPS IT, rather than what it
# answered when the tier was written. The measurement above was taken at 18; a peer's lap landed
# `.claude/rules/quality-assurance.md` at 34% of 67 sentences while this one was being proven, and
# the rebase brought it in. So the tier was seated at 19, its whole population is printed below, and
# every number after that one falls.
#
# IT FELL 19 -> 17 ON 20260910, the first two pages swept with --explain open beside them. Both were
# the room's own highest shares: `.claude/rules/comlink-tendency.md` 58% of 12 sentences and
# `.claude/rules/azimuth-galaxy-proposal-format.md` 63% of 11, seven counted sentences each,
# restated to lead with what is and every claim, name, path and stamp held. Both read 0% now.
#
# IT FELL 14 -> 9 ON 20260910.150347, on the five pages `--explain` priced at one or two counted
# sentences each: `.claude/rules/tame-guidance.md` 35% of 20 sentences,
# `.claude/rules/placeholder-ship-names.md` 50% of 10, `.claude/rules/remember.md` 42% of 14,
# `.claude/rules/remember-git-nib.md` 34% of 29, and `.claude/rules/session-log-provenance.md` 34%
# of 32. Nine counted words left, each for a form this tree already writes -- `rather than` for a
# bare `not`, `with the chapter already in hand` for `without rediscovering` -- and every claim,
# path, stamp and proper noun held. All five read 27-30% now. The listing was the whole of the
# choosing: pricing every page in the room by its own explain reading names the cheapest five, and
# five pages fell for nine words.
#
# IT FELL 17 -> 14 THE SAME DAY, on the three pages the listing priced at ONE restatement each:
# `.claude/rules/molt.md` 35% of 14 sentences, `.claude/rules/vocabulary-aroma.md` 32% of 25, and
# `.claude/rules/exec-bit.md` 31% of 32. Each gave up one counted word -- a `without` for a `while`,
# a `never` for a plain clause, a `loses` for a `drops` -- and all three read 28%. That is what
# `--explain` bought: the cheapest page in the room is now a reading rather than a guess.
law_ceiling=9
law_documents=0
law_readable=0
law_over=0
: > "$work/law_over.txt"
git ls-files '.claude/rules/*.md' 2>/dev/null \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$work/law.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  law_documents=$((law_documents + 1))
  set -- $(measure "$f")
  [ "$1" -ge "$REGISTER_MIN_SENTENCES" ] || continue
  law_readable=$((law_readable + 1))
  [ "$3" -gt "$FIELD_MAX" ] || continue
  law_over=$((law_over + 1))
  printf 'law: %s %s%% (%s of %s sentences)\n' "$f" "$3" "$2" "$1" >> "$work/law_over.txt"
done < "$work/law.txt"
# THE UNROSTERED FRONT DOORS. Every tracked README.md is a front door by construction -- it is the
# page a reader meets when they open the room. A dated basename is testimony and is read past, by
# the same rule the teaching tier uses. The floor is REGISTER_MIN_SENTENCES, cited rather than
# respelled, so a door too short to read a share from honestly is counted as unreadable rather
# than as passing.
#
# TWO ROOMS ARE READ PAST, each for a reason a lane could not argue with. `tools/fixtures/` holds
# planted and frozen material -- `caravan_ladder_prose_close_elder/README.md` opens *kept exactly
# as it shipped* -- and a control reads those bytes as its plant, so sweeping one would break the
# guard rather than improve a door. `vendor/` is third-party source held unmodified by law
# (`.claude/rules/gratitude-licenses.md`). Both would put a name on a list nobody may act on,
# which is the complaint this reading exists to answer.
front_doors=0
front_readable=0
front_unrostered_over=0
: > "$work/candidates.txt"
git ls-files '*README.md' 2>/dev/null \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]|^tools/fixtures/|^vendor/' > "$work/front.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  front_doors=$((front_doors + 1))
  set -- $(measure "$f")
  [ "$1" -ge "$REGISTER_MIN_SENTENCES" ] || continue
  front_readable=$((front_readable + 1))
  [ "$3" -gt "$DOOR_MAX" ] || continue
  case " $DOOR " in *" $f "*) continue ;; esac
  front_unrostered_over=$((front_unrostered_over + 1))
  printf 'candidate: %s %s%% (%s of %s sentences)\n' "$f" "$3" "$2" "$1" >> "$work/candidates.txt"
done < "$work/front.txt"

cat "$work/door.txt"
echo "door_documents=$(echo $DOOR | wc -w | tr -d ' ')"
echo "door_over_ceiling=$door_over"
echo "door_ceiling_percent=$DOOR_MAX"
echo "teaching_documents=$(wc -l < "$work/teaching.txt" | tr -d ' ')"
echo "teaching_over_field_target=$teaching_over"
echo "teaching_ceiling=$ceiling"
[ "$teaching_over" -eq 0 ] || sort -t% -k1 "$work/teaching_over.txt" | head -8
echo "law_documents=$law_documents"
echo "law_readable=$law_readable"
echo "law_over_field_target=$law_over"
echo "law_ceiling=$law_ceiling"
# FRONT_DETAIL_MAX bounds every listing this scan prints, rather than the front doors alone: a
# printout is an allocation whichever tier fills it (TAME).
[ "$law_over" -eq 0 ] || sort -t% -k1 -rn "$work/law_over.txt" | head -"$FRONT_DETAIL_MAX"
echo "front_doors=$front_doors"
echo "front_doors_readable=$front_readable"
echo "front_doors_unrostered_over=$front_unrostered_over"
# Bounded: a printout is an allocation (TAME). Past this the count still stands and the listing
# says where it stopped, so a reader is never told a short list is the whole one.
if [ "$front_unrostered_over" -gt 0 ]; then
  sort "$work/candidates.txt" | head -"$FRONT_DETAIL_MAX"
  if [ "$front_unrostered_over" -gt "$FRONT_DETAIL_MAX" ]; then
    echo "candidates_truncated_at=$FRONT_DETAIL_MAX"
  fi
fi

if [ "$door_over" -eq 0 ] && [ "$teaching_over" -le "$ceiling" ] && [ "$law_over" -le "$law_ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=register_drift"
echo "refused: a door, teaching, or law document reads more negatively than the style it claims -- read the lines above" >&2
exit 1
