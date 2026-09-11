#!/bin/sh
# tools/fixtures/l/law_tool_citation_control.sh -- proves the citation reading from both sides.
#
# A refusal shown only in the passing direction cannot be told from a bypass, so every plant here
# is counted while it stands and read back to zero once it is lifted. Each pen is a real git
# repository in a throwaway directory, because the reading is about what the REPOSITORY carries
# rather than about what this machine happens to hold on disk -- and one case plants exactly that
# difference.
#
# USAGE
#   sh tools/fixtures/l/law_tool_citation_control.sh
#
# Driven by tools/l/law_tool_citation_witness.rish. Run from the repository root.

set -u

SCAN=$(cd "$(dirname "$0")" && pwd)/law_tool_citation_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=absent"; echo "control_failures=1"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/law-tool-citation-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

fails=0
cases=0
note() { printf '%s=%s\n' "$1" "$2"; cases=$((cases + 1)); [ "$2" = yes ] || fails=$((fails + 1)); }
yn() { if [ "$1" -eq 0 ]; then echo yes; else echo no; fi; }
has() { echo "$1" | grep -q "$2" && echo yes || echo no; }

# A pen is its own tree root, holding a law room, a twin room, a roster, and two real tools.
mkpen() {
  d="$PEN/$1"; rm -rf "$d"
  mkdir -p "$d/.claude/rules" "$d/.cursor/rules" "$d/construction" "$d/tools/o" "$d/tools/hooks"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name pen \
    && git config commit.gpgsign false ) >/dev/null 2>&1
  printf 'x\n' > "$d/tools/o/one_witness.rish"
  printf 'x\n' > "$d/tools/o/two.sh"
  printf 'x\n' > "$d/tools/hooks/commit-msg"
  printf 'guard one\npath tools/o/one_witness.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
  printf '# twin\n\nSee `tools/o/two.sh`.\n' > "$d/.cursor/rules/a.mdc"
  echo "$d"
}
seal() { ( cd "$1" && git add -A >/dev/null 2>&1 && git commit -qm pen >/dev/null 2>&1 ); }
run()  { ( cd "$1" && sh "$SCAN" ) 2>&1; }

# --- a room whose every cited path the repository carries -------------------------------------
d=$(mkpen clean)
printf '# a\n\nRun `tools/o/one_witness.rish`, and read [`tools/o/two.sh`](../../tools/o/two.sh).\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note clean_free "$(yn $rc)"
note clean_verdict_ok "$(has "$out" '^verdict=ok$')"
note clean_untracked_zero "$(has "$out" '^cited_untracked=0$')"
note clean_counted_exactly "$(has "$out" '^cited_paths=2$')"
note clean_pages_counted "$(has "$out" '^law_pages=1$')"

# --- a law page naming a tool the repository does not carry -----------------------------------
d=$(mkpen ghost)
printf '# a\n\nGated by `tools/o/ghost_witness.rish`, and `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note ghost_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note ghost_counted "$(has "$out" '^cited_untracked=1$')"
note ghost_named "$(has "$out" '^untracked: tools/o/ghost_witness.rish$')"
note ghost_verdict "$(has "$out" '^verdict=citation_absent$')"
printf '# a\n\nGated by `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note ghost_lifted_zero "$(has "$out" '^cited_untracked=0$')"
note ghost_lifted_free "$(yn $rc)"

# --- on disk, and not in the repository: the reading a filesystem test would pass --------------
d=$(mkpen ondisk)
printf '# a\n\nHeld by `tools/o/loose_witness.rish`.\n' > "$d/.claude/rules/a.md"
seal "$d"
printf 'x\n' > "$d/tools/o/loose_witness.rish"
out=$(run "$d"); rc=$?
note ondisk_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note ondisk_counted "$(has "$out" '^cited_untracked=1$')"
( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm track >/dev/null 2>&1 )
out=$(run "$d")
note ondisk_tracked_zero "$(has "$out" '^cited_untracked=0$')"

# --- bare and linked, counted apart ------------------------------------------------------------
d=$(mkpen bare)
printf '# a\n\nRun `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d")
note bare_counted "$(has "$out" '^cited_bare=1$')"
printf '# a\n\nRun [`tools/o/one_witness.rish`](../../tools/o/one_witness.rish).\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d")
note linked_reads_zero_bare "$(has "$out" '^cited_bare=0$')"

