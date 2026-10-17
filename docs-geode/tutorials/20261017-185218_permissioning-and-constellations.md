# Permissioning and constellations -- a tutorial

**Stamp:** `20261017.185218`
**Status:** Living -- **Room:** checkable
**Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Audience:** someone who has just been given access to a shared project and wants to know what they may touch

## What a permission is

A permission is a written grant of one specific kind of access to one specific place. It is not
a feeling about trust. Read it the way you would read a lease: who holds it, what it covers, and
when it ends.

## The rules this project follows

1. **Custody first.** Nothing gets built that could destroy something a person holds. Where a
   decision belongs to a person, the work waits for that person.
2. **Two kinds of place.** A public place can be read by anyone. A private place is read only by the
   people added to it. Keep them apart: send private work only to the private place.
3. **Changes are added, not rewritten.** A push adds new commits on top of the old ones. Rewriting
   history is rare, and it takes a named reason and a recorded checkpoint first.
4. **Every change is signed.** A signature tells a reader who made the change.
5. **Examples use placeholder names.** A name in an example should never match a real account or
   a real network address.

## An example, with placeholders

Imagine a small team, **Acme Corp**, running a test network of three points:

- `~acme-star` -- the point that holds the team's keys
- `~acme-corp-test-ship` -- a test point the team runs for practice
- `~acme-corp-test-moon-example-host-here-now` -- a point for one collaborator

Each point has its own keys. A collaborator who joins the test network is added by the holder of
`~acme-star`, and receives access to the test point, never to the star's keys.

## Steps to follow when someone joins

1. Ask which place they need: public to read, private to build.
2. Add them to that place only.
3. Name the files they may work on, by path.
4. Write down the grant with the date and the person who gave it.

## What to check afterward

- Does their work land in the place you expected?
- Do the file names they touched match the grant?

If the answer to either is no, stop, reread the grant, and fix the mismatch before the next change.

## Where to go next

Read the first hour of the project, then this tutorial again once you have a grant of your own.
