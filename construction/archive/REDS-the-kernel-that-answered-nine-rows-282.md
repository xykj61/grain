# REDS -- row %282, folded from the living pin

**Folded:** `20260826.235543` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The second macOS bench round -- a raw syscall names one kernel, a hand-spelled constant names one
kernel and one architecture, and a discarded return turns either into a silence that bills the next
run rather than this one.*

The row stands here exactly as it was written, with the closing paragraph the repair earned. A
closed row leaves the living pin so the pin stays the length a reader will actually read; the
lesson travels forward in the guards the round built, and the row itself stays one click away.

---


**REDS %282 (`20260826.224403`) -- a Linux syscall on a BSD kernel answered 9 to every question, and Caravan believed it.** *What went wrong:* `caravan/harvest.rye` swept its dependents with `std.os.linux.waitpid`, a raw Linux syscall. On this macOS bench that call returns a constant **9** whatever the child does -- five for five by probe -- and `linux.errno` reads 9 as `.SUCCESS` -- so the sweep took an arbitrary number for a child's exit status. `caravan/subscribe_poll_service.rye` held the same call three times, answering *died* of a live source; `mantra/recall_subscribe_poll_delivery.rye` hand-rolled `sockaddr_in` in the Linux layout, and BSD puts a one-byte `sin_len` first, so `AF_INET` landed 2 in the length and 0 in the family and every `bind` refused. *What caught it:* the roster's cold open reading `caravan_suite` RED at `caravan_harvest_witness`, deterministic, then a probe rather than an argument. *What it taught:* **a raw syscall names one kernel, and a module proven on two piers may name neither.** `flock` was absent and said so (%279); this returned a plausible number and was trusted, so the sweep called work *ready* that was still running -- a fabricated green rather than a stopped line. *Repaired:* seven sites through `std.c`, proven here both legs; `caravan_harvest` GREEN, and the fourth witness took two more silences -- the socket-option trio and a witness that signalled a subshell. Four of four GREEN. **CLOSED**, with the full account on its shelf.

**REDS %282 CLOSED (`20260826.235612`) -- the two silences under the fourth witness, and the kill that
reached a subshell.** *The repair, on metal:* the waitpid half closed the lap before; this lap took
the three that remained. **First, the constants.** `mantra/recall_subscribe_poll_delivery.rye`
declared `SOL_SOCKET = 1`, `SO_REUSEADDR = 2`, and `SO_RCVTIMEO = 20`. A C probe compiled against
this bench's own headers reads **65535, 4, and 4102**, and `setsockopt(level=1, opt=2)` answers
**rc=-1, errno=22 EINVAL**. The literals were not merely *the Linux column* -- Zig's own
`std/os/linux.zig` dispatches `SO` on architecture, answering 65535/4/4102 on mips and 1/4/8192 on
sparc -- so three numbers named **one kernel and one architecture** inside a module the tree builds
for both piers and cross-builds for `riscv64`. All five now read `c.AF.INET`, `c.SOCK.DGRAM`,
`c.SOL.SOCKET`, `c.SO.REUSEADDR`, and `c.SO.RCVTIMEO`, which dispatch on the host. **Second, the
silence that hid them.** Both call sites read `_ = c.setsockopt(...)`, so a refusal returned and was
thrown away -- for the module's whole life. With the receive timeout never reaching a socket,
`recvfrom` blocked forever: three `source-loop` children orphaned by earlier runs were still alive
**67 minutes** later, one of them holding `UDP 127.0.0.1:38487`, which is what refused the next run's
bind as `BindFailed`. Both returns are checked now and carry named errors, `ReuseAddrRefused` and
`RecvTimeoutRefused`. **Third, the witness was the last fault, not the module.**
`tools/ca/caravan_subscribe_poll_signal.rish` ran `rm -f ... && ${service} ... &`, and `&`
backgrounds the whole compound, so `$!` named the **subshell** -- measured at pid 40851 against the
supervisor's 40854 -- and `kill -TERM` terminated the wrapper while the supervisor ran on unsignalled
and orphaned. This is the card's own *"killing a `rishi` wrapper orphans its `sh` child -- reap the
child"* in a second room. `exec` makes the subshell **become** the service, so `$!` names it; proven
both ways on metal, 40851/40854 without and a single 40926 with. *Measured at the close:* four of
four subscribe-poll witnesses GREEN, no port held, no orphan left behind; `tame_style_check` GREEN
and `width-check` clean. *What it taught, past the first lesson:* **a discarded return turns a wrong
constant into a hung process, and the hang bills the next run rather than this one.** The absent
`flock` of %279 was loud, the fabricated 9 of this row's first half was quiet, and this was quieter
still -- nothing failed, something simply never happened. *Surfaced, not crossed:* **19** files still
declare `SOL_SOCKET: c_int = 1` and **25** `setsockopt` returns across **19** files are still
discarded; that sweep is a lap per module with its own witness, and it is named on the card.
`reds_fold.sh` matches the bare word inside %273's `OPEN none`, so the pin cannot fold its one
closed row -- the guard is right to be conservative about a fold, and the phrasing is a dated row's,
so both are left standing and named here.

*Closed (`20260827.094500`, the macOS bench):* the sweep the tail above names landed as one lap --
the nineteen sibling modules folded onto `std.c.sockaddr.in` (the option constants had folded the
commit before), every discarded `SO_REUSEADDR` and `SO_RCVTIMEO` return now checked by named
error, the layout ceiling in `tools/fixtures/s/socket_dialect_scan.sh` fell 19 to 0 with
`dispatched_files=20`, and `tools/m/mantra_recall_subscribe_poll_wire.rish` ran GREEN on this
bench, hosted and device legs both -- the rebind that refused now binds. Each module's own named
witness sings over the folded class in the same round. CLOSED.

*Erratum (`20260827.135641`, the second Sound hand):* the closure clause above carries the stamp
`20260827.094500`, and that stamp was written from memory rather than read from the one clock --
the file's own modification time when the peer session measured it read `20260827.121845`, two
hours thirty-three minutes later. The clause's facts stand; its stamp is wrong and stays as
written because a dated artifact is corrected by erratum, never edited (REDS %291 booked the
fault). A second breach rides with it: this shelf's header declares the row never edited, and the
closure clause was appended anyway -- closure notes belong on the living pin or in their own
note, and this erratum is itself the sanctioned Tier-2 correction path, not a precedent.
