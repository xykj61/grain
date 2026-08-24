format session-log-v1
stamp 20260823.025333
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title The mode that moved no lines
prompt Keaton reported the unattended loop dying on `./tools/agent-jail.sh: Permission denied` once every twenty seconds, said a hand-run `chmod +x` fixed it, and asked for a rule to prevent it.
think First read the file rather than the story -- `ls -l` showed 755 on disk while `git ls-files -s` showed 100644 in the index, so the hand chmod repaired the working tree and left the repository still carrying the fault.
think Walked the mode per commit with `git ls-tree`. The file was 100755 from its first commit through 461052ad5e and read 100644 at 1c233b39db, the most recent commit -- the autonomous loop's own last lap, which broke the loop it was running in.
think `git diff --summary 1c233b39db^ 1c233b39db` named thirty-nine files losing 100755, none gaining it. Thirty-eight were still 100644 on disk; only agent-jail.sh had been repaired by hand.
think Mechanism: that commit repointed 116 path literals across 58 tracked sources. The safe shape was already in the tree -- `dated_path_repoint_scan.sh` rewrites with `cat "$f.dpr" > "$f"`, preserving mode -- so the rewrite that lost the bits reached for `mv tmp f` instead, which carries the temporary's mode.
think Why no guard caught it: a mode change moves no lines, so `git show --stat` reads `0 insertions(+), 0 deletions(-)`. All twenty-three rostered guards read lines. Mode is a class of tracked content the roster could not see at all.
think Scoped the rule before writing it. Measured 97 tracked shebang files at 100644, of which only the culprit's 39 were regressions -- the other 58 are fixture scans every witness runs as `run ["sh" "..."]` with the interpreter named, so their exec bit is genuinely optional. A blanket "shebang implies 755" rule would have been 58 lines of noise around one real fault.
think Chose the load-bearing set instead: a file is gated when a LIVING tracked file invokes it directly as `./path` in command position. Filtering candidates to blobs beginning `#!` removed every false positive at once -- no `.rish` in this tree carries a shebang, so the `site ./x.rish` ledger rows and `](./x.md)` link targets fell out for free.
think Added a second enforced reading the first one cannot give: on-disk exec bit must agree with the index mode. That is the early catch -- a drifted mode is a mode about to be committed by accident, and the working tree is where repair costs one chmod.
obs Restored all thirty-nine modes in both places -- `chmod +x` for the next run and `git update-index --chmod=+x` so a fresh clone inherits it. Repairing only the working tree would have left the next clone broken and the guard red.
obs The first scan shape read each of 13,650 blobs in its own `git cat-file` and took over sixty seconds. Replaced with one `git grep --cached -n -E '^#!'` filtered to line one, and one `git diff --raw` for the mode comparison: 0.87s, identical numbers on every field. A guard nobody waits for is a guard nobody runs.
obs Proved the RED path against the real regression before trusting it -- flipped agent-jail.sh back to 100644 in the index and both duties bit, naming the file. Then restored and confirmed GREEN.
obs The ratchet ceiling is proven from both sides with no override: the control plants fifty-nine uninvoked shebang files against a ceiling of fifty-eight. An env-var escape hatch would have been a door beside the wall.
obs Ran the monotone scan bare and read `verdict=not_monotone`, then checked HEAD in a throwaway worktree before booking a red -- it read the same. The scan wants every rows-holding file passed as an argument; run its own way it reads `rows=159, gaps_or_dupes=0`. The wrong invocation is not a red, and a worktree checked that without putting the round at risk.
obs REDS stood 271 bytes under its 24,576-byte bound, so rows %155-%156 folded to `crux/archive/` with a doorway line before %159 was booked. Row %156's open coverage question -- twenty-four rostered guards against 1,653 witnesses -- is carried forward in the doorway rather than folded away with it.
loom witness=exec_bit_witness scan_wall_ms=870 tracked_files=13650 shebang_files=517 directly_invoked=18 gated_red=0 worktree_disagreements=0 ratchet=58 ceiling=58 control_behaviors=16
file tools/fixtures/exec_bit_scan.sh two readings gated at zero, one ratchet under a falling ceiling, in one 0.87s pass
file tools/fixtures/exec_bit_control.sh sixteen behaviors on real git repositories in a pen -- five refusals bitten, eleven honest readings left free
file tools/exec_bit_witness.rish the rung that drives both and names what it does not prove
file .claude/rules/exec-bit.md the law -- rewrite in place with `cat "$tmp" > "$f"`, never `mv "$tmp" "$f"`
file .cursor/rules/exec-bit.mdc the canonical Cursor twin
file crux/standing-equipment.kyri exec_bit seated as the roster's twenty-fourth guard
file crux/REDS.md row %159 booked and closed; headline carried to 159; rows %155-%156 folded out under bound
file crux/archive/REDS-the-machinery-and-the-unrostered-guards-rows-155-156.md the closed range, every byte kept
recommend check-in (Keaton) -- the loop is safe to restart now that the index carries 100755 again. The open question row %156 named is now sharper rather than answered: twenty-four rostered guards against 1,653 witnesses, and this lap found a whole class of tracked content -- file modes -- that no guard read at all. Worth asking what else the roster cannot see before adding another row to it.
