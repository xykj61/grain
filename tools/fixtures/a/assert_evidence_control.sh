#!/bin/sh
# tools/fixtures/a/assert_evidence_control.sh -- prove the assert-evidence reading by doing.
#
# WHY. A guard that cannot red guards nothing (REDS %59). This control builds real git repositories
# in a throwaway pen, plants one Rishi assertion shape in each, runs
# tools/fixtures/a/assert_evidence_scan.sh inside them, and checks that each classification lands
# where it belongs. Nothing here touches the tree it is run from.
#
# THE PLANT LIVES ONLY IN THE PEN. The scan reads every tracked `*.rish` source, so a planted
# assertion written into tracked bytes would enter the live reading and move the very number the
# scan gates (`%785`, the guard whose ceiling was a quarter composed of its own proof). Every plant
# below is written into a pen repository at run time by a heredoc.
#
# THIS FILE IS NOT IN THE POPULATION, and that is proven rather than asserted. It is a `*.sh`, so
# the scan cannot read it however many assertion shapes its heredocs carry -- which the leg named
# `control_outside_population` reads out of the live scan rather than out of this sentence.
#
# THE CEILING IS PROVEN FROM BOTH SIDES WITH NO OVERRIDE IN THE SHIPPED INSTRUMENT. A pen copy of
# the scan is rewritten with `sed` to carry a small ceiling, so the live scan holds no environment
# variable, flag, or comment that lowers its own wall.
#
# USAGE
#   sh tools/fixtures/a/assert_evidence_control.sh
#
# Driven by tools/a/assert_evidence_witness.rish. Run from the repository root.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
cd "$_fd_root" || exit 2

scan=$_fd_root/tools/fixtures/a/assert_evidence_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT HUP TERM

legs=0
fails=0
leg() {
  name=$1; got=$2; want=$3
  legs=$((legs + 1))
  if [ "$got" = "$want" ]; then
    echo "$name=yes"
  else
    echo "$name=no got=$got want=$want"
    fails=$((fails + 1))
  fi
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2; exit }'; }

# build <name> [<scan source>] -- a pen repository carrying the scan under test at its real path,
# with the tracked sentinels the scan's own root-finder needs.
build() {
  d=$pen/$1
  src=${2:-$scan}
  mkdir -p "$d/tools/fixtures/a" "$d/tools/fixtures/s" "$d/rishi/src"
  cp "$src" "$d/tools/fixtures/a/assert_evidence_scan.sh"
  cp "$_fd_root/tools/fixtures/s/shell_portable.sh" "$d/tools/fixtures/s/shell_portable.sh"
  printf '# pen\nA real document so no pen is merely empty.\n' > "$d/README.md"
  printf 'const std = @import("std");\n' > "$d/rishi/src/main.rye"
  ( cd "$d" && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen ) >/dev/null 2>&1
  echo "$d"
}

# plant <dir> <relative path> -- a Rishi source whose body arrives on this call's stdin.
plant() {
  mkdir -p "$1/$(dirname "$2")"
  cat > "$1/$2"
}

commit_and_read() {
  ( cd "$1" && git add -A >/dev/null 2>&1 \
    && git commit -qm 'pen: one planted assertion' >/dev/null 2>&1
    sh tools/fixtures/a/assert_evidence_scan.sh ${2:-} 2>/dev/null )
}

# ---------------------------------------------------------------------------
# THE FIVE CLASSES, each planted alone so no leg can borrow another's evidence.
# ---------------------------------------------------------------------------

d=$(build classes)
plant "$d" tools/p/pen_classes_witness.rish <<'RISH'
let names = run ["true"]
assert names.ok else "the build refused -- ${names.err_brief}"
let field = run ["true"]
assert field.ok else "the build refused -- ${field.out_brief}"
let path = run ["true"]
let outfile = "pen.out"
assert path.ok else "the build refused -- see ${outfile}"
let said = run ["true"]
say "the build said ${said.err_brief}"
assert said.ok else "the build refused"
let quiet = run ["true"]
assert quiet.ok else "the build refused"
RISH
out=$(commit_and_read "$d")
leg classes_asserts      "$(echo "$out" | read_key asserts)"       5
leg classes_names_err    "$(echo "$out" | read_key names_err)"     1
leg classes_names_field  "$(echo "$out" | read_key names_field)"   1
leg classes_names_path   "$(echo "$out" | read_key names_path)"    1
leg classes_said_above   "$(echo "$out" | read_key said_above)"    1
leg classes_mute         "$(echo "$out" | read_key mute_asserts)"  1

