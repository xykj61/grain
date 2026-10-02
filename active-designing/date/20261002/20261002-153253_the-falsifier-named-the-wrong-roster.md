**Style:** Gauge at Field - **Status:** checkable -- one reading of tracked source, no new module
**Stamp:** `20261002.153253` - **Lane:** Diffuser (moonshots and research)

# The falsifier named the wrong roster

[The one branching tree in the whole catalog stands in Aurora, rather than in
Caravan](20261002-151621_the-one-branching-tree-stands-in-aurora.md) closed with a falsifier: whether
`caravan/roster.rye`'s own capability checks accept, refuse, or flatten a declared two-level tree,
left for Caravan's own next edit. Reading `caravan/roster.rye` answers it without an edit, and the
answer is that the question names the wrong file.

## What `caravan/roster.rye` actually reads

`caravan/roster.rye` imports four modules: `system.rye`, `regions.rye`, `capabilities.rye`, and
`read.rye` (`caravan/roster.rye:43-49`) -- a deliberate set that stops short of `channels.rye`. Its
one derivation function, `from_system`, walks `sys.map.domains` and `sys.map.grants`, the
region-grant table, and seats one capability per declared grant (`caravan/roster.rye:153-186`). That
walk stays entirely inside `sys.map`; `sys.graph`, the channel graph that records who may signal
whom, sits outside the function's whole reach.

The shape is deliberate rather than accidental. `caravan/system.rye`'s own `System` struct holds
both rings side by side -- `graph: channels.Graph` and `map: regions.Map`
(`caravan/system.rye:207-208`) -- kept in name-agreement by `verify()`, which answers
`.rosters_disagree` the moment a domain known to one ring sits absent from the other
(`caravan/system.rye:266-273`). The two rings are proven to *name* the same domains. Proving they
*answer the same question* would need them to ask one, and each asks its own: `map` says what
rights a domain holds over a region, and `graph` says which domains may signal each other. A
capability table built from `map` alone stops at that one question, a boundary that leaves a
channel's existence, let alone its depth from any other domain, entirely outside its view.

So the precise answer to the falsifier: `caravan/roster.rye`'s capability checks are blind to a
two-level tree in exactly the sense a region's rights table is blind to who may page it -- the
channel graph that would carry a tree's shape sits outside this module's read set, by the import
list at its own head.

## The module that does read the shape reads it the same way every time

The code that actually owns channel topology is `caravan/channels.rye`'s `Graph`. Its whole refusal
surface is four cases -- `NoSuchDomain`, `SelfLink`, `AlreadyLinked`, `GraphFull`
(`caravan/channels.rye:193-211`) -- and its permission check, `may_signal`, answers one question:
does a declared channel join these two names (`caravan/channels.rye:234-253`). Hop count, depth, and
every other property of the graph's shape stay outside that one question. `degree()` counts how many
channels touch one domain and stops there (`caravan/channels.rye:260-...`). Every one of these
functions treats a ring, a star, a tree, and two disjoint components alike, because each answers by
the same linear scan over declared pairs, regardless of the pattern those pairs happen to form.

The one place shape enters the reckoning at all is `system.rye`'s `verify()`, and even there the bar
is connectivity rather than shape: a domain earns a refusal only when its degree reads zero *and* it
holds no memory (`caravan/system.rye:283-291`, the `.isolated_domain` check). A domain sitting at
the bottom of a two-level tree, three hops from the root, clears this check exactly as easily as a
domain on a ring, because the check counts whether a domain is touched at all, rather than how far
it sits from anywhere else.

So a declared two-level tree earns acceptance through this whole chain for the same reason a ring, a
star, a pair of disjoint four-domain rings, and the already-landed Aurora/`channels.rye` branching
tree each do: every one of them is a set of pairs within `max_domains` and `max_channels`, each pair
naming a declared domain, each domain touched by at least one pair. The question of whether the set
forms a tree, a cycle, or a star belongs entirely to whoever reads the declaration afterward. A
"flatten" would need code that reads depth and sets it aside; the chain above answers every shape
the same way because depth is a property this chain never reads in the first place.

## Why the falsifier pointed elsewhere

The prior essay's own measurement -- cycle rank over all nineteen declared graphs -- found the
Aurora-shared roster's branching tree by computing `edges - vertices + connected_components` from
the declared edge list (`20261002-151621`, section on method). That computation lives in the
*essay's own script*, standing apart from every Caravan and Aurora module. Caravan's own code
declares graphs and leaves their classification to whoever reads the declaration -- which is exactly
what the essay's analysis script did, from outside, after the fact, as a research instrument rather
than a runtime check. Asking whether *Caravan's checks* treat a tree specially assumes a
classification step living inside the codebase, when the only code in the whole arc that ever read a
graph's shape was that one essay's own script.

`caravan/roster.rye` earned its place in the falsifier by carrying "roster" in its name beside
"capability checks," the two words the question reached for. The module that genuinely owns
capability checks over regions is exactly that one, and its jurisdiction stops at regions. The
module that owns channel shape is `channels.rye`, and reading it closes the question without an
edit: a two-level tree earns acceptance, plainly, through the same path every other declared shape
already walks.

## What a reading leaves open, named rather than attempted

Whether Caravan's design wants `verify()` to someday check shape -- whether a declared architecture
should answer refusal for branching past depth one, the way `max_channels` already answers refusal
for a complete graph by name (`caravan/channels.rye:29-32`, "a supervision tree that wires every
component to every other has stopped being a tree") -- stands as a design question for whoever next
edits `channels.rye` or `system.rye`. That line in the file's own header comment is the one place
this codebase states a shape preference in prose, a preference code has yet to enforce. Naming that
gap is as far as a reading reaches; closing it stays Caravan's own module edit, exactly as the
ruling that opened this essay already said -- the correction touches only which file the open
question belongs to.

## Bound

One reading of `caravan/roster.rye`, `caravan/channels.rye`, and `caravan/system.rye`'s tracked
source, with line citations, against the falsifier `20261002-151621` named. No new witness, no new
build, no Rye module touched. Graded B+ at Field: the finding carries weight and a specific target,
the correction closes a concrete falsifier rather than opening a fresh one, and the open design
question stands named rather than answered.
