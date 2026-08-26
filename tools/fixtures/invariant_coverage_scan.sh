#!/bin/sh
# tools/fixtures/invariant_coverage_scan.sh -- a seated law, measured for the first time.
#
# WHY THIS EXISTS. TAME asks that every assert carry a `// invariant:` line above it naming the
# reason -- *say why*, the single highest-value habit in the guidance. The law has been seated for
# months and nothing in this tree has ever counted it. The comment-dial measurement of
# 20260824.170904 counted it in passing and read 59.6%, which is a large enough gap to be worth a
# proper reading rather than a footnote.
#
# THE LABEL, and every spelling of it this tree writes. TAME asks for a `// invariant:` line, and
# names three moments an assert belongs at -- construction, mutation, postcondition -- so the tree
# also writes `// invariant (precondition):`, `(postcondition):`, `(bound):`, `(construction):`, and
# the bare `// precondition:` / `// postcondition:`, and `// seam:` where the assert guards the
# inherited-std boundary TAME names by that word -- 16 such stand above an assert.
# **483 lines carried a spelling this scan could
# not read**, all of them the seated label with its TAME category named, which is more faithful to
# the law rather than less. Found on opening `crypto/mldsa_encode.rye` to sweep it, where FIPS 204
# primitives carry their reasons under `// invariant (precondition):`.
#
# WHAT IT READS. Every authored `.rye` file outside vendor, gratitude, and old. For each assert
# standing in CODE -- a comment quoting an assert is prose, a line of a `\\` multiline string is
# generated source rather than this file's own, and `emit_assert(` is a function name that merely
# ends in one (8 such lines across 29,685, found while sweeping `glow/lower_assert.rye`) -- it walks up over blank lines and over
# a run of neighbouring asserts, then through the contiguous comment block above, and asks whether
# any line of that block says `invariant:`. A run of asserts under one invariant block is covered
# by it, which is how the law is actually written and how this tree actually spells it.
#
# WHY A RATIO OF TWO LINE COUNTS WOULD ANSWER A DIFFERENT QUESTION. One invariant line can head a
# block of six asserts, and one assert can carry three comment lines. Dividing the counts reads
# neither case correctly, so each assert is asked about individually.
#
# THE BINS, and why they are these. Not every assert is a contract:
#
#   witness   an assert inside a `*_witness.rye` file is proving a claim about the tree, and its
#             reason is the witness header rather than a line above the call.
#   selftest  an assert inside a proof that runs. A ROLE WORD in the function's name -- `main`,
#             `selftest`, `witness` -- says so, and so does REACHABILITY: a private function called
#             only from those entry points, directly or through other such functions, is proof
#             whatever it is called. The name vocabulary failed three times in three rounds
#             (REDS %207, %208, %210), each caught by a hand opening a file, and reachability is
#             what retires it: `image/photos.rye` names its proofs `run_hue_turn` and `run_bilinear`
#             and no vocabulary would ever have reached them, yet **200 of its 244 asserts** sit in
#             14 functions the selftest alone calls. A helper called from a `pub` function as well
#             stays a contract, which is what keeps reachability from swallowing real code.
#             So is every assert in a file under a `tests/` directory -- a STRUCTURAL reading rather
#             than a lexical one, the same shape as reading `date/` for a folded room. `rye/tests/`
#             holds 116 such files, and the two carrying asserts declare themselves `Rye test:` in a
#             header the selftest rule cannot see. Adding "test" to the word list would flip any
#             module whose header merely mentioned one; a directory says it and means it.
#             So is EVERY assert
#             in a file whose own `//!` header declares it one -- `lattice/lattice.rye` opens
#             `Lattice selftest`, builds to `lattice/bin/lattice selftest`, and names its 199
#             functions `welcome_add`, `welcome_matmul`, `welcome_reshape`. Binning by function
#             NAME alone read all 199 as contracts and reported the room at 0.0% coverage, which
#             sent a sweep at a file that is entirely test (found while starting that sweep).
#   contract  everything else -- an assert inside an ordinary function, which is exactly what the
#             seated law is about.
#
# The bins are reported separately rather than merged, because a single number over all three would
# be measuring three different promises at once.
#
# WHAT IS NOT MEASURED. Whether an invariant line says anything USEFUL. A line reading
# `// invariant: n is at most 64` above `assert(n <= 64)` restates its own assertion and counts here
# exactly like a line naming the failure the bound exists to prevent. Presence is the check; a
# reason a reader can use is the standard.
#
# PROVEN, because this bin moved the tree's reading by an order of magnitude.
# tools/fixtures/invariant_coverage_control.sh runs 15 behaviors on planted modules in a throwaway
# git pen, including the two failure modes that broke drafts of this rule: a `pub` function
# swallowed by the reachability spread, and a shared helper that must withdraw to contract when a
# `pub` function calls it too.
#
# THIS SEATS NOTHING ELSE. No ratchet, no ceiling, no roster entry. A measurement taken to answer a
# question is finished when the question is answered.
#
# USAGE
#   sh tools/fixtures/invariant_coverage_scan.sh            # the tree reading
#   sh tools/fixtures/invariant_coverage_scan.sh modules    # one row per module, worst first
#
# Run from the repository root.

