format session-log-v1
stamp 20260816.225423
editor Claude Code
model claude-fable-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title reds-first -- crux/ gitignore allowlist repaired (REDS #84)
prompt (found mid-round, during the glyph atlas send) a git add warning that crux/ paths are ignored
think While committing the glyph atlas round, git add printed "The following paths are ignored -- crux". The tracked files staged fine, so the commit was whole, yet the warning was real. Ran it down with git check-ignore -v crux/newfile.md, which pinned it to .gitignore:8:/* -- the root catch-all that ignores everything and then whitelists specific paths with ! negations.
think The 20260816 breach rename git mv work-in-progress crux moved the folder but never moved its allowlist entry: line 68 still reads !/work-in-progress/, and no !/crux/ was ever added. Tracked files under crux/ (REMEMBER, CAIRNS, TASKS) commit regardless, so nothing looked broken -- but any NEW untracked file under the tree's highest-priority living folder would be silently dropped from a git add. A fresh cairn split or a new crux doc would vanish.
think Reds-first: named it, booked REDS #84 with all three fields (what went wrong, what caught it, what it taught), fixed on metal, then resumed. The teaching: a rename is not done until its allowlist moves with it -- references are promises, and so is an ignore allowlist.
obs Fix is one line: added !/crux/ beside !/work-in-progress/ in .gitignore. Proven by git check-ignore going quiet (exit 1) on crux/newfile.md and a dry-run git add of a new crux path now succeeding ("add crux/.ignoretest") where it was blocked before. Kept !/work-in-progress/ too -- the back-compat symlink is still tracked.
file .gitignore added !/crux/ to the root-catch-all allowlist so new crux files are tracked
file crux/REDS.md booked REDS #84 -- the crux rename left its gitignore allowlist behind
recommend keep-going the red is closed on metal; the next constructive lap is the next open-media rung (font corpora or intra-frame video), no gate
