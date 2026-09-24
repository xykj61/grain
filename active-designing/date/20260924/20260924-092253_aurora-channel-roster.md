# The stage that speaks a channel roster

**Language:** EN
**Stamp:** `20260924.092253`
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living -- mixed -- the stage is named, and its source waits on the hosted witness
**Room:** design -- the shape outlives the file that will hold it

[`posted.rye`](../../../aurora/src/posted.rye) is the last freestanding Aurora stage that already runs. Two harts share one sealed datagram across a mailbox in RAM. The stage after it loads the roster [`channels.rye`](../../../caravan/channels.rye) already declares, and it speaks that roster on the hart.

The roster is small enough to read in one sitting. Eight domains fill it. Sixteen channels fill it. A channel joins exactly two domains. A domain name holds at most 48 bytes. Those four ceilings already stand in the module, witnessed on the host, with the graph declared at construction.

On the hart the stage says three things and then rests. It says how many domains the roster holds. It says how many channels the roster holds. It says that each channel names two domains, and that those two names are domains the roster itself declared. When the three sentences hold, the stage writes the passing finisher. When a channel names one domain twice, or names a domain the roster never declared, the stage writes the refusing finisher and the books stay as they were.

The same three sentences are the hosted witness. `qemu-system-riscv64` is absent on this pier, and the standing `qemu_riscv` capability already skips that leg and says so. The witness runs here. The wake comes later: Aurora's freestanding ELF, on `qemu-system-riscv64 -machine virt`, the same door [`aurora/run.sh`](../../../aurora/run.sh) already opens for `posted`.

The study this shape comes from is the Microkit clean-room brief, [`protection domains and channels`](../20260819/20260819-094721_clean-room-microkit-protection-domains-channels.md). The stage is Grain's own roster, spoken in Rye. Bakery keeps the toroidal scheduler and Aurora's place in the build graph. Diffuser keeps the wake-budget measurement. This page is the only path Incense holds for the stage.

The source, when the hosted witness opens, belongs beside `posted.rye` under `aurora/src/`. This page names it and leaves that file for the witness row.
