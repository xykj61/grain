# One bound, four ways

**Stamp:** `20261008.204218`
**Language:** EN
**Style:** Bhakta, Gauge, Radiant, and Twilight, each in its own section
**Voice:** Kyri
**Room:** checkable -- the same ceiling, said four ways
**Status:** Living -- Sagittarius of the orbit that opens at commit 8,071

The bound is one sentence. A weave holds at most 1,048,576 lines. `max_weave_lines` in `mantra/src/weave.rye` is `1 << 20`. This page says that once in each register. It edits no function.

## Bhakta

Picture a stack of paper on a table. The stack may grow until it holds 1,048,576 lines, and then it stops. When you ask to see the lines that are still present, the weave copies them onto a fresh sheet that belongs to you. Half a full stack, 524,288 lines, is about sixteen megabytes. The comment above `current` already measured that copy.

## Gauge

`max_weave_lines` is the constant `1 << 20` at line 142. `current` asserts the backing list is inside that constant before it copies. The comment records ReleaseSafe, twenty reads, best of three: 16,384 lines at 0.4ms, 131,072 lines from 3.3ms to 2.7ms, 524,288 lines from 25.3ms to 13.3ms. This round did not time it again. Beside that ceiling, one dependent holds at most 8 capabilities.

## Radiant

The ceiling is a kindness. A weave keeps every line a file has ever held, and the stop arrives while the machine is still comfortable. The read hands you a slice you own, so the lines you are looking at are yours for that moment.

## Twilight

One number, and the room stays quiet around it. 1,048,576 lines, and then the weave declines the next one. The copy at half that height is a small weight, already known.

The fascia face stays 60.5000, measured `20261008.204002`. The meter stays unrun. The shell grade stays 58.

The next two seats, still ahead: Capricorn reads what must stop, and the face may move by at most 1.0000 if that seat runs the witness. Aquarius studies one type and implements nothing. Sky of this orbit opens at commit 8,083. The seat after those two is Pisces, and the seat after Pisces is that sky.
