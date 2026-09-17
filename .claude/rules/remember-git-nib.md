# ITINERARY Git Nib -- Same Commit (seated `20260728.205029`)

When a send updates `construction/ITINERARY.md` **Git nib**, that update lands **in the same work commit** as the round's work (and session log when possible).

## Refuse

- A follow-up commit whose subject is only `construction: pin ITINERARY git nib` (or `construction: pin ITINERARY...`).
- Two-commit send pairs (work - then pin) for scroll noise.

**A follow-up that carries real content counts as a work commit rather than a pin-only one.** Rule 5 asks such a commit to
move the pin *as well*; what stays refused is a commit whose whole content is the pin.

## How

1. Stage ITINERARY with the round's finishing-edge / bookmark updates in the **work** commit.  
2. After that signed commit -- and after the final rebase, when the send takes one -- amend **at most once** so **Git nib** names `git rev-parse --short=10 HEAD~1`: **HEAD's parent**, a commit the round was built on and therefore one every clone already resolves. Writing pre-amend HEAD names the sibling state -- an object no other clone holds -- which stood as a fleet-wide double-red on five bodies out of six, every lap (REDS %401). **The tool's word for this move is `amend`:** `rishi/bin/rishi run tools/r/remember_git_nib.rish write amend`.  
3. **Stop.** Further amends chasing a perfect fixed-point hash are out of scope -- the card may lag HEAD by one amend; `prin scope` is living HEAD.
4. A pin-only follow-up stays off the remote.
5. **A follow-up carries the nib forward too** (REDS %450, `20260906`). When a send lands a commit on top of the work commit -- a session log recording facts that did not exist until the send was over -- that commit stages `construction/ITINERARY.md` with **Git nib** rewritten to `git rev-parse --short=10 HEAD`, read **before** the follow-up is committed. That HEAD becomes the follow-up's parent, so the card lands in the same `parent` state rule 2 aims for. **Rule 2's amend is spared here**: the final rebase is already behind the send, so the parent is known before the commit is made rather than after it. **The tool's word for this move is `follow-up`:** `rishi/bin/rishi run tools/r/remember_git_nib.rish write follow-up`.

## The writer names its shape, and refuses to guess (REDS %803, `20260917`)

**Rules 2 and 5 name commits one apart, and for nine days one tool derived one of them.**
`tools/r/remember_git_nib.rish` computed `HEAD^` whatever it was asked, so a lap running it exactly
as rule 5 asks pinned the **grandparent**. That hash resolves and sits an ancestor of HEAD, which
puts it one step past every state `tools/r/remember_git_nib_witness.rish` accepts, so the guard reds
on the next lap and names a round that already passed.

| You are about to | Say | It writes |
|---|---|---|
| amend after the final rebase (rule 2) | `write amend` | `HEAD^` |
| commit a follow-up on top of the work commit (rule 5) | `write follow-up` | `HEAD` |
| read both before deciding | no argument at all | nothing -- it prints both, each beside its rule |

**A write carries its shape, and one that names none stops at the door with the card still closed.** Nothing the program can read tells a
lap about to amend from a lap about to commit afresh: both stand at the same HEAD, with the same
index, in the same tree, and the difference lives entirely in what the hand does next. A writer that
picks for you is right half the time and silent about it, which costs more than the hand it replaced --
**a tool's answer carries an authority a hand's guess lacks**, so a wrong one travels further. So the bare render prints both candidates rather than one a hand will copy.

**Proven on real git repositories**, 34 legs in a throwaway pen under
[`../../tools/fixtures/r/remember_git_nib_shape_control.sh`](../../tools/fixtures/r/remember_git_nib_shape_control.sh),
every refusal planted and then lifted, **four mutations bitten**. The centrepiece runs the row's own
red rather than arguing it: two identical pens are carried to one commit, each writes its shape, each
then makes the follow-up commit this rule describes, and the guard's **own** state predicate -- copied
verbatim -- is asked what it sees. The follow-up shape reads `parent`; the amend shape reads `stale`.

**What stands beyond this repair: the contested send.** Rule 2 pins HEAD's parent after the *final* rebase,
and on a pier where peers land mid-send there is no final rebase -- one ship rebased three times in
twelve minutes, each replay moving its commit so the pin named the pre-rebase parent. Amending a
pushed commit is refused by `xy` as a non-fast-forward, correctly and never answered by force; a
pin-only follow-up is refused by this rule in its own words. So a correct contested send can still
leave the guard RED on a pin that resolves and is an ancestor of HEAD, one commit short. **A shape word leaves that one
standing**, and the convention it questions is Keaton's word. The row stays OPEN for that half.

## An amend asks whether a rebase is standing (`20260906.230614`)

**`git commit --amend` inside a conflicted rebase rewrites a PEER'S commit.** Mid-rebase, `HEAD` is
the last successfully applied commit -- which, on a tree that just pulled, is somebody else's. A send
that chains its steps as one command (`pull`, pin, `git add -A && git commit --amend`) has no state
between the links, so a pull that stops on a conflict hands the amend a HEAD it never meant to touch.
Rule 2's amend then folds the whole lap into a peer's commit, `rebase --continue` finds the lap's own
commit empty and drops it, and the log reads as though the lap never happened -- the red booked
at `20260906.230614`, cited by stamp here until the anointed spine binds its number
([`derived-spine`](derived-spine.md) rule 4).

**So step 2 begins by asking.** `[ -d .git/rebase-merge ] || [ -d .git/rebase-apply ]` answers in one
test; a standing rebase is finished or aborted before any amend. The same sentence is already seated
one room over for the round-open -- *do not run `git rebase --continue` on a tree that opens
mid-rebase* ([`the-baton`](the-baton.md)) -- and it is owed to the send for the same reason: **a
rebase is a state, and a chained command carries none.**

**What made this recoverable rather than a loss:** nothing had been pushed, so upstream held the
peer's commit at its own hash throughout, and `git diff` between that commit and the amended one
named exactly the lap's own files -- which is what proved the peer's work was otherwise untouched
before anything was reset.

## Why

Pin-only commits doubled Surface Chapter history and hurt `git log` scroll reading. Keaton seated this tidy `20260728.205029`.

**Why rule 5 exists.** [`../../tools/r/remember_git_nib_witness.rish`](../../tools/r/remember_git_nib_witness.rish) accepts three states -- the nib names HEAD, HEAD's pre-amend sibling, or HEAD's parent. A follow-up commit moves HEAD one further, so a nib pinned at the work commit's parent becomes `HEAD~2` and the guard reds on the next lap, naming a round that already passed. Neither rule reached the other: [`session-logs.md`](session-logs.md) permits a log-only follow-up as *a last resort*, and this rule forbade only a **pin**-only one, so a lap that told the truth about an eventful send reddened a standing guard. Proven in a pen against the guard's own predicate, copied verbatim: the same follow-up reads `stale` with the card untouched and `parent` with the nib carried forward.

Canonical Cursor twin: `.cursor/rules/remember-git-nib.mdc`.  
Counsel: `counsel/date/20260728/20260728-205029_surface-season-history-tidy-remember-pin-squash.md`.
