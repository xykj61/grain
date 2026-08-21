format session-log-v1
stamp 20260821.183454
editor Claude Code
model claude-opus-5
voice Kyri
host Vultr SEA NixOS VPS ai-jail pier (Daylight DC-1 hand) -- Eastern (EDT)
title Amphora lap 2, and the substitution that would have been silent
prompt fix amphora lap 2 with sha256sum
think Read what openssl was actually being asked to do before substituting for it, and the fix I had proposed a round earlier turned out to be wrong. Every call in that path is openssl dgst -SHA3-256. SHA3-256 is Keccak; sha256sum is SHA-2. Different algorithms, not two spellings of one.
think Sat with how quiet that failure would have been. The substitution compiles, runs green, and silently changes every content address in every manifest this tree has ever written -- and each new digest looks exactly as much like a digest as the old one. A hash tool is the sharpest case of this: wrong output is indistinguishable from right output by inspection, there is no crash, and the damage lands in precisely the artifacts meant to be immutable.
think Found the tree's own hash-tier spec naming SHA3-256 for the Working tier in plain text, one grep away. The evidence against the substitution was already written down; nobody had gone to read it, including me when I suggested it.
think Traced the second failure and found it was the same root. The unbound-variable death at amphora_pour.sh line 34 was not independent: an absent openssl produced an EMPTY digest, an empty digest wrote a short manifest entry line, and the reader of that line then died on a field that was not there. One cause, two symptoms.
think Chose the tree's own Keccak over installing openssl, because crypto/sha3.rye already exists -- authored Rye over Keccak-f[1600], clean-room from FIPS 202 -- and it computes exactly the algorithm the spec names. Same digests, no external dependency, and one more place the tree stands on what it built.
think Kept the oracle question rather than dropping it. The spec called openssl the INDEPENDENT host oracle and was right to: a digest checked only against the code that produced it proves nothing about whether that code computes SHA3-256 at all. So the witness checks against the published FIPS 202 known-answer vectors -- public, stable, and unchangeable by anyone here -- and against openssl additionally wherever it is installed, reporting honestly when it is not.
think Hit the module-path boundary and moved the tool rather than working around it. Rye refuses an import outside the module path, so a digest utility that imports crypto/sha3.rye belongs in crypto/, which is also simply where it belongs.
think Shipped a bug and caught it by testing rather than by reading. The tool printed a perfect digest through print, which is std.debug.print and writes to stderr, so every dollar-paren around it read the empty string -- the exact shape of the original failure, reproduced by my own fix. The digest goes to stdout now and the witness proves it is capturable.
think Fixed a second one the same way. The shim resolved its root from pwd, and the Amphora witness pours into a mktemp directory, so a tool that could only find its own binary when someone happened to be standing in the repository failed exactly where it was used. It locates itself from its own path now.
obs Corrected the record rather than editing it. REDS %112's closing row carries my wrong suggestion in its own words, and rows are append-only, so %116 accretes and says plainly what the earlier row got wrong. The ledger's own law provides for this: a later correction accretes as a new row pointing back.
obs Kept the unbraid honest against a tempting reading. Lap 2 passing does not make the old gate correct -- it was never right for a health meter to depend on another module's laps, and the fascia meter comment now says so rather than quietly implying the unbraid was a workaround for a broken lap.
obs REDS crossed its byte bound again and row 112 folded to archive, which needed its filename to say rows- rather than row- before the monotone scan could find it. A glob is a promise about names too.
loom fix=amphora_lap2 openssl_calls_replaced=5 algorithm=SHA3-256 unchanged=yes laps_green=3 witnesses_green=7
loom digest=own_keccak fips202_empty=matched fips202_abc=matched one_byte_changes=yes capturable=yes openssl_parity=skipped_absent
loom meter=fascia grade=45 of=100 still_unbraided=yes
file crypto/sha3_file.rye the SHA3-256 of a file over the tree's own Keccak, written to stdout
file tools/fixtures/sha3_256.sh the shim, locating itself, refusing a malformed digest
file tools/fixtures/sha3_file_control.sh FIPS 202 answers, a one-byte change, capturability, openssl when present
file tools/sha3_file_witness.rish the parity claim resting on a public standard rather than on local tools
file tools/fixtures/amphora_pour.sh one of five fixtures moved off openssl
file crux/REDS.md %116 booked -- the substitution that would have been silent
file crux/archive/REDS-fascia-meter-unbraided-rows-112.md row 112 folded to keep the pin under bound
recommend check-in (checkpoint) Amphora laps 1-3 and all seven Amphora and Cellar witnesses are GREEN, and there is no known red left standing on this pier. One door still wants a word rather than a kg: the colour normalization booked as REDS %114, which edits dated bodies. Beyond it, the openssl calls that remain outside the Amphora path -- the waymark derive and the equinox bundle manifest -- could take the same treatment on a later lap, which would leave the tree with no external hash dependency at all.