set -u

# One dialect for both piers: xargs_lines / xargs_lines_batched run a command over a
# newline-delimited path list in a spelling GNU and BSD userland both accept.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"

mode=${1:-tree}
root=${INVARIANT_ROOT:-.}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# A SYMLINK IS NOT A SECOND MODULE. Zig refuses an import that escapes the root file's directory,
# so a module three rooms need is symlinked into each of them -- image/photos.rye is the file and
# pond/apps/photos.rye and brushstroke/photos.rye are links to it. Counting the links would triple
# that file's 185-assert gap and read 555 where 185 stands. The first run of this scan did exactly
# that, and three identical rows in the worst-ten table are what showed it.
( cd "$root" && git ls-files '*.rye' 2>/dev/null ) | grep -vE '^(vendor|gratitude|old)/' \
  | ( cd "$root" && while IFS= read -r _f; do [ -L "$_f" ] || printf '%s\n' "$_f"; done ) > "$work/files.txt"
count=$(wc -l < "$work/files.txt" | tr -d ' ')
[ "$count" -gt 0 ] || { echo "verdict=no_modules"; exit 1; }

# CROSS-FILE CALLS, gathered once. A `pub fn` is exported for callers this file cannot see, so the
# proof spread may not reach into one -- REDS %211. Yet `caravan/regions.rye` exports
# `check_declared_access`, `check_reads` and `check_refusals` for a WITNESS to call, and its own
# selftest calls them too: 361 asserts that are proof by role and contract by export (REDS %213).
#
# The two are told apart by asking the tree rather than the file. A qualified call `.name(` from
# some OTHER authored module means a real caller exists; none means the export is for a proof
# harness. Paired with a `void` return -- a proof gives its caller nothing -- both conditions must
# hold before the spread reaches a `pub fn`, and each errs toward CONTRACT when it is unsure, since
# a contract read as proof hides a real gap while a proof read as contract merely inflates one.
( cd "$root" && xargs_lines "$work/files.txt" grep -HoE '\.[a-z_][A-Za-z0-9_]*[ ]*\(' 2>/dev/null ) \
  | sed 's/:\./\t/; s/[ ]*($//' | sort -u > "$work/qcalls.tsv"

