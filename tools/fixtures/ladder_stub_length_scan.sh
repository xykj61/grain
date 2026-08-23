#!/bin/sh
# tools/fixtures/ladder_stub_length_scan.sh -- the stub is measured, never described.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# REDS %128 booked this guard and never built it. A lift moves one byte-identical
# function body into caravan/ladder_checks.rye and leaves a DELEGATING STUB in
# every rung that calls it -- the signature, one return statement, the closing
# brace. The realized fall of a lift is (copies - 1) x (lines - stub), so the
# stub length is load-bearing arithmetic, and it is the one quantity of the whole
# arc that a hand ever typed from a glance at a diff. It was typed wrong once,
# published as "one-line stub" across a session log, an index row, and the
# operator card, and rode a signed commit to both remotes.
#
# So this scan reads the stub off disk and holds every living surface to it.
#
#   MEASURE: for each `return ladder_checks.X(...)` in caravan/*.rye, span the
#   enclosing function. A PURE STUB is one whose whole body is that single
#   return. The reported minimum is the shape a lift actually writes, and it is
#   a real measurement rather than a definition -- a stub that grew an invariant
#   comment or a multi-line signature moves the minimum, and the claim beside it
#   goes stale on that lap rather than a season later.
#
#   CHECK: every living surface that names a stub length in words must name the
#   measured one. The standing surface is construction/REMEMBER.md, the card that speaks
#   as NOW. Dated testimony is out of scope by the line the tree already draws --
#   a file whose own basename carries a one-clock stamp is testimony and is never
#   rewritten (.claude/rules/stamp-and-name.md) -- and session-logs/README.md is
#   that testimony's face, one row per dated lap, so its rows record what was
#   true on their own day. Two of them truthfully describe a FIVE-line stub from
#   the `link` arc of 20260820, a shape whose 612 stubs have since left the
#   ladder entirely. Holding a chronological index to today's disk would red on
#   true history forever, and a guard nobody can keep green teaches the bench to
#   route around it. Name another surface as an argument to widen the check.
#
# A lap that describes no stub is an honest lap, so `claims=0` answers ok. The
# count is printed either way, so a reader sees how much was actually checked
# rather than reading a GREEN that covered nothing.
set -eu

src_dir="caravan"
default_claims="construction/REMEMBER.md"

# prove-red: two generated controls, so both refusal paths are proven on metal
# without ever mutating the living surfaces the guard protects.
if [ "${1:-}" = "prove-red" ]; then
  fails=0
  ctl=$(mktemp)
  trap 'rm -f "$ctl"' EXIT

  printf 'the rung calls it through a one-line stub, so the fall is 39 x 19.\n' >"$ctl"
  out=$(sh "$0" "$ctl" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-drift: /'
  case "$out" in
    *verdict=stub_claim_drift*) echo "RED_stub_claim_drift_caught" ;;
    *) echo "verdict=prove_red_failed_to_refuse_drift"; fails=1 ;;
  esac

  empty=$(mktemp -d)
  trap 'rm -f "$ctl"; rm -rf "$empty"' EXIT
  out=$(SRC_DIR="$empty" sh "$0" "$ctl" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-blind: /'
  case "$out" in
    *verdict=no_stubs*) echo "RED_no_stubs_refused_rather_than_ok" ;;
    *) echo "verdict=prove_red_failed_to_refuse_blindness"; fails=1 ;;
  esac

  # A harness swept in with its own rungs, planted on a throwaway ladder so the
  # living one is never touched.
  eaten=$(mktemp -d)
  trap 'rm -f "$ctl"; rm -rf "$empty"; rm -rf "$eaten"' EXIT
  cat >"$eaten/ladder_checks.rye" <<'EOF'
