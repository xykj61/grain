# Sandboxing and Getting Set Up

**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Audience:** an Acme Corporation employee setting up a safe place to work on this template — beginner-welcome, developer-precise
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)
**Status:** Setup guide — describes the general, provider-neutral shape that runs today; the containment tool and any credentials live in your own environment, never in the tree. No accounts, no keys, no vendor secrets committed here.

---

Welcome. Before you write a line for this template, it is worth setting up a place to work that is **safe by construction** — a place where a mistake, a runaway command, or a fast coding agent can do its work without reaching anything of yours it has no business touching. This guide walks that setup in the order that keeps you safest: first the sandbox that fences the work, then the key discipline that keeps your secrets in your own hands, then the ordinary accounts a newcomer creates to contribute.

Read it once end to end before you start. Every step here is something you do in your own environment; nothing you set up is ever written into this shared tree. That separation — **the work lives in the template, your secrets live in you** — is the whole spirit of the page, and of the system it belongs to.

The order matters, so hold it plainly: **safety first.** A sandbox is not a finishing touch you add once things work; it is the ground you stand on before you begin. Set it up first, prove it holds, and only then bring in a key or an agent.

---

## 1. Why a sandbox comes first

Modern software is written fast — often with a coding agent doing much of the typing, running builds and commands in a loop on your behalf (see [`ides-agents-and-the-api.md`](20260810-065116_ides-agents-and-the-api.md) for that pattern in full). That speed is a gift, and it is exactly why the ground under it must be firm. An agent is a tireless pair of hands; a sandbox is the room those hands work in, with the door to the rest of your machine closed.

A **sandbox** here means one plain thing: a contained place where the work you do — and any tool or agent you let loose on it — can **read and write the project freely, and almost nothing else.** Writes outside the project are refused by the operating system itself, not by a convention or a reminder you might forget. Your other files, your other projects, and above all your secrets sit outside that room, untouched.

The particular shape this template is built around is an **ai-jail-style container**: a lightweight enclosure that

- **keeps the project tree durable** — your clone, its git history, its build cache all persist across sessions, exactly as you left them; and
- **resets the host home on exit** — the container's view of your home directory, `/tmp`, and the paths around them is fresh each session and thrown away when you leave, so nothing an agent scattered outside the project survives the sitting.

Hold those two facts together and the trade becomes clear: **the project persists; the surroundings are disposable.** Anything worth keeping lives inside your clone, where it endures. Anything a tool leaves lying around outside the clone vanishes when the container exits. That single rule — *keep it in the project or lose it* — is what makes a fast, autonomous tool safe to run: the blast radius of any mistake is bounded to a room you can rebuild in seconds.

> **A note on where you run.** This guide describes the *shape* of a safe container rather than pinning one product. On Linux, the enclosure is built from the kernel's own containment — user namespaces, bind mounts, a filesystem-access policy — so a write outside the fence is denied by the kernel, not by a linter. On macOS, the same discipline is expressed through the platform's application-sandbox facility. This template ships a macOS setup guide for exactly this at [`guides/macos-ai-jail-setup.md`](guides/macos-ai-jail-setup.md), witnessed on real hardware with a live write-fence probe. Whichever platform you are on, the promise you are setting up is identical: **writes fenced to the project, the host home reset on exit.**

### What a good sandbox fences, and what it deliberately does not

A sandbox earns its keep by being honest about its own edges. The shape this template favors makes three boundaries plain:

| Boundary | The safe default | Why it is drawn here |
|----------|------------------|----------------------|
| **Writes** | Fenced to the project directory (plus the usual temporary paths) | This is the real wall. A write anywhere else is refused by the operating system. |
| **The home directory** | Reset on exit; optionally made private *during* the session | Nothing an agent leaves outside the project survives, and your real home files can be kept out of view entirely. |
| **Reads and network** | Open by default, closeable when you have no reason to reach out | Named trade-offs, not oversights — see below. |

The write fence is the boundary that matters most, and it is the one the operating system enforces absolutely. Reads staying open and the network staying reachable are **deliberate, named trade-offs**, because enumerating every path a whole toolchain legitimately reads is a maintenance trap no honest tool takes on. Two safeguards keep those open doors from becoming a leak:

- **You can close them when you have no reason to keep them open.** A review pass that never needs the internet can run with the network denied outright. A session that has no business reading your real home can run with the home directory made private for its whole length.
- **Your secrets never sit inside the fence to begin with.** This is the heart of the next section: because a real key is filled by your own hand and lives outside the tree, an agent working *inside* the fence has nothing sensitive to read even while reads stay open. The custody discipline and the sandbox are two halves of one safety story.

### Prove the fence before you trust it

