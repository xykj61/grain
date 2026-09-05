# tools/fixtures/t/tracked_link_duty2.awk -- every relative link in a living document, resolved
# against the tracked set, in ONE process.
#
# WHY. The loop this replaced forked an `awk` and a `grep` per LINK and three more per file:
# roughly 47,700 processes across 4,289 candidate documents and ~17,400 links, for 72 of the
# roster's seconds. The resolution is a dozen lines of string work and the membership test is a
# hash lookup; neither was ever the cost (REDS %413).
#
# ARGV[1] is the known-path set, one per line. Every argument after it is a candidate document.
# Output is one `src -> target` line per unresolved link, prefixed `enforce ` or `ratchet `, which
# is exactly what the shell wrote before and lets the caller keep its own two rosters.
#
# WHAT IT DELIBERATELY DOES NOT DECIDE: whether a target that misses the tracked set exists on disk
# at all. A link resolving nowhere is a plain broken link and `living_docs_lint` owns that duty, so
# those are printed as `check ` and the caller tests only that handful -- the residue is small
# because almost every link points at something tracked.
BEGIN {
  kf = ARGV[1]
  while ((getline line < kf) > 0) known[line] = 1
  close(kf)
  ARGV[1] = ""
}
# A basename carrying a one-clock stamp is dated testimony, which keeps every word it wrote.
FNR == 1 {
  skip = 0
  src = FILENAME
  if (src ~ /^session-logs\//) { skip = 1 }
  n = split(src, seg, "/")
  base = seg[n]
  if (base ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/) skip = 1
  dir = ""
  for (i = 1; i < n; i++) dir = (i == 1) ? seg[i] : dir "/" seg[i]
  if (dir == "") dir = "."
  lane = (src ~ /^(external-research|expanding-prompts)\/yonder\//) ? "ratchet" : "enforce"
}
skip { next }
{
  line = $0
  while (match(line, /\]\([^)]+\)/)) {
    t = substr(line, RSTART + 2, RLENGTH - 3)
    line = substr(line, RSTART + RLENGTH)
    sub(/#.*$/, "", t)
    if (t == "") continue
    if (t ~ /^(http|mailto:|<|\/)/) continue
    r = resolve(dir "/" t)
    if (r == "") continue
    if (r in known) continue
    # Misses the tracked set. Whether it exists on disk at all is the caller's one test, over a
    # residue small enough to fork for -- almost every link points at something tracked.
    print "check", lane, src, t, r
  }
}
function resolve(p,   m, part, i, top, out, s) {
  m = split(p, part, "/"); top = 0
  for (i = 1; i <= m; i++) {
    if (part[i] == "" || part[i] == ".") continue
    if (part[i] == "..") { if (top > 0) top--; continue }
    out[++top] = part[i]
  }
  s = ""
  for (i = 1; i <= top; i++) s = (i == 1) ? out[i] : s "/" out[i]
  return s
}
