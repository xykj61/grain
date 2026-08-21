format session-log-v1
stamp 20260811.130827
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Mandate lap 11 — served over Comlink, sealed
prompt kg ty every1, baton prin recur — open the Comlink door
think a real NIC socket is not testable in a bounded witness, so the honest green lap is the binding: carry serve.rye's request/response bytes inside Comlink's sealed-datagram envelope (wire_format.rye)
think wire_format.seal_message is self-contained (fixed internal X25519/kumara seeds — alice/bob), max_message is 340 bytes, and serve request (56) + response (144) both fit; so a query rides one sealed datagram with no fragmentation, proven by a comptime assert
think comlink_serve.rye: serve_sealed(store, request_frame, response_frame) opens the sealed request (decrypt + verify signature + name), serves it, seals the response — the transport changes, the answer does not
obs added two mandate/ symlinks (wire_format.rye -> ../comlink/wire_format.rye, tally_copy.rye -> ../tally/copy.rye) beside the existing kumara/tilak/topology/constellation/names symlinks so wire_format's own imports resolve from mandate/
obs proved on metal: a query served over a sealed client→host→client round-trip equals a direct in-process query (same nearest + order); a single flipped ciphertext byte fails to open, so a forged/tampered datagram never reaches the store; comlink_serve.rye carries no TAME bans, assert-sweep advise tier empty
obs the query now crosses Comlink encrypted, signed, and name-checked end to end — the remaining transport horizon is a live NIC (a real virtio_net socket carrying these datagrams)
loom witness=mandate_comlink_serve_witness wall_ms=71 max_message=340 request_bytes=56 response_bytes=144 wire_capacity=528
loom build=mandate/comlink_serve.rye rye_zig=vendor/zig-toolchain/zig exit=0
file mandate/comlink_serve.rye serve_sealed + prove_comlink_serve; comptime budget assert; selftest + main
file mandate/wire_format.rye new symlink -> ../comlink/wire_format.rye
file mandate/tally_copy.rye new symlink -> ../tally/copy.rye
file tools/mandate_comlink_serve_witness.rish asserts the sealed-serve GREEN lines
file mandate/README.md lap 11 documented; Comlink transport marked landed (sealed datagrams); live NIC named as the remaining horizon
recommend check-in (Claude) — Mandate's eleven-lap arc reaches served-over-Comlink-sealed; the true-network horizon (a live virtio_net NIC) is a large systems domain, and the Acme DX design season is the other live door. A natural place to rule direction. Rest is Keaton's to take
