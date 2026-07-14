# libuv — With Gratitude

**Language:** EN
**Last updated:** 2026-07-06
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Kept as:** a teacher we study, not a dependency we link

---

libuv is the cross-platform asynchronous input-output library that carries the event loop beneath a great deal of the networked world, Urbit's Vere runtime among it. We keep it here in gratitude because its design taught us how a mature reactor holds itself: an event loop at the center that polls for readiness and schedules callbacks over the best mechanism each platform offers, a clock read once per loop turn and reused, every resource modeled as a handle with a named lifetime, and a datagram type whose allocate-then-receive rhythm hands the buffer's control to the caller. These are the marks of many years of careful work at the socket.

We study libuv; we do not link it. Our carriage grows in our own languages on proven ground, and both halves of our own problem are already answered — the hosted side on the toolchain's own threaded input-output, the freestanding side directly on virtio with no operating system beneath it, where a host loop has no place. So libuv's gift to us is a design to learn from rather than a library to depend on. The lessons we drew rest in [`../external-research/20260706-022912_ames-vere-libuv-content-carriage.md`](../external-research/20260706-022912_ames-vere-libuv-content-carriage.md) and are siloed into owned first-principles in [`../foundations/20260706-022912_the-wire-serves-the-fold.md`](../foundations/20260706-022912_the-wire-serves-the-fold.md).

## Source and License

- **Project:** libuv — https://libuv.org · https://github.com/libuv/libuv
- **Documentation:** https://docs.libuv.org
- **License:** MIT (with additional licenses for some included components; see the project's `LICENSE` and `LICENSE-extra`). Studied here under those terms; no source is vendored into this repository, and any future vendored copy would be kept whole with its license intact.

---

*May the reactor beneath so much of the network be thanked for what it taught us. May we honor its license as we honor its craft. And may the carriage we grow from these lessons stay our own.*
