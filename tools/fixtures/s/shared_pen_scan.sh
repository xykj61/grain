#!/bin/sh
# tools/fixtures/s/shared_pen_scan.sh -- a scratch path named by a constant is a path two ships share.
#
# WHY. Eight ships run one roster from eight checkouts, and a guard that builds its fixture in
# /tmp/<a name somebody chose> builds it in the SAME directory on every one of them. The failure is
# not subtle and it is not rare: on `20260906.222342` this pier's cold pass reddened at
# `amphora_restore_negative`, whose first line was `rm -rf /tmp/amphora_rneg_home`, and whose
# assertion `tamper refusal must leave no out-home` was reporting a fact about a peer's pen rather
# than about Amphora. Run alone it was GREEN, minutes later. Green alone and red in company is the
# signature, and it had already fired twice the lap before (`signal_trap`, `tlb_reach`).
#
# THE SWEEP THAT CLOSED THOSE COUNTED ONE SPELLING. It read `TMPDIR=` assignments in shell fixtures
# and repaired nine. This tree writes a pen at least FIVE ways -- a shell `TMPDIR=`, a bare literal
# in a command, a Rishi `let home = "/tmp/name"`, a redirection target, and `${TMPDIR:-/tmp}/<name>`
# -- so a count taken from one of them is a count of what that grep can see. Measured across the
# first four on `20260906`: 69 files and 341 sites, where the elder reading said nine. The fifth was
# added `20260907.000549` after `tlb_reach` reddened a cold pass on a pen written that way, and it
# cost two files and bought back the two it named: 61 files either way, one more spelling covered.
#
# WHAT IS COUNTED. A `/tmp/<token>` path -- written literally, or as `${TMPDIR:-/tmp}/<token>` on a
# pier where TMPDIR is unset -- in any living tracked `.sh` or `.rish`, whose token carries no `$`,
# so the name is fixed at write time rather than at run time.
#
# THE POPULATION WAS `tools/` UNTIL `20260908.052557`, AND THE ROSTER RUNS FILES OUTSIDE IT. The
# source line read `git ls-files 'tools/*'`, which is a room rather than a class: a constant pen is
# contended because eight checkouts share one `/tmp`, and nothing about that reasoning mentions a
# directory. The gap was not hypothetical -- `tools/r/rish_join_split_witness.rish` runs
# `rishi/tests/join.rish` and two siblings, and `tools/fixtures/r/rishi_bounded_process_control.sh`
# runs six more under `rishi/tests/`, so the roster already executes a room this meter could not
# read. Widened here to every tracked `.sh` and `.rish`, which takes the population from 3,221
# sources to 3,289 -- 68 files across `rishi/`, `comlink/`, `arbor/`, `aurora/`, `nixos/`,
# `pond/`, `rye/`, `context/fixtures/`, `classical-vedic-astrology/`, `active-designing/docs/glow/`
# and the two seed publishers at the root. Vendored source enters by none of this: `vendor/` and
# `gratitude/` are gitlinks, so `git ls-files` never lists a byte inside them.
#
# AND THE POPULATION WAS STILL PICKED BY EXTENSION UNTIL `20260908.072606`, WHICH IS THE SAME
# CHOICE ONE SPELLING ON. Widening `tools/*` to `.sh` and `.rish` traded a room for a suffix, and a
# suffix is no more a class than a directory is: a runner is a file the pier EXECUTES, and this tree
# writes seven tracked runners that carry no such suffix at all. Three of them are
# `tools/hooks/commit-msg`, `tools/hooks/pre-commit` and `tools/hooks/post-commit`, which
# `install_hooks.rish` points `core.hooksPath` at -- so every ship runs all three at every commit,
# which is the exact instant REDS `%601` describes, eight bodies written toward one `/tmp` name at
# once. A fourth, `tools/m/mind-bin/git`, is a git shim that runs as often as git does. The elder
# population could not read a line of any of them.
#
# THE POPULATION IS THEREFORE A UNION AND NEVER A SWAP, and the measurement is why the distinction
# is load-bearing rather than pedantic. Read `20260908.072606`: 881 tracked files open with `#!`,
# and 3,298 carry `.sh` or `.rish` -- yet **2,424 of those 3,298 carry no shebang**, because this
# tree's fixtures and Rishi sources are sourced or run by a named interpreter rather than executed.
# So a shebang-only reading would have bought 7 files and dropped 2,424, which is a widening in name
# and the largest narrowing this meter has ever taken. Extension OR shebang: 3,298 -> 3,305.
#
# THE SEVEN HOLD NO PEN TODAY, so both ceilings stay exactly where they stood -- the same shape the
# `tools/` widening took one lap earlier, and the honest one. A population widening that buys no
# number is buying reach, and reach is what it is for: the hooks are clean this morning, and the
# next fixed `/tmp` name written into the file that runs at every commit on eight ships now reds on
# the lap it arrives rather than on the morning a commit body goes missing.
#
# THE FIRST-LINE TEST IS EXACT rather than approximate. `git grep -I -n -E '^#!'` prints
# `path:lineno:text` and the reading keeps `lineno == 1`, so a `#!` inside a heredoc, a comment, or
# an awk program further down the file is read past. `-I` holds binaries out. Corroborated against a
# hand loop reading the first two bytes of every tracked file: both answer 881, and both name the
# same seven outside the suffix population -- which is the check worth having, since a fast reading
# that disagrees with a slow one is a fast reading that is wrong.
#
# THE WIDENING FOUND ONE FILE AND THE REPAIR LANDED IN THE SAME LAP, so both ceilings stay where
# they stood. `rishi/tests/file_io.rish` wrote `/tmp/rishi_io_test.txt`, `/tmp/rishi_io_test_num.txt`
# and `/tmp/rishi_io_var_path.txt` -- five sites, no wipe -- while its own rostered sibling
# `tools/r/rish_file_io_witness.rish` had written into `tools/fixtures/rish_io/` since it was
# seated. The elder copy simply never followed, and the meter could not say so. Pointed at the same
# anchor and run GREEN on metal. Measured before and after: `tools/`-only reads 236 sites, 46 files,
# 15 wiping; widened and repaired reads 236, 46, 15. Reach bought, number unchanged -- which is the
# one shape a population widening can take without asking for slack.
#
# WHAT PASSES FREE, by named rule.
#   A line carrying `mktemp` or `XXXXXX`. The kernel picks that suffix, so no two runs can agree.
#   A line whose first non-whitespace is `#`. A comment creates no directory; it teaches.
#   Any token holding `$` -- `$$`, `${home}`, `$TMPDIR` -- which is a name chosen at run time.
#   Dated testimony under any `date/` shelf, which keeps every word it wrote.
#   A token ending in `.lock` on a line that does not wipe. A lock over a resource the whole pier
#     shares -- a TCP port -- needs a pier-wide path to work at all, and a per-process one would
#     unserialise every ship in silence. Wiping still counts, so the rule is not a door.
#
# THE WIPING SUBSET IS READ SEPARATELY, because the two failures differ in kind. A file that only
# WRITES a constant pen may interleave with a peer and survive; a file that `rm -rf`s one takes the
# peer's in-flight state down with it. Both ratchet; the wiping ceiling is the one to drive to zero
# first, and it is small enough to.
#
# WHAT IS NOT PROVEN. That a pen is ever actually contended -- that depends on which ships run
# which guard at which second. This proves the shape that makes contention possible, which is the
# only half a reading of the source can prove.
#
# THE WIPE READING WAS LINE-SCOPED, AND THAT HID A THIRD OF THE LETHAL SUBSET (REDS `%544`,
# repaired `20260907`). A file assigning a constant pen on one line -- `let pen = "/tmp/name"` --
# and wiping it sixteen lines on -- `run ["rm" "-rf" pen]` -- carries no `/tmp/` token on the
# wiping line, so the site read `hold`. The paragraph that stood here declined the repair on a
# measurement, *ZERO carry that shape now*, and the measurement was taken by the same line-scoped
# reading it was defending: a limitation written down honestly still hides its own size, because
# the sentence naming a blind spot is written from inside it. Read by hand across every `hold`
# file, the honest population was **six** while this scan printed **four**.
#
# So the reading takes TWO PASSES over each file. The first collects every variable assigned a
# constant pen, by the one shape all five spellings share -- a name, an `=`, an optional quote, the
# token. The second counts a `rm -rf` line naming any of those variables as a wipe of that pen, in
# the three spellings this tree writes: `$pen`, `${pen}`, and the bare word a Rishi list passes. It
# errs toward counting, as every other rule here does. The repair found exactly the two files the
# hand-count named, which is the corroboration worth having.
#
# USAGE
#   sh tools/fixtures/s/shared_pen_scan.sh
#   sh tools/fixtures/s/shared_pen_scan.sh --list          # every site, file and token
#   SHARED_PEN_ROOT=<dir> sh tools/fixtures/s/shared_pen_scan.sh    # a pen's own tree
#
# Driven by tools/s/shared_pen_witness.rish. Run from the repository root.

