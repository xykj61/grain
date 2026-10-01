# Sonnet/Opus 5.5 -- safety classifier stops on routine work

**Language:** EN
**Stamp:** `20261001.142915` (EDT)
**Voice:** Kyri
**Style:** Gauge, Meter setting
**Status:** Checkable -- every claim below cites a comment URL
**Room:** checkable

## Provider and product

Anthropic, Claude Code. The model family is Sonnet 5.5 / Opus 5.5 (`claude-sonnet-5-5`,
`claude-opus-5-5`).

## What we observed

In one long Claude Code session on `claude-sonnet-5-5`, six separate safety-classifier stops
landed on ordinary repository work -- reading source files, running test scripts, editing text,
and a normal git commit/rebase/push sequence. No reason was given for any of the six; three left a
tool call marked "Interrupted" with unfinished work. Environment: Claude Code `2.1.286`, NixOS
`26.05.20260920.6d663c0` (`nixos-26.05`), tmux `3.6a`.

A search of `anthropics/claude-code` the same day found this is a known, active pattern rather than
something specific to our session -- fifteen new "safety classifier" reports filed in the prior 48
hours, several naming Opus/Sonnet 5.5 specifically as more prone to this than 5.1 or 4.8.

## The report

Ten comments posted on existing issues, cross-linking each other and naming our environment and
the stop pattern:

- [anthropics/claude-code#98724](https://github.com/anthropics/claude-code/issues/98724) -- closest to the repo's own bug-template shape; flagged first for that reason
- [anthropics/claude-code#98749](https://github.com/anthropics/claude-code/issues/98749)
- [anthropics/claude-code#98174](https://github.com/anthropics/claude-code/issues/98174)
- [anthropics/claude-code#98501](https://github.com/anthropics/claude-code/issues/98501)
- [anthropics/claude-code#98596](https://github.com/anthropics/claude-code/issues/98596)
- [anthropics/claude-code#97600](https://github.com/anthropics/claude-code/issues/97600)
- [anthropics/claude-code#98558](https://github.com/anthropics/claude-code/issues/98558)
- [anthropics/claude-code#98554](https://github.com/anthropics/claude-code/issues/98554)
- [anthropics/claude-code#97838](https://github.com/anthropics/claude-code/issues/97838)
- [anthropics/claude-code#98405](https://github.com/anthropics/claude-code/issues/98405)

Posted and later edited twice the same day: once to drop a misread detail (a model-pin precedence
message that was expected behavior, not a mismatch), once to fix a `gh api` flag mistake that had
briefly posted a literal filename instead of the comment text. Both corrections are recorded in
`session-logs/date/20261001/`.

A `/feedback` draft was also queued the same day, covering the same session.

## What we did meanwhile

The whole fleet (all eight ships) moved its model pin from the 5.5 family back to
`claude-sonnet-5` / `claude-opus-5`, on Keaton's word, until this clears. See
`construction/ITINERARY.md` and the session log at
`session-logs/date/20261001/20261001-142326_fleet-off-5-5-family.kyri`.

## Status at last read

**Open.** Filed `20261001.142915`; no maintainer reply seen yet on any of the ten threads.

## What would tell us it moved

A maintainer comment on any of the ten threads, a Claude Code changelog entry naming the
classifier, or our own observation that routine work on 5.5 no longer stops without a stated
reason -- at which point the fleet can move back.
