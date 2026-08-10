# Your First Hour with Grain OS

**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Audience:** an Acme Corporation employee meeting Grain for the first time — no prior knowledge assumed
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Status:** Tutorial — every command below runs today, on this tree, and ends at a line you can see with your own eyes

---

Welcome. In the next hour you will hold a personal operating system in your own hands — clone it, build a piece of it, and watch it prove itself true right in front of you. You need no background to begin. If you can open a terminal and type, you can do everything on this page.

Read gently. Each step lands before the next one asks anything of you.

## What Grain Is

**Grain is a personal operating system you own.** Not an account on someone else's machine, not a service you rent — a whole small computer's worth of software that lives in a folder you control, that you can read end to end, and that keeps working whether or not anyone else is watching.

Grain descends from the ideas of **Urbit** — the project that first dreamed of a personal server every person truly owns, identity and all. Grain carries that dream forward in its own language and its own hands, and thanks its ancestor plainly while standing on its own worth. You do not need to know Urbit to use Grain. It is named here only so you know where the family comes from.

One word matters above all others here: **custody-first.** *Custody* means keeping — the way you keep a key, a letter, a memory. Grain is built so that what is yours stays yours: your identity, your records, your secrets. Nothing important lives somewhere you cannot reach it, and nothing is built that would take it away from you. When a design choice pulls between "convenient for a company" and "kept safe in your own hands," Grain chooses your hands.

Grain is made of small, honest **modules** — self-contained pieces, each doing one clear thing. A handful you will meet soon:

| Module | What it keeps or does |
|--------|-----------------------|
| **kumara** | your identity — who you are on the system |
| **vault** | your secrets, split so a fire or a forgotten day cannot erase them |
| **scribe** | reads the system's own records (you will run this one today) |
| **mandate** | remembers many things and finds them fast |
| **comlink** | carries messages between two people, sealed on the wire |
| **pond** | the surface an application draws on |

You do not have to learn them all now. Today you will build and run **scribe**, because it is the piece that reads Grain's own diary — and reading the diary is a lovely first thing to do in a new home.

## What You Need Before You Start

Very little.

- **A terminal** — the plain text window where you type commands. On Linux or macOS it is called *Terminal*; you already have one.
- **A git client** — the tool that copies a project to your machine. Type `git --version`; if it answers with a number, you have it.
- **A little patience for one download.** The first build fetches a compiler toolchain. That is the longest wait on this page, and it happens once.

That is the whole list. No account, no key, no payment, nothing to sign up for. Grain is a template anyone may clone freely.

## Step 1 — Clone the Template

*Cloning* means making your own complete copy of the project. Grain lives as a public template — a starting point everyone is welcome to take.

From your terminal, in whatever folder you keep your projects:

```bash
git clone https://github.com/grain-os/grain
cd grain
```

The first command copies the whole system to a new folder named `grain`. The second steps you inside it. Everything else on this page runs from right here — this folder is your home base, and the tutorials call it *the repository root*.

Look around, if you like:

```bash
ls
```

You will see the modules named above as folders — `kumara`, `scribe`, `vault`, and their kin — beside a `tools/` folder full of small proofs, and a `manual/` folder holding the very page you are reading. Nothing here is hidden from you. That is the point.

## Step 2 — Meet the Two Commands

Grain speaks through two tools that already live inside your clone. You will not install them separately — they came with the copy.

- **`rye`** — the *builder*. It turns a module's source (a file ending in `.rye`) into a small program you can run. Think of it as the workshop that shapes a part.
- **`rishi`** — the *witness runner*. It runs the little scripts (ending in `.rish`) that prove a fact about the system is true. Think of it as the inspector who checks the part after the workshop is done.

They sit at `rye/bin/rye` and `rishi/bin/rishi` inside your clone. When this tutorial writes `rye build …` or `rishi/bin/rishi run …`, it means those tools, right there in your folder.

One idea will carry you through everything that follows: a **witness**. A *witness* is a short script that proves exactly one honest fact about Grain, and ends with a line that starts `GREEN:` when the fact holds. Green means true, checked, seen — not hoped, not remembered. Grain never asks you to take its word; it shows you the green line instead.

## Step 3 — Build Your First Module

You will build **scribe**, the reader of Grain's own records. Its source is a single file, `scribe/reader.rye`.

From the repository root:

```bash
rye build scribe/reader.rye -femit-bin=scribe/bin/reader
```

Read that line in plain words: *build the scribe reader from its source, and place the finished program at `scribe/bin/reader`.* The `-femit-bin=` part simply names where the built program should land.

The **first** time you run `rye`, it fetches the compiler toolchain it needs. This is the one real wait on this page — a few minutes, once, and never again. When the command finishes and returns you to a fresh prompt with no error, your program is built. You just compiled a piece of an operating system. Take the win.

## Step 4 — Run Its Selftest

Every Grain module can test *itself*. A **selftest** is the module proving, from the inside, that it does what it claims. You ask for it by name:

