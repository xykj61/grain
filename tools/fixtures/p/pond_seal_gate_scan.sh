#!/usr/bin/env sh
# pond_seal_gate_scan.sh -- every launcher that admits ENCLOSURE=pond reaches the master seal.
#
# WHAT THIS READS. One admission door, tools/e/enclosure_gate.sh, carries the gate: it reads the
# ENCLOSURE selector and admits the value `pond` only after tools/p/pond_exit_bron_master_seal.sh
# --require returns zero, and the launchers enter through it (until 20260829 three launchers each
# carried the same eight-line gate in full, and this scan held the copies in agreement; the door
# is that agreement made structural). That seal is the custody boundary for the season flip -- it demands a
# detached signature verifying against the cold master fingerprint alone, so an agent inside the
# jail cannot open the season by writing a sentinel. This scan discovers the launchers rather than
# listing them, and holds three readings of each.
#
# WHY IT EXISTS. tools/fixtures/p/pond_policy_launcher_scan.sh reads exactly one launcher,
# tools/ag/agent-jail.sh, because that is the one Pond's record describes. The same gate stands in
# tools/cu/cursor-jail.sh and tools/l/launch-zed.sh.example, and until this scan no guard read
# either. A rule written three times is a rule three files may quietly come to disagree about, and
# the disagreement had already begun: two of the three assign a dead EXIT_BRON the seal script sets
# for itself, and the third does not.
#
# WHY DISCOVERY RATHER THAN A ROSTER. REDS %301 and %326 booked the same root twice -- a meter that
# recognizes its subjects by a list of names never reports the one nobody thought to add. So the
# candidate set comes from `git grep` over every tracked file, and a fourth launcher written
# tomorrow is measured on the lap it arrives.
#
# THE READINGS
#   ungated_pond     a file admits `pond` and never reaches the seal with --require  ZERO, ENFORCED
#   unrefused_seal   the seal runs where its exit code is nobody's business          ZERO, ENFORCED
#   unnamed_callers  a caller the seal script's own header does not name             ZERO, ENFORCED
#   selector_sites   files reading the ENCLOSURE selector at all                     reported
#   sealed_gates     files admitting pond behind a refusing --require                reported
#
# A root with no seal, and a root git cannot read, both report `verdict=unreadable` rather than a
# green off an empty roster.
#
# WHY ALL THREE ARE GATES. `ungated_pond` is the escape direction: a launcher that honours `pond`
# without the seal flips the season with no custody, which is exactly custody gate territory.
# `unrefused_seal` is the vacuous-wall direction REDS %311 booked one room over -- there a needle
# the harness itself supplied, here a refusal whose exit code nothing reads; `... --require || true`
# is a gate in shape and an open door in fact. `unnamed_callers` is docs-implementation-sync: the
# seal's header is a claim about who calls it, and on 20260829 it named two of its three callers
# and missed tools/ag/agent-jail.sh, the launcher the standing loop actually runs.
#
# WHAT THIS DOES NOT REACH. Whether the seal itself is sound -- pond_enclosure_scorecard.rish reads
# that. Whether a launcher honours the exit code it reads, which is the shell's own contract.
# Comment stripping is FULL-LINE ONLY: a trailing `# ... pond` after live code would be read as
# code. That is named rather than repaired, because the cures for it (quote-aware parsing) are
# where a reader stops trusting the instrument. Zero tracked files carry that shape today.
#
# THE PER-HOST CONFIG IS OUT OF REACH ON PURPOSE. tools/e/enclosure.conf is gitignored, so git
# never offers it as a candidate. That is right rather than a hole: a config SETS the selector and
# a launcher ADMITS it, and the gate this scan reads lives entirely on the admitting side. A host
# writing ENCLOSURE=pond still meets the seal in whichever launcher it starts.
#
#   sh tools/fixtures/p/pond_seal_gate_scan.sh [--root DIR]
#
# ACCRETE-ONLY. This reads launchers and the seal. It rewrites none of them, and it flips nothing:
# the ENCLOSURE selector stays ai-jail until the switchover round lands behind its audit.
set -eu

