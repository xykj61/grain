# 971 · Editors, Remoting, and the TAME Rye OS — Neovim, Kakoune, SSH, Mosh, and What We Build

*The editor is where a person lives inside the system. The remote shell is how they reach it from afar. This research reads four projects — Neovim, Kakoune, SSH, and Mosh — and asks what TAME-aligned versions look like when the editor runs inside Skate, the configuration lives in Brix, and the remote connection speaks Comlink.*

**Language:** EN
**Version:** `20260620.010712` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## The Question of the Editor

A text editor for the TAME Rye OS must answer three questions:

1. **How does it edit?** Modal editing (Vim's verb-object grammar, Kakoune's select-then-act) is the most efficient model for a keyboard-first system. The question is which model, and whether we need a new DSL to configure it.
2. **How is it configured?** Neovim uses Lua; Kakoune uses KakouneScript; Vim uses VimL. Each is a separate language a person must learn. The TAME question: can we use what we already have — Brix for declarations, Rishi for behavior — rather than introducing another language?
3. **How does it compose with the system?** Kakoune's headless architecture delegates windows to the terminal multiplexer and scripting to the shell. This is the most TAME-aligned: the editor is about one thing (editing text), and everything else is composed from outside.

---

## Neovim — The Extensible Refactoring

Neovim is Vim refactored for extensibility. Plugins can be written in any language; Lua is the first-class configuration language; the architecture separates the core from the UI.

**What Neovim teaches (TAME-aligned):**

- **Separation of core and UI.** Neovim's core is a headless process; the UI connects through a protocol (msgpack-rpc). This is the same separation Brushstroke keeps: rendering in one process, editing logic in another.
- **Lua as configuration language.** Replacing VimL with a general-purpose language was the right move — it reduced the number of languages a person must learn. The TAME lesson: use what you already have.

**What to decline:**

- **Lua is still a separate language.** In the TAME Rye OS, the configuration language is Rishi (for behavior) and Brix (for declarations). No third language.
- **Unbounded plugin ecosystem.** Neovim's plugin architecture is powerful yet introduces unbounded complexity. TAME favors a small, stated set of capabilities, grown by accretion.

---

## Kakoune — The UNIX Editor

Kakoune is the most TAME-aligned editor in the field. Its design philosophy: do one thing well (text editing) and interface with other CLI tools for everything else. Multiple selections replace macros with a structural operation. The editor is headless — detached from the UI, composable with any terminal.

**What Kakoune teaches (TAME-aligned):**

- **Select, then act.** Kakoune inverts Vim's verb-object grammar: first select the text, see what is selected, then act on it. This is safer — the person sees what will change before it changes. TAME's first value (safety) applies to editing too.
- **The editor is just the editor.** Kakoune delegates window management to the terminal multiplexer, file browsing to the shell, version control to the VCS. Each tool is about one thing. This is `995` (single-stranded) applied to the editor.
- **Structural editing through multiple selections.** Rather than running a command and hoping it did the right thing, the person selects all occurrences, sees them highlighted, and acts. The feedback is immediate and honest.

**What to decline:**

- **KakouneScript.** Another DSL. In our system, editor configuration is Brix (what the editor is) and Rishi (what it does).

---

## The TAME Editor — What It Looks Like

Our editor runs inside **Skate** (the terminal surface) and is configured through **Brix** (declarations) and **Rishi** (behavior). It has no scripting language of its own.

### Modal Editing in Rye

The editor is a Rye module — a library that Skate calls. It follows Kakoune's select-then-act model: the person first selects (visually, with feedback), then acts. The core operations are:

- **Select** — by character, word, line, paragraph, regex, or structural pattern
- **Act** — delete, change, yank, paste, indent, comment
- **Multiple selections** — all occurrences selected at once, acted on together

The editing commands are values — the same value model that flows through every module. A keybinding maps a key sequence to an editing command; the command is a value; the editor applies it.

### Configuration Through Brix

Editor settings are Brix declarations — plain key-value, one field per line:

```brix
# editor.brix — editor configuration
tab-width 4
indent-style spaces
line-numbers true
wrap-mode soft
theme rye-dark
```

No Lua, no VimL, no KakouneScript. The editor reads the `.brix` file at startup. A person who knows Brix already knows how to configure the editor.

### Behavior Through Rishi

Custom editing behavior — macros, formatters, linters — is written in Rishi:

```rish
# format-on-save.rish — run the formatter before writing
let result = run ["rye" "fmt" current-file]
assert result.ok else "formatter failed"
```

The editor calls Rishi scripts at stated extension points (on-save, on-open, on-keystroke). Each script runs inside a Pond enclosure — bounded, isolated, policy-as-a-value. A misbehaving plugin cannot corrupt the editor or the system.

### No DSL Proliferation

The TAME Rye OS has three languages for configuration:

| Language | Purpose | Example |
|----------|---------|---------|
| **Brix** | Declare what exists (settings, descriptors, compositions) | `tab-width 4` |
| **Rishi** | Express behavior (scripts, macros, automation) | `run ["rye" "fmt" file]` |
| **Rye** | Build everything (the editor itself, the compositor, the kernel) | The source |

