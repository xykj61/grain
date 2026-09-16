#!/bin/sh
# tools/fixtures/a/awk_lcg_exact_control.sh -- the pen for awk_lcg_exact_scan.sh.
#
# Every leg runs the scan inside a real git repository built in a throwaway pen, where the answer
# is known before the scan is asked. Each refusal is planted and then LIFTED, because a refusal
# proven only in the planting direction cannot be told from a reading that always refuses.
#
# Three mutations are planted and each is asserted to bite: FEEDBACK, which decides whether a
# multiply-then-mod site is a generator or an index hash; COMMENT, which keeps the scan from
# counting its own prose; and MARGIN, the tenth-of-a-percent band that makes a borderline site
# fail toward refusal.
#
# The borderline numbers are chosen rather than found. Against a modulus of 2^32 the exact ratio
# is 2^53 / (2^32 - 1) = 2,097,152.0005, so a multiplier of 2,096,000 sits inside the band and
# outside the ratio -- refused with MARGIN on, welcomed with it off. No site in the living tree
# is within a factor of two of that band, which is why the case has to be built.
set -u

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
SCAN="$ROOT/tools/fixtures/a/awk_lcg_exact_scan.sh"
legs=0
fails=0

PEN=$(mktemp -d "${TMPDIR:-/tmp}/awk-lcg-exact-control.XXXXXX") || exit 1
cleanup() { [ -n "${PEN:-}" ] && [ -d "$PEN" ] && rm -rf "$PEN"; }
trap cleanup EXIT INT TERM HUP

leg() {
  name=$1; want=$2; got=$3
  legs=$((legs + 1))
  if [ "$want" = "$got" ]; then
    echo "leg $name ok"
  else
    fails=$((fails + 1))
    echo "leg $name FAILED want=$want got=$got"
  fi
}

key() { printf '%s\n' "$1" | grep -m1 "^$2=" | cut -d= -f2-; }

# ---- the scan stands -------------------------------------------------------------------------
[ -f "$SCAN" ] && leg scan_present yes yes || leg scan_present yes no
[ -x "$SCAN" ] && leg scan_executable yes yes || leg scan_executable yes no

# ---- the living tree -------------------------------------------------------------------------
LIVE=$(sh "$SCAN" 2>&1); live_status=$?
leg live_exits_zero 0 "$live_status"
leg live_verdict exact "$(key "$LIVE" verdict)"
leg live_overflowing 0 "$(key "$LIVE" overflowing)"
leg live_ceiling 0 "$(key "$LIVE" ceiling)"
leg live_exact_range 9007199254740992 "$(key "$LIVE" exact_range)"
[ "$(key "$LIVE" fedback)" -ge 5 ] && leg live_reads_generators yes yes || leg live_reads_generators yes no
[ "$(key "$LIVE" unread)" -ge 1 ] && leg live_names_blind_spot yes yes || leg live_names_blind_spot yes no
LIVELIST=$(sh "$SCAN" --list 2>&1)
printf '%s\n' "$LIVELIST" | grep -q '^exact ' && leg live_list_prints_exact yes yes || leg live_list_prints_exact yes no
printf '%s\n' "$LIVELIST" | grep -q '^unread ' && leg live_list_prints_unread yes yes || leg live_list_prints_unread yes no
sh "$SCAN" --bogus >/dev/null 2>&1 && leg bad_flag_refuses no yes || leg bad_flag_refuses no no

# ---- THIS CONTROL CONTRIBUTES NOTHING TO THE LIVING READING -------------------------------------
# The property the assembled plants above exist for, asserted rather than trusted. This file is a
# tracked `.sh` source and therefore inside the scan's own population, so a plant spelled literally
# here would be a live site. These four legs fail the moment a later hand writes one back in --
# which is the whole reason the numerals are variables, and a reason that is worth nothing unheard.
printf '%s\n' "$LIVELIST" | grep -q 'awk_lcg_exact_control' && leg self_absent_from_sites no yes || leg self_absent_from_sites no no
SELF_HITS=$(printf '%s\n' "$LIVELIST" | grep -c 'awk_lcg_exact_control' || true)
leg self_site_count 0 "$SELF_HITS"
# and the scan's own source is equally inside its population, for the same reason
printf '%s\n' "$LIVELIST" | grep -q 'awk_lcg_exact_scan' && leg scan_self_absent no yes || leg scan_self_absent no no
# the living tree reads the same whether or not this control is staged, which is the claim itself
leg live_still_exact exact "$(key "$LIVE" verdict)"


# ---- the pen ---------------------------------------------------------------------------------
REPO="$PEN/repo"
mkdir -p "$REPO/tools/fixtures/z"
cd "$REPO" || exit 1
git init -q .
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false