# --- what promises no file is read past --------------------------------------------------------
d=$(mkpen past)
printf '# a\n\nThe rooms `tools/ca` and `tools/rye`, the gitignored `tools/.build`, and the host\ncopy `tools/o/two.sh.example`. Real: `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note roomname_read_past "$(yn $rc)"
note roomname_counted_one "$(has "$out" '^cited_paths=1$')"

# --- a path at the end of a sentence keeps its extension ---------------------------------------
d=$(mkpen punct)
printf '# a\n\nThe guard is tools/o/one_witness.rish. It stands.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note sentence_end_counted "$(has "$out" '^cited_paths=1$')"
note sentence_end_free "$(yn $rc)"

# --- an extensionless hook is a file, and its absence is a fault -------------------------------
d=$(mkpen hook)
printf '# a\n\nEnforced at write time by `tools/hooks/commit-msg`, armed beside `tools/hooks/pre-push`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note hook_counted "$(has "$out" '^cited_paths=2$')"
note hook_absent_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note hook_absent_named "$(has "$out" '^untracked: tools/hooks/pre-push$')"
printf 'x\n' > "$d/tools/hooks/pre-push"
seal "$d"; out=$(run "$d"); rc=$?
note hook_present_free "$(yn $rc)"

# --- a cited runner no roster carries: counted, named, and never gated --------------------------
d=$(mkpen unrostered)
printf '# a\n\nRun `tools/o/one_witness.rish` and `tools/o/three_witness.rish`.\n' > "$d/.claude/rules/a.md"
printf 'x\n' > "$d/tools/o/three_witness.rish"
seal "$d"; out=$(run "$d"); rc=$?
note unrostered_free "$(yn $rc)"
note unrostered_counted "$(has "$out" '^runners_unrostered=1$')"
note unrostered_named "$(has "$out" '^unrostered: tools/o/three_witness.rish$')"
note runners_counted "$(has "$out" '^cited_runners=2$')"
printf 'guard one\npath tools/o/one_witness.rish\ntier lap\n\nguard three\npath tools/o/three_witness.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
seal "$d"; out=$(run "$d")
note unrostered_lifted_zero "$(has "$out" '^runners_unrostered=0$')"

# --- an absent roster cannot answer, and must not answer zero ----------------------------------
d=$(mkpen noroster)
printf '# a\n\nRun `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
rm -f "$d/construction/standing-equipment.kyri"
seal "$d"; out=$(run "$d"); rc=$?
note noroster_free "$(yn $rc)"
note noroster_unread "$(has "$out" '^runners_unrostered=unread$')"

# --- the twin room is read and reported, and it gates nothing ----------------------------------
d=$(mkpen twin)
printf '# a\n\nRun `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
printf '# twin\n\nRun `tools/o/ghost_witness.rish`.\n' > "$d/.cursor/rules/a.mdc"
seal "$d"; out=$(run "$d"); rc=$?
note twin_free "$(yn $rc)"
note twin_counted "$(has "$out" '^twin_cited_untracked=1$')"
note twin_pages_counted "$(has "$out" '^twin_pages=1$')"

# --- a room that names nothing, and a room that is not there -----------------------------------
d=$(mkpen silent)
printf '# a\n\nNo tool is named here.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note silent_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note silent_verdict "$(has "$out" '^verdict=no_citations$')"

d=$(mkpen empty)
rm -rf "$d/.claude/rules"
seal "$d"; out=$(run "$d"); rc=$?
note empty_room_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note empty_room_verdict "$(has "$out" '^verdict=law_room_empty$')"

# --- a room path the repository carries, and one it does not -----------------------------------
# The widened reading, proven the same way: every plant counted while it stands, read back to zero
# once lifted, and every read-past class shown to leave the real citation counted.
d=$(mkpen room)
mkdir -p "$d/foundations"
printf 'x\n' > "$d/foundations/real.md"
printf '# a\n\nRun `tools/o/one_witness.rish`. Canon: `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note room_clean_free "$(yn $rc)"
note room_clean_counted "$(has "$out" '^room_cited_paths=1$')"
note room_clean_zero "$(has "$out" '^room_cited_untracked=0$')"

printf '# a\n\nRun `tools/o/one_witness.rish`. Canon: `foundations/real.md` and `foundations/gone.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note room_ghost_refused "$([ $rc -ne 0 ] && echo yes || echo no)"
note room_ghost_counted "$(has "$out" '^room_cited_untracked=1$')"
note room_ghost_named "$(has "$out" '^room_untracked: foundations/gone.md$')"
note room_ghost_verdict "$(has "$out" '^verdict=citation_absent$')"
note room_ghost_tools_clean "$(has "$out" '^cited_untracked=0$')"
printf '# a\n\nRun `tools/o/one_witness.rish`. Canon: `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note room_ghost_lifted_zero "$(has "$out" '^room_cited_untracked=0$')"
note room_ghost_lifted_free "$(yn $rc)"

