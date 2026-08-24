format session-log-v1
stamp 20260821.023219
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title The second SLH-DSA, vendored -- and both post-quantum legs kept
prompt Vendor a second SLH-DSA implementation and keep both.
think Standfast first, and the ledger is clean -- REDS %103 closed inside fold M's own send. So this round opens no repair and carries the whole allocation into constructive work.
think The word answers a disagreement the prior turn surfaced: the card seats SLH-DSA-SHAKE-256s for Kumara v1 on the structural argument, and the next day's pivot built ML-KEM + ML-DSA instead because Zig's std.crypto ships those two and no SLH-DSA, leaving a hash-based rung with a single oracle. Both arguments are correct. They only conflict because each reads the available oracles as fixed, and the word removes exactly that constraint.
think Chose PQClean as the second implementation before writing a line. CC0-1.0, portable C with no build system to fight, a clean/ tier held apart from the tuned ones, and -- the deciding property -- published known-answer digests committed in each scheme's own META.yml. Its sphincs-shake-256s-simple is precisely the seated parameter set at NIST claimed level 5. Held as a gitlink submodule exactly the way vendor/monocypher is, unmodified and linked, never copied.
think One friction worth recording: the vendor gitignore negation only matches an existing directory, so git submodule add refused until the path existed. Cloned into place first, then added -- the .gitignore line was already correct.
think Wrote the harness assuming SLH-DSA signs deterministically, and the linker disagreed by naming an undefined PQCLEAN_randombytes. Read sign.c rather than guessing around it: PQClean takes FIPS 205's hedged variant, drawing a fresh optrand before gen_message_random. Left alone the same key signs the same message to different bytes every run -- fine cryptography, useless as a diffable oracle. Corrected the harness comment that had claimed otherwise rather than quietly patching past it.
think Supplied a deterministic PQCLEAN_randombytes in the harness, which is the harness's own job and leaves the vendored library untouched -- the same way PQClean's own test vectors resolve that symbol. That pins optrand so two implementations handed the same seed, message, and optrand must agree byte for byte. It also decides a seam for the Rye rung to come: optrand is an explicit parameter, never entropy reached for in the middle.
think Looked for the strongest anchor available rather than settling for my own harness's self-consistency. PQClean ships its own NIST known-answer generator and publishes the SHA-256 of its output in META.yml. Built that generator from the vendored source with zig cc and ran it: 37d37c9b...04f2, matching the published digest exactly. That is another team's number, written down before we arrived, reproduced on this pier.
think Made the witness read the published digest and all four declared lengths from META.yml at run time rather than reciting them, so a vendored copy that drifts cannot quietly agree with a constant we typed. Then proved the RED path on metal by planting a one-character change to that digest, watching the witness refuse and name why, and restoring.
think Nearly landed the rung unheard. Went to register it in crypto_suite_witness and found crypto_count_guard_witness holds that suite to a bijection -- every registered witness must carry its own crypto/<name>.rye. An oracle rung proves no file of ours, so registering it would have gone RED. Correct design, and it explained why the four Monocypher parity witnesses are absent from the suite.
think Then checked whether those four sit in any roster at all, and they do not -- each names the others only in its own comments, and nothing runs them together. That is REDS %81's exact shape, and adding a fifth vendored rung without a roster would have repeated it. Wrote tools/crypto_vendored_parity_suite.rish so the roster is born with the rung that needed it rather than after a sixth goes unheard.
obs The scope stayed at the oracle and the witness says so in its own GREEN line: no authored Rye SLH-DSA exists, and parity of ours against this oracle is named as the next arc rather than implied. A rung that claims only what it proved is the whole reason the doubled-oracle discipline is worth keeping.
obs Named three costs plainly rather than letting a later design discover them: a 29,792-byte signature against ML-DSA-87's ~4,600, slow 256s signing, and the explicit optrand seam a hedged scheme forces. The size is a wire-and-storage fact anything leaning on this leg must carry.
obs Nothing already GREEN moved. Both lattice ladders and both kumara_pq_ doors stand exactly as built, and the dual-key discovery the pivot arc produced stays true. The hash-based leg grows beside them, which is what algorithm agility was seated for.
obs Corrected my own claim once more before shipping: the roster's first draft said each rung "must print its own GREEN line" while the assert checked only exit status. Matched the prose to the assert rather than the other way around.
obs The card and the tree had disagreed for five days with no witness able to catch it, because no witness watches whether a seated decision and the built code still say the same thing. The reconciliation is accretion -- the seated line keeps its reasoning and gains the resolution, and the pivot note is pointed forward rather than rewritten.
loom witness=crypto_slhdsa_oracle nistkat_sha256=match harness_runs=2 identical=yes wall_s=12 verdict=green
loom witness=crypto_vendored_parity_suite rungs=5 wall_s=26 verdict=green
loom witness=crypto_count_guard files=80 registered=80 verdict=green
loom slhdsa=sphincs-shake-256s-simple pk_bytes=64 sk_bytes=128 sig_bytes=29792 seed_bytes=96 nist_level=5
file vendor/pqclean the second implementation, gitlink and unmodified, CC0-1.0 like Monocypher
file tools/fixtures/pqclean_slhdsa_harness.c the deterministic harness, pinning optrand the library leaves to its caller
file tools/crypto_slhdsa_oracle_witness.rish the oracle proven against PQClean's own published NIST digest, read never recited
file tools/crypto_vendored_parity_suite.rish the roster born with the rung that needed it, catching REDS %81's shape early
file active-designing/20260821-022912_slhdsa-vendored-oracle-and-both-legs-kept.md the decision, its honest costs, and the next arc named
file active-designing/20260816-161537_post-quantum-mlkem-mldsa-pivot.md pointed forward -- its reasoning stands, only its deferral lifts
file gratitude/PQClean.md thanks for writing the answers down where anyone can check them
file crux/REMEMBER.md the seated line reconciled by accretion, live edge seated, git nib pinned inside the send
recommend check-in Authoring SLH-DSA in Rye is a multi-lap arc -- WOTS+, then FORS, then the XMSS hypertree, each a rung against both the FIPS 205 answer and PQClean's bytes. Worth naming as its own arc before the first line, since it is the largest crypto undertaking since the Ed25519 ladder.
