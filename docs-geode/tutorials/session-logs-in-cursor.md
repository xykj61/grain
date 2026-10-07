# Session logs in Cursor

*How a sitting in `~/grain-incense` leaves a film you can watch later.*

**Language:** EN
**Style:** Bhakta at the Door setting, with Radiant warmth
**Guide:** [`../../context/BHAKTA_STYLE.md`](../../context/BHAKTA_STYLE.md) - [`../../context/TEACHER_STYLE.md`](../../context/TEACHER_STYLE.md)
**Voices:** Kyri and Kyli, jointly
**Written:** `20261007.085102`
**Status:** Living -- Cursor GUI sitting, written after the logs of this day were on disk
**Room:** mixed -- the paths and fields are checkable; the huddle around a prompt is judged
**Where this sits:** home is [`../../README.md`](../../README.md) - tutorials home is [`README.md`](README.md) - the incense plan is [`../../expanding-prompts/20261007-085102_incense-seed-acme-teacher-walk.md`](../../expanding-prompts/20261007-085102_incense-seed-acme-teacher-walk.md)

---

## Kyli -- the huddle

Welcome. You opened this tree in Cursor. You asked for a walk. When the walk ends, Grain keeps a short film of it: a **session log**.

A session log is a small text file that names what you asked, what the sitting thought, which files it touched, and what it recommends next. The filename carries a clock. The day's index points at it. You do not have to remember the sitting. You open the film.

Kyri will name the fields. I will keep the door open.

## Kyri -- what you open

1. Open the folder `~/grain-incense` as the Cursor workspace.
2. Work in the chat. Each sitting that lands writes a `.kyri` file under `session-logs/date/YYYYMMDD/`.
3. The day's table is `session-logs/date/README-index-YYYYMMDD.md`. Newest row at the top.
4. The room door is `session-logs/README.md`.

The name of a log looks like this:

```
session-logs/date/20261007/20261007-084830_the-suno-stems-reaper-mixea-hash-walk.kyri
```

The first twelve digits are the day. The six after the hyphen are the time on the New York clock. The rest is a short sprig, a few words for the play.

## The film, field by field

Open that file. You will see lines such as:

```
format session-log-v1
stamp 20261007.084830
editor Cursor
voice Kyri
title The Suno stems, Reaper, Mixea hash walk
prompt ...
think ...
obs ...
file ...
recommend ...
status ...
```

| Field | What it is |
|---|---|
| `stamp` | The one clock for this lap |
| `prompt` | What you asked, in one breath |
| `think` | The reasoning, short |
| `obs` | What the sitting measured |
| `file` | A path it wrote, and why |
| `recommend` | The next possession |
| `status` | Whether it landed |

A later sitting reads the film before it writes a new prompt. That is how connective tissue stays healthy: the next play starts from what actually happened.

## Commands this sitting ran

List today's shelf:

```sh
ls session-logs/date/20261007
```

Read the day's index:

```sh
sed -n '1,12p' session-logs/date/README-index-20261007.md
```

You will see a table. Each row is one sitting. Follow the link. That is the film.

## What this is for

An Acme employee who has never met this tree can still reconstruct a morning. The log is not a diary of feelings. It is a receipt of work, written so the next hand -- you, a teammate, or an agent -- can take the next possession without tearing the tissue.

---

*May the film stay short, and may the next huddle start from it.*