set -u

mode=${1:-count}
root=${SHARED_PEN_ROOT:-.}

# The ceilings only fall. Measured 20260907.000549 with the fifth spelling read and two repairs
# landed: 61 files and 308 sites, of which 7 files wipe. Three readings of the control's own making
# moved that number before it settled, and each was the guard counting something the tree had not
# done wrong: without the token lookahead the same tree read 69 files, five of them repaired the lap
# before; without the single-quote rule it read 65, four of them controls and scans quoting a path
# rather than opening one -- and two of those four were this file's own control, so the guard was
# counting its plants. The third arrived with the fifth spelling: a first reading called 47 files
# damaged, and applying this scan's own dollar lookahead to that spelling took it to 3, of which one
# is the port lock that is shared on purpose. Two were real, and both are repaired.
#
# LOWERED 20260907 to 54 and 4: the whole Amphora vessel family -- seven rostered witnesses -- took
# `mktemp -d` pens in one lap, which is 7 of the 61 files and THREE of the 7 wipers. The race was
# proven on metal in both directions before the repair shipped: four concurrent copies of the elder
# tools/am/amphora_carry_negative_witness.rish read two red and two green, and the two reds failed
# at DIFFERENT assertions (line 55 and line 77), which is a race rather than a defect; four
# concurrent copies of the repaired file read four green, and sixteen concurrent runs across the
# whole repaired family read zero red. What the same lap measured is why it mattered every lap
# rather than rarely: all eight ships had a roster pass live at one instant, their starts spread
# over 164 seconds against a pass of 1,422 seconds, so the passes overlap almost entirely and this
# guard's own "not proven -- that any pen is ever actually contended" is answered for this pier.
# RE-SEATED 20260907 to 6, and this is the one raise this ratchet has taken. The tree did not get
# worse; the meter started reading what was already there. Four was published against a population
# this scan could not fully see (`%544` above), so holding the elder number would gate on a
# measurement known to be wrong -- and the two files it newly sees were verified by hand before the
# number moved: `tools/i/ios_app_shell_witness.rish` and `tools/m/macos_app_bundle_witness.rish`,
# both rostered, both wiping `/tmp/grain_ios_shell_pen` and `/tmp/grain_macos_bundle_pen` through a
# `let`-held name. Both belong to the LOCA surface lane and both need a booted simulator to prove
# GREEN, so they are named here for their owner rather than edited blind from a Linux pier. This
# ceiling falls to 4 the moment they take `mktemp -d` pens, and to 0 when the other four do.
#
# LOWERED AGAIN 20260907.075107 to 53: `tools/fixtures/f/foundations_link_scan.sh` traded
# `/tmp/fls_links.txt` and `/tmp/fls_bad.txt` -- two names fixed at WRITE time, so every ship on
# this pier owned them at once -- for `${TMPDIR:-/tmp}/fls-pen-$$`, made and trapped. That repair
# had been written days earlier and never landed; it came back out of a round-open stash, which is
# why this file is the one that taught `a hold contended is a hold that loses`. The wipe ceiling is
# left where the lane that raised it put it; this lap touched only the file it repaired.
#
# THE SIXTH SPELLING, AND THE ONE RAISE IT FORCED (`20260907.163000`). The wipe predicate demanded
# an `r` or `R` flag, so `rm -f /tmp/name.txt` on a plain file read as a HOLD -- and the hold
# class was defined by the claim that a writer "may interleave with a peer and survive". That
# claim was false of exactly those files. `tools/fixtures/s/shipped_binary_claim_scan.sh`
# truncated a constant name, appended its hits, counted them, and removed the file; on this pier's
# cold pass of `20260907.150519` that guard read RED in company and GREEN alone, and the roster's
# own `standing_equipment` reddened behind it. Removing an in-flight FILE takes a peer down
# exactly as removing a directory does. Two files were repaired in the same lap -- that scan and
# `tools/fixtures/d/documented_room_scan.sh`, which carried the shape line for line -- and the
# remaining sixteen are named by `--list` for their owners, five of them the Caravan poll family
# sharing ONE sentinel path across five witnesses.
#
# So `wipe_ceiling` is RE-DERIVED 6 -> 16 rather than raised: the tree did not get worse, the
# meter started reading what was already there, and holding the elder number would gate on a
# measurement now known to be narrow. This is the second such re-derivation in this file and it
# follows the first (`%544`, 4 -> 6) exactly. Two tightenings landed with it, so the widening
# could not buy its number with noise: a `/tmp` path must begin at a BOUNDARY, which stopped two
# HAWM witnesses being charged for the Android device path `/data/local/tmp/...`; and a removal is
# charged to the path it NAMES, within its own command segment, which stopped
# `tools/l/launch-claude-chapter.rish` being charged for a pen it only tees after removing
# something else on the same very long line. `files_ceiling` FALLS 53 -> 49 on the same readings.
# BOTH FALL on `20260907.191214`, by one file that carried both readings. The `link_witness` ROUND
# MODE self-check held four constant pens and WIPED one of them -- `/tmp/link_witness_round_selfcheck_before.txt`,
# the snapshot its own compare reads back. That is the lethal shape this scan asks be driven to zero
# first, and it was worse than a clobber: a peer's snapshot landing between this tree's SNAPSHOT and
# its COMPARE makes the compare ask whether one tree's dangling set grew against another tree's, and
# two different trees compared as one can read GREEN while a real new dangling link stands. Repaired
# to `mktemp -d`, which cannot collide. Sites 252 -> 239, files 49 -> 48, wiping 16 -> 15.
# AND IT FALLS AGAIN 48 -> 46 on `20260907.213612`, this time because the meter stopped reading
# what it was never looking at. The heredoc rule below holds out a plant's own body, and the two
# files that leave the population by it never held a pen at all: an instrument-absence control that
# writes two plants on purpose, and a claim-preserve fixture carrying an embedded Python selftest.
# So 48 was set over a population contaminated by two, which is the reading that matters when a
# ceiling stands at zero slack -- the 49th file at that cold open was a correct peer control, and it
# reddened every ship on the pier for a path no process ever opens.
#
# WHETHER A RATCHET SHOULD CARRY SLACK IS NOT DECIDED HERE. It is the same standing question the
# doorway census raised the same day and left on the card, and answering it inside a repair to a
# different fault is the shape this tree refuses. The ceiling is set at the true reading, as every
# ratchet here is, and the question stands where it stands.
# THE POPULATION WAS NEVER WIDENED, ONLY THE SPELLINGS (`20260908`). Six of the notes above widen
# how a pen is SPELLED and every one of them held the reading to `tools/*.sh` and `tools/*.rish`.
# That pair is a hand-written enumeration standing in for "every runner this tree owns" -- %532's
# fault one room over -- and what it could not see was the language this tree writes its own
# programs in. `rye/tests/` alone holds four programs that name a constant pen and DELETE it, and
# `tools/p/parity_ch01.rish` builds and runs all four every parity pass, on eight ships.
#
# PROVEN ON METAL BEFORE THE WIDENING SHIPPED, both directions, on `rye/tests/dir_iterate_test.rye`
# as it stood: **89 failures in 2,400 concurrent runs** (`expected one entry, got none`, and
# `error: FileNotFound` out of createDir and openDir), against **0 failures in 2,400 serial runs**.
# Green alone, red in company -- this scan's own signature, in a room it could not read.
#
# AND WIDENING THE POPULATION ALONE WOULD HAVE MADE THE METER WORSE. Three of its rules are spelled
# in shell, and each fails in its own direction on a Rye source: `wipes()` reads `rm -`, so all four
# wipers land in the benign HOLD class; the comment rule reads `#`, so a `//!` usage line in a
# header is charged as an opened pen; and `<<` is Zig's SHIFT operator, so the heredoc detector
# swallowed the rest of a file. Population and predicate move together here or not at all -- a
# reading whose new members all sort into the safe class is more confidently wrong than the narrow
# one it replaced.
#
# THE CEILINGS ARE RE-DERIVED RATHER THAN RAISED, the third such re-derivation in this file and by
# the same reasoning as %544's and the sixth spelling's: the tree did not get worse, the meter
# started reading what was already there. `files_ceiling` 46 -> 50 for four files this seat does
# not repair -- `rishi/tests/file_io.rish` (three constant names, no wipe), `pond/enclosure_policy.rye`
# (an asserted path the module reasons ABOUT rather than opens, counted because this scan errs
# toward counting, as it does everywhere), and the two `tools/rye/macos_app_*_probe.rye` receipts
# whose witness wipes them, both LOCA-lane and unprovable from a Linux pier. `wipe_ceiling` STANDS
# AT 15, unmoved: the four Rye wipers this widening newly sees were repaired in the same lap to
# name their pen from `Thread.getCurrentId()`, and the same 2,400 concurrent runs then read **0**.
# The widening pays for itself rather than buying a number.
#
# SET AT 49 RATHER THAN 50 ON THE REBASE: a peer widened this same population by ROOM in the same
# hour (`%618`, dropping the `tools/*` glob), so the two widenings met in one file -- theirs by
# room, this one by room AND by language. The merged reading is one file lower than either lap
# predicted alone, and a ratchet is set at the true reading rather than at the one a lap expected.
# BOTH FALL BY ONE, `20260908.174500`: `tools/f/fleet_rearm_witness.rish` built and then
# `rm -rf`ed a CONSTANT `/tmp/fleet-rearm-pen` across five separate shells, which on a pier of
# eight ships running one roster is one directory eight hands wipe. It takes `mktemp -d` now and
# interpolates the captured path, so files 49 -> 48 and wiping 15 -> 14. A ratchet migrates on
# touch, and this lap was in the fleet tools already.
# AND BOTH FALL AGAIN, `20260908.175200`: `tools/f/fleet_lap_verdict_witness.rish` wrote two
# constant transcripts and asked the classifier to read each one back in the same shell, so a peer
# landing between the write and the read fed this witness a transcript it never wrote -- a silent
# failure that INVERTS a verdict, which is the fault the guard exists to catch. Files 48 -> 47 and
# wiping 14 -> 13. `tools/g/glow_host_run_witness.sh` carries the same shape in two `.out` files
# and stays counted on purpose: it SKIPs on a host lacking GLOW_HOST.kyri, which this pier is, so
# no lap here can close the repair on metal and a claim is not a witness.
files_ceiling=${SHARED_PEN_FILES_CEILING:-41}
wipe_ceiling=${SHARED_PEN_WIPE_CEILING:-7}

