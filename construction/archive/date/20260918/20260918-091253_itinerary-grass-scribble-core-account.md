# Shelved account -- GRASS, `scribble/scribble_core.rye` return-value bounds

**Shelved:** `20260918.091253` on the writer-sheds convention (`.claude/rules/the-writer-sheds.md`)
-- this account stood live on `construction/ITINERARY.md` and is folded whole here as its
predecessor moves aside for a new live GRASS account.

**GRASS -- `scribble/scribble_core.rye` NAMES THREE RETURN-VALUE BOUNDS.** Three functions
returned a count the caller trusts against its own destination slice -- `push_block`'s write index,
`parse_markdown`'s block count, `extract_kind_snippets`'s snippet count (shared by the rye/rish/
plain extractors) -- with no assert restating the bound at the point the count is handed back.
Four invariant asserts now do: `push_block` gets a post-copy `block.text_len <= max_block_text` and
a post-increment `count.* <= blocks.len`; `parse_markdown` and `extract_kind_snippets` each get a
postcondition `count <= out.len` right before their `return`. `scribble/bin/scribble selftest`
GREEN on metal (rebuilt from source, all fifteen welcome/unwelcome cases pass); `tame_style_check`
zero-assert ratchet falls 9 to 8 -- the file drops off the remaining list. `granary/` and
`pond/apps/scribble/` hold symlinks to this one file, so both apps carry the same asserts with
nothing further to touch. **YOURS, CARRIED FORWARD:** the silo README's C composite on a
pre-existing reading (front-door account); the coordination law's exemption question from `%819`
and the fleet's 271-tool `head -N` judgment `%804` (baton exemption account); THREADS.md's
pointer-stub-vs-in-place question and which of its ten threads carry forward (reverse-reading
account). `tally/pedersen.rye`'s exempt-list-vs-forced-assert question is answered below by Grass --
exempt, as a pure re-export shim. The zero-assert ratchet now names 7 files; the next agent-doable
pick is any of them, claim-board checked first.
