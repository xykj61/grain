#!/bin/sh
# Commit parent-hash claim guard -- a body sentence naming THIS commit's own
# parent by hash names the true first parent.
#
# REDS %801: a follow-up body said the card's Git nib is rewritten to
# `71a556d85c` -- this commit's own parent, and the parent was `397037a129`.
# The hash went into the body BEFORE the send's final rebase; the rebase moved
# the commit, the card was repointed by the step that knows, and the body was
# not. Every standing wall welcomed it. tools/hooks/commit-msg reads PATHS and
# never objects (%202), and an object check would have welcomed this one too,
# since the pre-rebase commit resolved on the ship that wrote it -- only the
# RELATION the sentence asserts was false.
#
#   sh tools/fixtures/c/commit_parent_claim_scan.sh [--window N] [--anchor REF]
#   sh tools/fixtures/c/commit_parent_claim_scan.sh --list [--window N]
#
# THE TOKEN RULE, inherited from nib_honesty (REDS %782): hexadecimal admits the
# decimals, so a ten-character run alone cannot say whether it is a commit or a
# number, and an all-decimal LCG constant read as an advertised commit once. A
# token here runs 7 to 40 hex characters, delimited by non-alphanumerics, and
# carries at least one of a-f.
#
# THAT CLAUSE IS NOT ENOUGH, and this header said it was until the pen proved
# otherwise. `ed25519` is seven characters, every one of them hexadecimal, and
# it stands beside the word parent in every hardened-derivation body this tree
# has written -- so it IS a token by the rule above, and it is counted as one.
# What keeps it out of the gate is the RELATION filter below rather than the
# character class: nothing in those sentences says `this commit's own parent`,
# so they read loose and the wall never sees them. A token rule alone cannot
# tell a curve name from a commit.
#
# THE BINDER is sentence scope: a hash token and the word parent in one
# sentence.
#
# THE SELF FILTER is what makes a gate possible. A sentence saying "this
# commit's own parent", "HEAD's parent", or "the parent this commit lands on"
# asserts a relation about ITSELF, which git can check after the fact. Every
# other parent sentence -- a peer's parent, a key derivation's parent, a past
# fault's parent -- is reported as `loose` and never gated, because the guard
# cannot know what it is about.
#
# THE GENRES, taken in order, each covering what the one before cannot:
#
#   true        the token prefixes this commit's true first parent.
#   quoted      the sentence names ANOTHER commit by hash ("the commit `X`"), so
#               the parent relation belongs to that commit. A PROXY, named as
#               one: it over-forgives, which is the safe direction for a gate,
#               and it is what lets an erratum quote a faulty hash as testimony.
#   origin      the token sits immediately after `from`, so the sentence moves a
#               pin OFF it rather than claiming it -- the card's repair idiom,
#               "the nib moves from A to B".
#   unresolved  the token names no commit in THIS checkout. Reported, never
#               gated: a pre-rebase hash resolves on the ship that wrote it and
#               vanishes everywhere else, so resolvability is per-checkout and a
#               wall built on it answers differently on eight ships.
#   sideways    resolves here and is no ancestor of the claiming commit -- a
#               commit left on an abandoned branch.
#   false       resolves, is an ancestor, and is claimed as the parent while
#               another commit holds that place. The %801 genre proper.
#
# THE GATE IS FORWARD-ONLY. `--anchor REF` counts the three claim genres over
# the commits in REF..HEAD alone. History is testimony and is never rewritten,
# so a wall over it would red on bodies no lap may repair; a wall over what
# lands after the anchor reds on the lap the next one arrives, and welcomes
# every correct body ever written.
#
# WHAT NO HOOK CAN REACH, the structural twin of REDS %803 one rule over: at
# commit-msg time `git rev-parse HEAD` is the prospective parent for a fresh
# commit and the commit being REPLACED for an amend, and nothing the hook can
# read tells those two apart -- so a hook-side wall would refuse every correct
# amend or welcome every wrong fresh commit. This reads after the fact, where
# the parent is a fact rather than a forecast.
#
# Read-only: no network, no key, no funds, no writes to the tree.
set -eu

WINDOW=4000
ANCHOR=
LIST=no
while [ $# -gt 0 ]; do
  case $1 in
    --window) WINDOW=${2:?--window wants a count}; shift 2 ;;
    --anchor) ANCHOR=${2:?--anchor wants a ref}; shift 2 ;;
    --list)   LIST=yes; shift ;;
    *) echo "unknown argument $1" >&2; exit 2 ;;
  esac
done

case $WINDOW in (*[!0-9]*|'') echo "--window wants digits" >&2; exit 2 ;; esac
# Bound: the window is a commit count held under a named maximum, so a runaway
# argument cannot walk the whole history of a tree already past 30,000 commits.
MAX_WINDOW=50000
[ "$WINDOW" -le "$MAX_WINDOW" ] || { echo "window $WINDOW over max_window $MAX_WINDOW" >&2; exit 2; }

