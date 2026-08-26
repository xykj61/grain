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
#
# WHAT IS GATED, AND WHAT IS ONLY REPORTED. One family is gated: `xargs -a` / `-d` and their long
# forms, because that family is the one proven on metal to zero a shipped page. Four more families
# are counted and printed without gating -- they are GNU-only too, and this round measured them
# rather than claiming them. A number a reader can check beats a ceiling nobody verified.
#
# THE ONE EXCLUSION, named once. This file writes the idiom it counts, inside its own pattern and
# its own prose, so it would report itself forever; it is excluded by path. It is written in POSIX
# shell for the same reason a portability guard must be: one that only runs on one host proves
# nothing about the other.
set -eu

CEILING="${SHELL_DIALECT_CEILING:-12}"
mode="${1:-measure}"

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- this guard reads tracked living sources" >&2
  exit 1
}
cd "$root"

SELF='tools/fixtures/shell_dialect_scan.sh'

# The chain between `xargs` and the flag must be dash-options only, so `xargs grep -d` -- where
# `-d` belongs to grep -- is read past rather than counted. The trailing class rejects `-delimiter`
# spelled as a longer word while accepting `-d'\n'` written with no space.
GATED_RE='xargs[[:space:]]+(-[a-zA-Z0-9]+[[:space:]]+)*(-(a|d)([^a-zA-Z0-9-]|$)|--(arg-file|delimiter|null))'

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
roster="$pen/roster"

git ls-files -- '*.sh' '*.rish' 'tools/hooks/*' | grep -v "^${SELF}\$" > "$roster" || true

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
# A COMMENT IS PROSE, NOT A COMMAND. The first site this meter reported was the sentence in
# geode_libraries_scan.sh explaining why that file had just been made portable. Counting it
# tells a writer to delete the explanation of their own repair, which is the test Gauge asks
# of any meter: ask what the number instructs, and whether doing it would help anyone. So a
# line whose first non-blank character is `#` is read past. The limit is named rather than
# hidden: a trailing comment on a line that also carries code is still counted, because that
# line does carry a command and no cheap reading tells the halves apart.
comment_line=':[0-9]+:[[:space:]]*#'
count_family() {
  tr '\n' '\0' < "$roster" | xargs -0 grep -nHE "$1" 2>/dev/null | grep -vE "$comment_line" | grep -c . || true
}

sites=$(count_family "$GATED_RE")
files=$(tr "\n" "\0" < "$roster" | xargs -0 grep -nHE "$GATED_RE" 2>/dev/null | grep -vE "$comment_line" | cut -d: -f1 | sort -u | grep -c . || true)

if [ "$mode" = list ]; then
  tr '\n' '\0' < "$roster" | xargs -0 grep -nHE "$GATED_RE" 2>/dev/null | grep -vE "$comment_line" || true
fi

echo "shell-dialect: two piers, one dialect -- a guard that runs on one host measures one host."
echo "gated_family=xargs_arg_file_or_delimiter"
echo "gated_sites=$sites"
echo "gated_files=$files"
echo "gated_ceiling=$CEILING"

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

echo "verdict=ok"