# `err` unabbreviated is the same cure as `err_brief`, and the whole-capture form is what a witness
# reaches for when the bounded head would cut the reason off.
d=$(build plain_err)
plant "$d" tools/p/pen_plain_witness.rish <<'RISH'
let b = run ["true"]
assert b.ok else "refused -- ${b.err}"
RISH
out=$(commit_and_read "$d")
leg plain_err_counts "$(echo "$out" | read_key names_err)" 1
leg plain_err_mute   "$(echo "$out" | read_key mute_asserts)" 0

# A message naming ANOTHER record's err is not this assertion's evidence. It reads as `names_path`,
# which is the honest answer -- something is interpolated, and it is no field of this record.
d=$(build wrong_record)
plant "$d" tools/p/pen_wrong_witness.rish <<'RISH'
let a = run ["true"]
let b = run ["true"]
assert b.ok else "refused -- ${a.err_brief}"
RISH
out=$(commit_and_read "$d")
leg wrong_record_not_err "$(echo "$out" | read_key names_err)" 0
leg wrong_record_path    "$(echo "$out" | read_key names_path)" 1

# ---------------------------------------------------------------------------
# THE SAY LOOKBACK, from both sides of its own window.
# ---------------------------------------------------------------------------

d=$(build say_window)
plant "$d" tools/p/pen_say_witness.rish <<'RISH'
let near = run ["true"]
say "reason ${near.err_brief}"
assert near.ok else "refused"
let far = run ["true"]
say "reason ${far.err_brief}"
say "one"
say "two"
say "three"
say "four"
say "five"
say "six"
assert far.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg say_window_said "$(echo "$out" | read_key said_above)"   1
leg say_window_mute "$(echo "$out" | read_key mute_asserts)" 1

# A `say` naming a DIFFERENT record does not rescue this one.
d=$(build say_other)
plant "$d" tools/p/pen_sayother_witness.rish <<'RISH'
let a = run ["true"]
let b = run ["true"]
say "reason ${a.err_brief}"
assert b.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg say_other_mute "$(echo "$out" | read_key mute_asserts)" 1
leg say_other_said "$(echo "$out" | read_key said_above)"   0

# ---------------------------------------------------------------------------
# THE BINDING READING -- which records can take the cure at all.
# ---------------------------------------------------------------------------

d=$(build bindings)
plant "$d" tools/p/pen_bind_witness.rish <<'RISH'
let direct = run ["true"]
assert direct.ok else "refused"
let waited = wait-for handle
assert waited.ok else "refused"
let bounded = run-bounded { argv: ["/bin/cat"], stdin: "", stdin-max: 0, stdout-path: "a.out", stdout-max: 8, stderr-path: "a.err", stderr-max: 8 }
assert bounded.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg bind_run_shaped  "$(echo "$out" | read_key cure_unwritable)" 1
leg bind_path_shaped "$(echo "$out" | read_key bind_path)"       1
leg bind_none_unseen "$(echo "$out" | read_key bind_unseen)"     0

# A locally defined function is followed one level. Without the trace both of these read `unseen`
# and the scan would claim the cure is unwritable where it is writable today.
d=$(build fn_trace)
plant "$d" tools/p/pen_fn_witness.rish <<'RISH'
fn git-run tail: run (git_argv + tail)
fn write-phase value: run-bounded { argv: ["/usr/bin/printf"], stdin: "", stdin-max: 0, stdout-path: "p.out", stdout-max: 8, stderr-path: "p.err", stderr-max: 8 }
let g = git-run ["status"]
assert g.ok else "refused"
let w = write-phase "phase"
assert w.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg fn_trace_run    "$(echo "$out" | read_key cure_unwritable)" 1
leg fn_trace_path   "$(echo "$out" | read_key bind_path)"       1
leg fn_trace_unseen "$(echo "$out" | read_key bind_unseen)"     0