# Arguments first, root-discovery second -- the reverse of this room's elder shape, and on purpose:
# a scan copied outside the tree can then still be pointed at a pen, where the elder order exits
# before it reads the flag that would have told it where to look.
ROOT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "pond_seal_gate_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done
if [ -z "$ROOT" ]; then
  # the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
  # outside a repository still resolve -- bounded at 8 steps, loud past the bound.
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _fd_steps=0
  while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
    _fd_steps=$((_fd_steps + 1))
    if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
fi

SEAL_REL="tools/p/pond_exit_bron_master_seal.sh"
SEAL="$ROOT/$SEAL_REL"

echo "pond_seal_gate_scan v1"
echo "seal=$SEAL_REL"

# invariant: the seal is the subject of every reading below, so its absence is unreadable
# rather than green -- a scan that reports zero because it found nothing is the failure this
# whole family exists to refuse.
if [ ! -f "$SEAL" ]; then
  echo "detail: the seal script is absent, so no gate can be read against it"
  echo "verdict=unreadable"
  exit 1
fi

# max_sites bounds the candidate roster. Three launchers carry the gate and one config assigns the
# selector, so four stand today; sixteen leaves a seat per body on the six-body constellation with
# room to spare, and still refuses a generated file that would flood the reading.
max_sites=16

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# THE SELECTOR PATTERN, BOUNDARY-ANCHORED. ENCLOSURE_CONF and ENCLOSURE_SECRETS are different
# variables that every launcher in this tree reads, and a pattern loose on the right would count
# all five files as selector sites. REDS %175 booked exactly this shape one room over, where a
# dated-stamp pattern matched a stamp sitting inside a longer name.
sel_pat='(\$\{?ENCLOSURE([^A-Z0-9_]|$)|^[[:space:]]*ENCLOSURE=)'

cd "$ROOT" || { echo "detail: cannot enter $ROOT"; echo "verdict=unreadable"; exit 1; }

# invariant: git IS the discovery instrument, so a root git cannot read is unreadable rather than
# empty. Caught by this scan's own staging run on 20260829: pointed at a plain directory, `git grep`
# failed, the error was swallowed, and the scan reported verdict=green off zero candidates -- a
# green built on having looked nowhere, which is the failure the seal-absent check one screen up
# was already written to refuse. One hole per instrument is one too many.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "detail: $ROOT is not a git repository, and git is how this scan finds its candidates"
  echo "verdict=unreadable"
  exit 1
fi
git grep -lE "$sel_pat" -- . 2>/dev/null > "$pen/candidates" || true

# strip_comments -- full-line shell comments removed, so a file that only MENTIONS the selector in
# its header drops out. Named as this reading's limit in the header above.
strip_comments() { sed 's/^[[:space:]]*#.*$//' "$1" 2>/dev/null || true; }

