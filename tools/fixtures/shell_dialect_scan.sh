#!/bin/sh
# tools/fixtures/shell_dialect_scan.sh -- count GNU-only shell idioms in this tree's own guards.
#
# WHAT THIS IS FOR. This tree runs on two piers: a NixOS VPS with GNU coreutils, and a macOS
# bench with BSD ones. A guard written in one host's dialect does not announce itself on the
# other -- it produces empty output, and a count taken from empty output is zero. A zero that
# nobody planted reads exactly like a healthy tree.
#
# WHAT IT COSTS WHEN IT IS MISSED. On 20260825 the macOS bench regenerated
# docs-geode/libraries/README.md and shipped it to the anointed remote with the witness column
# reading 0 for all 38 rooms. The generator counts through `xargs -a FILE -d '\n' grep -l`, and
# BSD xargs has neither flag, so the pipeline yielded nothing. The page's own guard agreed
# perfectly, because the guard renders through the same function it checks (REDS %240). This is
# REDS %169's confident wrong zero arriving through a second door, and REDS %226 -- two guards
# speaking one host's awk dialect -- was the same class a third time. A lantern that fires twice
# becomes a loom, so the class is measured here rather than remembered.
#
#   sh tools/fixtures/shell_dialect_scan.sh            # measure and gate
#   sh tools/fixtures/shell_dialect_scan.sh list       # print every gated site
#   sh tools/fixtures/shell_dialect_scan.sh prove-red      # plant one site; must exit 1
#   sh tools/fixtures/shell_dialect_scan.sh prove-dialect  # reproduce the zero under a BSD xargs
#   sh tools/fixtures/shell_dialect_scan.sh prove-portable # a real scan reads the same under both
#
# WHAT IS GATED, AND WHAT IS ONLY REPORTED. One family is gated: `xargs -a` / `-d` and their long
# forms, because that family is the one proven on metal to zero a shipped page. The tree's twelve
# sites moved to `tools/fixtures/shell_portable.sh` on `20260826.062128`, so the ceiling stands at
# ZERO and the family is a ratchet: the next one reds on the lap it arrives. Five more families are
# counted and printed without gating -- they are GNU-only too, and `date -d` is now known to be the
# root of REDS %250's clock-provenance refusal, so its repair is the next lap rather than a claim
# made here. A number a reader can check beats a ceiling nobody verified.
#
# THE ONE EXCLUSION, named once. This file writes the idiom it counts, inside its own pattern and
# its own prose, so it would report itself forever; it is excluded by path. It is written in POSIX
# shell for the same reason a portability guard must be: one that only runs on one host proves
# nothing about the other.
set -eu

CEILING="${SHELL_DIALECT_CEILING:-0}"
mode="${1:-measure}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads tracked living sources" >&2
  exit 1
}
cd "$root"

SELF='tools/fixtures/shell_dialect_scan.sh'

# TWO FILES HOLD THE ELDER SPELLINGS ON PURPOSE, and both are read past. This scan spells every
# pattern it hunts for, and `shell_portable.sh` spells the GNU leg of each fallback chain -- that
# leg IS the repair on a GNU host, and the BSD leg beside it is what makes the pair portable.
# Counting either would tell a reader to delete the answer.
HELPER='tools/fixtures/shell_portable.sh'

# The chain between `xargs` and the flag must be dash-options only, so `xargs grep -d` -- where
# `-d` belongs to grep -- is read past rather than counted. The trailing class rejects `-delimiter`
# spelled as a longer word while accepting `-d'\n'` written with no space.
GATED_RE='xargs[[:space:]]+(-[a-zA-Z0-9]+[[:space:]]+)*(-(a|d)([^a-zA-Z0-9-]|$)|--(arg-file|delimiter|null))'

