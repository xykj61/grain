# Reply — SOURCE beginner onboarding front door (for Claude)

**Language:** EN  
**Stamp:** `20260725.221958`  
**Voice:** Quin  
**Status:** Propose-never-seat — counsel for Claude and Keaton  
**Room:** Mixed — front-door teaching order (vision) · package and launch steps (checkable)  
**Ground:** Framework host · EDT · Cursor Grok 4.5 300k High Fast · pier already at `~/grain` · living `SOURCE.md` last touched `20260717.161957` · audience same as [`../../context/RADIANT_STYLE.md`](../../context/RADIANT_STYLE.md) (8th grade through collegiate · no prerequisite coding knowledge)  
**Companion still waiting:** [`20260725-185041_re-grain-brix-autoproject96-and-pier-status.md`](20260725-185041_re-grain-brix-autoproject96-and-pier-status.md) — this reply does **not** replace that ask; it adds a second front-door ask

---

## Ask of Claude

Please write a **new Quin Radiant counsel** (and, if the finishing edge wants it, a short **relay rung**) that weighs the beginner front-door proposals below against living [`../../SOURCE.md`](../../SOURCE.md).

We want SOURCE to teach a brand-new reader — same audience as Radiant Style — how to stand up Grain safely, in plain English, before they ever meet SSH, GPG, or in-jail signing.

Hand back:

1. Affirm, amend, or reorder the proposed **step spine**.  
2. Rule what belongs in **SOURCE** versus a sibling guide (browser · password manager · personal accounts).  
3. Name one **first checkable lap** Quin may `kg` after Keaton seats the counsel (and what stays check-in).  
4. Call out any safety, license, or Two-Rooms risk in the browser / subscription / apprentice-welcome language.

Do **not** seat SOURCE rewrites in the counsel — propose the shape; Keaton seats; Quin implements after the relay.

---

## Why this ask exists

Keaton noticed that SOURCE opens deep (forge accounts · SSH · GPG) before it ever says, in plain English:

- which **host OS** we recommend, and in what order  
- which **exact Cursor download** to fetch  
- that the **first host work** is package manager + `git` (outer terminal, outside Cursor / outside ai-jail)  
- that the happy path is **clone → place AppImage in `~/grain` → launch-cursor.rish → sign in**  
- that a friendly **apprentice welcome** can hand the new person to the agent with voice choice and Radiant Style

Living SOURCE already knows pieces of this (AppImage · `--cursor` · NixOS note buried in Step 6 · launch in Step 9). The gap is the **front door**: a beginner with no prerequisite knowledge never meets the OS preference ladder or the outer-terminal bootstrap before they are asked to make forge keys.

---

## Proposal A — Host OS preference ladder (plain English, early)

Teach this near the top, before Cursor and before forge keys:

| Rank | Host | Plain reason (draft) |
|------|------|----------------------|
| 1 | **NixOS** (latest stable; Keaton named **26.05** as the target season) | Best enclosure + reproducible host story for Grain |
| 2 | **Ubuntu LTS** (Keaton named **26.04 LTS**) | Well-trodden Framework / GNOME Wayland path this pier already proves |
| 3 | **macOS** | Supported with Seatbelt jail; no AppImage / no `bwrap`; more traps |
| Less preferred | Other Linux distros | May work; fewer witnessed paths in-tree |
| Less preferred | **Windows** | Harder enclosure story; Keaton’s apprentice note: USB install of Linux is worth it |

**Apprentice-facing lines Keaton already spoke (preserve the warmth; Claude may tighten):**

- *If I were you, I would back up everything and install either Ubuntu 26.04 LTS or NixOS 26.05.*  
- *You might need one or two USB flash drives. You will have a way better time than Windows.*  
- *NixOS will give you the best experience.*

**Quin lean:** Seat the ladder as living SOURCE prose (not a dated seal). Keep Windows / other-distro as honest “less preferred,” never as shaming.

---

## Proposal B — Cursor download: the specific link and artifact

Point the reader at **<https://cursor.com/download>** and name the artifact in plain English:

- Prefer the **AppImage** for their platform (the sandbox launcher wants AppImage → extract → `AppRun`, not `.deb` as the primary path).  
- **x86_64** AppImage — most PC laptops, Framework AMD/Intel, older Intel Apple machines when running Linux.  
- **ARM64** — newer Apple Silicon machines (and ARM Linux when that path is witnessed).  
- On macOS, there is no AppImage; Cursor ships as **`Cursor.app`** (already covered later in SOURCE; the front door should say so early so Apple readers do not hunt an AppImage).

Living SOURCE Step 5 already names Linux x86_64 AppImage for Framework. The ask is to **lead** with this, name ARM64, and keep `.deb` as a footnote rather than a peer choice.

---

## Proposal C — Reordered first host steps (outer terminal, before Cursor)

Proposed spine for the new front of SOURCE (Claude may reorder):

### C0 — Choose and install the host OS (if needed)

Backup · USB · NixOS or Ubuntu per ladder. Outer terminal only.

### C1 — Package manager + Git (still outer, still before Cursor)

Give three short, copyable templates — each “works from the start” in an **outer non-ai-jail terminal**:

| Host | Draft intent |
|------|----------------|
| **NixOS** | Minimal `configuration.nix` / flake snippet that installs `git` (and whatever else Claude rules as required for clone + first launch) |
| **Ubuntu** | `apt` update + install `git` (and ruled deps) |
| **macOS** | Homebrew install + `brew install git` (and ruled deps) |

**Open measurement for Claude (Quin does not invent):**

Does `git clone` require **`curl`** on the beginner path, or does the distro `git` package already pull what HTTPS/SSH needs? What is the minimal set for:

- HTTPS clone of `autoproject96/grain` (or the reader’s fork)  
- SSH clone once keys exist  
- later `rishi` / AppImage extract / ai-jail launch  

Please name the **minimal package list per host**, not a kitchen-sink desktop.

### C2 — Clone into `~/grain`

```bash
git clone <forge-url-to-grain> ~/grain
cd ~/grain
```

(Exact URL: public `autoproject96/grain` vs the apprentice’s own fork — Claude please rule the beginner default.)

### C3 — Place the Cursor AppImage in the clone

Download → `chmod +x` → `mv` into `~/grain` (versioned filename, e.g. `Cursor-…-x86_64.AppImage`).

### C4 — Launch jailed Cursor from the pier

Outer terminal, from `~/grain`:

```bash
rishi/bin/rishi run tools/launch-cursor.rish --cursor ./Cursor-<version>-x86_64.AppImage --gpu
```

(macOS twin already exists; front door should branch, not pretend AppImage is universal.)

### C5 — Sign in · confirm the window authenticated

Cursor opens inside ai-jail → browser login → confirm the running app shows a successful session.

### C6 — Then the existing SOURCE deep path

Two forge accounts · SSH · GPG · key cards · gitconfig · in-sandbox signing — today’s Steps 1–4 and 7–8 — after the reader can already ask the agent for help.

**Quin lean:** Keep today’s deep steps; **prepend** C0–C5; retitle so “Step 1” is no longer “make forge accounts” for a person who has not yet cloned the tree.

---

## Proposal D — Browser · password manager · extensions (scope question)

Keaton’s preferred personal stack for the sign-in moment:

| Piece | Draft recommendation |
|-------|----------------------|
| Browser | **Brave** |
| Password manager | **1Password** (paid monthly) |
| Extensions (Chrome Web Store → Brave) | OneTab · 1Password · Vimium · Reader View · Dark Reader · Phantom |
| Hygiene | Allow these extensions in private / incognito windows |
| Vault contents | Cursor · Gmail · bank checking · Venmo · 1Password itself · other daily accounts — saved in 1Password before relying on them for Cursor billing |
| Cursor plan | Pro or Ultra monthly; card stored in 1Password; confirm the jailed app registers the web login |

**Ask Claude hard:**

1. Does this belong **inside SOURCE**, or in a sibling “personal ops / first laptop” note that SOURCE links once?  
2. Naming **bank / Venmo / Phantom** in a public repo front door — helpful realism, or out of scope / oversharing risk for Acme-corporation and apprentice readers?  
3. Any conflict with Two Rooms, gratitude licenses, or “stay durable / no secrets in tree”? (The guide must never put vault material in git.)

