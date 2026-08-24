# Every module in `lotus/`

**Language:** EN - **Voice:** Kyri - **Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- **240 modules** stand in this directory on `20260824.091754`, and every one of them has a row below.
**Held to the directory by** [`../tools/l/lotus_module_roster_witness.rish`](../tools/l/lotus_module_roster_witness.rish) over [`../tools/fixtures/module_roster_scan.sh`](../tools/fixtures/module_roster_scan.sh), which gates `unrostered`, `phantom`, `duplicate_rows`, and `mismatched_rows` at zero.

This page exists because the front door could not hold it honestly. On `20260824` `README.md` stood at **297,878 bytes** and named **83** of the 240 modules beside it, with one name -- `channel.rye` -- belonging to `constel/` and `pond/apps/` rather than here. So 157 modules had landed with nobody adding a line, and the page read exactly like a full account (REDS %190, the third firing of the shape first booked as %184).

Each row's sentence comes from that module's own `//!` head comment, so the page says what the code says. For the ladder's reasoning -- which rung answered which question, and why the next one followed -- read [`LADDER.md`](LADDER.md); this page answers *what is here* and stops there.

---

## The wire and the stream -- 5

How audio arrives and how it is stored -- a sealed frame verified before the timeline ever sees it, and the two seam symlinks into `../tally/` that a reader finds here and expects explained.

| Module | What it does |
|---|---|
| [`wire.rye`](wire.rye) | the basic audio wire shape |
| [`stream.rye`](stream.rye) | a bounded audio byte stream, one frame at a time, reassembled gapless |
| [`wav.rye`](wav.rye) | the canonical RIFF/WAVE container for mono 16-bit PCM |
| [`parse_int.rye`](parse_int.rye) | tally/parse_int.rye -- strict-by-default integer parsing |
| [`tally_copy.rye`](tally_copy.rye) | tally/copy.rye -- the disjoint copy, with its preconditions written down |

## Span edits on the timeline -- 22

Every gesture that rearranges samples without asking what they sound like. Each is exact: the same samples in a different order, or an arithmetic mirror of them.

