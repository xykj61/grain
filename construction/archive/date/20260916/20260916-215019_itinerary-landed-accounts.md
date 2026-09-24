# ITINERARY -- landed accounts, shelved `20260916.215019`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The BAKERY account the live card carried before the lap of `20260916.215019`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**BAKERY -- THE LIBRARY TREE READ ONCE, RATHER THAN ONCE PER BUILD.**
**AIR FEELS** (row 1, N=5166): press a claimed boundary and feel whether the hand passes through.

A second lap died mid-send. Its whole set replayed onto HEAD exactly on the three code files --
`rye/src/main.rye`, `tools/fixtures/r/ryekey_control.sh`, `tools/r/ryekey_witness.rish` were
byte-identical between the stash base `fc5b1f9281` and `ca5f356a89` -- so no merge was owed there, and
only the three shared pins were re-derived by hand. A stash replay is a merge, and the conflicts that
bite leave no marker, so the code came across by `git checkout stash@{0} -- <path>`, which reads the
TREE and carries the mode, rather than by a blob read that would have landed every file at 100644.

**THE MECHANISM.** `library_identity_update` in `rye/src/main.rye` composes the identity of
`rye/lib/std` FROM the walk that has to happen anyway: the file count, then each sorted relative path
with its size, inode, modification time and status-change time, hashed into one identity digest. A
record `rye-key-library.<digest>.kyri` beside the `rye` binary remembers that tree's CONTENT digest
under that identity, and a build whose readings still agree feeds the remembered 32 bytes into the key
instead of reading the tree. **The walk stays and the read goes.** 552 files and 16,416,628 bytes are
hashed once per library rather than once per keyed build -- a walk-and-stat pass costs 16-21 ms against
145-154 for the read. A directory's own mtime carries none of this, since rewriting a file inside a
directory leaves the directory's mtime exactly where it was, which is why one stat cannot stand for a
tree. `ryekey_marker` moves v8 to **v9**, because the key absorbs a digest where it absorbed a byte
stream; every standing receipt takes one rebuild, and `rishi/bin/rishi` was rebuilt here under it by
the card's own three-move form.

**PROVEN ON METAL.** `ryekey` **37 legs** green, the library's seven readings taken beside the
compiler's five: the record exists and names its root, it was shown consulted by planting a digest into
it, each of its three compared fields refused its own plant, a file added and a file removed each
refused the remembered digest with no existing file's stat moved, a `chmod` moving only the
status-change time refused it too, and a build earning no receipt walked no library and wrote no
record. Three of the six readings cannot be isolated by any plant -- size moves mtime, a rename and a
replacement each move ctime, and ctime shadows the lot -- so their presence is proven by deleting one
`hasher.update` and watching a leg object, which is a mutation rather than a plant. The control says
so rather than claiming six isolated plants, because a filesystem does not offer six. The content
stream was also rebuilt from outside the program entirely, in twelve lines of Python, and agreed to
the character over 552 files. A hit on a 13,722,744-byte output reads **184-223 ms** here; a key
computation with no output to hash reads **41-58 ms**. Both are FREE, so run them.

**THE RED THIS LAP BOOKED.** `%790` -- a memo is reached by the digest of its subject's PATH, so a new
path means a new record rather than a replaced one, and nothing ever removes one. Counted straight
after one witness run: **56 records beside the binary, 5 live, 51 naming a path that no longer
exists** -- 91 percent dead, every one a throwaway pen. `rye/bin/` is gitignored at `.gitignore:155`,
so every tracked-file meter, the room bound and the census tools are blind to that room by
construction, and the memo's own witness proves each record's readings while never asking how many
records there are. Both memo families are single-stranded on purpose -- two prefixes rather than one,
so neither can evict the other -- and that argument is about the RECORDS. The SET they live in was
never anybody's one thing, so it named no maximum and grew. Booked rather than built: this lap was a
replay closing at its own witness.

**YOURS:** the emitted output is the largest term in a hit now, roughly 130 of those 184 ms. Every hit
re-hashes the binary standing beside the receipt, which is what keeps a torn or hand-replaced output
from being served. Should a served binary answer for itself by its bytes, or by the same four stat
readings the compiler's memo already trusts? That is a question about what a receipt promises rather
than a performance one, and it is named here rather than decided.
