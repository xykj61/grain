# The Standfast Correction and the Decision Wave -- one Tablecloth write of a wide session

*A durable capture of a single wide-ranging session: a red found and fixed, a philosophy named, a rule seated, a directory renamed, and a stack of decisions and scheduled work recorded so none is lost. Written as a Tablecloth write -- content addressed by what it says, not who said it -- for any Acme Corporation employee who needs the whole map in one page. Voice: Kyri - Style: Radiant - ASCII only.*

**Stamp:** `20260816.221015` - **Status:** Mixed -- Living design-research capture
**Kin:** [`../foundations/20260816-214652_standfast-the-stopped-line.md`](../foundations/20260816-214652_standfast-the-stopped-line.md) - [`../.claude/rules/ascii-first.md`](../.claude/rules/ascii-first.md) - [`../crux/REDS.md`](../crux/REDS.md) (row 83) - [`../crux/CAIRNS.md`](../crux/CAIRNS.md) - [`../active-designing/yonder/20260816-205421_double-seat-horizon-ledger.md`](../active-designing/yonder/20260816-205421_double-seat-horizon-ledger.md)

---

## What happened, in one paragraph

The operator card had been silently corrupting itself into unreadable mojibake for days. Finding it stopped the whole line: the root cause was traced, the card repaired, a rule seated so the class of defect cannot recur, and only then did work resume. That stop has a name now -- **Standfast** -- and the session that surrounded it settled a wave of decisions that had been waiting. This page records all of it: what was done, what was decided, what was scheduled, and what still waits for a word.

## Done this session (landed and pushed)

