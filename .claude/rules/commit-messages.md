
# Commit Messages -- Kyri, Gauge, CONTRIBUTING-Style

**Always on.** Every commit in this tree follows Urbit's own `CONTRIBUTING.md` shape, written in Kyri's voice at the **Meter** setting of [Gauge Style](gauge-style.md) -- exact, mechanism-first, refusal-aware, because a commit body's subject genuinely is what changed and what it caught. Never a bare terse line, never an unexplained diff.

## Subject line

- **Component-prefixed**: the short prefix names the area the commit touches -- `fleet:`, `seed:`, `logs:`, `rye:`, `rishi:`, and so on, matching the directory or module the change lives in. The prefix and the description are lowercase. If a commit truly spans more than two or three components, that is usually a sign it should be split, not a reason to list every component.
- **Under 50 characters total** (prefix and description combined), per Urbit's own `CONTRIBUTING.md` -- short enough to read in a `git log --oneline` without wrapping.
- **Written plainly**, present tense, describing what the commit does: add, fix, aim, record.

## Body

Every commit body carries, at Gauge's Meter setting:

- **A short paragraph** naming what changed and why it matters, in the same honest, affirmative voice as this project's prose everywhere else. Name at least one file, call, or field in that paragraph, so a reader can reconstruct the change.
- **A `Related` section**, even when there is no tracked issue to resolve. Name the session log file that rides in the commit, or state plainly "no related work". When a tracking issue exists, lead the body with Urbit's own `Resolves #<N>.` line before the description.
- **Nothing left undescribed.** A commit that touches multiple files names what each significant one contributes, rather than letting the diff speak for a change the message doesn't.

## Voice

Commit messages speak in **Kyri's** voice: the same sweet, capable, affirmative register as everything else in this tree. A commit message is a small piece of prose. Its setting is **Meter** -- exact and mechanism-first -- and Gauge's first rule still governs it: don't be too smart about it.

## Worked example

```
fleet: aim case 4 at the receipt card

The construction/ITINERARY.md file and the recursion-prompts/diffuser-inner.md
file now name acceptance case 4 for the Receipt Card. The snapshot witness
call and the refusal-chain witness call both returned GREEN.

Related
session-logs/date/20260922/20260922-201705_case-4-is-the-card.kyri
```

## Why it is shaped this way

Urbit's own `CONTRIBUTING.md` already earns trust from a large, careful open-source community with exactly this discipline -- atomic, component-scoped, briefly justified. Borrowing it directly, in our own voice, means every future contributor (human or agent) reads a commit history that explains itself, the same way `git log --show-signature` already proves who wrote it and TAME's own "say why" rule already governs code comments.
