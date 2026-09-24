# The next wire is the one Comlink already carries

**Language:** EN
**Stamp:** `20260924.143132`
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living -- mixed -- Comlink already crosses virtio-net, and Aurora has no virtio stage yet
**Room:** design -- the shape outlives the Aurora file that will hold it

[`posted.rye`](../../../aurora/src/posted.rye) is the sixth living Aurora stage. Two harts share one sealed datagram across a mailbox in RAM. [`roster.rye`](../../../aurora/src/roster.rye) stands beside those six and speaks who may talk to whom. The next wire leaves that one machine. It carries the same sealed datagram between two machines, and the card on that wire is virtio-net.

That wire already lives in Comlink. [`virtio_net.rye`](../../../comlink/virtio_net.rye) is the card a guest sees. [`device_wire.rye`](../../../comlink/device_wire.rye) proves the descriptor algebra on the host, then the same crossing on a real virtio link between two guests. The hosted selftest has been heard: five virtio structures are padding-free, the link frame carries a whole sealed datagram, and the fixture closes green. The witness is [`comlink_device_wire_hosted_witness.rish`](../../../tools/co/comlink_device_wire_hosted_witness.rish). It builds and runs on the host, with no emulator. Aurora's sources do not import that card. A second driver under `aurora/src/` would be a second account of the same device.

When an Aurora stage takes this wire, it wakes through the Comlink path that already exists. The six living stages stay six until the count is told to move. Bakery keeps the toroidal scheduler and Aurora's place in the build graph. Diffuser keeps the wake-budget measurement. This page names the handoff and leaves the Aurora file for the witness row.

The door that already says this is [`aurora/README.md`](../../../aurora/README.md). The room that already proves it is [`comlink/README.md`](../../../comlink/README.md).
