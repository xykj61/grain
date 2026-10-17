# Permissioning and constellation collaboration -- internal wiki

**Stamp:** `20261017.185218` (one clock, America/New_York)
**Status:** Living -- internal wiki, private repo only
**Audience:** the maintainers and DJINN, the collaborator this repo is held for
**Public version:** `docs-geode/tutorials/20261017-185218_permissioning-and-constellations.md`, depersonalized

## The rules we follow

1. **Custody first.** Build nothing that destroys. A gate waits for the person who holds it.
2. **Private and public are different remotes.** `xy` is the public field. The private copy takes
   collaborator work. Nothing private is pushed to a public remote without a named word.
3. **Pushes are fast-forward.** A force-push is a history rewrite, and it needs a checkpoint row and
   an explicit word first.
4. **Commits are signed,** except the public seed, which is anonymous by design.
5. **Names are placeholders until a holder says otherwise.** Docs use `~acme`-shaped names that
   can never parse as a live network address (see `.claude/rules/placeholder-ship-names.md`).

## MUR and the constellation, with Siya as the example

The MUR testnet runs as a constellation of fake piers inside the jailed pier. In the
planning, the constellation's galaxy is Siya's, numbered 15 in the roster, and the rest of the
network is open to other holders. The Siya name stays here, in the private wiki. It does not appear in
any public page, and no figure about the family's entity appears anywhere in the tree.

For collaboration: each holder controls the keys for their own point. A collaborator gains
access to the constellation by repo membership and by an invitation from the holder, never by
copying a key.

## What to do before a collaborator joins

- Confirm which remote they should read. A collaborator on the private copy never gets the seed door.
- Confirm which files are theirs. Name the files; do not rely on folder names.
- Record the grant in a session log, with the stamp of the word that gave it.

## Open items

- The file list for DJINN is in `construction/` on the private remote, not in this wiki.
- The Mycelium consensus foundation describes the network; this wiki describes who holds what.
