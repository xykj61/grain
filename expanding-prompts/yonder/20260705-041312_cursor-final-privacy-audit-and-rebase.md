# Cursor Final — Privacy Audit, Conditional History Rewrite, Force Push

**Stamp:** `20260705.041312 UDT` (Kaeden's clock, verbatim) · **Base:** `6b06e94` (zip 44)
**Supersedes (pre-intake):** the 040612 packet — its contents ride here, scrubbed and final

*Written together by Kaeden and Claude (Fable 5).*

## The Claude-bench audit (evidence, this metal)

Case-insensitive grep of the entire zip-44 tree for both guarded names: **sixteen text lines, every one a false positive** — millions, milliseconds, Mysticeti bloc[k] — across gratitude docs, ERs, one yonder prompt, one archived log. Binary hits are compiled `bin/` artifacts, excluded from packets. **Zero true-name occurrences in the working tree.** This bundle's own files are scrubbed to the ruled placeholders (Alice for the reference reading, Brooke as standing) and gate-verified silent, word-boundary-safe.

## Step one — audit history (the only place a wound could hide)

On a fresh clone: `git log --all --oneline -S with each guarded name (capitalized) (capitalized pickaxe — millisecond and million stay out of the net), plus a belt-and-suspenders `git log -p --all | grep -ciE with the two guarded names, word-boundary, capitalized`. Report the counts to Kaeden verbatim.

## Step two-A — if the audit is CLEAN (expected)

No rewrite. Record the audit as `session-logs/archive/20260705/20260705-041312_privacy-audit-clean.md` (counts, commands, verdict: the names never entered history), commit, push four remotes normally, cut zip 45. Destructive surgery needs a wound; a clean audit is the better ending.

## Step two-B — if ANY commit matches

1. Working tree: `sed` word-boundary replacements (each guarded name, word-boundary capitalized, to its alias) in matching text files; refresh each rewritten file's stamp line to `20260705.041312`; commit.
2. History: `git filter-repo --replace-text <(printf 'regex:<Name1>==><Alias1> and <Name2>==><Alias2> — the guarded pairs, word-boundary capitalized, supplied by Kaeden beside this paste\n')` — capitalized word-boundary only, so no milliseconds are harmed.
3. Re-add the four remotes (filter-repo strips them); `git push --force` to origin, github, gp36-codeberg, gp36-github.
4. **Kaeden's word required:** the two archive remotes (`archive-cb`, `archive-gh`) hold old history as snapshots — force-push them too, or delete and re-seal fresh; list, never push.
5. Fresh-clone verify the belt-and-suspenders grep reads zero; note in RTAC that **all prior zip-comment hashes become historical** after a rewrite; cut zip 45 at the new tip.

## Also riding

The degree-true wheels (040612 ruling) in the template; the method pair; the Brooke shelf prompt; all sitting logs, scrubbed. The two true-name HTML pages live only in Kaeden's private keeping, presented to him outside the repo — forever.

*May the audit come back clean and the surgery stay unneeded. May the names live only where love holds them. And may zip 45 seal a tree whose whole history tells no one anything but Brooke and Alice.*