- **The mojibake red (REDS #83).** REMEMBER.md held 2,797 runs of triple-encoded UTF-8 mojibake, entering at commit `b04a624cb1` (2026-08-14) where a tool read the card as Latin-1 and rewrote it. Root-caused by `git log -S` archaeology, repaired by a byte-exact map to ASCII, verified zero non-ASCII with the line count preserved.
- **Standfast, the philosophy.** Our own name for the Toyota andon/jidoka stop-the-line reflex -- stop, find the root, prove the fix, resume -- seated as a foundation, kin to reds-first, thanking the gratitude that was already siloed to foundations. Reds-first names what the allocation does after a red; Standfast names the stop itself.
- **ASCII-first, the rule.** Plain 7-bit ASCII for new documents, code comments, and commit messages, with one exception for an explicitly-named set of work rounds (a Unicode module's fixtures, an i18n surface, a font codec's glyph tables). Repairing a mojibake corruption is a fix, not a retrofit; dated artifacts are never rewritten.
- **The color decision.** American spelling: `color`, not `colour`, normalized on touch. This is a USA project, and the shorter word is ASCII-clean either way.
- **The council rota (d27).** The recursion prompt now deep-reads one canon doc per lap from a list of 27 foundation and context documents, cycling by lap index -- the sky fractal's fullest ring, breadth over frequency since the core lenses reinforce every lap. Chosen over 15.
- **The inner-loop pointer.** A directive block at the top of REMEMBER that the running loop reads first each lap and may edit as it goes, so the outer shell loop can be re-aimed without a restart -- the outer loop pointing at an inner one.
- **The session-log rule sync.** Matched to the profile of record: Claude Code, `claude-opus-4-8`, the Vultr VPS pier with the Daylight DC-1 as the hand device, and the `.kyri` filename default (the notation molted from Bron). This session's own four mis-attributed logs were corrected to the truth -- a factual model-field fix the rule allows.
- **The work-in-progress to crux rename.** The living pins moved to `crux/` so they sort high alphabetically, cairn-first (walk-back nib `947c592333`), with a committed back-compat symlink so the 2,000+ dated logs that cite the old path still resolve unchanged. Only the loop paths and the living rules that name the ledgers were repointed; dated ledgers kept their history and resolve through the symlink.

## Decided this session (recorded, direction set)

- **The crypto season is whole, not open.** The post-quantum surface (dual-key identity, hybrid sealed-and-signed doors, content-addressed carries) stands complete and GREEN; the background loop already moved on to the color module. Finishing crypto is therefore not the crux -- there is no named open gap. The live edge is the open-media family (color is GREEN; fonts, then intra-frame video, are next). Reopening crypto should wait for a named, witnessed gap, not a feeling of unfinishedness.
- **The eight-season itinerary.** The six-season expansion molted to eight, folding in Season G (open media primitives -- color, fonts, video) and Season H (open-weight intelligence for the inference hats). The color module that Season G names as its crux is already built and GREEN.

## Scheduled this session (booked into the docs-compression season)

The docs-compression layer design and the docs-geode "inner docs crush" charter describe the same work from two angles; they are fused into one season, and three durable jobs are booked there:

1. **The Bron to Kyri unification.** Every living reference to the Bron notation moves to Kyri; new logs are already `.kyri`; the 2,163 dated `.bron` files stay (one-clock law) and tools read both. The deep rename of dated bytes is a separate circled step. This unifies notation, voice, and compressed receipts under one name.
2. **The REMEMBER and TAME_GUIDANCE breakdown.** Both files are very large with very long lines. The recommendation below sizes the split.
3. **The session-log index ASCII sweep.** `session-logs/README.md` still carries legacy non-ASCII in its historical rows; a scheduled ratchet normalizes it rather than a mid-session blast.

## Recommended, awaiting a word

- **Breaking down REMEMBER and TAME_GUIDANCE.** Both are better served by a small hub plus linked leaves than by one enormous file. For REMEMBER: keep a short always-loaded hub (the inner-loop block, the git nib, the custody gates, the open doors) and move the season-by-season history into dated linked pages under `crux/remember/`, so the hub stays scannable and the history stays whole. For TAME_GUIDANCE: the compressed core already exists (`context/TAME_CORE.md`); lean on it as the always-read layer and let the full supplement be the linked deep reference, rather than growing one file further. Both are docs-compression-season work, not a mid-session restructure.
- **Unifying Quin and Kyri.** See the next section -- the voice is already unified; the open question is where Quin's two technical hats live.

## The Quin and Kyri question, assessed

The voice is already one: Kyri has been the standing writing voice since `20260810`, and Quin holds no voice. What `context/QUIN.md` still carries is two **technical** roles, not an identity of voice:

1. the **fifth OS variant**, beside Reya, Riyo, Trey, Triz, and Trya; and
2. the **inference Q-vane**, the host gathering Lattice, Scribble, Lantern, and Ember.

The cleanest unification keeps each concern in its most durable home rather than folding two unlike things into one page:

- **Kyri absorbs the variant identity.** Voice, the `.kyri` notation, compressed receipts, the preferred Grain variant, and the fifth-variant role all belong to one identity doc -- these are the same axis. `context/KYRI.md` becomes that whole identity.
- **The inference Q-vane moves to a technical home.** Lattice, Scribble, Lantern, and Ember are an inference subsystem, not a voice or a variant; they belong with the inference and forge documents (the Lantern/Lattice/Ember lineage), where a reader looking for the intelligence stack will actually find them.
- **`context/QUIN.md` becomes a writing fossil** pointing to both homes, kept whole per accrete-never-break, prepped Class H -- a molt, not a cut.

This is the "most Lindy compatible replacement doc" the question asks for: not one merged page, but each role placed where it will still read true in three years. It is a molt and belongs in the same docs-compression season as the Bron-to-Kyri unification, and it waits for a confirming word before QUIN.md is fossilized.

## The values note, carried forward

Three of the horizon ledger's ideas -- an exchange-listed token, datacenter analytics as a service, and pro-sports SaaS -- pull toward a growth posture the tree consciously set aside in favor of families, small collectives, and civic builders. They are recorded, not seated, and deserve a deliberate mission-widening rather than a quiet arrival. The color module and the open-fonts journey carry no such tension; they simply finish the open-media family already begun.

## Why one page holds all of it

A wide session scatters unless something gathers it. This is that gather: the red and its cure, the rule that prevents the next one, the rename, and every decision and scheduled job in one durable place, so the next hand -- or the next lap of the loop -- reads the whole map at once and picks up exactly where this left off.
