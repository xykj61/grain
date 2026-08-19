# Caravan -- Process Supervision

**Language:** EN
**Last updated:** `20260819.134659` (the boot ring lands -- the supervisor spawns its dependents from the declaration)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable -- process supervision ladder

**Caravan supervises.** It watches a dependent process, restarts it when it falls, and grows -- one accretion at a time -- toward the fuller shape a real service needs: bounded memory per dependent, more than one dependent, ordered startup, a named capability table, and a real exit-code vocabulary that tells restart-on-fall apart from an ordinary cycle and a deliberate stop.

Every ring here composes over the one before it. A later ring imports an earlier one, or restates its shape one step further out -- nothing is rewritten to make room for the next proof.

## The Ladder

| Ring | File | Proves |
|------|------|--------|
| seed | [`seed.rye`](seed.rye) | one parent, one dependent, restart on fall |
| bounded | [`bounded.rye`](bounded.rye) | supervision composed with a dependent's Tally garden |
| twin | [`twin.rye`](twin.rye) | two dependents, separate gardens, independent restart |
| chain | [`chain.rye`](chain.rye) | ordered startup stages, each restarting on its own fall |
| service (B) | [`service.rye`](service.rye) | one long-running dependent, a bounded multi-tick loop, a fall mid-sequence restarting the whole sequence |
| capabilities | [`capabilities.rye`](capabilities.rye) | a bounded table naming what each dependent may do |
| exit vocabulary | [`supervisor_exit.rye`](supervisor_exit.rye) | the three-way exit code: `cycle_ok` (0) spawns again, `stop_requested` (8) halts, anything else falls and restarts |
| restart-on-ok (D) | [`restart_on_ok.rye`](restart_on_ok.rye) | the exit vocabulary proven pure, argv-driven, before any wire work touches it |
| signal ring | [`supervisor_signal.rye`](supervisor_signal.rye) | a real `SIGTERM`/`SIGINT` handler whose entire body is one atomic store; the loop top creates the same sentinel a manual `touch` would |
| poll service (C) | [`subscribe_poll_service.rye`](subscribe_poll_service.rye) | production scheduling -- Caravan supervises Mantra's real subscribe-poll wire work, single pair and host-mirror pair-list alike |
| channels | [`channels.rye`](channels.rye) | the static supervision graph -- a bounded roster of protection domains, channels joining exactly two of them, every refusal named |
| regions | [`regions.rye`](regions.rye) | the declared sharing surface -- named memory regions granted to named domains at named permissions, with write and execute held apart |
| system | [`system.rye`](system.rye) | the whole architecture as one declaration -- a bounded Bron document naming domains, channels, regions, and grants, parsed once and verified whole |
| reader | [`read.rye`](read.rye) | the architecture read from its own file -- a bounded load from disk, oversize refused rather than truncated, every refusal named |
| roster | [`roster.rye`](roster.rye) | the supervisor's dependent table derived from the declaration -- every domain a dependent, every grant one capability, agreement with the map proven over the whole cross product |
| boot | [`boot.rye`](boot.rye) | the supervisor spawns its dependents from the declaration -- every declared domain started in order, handed exactly its own grants, restarted on the same line, a wider document starting nothing |
| exercise | [`exercise.rye`](exercise.rye) | a granted region does real work -- bytes carried across a declared share, an ungranted reach refused before any door opens, a read-only grant refused at two walls, a region that never grows by being used |

## Why the Exit Code Carries Three Meanings, Not Two

A supervisor that only knows "zero means done, anything else means retry" stalls a poller -- an ordinary, successful cycle looks identical to a finished job, and the supervisor stops exactly when it should keep going. `supervisor_exit.rye` names the third answer: zero is *ordinary*, rather than *finished* -- restart regardless. A reserved code, `stop_requested`, alone halts the loop, and it means the same thing whether a human created a sentinel file by hand or `supervisor_signal.rye`'s handler created it from a real signal. Counsel: [`counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md`](../counsel/20260707-014212_claude-counsel-graceful-stop-reframed.md), [`counsel/20260707-021012_claude-counsel-ring4-signal-handler.md`](../counsel/20260707-021012_claude-counsel-ring4-signal-handler.md).

