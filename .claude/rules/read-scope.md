# Read Scope -- open shelves and closed stacks

**Seated:** `20260827.155213` on Keaton's word - **Status:** Living
**Kin:** [`collaboration`](collaboration.md) (*References are promises*) - [`stamp-and-name`](stamp-and-name.md) (the resolvers) - [`quality-assurance`](quality-assurance.md) (on-touch, never on-walk)
**Map:** [`../../MAP.md`](../../MAP.md) is the walk that replaces the `ls`.
**Charter:** [`../../active-designing/20260829-203718_the-six-bodies-and-the-always-fleet.md`](../../active-designing/20260829-203718_the-six-bodies-and-the-always-fleet.md)

**The tree is a library with two floors.** The **open shelves** are the rooms a lap walks by
default. The **closed stacks** are rooms held whole and real -- nothing deleted, hidden, or
second-class -- that a lap enters only holding a call slip: a named path, a citation, or a
resolver's answer. The pair is this tree's warmer word for a read blacklist, and it is the
library's own: an open-shelf reading room you browse, and closed stacks fetched on request.

## Why the law exists

Six always-on hands read this tree around the clock, and reading is the budget. Measured by
`git ls-files` on `20260827`: the tree holds **14,703 tracked files**, and the dated, archived,
and deferred shelves (`date/`, `archive/`, `yonder/`) alone hold **7,568** of them -- over
half. The root faces **97 doors**, `tools/` holds **3,186 files** across its letter rooms, and
`session-logs/date/` holds **4,641**. A lap that opens with a root `ls`, a whole-`tools/` walk,
or a sweep-grep re-buys a map the tree already owns, every twenty minutes, six times over.

## Closed stacks, by shape and by name

**By shape:** every `date/`, `archive/`, and `yonder/` room, anywhere in the tree. These are
testimony and deferred work, and each has a resolver so a stale reference is an answer rather
than a hunt: `tools/d/dated_path_resolve.rish` for dated shelves, `tools/t/tool_path_resolve.rish`
for the tools letter rooms.

**By name:** `counsel/` - `waymarks/` - `bron-resins/` - `external-research/` - `gratitude/` -
`vendor/` - `seed/` - `research-silo/` - `classical-vedic-astrology/` -
`cubist-bhakti-astrology/` - `rye-learning-process/` - `nixos/` - `nixos-guide/` - `manual/` -
`docs-geode/` - `press/` - `saga/` - `journey/` - `biochemistry/` - `spellbook/` -
`assets/` - `keys/` - `recursion-prompts/` - `expanding-prompts/`.

**Closed governs the walk, never the write.** A lap may write a new dated study into a closed
room, cite into one, and fetch any named file from one -- what it never does is browse, `ls`,
or sweep a closed stack uninvited.

**The loops' own state is a closed stack.** Seated `20260827` on Keaton's word: the runtime state
of every agent loop lives in one gitignored **`loops/`** room, each subdirectory named plainly for
what it holds -- `loops/claude`, `loops/cursor`, `loops/codex`, `loops/editor-cursor`. It was six
dotted directories at the tree root, six of the 97 doors a lap faces when it opens the root.
`tools/ag/agent-jail.sh` and `tools/cu/cursor_jail_macos.rish` **adopt** an elder directory on the
next launch rather than abandoning it, because these hold auth a hand typed once.
**`.mind-state/` stays where it is**: the byte-pinned `tools/c/chatgpt-mind.sh` names it, and its
SHA-256 is the MIND adaptation receipt. Charter:
[`../../active-designing/20260827-174816_the-glow-tree-and-the-rooms-that-say-what-they-hold.md`](../../active-designing/20260827-174816_the-glow-tree-and-the-rooms-that-say-what-they-hold.md).
A lap reads **its own body's** files there by named path, and leaves every other body's alone. This
holds for outer-loop information (the launcher's transcript, lap counters, the seat prompt it was
handed) and inner-loop information (a sandbox's scratch, a session's cached auth) alike. The reason
is bounded reading rather than secrecy: six loops each walking five other loops' state is
thirty reads a round, none of which changes what the lap does next.

**The one shared window is `session-output/`** (gitignored, seated `20260828` on Keaton's word):
each loop tees its outer transcript to one per-seat file there, overwritten in place --
`mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so any agent reads a
peer loop's full output by named path rather than a hand pasting it. A read window, never a state
room: the loops' own state stays in `loops/`, and nothing in `session-output/` is a record --
`session-logs/` remains the journal.

## Open shelves

`construction/` pins (the card, REDS, the registries) - `context/` guides - `foundations/` -
`.claude/rules/` - `docs/` compressors - `session-logs/` flat (the pin and the newest logs) -
`active-designing/` and `active-development/` flat - **the module rooms the lap's own lane
names** - `tools/` by resolver rather than by walk.

## The four habits

1. **Never `ls` the root.** [`MAP.md`](../../MAP.md) is the walk, and it names both floors.
2. **Never walk `tools/` whole.** Resolve a witness by name, or open its one letter room.
3. **Scope a grep to the lane's rooms** plus `construction/` and `context/`; a tree-wide grep
   is a deliberate act the session log names. **The one standing exception is the reference
   sweep:** before any move or rename, the inbound-reference sweep stays whole-tree by law --
   references are promises, and a scoped sweep would break them silently.
4. **No sweep enters a closed stack uninvited.** QA passes, style sweeps, and ratchets ride
   on touch, and touch means the lap's own lane.

## What this law leaves whole

Witnesses keep their reach -- a guard reads whatever its scan reads, closed or open. The
resolvers and the census tools read the whole tree, because measuring is their job. And the
seed manifest is a different wall for a different reason: `template-manifest.bron` withholds
rooms from the **public**; the closed stacks only pace **our own** reading. Privacy and token
economy never share one mechanism, so neither can quietly loosen the other.

## Enforcement, honestly

The law is carried where unattended behavior is actually steered: the six seat prompts and the
card's Standing block. A read-census meter -- one that reads a lap's transcript and counts
closed-stack walks -- is named here as a future instrument rather than built, because a guard
on agent habit costs more than it returns while the habit is one week old.

Canonical Cursor twin: [`../../.cursor/rules/read-scope.mdc`](../../.cursor/rules/read-scope.mdc).