( cd "$root" && xargs_lines "$work/files.txt" awk -v QCALLS="$work/qcalls.tsv" -v WANT_SITES="${WANT_SITES:-0}" -v SITES="$work/sites.txt" '
  function covered(i,   j, k) {
    # up over blanks and over a run of neighbouring asserts, then through the comment block
    j = i - 1
    while (j >= 1 && (lines[j] ~ /^[ \t]*$/ || (lines[j] ~ /(^|[^A-Za-z0-9_])assert\(/ && lines[j] !~ /^[ \t]*\/\//))) j--
    while (j >= 1 && lines[j] ~ /^[ \t]*\/\//) {
      if (lines[j] ~ /\/\/[ \t]*(invariant|precondition|postcondition|seam)[^:]{0,30}:/) return 1
      j--
    }
    return 0
  }
  # Which functions are proofs? Name says one thing, the call graph says the rest.
  BEGIN {
    while ((getline ln < QCALLS) > 0) {
      t = index(ln, "\t"); if (t == 0) continue
      cf = substr(ln, 1, t - 1); cn = substr(ln, t + 1)
      qn[cn]++; qwhere[cn] = cf
    }
    close(QCALLS)
  }
  # Called with a qualifier from some file other than this one?
  function called_outside(nm, me) {
    if (!(nm in qn)) return 0
    if (qn[nm] >= 2) return 1
    return (qwhere[nm] != me)
  }
  function mark_proofs(   i, j, fname, ispub, a, b, body, n2, moved, pass) {
    nf = 0
    delete fstart; delete fend; delete fname_of; delete fpub; delete fvoid; delete isproof; delete outside
    for (i = 1; i <= n_lines; i++) {
      if (lines[i] ~ /^(pub[ \t]+)?(export[ \t]+)?fn[ \t]+[A-Za-z_]/) {
        if (nf > 0) fend[nf] = i - 1
        nf++
        fpub[nf] = (lines[i] ~ /^pub[ \t]/)
        fvoid[nf] = (lines[i] ~ /\)[ \t]*void[ \t]*\{/)
        fname = lines[i]
        sub(/^(pub[ \t]+)?(export[ \t]+)?fn[ \t]+/, "", fname); sub(/[ \t(].*$/, "", fname)
        fname_of[nf] = fname; fstart[nf] = i
      }
    }
    if (nf > 0) fend[nf] = n_lines
    # seed: the entry points a role word names
    for (i = 1; i <= nf; i++)
      isproof[i] = (fname_of[i] == "main" || fname_of[i] ~ /selftest/ || fname_of[i] ~ /witness/)
    # spread: called from a proof, to a fixed point
    for (pass = 1; pass <= 8; pass++) {
      moved = 0
      for (i = 1; i <= nf; i++) {
        if (!isproof[i]) continue
        body = ""
        for (j = fstart[i]; j <= fend[i]; j++) body = body "\n" lines[j]
        for (j = 1; j <= nf; j++) {
          if (j == i || isproof[j]) continue
          # A `pub` function is reached into only when the TREE says nobody else calls it and its
          # own signature says it gives nothing back. Without the first guard the spread swallowed
          # the API it was written to exercise -- 22,017 contract asserts read as 10,285 on the
          # first run of this rule. Without the second, an exported verb nobody has called yet
          # would read as proof; `image/photos.rye` publishes `scale_bilinear` with no caller in
          # the tree, and it returns a pixmap, so it stays a contract.
          # `name`, never FILENAME: flush() processes the file that just ENDED, and FILENAME already
          # holds the next one by then.
          if (fpub[j] && (called_outside(fname_of[j], name) || !fvoid[j])) continue
          if (body ~ ("[^A-Za-z0-9_]" fname_of[j] "[ \t]*\\(")) { isproof[j] = 1; moved = 1 }
        }
      }
      if (!moved) break
    }
    # withdraw: anything a NON-proof function also calls is shared code, so it is a contract again
    for (i = 1; i <= nf; i++) {
      if (isproof[i]) continue
      body = ""
      for (j = fstart[i]; j <= fend[i]; j++) body = body "\n" lines[j]
      for (j = 1; j <= nf; j++)
        if (isproof[j] && fname_of[j] != "main" && fname_of[j] !~ /selftest/ && fname_of[j] !~ /witness/ &&
            body ~ ("[^A-Za-z0-9_]" fname_of[j] "[ \t]*\\(")) outside[j] = 1
    }
    for (i = 1; i <= nf; i++) if (outside[i]) isproof[i] = 0
  }
  function proof_at(ln,   i) {
    for (i = 1; i <= nf; i++) if (ln >= fstart[i] && ln <= fend[i]) return isproof[i]
    return 0
  }
  function flush(   i, fn, kind, iswit, isself) {
    if (name == "") return
    iswit = (name ~ /_witness\.rye$/)
    # A file that calls itself a selftest in its own module doc is one, whatever its functions are
    # named. Read the head only, so a mention deep in the body cannot reclassify a real module.
    isself = 0
    for (i = 1; i <= n_lines && i <= 6; i++) if (lines[i] ~ /^\/\/!/ && tolower(lines[i]) ~ /selftest/) isself = 1
    if (name ~ /(^|\/)tests?\//) isself = 1
    # A file under a fixtures/ directory is a PLANTED ARTIFACT rather than a module: a deliberate
    # drift copy a sameness witness compares byte for byte, or an intentional ban violation a style
    # check must bite. Writing a reason into either changes the thing it was planted to be.
    if (name ~ /(^|\/)fixtures\//) isself = 1
    mark_proofs()
    c = cc = s = sc = w = wc = 0
    fn = ""
    for (i = 1; i <= n_lines; i++) {
      if (lines[i] ~ /^[ \t]*(pub[ \t]+)?(export[ \t]+)?fn[ \t]+[A-Za-z_]/) {
        fn = lines[i]
        sub(/^[ \t]*(pub[ \t]+)?(export[ \t]+)?fn[ \t]+/, "", fn)
        sub(/[ \t(].*$/, "", fn)
      }
      # An assert CALL: not `emit_assert(`, and not a line of a `\\` string holding generated source.
      if (lines[i] !~ /(^|[^A-Za-z0-9_])assert\(/) continue
      if (lines[i] ~ /^[ \t]*\\\\/) continue
      # A function DECLARATION named assert is not a call to one -- comlink/virtio_net.rye declares
      # its own `fn assert(ok: bool)` for a freestanding target with no std behind it.
      if (lines[i] ~ /^[ \t]*(pub[ \t]+)?fn[ \t]+[A-Za-z0-9_]*assert\(/) continue
      # An assert named inside a STRING is prose the program prints, not a call it makes.
      # tools/rye/tame_usize_audit.rye prints `needs assert(... <= maxInt(u32)) before cast`.
      if (lines[i] ~ /"[^"]*assert\(/) continue
      if (lines[i] ~ /^[ \t]*\/\//) continue
      k = covered(i)
      if (iswit)                                        { w++;  wc += k }
      else if (isself || proof_at(i))                   { s++;  sc += k }
      else {
        c++; cc += k
        # A sweep must read the same binning the count does, or it is two implementations again.
        if (WANT_SITES && !k) printf "%s\t%d\t%s\n", name, i, lines[i] >> SITES
      }
    }
    printf "%s %d %d %d %d %d %d\n", name, c, cc, s, sc, w, wc
    n_lines = 0
  }
  FNR == 1 { flush(); name = FILENAME }
  { lines[++n_lines] = $0 }
  END { flush() }
' ) > "$work/rows.txt" 2>/dev/null

[ "${WANT_SITES:-0}" = 1 ] && [ -f "$work/sites.txt" ] && cat "$work/sites.txt" >&2

if [ "$mode" = modules ]; then
  printf '%-56s %7s %7s %6s\n' module contract covered gap
  awk '$2 > 0 { printf "%-56s %7d %7d %6d\n", $1, $2, $3, $2 - $3 }' "$work/rows.txt" | sort -k4 -rn
  exit 0
fi

awk -v n="$count" '
  { c+=$2; cc+=$3; s+=$4; sc+=$5; w+=$6; wc+=$7
    if ($2 > 0) { mods++; gap = $2 - $3; if (gap == 0) clean++; else { gaps[++g] = gap; tg += gap } } }
  END {
    printf "modules=%d\n", n
    printf "contract_asserts=%d\n", c
    printf "contract_with_a_reason=%d\n", cc
    printf "contract_with_no_reason=%d\n", c - cc
    if (c > 0) printf "contract_coverage_percent=%d\n", cc * 100 / c
    printf "selftest_asserts=%d selftest_with_a_reason=%d\n", s, sc
    printf "witness_asserts=%d witness_with_a_reason=%d\n", w, wc
    printf "modules_with_a_contract_assert=%d\n", mods
    printf "modules_fully_covered=%d\n", clean
    printf "modules_with_a_gap=%d\n", mods - clean
    # how concentrated: sort the per-module gaps and read the top of the distribution
    for (i = 2; i <= g; i++) { v = gaps[i]; j = i - 1
      while (j >= 1 && gaps[j] < v) { gaps[j+1] = gaps[j]; j-- }
      gaps[j+1] = v }
    top10 = top50 = 0
    for (i = 1; i <= g && i <= 10; i++) top10 += gaps[i]
    for (i = 1; i <= g && i <= 50; i++) top50 += gaps[i]
    printf "total_gap=%d\n", tg
    if (tg > 0) {
      printf "gap_in_worst_10_modules=%d (%d%%)\n", top10, top10 * 100 / tg
      printf "gap_in_worst_50_modules=%d (%d%%)\n", top50, top50 * 100 / tg
      printf "worst_single_module_gap=%d\n", gaps[1]
      printf "median_module_gap=%d\n", gaps[int(g * 0.5) + 1]
    }
  }
' "$work/rows.txt"
echo "verdict=measured"