# THE SECOND GATED FAMILY. `date -d` is a GNU extension; BSD, which is what macOS ships, spells the
# parse `-j -f INFMT STRING`, the format-an-epoch `-r EPOCH`, and the relative shift `-v+4H`, and
# refuses `-d` outright. It earned its gate the way the xargs family did -- by costing a real
# reading on a real host. Measured `20260826.015353` on the macOS bench and reproduced here
# `20260826.072239` under a BSD-shaped date: tools/fixtures/one_clock_provenance_scan.sh read two
# PROV_OK lines on GNU and ZERO under the shim, calling every stamp in the tree unparsable, and
# tools/o/one_clock_witness.rish refused on its own PASS fixture (REDS %250). The seven lines that
# carried it moved to stamp_epoch, epoch_stamp and stamp_ahead in shell_portable.sh.
DATE_RE='date[[:space:]]+(-[a-zA-Z0-9]+[[:space:]]+)*-d([^a-zA-Z0-9-]|$)'
DATE_CEILING=${SHELL_DIALECT_DATE_CEILING:-0}

# A GNU SPELLING STANDING BESIDE ITS BSD PARTNER IS THE REPAIR, not a site. That pairing takes two
# shapes in this tree and the scan reads past both. On ONE LINE it is a fallback chain, and this
# pattern finds the partner: `date -d 'tomorrow 15:00' +%s 2>/dev/null || date -v+1d -v15H ... +%s`,
# which was read on metal `20260826.075023` and answered the same second on both dialects. Across
# TWO LINES it is a function whose legs each end in `&& return 0`, which is how shell_portable.sh
# writes them -- so that file is named above and read past whole. Counting either would tell a
# reader to delete the answer, which is the test this meter applies to every number it prints.
DATE_BSD_RE='date[[:space:]]+(-[a-zA-Z0-9]+[[:space:]]+)*-(j|r|v[+-])'

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
roster="$pen/roster"

# A TRACKED SYMLINK IS THE SAME SOURCE UNDER A SECOND NAME. `pond/apps/corpora/one_clock.rish`
# points at `tools/o/one_clock_witness.rish`, so `git ls-files` names one file twice and grep,
# following the link, counts every line in it twice. The date family read NINE across the tree where
# seven lines carry it -- a count that overstates the repair a reader is about to make and, in the
# gated tier, would name a size no edit can reach. Mode 120000 is git's own answer to which entries
# those are, so the roster asks git rather than guessing. THE LIMIT, named: a symlink pointing OUT
# of the roster's own globs would go unmeasured here, and nothing in this tree does that today --
# the one tracked symlink among the shell sources targets a file already on the roster.
roster_links=$(git ls-files -s -- '*.sh' '*.rish' 'tools/hooks/*' | grep -c '^120000 ' || true)
git ls-files -s -- '*.sh' '*.rish' 'tools/hooks/*' \
  | grep -v '^120000 ' \
  | cut -f2- \
  | grep -v "^${SELF}\$" \
  | grep -v "^${HELPER}\$" > "$roster" || true

if [ ! -s "$roster" ]; then
  echo "refused: no tracked shell sources found -- the roster this guard reads is empty" >&2
  exit 1
fi

if [ "$mode" = prove-red ]; then
  # The plant is ONE file, not a copy of the repository. REDS %239 was a pen that filled the
  # tmpfs and reddened four unrelated guards mid-run; a pen is motion, so this one stays small.
  printf 'xargs -a "$list" -d "\\n" grep -l pattern\n' > "$pen/planted_dialect_scan.sh"
  echo "$pen/planted_dialect_scan.sh" >> "$roster"
fi


if [ "$mode" = prove-date-red ]; then
  # The date ceiling stands at zero, so there is no tree one site under the reading. The plant
  # supplies it: one bare `date -d` with no BSD partner beside it, which must refuse at a ceiling of
  # zero and pass at a ceiling of one. A ceiling proven only in the passing direction cannot be told
  # from a bypass.
  printf 'stamp=$(date -d "2026-08-26 06:37:05" +%%s)\n' > "$pen/planted_date_scan.sh"
  echo "$pen/planted_date_scan.sh" >> "$roster"
fi