# --- a climb is stripped, so one citation of one file is one reading ---------------------------
d=$(mkpen climb)
mkdir -p "$d/foundations"
printf 'x\n' > "$d/foundations/real.md"
printf '# a\n\nRun `tools/o/one_witness.rish`. See `../../foundations/real.md` and `../foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note climb_free "$(yn $rc)"
note climb_counted_once "$(has "$out" '^room_cited_paths=1$')"

# --- an absolute path names the host, never the tree -------------------------------------------
d=$(mkpen abspath)
printf '# a\n\nRun `tools/o/one_witness.rish`. Copy it to `/etc/nixos/configuration.nix`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note abspath_free "$(yn $rc)"
note abspath_uncounted "$(has "$out" '^room_cited_paths=0$')"

# --- a placeholder is what the illustration law asks for, and it passes free --------------------
d=$(mkpen placeholder)
mkdir -p "$d/foundations"
printf 'x\n' > "$d/foundations/real.md"
printf '# a\n\nRun `tools/o/one_witness.rish`. Shape: `date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.md`\nand `docs/<subroom>/<page>.md`. Real: `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note placeholder_free "$(yn $rc)"
note placeholder_counted "$(has "$out" '^room_placeholder_read_past=1$')"
note placeholder_leaves_real "$(has "$out" '^room_cited_paths=1$')"
# The angle-bracket form is never collected, so it is neither counted as a placeholder nor gated.
# Proven by removing the stamped form and reading the placeholder count back to zero with the
# angle form still standing and the page still free.
printf '# a\n\nRun `tools/o/one_witness.rish`. Shape: `docs/<subroom>/<page>.md`. Real: `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note angle_free "$(yn $rc)"
note angle_uncounted "$(has "$out" '^room_placeholder_read_past=0$')"
note angle_leaves_real "$(has "$out" '^room_cited_paths=1$')"

# --- a gitignored path is a room the repository keeps outside itself ---------------------------
d=$(mkpen ignored)
mkdir -p "$d/foundations"
printf 'x\n' > "$d/foundations/real.md"
printf 'scratch/\n' > "$d/.gitignore"
printf '# a\n\nRun `tools/o/one_witness.rish`. Draft in `scratch/commit-msg.txt`, canon `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note ignored_free "$(yn $rc)"
note ignored_counted "$(has "$out" '^room_ignored_read_past=1$')"
note ignored_leaves_real "$(has "$out" '^room_cited_paths=1$')"
# Un-ignore it, and the same path must now be a promise the pen has to keep.
printf 'nothing\n' > "$d/.gitignore"
seal "$d"; out=$(run "$d"); rc=$?
note ignored_lifted_refuses "$([ $rc -ne 0 ] && echo yes || echo no)"
note ignored_lifted_counted "$(has "$out" '^room_cited_untracked=1$')"

# --- the twin room's own room paths are reported, named, and gate nothing -----------------------
d=$(mkpen twinroom)
mkdir -p "$d/foundations"
printf 'x\n' > "$d/foundations/real.md"
printf '# a\n\nRun `tools/o/one_witness.rish`. Canon `foundations/real.md`.\n' > "$d/.claude/rules/a.md"
printf '# twin\n\nSee `tools/o/two.sh` and `foundations/absent.md`.\n' > "$d/.cursor/rules/a.mdc"
seal "$d"; out=$(run "$d"); rc=$?
note twinroom_free "$(yn $rc)"
note twinroom_counted "$(has "$out" '^twin_room_cited_untracked=1$')"
note twinroom_named "$(has "$out" '^twin_room_untracked: foundations/absent.md$')"

# --- outside a repository the scan refuses rather than reading a filesystem ---------------------
d="$PEN/norepo"; mkdir -p "$d/.claude/rules"
printf '# a\n\nRun `tools/o/one_witness.rish`.\n' > "$d/.claude/rules/a.md"
out=$( cd "$d" && sh "$SCAN" 2>&1 ); rc=$?
note norepo_refused "$([ $rc -ne 0 ] && echo yes || echo no)"

# The leg COUNT is published and pinned by the witness, because `control_failures=0` reads exactly
# the same whether a leg passed or was deleted.
echo "control_cases=$cases"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=disagreement"
exit 1
