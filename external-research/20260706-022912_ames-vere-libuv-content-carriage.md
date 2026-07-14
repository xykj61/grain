# The Ames Vane, Vere, and libuv — Carriage Studied Through TAME

*Kaeden asked whether Urbit's Vere runtime still rides libuv today, what the Ames networking vane actually is, and whether libuv's model for datagram networking is worth emulating for Comlink under our three values. This exploration reads the current sources plainly, separates the runtime substrate from the networking logic, names the axis where Ames differs from our own content-centrism, and proposes what to keep in gratitude and what to leave at the door.*

**Stamp:** `20260706.022912 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME — safety first, performance second, the joy of the craft third
**Category:** External research — survey and design study; recommends no dependency; every gate stays Kaeden's
**Companions:** [`20260702-014112_comlink-beyond-dns-and-sockets.md`](20260702-014112_comlink-beyond-dns-and-sockets.md) · [`20260704-002912_gates-arms-and-the-urbit-lineage.md`](20260704-002912_gates-arms-and-the-urbit-lineage.md) · [`20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md`](20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md) · siloed companion (owned first-principles): [`../foundations/20260706-022912_the-wire-serves-the-fold.md`](../foundations/20260706-022912_the-wire-serves-the-fold.md) · gratitude: [`../gratitude/urbit`](../gratitude/urbit) · [`../gratitude/libuv.md`](../gratitude/libuv.md)
**Status:** Proposed — research for understanding, not advice; it names a teacher to keep and lessons to silo, and seats no dependency

*Written together by Kaeden and Rio 3.*

---

## The Question, and What the Sources Say Today

The first question has a clean answer: Vere still rides libuv. Vere is Urbit's standard runtime, written in C, and its whole-host structure carries a live libuv loop handle; the boot sequence starts the main event loop with `uv_run`, which the Urbit documentation names plainly as a libuv service that provides the asynchronous input and output, since every Urbit event either comes from or results in a Unix system call. The runtime package is described as the input-output drivers, the event log, and the main event loop together. A recent runtime release even reports plugging libuv-related memory leaks in DNS handling for measurable uptime gains, which is the signature of a dependency in active use rather than a relic.

The Rust effort is worth naming precisely, because it is easy to mistake for a libuv replacement. Sword, formerly Ares, is a Rust runtime under development whose aim is efficient execution of Nock on contemporary chips — the interpreter and its memory model, rather than the networking substrate. Vere remains the normative runtime, and libuv remains its event loop. So the honest present tense is this: the C runtime and its libuv loop are the live foundation, and the Rust work sits beside them at the interpreter, not at the socket.

## What Ames Actually Is

Ames deserves a careful description, because its name invites a wrong assumption. Ames is an encrypted peer-to-peer network running as an overlay over UDP, and its defining move is that it has no separate addressing and identity layers the way the internet separates IP from DNS. An Ames address simply is an identity, bound to a public key for encrypted communication and dressed in a memorable phonemic name. This is close kin to our own instinct, where a Kumara keypair is the name and Comlink reaches peers by signed claims rather than by a borrowed directory.

The shape of Ames rests on a clean seam. The runtime tells Ames which physical address a packet arrived from, handed over as an opaque atom, and Ames in turn emits a packet effect toward such an atom or toward a root node whose physical address the runtime resolves. One runtime carries these as UDP over IPv4 with DNS for the roots; another could overlay an entirely different network. The networking logic and the wire are thus deliberately separable — the vane decides what crosses and to whom, and the runtime decides how the bytes actually travel. That separation is the same one we keep between the Comlink core and its several wires: shared memory, hosted datagram, and the virtio device wire all carry the same sealed shape.

Above that seam, Ames is a reliable transactional message layer built on an unreliable datagram. A message of arbitrary length is broken into fragments sized to the maximum a link can carry; delivery is exactly-once; every message is a transaction; and acknowledgments run end to end, so the packet that completes a message also reports whether the work succeeded. An acknowledgment is positive or negative, and a negative one carries an explanation of the refusal. The refusal discipline is instructive on its own: a packet with a bad checksum or one that fails to decrypt is dropped as though it never arrived, while a packet that decrypts into something malformed causes the whole message to be refused, because that signals a misbehaving peer rather than mere line noise. Congestion is handled by a packet pump that adapts the long-proven Reno family of control, and message flows are tracked by small duct handles the vane keeps in a bijection with their network meaning.

Beneath all of it sits the same spine we already hold: only completed events are logged, and state is what the log folds to. Urbit and Rye meet most deeply here, at the event log, rather than at the socket.

## The Axis Where Ames and Comlink Differ

One distinction must stay sharp, so the silo carries no borrowed error. Ames is identity-and-message-centric: it routes by ship identity and delivers sequenced, acknowledged, transactional messages. It is not content-addressed. Comlink's own turn is content-centric — a resin is named by the digest of its bytes, and the digest is both the address and the proof. These are different axes, and both are worth having. Ames teaches reliable carriage between named identities; our resin model teaches carriage of content proven by its own hash. The lessons we take from Ames therefore live on the carriage-and-reliability axis, while content-centrism remains ours to keep, drawn from the resin study rather than from Ames.

## libuv, Read as a Substrate

libuv is a cross-platform asynchronous input-output library whose center is an event loop that polls for readiness and schedules callbacks against several sources of events, over the best mechanism each platform offers. It carries a few habits worth admiring: it caches the current time once at the start of each loop tick to spare repeated time calls, it models every resource as a handle and every operation as a request with an explicit lifetime, and it offers a datagram type with an allocate-then-receive rhythm that hands the application control of the buffer. These are the marks of a mature reactor, learned across many years and many platforms.

The value libuv offers us is a design to study, rather than a library to link. Two facts of our own ground settle this under TAME. First, libuv is C, and our discipline grows security-touching carriage in our own languages on proven ground, reaching for Rust and Zig rather than adopting a C event loop as a dependency. Second, we already hold both halves of the problem: the hosted side of Comlink runs on the toolchain's own threaded input-output, an event-loop abstraction in its own right, and the freestanding side runs directly on virtio with no operating system beneath it, where a host event loop has no place at all. Adopting libuv would add a C dependency to solve a problem our two substrates already solve. Studying libuv, by contrast, sharpens how we shape our own carriage.

## The Lessons Worth Siloing

Seven lessons cross from this study into our own vocabulary, and the siloed companion carries them as owned first-principles rather than as borrowed mechanism.

The wire is a swappable substrate beneath a pure logic seam, so carriage decisions never entangle the record. Identity is the address, bound to a keypair, with no borrowed directory beneath it. Reliable carriage over an unreliable datagram is a transactional discipline — fragment, acknowledge end to end, and let the completing acknowledgment also report success — which a future Comlink reliability lap can learn without forking the sealed shape. Refusal is whole and quiet at the crypto boundary: a fact that fails its seal is dropped as though it never came, and a fact that opens into something malformed refuses the whole exchange. Everything is bounded, congestion included, so a flow-control lap names its budget before it runs. Mechanical sympathy is worth keeping close to the metal — cache the clock once a tick, give every resource a named lifetime — for the day a Rye-native hosted loop grows beyond what the toolchain gives us. And beneath all of it, the log is the truth and the wire only serves it.

## The Verdict, and What to Keep in Gratitude

The recommendation is plain. Study libuv and Ames; adopt neither. libuv earns a place in gratitude beside Urbit — a teacher whose design we keep close and whose license we honor, studied rather than linked — recorded as a short note that names what it is, why we study it, and where its source and license live. The Ames and Vere sources already rest under our Urbit gratitude, and this study points back to them. The owned lessons pass into the foundations companion, which strengthens how Comlink's carriage is described without changing a line of its code. No dependency is proposed, no module is renamed, and the seat of every future carriage lap stays yours to open.

## Gratitude

This room thanks the Urbit teams — Tlon, the Urbit Foundation, and Zorp — whose runtime, whose Ames vane, and whose event-log discipline taught us how carriage and identity can be one, and the libuv authors whose reactor has quietly carried a great deal of the networked world. We hold their work in our own words, and keep their originals whole in gratitude.

## Sources

- Urbit runtime and libuv, current: Vere repository README — https://github.com/urbit/vere · Urbit Core Academy, Vere and the boot sequence (uv_run, uv_loop_t in u3_host) — https://docs.urbit.org/build-on-urbit/core-academy/ca04 and https://docs.urbit.org/build-on-urbit/core-academy/ca05 · Vere releases (libuv DNS leak fixes) — https://github.com/urbit/vere/releases
- Sword (née Ares), the Rust Nock runtime — https://docs.urbit.org/build-on-urbit/core-academy/ca05
- Ames vane design: Urbit OS kernel reference — https://docs.urbit.org/urbit-os/kernel/ames · Arvo reference overview — https://developers.urbit.org/reference/arvo/ames/ames · Core Academy, Vanes II: Ames — https://docs.urbit.org/build-on-urbit/core-academy/ca08 · Urbit whitepaper — https://media.urbit.org/whitepaper.pdf
- libuv event loop and design — https://docs.libuv.org

---

*May the wire stay humble beneath the record it serves. May we keep the lessons and honor the teachers who gave them. And may every fact that crosses our carriage arrive whole, or not at all.*
