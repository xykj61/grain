# Two hex reads stay

**Stamp:** `20261008.235650`
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Room:** checkable -- two hex reads named, neither edited
**Status:** Living -- Taurus of the orbit that opens at commit 8,086

Commit 8,087 is Taurus, fixed earth. This seat names what stays, and it leaves that thing in place.

Two reads in the file `rye/src/main.rye` still call `std.fmt.parseInt` with base 16. One sits in the cache record, where a `sha256` field becomes 32 bytes. The other sits in the library record and does the same work. Each takes two hex characters, `value[at .. at + 2]`, and parses them as a `u8`. A byte such as `0a` begins with a zero. `parse_int` refuses a leading zero unless the caller passes `allow_leading_zero` with base 16. These two reads keep the form that already accepts that zero.

The fascia witness stays unrun. The face stays 61.2000, measured `20261008.235324`. The shell grade stays 58. The root README badge stays 58. Clearing both remaining sites would drop the whole ratchet, and that move is larger than 1.0000.

Gemini says the work aloud.
