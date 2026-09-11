#!/bin/sh
# tools/fixtures/r/rye_build_lock_reach_scan.sh -- does the build lock reach the shadows it guards?
#
# WHAT THE LOCK IS. `rye build` and `rye run` bridge a `.rye` root and every local `.rye` module it
# imports to adjacent `.zig` shadow files, hand those to the toolchain, and delete them on the way
# out. Two builds staging the same shadow would delete each other's files mid-compile, so
# `rye/src/main.rye` takes one lock for the whole bridge -- shadow write to shadow delete, cache-hit
# path included, since the bridge stages before any receipt is consulted (REDS %281, landed
# `20260827.023156`).
#
# WHERE THE TWO SCOPES PART. The lock directory is `.rye-build.lock`, opened against
# `std.Io.Dir.cwd()` -- so its scope is THE CALLER'S WORKING DIRECTORY. A shadow's path is the
# source's own path with `.rye` traded for `.zig` -- so its scope is THE TREE. Two callers standing
# in two directories therefore take two different locks over one shadow namespace, and neither waits
# for the other. That is a boundary drawn on one axis over a hazard that lives on another.
#
# WHAT THIS READS. Every tracked `rye build` / `rye run` invocation under `tools/`, the working
# directory it runs from (a leading `cd <dir> &&` in the same shell string, else the repository
# root), and the closure of `.rye` files each root reaches through local `@import`. Two roots
# sharing a shadow path UNDER ONE lock scope are safe -- that is what the lock is for, and 55% of
# this tree's shadow paths are shared that way. Two roots sharing a shadow path across DIFFERENT
# lock scopes are guarded by nothing, and that reading is the gate.
#
# A PEN CWD IS NOT A SCOPE. A `cd "$var"` whose directory is a shell variable names a throwaway pen
# built by a control, which is disjoint from the tree by construction and holds its own lock beside
# its own sources. Those are counted as `pen_scopes` and left out of the collision reading.
#
# AND THIS SCAN'S OWN CONTROL IS PLANTED MATERIAL, WHICH THE READING ABOVE DOES NOT CATCH. That
# control writes its pens with a printf whose body names a LITERAL directory rather than a shell
# variable -- `cd <pen-dir> ... <root>.rye` with real words in both slots -- so every planted
# cross-scope line read as a tree invocation the moment the
# control was staged: `lock_scopes` went 2 to 5, naming `lab`, `lab/deep` and `shared`, and the gate
# refused its own pen. That is REDS %519's law in a second room -- a control's plants are literal
# lines of the tree, and a scan that reads its own control measures the plant. The one file is named
# and its exclusion is PRINTED, rather than the class being swept: measured `20260911`, two other
# controls (`rye_harness_roster_control.sh`, `rye_lib_resolve_control.sh`) name genuine tracked
# sources, so excluding every `_control.sh` would hide real invocations to spare this one.
#
# THE SAME TRAP CLOSED ON THIS DOOR ONE TURN LATER. The paragraph above first spelled the planted
# line out in full, and the scan reads `tools/*` -- so its own example counted as a fourth lock
# scope. An illustration is written from PLACEHOLDERS for exactly this reason
# (`.claude/rules/stamp-and-name.md`), and here the meter says so out loud rather than a reader
# having to notice.
#
# Run from the repository root:
#   sh tools/fixtures/r/rye_build_lock_reach_scan.sh
#   sh tools/fixtures/r/rye_build_lock_reach_scan.sh --explain   # name every cross-scope path
set -u

explain=no
[ "${1:-}" = "--explain" ] && explain=yes

pen=$(mktemp -d 2>/dev/null || echo "./.lap/rye-lock-reach-$$")
mkdir -p "$pen"
trap 'rm -rf "$pen"' EXIT

# Every invocation, as "cwd<TAB>root-source". A `cd <dir> &&` anywhere ahead of the verb in the same
# line sets the directory; anything else stands at the repository root.
SELF_CONTROL=${RYE_LOCK_SELF_CONTROL-tools/fixtures/r/rye_build_lock_reach_control.sh}
self_control_lines=$(grep -cE 'rye (build|run) [^ ]+\.rye' "$SELF_CONTROL" 2>/dev/null || echo 0)

