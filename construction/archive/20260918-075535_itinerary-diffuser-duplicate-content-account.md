# Shelved account -- Diffuser, the duplicate-content census (opened and closed)

Shelved whole from `construction/ITINERARY.md` at `20260918.075535` under
[`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md). One seat, one live account.

---

**DIFFUSER -- THE DUPLICATE-CONTENT CENSUS OVERSTATES ITS OWN COMPUTE-AVOIDANCE CASE.** A fifth
first-principles check, aimed at Mantra's name-to-bytes promise read as a compilation guarantee
rather than only a storage one. This tree's own tracked files were hashed (19,082 files, 175
duplicate-content groups, 1,272,252 duplicate bytes beyond one copy per group) as a proxy for
compute a content-addressed build could avoid recompiling. The falsifier ran on the largest single
pair, `image/text_paint.rye` and `pond/apps/text_paint.rye` (69,971 bytes, byte-identical,
confirmed by inspection as the "hand-filed symlink" pattern `.claude/rules/stamp-and-name.md`
already names) -- and it fired: the `image/` copy is imported live by five sibling modules, the
`pond/` copy by zero. The largest duplicate this census surfaced turned out to be inert, not
doubly-compiled, so raw duplicate bytes overstate the opportunity; the number that would matter is
duplicate bytes reached by a LIVE `@import` on both sides, which needs an exact-path import
resolver rather than a basename grep and was not built this lap. Paper, with the gap named as the
buildable next step and a second open question (whether Zig's own already-seated cache,
`tools/p/parity_zig_cache_seat.sh`, already dedupes across separate top-level compilations) left
unresolved: [here](../../active-designing/date/20260918/20260918-072000_the-duplicate-content-census-overstates-its-own-case.md).
**YOURS, ANY SHIP:** the exact-path `@import` resolver, scoped to the 175 duplicate-content groups
this pass already has on hand, is agent-doable and needs no new measurement.

---

**Closed the same lap, `20260918.075535`.** The named resolver is built:
[`tools/fixtures/d/duplicate_import_liveness_scan.sh`](../../tools/fixtures/d/duplicate_import_liveness_scan.sh).
Its first run priced the largest group at 193,055 extra bytes using a filesystem `stat`, and that
size read 23 bytes for one member -- the length of a symlink target string, not a truncated file.
`git ls-files -s` confirmed it: `classical-vedic-astrology/topology.rye` is a tracked git symlink
(mode `120000`) to `comlink/topology.rye`, and `sha256sum` (which follows symlinks) had hashed it
as a duplicate of its own target. Rewritten to read git's own index and blob sizes, the resolver
found **121 of 127 duplicate-`.rye` digest groups (95%) are entirely symlinks** -- including the
prior paper's own hand-checked `text_paint.rye` pair, where `pond/apps/text_paint.rye` turns out to
be a symlink to `image/text_paint.rye` rather than a hand-filed copy. The genuine hand-filed-copy
remainder is **6 digests, 1,480 extra bytes**, of which 613 (41%) are live. Reading:
[`../../active-designing/date/20260918/20260918-075535_the-exact-path-import-resolver-closes-the-duplicate-case.md`](../../active-designing/date/20260918/20260918-075535_the-exact-path-import-resolver-closes-the-duplicate-case.md).
**Verdict: the compute-avoidance case is closed, and closed harder than expected.** Mantra's
name-to-bytes binding stays a storage guarantee; the tree had already mostly solved this with
ordinary symlinks before the research thread opened, and `stamp-and-name.md`'s own
"hand-filed-symlink family" description undercounts how literally true the "symlink" half already
is. **YOURS, ANY SHIP:** whether Zig's own build cache treats a symlinked `@import` as the same
compilation unit as its target -- i.e. whether the 121 symlink groups also save compile time --
stays open and untouched by this reading.
