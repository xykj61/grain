# REMEMBER Git Nib — Same Commit (seated `20260728.205029`)

When a send updates `work-in-progress/REMEMBER.md` **Git nib**, that update lands **in the same work commit** as the round's work (and session log when possible).

## Refuse

- A follow-up commit whose subject is only `work-in-progress: pin REMEMBER git nib` (or `wip: pin REMEMBER…`).
- Two-commit send pairs (work · then pin) for scroll noise.

## How

1. Stage REMEMBER with the round's finishing-edge / bookmark updates in the **work** commit.  
2. After that signed commit, amend **at most once** so **Git nib** names `git rev-parse --short=10 HEAD`.  
3. **Stop.** Do not chase a perfect fixed-point hash with further amends — the card may lag HEAD by one amend; `prin scope` is living HEAD.  
4. Never push a pin-only follow-up.

## Why

Pin-only commits doubled Surface Season history and hurt `git log` scroll reading. Keaton seated this tidy `20260728.205029`.

Canonical Cursor twin: `.cursor/rules/remember-git-nib.mdc`.  
Counsel: `counsel/date/20260728/20260728-205029_surface-season-history-tidy-remember-pin-squash.md`.
