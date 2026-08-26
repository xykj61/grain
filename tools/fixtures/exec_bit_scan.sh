#!/bin/sh
# tools/fixtures/exec_bit_scan.sh -- a script the tree tells you to run is a script you can run.
#
# WHY. On 20260823 the commit 1c233b39db repointed 116 path literals across 58 tracked tool
# sources and, in the same pass, dropped mode 100755 to 100644 on thirty-nine tracked files.
# The rewrite read each file, wrote a temporary beside it, and moved the temporary over the
# original -- and `mv` carries the temporary's mode, never the original's. Nothing in the diff
# said so: `git show --stat` counts lines, and a mode change moves no lines, so the round read
# as a clean repoint. One of the thirty-nine was tools/ag/agent-jail.sh, which the unattended loop
# invokes as `./tools/ag/agent-jail.sh`, so the loop answered `Permission denied` once every twenty
# seconds until a hand ran `chmod +x`. The guard that would have caught it did not exist.
#
# WHAT IS GATED, hard.
#   Every tracked file carrying a shebang that a LIVING tracked file invokes directly -- as
#   `./path` in command position -- holds index mode 100755. This is the load-bearing set: when
#   the tree writes `./tools/ag/agent-jail.sh`, that is a promise a fresh clone must be able to keep.
#   Every tracked file's on-disk exec bit agrees with its index mode. A mode that has drifted in
#   the working tree is a mode about to be committed by accident, and this is where it is cheapest
#   to see. It also makes a DELIBERATE chmod loud, which is the point rather than a cost.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. Tracked shebang files at
# 100644 that nothing invokes directly -- the fixture scans, which every witness runs as
# `run ["sh" "tools/fixtures/..."]` with the interpreter named. Their exec bit is genuinely
# optional, so a sweep would be tidiness rather than repair. They fall on touch.
#
# WHAT IS NOT PROVEN. That a shebang names an interpreter this machine has, and that an executable
# file does anything useful. Only that the tree can run what it says to run.
#
# USAGE
#   sh tools/fixtures/exec_bit_scan.sh
#
# Driven by tools/e/exec_bit_witness.rish. Run from the repository root.

set -u

# One dialect for both piers: xargs_lines / xargs_lines_batched run a command over a
# newline-delimited path list in a spelling GNU and BSD userland both accept.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"

# The ratchet's ceiling only ever falls. Measured 20260823: 58 tracked shebang files sat at
# 100644 with nothing invoking any of them directly. Lowered to 57 on 20260824.112806, when a
# round touching sow_project.sh gave it and its new control the bit -- which is what "they fall
# on touch" means at birth as well: a fixture born at 100644 grows the population the ceiling
# exists to shrink, so it is born with the bit instead.
ceiling=57

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The index is the authority on mode, not the filesystem -- a fresh clone reads the index.
git ls-files -s > "$work/index.tsv"
awk '$1 == "100644" || $1 == "100755"' "$work/index.tsv" > "$work/regular.tsv"
awk '{ mode = $1; $1=""; $2=""; $3=""; sub(/^   /, ""); print mode "\t" $0 }' "$work/regular.tsv" \
  > "$work/modes.tsv"

# A file carrying a shebang is a file meant to be run by something. Read the INDEX rather than the
# working copy, so the reading is of the repository rather than of this machine. One `git grep`
# over the whole index, restricted to line one: the shape that read each of 13,650 blobs in its
# own `git cat-file` took over a minute, and a guard nobody waits for is a guard nobody runs.
git grep --cached -I -n -E '^#!' -- . 2>/dev/null \
  | awk -F: '$2 == 1 { print $1 }' | sort -u > "$work/shebang_paths.txt"
awk -F'\t' 'NR == FNR { want[$0] = 1; next }
            ($2 in want) { print $1 "\t" $2 }' \
    "$work/shebang_paths.txt" "$work/modes.tsv" > "$work/shebang.tsv"

# Every tracked path, as a set an awk lookup can answer in one pass.
awk '{ $1=""; $2=""; $3=""; sub(/^   /, ""); print }' "$work/regular.tsv" > "$work/tracked.txt"

