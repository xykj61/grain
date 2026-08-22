# Conway's Law and the Organization That Forgets

**Stamp:** `20260821.211423` - **Language:** EN - **Status:** Living
**Style:** Radiant - **Lens:** TAME - Lindy-first - Two Rooms
**Gratitude:** Melvin E. Conway, *How Do Committees Invent?* (1968)

*Any organization that designs a system will produce a design whose structure is a copy of the organization's communication structure.*

Conway published that in 1968 and it has held for every organization anyone has checked since. Until this page, the tree carried **zero** mentions of it - a silence worth ending, because Conway's Law explains this repository more exactly than any other law it cites.

## The organization, described plainly

Grain is built by one person and a rotating population of agents. The agents share a codebase and share **no memory at all**. Each session begins empty. Whatever the last session learned reaches this one through written artifacts alone, or it is simply gone.

That is the communication structure. One durable human, many amnesiac collaborators, and a single channel between them: **the tree itself.**

## The architecture is a copy of it, feature by feature

Conway says the design will mirror that structure. Look at what stands here:

**Session logs.** A reasoning trace written at the end of every response, for years, indexed newest-first. An organization whose members remember would find this baroque. An organization whose members forget everything nightly would find it the minimum.

**Witnesses on metal.** Nothing here is "working" until a witness prints GREEN - **1,639** of them. A claim cannot survive a context boundary, so a claim is replaced by a program that re-proves itself on demand. *Measurement beats memory* is a slogan in most shops. Here it is a structural necessity, because there is no memory to appeal to.

**The operator card.** One page, read first, every lap. The organization has no standing meeting, so it has a standing document.

**One-clock stamps.** Ordering has to survive between minds that never met. A stamp read from a single canonical clock is how two strangers agree on what happened first.

**The REDS ledger, with three fields.** What went wrong, what caught it, what it taught. The third field exists because the person who made the mistake will be gone before the next one arrives.

**Accrete-never-break.** An organization that forgets cannot safely delete, since it has lost the context that would tell it whether a thing still matters. So the default is to keep, and removal takes an explicit word.

Every one of those is Conway's Law operating on an organization with zero persistent memory. The architecture did what Conway said it would.

## The manoeuvre this makes available

The useful half of Conway's Law is its inverse: **change the communication structure and the architecture follows.** Teams do this deliberately - reorganize the groups to get the system boundaries they want.

Here the communication structure is unusually easy to reach, because it is *made of files*. The operator card, the recursion prompts, the council rota, the rules directory - these are the whole channel between one session and the next. Editing them **is** architecture work, done in prose.

That reframes several ordinary-looking chores:

- Refreshing the card sets what the next session builds. A stale live edge is an instruction, and it will be followed.
- The rota chooses which disciplines stay in living awareness across a long run, which is to say it selects the shape of the code that run will write.
- A rule written down enters the channel. A rule agreed in conversation leaves with the conversation.
- A room's name is read by every future session and by none of the past ones, so naming is a message sent forward.

## The blind spot it names

Conway's Law also warns where the seams will land: **a system's boundaries fall where its builders' communication is thinnest.** For this organization the thinnest communication is between *sessions*, so the seams to watch are the ones a single session can hold entirely in view - a module built inside one context window has an interior nobody re-examines, while a module split across sessions gets its boundary documented, argued, and witnessed.

That predicts something checkable: **the best-specified interfaces here should be the ones that took more than one session to build**, and the least-examined code should sit inside whatever a single long session could finish alone. It is a claim in the proposed room, and a future round can test it against the tree.

## Where it meets the disciplines already seated

- **Single-strandedness** asks each thing to have one clear thread. Conway explains why a tangled thread appears: it mirrors a tangled channel.
- **Silo technique** keeps a design speaking only our own names, which keeps the boundary a design decision rather than an accident of who talked to whom.
- **Docs stay synced** is Conway's maintenance clause - the channel decays faster than the code, so it is repaired in the same commit.
- **Gall's Law** grows the system; Conway's Law predicts the shape it grows into. Read as a pair, they say: grow it, and watch where your own silences are placing the seams.

*May the channel stay clear, may what one session learns arrive whole in the next, and may the seams land where we chose them rather than where we happened to fall quiet.*
