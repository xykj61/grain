# REDS %694 -- a digest answers what the bytes are and never where they land

*Folded from the living pin [`../REDS.md`](../REDS.md) on the lap that booked it. The pin stood at
**40,957 of the 40,960** its own header declares -- three bytes of headroom, every remaining row
OPEN and so unfoldable -- against a row of roughly four thousand. A row booked and closed in one
lap folds rather than pushing the pin past its bound, which is the move `%681` and `%548` made from
the same shelf. The headroom itself is the fleet question four ships have now raised in a row, and
it waits on Keaton's word rather than on any lap.*

---

**REDS %694 (`20260910.053613`) -- Amphora proved every cargo digest twice and never once asked
where the named file would land, so a vessel naming `../escaped.txt` wrote one directory above its
out-home and refused afterward.**

*What went wrong:* a vessel's cargo line is `cargo <mark> <digest> <name>`, and
`amphora/src/main.rye:restore_write_prove` builds its destination as
`std.fmt.bufPrint("{s}/{s}", .{ out_home, name })`. Nothing between the seal and that line asked
whether `name` could leave the home the restore was pointed at. The digest check that reads like
proof -- read the resin, write it, re-hash it, compare -- answers **what the bytes are**. The
destination was never a claim anybody checked.

*Measured on metal `20260910.052020`, before a line changed.* A pen, two files, one pour; the
sealed cargo opened with `vessel-seal open`, one name rewritten from `a.txt` to `../escaped.txt` in
both the readable listing and the cargo block, re-sealed and re-stamped -- the seal key and the
stamp seed are witness constants, so forging costs two commands. Then `amphora restore`:

```
amphora: carry walls verified rite=stamp-then-seal listing=agrees
amphora: restore walls verified out=/tmp/.../v2.bron.season
amphora: restore catalog files=2 plain_bytes=187
amphora: restore files proven count=2
amphora: cargo unproven -- '/tmp/.../v2.bron.season'   (the em dash is the program's own; spelled ASCII here)
exit=2
```

Every wall spoke and every wall was satisfied. The Kumara stamp verified, the AEAD seal opened, the
listing-agrees walk seated hours earlier on `20260910.045019` answered **agrees** -- correctly, since
listing and cargo told the same lie -- and `restore files proven count=2` is the digest check
passing, because the content was honest and only the destination was not. The refusal on the last
line is the parent compare noticing the restored season no longer matches, and by then
`escaped.txt` had been written one directory above the out-home. **A refusal that arrives after the
write is not a wall.**

*What caught it:* the council rota's Water row, read this lap -- *care and flow*, whose sense is to
taste the thing up close. `foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md` asks
that every seam carry **two small answers**: a collaboration check with the asker, a contract check
with the answerer. Restore is the answerer. Its contract says *write each named file into the
out-home*, and only the first half of that sentence was ever checked. Reading the code for the
missing half took one paragraph; proving it took a pen and four commands.

*What it taught:* **a value can be honest about itself and dishonest about its place, and a digest
cannot tell the difference.** `foundations/20260703-202312_the-marked-value.md` asks that a value be
checked twice, and Amphora obeyed that law thoroughly on one axis while the other axis had no check
at all -- which reads, from inside, exactly like a checked system. The narrower lesson is about
ordering: `restore_write_prove` writes and then proves, so every refusal it can raise is a refusal
after a mutation. The wider one is `%532`'s shape wearing different clothes -- three readers all
agreeing, all correct, and all answering a question nobody had asked.

*Repaired (`20260910.053613`):* the rule lives once, in `amphora/manifest_entry.rye` beside the
wreck rule it reads like. `name_verdict` welcomes a relative path whose every segment carries
content and is neither `.` nor `..`, and refuses everything else -- a leading `/`, an empty segment
(which is what `//` and a trailing `/` are), and any segment that walks upward.
`parse_manifest_line` refuses `error.EscapingName`, so the six readers that route a whole line
through the contract inherit it without a line of their own; `append_cargo_line`, the seventh
reader, which walks decrypted seal plain into a catalog slot and cannot route the whole line,
borrows `name_verdict` exactly as it already borrows `mark_verdict`. **Four doors** now speak: the
seal writer, the stamp writer, the listing check, and the cargo reader restore walks. Refused at
the cargo reader, the catalog never forms and `restore_write_prove` is never reached, so **the
refusal arrives before the mutation** rather than after it.

*Proven:* `tools/am/amphora_contained_name_witness.rish`, `tier lap`. The rule both directions in
the module's own selftest -- `sub/deeper/a.txt` welcomed, six escaping shapes each refused by
`error.EscapingName`. The honest vessel welcomed at every door and restored whole. Three doors
shown refusing a planted escaping name. Then the leg that makes the rest mean something: a pen copy
of the room with the two containment refusals **struck out**, built into an elder Amphora, which
seals the escaping name, stamps it, prints its files-proven line, and puts the file above the
out-home -- the pre-repair reading reproduced inside the witness, so a green here cannot be told
from a door with nothing to refuse. The wall then returns: the repaired `amphora` over that elder
seal tool refuses by name at the cargo door with no catalog formed and nothing written. The witness
was also proven able to red against the tree itself, by striking the rule out of
`amphora/manifest_entry.rye` and watching it refuse at its selftest leg. All fifteen elder
lap-clock amphora guards re-run GREEN beside it.

*Not taken, and named rather than guessed:* two shapes stand outside this repair. A filename
carrying a **newline** would split a cargo line in two, and a name carrying one is refused by
neither the pour walk nor this rule -- the pour side cannot produce one from a directory walk, so
it is a forged-vessel shape like this row's, and it wants its own reading. And
`restore_write_prove` still writes each resin body **before** re-hashing it, so a forged resin --
the plant `amphora_restore_negative` already catches -- lands its wrong bytes on disk and is
refused afterward. That is the same ordering fault this row closes for names, one field over, and
closing it means writing to a scratch name and renaming after the proof. **BOOKED.**
