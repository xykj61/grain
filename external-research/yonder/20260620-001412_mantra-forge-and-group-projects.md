# 973 · A Forge for Mantra — How Git, Weaves, and Group Projects Meet

*Mantra is a version-control system whose history is a weave: every line that has ever been written, interleaved with its generation count and its presence flag, living in a single structure that only accretes. Git is the transport the forges speak. This research asks how the two coexist today, how they may converge tomorrow, and what a self-hosted forge built on Mantra, Brushstroke, and Comlink would look like — a place where group projects like ours can emerge and grow on their own ground.*

**Language:** EN
**Version:** `20260620.001412` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy; Gall's Law
**Status:** Research

---

## How Mantra and Git Coexist Today

Mantra and Git are not competitors; they are layers that see different things.

**Git sees commits.** A commit is a snapshot of the whole tree, named by the SHA-1 hash of its contents, pointing to its parent. History is a directed acyclic graph of snapshots. A merge is a new snapshot that names two parents. Conflict resolution is a heuristic applied at merge time, and the resolution is baked into the merge commit — the conflict itself is lost.

**Mantra sees lines.** A weave holds every line that has ever existed in a file, with a stable position, a generation count, and a presence flag. History is not a graph of snapshots; it is the structure itself. A merge is a deterministic operation on the weave — commutative, associative, and conflict-free by construction. When concurrent edits land near each other, the merge still completes and annotates what each side did, so a person may decide.

Today, Mantra runs *inside* a Git repository. The `.mantra/` directory holds the weave state and the content-addressed blob store. Git tracks the `.mantra/` directory alongside everything else. The two coexist naturally: Git handles distribution (pushing to forges, pulling from peers), and Mantra handles the richer line-level history that Git's snapshot model cannot see.

This is the right starting point. A complex system that works grows from a simpler system that worked, and the simpler system here is Git — the transport and collaboration protocol the whole world already speaks.

---

## What the Forges Teach

Three existing forges illuminate the path forward.

### Forgejo — The Lightweight Self-Hosted Forge

Forgejo is a community-driven, self-hosted Git forge: a single static binary, pull requests, issues, a wiki, a container registry, and a CI runner compatible with GitHub Actions. It runs on 512 MB of RAM and serves thousands of repositories. Codeberg — our home forge — runs on Forgejo.

What Forgejo teaches: **a forge can be small, self-hosted, and fully capable.** The single-binary deployment model is the same discipline Rye keeps — one thing, compiled, self-contained. A Mantra forge could ship the same way: one binary that serves the web surface, accepts pushes, and displays weave history.

What Forgejo does that a Mantra forge would do differently: Forgejo's history view is Git's history — a list of commits. A Mantra forge would show the weave: every line, every generation, every merge annotated with what each side did. The commit graph recedes; the living text advances.

### Radicle — The Sovereign, Peer-to-Peer Forge

