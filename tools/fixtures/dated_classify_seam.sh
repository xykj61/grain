#!/bin/sh
# dated_classify_seam.sh — the regex seam for dated_classify.rish.
#
# Rishi owns the interface (tools/fixtures/dated_classify.rish); this POSIX-sh seam
# holds the two ripgrep patterns Rishi has no native regex for, exactly as the elder
# dated_classify.py delegated to Python's `re`. One definition lives here, reached
# only through the rish, so no two roofs can drift (REDS 40).
#
# Canon: context/specs/living-vs-dated.md
#   dated name   : (^|/)YYYYMMDD-HHMMSS_   anchored path segment
#   living header: **Stamp:** living ledger  |  living ledger (born   (case-insensitive, first 8000 bytes)
#
#   sh dated_classify_seam.sh classify <path>
#   sh dated_classify_seam.sh census
set -eu

# WIDENED 20260823.204456 (REDS %175). The sprig is OPTIONAL by the session-logs law -- it is
# added only when two logs share a second -- so 237 tracked logs are named `YYYYMMDD-HHMMSS.ext`
# with no underscore at all. Requiring one classified every last of them as LIVING, which left
# them open for writing to the dated-path repointer. The stamp alone marks testimony; what may
# follow it is an underscore-sprig or the extension directly.
DATED_RE='(^|/)[0-9]{8}-[0-9]{6}(_|\.)'
HDR_RE='(?i)(\*\*Stamp:\*\* *living ledger|living ledger *\(born)'
SKIP_RE='\.(png|jpg|jpeg|gif|webp|ico|pdf|woff|woff2|ttf|otf|zip|gz|xz|wasm|so|o|a|bin|mp4|webm)$'

is_dated_name() { printf '%s' "$1" | rg -q "$DATED_RE"; }
is_skip_ext()   { printf '%s' "$1" | rg -q "$SKIP_RE"; }
has_header()    { head -c 8000 "$1" 2>/dev/null | rg -q "$HDR_RE"; }

# header_files <listfile> — emit the paths in <listfile> that carry a living header in
# their first 8000 bytes. A bulk `rg -l` (whole-file) narrows to a handful of candidates,
# then head -c 8000 confirms the byte bound exactly — fast without loosening the semantics
# classify uses. Thousands of per-file spawns collapse to one rg pass plus a few checks.
header_files() {
  xargs -a "$1" -d '\n' rg -l "$HDR_RE" 2>/dev/null | while IFS= read -r f; do
    head -c 8000 "$f" 2>/dev/null | rg -q "$HDR_RE" && printf '%s\n' "$f"
  done
}

classify() {
  p="$1"
  if ! is_dated_name "$p"; then echo live; return 0; fi
  if is_skip_ext "$p"; then echo dated; return 0; fi
  if has_header "$p"; then echo live; else echo dated; fi
}

census() {
  all=$(mktemp); dn=$(mktemp); tx=$(mktemp)
  trap 'rm -f "$all" "$dn" "$tx"' EXIT
  git ls-files -z | tr '\0' '\n' > "$all"
  total=$(grep -c '' "$all")
  rg "$DATED_RE" "$all" > "$dn" || true
  dated_named=$(grep -c '' "$dn" || true)
  rg -v "$SKIP_RE" "$dn" > "$tx" || true
  live_among=$(header_files "$tx" | grep -c '' || true)
  dated=$(( dated_named - live_among ))
  live=$(( total - dated ))
  health=$(awk -v l="$live" -v t="$total" 'BEGIN{ if(t==0){print 0}else{printf "%.0f", 100.0*l/t} }')
  printf 'tracked_total=%s\n' "$total"
  printf 'dated_testimony=%s\n' "$dated"
  printf 'live_surface=%s\n' "$live"
  printf 'fascia_health=%s\n' "$health"
  printf 'definition=living-vs-dated\n'
  printf 'dated_name=(^|/)YYYYMMDD-HHMMSS_\n'
  printf 'living_header=Stamp living ledger | living ledger (born\n'
  printf 'verdict=ok\n'
}

