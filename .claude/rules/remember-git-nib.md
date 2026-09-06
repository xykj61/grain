# ITINERARY Git Nib -- Same Commit (seated `20260728.205029`)

When a send updates `construction/ITINERARY.md` **Git nib**, that update lands **in the same work commit** as the round's work (and session log when possible).

## Refuse

- A follow-up commit whose subject is only `construction: pin ITINERARY git nib` (or `construction: pin ITINERARY...`).
- Two-commit send pairs (work - then pin) for scroll noise.

**A follow-up that carries real content is not a pin-only commit.** Rule 5 asks such a commit to
move the pin *as well*; what stays refused is a commit whose whole content is the pin.

## How

1. Stage ITINERARY with the round's finishing-edge / bookmark updates in the **work** commit.  
2. After that signed commit -- and after the final rebase, when the send takes one -- amend **at most once** so **Git nib** names `git rev-parse --short=10 HEAD~1`: **HEAD's parent**, a commit the round was built on and therefore one every clone already resolves. Writing pre-amend HEAD names the sibling state -- an object no other clone holds -- which stood as a fleet-wide double-red on five bodies out of six, every lap (REDS %401).  
3. **Stop.** Further amends chasing a perfect fixed-point hash are out of scope -- the card may lag HEAD by one amend; `prin scope` is living HEAD.
4. A pin-only follow-up stays off the remote.
5. **A follow-up carries the nib forward too** (REDS %450, `20260906`). When a send lands a commit on top of the work commit -- a session log recording facts that did not exist until the send was over -- that commit stages `construction/ITINERARY.md` with **Git nib** rewritten to `git rev-parse --short=10 HEAD`, read **before** the follow-up is committed. That HEAD becomes the follow-up's parent, so the card lands in the same `parent` state rule 2 aims for. **No amend is needed here, unlike rule 2**: the final rebase is already behind the send, so the parent is known before the commit is made rather than after it.

## Why

Pin-only commits doubled Surface Chapter history and hurt `git log` scroll reading. Keaton seated this tidy `20260728.205029`.

**Why rule 5 exists.** [`../../tools/r/remember_git_nib_witness.rish`](../../tools/r/remember_git_nib_witness.rish) accepts three states -- the nib names HEAD, HEAD's pre-amend sibling, or HEAD's parent. A follow-up commit moves HEAD one further, so a nib pinned at the work commit's parent becomes `HEAD~2` and the guard reds on the next lap, naming a round that already passed. Neither rule reached the other: [`session-logs.md`](session-logs.md) permits a log-only follow-up as *a last resort*, and this rule forbade only a **pin**-only one, so a lap that told the truth about an eventful send reddened a standing guard. Proven in a pen against the guard's own predicate, copied verbatim: the same follow-up reads `stale` with the card untouched and `parent` with the nib carried forward.

Canonical Cursor twin: `.cursor/rules/remember-git-nib.mdc`.  
Counsel: `counsel/date/20260728/20260728-205029_surface-season-history-tidy-remember-pin-squash.md`.
