# REDS shelf -- a reader that walks past its own subject, row %572

**Language:** EN
**Stamp:** `20260907.123037`
**Status:** Shelf -- immutable once written
**Rows:** `%572` -- folded from [`../REDS.md`](../REDS.md) on `20260907.123037`
**Voice:** Kyri

A marker written above a bound names that bound. The reader beneath Amphora's bounds guard resolved
the marker by searching forward for the next const it could parse -- a const whose value is a
spelled integer -- and a bound joined by formula does not match that shape. So the search did not
stop at the marker's subject. It continued, and stopped at the next literal const in the file,
which is related to the declaration by nothing but proximity.

The failure mode that matters is the quiet one. A stranger with a small value fails the order and
the guard refuses, loudly, for the wrong reason. A stranger with a large value **satisfies** it: a
roof of forty declared to cover two hundred read `status=covers`, `slack=7992`, `verdict=ok`,
having decided the question against an unrelated `8192` six lines below. The relation the hand
declared was violated by a factor of five and no instrument said so.

The repair separates two acts the elder reader had fused. **Binding** finds the first const beneath
the marker, whatever form its value takes, and stops there unconditionally. **Classifying** then
says what that const is: a literal, with its type and value, or derived. Silence about a value it
cannot read is safe; continuing the search is what turned a known narrowness into a wrong answer.

Two verdicts follow, and both name repairs a hand can perform. `marker_on_derived` says the subject
is here and its value is an expression. `partner_derived` says the partner is spelled in its own
module and derived -- where the elder answered `partner_absent`, sending a reader to hunt a typo in
a const that is present on line three.

Ten of this family's sixteen bounds are derived, and that is the direction the tree is deliberately
moving: a bound joined by formula has one home for its literal rather than two. So the blind spot
sat exactly over the growing half, which is the reading worth carrying past this row.


**REDS %572 (`20260907.123037`) -- a bound marker binds to the const beneath it, and the reader walked past the ones it could not spell.** *What went wrong:* `tools/fixtures/a/amphora_bounds_agree_scan.sh` resolved a `/// couples:` or `/// covers:` marker to its subject by walking forward for the next line matching `^(pub )?const NAME: uN = <digits>;` -- a **literal** const. A bound whose value is an expression fails that pattern, so the walk stepped over the marker's actual subject and bound the declaration to whatever literal const came next in the file. *Proven in a pen `20260907.123037`, in the direction that decides:* a marker declaring `const max_roof: u32 = base * 4` -- forty -- covers a partner of two hundred, with an unrelated `const unrelated_large: u32 = 8192` six lines below, reads `cover_unrelated_large_to_b_max_partner_status=covers`, `slack=7992`, **`verdict=ok`**. The roof is five times too small and the guard is green, because it decided a relation nobody stated about a const nobody named. The same walk on the partner side answered **`partner_absent`** for `b.max_line_len` while that const is spelled on line three of `b.rye` -- present, readable, and derived. *What caught it:* the fire row's own instruction to look at the instrument the last lap leaned on. `20260907.103031` closed a season-door fault by handing the product relation to the compiler, since *"the roster guard reads a bound's spelled value and evaluates no expression"* -- a limit recorded as a limit. Asking what that limit does when a marker sits above such a value turned a documented narrowness into a false green in one pen run. *The population is the growing half:* **ten of this family's sixteen `const ... = ...` bounds are derived** -- `manifest_entry.max_line_len`, `main.min_cargo_line_len`, `main.max_manifest_bytes`, `main.max_carry_chunks`, `vessel_fetch_wire.{max_single_body,max_chunk_body,response_header_len,chunk_header_len}`, and the two `*_hex_len` doubles -- and a bound joined by formula rather than by a second literal is the shape this tree is deliberately moving toward (Q45). *What it taught:* **a reader that skips what it cannot parse walks past its own subject and answers about a stranger.** Silence about an unreadable value is safe; *continuing the search* is not, because the next thing found is structurally unrelated and the answer arrives wearing a real name. *Repaired:* `next_const_sig()` binds a marker to the **first const beneath it of any form** and classifies second -- `name:type=value` for a literal, `name:derived` for an expression -- and `partner_kind()` answers `derived` where it answered nothing. Two verdicts now say what the elder pair could not: **`marker_on_derived`** (the subject is here and its value is an expression) and **`partner_derived`** (the partner is spelled and derived), each refusing, each naming a repair a hand can perform. Both families take the same binding, so the equality half is closed with the order half. *Proven both ways:* two plants under `tools/fixtures/amphora_bounds_plants/`, each carrying the elder reader's own wrong answer in its head comment, and the false-green leg asserts the stranger's name is **absent** from the output rather than merely that the verdict refuses. `amphora_bounds_agree` GREEN at ten honored plant legs; the living tree reads exactly as before -- 12 couples agree, 2 covers hold, `verdict=ok` -- so nothing left the set the guard decides. *Not taken:* teaching the reader arithmetic, which would let a marker name a **product** and reach the season-door relation `roof >= files * line` that `20260907.103031` had to hand to the compiler. That is a second instrument evaluating expressions beside a compiler that already does, and it wants its own round and its own word. **CLOSED.**
