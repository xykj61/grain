# The copy a name depends on

**Stamp:** `20261008.210855`
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Room:** checkable -- one type, studied, with no new code
**Status:** Living -- Aquarius of the orbit that opens at commit 8,071

Commit 8,081 is Aquarius, fixed air, fun. One clear type, studied. This round implements nothing.

Mantra keeps a name's bytes by calling Tally. `mantra/tally_copy.rye` is a link to `tally/copy.rye`. The function there is the whole dependency:

`copy_disjoint` takes a comptime type `T`, a target slice `[]T`, and a source slice `[]const T`, and returns nothing. Two asserts hold the contract. The slices must be the same length. Their address ranges must not overlap. Then the copy runs.

`append_leaf` in `mantra/recall_lap1.rye` calls it five times, for peer, bolt, path, tilak, and the resin bytes. `recall` calls it once more, to hand those bytes back to the caller. The name itself is the struct `Name`: peer, bolt, revision, and path. The revision is a `u32` and is assigned, not copied. The four text fields and the bytes travel through `copy_disjoint`.

The standard library's SHA3-256 sits beside that copy. `recall` hashes the stored bytes and refuses when the digest disagrees. `parse_int`, the other Tally link, is how `mantra/src/main.rye` reads a weave record's numbers. This page studies `copy_disjoint`. It does not edit that function, and it does not edit `recall`.

The fascia face stays 60.6000, measured `20261008.210553`. The meter stays unrun. The shell grade stays 58. `max_weave_lines` stays `1 << 20`.

Pisces says the wish. The commit after Pisces is sky, at 8,083.