## Why the Graph Is Declared, Rather Than Discovered

`capabilities.rye` names what each dependent may do; `channels.rye` names who each dependent may talk to. Both are declared at construction and readable whole, so the complete communication graph of a supervised system lives in the declaration rather than emerging at runtime -- and a static graph is a graph a witness can check whole. Two clients wired to the same virtualiser still hold no path to each other, since sharing here is deliberate and visible rather than ambient. The shape comes from the Microkit clean-room brief, [`20260819-094721_clean-room-microkit-protection-domains-channels.md`](../active-designing/20260819-094721_clean-room-microkit-protection-domains-channels.md), studied from public docs alone -- concepts crossed the clean room, no source did. This is the first Rye rung of the Microkernel Target's Equinox 1, and it stands on hosted ground: pure policy, asserted and witnessed, with no kernel underneath it yet.

## Why Sharing Is Granted, Rather Than Assumed

`regions.rye` completes the triad: capabilities name **what** a dependent may do, channels name **who** it may talk to, and regions name **what memory** it may touch and how far. Every share is a declared grant of a named region into a named domain at a named permission, so a domain reaches exactly what its declaration hands it and nothing beside. Two clients served by one virtualiser each read their own receive buffer while reaching none of the other's, and the map answers *why* a refusal happened -- an undeclared region, an undeclared domain, an ungranted pair, a denied write, a denied execute -- rather than a bare no.

Two invariants carry the ring. Every grant reads, since a grant permitting nothing declares nothing. And write never stands beside execute in the same grant -- the W xor X rule, held structurally at the constructor and refused by name at the door, so the whole declaration can be checked at once by `write_xor_execute`. Two reads summarize a map for a human: `holders` counts how widely a region is shared, and `footprint` sums the bytes a domain reaches in total. Witness: [`tools/caravan_regions_witness.rish`](../tools/caravan_regions_witness.rish), GREEN on metal, its RED path proven by removing the guard and watching the constructor's own assert catch it.

## Why the Whole Architecture Is One Document

The three rings above each declare one thing well, and `system.rye` gathers them into a single value: a bounded Bron document naming the domains, the channels, the regions, and the grants of a whole system, parsed once and read whole. The grammar is flat -- `key value...` per line, comments and blank lines welcome -- so an architecture carries its own reasoning beside its wiring, and a reviewer meets the entire communication and sharing surface in one sitting rather than assembling it from constructor calls scattered through a program.

Order carries meaning. A channel or a grant names domains and regions already declared above it, so a document reads top-down and a forward reference refuses by name rather than passing quietly. Each domain line declares into both rings at once, which makes the two rosters agree by construction rather than by later repair.

Four properties live above the line level, and `verify` reads them off the finished value: the two rosters agree, W xor X holds across every grant, every declared region reaches at least one domain, and no domain stands an island. Each shortfall answers with its own name -- `rosters_disagree`, `write_and_execute`, `unheld_region`, `isolated_domain` -- so a refused architecture teaches its author what to change. The write-and-run permission word never enters the grammar at all, which makes W xor X a property of what a declaration *can say*, rather than only of what a later check happens to find.

The shape follows the single-stranded brief's own counsel: an enclosure is a value, rather than flags braided through the code that builds it. Witness: [`tools/caravan_system_witness.rish`](../tools/caravan_system_witness.rish), GREEN on metal, its RED path proven by admitting `rwx` into the grammar and watching the self-test refuse the weakened door.

## Why the Document Lives Beside the Code

`system.rye` proves a declaration whole, and it read that declaration from a source literal -- so the architecture still lived inside the program that checked it. `read.rye` takes the last step: the description lives beside the code as its own `.bron` artifact under [`systems/`](systems/), and the reader loads it from disk into a bounded buffer before a single line is parsed. An architecture is now a file a reviewer can open, a diff can show, and a witness can check without building anything that embeds it.

