# The terminal type, studied

**Stamp:** `20261009.101957`
**Language:** EN
**Style:** Twilight, the night register
**Voice:** Kyri
**Room:** checkable -- one type studied, nothing implemented
**Status:** Living -- Aquarius of the orbit that opens at commit 8,086

Commit 8,096 is Aquarius, fixed air. The studied theme is the loom and the thread. This seat studies one type and implements nothing.

The type is `Terminal` in the file `pond/apps/dexter_terminal.rye`. It is a fixed grid and a caret.

| Field | What it holds |
|---|---|
| `cells` | `term_rows` times `term_cols` bytes, filled with spaces at the start |
| `caret_row` | a `u32`, always the prompt row |
| `caret_col` | a `u32`, always within the width |

`term_rows` is 24. `term_cols` is 80. `prompt_row` is the last row, `term_rows` minus one. `render_terminal` draws a journal into the rows above and a prompt into the last row. The two regions do not overlap. The function returns a `Terminal`. It does not run a program.

`pond/apps/dexter_shell.rye` holds the line and its history. Submit remembers the line and clears it. Up and down recall an older line. Past either end is refused by name. It does not execute the line.

The proposed name beside these elders is Sill: the ledge of a window, where one spoken line rests before it is drawn. It is a plain word, not a waymark draw. It is absent from `context/LEXICON.md` and from `construction/`. A later birth greps the whole tree before the first file, and it creates nothing in this commit.

TUBE stays the GrapheneOS packaging ladder in `docs/TUBE.md`. Sill, if it is born, is the desk window. The phone path and the desk path stay two paths.

The fascia face stays 61.3000, measured `20261009.101857`. The witness stays unrun. The shell grade stays 58. The root README badge stays 58. No function was edited.

Pisces says the wish. The next commit after that wish is sky.
