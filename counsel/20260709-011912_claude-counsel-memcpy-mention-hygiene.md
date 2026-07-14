# Claude Counsel — the `@memcpy` Mention, Checked Before Fixed

**Stamp:** `20260709.011912 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the same one-clock law that already protects every dated session log, applied here to commit messages for the first time
**Register:** A real, concrete finding from a screenshot, checked before acted on — good news underneath, a small forward-looking fix on top, and a deliberate choice not to touch history
**Ground:** GitHub's own changelog, checked directly before writing anything here, rather than assumed from memory of older behavior

*Written by Kaeden and Rio 3.*

---

## What the Screenshot Actually Showed

GitHub's per-folder commit list bolds `@memcpy` in two recent commit subjects, and bold rendering in that exact spot is GitHub's own signal for a linkified, valid account mention — which means a real GitHub user or organization is genuinely named `memcpy`, and this repo's commit messages have been coincidentally referencing them every time a commit talks about the Zig builtin this tree has been ratcheting down all week.

## The Good News, Checked Rather Than Assumed

This bench did not want to recommend anything — rewrite history, change nothing, anything in between — without first knowing whether the underlying worry was even still true. It checked GitHub's own changelog directly: **GitHub removed the notification triggered by commit-message mentions in November 2025**, months before this project's own commits began. The bold rendering Kaeden saw is real and still happens — GitHub still linkifies the text; yet the notification that used to accompany it does not fire anymore. No one has actually been pinged, on this repo or any other, by any of this tree's many honest mentions of the memcpy builtin.

## Why This Changes the Right Answer, Not Just the Urgency

Because nothing has actually been sent, rewriting history to erase the bold text would purchase a purely cosmetic improvement at the cost of force-pushing four remotes in perfect sync — real risk, for zero real-world benefit. This tree already keeps a law for exactly this shape of question: dated artifacts stand as written, never rewritten, because they are a historical record of what was true and known at the time. A commit message is as dated an artifact as a session log, and this bench recommends treating it the same way. Old commits keep their bold `@memcpy` exactly as they are; nothing about them was ever wrong, only coincidentally styled in a way GitHub's renderer treats specially.

## What Actually Changed, Going Forward

`.claude/rules/git-signing.md` gained a new section, and its Cursor counterpart — which this bench discovered did not exist at all, unlike every other rule file's matching pair — was written fresh to carry it. The rule is precise about where it applies and where it does not: commit **subject and body text** should name a Zig builtin without its leading `@` — "the memcpy builtin," never a bare `@memcpy` — because GitHub's commit-message renderer linkifies regardless of backticks there. **File content, counsel, and documentation** keep the `@` and the backtick exactly as this tree's style already writes it, since full Markdown rendering already handles a backtick-wrapped `@memcpy` correctly, and nothing in `TAME_GUIDANCE.md` or anywhere else needed to change.

---

*May a worry always be checked before it is acted on, so the fix that follows is the fix the truth actually asked for. May a dated commit keep its own words exactly as spoken, the same courtesy this tree already gives every session log. And may the next builtin that happens to share a name with a stranger be caught by a rule already written, rather than a screenshot taken after the fact.*
