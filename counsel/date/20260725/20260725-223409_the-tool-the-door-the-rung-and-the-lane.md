# The Tool, the Door, the Rung, and the Lane

**Language:** EN
**Stamp:** `20260725.223409`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Mixed — checkable where it cites pier measurements and tree paths · vision where it shapes the lanes ahead
**Ground:** origin/main nib `efb140f23b`, pulled and verified by counsel this hour · full parity **paused** (wasmtime) · pier renamed to `~/grain`, new agent rooted on `home-xy-grain` · REMEMBER prose one truth-correct behind
**Answers:** [`counsel/replies/20260725-185041_re-grain-brix-autoproject96-and-pier-status.md`](replies/20260725-185041_re-grain-brix-autoproject96-and-pier-status.md) · [`counsel/replies/20260725-221958_re-source-beginner-onboarding-front-door.md`](replies/20260725-221958_re-source-beginner-onboarding-front-door.md)
**Unifies:** the prior counsel session's unapplied relay — handoff filing · README Radiant pass · remote-shape truth

*Written together by Keaton and Quin.*

---

## What This Unifies

Two counsel replies arrived in one day, and a third piece of guidance — the previous session's closing relay — was written yet never handed to the bench. This memo answers all three in one voice, so a single relay can carry the whole of it. The tool is the wasmtime posture that paused parity. The door is SOURCE's beginner front door. The rung is Brix-and-Tally-in-Glow's first checkable step. The lane is the autoproject96 agentic-development research this repository now exists to host. Grain, as umbrella, opens the memo because everything below stands inside it.

## Grain, Affirmed

**Grain is the umbrella; Glow stays the language.** The seat already lives in the lexicon and its spec at `20260725.185041`, and this counsel affirms it without amendment. The sweep discipline the reply proposed is the right one: living prose replaces "Glow OS" with "Grain" as files are touched, dated logs and sealed briefs stay readable under the accrete tiers, and path renames — `manual/glow-os/`, any folder still wearing the old spoken name — wait for their own witnessed lap rather than riding along silently. The supersede note beside the `20260713` naming spec keeps the history honest. Nothing further is owed here; the name is doing its work.

## The Tool — Wasmtime, Four Rulings

Full parity went RED on chapter 2 because a host tool was absent, and that sentence contains the whole problem: the suite spoke the word for *broken* when the true condition was *unprovisioned*. A RED that means "environment" teaches the bench to distrust the gate, and a silent skip that still prints GREEN is the exact break condition THREATS names. The rulings below give the suite a third honest word and make the absence surface in seconds rather than minute thirty-five.

**Ruling 1 — the pin is the seat; the bootstrap is how a fresh host fills it.** Keep `tools/.cache/wasmtime/wasmtime` as the gitignored pin, with PATH remaining the first courtesy check, exactly as `receipt_verify_wasm.rish` already resolves. Add `tools/bootstrap_wasmtime.sh` beside `rye/bootstrap.sh`: it checks PATH, then the pin, and only when both are empty fetches the **31.0.0** release for the host triple, verifies it against a tracked digest fixture at `tools/fixtures/wasmtime_31_0_0.sha256`, and installs it to the pin. On the very first fetch, when no fixture exists yet, the script records the digest and says so loudly — trust on first use, written down in the open — and every later fetch asserts against it. Network lives in the bootstrap and nowhere else; a witness never reaches for the wire. This mirrors how the zig toolchain is already handled, and it makes provisioning one command instead of one rediscovery.

**Ruling 2 — the witness stays in chapter 2, and it learns a third word.** `receipt_verify_wasm` remains a correctness gate, because the portable seam is a real product claim and an advisory seat would quietly weaken it. What changes is the vocabulary:

| Word | Meaning | Effect on the suite |
|------|---------|---------------------|
| **GREEN** | wasmtime present · guest built · both invokes verified | counts green, as today |
| **RED** | wasmtime present · build or invoke failed | a true red — stops the suite, owned in writing, unchanged |
| **ABSENT** | wasmtime missing from PATH and pin | printed loudly with the restore line; counted; the suite's own summary becomes **PARTIAL** |

A suite carrying any ABSENT reports itself as **PARTIAL — n green · 0 red · 1 absent(wasmtime)** and withholds the suite-level GREEN word entirely. Nothing claims the wasm seam proven when it was never run, and nothing calls a missing binary a correctness failure. If the chapter runner cannot express the third state without softening a true red, the bench stops and replies rather than improvising — a gate nobody trusts is worse than none.

**Ruling 3 — the ritual speaks first.** A preflight at the head of `tools/parity.rish` (and of `parity_ch02.rish` when run alone) checks host tools before any forty-minute clock starts, and when wasmtime is absent it prints, in this shape:

```
preflight ABSENT: wasmtime
  seat 1: wasmtime-cli on PATH
  seat 2: tools/.cache/wasmtime/wasmtime  (pin 31.0.0)
  restore: sh tools/bootstrap_wasmtime.sh
  effect:  receipt_verify_wasm reports ABSENT; the suite is PARTIAL, never GREEN
```