A sandbox you *believe* holds is worth less than one you have *watched* hold. This template's whole culture is that a claim is proven on metal, not asserted in prose — and a fence is a claim like any other. Before you do real work in a new container, prove the wall with your own eyes: attempt one write **inside** the project (it succeeds) and one write **outside** it, into your real home (it is refused). Two outcomes, both visible, both enforced by the operating system rather than simulated. The macOS guide above ships a witness that does exactly this pair; on any platform, the habit is the same — *see the wall hold before you lean on it.*

---

## 2. Custody-first keys — filled by your own hand, never committed

Here is the single most important discipline on this page, and the one a public template must be most careful about: **a real key is never written into this tree.** Not a signing key, not an identity seed, not a share of a secret, not a credential to reach a service — nothing that is genuinely yours ever enters a file that is committed and shared.

This is not merely good manners. **A key in a public template is a leaked key** — the moment it is committed, anyone who ever clones the template holds it. So the rule is absolute and structural, and the system is built to make honoring it the natural path.

### The shape the tree already keeps

You do not have to invent this discipline; the template already lives it, and its **`vault`** module is the worked example to study. Vault is the keeper of secrets — it holds the *arithmetic* of keeping a secret alive through fire, flood, a lost device, and a forgetting decade, by splitting it Shamir-style so that any few pieces recombine it and any fewer reveal nothing. And it does all of that while carrying **no real secret at all.**

Read how it draws the line, from the module's own words:

- **Only a fake seed lives in the tree.** Vault's self-test and every record it emits run on a plainly fake key — a seed of repeated `0x11` bytes — so no real secret is ever demonstrated, checked in, or invented. The disaster arithmetic is proven completely, on a value that is safe to publish because it protects nothing.
- **A real keeping is filled by your own hand, in your own jail.** The module states it directly: a real key, share, or phrase never enters the tree; a real keeping is filled by hand, inside the very kind of sandbox Section 1 set up. The fake seed is what ships; the real value is something only you ever place, in your own contained room, and never commit.
- **Build nothing that destroys; place no key to lose.** The module's closing discipline is the one to carry into all of your own work here. The safest key is one the shared tree was never able to lose, because it was never given it.

You can watch this hold for yourself. The module builds and proves green while touching nothing real:

```bash
rye build vault/shard.rye -femit-bin=vault/bin/shard
vault/bin/shard selftest    # the disaster arithmetic, on a fake key
rishi/bin/rishi run tools/vault_shard_witness.rish
```

The green line proves the keeping-arithmetic works — and proves, just as importantly, that it works **without a real secret anywhere in sight.** That is the pattern to imitate every time your own work meets a key: prove the mechanism on a fake value that is safe to share, and let the real value live only in your own hand.

### The rule, stated once and plainly

For any secret at all — a signing key, an identity seed, a service credential, a share of a keeping — hold this shape:

1. **Fill it by your own hand, inside your own sandbox.** The contained room from Section 1 is exactly where a real key belongs while you work: reads open, but nothing sensitive committed, and the host home reset on exit so no stray copy lingers.
2. **Keep it in a path the tree ignores, or outside the tree entirely.** A real key belongs in a gitignored location or an environment variable your tools already read — never in a tracked file. When in doubt, the template's own `.gitignore` names the safe local paths; add nothing tracked that carries a secret.
3. **Never demonstrate a real key.** When you need to show that some key-shaped mechanism works — in a witness, an example, a test — use a fake value the way `vault` uses its `0x11` seed. A demonstration protects nothing precisely so it is safe to publish.
4. **Prefer keys that are scoped and revocable.** When a task needs a credential to reach a service, reach for the narrowest one that does the job and can be revoked the moment the work is done, rather than a broad, long-lived one. A dedicated, single-purpose key that a mistake could only spend narrowly is worth far more than a powerful key kept carefully.

That is the whole of it: **the mechanism ships; the secret does not.** Set up this way, even a compromised sandbox or a careless commit exposes nothing that matters, because nothing that matters was ever inside the tree to expose.

---

## 3. The accounts a newcomer creates to contribute

With a safe room to work in and a clear rule for your secrets, the last piece of setup is the handful of ordinary accounts and keys a contributor creates. These are described generically on purpose — bring whichever providers you prefer; the template names none and needs none.

You will set up three things, in this order:

### A code-forge account

To share your work and open contributions, you create an account on a **git forge** — a hosting service for git repositories. This is where your clone of the template pushes to, where you open a contribution for review, and where your public key is registered so others can verify your commits. Any mainstream forge works; the template is a plain git repository and cares only that it can be pushed and pulled. Create the account, and you have a home on the network for your copy of the work.

### A signing key

This template's culture is that **every commit is signed**, so a reader can prove who wrote each change rather than trust a name typed into a field. So you create a **commit-signing key** — a cryptographic keypair whose private half stays with you and whose public half you register with your forge account. Once it is set up, your git tooling signs each commit automatically, and the forge shows your commits as verified.

