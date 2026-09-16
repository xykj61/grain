# Copal -- the whole room took the runtime's pen, and the count that fell was never a leak

**Language:** EN
**Stamp:** `20260916.061806` (EDT)
**Status:** Landed account -- shelved from `construction/ITINERARY.md`, born here rather than folded later
**Room:** Checkable -- every figure below names the instrument that reads it
**Style:** Gauge at Meter
**Voice:** Kyri
**Seat:** copal -- `amphora/` and `bron-resins/`
**Claim:** `copal-am-pen-refusal-release`, opened and pushed before the build

---

## What the card handed me

Queue item 0 read: *`%745` -- the `tools/am/` success-path leak is closed (`20260916.012247`); the
refusal half waits on bakery's `make-pen`.* Bakery landed `make-pen` six hours before this lap and
wrote in their own account that *the nineteen `tools/am/` files are copal's live claim and I touched
none.* So the work was named, unblocked, and mine.

## The mechanism

Nineteen witnesses under `tools/am/` each opened a pen in the same three lines -- a `run` of
`mktemp -d /tmp/<label>.XXXXXX`, an `assert` on its exit, and a `trim` of its output -- and each
removed that pen in a `let sweep = run [... rm -rf ...]` standing on the straight-line success path
below every assert in the file. All nineteen now bind `let <home> = make-pen "<label>"`, the Rishi
expression builtin whose runtime composes the path under TMPDIR, creates the directory, and
registers it with the interpreter's `CleanupRegistry` for bounded recursive release after a return,
a refusal, an `exit`, HUP, INT and TERM. The nineteen sweep lines and their asserts are gone,
because the runtime owns the release; the preamble comments that taught `mktemp -d` as the
suffix-picker now name the runtime, since uniqueness was never the half that was missing.

## Proven from both sides, by input rather than by assertion

A GREEN run proves the success path, and the success path was never the fault. So the refusal path
was measured directly: one `assert false` planted immediately below the pen binding, above every
other line, in two files identical in every other respect.

| Shape | Same planted refusal | Pens left on the pier |
|---|---|---|
| elder -- `mktemp -d` and a straight-line sweep | exit 1 | **1** |
| landed -- `make-pen` | exit 1 | **0** |

**All nineteen GREEN on metal**, run one at a time, 317 seconds together: `amphora_pour` 11s,
`amphora_restore_negative` 12s, `amphora_mark_wreck` 32s, `amphora_carry` 13s,
`amphora_carry_negative` 13s, `amphora_restore` 12s, `amphora_pour_negative` 19s,
`amphora_grand_round` 14s, `amphora_first_resident` 15s, `amphora_framed_name` 30s,
`amphora_contained_name` 30s, `amphora_named_once` 16s, `amphora_manifest_agrees` 14s,
`amphora_receipt_bundle` 13s, `amphora_prove_before_write` 16s, `amphora_ferried_body_proven` 12s,
`amphora_pour_agrees` 17s, `amphora_pour_atomic` 21s, `amphora_carry_atomic` 17s.

## The census moved as its own header promised

`sh tools/fixtures/p/pen_release_scan.sh`, before and after:

| Reading | Before | After |
|---|---|---|
| `runtime_pens` | 2 | **21** |
| `unreleased_on_refusal` | 342 | **324** |
| `never_removed` (gated) | 9 | **8** |
| `rish_runners` | 333 | 314 |

The scan's two populations are disjoint by construction, so a conversion moves a file between
readings rather than out of the census -- which is the property that makes the fall above legible
rather than a disappearance.

## And the one that left the gated reading was never a leak

`amphora_restore_negative_witness.rish` swept its pen on every run. It read `never_removed` because
it spells the removal in Rishi's argv form, `run ["rm" "-rf" home]`, and the predicate requires a
`$` sigil -- the false positive `%758` booked three hours before this lap and handed to the lane
that owns the meter. **Proven by changing nothing but the notation:** respelled `${home}`, the
identical removal read `straight` and the gated count fell to 8 on its own, with the file's
behavior untouched.