The bound arrives at the door. A document may span at most `max_lines` lines of `max_line_len` bytes, and `max_document_bytes` derives that same bound as a byte count, so the file bound and the parse bound can never drift apart. The truncation guard is the load-bearing detail: a short read fills the buffer and reports the bytes that arrived, which makes a file larger than the buffer and a file exactly filling it look identical from the inside. So the reader keeps one byte of headroom and refuses any read that reaches the buffer's own edge -- a declaration cut mid-line still parses and still describes a system nobody wrote, and that is the one outcome worth spending a byte to rule out.

The refusal vocabulary stays whole across the seam. An absent file answers `NoSuchDocument`, an oversize one `DocumentTooLarge`, anything else unreadable `DocumentUnreadable`, and every line-level refusal keeps the name the parser already gave it -- so an operator reading a RED knows which happened without opening a thing. Three artifacts stand on disk: `serial_stack.bron` reads whole at 73728 declared bytes with no client-to-client path, `unheld_region.bron` parses line by line and still answers `unheld_region` for the whole, and `write_execute.bron` is refused at its own line by a grammar that holds `r`, `rw`, and `rx` and nothing else. Witness: [`tools/caravan_read_witness.rish`](../tools/caravan_read_witness.rish), GREEN on metal, its RED path proven by removing the truncation guard and watching a 257-byte buffer return a silently cut document that parsed happily.

## Why the Supervisor Reads the Same Sentences

Four rings named a system, and one gap stayed open across all of them: the declaration described an architecture, and the supervisor still held its roster somewhere else. Two sources of truth wearing one architecture's name is the oldest way a proof stops meaning anything. `roster.rye` closes that gap in one direction -- the capability table is **derived** from the parsed declaration rather than written beside it, so the rights a supervisor enforces and the grants a witness reads are the same sentences.

Two properties make the derivation checkable rather than merely tidy. **Conservation:** every declared domain seats exactly one dependent and every declared grant seats exactly one capability, so the table holds as many capabilities as the document holds grants -- nothing invented, nothing dropped. **Agreement:** over the whole cross product of declared regions and declared domains, at read, write, and execute each, the table's answer equals the map's answer. The negative answers carry the weight: a client reaching a buffer it was never granted is the failure this whole arc exists to rule out, and both rings refuse it, each in its own vocabulary -- the map answering `not_granted`, the table answering `no_such_resource`. W xor X crosses the translation for free, since a grammar that cannot say `rwx` cannot derive a mask holding both.

The bound is the honest part. A declaration may legally name more domains than a capability table seats, so `from_system` answers `TooManyDomains` rather than seating what fits and reporting itself ready -- a refusal naming the **supervisor's** bound, never a fault in the document. `wide_roster.bron` makes that distinction visible: five wired domains around one shared region, whole by every property `verify` reads, and still past the four dependents this table holds. Witness: [`tools/caravan_roster_witness.rish`](../tools/caravan_roster_witness.rish), GREEN on metal, its RED path proven by widening the derived mask with one right the document withheld and watching the agreement check abort.

## Why the Dependents Are Spawned From the Document

`roster.rye` closed one half of the gap between the declaration and the supervisor. The other half stayed open: a derived table still described dependents nobody had started, and a supervision loop spawning from a hand-written list would carry the old second source of truth right past every proof the four rings before it earned. `boot.rye` closes it -- one document on disk becomes a running system. The reader loads it, the roster derives the table, and the supervisor starts one real dependent process per declared domain, in declaration order, handing each dependent exactly the capabilities its own domain was granted and nothing beside.

