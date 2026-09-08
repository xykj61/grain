#!/bin/sh
# tools/fixtures/r/rishi_run_record_scan.sh -- the law named a field the language answers NoSuchField to.
#
# WHY. Rishi's `run` builtin returns a record, and every `.rish` script in this tree reads that
# record. `rishi/src/main.rye` builds it in one function, `run_result_record`, whose four fields
# are `out`, `err`, `code`, and `ok`. The agent rule an unattended lap loads every lap --
# `.claude/rules/tame-guidance.md` -- said something else in its cheatsheet table: "`run` always
# returns `{ status, out, err }`. Check `status` before trusting `out`." There is no `status`.
# Asked for one on metal, the interpreter answers `NoSuchField` and exits 1.
#
# THE CORRECTION WAS ALREADY WRITTEN, AND REACHED ONE PAGE OF FOUR. `context/TAME_GUIDANCE.md`
# carries an erratum stamped `20260729.214600` saying exactly this -- the field is `ok`, `status`
# does not exist, `say r.status` answers `NoSuchField`. Forty days later the Claude rule still
# named the dead field twice, `context/TAME_CORE.md` still wrote "check `status`/`.ok`" inside the
# same sentence that gave the right record, and the same rule page disagreed with ITSELF: its
# TAME Core block read `{ ok, out, code }` eight lines above the table that read `{ status, out,
# err }`. Only the Cursor twin was right. An erratum is a record of a correction, and nothing in
# the tree made it a gate, so the correction stopped at the page that recorded it.
#
# WHAT IS COUNTED.
#   `claims_unknown_field` -- GATED AT ZERO. A living law page naming a `run`-record field outside
#     the set derived from the implementation. Two claim shapes are read, because the fault wore
#     both: a brace list beside the word `run` (`{ status, out, err }`), and a check clause naming
#     what to read before trusting `out` (`check `status`/`.ok``). A page may spell the record with
#     fewer fields than exist -- a compressed core is allowed to compress -- so a MISSING field is
#     not counted. Naming one that does not exist is the fault, since a reader acts on it.
#   `metal_missing_fields` -- GATED AT ZERO when the interpreter is present. Each derived field is
#     asked of a real `run` result through `rishi/bin/rishi`; one that does not resolve means the
#     source and the running language disagree, which is a deeper red than any page.
#   `metal_probe_reds` -- GATED AT ONE when the interpreter is present. A field the derivation says
#     does not exist is asked for, and MUST refuse. A guard that cannot red guards nothing: without
#     this leg a broken probe would report every field present and read green over anything.
#
# WHAT PASSES FREE, by named rule.
#   A line carrying `Erratum` or `erratum`. `TAME_GUIDANCE.md` keeps the wrong belief visible on
#     purpose -- "the wrong belief stays visible here rather than being quietly overwritten" -- and
#     a guard that reds on an honest record of a correction teaches hiding corrections.
#   Dated testimony: every `date/`, `archive/`, and `yonder/` shelf, plus any file whose own
#     basename carries a one-clock stamp. Accrete-never-break; a log keeps every word it wrote.
#   `gratitude/` and `vendor/`, which speak other projects' words.
#
# WHAT IS NOT PROVEN. Whether a script that reads `ok` then acts on it acts correctly -- this
# reads names rather than logic. And the bounded sibling record built by `bounded_process_result`
# (seven fields, a different builtin) is out of scope until a law page claims its shape too.
#
# USAGE
#   sh tools/fixtures/r/rishi_run_record_scan.sh
#   sh tools/fixtures/r/rishi_run_record_scan.sh --list        # every claim site and the field named
#   RISHI_RUN_RECORD_ROOT=<dir> sh tools/fixtures/r/rishi_run_record_scan.sh    # a pen's own tree
#
# Driven by tools/r/rishi_run_record_witness.rish. Run from the repository root.

set -u

mode=${1:-count}
root=${RISHI_RUN_RECORD_ROOT:-.}
claims_max=${RISHI_RUN_RECORD_CLAIMS_MAX:-0}

cd "$root" 2>/dev/null || { echo "verdict=no_root"; echo "refused: $root is not a directory" >&2; exit 1; }

source_file=rishi/src/main.rye
[ -f "$source_file" ] || { echo "verdict=no_source"; echo "refused: $source_file absent -- the field set is derived from it, and a guess is not a derivation" >&2; exit 1; }

