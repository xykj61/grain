#!/bin/sh
# tools/fixtures/d/dated_path_exclusions.sh -- what the dated-path tools do not look at. One list.
#
# WHY THIS FILE EXISTS. Two tools act on the same corpus of dated references: the census counts
# them and the repointer rewrites them. They must agree on what is NOT the field, and for one day
# they did not.
#
# The census learned first, reddening on its own demonstration paths, and excluded `dated_path_*`
# by name. The repointer -- written the same day, for the same corpus -- never received that
# lesson, and its apply run rewrote the witness's deliberately stale fixture, leaving the rung that
# proves the fold rule works proving nothing (REDS %121). Within the hour of booking that red, the
# two lists had diverged AGAIN: the census gained `shipped_binary_claim_control.sh` and the
# repointer did not.
#
# Twice is not carelessness, it is structure. A list kept in two places is two lists that happen to
# match today. So there is one list, here, and both tools read it.
#
# WHAT BELONGS ON IT, and the test is the same for every entry: **is this the field, or the
# instrument?** A tool that demonstrates recovery must cite a path that no longer resolves; a
# control that proves a guard refuses must plant the thing it refuses. Those paths are fixtures,
# not defects and not references -- counting them makes a meter rise as its proof gets stronger,
# and rewriting them disarms the proof entirely.
#
# HOW TO ADD ONE. Add the name below, once. Both tools pick it up, and
# `tools/d/dated_path_witness.rish` proves neither has drifted back to a private copy.
#
#   . tools/fixtures/d/dated_path_exclusions.sh
#   dp_grep_excludes   # sets "$@" to grep flags:  --exclude-dir=X ... --exclude=Y ...
#   dp_find_excludes   # sets "$@" to find tests:  ! -name Y ...
#   dp_find_paths      # sets "$@" to find tests:  ! -path ./Z ...
#   dp_paths_roster    # one excluded path per line, for consumers that filter afterward
#   dp_find_prune      # sets "$@" to find tests:  -name X -o -name Y ...   (for -prune)

# SURVEYED `20260821.203103`, AND THE OTHER LISTS DELIBERATELY STAY SEPARATE. Three more scan
# scripts in tools/fixtures carry exclusions, and the instinct after unifying these two was to
# gather those as well. Measurement said no, and the reasoning is recorded here so a later round
# does not re-open it and "helpfully" merge them:
#
#   shipped_binary_claim_scan.sh -- shares `.git seed vendor` and adds `gratitude`, because
#     third-party study notes make no claims about OUR tools. Folding it in would either scan that
#     text for claims it cannot make, or -- if `gratitude` joined the list below -- drop 113 dated
#     references from the census including SIX genuinely broken ones. A merge that hides real
#     breakage is not a merge.
#
#   vols_survey_truth.sh and vols_survey_crosscount.sh -- a survey scope rather than a field
#     boundary, and the two differ from each other on purpose: `truth` walks the real tree while
#     `crosscount` walks a fixture tree, so a narrower list fits a smaller corpus. Both witnesses
#     stand GREEN.
#
# THE TEST FOR WHETHER TWO LISTS SHOULD MERGE is whether they answer the same QUESTION, not
# whether they share entries. These two did -- both ask "what is not the field, and what is the
# instrument?" -- and the volatile half, the fixture names, grows with every tool that plants one.
# The three-directory base below is stable and duplicating it elsewhere costs nothing.
#
# Directories that are not this field at all: object storage and third-party source held
# unmodified. Matched by NAME, so an entry here prunes that directory wherever it sits -- correct
# only where the name is unambiguous in this tree, which was measured rather than assumed: `.git`
# and `vendor` each occur exactly once, at the root.
DP_EXCLUDE_DIRS=".git vendor"

