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
# pier where TMPDIR is unset -- in a living tracked `.sh` or `.rish` under `tools/`, whose token
# carries no `$`, so the name is fixed at write time rather than at run time.
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
# AND THE WIPE READING IS LINE-SCOPED. A file that assigns a constant pen to a variable on one line
# and `rm -rf`s that variable on another reads as a `hold` rather than a `wipe`, which under-reads
# the lethal subset. `tlb_reach_census.sh` was written exactly that way. Measured `20260907.000549`
# across the 54 files this scan counts as holding: ZERO carry that shape now, so it is named here
# rather than gated -- a variable tracker for one live instance is a cost with nothing to buy.
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
files_ceiling=${SHARED_PEN_FILES_CEILING:-54}
wipe_ceiling=${SHARED_PEN_WIPE_CEILING:-4}

cd "$root" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root is not a directory" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads git ls-files" >&2; exit 1; }

sources=$(git ls-files 'tools/*' 2>/dev/null | grep -E '\.(sh|rish)$' | grep -v '/date/')
sources_n=$(printf '%s\n' "$sources" | grep -c . || true)
if [ "$sources_n" -eq 0 ]; then
  echo "verdict=no_sources"
  echo "refused: no tracked tools sources under this root -- a zero here would read as clean" >&2
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
    { line = $0; gsub(/\$\{TMPDIR:-\/tmp\}/, "___________/tmp", line) }
    line ~ /^[ \t]*#/ { next }
    line ~ /mktemp|XXXXXX/ { next }
    {
      s = line
      off = 0
      # A wipe is read off the WHOLE line rather than the token, since the `rm -rf` and its target
      # are separate words and Rishi spells it as a list: run ["rm" "-rf" home].
      wipe = (line ~ /rm[ \t]+-[a-zA-Z]*[rR]/ || line ~ /"rm"[ \t]+"-[a-zA-Z]*[rR]/) ? "wipe" : "hold"
      while (match(s, /\/tmp\/[A-Za-z0-9_.\-]+/)) {
        tok  = substr(s, RSTART, RLENGTH)
        # READ THE CHARACTER AFTER THE TOKEN, not only the token. The token class stops at `$`, so
        # `/tmp/pen_$$` and `/tmp/pen_${home}` both match as the constant `/tmp/pen_` and would be
        # counted -- the guard instructing the repair the file has already made. The control caught
        # both on the first run (pid_free, interpolate_free).
        next_ch = substr(s, RSTART + RLENGTH, 1)
        abs_pos = off + RSTART
        off = off + RSTART + RLENGTH - 1
        s = substr(s, RSTART + RLENGTH)
        if (tok ~ /\$/) continue
        if (next_ch == "$") continue
        if (quoted(line, abs_pos)) continue
        # A LOCK IS SHARED ON PURPOSE, WHERE A PEN NEVER IS. tools/fixtures/a/amphora_vessel_port_lock.sh
        # holds a .lock under the same default, and TCP port 38494 is one resource for the whole
        # pier -- so a pier-wide path is what makes that lock work, and a per-process one would
        # silently unserialise eight ships. Freed only on a line that does NOT wipe: a lock is
        # released with rm -f, never rm -rf, so a pen wearing a .lock suffix to escape this rule is
        # still counted the moment it behaves like a pen. Proven both ways in the control.
        if (wipe == "hold" && tok ~ /\.lock$/) continue
        print F "\t" wipe "\t" tok
      }
    }
  ' "$f"
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
