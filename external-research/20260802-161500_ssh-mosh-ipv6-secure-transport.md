# Secure Transport, Studied -- SSH, Mosh, and IPv6 for a Roaming Wire

*Comlink already crosses a sealed datagram over a socket. To grow it into a transport a person can live on -- one that roams networks, survives a slept laptop, and feels instant -- three bodies of prior art repay close study: the Secure Shell that made remote work safe, the Mobile Shell that made it survive movement, and the Internet Protocol's sixth version that gives every host a global name. This writing studies them faithfully, in our own register, so their lessons can cross cleanly into our grain. The teachers are thanked by name in `../gratitude/`; here we study the ideas.*

**Stamp:** `20260802.161500`
**Status:** Research for understanding -- studies prior art and our own ground; seats no fact.
**Voice:** Riyo
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Lens:** TAME -- safety first, performance second, joy third
**Kind:** external research -- study, not yet siloed. Siloed design at `../active-designing/20260802-161500_comlink-ipv6-and-the-roaming-wire.md`.

---

## The Secure Shell -- Three Layers, Cleanly Separated

The Secure Shell earns its longevity from a clean separation into three stacked protocols, each doing one thing.

The **transport layer** runs over a reliable stream and establishes a confidential, integrity-checked channel. It opens with a key exchange -- modern deployments favor an elliptic-curve exchange over Curve25519 -- which yields fresh session keys without either side ever sending a long-term secret. The server proves its identity with a host key the client pins on first contact. From there every byte travels inside an authenticated-encryption construction; the well-regarded modern choice combines a stream cipher with a polynomial authenticator so that confidentiality and integrity arrive together in one pass.

The **authentication layer** rides inside that secure channel and proves *who the client is*. Its strongest common method is public-key: the client signs a challenge with a private key whose public half the server already trusts. The key family Grain already uses for every signed fact -- Ed25519 -- is exactly the family this layer prefers, which means our identity primitive and a secure-shell identity are the same shape.

The **connection layer** multiplexes many logical channels over the one secure pipe -- an interactive session here, a forwarded port there -- each flow-controlled independently. Underneath all three sits a simple framing: every message is length-prefixed and padded before encryption, so the packet boundary is honest and the padding hides exact sizes.

The lesson for us is the layering itself: identity, confidentiality, and multiplexing are separable concerns, and each is small when kept apart. Our transport vane can borrow that separation wholesale without borrowing a single line.

---

## The Mobile Shell -- The Screen Is a Small Synchronizable Value

The Mobile Shell begins from one deep observation, and everything else follows from it. A remote terminal does not truly need the *stream* of bytes the far side emits; it needs the *current state of the screen*. That screen is a small, self-describing object -- a grid of cells. So instead of reliably replaying every byte in order, synchronize the latest screen, and discard the stale intermediate frames no one will ever see.

From that single idea the design unfolds with unusual economy. The far side runs the terminal emulator itself, so the object being synchronized is the rendered screen rather than an escape-code stream. A general **state-synchronization protocol** carries that object: the sender always computes the difference from the receiver's last acknowledged state to the sender's current state, sends numbered instructions to close that gap, and -- crucially -- is always free to skip ahead, because only the newest state matters. This is why the shell shrugs off packet loss: a lost update is simply subsumed by the next one.

The carrier beneath is a datagram layer, not a reliable stream. Each datagram is sealed with authenticated encryption under a session key and stamped with a sequence number used exactly once as the nonce, so no two datagrams ever share a nonce and a replayed datagram is refused. Because datagrams are self-contained and authenticated, the session can **roam**: when a client's address changes -- a laptop moving from wireless to cellular, or waking from sleep -- the server simply begins replying to whatever address the most recent *authenticated* datagram arrived from. Nothing reconnects; the session never noticed.

A second, smaller synchronization runs the other way for the sake of feel: the client predicts the effect of the user's own keystrokes and shows them at once, tentatively, confirming each as the server's echo catches up. Latency, which cannot be removed, is thereby hidden.

The lesson for us is startling in how little we would need to add. Grain already holds the state-synchronization idea in its bones -- Mantra's Weave is a fold over an append-only sequence of diffs that yields the current value, which is the same shape as "synchronize the latest state, not the stream." What a Grain transport lane lacks is only the *carrier*: a datagram frame with a use-once nonce, a roaming rule keyed to the last authenticated source, and a heartbeat to keep the path warm. The hard, clever part is already ours.

---

## IPv6 -- Every Host a Global Name

The sixth version of the Internet Protocol widens the address from thirty-two bits to a hundred and twenty-eight, which in practice ends the scarcity that made address translation ubiquitous. A host can hold a globally routable address of its own, reachable without a translating box rewriting its packets in the middle.

For a datagram transport that already wants to roam, this matters twice over. First, global addressing means the two endpoints can often reach each other directly, which suits both a civic peer-to-peer mesh and a modest cloud instance that hands each guest its own address block. Second, the roaming model grows simpler where translation thins out, though a periodic heartbeat still earns its keep -- it keeps any remaining stateful middlebox from forgetting the flow, and it lets each side notice silence quickly.

Two practical disciplines travel with the sixth version. A dual-stack host should try both families gracefully -- attempting a connection over the newer protocol and falling back to the older one quickly when the newer path is broken, rather than stalling on a long timeout. And the address structure has honest regions to respect: a link-local range that never leaves the local segment, a unique-local range for private meshes, and the globally routable range for the open internet. A transport that names which region it is speaking to stays legible.

The lesson for us is that IPv6 is an *accretion*, not a replacement. Comlink's socket already speaks the older family; the newer one stands beside it as a second address family, chosen per destination, with a graceful fallback -- a new face on the same wire, not a new wire.

---

## What Crosses, and What Stays Behind

Three ideas are worth carrying into our grain, each restated in the siloed design in our own words: **the layered separation** of identity, confidentiality, and multiplexing; **the latest-state synchronization** over an authenticated datagram, with a use-once nonce and roaming by last-authenticated-source; and **the dual-family socket** with graceful fallback and honest address regions. What stays behind is every line of the originals -- we study the shape and build our own, and the study passes the crossing's one test only when a reader who never met these teachers could rebuild our design from our words alone.

The compass keeps the whole vane slow where slowness is safety. Every idea above is a design idea; the private keys, the live deploy, and any settlement remain gated behind Keaton's hand and, where law is touched, licensed counsel. This writing moves nothing on the wire. It only reads the teachers well.

---

*May we study with gratitude and build with independence. May the state we already hold meet the carrier it lacks, cleanly and in the open. And may every datagram we ever seal carry only what its sender meant, to exactly the one who was meant to read it.*