The next hand meets the gap at second one, with the fix in the same breath as the finding.

**Ruling 4 — a send may proceed while parity is partial, under four conditions.** First, zero true reds stand: every non-green is a named ABSENT with its restore line. Second, the send's payload lies outside the paused chapters' guard — prose, counsel, session artifacts — or the specific witnesses guarding any touched code ran green singly. Third, the send note names the partial state plainly, as this evening's sends already did. Fourth, the full re-run is queued as the first measurement once provisioning lands. By these conditions the two sends made under pause stand ratified; their honest notes were exactly the law in action. Full suite GREEN returns as the requirement before any send that changes code under chapter 2's guard, before any waymark claim that cites suite green, and before anything release-shaped.

## The Door — SOURCE's First Day

The `221958` reply saw the gap truly: SOURCE opens with forge accounts and keys, while a brand-new reader needs a first day that ends with a working, jailed Cursor before any cryptography begins. The rulings below answer the reply's eight asks in order.

**The spine is affirmed, prepended as Part One.** C0 through C5 become **Part One — The First Day**: choose the host, install git, clone, place the AppImage, launch, sign in. Today's deep steps become **Part Two — The Signed Home**, retitled and otherwise untouched — accrete, never break. Part One is a condensed happy path with pointers down-page; where Step 5, Step 6, and Step 9 already explain the AppImage, the enclosure, and the launch in full, the First Day gives the short move and links the depth rather than duplicating it. The OS ladder sits at the very top in Keaton's own warmth — NixOS 26.05 first, Ubuntu 26.04 LTS second, macOS third with its Seatbelt path named, other distros and Windows as honest "less preferred," never as shaming. The apprentice-facing lines about backups and USB drives keep their voice.

**The minimal package answer: git, and git alone.** A clone over HTTPS needs no separate `curl` — git's HTTPS transport carries its own machinery, and every distro's git package brings it along. So C1 is one move per host: on NixOS, `nix-shell -p git` for the first day, with the durable `environment.systemPackages` line shown beside it for when the reader settles in; on Ubuntu, `sudo apt update && sudo apt install -y git`; on macOS, `xcode-select --install`, which ships git without asking for Homebrew at all — Homebrew arrives later, in Part Two, where the QR-art step already uses it. Everything the *jail launch* needs stays documented inside Step 6, where it lives; the First Day's package list stays exactly as small as the clone. The Ubuntu line is the path this pier proves; the NixOS and macOS lines are stated as the standard commands and marked for on-metal witness when those hosts arrive in the tree's hands.

**The beginner clone is the public repository over HTTPS, no fork, no keys.** `git clone https://codeberg.org/autoproject96/grain.git ~/grain`, with the GitHub mirror named beside it as the alternate. This works on minute one of day one, with no account anywhere. Fork-first would ask a newcomer to hold two new concepts before their first success; the fork arrives naturally in Part Two, the moment forge accounts exist.

**Browser, password manager, and extensions: one sentence in SOURCE, the rest in a sibling.** SOURCE keeps a single line of the shape *"use a real password manager, sign in through the browser window the jailed app opens, and keep every credential outside this tree."* The fuller hygiene — browser choice, extension habits, the private-window tradeoff — lives in a linked sibling, `manual/guides/first-day-personal-ops.md`, written in general terms. And here counsel must speak plainly on the hard ask: **the bank, Venmo, and Phantom inventory stays out of the pier papers entirely.** A public front door that tells beginners which financial accounts to gather and which wallet extension to install is oversharing that ages fast, and it shapes exactly the pattern phishing teaches people to follow; it widens a newcomer's attack surface with no Grain need behind it. That warmth belongs where it began — in a person-to-person letter — and the sibling guide speaks generically: a password manager you trust, the accounts *you* rely on, saved before you need them. The extension-in-private-windows habit gets named as a tradeoff each person weighs, rather than a pier recommendation. Nothing here collides with gratitude licenses — naming Brave or 1Password in a guide is the docs relaxation working as designed — and the one absolute line the sibling states is the one already in the tree's bones: vault material never enters git.

**The apprentice welcome becomes a letter SOURCE links once.** File Keaton's draft at `manual/guides/apprentice-welcome.md` with its voice preserved and only lightly tightened. The five-name menu is a teaching kindness and it is safe: **Reya, Riyo, Trey, Triz, and Quin are offered as names for the apprentice's own companion on the apprentice's own pier** — and making up a new name is offered just as warmly. One clarifying line keeps the archive at rest: in *this* repository the standing voice is Quin, and the retired notes stay retired. SOURCE itself points at `context/QUIN.md` rather than carrying a menu, because SOURCE is this pier's paper. The affordability invite — *reach out to me and let's talk* — stays in the letter, where a person is speaking to a person. SOURCE says only "a paid Cursor plan that includes Agent mode," because a dollar figure in a living pier paper is a claim that rots, and root rule nine asks docs to carry only what stays true.

