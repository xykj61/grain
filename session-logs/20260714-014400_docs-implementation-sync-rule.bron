format session-log-v1
stamp 20260714.014400
editor Cursor
model Sonnet 5 1M Medium
voice Rio 3
host macOS 26.6 arm64 (Apple M2) — see context/specs/20260713-211800_local-host-system-hardware-anonymized.md
title A new root rule and an always-on agent rule pair: docs and implementation stay synced
prompt Keaton asked for Cursor/Claude rules, and an expansion of TAME Guidance, asserting that implementation and docs are always synced and checked.
think Checked what already exists before adding anything, since duplicating an existing mechanism would be its own kind of drift: tools/living_docs_lint.rish already checks five real duties (retired words, broken links, orphan pages, Status rooms, pin-string byte-match) -- all mechanical hygiene among docs themselves. Nothing existing checks whether a doc's behavioral claim still matches what the code actually does, which is the real gap Keaton named.
think Placed the new discipline as TAME_GUIDANCE.md root rule 9, extending rules 3 (say why) and 6 (state invariants positively) to the doc/code boundary rather than inventing an unrelated new category -- a doc's claim about behavior is itself an assertable invariant, and should be checked the same way a struct's invariant is checked, not merely believed because it was once true.
think Wrote the rule as a ratchet, not a sweep, matching rule 4 (accrete, never break) and the project's own established as-you-touch discipline elsewhere in TAME -- tighten sync wherever a doc or its code is already open for other reasons, rather than a tree-wide pass that would itself become the kind of large, hard-to-review change the small-PR goal exists to avoid.
think Tied the rule to Two Rooms directly: a doc's claim belongs in the checkable room only once a witness actually binds it: an unwitnessed claim should be named as intent or horizon, not stated as settled fact -- giving the new rule a concrete, already-seated vocabulary to lean on rather than inventing its own.
think Wrote the matching always-on Cursor/Claude rule pair (docs-implementation-sync.mdc/.md), mirroring session-logs.mdc's exact frontmatter and file-pair convention, so the operational instinct -- read or run before citing, update the doc in the same commit as the behavior change, don't sweep -- lives where the agent actually reads rules, not only in the operational supplement a human reads at the keyboard.
file context/TAME_GUIDANCE.md why: new root rule 9, and a pointer to the new rule pair beside the existing tame-guidance.mdc/.md pointer
file .cursor/rules/docs-implementation-sync.mdc why: always-on agent rule -- check before citing, update in the same commit, ratchet not sweep
file .claude/rules/docs-implementation-sync.md why: matching Claude rule, same content
recommend keep-going -- this is a rule addition, not a code change; nothing to witness beyond the rule text itself reading correctly, which the lint pass just confirmed clean.
