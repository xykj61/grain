#!/bin/sh
# tools/fixtures/exec_bit_control.sh -- prove the exec-bit reading by doing, on real repositories.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). This control builds git repositories
# in a temporary pen, plants one condition in each, runs tools/fixtures/exec_bit_scan.sh inside
# them, and checks that the refusals bite and the honest readings stay free. Nothing here touches
# the tree it is run from.
#
# USAGE
#   sh tools/fixtures/exec_bit_control.sh
#
# Driven by tools/exec_bit_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/exec_bit_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A repository with one caller and one script, both tracked. `mode` sets the script's index mode
# and `caller` is the line the caller carries.
build() {
  name=$1; mode=$2; caller=$3
  d=$pen/$name
  mkdir -p "$d"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && mkdir -p tools \
    && printf '#!/bin/sh\necho ran\n' > tools/thing.sh \
    && chmod "$mode" tools/thing.sh \
    && printf '# runner\n%s\n' "$caller" > RUN.md \
    && git add -A \
    && git commit -qm 'pen: one caller and one script' ) >/dev/null 2>&1
  echo "$d"
}

verdict_of() { ( cd "$1" && sh "$scan" 2>/dev/null; ) }

# 1. The agreeing tree -- invoked directly, and executable. Free, and reading zero.
d=$(build agreeing 755 './tools/thing.sh')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && echo "agreeing_free=yes" || echo "agreeing_free=no"
echo "$out" | grep -q 'directly_invoked_not_exec=0' && echo "clean_reads_zero=yes" || echo "clean_reads_zero=no"
echo "$out" | grep -q 'directly_invoked=1' && echo "invoked_seen=yes" || echo "invoked_seen=no"

# 2. The regression itself -- invoked directly, and not executable. Refused, and counted.
d=$(build lost_bit 644 './tools/thing.sh')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=exec_bit_lost' && echo "lost_bit_refused=yes" || echo "lost_bit_refused=no"
echo "$out" | grep -q 'directly_invoked_not_exec=1' && echo "lost_bit_counted=yes" || echo "lost_bit_counted=no"
echo "$out" | grep -q 'not_exec: tools/thing.sh' && echo "lost_bit_named=yes" || echo "lost_bit_named=no"

# 3. An interpreter named ahead of the path needs no exec bit. Free.
d=$(build interpreter 644 'sh ./tools/thing.sh')
verdict_of "$d" | grep -q 'verdict=ok' && echo "interpreter_named_free=yes" || echo "interpreter_named_free=no"

# 4. A Markdown link target invokes nothing. Free.
d=$(build mdlink 644 'see [the thing](./tools/thing.sh) for details')
verdict_of "$d" | grep -q 'verdict=ok' && echo "markdown_link_free=yes" || echo "markdown_link_free=no"

# 5. A file with no shebang is run by something that names it. Free.
d=$(build noshebang 644 './tools/thing.sh')
( cd "$d" && printf 'plain text, no shebang\n' > tools/thing.sh && git add -A \
  && git commit -qm 'pen: the script loses its shebang' ) >/dev/null 2>&1
verdict_of "$d" | grep -q 'verdict=ok' && echo "no_shebang_free=yes" || echo "no_shebang_free=no"

# 6. Dated testimony keeps every reference it ever wrote, and gates nothing. Free.
d=$(build testimony 644 './tools/thing.sh')
( cd "$d" && git mv RUN.md 20260101-000000_a-dated-note.md \
  && git commit -qm 'pen: the caller becomes testimony' ) >/dev/null 2>&1
verdict_of "$d" | grep -q 'verdict=ok' && echo "dated_testimony_free=yes" || echo "dated_testimony_free=no"

# 7. The working tree drifting from the index -- the mode about to be committed by accident.
d=$(build drift 755 './tools/thing.sh')
chmod 644 "$d/tools/thing.sh"
out=$(verdict_of "$d")
echo "$out" | grep -q 'worktree_index_disagreements=1' && echo "worktree_drift_counted=yes" || echo "worktree_drift_counted=no"
echo "$out" | grep -q 'verdict=exec_bit_lost' && echo "worktree_drift_refused=yes" || echo "worktree_drift_refused=no"

# 8. The ratchet: shebang files at 100644 that nothing invokes. Counted, free under the ceiling,
#    refused once over it -- proven by planting fifty-nine against a ceiling of fifty-eight.
d=$(build ratchet_under 755 './tools/thing.sh')
( cd "$d" && i=1; while [ "$i" -le 58 ]; do printf '#!/bin/sh\necho %s\n' "$i" > "tools/spare$i.sh"; i=$((i + 1)); done
  chmod 644 tools/spare*.sh && git add -A && git commit -qm 'pen: fifty-eight uninvoked scans' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'plain_shebang_ratchet=58' && echo "ratchet_counted=yes" || echo "ratchet_counted=no"
echo "$out" | grep -q 'verdict=ok' && echo "ratchet_under_ceiling_free=yes" || echo "ratchet_under_ceiling_free=no"

( cd "$d" && printf '#!/bin/sh\necho 59\n' > tools/spare59.sh && chmod 644 tools/spare59.sh \
  && git add -A && git commit -qm 'pen: one over the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'plain_shebang_ratchet=59' && echo "ratchet_over_counted=yes" || echo "ratchet_over_counted=no"
echo "$out" | grep -q 'verdict=exec_bit_lost' && echo "ratchet_over_ceiling_refused=yes" || echo "ratchet_over_ceiling_refused=no"

echo "control_verdict=ok"