pub fn weigh_the_answer(io: std.Io, report_out: *Report) !void {
    return ladder_checks.weigh_the_answer(@This(), io, report_out);
}
EOF
  out=$(SRC_DIR="$eaten" sh "$0" "$ctl" 2>&1) || true
  printf '%s\n' "$out" | sed 's/^/control-eaten: /'
  case "$out" in
    *verdict=harness_delegates_to_itself*) echo "RED_harness_self_delegation_caught" ;;
    *) echo "verdict=prove_red_failed_to_refuse_eaten_harness"; fails=1 ;;
  esac

  [ "$fails" -eq 0 ] || exit 2
  exit 1
fi

src_dir="${SRC_DIR:-$src_dir}"
[ -d "$src_dir" ] || { echo "verdict=missing_source"; exit 2; }

# The harness never delegates to itself. A lift rewrites every rung that wrote a
# family's body into a stub calling caravan/ladder_checks.rye, and the harness
# lives in that same directory -- so a glob over caravan/*.rye sweeps the harness
# in with the rungs and replaces the body it just received with a stub calling
# itself. That has happened three times in this arc, caught by hand each time and
# recorded twice in a log without ever becoming a check (REDS %132). It is
# unambiguous on disk and free to read, so it is a check now.
harness="$src_dir/ladder_checks.rye"
if [ -f "$harness" ] && grep -q '^[[:space:]]*return ladder_checks\.' "$harness"; then
  echo "detail: $harness delegates to itself -- a lift's stub loop swept the harness in with its rungs"
  echo "verdict=harness_delegates_to_itself"
  exit 1
fi

# Measure every delegating stub, and report the minimum span and the pure count.
measured=$(
  for f in "$src_dir"/*.rye; do
    [ -f "$f" ] || continue
    case "$f" in */ladder_checks.rye) continue ;; esac
    awk '
      { line[NR] = $0 }
      END {
        for (i = 1; i <= NR; i++) {
          if (line[i] !~ /^[[:space:]]*return ladder_checks\./) continue
          s = i; while (s > 1 && line[s] !~ /^(pub )?fn /) s--
          e = i; while (e < NR && line[e] !~ /^\}$/) e++
          # A pure stub carries exactly one body line: the delegating return.
          if (e - s == 2) print e - s + 1
        }
      }
    ' "$f"
  done
)

pure=$(printf '%s' "$measured" | grep -c . || true)
if [ "${pure:-0}" -eq 0 ]; then
  echo "pure_stubs=0"
  echo "detail: no delegating stub found under $src_dir -- the scan can prove nothing"
  echo "verdict=no_stubs"
  exit 1
fi
stub_lines=$(printf '%s\n' "$measured" | sort -n | head -1)

echo "pure_stubs=$pure"
echo "stub_lines=$stub_lines"

# Hold every living claim to the measurement.
claims=0
drift=0
# Take the named surfaces when given, otherwise the standing one. A quoted
# "${@:-$default}" would collapse two paths into one word and read neither,
# answering claims=0 while the card said otherwise -- the exact shape of
# blindness this scan exists to refuse.
[ "$#" -gt 0 ] || set -- $default_claims
for f in "$@"; do
  [ -f "$f" ] || continue
  while IFS= read -r line; do
    case "$line" in
      *one-line\ stub*|*two-line\ stub*|*three-line\ stub*|*four-line\ stub*|*five-line\ stub*) : ;;
      *) continue ;;
    esac
    for word in one two three four five; do
      case "$line" in *"$word-line stub"*) : ;; *) continue ;; esac
      claims=$((claims + 1))
      case "$word" in
        one) n=1 ;; two) n=2 ;; three) n=3 ;; four) n=4 ;; five) n=5 ;;
      esac
      if [ "$n" -ne "$stub_lines" ]; then
        echo "detail: $f says $word-line stub, disk measures $stub_lines -> $(printf '%s' "$line" | cut -c1-58)"
        drift=$((drift + 1))
      fi
    done
  done < "$f"
done

echo "claims=$claims"
echo "claims_adrift=$drift"
if [ "$drift" -ne 0 ]; then echo "verdict=stub_claim_drift"; exit 1; fi
echo "verdict=ok"
exit 0