: > "$pen/sites"
while IFS= read -r f; do
  [ -n "${f:-}" ] || continue
  [ -f "$f" ] || continue

  # A GUARD'S OWN PLANTED MATERIAL IS NOT A LAUNCHER. This scan's control plants ungated launchers
  # in heredocs, so without this the instrument reds on its own proof. TWO conditions rather than
  # one, the discipline the QA report card seats for its index reading: the file lives in the
  # fixtures room AND is named as a guard instrument. A self-declared exemption is a door, and a
  # door beside a wall makes the wall a habit -- so a launcher would have to be both filed as a
  # fixture and named as a scan or control to slip past, and at that point nobody runs it.
  case "$f" in
    tools/fixtures/*_scan.sh|tools/fixtures/*_control.sh) continue ;;
  esac

  strip_comments "$f" > "$pen/body"
  grep -qE "$sel_pat" "$pen/body" || continue
  printf '%s\n' "$f" >> "$pen/sites"
done < "$pen/candidates"

site_count=$(grep -c . "$pen/sites" 2>/dev/null || true)
[ -n "$site_count" ] || site_count=0
echo "selector_sites=$site_count"
echo "max_sites=$max_sites"

if [ "$site_count" -gt "$max_sites" ]; then
  echo "detail: the selector roster exceeds max_sites $max_sites"
  echo "verdict=unbounded"
  exit 1
fi

# The seal's own header -- the comment block at the top of the file, which is where it names the
# launchers that share it. Read as a claim, the way docs-implementation-sync asks.
awk '/^#/{print; next} {exit}' "$SEAL" > "$pen/seal_header"

ungated_pond=0
unrefused_seal=0
unnamed_callers=0
sealed_gates=0
pond_admitting=0

while IFS= read -r f; do
  [ -n "${f:-}" ] || continue
  strip_comments "$f" > "$pen/body"

  # ADMITS POND, in the two spellings a shell writes: an equality test against the selector, or a
  # case branch labelled pond under a case that switches on it.
  admits=no
  if grep -qE '\$\{?ENCLOSURE\}?"?[[:space:]]*=[[:space:]]*"?pond' "$pen/body"; then
    admits=yes
  elif grep -qE 'case[[:space:]]+"?\$\{?ENCLOSURE' "$pen/body" \
    && grep -qE '^[[:space:]]*"?pond"?\)' "$pen/body"; then
    admits=yes
  fi
  [ "$admits" = yes ] || continue
  pond_admitting=$((pond_admitting + 1))

  # REACHES THE SEAL -- the seal script named and --require spelled on one line, so a call that
  # asks for the weaker --policy mode is read as what it is: a check of the keyring rather than of
  # the signature.
  seal_line=$(grep -nE "pond_exit_bron_master_seal[^ ]*.*--require" "$pen/body" | head -1 || true)
  if [ -z "$seal_line" ]; then
    ungated_pond=$((ungated_pond + 1))
    if grep -qE "pond_exit_bron_master_seal" "$pen/body"; then
      weak=$(grep -oE -- "--[a-z-]+" "$pen/body" | grep -E -- '--(policy|season-closed)' | head -1 || true)
      echo "detail: $f admits pond and reaches the seal as ${weak:-a weaker mode} rather than --require"
    else
      echo "detail: $f admits pond and never reaches $SEAL_REL -- the season flips with no custody"
    fi
    continue
  fi

  # REFUSES ON THE SEAL -- the exit code is read. Three spellings are accepted by name, and a
  # fourth reds so a hand reads it rather than a pattern guessing at it.
  seal_text=${seal_line#*:}
  if printf '%s' "$seal_text" | grep -qE '(^|[[:space:]])if[[:space:]]+!' \
    || printf '%s' "$seal_text" | grep -qE '\|\|[[:space:]]*(exit|return)'; then
    sealed_gates=$((sealed_gates + 1))
  else
    unrefused_seal=$((unrefused_seal + 1))
    echo "detail: $f runs the seal where nothing reads its exit code -- ${seal_text}"
  fi

  # NAMED BY THE SEAL'S HEADER. A tracked `.example` is the source of the per-host runnable copy,
  # so the header naming tools/l/launch-zed.sh covers tools/l/launch-zed.sh.example.
  bare=${f%.example}
  if grep -qF "$f" "$pen/seal_header" || grep -qF "$bare" "$pen/seal_header"; then
    :
  else
    unnamed_callers=$((unnamed_callers + 1))
    echo "detail: $f calls the seal and $SEAL_REL's own header does not name it"
  fi
done < "$pen/sites"

echo "pond_admitting=$pond_admitting"
echo "sealed_gates=$sealed_gates"
echo "ungated_pond=$ungated_pond"
echo "unrefused_seal=$unrefused_seal"
echo "unnamed_callers=$unnamed_callers"

if [ "$ungated_pond" -ne 0 ]; then
  echo "verdict=ungated_pond"
  exit 1
fi
if [ "$unrefused_seal" -ne 0 ]; then
  echo "verdict=unrefused_seal"
  exit 1
fi
if [ "$unnamed_callers" -ne 0 ]; then
  echo "verdict=unnamed_caller"
  exit 1
fi

echo "verdict=green"
