# A resin and a vessel

**Language:** EN
**Stamp:** `20261003.120945` (EDT)
**Voice:** Kyri
**Style:** Bhakta with Radiant warmth, Gauge at Field
**Status:** Living -- **Room:** research for understanding
**Silo:** none yet -- design choices on this page wait for a word before a designing page

This page starts the explanation over. It is for a reader who has the words resin, vessel, Amphora, and hash in one conversation and cannot yet tell which word is the box.

## Two things you can hold

Picture a season of work: notes, programs, a manifest that lists them. You want that season safe at home, and you want to be able to hand the same season to someone far away.

**Cellar** keeps it at home. Cellar is the module for preservation in place. It seals the bytes so a later reading can prove they were not changed. The elder name Amber still appears on a few wire tokens. The living module name is Cellar. [`../../../cellar/README.md`](../../../cellar/README.md) says this in its own first paragraphs.

**Amphora** carries it. Amphora is the module for preservation in motion. You hand it a directory. It writes one file. That file is the **vessel**. Pour fills the vessel and seals it. Carry moves it. Restore opens it at the far side and checks it before trusting it. [`../../../amphora/README.md`](../../../amphora/README.md) names those three verbs.

A resin and a vessel are different things.

A **resin** is one content-addressed unit: the stored bytes, listed in a manifest, proved by a digest. Cellar seals resins. Amphora carries them. The archive law says the resin is the matter and the digest is the address. That law is [`../../../context/specs/20260703-191112_resins-and-hash-tiers.md`](../../../context/specs/20260703-191112_resins-and-hash-tiers.md). The lexicon's later row says the same job in travel clothes: a resin is the packed whole that crosses a seam, and a **bead** is one part of that whole. Both rows live in [`../../../context/LEXICON.md`](../../../context/LEXICON.md).

A **vessel** is the one file Amphora writes for a season. The season may contain many resins. A resin that is too large for one datagram is cut into chunks for the crossing, then assembled again. The vessel is the file you put in a pocket. The resin is a unit of bytes the vessel's cargo is made from.

So Amphora is the craft. The vessel is the file that craft writes. The resin is the unit of bytes. Three names, three jobs.

## The wish that one word could cover the bundle

The original wish was a good one. One Grain word, **resin**, would mean the bundle you can archive or send: stored by the in-place sealer, or carried across a wire, under a name the bytes themselves support, in a namespace where a name keeps meaning the same bytes.

That wish matches the resin. It does not match the vessel, and it does not match the digest.

A vessel is a particular file shape: one season, poured, sealed, signed, carried, restored. Calling every vessel a resin in the wide sense is fair teaching, once the narrow sense is already clear. A sentence that can survive being said for years is: a vessel is the file Amphora pours when the bundle is a whole season. Folding the word vessel away would make the three verbs harder to teach, because pour, carry, and restore all name that file.

Calling the digest a resin is the slip this morning's study made, and the formula page still has a comment that invites it. In [`../../../context/CHEMICAL_FORMULAS.md`](../../../context/CHEMICAL_FORMULAS.md) the line `payload -> resin` is glossed "the content address." The archive law uses resin for the bytes. The short name is the **digest**. A digest is the result of a **hash**, a recipe that turns any number of bytes into a fixed-size name. Same bytes, same digest. Change one bit, and the digest changes. The digest is how you check. The resin is what you checked.

## What is already a good idea

Content-addressed bytes are a good idea, and this tree already builds on them. Anyone with the bytes can recompute the digest and see that they match. That is the proof. It needs no secret mixed in. A salt, the random extra used so two identical passwords wear different digests, would break that proof. A content address has to come out the same every time.

A global namespace that is only a pile of digests is a weaker idea than the one already seated. Digests name bytes. People need a place to find those bytes. The seated grammar is `peer / bolt / revision / path`, in the lexicon row for the referential namespace, and the design is [`../../../active-designing/date/20260706/20260706-023912_the-referential-namespace.md`](../../../active-designing/date/20260706/20260706-023912_the-referential-namespace.md).

Read it as four plain parts:

| Part | What it is |
|---|---|
| **peer** | Who holds it. Kumara is the identity you own, a key in your hands. |
| **bolt** | Which work. A bolt is one coherent unit, with its own history. |
| **revision** | Which moment of that work. |
| **path** | Which file inside that moment. |

**Recall** is the promise on a read: the same name gives the same bytes, or an honest answer that they are not here yet. The digest sits under that promise as the check. It does not replace the four-part name. A grower can point at a season by a person's name and a path. The digest tells a later reader the bytes are still the bytes.

**Comlink** carries sealed messages between machines. It is the wire. It is not the bundle and not the name. Amphora's third lap already fetches vessel cargo by digest on a hosted Comlink path. The carrying and the naming stay different jobs.

**Constellation**, in the seated chapter, is the ring of funds. Using that word for peer discovery would put a second job on a name that already has one. Peer discovery, when it is built, belongs beside Comlink and Kumara: find a peer, then carry a vessel to them. The name for that finder can wait until the job is real.

## What I would keep

Keep **resin** for the bundle of bytes you can store or send. That is the original wish, and it is already the archive law.

Keep **vessel** for the one file Amphora writes. Teach the bridge in one sentence, and keep both words.

Keep **digest** for the short name, and **hash** for the recipe that makes it. Both words stay true on a ten-thousandth reading. The naming foundation asks a name to be clear on the first day and still pleasant to type long after, in [`../../../foundations/20260823-034321_the-return-that-feeds-everyone.md`](../../../foundations/20260823-034321_the-return-that-feeds-everyone.md). Hash needs one first-day sentence. It does not need a softer substitute.

Keep **Cellar** and **Amphora** as the two ways of caring for a resin: one at home, one in motion.

Leave the formula comment for a later word. The page is mirrored byte for byte, so a one-line tighten belongs in a lap that updates both copies together.

## Choices still open

Nothing on this page is seated in the lexicon, the spellbook, or the favorites list. A designing page waits until these choices are confirmed.

1. Resin is the bundle. Vessel is the file. Digest is the address. This is the reading I recommend, because the code already pours, carries, and restores a vessel, and the law already proves a resin by a digest.
2. A vessel may be taught as a resin that holds a season. The word vessel stays in the module.
3. The four-part name stays. The digest remains the check under it, not a replacement for peer, bolt, revision, and path.

*May a bundle keep its name, a file keep its shape, and a short check stay honest the thousandth time you ask.*
