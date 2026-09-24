# The selection before the verb -- what a modal editor's design document actually argues

**Language:** EN - **Style:** Gauge, Field setting - **Voice:** Kyri
**Stamp:** `20260908.021022` - **Status:** Research for understanding -- the world studied with
attribution, so a later design page can name only our own things
**Room:** research for understanding
**Studied:** Kakoune (Maxime Coste and contributors, 2011-), its published `design.asciidoc`, its
release tags, and its own documentation. Gratitude: [`../gratitude/maxime-coste-kakoune.md`](../gratitude/maxime-coste-kakoune.md)
**Clean room:** No source was read and none will be. Concepts enter with attribution; code never
does ([`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)).

Keaton asked what it would take to build an editor of our own in this tree's languages. Before that
question can be answered honestly, the thing being learned from has to be read rather than
remembered -- so this page reads the design document its author published, and stops there. The
design that follows is a separate page, and it names only our own modules.

## What the document actually claims, in its own order

Ten principles are stated. Four carry the architecture and six describe the taste around them.

**Normal mode IS the editing language.** This is the sentence the rest hangs from. There is no
separate scripting dialect for text manipulation: the keys a person presses interactively are the
same terms a script composes. One grammar, learned once, used twice.

**Selection precedes action.** Where the vi lineage says *delete two words* and shows you the result,
this design says *select two words* -- visibly, on screen -- and then *delete*. The object is chosen
first and displayed; the verb confirms something already true. Multiple selections are the ordinary
state rather than a special mode, so acting on many places is the same act as acting on one.

**Composability over reimplementation.** The editor deliberately does not grow the features Unix
already has. It states the boundary plainly -- *"a code editor. It is not an IDE, not a file browser,
not a word processor and not a window manager"* -- and provides a pipe so selections can be handed to
any external program and taken back.

**Simplicity bought by exclusion.** The document names what was refused to keep the core small:
threading, binary plugins, and an embedded scripting language. Each is delegated to a helper process
instead. This is a stated architectural cost, taken on purpose.

The remaining six -- interactivity, limited scope, orthogonality of modes, speed, self-documentation,
and vi-compatibility-where-it-costs-nothing -- are consequences and manners rather than structure.

## What is genuinely transferable, and what is not

**Transferable, because it is an idea about order:** show the object before the verb acts on it. That
is not a keymap or an implementation; it is a claim about when a person should be able to see what is
about to happen. This tree already argues the same thing in a different room -- a scan prints what it
found, and the tool applies exactly that column and nothing else.

**Transferable, because it is an idea about grammar:** one language for the interactive and the
scripted case. Our own equivalent question is whether an editor's terms and Rishi's terms are the
same terms.

**Transferable, because it is an idea about boundaries:** name what the program refuses to be, in the
document, before anyone asks for it. Every seated law in this tree that ends *what this does not
reach* is doing the same work.

**Not transferable:** the keymap, the mode letters, the command names, and the C++ architecture. A
person's fingers are trained on a specific grammar and that grammar is the project's own. Borrowing
it would be borrowing an interface, which is a different act from learning a principle, and it would
put us in the position of maintaining somebody else's muscle memory.

**Not transferable without a decision:** the client-server split over a UNIX socket. It is a good
shape and this tree already has a supervision module with its own opinions about processes and
capabilities, so adopting the shape means asking whether it fits ours rather than assuming it does.

## The honest cost, stated before anyone is enthusiastic

The project being studied has run since 2011 with a maintainer and contributors, and its most recent
tag at the time of writing is `v2026.05.21`. A text editor is not a weekend: buffer representation,
undo, incremental redisplay, terminal capability handling, input decoding, and file encoding are each
a real body of work, and none of them is the interesting part. The interesting part -- the grammar --
is perhaps a tenth of it.

That is the number a design page has to open with rather than close with, and it is why the page that
follows this one argues for a **shape and a name** rather than for a build starting now.

## What this page does not do

It names no module of ours, proposes no design, and settles no priority. Those belong on the design
page, under silo technique, where only our own names are spoken.