cd "$root" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root is not a directory" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads git ls-files" >&2; exit 1; }

# TWO WIDENINGS MET HERE IN ONE HOUR AND BOTH ARE RIGHT (`20260908`). One reads a runner by its
# SHEBANG, which catches a file with no extension at all; this one reads `.rye`, because a compiled
# program opens its pen when it RUNS rather than when its source is invoked. The peer leg that stood
# between them claimed *a compiled source is not a runner -- the file names a pen the pier never
# opens from this path*, and that is measurably false: `rye/tests/dir_iterate_test.rye` is built and
# run by `tools/p/parity_ch01.rish` on every parity pass, and its constant pen raced **89 times in
# 2,400 concurrent runs** against 0 in 2,400 serial. What the source is invoked as and what the
# program does are two questions; only the second decides whether two ships collide.
sources=$(
  {
    git ls-files 2>/dev/null | grep -E '\.(sh|rish|rye)$'
    # A runner names itself on its first line. `git grep -n` prints `path:lineno:text`, so keeping
    # only `lineno == 1` reads the shebang rather than a `#!` standing anywhere further down.
    git grep -I -n -E '^#!' 2>/dev/null | awk -F: '$2 == 1 { print $1 }'
  } | grep -vE '^(vendor|gratitude)/' | grep -v '/date/' | sort -u)
