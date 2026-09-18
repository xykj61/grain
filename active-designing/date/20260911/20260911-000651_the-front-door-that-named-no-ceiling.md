# The front door that named no ceiling

**Stamp:** `20260911.000651`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **checkable room**: every count below comes from a scan named beside it
**Kin:** [`20260910-223215_the-ceiling-a-manual-page-is-held-to.md`](20260910-223215_the-ceiling-a-manual-page-is-held-to.md) -- [`../.claude/rules/gauge-style.md`](../.claude/rules/gauge-style.md) -- [`../.claude/rules/read-scope.md`](../.claude/rules/read-scope.md)

---

## The reading

`tools/fixtures/p/prose_register_scan.sh` gained a declaration wall on `20260910.191740`: every
page on its `DOOR` roster must name the word `Door` inside its own `**Style:**` line, and the
witness asserts `door_setting_undeclared=0`. Nineteen pages sit on that roster. Eighteen named
their setting. The one that did not was `README.md` -- the tree's own front door, the page every
newcomer opens first and the most cited artifact this repository owns.

So `prose_register` stood **red** on the standing roster, and the guard was right: a page held to
a ceiling ought to say so where a reader can see it.

**The page had said it, and a later commit took the sentence back.** `570526cad9` landed the clause
at 22:18 and reads `18 declared, 0 undeclared` in its own commit body. `84a0ebc26`, three commits
later, rewrote `README.md:23` to the elder line; its subject names `foundations/` and its body
mentions the README nowhere. Its tree predated the clause, and a whole-index commit carried that
tree forward.

**The same commit moved two things in that file, and only one healed.** The metrics block's witness
count went `1941 -> 1940` and came back on the next commit, because `tools/hooks/pre-commit`
regenerates it. The Style clause no hook regenerates stood reverted until a guard read it. **A
generated line repairs itself and an authored one waits for a reader** -- which is the argument for
putting a declaration in an emitter wherever a page has one, and `docs-geode/libraries/README.md`
taught that lesson on this same lap by going red when the sweep edited the page instead of
`tools/fixtures/g/geode_libraries_scan.sh:151`.

**The repair is one clause.** `README.md:23` reads `**Style:** Bhakta at the Door setting, with
[Gauge](context/GAUGE_STYLE.md) and ...`, and the sentence four lines down that already published
the page's own number now names what the number is measured against -- *its negation reads 6%
against the Door ceiling of 20%*. The word has to sit on the FIRST physical line of the clause,
because `declared_style_line_of()` in `tools/fixtures/q/qa_report_card.sh` prints one line and
stops; the README's Style clause wraps across six.

Measured after: `door_setting_declared` 17 -> **18**, `door_setting_undeclared` 1 -> **0**,
`verdict=ok`, and `tools/p/prose_register_witness.rish` GREEN at 43 control legs, 0 failing.

## The same silence, one shelf down

`docs-geode/` is the shipping shelf -- the room a newcomer meets after the front door. Measured
this lap over its 47 tracked pages: **23 carried a `**Style:**` line and 7 of the 23 named a
setting.** The other sixteen declared a register and left the ceiling unsaid, while the teaching
tier of the same scan has been reading all 47 against the Field target of 30% the whole time.

The reason the room was measured and nobody knew it is worth writing down, because it reads as a
gap and is the opposite of one. The teaching tier's glob is `git ls-files 'docs-geode/*.md'`, and
**git's pathspec `*` crosses a slash** where a shell's does not -- so that one pattern already
reaches every page at every depth. This lap opened expecting an unread room and found a read one;
the finding is the declaration rather than the reach.

**Sixteen pages name their setting now, chosen by reader rather than by number**, which is the law
the manual took yesterday. A room's `README.md` is a front door by the scan's own words, so nine
of them read Door; five reference and walkthrough pages read Field; `study/README.md` and
`lessons/README.md` keep Bhakta and take the Door setting beside it.

**Two front doors stood above Door, so they were swept rather than relabelled.**
`sangha/README.md` read 27% of 29 sentences and reads **17%**: three sentences restated -- *arrives
with nothing* -> *arrives fresh*, *a reader who has never met this tree* -> *a reader meeting this
tree for the first time*, *after its Check witnesses went green -- never before* -> *only after its
Check witnesses went green*. `edu/yonder/pleac/README.md` read 27% of 11 and reads **18%**: one
phrase, *a missing spoon in the stdlib* -> *a spoon the stdlib still owes it*. Every claim, path,
stamp and verdict word is held; the register moved and nothing else did.

Every one of the 23 declaring pages now reads at or under what it declares -- sixteen Door pages
between 0% and 18%, seven Field pages between 15% and 29%.

## Twelve citations that pointed at nothing, in a room with two guards over it

The same walk found a second class. **Fifteen backticked relative paths in `docs-geode/edu/yonder/`
resolved to no file**, and twelve of them stood in living pages. All fifteen were depth arithmetic:
`../context/GAUGE_STYLE.md` written from a page three directories deep, `../../SOURCE.md` from one
four deep. Every target exists; only the count of `../` steps missed.

**Nothing in the tree was reading them**, and the two guards that come closest each pass them by for
a reason. `tracked_link` reads Markdown links, and a backticked path is not one.
`docs_command_path` reads a path a page tells a reader to RUN, and passes an absent one free on
purpose. That is `%568`'s shape and the shape `law_tool_citation` was built for one room over on
`20260910`: a citation in a backtick is a promise about a file, and the room that makes the promise
is where the wall belongs.

**The twelve living ones are repaired**, each by correcting its depth. The remaining three sit in
`20260727-115547_the-example-app-series-plan.md`, whose basename carries a one-clock stamp -- that
page is testimony and keeps every word it wrote.

**A guard for this class is proposed and not built.** The shape is `law_tool_citation`'s, scoped to
`docs-geode/`: resolve each backticked relative path against its page's own directory, hold
untracked at zero, read dated basenames past. Whether the shipping shelf earns its own wall, or
whether the existing one should widen its room, is a question for the card rather than a thing to
assume.

## What this does not settle

**Whether a room's `README.md` is a Door by construction.** The scan says so in a comment and
prices it in a reported reading -- `front_doors_unrostered_over=19` measures every unrostered
`README.md` against the 20% Door ceiling, including pages the teaching tier already holds at Field
30% and which pass. Two of the nineteen are mine and both now declare Door and read under it. The
other seventeen belong to other lanes.

**Whether a page's front matter is read as prose when a navigation block precedes it.** The scan
drops the FIRST bold-key block after the title, which on `docs-geode/sangha/README.md` is the
shared `**Where this sits:**` line -- so the `**Language:** ... **Voice:** ... **Style:**` block
below it counted as a body sentence and carried one negation into that page's eight. Measured
across the teaching tier's three rooms: **three pages** stack two blocks this way. Small, real, and
named here rather than chased.
