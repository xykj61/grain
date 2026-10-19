# Page header -- the one place a living page's header is defined

**Status:** Living
**Room:** checkable

The single definition of a living page's header shape for pages in `context/`, `context/voices/`,
and `context/styles/`. Referenced from the clean-slate tree's `context/lib/page-header.md`
(`grain-ww/20261015-grain`), adapted for petrichor's existing conventions.

## The shape

A living page opens with a title, then a short header block. Each field is one line, bold label,
colon, value:

- **Status:** `Living`, `Proposed`, `Done`, or `Draft`, then one clause saying what the page is.
  The label sits in the first twelve lines.
- **Room:** the register the page's claims are held to: `checkable`, `vision`, `mixed`, or
  `research` (per `context/TWO_ROOMS.md`).
- **Composes from:** the library pages this page draws its shared moves from, as relative links.

Pages that write in a named voice or style may add **Style:** or **Voice:** after **Status:**.

## What the header carries, and what it leaves to git

A header never carries a stamp that could go stale, a commit hash, or a count. The one-clock
stamp in a **dated** file's name is the file's identity; a living file's last edit is read from
`git log -1 --format=%ai -- <path>`, so no line in the header needs refreshing.

Rule pages (`.claude/rules/`) carry their own **Seated:** stamp, which is the date the rule was
first seated by Keaton's word. That is a different convention and stays where it is.

## What is not in the header

Dated testimony keeps its own header, as written. A title that names its own page stays as it is.