# THE PLANTS ARE ASSEMBLED RATHER THAN SPELLED, and the reason is this control's own subject.
# The scan reads every tracked `.sh` and `.rish` source, and this file is one -- so a plant written
# literally here is a live site in the tree the moment this control is tracked. Measured
# `20260916.185000`, the lap this control landed: staging it took the live reading from
# `overflowing=0 exact=7 unread=17` to `overflowing=5 exact=8 unread=18`, and the wall reddened on
# five generators that exist only to be refused inside a pen.
#
# That is REDS %775's shape one instrument over -- a plant is a sentence that must not be true, and
# a meter reading for truth cannot tell one from a claim. The repair is the same one that row chose:
# MOVE THE PLANT, not the meter. Widening the scan to read past `tools/fixtures/` would be the
# exclusion %774 warned about, where a census stops measuring its own subject to make a number
# smaller; excluding this file by name would leave the next control to rediscover all of it.
#
# So the numerals live in shell variables and the heredocs below are UNQUOTED, which expands them as
# each pen file is written. The pen receives the literal arithmetic and every leg proves exactly what
# it proved before; the tracked bytes of this file carry no `variable * digits % digits` shape at all,
# so the live reading does not move when this control is staged. The scan's regex requires digits on
# both sides, which is what makes a substituted numeral invisible to it -- and that is a property of
# the scan's own pattern rather than a trick, so a later hand widening the pattern to accept a shell
# variable must move these plants again and will find this paragraph saying so.
G_MUL=1103515245     # the glibc multiplier: times 2^31 it reaches 2.37e18, 263x past 2^53
G_MOD=2147483648     # 2^31
M_MUL=48271          # MINSTD: times 2^31-1 it reaches 1.04e14, inside the range
M_MOD=2147483647     # 2^31 - 1
B_MUL=2096000        # a multiplier inside the borderline band against 2^32, outside the ratio
B_MOD=4294967296     # 2^32
G_INC=12345

safe() {
  cat > "$REPO/tools/fixtures/z/safe.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ s = 7; for (i = 0; i < 4; i++) { s = (s * $M_MUL) % $M_MOD; print s } }'
EOS
}
safe
git add -A >/dev/null 2>&1
git commit -qm pen >/dev/null 2>&1

run() { sh "$SCAN" "$@" 2>&1; }

# clean: one exact generator, nothing else
OUT=$(run); st=$?
leg pen_clean_exits_zero 0 "$st"
leg pen_clean_verdict exact "$(key "$OUT" verdict)"
leg pen_clean_exact 1 "$(key "$OUT" exact)"
leg pen_clean_fedback 1 "$(key "$OUT" fedback)"
leg pen_clean_overflowing 0 "$(key "$OUT" overflowing)"
leg pen_clean_unread 0 "$(key "$OUT" unread)"

# planted: a fed-back site past the exact range
cat > "$REPO/tools/fixtures/z/over.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ x = 1; x = (x * $G_MUL + $G_INC) % $G_MOD; print x }'
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg planted_over_refuses 1 "$st"
leg planted_over_verdict rounded "$(key "$OUT" verdict)"
leg planted_over_count 1 "$(key "$OUT" overflowing)"
printf '%s\n' "$OUT" | grep -q 'product_over_exact_range=past' && leg planted_over_says_past yes yes || leg planted_over_says_past yes no
printf '%s\n' "$OUT" | grep -q 'over\.sh:2' && leg planted_over_names_line yes yes || leg planted_over_names_line yes no
rm -f "$REPO/tools/fixtures/z/over.sh"; git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg lifted_over_exits_zero 0 "$st"
leg lifted_over_count 0 "$(key "$OUT" overflowing)"

# planted: an INDEX hash, not a generator -- unread, never gated
cat > "$REPO/tools/fixtures/z/hash.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ for (i = 0; i < 4; i++) { h = (i * $G_MUL) % $G_MOD; print h } }'
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg index_hash_exits_zero 0 "$st"
leg index_hash_unread 1 "$(key "$OUT" unread)"
leg index_hash_not_gated 0 "$(key "$OUT" overflowing)"

# MUTATION FEEDBACK -- with the fed-back test off, that index hash reads as a generator and reds
sed 's/^FEEDBACK=on$/FEEDBACK=off/' "$SCAN" > "$PEN/mut_feedback.sh"
grep -q '^FEEDBACK=off$' "$PEN/mut_feedback.sh" && leg mutation_feedback_applied yes yes || leg mutation_feedback_applied yes no
MOUT=$(sh "$PEN/mut_feedback.sh" 2>&1); mst=$?
leg mutation_feedback_bites 1 "$mst"
[ "$(key "$MOUT" overflowing)" -ge 1 ] && leg mutation_feedback_counts yes yes || leg mutation_feedback_counts yes no
rm -f "$REPO/tools/fixtures/z/hash.sh"; git add -A >/dev/null 2>&1