# `run-bounded` is asked before `run`, or its own name would answer the `run` test.
d=$(build bounded_first)
plant "$d" tools/p/pen_bounded_witness.rish <<'RISH'
let b = run-bounded { argv: ["/bin/cat"], stdin: "", stdin-max: 0, stdout-path: "a.out", stdout-max: 8, stderr-path: "a.err", stderr-max: 8 }
assert b.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg bounded_not_run "$(echo "$out" | read_key bind_path)" 1

# A binding opening on a conditional rather than on a verb reads `unseen`, which is the reading
# saying less rather than claiming more.
d=$(build conditional_bind)
plant "$d" tools/p/pen_cond_witness.rish <<'RISH'
fn write-phase value: run-bounded { argv: ["/usr/bin/printf"], stdin: "", stdin-max: 0, stdout-path: "p.out", stdout-max: 8, stderr-path: "p.err", stderr-max: 8 }
let c = ?: flag (write-phase "phase") ({ok: true, overflow: ""})
assert c.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg conditional_unseen "$(echo "$out" | read_key bind_unseen)" 1

# ---------------------------------------------------------------------------
# WHAT THE READING DECLINES, each planted and then lifted.
# ---------------------------------------------------------------------------

# A `.sh` source carrying the characters is not read, which is the whole reason this control can
# exist in the tree at all.
d=$(build shell_declined)
plant "$d" tools/p/pen_shell_plant.sh <<'SH'
#!/bin/sh
# assert quiet.ok else "refused"
SH
out=$(commit_and_read "$d")
leg shell_declined "$(echo "$out" | read_key asserts)" 0
plant "$d" tools/p/pen_shell_plant.rish <<'RISH'
let quiet = run ["true"]
assert quiet.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg shell_lifted "$(echo "$out" | read_key mute_asserts)" 1

# An untracked Rishi source is not read either: the population is `git ls-files`.
d=$(build untracked)
plant "$d" tools/p/pen_tracked.rish <<'RISH'
let a = run ["true"]
assert a.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg untracked_before "$(echo "$out" | read_key mute_asserts)" 1
plant "$d" tools/p/pen_untracked.rish <<'RISH'
let b = run ["true"]
assert b.ok else "refused"
RISH
out=$( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh 2>/dev/null )
leg untracked_unread "$(echo "$out" | read_key mute_asserts)" 1

# An assertion with no `else` message carries nothing to classify.
d=$(build no_else)
plant "$d" tools/p/pen_noelse.rish <<'RISH'
let a = run ["true"]
assert a.ok
RISH
out=$(commit_and_read "$d")
leg no_else_unread "$(echo "$out" | read_key asserts)" 0

# An assertion on a field that is not `ok` is another question and is left to it.
d=$(build other_field)
plant "$d" tools/p/pen_other.rish <<'RISH'
let a = run ["true"]
assert a.code == 0 else "refused"
RISH
out=$(commit_and_read "$d")
leg other_field_unread "$(echo "$out" | read_key asserts)" 0

# ---------------------------------------------------------------------------
# THE CEILING, from both sides, on a pen copy carrying a small one.
# ---------------------------------------------------------------------------

small=$pen/small_ceiling_scan.sh
sed 's/^CEILING=[0-9]*$/CEILING=1/' "$scan" > "$small"
chmod +x "$small"

d=$(build ceiling_at "$small")
plant "$d" tools/p/pen_at.rish <<'RISH'
let a = run ["true"]
assert a.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg ceiling_at_holds   "$(echo "$out" | read_key mute_asserts)" 1
leg ceiling_at_verdict "$(echo "$out" | read_key verdict)"      within

d=$(build ceiling_over "$small")
plant "$d" tools/p/pen_over.rish <<'RISH'
let a = run ["true"]
assert a.ok else "refused"
let b = run ["true"]
assert b.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg ceiling_over_holds   "$(echo "$out" | read_key mute_asserts)" 2
leg ceiling_over_verdict "$(echo "$out" | read_key verdict)"      over
( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh >/dev/null 2>&1 )
leg ceiling_over_exit "$?" 1

# ---------------------------------------------------------------------------
# THE MODES AND THE REFUSALS.
# ---------------------------------------------------------------------------