```bash
scribe/bin/reader selftest
```

Scribe will read a small record, pick it apart into its pieces, and report what it found — ending with a line that begins `GREEN:`. In plain terms, scribe is telling you: *I read a Grain document, I understood its shape, I found the pieces inside it, and every claim I make about myself is true.*

You have now watched a module examine its own work and pass. This is the heartbeat of Grain: nothing is trusted until it has shown itself sound.

## Step 5 — Run the Witness and See GREEN

The selftest is scribe checking itself. A **witness** is Grain checking scribe — an outside inspector, kept in `tools/`, that runs the module and confirms every promise independently. Running it is the moment the whole discipline clicks into place.

```bash
rishi/bin/rishi run tools/scribe_reader_witness.rish
```

You should see a line like:

```
GREEN: scribe reader — the Kyri voice's home reads its own records: parse a document,
dispatch by format, get a field, count a repeated key — bounded and zero-copy.
```

When that line appears, you have proven — on real metal, with your own eyes — that scribe works. Not "should work." *Works.* Should any check ever fail, the witness stops loudly, prints a plain message telling you which promise broke, and exits with an error rather than pretending all is well. Green is earned every time.

That is the full loop of Grain, and you have now walked all of it: **build a module, let it test itself, let a witness prove it, read the green line.** Every one of the modules named at the top of this page is held to exactly this standard.

## Step 6 — Read a `.kyri` Log

The last skill of your first hour is the gentlest, and it lets you read Grain's memory.

Grain keeps a diary. Every time real work happens, it writes a short record — a **session log** — into `session-logs/`. These files end in `.kyri`, the plain notation Grain uses for its own records. *Kyri* is simply a tidy way of writing down facts: the first line names the kind of record, and every line after it is one fact, written as a name followed by its value. No brackets, no punctuation to trip over — just one honest fact per line.

Here is the shape of a session log, so you can recognize it anywhere:

```kyri
format session-log-v1
stamp 20260810.062705
editor Claude Code
voice Riyo
title Vault — the keeper of secrets
prompt build the vault module
think reasoned through the shape of a keeping that survives fire and time
obs the selftest proves it whole on a fake key
file vault/shard.rye the module — split a secret into signed shares
recommend check-in — the first lap holds; the next module waits its round
```

Read it top to bottom and it reads like a note to a friend:

- **`format`** — the very first line names what kind of record this is. Scribe reads this line first to know how to understand the rest.
- **`stamp`** — when the work happened, as a date and time.
- **`title`** — a short name for the round of work.
- **`prompt`** — what someone asked for.
- **`think`** — a step of reasoning. There may be several; each is one thought.
- **`obs`** — an observation, something noticed or decided along the way.
- **`file`** — a file the work touched, and one plain line saying why. There may be several.
- **`recommend`** — the closing note: what to do next, and why.

Some names — `think`, `obs`, `file` — appear more than once, because real work has more than one thought and touches more than one file. Scribe handles that perfectly: ask it for `think` and it can hand you every one. That is the very fact the witness you ran in Step 5 confirms.

To read a real one, list the diary and open any entry:

```bash
ls session-logs/
```

Pick a filename that looks interesting and open it in any text editor, or read it straight through with scribe itself:

```bash
scribe/bin/reader selftest
```

You now know how to read Grain's memory — every decision it has made is written in plain lines you can follow, kept where you can always reach them. That, again, is custody-first: even the system's own history belongs to you.

## What You Have Done

In one hour, with no prior knowledge, you:

- **cloned** your own complete copy of a personal operating system;
- **built** a real module from its source;
- watched that module **test itself** and pass;
- ran a **witness** and saw the `GREEN:` line prove it true;
- learned to **read** Grain's own records in plain `.kyri`.

You now hold the whole rhythm of Grain in your hands: *build, prove, read, keep.* Everything larger is made of exactly these small, honest moves.

## Where to Explore Next

You have a home now. Here are gentle doors from it, in the order they tend to open.

| Next step | What waits there |
|-----------|------------------|
| [`tutorials/first-witness.md`](tutorials/first-witness.md) | Write a tiny witness of your very own — the shortest path to making the system prove *your* fact |
| [`tutorials/run-record-and-failures.md`](tutorials/run-record-and-failures.md) | How a command's result is captured, and how a witness proves a failure on purpose |
| [`reference/rishi-language.md`](reference/rishi-language.md) | The full, gentle reference for the witness language you have already been reading |
| Other modules' witnesses in [`../tools/`](../tools/) | Run `tools/kumara_tilak_witness.rish`, `tools/pond_ring_dimeroll_witness.rish`, and their neighbors — each proves a different module green, the same way scribe just did |
| The four rooms of [`the manual`](README.md) | Tutorials to learn by hand, guides for a task in front of you, reference to look one thing up |

Take them one at a time. Grain grows exactly the way you just learned it — one small proven piece after another — and so, happily, can you.

---

*May your first build finish clean, your first witness run green, and every record you read tell you the plain truth of what it holds.*