if [ "$mode" = prove-dialect ]; then
  # THE MECHANISM, PROVEN ON METAL rather than asserted. A counter that falls proves a spelling
  # changed; it does not prove the spelling was ever broken. So this leg builds a two-line `xargs`
  # that refuses `-a` and `-d` exactly as BSD xargs does, puts it first on PATH, and runs both
  # forms against one file that matches and one that does not. The GNU form must answer 0 -- the
  # confident wrong zero itself, reproduced -- and the portable form must answer 1.
  real_xargs=$(command -v xargs) || { echo "refused: no xargs on PATH" >&2; exit 1; }
  mkdir -p "$pen/bin"
  printf '#!/bin/sh\nfor a in "$@"; do case "$a" in -a|-a*|-d|-d*) echo "xargs: illegal option" >&2; exit 1;; esac; done\nexec %s "$@"\n' "$real_xargs" > "$pen/bin/xargs"
  chmod +x "$pen/bin/xargs"
  printf 'this line reaches caravan/ plainly\n' > "$pen/hit.txt"
  printf 'this line reaches nothing\n' > "$pen/miss.txt"
  printf '%s\n%s\n' "$pen/hit.txt" "$pen/miss.txt" > "$pen/files"
  gnu=$(PATH="$pen/bin:$PATH" sh -c "xargs -a '$pen/files' -d '\n' grep -lI 'caravan/' 2>/dev/null | grep -c . || true")
  por=$(PATH="$pen/bin:$PATH" sh -c "tr '\n' '\0' < '$pen/files' | xargs -0 grep -lIE '(^|[^A-Za-z0-9_])caravan/' 2>/dev/null | grep -c . || true")
  echo "shell-dialect: the mechanism, reproduced under a BSD-shaped xargs."
  echo "gnu_form_under_bsd=$gnu"
  echo "portable_form_under_bsd=$por"
  if [ "$gnu" -ne 0 ]; then
    echo "verdict=shim_did_not_bite"
    echo "refused: the GNU form answered $gnu under a shim that must break it -- the proof is not a proof."
    exit 1
  fi
  if [ "$por" -ne 1 ]; then
    echo "verdict=portable_form_broke_too"
    echo "refused: the portable form answered $por where 1 was planted."
    exit 1
  fi
  echo "verdict=ok"
  exit 0
fi

if [ "$mode" = prove-date ]; then
  # THE SECOND DIALECT, PROVEN THE SAME WAY. `prove-portable` above shows a real guard reading one
  # number under two `xargs`. This leg does it for `date`, over the guard the fault was actually
  # found in: tools/fixtures/one_clock_provenance_scan.sh, which parses every dated stamp it weighs.
  #
  # Measured on this pier `20260826.072239`, before the repair: the scan read two PROV_OK lines on
  # GNU and ZERO under a BSD-shaped `date`, calling every stamp in the tree unparsable. That is the
  # macOS bench's `PROV_FAIL count=1` (REDS %250), reproduced here without a Mac.
  #
  # The base is pinned to HEAD and the stamp list is one explicit stamp, so the branch's own merged
  # history stays out of the reading. It does NOT make the number constant: the provenance scan
  # weighs every dated artifact the working tree and index hold, so a round staging its own session
  # log adds one. That is why this leg compares the two dialects against each other and refuses
  # when they differ, rather than pinning a count anyone would have to edit each round (REDS %259).
  real_date=$(command -v date) || { echo "refused: no date on PATH" >&2; exit 1; }
  mkdir -p "$pen/bin" "$pen/tools/fixtures"
  cat > "$pen/bin/date" <<SHIM
