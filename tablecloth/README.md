# Tablecloth -- the personal Documents tree

**Stamp:** `20261017.150528` (one clock, America/New_York, EDT)
**Status:** Living -- the rules for what lives under `tablecloth/` and how it is filed
**Voice:** Kyri, in Radiant Style
**Kin:** [`documents/notes/date/20261017/20261017-144713_the-documents-filetree.md`](documents/notes/date/20261017/20261017-144713_the-documents-filetree.md) (the first page, the Finder-like picture) - [`scribe/`](../scribe/README.md) (the Kyri records home) - [`context/LEXICON.md`](../context/LEXICON.md) (*Tablecloth*, the content-addressed store)

---

## What lives here

`tablecloth/` is a personal filing tree, the way a Finder window is. Every document you keep, every
download you bring in, and every generation or artifact a session makes lands under `documents/`, in
one of the categories below. Nothing here is a secret. Keys, tokens, and identity files stay in their
own rooms and never enter this tree.

## The categories

Each category is a folder under `documents/`. Within a category, files sit on day shelves
(`date/YYYYMMDD/`), so the day a thing arrived is always one folder away.

| Folder | What goes in it | Example |
|---|---|---|
| `documents/counsel/` | Advice and rulings offered for a decision Keaton has yet to make | the license-fork counsel, `20261015` |
| `documents/research/` | External research and studies, read with attribution | the fold, surface, and WASM study, `20261015` |
| `documents/projects/` | Project specs, summaries, and status pages, including Asana source pages | the 20261015-grain summary, `20261017` |
| `documents/packets/` | Task packets handed to one person or one agent, with its gates | a packet for a collaborator's bench |
| `documents/notes/` | Personal working notes, first-hand pages, and the Documents tree itself | the filetree page, `20261017` |
| `documents/generations/` | Machine-made outputs kept whole, with the prompt beside them | a model's answer saved as a file |
| `documents/artifacts/` | Pages and reports a session published or saved | a published report, saved for keeping |

A folder is created on its first real file. An empty category is not kept.

## Naming

Every file takes the one-clock shape:

```
YYYYMMDD-HHMMSS_short-sprig.ext
```

- **The stamp** comes from the one clock, in America/New_York (EDT in summer). Read it with
  `TZ=America/New_York date +%Y%m%d.%H%M%S` and write it with a hyphen in the filename.
- **The sprig** is two to five plain words about what the file is.
- **The extension** names the kind: `.md` for prose, `.pdf` or `.docx` for a document a person received.

A file arriving from outside keeps its own content and takes a new name from the day it arrived. The
stamp in its name is the arrival stamp, so the name says when it came in.

## Filing a file

1. **Arrive.** A new file lands in `documents/` at the day's stamp. It may wait in a folder of its own
   for a few hours, and it finishes its arrival by the end of the day.
2. **Choose the category** by what the file is for, using the table above. If two fit, choose the one
   that a reader would look in first.
3. **Shelve it** under `date/YYYYMMDD/` in that category, with the stamp in the basename.
4. **Repoint** every reference to it in the same change. A link in a summary, a session log, or a
   packet names the new path.
5. **Commit it** with a mechanism-first message, per the tree's commit discipline.

## Dated testimony keeps its words

A file whose basename already carries a one-clock stamp is testimony. Its contents stay as written.
The one sanctioned change is a time-zone conversion, applied to the stamp and recorded in the file's own
header. The `20261015` counsel and research pages took that conversion on `20261017`: their stamps moved from
Pacific to Eastern by three hours, the change is written in each header, and the body keeps every other word.

## Asana

Asana is the board. Tablecloth is the source of truth. A task in Asana names a path in tablecloth, not a
copy of its text, so an update lands once and every link reads the same.

- **The project spec for `20261015-grain`** is the newest dated file in `documents/projects/`. Older
  drafts keep their place as testimony.
- **Counsel and research** pages are linked from the spec's "what is settled" and "what is open" lists. A
  task that waits on counsel names the counsel page by path.
- **Packets** that go to a collaborator are filed under `documents/packets/` before they are sent, so the
  text a collaborator received is the text on disk.

## What this page does not do

It does not move files without a reason, and it does not rewrite testimony. It names where a file goes. A
file already filed keeps its place until a filing reason arrives.

---

*May every file find its shelf on the day it arrives, and may the tree stay a place you can walk without
losing the thread.*