# health <live_ctrl> <dated_ctrl> — the per-room fascia-health report, reproducing the
# elder fascia_health_scan.sh Python block byte-for-byte: the two control verdicts, the
# global tally, and every room carrying dated testimony, sorted by live-percentage then
# room name. dated iff dated-named and not rescued by a living header.
health() {
  live_ctrl="$1"; dated_ctrl="$2"
  c_live=$(classify "$live_ctrl")
  c_dated=$(classify "$dated_ctrl")
  echo "C_live=$c_live"
  echo "C_dated=$c_dated"
  if [ "$c_live" != "live" ] || [ "$c_dated" != "dated" ]; then
    echo "controls_honored=0"; echo "verdict=misread"; echo "census=withheld"; return 0
  fi
  echo "controls_honored=2"
  echo "controls: 2 of 2 honored - ratio released"

  all=$(mktemp); dn=$(mktemp); tx=$(mktemp); la=$(mktemp)
  trap 'rm -f "$all" "$dn" "$tx" "$la"' EXIT
  git ls-files -z | tr '\0' '\n' > "$all"
  rg "$DATED_RE" "$all" > "$dn" || true
  rg -v "$SKIP_RE" "$dn" > "$tx" || true
  header_files "$tx" > "$la"

  # One awk pass: DN (dated-named) and LA (living-header rescue) are sets; a file is
  # dated when it is in DN and not in LA. Tally globals and per-room, then emit rows.
  awk -v dnf="$dn" -v laf="$la" '
    BEGIN {
      while ((getline line < dnf) > 0) DN[line] = 1
      while ((getline line < laf) > 0) LA[line] = 1
    }
    {
      f = $0
      s = index(f, "/")
      room = (s > 0) ? substr(f, 1, s - 1) : "(root)"
      total[room]++; ntotal++
      is_dated = (f in DN) && !(f in LA)
      if (is_dated) { dated[room]++; ndated++ } else { live[room]++; nlive++ }
    }
    END {
      health = (ntotal > 0) ? sprintf("%.0f", 100.0 * nlive / ntotal) : 0
      printf "tracked_total=%d\n", ntotal
      printf "dated_testimony=%d\n", ndated
      printf "dated_definition=living-vs-dated\n"
      printf "live_surface=%d\n", nlive
      printf "fascia_health=%s\n", health
      printf "shred=RED\n"
      for (r in total) {
        if (dated[r] > 0) {
          pct = (total[r] > 0) ? 100.0 * live[r] / total[r] : 0.0
          printf "%.10f\t%s\t%d\t%d\t%d\n", pct, r, live[r], dated[r], total[r] > "/dev/stderr"
        }
      }
    }
  ' "$all" 2> "$tx.rows"
  # Sort rooms by live-pct ascending, then room name; format each to four lines.
  sort -t "$(printf '\t')" -k1,1g -k2,2 "$tx.rows" | awk -F '\t' '{
    printf "room_%s_live_pct=%.1f\n", $2, $1
    printf "room_%s_live=%d\n", $2, $3
    printf "room_%s_dated=%d\n", $2, $4
    printf "room_%s_total=%d\n", $2, $5
  }'
  rm -f "$tx.rows"
  echo "verdict=ok"
}

