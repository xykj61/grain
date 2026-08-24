format session-log-v1
stamp 20260821.191312
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title Five guides read against the tree, and the loom the class had earned
prompt read the other five manual guides against the tree
think Made this a verification round rather than a writing one on purpose. Prose already outnumbers code here, and the honest shape of a follow-on to REDS %117 is to check claims rather than to add more of them.
think Extracted checkable claims mechanically first -- every cited path, every command -- and my first path check was wrong in a way I should have seen coming: I resolved from the repository root while the citations are relative to manual/. The same mistake the dated-path census made two rounds ago, made again by me, which is its own small lesson about how easily a measurement can be confidently wrong.
think Re-checked resolving from each citing file and found four apparent misses, three of which were link LABELS rather than targets -- the target beside each was stamped and correct. Reading the surrounding line is what told them apart.
think Found the fourth was a narrative hypothetical: a witness the reader is told to WRITE two paragraphs earlier, then run. Not a false claim, and worth not booking as one.
think Went after the commands next, since that is where %117's class lives. Three of the five carried real defects and two were clean, and the split was not random: the two clean ones are the shortest and least inviting, and the three with the warmest prose carried every fault.
think Checked whether sh rye/bootstrap.sh works from the root as the guide claims, rather than assuming it needed a cd. It self-locates. The guide was right and I nearly corrected something correct.
think Found the machines guide saying the binaries ship three separate times, most plainly as the shipped rye and rishi binaries are built for exactly this architecture, plus a clone-then-run block with no build between them.
think Found the sandboxing guide inviting a reader to watch this hold for yourself and then writing a bare rye build, which no reader can run since rye lives at rye/bin/rye and never on a PATH.
think Found the developer guide illustrating the run-record with vault/bin/vault, a binary nothing in this tree builds. vault/ holds kumara.rye and shard.rye and no vault.rye at all.
think Ran the correction instead of trusting it, and that is how the better finding arrived. With the path fixed to the real vault/bin/shard the example STILL failed: it checks ok.out for the green line, and a Rye program prints through std.debug.print, so the answer is on ok.err and out is empty. The illustration teaching the run-record was reading the wrong field of the run-record.
think Built the loom rather than a third fix, since the class had now fired twice. The guard measures its own premise each run -- git ls-files rye/bin rishi/bin -- and stands down if the tree ever does ship binaries, because a guard that cannot notice its premise expiring will one day be wrong with confidence.
obs The guard reddened on its first run against three pages that were QUOTING the false claim in order to explain it was false. Exactly the trap the colour sweep hit an hour earlier: the record of a fault necessarily contains the fault's own words. A line citing a REDS row or wearing the emphasis-quote form is exempt now, because a guard that makes the record unwritable has erased its own reason.
obs Two guides needed nothing. Saying so plainly matters as much as the three corrections -- a review that finds fault everywhere is a review nobody will trust the next time it finds fault somewhere.
loom review=five_guides clean=2 defective=3 false_claims_fixed=5 paths_checked=44 path_misses_real=0
loom finding=dev_guide_second_fault field=ok.out expected=ok.err out_len=0 err_len=712
loom loom=shipped_binary_claim premise_measured=tracked_binaries assertion=refused quotation=allowed dated=allowed
file manual/20260810-065116_running-grain-on-your-machines.md three false ship claims replaced by the build that actually works
file manual/20260810-065116_sandboxing-and-getting-set-up.md the bare rye corrected to the invocation a reader can run
file manual/20260810-065116_the-developer-guide.md the run-record example, both faults -- the path and the field
file tools/fixtures/shipped_binary_claim_scan.sh the premise measured, the claim refused, the record left writable
file tools/shipped_binary_claim_witness.rish both directions proven on planted pages
file crux/REDS.md %118 -- the class named, and the loom that ends it
recommend check-in (checkpoint) the five are read and the class is guarded. Two doors, both small and both yours to time: the manual's other rooms (glow-os, guides, reference, video-scripts, 26 files) have never been read against the tree at all, and the two clean guides plus the corrected three still carry claims about behavior that only a full reader's walk would test -- the guard catches one specific false sentence, not every aged one.
