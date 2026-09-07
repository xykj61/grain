# REDS shelf -- a door and the wall behind it, row %565

**Language:** EN
**Stamp:** `20260907.103031`
**Status:** Shelf -- immutable once written
**Rows:** `%565` -- folded from [`../REDS.md`](../REDS.md) on `20260907.103031`
**Voice:** Kyri

Amphora's season door declared sixteen files and the cargo byte roof behind it carried twelve. Four
of the sixteen slots the door promised could never be filled, at any name length, and the program
said so only after accepting the season -- at `CargoTooLarge`, naming a roof the operator was never
told about.

The elder declaration was honest about the wrong pair. `max_season_files` was coupled to
`vessel_seal.max_cargo`, and the vessel really does hold sixteen cargo slots; what a season can pour
into them is decided somewhere else entirely, by 1,024 bytes divided by the 85 the shortest possible
cargo line costs. Both numbers were right, and the marker tying them said `=` where the truth was
`>=`.

**A door and the wall behind it are two numbers, and only the smaller one is a promise.** The
repair moves the door to the wall, hands the relation to the compiler from both sides, and declares
the vessel's slot count as a `covers:` order rather than an equality -- the second such declaration
this tree has written.


**REDS %565 (`20260907.103031`) -- the season door promised sixteen files and the byte roof behind it carried twelve, so four declared slots could never be filled at any name length.** *What went wrong:* `amphora/src/main.rye` declared `max_season_files: u32 = 16` with the comment *matches vessel cargo slots* and a `/// couples: vessel_seal.max_cargo` marker, both true about the vessel and neither true about the roof. A cargo line is `"cargo "` + `mark_plain_bytes` + a space + a 64-character digest + a space + the name + a newline, so the shortest one a file can write is **85 bytes**, and `max_cargo_bytes` is **1,024**. Twelve such lines cost 1,020 and fit; thirteen cost 1,105 and do not. `build_cargo_plain` therefore refused at `CargoTooLarge` a season `read_season` had welcomed one step earlier, naming a roof the operator never asked about -- REDS `20260906.193823` exactly, one bound over, and that row's own repair had sized `max_manifest_bytes` to carry twelve while leaving the door saying sixteen. *What caught it:* reading the two bounds beside each other and then running the binary rather than the arithmetic. Poured on metal `20260907.102700`, one-character names, season sizes 10 through 16: `exit=0` at 10, 11 and 12 (`manifest_lines_bytes=880, 968, 1056`) and `exit=2 cargo too large` at 13, 14, 15 and 16. No guard read it: `amphora_bounds_agree` compares a bound to a partner bound, and this relation is a **product** -- door times line cost against roof -- which no marker in its grammar can spell. *What it taught:* **a door and the wall behind it are two numbers, and only the smaller one is a promise.** The couple marker was honest about the wrong pair; the vessel does have sixteen slots, and a season can only ever pour twelve into them, so the true relation was an order all along. *Repaired (`20260907.103031`):* `max_season_files` reads **12**; `min_cargo_line_len` names the 85 with its four fields spelled out; a `max_cargo_mirror` beside it carries the vessel's slot count in main's own `max_seal_plain_mirror` idiom, wearing the elder `couples:` to vessel_seal and a new `covers: main.max_season_files` -- the tree's **second** declared order relation. The relation itself is handed to the compiler, both ways: `max_season_files * min_cargo_line_len <= max_cargo_bytes` and `(max_season_files + 1) * min_cargo_line_len > max_cargo_bytes`, so the literal is the largest season the roof carries and a later raise to the roof reds the build rather than leaving the door quietly narrow. Proven on metal by plant: **11, 13 and 16 each stop the build** at `reached unreachable code` naming the assert, and 12 builds. Behavior moved by one word and no input: 12 still pours, 13 now refuses at the door as `season overflow` rather than at the roof as `cargo too large`. `amphora_bounds_agree` GREEN with `covers_declarations=2, covers_hold_count=2`; all nine amphora witnesses GREEN. *And the guard failed safe on the way:* a first draft derived `max_season_files = max_cargo_bytes / min_cargo_line_len` and the scan answered `partner_absent`, `verdict=misread` -- it reads a bound's **spelled** value and cannot evaluate an expression, which is why the literal stayed and the compiler took the relation. **CLOSED.**
