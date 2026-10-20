format session-log-v1
stamp 20260905.014249
editor Claude Code terminal on the Dallas pier, reached over SSH from a Daylight DC-1 tablet
provider Anthropic
product Claude Code
role Incense -- field captain, law and review, tree grain-incense
modality text
model claude-opus-5
model_status active -- the harness system prompt declares the running model by exact id
voice Kyri
host NixOS 6.18.49 x86_64 AMD pier (Vultr Dallas), one clock America/New_York
title The login that never reached a tree
prompt Restarting petrichor gave Not logged in; I logged in manually within the petrichor pier and still get it. I assume pheromone has the same problem -- can we fix it?
think Measured before prescribing, and the three readings told the whole story: the host carries a 509-byte credential, grain-incense/loops/claude carries the same 509 bytes and works, and pheromone and petrichor carry none at all.
think claude login writes to the HOST's HOME/.claude, and --private-home exists precisely to replace HOME with a tmpfs. Only loops/claude is mounted in. So a login typed at the pier shell reaches no tree whichever directory it was typed in -- cd moves the working directory and the credential follows HOME. That is why logging in from inside grain-petrichor changed nothing.
obs A sandbox that replaces a directory replaces everything anyone ever put there, and an instruction that works outside it can fail inside it while looking identical from the keyboard. Keaton did the right thing twice and got the same line both times.
obs The answer was already written in the same file. agent-jail.sh has seeded cursor's browser login from the host into the state room since it was written, with a comment saying private-home would otherwise drop it. The same seam, the same fix, and only one of the two agents ever got it -- which is the second time the claude side of this launcher has been the half left undone, after %408's conditional mount.
obs The refresh clause is what cursor's line does not need and this one does. A token refreshes: the jailed agent writes its own back into the tree's room, so the tree's copy is newer after a working lap and must never be clobbered, while a fresh pier login makes the host's newer and every tree should pick it up. Whichever hand moved last wins is the only rule that stays true without a hand remembering it.
obs Proven in all three states with mode 0600 preserved -- seeded when absent, left alone when the tree's copy is newer, refreshed when the host's is. The first attempt at the absent case was confounded by prefer_adopted_room overriding an empty probe room back to loops/claude, which is that guard working correctly rather than a fault.
obs Custody read plainly rather than assumed: no credential leaves the machine, none is written anywhere tracked since loops/ is gitignored and a closed stack, and nothing here creates, holds or moves a custody key. It carries the maintainer's own already-granted session between two directories of his own pier, which the cursor line beside it has done all along.
loom seed host_bytes=509 incense=509 pheromone=absent petrichor=absent states_proven=3 mode=0600
file tools/ag/agent-jail.sh the claude login seeded from the host and refreshed when the host's is newer
recommend kg -- both ships launch on the same command once this lands; the utility yonder research is still named and unstarted
