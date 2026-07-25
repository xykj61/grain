# Component — Naming Proposal

**Purpose:** propose a name for a module, language, or variant with real collision research and an honest migration-cost estimate — so the name can be confirmed or denied, not guessed.

**Tokens**

- `{{THING}}` — what needs a name (a module, a kernel variant, a vane bundle).
- `{{CANDIDATES}}` — the candidate name(s) to weigh.
- `{{ROLE}}` — the role the name must fit (kernel vane, language, shell, umbrella).

---

## The Expanded Prompt (fill the tokens, then run)

Propose a name for **{{THING}}** from the candidate(s) **{{CANDIDATES}}**, which must fit the role of **{{ROLE}}**. Follow this fork's own naming discipline:

1. **Search the world, current-date.** For each candidate, web-search for existing programming languages, kernels, projects, and trademarks. Report real collisions plainly — including soft collisions (adjacent-domain projects) and collisions with this fork's *own* retired names (as "Reya" collided with the retired Reya 2 voice).
2. **Check the fit.** If the role is a vane, confirm the four-letter convention and the alphabet position. If it is a rename of an existing module, grep the inbound-reference count so the migration cost is a real number, not a guess.
3. **Recommend without deciding.** Give a clear recommendation with reasoning, but leave the confirm/deny to Keaton — add the candidate to `context/specs/20260713-235600_names-awaiting-confirmation.md`.
4. **Do not rename anything.** Recording a proposal is not executing a migration; migrations wait for Keaton's word and go cheapest-first.
5. **Log it** — bron session log, Pacific stamp, and if the name could matter past this fork, a Galaxy Pitch block.

**Produces:** a new row (or section) on the names-awaiting-confirmation checklist; a bron session log; commits pushed to both remotes.