| Module | What it does |
|---|---|
| [`timeline.rye`](timeline.rye) | the edit gestures over a reassembled sample timeline -- cut, gain, splice |
| [`crop.rye`](crop.rye) | crop -- keep the `count` samples starting at `start` and DROP every sample before and after, so the clip becomes exactly that span, IN PLACE |
| [`duplicate.rye`](duplicate.rye) | duplicate -- insert a second copy of the `count` samples starting at `start` immediately after the span, IN PLACE, so [start, start+count) becomes [start |
| [`move.rye`](move.rye) | move -- lift the `count` samples starting at `start` out of the timeline and reinsert them at `dest`, IN PLACE, so the span is RELOCATED and the clip's length HOLDS |
| [`paste_over.rye`](paste_over.rye) | paste_over -- write the `src` samples over the clip IN PLACE starting at `at`, so [at |
| [`replace.rye`](replace.rye) | replace -- remove the `count` samples starting at `at` and insert `src` in their place, IN PLACE, so [at, at+src.len) becomes `src` |
| [`insert_silence.rye`](insert_silence.rye) | insert_silence -- open `count` samples of silence at position `at`, shifting the tail right to make room, GROWING the clip, the lossless twin of ALES108's shift |
| [`silence_span.rye`](silence_span.rye) | silence_span -- write silence over `count` samples starting at `start`, IN PLACE, leaving the length and every sample outside the span exactly as they were |
| [`shift.rye`](shift.rye) | shift -- slide the whole clip by `by` samples and DROP the samples that fall off the edge, filling the vacated end with silence, the honest twin of ALES106's rotate |
| [`rotate.rye`](rotate.rye) | rotate -- cyclic left-shift the whole clip by k samples, the k that fall off the front wrapping onto the tail |
| [`reverse.rye`](reverse.rye) | reverse -- turn the whole clip end for end, the plainest EXACT edit on the timeline |
| [`invert.rye`](invert.rye) | invert -- flip every sample's sign, y = saturate(-x), the exact VALUE-mirror of ALES104's reverse |
| [`nyquist.rye`](nyquist.rye) | nyquist_flip -- flip the sign of every ODD-indexed sample, y[n] = saturate((-1)^n * x[n]), the exact parity-cousin of ALES105's invert |
| [`normalize.rye`](normalize.rye) | peak normalization -- measure the loudest sample through ALES13's meter |
| [`halve.rye`](halve.rye) | the half-wave rectifier -- keep the positive half, zero the negative, y = max(x, 0) |
| [`halve_neg.rye`](halve_neg.rye) | the inverted half-wave rectifier -- keep the negative half, zero the positive, y = min(x, 0) |
| [`join.rye`](join.rye) | the crossfade join -- the choice of law where an inserted span meets its neighbour |
| [`insert_join.rye`](insert_join.rye) | the two-sided insert-join, the trailing-seam law |
| [`paste_join.rye`](paste_join.rye) | the paste that JOINS rather than butts -- a held span dropped into the middle of a master crosses BOTH its seams equal-power |
| [`graft.rye`](graft.rye) | the graft -- a selected span COPIED or MOVED onto a second point, both channels in lockstep |
| [`selection.rye`](selection.rye) | the selection -- a marked span a keeper edits as ONE across both channels |
| [`clipboard.rye`](clipboard.rye) | the clipboard -- a held span PASTED anywhere, any number of times, ACROSS masters |

## Transport, clock, and the map -- 10

Reading a master the way a keeper hears it -- play, loop, meter, scrub -- and the named places they keep along the way.

| Module | What it does |
|---|---|
| [`clock.rye`](clock.rye) | the sample clock -- a real time base for the timeline |
| [`transport.rye`](transport.rye) | the transport play head -- read a rendered master forward, block by block, stopping exactly at the end |
| [`loop.rye`](loop.rye) | the transport loop -- a marked region read round and round, the first read that does not end |
| [`meter.rye`](meter.rye) | the peak/RMS meter -- the same root ALES11 proved, turned around to READ the master rather than SHAPE the field |
| [`scrub.rye`](scrub.rye) | the scrub window -- a small, fixed-length read a keeper DRAGS across a stereo master |
| [`markers.rye`](markers.rye) | the markers track -- named positions a keeper navigates and snaps to |
| [`marker_time.rye`](marker_time.rye) | markers in real time -- a named place set and read in SECONDS |
| [`cue_sheet.rye`](cue_sheet.rye) | the marker track travels as text -- a cue sheet |
| [`cue_seal.rye`](cue_seal.rye) | the cue sheet, SEALED -- the arrangement map that verifies before it is trusted |
| [`track.rye`](track.rye) | the track table -- many placed clips rendered into one master |

## Mix, faders, and the stereo field -- 16

Many tracks becoming one master, and the laws that govern where each one sits and how loud it lands.

| Module | What it does |
|---|---|
| [`mix.rye`](mix.rye) | mix a second track |
| [`fader.rye`](fader.rye) | the per-track fader column -- each track's level scales its contribution before the sum |
| [`strip.rye`](strip.rye) | mute and solo -- the channel strip's two switches, resolved to an effective fader column |
| [`pan.rye`](pan.rye) | pan -- one mono track placed across a stereo field, opening the second channel |
| [`power.rye`](power.rye) | the equal-power pan law -- the constant it keeps is POWER, not SUM |
| [`crossfade.rye`](crossfade.rye) | the equal-power crossfade -- ALES11's pan law swept over TIME |
| [`fade.rye`](fade.rye) | a fade envelope |
| [`auto_pan.rye`](auto_pan.rye) | auto-pan -- the same triangle LFO swept across the STEREO FIELD, the family's third and last target |
| [`auto_pan_power.rye`](auto_pan_power.rye) | the equal-power auto-pan -- ALES11's equal-power split swept across time, in place of ALES76's linear weight |
| [`mid_side.rye`](mid_side.rye) | MID/SIDE -- the stereo master read as its SUM and its DIFFERENCE, the reversible primitive the width family spends |
| [`rack.rye`](rack.rye) | the multi-slot clipboard -- a NAMED RACK of held spans |
| [`rack_merge.rye`](rack_merge.rye) | two saved racks JOINED -- a rack merge, and a sealed import |
| [`rack_paste_join.rye`](rack_paste_join.rye) | the rack's paste, JOINED -- a named slot dropped into the middle of a master crosses BOTH its seams equal-power |
| [`rack_rename.rye`](rack_rename.rye) | a slot RE-NAMED in place |
| [`rack_seal.rye`](rack_seal.rye) | the slot sheet, SEALED -- a rack sheet that verifies before it is trusted |
| [`rack_sheet.rye`](rack_sheet.rye) | the rack travels as text -- a SLOT SHEET |

## Tone and filters -- 14

Shaping brightness rather than level. The one-pole split underneath, and the bands, shelves, and sweeps built from it.

| Module | What it does |
|---|---|
| [`tone.rye`](tone.rye) | a tone control -- a one-pole filter that shapes a clip's brightness |
| [`tone_carry.rye`](tone_carry.rye) | a carried-state low-pass -- a filter that spans a re-berthed region without a fresh transient |
| [`shelf.rye`](shelf.rye) | a two-band tone shelf -- bass and treble from the one-pole split |
| [`stack.rye`](stack.rye) | a three-band tone stack -- bass, mid, and treble from two one-pole splits |
| [`band.rye`](band.rye) | a band-pass -- keep the middle, drop the lows below one cutoff and the highs above another |
| [`bell.rye`](bell.rye) | a parametric bell (peaking EQ) -- turn the middle band, hold the edges |
| [`notch.rye`](notch.rye) | a band-reject (notch) -- keep the edges, drop the middle |
| [`allpass.rye`](allpass.rye) | the ALLPASS filter -- Schroeder's diffusion stage, the delayed DRY read against the delayed OUTPUT |
| [`sweep.rye`](sweep.rye) | a filter sweep -- a low-pass whose cutoff MOVES across a span, seamless because the state carries |
| [`glide.rye`](glide.rye) | the gliding delay -- a fractional delay read by linear interpolation |
| [`smooth_runs.rye`](smooth_runs.rye) | the run-length smoother -- absorb every run shorter than a minimum into what surrounds it, the smoothing hysteresis a real VAD needs |
| [`smooth_trim.rye`](smooth_trim.rye) | the smoothed silence trim -- smooth the runs through ALES101 BEFORE stripping the silence, so the strip declicks the pause and keeps the gap |
| [`dc_block.rye`](dc_block.rye) | the one-pole IIR DC blocker -- a DRIFTING-offset remover with CARRIED STATE, y[n] = x[n] - x[n-1] + R*y[n-1] |
| [`dc_remove.rye`](dc_remove.rye) | the DC-offset remover -- subtract the span's MEAN from every sample, y = x - mean, a PURE TRANSLATION |

## Dynamics -- 17

Gain that answers to the signal. A threshold, a ratio, and a sense of time -- the three knobs the whole family arranges differently.

| Module | What it does |
|---|---|
| [`compress.rye`](compress.rye) | a compressor -- the limiter's ceiling made gentle |
| [`compress_env.rye`](compress_env.rye) | an attack/release compressor -- the compressor's softened ceiling given a patient sense of time |
| [`compress_env_hold.rye`](compress_env_hold.rye) | an attack/HOLD/release compressor -- the breathing compressor given the one stage between its two knobs |
| [`limit.rye`](limit.rye) | a peak limiter -- a hard ceiling the signal may touch yet never cross |
| [`limit_env.rye`](limit_env.rye) | an attack/release limiter -- the peak limiter's hard ceiling given a patient sense of time, and the rung that completes the breathing trio |
| [`limit_env_hold.rye`](limit_env_hold.rye) | an attack/HOLD/release limiter -- the breathing limiter given the one stage between its two knobs, and the rung that completes the HELD dynamics trio |
| [`gate.rye`](gate.rye) | a noise gate -- the compressor's threshold turned upside down |
| [`gate_env.rye`](gate_env.rye) | an attack/release noise gate -- the gate's silenced floor given a patient sense of time |
| [`gate_env_hold.rye`](gate_env_hold.rye) | an attack/HOLD/release noise gate -- the breathing gate given the one stage between its two knobs |
| [`gate_key.rye`](gate_key.rye) | the keyed gate -- the door opened by ANOTHER signal |
| [`expand.rye`](expand.rye) | a downward expander -- the compressor mirrored under the threshold |
| [`expand_env.rye`](expand_env.rye) | an attack/release downward expander -- the expander's deepened floor given a patient sense of time |
| [`expand_env_hold.rye`](expand_env_hold.rye) | an attack/HOLD/release downward expander |
| [`envelope.rye`](envelope.rye) | an envelope follower -- the time base the whole dynamics family waits for |
| [`hold_env.rye`](hold_env.rye) | the envelope follower given a HOLD stage -- the patience between attack and release |
| [`sidechain.rye`](sidechain.rye) | the sidechain compressor -- the gain that follows ANOTHER signal |
| [`deess.rye`](deess.rye) | the de-esser -- the first sidechain COMPOSITION |

## Delay and modulation -- 9

A copy of the signal heard later, and what happens when the amount of later keeps moving.

| Module | What it does |
|---|---|
| [`echo.rye`](echo.rye) | the feedback delay -- the echo that decays |
| [`echo_time.rye`](echo_time.rye) | the echo in real time -- a delay named in MILLISECONDS |
| [`taps.rye`](taps.rye) | the multi-tap delay -- several fixed taps of the DRY signal |
| [`multitap_time.rye`](multitap_time.rye) | the multi-tap delay in real time -- taps named in MILLISECONDS |
| [`chorus.rye`](chorus.rye) | the chorus -- a triangle-LFO modulated delay round a centre |
| [`vibrato.rye`](vibrato.rye) | the vibrato -- the triangle-LFO modulated delay heard WET-ONLY |
| [`flanger.rye`](flanger.rye) | the flanger -- a short modulated delay with a FEEDBACK path |
| [`tremolo.rye`](tremolo.rye) | the tremolo -- the triangle LFO turned on AMPLITUDE, not delay |
| [`ring_mod.rye`](ring_mod.rye) | the ring modulator -- the tremolo's carrier let CROSS ZERO |

## Saturation and clipping -- 10

Deliberate distortion, each rung a different curve. The odd maps colour without adding even harmonics; the even ones change the character outright.

| Module | What it does |
|---|---|
| [`drive.rye`](drive.rye) | the hard-clip drive -- a pre-gain into ALES49's ceiling |
| [`soft_drive.rye`](soft_drive.rye) | the soft-clip overdrive -- ALES78's hard clip with its corner rounded |
| [`tube.rye`](tube.rye) | the asymmetric tube drive -- a different ceiling per sign, the DRIVE family's first CLIP that is not odd |
| [`fold.rye`](fold.rye) | the wavefolder -- the excess past the ceiling reflects back, a mirror not a wall |
| [`crush.rye`](crush.rye) | the bit-crusher -- drop the low bits, and the map is no longer odd |
| [`decimate.rye`](decimate.rye) | the sample-rate decimator -- hold each sample across a run, crushing TIME rather than AMPLITUDE |
| [`rectify.rye`](rectify.rye) | the full-wave rectifier -- fold the wave at zero, y = \|x\|, the plainest EVEN-harmonic generator |
| [`center_clip.rye`](center_clip.rye) | the center clipper -- silence the quiet middle, pass the loud, y = if \|x\| <= t then 0 else x |
| [`soft_center_clip.rye`](soft_center_clip.rye) | the soft center clipper -- silence the quiet middle AND subtract the threshold, y = if \|x\| <= t then 0 else x - sign(x)*t |
| [`infinite_clip.rye`](infinite_clip.rye) | the infinite clipper -- silence the quiet middle AND pin the loud to the rail, y = if \|x\| <= t then 0 else sign(x)*sample_max |

## Reverb -- 15

Schroeder's reverberator and the controls a keeper reaches for on it -- which room, how much, how bright, how long, and where in the field it sits.

| Module | What it does |
|---|---|
| [`reverb.rye`](reverb.rye) | the REVERB -- Schroeder's reverberator, parallel COMB stages summed then diffused through series ALLPASS stages |
| [`reverb_console_predelay.rye`](reverb_console_predelay.rye) | THE CONSOLE PRE-DELAY -- the dry-composed pre-delay, end to end |
| [`reverb_early_late.rye`](reverb_early_late.rye) | THE EARLY/LATE BALANCE -- the first reflections against the diffuse wash |
| [`reverb_freeze.rye`](reverb_freeze.rye) | THE FREEZE -- the reverb's HELD TAIL, sustained by iterated reverberation |
| [`reverb_gate.rye`](reverb_gate.rye) | THE GATE -- the reverb's GATED TAIL, the classic gated-reverb sound |
| [`reverb_gate_env.rye`](reverb_gate_env.rye) | THE ENVELOPE GATE -- the reverb's GATED TAIL given a shaped edge, the time-following gated reverb |
| [`reverb_mix.rye`](reverb_mix.rye) | THE WET/DRY MIX -- the first reverb knob that is not a bank choice |
| [`reverb_pan.rye`](reverb_pan.rye) | REVERB PAN -- reverberate the master WET, then place the reverberated result WHERE it sits in the field, the next rung after ALES212 closed HOW WIDE the wash sits |
| [`reverb_place.rye`](reverb_place.rye) | REVERB PLACE -- reverberate the master WET, then SEAT the reverberated result in the field: how WIDE it sits and WHERE, in one call |
| [`reverb_predelay.rye`](reverb_predelay.rye) | THE PRE-DELAY -- the reverb's WHEN knob, the short silent gap before the reverberant tail begins |
| [`reverb_preset.rye`](reverb_preset.rye) | NAMED ROOMS -- a reverb a keeper reaches for by name |
| [`reverb_shelf.rye`](reverb_shelf.rye) | THE SHELF -- a two-band tone shelf on the reverberant tail, the reverb's EQ |
| [`reverb_time.rye`](reverb_time.rye) | the REVERB in real time -- a network named in MILLISECONDS |
| [`reverb_tone.rye`](reverb_tone.rye) | THE TONE -- the reverb's DARKNESS knob, the high-cut on the reverberant tail |
| [`reverb_width.rye`](reverb_width.rye) | REVERB WIDTH -- reverberate the master WET, then set how wide the reverberated result sits |

## Analysis and silence -- 9

Rungs that READ the audio rather than write it, and the edits those readings make possible.

| Module | What it does |
|---|---|
| [`zero_cross.rye`](zero_cross.rye) | the zero-crossing counter -- the suite's first ANALYSIS rung, reading ALES92's flips as a count without writing one sample |
| [`schmitt.rye`](schmitt.rye) | the Schmitt trigger -- a HYSTERESIS comparator that gives ALES89's square a MEMORY against chatter, flip HIGH on a rise past t_high, flip LOW on a fall past t_low |
| [`voiced.rye`](voiced.rye) | the voiced/unvoiced/silent classifier -- the first Lotus rung to FUSE two analysis readers into one verdict |
| [`segment.rye`](segment.rye) | the voice-activity segmenter -- ALES94's classifier read across a whole clip, frame by frame, coalesced into runs |
| [`split_silence.rye`](split_silence.rye) | the silence splitter -- segment the clip through ALES95, then cut AT the silence, keeping each non-silent region as its own take |
| [`trim_silence.rye`](trim_silence.rye) | the silence stripper -- segment the clip through ALES95, then cut every silent run, leaving the sound contiguous |
| [`top_tail.rye`](top_tail.rye) | the top-and-tail trimmer -- segment the clip through ALES95, then cut ONLY the leading and trailing silence, keeping every internal pause |
| [`pad_tail.rye`](pad_tail.rye) | the padded top-and-tail -- trim the leading and trailing silence like ALES98, yet keep a chosen margin of silence adjacent to the content |
| [`collapse_silence.rye`](collapse_silence.rye) | the silence collapser -- cap every silent run to a maximum, keeping the pauses yet shortening the long ones |

## Render, catalog, and the sealed session -- 22

Where a project becomes an artifact somebody else can verify -- a render, a record, a catalog, and the one seal law they all call.

| Module | What it does |
|---|---|
| [`render.rye`](render.rye) | the render rung -- an ordered chain of real effects over one Clip becomes a canonical .wav |
| [`render_album.rye`](render_album.rye) | a whole record as one saveable artifact |
| [`render_bundle.rye`](render_bundle.rye) | manifest and .wav as one saveable artifact |
| [`render_manifest.rye`](render_manifest.rye) | a render describes itself, sealed |
| [`catalog_verify.rye`](catalog_verify.rye) | a whole catalog proven whole, end to end |
| [`library_diff.rye`](library_diff.rye) | what changed between two catalog versions |
| [`library_diff_sheet.rye`](library_diff_sheet.rye) | what changed, as a readable page |
| [`library_find.rye`](library_find.rye) | resolve an album by name in a catalog |
| [`library_manifest.rye`](library_manifest.rye) | a keeper's whole catalog, content-addressed |
| [`library_merge.rye`](library_merge.rye) | two independent sets of catalog changes, reconciled |
| [`library_merge_sheet.rye`](library_merge_sheet.rye) | the merge verdict, as a readable page |
| [`library_sheet.rye`](library_sheet.rye) | a keeper's whole catalog as a readable page |
| [`album_diff.rye`](album_diff.rye) | what changed between two record versions |
| [`album_diff_sheet.rye`](album_diff_sheet.rye) | what changed in a record, as a readable page |
| [`album_find.rye`](album_find.rye) | resolve a track by name in a record |
| [`album_manifest.rye`](album_manifest.rye) | a whole record's own content address, sealed |
| [`album_merge.rye`](album_merge.rye) | two independent sets of record changes, reconciled |
| [`album_merge_sheet.rye`](album_merge_sheet.rye) | the record merge verdict, as a readable page |
| [`album_sheet.rye`](album_sheet.rye) | a whole record's readable table of contents |
| [`seal.rye`](seal.rye) | the seal, made general -- one verify-before-trust law both sheets call |
| [`session.rye`](session.rye) | the session file -- a keeper's whole project as one sealed document |
| [`preset.rye`](preset.rye) | a named effect chain a keeper loads by name |

## The stereo carry -- 91

Ninety-one rungs that take a proven mono gesture to two channels in lockstep. Each reads its own frozen snapshot of its channel, so a gesture never hears its own output on the other side; each carries the same parameters to both, so the image holds.

| Module | What it does |
|---|---|
| [`stereo_allpass.rye`](stereo_allpass.rye) | the ALLPASS filter carried into stereo |
| [`stereo_band.rye`](stereo_band.rye) | a BAND-PASS carried into stereo |
| [`stereo_bell.rye`](stereo_bell.rye) | a PARAMETRIC BELL (PEAKING EQ) carried into stereo |
| [`stereo_center_clip.rye`](stereo_center_clip.rye) | the center clipper carried into stereo, ONE SHARED DEAD ZONE, opening the dead-zone corner of the stereo NONLINEAR class |
| [`stereo_chorus.rye`](stereo_chorus.rye) | the CHORUS carried into stereo |
| [`stereo_collapse_silence.rye`](stereo_collapse_silence.rye) | the interior silence-capper carried into stereo, ONE JOINT SILENCE capped in ONE LOCKSTEP -- the stripper of ALES148 kept its pauses |
| [`stereo_compress_env_hold.rye`](stereo_compress_env_hold.rye) | the ATTACK/HOLD/RELEASE COMPRESSOR carried into stereo |
| [`stereo_compress_env.rye`](stereo_compress_env.rye) | the ATTACK/RELEASE COMPRESSOR carried into stereo -- the LINKED envelope (ALES160) driving ONE LINKED gain (ALES157) over time |
| [`stereo_compress.rye`](stereo_compress.rye) | the compressor carried into stereo, ONE LINKED GAIN from the max detector, the image held to the sample |
| [`stereo_crop.rye`](stereo_crop.rye) | stereo_crop -- Trim to Selection carried into stereo, both channels in lockstep |
| [`stereo_crossfade.rye`](stereo_crossfade.rye) | the equal-power crossfade carried into stereo, ONE SHARED LAW |
| [`stereo_crush.rye`](stereo_crush.rye) | the bit-crusher carried into stereo, ONE SHARED GRID, the resolution corner of the stereo NONLINEAR class |
| [`stereo_cut.rye`](stereo_cut.rye) | stereo_cut -- the foundational span-remove carried into stereo, both channels in lockstep |
| [`stereo_dc_remove.rye`](stereo_dc_remove.rye) | the DC-offset remover carried into stereo, TWO INDEPENDENT MEANS taken back out, a per-channel PURE TRANSLATION that PRESERVES the stereo image |
| [`stereo_decimate.rye`](stereo_decimate.rye) | the sample-rate decimator carried into stereo, ONE SHARED RUN GRID, the time corner of the stereo NONLINEAR class |
| [`stereo_drive.rye`](stereo_drive.rye) | the hard-clip drive carried into stereo, ONE SHARED MAP, opening the stereo NONLINEAR class |
| [`stereo_duplicate.rye`](stereo_duplicate.rye) | stereo_duplicate -- the growth gesture carried into stereo, both channels in lockstep |
| [`stereo_echo.rye`](stereo_echo.rye) | the ECHO carried into stereo |
| [`stereo_echo_time.rye`](stereo_echo_time.rye) | the STEREO ECHO in real time |
| [`stereo_envelope.rye`](stereo_envelope.rye) | the ENVELOPE FOLLOWER carried into stereo -- one LINKED detector, the time base the whole stereo time-varying dynamics family waits for |
| [`stereo_expand_env_hold.rye`](stereo_expand_env_hold.rye) | the ATTACK/HOLD/RELEASE DOWNWARD EXPANDER carried into stereo |
| [`stereo_expand_env.rye`](stereo_expand_env.rye) | the ATTACK/RELEASE DOWNWARD EXPANDER carried into stereo |
| [`stereo_expand.rye`](stereo_expand.rye) | the downward expander carried into stereo, the gate's linked DECISION fused with the compressor's linked GAIN |
| [`stereo_fade.rye`](stereo_fade.rye) | the fade envelope carried into stereo, ONE SHARED RAMP |
| [`stereo_flanger.rye`](stereo_flanger.rye) | the FLANGER carried into stereo |
| [`stereo_fold.rye`](stereo_fold.rye) | the wavefolder carried into stereo, ONE SHARED TRIANGLE, the reflecting corner of the stereo NONLINEAR class |
| [`stereo_gate_env_hold.rye`](stereo_gate_env_hold.rye) | the ATTACK/HOLD/RELEASE NOISE GATE carried into stereo |
| [`stereo_gate_env.rye`](stereo_gate_env.rye) | the ATTACK/RELEASE NOISE GATE carried into stereo -- the LINKED envelope (ALES160) driving ONE LINKED gate decision (ALES156) over time |
| [`stereo_gate.rye`](stereo_gate.rye) | the noise gate carried into stereo, ONE LINKED DETECTOR, the image the gate refuses to tear |
| [`stereo_halve_neg.rye`](stereo_halve_neg.rye) | the inverted half-wave rectifier carried into stereo, ONE SHARED THRESHOLD AT ZERO, COMPLETING the rectifier family in stereo |
| [`stereo_halve.rye`](stereo_halve.rye) | the half-wave rectifier carried into stereo, ONE SHARED THRESHOLD AT ZERO, the EVEN+ODD member of the stereo NONLINEAR class's even corner |
| [`stereo_hold_env.rye`](stereo_hold_env.rye) | the HELD envelope follower carried into stereo |
| [`stereo_infinite_clip.rye`](stereo_infinite_clip.rye) | the infinite clipper carried into stereo, ONE SHARED RAIL, CLOSING the dead-zone family in stereo |
| [`stereo_insert_join.rye`](stereo_insert_join.rye) | the two-sided insert-join carried into stereo -- both channels, both seams, in lockstep |
| [`stereo_insert_silence.rye`](stereo_insert_silence.rye) | stereo_insert_silence -- opening a silent gap carried into stereo, both channels in lockstep |
| [`stereo_invert.rye`](stereo_invert.rye) | stereo_invert -- the phase flip of a master carried into stereo, both channels in lockstep |
| [`stereo_join.rye`](stereo_join.rye) | the crossfade join carried into stereo -- both channels crossed in lockstep |
| [`stereo_limit_env_hold.rye`](stereo_limit_env_hold.rye) | the ATTACK/HOLD/RELEASE BRICKWALL LIMITER carried into stereo |
| [`stereo_limit_env.rye`](stereo_limit_env.rye) | the ATTACK/RELEASE BRICKWALL LIMITER carried into stereo -- the LINKED envelope (ALES160) driving ONE LINKED ceiling (ALES158) over time |
| [`stereo_limit.rye`](stereo_limit.rye) | the brickwall limiter carried into stereo, the ratio->inf corner of the linked gain -- both a true ceiling and an image held whole |
| [`stereo_loop_meter.rye`](stereo_loop_meter.rye) | metering a looping stereo region live -- the ALES16 loop head feeding the ALES17 stereo meter |
| [`stereo_loop.rye`](stereo_loop.rye) | the stereo loop -- one marked region cycled through two channels in lockstep |
| [`stereo_meter.rye`](stereo_meter.rye) | the stereo meter during playback -- two meters read both channels in lockstep off the one stereo head |
| [`stereo_move.rye`](stereo_move.rye) | stereo_move -- the drag gesture carried into stereo, both channels in lockstep |
| [`stereo_normalize.rye`](stereo_normalize.rye) | peak normalization carried into stereo, ONE SHARED GAIN |
| [`stereo_notch.rye`](stereo_notch.rye) | a BAND-REJECT (NOTCH) carried into stereo |
| [`stereo_nyquist.rye`](stereo_nyquist.rye) | stereo_nyquist_flip -- the Nyquist flip of a master carried into stereo, both channels in lockstep, COMPLETING the stereo pure-rearrangement class |
| [`stereo_pad_tail.rye`](stereo_pad_tail.rye) | the padded top-and-tail carried into stereo |
| [`stereo_paste_over.rye`](stereo_paste_over.rye) | stereo_paste_over -- the overwrite paste carried into stereo, both channels in lockstep |
| [`stereo_preset.rye`](stereo_preset.rye) | a named preset carried over both channels of a stereo master |
| [`stereo_rectify.rye`](stereo_rectify.rye) | the full-wave rectifier carried into stereo, ONE SHARED FOLD AT ZERO, the EVEN corner of the stereo NONLINEAR class |
| [`stereo_render.rye`](stereo_render.rye) | the stereo render rung -- an ordered effect chain over a StereoClip becomes an interleaved stereo .wav |
| [`stereo_replace.rye`](stereo_replace.rye) | stereo_replace -- the general span-edit carried into stereo, both channels in lockstep |
| [`stereo_reverb_console_predelay.rye`](stereo_reverb_console_predelay.rye) | THE STEREO CONSOLE PRE-DELAY -- the dry-composed pre-delay heard AGAINST the dry, now across a stereo master |
| [`stereo_reverb_early_late.rye`](stereo_reverb_early_late.rye) | THE STEREO EARLY/LATE BALANCE -- the first reflections against the diffuse wash, now across a stereo master |
| [`stereo_reverb_freeze.rye`](stereo_reverb_freeze.rye) | THE STEREO FREEZE -- the reverb's HELD TAIL carried across a stereo master, sustained by iterated reverberation |
| [`stereo_reverb_gate_env.rye`](stereo_reverb_gate_env.rye) | THE STEREO ENVELOPE GATE -- the reverb's GATED TAIL given a shaped edge, the time-following gated reverb, now across a stereo master |
| [`stereo_reverb_gate.rye`](stereo_reverb_gate.rye) | THE STEREO GATE -- the reverb's GATED TAIL, the classic gated-reverb sound, now across a stereo master |
| [`stereo_reverb_mix.rye`](stereo_reverb_mix.rye) | THE STEREO WET/DRY MIX -- the reverb's most-reached-for knob, HOW MUCH reverb, now across a stereo master |
| [`stereo_reverb_predelay.rye`](stereo_reverb_predelay.rye) | THE STEREO PRE-DELAY -- the reverb's WHEN knob, the short silent gap before the reverberant tail begins, now across a stereo master |
| [`stereo_reverb_preset.rye`](stereo_reverb_preset.rye) | STEREO NAMED ROOMS -- the reverb a keeper reaches for by name, now across a stereo master |
| [`stereo_reverb.rye`](stereo_reverb.rye) | the REVERB carried into stereo |
| [`stereo_reverb_shelf.rye`](stereo_reverb_shelf.rye) | THE STEREO SHELF -- a two-band tone shelf on the reverberant tail, the reverb's EQ, now across a stereo master |
| [`stereo_reverb_time.rye`](stereo_reverb_time.rye) | the STEREO REVERB in real time |
| [`stereo_reverb_tone.rye`](stereo_reverb_tone.rye) | THE STEREO TONE -- the reverb's DARKNESS knob, the high-cut on the reverberant tail, now across a stereo master |
| [`stereo_reverse.rye`](stereo_reverse.rye) | stereo_reverse -- turning a master end for end, both channels in lockstep |
| [`stereo_ring_mod.rye`](stereo_ring_mod.rye) | the RING MODULATOR carried into stereo |
| [`stereo_rotate.rye`](stereo_rotate.rye) | stereo_rotate -- the cyclic turn of a master carried into stereo, both channels in lockstep |
| [`stereo_schmitt.rye`](stereo_schmitt.rye) | the Schmitt trigger carried into stereo, ONE SHARED BAND, TWO INDEPENDENT RAILS |
| [`stereo_segment.rye`](stereo_segment.rye) | the voice-activity segmenter carried into stereo, ONE SHARED FRAME GRID and TWO INDEPENDENT SEGMENTATIONS -- the suite's third STEREO ANALYSIS rung |
| [`stereo_shelf.rye`](stereo_shelf.rye) | a TWO-BAND TONE SHELF carried into stereo |
| [`stereo_shift.rye`](stereo_shift.rye) | stereo_shift -- the grid nudge carried into stereo, both channels in lockstep |
| [`stereo_silence_span.rye`](stereo_silence_span.rye) | stereo_silence_span -- silencing a span carried into stereo, both channels in lockstep |
| [`stereo_smooth_runs.rye`](stereo_smooth_runs.rye) | the run-length smoother carried into stereo, TWO INDEPENDENT HYSTERESIS HOLDS |
| [`stereo_smooth_trim.rye`](stereo_smooth_trim.rye) | the smoothed silence trim carried into stereo |
| [`stereo_soft_center_clip.rye`](stereo_soft_center_clip.rye) | the soft center clipper carried into stereo, ONE SHARED CONTINUOUS DEAD ZONE, the phase-holding yet ratio-breaking member of the stereo dead-zone corner |
| [`stereo_soft_drive.rye`](stereo_soft_drive.rye) | the soft-clip overdrive carried into stereo, ONE SHARED SHOULDER, the rounded corner of the stereo NONLINEAR class |
| [`stereo_split_silence.rye`](stereo_split_silence.rye) | the auto-splitter carried into stereo, ONE cut line for BOTH channels -- the stereo twin of the silence stripper |
| [`stereo_sweep.rye`](stereo_sweep.rye) | a FILTER SWEEP carried into stereo |
| [`stereo_taps.rye`](stereo_taps.rye) | the MULTI-TAP delay carried into stereo |
| [`stereo_tone.rye`](stereo_tone.rye) | a TONE CONTROL carried into stereo |
| [`stereo_top_tail.rye`](stereo_top_tail.rye) | the top-and-tail trimmer carried into stereo, ONE BRACKET for BOTH channels |
| [`stereo_transport.rye`](stereo_transport.rye) | the stereo transport -- one head reading two channels in lockstep |
| [`stereo_tremolo.rye`](stereo_tremolo.rye) | the TREMOLO carried into stereo |
| [`stereo_trim_silence.rye`](stereo_trim_silence.rye) | the silence stripper carried into stereo, TWO INDEPENDENT SILENCES cut in ONE LOCKSTEP |
| [`stereo_tube.rye`](stereo_tube.rye) | the asymmetric tube drive carried into stereo, ONE SHARED UNEVEN RAIL, the even-harmonic corner of the stereo NONLINEAR class |
| [`stereo_vibrato.rye`](stereo_vibrato.rye) | the VIBRATO carried into stereo |
| [`stereo_voiced.rye`](stereo_voiced.rye) | the voiced/unvoiced/silent classifier carried into stereo, ONE SHARED BAND/FLOOR/SPLIT and TWO INDEPENDENT VERDICTS |
| [`stereo_wav.rye`](stereo_wav.rye) | the canonical RIFF/WAVE container widened to two channels, interleaved |
| [`stereo_width.rye`](stereo_width.rye) | STEREO WIDTH -- the image narrowed or widened, by scaling the SIDE and recombining, the first rung to spend ALES210's mid/side primitive |
| [`stereo_zero_cross.rye`](stereo_zero_cross.rye) | the zero-crossing counter carried into stereo, ONE SHARED BAND and TWO INDEPENDENT COUNTERS |