git ls-files 'tools/*' 2>/dev/null \
  | grep -E '\.(rish|sh)$' \
  | grep -vxF "$SELF_CONTROL" \
  | while IFS= read -r f; do
      [ -f "$f" ] || continue
      grep -hoE 'cd [^ ]+ &&[^"]*rye (build|run) [^ ]+\.rye|rye (build|run) [^ ]+\.rye' "$f" 2>/dev/null
    done \
  | awk '
      {
        cwd = "."
        if ($1 == "cd") { cwd = $2; gsub(/"/, "", cwd) }
        src = ""
        for (i = 1; i <= NF; i++) if ($i ~ /\.rye$/) src = $i
        if (src == "") next
        if (cwd ~ /\$/) { print "PEN\t" cwd; next }
        print cwd "\t" src
      }' \
  | sort -u > "$pen/invocations"

pen_scopes=$(awk -F'\t' '$1 == "PEN"' "$pen/invocations" | wc -l | tr -d ' ')
grep -v '^PEN	' "$pen/invocations" > "$pen/tree" || true

# Resolve each (cwd, root) to a tree-relative source path, then walk its import closure and claim
# one shadow path per member for that cwd's lock scope.
awk -F'\t' '
  function dirname(p,  i) { i = length(p); while (i > 0 && substr(p, i, 1) != "/") i--; return i > 0 ? substr(p, 1, i - 1) : "." }
  function normalize(p,  parts, n, out, i, k) {
    n = split(p, parts, "/"); k = 0
    for (i = 1; i <= n; i++) {
      if (parts[i] == "" || parts[i] == ".") continue
      if (parts[i] == "..") { if (k > 0) k--; continue }
      out[++k] = parts[i]
    }
    p = ""
    for (i = 1; i <= k; i++) p = (i == 1) ? out[i] : p "/" out[i]
    return p
  }
  function walk(f, rid, scope,   d, line, arr, imp, n, i, shadow) {
    if ((rid SUBSEP f) in seen) return
    seen[rid SUBSEP f] = 1
    shadow = substr(f, 1, length(f) - 4) ".zig"
    claims[shadow]++
    if (!((shadow SUBSEP scope) in claimed)) { claimed[shadow SUBSEP scope] = 1; scopes[shadow] = scopes[shadow] " " scope }
    d = dirname(f)
    while ((getline line < f) > 0) {
      n = split(line, arr, "@import\\(\"")
      for (i = 2; i <= n; i++) { imp = arr[i]; sub(/".*/, "", imp); if (imp ~ /\.rye$/) pending[++pc] = normalize(d "/" imp) }
    }
    close(f)
  }
  {
    scope = normalize($1); if (scope == "") scope = "."
    root = normalize((scope == ".") ? $2 : scope "/" $2)
    roots[++rc] = root SUBSEP scope
  }
  END {
    for (r = 1; r <= rc; r++) {
      split(roots[r], p, SUBSEP)
      pc = 0; delete pending
      walk(p[1], r, p[2])
      i = 1
      while (i <= pc) { walk(pending[i], r, p[2]); i++ }
    }
    for (s in claims) {
      total++
      if (claims[s] > 1) shared++
      if (claims[s] > busiest_n) { busiest_n = claims[s]; busiest = s }
      n = split(scopes[s], sc, " ")
      distinct = 0; delete seenscope
      for (i = 1; i <= n; i++) if (sc[i] != "" && !(sc[i] in seenscope)) { seenscope[sc[i]] = 1; distinct++ }
      if (distinct > 1) { cross++; print "cross " s scopes[s] > "/dev/stderr" }
    }
    printf "build_roots=%d\n", rc
    printf "shadow_paths=%d\n", total
    printf "shared_paths=%d\n", shared + 0
    printf "cross_scope_collisions=%d\n", cross + 0
    printf "busiest_path=%s busiest_claims=%d\n", busiest, busiest_n
  }
' "$pen/tree" 2> "$pen/cross" > "$pen/reading"

lock_scopes=$(cut -f1 "$pen/tree" | sort -u | wc -l | tr -d ' ')

cat "$pen/reading"
echo "lock_scopes=$lock_scopes pen_scopes=$pen_scopes"
echo "self_control_excluded=$SELF_CONTROL self_control_lines=$self_control_lines"
echo "lock_scope_names: $(cut -f1 "$pen/tree" | sort -u | tr '\n' ' ')"

if [ "$explain" = yes ]; then
  if [ -s "$pen/cross" ]; then
    echo "--- shadow paths claimed under two lock scopes ---"
    sort -u "$pen/cross"
  else
    echo "--- no shadow path is claimed under two lock scopes ---"
  fi
fi

cross=$(sed -n 's/^cross_scope_collisions=//p' "$pen/reading")
if [ "${cross:-0}" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=cross_scope_shadow"
fi