# planted: the same fault inside a COMMENT -- read past
cat > "$REPO/tools/fixtures/z/prose.sh" <<'EOS'
#!/bin/sh
# teaching line: s = (s * 1103515245 + 12345) % 2147483648 rounds in a double
echo teaching
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg comment_exits_zero 0 "$st"
leg comment_not_counted 0 "$(key "$OUT" overflowing)"
leg comment_not_in_sites 1 "$(key "$OUT" sites_read)"

# MUTATION COMMENT -- with the read-past off, the prose counts and reds
sed 's/^COMMENT=on$/COMMENT=off/' "$SCAN" > "$PEN/mut_comment.sh"
grep -q '^COMMENT=off$' "$PEN/mut_comment.sh" && leg mutation_comment_applied yes yes || leg mutation_comment_applied yes no
MOUT=$(sh "$PEN/mut_comment.sh" 2>&1); mst=$?
leg mutation_comment_bites 1 "$mst"
leg mutation_comment_counts 1 "$(key "$MOUT" overflowing)"
rm -f "$REPO/tools/fixtures/z/prose.sh"; git add -A >/dev/null 2>&1

# planted: a BORDERLINE multiplier -- inside the band, outside the ratio
cat > "$REPO/tools/fixtures/z/edge.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ b = 1; b = (b * $B_MUL) % $B_MOD; print b }'
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg borderline_refuses 1 "$st"
leg borderline_count 1 "$(key "$OUT" overflowing)"
printf '%s\n' "$OUT" | grep -q 'product_over_exact_range=borderline' && leg borderline_says_borderline yes yes || leg borderline_says_borderline yes no

# MUTATION MARGIN -- with the band off, the same multiplier walks free
sed 's/^MARGIN=on$/MARGIN=off/' "$SCAN" > "$PEN/mut_margin.sh"
grep -q '^MARGIN=off$' "$PEN/mut_margin.sh" && leg mutation_margin_applied yes yes || leg mutation_margin_applied yes no
MOUT=$(sh "$PEN/mut_margin.sh" 2>&1); mst=$?
leg mutation_margin_bites 0 "$mst"
leg mutation_margin_welcomes 0 "$(key "$MOUT" overflowing)"
leg mutation_margin_keeps_exact 2 "$(key "$MOUT" exact)"
rm -f "$REPO/tools/fixtures/z/edge.sh"; git add -A >/dev/null 2>&1

# a modulus of 2 and a multiplier of 1 are arithmetic rather than a generator, and read past
cat > "$REPO/tools/fixtures/z/tiny.sh" <<'EOS'
#!/bin/sh
awk 'BEGIN{ p = 5; p = (p * 1) % 2; print p }'
EOS
git add -A >/dev/null 2>&1
OUT=$(run)
leg tiny_read_past 1 "$(key "$OUT" sites_read)"
rm -f "$REPO/tools/fixtures/z/tiny.sh"; git add -A >/dev/null 2>&1

# an untracked file is outside the population -- the scan reads the index, never the directory
cat > "$REPO/tools/fixtures/z/untracked.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ u = 1; u = (u * $G_MUL) % $G_MOD; print u }'
EOS
OUT=$(run); st=$?
leg untracked_outside_population 0 "$(key "$OUT" overflowing)"
leg untracked_exits_zero 0 "$st"
rm -f "$REPO/tools/fixtures/z/untracked.sh"

# a vendored source is not ours to move, and stands outside the population
mkdir -p "$REPO/vendor/x"
cat > "$REPO/vendor/x/v.sh" <<EOS
#!/bin/sh
awk 'BEGIN{ v = 1; v = (v * $G_MUL) % $G_MOD; print v }'
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg vendored_outside_population 0 "$(key "$OUT" overflowing)"
leg vendored_exits_zero 0 "$st"

# a Rishi source reaches for awk too, and is read alongside shell
cat > "$REPO/tools/fixtures/z/r.rish" <<EOS
let out = run ["awk" "BEGIN{ r = 1; r = (r * $G_MUL) % $G_MOD; print r }"]
EOS
git add -A >/dev/null 2>&1
OUT=$(run); st=$?
leg rishi_in_population 1 "$(key "$OUT" overflowing)"
leg rishi_refuses 1 "$st"
rm -f "$REPO/tools/fixtures/z/r.rish"; git add -A >/dev/null 2>&1

# outside a git tree the scan refuses rather than reading nothing and calling it clean
OUT=$(cd "$PEN" && sh "$SCAN" 2>&1); st=$?
leg outside_repo_refuses 1 "$st"
leg outside_repo_verdict unreadable "$(key "$OUT" verdict)"

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "fail=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=failed"
exit 1
