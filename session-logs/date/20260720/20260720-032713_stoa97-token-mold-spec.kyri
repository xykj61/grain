format session-log-v1
stamp 20260720.032713
editor Cursor
model Cursor Sonnet 4.6
voice Rio 3
title STOA97 token→MoldSpec rewrite GREEN
prompt Implement STOA97 lean A: make parse_source in glow/rune_mold.rye build MoldSpec from the Glow token stream, retiring lower_multi.collect_lines and byte-level digraph head parsing inside that function.
think Read glow/tokens.rye to map the full Kind enum and tokenize/slice_of API; confirmed rune2 carries "+$"/"$:"/"$%", double_equals carries "==", percent_tag carries "%name", equals/aura/tilde/lbracket/rbracket are all distinct kinds.
think Read existing parse_source in glow/rune_mold.rye — it called lower_multi.collect_lines, built a lines array, then byte-scanned each line for "+$"/"$:"/"$%"/"==" heads and "face=@u32"/"[%tag ~]" bodies.
think Traced every mold desk (amount-mold, pair-mold, kind-mold, xact-mold, xfer-mold) through the tokenizer to confirm exact token sequences: "+$" ident newline "$:" ident equals aura newline ... double_equals; "$%" lbracket percent_tag (tilde | ident equals aura ...) rbracket newline ... double_equals.
think Planned new parse_source: tokenize src → walk with u32 cursor i; skip leading newlines; require rune2("+$"); require ident(name); skip newlines; branch on body rune "$:" or "$%"; for $: loop ident-equals-aura until double_equals; for $% loop lbracket-percent_tag-(tilde|faces)-rbracket until double_equals; verify trailing tokens are newlines only.
think Noted tokens.rune2_is is private (lowercase); wrote inline rune2_text_is helper using tokens.slice_of + std.mem.eql.
think Replaced lower_multi import with tokens + tally_copy; added const assert = std.debug.assert; rewrote push_name and push_tag as push_name/push_tag_unit/push_tag_faces using copy_disjoint instead of @memcpy; used u32 for all new loop counters with @as(usize,@intCast) seam casts at index sites.
think Mapped TokenError to ParseError: EmptySource→EmptySource, TooManyTokens→NotAMold, BadToken→NotAMold.
think Updated witness_version in rune_mold_witness.rye from 20260719.194808 to 20260719.232000; updated GREEN string to include "STOA97 token→MoldSpec"; added STOA97 assertion to tools/glow_rune_mold_witness.rish.
think Ran all four witnesses: glow_rune_mold_witness (GREEN), glow_lower_mold_witness (GREEN), glow_lower_named_cast_witness (GREEN), glow_run_desk_witness (GREEN — full desk suite, 142 s).
obs All existing tests pass unchanged; same public API; lower_mold and lower_named_cast call parse_source identically — no edits to either. The lower_multi import is gone from rune_mold.rye; tally_copy and tokens enter. Error mapping preserves MoldNotU32 and TooFewTags exactly as witnesses require.
obs The faces[] array in the $% payload arm parse holds []const u8 slices into src; copy_disjoint copies them into spec.payloads before the function returns — slices remain valid for the duration.
obs TooFewLines/TooManyLines/MissingTuple remain in ParseError set (no removal); only their emission paths change — now structural token failures map to other existing errors. Witness scripts do not check those specific errors by name.
file glow/rune_mold.rye complete token-based parse_source; lower_multi import retired; tokens+tally_copy added; copy_disjoint throughout; assert contracts at preconditions; u32 counters
file glow/rune_mold_witness.rye witness_version bumped to 20260719.232000; GREEN string adds STOA97 token→MoldSpec
file tools/glow_rune_mold_witness.rish STOA97 assertion added; say line updated
recommend check-in STOA97 lean A is complete and all four witnesses are GREEN; parent agent owns commit. Next step if any: STOA98 or further TAME tightening on rune_mold if the 256-roster ceiling is ever lifted for this file.