# THE TRUTH IS DERIVED, NEVER SPELLED HERE. A field list typed into this scan would be a fifth
# copy of the very claim the guard exists to check.
fields=$(awk '
  /^fn run_result_record\(/ { inside = 1 }
  inside && match($0, /\.name = "[a-z_-]+"/) {
    s = substr($0, RSTART + 9, RLENGTH - 10)
    print s
  }
  inside && /^}/ { inside = 0 }
' "$source_file" | sort -u)
fields_n=$(printf '%s\n' "$fields" | grep -c . || true)
if [ "$fields_n" -eq 0 ]; then
  echo "verdict=no_fields"
  echo "refused: no fields derived from run_result_record -- a zero here would call every claim unknown" >&2
  exit 1
fi

known() {
  printf '%s\n' "$fields" | grep -qx "$1"
}

# THE LIVING LAW PAGES, named rather than discovered, because this reads CLAIMS ABOUT one
# language's record and the rooms that make such claims are few and stable.
pages="CLAUDE.md context/TAME_CORE.md context/TAME_GUIDANCE.md rishi/README.md"
for d in .claude/rules .cursor/rules; do
  [ -d "$d" ] || continue
  for f in "$d"/*.md "$d"/*.mdc; do
    [ -f "$f" ] || continue
    pages="$pages $f"
  done
done

hits=""
pages_read=0
for f in $pages; do
  [ -f "$f" ] || continue
  case "$f" in
    */date/*|*/archive/*|*/yonder/*|gratitude/*|vendor/*) continue ;;
  esac
  base=$(basename "$f")
  case "$base" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]*) continue ;;
  esac
  pages_read=$((pages_read + 1))
  found=$(awk -v F="$f" '
    # A CLAIM IS ABOUT THE BUILTIN, so the line names it as code. Ordinary English carrying the
    # word run, and ordinary English carrying the word check, are not claims about this record --
    # reading them as claims is how a first draft of this scan called `check the` a field name.
    /[Ee]rratum/ { next }
    !/`run`/ { next }
    {
      line = $0
      # SHAPE ONE -- a brace list beside the builtin: `{ status, out, err }`. Two or more
      # comma-separated bare identifiers, so a brace holding prose is left alone.
      if (match(line, /\{[^{}]*\}/)) {
        inner = substr(line, RSTART + 1, RLENGTH - 2)
        gsub(/`/, "", inner)
        n = split(inner, parts, ",")
        if (n >= 2) {
          bare = 0
          for (i = 1; i <= n; i++) {
            w = parts[i]
            gsub(/^[ \t.]+|[ \t]+$/, "", w)
            if (w ~ /^[a-z_-]+$/) { bare++; keep[bare] = w }
          }
          if (bare >= 2) for (i = 1; i <= bare; i++) print F "\tshape\t" keep[i]
        }
      }
      # SHAPE TWO -- a check clause naming what to read before trusting `out`. The field is
      # written as code, so the backtick is required: `check `status`/`.ok``. Without it the
      # clause is prose -- `check before trusting `out`` names no field and counts none.
      if (line ~ /trusting/ && match(line, /[Cc]heck `[.a-z_\/-]+`/)) {
        clause = substr(line, RSTART, RLENGTH)
        sub(/^[Cc]heck /, "", clause)
        gsub(/`/, "", clause)
        n = split(clause, parts, "/")
        for (i = 1; i <= n; i++) {
          w = parts[i]
          gsub(/^[ \t.]+|[ \t]+$/, "", w)
          if (w ~ /^[a-z_-]+$/) print F "\tcheck\t" w
        }
      }
    }
  ' "$f")
  [ -n "$found" ] && hits="$hits$found
"
done

unknown_sites=$(printf '%s' "$hits" | awk -F'\t' -v known_list="$(printf '%s' "$fields" | tr '\n' ' ')" '
  NF == 3 {
    ok = 0
    n = split(known_list, k, " ")
    for (i = 1; i <= n; i++) if (k[i] == $3) ok = 1
    if (!ok) print $0
  }
')
claims_n=$(printf '%s' "$hits" | awk -F'\t' 'NF==3' | grep -c . || true)
unknown_n=$(printf '%s' "$unknown_sites" | grep -c . || true)

# THE METAL LEGS. The interpreter is a build artifact and untracked, so its absence is reported
# rather than gated -- yet when it IS here, source and language must agree, and the probe must be
# able to refuse.
metal=absent
metal_missing=0
metal_probe_reds=0
if [ -x rishi/bin/rishi ]; then
  metal=present
  pen=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
  for w in $fields; do
    printf 'let r = run ["sh" "-c" "printf hi"]\nsay r.%s\n' "$w" > "$pen/probe.rish"
    rishi/bin/rishi run "$pen/probe.rish" >/dev/null 2>&1 || {
      metal_missing=$((metal_missing + 1))
      echo "metal_missing_field: $w -- derived from $source_file, refused by the interpreter"
    }
  done
  absent_name=zzz_not_a_field
  known "$absent_name" || {
    printf 'let r = run ["sh" "-c" "printf hi"]\nsay r.%s\n' "$absent_name" > "$pen/probe.rish"
    if rishi/bin/rishi run "$pen/probe.rish" >/dev/null 2>&1; then
      echo "metal_probe_blind: asking for $absent_name succeeded -- this probe cannot red"
    else
      metal_probe_reds=1
    fi
  }
  rm -rf "$pen"
fi

if [ "$mode" = "--list" ]; then
  printf '%s' "$hits" | awk -F'\t' 'NF==3 {print "claim: " $1 "\t" $2 "\t" $3}'
fi

printf 'derived_fields=%s\n' "$(printf '%s' "$fields" | tr '\n' ',' | sed 's/,$//')"
echo "derived_fields_n=$fields_n"
echo "pages_read=$pages_read"
echo "claim_sites=$claims_n"
echo "claims_unknown_field=$unknown_n"
echo "claims_max=$claims_max"
echo "metal=$metal"
echo "metal_missing_fields=$metal_missing"
echo "metal_probe_reds=$metal_probe_reds"

verdict=ok
if [ "$unknown_n" -gt "$claims_max" ]; then
  printf '%s' "$unknown_sites" | grep . | sed 's/^/over: /'
  echo "over: claims_unknown_field=$unknown_n past its wall of $claims_max -- a law page names a run-record field the interpreter answers NoSuchField to"
  verdict=over_wall
fi
if [ "$metal" = present ] && [ "$metal_missing" -gt 0 ]; then
  echo "over: metal_missing_fields=$metal_missing -- $source_file and the running interpreter disagree"
  verdict=metal_disagrees
fi
if [ "$metal" = present ] && [ "$metal_probe_reds" -ne 1 ]; then
  echo "over: the absent-field probe did not refuse -- this instrument cannot make a sound"
  verdict=probe_blind
fi
echo "verdict=$verdict"
[ "$verdict" = ok ] || exit 1
exit 0