# shed <cited> <orphan> <citer> — the orphan-floor census behind the C1/C2 controls,
# reproducing the elder shed_census_scan.sh Python block. A dated file is an orphan when
# its basename is cited in no tracked text file (self-mention counts). The count is a
# FLOOR that errs toward keeping. Rooms are listed by orphan count, ties by first sight.
shed() {
  cited="$1"; orphan="$2"; citer="$3"
  all=$(mktemp); dn=$(mktemp); dtx=$(mktemp); resc=$(mktemp); dtr=$(mktemp)
  dbn=$(mktemp); tf=$(mktemp); ment=$(mktemp); orph=$(mktemp)
  trap 'rm -f "$all" "$dn" "$dtx" "$resc" "$dtr" "$dbn" "$tf" "$ment" "$orph"' EXIT
  git ls-files -z | tr '\0' '\n' > "$all"
  total=$(grep -c '' "$all")
  # true dated = dated-named, minus files rescued by a living header (like classify)
  rg "$DATED_RE" "$all" > "$dn" || true
  rg -v "$SKIP_RE" "$dn" > "$dtx" || true
  while IFS= read -r f; do has_header "$f" && printf '%s\n' "$f"; done < "$dtx" > "$resc"
  awk 'NR==FNR{r[$0]=1;next}!($0 in r)' "$resc" "$dn" > "$dtr"
  dated_ct=$(grep -c '' "$dtr")
  # mention floor: which dated basenames appear anywhere in tracked text content
  sed 's#.*/##' "$dtr" | sort -u > "$dbn"
  rg -v "$SKIP_RE" "$all" > "$tf" || true
  xargs -a "$tf" -d '\n' rg -F -o -I -N --no-filename -f "$dbn" 2>/dev/null | sort -u > "$ment"
  awk -F/ 'NR==FNR{m[$0]=1;next}{b=$0;sub(/.*\//,"",b); if(!(b in m)) print $0}' "$ment" "$dtr" > "$orph"
  orph_ct=$(grep -c '' "$orph")

  cited_base=$(basename "$cited"); orphan_base=$(basename "$orphan")
  if grep -qxF "$cited_base" "$ment"; then c1=REFERENCED; else c1=ORPHAN; fi
  if grep -qxF "$orphan_base" "$ment"; then c2=REFERENCED; else c2=ORPHAN; fi
  echo "C1=$c1"; echo "C2=$c2"; echo "citer_tracked=yes"
  echo "cited_path=$cited"; echo "orphan_path=$orphan"
  if [ "$c1" != REFERENCED ]; then echo "controls_honored=0"; echo "verdict=misread"; echo "census=withheld"; return 0; fi
  if [ "$c2" != ORPHAN ]; then echo "controls_honored=0"; echo "verdict=misread"; echo "census=withheld"; return 0; fi
  echo "controls_honored=2"; echo "controls: 2 of 2 honored - census released"
  echo "tracked_total=$total"; echo "dated_testimony=$dated_ct"
  echo "dated_definition=living-vs-dated"; echo "orphaned=$orph_ct"
  share=$(awk -v o="$orph_ct" -v d="$dated_ct" 'BEGIN{ if(d==0){print 0}else{printf "%.0f", 100.0*o/d} }')
  echo "orphan_share_of_dated=${share}%"
  health=$(awk -v o="$orph_ct" -v d="$dated_ct" 'BEGIN{ s=(d==0)?0:100.0*o/d; r=sprintf("%.0f",100-(59.0/18.0)*s)+0; if(r<0)r=0; if(r>100)r=100; print r }')
  hif=$(awk -v h="$health" 'BEGIN{ v=h+10; if(v>100)v=100; print v }')
  echo "fascia_health_now=$health"; echo "fascia_health_if_orphans_shed=$hif"; echo "shred=RED"
  awk -F/ '{ r=($0 ~ /\//)?$1:"(root)"; if(!(r in seen)){seen[r]=1; order[++n]=r} cnt[r]++ }
    END{ for(i=1;i<=n;i++) printf "%d\t%s\n", cnt[order[i]], order[i] }' "$orph" \
    | sort -s -k1,1rn | awk -F'\t' '{ print "room_" $2 "=" $1 }'
  echo "verdict=ok"
}

cmd="${1:-}"
case "$cmd" in
  classify) [ $# -ge 2 ] || { echo "usage: dated_classify_seam.sh classify <path>" >&2; exit 2; }; classify "$2" ;;
  census)   census ;;
  health)   [ $# -ge 3 ] || { echo "usage: dated_classify_seam.sh health <live> <dated>" >&2; exit 2; }; health "$2" "$3" ;;
  shed)     [ $# -ge 4 ] || { echo "usage: dated_classify_seam.sh shed <cited> <orphan> <citer>" >&2; exit 2; }; shed "$2" "$3" "$4" ;;
  *)        echo "usage: dated_classify_seam.sh classify <path> | census | health <live> <dated> | shed <cited> <orphan> <citer>" >&2; exit 2 ;;
esac