The seam is a capability line on argv. Each grant crosses as one `region:perm` word in the same three-word grammar the document is written in, so a dependent reads its rights off its own arguments and re-derives nothing -- which is what makes the parent's fidelity check meaningful rather than self-confirming. W xor X crosses here too, by absence: a mask holding write beside execute has no word at all, so it cannot be spelled onto the wire, and `rwx` reads back as no mask.

Five properties make the boot checkable rather than merely arranged. **Coverage:** every declared domain starts, so a system reporting itself up has every component running. **Order:** dependents start in declaration order, so a document reads as a startup sequence. **Fidelity:** the words handed to each dependent agree with the map at every right, checked by the parent before the spawn and by the dependent after it. **Constancy:** the capability line is built once and reused across every restart, so a dependent that falls comes back holding exactly what it held before -- a restart grants nothing a first start withheld. And **refusal before action:** a declaration this supervisor cannot seat spawns nothing at all.

That last one is the load-bearing negative. A half-booted system is worse than a refused one, since it looks alive from the outside while the components its running dependents depend on were never started -- so `wide_roster.bron`, whole by every property `verify` reads and still past the four dependents this table holds, answers `TooManyDomains` before a single process exists. Witness: [`tools/caravan_boot_witness.rish`](../tools/caravan_boot_witness.rish), GREEN on metal, its RED path proven by rendering a read-only grant as `rw` and watching the fidelity assert abort after the first dependent came up and before the widened line ever spawned.

## Why a Grant Has To Do Work

Seven rings carried a system from a document on disk to running dependents, and every one of them stopped at the same place: a grant was something a dependent could **name**. `boot.rye` hands each dependent its own `region:perm` words and the dependent reads them back faithfully, yet no byte ever crossed a declared share. A capability that only reads true is a label; a capability that opens a door is a capability. `exercise.rye` makes the grant do work -- each declared region is provisioned as a real backing store of exactly its declared length, and a dependent reaches one through a `Reach` it may open only for a region its own capability list names, at rights that list carries. The virtualiser writes; the client granted the same buffer reads back exactly those bytes. The share carried something.

Two walls stand behind every refusal, and the order is the design. The **first** wall is the dependent's own capability list, consulted before any syscall, so an ungranted reach is refused with nothing opened at all -- `client_a` reaching `rx_b` and `client_b` reaching `rx_a` both answer `NotGranted`, and the isolation reads the same from either side. The **second** wall is the open mode itself, derived from the same rights, so a read-only reach holds a read-only door even if the first wall were ever wrong. A system that refuses only at the outer wall keeps one mistake between itself and a write it never granted.

W xor X arrives here as a plain consequence rather than a new rule. A grant spelling `rx` carries no write bit, so `font_rom` reads and runs for both clients and refuses `WriteDenied` by the same path that refuses an ordinary reader -- execute never grows a write door, since the grammar three rings back cannot say both at once. And the extent is the honest part: a region is provisioned at its declared length and never grows, so a reach leaving that extent answers `PastEnd` while the store on disk stays exactly as wide as it was declared. Static allocation is the seL4 teaching this ring inherits -- what a system may touch is settled before it runs.

Witness: [`tools/caravan_exercise_witness.rish`](../tools/caravan_exercise_witness.rish), GREEN on its first metal pass, with both walls proven RED in turn. Dropping the capability check made `client_a` reach a buffer it was never granted, and the self-test named it. Dropping the door's own write check let a read-only grant reach the host, where `NotOpenForWriting` caught it and the invariant aborted at exit 134 -- the second wall doing exactly the work it was built for.

## Held

Extended-run stability (dozens of supervised cycles, watched for resource growth) waits for a genuine indefinite consumer to make the longer run mean something -- see [`counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](../counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md) for the reasoning. `system.rye` reads flat Bron, the same notation Brix descriptors use, and it declares Caravan's own three rings alone -- composing a build remains Brix's work, and Pond's policy layer stays its own. Caravan supervises processes, and stops exactly there.

---

*May every dependent that falls be caught, and every dependent that finishes ordinarily be trusted to go again. May a stop always mean the same thing, however it arrives.*
