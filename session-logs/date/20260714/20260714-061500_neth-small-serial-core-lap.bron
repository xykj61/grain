stamp: 20260714.061500
zone: PDT (Reno, NV convention)
model: Sonnet 5 1M Medium
voice: Rio 3

what: >
  Opened and landed the Neth build ladder's second lap -- the small serial
  core -- per the IronBeetle-siloed pattern 1 and Keaton's chosen direction
  (swing back to witnessed code after a day of naming/design/security work).

why: >
  The naming registry is fully settled and host security is fully closed;
  the compass's own "two-thirds implementation, one-third design" discipline
  pointed at a real code lap next. Neth's deterministic-root witness was
  already green; this lap turns "keep the serial core small" from a design
  sentence into a bounded, witnessed function.

did:
  - "linengrow/neth_serial_core.rye": >
      New module. `append_and_reroot(log, log_len, line, ...)` -- the one
      narrow ordered step: append one already-signed record, then fold the
      whole log (verify + apply) into the new balances and root. Bounded
      at `max_append_bytes = 768` (far under receipt_core's 4096 whole-log
      max) and enforced with `StepTooLarge`, not just stated. Doc comment
      names, explicitly, what stays outside: Comlink carriage (before),
      disk write (after), record signing (before -- mala_core.sign_fact).
  - "linengrow/neth_serial_core_witness.rye": >
      Three claims, each on purpose: (1) two independent calls, same prior
      log, same one pre-signed record, agree bit-for-bit on the new root
      and balances (issuer 150, holder 850, from a 1000/200 welcome log
      plus one more 50 send-back); (2) an oversized (1000-byte) record is
      refused with StepTooLarge and the log it was refused against is left
      byte-for-byte untouched; (3) the pre-signed record was built and
      signed entirely outside the core call, named in the printed record.
  - "tools/neth_serial_core_witness.rish": >
      Build + run wrapper, same shape as tools/neth_root_witness.rish.
  - "tools/parity_ch01.rish": >
      Appended the new witness to the living suite (end of file, after
      Lattice lap 13).
  - "work-in-progress/TASKS.md": >
      Neth ladder's small-serial-core row marked done, pointing at all
      three new files and this stamp.

witness: |
  $ rishi/bin/rishi run tools/neth_serial_core_witness.rish
  → neth-core: prior log -- 1006 bytes (mint, send)
  → neth-core: one pre-signed record ready -- 500 bytes, under the 768-byte bound
  → neth-core: appended -- new log 1506 bytes, issuer 150, holder 850
  → neth-core: new root -- 8e4049d4dff6f5d4d873636e87bf13695fe4232852f46fa101b0dd13dceb2a1c
  → neth-core: oversized record (1000 bytes) refused with StepTooLarge, log left untouched -- GREEN unwelcome path
  → GREEN: Neth small serial core -- append+fold bounded and asserted; Comlink
     carriage, disk write, and record signing all named outside this call.

named_gap: >
  A full sequential run of tools/parity_ch01.rish on this Mac still halts
  earlier, at the pre-existing SLC-2a Lap 1 Brushstroke Wayland-viewer
  witness (Wayland is Linux-only; already named in
  external-research/20260714-005658_native-arm64-parity-witness-run.md).
  This new witness sits past that point in file order and was proven
  standalone rather than through the full sequential run -- not a
  regression from this lap, an existing macOS-only limitation.

next: >
  The Neth ladder's remaining laps -- two-posture root install, apply-step
  crash safety, deterministic-simulation horizon -- are next in order,
  each building on this one. Keaton's word before opening the next.
