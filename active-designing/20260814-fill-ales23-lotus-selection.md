# ALES23 — Lotus's selection, a marked span a keeper edits as one across both channels

**Stamp:** `20260814.135230` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES22
**Waymark:** ALES · rung ALES23
**Kin:** [`ALES20 — the markers track`](20260814-fill-ales20-lotus-markers.md) · [`ALES22 — the cue sheet`](20260814-fill-ales22-lotus-cue-sheet.md) · [`lotus/selection.rye`](../lotus/selection.rye) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2, `cut` and `gain` reused whole) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the `StereoClip` whose channels share one length) · [`lotus/markers.rye`](../lotus/markers.rye) (ALES20, `region_between`)

---

## Why this round

The markers track (ALES20) names places and the cue sheet (ALES22) saves them, yet a keeper does more than navigate to a mark — they **grab** the span between two marks and act on it whole: silence the count-in, halve the bridge, cut the bad take. A selection is that grabbed span `[start, end)` over a stereo master, edited as one.

Lindy-first, crux-first: a selection is the primitive every span edit rides on — cut, gain, silence, and (later) copy and move all take a selection — so it is a higher-Lindy move than one more single-purpose transform. It stays wholly within the edit side, reusing ALES2's two proven in-place edits and ALES20's `region_between` over their public APIs, so it carries the least risk of the road-on's rungs. No module seam, no gate.

## The one crux this rung fixes

**Editing a selection keeps the two channels in lockstep and operates exactly the marked span.** Two facts make this exact:

- **Lockstep from the shared length.** A `StereoClip`'s two channels share one length (ALES10's invariant `left.len == right.len`), and every edit passes the **same** `(start, span)` to each — so a cut shrinks both by the same count (`left.len == right.len` after) and a gain scales the same samples in both. The edit is checked against the shared length **first** (ALES2's `cut` / `gain` refuse `BadRange` before any shift), so either both channels change or neither does — a stale span past a shrunk master refuses `BadRange` before touching a sample.
- **Exactness from ALES2's own edits.** Each channel edit is ALES2's proven `cut` / `gain`, so a selection cut equals cutting each channel by hand — the samples outside the span untouched, the tail gapless, the gain saturating to the i16 range.

## The shape

`lotus/selection.rye`:

- `Selection` — a grabbed span `[start, end)`, a pair of offsets with a `span()`; no samples of its own.
- `make(master, start, end)` — validate the span against the master's shared length, refusing `BadSelection` on an empty, inverted, or past-the-master span.
- `select_between(markers, i, j, master)` — grab the span between two named marks, exactly ALES20's `region_between` read as an editable selection; forwards `BadPair`.
- `cut(master, sel)` — remove the span from both channels in lockstep (ALES2's `cut` applied to each).
- `gain(master, sel, num, den)` — scale the span's loudness in both channels (ALES2's `gain`); a negative num inverts phase.
- `silence(master, sel)` — a gain of 0/1 over the span, the count-in or the dead bar zeroed as one.
- `SelectionError` — `error{ BadSelection } || timeline.EditError || markers.MarkerError`, every forwarded fault refusing by name.

## What the witness proves (GREEN on metal)

`tools/al/ales_selection_witness.rish`: a selection cut removes the span from both channels in lockstep, equal to cutting each by hand, the stereo staying aligned; a gain scales the span in both channels and leaves the rest and the lengths untouched; silence zeroes the span in both; a selection grabbed between two markers drives a real cut; and every edge refuses by name — an empty, inverted, or past-the-master span (`BadSelection`), a zero denominator (`BadGain`), a non-ascending marker pair (`BadPair`), and a stale span past a shrunk master (`BadRange`) refused before either channel is touched. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a selection a keeper edits a marked span as one. The next rung can offer the **choice of law** where a crossfade meets a selected edit, **splice** a selection onto a second point (a marked copy or move), or — a module seam, Keaton's word — carry a selection across the ALES0 audio **wire** as its own framed payload, tying an editable span to the Mikrophone's capture. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
