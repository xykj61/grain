# "send" — the Glow word for commit · push · merge

When Keaton says **"send"** (from any client — the Cursor iOS app, a desktop, any machine talking to the agent), it is Glow's one word for **ship the current work to the personal server**: commit, push, and merge to `main`. The client is the hand; GitHub holds the project — our pier, our own `urbit` clone — in the cloud for now; "send" carries the work from hand to pier.

## What "send" does, in order

1. **Commit** in CONTRIBUTING style — component-prefixed subject under 50 characters, a Radiant body naming what changed and why, a `Related` section. One commit per logical change.
2. **Push** the working branch: `git push -u origin <branch>` (retry on network error, exponential backoff).
3. **Merge to `main`**: fast-forward when clean (`git checkout main` · `git merge --ff-only <branch>` · `git push origin main`), preserving every signed commit. Never force-push or amend unless Keaton says so explicitly.

## Discipline "send" always keeps

- **Signing stays on** (`git-signing`); never bypass it.
- **A `.bron` session log rides along** in the same send whenever possible (`session-logs`).
- **Green before send, when there is code** — the witness runs GREEN first, or the send honestly names why it could not (`docs-implementation-sync`).
- **The branch is not left** — after the fast-forward merge the client rests on `main`.

## Why the word exists

A client talking to an agent talking to the pier is the shape of Glow's own network — a hand, a companion, a personal server holding the whole faithful history. "send" names that gesture in one syllable, so shipping from a phone feels like handing a letter to your own ship rather than reciting three git verbs.