# Living files only. A file whose own basename carries a one-clock stamp is testimony, and
# testimony keeps every reference it ever wrote (accrete-never-break). The same line the fold,
# the resolver, and the repointer already draw.
grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' "$work/tracked.txt" > "$work/living.txt"

# A path in COMMAND position, written the way a shell would run it. The word before the token
# settles it: an interpreter named ahead of the path -- `sh ./x`, `bash ./x`, `rishi run ./x` --
# needs no exec bit, and a Markdown link `](./x)` invokes nothing at all.
: > "$work/invoked.txt"
xargs_lines_batched 400 "$work/living.txt" \
  grep -hoE '(^|[]| 	`|;&(])[^ 	`|;&()]* *\./[A-Za-z0-9_][A-Za-z0-9_./-]*' 2>/dev/null \
  | awk '
      {
        line = $0
        if (line ~ /\]\( *\.\//) next            # a Markdown link target runs nothing
        n = split(line, w, /[ \t]+/)
        tok = w[n]; prev = (n > 1 ? w[n-1] : "")
        if (tok !~ /^\.\//) next
        if (prev ~ /^(sh|bash|zsh|dash|source|\.|run|rishi|python|python3|perl|ruby|node|cat|ls|rm|cp|mv|git|chmod|head|tail|grep|wc|echo|printf|test|\[|-f|-x|-e|-r|file|stat|awk|sed|jq|site|path)$/) next
        sub(/^\.\//, "", tok)
        sub(/[.,:;)"`'"'"']+$/, "", tok)
        if (tok != "") print tok
      }' \
  | sort -u > "$work/invoked.txt"

# The gated set: invoked directly AND carrying a shebang AND tracked.
awk -F'\t' 'NR == FNR { mode[$2] = $1; next }
            ($0 in mode) { print mode[$0] "\t" $0 }' \
    "$work/shebang.tsv" "$work/invoked.txt" > "$work/gated.tsv"

awk -F'\t' '$1 != "100755" { print $2 }' "$work/gated.tsv" > "$work/not_exec.txt"

# The working tree must agree with the index, or a mode is already drifting toward a commit.
: > "$work/disagree.txt"
# `git diff --raw` reports the index mode and the working-tree mode side by side in one pass.
# A deleted file reads 000000 and belongs to `git status`, never to this reading.
git diff --raw -- . 2>/dev/null \
  | awk '{ old = substr($1, 2); new = $2
           if (new != "000000" && new != old) {
             path = $0; sub(/^[^\t]*\t/, "", path)
             print path " index=" old " worktree=" new
           } }' >> "$work/disagree.txt"

# The ratchet: a shebang at 100644 that nothing invokes directly.
awk -F'\t' '$1 == "100644" { print $2 }' "$work/shebang.tsv" | sort > "$work/plain.txt"
comm -23 "$work/plain.txt" "$work/invoked.txt" > "$work/ratchet.txt"

not_exec=$(wc -l < "$work/not_exec.txt" | tr -d ' ')
disagree=$(wc -l < "$work/disagree.txt" | tr -d ' ')
ratchet=$(wc -l < "$work/ratchet.txt" | tr -d ' ')

echo "tracked_regular_files=$(wc -l < "$work/regular.tsv" | tr -d ' ')"
echo "shebang_files=$(wc -l < "$work/shebang.tsv" | tr -d ' ')"
echo "directly_invoked=$(wc -l < "$work/gated.tsv" | tr -d ' ')"
echo "directly_invoked_not_exec=$not_exec"
echo "worktree_index_disagreements=$disagree"
echo "plain_shebang_ratchet=$ratchet"
echo "plain_shebang_ceiling=$ceiling"

[ "$not_exec" -eq 0 ] || sed 's/^/not_exec: /' "$work/not_exec.txt"
[ "$disagree" -eq 0 ] || sed 's/^/disagree: /' "$work/disagree.txt"
[ "$ratchet" -eq 0 ] || { echo "ratchet: $ratchet shebang files at 100644 that nothing invokes directly, repaired on touch"; sed 's/^/ratchet: /' "$work/ratchet.txt" | head -5; }

if [ "$not_exec" -eq 0 ] && [ "$disagree" -eq 0 ] && [ "$ratchet" -le "$ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=exec_bit_lost"
echo "refused: a script the tree invokes directly cannot be run -- read the lines above" >&2
exit 1