No `.vim`, no `.lua`, no KakouneScript. Three languages serve the whole system.

---

## SSH and Mosh — The Remote Shell Question

### SSH — The Established Protocol

SSH (Secure Shell) is the established protocol for remote access. It runs over TCP, provides encrypted channels, and multiplexes sessions.

**TAME alignment:**

- **Encryption is structural.** SSH encrypts everything by default — the channel is never unprotected. This aligns with TAME's safety-first value.
- **Authentication through keys.** SSH's public-key authentication is the same owner-key model we use throughout.

**What SSH does that is not TAME-aligned:**

- **TCP head-of-line blocking.** SSH runs over TCP, so a lost packet blocks all subsequent data until it is retransmitted. On a mobile or lossy connection, this makes the session feel frozen. TAME's performance value suffers.
- **No state synchronization.** SSH sends a byte stream; if the connection drops, the session is lost. Reconnection requires starting over.
- **The protocol is large and accumulated.** SSH has grown many features (port forwarding, X11 forwarding, SOCKS proxying) that are rarely used and expand the attack surface.

### Mosh — The State-Synchronized Shell

Mosh (Mobile Shell) replaces SSH's byte stream with a **State Synchronization Protocol (SSP)** over UDP. Instead of streaming bytes, Mosh synchronizes the terminal state: the server holds the current screen contents, and the client holds a prediction. Updates are sent as state diffs, not byte sequences.

**What Mosh teaches (TAME-aligned):**

- **State synchronization over byte streaming.** The server and client share a value (the terminal state) and synchronize it. This is the same model as Mantra's weave: two sides converge to the same state. The protocol is about values, not pipes — exactly what Hickey taught.
- **UDP removes head-of-line blocking.** Each datagram is independent; a lost packet does not block the next. The client predicts locally and corrects when the server's state arrives. Performance on lossy connections is dramatically better.
- **Roaming.** Because Mosh uses UDP and the client can reconnect from any IP address, the session survives network changes (WiFi to cellular, VPN reconnect). The session is named by a key, not by a TCP connection.
- **Control-C always works.** Mosh does not fill network buffers, so a runaway process can always be interrupted. Safety.

**What Mosh does that is not TAME-aligned:**

- **Initial connection through SSH.** Mosh uses SSH to bootstrap the session (exchange the AES key and port), then drops the SSH connection. The dependency on SSH for setup is practical yet not minimal.
- **AES-128 in OCB3 mode.** Our crypto foundation uses ChaCha20-Poly1305 and Ed25519. A TAME Comlink-based remote shell would use our own crypto stack, not AES-OCB.

---

## Comlink Remoting — The TAME Remote Shell

A TAME remote shell speaks **Comlink** — the bounded network that carries values between identities. The protocol is:

1. **Connection setup** through owner keys — the client and server authenticate via Ed25519, agree on a shared secret via X25519, and seal the session with ChaCha20-Poly1305. No SSH dependency.
2. **State synchronization** over UDP — like Mosh's SSP, yet the state is a Rishi value (the terminal's content as a structured record), not a raw screen buffer. The value flows through the same one-value model.
3. **Roaming** — the session is named by the key pair, not by a network address. The client can reconnect from any IP.
4. **Bounded messages** — every datagram has a stated maximum size. No unbounded buffers.
5. **Pond enclosure** — the remote shell runs inside a Pond enclosure on the server. The policy names what the remote session may access. The same isolation that protects local applications protects remote ones.

This is Mosh's insight — state synchronization over UDP — carried through our own crypto, our own protocol, and our own enclosure model.

---

## What Is TAME-Aligned and What Is Not

| Protocol | TAME-aligned | Not TAME-aligned |
|----------|-------------|-----------------|
| **SSH** | Encryption by default; key authentication | TCP blocking; byte stream; large surface |
| **Mosh** | State sync; UDP; roaming; Control-C works | SSH bootstrap; AES-OCB; raw screen state |
| **Comlink remoting** | Our own crypto; value-based state sync; Pond enclosure; bounded messages | Not yet built |

Both SSH and Mosh are usable as stand-ins. The TAME path is Comlink remoting — our own protocol, our own crypto, our own values. SSH and Mosh inform the design; Comlink carries it forward.

---

## Sources

- Mosh: mosh.org. State Synchronization Protocol over UDP. GPLv3.
- SSH: OpenSSH. The established remote shell. BSD license.
- Kakoune: kakoune.org. UNIX-philosophy modal editor. Unlicense.
- Neovim: neovim.io. Extensible Vim refactoring. Apache 2.0 + Vim license.

All read for concepts. The design decisions are our own.

---

*May the editor we build need no language of its own — only Brix for what it is and Rishi for what it does. May the remote shell carry values rather than bytes, synchronize state rather than stream, and roam without losing the thread. May three languages serve the whole system, and may the hand that types never need to learn a fourth.*