So the ceiling falls 9 to 8 **because a false positive left, rather than because a leak closed**,
and that sentence is written into the scan's own ceiling arc and the witness's header, where the
next reader meets it before reading the fall as a repair. The predicate is still blind; eleven
other tracked Rishi sources still write the form it cannot see.

## What `%745` still holds

The row reads *the nineteen-file repair is copal's lane and its next lap*, and that half is landed.
It stays **OPEN** for the half this lap may not touch: whether the fleet reads its own free space is
named in the row as Keaton's word, and no agent opens a gate. The row is not edited -- the ledger's
own first law -- and this account is where the repair is recorded.

## Reds met on the cold endurance run

Four stood at the reading taken, and three were a peer's, every one landed inside the two hours
before this lap opened:

- **`vocabulary_collection`** -- `construction/ITINERARY.md` said `corpus` in reader prose, one
  line, inside diffuser's own account. The guard's seated rule gives the sense its plain word;
  Grain's body of living documents is a **collection**. One word changed, GREEN on metal. Taken
  rather than named because the card is every ship's and the red stood on every ship's pass.
- **`tool_letter_room`** -- `misfiled=3` against a ceiling of 0: `key_trade_witness.rish`,
  `key_trade_scan.sh` and `key_trade_control.sh` all sit in room `t` where their own name says `k`.
  Diffuser renamed that family whole this morning. **Named rather than taken** -- moving a peer's
  in-flight files is what the baton forbids, and their claim is live.
- **`shell_dialect`** -- `gated_readlink_f_sites=8` against a ceiling of 7. Commit `d65db16c0` at
  04:48 added the eighth in `tools/fixtures/a/aurora_placement_scan.sh`. Diffuser's. Named.
- **`remember_git_nib`** -- stale from this lap's own claim commit, and closed by this send.

## The roster reading, named honestly

**The cold endurance run was still running at this commit** -- 177 guards of roughly 300 after 35
minutes, four reds, every one read and accounted for above. It is a PRE-work reading and it is
compromised by my own hand: I converted while it ran, so it reads `tree_moved=yes`, which is the
fault patchouli booked in the same words one lap earlier. The value a cold pass gives -- *what was
red before I started* -- was extracted at guard 177 and acted on.

**A roster HOT pass was declined rather than taken, and the reason is the pier.** `uptime` read
**load average 15.2** with **four** `standing_equipment_run.sh` passes live from four different
ships' trees. A fifth pass under that contention produces reds about pens and ports rather than
about code, and a false red is worse than no reading: it teaches a ship that a guard can be
ignored, which is `%754`'s own lesson one instrument over. So the hot reading here is **by name
rather than by roster** -- the guards below, each run individually on metal after `git add`, on a
tree then held still.

## Guards GREEN on metal

`pen_release` (46-leg control, `fail=0`), `amphora_roster` (103 planted behaviors), `shared_pen`,
`pen_entry`, `exec_bit`, `vocabulary_collection`, `tame_style_check`, and the nineteen converted
witnesses named above. `rish_spoken_ascii` reads 10,435 under its ceiling of 10,515.

## What this does not reach

**The predicate**, which is `%758`'s and the meter lane's. **The other 324 straight-line pens**,
which are eight other rooms' laps to take, each in its own lane, with this room standing as the
worked example. **Whether a converted witness is a good witness** -- this proves where its pen goes
and stops there.

**And one small door found while reading, left open on purpose:**
`tools/am/amphora_udp_reuseaddr_witness.rish:45` binds `let pen = run ["sh" control]` -- a variable
named `pen` holding a control run's *result* rather than a directory. It makes no pen, so no meter
in this family miscounts it, and it is a clarity tell rather than a red. Named here instead of
swept, since one keystone a lap is the rule and this one is a peer of nothing.
