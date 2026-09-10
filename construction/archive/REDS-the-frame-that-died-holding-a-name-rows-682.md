# REDS shelf -- row %682, the frame that died holding a name

**Language:** EN
**Status:** Shelf -- immutable once written; the living pin is [`../REDS.md`](../REDS.md)
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- one CLOSED row, folded so the pin can hold a live one, its relative links
re-anchored one directory deeper

Folded `20260910.002413`, in the same lap that recovered it, and the arithmetic says why.
`construction/REDS.md` stood at **40,959 bytes** against the **40,960** its own header declares --
one byte of room -- and all sixteen rows on it read **OPEN**, so not one was lawful to move. This
row reads **CLOSED**, which makes it the only row in the ledger the pin's own law lets go. A closed
row lands on a shelf now rather than resting on the pin first; that is the ceiling speaking, and it
is recorded here rather than felt as friction.

The row moved whole; nothing in it is edited but the view. It wears its third number -- `%676`
from a local read, `%681` from the anointed spine on recovery, and `%682` after a peer published
`%681` while this send was rebasing. A published number never moves and an unshared one does, so
the stamp is the identity and the number is a view of it.

**REDS %682 (`20260909.225728`) -- a Glow parser returned a slice into its own dead frame, and every field beside it read correct.** *What went wrong:* `glow/rune_core.rye`'s `parse_payload_line` returned `rf.face_slice(&face_spec)`, a view of a local that dies on return. `parse_source` copied from it with a bare `@memcpy` and got the right bytes by luck -- nothing touched the stack between. Migrating that site to `copy_disjoint` on touch inserted one call, and the payload face read garbage where `amount` belonged. *What caught it:* the earth rota row. `glow/` holds 45 of the 60 zero-assert files the TAME ratchet prints, so the lap bound `assert` and wrote accessor preconditions; the module's own witness then refused the face. *What it taught:* **`payload_len` was 6, `payload_value` 5, `has_payload` true -- every derived field was computed before the frame died, so only the bytes were wrong.** A parser answering a right length and a wrong name lowers a core binding a variable nobody wrote. Sibling `parse_arm_line` was always safe: it borrows the caller's `src`. Repaired by returning `rf.FaceSpec` by value; proven both ways in a pen. A sweep of `glow/` found no second site -- a lantern, not a loom. *Booked `%676` from a local read at `20260909.225728`, and the lap never reached a commit -- the round open stashed it. Recovered `20260910.002413`, by which time the anointed spine had spent through `%680`, so the unshared row derives above it. The key is the stamp (`derived-spine` 1 and 3).* **CLOSED.**
