# Cursor Agent on the pier

*How to start `cursor-agent` from this tree, and how Kyri and Kyli teach a prompt.*

**Language:** EN
**Style:** Bhakta at the Door setting, with Radiant warmth
**Guide:** [`../../context/BHAKTA_STYLE.md`](../../context/BHAKTA_STYLE.md) - [`../../context/TEACHER_STYLE.md`](../../context/TEACHER_STYLE.md)
**Voices:** Kyri and Kyli, jointly
**Written:** `20261007.085102`
**Status:** Living -- launch paths read from the tree; print-mode examples are the documented flags
**Room:** mixed -- the launch files exist; a live agent chat is a later possession
**Where this sits:** home is [`../../README.md`](../../README.md) - tutorials home is [`README.md`](README.md) - the incense plan is [`../../expanding-prompts/20261007-085102_incense-seed-acme-teacher-walk.md`](../../expanding-prompts/20261007-085102_incense-seed-acme-teacher-walk.md)

---

## Kyli -- two benches

Cursor has two benches.

The **GUI** is the window you already opened on `~/grain-incense`. Chat lives there. Files change there. Session logs are born there.

The **CLI** is `cursor-agent`. It is the same kind of agent, started from a terminal, often inside this tree's **agent jail**. The jail is a wrapper that starts the agent from the repository root with the project's own bounds.

You use the GUI when you want to see the huddle. You use the CLI when a pier, a script, or an unattended lap should start the agent for you.

## Kyri -- the launch that ships with the tree

From the repository root:

```sh
rishi/bin/rishi run tools/l/launch-cursor-agent.rish
```

That Rish file starts:

```sh
bash tools/ag/agent-jail.sh cursor-agent
```

Resume, print, and extra flags go through the bash elder, because the Rish launcher does not yet forward argv:

```sh
./tools/ag/agent-jail.sh --continue agent
./tools/ag/agent-jail.sh --resume=CHAT_ID agent
./tools/ag/agent-jail.sh cursor-agent -p "what is the hostname"
```

A one-shot print on a trusted local bench (documented in this tree's launch notes) looks like:

```sh
cursor-agent -p --force --trust --sandbox disabled pong
```

`--force` and `--trust` are local-bench flags. They stay on a machine you already own. They are not a way around the field's signing walls.

## Prompt examples Kyri and Kyli share

Paste these into GUI chat or into `cursor-agent -p "..."` after you have opened `~/grain-incense`.

**Huddle -- expand, then run**

```
Read expanding-prompts/20261007-085102_incense-seed-acme-teacher-walk.md.
Run its laps in order. Keep dated testimony. The cut stays RED.
Write a session log. Stop before any Mitra cut.
```

**Film -- write the sitting**

```
Write a session-log-v1 .kyri for this sitting under session-logs/date/YYYYMMDD/.
Prepend a row to that day's README-index. Stamp from the New York clock.
```

**Seed -- publish only when Keaton asked**

```
The public seed subject is incense.
Run sh publish-seed.sh and stop at custody gate %1.
Push only with sh publish-seed.sh --push when the user has already asked.
```

**Acme -- teach, do not crush the geode**

```
Write for a generic Acme employee.
docs-geode pages declare Bhakta at the Door setting, with Radiant warmth.
Teacher Style may speak in the body. The style line stays Bhakta.
Do not rewrite every geode page in one lap. Audit, then touch the doors you opened.
```

## What you will see when it works

The Rish launcher prints `launch-cursor-agent: agent-jail finished` with `ok=true` when the jail starts the agent. A print-mode `-p` call returns one answer and exits. A GUI sitting leaves a session log on the day's shelf.

## Why this matters to a life

A team that can start the same agent from a window or a pier can teach the next person without a private ritual. The command is the play. The prompt is the huddle. The session log is the film.

---

*May the two benches stay the same team.*