d=$(build modes)
plant "$d" tools/p/pen_modes.rish <<'RISH'
let a = run ["true"]
assert a.ok else "refused"
let b = run ["true"]
assert b.ok else "refused -- ${b.err_brief}"
RISH
out=$(commit_and_read "$d" --list)
leg list_names_mute_only "$(echo "$out" | grep -c 'pen_modes.rish:2')" 1
leg list_omits_cured     "$(echo "$out" | grep -c 'pen_modes.rish:4')" 0

out=$(commit_and_read "$d" --classes)
leg classes_names_both "$(echo "$out" | grep -c 'pen_modes.rish:')" 2

out=$( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh --explain tools/p/pen_modes.rish 2>/dev/null )
leg explain_names_target "$(echo "$out" | read_key explain)"      tools/p/pen_modes.rish
leg explain_counts_here  "$(echo "$out" | read_key asserts_here)" 2
leg explain_verdict      "$(echo "$out" | read_key verdict)"      explained

( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh --explain tools/p/absent.rish >/dev/null 2>&1 )
leg explain_absent_refuses "$?" 2
( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh --explain >/dev/null 2>&1 )
leg explain_bare_refuses "$?" 2
( cd "$d" && sh tools/fixtures/a/assert_evidence_scan.sh --nonsense >/dev/null 2>&1 )
leg unknown_argument_refuses "$?" 2

# An empty pen answers zero rather than failing, and answers it about the pen.
d=$(build empty_pen)
out=$(commit_and_read "$d")
leg empty_pen_zero    "$(echo "$out" | read_key asserts)"      0
leg empty_pen_verdict "$(echo "$out" | read_key verdict)"      within

# ---------------------------------------------------------------------------
# MUTATIONS -- each removes one clause of the scan and must change a reading.
# ---------------------------------------------------------------------------

d=$(build mutant_base)
plant "$d" tools/p/pen_mut.rish <<'RISH'
let a = run ["true"]
assert a.ok else "refused -- ${a.err_brief}"
let b = run-bounded { argv: ["/bin/cat"], stdin: "", stdin-max: 0, stdout-path: "o", stdout-max: 8, stderr-path: "e", stderr-max: 8 }
assert b.ok else "refused"
say "reason ${c.err_brief}"
RISH
plant "$d" tools/p/pen_mut2.rish <<'RISH'
let c = run ["true"]
say "reason ${c.err_brief}"
assert c.ok else "refused"
RISH
out=$(commit_and_read "$d")
leg mutant_base_err   "$(echo "$out" | read_key names_err)"      1
leg mutant_base_path  "$(echo "$out" | read_key bind_path)"      1
leg mutant_base_said  "$(echo "$out" | read_key said_above)"     1

# Mutation 1 -- drop the `err_brief` arm from the cure test. The cured site falls to mute.
mut=$pen/mut_errbrief.sh
sed 's/index(m, "${" v ".err_brief}")/0/' "$scan" > "$mut"
m=$(build mutant_errbrief "$mut")
cp "$d/tools/p/pen_mut.rish" "$m/tools/p/pen_mut.rish" 2>/dev/null || { mkdir -p "$m/tools/p"; cp "$d/tools/p/pen_mut.rish" "$m/tools/p/pen_mut.rish"; }
out=$(commit_and_read "$m")
leg mutation_errbrief_bites "$(echo "$out" | read_key names_err)" 0

# Mutation 2 -- ask the `run` test before the `run-bounded` test. The path-shaped record is then
# claimed as run-shaped and `bind_path` empties.
mut=$pen/mut_order.sh
sed 's|if (b ~ /run-bounded\[ \\t\]\*\[\\\[{(\]/) return "path"|if (0) return "path"|' "$scan" > "$mut"
if ! cmp -s "$mut" "$scan"; then
  m=$(build mutant_order "$mut")
  mkdir -p "$m/tools/p"; cp "$d/tools/p/pen_mut.rish" "$m/tools/p/pen_mut.rish"
  out=$(commit_and_read "$m")
  leg mutation_order_bites "$(echo "$out" | read_key bind_path)" 0
else
  leg mutation_order_bites unpatched patched
fi

