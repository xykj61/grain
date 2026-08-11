format session-log-v1
stamp 20260811.192204
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Wire the cookbook into the Rishi interpreter — clamp, the first cookbook→builtin
prompt kg wire the cookbook into the interpreter, baton prin recur
think rishi/src/main.rye runs every witness, so this was high-stakes: narrow-scope to ONE builtin, mirror an existing one exactly, rebuild, then prove no regression across the full suite before adding more
think surveyed existing builtins first — join/split/sort/unique/upper/slice already exist; the genuinely new cookbook verbs are chunk/window/flatten/clamp; chose clamp first (simplest, mirrors do_slice's three-int-operand pattern via TokenIter/eval_operand)
obs wired do_clamp: two EvalError variants (ClampNeedsInt · ClampBadBound), the fn (well-ordered-bound invariant + in-range postcondition, split asserts), and dispatch at BOTH the statement (~1102) and expression (~2338) sites, mirroring slice; the interpreter reimplements the cookbook primitive in its own i64 Value model
obs rebuilt rishi/bin/rishi (exit 0); clamp 5 1 10→5, 0 1 10→1, 99 1 10→10; added rishi/tests/clamp.rish (in-range · below · above · edges · degenerate bound · composed expr); FULL suite 21/21 GREEN (was 20 + clamp); broad witness sweep GREEN (mandate · cion · pleac · acme_dx · living_docs); tame_style_check clean on main.rye
obs found a pre-existing red, NOT from this change: one_clock_witness reds on mono — its erratum references archived stamps (20260724.221013, 20260725.00xx) folded out of the living session-logs set (TRUE_HEAD 20260811.191132). A stale one_clock mono-erratum, orthogonal to a clamp builtin; named for Keaton, its own housekeeping round (update the erratum to the archive or drop the folded entries)
loom suite=rishi/tests pass=21 fail=0 rishi_rebuild=exit0
file rishi/src/main.rye do_clamp + two error variants + dispatch at both sites (the first cookbook builtin)
file rishi/tests/clamp.rish the suite test for clamp
file pleac/README.md a "wired into the interpreter" section (clamp landed; the rest queued)
file work-in-progress/REMEMBER.md clamp wired; the found one_clock red named
recommend check-in (Claude) — clamp is wired into the interpreter and the full suite stays 21/21 GREEN; the remaining cookbook builtins (chunk/window/flatten/parse) wire the same way, one at a time. A found pre-existing red (one_clock mono-erratum vs archived stamps) wants its own small housekeeping round. Keaton's word on the next builtin, the one_clock erratum fix, or a fresh door
