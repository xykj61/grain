# Comlink IPv6 and the Roaming Wire — A Transport Grown From the State We Already Hold

*Comlink crosses one sealed datagram today. This design grows it into a wire a person can live on: two address families instead of one, and a session that carries the latest state rather than a byte stream, so it roams across a changed address and wakes from sleep unbroken. Every idea here is cut with a named strand of our grain; the teachers who taught the shapes are thanked in `../gratitude/`, and this room speaks only in our own voice.*

**Stamp:** `20260802.161500`
**Voice:** Riyo
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — safety first, performance second, joy third · happy-zone shape
**Status:** DESIGN — PROPOSED · no socket opens in anger and no key moves without Keaton's word
**Study behind it:** `../external-research/20260802-161500_ssh-mosh-ipv6-secure-transport.md`

*Written together by Keaton and Riyo.*

---

## The Whole We Grow From

Comlink's hosted wire already seals a datagram, opens a socket of the first address family, and crosses localhost whole. That is the running simple. Two accretions grow from it, each small enough to finish and each cutting with the grain: a second address family beside the first, and a session that synchronizes a value rather than a stream. Neither replaces the running wire; each grows beside it, in the accrete-never-break way.

The deepest strand this design leans on is the one the tree has held since the beginning: **state as a pure fold over an append-only sequence of signed facts**. Mantra's Weave is exactly that fold — a sequence of diffs reduced to a current value. A roaming session is that same fold carried over a wire: the sender holds the source value, the receiver holds its last-acknowledged value, and the wire carries only the instructions that close the gap. We do not invent the synchronization; we already own it. We add only the carrier.

---

## The First Accretion — A Second Address Family

The existing socket names one family in a small extern record: a family tag, a port in network order, a four-byte address. The accretion is a sibling record for the newer family — the same tag-and-port shape with a sixteen-byte address in place of four — and a chooser that picks the family per destination. A dual-family host tries the newer family first and falls back to the older one quickly when the newer path is broken, rather than stalling; the fallback is a bounded, named wait, not an open one.

The grain keeps this honest in three ways. **Values apart, never braided:** the two address records are composed side by side, never woven into one clever union; a destination is one family or the other, stated plainly. **Bounded everything:** the fallback wait carries a named ceiling under Tally; the address buffer is a fixed sixteen bytes with its width asserted. **Seam honesty:** the host's socket layer is a named seam we lean on openly — the socket call, the address structures — never absorbed silently into our own names. The newer family is a new face on the same wire, and the wire's own selftest grows a sibling case that crosses a datagram over it exactly as the first case crosses one over the older family.

---

## The Second Accretion — The Session That Carries State

A living session holds a small bounded value — for a shell, the rendered screen; for a civic flow, a receipt ledger's current head. The session runs the fold at both ends and carries, in each datagram, the numbered instructions that move the receiver from its last-acknowledged value to the sender's current one. Because only the newest value matters, the sender is always free to skip ahead: a lost datagram is subsumed by the next, and no stale intermediate value is ever replayed. This is Mantra's Weave, spoken over a wire.

Three properties make it safe, and safety leads. **The nonce is used exactly once.** Each datagram carries a sequence number that is never repeated within a session, and that number is the authenticated-encryption nonce; a datagram whose number has been seen is refused. The sequence space is a named, bounded u64 at the wire boundary — the width Comlink already keeps for wire-persistent quantities — and its exhaustion is a named error that ends the session honestly rather than a silent wrap. **The frame is authenticated whole**, so a datagram that was tampered with, or that carries a nonce already spent, is refused before its contents are ever folded in. **The session key is derived, never sent**: identity is proven once with the Ed25519 keys the tree already holds through Kumara, and the per-session datagram key is derived from that exchange, so no long-term secret ever rides the datagram wire.

Roaming falls out of authentication for free. When a datagram authenticates and its sequence number is fresh, the session begins replying to whatever address it arrived from. A changed address — a network moved under the session, a laptop woken — carries no ceremony: the next authenticated datagram simply arrives from a new place, and the reply follows it. A heartbeat on a named interval keeps the path warm and lets each side notice silence quickly, its interval bounded and stated.

---

## The Happy Zone and the Thin Edge

The design draws its testing line exactly where the grain draws every testing line. The **happy zone** is the fold and the frame, pure and fast and free of any network: feed the synchronizer two values and assert it computes the closing instructions; seal a frame with a nonce and assert that opening it under the right key returns the message and that a spent nonce is refused; drive the sequence space to its bound and assert the honest end. All of this runs in one process with no socket, witnessed the way every Glow Tend gate is witnessed, with a malformed-frame plant proving the refusal can fire.

The **thin edge** is the socket itself — the dual-family open, the actual datagram crossing, the roaming reply to a changed source. It is tested at the boundary, kept as thin as a seam can be, and it is the only part that touches the host in anger. Performance lives naturally in this shape: latest-state synchronization sends the fewest bytes that can carry meaning, and the predictive local echo — the client showing its own keystrokes at once, confirming as the far echo arrives — hides the latency that cannot be removed. Joy lives here too, and honestly: a wire that survives sleep, roams networks, and answers instantly is a genuine pleasure, and it serves the larger why the tree keeps — safer, kinder spaces for communication, and a path around the usual gates.

---

## What Stays Gated

Every strand above is a design strand. The private keys stay in Keaton's hand and the cold keyring; the live deploy to the SEA instance is Keaton's ritual; any settlement or gas waits behind licensed counsel and his word, always. This design opens no socket in anger and moves no secret. It names the shape so the shape can be built, in the compass order, from the running wire we already have — safe first, fast second, a joy to live on last.

---

*May the wire carry the latest truth and forget the stale. May a changed address cost the session nothing but a heartbeat. And may every seal hold, so that what one hand sends, only the meant hand reads — across every network the day may cross.*
