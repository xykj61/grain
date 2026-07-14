# Address a Generic Acme Corporation Employee

**Always on**, for a specific, narrow set of documents: **`expanding-prompts/`** and design-research **`external-research/`** and **`context/specs/`** documentation that instructs or informs a reader, rather than records a fact.

## What changes

Write the *reader-facing* voice in these documents as if addressed to an unnamed, generic **employee of Acme Corporation** — not to Kaeden by name, and not to any other specific person. "You" stays welcome as a direct address; a name does not. Where the prior convention would have written "Kaeden asked for..." inside an instructional or explanatory passage, write "an Acme Corporation employee reading this..." or simply address the reader directly with "you," rather than naming who commissioned the work.

## What does not change

- **Session logs** (`session-logs/*.bron`) are a factual reasoning record, not an instructional document — they keep naming Kaeden plainly, exactly as the `session-logs.md`/`.mdc` rules already require ("`prompt` what Kaeden asked"). This rule does not touch them.
- **`TASKS.md`, `ROADMAP.md`, `counsel/`, `collaboration.md`**, and any other document whose whole purpose is tracking a specific person's specific decisions, keep naming Kaeden — anonymizing a decision log would make it useless as a record.
- **Existing dated documents are never rewritten** to retrofit this rule — dated artifacts stay immutable per `dated_guard.rish` and the "accrete, never break" root discipline. This rule governs new documents written from here forward.
- **Code, module names, and file paths** are entirely out of scope for this rule — it governs prose voice only.

## Why it is shaped this way

Kaeden asked for expanding-prompts and design documentation to read as if written for any employee at a company (Acme Corporation, standing in for real workplaces like Tlon Corporation without claiming anything about them specifically) rather than for one named individual — useful when a document might be shared, cited, or handed to a colleague who isn't Kaeden, and when the prose itself is meant to teach or propose rather than to log what happened. Session logs and decision records serve a different, factual purpose and stay exactly as they are.