AFTER=
if [ -n "$ANCHOR" ]; then
  git rev-parse --verify --quiet "$ANCHOR^{commit}" >/dev/null 2>&1 || {
    echo "anchor $ANCHOR resolves to no commit here" >&2; exit 2; }
  AFTER=" $(git rev-list "$ANCHOR..HEAD" 2>/dev/null | tr '\n' ' ')"
fi

# One git log pass; the classification that needs no object lookup happens here.
git log -"$WINDOW" --format='%H%x01%P%x01%B%x02' 2>/dev/null | awk -v OFS='\t' '
BEGIN{ RS="\x02" }
NF{
  n=split($0,p,"\x01"); if(n<3) next;
  h=p[1]; sub(/^[ \t\n]+/,"",h); split(p[2],pp," "); first=pp[1]; body=p[3];
  gsub(/\n/," ",body);
  cnt=split(body,S,/[.!?][ ]+/);
  for(i=1;i<=cnt;i++){
    s=S[i];
    if (s !~ /parent/) continue;
    self = (s ~ /this commit.?s?( own)? parent/ || s ~ /its own parent/ \
         || s ~ /HEAD.?s parent/ || s ~ /the parent this/ \
         || s ~ /parent of this commit/);
    quoted = (s ~ /commit .?[0-9a-f]{7,40}/);
    t=s;
    while (match(t,/(^|[^0-9A-Za-z])[0-9a-f]{7,40}([^0-9A-Za-z]|$)/)) {
      lead=substr(t,1,RSTART+RLENGTH-1);
      tok=substr(t,RSTART,RLENGTH); gsub(/[^0-9a-f]/,"",tok);
      t=substr(t,RSTART+RLENGTH-1);
      if (tok !~ /[a-f]/) continue;
      origin = (lead ~ /from .?[0-9a-f]{7,40}.?$/);
      g = self ? (index(first,tok)==1 ? "true" : (quoted ? "quoted" : (origin ? "origin" : "undecided"))) : "loose";
      print g, h, tok, first, substr(s,1,140);
    }
  }
}' > "${TMPDIR:-/tmp}/cpc.$$" || { rm -f "${TMPDIR:-/tmp}/cpc.$$"; exit 1; }
SEGFILE="${TMPDIR:-/tmp}/cpc.$$"
trap 'rm -f "$SEGFILE"' EXIT INT TERM

# The three claim genres need one object lookup apiece, and only the undecided
# rows reach them -- ten rows in four thousand commits, rather than one git call
# per token.
UNRES=0; SIDE=0; FALSE=0
UNRES_A=0; SIDE_A=0; FALSE_A=0
LISTED=
while IFS='	' read -r g h tok first sent; do
  [ "$g" = undecided ] || continue
  if git rev-parse --verify --quiet "$tok^{commit}" >/dev/null 2>&1; then
    if git merge-base --is-ancestor "$tok" "$h" 2>/dev/null; then v=false; else v=sideways; fi
  else v=unresolved; fi
  case $v in
    unresolved) UNRES=$((UNRES+1)) ;;
    sideways)   SIDE=$((SIDE+1)) ;;
    false)      FALSE=$((FALSE+1)) ;;
  esac
  if [ -n "$AFTER" ]; then
    case $AFTER in (*" $h "*)
      case $v in
        unresolved) UNRES_A=$((UNRES_A+1)) ;;
        sideways)   SIDE_A=$((SIDE_A+1)) ;;
        false)      FALSE_A=$((FALSE_A+1)) ;;
      esac ;;
    esac
  fi
  [ "$LIST" = yes ] && LISTED="$LISTED$v $(echo "$h" | cut -c1-10) tok=$tok parent=$(echo "$first" | cut -c1-10) :: $sent
"
done < "$SEGFILE"

awk -F'\t' '
{ seg++; c[$1]++ }
END{
  printf "segments=%d\n", seg+0;
  printf "loose=%d\n", c["loose"]+0;
  printf "self=%d\n", seg-c["loose"];
  printf "self_true=%d\n", c["true"]+0;
  printf "self_quoted=%d\n", c["quoted"]+0;
  printf "self_origin=%d\n", c["origin"]+0;
  printf "self_undecided=%d\n", c["undecided"]+0;
}' "$SEGFILE"
echo "window=$WINDOW"
echo "unresolved=$UNRES"
echo "sideways=$SIDE"
echo "false=$FALSE"
if [ -n "$ANCHOR" ]; then
  echo "anchor=$(git rev-parse --short=10 "$ANCHOR")"
  echo "anchored_commits=$(git rev-list --count "$ANCHOR..HEAD")"
  echo "unresolved_after_anchor=$UNRES_A"
  echo "sideways_after_anchor=$SIDE_A"
  echo "false_after_anchor=$FALSE_A"
  echo "claims_after_anchor=$((UNRES_A+SIDE_A+FALSE_A))"
else
  echo "anchor=none"
fi
[ "$LIST" = yes ] && printf '%s' "$LISTED"
echo "verdict=read"