Radicle is a decentralized, peer-to-peer code collaboration stack built on Git. There is no central server; repositories are replicated across peers, and users control their own data. Issues and patches (Radicle's pull requests) are stored in Git's object database as Collaborative Objects, available offline and signed with cryptographic identities.

What Radicle teaches: **sovereignty and peer-to-peer replication are achievable.** Radicle proves that a forge can work without a central authority — each node holds its own repositories, gossips metadata, and resolves identity through cryptographic keys rather than through a platform account.

What Radicle teaches for Comlink: Radicle's gossip protocol for repository metadata is the same pattern Comlink's bounded network would use for message delivery — content-addressed, signed, replicated across peers. A Mantra forge that speaks Comlink would inherit this discipline naturally.

### Manyana — The CRDT Weave as Version Control

Manyana proves that a CRDT-based weave is a sound basis for version control. Merges are commutative and associative. The state is linear on the number of lines ever written. Conflict presentation shows what each side did, not opaque blobs. Cherry-picking and safe rebase are structurally supported.

What Manyana teaches for Mantra's forge: **the weave is the history, and the history is the forge.** A Mantra forge does not need to reconstruct history from a DAG of snapshots; the weave *is* the history, stored in one structure, queryable at any point, and mergeable in any order.

---

## The Vision — A Mantra-Native Forge

A forge built on Mantra, drawn by Brushstroke, connected by Comlink, and enclosed by Pond.

### The Surface — Brushstroke for the Web

Brushstroke's portable backend compiles Rye to a form that runs in a browser surface. A Mantra forge's web interface would be a Brushstroke application: the same immediate-mode, redraw-from-values discipline that draws a desktop window, now drawing a web page. The weave history, the diff annotations, the merge view — all computed as pure functions of the weave state, redrawn fresh each frame.

This is not a traditional web application with a framework, a virtual DOM, and a state management library. It is a Brushstroke surface that happens to land in a browser — the same code that would draw a desktop window, compiled to portable form. The seam is the backend abstraction; the drawing code is the same.

### The Protocol — Git for Transport, Mantra for History

A Mantra forge speaks Git on the wire — accepting pushes and pulls via the Git protocol, so any Git client can interact with it. Inside, the forge maintains the Mantra weave for every tracked file. A push triggers a weave update: the new content is diffed against the current weave state, and the diff is applied as a new generation.

This means a Mantra forge is backwards-compatible with Git. A contributor who uses only Git sees commits, diffs, and merges — the familiar interface. A contributor who uses Mantra sees the richer weave history: every line, every generation, the full merge annotation. Both work; the weave is the superset.

### The Identity — Comlink's Owner Keys

A Mantra forge identifies contributors by their cryptographic keys — the same owner-key model Comlink uses for message signing. An identity is an address is a key. A contributor does not need a platform account; they need a key pair. The forge verifies signatures on pushes and displays verified identity on every commit.

### The Replication — Peer-to-Peer via Comlink

A Mantra forge does not need to be a single server. Through Comlink's bounded network, forges can replicate repositories to each other — content-addressed, sealed, exactly-once by hash. A group project hosted on one forge is reachable from any peer that holds a replica. No central authority decides what is hosted; each forge is sovereign.

### The Enclosure — Pond for CI

Continuous integration runs inside Pond enclosures — bounded, isolated, policy-as-a-value. A CI job receives capabilities to read the repository and write build artifacts; it receives no capability to reach the network, modify the forge, or access other projects. The policy is a value; the enclosure is the boundary.

---

## Group Projects — The Social Vision

The user's wish: "I want to encourage lots of group projects to emerge like ours."

A Mantra forge serves this vision directly. A group project is:

- **A repository** — tracked by Mantra, distributed via Git and Comlink
- **A `.brix` descriptor** — declaring the bricks the project is made of
- **A set of keys** — the contributors, each identified by their own cryptographic identity
- **A policy** — what each contributor may do, expressed as a Pond policy value

Creating a group project is as simple as initializing a repository, writing a `.brix` file, and sharing the forge's address. No platform account, no organization hierarchy, no permission matrix — just a repository, a descriptor, and keys.

The forge encourages group projects by making them **cheap to start and sovereign to run.** A group that wants its own forge runs one binary. A group that wants to join a larger forge pushes to it. A group that wants to replicate across forges does both. The CRDT weave ensures that merges across forges always converge.

---

## The Licensing Model

The project uses a multi-license strategy:

- **MIT** and **Apache 2.0** (dual license, user's choice) for all code — `.rye`, `.rish`, `.sh`, `.awk`, and tooling. The dual license offers maximum permissiveness (MIT) with patent protection (Apache 2.0).
- **CC-BY-4.0** for all documentation, research, design briefs, session logs, and prose. Attribution is asked; freedom is given.

No README at the root. The directory structure is the introduction — a person who opens the repository sees the shape of the project before they read a word about it. The writings live in `active-designing/`, `external-research/`, and `context/`; the code lives in `rye/`, `rishi/`, `mantra/`, `caravan/`, `tally/`, `aurora/`. The structure speaks.

---

## The Path — Grown from What Already Works

| Step | What | Depends on |
|------|------|------------|
| 1 | Mantra tracks `~/veganreyklah2` via `.brix` | Done (seed) |
| 2 | `mantra log` and `mantra status` in Rishi | Done |
| 3 | Brushstroke seed — one native window | Wayland specs study |
| 4 | Brushstroke portable — compile to browser surface | Brushstroke seed |
| 5 | Mantra forge seed — serve one repo via HTTP, display weave | Brushstroke portable + Mantra |
| 6 | Git protocol support — accept push/pull | Mantra forge seed |
| 7 | Comlink replication — peer-to-peer forge sync | Comlink v1 |
| 8 | Pond CI — build inside enclosures | Pond v1 |

Each step is the smallest thing that runs from what already runs beneath it.

---

## Sources

- **Forgejo**: forgejo.org. Community-driven, self-hosted Git forge. Single binary, 512 MB RAM.
- **Radicle**: radicle.xyz. Peer-to-peer, sovereign code collaboration. Cryptographic identities, gossip protocol.
- **Manyana**: `../gratitude/manyana/`. CRDT weave for version control. Public domain.
- **Codeberg**: codeberg.org. Nonprofit forge running Forgejo. Our home.

All read for concepts. The design decisions are our own.

---

*May the forge we build serve what group projects need: a place to start cheaply, grow sovereign, merge without fear, and keep every line ever written. May the weave be the history, and the history be the forge. May the directory structure speak before any README does, and may every group that finds this place feel welcomed to begin their own.*