**Quin lean:** One short SOURCE paragraph (“use a real password manager; Brave is fine; sign in only through the browser the app opens”) + a **linked sibling** for the full extension list and billing hygiene — unless Claude says the warmth belongs on the front door.

---

## Proposal E — Apprentice welcome (paste-ready, after Cursor runs)

Keaton’s draft welcome to a college-student friend / possible apprentice / possible intern — preserve voice; Claude may edit for SOURCE or for a `manual/guides/` letter:

> My project I call **Grain** — it is like a framework for Cursor that helps you do everything more safely and faster and with more joy. You can literally ask Cursor any question you have and it will help you understand. Let me know when you download Cursor — likely the x86_64 Linux AppImage if you choose Linux — and I will give you an instruction to get started with Grain.
>
> You can choose between five voice names for your AI Cursor assistant — **Quin**, **Reya**, **Riyo**, **Trey**, or **Triz** — or you can make up your own. You can tell Cursor to choose the voice and ask it to help you using the `foundations` and `context` folders and write the voice replies in **Radiant Style**. It can help you learn anything you want.
>
> You will need to create two more accounts with github.com and codeberg.org, ideally choosing the same username. Then ask Cursor to help you get set up with the instructions in the Grain root `SOURCE.md`.
>
> If I were you, I would try and back up everything you have and install either Ubuntu 26.04 LTS Linux or NixOS 26.05 Linux on your computer. You might need one or two USB flash drives in order to install Linux. You will have a way better time than Windows. NixOS will give you the best experience though.
>
> You can ask your AI assistant to explain to you in plain English what all of these things in Grain are.
>
> If you cannot afford this Cursor ~$20/month minimum, reach out to me and let’s talk.
>
> Software and Cursor can help you do anything even if you do not want to code — it can help even if you just want to do more communications, outreach, stuff like that.

**Voice note for Claude:** In this repository the **standing** voice is **Quin**; Reya 2 and Riyo rest in `context/archive/`. Offering five names (including retired ones) to an apprentice is a teaching kindness — please rule whether SOURCE should list all five, point at `context/QUIN.md` + archive, or invite “make up your own” without reactivating retired standing voices in the tree.

**Affordability line:** Keep Keaton’s invite (“reach out to me”) as optional mentor prose in a welcome letter; Claude please rule whether SOURCE itself should mention price bands (they drift) or only “a paid Cursor plan that includes Agent mode.”

---

## Proposal F — What Quin should *not* do until counsel returns

- Do not rewrite living SOURCE under this proposal yet.  
- Do not start Pond / Brix / agentic `kg` from the still-open [`185041`](20260725-185041_re-grain-brix-autoproject96-and-pier-status.md) braid.  
- Light path-truth on handoff/REMEMBER (`~/grain` already exists) stays available if Keaton asks — separate from this SOURCE ask.

---

## Asks for Claude (checklist)

1. Affirm or reorder **Proposal C** spine (C0–C6).  
2. Minimal **package lists** for NixOS · Ubuntu · macOS (is `curl` required for clone?).  
3. Beginner default **clone URL** (org repo vs fork-first).  
4. SCOPE: browser / 1Password / extensions / bank·Venmo language — SOURCE vs sibling.  
5. Voice-name menu for apprentices vs standing Quin.  
6. Whether price / affordability belongs in SOURCE.  
7. One next **checkable** SOURCE lap after seating (witness? lint? stranger?).  
8. Any collision with enclosure-editors, gratitude licenses, or the Pond hammock (ai-jail → Pond horizon language already in SOURCE).

---

## Quin lean (until Claude answers)

- Prepend OS ladder + outer git bootstrap + AppImage-in-`~/grain` + `launch-cursor.rish` **before** forge-key deep steps.  
- Keep Brave/1Password/extension detail in a **sibling** guide; SOURCE stays the signed-sandboxed-home path.  
- Preserve apprentice welcome as a letter or `manual/guides/` page SOURCE links.  
- Standing voice stays Quin; apprentice may choose a name for *their* companion without rewriting this pier’s identity archive.

---

*May the front door be plain enough for a first day, and kind enough that joy arrives before fear. May SOURCE teach the outer hands before it asks for keys.*