# ONE NAME, TWO MEANINGS -- and the two matchers can not both anchor it (REDS %122).
#
# `seed/` at the root is the gitignored projection of this same tree, and pruning it is what keeps
# every reference from being counted twice. `recursion-prompts/seed/` is the loop's own seed room,
# and a NAME match prunes it too. That collateral is how the council rota came to hold five dead
# paths after the fold with neither tool noticing: both were blind to the room those paths live in.
#
# find anchors cleanly -- `-path ./seed` matches the whole path, so the projection is pruned and
# the loop's room is kept. GREP CANNOT: --exclude-dir matches the directory NAME here, and a
# leading ./ in the pattern simply never matches, which a first attempt at this fix read as
# success because the check it was read from could not have matched either. So grep keeps the
# name exclusion and the collateral room is RE-ADMITTED explicitly, scanned in its own pass.
# Measured rather than assumed: `.git` and `vendor` each occur once, at the root, so their name
# match carries no collateral; `seed` occurs twice, which is why only it needs this treatment.
DP_EXCLUDE_ROOT_DIRS="./seed"

# The directory name that root path reduces to -- what grep must be given, since it matches names.
DP_EXCLUDE_ROOT_NAMES="seed"

# A CHECKOUT OF THIS SAME REPOSITORY IS NOT THE FIELD -- derived from git, never named by hand.
#
# WHY. `git worktree add` makes a second, complete checkout of this repository, at a different
# commit, in its own directory. When that directory sits INSIDE the root -- which is where the
# MANY HANDS grant puts them, `.gitignore:140` reserving `/.claude/worktrees/` for exactly this --
# the census walks it and reads a photograph of the field as the field.
#
# This is the `seed/` argument one room over, and it lands harder. The projection copies HEAD, so
# its references are at least current; a worktree stands at whatever commit its hand is working,
# so every reference it carries to a room folded since reads GONE. Measured `20260829` with one
# worktree present at `e33a8cc48`: 148 of 296 `gone` and 22 of 39 `ambiguous` were its copies, so
# the lost-reference gate read 335 against a ceiling of 168 and the field itself read 165.
#
# The repointer took the sharper half. It WRITES -- `cat "$f.dpr" > "$f"` -- and enumerates by
# walking `.`, so its dry run named exactly one file to rewrite and that file was inside the
# peer's checkout: `.claude/worktrees/<hand>/docs-geode/demos/README.md`. The field's own copy of
# that page is already on DP_EXCLUDE_PATHS below; the copy evaded it because that roster anchors
# at the root. A tool the mark law names as the standing repair would have written into land it
# does not own, and touched nothing in the field at all.
#
# DERIVED RATHER THAN NAMED, because a hand-typed roster grows when somebody remembers (REDS
# %277). `git worktree list --porcelain` is the authority, so a worktree made tomorrow is pruned
# on the lap it arrives.
#
# WHAT IT NEVER PRUNES. The main worktree is the field, so the root itself is dropped by identity.
# A worktree OUTSIDE the root is not walked in the first place and needs no entry. And run from
# INSIDE a worktree, `--show-toplevel` answers that worktree, no sibling sits beneath it, and the
# roster is empty -- which is right, because from in there that checkout IS the field.
#
# SILENT OUTSIDE A REPOSITORY, on purpose: the control corpus runs these tools from a throwaway
# pen before `git init`, and a roster that refused there would break the proof rather than the
# fault.
dp_worktree_dirs() {
  command -v git >/dev/null 2>&1 || return 0
  _dp_root=$(git rev-parse --show-toplevel 2>/dev/null) || return 0
  [ -n "$_dp_root" ] || return 0
  git worktree list --porcelain 2>/dev/null | while IFS= read -r _dp_line; do
    case "$_dp_line" in
      "worktree "*) _dp_wt=${_dp_line#worktree } ;;
      *) continue ;;
    esac
    # The main worktree is the field itself; pruning it would prune everything.
    [ "$_dp_wt" = "$_dp_root" ] && continue
    case "$_dp_wt" in
      "$_dp_root"/*) printf '%s\n' "${_dp_wt#"$_dp_root"/}" ;;
    esac
  done
}

# Rooms pruned only as collateral of a name match above, to be scanned in their own pass and
# folded back into the corpus. A consumer that skips this re-admit is blind to the room.
DP_READMIT_DIRS="recursion-prompts/seed"

# Files whose dated paths are the instrument's own fixtures rather than citations of the field.
# Matched by NAME, so an entry here excludes that filename wherever it sits.
# A CONTROL IS INSTRUMENT, CATEGORICALLY -- amended 20260823.124407.
#
# This list named controls ONE AT A TIME, and paid for it repeatedly: the census gained
# `shipped_binary_claim_control.sh`, then `tracked_link_control.sh`, then `banner_room_control.sh`,
# each after a new control planted a dated name the tree deliberately does not carry. Four more
# controls were written in a single session on 20260823 -- exec_bit, seed_link, empty_document,
# prose_register -- and `foundations_link_control.sh` was contributing six planted names while
# still absent from the list.
#
# `tools/fixtures/p/phantom_path_scan.sh` already learned this and excludes the GLOB: a `*_control.sh`
# fixture plants what its guard refuses, so its paths are fixtures by construction rather than by
# anyone remembering to add them. The same rule holds here. A lantern that fires twice becomes a
# loom; this one fired six times.
DP_EXCLUDE_NAMES="dated_path_* *_control.sh session_logs_archive.rye"

# The same test, applied to a file whose NAME cannot carry the exemption. `docs-geode/demos/`
# demonstrates the resolver recovering a stale reference, which requires quoting one -- and the
# page prints the answer it gets, so repointing the reference would make its own quoted output
# wrong. Its basename is README.md, which no name-match could exempt without exempting every
# README in the tree, so exact paths get their own list. Written relative to the repository root,
# without a leading ./ -- each consumer adds what its own matcher needs.
DP_EXCLUDE_PATHS="docs-geode/demos/README.md"

# A NAME A CONTROL PLANTS IS NEVER A FILE THE TREE HAS -- and the record of that control is
# testimony, not instrument, so a name-match on the control cannot reach it. `tracked_link_control.sh`
# plants `20260101-000000_a-dated-note.md` to prove dated testimony passes free, and the exclusion
# above keeps the control itself out of the corpus. The SESSION LOG that narrates why then quoted
# the planted name, and the census counted it as a real reference resolving nowhere -- the meter
# rising because the round explained itself well.
#
# So the exemption belongs to the planted NAME rather than to any file that mentions it. A basename
# subtracted here is subtracted wherever it is quoted, which is safe precisely because these names
# are constructed to match nothing: a stamp of all zeros names no lap this tree ever ran.
#
# THE NAMES COME FROM TWO PLACES, AND ONLY ONE OF THEM CAN BE DISCOVERED (`20260824.193000`,
# REDS %203's named remainder, now counted). A hand-written roster reaches the names somebody
# remembered, which is REDS %187's shape; the roster held 2 planted names and the tree held 47.
#
#   DISCOVERED -- a name an instrument plants. `dp_discovered_fixture_basenames` finds it by two
#     conjuncts, and each closes one failure mode of the other:
#       1. the basename appears in AUTHORED CODE -- .rye, .rish, .sh, .brix outside vendor and
#          gratitude, and outside THIS FILE, since a roster that reads itself discovers everything
#          it lists;
#       2. its SPRIG names no file anywhere in the tree.
#     Conjunct 2 alone reads 105 of 122 lost basenames, because a document that was deleted has an
#     absent sprig too. Conjunct 1 alone reads real documents that merely MOVED -- the first attempt
#     at this count returned `20260729-222500_reds-first-and-the-allocation.md`, whose sprig sits on
#     disk under a different stamp. Together they read 47, and every one is a fixture by eye:
#     `ghost`, `theta`, `moved`, `x.md`, `never-written`, `a-room-that-never-folded`.
#
#   LISTED -- a name the tree DELIBERATELY does not carry. A debride removed it, or a fusion
#     retired it. No instrument plants it, so nothing can discover it, and it is a decision rather
#     than a fact. Those four stay written below, and that is the right home for them.
# Basenames a reference may name that the tree deliberately does NOT carry, so the census reads
# them as intent rather than as breakage.
#
#   The first is planted by a control to match nothing -- a stamp of all zeros names no lap this
#   tree ever ran (REDS %157).
#
#   The next three are DEBRIDED. The deep debride of 20260823.072824 removed a resume draft, a
#   personal ontology, and a co-authored cover letter from all 3,314 commits on Keaton's word
#   (REDS %162's third resolution). They stand on the author's disk and in no repository. The
#   references that still name them live in dated testimony, which keeps every word it wrote, so
#   the honest reading is a path asserted absent rather than a reference gone stale -- the same
#   shape REDS %139 chose for a path asserted absent and REDS %157 extended to a basename.
#
#   The last is FUSED rather than debrided: Conway's Law and Gall's Law became one page on
#   20260823.105651, and Conway's separate telling left the tree while staying in history. A
#   dated session log still names it, and testimony keeps every word it wrote, so the census
#   reads the name as intent.
#
#   The sixth is planted by `commit_message_guard_scan.sh` on 20260824.172500, to prove the
#   commit-msg hook refuses a body citing a path the tree does not hold (REDS %202). A stamp of
#   20260101-010101 names no lap this tree ever ran, so the name matches nothing by construction --
#   the same reasoning as the first entry, one control later.
#
#   The SEVENTH is the sixth's own shape, one year of stamps later and one control after it.
#   `commit_message_guard_scan.sh` planted `20260905-183418_the-handoff-from-the-eight-core-round.md`
#   on 20260905.183603 to prove the hook now resolves a bare one-clock basename, after a hard wrap
#   walked a fabricated citation past the path check (REDS %437). The stamp 183418 names no lap this
#   tree ever ran -- the real handoff is 183107 -- so the name matches nothing by construction, which
#   is the same reasoning as the first entry and the sixth.
#
#   AND ITS ELIDED SPELLING IS THE SAME PLANTING. Both the control and the ledger row shorten the
#   fabricated name to `20260905-183418_...md` when quoting it a second time, and an ellipsis is
#   still a one-clock stamp followed by a sprig, so the census reads it as a reference like any
#   other. A name that was fabricated on purpose stays fabricated when it is abbreviated, so both
#   spellings are LISTED rather than one -- otherwise the subtraction depends on how a sentence
#   happened to be typed.
#
#   ITS OTHER TWO REFERENCES ARE THE LEDGER ROW EXPLAINING IT, and they are LISTED by the fifth
#   entry's reasoning rather than by a new one: a ledger row that quotes a fabricated path in order
#   to record how it escaped is a path asserted absent, not a reference gone stale. This is the
#   class where a red cannot be written down without raising a meter -- the ledger's account of a
#   fabricated citation is, to a path census, two more fabricated citations -- and the honest answer
#   is the one this file already gives: the instrument and the record of the instrument are both
#   instrument. Counting them makes a meter rise as its proof gets stronger, which is exactly what
#   this file exists to prevent (REDS %438).
#
#   The fifth LISTED name is DEBRIDED like the three above it, and it is here because the
#   subtraction was happening anyway by accident. The deep debride of 20260825 removed
#   `counsel/date/20260730/...pole-bozo-djinn-murr-keaton.md` from the tree and from every commit on
#   Keaton's word. Five references still name it -- one in `construction/REDS.md`, three in
#   `expanding-prompts/date/20260730/`, one in a session log -- and every one of them is dated
#   testimony or a ledger row explaining the removal, so the honest reading is a path asserted
#   absent rather than a reference gone stale. That is the same verdict the three names above
#   carry, reached the same way.
#
#   WHY IT IS WRITTEN HERE RATHER THAN LEFT TO DISCOVERY. The round that raised the ceiling for
#   this page wrote its full path into `dated_path_scan.sh`'s own comment to explain the rise, and
#   `dp_discovered_fixture_basenames` read that comment: the basename appears in authored code and
#   its sprig names no file, so both conjuncts held and all five references were subtracted in
#   silence. The census then read 178 where it had read 182, and the round recorded the shift as
#   untraced (REDS %245). Discovery skips full-line comments now, so the accident cannot recur --
#   which means the subtraction has to be a decision, and this is where decisions live.
#
#   THE SAME EVENT, RECORDED FROM THE CUT'S SIDE. The mitra shed, circled on Keaton's word
#   (SHRED_PREP shed-complete record, stamp 20260826.032839; commit e82040c5a), cut those eleven
#   foundations elders and one expanding-prompts fossil,
#   `20260811-220402_wade-bit-design-system-and-dimeroll-entities.md`, whose living mutants stand
#   at fresh stamps and whose living citers were repointed in the cut's own round. Its remaining
#   references live in dated testimony, which keeps every word it wrote, so the census reads each
#   as intent rather than breakage -- the same LISTED shape %157 seated and %162 extended. The cut
#   crossed this census while the census stood dark on the cutting host (the BSD dialect fault,
#   REDS %272), which is how the crossing went unmeasured; REDS %274 records that lesson.
#   THE TEN BELOW ARE ONE EVENT, the SECOND mitra shed, circled on Keaton's word 20260827.162143
#   (SHRED_PREP shed-complete record). Each was a prepped fossil whose living mutant stands and
#   whose living citers were repointed in the cut's own round: six June and p31 foundations
#   elders, the Oven bake-seat elder its Kiln mutant replaced, the anvil-to-oven naming counsel
#   the LEXICON's Ember row carries, the swarm-that-feeds elder, and the six-chapter double-seat
#   whose eight-chapter mutant accretes all six whole. Their remaining references live in dated
#   testimony and in the chapter witnesses that now read the shed RECORD rather than the file --
#   so the census reads each as intent rather than breakage, the same LISTED shape %157 seated.
# The LISTED half only. The two planted names that stood here -- `20260101-000000_a-dated-note.md`
# and `20260101-010101_never-written.kyri` -- are found by discovery now, along with 45 more, so
# listing them would be the duplication this round exists to end.
#
#   THE TWELVE BELOW ARE ONE EVENT, and it is a shape this list had not met before. The chapter
#   molt of 20260826 re-seated eleven foundations at fresh one-clock stamps and the deep debride
#   that carried the word "season" to "chapter" removed the elder stamps from every commit. A FOLD
#   keeps a basename and only moves it, which is why the resolver recovers a folded reference from
#   the basename alone; a MOLT changes the stamp, so every reference to the elder names a string
#   that exists nowhere and never will again. The census read 390 lost where its ceiling stood at
#   178, and 197 of those sit in session logs -- dated testimony, which accrete-never-break keeps
#   word for word. So the references are permanent by law, and counting them as breakage forever
#   would make the ceiling a monument to a decision the tree made on purpose.
#
#   Each name carries its forwarding address, which is the part a reader actually needs: an old
#   log naming `20260706-185112_follow-our-compass.md` is naming the page that lives at
#   `foundations/20260826-024943_follow-our-compass.md` today. Every pair below was checked both
#   ways on the lap it was written -- the elder absent from `git ls-files`, the successor present
#   on disk.
#
#     20260702-184312_the-grain-and-the-crossing.md      -> foundations/20260826-024942_...
#     20260706-185112_follow-our-compass.md              -> foundations/20260826-024943_...
#     20260618-182412_single-stranded.md                 -> foundations/20260823-204456_...
#     20260728-220203_realidream.md                      -> foundations/20260825-233310_...
#     20260628-124512_anywhere-we-are-found.md           -> foundations/20260826-024940_...
#     20260728-232511_lantern-lattice-oven.md            -> foundations/20260826-024944_...
#     20260728-221253_the-graph-beneath-the-surface.md   -> foundations/20260826-024939_...
#     20260628-133212_a-home-in-plain-text.md            -> foundations/20260826-024941_...
#     20260823-222018_what-mantra-is.md                  -> foundations/20260825-211056_...
#     20260821-035846_every-climate-has-a-fiber.md       -> foundations/20260824-003828_...
#     20260813-142420_mycelium-the-consensus-protocol.md -> foundations/20260825-211055_...
#
#   The twelfth is DELETED rather than molted, and it carries no forwarding address:
#   `20260703-235912_diet-and-the-crossing-manifest.md` left the live tree on the round that
#   retired the diet framing. Thirteen references name it, and the two living ones are the rows in
#   `construction/ready-to-ask-claude.md` that RECORD the deletion -- a ledger saying "deleted from
#   live tree" beside the path it means. That is REDS %246's lesson at table scale: a line
#   explaining why a page is gone looks exactly like a line citing it.
#
#   WHAT STAYS COUNTED, on purpose. Names whose successor this round could not prove stay in the
#   census where a later lap can see them -- `20260629-031512_slc1-lap-closed-handoff.md` (renamed
#   in place, lap -> ring, same stamp), and the basenames sitting at two paths at once, which are
#   the AMBIGUOUS class rather than this one. Listing a name nobody has traced would convert an
#   open question into a silent decision, which is the accident REDS %245 and %246 were booked for.
#   FIVE MORE, DECLARED WHEN DISCOVERY NARROWED TO INSTRUMENTS (REDS %268). Each is a string
#   inside a module's own test body rather than a citation of anything, and each was found by
#   discovery until its source stopped being read for plants. Listed here once, which is what this
#   file asks for, so a healthy tree reads exactly what it read before the narrowing:
#
#     20260702-090000_theta.md      -> tools/rye/session_logs_archive.rye, a fold test's fixture path
#     20260716-145955_rune.bron     -> tools/rye/session_logs_archive.rye, should_fold_flat input
#     20260717-125858_skate.bron    -> tools/rye/session_logs_archive.rye, should_fold_flat input
#     20260713-201910_old.bron      -> scribe/reader.rye, is_scribe_extension input
#     20260810-113354_a-log.kyri    -> scribe/reader.rye, is_scribe_extension input
#
#   AND ONE NAME NO FILE EVER WORE. `20260816-205859_double-seat-expansion-eight-chapters.md` was
#   invented by the chapter molt of 20260826, which swept `season` to `chapter` through a path
#   literal whose dated basename correctly kept the elder word. Its forwarding address is
#   `active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-seasons.md`, which
#   stands and always did. The rows and logs that book REDS %268 must quote the broken form to
#   explain it, and a row naming a lost reference is itself one -- the cost of saying so, paid once
#   and visible, exactly as REDS %245, %246 and %253 already record. Listed rather than paid for by
#   a rising ceiling, because a ceiling only falls.
#
#   AND ONE NAME A BREACH RENAMED, `20260904.214754`. The aroma breach retired the word *smell* from
#   living instruction on Keaton's word, and the earth row's threshold page went from
#   `20260826-021735_earth-the-row-that-smells.md` to
#   `foundations/20260826-021735_earth-the-row-that-breathes-in.md` -- same stamp, new sprig, so a
#   FOLD resolver cannot recover it: the fold keeps a basename and only moves it, while this
#   changed the basename itself. The two living citers were repointed in the same commit; the four
#   that remain sit in dated testimony, which keeps every word it wrote. Listed rather than paid for
#   by a rising ceiling, because a ceiling only falls.
#
DP_FIXTURE_BASENAMES="20260905-183418_the-handoff-from-the-eight-core-round.md \
20260905-183418_...md \
20260730-022147_keaton-livermore-resume-draft.md \
20260730-022147_personal-ontology.md \
20260730-022147_cover-letter-co-authored.md \
20260821-211423_conways-law-and-the-organization-that-forgets.md \
20260730-150702_pole-bozo-djinn-murr-keaton.md \
20260702-184312_the-grain-and-the-crossing.md \
20260706-185112_follow-our-compass.md \
20260618-182412_single-stranded.md \
20260728-220203_realidream.md \
20260628-124512_anywhere-we-are-found.md \
20260728-232511_lantern-lattice-oven.md \
20260728-221253_the-graph-beneath-the-surface.md \
20260628-133212_a-home-in-plain-text.md \
20260823-222018_what-mantra-is.md \
20260821-035846_every-climate-has-a-fiber.md \
20260813-142420_mycelium-the-consensus-protocol.md \
20260703-235912_diet-and-the-crossing-manifest.md \
20260811-220402_wade-bit-design-system-and-dimeroll-entities.md \
20260702-090000_theta.md \
20260716-145955_rune.bron \
20260717-125858_skate.bron \
20260713-201910_old.bron \
20260810-113354_a-log.kyri \
20260816-205859_double-seat-expansion-eight-chapters.md \
20260826-021735_earth-the-row-that-smells.md \
20260702-165412_the-happy-zone-and-the-thin-edge.md \
20260629-063512_realidream.md \
20260629-063512_the-graph-beneath-the-surface.md \
20260629-063512_lantern-lattice-anvil.md \
20260728-221253_lantern-lattice-anvil.md \
20260629-063512_the-wafer-and-the-sovereign-coin.md \
20260826-024944_lantern-lattice-oven.md \
20260728-232415_anvil-forge-to-oven-name-lean.md \
20260826-001746_the-swarm-that-feeds-the-oven.md \
20260813-020035_double-seat-expansion-six-seasons.md \
20260727-135351_seva-fund-founding-announcement.md"

# Each helper REPLACES the positional parameters, so a caller captures its own arguments first.
# Globbing is disabled while the list is expanded, because `dated_path_*` is a pattern meant for
# grep and find rather than one the shell should resolve against the working directory.

dp_grep_excludes() {
  set -f
  _dp=""
  for _d in $DP_EXCLUDE_DIRS; do _dp="$_dp --exclude-dir=$_d"; done
  for _d in $DP_EXCLUDE_ROOT_NAMES; do _dp="$_dp --exclude-dir=$_d"; done
  for _n in $DP_EXCLUDE_NAMES; do _dp="$_dp --exclude=$_n"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

dp_find_excludes() {
  set -f
  _dp=""
  for _n in $DP_EXCLUDE_NAMES; do _dp="$_dp ! -name $_n"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

dp_find_paths() {
  set -f
  _dp=""
  for _p in $DP_EXCLUDE_PATHS; do _dp="$_dp ! -path ./$_p"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

# For consumers that cannot exclude by path at match time -- grep has no --exclude-path -- the same
# list is emitted as a plain roster to filter against afterward.
dp_paths_roster() {
  set -f
  set -- $DP_EXCLUDE_PATHS
  set +f
  printf '%s\n' "$@"
}

dp_find_prune() {
  set -f
  _dp=""
  _first=1
  for _d in $DP_EXCLUDE_DIRS; do
    if [ "$_first" = 1 ]; then _dp="-name $_d"; _first=0; else _dp="$_dp -o -name $_d"; fi
  done
  for _d in $DP_EXCLUDE_ROOT_DIRS; do
    if [ "$_first" = 1 ]; then _dp="-path $_d"; _first=0; else _dp="$_dp -o -path $_d"; fi
  done
  # Every in-root worktree, so a walker never descends into a second checkout of this same
  # repository. find anchors a path cleanly, which is what this side needs and grep cannot give.
  # `set -f` above keeps a glob character literal here; the find test is built one line at a time
  # so a worktree path carrying a space stays one path rather than becoming two.
  for _d in $(dp_worktree_dirs); do
    if [ "$_first" = 1 ]; then _dp="-path ./$_d"; _first=0; else _dp="$_dp -o -path ./$_d"; fi
  done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

# The collateral rooms, emitted as plain paths for a consumer to scan in a second pass.
dp_readmit_dirs() {
  set -f
  set -- $DP_READMIT_DIRS
  set +f
  printf '%s\n' "$@"
}

# The LISTED absences, emitted one per line for a consumer to subtract from its corpus.
dp_fixture_basenames() {
  set -f
  set -- $DP_FIXTURE_BASENAMES
  set +f
  printf '%s\n' "$@"
}

# The DISCOVERED plantings, emitted one per line. Two passes and no roster:
#
#   1. every dated basename written into authored code, outside this file;
#   2. minus every one whose sprig names a real file.
#
# The second pass is what keeps a moved document from being read as a planting, and the first is
# what keeps a deleted one from being read as a planting. Neither conjunct is safe alone, which is
# why the first attempt at this count was wrong and why both are spelled out here.
#
# CONJUNCT 1 READS CODE AND SKIPS FULL-LINE COMMENTS -- amended 20260826.052117, and the reason is
# that the two say different things. Code that names a dated basename PLANTS it; a comment that
# names one WRITES ABOUT it, and a round explaining why a page is gone is doing the second while
# looking exactly like the first. `dated_path_scan.sh` gained a comment naming a debrided counsel
# page, both conjuncts held, and the census silently stopped counting that page's five surviving
# references -- the untraced 182-to-178 shift REDS %245 recorded and %246 traced.
#
# The strip costs nothing, which was measured rather than assumed. Three basenames leave discovery
# under it: `20260104-000000_x.md` and `20260729-134259_x.md`, each named only in a control's or a
# scan's prose, carry ZERO references anywhere in the corpus -- so subtracting them subtracted
# nothing -- and the third is the debrided page, which is LISTED above by decision now. Fifty-six
# discovered names are unchanged.
#
# Only a line whose FIRST non-blank character opens the comment is dropped. A trailing comment on a
# code line still reads, which errs toward keeping a planting: a false negative here re-admits a
# fixture into the census, and a false positive hides real breakage. Between those two the census
# takes the one that shows too much.
#
# A PLANT IS PLANTED BY AN INSTRUMENT, and only an instrument is read for one (REDS %268).
#
# This discovery emits a dated basename whose SPRIG names no tracked file -- which is exactly the
# definition of a broken reference, so for one day the test could not tell a plant from a wound.
# The chapter molt of 20260826 rewrote a path literal whose dated basename correctly kept the elder
# word, leaving `tools/l/launch-claude-chapter.rish` -- the script that starts every unattended lap
# -- naming `active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-chapters.md`
# where the file on disk is `..._eight-seasons.md`. The launcher is a `.rish`, so the wound was
# discovered here, emitted as a fixture, and subtracted from the corpus. Worse, the subtraction is
# BY BASENAME and reaches every file: the identical break in
# `recursion-prompts/seed/autonomous-loop.seed.md` was erased along with it. Measured on this tree:
# with both broken the census read `broken_gone=151`, `refs_lost=168`, `under_ceiling=yes`; with
# only the Markdown one broken it read 152, 169, and `under_ceiling=no`. One bad path in one shell
# script blinded the whole census to that name.
#
# So the source set is the three names this tree already calls instruments -- `_control`,
# `_witness`, `_scan` -- in any of the four languages it reads. Measured `20260826.124500`: it takes
# 2,097 files where it took 4,784, so 2,687 ordinary sources can no longer erase their own
# breakage, and a launcher is an ordinary source. Anything a module's own test body plants is
# DECLARED above instead, once and on the record, which is the shape this file already asks for.
# Measured cost of the narrowing: five names, all of them test inputs inside `.rye` bodies, now
# listed by hand -- so the fixture list reads 77 either way and a healthy tree reads what it read.
#
# The residual is named rather than hidden: a genuine wound inside a control, witness, or scan is
# still subtracted here. Those are the files whose job is to plant names, so that is where the
# ambiguity honestly lives, and it is 2,097 files rather than the whole tree.
#
# Takes the repository root, so a caller that has cd'd into a pen still reads the tree it means to.
dp_discovered_fixture_basenames() {
  _dp_root=${1:-.}
  ( cd "$_dp_root" 2>/dev/null || exit 0
    git ls-files 2>/dev/null | while IFS= read -r _f; do
      basename "$_f"
    done | sed -n 's/^[0-9]\{8\}-[0-9]\{6\}[_.]//p' | sort -u > "$_dp_root/.dp_sprigs.$$" 2>/dev/null \
      || return 0
    git ls-files '*.rye' '*.rish' '*.sh' '*.brix' 2>/dev/null \
      | grep -vE '^(vendor|gratitude|old)/' \
      | grep -v '^tools/fixtures/d/dated_path_exclusions.sh$' \
      | grep -E '_(control|witness|scan)\.(rye|rish|sh|brix)$' \
      | xargs sed -e 's/^[[:space:]]*#.*$//' -e 's|^[[:space:]]*//.*$||' 2>/dev/null \
      | grep -oE '[0-9]{8}-[0-9]{6}[_.][A-Za-z0-9._-]+\.(md|bron|kyri|rye|rish|tsv|brix|glow|sh)' \
      | sort -u \
      | while IFS= read -r _b; do
          _sp=$(printf '%s' "$_b" | sed -n 's/^[0-9]\{8\}-[0-9]\{6\}[_.]//p')
          [ -n "$_sp" ] || { printf '%s\n' "$_b"; continue; }
          grep -qxF -- "$_sp" "$_dp_root/.dp_sprigs.$$" || printf '%s\n' "$_b"
        done
    rm -f "$_dp_root/.dp_sprigs.$$"
  )
}