#!/bin/sh
case "\${1:-}" in
  -d|-d*) echo "date: illegal option -- d" >&2; exit 1 ;;
  -j) shift
      [ "\${1:-}" = "-f" ] || { echo "date: illegal time format" >&2; exit 1; }
      infmt=\$2; str=\$3; shift 3
      [ "\$infmt" = '%Y%m%d%H%M%S' ] || { echo "date: unsupported input format \$infmt" >&2; exit 1; }
      y=\${str%??????????}; rest=\${str#????}; mo=\${rest%????????}
      d=\${rest#??}; d=\${d%??????}; hms=\${str#????????}
      h=\${hms%????}; mi=\${hms#??}; mi=\${mi%??}; s=\${hms#????}
      exec $real_date -d "\${y}-\${mo}-\${d} \${h}:\${mi}:\${s}" "\$@" ;;
  -r) ep=\$2; shift 2; exec $real_date -d "@\${ep}" "\$@" ;;
esac
exec $real_date "\$@"
SHIM
  chmod +x "$pen/bin/date"

  # The plant restores the elder body byte for byte, sourced after the helper so it wins. A plant
  # that merely deleted the call would answer empty on both dialects and prove nothing.
  cat > "$pen/elder.sh" <<'ELDER'
stamp_epoch() {
  dot=$1
  ymd=${dot%%.*}
  hms=${dot#*.}
  yyyy=${ymd%????}
  mm=${ymd#????}; mm=${mm%??}
  dd=${ymd#??????}
  hh=${hms%????}
  mi=${hms#??}; mi=${mi%??}
  ss=${hms#????}
  TZ="$ZONE" date -d "${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}" +%s 2>/dev/null || return 1
}
ELDER
  awk -v elder="$pen/elder.sh" '
    { print }
    /shell_portable\.sh"$/ && !seen { print ". \"" elder "\""; seen = 1 }
  ' tools/fixtures/one_clock_provenance_scan.sh > "$pen/tools/fixtures/planted_one_clock_provenance_scan.sh"
  cp tools/fixtures/shell_portable.sh "$pen/tools/fixtures/"

  read_ok() {
    ONE_CLOCK_PROVENANCE_BASE=HEAD ONE_CLOCK_PROVENANCE_STAMPS=20260101.120000 \
      sh "$1" 2>/dev/null | grep -c '^PROV_OK' || true
  }
  live_gnu=$(read_ok tools/fixtures/one_clock_provenance_scan.sh)
  live_bsd=$(PATH="$pen/bin:$PATH" read_ok tools/fixtures/one_clock_provenance_scan.sh)
  plant_gnu=$(read_ok "$pen/tools/fixtures/planted_one_clock_provenance_scan.sh")
  plant_bsd=$(PATH="$pen/bin:$PATH" read_ok "$pen/tools/fixtures/planted_one_clock_provenance_scan.sh")

  echo "shell-dialect: a real clock guard, read on both dialects, and a plant that must still break."
  echo "subject=tools/fixtures/one_clock_provenance_scan.sh:PROV_OK"
  echo "living_gnu=$live_gnu"
  echo "living_bsd_shaped=$live_bsd"
  echo "planted_elder_gnu=$plant_gnu"
  echo "planted_elder_bsd_shaped=$plant_bsd"
  if [ "$live_gnu" -eq 0 ]; then
    echo "verdict=subject_reads_nothing"
    echo "refused: the subject answered 0 on GNU -- a comparison against zero proves nothing."
    exit 1
  fi
  if [ "$live_bsd" != "$live_gnu" ]; then
    echo "verdict=host_changed_the_reading"
    echo "refused: the subject read $live_gnu on GNU and $live_bsd under a BSD-shaped date."
    exit 1
  fi
  if [ "$plant_gnu" != "$live_gnu" ]; then
    echo "verdict=plant_is_not_a_working_copy"
    echo "refused: the planted copy read $plant_gnu on GNU where the living subject reads $live_gnu."
    exit 1
  fi
  if [ "$plant_bsd" -ne 0 ]; then
    echo "verdict=plant_did_not_bite"
    echo "refused: the planted elder spelling still read $plant_bsd under the shim."
    exit 1
  fi
  echo "verdict=ok"
  exit 0
fi

if [ "$mode" = prove-portable ]; then
  # THE REPAIR, PROVEN BY BEHAVIOUR rather than by spelling. `prove-dialect` above shows the GNU
  # form zeroing under a BSD-shaped xargs on a toy pair of files; this leg shows a REAL guard of
  # this tree reading the same number on both dialects, which is the property the repair claims.
  #
  # exec_bit_scan.sh is the subject on purpose. It counts paths a tracked file invokes as `./x`,
  # and it gates `directly_invoked_not_exec` at zero, enforced. Measured `20260826.062128` before
  # the repair: `directly_invoked` read 18 on GNU and 0 under the shim, and BOTH runs printed
  # `verdict=ok` -- so the enforced gate had nothing to enforce over on the second pier (REDS %249).
  #
  # BOTH DIRECTIONS, in one leg. The living subject must agree across dialects, AND a planted copy
  # carrying the elder GNU-only spelling must still disagree. Without the second half this leg
  # could not tell a portable subject from a shim that had stopped biting -- and a refusal proven
  # only in the passing direction cannot be told from a bypass. Comparing readings rather than
  # pinning a constant keeps both halves true as the tree grows.
  real_xargs=$(command -v xargs) || { echo "refused: no xargs on PATH" >&2; exit 1; }
  mkdir -p "$pen/bin" "$pen/tools/fixtures"
  printf '#!/bin/sh\nfor a in "$@"; do case "$a" in -a|-a*|-d|-d*) echo "xargs: illegal option" >&2; exit 1;; esac; done\nexec %s "$@"\n' "$real_xargs" > "$pen/bin/xargs"
  chmod +x "$pen/bin/xargs"

  # The plant is one line of one copy, and the helper travels beside it because the copy sources it.
  sed "s|^xargs_lines_batched 400 \"\$work/living.txt\" .*|xargs -a \"\$work/living.txt\" -d '\\n' -n 400 \\\\|" \
    tools/fixtures/exec_bit_scan.sh > "$pen/tools/fixtures/planted_exec_bit_scan.sh"
  cp tools/fixtures/shell_portable.sh "$pen/tools/fixtures/"

  read_invoked() { sh "$1" 2>/dev/null | sed -n 's/^directly_invoked=\([0-9][0-9]*\)$/\1/p' | head -1; }
  live_gnu=$(read_invoked tools/fixtures/exec_bit_scan.sh)
  live_bsd=$(PATH="$pen/bin:$PATH" read_invoked tools/fixtures/exec_bit_scan.sh)
  plant_gnu=$(read_invoked "$pen/tools/fixtures/planted_exec_bit_scan.sh")
  plant_bsd=$(PATH="$pen/bin:$PATH" read_invoked "$pen/tools/fixtures/planted_exec_bit_scan.sh")

  echo "shell-dialect: a real guard, read on both dialects, and a plant that must still break."
  echo "subject=tools/fixtures/exec_bit_scan.sh:directly_invoked"
  echo "living_gnu=${live_gnu:-none}"
  echo "living_bsd_shaped=${live_bsd:-none}"
  echo "planted_elder_gnu=${plant_gnu:-none}"
  echo "planted_elder_bsd_shaped=${plant_bsd:-none}"
  if [ -z "$live_gnu" ] || [ "$live_gnu" -eq 0 ]; then
    echo "verdict=subject_reads_nothing"
    echo "refused: the subject answered '${live_gnu:-none}' on GNU -- a comparison against zero proves nothing."
    exit 1
  fi
  if [ "$live_bsd" != "$live_gnu" ]; then
    echo "verdict=host_changed_the_reading"
    echo "refused: the subject read $live_gnu on GNU and ${live_bsd:-none} under a BSD-shaped xargs -- a guard measuring its host."
    exit 1
  fi
  # A PLANT THAT READS NOTHING IS NOT A PLANT. A `sed` that missed its line, or a copy left
  # syntactically broken, would answer empty under the shim -- indistinguishable from the zero this
  # leg is looking for, and it would pass. So the plant must first prove it WORKS on GNU, reading
  # exactly what the living subject reads, before its silence under the shim is allowed to mean
  # anything. This is the vacuum the tree already paid for once: five custody bars of the enclosure
  # witness passed for their whole lives on literal quote characters (grain strand, REDS row 59).
  if [ "${plant_gnu:-none}" != "$live_gnu" ]; then
    echo "verdict=plant_is_not_a_working_copy"
    echo "refused: the planted copy read '${plant_gnu:-none}' on GNU where the living subject reads $live_gnu -- its silence under the shim would prove nothing."
    exit 1
  fi
  if [ "${plant_bsd:-0}" -ne 0 ]; then
    echo "verdict=plant_did_not_bite"
    echo "refused: the planted elder spelling still read ${plant_bsd} under the shim -- this leg would pass a broken subject."
    exit 1
  fi
  echo "verdict=ok"
  exit 0
fi
# A COMMENT IS PROSE, NOT A COMMAND. The first site this meter reported was the sentence in
# geode_libraries_scan.sh explaining why that file had just been made portable. Counting it
# tells a writer to delete the explanation of their own repair, which is the test Gauge asks
# of any meter: ask what the number instructs, and whether doing it would help anyone. So a
# line whose first non-blank character is `#` is read past. The limit is named rather than
# hidden: a trailing comment on a line that also carries code is still counted, because that
# line does carry a command and no cheap reading tells the halves apart. The same limit reaches
# PROSE INSIDE A STRING -- an assertion message reading "want the date -d advisory printed" counts
# as a site, which is how the advisory_date_d family first read 10 where the tree holds 9. Telling
# a reader to repair a sentence is the number instructing nobody, so a guard that must name one of
# these families in prose spells it without the flag: "the GNU-only date advisory".
comment_line=':[0-9]+:[[:space:]]*#'
count_family() {
  tr '\n' '\0' < "$roster" | xargs -0 grep -nHE "$1" 2>/dev/null | grep -vE "$comment_line" | grep -c . || true
}

sites=$(count_family "$GATED_RE")
date_sites=$(tr '\n' '\0' < "$roster" | xargs -0 grep -nHE "$DATE_RE" 2>/dev/null \
  | grep -vE "$comment_line" | grep -vE "$DATE_BSD_RE" | grep -c . || true)
files=$(tr "\n" "\0" < "$roster" | xargs -0 grep -nHE "$GATED_RE" 2>/dev/null | grep -vE "$comment_line" | cut -d: -f1 | sort -u | grep -c . || true)

if [ "$mode" = list ]; then
  tr '\n' '\0' < "$roster" | xargs -0 grep -nHE "$GATED_RE" 2>/dev/null | grep -vE "$comment_line" || true
fi

echo "shell-dialect: two piers, one dialect -- a guard that runs on one host measures one host."
echo "gated_family=xargs_arg_file_or_delimiter"
echo "gated_sites=$sites"
echo "gated_files=$files"
echo "gated_ceiling=$CEILING"
echo "gated_date_family=date_parse_or_relative"
echo "gated_date_sites=$date_sites"
echo "gated_date_ceiling=$DATE_CEILING"
echo "roster_symlinks_skipped=$roster_links"

# Advisory, and honest about it: counted this round, gated by nothing. Each is GNU-only, and none
# has yet been proven on metal to have cost this tree a wrong number, so none of them spends a
# ceiling it has not earned.
echo "advisory_grep_perl=$(count_family 'grep[[:space:]]+(-[a-zA-Z0-9]+[[:space:]]+)*-[a-zA-Z]*P([^a-zA-Z]|$)')"
echo "advisory_readlink_f=$(count_family 'readlink[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-[a-zA-Z]*f([^a-zA-Z]|$)')"
echo "advisory_stat_c=$(count_family 'stat[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-c([^a-zA-Z]|$)')"
echo "advisory_sed_i_bare=$(count_family 'sed[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*-i([[:space:]]|$)')"

if [ "$sites" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $sites gated sites against a ceiling of $CEILING -- a ceiling only falls."
  exit 1
fi

if [ "$date_sites" -gt "$DATE_CEILING" ]; then
  echo "verdict=over_date_ceiling"
  echo "refused: $date_sites gated date sites against a ceiling of $DATE_CEILING -- a ceiling only falls."
  exit 1
fi

echo "verdict=ok"