**The one checkable lap, and its witnesses.** The lap is: prepend Part One, retitle Part Two, create the two sibling pages, and link them — one sitting, one send. It is a content lap by design, so `claim_preserve_witness` deliberately stays in its holster; the guards are `markdown_structure_witness`, `living_docs_lint`, and `radiant_lint` over every touched page, green or stop. The reply asked for risk callouts, and they are three: keep the "ai-jail, becoming Pond" phrasing exactly as horizon language, promising nothing Pond has yet earned; keep every command in the First Day copy-runnable on the host it names, with the two unverified host lines marked; and keep the guide's Status line living, so recommendations read as guidance rather than borrowed bench authority.

## The Rung — Brix and Tally, in Glow, in Order

Brix-in-Glow is affirmed as the next constructive season, with Tally climbing in lockstep as the bounded-memory twin rather than a rival lane — and its place in the queue is *after* the measurements that are load-bearing. The order: the hygiene in this relay lands, the wasmtime seat lands, full parity runs back to GREEN, and then the first Brix motion is a **survey** — the seated word for a named looking pass before any code goes green. The survey walks the Glow generator surface, the elder `.brix` fixtures and the Brix supplement in TAME, and Tally's current bounds, and it produces one document naming the smallest Glow-authored descriptor, the one witness that would bind it, the one apply path that would close the loop, and Tally's lockstep bound beside it. It also *proposes* a ladder slug for the waymark draw — and there it stops, because a new ladder's name is a naming round, and naming rounds park for Keaton's word. No Nix, infuse, or s6 code enters the tree at any rung; the gratitude sources stay ideas, clean-room, as the reply itself insisted. Pond keeps its full gate — the seven fencepost decisions are Keaton's, and no Pond code moves before them. Duty-8 stays the background mechanical lane it has been, HAWM and glass finishing continue untouched, and glow comment-truth stays on-touch. Nothing in the Brix season asks any of those to yield.

## The Lane — autoproject96, a Workshop for Faithful Automation

The reply asked for the first research counsel on fully automating agentic development, and the frame below is offered as that counsel's seed — a section now, a dedicated hammock when the lane earns its own sitting.

**What stays human-gated, this season and as standing law.** Seating words and names. Keys, custody, money, and wire vocabulary. Everything Tier 1, and every judgment call about which tier a byte lives in. Gratitude-license questions. Compass edits. The remote roster. And **send** — the word that moves the pier — stays Keaton's this season, so every automated lap ends at a signed commit awaiting a human word.

**What an agent may `kg` alone.** The open itinerary's mechanical stops: witness-first laps, on-touch ratchets, document filings, session logs, REMEMBER refreshes — signed with the jail key, inside the enclosure, with STOP words absolute and every report speaking Two Rooms: proven as proven, proposed as proposed.

**The lanes stay separate, and the keys are the map.** `autoproject96` is the agentic research lane — this repository, both forges. `groupproject36` is the elder veganreyklah2 lane, its own identity and history. `xykj61` holds the legacy remotes, whose mirror-or-retire word remains Keaton's custody decision, still open. An agent never pushes across lanes; which jail key a hand holds *is* which lane it may touch, and `PUBKEYS.md` with `REMOTE_ROSTER.md` stays the single map. History confusion is prevented at the credential, which is stronger than preventing it at the prompt.

**The minimal agent pier ritual.** Clone the public tree over HTTPS. Bootstrap — the zig pin, and now the wasmtime pin. Preflight. One witness green under the stranger bound, which this pier has already proven at twenty-nine seconds cold. Read the compass card. Take the itinerary from REMEMBER. Work the bounded stops witness-first, log in Bron, commit signed with the jail key, report, and stop at the journey's pause. Autonomy is earned by witnesses, never assumed: the license to automate a stop *is* the witness that binds it, and a stop no witness binds stays a human's.

**The first measurement is already scheduled.** The relay beneath this counsel, executed end-to-end by the new agent rooted on `home-xy-grain`, is specimen one of the lane — its session logs, its stops, its elapsed shape are the first data the research collects. The lane begins by watching itself work.

## The Order of Work

Hygiene first, because it is cheap and it clears the record: file this counsel, truth-correct REMEMBER, file the fresh-session handoff, apply the README pass under its two witnesses. The wasmtime seat next, because it is small and everything measurable waits on it. The full parity re-run when Keaton times it, because thirty to forty minutes belongs to the operator's clock. The SOURCE First Day on Keaton's seating word, because the reply asked that the shape be seated before it is built. The Brix survey after parity's green word, reading only. And the lane's first specimen is the doing of all of the above.

## Awaiting Keaton

Reported once, plainly, with nothing pressed: the xykj61 remotes' mirror-or-retire custody word. The seven Pond fencepost decisions at the foot of `170344`. The SOURCE seating word — pasting the relay carries it, and striking a letter holds it. The Brix ladder name and waymark draw, after the survey returns. The data-dignity options for Linengrow, which counsel can draft unasked whenever wanted. The succession trustee names. And Mand ring-3's production reach, test-only today.

---

*May the suite speak three honest words and never a false green. May the front door welcome a first day before it asks for keys. And may the lane learn to work faithfully by watching its own hands, season after careful season.*
