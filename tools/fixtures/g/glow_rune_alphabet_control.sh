#!/bin/sh
# glow_rune_alphabet_control.sh -- the rune gate proven able to red, on a throwaway checkout.
#
#   sh tools/fixtures/g/glow_rune_alphabet_control.sh
#
# WHY THIS FIXTURE EXISTS. `tools/g/glow_rune_alphabet_witness.rish` was rostered on
# `20260909.155028` after the fault it watches walked straight past it, and it arrived asserting on
# a delegate's result with no refusal of its own on disk. `standing_equipment_redleg` reads exactly
# that population and held it at 53; this guard made it 54 and the cold endurance run refused
# `ceiling_raised` on every ship. The aether row states the standard the repair answers: a witness
# must be proven able to make a sound before its silence means anything.
#
# THE SUBJECT IS A REPOSITORY, so the pen is one. `tools/g/glow_rune_alphabet_worker.sh` resolves
# its own root from `$0` and then reads five tracked files, so a plant has to land in a whole
# checkout rather than in a copied file. `git worktree add --detach` gives that in about a second
# and is removed whole on every exit path. THE WORKER UNDER TEST IS THE ONE ON DISK: the pen holds
# HEAD's copy, so a worker being repaired would otherwise be proven in its elder form -- the same
# lesson `tools/c/convergence_tree_prove.sh` wrote down at `20260909.170804`.
#
# FOUR PLANTS, FOUR DISTINCT REFUSALS, and the ORDER of the worker's own checks is what keeps them
# distinct. The digraph count is read first, so any plant that changes the population size reads as
# a count fault whatever else it did. Each plant below therefore keeps the count at thirty and
# differs only in WHICH head moved:
#
#   count    -- one pair deleted. Reads `expected 30 digraphs, got 29`.
#   unnamed  -- an exempt head swapped for a novel one. The count holds and `+@` can be pronounced
#               by nothing, which is the case the worker's own comment records a bare ceiling of two
#               passing in silence.
#   elder    -- a spoken head swapped away. The count holds and `lusbuc` keeps a pronunciation row
#               with no lexer head, which is the direction the elder roll was written for.
#   barket   -- `|^` swapped away. The count holds and the STOA111 head no longer tokenizes.
#
# EVERY PLANT IS LIFTED AND READ BACK. A refusal shown only in the failing direction cannot be told
# from a tool that refuses everything, so each case ends by restoring the file and requiring `OK`.
#
# Prints `pass=N fail=N`. Bounded: one pen, four plants, at most nine worker runs.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
worker_real="$root/tools/g/glow_rune_alphabet_worker.sh"
[ -f "$worker_real" ] || { echo "refused: no worker at $worker_real" >&2; exit 2; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/rune-pen.XXXXXX")
rmdir "$pen"
cleanup() { git -C "$root" worktree remove --force "$pen" >/dev/null 2>&1 || rm -rf "$pen"; }
trap cleanup EXIT INT TERM

git -C "$root" worktree add --detach "$pen" HEAD >/dev/null 2>&1 \
  || { echo "refused: could not make a pen checkout" >&2; exit 2; }

# `cat >` writes through the checkout's own inode, so the mode git tracks survives the copy
# (`.claude/rules/exec-bit.md`).
#
# THE WHOLE SUBJECT COMES FROM THE WORKING TREE, not the worker alone (`20260911.202958`). The pen
# is HEAD, and a lap repairing one of the documents the worker binds would otherwise be proven
# against the elder copy: the widened worker met HEAD's reference page, which did not yet teach
# `|+`, and eighteen checks failed for a fault the working tree had already repaired. Copying only
# the worker made the pen half-current, which is worse than either whole, so every file the worker
# reads is copied beside it.
for rel in \
  tools/g/glow_rune_alphabet_worker.sh \
  glow/tokens.rye \
  context/TAME_GUIDANCE.md \
  active-designing/docs/glow/runes.md \
  active-designing/date/20260719/20260719-220814_glow-rune-pronunciation-closed-table.md \
  active-designing/date/20260720/20260720-033852_glow-bartis-g1-row.md \
  active-designing/date/20260720/20260720-151119_glow-barket-g1-row.md \
  active-designing/20260822-221639_glow-barlus-g1-row.md
do
  [ -f "$root/$rel" ] || { echo "refused: the working tree holds no $rel" >&2; exit 2; }
  cat "$root/$rel" > "$pen/$rel"
done

tokens="$pen/glow/tokens.rye"
[ -f "$tokens" ] || { echo "refused: the pen holds no glow/tokens.rye -- nothing to plant in" >&2; exit 2; }
pristine="$pen/.pristine-tokens"
cat "$tokens" > "$pristine"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

run_worker() { ( cd "$pen" && sh tools/g/glow_rune_alphabet_worker.sh 2>&1 ); }
lift() { cat "$pristine" > "$tokens"; }
# The portable in-place form this tree prescribes: write a temporary, cat it back (`shell_dialect`
# gates `sed -i` at zero, since GNU and BSD spell it differently).
plant() { sed "$1" "$tokens" > "$tokens.tmp" && cat "$tokens.tmp" > "$tokens" && rm -f "$tokens.tmp"; }

# THE BASELINE. A pen that cannot pass proves nothing about the plants that follow, and the three
# published fields are what two peer witnesses bind by name (REDS %283).
base=$(run_worker) && base_ok=yes || base_ok=no
check "clean pen passes" yes "$base_ok"
check "clean pen says OK" yes "$(has "$base" "OK")"
check "clean pen publishes rune_heads" yes "$(has "$base" "rune_heads=")"
check "clean pen publishes lexer_heads" yes "$(has "$base" "lexer_heads=")"
check "clean pen publishes unnamed_glyphs" yes "$(has "$base" "unnamed_glyphs=")"

# Each case: plant, require a refusal naming its own fault, lift, require the pass back.
case_run() {
  label=$1; expr=$2; want=$3
  lift
  plant "$expr"
  out=$(run_worker) && refused=no || refused=yes
  check "$label refuses" yes "$refused"
  check "$label names its fault" yes "$(has "$out" "$want")"
  lift
  back=$(run_worker) && back_ok=yes || back_ok=no
  check "$label lifted reads OK" yes "$back_ok"
}

case_run "count"   's/"+\$",//'      "expected 30 digraphs"
case_run "unnamed" 's/"?&"/"+@"/'    "lexer head +@ carries no pronunciation row"
case_run "elder"   's/"+\$"/"?!"/'   "tokens missing +\$"
case_run "barket"  's/"|\^"/"|~"/'   "barket must tokenize"

# THE WORKER REFUSES OVER DOCUMENTS TOO, and the four plants above reach none of them. Past its
# roll, the worker binds the closed pronunciation table and the TAME_GUIDANCE pin -- the table must
# still name the witness that watches it and still claim the **25** it was sealed at, and the family
# index must still carry every spoken name. Those are the bindings that carry the language's own
# vocabulary, they are edited by hands rather than by the lexer, and a refusal nobody plants is a
# refusal nobody has seen. Added `20260909.194500` beside the four above rather than instead of
# them: a second lap reached this guard the same evening and had these three cases and not the pen,
# so the pen is the peer's and the documents are the accretion.
#
# The plant is by file, since these live outside `glow/tokens.rye`, and each keeps its own pristine
# copy so a lift restores exactly what the worktree checked out.
doc_plant() {
  f="$pen/$1"
  [ -f "$f" ] || { echo "refused: the pen holds no $1 -- nothing to plant in" >&2; exit 2; }
  [ -f "$f.pristine" ] || cat "$f" > "$f.pristine"
  sed "$2" "$f" > "$f.tmp" && cat "$f.tmp" > "$f" && rm -f "$f.tmp"
}
doc_lift() { f="$pen/$1"; cat "$f.pristine" > "$f"; }

doc_case() {
  label=$1; rel=$2; expr=$3; want=$4
  doc_plant "$rel" "$expr"
  out=$(run_worker) && refused=no || refused=yes
  check "$label refuses" yes "$refused"
  check "$label names its fault" yes "$(has "$out" "$want")"
  doc_lift "$rel"
  back=$(run_worker) && back_ok=yes || back_ok=no
  check "$label lifted reads OK" yes "$back_ok"
}

table=active-designing/date/20260719/20260719-220814_glow-rune-pronunciation-closed-table.md
tame=context/TAME_GUIDANCE.md

# A `g` flag on every one, because each of these words stands on many lines of its page and a
# first-occurrence substitution leaves the grep the worker runs perfectly satisfied.
doc_case "table_witness" "$table" 's/glow_rune_alphabet_witness\.rish/glow_rune_alphabet_absent.rish/g' "table must name witness"
doc_case "table_seal"    "$table" 's/\*\*25\*\*/**24**/g'                                              "closed table must still claim"
doc_case "tame_index"    "$tame"  's/barket/barkat/g'                                                    "TAME family index missing barket"

# THE FOURTH BINDING, PLANTED FROM BOTH SIDES (`20260911.202958`). The worker now walks the lexer's
# own heads against `active-designing/docs/glow/runes.md`, the page a beginner and an LLM read
# first, and that binding arrived because a rune had already walked past every other one: `|+`
# barlus, named `20260822` and folded by seven gate sources, was taught on no page of the Book.
# A binding proven only by the tree passing today cannot be told from a binding nobody reads.
book=active-designing/docs/glow/runes.md

# One taught head vanishes from the page while the lexer keeps it. `|~` is no lexer head, so the
# substitution removes `|-` from the reference and adds nothing the other readings would notice.
doc_case "book_head" "$book" 's/`|-`/`|~`/g' "lexer head |- is taught nowhere in the rune reference"

# THE PAGE ITSELF GONE, which is the one fault a substitution can never plant. A missing binding is
# the shape that reads as agreement from every side: no page, no unnamed head, no refusal.
mv "$pen/$book" "$pen/$book.aside"
out=$(run_worker) && refused=no || refused=yes
check "book_absent refuses" yes "$refused"
check "book_absent names its fault" yes "$(has "$out" "the rune reference is missing")"
mv "$pen/$book.aside" "$pen/$book"
back=$(run_worker) && back_ok=yes || back_ok=no
check "book_absent lifted reads OK" yes "$back_ok"

echo "coverage: a clean pen, the published fields, four plants in the lexer table -- count, an unnamed head that keeps the count, a pronunciation row whose head has gone, and the barket head -- and five in the documents the worker binds: the table's own witness name, its sealed count, the family index, a taught rune struck from the reference, and the reference itself gone. Each refused and each lifted back to OK"
echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