Two disciplines from Section 2 apply here in full, because a signing key *is* one of the secrets that page governs:

- **The private half is filled and held by your own hand** — generated in your own environment, kept in a path the tree ignores, never committed. The template holds no signing key and never will.
- **A dedicated, revocable key is the safer choice.** A signing key scoped to this work, one you can revoke without disturbing the rest of your life, honors the custody-first spirit better than reaching for a broad, long-lived identity you use everywhere.

You register only the *public* half with your forge — that is what lets others verify your signatures — while the private half stays in your own hands, exactly like every other secret here.

### An access credential for pushing (scoped and revocable)

Finally, to let your git tooling and any command-line forge tool actually push and open contributions, you create an **access credential** — an SSH key registered with your forge, or a scoped access token, depending on how your forge and tools prefer to authenticate. Here the "scoped and revocable" rule from Section 2 earns its keep most concretely: create the **narrowest** credential that does the job — ideally one limited to just the repositories you are working on, with only the permissions the task needs — and revoke it when you are done. A single-repository, revocable credential means a mistake can reach only that one place; a broad account-wide credential means a mistake can reach everything.

Store this credential the way Section 2 requires: in an environment variable your tools read, or a gitignored local file — **never** in a tracked file in the tree. If you generate an SSH key for this, its private half follows the same custody rule as your signing key: filled by your own hand, held outside the tree, registered with the forge only in its public half.

> **A quiet, deliberate choice.** When you set up a sandbox that a coding agent will later work in, it is worth generating these keys *yourself, from outside that sandbox*, rather than having the agent that will use them also mint them. A "dedicated, revocable" key means more when the hand that created it is your own. This is the same care the macOS setup guide names for its own jail-local keys.

---

## 4. A short checklist, in the safe order

Here is the whole setup as a sequence you can follow top to bottom. Each step is safe to do before the next, and none of them writes a secret into the tree.

1. **Clone the template** and change into it.
   ```bash
   git clone https://github.com/grain-os/grain
   cd grain
   ```
2. **Set up your sandbox** for this project — the ai-jail-style container that fences writes to the project and resets the host home on exit. On macOS, follow [`guides/macos-ai-jail-setup.md`](guides/macos-ai-jail-setup.md); on Linux, use the kernel-containment enclosure your setup provides. Configure it so the project directory is durable and the surrounding home is disposable.
3. **Prove the fence.** Attempt one write inside the project (it succeeds) and one write into your real home (it is refused). See the wall hold before you trust it.
4. **Create your forge account**, so your work has a home on the network.
5. **Generate your signing key** by your own hand, keep the private half outside the tree, and register the public half with your forge.
6. **Create a scoped, revocable access credential** for pushing — the narrowest that does the job — stored in your environment or a gitignored path, never in a tracked file.
7. **Confirm your secrets are outside the tree.** A quick `git status` should show nothing sensitive staged, and every key path you created should be one the tree ignores. When in doubt, keep it out.
8. **Prove the whole setup works** by running a witness against the shipped tools — for example `rishi/bin/rishi run tools/scribe_reader_witness.rish` — and, if you built `vault` while reading Section 2, its green line too. A green line is the system proving itself on your own metal, inside the safe room you just built.

When those eight steps are done, you have exactly what this page set out to give you: a contained place to work, a clear and absolute discipline that keeps your secrets in your own hands, and the ordinary accounts a contributor needs — all arranged so that the work lives in the template and everything that is genuinely yours lives in you.

---

## Where to look next

- **[`ides-agents-and-the-api.md`](20260810-065116_ides-agents-and-the-api.md)** — how an editor, a coding agent, and a model cooperate on this tree, and why the witness keeps that loop safe. Read this next if an agent will do some of your typing.
- **[`20260810-065116_your-first-hour-with-grain.md`](20260810-065116_your-first-hour-with-grain.md)** — clone, build, and prove your first module by hand, so you know the loop your safe room is protecting.
- **[`20260810-065116_the-developer-guide.md`](20260810-065116_the-developer-guide.md)** — the four languages, the one discipline, and the build-and-witness rhythm every contribution follows.
- **[`guides/macos-ai-jail-setup.md`](guides/macos-ai-jail-setup.md)** — the macOS application-sandbox enclosure in full, witnessed on real hardware with a live write-fence probe.
- **[`../vault/README.md`](../vault/README.md)** — the keeper of secrets: how the tree proves a keeping-mechanism on a fake key while holding no real secret at all. The worked example behind Section 2.
- **[`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md)** — the full engineering discipline this template keeps, safety first.

---

*May your room hold exactly where it says it holds, may every real key stay in your own hand, and may nothing that is truly yours ever travel to a place you cannot reach. Safety first; build nothing that destroys; place no key to lose.*