sources_n=$(printf '%s\n' "$sources" | grep -c . || true)
if [ "$sources_n" -eq 0 ]; then
  echo "verdict=no_sources"
  echo "refused: no tracked runner sources under this root -- a zero here would read as clean" >&2
  exit 1
fi

hits=$(printf '%s\n' "$sources" | while read -r f; do
  [ -n "$f" ] && [ -f "$f" ] || continue
  awk -v F="$f" '
    # TEXT INSIDE SINGLE QUOTES IS TEXT, not a path this file opens. A control writes a plant into
    # a throwaway tree with `printf \x27... /tmp/wiped_pen ...\x27 > "$pen/..."`, and a scan
    # normalises a path bwrap made with `sed -e \x27s#/tmp/bwrap-hosts...#\x27`. Both are talking
    # ABOUT a path rather than claiming one, and counting them makes a guard report its own plants
    # -- the fault %519 booked one room over. Measured: exactly four files, seventeen sites, and
    # every one of the four is a control or a scan. Spans are PAIRED rather than counted by parity,
    # so a lone apostrophe in ordinary prose opens nothing and the reading errs toward counting.
    function quoted(line, pos,   i, a, b) {
      i = 1
      while (1) {
        a = index(substr(line, i), "\x27"); if (a == 0) return 0; a = a + i - 1
        b = index(substr(line, a + 1), "\x27"); if (b == 0) return 0; b = b + a
        if (pos > a && pos < b) return 1
        i = b + 1
      }
    }
    # THE FIFTH SPELLING, AND WHY IT IS NORMALISED RATHER THAN MATCHED SEPARATELY. This tree also
    # writes a pen as ${TMPDIR:-/tmp}/<name>, and TMPDIR is UNSET on this pier, so that default
    # resolves to /tmp for all eight ships. The literal /tmp/ never appears in it -- the text reads
    # /tmp} -- so the four elder spellings passed straight over it. tools/fixtures/t/tlb_reach_census.sh
    # is written that way, opens with rm -rf on that pen, and reddened the cold pass of
    # 20260906.233225 at "the probe no longer builds" while running GREEN alone one minute later.
    # Substituting a SAME-LENGTH stand-in keeps every column where it stood, so the quote rule and
    # the dollar lookahead below read true positions and there is one matcher rather than two.
    # The stand-in is dashes rather than underscores: the path boundary rule below reads the
    # character before /tmp, and an underscore is a word character, so the elder filler made the
    # fifth spelling look like the tail of a longer name and freed it. Same length either way, so
    # every column the quote rule and the dollar lookahead read stays where it stood.
    function norm(l) { gsub(/\$\{TMPDIR:-\/tmp\}/, "-----------/tmp", l); return l }
    # A WIPE IS ANY REMOVAL OF THE PEN, RECURSIVE OR NOT -- the sixth spelling, seated
    # 20260907.163000. The elder predicate demanded an r or R flag, so `rm -f /tmp/name.txt` on a
    # plain file read as a HOLD, and the header reason for the hold class -- that a writer may
    # interleave with a peer and survive -- was false of exactly those files. It fired on this
    # pier cold pass of 20260907.150519: tools/fixtures/s/shipped_binary_claim_scan.sh truncated a
    # constant /tmp name, appended, counted, and removed it, and the guard read red in company and
    # GREEN alone. Removing an in-flight FILE takes a peer down exactly as removing a directory
    # does; the flag says how, never whether.
    # THE SEVENTH SPELLING IS A LANGUAGE RATHER THAN A SYNTAX. Rye removes a pen with
    # deleteTree, deleteFile or deleteDir, so a shell-shaped wipe predicate reads every Rye wiper
    # as a HOLD -- the benign class. That is the direction a meter must never be wrong in.
    function wipes(l) { return (l ~ /(^|[^A-Za-z0-9_.\/-])rm[ \t]+-/ || l ~ /"rm"[ \t]+"-/ || l ~ /delete(Tree|File|Dir)Z?[ \t]*\(/) }
    # WHERE THE rm STANDS ON THE LINE, so a removal is charged to the path it actually names. Any
    # rm on a line used to mark every /tmp token on that line, which the widening made loud:
    # tools/l/launch-claude-chapter.rish removes .loop-gates-only and tees a constant pen in one
    # long command, and the pen is a hold rather than a wipe. Zero means no rm on this line.
    function rm_at(l,   p) {
      p = match(l, /(^|[^A-Za-z0-9_.\/-])rm[ \t]+-/); if (p > 0) return p + RLENGTH
      p = match(l, /"rm"[ \t]+"-/); if (p > 0) return p + RLENGTH
      p = match(l, /delete(Tree|File|Dir)Z?[ \t]*\(/); if (p > 0) return p + RLENGTH
      return 0
    }
    # THE SEGMENT A TOKEN STANDS IN, so a removal never reaches across a command separator. One
    # line of tools/l/launch-claude-chapter.rish removes .loop-gates-only and, several commands
    # later in the same line, tees a constant pen: the pen is a hold, and only a reading that stops
    # at the ; && || | between them can say so. Ordinary prose carrying an ampersand costs nothing,
    # since a segment with no rm in it is a hold either way.
    function seg_head(l, pos,   i, c, start) {
      start = 1
      for (i = 1; i < pos; i++) {
        c = substr(l, i, 1)
        if (c == ";" || c == "&" || c == "|") start = i + 1
      }
      return start
    }
    function wiped_here(l, pos,   start, p) {
      start = seg_head(l, pos)
      p = rm_at(substr(l, start))
      return (p > 0 && start + p - 1 < pos)
    }
    # The recursive form is still read apart, because one rule needs it: the port lock below is
    # RELEASED with rm -f by design, so the lock exemption asks whether the removal was recursive
    # rather than whether it happened at all. That keeps both halves of the elder rule -- a real
    # lock passes free, and a pen wearing a .lock suffix to escape the rule is counted the moment
    # it is destroyed like a pen.
    function wipes_recursive(l) { return (l ~ /rm[ \t]+-[a-zA-Z]*[rR]/ || l ~ /"rm"[ \t]+"-[a-zA-Z]*[rR]/) }
    # A HEREDOC BODY IS PROGRAM CONTENT, not a path this file opens -- the same distinction the
    # quote rule above already draws, one scale up. A control writes a plant with
    # `cat > "$pen/probe.sh" <<PEN ... PEN`, and every /tmp path inside that body belongs to the
    # PLANT rather than to the control: the control never opens it, no peer can collide on it, and
    # the plant is usually never executed at all.
    #
    # THIS IS THE THIRD ROOM TO MEET THE FAULT, which is what makes it a law rather than a patch.
    # %443 taught it to the instrument-absence meter, whose control now carries the sentence in its
    # own body -- "the meter must be able to read a control like this one without counting the
    # plants it writes" -- and the ASCII comment meters learned it as "skip program content" when a
    # Rye multiline string and a shell heredoc body proved to be what a program PRINTS. This meter
    # had not, and it read four tokens across three files that way, every one inside a heredoc:
    # tools/fixtures/j/journal_query_control.sh (a planted probe reading a constant path),
    # tools/fixtures/i/instrument_absence_control.sh (two plants it writes on purpose), and
    # tools/fixtures/c/claim_preserve_modality.sh (an embedded Python selftest).
    #
    # WHAT IT COST, and why it was worth a lap rather than a ceiling raise. The files ceiling stood
    # at 48 against a true reading of 46, so the population it was set over was contaminated by two
    # files that never held a pen. A ratchet at zero slack over a contaminated population reds every
    # ship on the pier for a plant -- the shape REDS %585 books -- and it fired here at the cold
    # open of 20260907.213612 reading 49 files, the 49th a correct peer control landed that hour.
    #
    # THE OPENING LINE IS STILL READ, since `cat > /tmp/real_pen <<EOF` genuinely claims a path; only
    # the body between the opener and its terminator is held out. Both passes skip it, so a pen
    # ASSIGNED inside a plant is not learned either. The delimiter is read by stripping the optional
    # dash, tilde and quotes rather than by matching a quote inside this regex, because the awk
    # program is a single-quoted shell string and a literal apostrophe here would end it.
    { if (FNR == 1) { inhere = 0; hereterm = "" } }
    inhere {
      hline = $0; sub(/^[ \t]+/, "", hline)
      if (hline == hereterm) { inhere = 0; hereterm = "" }
      next
    }
    {
      if ($0 !~ /^[ \t]*#/ && $0 !~ /^[ \t]*\/\//) {
        hp = index($0, "<<")
        if (hp > 0) {
          hrest = substr($0, hp + 2)
          sub(/^[-~]/, "", hrest)
          sub(/^[ \t]+/, "", hrest)
          hq = sprintf("%c", 39)
          gsub(hq, "", hrest); gsub(/"/, "", hrest)
          if (match(hrest, /^[A-Za-z_][A-Za-z0-9_]*/)) {
            hereterm = substr(hrest, 1, RLENGTH); inhere = 1
          }
        }
      }
    }
    # PASS ONE READS THE ASSIGNMENTS, so a wipe one line below its pen is read as a wipe. See the
    # header: the elder reading was line-scoped, and it hid two of the six wipers in this tree.
    FNR == NR {
      line = norm($0)
      if (line ~ /^[ \t]*#/ || line ~ /^[ \t]*\/\//) next
      if (line ~ /mktemp|XXXXXX/) next
      s = line; off = 0
      while (match(s, /(^|[^A-Za-z0-9_.])\/tmp\/[A-Za-z0-9_.\-]+/)) {
        rs = RSTART; rl = RLENGTH
        # A PATH BEGINS AT A BOUNDARY. The token class alone matches the tail of
        # /data/local/tmp/seva_b0_witness, an Android device path this pier never opens, and two
        # HAWM witnesses were counted for it. The boundary character is consumed by the match, so
        # it is stepped over here rather than folded into the token.
        lead = (substr(s, rs, 1) == "/") ? 0 : 1
        tok = substr(s, rs + lead, rl - lead)
        next_ch = substr(s, rs + rl, 1)
        abs_pos = off + rs + lead
        off = off + rs + rl - 1
        s = substr(s, rs + rl)
        if (tok ~ /\$/) continue
        # A NAME COMPLETED AT RUN TIME IS NOT FIXED AT WRITE TIME, whichever notation completes
        # it. `$` is the shell marker and `{` the Rye one: /tmp/pen-{d} is a bufPrint format whose
        # pid arrives when the program runs, so no two processes can agree on it.
        if (next_ch == "$" || next_ch == "{") continue
        if (quoted(line, abs_pos)) continue
        # The assignment is read from the text immediately BEFORE the token, which is the one shape
        # every spelling shares: `pen=/tmp/x`, `pen="/tmp/x"`, `let pen = "/tmp/x"`, `local pen=`.
        pre = substr(line, 1, abs_pos - 1)
        if (match(pre, /[A-Za-z_][A-Za-z0-9_]*[ \t]*=[ \t]*"?[ \t]*$/)) {
          name = substr(pre, RSTART, RLENGTH)
          sub(/[ \t]*=.*$/, "", name)
          held[name] = tok
        }
      }
      next
    }
    {
      line = norm($0)
    }
    line ~ /^[ \t]*#/ || line ~ /^[ \t]*\/\// { next }
    line ~ /mktemp|XXXXXX/ { next }
    {
      # A WIPE OF A HELD PEN IS A WIPE. `rm -rf "$pen"` and `run ["rm" "-rf" pen]` carry no /tmp/
      # token of their own, so the elder line-scoped reading called them holds and the lethal
      # subset read low. The name is matched at word boundaries in any of its three spellings --
      # $pen, ${pen}, and the bare word a Rishi list passes -- and the reading errs toward
      # counting, as every other rule here does.
      if (wipes(line)) {
        for (name in held) {
          if (line ~ ("(^|[^A-Za-z0-9_])[$]?[{]?" name "[}]?([^A-Za-z0-9_]|$)")) {
            print F "\t" "wipe" "\t" held[name]
          }
        }
      }
      s = line
      off = 0
      while (match(s, /(^|[^A-Za-z0-9_.])\/tmp\/[A-Za-z0-9_.\-]+/)) {
        rs = RSTART; rl = RLENGTH
        lead = (substr(s, rs, 1) == "/") ? 0 : 1
        tok  = substr(s, rs + lead, rl - lead)
        # READ THE CHARACTER AFTER THE TOKEN, not only the token. The token class stops at `$`, so
        # `/tmp/pen_$$` and `/tmp/pen_${home}` both match as the constant `/tmp/pen_` and would be
        # counted -- the guard instructing the repair the file has already made. The control caught
        # both on the first run (pid_free, interpolate_free). The SAME rule reads Rye notation:
        # `{` opens a bufPrint format placeholder, so /tmp/pen-{d} is completed at run time exactly
        # as /tmp/pen_$$ is. Both passes carry this rule or neither does -- pass one learns the
        # held names and pass two counts the sites, and a rule in one alone frees a pen from the
        # wipe reading while still charging it as a constant.
        next_ch = substr(s, rs + rl, 1)
        abs_pos = off + rs + lead
        off = off + rs + rl - 1
        s = substr(s, rs + rl)
        if (tok ~ /\$/) continue
        if (next_ch == "$" || next_ch == "{") continue
        if (quoted(line, abs_pos)) continue
        # A REMOVAL IS CHARGED TO THE PATH IT NAMES, so a token standing BEFORE the rm on its line
        # is a hold. A held variable removed anywhere on the line is still a wipe, which pass one
        # settles above.
        wipe = wiped_here(line, abs_pos) ? "wipe" : "hold"
        # A LOCK IS SHARED ON PURPOSE, WHERE A PEN NEVER IS. tools/fixtures/a/amphora_vessel_port_lock.sh
        # holds a .lock under the same default, and TCP port 38494 is one resource for the whole
        # pier -- so a pier-wide path is what makes that lock work, and a per-process one would
        # silently unserialise eight ships. Freed only on a line that does NOT wipe: a lock is
        # released with rm -f, never rm -rf, so a pen wearing a .lock suffix to escape this rule is
        # still counted the moment it behaves like a pen. Proven both ways in the control.
        if (tok ~ /\.lock$/ && !wipes_recursive(line)) continue
        print F "\t" wipe "\t" tok
      }
    }
  ' "$f" "$f"
done)
sites=$(printf '%s\n' "$hits" | grep -c . || true)
files=$(printf '%s\n' "$hits" | grep . | cut -f1 | sort -u | grep -c . || true)
wipe_files=$(printf '%s\n' "$hits" | grep . | awk -F'\t' '$2=="wipe"{print $1}' | sort -u | grep -c . || true)

if [ "$mode" = "--list" ]; then
  printf '%s\n' "$hits" | grep . | sort -u | sed 's/^/site: /'
fi

echo "sources_read=$sources_n"
echo "constant_pen_sites=$sites"
echo "constant_pen_files=$files"
echo "files_ceiling=$files_ceiling"
echo "wiping_files=$wipe_files"
echo "wipe_ceiling=$wipe_ceiling"

verdict=ok
if [ "$files" -gt "$files_ceiling" ]; then
  echo "over: constant_pen_files=$files past its ceiling of $files_ceiling -- name the pen with mktemp or \$\$"
  verdict=over_ceiling
fi
if [ "$wipe_files" -gt "$wipe_ceiling" ]; then
  echo "over: wiping_files=$wipe_files past its ceiling of $wipe_ceiling -- a wipe of a shared pen takes a peer down"
  verdict=over_ceiling
fi
echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
