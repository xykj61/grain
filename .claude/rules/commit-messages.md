# Commit Messages — Rio 3, Radiant, CONTRIBUTING-Style

**Always on.** Every commit in this tree follows Urbit's own `CONTRIBUTING.md` shape, written in Rio 3's Radiant Style — never a bare terse line, never an unexplained diff.

## Subject line

- **Component-prefixed**: the short prefix names the area the commit touches — `context:`, `external-research:`, `work-in-progress:`, `session-logs:`, `rye:`, `rishi:`, and so on, matching the directory or module the change lives in. If a commit truly spans more than two or three components, that is usually a sign it should be split, not a reason to list every component.
- **Under 50 characters total** (prefix and description combined), per Urbit's own `CONTRIBUTING.md` — short enough to read in a `git log --oneline` without wrapping.
- **Written plainly**, present tense, describing what the commit does — "add," "fix," "propose," "rename" — not what it *will* do or *has* done.

## Body

Every commit body carries, in Radiant Style:

- **A short paragraph** naming what changed and why it matters, in the same honest, affirmative voice as this project's prose everywhere else — no filler, no hedging, no "this commit aims to."
- **A `Related` section**, even when there is no tracked issue to resolve — name the companion docs, the session that produced this change, or state plainly "no related work" rather than omitting the section. When a tracking issue exists, lead the body with Urbit's own `Resolves #<N>.` line before the description.
- **Nothing left undescribed.** A commit that touches multiple files names what each significant one contributes, rather than letting the diff speak for a change the message doesn't.

## Voice

Commit messages speak in **Rio 3's** voice: the same sweet, capable, affirmative register as everything else in this tree. A commit message is a small piece of prose, not an exception to Radiant Style.

## Worked example

```
context: propose Urbit-parallel naming mapping, no renames yet

Maps every Rye OS module to either a proposed Arvo/vane parallel, a
Gall-agent parallel, or an honest "no analog -- stays Rye-named" verdict.
Every proposed rename carries a grep-counted inbound-reference number so
future migration PRs can be sized against Urbit's own small-PR grants
discipline.

Related

Zero files renamed by this commit; Kaeden is still reviewing before any
migration proceeds.
```

## Why it is shaped this way

Urbit's own `CONTRIBUTING.md` already earns trust from a large, careful open-source community with exactly this discipline — atomic, component-scoped, briefly justified. Borrowing it directly, in our own voice, means every future contributor (human or agent) reads a commit history that explains itself, the same way `git log --show-signature` already proves who wrote it and TAME's own "say why" rule already governs code comments.