# Mutation 3 -- widen the `say` lookback past its window. The far `say` then rescues an assertion
# it never printed a reason for.
mut=$pen/mut_window.sh
sed 's/j >= n - 6/j >= n - 60/' "$scan" > "$mut"
m=$(build mutant_window "$mut")
plant "$m" tools/p/pen_far.rish <<'RISH'
let far = run ["true"]
say "reason ${far.err_brief}"
say "one"
say "two"
say "three"
say "four"
say "five"
say "six"
assert far.ok else "refused"
RISH
out=$(commit_and_read "$m")
leg mutation_window_bites "$(echo "$out" | read_key said_above)" 1

# Mutation 4 -- drop the `say` shape test, so any earlier line naming the record rescues it. The
# binding line itself then counts, and no mute assertion survives.
mut=$pen/mut_sayshape.sh
sed 's|line\[j\] ~ /\^\[\[:space:\]\]\*say/|1|' "$scan" > "$mut"
if ! cmp -s "$mut" "$scan"; then
  m=$(build mutant_sayshape "$mut")
  plant "$m" tools/p/pen_shape.rish <<'RISH'
let q = run ["true"]
let note = "the reason will be ${q.err_brief}"
assert q.ok else "refused"
RISH
  out=$(commit_and_read "$m")
  leg mutation_sayshape_bites "$(echo "$out" | read_key mute_asserts)" 0
else
  leg mutation_sayshape_bites unpatched patched
fi

# ---------------------------------------------------------------------------
# THE CURE SPEAKS -- the one leg that runs the two forms rather than reading them.
#
# Every leg above proves the reading. This proves the SUBJECT: that a mute refusal and a cured one
# actually differ in what an operator sees. The two scripts below are REDS %734's own case, the
# stderr text taken from the ten failures that carried their reason. The interpreter is needed for
# this pair, and it lives under `rishi/bin`, which holds nothing tracked -- so its absence is
# reported as its own failing leg rather than passing in silence (REDS %788).
# ---------------------------------------------------------------------------

rishi_bin=$_fd_root/rishi/bin/rishi
if [ -x "$rishi_bin" ]; then
  say_pen=$pen/speak
  mkdir -p "$say_pen"
  cat > "$say_pen/mute.rish" <<'RISH'
let build = run ["sh" "-c" "echo 'unable to load pan.zig' >&2; exit 1"]
assert build.ok else "Lattice build failed"
RISH
  cat > "$say_pen/cured.rish" <<'RISH'
let build = run ["sh" "-c" "echo 'unable to load pan.zig' >&2; exit 1"]
assert build.ok else "Lattice build failed -- ${build.err_brief}"
RISH
  mute_said=$( cd "$_fd_root" && "$rishi_bin" run "$say_pen/mute.rish" 2>&1 | head -1 )
  cured_said=$( cd "$_fd_root" && "$rishi_bin" run "$say_pen/cured.rish" 2>&1 | head -1 )
  leg cure_speaks_mute_is_silent \
    "$(printf '%s' "$mute_said" | grep -c 'pan.zig' || true)" 0
  leg cure_speaks_cured_carries \
    "$(printf '%s' "$cured_said" | grep -c 'pan.zig' || true)" 1
  leg cure_speaks_keeps_the_words \
    "$(printf '%s' "$cured_said" | grep -c 'Lattice build failed' || true)" 1
  ( cd "$_fd_root" && "$rishi_bin" run "$say_pen/cured.rish" >/dev/null 2>&1 )
  leg cure_speaks_still_refuses "$?" 1
else
  leg cure_speaks_mute_is_silent    unbuilt 0
  leg cure_speaks_cured_carries     unbuilt 1
  leg cure_speaks_keeps_the_words   unbuilt 1
  leg cure_speaks_still_refuses     unbuilt 1
fi

# ---------------------------------------------------------------------------
# THIS CONTROL IS OUTSIDE THE LIVE POPULATION, read rather than asserted.
# ---------------------------------------------------------------------------

live=$(sh "$scan" 2>/dev/null | read_key asserts)
mine=$(sh "$scan" --classes 2>/dev/null | grep -c 'assert_evidence_control.sh' || true)
leg control_outside_population "$mine" 0
leg live_population_read "$([ "${live:-0}" -gt 0 ] && echo yes || echo no)" yes

echo "control_legs=$legs"
echo "control_failed=$fails"
if [ "$fails" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=failed"
exit 1
