# The stage that speaks a channel roster

**Language:** EN
**Stamp:** `20260924.092253`
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Living -- mixed -- the stage speaks on the hart, and a broken channel waits on the refusing finisher
**Room:** design -- the shape outlives the source that speaks it

[`posted.rye`](../../../aurora/src/posted.rye) is the sixth living Aurora stage. Two harts share one sealed datagram across a mailbox in RAM. The roster stage stands beside those six. It speaks the roster [`channels.rye`](../../../caravan/channels.rye) already declares. The hart carries that roster as data, and the agreement witness requires the spoken pairs to match the hosted demo.

The roster is small enough to read in one sitting. Eight domains fill it. Sixteen channels fill it. A channel joins exactly two domains. A domain name holds at most 48 bytes. Those four ceilings already stand in the module, witnessed on the host, with the graph declared at construction.

On the hart the stage says how many domains the roster holds, how many channels it holds, and that each channel names two domains the roster itself declared. It then names each pair, low domain then high. When those sentences hold, the stage writes the passing finisher. When a channel names one domain twice, or names a domain the roster never declared, the refusing finisher is the shape this page still holds. The hart today meets a broken ceiling by stopping before any sentence is written.

The hosted witness speaks the same counts and the same two-domain sentence. The wake is [`aurora/run.sh`](../../../aurora/run.sh) `roster` on `qemu-system-riscv64 -machine virt`. The agreement witness requires the domain count, the channel count, the two-domain sentence, and the four pairs to match.

The study this shape comes from is the Microkit clean-room brief, [`protection domains and channels`](../20260819/20260819-094721_clean-room-microkit-protection-domains-channels.md). The stage is Grain's own roster, spoken in Rye. Bakery keeps the toroidal scheduler and Aurora's place in the build graph. Diffuser keeps the wake-budget measurement. This page is the only path Incense holds for the stage.

The source stands at [`aurora/src/roster.rye`](../../../aurora/src/roster.rye), beside `posted.rye`.
