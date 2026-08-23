# Caravan -- Process Supervision

**Language:** EN
**Last updated:** `20260820.201710` (the refrain rung -- a named ending finally changes what the plan does next)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable -- process supervision ladder

**Caravan supervises.** It watches a dependent process, restarts it when it falls, and grows -- one accretion at a time -- toward the fuller shape a real service needs: bounded memory per dependent, more than one dependent, ordered startup, a named capability table, and a real exit-code vocabulary that tells restart-on-fall apart from an ordinary cycle and a deliberate stop.

**A supervised process here is a *dependent*.** The elder word named offspring, and the ring arc outgrew it: by `unhand.rye` a supervised process is weighed by the line it holds rather than by the ceiling its domain was granted, and by `confer.rye` and `revoke.rye` its reach travels to it and returns from it while it runs. That is a dependent -- something held up by what it was granted -- rather than a thing begotten. The one place the elder word still stands is `std.process.Child`, which is Zig's name at the seam and stays exactly as Zig wrote it. The record of the word that departed, and why it left, waits in [`../construction/CAIRNS.md`](../construction/CAIRNS.md) and the Lexicon's **Dependent** row.

Every ring here composes over the one before it. A later ring imports an earlier one, or restates its shape one step further out -- nothing is rewritten to make room for the next proof.

**A rung's checks live where they are written once.** [`ladder_checks.rye`](ladder_checks.rye) is the harness a rung hands itself to: a lifted check takes the rung as a comptime parameter and reaches every helper through it, so one body runs against whichever rung called it -- that rung's own report, its own helpers, its own wire -- and a chained check re-enters the rung at every link. **A rung publishes a check only to change it**, since the harness reaches each link through `link`, which runs the rung's own body when that rung wrote one and its own body when the rung said nothing. Where a hundred lines of copy stood, a rung keeps nothing at all. **The fold walks down one rung at a time** -- a rung folds into the rung directly beneath it, and no rung is folded into by two, so the chain a reader follows never skips a step and no two rungs write the same stub. The meter that watches the carry is [`../tools/caravan_ladder_copy_witness.rish`](../tools/caravan_ladder_copy_witness.rish), its one-step rule stands as [`../tools/fixtures/caravan_ladder_reach_scan.sh`](../tools/fixtures/caravan_ladder_reach_scan.sh), and the design call it answers is [`../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`](../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md).

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
| carry | [`carry.rye`](carry.rye) | two real processes share one declared region -- a producer writes and exits, the granted consumer starts afterward and reads back exactly those bytes, and every refusal holds inside a dependent that knows only its own argv line |
| notify | [`notify.rye`](notify.rye) | a declared channel rings between two real processes -- every channel its own silent doorbell, the producer writing the share then ringing, the consumer hearing before it reads, an unwired pair refusing NotWired and a bell that never rang heard as Unheard |
| roundtrip | [`roundtrip.rye`](roundtrip.rye) | one declared channel carries both ways -- two directed doorbells per channel so a ring is unhearable by the dependent that rang it, a request answered on the region the answerer owns, and the ask still standing beside the answer when it comes home |
| serve | [`serve.rye`](serve.rye) | one virtualiser serves two clients in one run -- each asked and answered on its own channel, a ring addressed to one client unhearable by the other, every message naming the client it belongs to, and the neighbor's memory refused at the wall |
| restart | [`restart.rye`](restart.rye) | a served dependent falls mid-conversation and the supervisor carries it home -- eight named outcomes read as answers, one reserved code as a deliberate stop, every other code as a fall, the declared bell and the declared bytes standing through the fall, and a dependent that always falls declined by name after a bounded three restarts |
| rederive | [`rederive.rye`](rederive.rye) | a restarted dependent's rights come from the document, never from the parent's memory -- every attempt reloads the declaration and derives its own line, a remembered line kept as a claim to check, and a disagreement met by a named policy: refuse, heal, or report |
| unprompted | [`unprompted.rye`](unprompted.rye) | a client rings a server that has not spoken first -- one attending verb carrying both directions, an ask told from an answer by the bytes rather than by the bell, and a forged ask refused at the wall the declaration already stands |
| queue | [`queue.rye`](queue.rye) | more than one ask stands on one channel at once -- a head the producer owns and a tail the consumer owns, a drain bounded by the queue rather than by the bell, a ring with nothing behind it draining zero by name, and a full queue refusing rather than overwriting an unread ask |
| fanin | [`fanin.rye`](fanin.rye) | two producers write one server -- every ask attributed to the region it arrived in rather than to the author its bytes claim, a sweep bounded per stream so a full producer never delays a quiet one, and an ask that lies about its author refused rather than believed |
| stall | [`stall.rye`](stall.rye) | a consumer stops reading and the rest keep going -- a full stream taking the door its plan declared rather than one the code preferred, refusing so nothing is lost or lapsing so nothing waits, a stalled peer costing its own stream alone, and the answers that fell out of the window counted by the consumer that lost them |
| relay | [`relay.rye`](relay.rye) | one domain both asks and answers -- the chain's shape derived from its grants rather than declared, a middle that forwards a fresh ask while its whole backlog stands unanswered, the two ends sharing no region and no channel, and the far end's name reaching the client as a claim it takes on the relay's word |
| cycle | [`cycle.rye`](cycle.rye) | a shape with no ends -- every domain spanning exactly two peers, the one lap that closes searched out of the flow graph rather than declared, an ask travelling a full circuit and arriving back at the domain that wrote it, and no domain inside the ring able to total the lap it belongs to |
| gap | [`gap.rye`](gap.rye) | a middle of the ring falls mid-lap -- the debt standing in the region rather than in the process, and the one thing a fall swallows that a safe restart will not redo: the bell |
| decline | [`decline.rye`](decline.rye) | a middle lost for good -- the domain declined by name once its attempts are spent, the circuit behind the hole free to run and report and wait, and no neighbor able to reach around it, refused by absence on one side and by rights on the other |
| standby | [`standby.rye`](standby.rye) | a ring repaired around a domain it lost -- a standby named beside that domain refused as a second writer, a detour drawn in advance refused as a shape with a choice of laps, and the succession carrying every ask home over regions the loss left standing, at the price of bells it never inherits |
| inflight | [`inflight.rye`](inflight.rye) | a ring re-declared while a lap is in flight -- the successor derived with one dependent unreaped beneath it, that dependent carrying its arc home under grants the newer document had already retired, the next spawn governed by the newer words absolutely, and a successor that moves one region refused under both readings at once |
| concurrent | [`concurrent.rye`](concurrent.rye) | two dependents of one ring running at the same moment -- the pairs that may run together derived from the grants and the wiring rather than declared, a ring of three admitting none at all and a ring of four exactly two, a bare channel across region-disjoint domains refusing them as surely as shared memory would, and every dependent of a stage reaped before any verdict about it leaves the supervisor |
| cohort | [`cohort.rye`](cohort.rye) | the widest set of domains a document may run at once -- derived by weighing every subset rather than by taking the first domain that fits, a ring's widest set held to `floor(n / 2)` so no ring offers a triple at all, one server and its three clients offering three where a first fit takes one, and the whole cohort reaped before any verdict about any of it leaves the supervisor |
| harvest | [`harvest.rye`](harvest.rye) | reaping by readiness rather than by age -- a bounded no-hang sweep tells the supervisor which dependents have already exited, and the answer arrives in two halves: where the head waits on a domain readiness converts nothing, and where the head waits on a slot it converts the whole of it, one lingering eldest turning one idle turn into zero |
| rolling | [`rolling.rye`](rolling.rye) | a slot refilled the moment a dependent finishes rather than a whole stage reaped first -- reaping split from reporting so a verdict still waits for the drain, admission held head-of-line so a lap never reorders itself, and the waiting that remains counted by its true cause: idle by barrier where the discipline held the slot, idle by order where the document did |
| overtake | [`overtake.rye`](overtake.rye) | reaching past a blocked head, and what a document must declare for the reordering to keep its meaning -- the lawful order derived from the regions the declaration already names rather than added to it, isolation and order kept as two questions so a domain that may not stand beside itself may still be passed freely, no lawful pass at all over the ordered lap where the order is the arc, and every slot converted over a lap whose head blocks on its own domain |
| commute | [`commute.rye`](commute.rye) | a region two domains only read, and the two rooms it opens at once -- direction taken from the grants the declaration already carries, so a shared region conflicts only where one of the two sides may write it, the whole of a reading lap converted where nobody writes what everybody holds, and the order half closed while the isolation half stays open where the head publishes |
| intent | [`intent.rye`](intent.rye) | a grant is a ceiling and a hop is an act -- each queued item declaring one letter per hop, the effective write read as the grant AND the word so a declaration narrows and never widens, the dependent's line narrowed to exactly what it declared so an undeclared write meets a refusal from the mechanism, the order half of a ceiling lap converted whole while the isolation half stays closed because a channel is a standing joint no per-hop word narrows |
| phases | [`phases.rye`](phases.rye) | a turn cut into phases keeps an order its regions never name -- each phase naming the turn it belongs to, phases of one turn kept in the order they were written whatever their regions say, the declaration growing no second dialect because the link speaks about the queue rather than the document, the isolation half needing nothing because a domain never stands beside itself |
| fence | [`fence.rye`](fence.rye) | a phase follows a prefix of its turn, and a prefix is one number -- one number per phase naming how many leading siblings it follows, `after = step` the link exactly and `after = 0` a phase freed of its siblings, the relation transitively closed by construction so a supervisor never walks a graph to admit a dependent |
| mask | [`mask.rye`](mask.rye) | a phase names the siblings it follows, and a turn closes them once -- a whole turn fitting inside one `u32` so the set is closed in a single pass at the door and every admission stays one bit test, a full mask reading as the fence and the link exactly, and the hole a prefix must swallow finally writable |
| precede | [`precede.rye`](precede.rye) | a turn may name a turn, and the plan closes them once -- a whole plan's turns inside one `u32`, direction ruling out every cycle without a walk |
| arrange | [`arrange.rye`](arrange.rye) | a plan may be written in any order, and the queue seats it -- the sequence a checkable claim and then a derivable one, a seated plan arranging to itself exactly |
| arrive | [`arrive.rye`](arrive.rye) | a phase may arrive after the plan is seated -- an arrival a claim about one phase costing one walk, and a plan grown one arrival at a time proving to be the plan written whole |
| enlist | [`enlist.rye`](enlist.rye) | a phase may join a run already under way -- the reading carrying over whole so the mid-run door needs no new refusal, only a memory, and a newcomer taking the tail so nothing already granted moves |
| withdraw | [`withdraw.rye`](withdraw.rye) | a phase still waiting may leave a run -- the mirror of the three facts an arrival owed the plan, read backwards, and exactly what makes a departure invisible downstream |
| replace | [`replace.rye`](replace.rye) | a run may correct a phase in one act -- the correction refused by every reading that weighs a newcomer against a record still holding the phase it replaces |
| understudy | [`understudy.rye`](understudy.rye) | a record may carry two shapes of one phase at once -- the work in flight finishing under the shape it started with while every reading downstream answers from the new one |
| unhand | [`unhand.rye`](unhand.rye) | a dependent is weighed by the line it holds, never by the ceiling its domain was granted -- the supervisor remembering one line per live dependent, and a line as wide as its own ceiling reading as the ceiling exactly |
| taper | [`taper.rye`](taper.rye) | a line only ever shrinks, and the door widens the moment the work narrows -- a handback one number the dependent publishes and the run takes in, with the direction, the floor, and the reach each refused by name |
| entrust | [`entrust.rye`](entrust.rye) | a line may also grow, and growing is the harder half -- a reserve handed forward one number the run publishes and the dependent answers, so work for a domain already standing is carried by the dependent already there, with the direction, the supply, the reach, the room, and the answer each refused by name |
| confer | [`confer.rye`](confer.rye) | the reach itself travels, rather than riding along from the spawn -- the capability word derived from the ceiling, read back before it leaves, and grafted by the dependent into its own slot, so dark reach falls to zero with the region, the letter, the wire, the room, and the answer each refused by name |
| revoke | [`revoke.rye`](revoke.rye) | reach returns the moment its work is carried, rather than resting in a dependent's hands for the whole of its life -- one shrinking number over the wire, a slot the dependent rebuilds around it, and an answer earned by the dependent's own probe, so stale reach falls to zero with the direction, the supply, the work still standing, and the answer each refused by name |
| reclaim | [`reclaim.rye`](reclaim.rye) | a conferral leaves with the dependent it was made to -- the notes swept clean at the reaping, so inherited reach at a successor's first breath falls to zero |
| abandon | [`abandon.rye`](abandon.rye) | a conferral whose holder fell served nobody, and the run says so -- the loss written into the departed domain's notes after the reclamation sweeps them, and read back before the report believes it |
| reckon | [`reckon.rye`](reckon.rye) | a plan that lost an arc is reported short -- completion a verdict the run earns rather than a shape its record fell into, standing on the wire where an operator reads it |
| mend | [`mend.rye`](mend.rye) | a plan reported short is run again for exactly what it lost -- the repair seated from a loss note on the wire rather than from memory, bounded by the loss, at a price of exactly one more dependent |
| bear | [`bear.rye`](bear.rye) | a plan may name the loss it would rather carry than repair -- the bearing declared beside the outcome its author already expects, written on the wire glyph by glyph, and a third settlement word for a plan as whole as it was ever asked to be |
| appraise | [`appraise.rye`](appraise.rye) | a loss its author left unmarked is weighed by what came home after it -- the standard published at the plan, the evidence the plan's own downstream, and no evidence read as repair |
| recant | [`recant.rye`](recant.rye) | a judgment a run's own evidence disproves is taken back on the wire and repaired -- the appraisal the one note a run never clears, and every standing judgment upheld or recanted |
| amend | [`amend.rye`](amend.rye) | a settlement an operator already read is corrected where they read it -- the elder reading and the word that supersedes it written as one pair, and a reading this run still stands behind confirmed and left alone |
| courier | [`courier.rye`](courier.rye) | a correction is carried to the reader who never comes back -- the address seated on the wire beside the reading, the letter written into the reader's own box outside this plan's wire, and the box read back before anybody is believed reached |
| hear | [`hear.rye`](hear.rye) | a correction is finished when its reader answers, and the plan reads that answer in their own hand -- the reader's box facing two ways, and an answer bound to the reading it answers |
| dispute | [`dispute.rye`](dispute.rye) | a reader who answers something other than agreement is recorded rather than set aside -- both readings written into the record, the plan's and its reader's, and neither one resolving the other |
| abide | [`abide.rye`](abide.rye) | the word an operator reads stands beside the reading held against it -- one byte quoting the reader's own objection, written where the settlement is read rather than where the record is kept |
| lapse | [`lapse.rye`](lapse.rye) | an objection is put back to the reader who raised it, and answered or let go -- the question written into that reader's own box, the answer published in one byte beside the word it bounds |
| repose | [`repose.rye`](repose.rye) | a mark carries the standing of the objection it quotes -- one byte appended to the escort, naming whether the reader who raised it still holds it, with their own reading untouched beneath |
| tidings | [`tidings.rye`](tidings.rye) | the reader who raised a quarrel is told how it came out -- one byte written into their own box, naming whether the word they objected to reads differently now or reads exactly as it read |
| appeal | [`appeal.rye`](appeal.rye) | the reader told how a quarrel came out may answer that telling -- their own reply read out of their own box, and published where an operator opens the plan |
| endure | [`endure.rye`](endure.rye) | a quarrel its holder still presses outlives the run that heard it -- one byte in the only note a provisioning leaves alone, so the next run opens knowing |
| heed | [`heed.rye`](heed.rye) | a plan run under a quarrel it inherited says so in the word an operator reads -- one byte beside the settlement, published without softening it or withdrawing the quarrel |

## Why the Exit Code Carries Three Meanings, Not Two

A supervisor that only knows "zero means done, anything else means retry" stalls a poller -- an ordinary, successful cycle looks identical to a finished job, and the supervisor stops exactly when it should keep going. `supervisor_exit.rye` names the third answer: zero is *ordinary*, rather than *finished* -- restart regardless. A reserved code, `stop_requested`, alone halts the loop, and it means the same thing whether a human created a sentinel file by hand or `supervisor_signal.rye`'s handler created it from a real signal. Counsel: [`counsel/date/20260707/20260707-014212_claude-counsel-graceful-stop-reframed.md`](../counsel/date/20260707/20260707-014212_claude-counsel-graceful-stop-reframed.md), [`counsel/date/20260707/20260707-021012_claude-counsel-ring4-signal-handler.md`](../counsel/date/20260707/20260707-021012_claude-counsel-ring4-signal-handler.md).

## Why the Graph Is Declared, Rather Than Discovered

`capabilities.rye` names what each dependent may do; `channels.rye` names who each dependent may talk to. Both are declared at construction and readable whole, so the complete communication graph of a supervised system lives in the declaration rather than emerging at runtime -- and a static graph is a graph a witness can check whole. Two clients wired to the same virtualiser still hold no path to each other, since sharing here is deliberate and visible rather than ambient. The shape comes from the Microkit clean-room brief, [`20260819-094721_clean-room-microkit-protection-domains-channels.md`](../active-designing/date/20260819/20260819-094721_clean-room-microkit-protection-domains-channels.md), studied from public docs alone -- concepts crossed the clean room, no source did. This is the first Rye rung of the Microkernel Target's Equinox 1, and it stands on hosted ground: pure policy, asserted and witnessed, with no kernel underneath it yet.

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

That last one is the load-bearing negative. A half-booted system is worse than a refused one, since it looks alive from the outside while the components its running dependents rely on were never started -- so `wide_roster.bron`, whole by every property `verify` reads and still past the four dependents this table holds, answers `TooManyDomains` before a single process exists. Witness: [`tools/caravan_boot_witness.rish`](../tools/caravan_boot_witness.rish), GREEN on metal, its RED path proven by rendering a read-only grant as `rw` and watching the fidelity assert abort after the first dependent came up and before the widened line ever spawned.

## Why a Grant Has To Do Work

Seven rings carried a system from a document on disk to running dependents, and every one of them stopped at the same place: a grant was something a dependent could **name**. `boot.rye` hands each dependent its own `region:perm` words and the dependent reads them back faithfully, yet no byte ever crossed a declared share. A capability that only reads true is a label; a capability that opens a door is a capability. `exercise.rye` makes the grant do work -- each declared region is provisioned as a real backing store of exactly its declared length, and a dependent reaches one through a `Reach` it may open only for a region its own capability list names, at rights that list carries. The virtualiser writes; the client granted the same buffer reads back exactly those bytes. The share carried something.

Two walls stand behind every refusal, and the order is the design. The **first** wall is the dependent's own capability list, consulted before any syscall, so an ungranted reach is refused with nothing opened at all -- `client_a` reaching `rx_b` and `client_b` reaching `rx_a` both answer `NotGranted`, and the isolation reads the same from either side. The **second** wall is the open mode itself, derived from the same rights, so a read-only reach holds a read-only door even if the first wall were ever wrong. A system that refuses only at the outer wall keeps one mistake between itself and a write it never granted.

W xor X arrives here as a plain consequence rather than a new rule. A grant spelling `rx` carries no write bit, so `font_rom` reads and runs for both clients and refuses `WriteDenied` by the same path that refuses an ordinary reader -- execute never grows a write door, since the grammar three rings back cannot say both at once. And the extent is the honest part: a region is provisioned at its declared length and never grows, so a reach leaving that extent answers `PastEnd` while the store on disk stays exactly as wide as it was declared. Static allocation is the seL4 teaching this ring inherits -- what a system may touch is settled before it runs.

Witness: [`tools/caravan_exercise_witness.rish`](../tools/caravan_exercise_witness.rish), GREEN on its first metal pass, with both walls proven RED in turn. Dropping the capability check made `client_a` reach a buffer it was never granted, and the self-test named it. Dropping the door's own write check let a read-only grant reach the host, where `NotOpenForWriting` caught it and the invariant aborted at exit 134 -- the second wall doing exactly the work it was built for.

## Why the Carry Has To Cross a Real Seam

`exercise.rye` made a grant do work, and both halves of that proof lived inside one process, holding two capability lists side by side in the same memory. That proved the policy. It could never prove the seam. `carry.rye` carries the same bytes between two real processes: the supervisor provisions each declared region, derives the table, and starts one dependent per assignment, each holding nothing beyond its own argv line. The producer writes and exits; the consumer starts afterward, opens the same region through its own read-only grant, and reads back what the first process left there. Two address spaces, one declared share, and thirty-six bytes arrive.

Order becomes load-bearing rather than merely tidy. The carry works precisely because declaration order is startup order -- the document names `serial_virt` before `client_a`, so the producer has already exited by the time the consumer opens the region. A startup sequence written into a document is a real sequence at run time.

Judgment stays with the supervisor. A dependent attempts exactly the one task its plan word names and reports the outcome as an exit code from a closed vocabulary -- carried, `NotGranted`, `WriteDenied`, `PastEnd`, or bytes that differed -- and the parent asserts which code it expected. A component never grades itself, so a dependent that quietly did nothing cannot report success. The plan wire is closed the same way the capability wire is: four verbs cross it, and `destroy:rx_a` or a plan naming no region reads as no task at all.

The dependent learns nothing it was not handed. It never reads the declaration, so it has no idea how wide a region is; it takes the extent from the provisioned store, which the parent sized at exactly the declared length and which never grows by being used. Static allocation settles the bound before anything runs -- the seL4 teaching, arriving here as the reason a dependent needs no document to stay inside its region.

Witness: [`tools/caravan_carry_witness.rish`](../tools/caravan_carry_witness.rish), GREEN on its first metal pass, with both RED paths proven before the green was trusted. Asking the producer to open the region without writing left the consumer reading zeros, and it reported `bytes differed` rather than success. Letting a dependent grant itself a capability its argv never carried let `client_b` reach `rx_a`, and the supervisor caught it by name at exit 1 -- which is what makes the refusals in the green run statements about the dependent's own line rather than about the file system.
## Why the Channel Has To Ring

`carry.rye` carried bytes across the seam and left the other half of the Microkit shape unbuilt. A share answers *what*; it never answers *when*. A consumer holding a granted region has no way to learn that anything arrived in it, so it either polls forever or reads whatever happens to be there -- and the declaration had named channels since `channels.rye` without a running dependent ever being able to ring one. `notify.rye` makes the channel real: every declared channel is provisioned as its own doorbell, a small store holding one count, and a dependent may ring only a peer its own declaration wired it to. The producer writes the region and rings the bell in the same process, then exits; the consumer starts afterward, hears the bell, and only then reads the share. Notify says *something happened*, the region says *what*, and neither half pretends to be the other.

Writing before ringing is the discipline, and it lives in the code rather than in a comment on the consumer -- a bell that rang before the bytes landed would tell a reader to go look at something not yet there. One channel owns exactly one bell no matter which endpoint reaches for it, since the path orders its two domain names; a pair that rang two different stores would be two channels wearing one declaration's name.

Two refusals carry the ring. Two clients sharing a virtualiser hold no channel to each other, so `client_a` ringing `client_b` answers `NotWired` with no bell opened at all, both ways -- the wall is the dependent's own peer list, consulted before any path is built, the same ordering the region walls already keep. And hearing is a real check rather than a courtesy: a dependent told to hear a bell that never rang answers `Unheard` and reads nothing, so a consumer cannot mistake an untouched region for a delivered one. That single refusal is what makes the ordering claim mean anything -- the consumer reads the share because the bell rang, rather than because two processes happened to run in a convenient order.

Witness: [`tools/caravan_notify_witness.rish`](../tools/caravan_notify_witness.rish), GREEN on its first metal pass, with both RED paths proven before the green was trusted. Neutralizing the peer-list wall let `client_a` reach for a bell it was never wired to, and the refusal degraded from `NotWired` into a bare `malformed` -- which is the argument for the first wall stated plainly: without the dependent's own list, a channel refusal stops being a named answer and becomes an accident of what happens to exist on disk. Dropping the hearing check let a consumer read an undelivered region and report `bytes differed` rather than `Unheard`, so the supervisor caught it by name at exit 1.


## Why the Channel Carries Both Ways

`notify.rye` made a channel ring, and it rang one direction only. The producer wrote the share, rang the bell, and exited; the consumer heard and read. Nothing in that arc let the consumer answer -- and the bell itself could not have told the difference, since one channel owned one counted store reached the same way from either side. A dependent that rang and then listened would have heard its own ring come back as news. `roundtrip.rye` closes the loop and repairs that latent echo in the same move: every declared channel is provisioned as two doorbells, one per direction, named by sender and receiver rather than by the unordered pair.

The answer travels on memory the answerer holds. `serial_stack.bron` grants every client read alone, so a client there can hear a delivery and can never answer one; `serial_duplex.bron` declares `tx_a` beside `rx_a`, owned the other way, and the reply rides it. That is the declaration doing the work again -- a round trip is a property of what the document grants, rather than a convention two programs agree on at run time.

The crux is the middle step of the trip. The virtualiser requests, then collects immediately, and hears `Unheard` on a channel it rang moments before -- because a directed bell carries a ring away from its sender and never back to it. Then the client replies, and the same collect answers `carried`: the answer arrived, and the ask it answers is still standing exactly where it was written. Two identical assignments, differing only in whether the reply has happened, are what make the ordering claim checkable rather than merely narrated.

Witness: [`tools/caravan_roundtrip_witness.rish`](../tools/caravan_roundtrip_witness.rish), GREEN on its first metal pass, with both RED paths proven before the green was trusted. Sorting the bell's endpoints back into one undirected store let the virtualiser hear its own ring and read an empty answer, reporting `bytes differed` where `Unheard` belonged -- the echo made visible. Neutralizing the peer-list wall degraded an unwired ring from `NotWired` into a `WriteDenied` that merely happened to fire first, which is the same lesson `notify.rye` learned, holding here.

## Why One Server Serves Two Clients

`roundtrip.rye` closed the loop between two domains, and every claim it proved was a claim about a pair. A pair cannot tell an isolated server from one that simply had no second client to leak to. `serve.rye` adds the third party: `serial_two_clients.bron` gives both clients the duplex shape -- a receive region the virtualiser writes and the client reads, a transmit region the client writes and the virtualiser reads -- and one run serves them both, each on its own channel, with the two answers standing side by side.

The crux is the second step. The virtualiser rings `client_b` and nobody else, and `client_a` then collects and answers `Unheard`. One sender, two receivers, and the ring reaches exactly the one it was addressed to -- so isolation stops being an absence of traffic and becomes a refusal a witness watches happen. The four steps that follow serve `client_a` in the same run and collect from `client_b` a second time, proving the newer conversation left the older one standing exactly where it was.

Every message names the client it belongs to, which is the crossed-wire wall stated in bytes. An ask reads `serve: ask for client_a` and an answer reads `serve: answer from client_a`, each derived from what the dependent already knows -- the requester from the peer it is serving, the replier from its own domain label. A client handed its neighbor's question refuses it rather than answering somebody else's mail, and the virtualiser collecting an answer signed by the wrong domain refuses it the same way.

Witness: [`tools/caravan_serve_witness.rish`](../tools/caravan_serve_witness.rish), GREEN on its first metal pass, with both RED paths proven before the green was trusted. Naming a bell by its sender alone let `client_a` hear the ring meant for `client_b` and walk on into the regions, reporting `bytes differed` where `Unheard` belonged -- one server broadcasting to every client it serves, which is precisely what a per-pair direction prevents. Addressing every ask to a fixed client made `client_a` read its neighbor's question, and it declined to answer rather than replying to mail addressed elsewhere.

## Why a Fall Is Survivable

`serve.rye` made the arc a system, and every step in it ran to completion. A system that only ever completes has proven nothing about the day a dependent falls, and falling is the whole reason a supervisor exists. `restart.rye` drops a served client mid-conversation and asks what survives -- and the answer separates into three things, which is the finding.

The bell stands. A doorbell holds a count until someone clears it, so the ring the fallen attempt heard is still ringing for the attempt that replaces it. The memory stands too: a region belongs to the declaration rather than to a process, so bytes a dependent wrote before it fell are exactly where it left them. The progress does not stand, and it should not -- a restarted dependent knows only what its argv and the declaration tell it. Together those give the property this ring is really about: **restart is safe when every step is idempotent over declared state.** The client dropped before writing hears the standing bell and writes its answer for the first time; the client dropped after writing rewrites the same bytes over themselves and rings once. Neither needs the server to ask again, and the virtualiser collecting afterward cannot tell from the outside that anything fell.

The three exit meanings are read here rather than assumed, and reading them right is the wall. A named outcome -- `carried`, `Unheard`, `NotWired`, `WriteDenied` -- is an **answer**, so a supervisor that restarts one is restarting a dependent that did its job. `stop_requested` is a **deliberate stop**, and supervision of that domain ends with no restart spent. Every code the vocabulary cannot name is a **fall**, which is also what a signal-killed dependent reports, so one meaning covers both causes. The whole byte partitions into exactly those three -- eight answers, one stop, and the remaining two hundred forty-seven falls -- checked as pure policy before any process runs, and restarts stay bounded at three so a dependent that falls every time is declined by name rather than restarted forever.

Witness: [`tools/caravan_restart_witness.rish`](../tools/caravan_restart_witness.rish), GREEN on its first metal pass, with both RED paths proven before the green was trusted. Reading every non-zero exit as a fall -- the elder rule applied without this world's outcome vocabulary -- restarted a correct `NotWired` refusal four times and then declined it, which is a supervisor spending its whole budget on success. Re-silencing the bells between attempts left the restarted client answering `Unheard` where `carried` belonged, which is the standing-bell claim stated in reverse.


## Why the Rights Are Derived Again

`restart.rye` proved a fall survivable, and every restart in it took the dependent's capability line from a table the supervisor derived once, at boot, and then carried in memory for the life of the run. That is one authority too many. A supervisor that remembers what a dependent may do stands beside the declaration as a second description of the same system, and the day the two disagree, the running dependents obey the copy. `rederive.rye` removes the second authority: every attempt, the first and each restart after it, reloads the declaration from disk and derives the dependent's line from that read. The property it names is a small one said plainly -- a dependent's rights are a function of the document, evaluated per attempt, rather than a value the parent holds.

Memory is kept, and it is kept as a claim to check rather than as a source to obey. Each derivation is compared against what the supervisor remembered, and a disagreement is met by a policy an operator chooses. `refuse` declines the spawn by name, so nothing runs on a system whose two descriptions of itself have parted. `heal` names the drift, replaces the memory with the fresh derivation, and continues. `report` names the drift, keeps the memory exactly as it stands, and continues anyway.

That third policy is the crux, and it exists because the first cut of this ring could not state its own claim. Under `refuse` nothing spawns, and under `heal` the memory agrees again before any line is chosen -- so in neither case can a reader tell a document-derived line from a remembered one. `report` leaves the two still disagreeing at the moment of the spawn, and the supervisor asks the widened dependent to do exactly the act its memory wrongly permits. `WriteDenied` comes back. The refusal is the document's line arriving at the dependent, visible from outside the program.

The count carries the other half. Four attempts across a real restart derive their rights four times, so a supervisor that read the file once and remembered it afterward would report fewer derivations than attempts. The cost of the whole property is one file read per attempt, and what it buys is that no running dependent's rights ever depend on how long its parent has been awake.

Witness: [`tools/caravan_rederive_witness.rish`](../tools/caravan_rederive_witness.rish), GREEN on metal, with both RED paths proven before the green was trusted. Handing the dependent the remembered line rather than the freshly derived one tripped `line_agrees` inside `spawn_slot`, refusing the widened line before a process started -- which is the wall `boot.rye` built, holding here. Deriving once before the loop and reusing it broke the per-attempt count in `run_plan`, which is the same claim stated in reverse.

## Why the Bytes Say What the Bell Cannot

Every conversation up to `rederive.rye` began at the server. The virtualiser asked, the client answered, and a dependent waiting on a channel already knew what the next bell would mean, because its own parent had scheduled the ask that caused it. `unprompted.rye` inverts that: a client writes an ask into the memory it owns and rings a server that asked for nothing.

The inversion raises the question the ring exists to answer. A doorbell carries no payload -- it is a count that went up -- so a server hearing a ring learns only that its peer did something. Guessing which something, from its own expectations, would put the schedule back in charge of the meaning. So `attend` hears, reads the region its peer writes, and lets what stands there decide: an ask addressed here it answers on the memory it owns, an answer it reports as an answer, and anything else it refuses by name. **Who spoke first is a fact of the shared memory, never of the bell.**

The run states that claim in a form a reader can check. One verb carries a client-first conversation and a server-first one over the same wiring, and the two outcomes differ only because the bytes differed -- three attending steps, two of them answering an ask. `serial_two_clients.bron` never changes; only the order of who writes first does, since each side already writes memory it owns and reads memory its peer owns.

What makes an unprompted ask trustworthy is the wall the declaration already stands. A client planting an ask in the server's own receive region is refused `WriteDenied` before a bell rings, so the region a message arrives on already names who wrote it, ahead of the first byte read. The bell says something happened; the grant says who could have made it happen; the bytes say what it was.

Witness: [`tools/caravan_unprompted_witness.rish`](../tools/caravan_unprompted_witness.rish), GREEN on metal, both RED paths proven before the green was trusted. Making `attend` look only for an answer -- classifying by expectation rather than by what stands -- turned the unprompted ask into `bytes differed` and stopped the client-first conversation dead. Dropping the heard-count check let the server attend a peer that had never rung, which is the `Unheard` wall stated in reverse.

One seam is named rather than assumed: this ring's `answer seen` report lives beside the shared outcome vocabulary in `carry.rye` rather than inside it, since `restart.rye` proves a partition over exactly the codes that vocabulary names today. A supervisor that ever runs both rings widens that partition deliberately.

## Why the Queue Says How Much, and the Bell Only Says Look

Every ring through `unprompted.rye` carried exactly one message at a time. A producer wrote at offset zero of a region and rang, so a second message written before the first was read would have quietly replaced it -- correct precisely while no more than one ask is ever outstanding, which is a schedule, and this arc has been retiring schedules one ring at a time.

`queue.rye` names the reason a bell cannot carry the rest. A doorbell coalesces: rings arriving before the receiver runs are indistinguishable from one, and a producer batching many asks behind a single ring is doing the efficient thing rather than a wrong one. So the ring count never answers *how many asks are waiting*. **A ring says something happened; how much happened is a fact of the queue.** Two indices in shared memory answer it -- a head counting asks ever written, a tail counting asks ever drained -- and a drain reads until the two agree rather than once per ring.

Ownership places those indices, which is the quiet finding of the ring. A producer's head must live in memory the producer writes; a consumer's tail must live in memory the consumer writes. The declaration already grants exactly that pair of regions per channel, so a queue spans both and needs no new wiring at all -- and neither side can move the other's number. A producer able to advance the tail could claim its asks were consumed; a consumer able to advance the head could invent asks nobody made. Both are refused `WriteDenied` at the wall the declaration already stands, and the producer still *reads* the consumer's tail freely, so progress is visible to the side that cannot forge it.

Order carries meaning one level in from `notify.rye`'s own. There the bytes were written before the bell, since a bell rung early sends a reader to look at nothing. Here the slots are written before the head, since a head raised early promises a consumer messages that have not landed -- and the head, rather than the bell, is what a drain believes.

Capacity is declared rather than hoped for. A producer reads the tail, computes what stands outstanding, and answers `QueueFull` rather than writing over an ask nobody has read, so a full queue is a refusal an operator can see instead of a message that silently went missing. A ring with nothing behind it answers `nothing new` -- a named success, since a ring did arrive and the honest count was zero.

The numbers state the claim: seven asks carried on three rings across three drains, three of them landing behind a single ring. Witness: [`tools/caravan_queue_witness.rish`](../tools/caravan_queue_witness.rish), GREEN on metal, both RED paths proven before the green was trusted. Driving the drain from the bell count rather than from `head - tail` carried one ask of three, and the producer caught it by reading the consumer's own tail standing at 1 against a head of 3. Dropping the capacity refusal let a fifth ask land in a four-slot queue, overwriting an unread one, and the next drain read a sequence number it never expected.

## Why the Region Names the Author, and the Bytes Never Do

Every ask in `queue.rye` came from one producer, so the question *who wrote this?* had a single answer and never had to be asked. A second client asks it, and `fanin.rye` answers it twice over.

Attribution comes first. A message is bytes, and bytes can say anything: `client_b` may write an ask whose text names `client_a` as its author, and no amount of reading that text will catch the lie. So the server never asks the bytes. It reads `tx_a`, and `tx_a` is a region only `client_a` may write -- the sibling holds no grant there at all and is refused `NotGranted` before a single byte moves. **The author of an ask is the domain that owns the region it arrived in**, and a byte-claim disagreeing with that region is refused `Misattributed` rather than believed. The server knows the true author and could simply overrule the claim; an ask that lies about itself is a fact an operator wants to see instead of one the server quietly repairs.

Fairness comes second, and it arrives without a single wrong byte. A server that empties one client's queue before looking at the next lets a busy producer delay a quiet one for as long as it keeps writing. A declared per-pass take answers it: one sweep draws at most `per_pass` asks from **each** stream, so a client sitting on a full queue and a client holding one ask are both served on the same pass, and the quiet one finishes first.

The numbers state the claim: seven asks from two producers carried on three rings across two sweeps of two streams, the busy client giving up two of its four while the quiet client finished. Witness: [`tools/caravan_fanin_witness.rish`](../tools/caravan_fanin_witness.rish), GREEN on metal, both RED paths proven before the green was trusted. Trusting the claimed author rather than the region carried the impostor's forged ask home as genuine. Spending one shared budget across the streams rather than a bound per stream let the busy client consume the whole pass, and the quiet client's single ask was served zero -- caught by that client reading the server's own ledger.

## Why a Stalled Peer Costs Its Own Stream Alone

`fanin.rye` bounded every sweep per stream, so a busy producer could never delay a quiet one. Every consumer in that ring kept reading. `stall.rye` asks what happens when one of them stops, and it is a different question entirely -- fairness divides attention among peers that are working, and says nothing about a peer that has gone silent.

The situation is plain. The server holds a queue at capacity for a client whose tail has not moved in passes, and another answer is ready to write. Three doors stand open, and only one of them is a system.

Blocking is the door that looks safest and is worst. A server that waits for a stalled tail to move hands one silent domain the power to stop every other domain it serves; a client that crashed mid-read, or simply went to sleep, takes the whole server down with it. That is the failure this ring exists to rule out, and the RED probe showed it plainly -- returning `QueueFull` for the whole pass on one full stream stopped the pass at `client_b` and never reached `client_a` at all, so a consumer with an empty queue was served zero by a peer it shares nothing with.

Refusing keeps every byte. The server writes nothing for that stream, reports the refusal, and moves straight on to the next one, which is served on the same pass. The stalled client loses nothing; the answer it never received is one the server declined to write, and an operator can read that.

Lapsing keeps moving. The server writes anyway, the oldest unread answers fall out of the window, and the consumer learns exactly how many it missed the moment it wakes -- because the head stands further ahead than the queue is wide, and that difference is the count. **A dropped answer is arithmetic here, never a silence.**

Which door a stream takes is declared per stream, and a pass naming fewer doors than it holds streams is refused rather than defaulted. A server that quietly picked a door for an undeclared stream would be making a policy decision the document never made, which is the one thing this arc has been retiring ring after ring.

Underneath both doors stands a wall the declaration already keeps. A server able to advance a consumer's tail could mark every lapsed answer read and leave nothing to count, so the loss would become invisible rather than named. It holds read alone on that region, and the attempt is refused `WriteDenied` before a byte moves. **The side that bears the loss is the only side that can report it drained.**

The numbers state the claim: twelve answers drained across three passes of six streams while one consumer slept, the reading consumer taking eight of eight on every pass, and the silent one waking to name the two it lost. Witness: [`tools/caravan_stall_witness.rish`](../tools/caravan_stall_witness.rish), GREEN on metal, both RED paths proven before the green was trusted. Dropping the window resync in the drain made the loss silent, and two layers caught it in turn: the bound assert fired first, and with that bound relaxed as well, the consumer read the answer standing in slot zero, found number 4 where it expected 0, and answered `bytes differed` -- a mismatch where a count belongs.


## Why a Chain Crosses Two Seams Without Waiting

Every ring before this one was a single hop wide. A domain either asked or answered, and the region it wrote said which -- `serve.rye` gave one server two clients, `fanin.rye` gave one server two producers, `stall.rye` gave it a consumer that stopped reading. In all of them, roles and domains stood in one-to-one correspondence.

`relay.rye` seats the first domain that holds two roles at once. `relay_virt` answers `client` and asks `backend` in the same run, and three questions open that no single hop ever poses.

The first is whether the two roles can be told apart, and the declaration is where they are. The relay reads asks on `ask_up` and answers on `answer_down` -- two different regions, both read-only to it, so an answer can never be mistaken for an ask by a server that guessed wrong about its own inbox. This is the fanin lesson raised one level: there the region named the author, here it names the role.

The shape itself is derived rather than declared. A region granted read-write to exactly one domain and read-only to exactly one other is a one-way street, and the direction is the grant's to state. Five such flows fall out of ten grants, and the single domain that spans two peers is the relay -- found by the document's own arithmetic, with no role word written anywhere. The RED probe proved the derivation is a real check rather than decoration: opening a back channel between the two ends made three domains span two peers, and the shape refused a chain with no single middle.

The second question is whether a chain deadlocks, and it cannot, for a structural reason. No verb in this ring waits. A client's ask has no answer on the pass it arrives, since the answer lives two hops away, so the relay forwards what is pending, rings the neighbor that will answer, reports the backlog standing behind it, and returns. The run proves it the hard way: the client asks a second time while nothing at all has been answered, and the relay forwards that new pair with four asks outstanding. The blocking RED probe made the cost plain -- a relay that waited until its backlog cleared stopped the second forwarding pass dead at `QueueFull`, with two asks in hand and the whole chain frozen behind it. **Forwarding is a pass, never a wait.**

The third question is what the isolation costs, and this is the finding worth carrying forward. `client` and `backend` share no channel and hold no grant on a single region in common, which is exactly what keeps a two-hop system from quietly collapsing into one -- the far end's attempt to write the near end's memory is refused `NotGranted` before any permission is even compared. Yet a client that shares no memory with the far end has nothing to attest it with. The author named in an answer reaches the client as a **claim it takes on the relay's word**, where a one-hop client could have taken it from the region the bytes arrived in. **Memory attests a neighbor; it cannot attest a stranger.** Everything past one hop wants a signature the bytes carry themselves, which is Kumara's work rather than Caravan's, and this ring names the seam honestly rather than papering it.

One wall keeps the origin honest in the meantime. A relay able to author the asks it forwards would make the origin in every ask its own invention, so it holds read alone on the region the client writes and the attempt is refused `WriteDenied`.

The numbers state the claim: four asks crossed two seams and came home, two of them asked while none stood answered, and every hop -- asked, forwarded, answered, delivered, taken -- settled at four. Witness: [`tools/caravan_relay_witness.rish`](../tools/caravan_relay_witness.rish), GREEN on metal, both RED paths proven before the green was trusted.

## Why a Ring Has No Vantage Point

Every declaration in this arc until now has had ends. `relay.rye` gave a chain a middle, and the client that only asks and the backend that only answers were the whole point of it -- the shape ran between two domains that each touched exactly one neighbor.

`cycle.rye` removes the ends. `alder` writes `ask_ab` and reads `ask_ca`, `birch` writes `ask_bc` and reads `ask_ab`, `cedar` writes `ask_ca` and reads `ask_bc`. Every domain is a middle, the flow graph closes on itself, and three questions open that no chain poses.

The first is whether a ring is derivable, and it is, twice over from the grants alone. In a chain, two domains span a single peer and those are its ends; here every domain spans exactly two, so nothing is an end -- **a ring is the shape with no ends.** And exactly one directed walk visits every domain once and returns where it began, searched out of the flow graph by a bounded backtracking walk, which gives the circulation order: alder to birch to cedar and home. Both halves are real checks rather than decoration, and the RED probes proved it. Reversing a single edge -- letting alder write `ask_ca` so cedar reads it -- leaves the grants looking much the same and closes the walk nowhere, and the search refused a declaration whose grants close on no single lap. Running the chain declaration `serial_relay.bron` through the same shape check found two domains spanning other than two peers and refused a shape with an end.

The second is whether a closed graph still settles, and it does, for the reason the chain settled: no verb waits. A pass moves what stands, rings the neighbor that carries it further, reports what it moved, and returns. The run proves it the hard way -- alder places a second pair while the first is still mid-lap, and all four asks travel the whole circuit and come home. What a badly ordered pass costs is worth naming precisely: a domain reading for its lap before its predecessor has rung hears an **unrung bell** and returns, so the cost of bad ordering is a wasted pass rather than a stopped ring. **Circular wait is a property of waiting, never of circles.**

An ask that travels a full lap arrives at the domain that wrote it, and that arrival has a signature. At one hop, the region an ask arrives in names its author and the bytes name its origin, and the two agree -- that is `fanin.rye`'s law. After a full lap they must disagree: bytes reaching alder from cedar, naming alder as their origin, are alder's own ask come home. **The disagreement is what a completed lap looks like**, and a homecoming refuses any ask still naming a stranger.

The third question is what the ring takes away, and this is the finding worth carrying forward. No domain holds a grant on every region, so no domain can total the lap it belongs to. alder reads three of the four regions, and the arc between the other two is refused `NotGranted` before any permission is compared. In the chain, the relay could read every hop and report the whole run from inside it; **a ring has no vantage point.** Only the parent outside the ring sees the whole, which is exactly what a supervisor is for. That fact follows from the ends fact rather than standing beside it: a domain reaching every region would have to touch every other domain, which makes a star, and a star has ends. The check stands anyway, since a wider declaration may someday find a way to violate it, and a guard that has never fired costs nothing.

One wall keeps the origin honest around the circuit. A passer able to author asks in its predecessor's region would make every origin its own invention, so it holds read alone there and the attempt is refused `WriteDenied`.

The numbers state the claim: four asks travelled a full lap and came home, two of them placed while the first pair was still travelling, and every arc settled at four. Witness: [`tools/caravan_cycle_witness.rish`](../tools/caravan_cycle_witness.rish), GREEN on metal, both RED paths proven before the green was trusted.

## Why a Safe Restart Is Also a Silent One

`cycle.rye` closed the ring and every domain in it ran to completion. A ring that only ever completes has proven nothing about the day one of its middles falls, and a middle is the only kind of domain a ring has. So `gap.rye` drops `birch` mid-lap, with asks standing in the arcs on either side of it, and asks what a lap owes a domain that was absent for part of it.

The reassuring half of the answer is the one `restart.rye` already taught, now read around a circuit. A lap owes a returned domain nothing at all, because the debt is written where the domain can read it. A region belongs to the declaration rather than to a process, so the asks alder placed stand exactly where they stood, the bell alder rang stands on the channel, and the arithmetic that says how many wait -- the inbound head above the onward head -- reads the same on the attempt after the fall as it would have on the attempt that fell. A middle that falls before it writes costs the ring one attempt and nothing else.

The finding is sharper. **Idempotence over bytes is what makes a restart safe, and it is also what makes a restart silent.** A step written to be safe to take twice finds, on its second taking, that there is nothing left to do -- and so it does nothing, including the one thing that was actually left undone. `birch` falls after writing its onward batch and before ringing `cedar`. The bytes are whole. The attempt that returns reads its arc, finds nothing pending, reports `nothing new`, and rings nobody. `cedar` hears an unrung bell, and the lap stands one arc short of home with every ask it was carrying safely on disk. Nothing was lost, and nothing arrives.

So the honest answer to whether a circuit with a hole in it settles is that **it waits at the hole, and what it waits on is the wake rather than the bytes.** The cure is to make the wake idempotent too, and `gap.rye` names the two readings rather than baking one in. Under `wake-when-moved` a pass rings its successor only when that attempt actually moved bytes, which is the strict reading a whole ring runs under, where nothing ever falls. Under `wake-every-pass` a pass rings whenever it completes, whether or not it moved anything. One line apart, and the same hole closes: **a bell rung twice costs a wasted pass; a bell never rung costs the lap.** Both readings run in the self-test, so the stall is proven rather than asserted.

A pass under either reading is held to where its arc **stands** once the move is done -- the onward head level with the inbound head, at the total the plan names -- rather than to how far this attempt moved it. A restarted step that measured its own progress would read a correct no-op as a failure. And every attempt, the first and the return after it, reloads the declaration from disk and derives the returning domain's line from that read, so a domain that comes back takes its rights from the document rather than from a parent's memory of it, exactly as `rederive.rye` asks.

The numbers state the claim: one fall before the write costing one attempt and two asks still home, the same fall after the write costing the whole lap at zero asks home, and that lap closing again at two under a wake that rings on every pass -- five attempts across it, each deriving its rights from five fresh reads of the declaration. Witness: [`tools/caravan_gap_witness.rish`](../tools/caravan_gap_witness.rish), GREEN on metal, both RED paths proven before the green was trusted.

## Why a Ring Has No Detour

Every hole `gap.rye` opened eventually closed. `decline.rye` leaves one open: `birch` falls on every attempt rather than on the first alone, spends what the supervisor allows it, and is **declined by name** -- a domain the ring will not get back. The question is what the rest of the circuit is entitled to do with a lap it can no longer finish.

The first answer holds the previous rung to its own bound. `wake-every-pass` mended a hole that closed by replacing a bell a fall had swallowed, and a domain that never completes a pass never reaches the line that rings. So the carry-on lap runs under that very reading and is unchanged by it: **a cure for a silent restart is no cure for an absent domain.** Running it proves that rather than assuming it.

The second answer is calm. The rest of the circuit may run, and it finds nothing. Under `carry-on` every domain behind the hole starts, hears the bell it was waiting on ringing zero times, and reports `Unheard` -- nobody hangs, nobody invents work, and nobody advances. A hole that stays open is announced by the same honest silence at every arc behind it. Under `halt` those steps never start, and the report names them skipped. **The choice is about what an operator learns rather than about what the ring achieves:** halting says where the circuit stopped, carrying on proves the rest of it healthy and every ask parked at exactly one place. The work is safe either way, because it stands on disk in a region that belongs to the declaration.

The third answer is the finding, and it is structural rather than policed:

**A ring has no detour, and the capability table refuses in two distinct ways -- by absence and by rights.**

`alder` reaches for the arc behind the hole, `ask_ab` onward to `ask_bc`, with two real asks standing in it, and is refused `NotGranted`: the declaration hands alder no word for `ask_bc` at all. `cedar` reaches for alder's own homeward arc, `ask_ca` onward to `taken`, and gets further, since it holds both regions -- then it is stopped at the claim with `WriteDenied`, because it holds `taken` at rights that read and never write. Neither refusal is a rule this module enforces. Both are the grants, read back by the dependent from the words it was handed. So the entitlement question closes cleanly: the circuit is entitled to run, to report, and to wait, and it is never entitled to reach around. Nothing had to forbid that, because nothing ever permitted it.

The numbers state the claim: two attempts spent and one decline, two steps never started under `halt` and two reporting `Unheard` under `carry-on`, two neighbors reaching around the hole and two refused, and zero asks home across it either way. Witness: [`tools/caravan_decline_witness.rish`](../tools/caravan_decline_witness.rish), GREEN on metal, both RED paths proven before the green was trusted.

## Why a Ring Is Repaired by Being Declared Again

`decline.rye` proved that no neighbor may reach around an open hole -- a ring has no detour, and the capability table refuses by absence and by rights. That answered what a *neighbor* may do, and left the sharper question standing. May the *declaration* draw the detour, naming a standby that legitimately holds the lost domain's regions, and what does a grant written for an absent domain cost the ring on every day the hole is closed? `standby.rye` writes both tempting versions out plainly and lets each refuse itself.

**A standby present beside the domain it would replace is a second writer.** [`serial_cycle_shadow.bron`](systems/serial_cycle_shadow.bron) gives `beech` exactly `birch`'s grants, so the ring already has a hand on the regions the day birch is lost. The refusal lands a whole layer earlier than any capability check. A directed region carries exactly one writer and exactly one reader; this document carries two of each, so there is no flow to derive, no shape to name, and nothing for a ring order to search. The cost of a detour drawn in advance is charged every day the hole is closed.

**A standby given regions of its own is a different shape.** [`serial_cycle_bypass.bron`](systems/serial_cycle_bypass.bron) answers that refusal honestly: `dogwood` gets its own arcs, every region keeps one writer and one reader, and the flow derivation is content. What falls away is the ring. alder writes to two successors and cedar reads from two predecessors, so alder spans three peers, and no single directed walk visits all four domains once and comes home. A ring with a spare route is not a ring with a spare route; it is a shape with a choice of laps, and `ring_order` answers null rather than picking one.

So the repair is a re-declaration, and it is the finding:

**A ring is repaired by being declared again, never by being routed around -- and the asks pay nothing for it, because a region belongs to the document rather than to the domain that was lost.**

[`serial_cycle_succession.bron`](systems/serial_cycle_succession.bron) names `beech` where `birch` stood and moves nothing else. The four regions are the ring's own, name for name and byte for byte, so the two asks alder placed before the loss stand exactly where it left them. Every attempt in this arc already reloads its document from disk and derives the dependent's line from that read, so handing a later step a later document is the ordinary act the ring has been performing all along. The standby takes the lost domain's grants unchanged, and four asks come home -- two of them placed before the domain carrying them was declined.

The succession is not free, and the cost sits at the seam rather than in the work. A channel carries the names of both its ends, so replacing a domain replaces its channels: `alder->birch` and `birch->cedar` are gone, `alder->beech` and `beech->cedar` stand new and silent at zero, and the ring alder already spent on birch is spent for good. **A standby inherits regions and never inherits a bell**, so the successor is woken again by name. That cost is proven rather than asserted: a probe that gave beech every one of birch's grants and never woke it by name heard its bell rung zero times and reported `Unheard`.

The numbers state the claim: one middle declined after two attempts, six fresh directed bells standing beside the ring's own six, and four asks home across the repair. Witness: [`tools/caravan_standby_witness.rish`](../tools/caravan_standby_witness.rish), GREEN on metal, both RED paths proven before the green.


## Why a Declaration Reaches a Domain Only at Its Spawn

`standby.rye` repaired a ring by declaring it again, and every swap it made happened between steps: one domain had returned, the next had not begun, and the supervisor stood alone with both documents in its hands. `inflight.rye` asks the sharper question -- may a ring be re-declared while a lap is *in flight*, and what does a domain still running under the elder document owe a successor already derived from the newer one?

The answer begins with something a supervisor cannot have. **A supervisor re-declaring mid-lap cannot know whether the domain it is replacing has finished.** Between the spawn and the reaping there is no outcome to read: the dependent may be mid-write, or it may have exited a microsecond ago and simply not been waited on. This module derives the successor exactly there, holding one unreaped dependent, and the ignorance is the permanent condition of the act rather than an accident of the test.

**So the rights of a running domain are frozen at its spawn.** A dependent takes its grants from the words it was handed, and those words were written from the document that stood when it started. [`serial_cycle.bron`](systems/serial_cycle.bron) spawns `birch`; before that dependent is reaped the run derives [`serial_cycle_succession.bron`](systems/serial_cycle_succession.bron), whose table has no `birch` in it at all; and birch carries two asks from `ask_ab` to `ask_bc` anyway, under grants the newer document has already retired. The domain the successor replaced carried the ask that came home.

**And a re-declaration governs from the swap forward.** The same table that could not touch the running birch refuses the next one absolutely: a step naming `birch` after the swap is turned away `UnknownDomain`, since a spawn derives from the document standing at that instant.

Those two halves give the finding:

> A declaration reaches a domain at the moment it is spawned, never after -- so a ring may be re-declared mid-lap, and the only documents safe to swap in are the ones that are safe under both readings at once, whether the replaced domain has finished or is still writing.

Exactly one property answers to both readings: the regions may not move. [`serial_cycle_moved.bron`](systems/serial_cycle_moved.bron) reads as a whole ring and renames one arc, so a domain still writing would fill a store nobody under the newer document ever reads, while a domain that had already finished would be harmed not at all. A supervisor cannot tell those apart, so it refuses the document rather than the risk -- `RegionsMoved`, mid-flight, with the dependent still unreaped.

What the swap does not carry is the ring itself. birch spent its ring on `birch->cedar`, a channel the succession no longer has, so the lap resumes only once the successor's side is woken by name -- the seam cost `standby.rye` named, now paid mid-lap. alder places two more under the newer document and rings `beech`, which finds four standing where it wrote none.

One further thing the round found by running it: a refusal at the swap refuses the *successor*, never the running dependent. The first cut returned the refusal straight from between the spawn and the wait, abandoning a dependent it had spawned under a document that permitted every word of it. The supervisor now reaps what it started before it reports why the newer document was turned away.

The numbers state the claim: one successor derived with one dependent unreaped beneath it, one step run to completion under a document that had already retired it, and four asks home with two of them carried by that retired domain. Witness: [`tools/caravan_inflight_witness.rish`](../tools/caravan_inflight_witness.rish), GREEN on metal, with the region guard proven load-bearing first -- disabled, the moved document read back as safe and the lap fell through to a bare outcome mismatch.

## Why Two Domains May Run at Once, and When They May Not

`inflight.rye` held one unreaped dependent and re-declared the ring around it. Every ring in this arc, that one included, ran its lap one domain at a time: spawn, wait, spawn the next. That is a schedule, and this arc has been retiring schedules one ring at a time. `concurrent.rye` asks whether two domains of one ring may run at the same moment, and the answer turns out to belong to the document rather than to the supervisor.

**Two domains may run together exactly when they share no region and no channel.** A region held by two running dependents is a store one may be writing while the other reads it, and neither can tell from inside. A channel joining two running dependents is a doorbell one may be ringing while the other clears it, which is the same hazard one layer up -- a bell is state too. Both tests read the declaration alone, and neither is declared anywhere.

**Both halves are needed, because a channel is declared apart from the grants.** [`serial_cycle_wide_wired.bron`](systems/serial_cycle_wide_wired.bron) keeps every region and every grant of the ring and adds one line, `channel alder cedar`, so that pair shares no memory at all and still may not run together. Its mirror, [`serial_cycle_wide_mute.bron`](systems/serial_cycle_wide_mute.bron), shares a small store in silence with no channel over it -- a pair the channels alone would have cleared.

**The two tests separate only outside a ring, and the separation costs the shape.** A region joining two domains makes them neighbors, so inside a true ring region-adjacency and channel-adjacency coincide and either test alone would answer correctly. The mute document earns its silent sharing by ceasing to be a ring, exactly the price [`serial_cycle_bypass.bron`](systems/serial_cycle_bypass.bron) paid for a spare route. So the pair of tests is what a supervisor keeps, since the shape it is handed may not be a ring at all.

**How much concurrency a ring permits is arithmetic rather than policy.** In a ring every domain is adjacent to two others, so the pairs that may run together are the non-adjacent ones -- `n * (n - 3) / 2` of them. A ring of three has none, which is why [`serial_cycle.bron`](systems/serial_cycle.bron) was entirely serial and nothing in this module could have made it otherwise. A ring of four has two, and [`serial_cycle_wide.bron`](systems/serial_cycle_wide.bron) spends both in one lap: cedar carries the first pair of asks onward while alder places the second, then dogwood carries the first pair home-ward while birch moves the second.

**And a supervisor holding two unreaped outcomes owes both a reaping before it reports either.** `inflight.rye` learned that rule with one dependent standing -- an abandoned dependent is a leak dressed as a safety check. With two in flight it gains a second edge: the first outcome may be a refusal, and reporting it the instant it arrives leaves a sibling running behind the verdict. The unsafe reading stands in the module as a named control, so the safe one is proven against it rather than merely asserted.

The numbers state the claim: a ring of three admitting zero pairs and a ring of four admitting two, ten dependents across eight stages with two of them holding a pair at once, a peak of two unreaped and none reported behind, and four asks home. Witness: [`tools/caravan_concurrent_witness.rish`](../tools/caravan_concurrent_witness.rish), GREEN on metal, with both guards proven load-bearing first -- the region test disabled waved the mute pair through, and the channel test disabled waved the wired pair through.

## Why the Widest Set Is Derived, Rather Than Chosen

`concurrent.rye` answered the pair question and left the next one standing. A supervisor with three slots wants the widest **set** it may run, and a pair is only the smallest such set. `cohort.rye` derives it.

**A set may run together exactly when every pair in it may.** Both hazards are relations between two domains -- a region one may write while the other reads, a bell one may ring while the other clears -- so a set carries no hazard its pairs do not already carry. The pair predicate is reused whole rather than restated one size up.

**A ring has no room for three.** Its widest set is `floor(n / 2)`: one at three, two at four. A non-adjacent triple wants a ring of six, past the four dependents one supervisor holds. So the shape with room for three is not a ring at all -- it is the most ordinary shape in this tree, one server and its clients. `serve.rye` proved two clients never hear each other's bell, and [`serial_three_clients.bron`](systems/serial_three_clients.bron) turns that isolation into room a supervisor can spend.

**The widest set is not what you get by taking the first domain that fits.** In that document the virtualiser is declared first and touches every client, so a first fit takes it and runs one dependent where the widest set runs three. The first fit is never unsafe; it is simply narrow, threefold, on the plainest shape in the tree -- which is exactly why the derivation is exhaustive.

**The cost of exhaustive is named rather than hidden.** Weighing every subset costs `2^n`, and `n` is bounded at the roster bound, so the search is bounded at 256 subsets by the same constant. A supervisor bounds its roster; it never bounds its search and then calls the narrower answer the widest.

**And the room comes from privacy, which costs a shape verdict.** Each client keeps a tail region no other domain may reach, and a region only one domain can reach carries no direction at all -- so the declaration answers `no directed flow to derive` rather than naming a ring. That is the same kind of price the mute document paid for silent sharing, stated rather than hidden.

The numbers state the claim: sixteen subsets weighed to derive a widest set of three where the first fit takes one, nine dependents across five stages with two of them holding three at once, a peak of three unreaped and none reported behind, and six asks home. Witness: [`tools/caravan_cohort_witness.rish`](../tools/caravan_cohort_witness.rish), GREEN on metal, with the greedy reading carried in-module as a named control so the derivation is proven against it rather than merely asserted.

## Why Rolling Never Creates Room

`cohort.rye` spent the widest set and reaped every stage whole, which left the barrier standing: a stage holds a slot empty while a dependent that could have used it waits behind the line. `rolling.rye` refills instead, and finds that the gain is smaller and stranger than it looks.

**Reaping is not reporting.** The rule `cohort.rye` proved was never *reap everything before you reap anything*; it was *let no verdict leave while a sibling still runs*. A rolling supervisor keeps that rule exactly by splitting the two acts -- reap eagerly to free a slot, hold every verdict until the queue drains. The reading that judges on the reaping stands in the module as a named control, and it re-opens the very hazard the rung before it closed, two dependents deep.

**A rolling supervisor never reorders, so the order bounds the room.** Admission is head-of-line only: the head enters when a slot is free and it is clear against every domain still running. Reaching past a blocked head for a later item that happens to fit would reorder the lap, and in these documents order is meaning -- an ask is placed before it is passed, and passed before it comes home.

**So rolling never creates room; it stops the supervisor from being the reason the room goes unspent.** The waste is counted by its cause. Over the ordered lap the two disciplines wait the *same two turns*: staged calls them barriers, rolling calls them the order, and the slot stands empty either way. Rolling converted no waiting into work there. What it did was prove who was doing the waiting.

**Where the order agrees with the isolation, the whole of it converts.** Three clients placing twice each into the regions they own touch nothing of one another, so the rolling supervisor fills a freed slot at once and stands idle zero turns where staging stands idle two -- the same document, the same bound of three, the same six dependents run to the same end.

**And the two readings differ in one line.** Both reap one dependent per turn; rolling may fill whenever a slot is free, staged may fill only an empty table. A difference in the report is therefore a difference in the discipline rather than in the program. The honest limit of hosted ground is named beside it: a supervisor waits on a dependent it can name, so it reaps the eldest, and a long-running eldest holds a slot its younger siblings have already freed.

The numbers state the claim: two idle turns either way over the ordered lap -- two by barrier staged, two by order rolling -- with six asks home under both at a peak of three; two turns idle staged against zero rolling where the order agrees; and a refusal that strands two dependents under the loose reading and none under the held one. Witness: [`tools/caravan_rolling_witness.rish`](../tools/caravan_rolling_witness.rish), GREEN on metal.

## Harvest -- readiness converts a slot, never a domain

`rolling.rye` refilled a slot the moment a dependent finished, and named its own honest limit plainly: a hosted supervisor waits on a dependent it can name, so it waits on the eldest, and a long-running eldest holds a slot its younger siblings have already freed. `harvest.rye` asks whether being *told* which dependent finished converts any of that waiting.

**A supervisor can be told.** A bounded no-hang sweep across the whole table asks the ground which dependents have already exited, so a turn reaps a dependent that is ready rather than the dependent that is oldest. Both readings sweep and both wait exactly as long, which is what makes their numbers one comparison rather than two programs disagreeing; only the choice differs.

**Readiness converts a slot, never a domain.** The head enters when a slot is free *and* it is clear against every domain still in the table. Reaping the ready dependent frees a slot sooner; it removes a domain only when that domain is the one the head was waiting on. So over the ordered lap, where the virtualiser conflicts with all three clients at once, both readings stand idle the same two turns and six asks come home either way -- readiness converts nothing at all. Give one dependent a deliberate quarter-second linger and the picture inverts: the eldest-first reading blocks on it while a sibling that has already exited holds the very slot the head is asking for, and readiness takes that slot at once. One idle turn becomes zero, over one document and one bound of three.

**The linger is the whole of the conversion, and the probe proves it.** With the linger set to zero the dependents of the stagger lap finish in roughly the order they were spawned, and the readiness reading stands idle exactly where age does -- the check goes RED. Alike dependents make the question unmeasurable, which is why the stagger is deliberate, named, and handed to each dependent as one extra word that the shared dependent entry never sees.

**Reaping out of order keeps every rule the rung before it proved.** A verdict still waits for the whole queue to drain, so nothing leaves while a sibling runs, and every outcome is judged against the expectation its own item carried -- the judging never depended on reap order.

The numbers state the claim: two idle turns by age and two by readiness over the ordered lap with six asks home at a peak of three; one idle turn by age against zero by readiness over the stagger lap, with five of six dependents reaped out of order and the run finishing a shade sooner on the wall. Witness: [`tools/caravan_harvest_witness.rish`](../tools/caravan_harvest_witness.rish), GREEN on metal.

## Overtake -- a document that names its regions has already named its lawful order

`rolling.rye` admitted head-of-line only and named its reason plainly: reaching past a blocked head would reorder the lap, and in these documents order is meaning -- an ask is placed before it is passed and passed before it comes home. `harvest.rye` then answered which dependent a turn reaps. `overtake.rye` answers the question both of them left standing: may a supervisor look past a blocked head at all?

**It may, and the document already says when.** The order a queue is written in carries two different things at once, and only one of them is meaning. Where two items touch a region in common, their order is the arc itself. Where they touch no region in common, the order between them is incidental -- the queue had to write one of them first, and either first is the same run. So the test for a lawful pass is *derived* from the declaration rather than added to it, which is `cohort.rye`'s lesson one turn further on: the widest set is derived, and so is the lawful order. Nothing new is declared, and that is the finding.

**Isolation and order are two questions, kept apart.** Whether two items may run at the same instant is `rolling.admissible`, unchanged, and it refuses a domain beside itself. Whether one may run *before* another is `share_a_hop`, and it never asks which domain an item belongs to at all. A domain may not stand beside itself, yet an item of another domain touching none of its regions may pass it freely -- and the difference between those two sentences is the whole of the room this rung finds.

**Overtaking converts a slot the order was holding, never one the shape holds.** Over the ordered lap it converts nothing: not one pass is lawful, since every candidate is refused either by the running table, the virtualiser touching all three clients, or by a region it shares with the head. Over a lap whose head blocks on its own domain it converts the whole of it -- a head-of-line supervisor stands a table two-thirds empty while two items of other domains, sharing not one region with it, wait behind the line.

**The unchecked reading is carried as a named control and breaks on metal.** It keeps the isolation exactly and drops only the order test. Handed a lap where a taker sits behind its own passer, it takes first, the home hears no bell that was never rung, and the run refuses. Faster and wrong, proven rather than argued. The probe reaches further still: drop the order test from the *checked* reading and the ordered lap itself refuses, so its zero lawful passes is real work rather than an absence of candidates.

The numbers state the claim: nine slot-turns unspent under both readings over the ordered lap, with zero lawful passes and six asks home either way; two slot-turns unspent in line against zero overtaking on the self-blocking lap, with two lawful passes reaching two items back, the same four dependents and the same peak of three. Witness: [`tools/caravan_overtake_witness.rish`](../tools/caravan_overtake_witness.rish), GREEN on metal.

## Commute -- a shared region is a hazard only where someone may write it

`overtake.rye` derived a lawful order from the declaration and kept two questions apart: whether two items may run at the same instant, and whether one may run before another. Both asked the same thing of the document -- which regions does each side touch -- and both stopped there. `commute.rye` asks what the grants say past that point.

**They say who writes.** Every grant in every declaration this arc has read carries a permission beside its region, and a region held read-only by two domains is a fact they agree about rather than a hazard between them. Neither can see the other's hand in it, because neither has a hand. So a shared region conflicts only where at least one of the two sides may write it -- and that sentence is true in *both* rooms. Nothing new is declared, again: [`systems/serial_three_clients_menu.bron`](systems/serial_three_clients_menu.bron) adds the one thing an ordinary server has that the elder shape never carried, something published once and read by everyone, and adds no new kind of word to say it. The direction was in the grants from the first declaration this arc ever read.

**One refinement, two rooms, and the write closes exactly one of them.** Over the reading lap, where nobody writes what everybody holds, direction converts the whole of it: a test that counts any shared region as a hazard holds the table at one dependent, while reading the grants fills it to three. Over the published lap, whose head writes the very region the items behind it read, the order half converts nothing -- the publisher's write orders every reader behind it -- and the isolation half still converts, because two readers may hold the machine together even where no pass between them is lawful.

**The control keeps direction and spends it too freely.** `reads_free` orders a pair only where *both* sides may write, which reads a write-then-read pair as commuting -- and that pair is the arc itself, the passer writing `back_b` and the taker reading it. Handed a lap where the taker sits behind its own passer, the control takes first, the home hears no bell that was never rung, and the run refuses. The probes reach further: run the reading lap by region under the fine reading's own checks and it reds at six slot-turns, so the conversion is real work; run the published lap under `reads_free` and two items pass a head that writes what they read, so its zero passes is a refusal earned rather than an absence of candidates.

**`gap.attempt` gained one word for this rung.** `peek` reads an index and changes nothing, which the supervised path had no way to say -- `place`, `pass`, and `home` each write something before they finish. The three verbs a ring under fall asks are untouched, and the peek answers exactly what `cycle.rye`'s own peek answers.

The numbers state the claim: zero pairs of these four domains may run at once by region and three by grant; six slot-turns unspent by region against zero by grant over the reading lap, at a peak of one against three, with two lawful passes reaching two items back and four dependents run to the same end; zero lawful passes under both readings over the published lap, with the isolation half still converting two slot-turns of six. Witness: [`tools/caravan_commute_witness.rish`](../tools/caravan_commute_witness.rish), GREEN on metal.

## Intent -- a grant is a ceiling, and a hop is an act

`commute.rye` read the permission beside each region and separated two rooms with it. That refinement reads the document and stops, and the document speaks in ceilings: a domain granted `rw` on a region holds the right to write it for as long as it runs, so every reader behind it waits -- even on a turn where the writer only looks. `intent.rye` lets an item say what it will do this turn, and never takes it at its word.

**The word is read twice, in two different rooms.** Each queued item carries one letter per hop -- `r` for a hop it only reads, `w` for one it writes. The supervisor *schedules* by those letters, so two items sharing a region neither writes this turn may be reordered though the grants would have ordered them. And it *hands them out as the line*: the dependent's capability words are narrowed to exactly what it declared, read alone on a region it holds `rw` yet only reads this hop. So an item that writes past its own word meets a refusal from the mechanism rather than a rebuke from the supervisor. The second reading is what makes the first one safe.

**The word may narrow a grant and never widen one.** The effective write is the grant *and* the word, in that order, so an item declaring `w` on a region the document grants it read-only writes nothing and orders nobody. Trust flows one way only, and the ceiling still rules.

**The boot's own check wanted equality, and safety only ever wanted a ceiling.** `boot.line_agrees` asks that a handed line *equal* the declaration, which is exactly right when the line is the derivation -- and refuses a narrowed line for being too careful. `boot.line_within` is the honest reading for a narrowed line: every right on it is a right the document grants, and none exceeds it. Equality implies it; a line that widens a right fails both. `cohort.spawn_one_extra` keeps the strong assert for every rung that hands a derived line, and `cohort.spawn_one_within` carries the ceiling for this one, so neither guarantee was traded for the other.

**One room converts, and the other is closed for a reason worth naming.** Over the ceiling lap, whose virtualiser holds `rw` on the published region and only looks at it, reading the act converts the order half whole: no lawful pass at all by grant against two by act, reaching three items back, the table filled to three where the grants held it at two. The isolation half converts nothing here, and the document says why -- a channel joins two domains at every instant they both run, and a bell may ring at any moment of a hop, so a per-hop word narrows what a dependent touches and narrows no standing joint at all.

**The control believes the word without handing it over.** `trusted` schedules by the same letters and hands the full derived line. Given an item that declares `r` on a region it then writes, the write lands, the dependent answers `carried` where its own declaration said `WriteDenied`, and the run refuses -- while the narrowed line refuses the write itself. The second probe reaches further: remove the narrowing under the act's own reading and the lie lap reds identically to the control, which proves the narrowing is the whole of the safety rather than an ornament on it.

The numbers state the claim: the virtualiser holds seven capabilities and is handed one, read alone; six slot-turns unspent by grant against three by act over the ceiling lap, zero lawful passes by grant against two by act reaching three items back, five dependents run to the same end under both at a peak of two against three; and the undeclared write meeting `WriteDenied` from the dependent's own word. Witness: [`tools/caravan_intent_witness.rish`](../tools/caravan_intent_witness.rish), GREEN on metal.


## Phases -- a turn cut into phases keeps an order its regions never name

`intent.rye` let an item say what it will do this turn and never took it at its word. That refinement reads one item whole, so a hop's letter describes the item's *whole* turn. An author who wants a finer grain has one honest move left: cut the turn into smaller items, each naming one hop and declaring one letter. `phases.rye` makes that cut safe.

**Cutting is safe only once the queue can see the cut.** Two phases of one turn that share no region read, to every rung before this one, as two unrelated items -- `overtake.share_a_hop` finds nothing in common, so nothing orders them, and a lookahead may admit the second while the first still waits. The author wrote the order; the regions never carried it; so the supervisor breaks it wherever the two footprints happen to miss each other.

**The link is a fact the queue already holds.** Each phase names the turn it belongs to, and phases of one turn keep the order they were written in, absolutely. The declaration grows no second dialect: the document still speaks in ceilings, the item still speaks in letters, and the link speaks about the *queue* -- which is the only place authorship has ever lived. `plan_is_ordered` reads the cut once at the door, so a turn whose steps arrive shuffled is refused rather than kept faithfully in the wrong order.

**The concurrency half needs no new word, and the cut is why.** Two phases of one turn share a domain, and `commute.admissible` already refuses to stand a domain beside itself. So the link is asked in the order room alone; the isolation room had closed this door before the cut was ever made.

**What the link costs, named plainly.** A link is a constraint, so it can only take passes away, never add one. Over the cut lap the act reading takes the one pass that runs a turn's second phase ahead of its first, and the linked reading declines exactly that pass -- the same five dependents reach the same end, at a peak of one where the acts reached two. Safety first, then the slot.

The numbers state the claim: one phase admitted out of turn by act against zero linked; one lawful pass by act against zero linked; five dependents run to the same end under both, at a peak of two against one. Both RED paths were proven on metal first -- remove the link from `items_contend` and the cut read straight reds at two phases of one turn reading as free to swap; hide the link from the choosing alone and the linked run's own `fill_table` invariant fires, so the assert saying a linked reading never runs a turn's phases out of order is load-bearing rather than decorative. Witness: [`tools/caravan_phases_witness.rish`](../tools/caravan_phases_witness.rish), GREEN on metal.

## Fence -- a phase follows a prefix of its turn, and a prefix is one number

`phases.rye` made the cut safe by holding a turn's phases in the order they were written, absolutely. That order is *total*, which is stronger than most turns need: a turn whose middle phases are genuinely independent pays for an order it never asked for, and the supervisor holds a phase behind a sibling that has nothing to do with it. `fence.rye` lets the author say how much of the turn each phase actually follows.

**The honest refinement looks like a graph, and a graph is what a queue may not grow.** Let a phase name the phases it depends on and the queue stops being a queue -- every admission would walk edges, close them transitively, and answer a question whose cost climbs with the turn. A supervisor that must walk a graph to admit one dependent is a different machine from the one this arc built.

**A prefix is the shape that fits.** A phase names one number: how many leading phases of its own turn it follows. `after = step` is the link exactly as `phases.rye` left it, `after = 0` frees a phase of its siblings entirely, and anything between is the author naming where the seam really is. The relation this makes is transitively closed *by construction*, so nothing is ever walked -- a phase at step `i` orders a phase at step `j > i` exactly when `i < after_j`, one comparison, and the closure needs no computing because a prefix already holds every prefix inside it.

**A fence at its own step is the link, exactly** -- proven pair by pair over the whole lap, so the elder reading is a fence rather than a rival to it.

**What the fence buys and what it refuses, in one lap.** A fence can only ever stand between two readings already measured: it takes back passes the total order refused, and it refuses passes the regions alone would have taken. The fenced lap carries one of each -- a phase peeking `menu` under a fence of zero, free to pass its blocked sibling, and a phase peeking `back_b` under a fence of two, held behind both.

The numbers state the claim: **2 phases run past their turn by act, 1 fenced, 0 linked; the fence broken 1 time by act and 0 fenced; 2 passes by act, 1 fenced, 0 linked; slots unspent 7 by act, 8 fenced, 10 linked** -- the fence sitting exactly between, which is the whole finding in one number. Six dependents run to the same end under all three. Both RED paths were proven on metal first: drop the fence from `items_contend` and the fence read straight reds at a phase inside a named prefix being free to pass it; keep the fence and hide it from the choosing alone, and the fenced run's own `fill_table` invariant fires, so the assert saying a fenced reading never runs a phase past the prefix it named is load-bearing rather than decorative. Witness: [`tools/caravan_fence_witness.rish`](../tools/caravan_fence_witness.rish), GREEN on metal.

## Mask -- a phase names the siblings it follows, and a turn closes them once

`fence.rye` let a phase say how much of its own turn it follows, and it said it in one number. That prefix is transitively closed by construction, which is exactly why it costs nothing to read -- and exactly what it cannot express. **A prefix must reach its farthest dependency, so it swallows every hole on the way.** A phase genuinely free of step 0 yet bound to step 1 has to name both or neither, and the author who knows better has no way to write it down.

**The honest shape is a set, and the fear was that a set is a graph.** It is -- yet a turn is small. `max_queue_len` is sixteen, so every phase a turn may hold fits inside one machine word, and the set a phase names is one `u32`. That changes what the closure costs: rather than walking edges at every admission, the queue **closes the whole plan once**, at the door, in a single forward pass over at most sixteen steps, and every admission after it is one bit test -- the same constant the prefix had.

**A full mask is the fence, and the link, exactly** -- proven pair by pair over the whole lap under all three readings, so this rung generalizes its elders rather than rivalling them. And **a prefix survives the closing exactly**, because filling a mask in only ever adds bits below its highest, which leaves the fenced reading stable under the close.

**A turn cut inside one domain could never show this**, and the elder rungs' laps are exactly that: two phases of one domain never stand at one instant, so isolation already runs them in the order they were written and no reading of authorship can loosen it. Authorship earns its keep on a turn that **spans domains** -- a request placed, read back, answered -- which is the first lap on which a fence and a mask can differ at all. The masked lap's cut turn runs across three domains, with step 3 naming step 2 alone and skipping step 1 entirely.

**And the run turns out never to need the closing.** Every bit the closing adds is reachable through a sibling the phase named directly, so a phase can only be passed while a direct namer of its own still waits -- the queue's own discipline carries transitivity by induction, and skipping the close changes no admission on this lap. The closing is what makes the *pairwise* reading honest, which is worth its one pass at the door: a supervisor answering *do these two hold each other?* must answer for the order the author implied, not merely the edges written down.

The numbers state the claim: **2 phases run past their turn by act, 2 masked, 1 fenced, 0 linked; the mask broken 1 time by act and 0 masked; the implied prefix broken 1 time by act, 1 masked, 0 fenced; 3 passes by act, 3 masked, 2 fenced, 1 linked; slots unspent 4 by act, 5 masked, 6 fenced, 6 linked** -- the mask standing strictly between the act reading and the fence, which is the whole finding in one number. Seven dependents run to the same end under all four. Both RED paths were proven on metal first: drop the mask from `items_contend` and the mask read straight reds at a phase inside its own closed mask being free to pass it; keep the mask and hide it from the choosing alone, and the masked run's own `fill_table` invariant fires at [`mask.rye:578`](mask.rye), so the assert saying a masked reading never runs a phase past the siblings it named is load-bearing rather than decorative. Witness: [`tools/caravan_mask_witness.rish`](../tools/caravan_mask_witness.rish), GREEN on metal.

## Precede -- a turn may name a turn, and the plan closes them once

`mask.rye` let a phase name the exact siblings of its own turn it follows, held that set in one machine word, closed the plan once at the door, and kept every admission after it at one bit test. Every reading in the arc up to there orders phases *inside* one turn and reads two turns by their regions alone. **A turn that must follow another turn had no word for it at all.**

**A turn is the same small thing a phase's siblings were.** A queue holds at most `max_queue_len` phases, so it can never cut its work into more than that many turns -- sixteen, which fits the same `u32` a sibling mask fits. So a turn names the turns it follows as one word, the plan closes those names once in a single forward pass, and a supervisor asking whether two phases of two turns hold each other answers with one bit test. **The graph a phase was spared is spared one tier up**, for the same reason and at the same price.

**Direction is what rules out a cycle without a walk.** A turn may name only turns numbered below it. That one authoring rule, read once at the door, makes every cycle impossible by construction -- so the closing needs no visited set, no stack, and no second pass: walking turn numbers upward, every turn a turn names is already closed by the time it is read. A plan reaching sideways or backward is refused rather than run. Beside it, **a turn speaks with one voice**: every phase cut from one turn carries that turn's names, and a plan whose phases disagree is refused, so the order across turns stays a fact about turns rather than a per-phase opinion that could contradict itself.

**An empty turn mask is the sibling mask, exactly** -- proven pair by pair over the whole lap, so this rung generalizes `mask.rye` rather than rivalling it, the same way a full sibling mask was the fence and the link.

**The cost is named rather than hidden.** A cross-turn order is a constraint, so it can only ever take passes away. This rung buys back no slot; what it buys is an order that was previously unwritable, and a supervisor that keeps it -- safety first, then the slot, in TAME order.

The numbers state the claim: **the preceded lap breaks a named turn 2 times by act, 2 masked, 0 preceded; passes 3 by act, 3 masked, 1 preceded; slots unspent 4 by act, 4 masked, 6 preceded** -- the whole finding in three lines, the gain and the price each on its own. Seven dependents run to the same end under all three. Both RED paths were proven on metal first: drop the turn order from `items_contend` and the pure read reds at a phase inside a named turn being free to pass it, caught in the happy zone before a single dependent starts; keep the order and hide it from the choosing alone, and the preceded run's own `fill_table` invariant fires at [`precede.rye:616`](precede.rye), so the assert saying a preceded reading never runs a phase past a turn its turn named is load-bearing rather than decorative. Witness: [`tools/caravan_precede_witness.rish`](../tools/caravan_precede_witness.rish), GREEN on metal.

## Arrange -- a plan may be written in any order, and the queue seats it

`precede.rye` let a turn name the turns it follows and closed those names once at the door. Every reading in the arc up to there -- act, linked, fenced, masked, preceded -- takes the queue's **written sequence** as given, and only ever loosens or tightens which pairs of it may be swapped. So a plan whose phases are written in an order its own names forbid is carried faithfully into a run that cannot honor it, and the first sign of trouble is an invariant firing mid-flight, with dependents already started.

**The sequence is a claim, and a claim may be checked.** A plan is *seated* when no phase stands before a phase of a turn it names. That is one bounded pass over pairs, read at the door, and it turns a mid-run panic into a named refusal -- `PlanUnseated`, answered before a single dependent starts. Safety first, in TAME order.

**And a checkable claim is usually a derivable one.** Every fact the seating needs is already written down, so the queue derives a lawful sequence rather than trusting the one it was handed. `arrange` seats the earliest-written phase nothing unseated still holds, again and again, so the author's order survives everywhere the names permit and moves only where they demand it.

**Direction is why the seating never stalls.** A turn names only turns numbered below it, and a turn's steps keep the order they were written in, so among the phases still unseated the one with the smallest turn number -- earliest written on a tie -- is held by nothing. The same authoring rule that spared the closing a graph spares the seating one: no visited set, no back-tracking, no second pass.

**Arranging moves phases and never touches a name.** The output is a permutation of the plan exactly as its author wrote each phase -- the same tasks, turns, steps, and masks. What changes is only where each one stands. And **a seated plan arranges to itself, exactly**, phase for phase over the whole lap, so this rung generalizes `precede.rye` rather than rivalling it.

**What it buys, and what it costs, named plainly.** Arranging buys back no slot and refuses no pass: handed a lawful sequence it is the identity, and handed an unlawful one it recovers precisely the run the author would have gotten by writing the phases out by hand. What it buys is that the author no longer has to. The price is one bounded seating at the door -- at most `max_queue_len` squared pair tests over sixteen phases -- paid once, before any dependent starts.

The numbers state the claim: **a plan written against its own names is refused at the door with 0 dependents started; the arranged run breaks 0 named turns; 1 pass written by hand against 1 arranged; 6 slots unspent against 6; 7 dependents to the same end under both orders.** Both RED paths were proven on metal first -- remove the seating check from the door and the elder invariant fires at `caravan/precede.rye:615` with dependents already in flight, and hide the turn mask from the seating and the pure read reds at the derived order failing to recover the one the author wrote. `caravan/arrange.rye` + `tools/caravan_arrange_witness.rish`.


## Arrive -- a phase may arrive after the plan is seated

`arrange.rye` derived the sequence a plan's own names imply, so an author no longer writes the lawful order by hand. Every rung in this arc up to there reasons over a queue handed **whole** before the first dependent starts: the door reads the plan once, seats it once, and the supervisor spends what it was given. Work that shows up after the plan is seated had no door at all -- the only honest answer available was to seat the whole plan again from the top.

**An arrival is a claim about one phase, so it costs one pass.** A phase may join a seated plan at the tail exactly when three facts hold, and all three are readable in a single walk: no phase already placed names the newcomer's turn, the newcomer's step is the next step its turn has open, and a turn already standing says the same thing about what it follows as the newcomer does. So an arrival spends at most `max_arrival_tests` tests where a seating spends `max_seating_tests` -- the queue's length against its square.

**A refusal is a name, never a surprise.** A newcomer some placed phase was waiting for would have had to stand *ahead* of work already granted its place, so the door answers `ArrivalUnseated` rather than quietly re-ordering a plan someone is already counting on. And the refusal names a real order rather than a shy reading: the same phase arriving *before* its waiter is welcome at the tail.

**A plan grown one arrival at a time is the plan written whole.** Handed its own phases in order, one at a time, the growing plan reproduces the author's plan exactly -- phase for phase, name for name -- and it seats to itself, so this rung generalizes `arrange.rye` rather than rivalling it, the same way a seated plan arranged to itself and an empty turn mask was the sibling mask.

**The limit is named plainly.** What this rung answers is whether a phase may join a plan and what the answer costs; the arrivals are weighed at the door, before the run begins. Carrying an arrival into a supervisor with dependents already in flight is the next rung's question, and this reading is what it will stand on.

The numbers state the claim: **six arrivals cost at most 96 tests against 1536 to seat the plan again each time; a newcomer a placed phase was waiting for is refused at the door with 0 dependents started; the grown run breaks 0 named turns; 1 pass handed whole against 1 grown by arrival; 6 slots unspent against 6; 7 dependents to the same end under both hands.** Both RED paths were proven on metal first -- let the door stop noticing who was waiting and the pure read reds in the happy zone, and silencing that read as well fires the run's own invariant at `caravan/arrive.rye:341`, so `assert(plan_is_seated)` is load-bearing rather than decorative; let the door stop checking a turn's step order and the pure read reds at a phase skipping the step its own turn had open. `caravan/arrive.rye` + `tools/caravan_arrive_witness.rish`.


## Enlist -- a phase may join a run already under way

`arrive.rye` opened a door for work that shows up after a plan is seated, and it named its own limit plainly: the arrivals are weighed at the door, before the run begins. Every rung in this arc, that one included, hands the supervisor a queue whose last phase is known before its first dependent starts. A phase that shows up while dependents are in flight had no answer at all -- only a refusal to begin, or a run torn down and seated again from the top.

**The reading carries over whole, and that is the finding.** The three facts `arrive.rye` reads -- nobody placed waits on the newcomer's turn, its step is the next one that turn has open, and a turn already standing says one thing about what it follows -- are facts about *the phases a run was ever handed*, taken or waiting alike. Read against that, they mean at the tenth dependent exactly what they meant before the first. So the mid-run door needs no new refusal at all; it needs a memory, and an enlistment costs `max_enlist_tests` -- one walk of the record, exactly what arriving at the door costs.

**What a run must never do is forget what it spent.** A supervisor that reads only the work still waiting has lost every phase it already ran, and the same reading turns silently wrong: a phase rejoins after it has come home and after the turn that names it has started, nothing visible waits on it, and it stands behind its own follower while `out_of_precede` reads zero. This rung keeps the whole record for exactly that reason, and it measures the difference rather than asserting it -- the same newcomer refused by name against a record of six, welcomed back by the very same reading over the four still waiting.

**A newcomer takes the tail, so nothing already granted moves.** Every dependent started before an enlistment keeps the slot, the line, and the grants it was handed -- `inflight.rye`'s rule for a domain whose document changed underneath it, read one tier up. A refused enlistment leaves the run exactly as it found it, with the record the length it already was.

**The limit is named plainly.** A newcomer joins the tail and waits its turn like any other phase; it never preempts a dependent already running, and it never reaches back to re-order work already placed. Whether a run may *withdraw* a phase still waiting -- the mirror of this rung -- is answered by the rung below.

The numbers state the claim: **an enlistment costs at most 16 tests against 256 to seat the plan again; a phase already spent is refused by name against a record of 6 and welcomed by the same reading over the 4 still waiting; three newcomers joined a run already under way; 0 named turns broken under both hands; 7 dependents to the same end; 1 pass handed whole against 0 joined while running, since work that has not arrived is work a blocked head cannot pass over.** Both RED paths were proven on metal first -- weigh the newcomer against the work still waiting rather than the record, and the pure read reds at a phase the run already spent joining it a second time; wave every newcomer through, and it reds the same way, so the refusal is load-bearing rather than decorative. `caravan/enlist.rye` + `tools/caravan_enlist_witness.rish`.

## Withdraw -- a phase still waiting may leave a run

`enlist.rye` carried a newcomer into a supervisor with dependents already in flight, and named its own limit plainly: a run may take work while it runs, and nothing may yet leave one. A phase queued by mistake, or made pointless by a dependent that already came home, had no door out at all -- only a run carried to its end doing work nobody wanted, or a run torn down and seated again from the top.

**A withdrawal owes the plan the same three facts an arrival owed it, read backwards, and that is the finding.** An arrival asks whether anybody placed waits on its turn, whether its step is the next one that turn has open, and whether a turn already standing agrees with it about what it follows. A withdrawal asks the mirror of each: whether the phase still waits, whether its step is the last one its turn holds, and whether any phase in the record names its turn. One walk answers all three, against the same whole record `enlist.rye` proved a run must keep.

**Those three facts are exactly what make a departure invisible downstream, which is why they are the right three.** A phase that still waits has handed out no slot, no line, and no grant. A phase standing last in its own turn has no sibling whose fence would fall open early. A phase whose turn nobody names has no follower a supervisor could release by mistake. Meet all three and every reading downstream -- `elder_waits`, `sibling_waits`, `may_pass` -- answers exactly what it would have answered had the phase never been written.

**What a run must never do is release a follower whose predecessor never ran.** A supervisor asking only the plainest question -- does this phase still wait -- lets turn 4 leave while turn 5 names it, and turn 5 then starts with `elder_waits` reading zero, satisfied by a turn that never came home. Nothing reports it, which is what makes it worth measuring: this rung weighs the same phase under both readings and shows the difference rather than asserting it.

**A departure moves nothing.** In a run the record keeps its shape and its length, and the phase is marked gone where it stands, so every dependent already started keeps the slot, the line, and the grants it was handed -- `enlist.rye`'s rule for a newcomer, read from the other side. On a plan not yet running, a withdrawal closes the gap it leaves and every phase that remains keeps the order its author wrote.

**Withdrawal inverts arrival.** A plan grown by an arrival and then relieved of that same phase is the plan it was handed, phase for phase -- this arc's standing generalization test, one tier further out from an empty turn mask being the sibling mask, a seated plan arranging to itself, and a plan grown one arrival at a time proving to be the plan its author wrote.

**The limit is named plainly.** A withdrawal reaches only work still waiting: a dependent already running is never recalled, and a phase already home is never unrun. Whether a run may *replace* a phase -- withdraw one and enlist another in one act, so a plan may be corrected rather than only grown and pruned -- is answered by the rung below.

The numbers state the claim: **a withdrawal costs at most 16 tests against 256 to seat the plan again, exactly what an arrival and an enlistment each cost; a turn its follower names is refused its leave against a record of 7, and the shy reading lets it go so that turn 5 then waits on nobody; three refusals each carry their own name -- `WithdrawalMissing`, `WithdrawalStarted`, `WithdrawalUnseated`; a plan relieved of its own arrival is that plan, all 6 phases; two phases left a run already under way, leaving 5 dependents against 7 handed whole with 0 named turns broken.** The schedule itself was corrected by metal -- an earlier draft reached for turns the passes had already started, and the run refused with `WithdrawalStarted` rather than pretending. Both RED paths were proven on metal first -- drop the check that no phase names the departing turn and the pure read reds at a follower released by a predecessor that never ran; drop the check that the phase still waits and the module's own invariant fires at `caravan/withdraw.rye:624` with dependents in flight, so the contract is load-bearing rather than decorative. `caravan/withdraw.rye` + `tools/caravan_withdraw_witness.rish`.


## Replace -- a run may correct a phase in one act

`withdraw.rye` gave a waiting phase a door out and named its own limit plainly: a run may now grow and prune, so a plan could be corrected only by doing both in sequence. A correction is the commonest change there is -- this phase is the right phase in the wrong shape, fix it -- and it was the one change the arc could not make.

**A correction that keeps a phase's turn and its step is refused by every reading that weighs the newcomer against a record still holding the phase it replaces, and that is the finding.** The plainest correction there is -- same turn, same step, different work -- asks a plan for a step its own turn has already spent. `arrival_admits` counts one step standing and the newcomer offers step zero, so the door closes on the very change it was built to make. Weigh the same newcomer against the **residue** -- the record holding neither the departing phase nor the newcomer -- and the step it offers is the step that turn has open. Both triples want that one record, and neither leg can find it alone.

**A replacement keeps the slot, and a sequence cannot.** An arrival lands at the tail, so correcting a phase in the middle of a plan by withdrawing it and enlisting another carries the correction to the end and lets every phase the author wrote after it stand ahead of it. Measured rather than asserted: correcting the third of seven phases moves no phase at all in one act, against five places moved by the sequence that reaches the same set.

**The residue is a lawful plan, which is exactly what makes the gap dangerous.** Between a withdrawal and its enlistment the record seats itself, orders itself, and answers every reading a supervisor knows how to ask -- so nothing in the machinery can tell a half-finished correction from a finished plan, and a run in that gap will admit from behind the empty slot a dependent the correction would have held. One act closes the gap by never opening it.

**A replacement moves nothing, in the strongest form this arc has reached.** A withdrawal keeps the record's length and leaves a hole; an enlistment keeps every index and grows the tail. A correction does neither: the length never changes and no index is ever added, so every dependent already started keeps the slot, the line, and the grants it was handed, and the plan an operator reads is the plan its author wrote with one phase now saying something else.

**A correction earns one refusal of its own.** A newcomer can be lawful at the tail and unlawful in the slot: a phase may name only turns below its own, so a high turn dropped into an early place names a turn standing after it, and the plan stops seating itself while the arrival leg sees nothing wrong. `ReplacementUnseated` is that fact, named where an operator meets it.

**The limit is named plainly.** A correction reaches only work still waiting, exactly as a withdrawal does: a dependent already running is never recalled and a phase already home is never rewritten. Whether a run may correct a phase a dependent is *running* -- letting the work in flight finish under the shape it started with while the record already reads the new one -- is answered by the rung below.

The numbers state the claim: **a correction costs at most 32 tests against 256 to seat the plan again, twice what an arrival, an enlistment, or a withdrawal each spend; a record still holding the phase refuses its own correction while the residue takes it; a correction moves 0 places of a plan of 7 against 5 moved by the sequence; a plan correcting a phase to itself is that plan, all 7 phases; one phase was corrected in a run already under way, leaving 7 dependents and 7 places either way with 0 named turns broken.** Both RED paths were proven on metal first -- weigh the arrival against the record still holding the phase, and the pure read reds at a phase nobody waits on being refused its correction, the finding shown as a failure; drop the slot's own seating check, and a phase naming a turn behind it is seated anyway. `caravan/replace.rye` + `tools/caravan_replace_witness.rish`.
## Understudy -- a record may carry two shapes of one phase at once

`replace.rye` let a run correct a phase in one act and named its own limit plainly: a correction reaches only work still waiting. A dependent already running was never recalled, so the commonest correction of a busy run -- this work is in flight and the next hand should do it differently -- had no door at all.

**The finding is that the door costs nothing, because the arc had already separated what a dependent was handed from what the record says.** A dependent carries its own domain, its verb, its count, and the outcome it owes from the moment it is spawned; the grants it holds were narrowed once and handed over; and every reading the supervisor makes about work still waiting steps over a phase already started. So a phase in flight and its slot in the record are two shapes of one phase already -- this rung only says so and keeps them honest.

**What a run must never do is forget which slot each dependent came from.** A record that remembers only how many dependents run cannot tell a phase still in flight from a phase already home, and those two want opposite answers: one may take an understudy, and the other may never be rewritten at all. The table carries that memory here, one index per live dependent, shifted when the eldest is reaped.

**An understudy earns two refusals, one about place and one about time.** `UnderstudyMoved` is the place: a running phase's step is already spent, and the plan's memory of what it spent is what keeps every later arrival honest, so the work may change entirely while the turn and the step may not move at all. `UnderstudyHomed` is the time: a phase whose dependent has come home is finished work, and rewriting it would make the record lie about what ran. The slot's own seating check carries through as `ReplacementUnseated`, since a shape sound in its own right can still name a turn standing behind it.

**An understudy of work still waiting is that work's correction, exactly.** The rung generalizes its elder rather than rivalling it -- hand it a waiting phase and every answer comes from `replace.rye`, refusal for refusal.

**The limit is named plainly.** An understudy reaches one shape at a time and never recalls the dependent standing under it. The rung below answers what that leaves open: a run may weigh a dependent by the line it was handed, rather than by the ceiling its domain was granted.

The numbers state the claim: **an understudy costs at most 19 tests against 32 for a correction and 256 to seat the plan again, one walk of the record and one glance at the table, weighing no triple at all; the very phase a correction refuses with `WithdrawalStarted` is welcomed here unchanged; an understudy changes what 0 turns remember against 2 changed by the move it refuses; an understudy of waiting work is that work's correction, all 7 phases; and one shape swapped under a running dependent leaves 7 places, 7 dependents, and 2 carried home either way with 0 named turns broken.** All three RED paths were proven on metal first -- judge the reaped dependent from the record rather than from what it was handed, and the swapped run reds at `client_a: expected bytes differed, heard carried`, the finding shown as a failure; drop the place refusal, and a shape moved out of a place already spent is seated anyway; drop the running check, and a phase already home is rewritten after its work has run. `caravan/understudy.rye` + `tools/caravan_understudy_witness.rish`.

## Unhand -- a dependent is weighed by the line it holds

`understudy.rye` proved that what a dependent was handed travels with the dependent, and that proof has one more consequence the arc had not spent. Every rung up to here asks the isolation room what the document permits each *running domain*, even though `intent.narrow` already handed each dependent a far smaller line -- capabilities for the arcs it names this turn, with the write bit dropped wherever the item declared a read. So a domain granted `rw` over a region blocked every reader of that region for as long as any of its dependents ran, while the dependent in flight held no capability to that region whatsoever.

**A line handed over is a fact about the dependent, so a run may weigh it as one.** The dependent cannot reach past the line it holds -- the line *is* what it holds. A run may therefore unhand the ceiling's claim over a running dependent and weigh newcomers against the far smaller thing that dependent actually carries.

**What a run must never do is weigh a dependent it does not remember.** The ceiling reading needs only a domain name, which every live dependent already carries; the held reading needs the whole line. So the supervisor holds one line per live dependent, shifted when the eldest is reaped, exactly as it holds the slot each dependent came from.

**The rung earns two refusals, one about memory and one about reach.** `UnhandUnheld` is the memory: a forgotten dependent is an unweighed one, so a run weighs by held lines only while it remembers a line for every dependent standing. `UnhandWidened` is the reach: a remembered line may name only what the document already grants that domain, since a line claiming an ungranted write would admit a newcomer the ceiling rightly blocks.

**The channel joint stays exactly where it stands.** A channel joins two domains at every instant of both, and a line narrowed to this turn's arcs says nothing about it. A domain still runs one dependent at a time. This rung narrows the memory room alone and leaves the doorbell room honest.

**A line as wide as its own ceiling reads exactly as the ceiling does.** The arc's standing generalization test, one tier further out -- hand a dependent every region its domain may reach, declaring a write wherever the document grants one, and the held reading answers `intent.admissible` refusal for refusal.

**The limit is named plainly.** A run weighs a dependent by the line it was handed at spawn, and that line never moves while the dependent runs. Whether a dependent may give back an arc it has finished with -- a line shrinking mid-flight, so the door widens the moment the work narrows -- is the question the next rung answers.

The numbers state the claim: **the isolation room costs at most 48 tests by the held line against 36 by the ceiling, the narrower room reading more and admitting more; the ceiling refuses a reader of a board the running domain may write, and the held line welcomes the same newcomer unchanged; a line as wide as its own ceiling reads as the ceiling, all 9 pairs; and one plan run twice reaps 7 dependents and carries 1 home either way, with 2 at once by the ceiling against 3 by the lines held, and 8 slots left unspent against 1.** All four RED paths were proven on metal first -- drop the memory refusal and the reading walks past the end of what it remembers, panicking at `index out of bounds: index 0, len 0`; drop the reach refusal and a line claiming a write the document never granted is weighed anyway; drop the channel refusal and a domain joined by a channel is admitted beside its peer; answer the door by the ceiling in both runs and the finding shows as a failure, `the narrower room bought no room at all: 2 against 2`. `caravan/unhand.rye` + `tools/caravan_unhand_witness.rish`, over its own `caravan/systems/serial_three_clients_board.bron`.

## Taper -- a line only ever shrinks, and the door widens as the work narrows

`unhand.rye` weighed a newcomer against the line each running dependent was actually handed rather than against everything its domain may ever reach, and it named its own limit plainly: that line never moves while the dependent runs. A dependent handed three arcs at spawn stayed weighed against all three until it exited, long after it had finished with the first.

**A dependent that has finished an arc may give it back.** The walk a `stand` makes is ordered -- it reads its arcs in the order its plan names them -- so at every instant the dependent holds a *suffix* of the line it was handed. A handback is therefore one number: how many leading arcs are done with. A line written that way can only ever shrink, and the run's whole memory of the shrinking is a single byte per dependent.

**What a run may never do is narrow a line it has not heard narrowed.** A handback is a fact the dependent publishes and the supervisor reads; a supervisor that guessed would weigh a door against work still in flight. Each dependent publishes into a note of its own, the run reads the note between fills, and the run acknowledges what it has taken in -- a two-way notification, the shape a microkernel already gives a parent and its protection domain. Both sides are bounded: a dependent never waits forever on a reader that is not coming, and a blocked run never spins past its own bound before it reaps.

**The rung earns three refusals, and every one is about the line.** `TaperReversed` is the direction: a line only ever shrinks, so a note read lower than the run remembers claims arcs already given back. `TaperEmptied` is the floor: a dependent always holds at least the arc it is working, and a line given back whole is a departure `withdraw.rye` already answered. `TaperWidened` is the reach: what remains named must be what was handed, declaring exactly what it declared at spawn.

**The door itself needs nothing new.** `unhand.admissible_held` weighs a newcomer against the lines a run remembers, and this rung changes only what those lines say. The channel joint stands exactly where it stood, and a domain still runs one dependent at a time.

**A run that hears nothing behaves exactly as the rung below.** Silence leaves every line at full width, which is the held reading itself -- so the narrower room is never less safe than the wider one, only sometimes wider. The generalization test says it in the arc's own habit: with nothing given back anywhere, every pair reads as `unhand.admissible_held` reads it.

**The limit is named plainly.** A run widens only as far as its dependents publish, and it pays for the chance with a bounded listen at each blocked moment. Whether a supervisor may hand a running dependent a *wider* line -- work arriving for a dependent already in flight, rather than work leaving it -- is answered by the rung above, in **Entrust**.

The numbers state the claim: **a line of three arcs reads as two the moment its first arc comes back, arcs and letters together; three refusals stand by name; a run that hears nothing reads as the line handed, all 9 pairs; and one plan run twice reaps 5 dependents and carries 1 home either way, with 2 at once by the line handed against 3 by the line still held.** All five RED paths were proven on metal first -- drop the direction refusal and a line grows back an arc it had already given away; let a line be given back whole and the walk panics at `reached unreachable` on the invariant that a narrowed line always keeps the arc its dependent is working; let a narrowed line name an arc nobody handed it and the reach reads as within; answer the door by the line handed in both runs and the finding shows as a failure, `the narrower room bought no room at all: 2 against 2`; never listen at all and the run reports `a run of a standing dependent heard no handback at all`. `caravan/taper.rye` + `tools/caravan_taper_witness.rish`, over the board declaration the rung below opened.

## Entrust -- a line may also grow, and growing is the harder half

**A shrink is safe by construction; a widening is not.** When a line narrows, the door has already weighed the wider line -- every sibling standing beside that dependent was admitted against it -- so narrowing can only free room. A widening reaches the other way: it takes on arcs the door never weighed, beside siblings admitted against the narrower line. So a widening looks in two places a shrink never had to.

**The shape stays one number.** A phase carries a **reserve** beside the line it hands its dependent at spawn: arcs the supervisor may entrust later, written in the same grammar the line itself speaks. The dependent is spawned holding both, and the run remembers only the handed line -- the reserve stands dark to the door until it is entrusted. An entrustment is therefore the count of leading reserve arcs handed over, and the line the run remembers is the handed line followed by that prefix. A line written that way can only ever grow, and the whole memory of the growing is one byte per dependent.

**The win is a different one than the shrink bought.** A taper bought room -- more dependents at once. An entrustment buys the opposite economy: work arriving for a domain already standing is carried by the dependent already there, so the same arcs are read by **fewer dependents**. Where `unhand.admissible_held` refuses a second dependent of a running domain, an entrustment dissolves the block without weakening it, because the arcs go to the one dependent rather than to a second.

**The notification runs the other way.** In `taper.rye` the dependent published and the supervisor acknowledged. Here the supervisor publishes and the dependent answers -- the same two-way note, read from the other end, and bounded on both sides so neither a dependent waiting for work nor a run waiting for an answer waits forever.

**The rung earns five refusals, two more than the shrink, and every one is about the line.** `EntrustReversed` is the direction: a line only ever grows here, so an entrustment lower than the run remembers claims work back. `EntrustExhausted` is the supply: a reserve gives only what it holds, and a widened line names no more arcs than one item may ever name. `EntrustUngranted` is the reach a shrink never had to check -- a narrowed line was inside the document by construction, being a suffix of a line already granted, while a widened line reaches and must be weighed against what the document actually grants that domain. `EntrustContended` is the room: a widening is refused wherever the widened line would contend with a line another running dependent holds, since the door that admitted those siblings never weighed this reach. `EntrustUnheard` is the answer: a handback was a fact the run took in, while an entrustment is an act the dependent must confirm, and a run that entrusted work nobody took on would believe work done that was never read.

**The door itself needs nothing new.** `unhand.admissible_held` weighs a newcomer against the lines a run remembers, and this rung changes only what those lines say -- the same finding `taper.rye` made about a line that shrinks, read from the other side.

**A run that entrusts nothing behaves exactly as the rung below.** With no reserve handed anywhere, every line stands at the width it was handed, and the generalization test says it in the arc's own habit: every pair reads as `unhand.admissible_held` reads it.

**The limit is named plainly, and the rung below closes it.** A dependent was spawned holding its reserve capabilities, so this rung's isolation claim is about the *work* a dependent is permitted to do rather than about the reach it physically holds. A real microkernel hands a capability into a running dependent's cspace. **Confer** below carries the capability word itself over a channel into a dependent already running, and measures what that buys.

The numbers state the claim: **a line of three arcs reads as four the moment one reserve arc is entrusted, arcs and letters together; four refusals stand as a pure fold and a fifth in the run; a run that entrusts nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice reaps 4 dependents with a dependent of its own for every phase against 3 with work handed to the dependent already standing, 1 coming home either way, 1 phase carried without a dependent of its own.** All six RED paths were proven on metal first -- drop the direction refusal and a line takes work back from a dependent already carrying it; drop the length half of the supply guard and the depth half still refuses, drop both and the walk panics at `reached unreachable` on the invariant that exactly the entrusted prefix was taken on; drop the reach refusal and a line reaching for a write the document never granted reads as within; drop the room refusal and a widening reaches a region a sibling was already reading; never entrust at all and the run reports that a standing dependent with a reserve was entrusted nothing; entrust and never wait for an answer, and the run refuses the whole record with `EntrustUnheard`. `caravan/entrust.rye` + `tools/caravan_entrust_witness.rish`, over the board declaration the rungs below opened.

## Confer -- the reach itself travels, rather than riding along from the spawn

**A permission that grows is not yet a reach that grows.** `entrust.rye` let a supervisor hand a running dependent more work, and it named its own limit rather than letting it pass: the dependent had been handed capability words for its whole reserve at the moment it started, so an entrustment grew the run's permission while the arcs were already in the dependent's hands. This rung moves the reach itself.

**The shape of the message is the whole move.** A dependent is spawned narrowed to exactly the line it was handed -- the same narrowing `unhand.rye` and `taper.rye` always made -- and the capability word for each entrusted arc travels to it over a channel, where it grafts the word into its own slot before it reads. The words land first and the count that makes them live lands second, so a dependent reading between the two sees fewer words than are written rather than a count naming a word that has not arrived.

**A conferred word is derived, never authored.** The run reads the domain's ceiling out of the table `roster.from_system` derives from the declaration, masks it down to the letter the reserve declares for that arc, renders it in the same `region:perm` grammar the spawn already speaks, and reads its own rendering back before publishing it. Nothing about the wire lets a supervisor invent a right the document withholds.

**The measurement is what makes the rung honest rather than decorative.** A dependent asked to reach an arc it has not been conferred answers `NotGranted` from `serve.reach_by_name`, because its capability list genuinely does not name that region. So the two rooms disagree on a number nothing else in this arc has measured: **dark reach** -- arcs a running dependent could physically touch that the door has not yet weighed. This rung buys no speed and no room; it buys the isolation claim itself.

**The rung earns five refusals, and every one is about the word rather than the line.** `ConferUngranted` is the region: a ceiling names what a domain may ever reach, so a reserve arc the document never granted it has no word to send. `ConferOverreaching` is the letter: a reserve declaring a write over a region granted read-only would confer a right the ceiling withholds. `ConferGarbled` is the wire: three permission words carry the whole grammar, so a right outside it refuses rather than quietly rendering as something narrower. `ConferOverfull` is the room in the dependent's own hands: one slot holds a bounded number of capabilities, and a graft past that bound is refused before it is published. `ConferUnheld` is the answer: a run that conferred reach nobody grafted would believe a dependent able to touch what it never took in hand.

**The door itself needs nothing new.** `entrust.admissible_in` weighs a widened line the same way whether the dependent came to hold its arcs at the spawn or over a channel. Everything this rung changes stands on the dependent's side, which is exactly where the elder limit lived.

**A run that confers nothing behaves exactly as the rung below.** With no reserve named anywhere, no word travels, every line stands at the width it was handed, and the generalization test says it in the arc's own habit: every pair reads as `unhand.admissible_held` reads it.

**The limit was named plainly, and the rung below closes it.** A conferred word grew a dependent's capability list and never pruned it, so reach arrived and stayed for the life of that dependent. **Revoke** below carries the mirror act -- the deletion a real microkernel makes when it frees a cspace slot -- and measures what it buys.

The numbers state the claim: **a reserved read renders as `menu:r` from the ceiling and reads back as itself; four refusals stand as a pure fold and a fifth in the run; a run that confers nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice reaps 3 dependents either way and carries 1 home either way, while the dark reach held at the spawn falls from 1 to 0 -- measured in the dependent's own hands, which report 1 arc reachable before the word arrived under the elder reach and 0 under this one.** All six RED paths were proven on metal first -- drop the region refusal and a word travels for a region the document never granted; drop the letter refusal and a word carries a write the ceiling withholds; drop the wire round-trip and a right outside the grammar renders anyway as something narrower; widen the room bound and a word travels to a dependent with no room to hold it; publish a count of nothing and the run refuses the whole record with `ConferUnheld`; let the dependent skip the graft and it answers `NotGranted` on the conferred arc while carrying fine when every word rode along from the spawn, which is the whole rung read from the dependent's side. `caravan/confer.rye` + `tools/caravan_confer_witness.rish`, over the board declaration the rungs below opened.


## Revoke -- reach returns the moment its work is carried

`confer.rye` moved the reach itself and closed the gap at the front of a dependent's life: a dependent is spawned narrowed to exactly the line it was handed, and each capability word arrives over a channel when the door grants it. That left the mirror gap open at the back. A conferred word, once grafted, stayed in the dependent's hands until the dependent exited -- the word grew a capability list, and nothing ever pruned it.

**This rung closes the back half, and the direction is the whole move.** A real microkernel deletes a cspace slot; a supervisor here publishes one number -- how many conferred words a dependent may still hold -- and the dependent rebuilds its own slot down to that count, then asks for each returned arc to prove the deletion is physical rather than promised.

**The measurement mirrors the rung below exactly.** Confer weighed *dark reach*, arcs a running dependent could touch that the door had not yet weighed. This rung weighs **stale reach**: arcs a dependent can still touch after the work that reach served is already carried. Holding every conferred word leaves that number above zero at the moment a dependent comes home; revoking drives it to zero, with the same work carried by the same dependents.

**The discipline is the rung below read backwards.** There, a run widened the line it remembers only once the dependent answered that it held. Here, a run narrows what it believes a dependent can touch only once the dependent answers that it pruned. Both sides refuse to believe a change to a dependent's hands until the dependent's own hands report it.

**The answer is earned by a measurement, never an intention.** A dependent claims it pruned only once the arcs it returned genuinely refuse it. A rebuild that left any of them reachable publishes nothing at all, and the run refuses the whole record rather than believing a deletion that never happened. This is the one place the rung grew past its first draft: the first shape let a dependent answer for its own good faith, and the run believed it.

**A pruning is a rebuild rather than a removal, which is why it is total.** The line a dependent was spawned holding is never at risk, and the conferred words come back one at a time in exactly the order they were granted.

**The rung earns four refusals, and each is about the return of a word rather than its arrival.** `RevokeReversed` is the direction: a revocation only ever shrinks, so a number naming more reach than the dependent was conferred refuses rather than quietly growing it. `RevokeUngiven` is the supply: a dependent conferred nothing has no reach to return. `RevokeInflight` is the work still standing -- the hard half of this rung -- since a word whose arc is still being served may not be taken back, however tidy the pruning would be. `RevokeUnpruned` is the answer: a run that revoked reach nobody pruned would believe a dependent unable to touch what it still holds.

**The door itself needs nothing new.** `confer.admissible_in` weighs a widened line the same way whether the dependent keeps its conferred arcs or returns them; everything this rung changes stands on the dependent's side.

**A run that revokes nothing behaves exactly as the rung below.** With no pruning promised anywhere, every conferred word stays where the rung below left it, and the generalization test says it in the arc's own habit: every pair reads as `unhand.admissible_held` reads it.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a run that revokes nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice reaps 3 dependents either way, carries 1 home either way, and confers 1 arc either way, while the stale reach at home falls from 1 to 0 -- measured in the dependent's own hands, which report 1 arc still reachable at home when the word is held and 0 when it is returned.** All five RED paths were proven on metal first -- drop the direction refusal and a revocation grows a dependent's reach instead of shrinking it; drop the supply refusal and a run takes back reach that was never conferred; drop the in-flight refusal and a word is pruned while the work it served still stands; withhold the dependent's answer and the run refuses with `RevokeUnpruned` rather than believing reach returned that never was; let the dependent hear the revocation and keep every word anyway, and it publishes nothing rather than a false answer, so the run refuses again, which is the whole rung read from the dependent's side. `caravan/revoke.rye` + `tools/caravan_revoke_witness.rish`, over the board declaration the rungs below opened.


## Reclaim -- a conferral leaves with the dependent it was made to

`confer.rye` closed the gap at the front of a dependent's life, and `revoke.rye` closed the gap at the back of a *standing* dependent's life. Both weigh what one dependent may touch while it stands. Neither asks what becomes of the conferral once that dependent is gone.

**The conferral outlives its holder, and that is the hole this rung closes.** A conferral is published per domain -- the words, the count that makes them live, and the answers about them -- and a domain outlives every dependent that ever stands in it. So the next dependent of that domain opens its eyes on a wire that already carries a word, grafts it, and reads an arc no door ever weighed for it. Revoking does not help: revocation prunes the holder's hands, while the word on the wire stands exactly as it was written.

**The measurement completes the family.** Dark reach was what a dependent could touch before the door weighed it; stale reach was what it could touch after its work came home; **inherited reach is what it can touch at its first breath because somebody else was granted it.** Leaving each conferral standing holds that number above zero; reclaiming drives it to zero, with the same work carried by the same dependents.

**A conferral names the generation it was made to, and that is what makes the count exact.** A supervisor may publish a word for this very dependent between the spawn and its first breath, so *something standing here* is no evidence at all -- a word addressed to an **earlier** generation of this domain is. This was found by the measurement disagreeing with itself: the first cut of the rung had the elder reporting its own conferral as inherited, because it drew its first breath after the run had already written for it. **The generation is a measurement, never a guard.** A careless successor grafts a foreign word all the same, which is exactly why the conferral is reclaimed rather than merely labelled.

**The control run shows the hazard plainly.** Under the leaving take the successor is conferred nothing by any phase, and comes home having grafted one word anyway -- the one its predecessor was granted, still live, still reachable.

**A reclamation takes the conferral whole** -- the words, the count that makes them live, the generation it was addressed to, and every answer given about it. A count left standing lets a successor graft a word; an answer of *held* left standing lets a supervisor believe a successor grafted a word it never saw.

**The rung earns four refusals, and each is about a conferral outliving its holder.** `ReclaimStanding` is the moment: reach from a dependent still in flight returns by revocation, since a standing dependent can answer for its own hands. `ReclaimUngiven` is the supply: a dependent conferred nothing leaves nothing behind. `ReclaimTwice` is the count: a conferral already reclaimed may not be reclaimed again, or a run reports reach it never took back. `ReclaimInherited` is the answer -- the hard half -- since a run that reclaimed a conferral a successor could still graft would believe an isolation it does not have.

**The door itself needs nothing new.** `revoke.admissible_in` weighs a widened line the same way whether a departed dependent's conferral stands or leaves with it; everything this rung changes stands on the wire between the two.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a run that reclaims nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice reaps 3 dependents either way, carries 2 home either way, confers 1 arc and revokes 1 either way, while the inherited reach at a successor's first breath falls from 1 to 0 -- measured in the successor's own hands, which graft the standing words into a copy of the hands they were spawned with and ask for each arc.** All five RED paths were proven on metal first -- let the fold forget the moment and a conferral is reclaimed from a dependent still standing; let it forget the supply and a run takes back a conferral that was never made; let it forget the count and a conferral already taken back is taken back again; let the first breath forget the generation and the elder reports its own conferral as inherited, so the run refuses the whole record with `ReclaimInherited`; reclaim nothing at all under the reclaiming take and the successor inherits, so the run refuses again, which is the guard proving it is a check rather than decoration. `caravan/reclaim.rye` + `tools/caravan_reclaim_witness.rish`, over the board declaration the rungs below opened.



## Abandon -- a conferral whose holder fell served nobody, and the run says so

`confer.rye` closed the gap at the front of a dependent's life, `revoke.rye` the gap at the back of a standing one, and `reclaim.rye` the gap after its holder is gone. Three rungs about what a dependent may **touch**. None of them asks what became of the **work**.

**A reclamation is silent about why its holder left, and that is the hole this rung closes.** It takes the conferral back the moment the dependent is reaped, whether that dependent carried its work home or fell mid-arc, and both readings leave the same bare domain and the same clean count behind. Meanwhile the run has already counted the conferred phase as **absorbed** -- the record's word for *taken up*, which is its word for *carried*. So a plan whose author declared a fall reads back as a plan fully carried out, with an arc in it that nobody ever served.

**The measurement completes the family, and this one counts work rather than touch.** Dark reach was what a dependent could touch before the door weighed it; stale reach what it could touch after its work came home; inherited reach what a successor could touch at its first breath. **Abandoned reach is what a run conferred that nobody served**, because its holder fell holding it. The other three count a hazard; this one counts a loss.

**Every other number stands still, which is what makes the finding a finding.** Both runs take up 4 phases, spend 3 dependents, carry 1 home, confer 1 arc, reclaim 1 conferral, and absorb 1 phase into a standing dependent. Only the answer for the lost work moves, from 0 to 1 -- and the 0 is the false one.

**The answer stands on the wire rather than in the supervisor's memory.** The count is written into the departed domain's own notes *after* the reclamation has swept them clean, so it survives the very act that erases every other trace of the conferral, and it is read back before the report believes it. A number an operator can read after the run is a fact; a number held in a process that has exited is a claim.

**The plan's own declaration reaches the dependent for the first time.** A plan already names the outcome it expects of every phase, and until now only the supervisor read that word. The window this rung studies opens inside the dependent's life -- after it grafts a conferral and before it carries the work -- so the declaration rides the same wire as the pruning promise, written before the spawn and read at the graft.

**The rung earns four refusals, and each is about work rather than reach.** `AbandonStanding` is the moment: a dependent still in flight has abandoned nothing, since it may yet carry every arc it holds. `AbandonUngiven` is the supply: a dependent conferred nothing leaves no work behind. `AbandonHomed` is the honesty of the count: a dependent that came home served what it was granted, and a measurement that overstates its own loss is as useless as one that hides it. `AbandonUncounted` is the answer -- the hard half -- since a run that reclaimed a fallen holder's conferral and recorded nothing would report an arc carried that nobody carried.

**The door itself needs nothing new.** `reclaim.admissible_in` weighs a widened line the same way whether a departed holder's work was served or lost; everything this rung changes stands in the record and on the wire.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a run that answers for no abandonment reads as the line handed, all 9 pairs; and one plan of 4 phases run twice spends 3 dependents either way, carries 1 home either way, confers 1 arc and reclaims 1 conferral either way, absorbs 1 phase either way, while the abandoned reach rises from a false 0 to a true 1.** All five RED paths were proven on metal first -- let the fold forget the moment and a standing dependent's work is called abandoned while it may yet carry it; let it forget the supply and a run abandons work it never conferred reach for; let it forget the honesty of the count and a dependent that came home is counted as having lost its work; withhold the note and the run refuses its own record with `AbandonUncounted` rather than trusting a number it never read back; and answer under the wrong take, so the *silent* run counts 1 -- the guard catching the same gap from the other side, which is what proves it is a check rather than decoration.

**The lap earned an honest RED of its own before it was green.** The falling dependent was written second, the door refused it beside a standing sibling that contends over `board`, and the run passed its conferring phase ahead as a dependent of its own -- so the holder fell holding nothing, and the guard said so plainly. The plan was reordered rather than the guard softened. `caravan/abandon.rye` + `tools/caravan_abandon_witness.rish`, over the board declaration the rungs below opened.


**A later round sharpened the harvest rung beneath this one (REDS %95).** Reaping by readiness had asserted an exact zero over a raw idle count the scheduler gets a vote in, and it went RED on 2 of 12 cold runs with nothing in the tree changing. The root was in the module: readiness reaped the lowest-indexed ready dependent, so a sibling the head did not want could be reaped instead, emptying a slot the head still could not use. `choose_slot` now prefers the ready slot whose going lets the head enter, asked of `rolling.admissible` itself, and the rung asserts the number it can guarantee -- a turn idle beside a dependent already exited whose going would have opened the door, which is 1 for eldest-first and 0 for readiness by construction.

## Reckon -- a plan that lost an arc is reported short

`confer.rye` closed the gap at the front of a dependent's life, `revoke.rye` the gap at the back of a standing one, `reclaim.rye` the gap after its holder is gone, and `abandon.rye` counted what a fallen holder's conferral never bought. Four rungs about one dependent at a time. None of them asks what the plan itself amounts to.

**A run counts the loss and reports success anyway, and that is the hole this rung closes.** `abandon.rye` writes the abandoned reach into the departed domain's own notes and reads it back, so the number is a fact. Yet the run that wrote it still returns cleanly: the record drained, every outcome matched the word its author declared, and the report reads four phases queued, three dependents reaped, one absorbed. An operator reads that as a plan carried out, with the abandoned count sitting quietly beside it as one more number among a dozen that nobody has to look at.

**The measurement is overclaimed completion, and it is the first of this arc that weighs the report rather than the run.** Dark reach, stale reach, inherited reach, and abandoned reach each count arcs a dependent held; this counts a claim a supervisor made. Assuming completion holds it at one; reckoning it drives it to zero, with the same work carried by the same dependents.

**Completion becomes a verdict the run earns.** A plan is `carried` when every phase it absorbed into a standing dependent was actually served, and `short` when any of them was not. A drained queue is evidence that every phase was **taken up**, and taking a phase up is a different act from serving it.

**The verdict stands on the wire.** A plan-level note carries the word after the last dependent is reaped, so an operator reads the plan's own judgment once the supervisor that formed it has exited -- and the witness reads it there rather than trusting the run's telling.

**The rung earns four refusals, and each is about the plan rather than one dependent.** `ReckonEarly` is the moment: a plan with a dependent still in flight has not finished, and a verdict taken there would judge work that may yet be carried. `ReckonUnabsorbed` is the work: a plan that absorbed no phase has nothing this rung can weigh, and it is left carried by the shape of its own record rather than judged by a measurement that does not apply. `ReckonMiscounted` is the honesty of the count: a plan cannot lose more arcs than it absorbed. `ReckonOverclaimed` is the answer -- the hard half -- since a run that read back a verdict of *carried* while an arc it absorbed bought nothing would report a plan carried out that nobody carried out.

**The door itself needs nothing new.** `abandon.admissible_in` weighs a widened line the same way whether the plan it belongs to comes home whole or short; everything this rung changes stands in the report and on the wire.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice spends 3 dependents either way, carries 1 home either way, confers 1 arc and reclaims 1 conferral either way, absorbs 1 phase either way, and loses 1 arc either way -- while the completion it claims and never served falls from 1 to 0.** Every number stands still including the loss itself, which is what makes this a finding about the report rather than about the work. All five RED paths were proven on metal first -- let the fold forget the moment and a plan is judged while a dependent still stands; let it forget the work and a plan that absorbed nothing is reckoned all the same; let it forget the honesty of the count and a plan loses more arcs than it ever absorbed; withhold the verdict from the wire and the run refuses its own record with `ReckonOverclaimed` rather than trusting a judgment it never read back; and derive the verdict as if nothing were lost, so a reckoning run would report its plan carried out. `caravan/reckon.rye` + `tools/caravan_reckon_witness.rish`, over the board declaration the rungs below opened.



## Mend -- a plan reported short is run again for exactly what it lost

`reckon.rye` taught a run to weigh its own plan and say `short` when an arc it absorbed bought nothing. The verdict goes to the wire, an operator reads it after the supervisor exits, and the run returns. Nobody acts on it.

**A supervisor that reads its own short verdict and does nothing has learned the truth and changed nothing by learning it.** The plan is still short, and now it is short on the record. Every rung of this arc so far has made a supervisor more honest; this is the first that makes one more useful.

**The measurement is work still standing when the supervisor exits.** The five counts before it weigh reach a dependent held or a claim a supervisor made; this weighs an arc of a plan that nobody carried. It differs from overclaimed completion in the way that matters most: an overclaim is a sentence a supervisor should not have written, and is repaired by saying less. Unserved work is repaired only by doing more.

**A mend seats from the record, never from memory.** The verdict says *that* a plan fell short; a repair needs to know *where*, and the answer lives in a table that is gone the moment the run returns. So the run writes a **loss note** beside the verdict -- one glyph per phase, `x` where an absorbed arc was never served, `.` everywhere else -- and the mend reads its own run's published verdict back before it decides anything. One glyph per phase rather than a packed mask, because the reader here is a person first: `.x..` says which phase of four the plan lost, at a glance, straight off the wire.

**The repair is bounded by the loss.** It seats exactly the phases the wire names, each freed of the arrangement it was written for. The dependent those phases were conferred into is gone, so the work stands on its own line now, and the order a phase named was an order among siblings that have already been taken up. What the document always permitted is still permitted -- only the dependent the work was arranged through had fallen.

**The price is named rather than hidden.** A repair costs exactly the dependents its lost phases call for -- one here, never two -- and the lap asserts that cost rather than reporting it quietly beside the finding.

**The rung earns four refusals, and each is about the mend rather than the plan it repairs.** `MendUnread` is the record: a mend that read no verdict at all, or read a short verdict naming no phase, is acting on memory rather than on what its run published. `MendWhole` is the plan: a plan the wire calls carried has nothing here to repair, and a mend that ran anyway would re-do work already served. `MendOvereach` is the reach: a repair may never seat more phases than the plan lost, since a repair that could grow into a re-run is no longer a repair. `MendUnserved` is the answer -- the hard half -- since a run that published `carried` with an arc still standing would report a repair nobody made.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice confers 1 arc, reclaims 1 conferral, absorbs 1 phase, loses 1 arc, and reports the plan short when it first weighs it -- either way -- while the work left standing when the supervisor exits falls from 1 to 0, at a price of exactly one more dependent, 3 against 4.** Six RED paths were proven on metal first -- withhold the loss note and the plan reports short while naming no phase it lost; let the mend seat from its own memory rather than the wire and it refuses `MendUnread`; disarm the whole-plan refusal and a carried plan falls through to a mend that can seat nothing; let the repair seat every phase rather than the lost ones and `unserved_after` refuses to compute a number from a repair that carried more than the plan ever lost; count the loss as untouched while publishing `carried` and the run refuses `MendUnserved`; withhold the settled verdict from the wire and the run refuses the same way, rather than trusting a judgment it never read back. `caravan/mend.rye` + `tools/caravan_mend_witness.rish`, over the board declaration the rungs below opened.

## Bear -- a plan may name the loss it would rather carry than repair

`mend.rye` taught a run to read its own short verdict and run the plan again for exactly the arcs it lost. It repairs **everything** it lost, because nothing in the record ever told it otherwise.

**That is the right default and the wrong law.** Some work is worth doing twice, and some work is worth carrying as a loss -- and only the author of a plan knows which is which. A supervisor that re-runs every loss is not being thorough; it is answering a question nobody asked it.

**The measurement is work re-run against the plan's own word.** Every count of this arc before it weighs a harm: reach a dependent held past its work, a claim a supervisor made, an arc nobody carried. This one weighs an **overreach** -- an arc a run re-ran after its author asked it to be borne. The plan still comes out complete under the elder reading, which is exactly why nothing below this rung could see it. What the completion cost was obedience.

**A phase declares its own bearing, and the run reads it from the record.** A phase written `bear = true` says: if this arc is lost, carry the loss. The word sits beside the outcome its author already declares, so a plan says both what it expects of a phase and what it would accept of a loss. A phase that comes home is untouched by it, since a bearing only ever answers a question the loss itself asks.

**The bearing stands on the wire beside the loss.** The run writes a bearing note next to the loss note -- one glyph per phase, `b` where an arc was lost and its author asked it borne -- and the repair reads it back before it seats a single phase. `...b` says which phase of four the plan chose to carry, straight off the wire. A supervisor that bore from memory would be obeying a plan it believes in rather than the one it published.

**The settlement gains a third word, because two were no longer honest.** A plan whose every repairable arc came home and whose borne arc remains is neither `carried` nor plainly `short`: it is **borne**, as complete as its author ever asked it to be. Reporting that plan short would send an operator looking for work nobody wants done.

**The rung earns four refusals, and each is about the bearing rather than the repair it bounds.** `BearEarly` is the moment: a bearing weighed before the run published what it lost is obeying a plan it remembers. `BearWhole` is the work: a plan that lost nothing has nothing to bear. `BearMiscounted` is the honesty of the count: every lost arc is either borne or repaired, never both and never neither. `BearOverrepaired` is the answer -- the hard half -- since a run that re-ran an arc its author asked it to bear, or that published a settlement the wire does not carry, would report an obedience it never practiced.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 9 pairs; and one plan of 4 phases run twice absorbs 2 phases into standing dependents, loses 2 arcs, and reports the plan short when it first weighs it -- either way -- while the arcs re-run against the plan's own word fall from 1 to 0, the losses carried rather than repaired rise from 0 to 1, and the elder reading spends one more dependent for the disobedience, 4 against 3.** Six RED paths were proven on metal first -- withhold the bearing note and the bearing run repairs every loss and settles carried out whole; let the repair reach past the bearing it read and it refuses `BearOverrepaired` before it spawns anything; withhold the settlement from the wire and the run refuses the same way, rather than trusting a judgment it never read back; let the count stop closing and a loss neither borne nor repaired passes unminded; disarm the moment and a bearing is weighed before the run published anything; drop the bearing from a re-seated phase and the fold catches a plan whose word survived one writing-down and not the next. `caravan/bear.rye` + `tools/caravan_bear_witness.rish`, over the board declaration the rungs below opened.

## Appraise -- a loss its author left unmarked is weighed by what came home after it

`bear.rye` taught a plan to name the loss it would rather carry than repair. That word is a judgment made **before** the run, and it is the right place for it: an author knows which of their own arcs is worth doing twice.

**Yet a bearing can only speak about what its author could foresee.** Some losses reveal what they were worth only after the run is over. A plan that left a loss unmarked said nothing about it, and the rung below reads that silence as `repair`, every time, whatever the run went on to learn.

**The measurement is arcs re-run for work the plan already got past.** The rung below weighs obedience -- work a run did after its author asked it not to. This one weighs **judgment**: work a run did that its author never spoke to, and that the run's own evidence says nobody needed. A plan comes out complete under the elder standard either way, and one more dependent is what it spent to get there.

**A plan publishes the standard by which its own silences are read.** A record written `standard = .weighed` says: where I left a loss unmarked, weigh it by what came home after it. `standard = .repair` is the rung below exactly. The standard lives at the plan rather than the phase, since it is a statement about a whole record rather than one arc, and one word an author writes once is a word an author can mean.

**The evidence is the plan's own downstream, and only the run can produce it.** A lost arc whose followers all came home is an arc the plan got past -- the work behind it stood up without it, which is a fact about this run and never about the record. A lost arc that took its followers down with it, or that has no follower at all to speak for it, is repaired: silence about an arc nothing depended on is no evidence, and custody-first reads no evidence as repair.

**The appraisal stands on the wire beside the loss and the bearing.** One glyph per phase, `w` where an unmarked loss was weighed and found spent, so `.w...` names which phase of five the run judged the plan had got past -- and the repair reads it back before it spares anything. A supervisor that appraised from memory would be applying a standard it believes in rather than the one its plan published.

**An author's own word outranks any rule about their silences.** A phase its author marked never reaches the standard at all, and `AppraiseMarked` says so by name rather than leaving it to a count.

**The rung earns four refusals, each about the judgment rather than the repair it bounds.** `AppraiseEarly` is the moment: a standard applied before the run published what it lost is judging from memory. `AppraiseMarked` is the authority. `AppraiseMiscounted` is the honesty of the count -- every lost arc is marked, weighed, or repaired, never two of those and never none. `AppraiseUnweighed` is the answer: a repair that seats a phase its own appraisal spared is stopped by name before it spawns.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 5 phases run twice absorbs 2 phases into standing dependents, loses 2 arcs, marks neither, and reports the plan short when it first weighs it -- either way -- while the arcs re-run for work the plan already got past fall from 1 to 0, the losses weighed spent and carried rise from 0 to 1, and the elder standard spends one more dependent for the judgment, 5 against 4.** Six RED paths were proven on metal first -- withhold the appraisal note and the weighing run repairs every loss and settles carried out whole; let the repair seat a phase its own appraisal spared and it refuses `AppraiseUnweighed` before it spawns anything; let the count stop closing and a loss neither marked, weighed, nor repaired passes unminded; disarm the moment and a standard is applied before the run published anything; disarm the authority and a standard reaches a phase its author had already marked; let a marked phase into the fold itself and the fold's own invariant fires at `appraised_in`. `caravan/appraise.rye` + `tools/caravan_appraise_witness.rish`, over the board declaration the rungs below opened.

## Recant -- a judgment a run's own evidence disproves is taken back and repaired

**`appraise.rye` taught a plan to publish the standard by which its silences are read, and a run to weigh an unmarked loss by what came home after it.** That judgment goes to the wire, and it stays there: a judgment outlives the run that made it, which is exactly what makes it a record.

**Yet the evidence under it belongs to one run alone.** A later run of the same plan meets that standing judgment with evidence of its own, and nothing below this rung ever asks the two to agree.

**The measurement is arcs spared on a judgment this run's own evidence disproves.** The rung below weighs judgment -- work a run did that nobody needed. This one weighs a **record against itself**: work a run declined to do on the word of a run that is over, while its own record says that word no longer holds. A plan spared this way settles `borne`, which tells an operator there is nothing left to do, so nothing below this rung could see the arc it left standing.

**A plan publishes whether its own judgments answer to a later run.** A record written `review = .revisit` says: a standing appraisal answers to the evidence of every run that meets it. `review = .stand` is where the rung below leaves it -- a judgment once published stands, and a run that meets it adds its own reading rather than weighing it. The word sits at the plan beside the standard, since it instructs about the record's own history rather than about any one phase.

**The standing appraisal is the one note a run does not clear.** Every other note a plan carries provisions back to nothing at the head of a run, so no supervisor reads the last run's word as its own. The appraisal is left exactly where it was, because a judgment that vanished with its run was never a record -- and because what a run does with a judgment it did not make is the whole subject here.

**A recantation is bounded by the judgment it takes back.** Only an arc a standing appraisal named may be recanted, and every standing judgment this run can weigh is upheld or recanted -- never both and never neither. A run that recanted an arc nobody spared would be inventing a reversal, which is the same overreach as repairing work the wire never named.

**The recantation stands on the wire beside the appraisal it reverses.** One glyph per phase, `r` where a standing judgment was taken back, so `.r....` names which phase of six this run refused to spare on an older run's word -- written while the run still holds the evidence, and read back before the repair seats a single phase on its strength. The judgment leaves the wire in the same breath.

**The rung earns four refusals, each about the reversal rather than the repair it opens.** `RecantEarly` is the moment: a standing judgment weighed again before this run published what it lost is judging from memory. `RecantUnappraised` is the supply. `RecantMiscounted` is the honesty of the count. `RecantUnspoken` is the answer: a run that recanted an arc and then declined to repair it would report a reversal it never carried out.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice against the same standing judgment absorbs 3 phases into standing dependents, loses 3 arcs, marks none, and reports the plan short when it first weighs it -- either way -- while the arcs spared on a judgment this run's evidence disproves fall from 1 to 0, the standing judgments taken back rise from 0 to 1, the settlement moves from `borne` to `carried`, and the reversal costs one more dependent, 6 against 5.** Six RED paths were proven on metal first -- withhold the recantation from the wire and the reversal never reaches the repair; let the repair spare a recanted arc and it refuses `RecantUnspoken`; disarm the moment and a judgment is weighed again before the run published anything; disarm the supply and a run takes back a judgment nobody ever made; let the count stop closing and a standing judgment is neither upheld nor recanted, unminded; plant a recantation reaching an arc no judgment ever spared and the armed supply guard refuses `RecantUnappraised` at the run. `caravan/recant.rye` + `tools/caravan_recant_witness.rish`, over the board declaration the rungs below opened.

## Amend -- a settlement an operator already read is corrected where they read it

**`recant.rye` taught a run to take back a judgment its own evidence disproves,** repair the arc that judgment spared, and settle the plan `carried` where the elder reading settled `borne`. Every word of that correction goes to the wire, and every word of it is true.

**Yet the person the elder word was written for has already read it and gone.** A reader who was told there is nothing left to do carries that sentence away, and nothing below this rung ever reaches them again.

**The measurement is readings left standing on a settlement this run superseded.** The rung below weighs a record against itself -- a judgment one run made and a later run's evidence disproves. This one weighs a **record against its reader**: the word an operator holds, against the word the plan now stands behind. The wire is entirely truthful the whole time, which is exactly why nothing below this rung could see it -- every note says what is so, and the belief in the room says otherwise. The belief is the one somebody acts on.

**A plan publishes whether its own corrections are addressed.** A record written `notice = .posted` says: a settlement this run supersedes is corrected on the wire, in words naming both the reading it replaces and the reading that replaces it. `notice = .silent` is where the rung below leaves it -- the settlement is overwritten, and whoever read the elder word keeps it. The word sits at the plan beside the review, since it instructs about who a record answers to rather than about any one phase.

**The standing reading is the second note a run does not clear.** The appraisal survives a run because a judgment that vanished with its run was never a record. The reading survives for a plainer reason still: a reader's copy survives the run whatever the wire does, so a wire that forgets what it last told somebody has no way to notice it changed its mind.

**An amendment is bounded by the reading it corrects.** Only a reading some run actually published may be amended, and every standing reading this run can weigh is confirmed or amended -- never both and never neither. A run that amended a reading nobody took would be correcting a reader who does not exist, which is the same overreach as taking back a judgment nobody made.

**The amendment stands on the wire in an operator's own words.** It is the first note of this arc addressed to a **person** rather than to a phase, so it is written about the plan whole rather than one glyph per phase: two bytes, the reading superseded and the reading that supersedes it, so `bc` reads *you were told the plan was borne; it is carried out whole*. The standing reading leaves the wire in the same breath, since a reading that has had its reply is no longer waiting for one.

**The rung earns four refusals, each about the notice rather than the correction it carries.** `AmendEarly` is the moment: a reading answered before this run published its own settlement is correcting from memory. `AmendUnread` is the supply. `AmendMiscounted` is the honesty of the count. `AmendUnspoken` is the answer: a run that superseded a reading and published no amendment corrected in private, and a report read on that silence would say a reader was reached when nobody reached them.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice against the same standing reading absorbs 3 phases into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, spends the same 6 dependents, and settles `carried` -- either way -- while the readings corrected where they were read rise from 0 to 1 and the readings left standing on a word this run superseded fall from 1 to 0.** The price is nothing but the willingness to say so: a correction costs no work whatever. Six RED paths were proven on metal first -- withhold the amendment from the wire and the run refuses `AmendUnspoken`; leave the answered reading standing and the reader is found still waiting; disarm the moment and a reader is corrected before the run published anything; disarm the supply and a run corrects a reader who never read a word; let the count stop closing and a standing reading is neither confirmed nor amended, unminded; plant a correction addressed to a reading the wire never named and the armed supply guard refuses `AmendUnread` at the run. `caravan/amend.rye` + `tools/caravan_amend_witness.rish`, over the board declaration the rungs below opened.

## Courier -- a correction is carried to the reader who never comes back

**`amend.rye` taught a run to answer the operator whose word it replaced** -- the settlement superseded, the settlement that supersedes it, both readings named in two bytes on the wire, and the standing reading cleared in the same breath. It is a true correction, honestly published, and it waits.

**Waiting is the whole of what is left wrong.** A correction published on the wire reaches whoever comes back to read the wire. The operator this rung studies is the one who does not -- who read `borne`, understood there was nothing left to do, and went about the rest of their day. Every note below this rung answers a reader who returns; nobody had yet answered the reader who does not.

**The measurement is corrections left waiting for a reader who never returns.** The rung below weighs a record against its reader and writes the answer down. This one weighs that answer against the **distance** between where it was written and where the reader actually is. A correction that never travels is a letter written, sealed, and left in the writer's own drawer -- entirely honest, and read by nobody.

**A reader leaves an address, or they leave nothing.** A reading arrives on the wire beside the place its reader was reached at, since a person who took a word away is somewhere, and the plan either wrote that down or it did not. An amendment whose reading names no address has nowhere to go, and the rung says so by refusing rather than by inventing a destination.

**A plan publishes whether its own corrections travel.** A record written `dispatch = .carried` says: a correction this run posts is carried to the address its reading was taken at. `dispatch = .waiting` is where the rung below leaves it -- the correction stands on the wire, correct and unread. The word sits at the plan beside the notice, since it instructs about how far a record reaches rather than about any one phase.

**The delivery lands outside this plan's own wire, and that is the point.** Every note of this arc so far is written into the plan's own note directory, where a reader must come looking. A delivery is written into the **reader's** box instead -- `caravan/.readers/desk.told`, a directory this plan does not otherwise touch -- so the first outward reach of the whole arc is visible as exactly that: a record leaving the place records are kept. The run reads the box back before it believes anybody was reached.

**A delivery is bounded by the correction it carries.** Only an amendment this run actually posted may be carried, and every posted amendment is carried or held -- never both and never neither. A run that delivered a correction nobody wrote would be handing a reader a blank page.

**The rung earns four refusals, each about the journey rather than the correction it carries.** `CourierEarly` is the moment: a correction carried before this run posted one is delivering from memory of a letter nobody wrote. `CourierUnaddressed` is the supply. `CourierMiscounted` is the honesty of the count. `CourierUndelivered` is the answer -- the hard half -- since a run that reports a reader reached whose box holds nothing has made a claim rather than a delivery, and a report read on that claim is worse than the silence below it.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 phases into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts the same correction, spends the same 6 dependents, and settles `carried` either way -- while corrections carried to the place their reader was reached rise 0 to 1 and corrections left waiting for a reader who never returns fall 1 to 0.** The price is nothing but the walk. Module [`courier.rye`](courier.rye) - witness [`../tools/caravan_courier_witness.rish`](../tools/caravan_courier_witness.rish), registered in the choir that sings all 61 rungs GREEN in one voice.

## Hear -- a correction is finished when its reader answers

**`courier.rye` taught a run to carry its correction to the place its reader was actually reached** -- the address seated on the wire beside the reading, the letter written into the reader's own box, and the box read back before the report believes anybody was reached. The letter leaves, and that is exactly as far as it goes.

**A letter that left proves a journey, never a reading.** Nothing below this rung asks whether anybody opened the box. A reader who wrote back the same afternoon and a reader who never looked read precisely alike from the plan's side -- which leaves the one question a correction exists to answer, *does this person now hold the word we stand behind?*, standing entirely unasked.

**The measurement is corrections whose reader answered into silence.** The rung below weighs an answer against the distance it travelled. This one weighs it against the **hand that answered it**: a reader wrote back, in their own word, into a plan that never listened.

**A reader's box faces two ways, and a run may only reach one of them.** The plan writes `caravan/.readers/desk.told`, the letter it carried; the reader writes `caravan/.readers/desk.said`, the reading they now hold. A run reads the second and never writes it, since an acknowledgement a supervisor can write for its reader acknowledges nothing at all -- it is the plan agreeing with the plan. The selftest harness that stands a reader up on the wire names itself as that reader plainly, exactly as it stands up a reading and an address.

**A plan publishes whether it hears.** A record written `receipt = .asked` says: a correction this run carries stays open until the reader's own hand answers it. `receipt = .unasked` is where the rung below leaves it -- the letter is delivered and the plan calls itself finished. The word sits at the plan beside the dispatch, since it instructs about whether a record listens rather than about any one phase.

**An answer is bound to the reading it answers** -- the consensus season's own law, one tier out. A hand naming the reading the letter carries is an agreement; a hand naming any other reading is a different sentence, and a run that counted it as agreement would be reading consent into a stranger's letter.

**A hearing is bounded by the correction that earned it.** Only a letter this run actually carried may be heard, and every carried letter is heard or unheard -- never both and never neither. A run listening for the reply to a letter nobody sent is hearing its own hope.

**The rung earns four refusals, each about the answer rather than the correction that earned it.** `HearEarly` is the moment. `HearUnanswered` is the supply. `HearMiscounted` is the honesty of the count. `HearMisheard` is the answer -- the hard half -- since a report claiming agreement from a hand that named a different reading is worse than the silence below it.

The numbers state the claim: **three refusals stand as a pure fold and a fourth in the run; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts the same correction, carries it to the same reader, spends the same 6 dependents, and settles `carried` either way -- while answers read in the reader's own hand rise 0 to 1 and corrections answered into silence fall 1 to 0. The price is one read of a file the run already knew the name of.** Five RED paths proven first, one a planted control that reports a reader agreeing to a word they never wrote. Module `caravan/hear.rye`, witness `tools/caravan_hear_witness.rish`, and the choir sings 62 rungs in one voice.

## Dispute -- a reader who answers something other than agreement is recorded

**`hear.rye` taught a run to read what its reader answered back** -- the letter carried into the reader's own box, the reader's own hand read out of the box beside it, and an answer bound to the reading it answers, so a hand naming any other reading never counts as agreement. That binding is exactly right, and it is where the listening stops.

**A reader who disagrees is heard and then dropped.** Below this rung a hand naming a different reading earns `HearMisheard` and nothing else: honest about what it refuses, and entirely silent about what that reader actually meant. The person answered in their own word, the plan declined to call it agreement, and the record kept no trace that anybody ever disagreed.

**The measurement is answers set aside without a record.** The rung below weighs a correction against the hand that answered it. This one weighs the record against the answers that hand gave and the plan threw away -- a reader who wrote back plainly, in a word the plan could not accept, into a record that now reads as though the correspondence had closed.

**A dispute names both readings, and resolves neither.** The wire carries two bytes in `caravan/.disputes/plan.dispute`: the reading this run stands behind, and the reading its reader holds. A run writes the pair and stops there, since a supervisor that settled the disagreement in its own favor would be recording a quarrel and calling it a verdict.

**A plan publishes whether its record may hold a disagreement.** A record written `standing = .open` keeps an answer this run cannot accept in both voices. `standing = .settled` is where the rung below leaves it -- the answer is set aside, counted nowhere, and the record reads as one voice.

**A dispute is bounded by the answer that earned it.** Only a hand this run actually read may be disputed, and every answered hand is agreed or disputed -- never both and never neither. A run recording a disagreement with a reader who never wrote is quarrelling with itself.

**The rung earns four refusals, each about the record rather than the answer that earned it.** `DisputeEarly` is the moment. `DisputeUnheard` is the supply. `DisputeMiscounted` is the honesty of the count. `DisputeUnfounded` is the record -- a pair naming one reading twice is agreement wearing a quarrel's clothes, and a record built on it would manufacture a disagreement nobody ever had.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts the same correction, carries it to the same reader, reads the same answer, spends the same 6 dependents, and settles `carried` either way -- while disagreements written into the record rise 0 to 1 and answers set aside without a record fall 1 to 0. The price is two bytes written into a note the run already knew the name of.** Five RED paths proven first, one a planted control that writes `cc` into the record -- a reader who agreed, written down as disputing themselves. Module `caravan/dispute.rye`, witness `tools/caravan_dispute_witness.rish`, and the choir sings 63 rungs in one voice.


## Abide -- the word an operator reads stands beside the reading held against it

**`dispute.rye` taught a run to keep what its reader answered** -- the letter carried into the reader's own box, the reader's own hand read out of the box beside it, and the two readings written into the plan's record in both voices, resolved by neither. That record is exactly right, and it is kept where nobody reads it.

**The record is kept out of sight of the person acting on the word.** A disagreement lands in `plan.dispute`, among the plan's own notes, and an operator looking for the outcome opens `plan.settled` -- a different file, one byte, reading precisely as it would have read had nobody objected at all. The objection is faithfully recorded and entirely invisible where it matters.

**The measurement is words read as settled over a standing disagreement.** The rung below weighs a record against the answers it declined to keep. This one weighs the record against the place a person actually reads -- a settlement opened by an operator who has no way to learn that their own reader holds a different word.

**An escort quotes, and never argues.** The mark is one byte in `caravan/.abidings/plan.beside`: the reading this plan's reader holds. The plan's own word stays exactly as it was written, because an escort adds a voice beside a sentence rather than editing the sentence, and a run that softened its own verdict under objection would be settling the quarrel it promised to leave open.

**A plan publishes whether its word travels alone.** A record written `escort = .escorted` says whoever reads this word reads the objection with it. `escort = .alone` is where the rung below leaves it -- the objection is kept, and kept elsewhere.

**A mark is bounded by the record that earned it.** Only a disagreement this run actually read out of its own notes may be quoted, and only the reader's own reading may be quoted from it.

**The rung earns four refusals, each about the mark rather than the word it stands beside.** `AbideEarly` is the moment. `AbideUnrecorded` is the supply. `AbideMiscounted` is the honesty of the count. `AbideMisquoted` is the record -- an escort carries one person's word to whoever reads another, so a mark naming any other reading puts a sentence in that person's mouth.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, spends the same 6 dependents, and settles `carried` either way -- while published words standing beside the reading against them rise 0 to 1 and words an operator reads with no sign of the objection fall 1 to 0. The price is one byte written into a note the run already knew the name of.** Five RED paths proven first, one a planted control where the mark quotes the plan's own reading -- the plan recorded as its own objector, with the selftest still calling itself GREEN. Module `caravan/abide.rye`, witness `tools/caravan_abide_witness.rish`, and the choir sings 64 rungs in one voice.


### lapse -- an objection is put back to its reader, and answered or let go

**`abide.rye` taught a run to stand its published word beside the reading held against it** -- the disagreement quoted in one byte where the settlement is read, the plan's own word untouched beside it, and an operator who finds the objection in the same reach that finds the outcome. That escort is exactly right, and it never says for how long.

**A mark says somebody objects, and never says for how long.** An objection recorded once escorts every future read of that word. Nothing asks whether the person who raised it still holds it, and nothing ever will, so a plan carries a live quarrel long after there is anybody left to have it -- and every operator who reads that word is answering to a mind that may have changed a season ago, or gone silent for good.

**The measurement is objections published with no term on them at all.** The rung below weighs a record against the place a person reads. This one weighs the record against the life of the person who wrote it -- an objection standing on every future reader, which nobody has been asked to renew and nobody may let go.

**A term asks, and never decides.** The act is one question written into the reader's own `caravan/.readers/desk.again`, naming both readings of the quarrel exactly as the record names them, and then one byte published in `caravan/.lapsings/plan.term`: `r` for an objection its reader raised again, `l` for one nobody renewed.

**A term reports, and never withdraws.** The escort stays exactly as it was written, because a run that erased the mark because its reader went quiet would be winning the quarrel by outlasting them.

**Silence belongs to the person who is silent.** No run of this plan ever writes its reader's renewal, exactly as no run writes their first answer. The supervisor's whole part is to ask plainly, read what it finds, and report honestly when it finds nothing.

**The rung earns four refusals, each about the term rather than the objection it bounds.** `LapseEarly` is the moment. `LapseUnasked` is the hard half -- a lapse published without the question ever leaving the building is silence nobody listened for, since nobody went quiet where nobody was addressed. `LapseMiscounted` is the honesty of the count. `LapseMisrenewed` is the record -- a second hand naming any other reading raises a different quarrel entirely.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, escorts the same published word, spends the same 6 dependents, and settles `carried` either way -- while standing objections put back to the reader who raised them rise 0 to 1 and objections published with no term on them at all fall 1 to 0. The price is one question written into a box the run already knew the name of, and one byte beside the word it bounds.** Both answers the question admits are proven on the wire rather than only as folds: a third run over a reader who raises their objection again publishes `renewed`. Five RED paths proven first, one a planted control where every guard is disarmed at once and the run publishes an objection let go by a reader who was never addressed -- `desk.again` never written, the question fabricated from the plan's own record, and the selftest still calling itself GREEN. Module `caravan/lapse.rye`, witness `tools/caravan_lapse_witness.rish`, and the choir sings 65 rungs in one voice.


### repose -- a mark carries the standing of the objection it quotes

**`lapse.rye` taught a run to put an objection back to the reader who raised it** -- the question written into that reader's own box, the answer read out of it, and one byte naming what became of the quarrel. That term is exactly right, and it is filed where the deciding happened.

**A mark reads the same whether the quarrel is live or long over.** The escort in `plan.beside` is one byte naming the reading its reader holds, and that byte is identical the day the objection is raised and the season after nobody renewed it. The term says which -- in a note of its own, to a reader who has no reason to know that note exists. So an operator opening the one file the mark lives in reads a live quarrel, every time, forever.

**The measurement is objections escorted whose standing an operator cannot read.** The rung below weighs a record against the life of the person who wrote it. This one weighs what that weighing ever reached: a term decided where the deciding happened and never carried to the mark itself, which is a finding filed rather than delivered.

**A standing rides in the mark, never in a second file.** The act is one byte appended to the escort the rung below wrote, so `caravan/.reposings/plan.beside` reads `sq` -- the reader's own reading first, exactly as they earned it, and the standing of their objection second: `h` for one they raised again and still hold, `q` for one at repose, which nobody renewed. There is no second note to know about, and every elder reader of that file still reads the mark it always read.

**A repose reports, and never withdraws.** The mark's first byte is never touched, and no lapse ever takes an escort down. An objection let go keeps escorting every future read of that word -- it simply stops pretending its reader is still standing behind it.

**The rung earns four refusals, each about the standing rather than the objection it reports on.** `ReposeEarly` is the moment. `ReposeUnweighed` is the hard half -- a standing published where nobody ever put a term on the objection has decided a person's mind rather than read it. `ReposeMiscounted` is the honesty of the count. `ReposeMisread` is the record -- a standing that disagrees with the term the wire itself carries puts a word in the reader's mouth at the one place their word is read.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, escorts the same published word, asks the same reader whether they still object, reads the same silence, spends the same 6 dependents, and settles `carried` either way -- while marks carrying the standing of the objection they quote rise 0 to 1 and objections escorted whose standing an operator cannot read fall 1 to 0. The price is one byte appended to a note the run had already written.** Both answers the question admits are proven on the wire rather than only as folds: a third run over a reader who raises their objection again publishes `h` beside an untouched `s`. Five RED paths proven first, one a planted control where every guard is disarmed at once and the run publishes an objection at repose over a reader who was never asked -- `plan.term` and `desk.again` both absent from the wire, and the selftest still calling itself GREEN. Module `caravan/repose.rye`, witness `tools/caravan_repose_witness.rish`, and the choir sings 66 rungs in one voice.

### tidings -- the reader who raised a quarrel is told how it came out

**`repose.rye` taught a mark to carry the standing of the objection it quotes** -- one byte appended to the escort, so an operator opening the objection reads whether anybody is still behind it. That finding is exactly right, and it lands exactly where every other finding of this arc lands: at the place a word is read.

**Nothing has ever gone back to the person who raised the quarrel.** The record keeps their disagreement, the escort stands their objection beside the word, the term puts the question back to them, and the mark publishes what became of it. Every one of those notes is written where an operator reads. The reader who objected is written to once, early, with a correction -- and then hears nothing again, however the season turns out.

**The measurement is objections weighed whose raiser was never told how it came out.** The rung below weighs what a finding ever reached at the mark. This one weighs what the whole arc ever reached at the person it began with: a quarrel decided in its raiser's absence, which is a season of work done on somebody's behalf and never reported to them.

**A tiding is written where the reader is, in the box they already know.** The act is one byte into that reader's own `caravan/.readers/desk.outof`, beside the letter this arc already carried them and the question it already asked them: `m` for a word their objection stood against that reads differently now, `t` for one that reads exactly as it read. A reader who has heard from this plan twice hears from it a third time in the place they already look.

**A tiding reports, and never argues.** It grades no objection and names no winner. It reads the word the reader stood against and the word the plan finally settled, and says whether they are the same -- which is the one thing a person who objected to a word actually asked.

**The rung earns four refusals, each about the writing back rather than the quarrel it reports on.** `TidingsEarly` is the moment -- a run writing to a raiser it never heard from is answering a letter that never arrived. `TidingsUnweighed` is the hard half: a run that tells somebody how a quarrel came out where nothing ever came of it has invented a season's work on their behalf. `TidingsMiscounted` is the honesty of the count. `TidingsMisread` is the record -- an answer that disagrees with the two words the wire carries sends a reader away believing the wrong season.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, escorts the same published word, asks the same reader whether they still object, reads the same silence, stands the same mark, spends the same 6 dependents, and settles `carried` either way -- while raisers told how their own quarrel came out rise 0 to 1 and objections weighed whose raiser was never told how it came out fall 1 to 0. The price is one byte in a box the arc had already written to.** The answer the lap sends is the uncomfortable one, and it is the true one: this reader objected to `carried`, and `carried` is what the plan finally settled, so the box reads `t`. Both answers ride the wire rather than only the fold -- the `moved` answer is written to a reader of its own, read back out of their box, and cleared again. Five RED paths proven first, one a planted control where every guard is disarmed at once and the selftest calls itself GREEN while `desk.outof` is absent from the raiser's box entirely, beside a `desk.told`, a `desk.again`, and a `desk.still` that all arrived. Module `caravan/tidings.rye`, witness `tools/caravan_tidings_witness.rish`, and the choir sings 67 rungs in one voice.
### appeal -- the reader who is told how a quarrel came out may answer that telling

**`tidings.rye` carried the whole arc's finding back to the person it began with** -- one byte into that reader's own box, naming whether the word they objected to reads differently now or reads exactly as it read. That is the first thing this arc ever sent outward, and it is right.

**It is also the last word.** A reader told `t` -- your word stood -- has read a season's answer to their own quarrel and has nowhere to put what they think of it. They may accept it, they may press the case still, and either way the plan hears nothing: every note beneath this rung travels one direction, from the run to the reader, and the run never looks back.

**The measurement is readers who answered how their quarrel came out and whom no run ever read.** The rung below weighs what the arc finally reached at the person it began with. This one weighs what that person reached back -- a reply written in their own hand into their own box, sitting there unread while the plan reports itself finished.

**An appeal is read where the reader wrote it, and recorded where an operator reads.** The act is two halves facing opposite ways: one byte the reader writes into their own `caravan/.readers/desk.press` -- `a` for an outcome they accept, `p` for a quarrel they press still -- and one byte the run writes into `caravan/.appeals/plan.appeal`, so an operator opening this plan reads whether the person who raised the quarrel is content with how it came out.

**A plea is quoted, and never composed.** No run of this plan ever writes a reader's `.press`, exactly as no run writes their answer or their renewal. A supervisor that could file a plea on a reader's behalf would be pressing an objection it invented and then reading its own handwriting back as consent.

**The rung earns four refusals, each about the reading back rather than the quarrel it closes.** `AppealEarly` is the moment -- a run reading a plea where nobody was ever told is hearing a reply to a letter it never sent. `AppealUnvoiced` is the hard half: a plea recorded where the reader's own hand wrote nothing is a supervisor filing an objection on their behalf and calling it theirs. `AppealMiscounted` is the honesty of the count. `AppealMisrecorded` is the record -- a published plea that disagrees with the byte in the reader's own box tells every future operator the wrong thing about a living person.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, escorts the same published word, asks the same reader whether they still object, reads the same silence, stands the same mark, tells the same raiser how it came out, spends the same 6 dependents, and settles `carried` either way -- while readers whose reply was read back rise 0 to 1 and readers who answered how their quarrel came out and were never read fall 1 to 0. The price is one byte in a note an operator already opens.** Both pleas ride the wire rather than only the fold: the accepting plea is written by a reader of the fold's own and read back out of their box, and a third run over a reader who accepts publishes `a` beside an untouched mark. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the note never written, the read-back skipped, the provisioning invariant, and all three harness reads -- and the selftest calls itself GREEN while `plan.appeal` still holds the cleared zero byte, beside a `desk.press` reading `a` that nobody ever opened. Module `caravan/appeal.rye`, witness `tools/caravan_appeal_witness.rish`, and the choir sings 68 rungs in one voice.

### endure -- a quarrel its holder still presses outlives the run that heard it

**`appeal.rye` opened the last door** -- the reader who was told how their quarrel came out may answer that telling, one byte in their own hand, published where an operator opens the plan. The arc finally listens.

**It listens for exactly one run.** The provisioning that opens the next run clears `plan.appeal` along with every other note, and it is right to: a finding belongs to the run that made it, and a record wearing the last run's judgment is a record nobody can trust. Yet a plea is no finding. It is a living person saying the matter is not over, and clearing it by morning means every run opens on a reader whose position the plan has already forgotten.

**The measurement is pressed quarrels a run heard and the run after it began without.** The rung below weighs what a reader reached back at the run. This one weighs the first thing in the whole arc that reaches past a single run -- a position stated plainly, recorded honestly, and swept away by the next provisioning before anybody could act on it twice.

**A contentment is spent; a pressing stands.** The judgment is one line because the distinction is one line. A reader who **accepts** how their quarrel came out has closed it, and carrying that forward would hold a living person to a word they spoke about a plan since run again -- exactly the harm the clearing prevents. A reader who **presses** has said the opposite, and a position stated that way stands until its holder says otherwise. Carrying the first is presumption; dropping the second is forgetting.

**A position is carried where the next run will open it.** One byte into `caravan/.endures/plan.standing`, and it is the only note of this whole arc a provisioning leaves alone. Every other note here is cleared so no run wears another's findings; this one survives so no run opens blind to a quarrel still live.

**A position is quoted, and never composed.** No run of this plan writes a reader's plea, and no run of this plan drops a standing one. `clear_standing` exists for a fresh tree and for the selftest that stands in for one; a supervisor that could close a quarrel on its holder's behalf would be doing the forgetting on purpose.

**The rung earns four refusals, each about what a run hands the run after it.** `EndureEarly` is the moment -- a run carrying a position where it read nobody hands the next run a quarrel that belongs to no one. `EndureUnpressed` is the hard half -- a contentment carried forward takes a person who said the matter was closed and hands the next run their objection anyway. `EndureMiscounted` is the honesty of the count: every position this run heard is carried forward or let go, never both and never neither. `EndureMisremembered` is the record -- the next run opens that byte and begins its whole season believing a person is still in a quarrel, so it must be the quarrel this run actually heard.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same answer, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, reads the same reply, spends the same 6 dependents, and settles `carried` either way -- while positions carried past the run that heard them rise 0 to 1 and pressed quarrels the run after this one begins without fall 1 to 0. The price is one byte in a note the next provisioning leaves alone.** The one property no single run can show from inside itself is proven as its own fold: the byte is written, a provisioning runs over it, `plan.appeal` comes back cleared and `plan.standing` comes back unchanged. A third run whose reader accepts carries nothing of its own, and the position pressed two runs earlier still stands. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the note never written, the read-back skipped, the wire fold's survival read, and both harness reads -- and the selftest calls itself GREEN while `caravan/.endures/plan.standing` does not exist at all. Module `caravan/endure.rye`, witness `tools/caravan_endure_witness.rish`, and the choir sings 69 rungs in one voice.


### heed -- a plan run under a quarrel it inherited says so

**`endure.rye` opened the last door** -- a quarrel its holder still presses outlives the run that heard it, one byte in the only note a provisioning leaves alone. Every run after that one opens knowing.

**And knowing is all it does.** Nothing in the arc obliges a run to answer a position it inherited. It reads the note, takes up its record, carries the work home, and publishes `carried out whole` -- exactly the settlement it would have published had nobody ever raised a word against it. So a quarrel can stand forever in a note every run reads and no run answers.

**The measurement is plans reported carried while an inherited quarrel stood against them.** The rung below weighs what one run hands the next. This one weighs what the run receiving it owes back -- and the honest debt is small, since a supervisor can neither settle a quarrel nor withdraw one. What it can do is refuse to publish its outcome as if the quarrel were not there.

**The work is honest, and the word is not the whole of it.** The plan really was carried; nothing here softens that, and both runs of the lap settle `carried out whole`. What the regard adds is company: one byte in `caravan/.heeds/plan.regard` saying a living person's objection was open when this run began and is open still, so the reach that finds the outcome finds the quarrel standing over it.

**A regard is read before the record is taken up.** The heeding reads the standing note as the first act of the run and publishes only at the end, and that ordering is the rung. After `endure` writes at the end, the standing note may hold *this* run's own quarrel, and a plan qualifying its word by an objection it raised itself would be reading its own handwriting back as somebody else's judgment.

**A quarrel survives a provisioning; a word about one does not.** The seam is the whole distinction, and it is proven as its own fold: the position belongs to the person holding it, so it endures, and the regard belongs to the run that said it, so it clears with every other finding.

**A position is weighed, and never withdrawn.** No run of this plan writes the standing note and no run clears it. After the weighing run, `plan.standing` reads `p` exactly as it did before -- untouched by the very act of answering it.

**The rung earns four refusals, each about what a run owes a position it did not make.** `HeedEarly` is the moment -- a run publishing a regard where nothing stood tells an operator about a quarrel nobody holds. `HeedUnpressed` is the hard half -- a word standing under a byte no endurance would ever have written publishes an objection nobody ever made. `HeedMiscounted` is the honesty of the count: every position this run inherited is weighed into its word or left standing beside it, never both and never neither. `HeedMisrecorded` is the record -- an operator opens that byte beside the settlement and takes the two together as the whole outcome.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; a plan nobody ever pressed a quarrel against weighs nothing at all; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same accepting answer, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, spends the same 6 dependents, and settles `carried` either way -- while inherited positions weighed into the run's own word rise 0 to 1 and plans reported carried under a quarrel nobody weighed fall 1 to 0. The price is one byte beside a settlement the run had already published.** This run's own reader **accepts**, on purpose, so nothing it heard itself could account for the regard it publishes. The four notes at the end read the rung in miniature: `plan.settled` reads `c`, `plan.standing` reads `p`, `plan.appeal` reads `a`, and `plan.regard` reads `u`. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the note never written, the read-back skipped, the wire fold's read, and the harness read -- and the selftest calls itself GREEN while `caravan/.heeds/plan.regard` holds only the provisioning's zero byte. Module `caravan/heed.rye`, witness `tools/caravan_heed_witness.rish`, and the choir sings 70 rungs in one voice.

### relent -- a quarrel its holder withdraws stops standing

**`heed.rye` opened the last door** -- a plan run under a quarrel it inherited says so in the word an operator reads, one byte beside the settlement. The arc finally answers a position it did not make.

**And it answers it every run, forever.** The standing note is the one record a provisioning leaves alone, by design, so no run opens blind to a live quarrel -- and nothing in the whole arc ever takes it down. A person may say the matter is over on the very next run, in their own hand, in the same box the arc already reads, and the note stands, and the next run stands under it, and so does the run after that.

**The measurement is withdrawn quarrels that went on standing.** The rung below weighs what a run owes a position it inherited. This one weighs what that position owes the person holding it -- an end, once they ask for one.

**The judgment is one line, and it is whose hand wrote it.** A reader whose box still reads a pressing has said nothing new, and a position stands until its holder says otherwise. A reader whose box now reads a contentment has closed their own quarrel, and that is the one word this arc has ever taken as closing one. An empty box closes nothing: silence is no consent here, and reading it as consent would close a living person's quarrel for them.

**A note comes down before the record is taken up.** The relenting is the first act of the run rather than the last, and that ordering is the rung -- the note it may take down is the note every step after it reads, and a position its holder released should never have stood there to be weighed at all.

**A quarrel is closed by its holder, and never by the supervisor.** The whole arc beneath this holds one line: a run may weigh a quarrel, report it, escort it, and carry it past itself, and it may never close one. This rung keeps that line exactly -- the clearing runs only where a living person's own hand wrote that the matter is over, and `RelentUnwithdrawn` refuses it everywhere else.

**The regard falls with the quarrel.** A word stops standing under a position that no longer stands, so the plan whose quarrel was withdrawn publishes its outcome alone again -- honestly, since nothing is left standing over it. Two numbers move together, and naming that as one finding is the honest reading.

**The rung earns four refusals, each about closing something somebody else opened.** `RelentEarly` is the moment -- a run clearing a note where nothing stood is forgetting a quarrel nobody ever held. `RelentUnwithdrawn` is the hard half. `RelentMiscounted` is the honesty of the count: every position this run inherited is let go or left standing, never both and never neither. `RelentMisrecorded` is the record -- every run after this one opens that note and begins its season by it, so it must say what this run actually left there.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; a quarrel its holder still presses stands through a run allowed to close one; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same accepting answer, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, spends the same 6 dependents, and settles `carried` either way -- while standing positions let go on their holder's own word rise 0 to 1, withdrawn quarrels still standing over the plan fall 1 to 0, and the regard falls with them, 1 to 0. The price is one note taken down, at no cost in work at all.** The property that makes a withdrawal worth having is proven as its own fold: the note survives a provisioning while it stands, and stays down once it is taken down, because a quarrel that came back with the morning would be no closer to over than one no run ever answered. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the clearing skipped, the read-back skipped, the wire fold's two reads, and both harness reads -- and the selftest calls itself GREEN while `caravan/.relents/plan.standing` still reads `p` and `plan.regard` still reads `u`, so an operator would open a quarrel its holder closed weeks ago and a word still standing under it. Module `caravan/relent.rye`, witness `tools/caravan_relent_witness.rish`, and the choir sings 71 rungs in one voice.


### dwell -- a standing quarrel says how long it has stood

**`relent.rye` opened the last door** -- a quarrel its holder withdraws stops standing over the plan, on that holder's own word and on nobody else's. The arc finally lets a quarrel end.

**And it ends only where its holder returns to end it.** A person who raised a position and then went quiet has said nothing, and silence is no consent here -- rightly, since reading it as one would close a living person's quarrel for them. So their note stands, run after run, exactly as it should.

**The measurement is standing quarrels whose note never said how long.** The rung below weighs whether a position may come down. This one weighs what an operator can learn about a position that stays: the note carries one byte, the quarrel itself, and reads identically whether it arrived on the last run or has outlasted a hundred. Those two ask for very different attention.

**The age is a fact about the quarrel, not a finding of any run.** So it survives a provisioning beside the standing note -- the one other record a provisioning leaves alone -- and it comes down with that note the moment its holder lets the matter go. A count reset each morning would call the oldest position on the wire brand new.

**An age only ever climbs.** The runs a position stood through already happened, and no later run can unhappen them, so a run reads the age already on the wire before it writes and `DwellForgotten` refuses any age that would shorten it. At the bound of one byte the count holds rather than wrapping, which says *at least* 255 runs and never rolls a long quarrel back to nothing.

**The dating is the last act of the run rather than the first**, and that ordering is the rung -- a position has stood through this run only once the run is over, and the relenting at the top may already have taken down the very note an age would be written beside.

**The quarrel itself is untouched.** This rung says how long a position has stood and never whether it stands at all: the word standing under it keeps its company, the settlement keeps its meaning, and the holder keeps the only hand that closes anything.

**The rung earns four refusals, each about the honesty of a number an operator will trust.** `DwellEarly` is the moment -- a run dating a position where nothing stands tells an operator the age of a quarrel that is over. `DwellForgotten` is the hard half. `DwellMiscounted` is the honesty of the count: every position left standing is dated or left bare, never both and never neither. `DwellMisrecorded` is the record -- every run after this one opens that byte and reads a quarrel's whole history in it.

The numbers state the claim: **three refusals stand as a pure fold and the fourth beside them; a plan that loses nothing reads as the line handed, all 16 pairs; a plan nobody ever pressed a quarrel against carries no age at all; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, publishes the same word standing under it, spends the same 6 dependents, and settles `carried` either way -- while standing positions this run said the age of rise 0 to 1 and standing quarrels whose note never said how long fall 1 to 0. The price is one byte beside the position, at no cost in work at all.** The two properties that make an age worth writing are proven as their own fold: it survives a provisioning beside the position it counts, and it falls with that position when its holder lets the matter go. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back skipped, and both harness reads -- and the selftest calls itself GREEN while `caravan/.dwells/plan.dwell` does not exist at all and `plan.standing` still reads `p`, so an operator would open a quarrel of wholly unknown age and be told its age was recorded. Module `caravan/dwell.rye`, witness `tools/caravan_dwell_witness.rish`, and the choir sings 72 rungs in one voice.


### swell -- a long-standing quarrel reads where the outcome is read

**`dwell.rye` opened the last door** -- a standing quarrel says how many runs it has stood through, honestly and durably, in one byte beside the position itself. So the age exists at last, and it is exact.

**And it lives in `plan.dwell`, which is a note you have to go looking for.** The place an operator actually opens -- the settlement, the regard, the word the plan came to -- says nothing about it. A quarrel of two hundred runs and one raised this morning read exactly alike there, and the difference is available only to whoever thinks to ask.

**The measurement is long-standing quarrels an operator reads no louder than a fresh one.** The rung below writes an age; this one spends it, at the one place a reading costs nobody a second file to know about.

**The bound is named in the module and no run may move it.** A threshold a plan could pass in would let any plan quiet its oldest quarrel by naming a larger number, which is precisely the move this rung exists to refuse -- a supervisor grading the objections raised against itself. Three runs is the smallest count that means *this has outlasted a passing lap*, and the reading is inclusive at the bound, since a position that has stood the named number of runs has already outlasted them.

**The reading comes off the wire, never off memory.** A run opens the age actually written beside the position rather than the age it believes it wrote a moment ago, and `SwellUndated` refuses by name where no age is there at all -- a standing computed from an age nobody wrote is a guess wearing a measurement's clothes, and it would read loudest of all.

**The heralding is the last act of the run**, after the dating below it, because the age this rung reads is the age that dating just left on the wire -- and because the relenting above may already have taken down the very position a standing would speak about.

**A herald reports, and never argues.** It grades no objection, names no winner, and moves no word: the settlement reads exactly as it would have read had nobody objected at all, the quarrel stands exactly where its holder left it, the age below is untouched, and the word standing under it keeps its company. This rung says how loudly a position reads, and nothing else.

**The standing falls with the quarrel, and survives a provisioning**, as the age does -- since a byte left behind beside the outcome would go on shouting for a quarrel its own holder let go, and a herald cleared every morning would quiet the oldest position on the wire.

**The rung earns four refusals, each about the honesty of a word an operator reads without going looking.** `SwellEarly` is the moment -- a run publishing a standing where nothing stands announces the volume of a quarrel that is over. `SwellUndated` is the hard half. `SwellMiscounted` is the honesty of the count: every position left standing is heralded or left unpublished, never both and never neither. `SwellMisrecorded` is the record -- this byte sits where the outcome is read, so a note disagreeing with the standing this run weighed would be the loudest wrong word on the wire.

The numbers state the claim: **four refusals stand as a pure fold; a plan that loses nothing reads as the line handed, all 16 pairs; a quarrel raised on this very run is published quietly and honestly; a plan nobody ever pressed a quarrel against publishes no standing at all; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same word standing under it, spends the same 6 dependents, and settles `carried` either way -- while standing quarrels published where the outcome is read rise 0 to 1 and long-standing quarrels an operator reads no louder than a fresh one fall 1 to 0. The price is one byte beside the outcome, at no cost in work at all.** The two properties that make a published standing trustworthy are proven as their own fold: it survives a provisioning beside the position it speaks for, and it falls with that position when its holder lets the matter go. Five RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back skipped, and both harness reads -- and the selftest calls itself GREEN while `caravan/.swells/plan.swell` does not exist at all and `plan.standing` still reads `p` beside an age of 4, so an operator would open a quarrel four runs old and be told its standing was published. Module `caravan/swell.rye`, witness `tools/caravan_swell_witness.rish`, and the choir sings 73 rungs in one voice.


### refer -- a long-standing quarrel goes before a hand that is neither party

**`swell.rye` opened the last door** -- a long-standing quarrel is published right where an operator reads the outcome, in one byte beside the settlement. So the standing is visible at last, and it is honest.

**And then the run goes on exactly as it always ran.** Nothing in the arc so far asks a plan to *do* anything about a standing it has published, so a supervisor may announce an old objection forever and change nothing at all. The two hands holding the argument stay the two hands that cannot end it: one may not grade an objection raised against itself, and the other has already said what they think.

**The measurement is long-standing quarrels nobody outside the argument ever sees.** The rung below prints how loudly an objection reads. This one carries the case, once, to somebody who has not spoken yet.

**The forum is read off the wire, never chosen by a run.** A supervisor able to name the hand weighing an objection against it has named its own judge, and naming the judge is most of what a judge does. `plan.forum` is seated by an operator before any quarrel exists, and a run's whole part is to read it -- `ReferUnaddressed` refuses by name where nothing stands there at all, a configuration reachable by argument alone, which is what makes that guard load-bearing.

**A forum that names a party has heard nothing.** `ReferParty` is the rung itself, refused by name: a case landing in the box of the reader who raised the quarrel wears the look of a hearing while being none.

**The case is copied, never summarized.** Three facts come off the wire in the run that sends them -- what the plan came to, how loudly the objection reads, and how many runs it has stood -- because a summary is exactly where a supervisor would get to shade the argument against itself.

**The referring is the last act of the run**, after the heralding below it, because the standing it carries out is the standing that heralding just published -- and because the relenting above may already have taken down the very quarrel a case would be built from.

**A referral carries, and never argues.** The settlement reads exactly as it would have read had nobody objected at all, the quarrel stands where its holder left it, the age and the standing below are untouched, and the word standing under it keeps its company. This rung changes who has seen the argument, and nothing else.

**A case, once carried, belongs to the desk it landed on.** It survives a provisioning, as every record of a quarrel does -- and it survives the withdrawal of the quarrel itself, which nothing else in this arc does. A supervisor able to take a case back off a third hand's desk would have referred nothing; it would have shown somebody a document and then closed their hand around it.

The numbers state the claim: **five refusals stand by name -- early, unaddressed, party, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a quarrel raised on this very run is left with the people having it; a plan nobody ever pressed a quarrel against carries no case anywhere; and one plan of 6 phases run twice absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, spends the same 6 dependents, and settles `carried` either way -- while long-standing quarrels carried to a hand that is neither party rise 0 to 1 and long-standing quarrels nobody outside the argument ever sees fall 1 to 0. The price is three bytes on one desk, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back skipped, and both harness reads of the desk -- and the selftest calls itself GREEN while `caravan/.readers/bench.case` does not exist at all beside a quarrel four runs old still reading loud, so an operator would believe a third hand had the case in front of them. The lap turned its own ratchet too: gathering the six quarrel words into one `Quarrel` shape brought `run_in_refer` back under seventy lines, and the harness split at its own seam, so the tree-wide past-70 roster stays clean. Module `caravan/refer.rye`, witness `tools/caravan_refer_witness.rish`, and the choir sings 74 rungs in one voice.


### deem -- the hand a case went to is read back, and its finding published

`refer.rye` above puts a quarrel old enough to count before a hand that is neither party to it, three facts copied off the wire onto a desk outside the argument. So the case travels at last, and it travels whole. **And then nothing comes home.** Nothing in the arc asks what that hand made of it, so a plan may refer the same quarrel every run for a season and never once be told. The argument gains a document and loses none of its stuckness.

**The finding is read off the wire, never written by a run.** A supervisor able to author the word against it has graded its own objection, which is the whole thing the referring existed to prevent. The answer stands in the third hand's own box, written by that hand at a time no run controls, and a run's entire part is to read it and to say plainly when it finds nothing. `DeemSilent` refuses by name where the box holds nothing at all, and a run facing a silent desk leaves the case honestly waiting rather than supplying a verdict of its own.

**A finding must name the case it answers.** A desk that has heard this argument before may still hold the answer to an older one -- an earlier settlement, a younger quarrel -- and a plan publishing that beside today's outcome would put a third hand's name on a word they never said about this work. So a finding carries four bytes: the three that named the case, echoed back exactly as they were sent, and one more saying what the hand made of it. `DeemMismatched` is the rung itself.

**A word from outside carries, and never decides.** The finding says what a third hand makes of the argument; it settles nothing. In the measured lap the bench finds *for the reader who objected* and the plan still reads `carried out whole` -- the settlement, the quarrel, its age, its standing, the case on the desk, and the word standing under it each coming out of a reading run exactly as they went in.

**The reading is the last act of the run**, after the referring below it, because the case a finding is weighed against is the case that referring just carried -- and because a run that carried nothing out is owed no answer by anybody.

**A finding belongs to the hand that wrote it.** It survives a provisioning of this plan, and taking down the plan's own published copy never reaches onto somebody else's desk to unsay what they said. A supervisor able to edit the answer it quotes would be grading the objection against it after all.

The numbers state the claim: **five refusals stand by name -- unreferred, silent, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a run owed no word from anybody publishes none; a plan nobody ever pressed a quarrel against is answered by nobody; a desk that has said nothing yet leaves the case honestly waiting; and one plan of 6 phases run twice -- with the same answer sitting in the same box both times -- absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, carries the same case to the same third hand, spends the same 6 dependents, and settles `carried` either way -- while carried cases whose answer was read and published rise 0 to 1 and cases carried out that nobody is ever heard back on fall 1 to 0. The price is one byte beside the outcome, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back dropped, and the harness read of the note replaced by the answer it hoped for -- and the selftest calls itself GREEN while `caravan/.deems/plan.deem` does not exist at all, so an operator would believe a hand outside the argument had spoken to them. Module `caravan/deem.rye`, witness `tools/caravan_deem_witness.rish`, and the choir sings 75 rungs in one voice.


### avow -- the plan says on the record what it makes of the finding against it

`deem.rye` above reads back the hand a case went to and publishes what they made of it in the one byte an operator opens. So the answer comes home at last, and it comes home whole. **And then the plan goes on exactly as it always went.** Nothing in the arc asks a supervisor to answer the finding it just published, so it may print `a hand outside the argument finds for the reader who objected` beside `carried out whole`, every run for a season, and let that finding touch nothing whatever about what it does next. The argument gains a verdict and loses none of its stuckness.

**A run writes this note, and that is the whole rung.** Every record the arc has reached outward for -- the reader's reply, the third hand's finding -- is written by a hand this plan does not own, precisely so a supervisor can never grade the objection against it. An avowal is the opposite kind of record: the plan answering *for itself*, in its own hand, which is exactly what it owes a verdict it went looking for. Saying so decides nothing; it only stops the silence from being free. `AvowUnheard` refuses by name where a run read no finding at all.

**An avowal answers a particular finding.** A plan that has answered this argument before may still be holding its word on an older verdict -- one for its own reading, from a run before the third hand changed their mind -- and publishing that beside today's finding would tell an operator the plan had spoken to something it never spoke to. So an avowal carries two bytes: the finding echoed back exactly as it was published, and one more saying what the plan makes of it. `AvowMismatched` is the rung itself.

**Answering is not yielding.** The plan may concede the finding and say the work is owed another look, or keep its own word and say so where the finding is read; both are honest answers, proven on the wire, and the rung asks for neither in particular. The settlement, the quarrel, its age, its standing, the case on the desk, and the finding itself each come out of an avowing run exactly as they went in.

**The avowing is the last act of the run**, after the reading below it, because the finding a plan answers is the finding that reading just published -- and because a run that heard nothing from anybody is fairly asked to answer nothing.

**An avowal is the plan's own.** It survives a provisioning, as every record of this argument does, and it falls with the finding it answers, since a word left standing beside a verdict no longer published would have the plan answering an argument nobody is making.

The numbers state the claim: **five refusals stand by name -- unheard, unfound, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a run owed no word from anybody answers none; a plan nobody ever pressed a quarrel against is answered by nobody; a desk that has said nothing yet leaves the plan nothing to answer; a plan may keep its own word and is made to say so; and one plan of 6 phases run twice -- reading the same finding off the same desk both times -- absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, carries the same case to the same third hand, reads back the same finding, spends the same 6 dependents, and settles `carried` either way -- while published findings the plan answered on the record rise 0 to 1 and findings a plan published and never said one word about fall 1 to 0. The price is two bytes beside the finding, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back dropped, and the harness read of the note replaced by the answer it hoped for -- and the selftest calls itself GREEN while `caravan/.avows/plan.avow` does not exist at all, so an operator would believe the plan had answered a finding it never once addressed. One of those probes taught the rung its own shape: the first cut read the published finding off the wire before consulting the refusal ladder, so a run that heard nothing refused `AvowUnfound` where the ladder promised `AvowUnheard`; the read now supplies the ladder rather than short-circuiting it, and every refusal is reached by argument. Module `caravan/avow.rye`, witness `tools/caravan_avow_witness.rish`, and the choir sings 76 rungs in one voice.


### owe -- a concession the plan made reaches the run that comes after it

`avow.rye` above makes a supervisor say, in its own hand and beside the outcome an operator opens, what it makes of the finding standing against it. So the plan answers at last, and it answers on the record. **And then the answer costs it nothing.** A plan may say `the plan takes the finding, and says the work is owed another look` -- and the run ends, and the run after it opens owing nothing at all. Nothing on the wire remembers the admission, so a supervisor may take every finding ever put to it, promise another look every single time, and begin each morning clean. The argument gains an admission and loses none of its stuckness.

**The debt is the only note in the arc written for a run that has not started.** Every other record this arc keeps is a record *of* the run that wrote it -- what was lost, what was said, what a third hand made of it. A debt is addressed forward, and that is exactly what makes a concession cost something: it is still there when the plan next opens its own notes. `OweUnsaid` refuses by name where the plan said nothing at all.

**A plan that keeps its own word owes nothing.** Answering is not yielding, and the rung below proved it; this rung holds the other half of that promise. A dissent books no debt, because booking one would turn holding one's ground into an admission of fault -- which would make the honest answer the expensive one, and teach every supervisor to concede nothing. `OweUnconceded` refuses by name.

**A debt names the concession it carries.** A plan that conceded some earlier argument may still hold that older debt, and leaving it standing beside today's admission would have a later run meeting a concession this plan never made about the work in front of it. So a debt carries two bytes: the finding echoed back exactly as the plan conceded it, and the outcome it was conceded under -- a plan that said `carried out whole` while conceding owes a different look than one that had already reported itself short. `OweMismatched` is the rung itself.

**Booking is not repairing.** The debt says the plan owes the work another look; it never decides what that look finds, and it never reaches back into the run that booked it. The settlement, the quarrel, its age, its standing, the case on the desk, the finding, and the plan's own word on it each come out of a booking run exactly as they went in.

**The booking is the last act of the run**, after the avowing below it, because the concession a debt carries is the concession that avowing just published -- and because a run that said nothing has admitted nothing to carry anywhere.

**A debt outlives the run that made it.** It survives a provisioning, since a debt swept every morning would let a plan concede at bedtime and wake owing nothing, and it falls with the concession it carries, since a debt standing beside a word the plan no longer holds would have a later run meeting an admission nobody is making.

The numbers state the claim: **five refusals stand by name -- unsaid, unconceded, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a plan keeping its own word owes the work nothing and books nothing; a plan that says nothing concedes nothing and books nothing; a run owed no word from anybody answers none; and one plan of 6 phases run twice -- conceding the same finding in the same words both times -- absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, carries the same case to the same third hand, reads back the same finding, answers it on the record either way, spends the same 6 dependents, and settles `carried` either way -- while concessions booked as a debt the next run finds rise 0 to 1 and concessions a plan made that reach no run after them fall 1 to 0. The price is two bytes beside the plan's own word, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back dropped, and both harness reads of the debt replaced by the answer they hoped for -- and the selftest calls itself GREEN while `caravan/.owes/plan.owe` does not exist at all, so an operator would believe a concession had been carried forward that reached nobody. Module `caravan/owe.rye`, witness `tools/caravan_owe_witness.rish`, and the choir sings 77 rungs in one voice.


### meet -- the run that inherits a debt is made to meet it

`owe.rye` above writes a concession down as a debt that outlives the run that made it, addressed forward to a run that has not started. So the admission finally costs the plan something past the breath that spoke it. **And then the run after it opens, reads nothing, and settles whole.** Nothing in the arc asks the inheriting run to do one thing about the debt standing in its own notes, so a supervisor may book a concession in good faith at bedtime, open on it every morning for a season, and report `carried out whole` every single time without ever once meeting it. The debt gains permanence and loses none of its stuckness.

**Meeting comes before booking, and the ordering is the rung.** The debt on the wire is the debt this run inherited right up until the moment this run writes its own -- so a run that booked first would meet today's concession and call yesterday's answered. `meet_the_debt` runs ahead of `book_the_debt` for exactly that reason, which makes this the first rung of the whole arc whose place in the order is a safety property rather than a courtesy.

**A run meets the debt that actually stood.** A plan carrying an older admission may still find it here, and recording some other debt met would tell a later run an admission had been answered that nobody ever looked at -- which is worse than no meeting at all, since it closes the question rather than leaving it open. So the receipt carries two bytes: the inherited debt echoed back exactly as it stood. `MeetMismatched` is the rung itself.

**Meeting is a claim about the work this run did.** A run that has published no outcome of its own has met nothing, however willing it was, so `MeetUnsettled` refuses by name where the settlement is not yet on the wire. And `MeetUnowed` refuses where no debt stood at all, since a run cannot answer an admission nobody made.

**The taking down is the act; the receipt is its record.** A meeting written beside a debt still standing would have every run after this one inherit an admission already answered, and each of them answer it again. So the receipt is written first and the debt comes down second, and a run that falls between the two acts leaves a question still open rather than an admission quietly gone.

**Meeting is not repairing, and it is not conceding twice.** The receipt says the inherited admission was finally looked at; it never decides what the look found, and it never touches today's word. The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word on it, and the concession that word leaves owing each come out of a meeting run exactly as they went in.

**A receipt survives a provisioning, and the debt it answers stays down.** A receipt swept every morning would have the same admission met forever; a debt that came back with the morning would make the meeting a courtesy rather than a close.

The numbers state the claim: **five refusals stand by name -- unowed, unsettled, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a plan inheriting nothing meets nothing and writes no receipt; a plan keeping its own word owes the work nothing; a plan that says nothing concedes nothing; a run owed no word from anybody answers none; and one plan of 6 phases run twice -- opening both times holding the same debt an earlier run booked, over a finding that went for the plan under an outcome already reporting itself short -- absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, carries the same case to the same third hand, reads back the same finding, answers it on the record either way, leaves today's own concession owing nothing either way, spends the same 6 dependents, and settles `carried` either way -- while inherited debts this run met and took down rise 0 to 1 and debts a plan inherited that the run never met fall 1 to 0. The price is two bytes beside the debt, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the taking down skipped, both read-backs dropped, and the harness's own two reads removed -- and the selftest calls itself GREEN while `caravan/.meets/plan.met` does not exist at all and the inherited debt is still standing, so an operator would believe an admission had been answered that nobody ever looked at. Module `caravan/meet.rye`, witness `tools/caravan_meet_witness.rish`, and the choir sings 78 rungs in one voice.

### redress -- a meeting says what it found, rather than closing the question in silence

`meet.rye` above makes the run that opens holding an admission take it up, receipt it, and take it down. So a debt stops being permanent and ignorable at once. **And then the receipt says nothing whatever about what the look found.** A meeting is filed, the admission comes off the wire, the question closes -- and nothing anywhere records whether one thing about the work ever changed. So a supervisor may meet every debt it ever books, change nothing, and read as perfectly answerable forever. The admission gains an answer and loses none of its stuckness.

**Two honest upshots, and both of them close the question.** `sound` is the plan looking at what it conceded and finding the work stands as it is; `righted` is the plan looking and putting the work right. The failure this rung names is neither -- it is a meeting that comes to neither and says so nowhere.

**The stronger claim bears the burden.** Saying the work was put right is a claim about this run's own doing, and a run whose outcome reports itself short has put nothing right this lap, however sincerely it looked -- `RedressUnrighted` refuses by name. Saying the work was found sound carries no such burden, since soundness is a word about the admission rather than about the lap. Making the weaker claim free is deliberate: a burden on both would teach every supervisor to say nothing at all, which is the very harm.

**A run reports on the meeting it actually made.** The redress takes its subject off the wire -- the receipt the rung above just wrote -- rather than from anything the plan asked for, and echoes it byte for byte. A finding filed against some other meeting would answer a question this look never asked, and `RedressMismatched` is the rung itself.

**The receipt stays exactly where the meeting left it.** A redress reports on a meeting rather than replacing one, so both notes stand together: one saying the admission was looked at, the other saying what the look found. A later reader lays them side by side and sees both facts at once.

**Redressing is not un-conceding, and it is not repairing twice.** The finding says what this run's look came to; it never reaches back into the settlement, the quarrel, its age, its standing, the case on the desk, the third hand's word, the plan's own answer, the concession that answer leaves owing, or the meeting itself.

**A finding survives a provisioning, and falls with the meeting it reports on.** A finding swept every morning would leave every later run reading a closed question with no answer in it; a finding outliving its receipt would report on a look this plan's own wire has forgotten.

The numbers state the claim: **five refusals stand by name -- unmet, unrighted, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a plan inheriting nothing meets nothing and so reports on nothing; a plan keeping its own word owes the work nothing; a plan that says nothing concedes nothing; a run owed no word from anybody answers none; and one plan of 6 phases run twice -- opening both times holding the same debt an earlier run booked, meeting it and taking it down both times -- absorbs 3 into standing dependents, loses 3 arcs, takes the same judgment back, re-seats the same 3 phases, posts and carries the same correction, reads the same reply, records the same disagreement, escorts the same published word, asks the same reader, stands the same mark, tells the same raiser, carries the same position past itself, dates it to the same age of 4, publishes the same loud standing, carries the same case to the same third hand, reads back the same finding, answers it on the record either way, leaves today's own concession owing nothing either way, meets the same inherited debt either way, spends the same 6 dependents, and settles `carried` either way -- while meetings this run said the upshot of rise 0 to 1 and debts a plan met whose meeting never said what it found fall 1 to 0. The price is one byte beside the receipt, at no cost in work at all.** Six RED paths proven first, one a planted control where every guard is disarmed at once -- the write skipped, the read-back dropped, and the harness's own two reads removed -- and the selftest calls itself GREEN while `caravan/.redresses/plan.redress` does not exist at all, so an operator would believe a look had been reported on that nobody ever wrote down. Module `caravan/redress.rye`, witness `tools/caravan_redress_witness.rish`, and the choir sings 79 rungs in one voice.


### apprise -- the reader who won an admission is told what the look found

`redress.rye` above makes a meeting say what it came to. An admission is taken up, receipted, taken down, and answered -- `sound` for work the plan found stands as it is, `righted` for work the plan put right. So a meeting stops being empty. **And every byte of that finding is written where only the plan looks.** It lands in the plan's own notes, read by the next run of the plan and by nobody else. The reader who raised the quarrel that began this whole arc -- answered once, early, and told once how their objection came out -- is never told that the admission they won was finally acted on. The arc can run to its end with the one person it was for hearing not a word of it. **The measurement is findings a plan reached whose raiser was never told**, and it falls 1 to 0.

**A finding is carried where the reader is, in the box they already know.** The delivery lands in that reader's own `.found`, beside the letter this arc carried them, the question it asked them, and the word it already sent about how their quarrel came out. A reader who has heard from this plan three times hears from it a fourth in the place they already look.

**The finding travels byte for byte, and never a summary of itself.** The redress standing on the plan's own wire is what lands in the box -- the meeting reported on and the upshot the plan reached, unchanged -- so the reader opens the same three bytes a later run of the plan will open. `AppriseMismatched` refuses a delivery carrying anything else, and it is the rung itself: a raiser told some other look's finding has been answered about an argument that was never theirs.

**A finding reaches a person or it reaches nobody.** A plan that never wrote down where its reader was cannot carry anything to them, and inventing a correspondent would be worse than the silence -- `AppriseUnaddressed` refuses by name rather than guessing at a box.

**The plan's own note stays exactly where the redress left it.** An apprising carries a finding outward rather than moving one, so both stand together: the record where the next run reads it, and the delivery where its reader does. A later reader lays them side by side and sees the same three bytes.

**Apprising is not redressing twice, and it is not re-deciding anything.** The delivery says what this run's look came to; it never reaches back into the settlement, the quarrel, its age, its standing, the case on the desk, the third hand's word, the plan's own answer, the concession that answer leaves owing, the meeting, or the finding itself. Each comes out of an apprising run exactly as it went in.

**A delivery survives a provisioning, and leaves the note it copies where it stands.** A delivery swept every morning would leave its reader holding an answer that vanished before they read it; a delivery that moved the plan's own note would trade one silence for another.

The numbers state the claim: **five refusals stand by name -- unfound, unaddressed, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; a plan inheriting nothing meets nothing and so carries nothing; every rung below moves exactly as it moved, and only the telling parts the two plans.** Witness: `tools/caravan_apprise_witness.rish`.


### suffice -- the reader who was told says whether it settles the thing

`apprise.rye` above carries the finding home. The answer a plan reached goes byte for byte into the box the reader who won it already knows, so a finding stops being private. **And then the arc asks that reader nothing.** A plan may hear an objection, carry it to a hand outside the argument, take the finding on the record, concede, book the debt, meet it, put the work right, and tell the person who raised the quarrel that it did -- and never once learn whether that answer settled the thing or left them exactly as unhappy as before. The whole arc runs to its end on the plan's own account of itself. **The measurement is answers a plan carried whose worth it never learned**, and it falls 1 to 0.

**The word is read off the wire, and never written by a run.** A supervisor able to author its reader's satisfaction has graded its own answer, which is the whole thing this arc has spent thirty rungs preventing. So the word stands in that reader's own `.suits`, in their own hand, and `SufficeSilent` refuses by name where the box holds nothing -- since silence is no consent here, exactly as it was not when a quarrel was withdrawn.

**A word must name the answer it weighs.** A reader may still be holding their verdict on an earlier look at an earlier admission, and taking that as today's word would credit this run with a satisfaction nobody expressed about it. So the word carries four bytes: the three carried to them echoed back exactly, and one more saying what they make of it. `SufficeMismatched` is the rung itself.

**Two honest words, and the plan may not prefer either.** `settles` is the reader saying the answer closes the matter; `wanting` is the reader saying it falls short. This rung asks for neither -- what it ends is nobody ever being asked. The reader of the measured lap says `wanting`, on purpose, and the plan still reads `carried out whole`: a reader's dissatisfaction is a fact an operator is owed rather than a verdict on the work.

**The reader keeps their own word exactly where they wrote it.** A weighing carries a verdict inward rather than moving one, so both stand together: the word in the reader's hand, and the plan's copy in `plan.worth` where an operator opens it. The plan's copy falls with the answer it weighs, so a later run never reads a satisfaction about a delivery this wire has forgotten.

**Weighing is not re-deciding anything.** The word says what the reader makes of the answer; it never reaches back into the settlement, the quarrel, its age, its standing, the case on the desk, the third hand's word, the plan's own answer, the concession, the meeting, the finding, or the delivery itself. Each comes out of a weighing run exactly as it went in.

**The reader's own word is sitting in their box under both runs.** The unasking plan is not blocked from learning; it simply never looks. That is what makes the silence a cost rather than an impossibility.

The numbers state the claim: **five refusals stand by name -- untold, silent, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the asking parts the two plans.** Witness: `tools/caravan_suffice_witness.rish`.

### reopen -- a reader who says the answer falls short opens the matter again

`suffice.rye` above finally asks. The reader who was told what the look found says whether it settles the thing, in their own hand, and the plan publishes that word where the settlement is read -- so an answer stops being the plan's own last word about itself. **And then nothing whatever follows from what they said.** A plan may hear an objection, carry it outside the argument, take the finding on the record, concede, book the debt, meet it, put the work right, tell the person who raised the quarrel, read that person's verdict, publish it honestly -- and go on answering exactly the same way forever. A supervisor may learn every run that its answer settled nothing, and owe nothing for it. **The measurement is words a reader wrote calling an answer short that opened nothing**, and it falls 1 to 0.

**A hand outside the plan opens a matter the plan had closed.** Every rung of this arc reaches outward to be *told* something -- a quarrel, a standing, a third hand's finding, a reader's verdict -- and the plan has always decided by itself what to do about it. Here what it is told costs it a look it never chose to take. That is the whole rung, and it is the first of its kind in the arc.

**A reader who says the answer settles the matter leaves nothing to take up.** Booking a matter open there would punish a plan for asking and teach every supervisor never to ask at all, which would undo the rung below in a single lap. So satisfaction costs nothing, dissatisfaction costs exactly one more look, and `ReopenSettled` refuses by name.

**The note is addressed forward, and its every byte came from outside.** It is the second note in the whole arc written for a run that has not started -- `owe.rye` wrote the first -- and the two are the honest pair this arc has been walking toward: a debt books what the plan itself conceded, while a reopening books what its reader says is still wanting. A plan may keep its own word, concede nothing, owe nothing, and still be reopened by the person it answered.

**A note must name the word it reopens.** A note left over from an earlier lap may be reopening an older answer entirely, and reading that as today's would tell an operator this run acted on a verdict it never read. So the note carries four bytes: the reader's own word, echoed back whole. `ReopenMismatched` is the rung itself.

**Booking is not answering.** The note says the matter is owed another look and never decides what that look finds. The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, and the reader's own verdict each come out of a reopening run exactly as they went in -- and both runs settle `carried out whole`, because a reader's dissatisfaction is a fact an operator is owed rather than a verdict on the work.

**A reopened matter survives a provisioning, and falls with the word that opened it.** A matter swept every morning would let a plan answer a `wanting` word and open the next run owing nothing at all; a matter standing on a verdict this wire has forgotten would send a run looking again at an answer nobody ever called short.

The numbers state the claim: **five refusals stand by name -- unweighed, settled, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the taking up parts the two plans.** Witness: `tools/caravan_reopen_witness.rish`.

### reweigh -- a run that inherits a reopened matter takes the look again

`reopen.rye` above books the matter open. A reader who says the answer falls short opens it again, in a note addressed to the run that has not started yet -- so a plan's own reader may finally cost it a look. **And then that run opens, reads past the note, and settles whole.** The matter stands reopened forever and asks nothing of anybody: permanent and ignorable at once, which is the most comfortable thing an open question can be. This is the shape `owe.rye` wore before `meet.rye` answered it, one tier further out -- there the plan's own concession went unmet, here its reader's own reopening goes unlooked-at. **The measurement is reopened matters a plan inherited that the run never looked at again**, and it falls 1 to 0.

**A run earns the second look by finishing its own.** A supervisor that has published no outcome has nothing to weigh the reopened matter against, and calling that a second look would file a fresh answer over a question this run never actually re-asked. `ReweighUnsettled` refuses by name.

**The receipt names the matter it looked at.** A plan may be carrying an older second look from a run before today, and leaving that standing beside a freshly reopened matter would tell a later run a question had been answered which nobody ever reopened -- worse than no receipt at all, since it closes the matter rather than leaving it open. `ReweighMismatched` is the rung itself.

**The taking down is the act, and the receipt is only its record.** A second look written beside a matter still standing open would have every run after this one inherit a reopening already answered, and answer it forever. So the receipt lands first and `plan.again` comes down after, and a run that falls between the two acts leaves a question open rather than one quietly gone.

**Looking again is not deciding again.** The receipt says the matter was taken up a second time and never rewrites what the first look found. The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, and the reader's own verdict each come out of a reweighing run exactly as they went in -- and both runs settle `carried out whole`.

**A second look survives a provisioning, and the matter it answers stays down.** A receipt swept every morning would have a later run reopen a matter this plan has already answered; a matter left standing beside its own receipt would have every run after this one look at it forever.

The numbers state the claim: **five refusals stand by name -- unopened, unsettled, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the second look parts the two plans.** Witness: `tools/caravan_reweigh_witness.rish`.

### recount -- the reader who reopened a matter is told what the second look came to

`reweigh.rye` above makes the second look. A run that inherits a reopened matter takes it up again, receipts it, and takes the matter down -- all inside the plan's own notes, in a place only a later run of this plan ever opens. **And the reader who reopened it is never told.** They said the answer fell short, they got the look they asked for, and their own box stays exactly as empty as it was. This is the shape `deem.rye` wore before `tidings.rye` answered it, one tier further out -- there a raiser never heard how their quarrel came out, here a reader never hears what their reopening bought. **The measurement is second looks a run made whose reader was never told**, and it falls 1 to 0.

**The telling lands where the reader is, not where the record is.** Every note of the second look so far lives under the plan's own note directory, where a reader must come looking; this one lands in that reader's own box as `<address>.knows`, so the outward reach is visible on the wire as a record leaving the place records are kept.

**A run tells only what it actually looked at.** A telling written by a run that made no second look would announce an answer to a question nobody re-asked, and a reader reading it would close a matter still open on the wire. `RecountUnlooked` refuses by name.

**The telling names the matter it is about.** A reader may already hold a telling from a run before today, and leaving that standing beside a fresh second look would tell them their newest reopening had been answered by an older run's work -- worse than an empty box, since a box that says nothing at least says nothing false. `RecountMismatched` is the rung itself.

**Telling is not deciding.** The telling copies the receipt and rewrites nothing. The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's own verdict, and the second look itself each come out of a telling run exactly as they went in -- and both runs settle `carried out whole`.

**A telling survives a provisioning, and falls with the receipt it copies.** One swept every morning would leave a reader who was told opening an empty box tomorrow; one standing beside a second look this plan's own wire has forgotten would answer a question nobody can find.

The numbers state the claim: **five refusals stand by name -- unlooked, unaddressed, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the telling parts the two plans.** Witness: `tools/caravan_recount_witness.rish`.

### allay -- the reader who was told says whether the second look puts the matter to rest

`recount.rye` above carries the second look home. Four bytes leave the plan's own notes and land in the box of the reader who asked for them, so a reopening finally comes back to the person who made it. **And nobody ever asks whether it answered them.** The telling lands, the run settles `carried out whole`, and that reader's own reply -- already written, already sitting in their box -- is never opened. A matter reopened once may be reopened again, and a plan that never reads the answer cannot tell a question finally put to rest from one still standing. This is the shape `apprise.rye` wore before `suffice.rye` answered it, one tier further out. **The measurement is tellings a run made whose reader's word was never read back**, and it falls 1 to 0.

**The word is read where its writer left it, and published where the settlement is read.** The reader keeps five bytes in `<address>.rests` -- the telling they were carried, echoed back whole, and one byte for what they make of it -- and the run copies that one byte into `plan.rest`, so an operator opening the outcome learns whether the matter is closed. The plan copies the word; it never composes one.

**A run reads a reply only to a telling it actually made.** The telling comes off the wire rather than out of the run's memory of having made one, so a plan that carried nothing home reads nothing and says so. `AllayUntold` refuses by name.

**A reader who wrote nothing is reported as silent, never as content.** A box that says nothing and a reader who says the matter still stands are two different facts, and only the second one is a word. `AllaySilent` refuses by name.

**The word names the telling it is about.** A reader may still hold a reply to a telling from a run before today, and reading that as today's would publish a verdict about a second look nobody made this morning. `AllayMismatched` is the rung itself.

**Reading is not deciding.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, and the telling itself each come out of a reading run exactly as they went in -- and both runs settle `carried out whole`.

**A reader's reply survives a provisioning, and the plan's copy falls with the telling it answers.** A reply swept every morning would leave a reader who answered reading a plan that never heard them; a published word standing beside a telling this plan's wire has forgotten would say a matter rests that nobody can find.

The numbers state the claim: **five refusals stand by name -- untold, silent, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the reading parts the two plans.** Witness: `tools/caravan_allay_witness.rish`.

### forbear -- a matter its reader says still stands leaves the run that heard it

`allay.rye` above reads the reply. The plan finally opens the word its reader wrote about the second look, so an outcome can say whether the matter came to rest or stands exactly where it stood. **And a matter that stands dies with the run that read it.** The word is read, the settlement is published, the run reports `carried out whole`, and nothing anywhere tells the run that comes next that this reader has now refused twice. So the correspondence closes one full turn and begins the same turn again from nothing: the next run reopens a matter already reopened, looks again at a look already taken, and carries home an answer this reader has already called insufficient. **The measurement is matters a run left standing with nothing handed on**, and it falls 1 to 0.

**Forbearing is holding back, and holding back is a record.** A run that forbears decides nothing, overturns no second look, and answers nobody again. It declines to open the same question a third time from nothing, and writes what it declined into `plan.hold` -- five bytes, the reader's own refusal copied whole -- where the run after it reads its own inheritance. This is the third note in the arc addressed to a run that has not started, joining `.again` and `.debt`, and the first whose whole content came from a person outside the plan.

**A run forbears only on a word it actually read.** A forbearance booked without a reply would hand on an impasse this run never heard, and the run after it would open holding a refusal nobody made. `ForbearUnread` refuses by name.

**A matter its reader says rests is left alone.** Handing on an impasse over a question already settled would have every later run inherit an argument that ended -- the exact harm this rung exists to prevent, wearing the prevention's own clothes. `ForbearAllayed` refuses by name.

**The forbearance names the matter it holds back on.** A run may still find a forbearance left by a run before today, and reading that as this run's would spare the next run a question nobody refused this morning. `ForbearMismatched` is the rung itself.

**Holding back is not settling.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, the telling, and the reader's reply each come out of a forbearing run exactly as they went in -- and both runs settle `carried out whole`.

**A forbearance survives a provisioning, and comes down only on the word of the run that inherits it.** Alone among the notes of this arc it does not fall with the record beneath it: the telling its reader refused may come down while the impasse stands, since the whole point is that the next run finds it. One swept every morning would leave that run opening exactly the question this rung exists to spare it.

The numbers state the claim: **five refusals stand by name -- unread, allayed, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, and only the forbearing parts the two plans.** Witness: `tools/caravan_forbear_witness.rish`.


### mind -- a run says what impasse it opened holding

`forbear` hands a twice-refused matter to the run that comes next, in the one note a provisioning leaves alone. **And the hand that inherits it never says so.** The forbearance is on the wire the moment the run begins; the run opens, works, settles `carried out whole`, and publishes an outcome that reads exactly as it would have read had nobody ever refused anything. So an operator meets a plan that looks untroubled while it runs under a matter the run before it could not settle, and the whole correspondence the arc spent arrives one lap later exactly where it started.

**The measurement is impasses a run opened holding and never named**, and it falls **1 to 0**. This is the shape `endure` wore before `heed` answered it, three tiers further out: there a plan ran under a quarrel it inherited and never said so; here a plan runs under an impasse it inherited and never says so.

**Minding is naming, and naming is where the outcome is read.** A run that minds decides nothing, reopens nothing, and answers nobody. It publishes six bytes into `plan.mind` -- the forbearance echoed whole, this run's own byte last -- beside the settlement and the reader's own word, so an operator opening the outcome learns what the run began under. Every byte save that last one came from outside the plan, copied rather than composed: a supervisor able to author its own inheritance would be a plan inheriting its own argument.

**A run names only an impasse it was actually handed.** A mark published without a forbearance would report a matter nobody handed this plan. `MindUninherited` refuses by name.

**A matter the word says rests is left alone.** Naming a settled question as an impasse would have every outcome from here forward report an argument that ended -- the exact harm this rung prevents, wearing the prevention's own clothes. `MindRested` refuses by name.

**The mark names the impasse it is about.** A run may still find a mark left by a run before today, and reading that as this run's would report an inheritance nobody handed it this morning. `MindMismatched` is the rung itself.

**The naming is the act, and the taking down is only its close.** The mark lands first and the forbearance comes down after, so a run that falls between the two leaves an impasse standing for the next hand rather than one quietly gone -- the same order `reweigh` keeps between its receipt and the matter it answers.

**Naming is not settling.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, the telling, the reader's reply, and the impasse this run hands on itself each come out of a minding run exactly as they went in -- and both runs settle `carried out whole`.

The numbers state the claim: **five refusals stand by name -- uninherited, rested, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, the forbearing included, and only the minding parts the two plans.** Four further RED paths proven on metal beyond the folded five: a planted control that printed GREEN while `caravan/.minds/plan.mind` did not exist at all, a mark written from another matter raising `MindMisrecorded` by name, a measured run handed no forbearance at all, and a control that took the inheritance down before the mark that names it landed. Witness: `tools/caravan_mind_witness.rish`.


### desist -- a plan stops relaying an impasse that has come round twice

`mind` makes a run say what impasse it opened holding. **And then it hands the very same matter on again.** A run opens holding an impasse, names it faithfully, takes the inheritance down, and forbears once more -- so the next run opens holding the same refusal, names it just as faithfully, and hands it on in its turn. Every run is honest, every note lands, and the matter never moves. A correspondence that cannot settle a question and cannot stop asking it is a loop wearing diligence for a face, and an operator reading any single outcome sees a plan doing everything right.

**The measurement is impasses a plan carried round twice and relayed anyway**, and it falls **1 to 0**. The rung below ends the impasse being inherited in silence; this one ends the silence being inherited forever. It is where the arc stops being a correspondence and becomes a boundary.

**Bounding is stopping, and stopping is a record.** A run that desists publishes seven bytes into `plan.wall` -- the mark echoed whole, this run's own byte last -- beside the settlement and the mark it bounds, and then hands the matter to nobody. The relay ends where the wall stands, so the next run opens holding neither the impasse nor the pretense that another lap will settle it. Every byte save that last one came from outside the plan: the mark copied the forbearance, and the forbearance copied the reader.

**A run bounds only a matter it has already named.** A wall from a run that named no impasse would report a correspondence exhausted over a question nobody asked. `DesistUnnamed` refuses by name.

**A matter on its first round is relayed, never walled.** The first refusal earns the next run's look; bounding there would end an exchange on its opening word -- the harm this rung prevents, wearing the prevention's own clothes. `DesistFresh` refuses by name.

**The wall names the matter it bounds.** A run may still find a wall left by a run before today, and reading that as this one's would report a boundary around a matter nobody carried here. `DesistMismatched` is the rung itself.

**The wall stands before the relay is stayed.** The boundary lands first and the forbearing is withheld after, so a run that falls between the two hands the matter on exactly as the rung below it always did, rather than dropping a question into silence.

**Bounding is not settling.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, the telling, the reader's reply, and the mark this run just made each come out of a bounding run exactly as they went in -- and both runs settle `carried out whole`.

**The evidence is read where a run can still see it.** The mark the run before today left is opened at the top of the close, before this run's own minding writes over it -- the one moment a run can tell a matter on its second round from a matter on its first. No supervisor writes its own evidence: the harness seats the elder mark, standing in for the run that made it.

The numbers state the claim: **five refusals stand by name -- unnamed, fresh, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, the minding included, and only the bounding parts the two plans.** The forbearing two tiers down is where the wall is felt: standing matters handed to the run after it read **1 relaying, 0 bounding**, with matters left unhanded still 0 against 0, since a bounded matter is counted as walled rather than dropped. A planted control proved the read that closes the claim: the wall was taken down and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_desist_witness.rish`.


## Beckon -- the wall reaches the person who can act on it

`desist.rye` stood a boundary where a correspondence used to run. `beckon.rye` carries it out.

**A wall that ends a correspondence is written where the plan keeps its records.** Every note of this arc lands under the plan's own notes, and an operator learns of any of them by coming to look. So a matter can be bounded honestly, exactly, and privately: the loop ends, the record is precise, and the one person who could take the matter up outside the plan is never told it stopped. A wall an operator never opens bounds the matter exactly as well as no wall at all, for everyone save the plan that stood it.

**The measurement is walls a plan stood and told nobody about**, and it falls **1 to 0**.

**Beckoning is carrying, and carrying is a record.** A run that beckons writes eight bytes -- the wall echoed whole, this run's own byte last -- into `caravan/.readers/desk.walls`, the box that reader already reads, beside every other word this arc has carried them. Then it opens that box again and reads the call back, because a supervisor that believed its own telling could report a person reached whose box was never opened.

**Every byte of the call save one came from outside the plan.** The wall copied the mark, the mark copied the forbearance, and the forbearance copied the reader's own five-byte refusal -- so the word a person finds in their own box is the word they wrote themselves, carried four tiers without a supervisor's hand on it.

**A run calls a person only to a wall it has already stood.** A call from a run that bounded nothing would summon a reader to a correspondence still running. `BeckonUnwalled` refuses by name.

**A call lands where a person actually is.** A reader who left no address has no box to open, and a call written into the air reaches nobody while reporting that somebody was reached. `BeckonUnaddressed` refuses by name.

**The call names the wall it carries.** A reader's box may still hold a call left by a run before today, and reading that as this one's would report a person reached about a boundary nobody stood here. `BeckonMismatched` is the rung itself.

**The wall stands before the call goes out.** The boundary lands first and the summons after, so a run falling between the two leaves a wall standing and uncarried -- exactly the state the rung below always left -- rather than calling a person to a boundary that does not exist.

**Beckoning is not settling.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, the telling, the reader's reply, the mark, and the wall itself each come out of a beckoning run exactly as they went in -- and both runs settle `carried out whole`.

The numbers state the claim: **five refusals stand by name -- unwalled, unaddressed, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, the bounding included, and only the beckoning parts the two plans.** Both runs stand the same wall (**1 keeping, 1 beckoning**) and both stay the relay (**0 keeping, 0 beckoning**), since a bounded matter is handed to nobody under either plan. A planted control proved the read that closes the claim: the call was taken down from the reader's box and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_beckon_witness.rish`.


## Answer -- the person who was called says what they will do

`beckon.rye` carried the wall out to a person. `answer.rye` opens what they wrote back.

**A reader called to a boundary has exactly one way to reply: write a word into the box they were written to.** So the reply lands there, and the plan -- whose part was done the moment the call went out -- never opens it. The arc reaches a person and then stops listening, which is a correspondence held with oneself in a room where somebody else is speaking.

**The measurement is answers a reader wrote back that the plan never opened**, and it falls **1 to 0**.

**The reader's own word lives in the reader's own hand.** Nine bytes stand in `caravan/.readers/desk.hands` -- the call echoed whole, that person's own byte last -- seated by the harness on their behalf, since no run of this plan may ever write it. A plan that could compose the reply it reads would be answering its own call.

**Opening is reading, and reading is a record.** A run that hears writes ten bytes into `caravan/.minds/plan.answer` -- the answer echoed whole, this run's own byte last -- then reads that note back before it believes a word of it.

**Every byte of the record save one came from outside the plan.** The answer copied the call, the call copied the wall, the wall copied the mark, the mark copied the forbearance, and the forbearance copied the reader's own first refusal. An operator reading ten bytes reads five tiers of a correspondence and a person's own word at the end of it.

**A run opens an answer only to a call it actually carried.** A word found in a box a run never wrote to answers some other run entirely. `AnswerUncalled` refuses by name.

**A reader who wrote nothing back is silent, never answered.** An empty box is an honest ending, and counting one as a reply would tell an operator a person had spoken. `AnswerSilent` refuses by name.

**The answer names the call it replies to.** A box may still hold a word about a boundary from a run before today, and reading that as this one's would report a person answering a wall nobody stood here. `AnswerMismatched` is the rung itself.

**The call goes out before the answer is opened.** The summons lands first and the reading after, so a run falling between the two leaves a person called and unread rather than a record of a reply to a call never carried.

**Opening is not settling, and never answering back.** Everything beneath -- the settlement through the mark, the wall, and the call itself -- comes out of an opening run exactly as it went in, and the reader's own answer stays exactly where they wrote it. Both runs settle `carried out whole`.

The numbers state the claim: **five refusals stand by name -- uncalled, silent, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, the beckoning included, and only the opening parts the two plans.** Both runs carry the same call to the same person (**1 leaving, 1 hearing**) and both leave no wall unheralded (**0 against 0**). A planted control proved the read that closes the claim: the record was taken down from the plan's own notes and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_answer_witness.rish`.


## Abate -- the reader's word takes the wall down

`answer.rye` heard what the person said. `abate.rye` does something about it.

**A reader who answers `takes_up` has said the matter leaves with them, and the plan's own boundary answers to nobody.** The wall stands in the notes run after run, outliving the correspondence it ended and the release that ended it. Every rung of this arc has carried a person's word further -- into the record, out to their box, back into the outcome -- and not one of them has ever let that word *move* the plan. A correspondence where the other party's word has no force is a correspondence in name only.

**The measurement is walls a plan kept standing after their reader took the matter up**, and it falls **1 to 0**.

**Abating is taking down, and taking down is a record.** A run that abates writes eleven bytes into `caravan/.minds/plan.abate` -- the recorded answer echoed whole, this run's own byte last -- reads that note back before it believes a word of it, and only then lets the wall fall, reading once more to be sure it did.

**Every byte of the abatement save one came from outside the plan.** The record copied the answer, the answer copied the call, the call copied the wall, the wall copied the mark, and the mark copied the reader's own five-byte refusal -- so an operator reading eleven bytes reads six tiers of a correspondence and the release that closed it.

**A run abates only a wall whose answer it actually opened.** A plan that heard nobody holds no word to act on. `AbateUnopened` refuses by name.

**A wall comes down only on the word of the reader who was called to it.** A reader who lets the boundary stand has asked for nothing, and taking it down on their acceptance would read a release into a word that granted none. `AbateUnreleased` refuses by name -- the one refusal in this arc that guards a person's word against a plan eager to mean more by it than they did.

**The abatement names the wall it takes down.** A plan may still be standing a boundary about some other matter, and reading this reader's release as covering it would take down a wall nobody released. `AbateMismatched` is the rung itself.

**The record lands before the wall falls.** A run stopping between the two leaves a wall standing beside a record of why it should not -- exactly the state the rung below always left -- rather than a boundary gone with nothing on the wire naming who released it.

**Abating is not settling.** The settlement, the quarrel, its age, its standing, the case on the desk, the finding, the plan's own word, the concession, the meeting, the redress, the delivery, the reader's first verdict, the second look, the telling, the reader's reply, the mark, the call, and the reader's own answer each come out of an abating run exactly as they went in -- and both runs settle `carried out whole`.

The numbers state the claim: **five refusals stand by name -- unopened, unreleased, mismatched, miscounted, misrecorded; a plan that loses nothing reads as the line handed, all 16 pairs; every rung below moves exactly as it moved, the opening included, and only the abating parts the two plans.** Both runs open the same release (**1 holding, 1 abating**) and both leave no answer unopened (**0 against 0**). A planted control proved the read that closes the claim: the abatement was taken down from the plan's own notes and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_abate_witness.rish`.


## `conclude.rye` -- a reader's ending is kept, so the next run inherits a matter closed

`abate.rye` moves a wall on one of the two words a reader may hand back. `conclude.rye` keeps the other one.

A reader who takes the matter up releases the plan, and the boundary comes down. A reader who **lets the wall stand** has ended the matter where they sit: no wall falls, because none should -- and the plan writes nothing at all. So the run after this one opens on a wire holding no closure, no release, and no word, which is exactly the wire a run inherits when nobody was ever called. **A correspondence that closed and a correspondence that merely stopped read identically**, and a later run will open the whole matter afresh over a person who already said they were done.

**The measurement is correspondences a reader ended that no later run could tell from one merely stopped**, and it falls **1 to 0**.

**Concluding is writing down, and what is written is addressed forward.** A run that concludes writes eleven bytes into `caravan/.minds/plan.close` -- the recorded answer echoed whole, this run's own byte last -- and reads that note back before the report believes a single ending was kept. Like the forbearance five tiers down, and alone in this rung's own notes, **the closure does not fall with the records beneath it**: a note written for a run that has not started earns nothing by being swept with the lap that wrote it.

**Every byte of the closure save one came from outside the plan.** The record copied the answer, the answer copied the call, the call copied the wall, the wall copied the mark, and the mark copied the reader's own five-byte refusal -- so the run that inherits eleven bytes inherits six tiers of a correspondence and the word that ended it.

**A run concludes only on an answer it actually opened.** `ConcludeUnopened` refuses by name.

**A correspondence closes only on the word of the reader who ended it.** A reader who takes the matter up carried it onward rather than ending it, and writing a closure there would record an ending that person never made. `ConcludeUnended` refuses by name -- the consent guard of this tier, mirror to `AbateUnreleased` below it.

**The closure names the call it ends.** `ConcludeMismatched` is the rung itself; `ConcludeMiscounted` keeps the count honest, and `ConcludeMisrecorded` reads the note back out of the plan's own notes rather than out of the memory of having written it.

**Between the two rungs, every word a reader can hand back now moves the plan.** A release takes the wall down; an acceptance closes the matter. Neither does the other's work, and `check_conclude` proves the two read a reader's word differently rather than merely claiming it.

**The pair runs the reader's other word, for the first time in the arc.** Every rung from `beckon` up seated `takes_up` in its harness, since each was about what a plan does when a person asks something of it. This rung seats `accepts` -- so the acceptance branch runs end to end, and the abating below correctly moves nothing: **walls a plan kept standing after their reader took the matter up reads 0 against 0**, which is `AbateUnreleased` read from its welcoming side, in the live path rather than only in the fold.

The numbers state the claim: **five refusals stand by name -- unopened, unended, mismatched, miscounted, misrecorded; every rung below moves exactly as it moved, the opening included (1 leaving, 1 concluding), and only the concluding parts the two plans.** A planted control proved the read that closes the claim: the closure was taken down from the plan's own notes and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_conclude_witness.rish`.


## `respect.rye` -- the run after reads the ending it inherited

`conclude.rye` writes the ending down. `respect.rye` is the first rung in the arc that opens one and answers for it.

A note addressed forward is worth exactly what the run receiving it does with it. The closure stands in `caravan/.minds/plan.close` lap after lap, saying plainly that this correspondence closed -- and a run that never looks carries the same wall to the same reader as though the whole exchange the arc spent had never happened.

**The measurement is endings a run opened holding and never named**, and it falls **1 to 0**.

**Respecting is naming, and the naming is the act.** A run that respects publishes twelve bytes into `caravan/.minds/plan.respect` -- the closure it was handed echoed whole, this run's own byte last -- reads that note back before the report believes a single ending was named, and only then takes the inheritance down. The mark lands first and the closure comes down after, so a run falling between the two leaves an ending standing for the next hand rather than one quietly gone.

**Every byte of the mark save one came from outside this run.** The closure copied the record, the record copied the answer, the answer copied the call, the call copied the wall, the wall copied the mark beneath it, and that mark copied the reader's own first refusal -- so twelve bytes carry seven tiers of a correspondence and the word that ended it. On the wire it reads `osrwsmwbyocr`.

**A run respects only an ending it actually inherited.** `RespectUninherited` refuses by name.

**An inheritance is respected only where its reader ended the matter.** `RespectUnended` refuses by name -- the consent guard of this tier, mirror to `ConcludeUnended` below it.

**The mark names the ending it is about**, weighed against the word standing in the reader's own box where that reader left it, so a closure built on somebody else's word is caught before it is ever published. `RespectMismatched` is the rung itself; `RespectMiscounted` keeps the count honest, and `RespectMisrecorded` reads the note back out of the plan's own notes rather than out of the memory of having published it.

**The pair asks the concluding below to write nothing**, so what stands on the wire at the end of the lap is this rung's own work rather than a fresh closure written over it: the reopening run leaves the inherited closure standing and publishes no mark, and the respecting run publishes the mark and leaves the closure gone. **A closure that returned every morning would make the naming a courtesy rather than an act.**

The numbers state the claim: **five refusals stand by name -- uninherited, unended, mismatched, miscounted, misrecorded; every rung below moves exactly as it moved, the opening included (1 reopening, 1 respecting), and only the respecting parts the two plans.** A planted control proved the read that closes the claim: the mark was taken down from the plan's own notes and the very same read made again, and it failed on metal with the note gone. Witness: `tools/caravan_respect_witness.rish`.


## `refrain.rye` -- a named ending finally changes what the plan does next

`respect.rye` names the ending. `refrain.rye` is the first rung in the arc where naming it costs the plan a letter it would otherwise have sent.

Naming an ending changes what an outcome says; until it changes what the plan does next, the person the ending was about receives exactly the letter they would have received had nobody read a thing. The mark stands in `caravan/.minds/plan.respect` saying plainly that this matter closed -- and the rung five tiers down carries a wall to that reader's own box on the plan's own word, every lap, regardless.

**The measurement is readers a plan summoned again about a matter it had already named as ended**, and it falls **1 to 0**.

**Refraining is sparing, and the record is what makes it checkable.** A run that refrains publishes thirteen bytes into `caravan/.minds/plan.refrain` -- the mark it was handed echoed whole, this run's own byte last -- reads that note back before the report believes anybody was spared, and only then takes the summons out of the reader's box. The record lands first and the summons comes down after, so a run falling between the two leaves a reader summoned rather than a reader spared with nothing on the wire saying why.

**Every byte of the record save one came from outside this run.** The mark copied the closure, the closure the record, the record the answer, the answer the call, the call the wall, the wall the impasse, and that impasse the reader's own first refusal -- so thirteen bytes carry eight tiers of a correspondence and the word that ended it. On the wire it reads `osrwsmwbyocrf`.

**A run refrains only where an ending was actually named.** `RefrainUnnamed` refuses by name.

**A reader who has taken the matter up again is never spared.** The word is read where that person left it, in their own box, rather than out of the mark the plan is holding -- so a correspondence its reader reopened since the ending was named stays live, and the plan keeps answering them. `RefrainTakenUp` refuses by name, the consent guard of this tier, mirror to `RespectUnended` below it.

**The record names the ending it spares a reader about**, weighed against the word standing in that reader's own box, so a sparing built on somebody else's word is caught before a single summons comes down. `RefrainMismatched` is the rung itself; `RefrainMiscounted` keeps the count honest, and `RefrainMisrecorded` reads the note back out of the plan's own notes rather than out of the memory of having published it.

**Refraining takes down the summons, never the boundary.** The wall stands and the mark stands; a reader who let the wall stand keeps it and simply stops hearing about it. **The pair hands neither plan a closure to open holding**, so the respecting below correctly names nothing and reads 0 against 0 -- and the mark both plans act on was written by the harness for a run before today, which is the only kind of mark this rung was ever meant to read.

The numbers state the claim: **five refusals stand by name -- unnamed, taken up, mismatched, miscounted, misrecorded; every rung below moves exactly as it moved, the opening included (1 calling, 1 refraining), and only the refraining parts the two plans.** Two planted controls proved the reads that close the claim: the record was taken down from the plan's own notes and the same read made again, failing on metal with the note gone; and a summons was put back into the reader's box, making the read that closes the sparing claim fail there too. Witness: `tools/caravan_refrain_witness.rish`.

## `farewell.rye` -- the reader hears the plan's own last word

`refrain.rye` spares the reader. `farewell.rye` is the rung that finally tells them so.

A sparing lives entirely inside the plan: thirteen bytes among the plan's own notes, and a summons quietly taken out of a box the reader never sees emptied. From where that person sits, the letters simply stop. A plan that honored their ending and a plan that mislaid their file read exactly alike from the outside -- the same silence, carrying the same nothing -- so the one courtesy the whole arc was spent to earn arrives as an absence they are left to interpret.

**The measurement is readers a plan stopped writing to without ever saying so**, and it falls **1 to 0**.

**Bidding farewell is telling, and the telling lands where the reader is.** A run that bids farewell writes fourteen bytes into `caravan/.readers/desk.fares` -- the record it was handed echoed whole, this run's own byte last -- and opens that box again before the report believes anybody was told. Every note this rung climbs past lives under the plan's own directory, where a person must come looking; this one lands outside it, so the arc's last courtesy is visible on the wire as a record leaving the place records are kept.

**Every byte of the parting save one came from outside this run.** The record copied the mark, the mark the closure, the closure the answer, the answer the call, the call the wall, the wall the impasse, and that impasse the reader's own first refusal -- so fourteen bytes carry nine tiers of a correspondence and the word that ended it. On the wire it reads `osrwsmwbyocrfl`.

**A run bids farewell only where a reader was actually spared.** A plan holding no record spared nobody, and a parting sent there would end a correspondence the plan is still perfectly willing to carry. `FarewellUnspared` refuses by name, and `FarewellUnaddressed` bounds the reach exactly as every other word this arc carries outward.

**The letter names the sparing it is about.** A reader holding an older parting would read their newest matter as closed by a run before today -- worse than an empty box, since a box that says nothing at least says nothing false. `FarewellMismatched` is the rung itself; `FarewellMiscounted` keeps the count honest, and `FarewellMisrecorded` reads the letter back out of the reader's own box rather than out of the memory of having written it.

**A parting carries the arc's last word, never its boundary.** The wall stands, the mark stands, and the record stands; the reader is simply told that the plan has stopped writing. **The pair hands neither plan a named ending to open holding**, so the refraining below correctly spares nobody and reads 0 against 0 -- and the record both plans act on was published by the harness for a run before today, which is the only kind of record this rung was ever meant to carry outward.

The numbers state the claim: **five refusals stand by name -- unspared, unaddressed, mismatched, miscounted, misrecorded; every rung below moves exactly as it moved, the opening included (1 quiet, 1 parting), and only the parting parts the two plans.** Two planted controls proved the reads that close the claim: the parting was taken out of the reader's box and the same read made again, failing on metal with the box empty; and a parting about some other sparing was written into that same box, making the read that names the matter fail there too. Witness: `tools/caravan_farewell_witness.rish`.

## The ladder's carried checks -- the fold, and the meter that keeps it

Every rung above imports the implementation of the rung beneath it. For eighty-odd rungs it also carried a fresh copy of that rung's self-test, because a check function was private and a later rung had no way to *call* the one below it -- only to carry its bytes forward.

Measured on metal rather than recalled, the carry reached **779 copied bodies over 54,612 lines**, growing about 4,383 lines a rung. On Keaton's word (`20260820.142246`) the design call in [`../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`](../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md) landed as **option A**: every check is `pub` now, and a rung whose check is byte-for-byte the rung below's runs it there rather than keeping a second copy.

**523 checks fold that way, and 39,962 lines leave the ladder** -- from 289,303 lines to 249,341, with `recount` alone falling 15,664 to 13,113. Each folded check now lives in exactly one place, so an improvement to it improves every rung above at once.

The fold is conservative on purpose, and both of its limits were taught by a bolder first cut that went RED:

- **A check that reaches the wire stays home.** The bodies match byte for byte, yet each rung keeps its notes in its own directory, so the rung below would provision *its* wire and leave this rung's cold. The bolder cut passed on a warm tree and failed the moment the choir cleared the stores -- `NoteUnavailable`, a debt that could not be seated at all, which is exactly what the cold-start discipline REDS %92 seated exists to surface.
- **A check whose tail chains into a check this rung invented stays home.** The rung below has never heard of the check it would chain to, so the chain would end early and silently skip everything this rung added.

What stayed carried after A was **256 bodies over 12,035 lines**, growing about 1,637 a rung. **Option B then ran on Keaton's word (`20260820.162747`)** and ended that growth's largest share: `ladder_checks.rye` is the shared harness, its whole contract one word -- `rung` -- so a lifted check takes the rung as a comptime parameter, reaches every helper through it, and re-enters that rung on every chained tail. Both of A's named limits fall to it: the harness opens no store of its own, and a chained check ends in the rung that called it rather than the rung below. **57 bodies lifted across 30 rungs, and the carry fell from 17,997 lines to 1,952.** All 30 touched rungs were built twice, pristine and folded, and printed the same lines from a cold tree.

Nothing observable changed. Every rung of the grievance arc from `appraise` to `recount` was built twice -- folded and pristine -- and run against the same wire: **28 rungs, the same output lines, every one of them** -- only the order in which three concurrent dependents print interleaves, run to run, in the pristine build exactly as in the folded one. Every check that ran before still runs, in the same order, printing the same words. The choir sings every rung GREEN from a cold tree.

`tools/caravan_ladder_copy_witness.rish` changed jobs with the fold, and changed size with it. It holds the standing under a named ceiling of **4,000** carried lines -- **47** stand there now across **101 modules and 1,275 checks** -- and it counts all three folds off the ladder rather than believing the prose: **913** checks run in the rung that owns them, counted in either form a rung may name that rung; **85** check bodies stand in the harness, each running against whichever rung handed itself in; and **0** rungs carry a forwarding stub. It proves its counting by hand on a two-rung control set, and refuses by name on every RED path it names: a control set with no modules, a control set whose modules hold no checks at all, a control set grown past its ceiling, a rung reaching past its neighbor in either fold form, and a lifted body whose printed line or comment its own lift rewrote (REDS %99). It sings with the choir, so it can never become a guard nobody runs.

**The chained bodies are lifted, and the meter says by how much.** Each new rung used to re-enter the four chained check bodies of the rung below -- the rung's own check, its refusals, its measure, and its wire -- which neither fold had reached, so the carry climbed 2,202 to 2,669 with `beckon` and 2,669 to 3,324 with `answer`. Reading which bodies made up that number found eight of them standing byte for byte alike across every rung that held them, and all eight lifted whole: the `mind` chain's measure and wire, the entire `desist` chain, and the `beckon` rung's check and its refusals. **The carry fell 3,324 to 2,762**, fold B climbed 592 to 612, and fold A held at exactly 757 -- the honest signal that lifting a body moves where it runs and never how many folds stand.

**Two bodies stayed home, and the next rung lifted them.** A chain's last link is the one place a rung differs from the rung above it: it ends in `return 0` in the rung that tops the ladder and climbs into the next rung's own check everywhere above. So `check_beckon_measure` and `check_beckon_wire` were one body per rung rather than two copies of one -- until `abate.rye` was born above `answer.rye` and made them agree, at which point they lifted whole beside `check_answer` and its refusals. `check_answer_measure` and `check_answer_wire` took that terminal seat in their place -- and lifted on the very next lap, when `conclude.rye` was born above `abate.rye` and made them agree, beside `check_abate` and its refusals. `check_abate_measure` and `check_abate_wire` took it next, and lifted in their turn when `respect.rye` was born above `conclude.rye`, beside `check_conclude` and its refusals. `check_conclude_measure` and `check_conclude_wire` took the seat after that, and lifted when `refrain.rye` was born above `respect.rye`, beside `check_respect` and its refusals. `check_respect_measure` and `check_respect_wire` took the seat next, and lifted when `farewell.rye` was born above `refrain.rye`, beside `check_refrain` and its refusals. `check_refrain_measure` and `check_refrain_wire` hold the seat now. Every chained body passes through this shape on its way into the harness, one rung at a time.

**Then the stub itself changed, and the carry fell to almost nothing.** What stood at 2,762 was very largely the five-line call each lifted check cost each rung, byte-identical across rungs by design since `@This()` resolves per rung. Those stubs existed for one reason: a chained body re-entered the rung *by name*, and a name the rung never published was a compile error, so silence had no way of being heard. Fold C ([`../active-designing/date/20260820/20260820-182533_caravan-ladder-the-harness-answers-for-silence.md`](../active-designing/date/20260820/20260820-182533_caravan-ladder-the-harness-answers-for-silence.md)) gives silence a meaning: the harness reaches every chained link through `link`, which runs the rung's own body when `@hasDecl` finds one and its own body when it does not. **612 stubs left the ladder in one pass, and the carry fell 2,762 to 47** -- a single copied body across 97 modules and 1,091 checks.

Nothing observable moved, and the shape of the change is why. A rung that keeps a body is dispatched to that body, exactly as before; a rung that publishes nothing reaches the same harness body one call earlier. The test is `comptime`, so the two are the same machine code and a name the harness does not hold can only be reached for by a rung that declares it -- which is how the terminal links of a chain keep their own bodies. All 33 touched rungs were built and run from a cold tree, and the choir sang all 91 GREEN.

**A rung now costs the ladder its own new checks and nothing else**, and five rungs have now proved it by being born: `abate.rye`, then `conclude.rye`, then `respect.rye`, then `refrain.rye`, then `farewell.rye` -- each a whole new rung, and each time the carry stood exactly where it was, at **47** lines, while the ladder grew to 102 modules and 1,321 checks. `farewell.rye` proved something else beside it: born as a copy of the rung beneath it, it inherited that rung's delegations whole, all 39 naming two steps down -- and the one-step guard REDS %98 left behind named the fault on its first pull, before a single line of it reached a send. The ceiling of 4,000 stops being the thing that refuses first, and the meter's job shifts from watching a carry climb to holding a wall at zero: no rung carries a stub that only forwards itself to the harness.

### The spine beside the checks -- what a byte-identical meter cannot see, and where it went

That meter counts **byte-identical bodies**, and it says so in its own first sentence. Beside it, measured `20260820.204641`, stood the ladder's **orchestration spine**: every rung held one `close_the_quarrel` that ran the whole correspondence in order, and a rung born from the rung beneath it copied that function whole and inserted its own step. The staircase was exact -- sixteen lines at `refer`, three more at each rung, eighty-six at `refrain` -- so no two rungs held the same body and the whole spine rode free past a meter reading 47.

Read two ways that agreed, the spine was **106 distinct lines standing on disk 1,003 times across 21 rungs, 897 of them a line the ladder had already written**. The union count asks how many different lines the ladder holds; the neighbor walk asks of each spine how many of its lines already stand in the spine directly beneath it. Both answered 897.

That was a ratchet rather than a red -- nothing was measured wrong, and something was never measured -- so the close was a second meter beside the first: [`../tools/caravan_ladder_spine_witness.rish`](../tools/caravan_ladder_spine_witness.rish) over [`../tools/fixtures/caravan_ladder_spine_scan.sh`](../tools/fixtures/caravan_ladder_spine_scan.sh), holding both numbers in one place so neither can be read alone.

**Fold D moved it on `20260820.212419`.** The spine lives in [`ladder_checks.rye`](ladder_checks.rye) now -- one body taking the rung as a `comptime` parameter and running the steps that rung declares, so the rung holding five steps and the rung holding twenty-five reach the same spine and each gets exactly its own. The staircase became a property the harness derives rather than twenty-one hand-copies of it, and adding a step to the arc costs three lines in one file rather than a fresh copy of everything beneath it.

The numbers moved as the design call predicted, and the one that should have stood still stood still:

| Reading | Before | After |
|---|---|---|
| Rungs holding a spine | 21 | **1** -- the harness |
| Spine lines on disk | 1,003 | **19** at the entry, 170 counting its four movements |
| Carried spine lines | 897 | **0** |
| Spines past TAME's seventy-line bound | 4 | **0** -- the longest movement is 59 |
| Byte-identical carry, beside it | 47 | **47**, unmoved |

That last row is the honest proof: a lift removed a cost rather than trading it for a cheaper-looking one, since the number a lift could most easily have inflated stayed exactly where it stood. The spine ceiling came down 1,100 to **40**, tight enough to catch the second rung that writes a spine of its own rather than the tenth -- the meter stopped sizing a cost and became the wall that keeps the fold folded.

Read in order, the harness spine is four movements and a closing line, the seam the arc has shown since it began: **the standing** (what a run owes a position that outlived it), **the finding** (a case read, answered, met, and carried home), **the second look** (what a reader's short word costs the plan that answered them), **the correspondence** (the movement still growing, where a matter that comes round twice meets a wall and a person outside the plan finally gets a say), and **the booking**, always last. What it cost is named plainly in the brief: opening `refrain.rye` no longer shows the whole arc on one screen. That order lives in the harness now, in the one complete copy there is -- so it is written to be read. Full reasoning: [`../active-designing/date/20260820/20260820-204641_caravan-ladder-the-spine-the-meter-cannot-see.md`](../active-designing/date/20260820/20260820-204641_caravan-ladder-the-spine-the-meter-cannot-see.md).


### The printing, and the two folds that answered most of it

Two honest meters watched this ladder, and a third shape rode free past both. The copy meter reads `check_` bodies and counts byte-identical ones; the spine meter reads one named orchestration function. Every rung also reports what its run did, in words an operator reads -- a `tell_` family printing one line per tier of the correspondence -- and a rung born from the rung beneath it copies that family whole and inserts its own tier. A different prefix than the first meter reads, a different function than the second names, so the printing went uncounted while each elder meter reported a true number. A ratchet, then, rather than an erratum: both had named their own window in their own first sentence.

Measured on `20260820.221349`, the printing stood at **2,468 distinct lines on disk 9,317 times across 42 rungs, 6,849 of them lines the ladder had already written** -- seven and a half times the spine fold D lifted, and the largest carry on the ladder. The meter is [`../tools/caravan_ladder_print_witness.rish`](../tools/caravan_ladder_print_witness.rish) over [`../tools/fixtures/caravan_ladder_print_scan.sh`](../tools/fixtures/caravan_ladder_print_scan.sh), and it reports the carry two ways on purpose, because the split decides what the fold should be: whole bodies standing byte for byte lift the way a check lifts, while the staircase wants the harness seam fold D opened.

**Fold E took the first half on `20260820.222728`.** The note-writing pair is the part of the family the whole correspondence arc never varies: `tell_path`, which writes the address an answer is left at, and `tell_outcome`, which writes the single byte telling a reader how their quarrel came out. Both stood byte for byte in **twenty-nine rungs**, and every symbol either one reaches -- the path ceiling, the readers' directory, the address test, the result shape, the byte that names an outcome, the error set -- already stood public on all twenty-nine. So both lifted into [`ladder_checks.rye`](ladder_checks.rye) whole, each rung keeping a three-line call that leaves its own public surface untouched.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 9,317 | **8,427** |
| Carried printing lines | 6,849 | **5,955** |
| Lines deleted from rungs | -- | **986**, for 174 lines of call |
| Neighbor walk, read independently | 6,641 | **5,735** -- within four percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The last two rows are the same honest proof fold D left: a lift removed a cost rather than trading it for a cheaper-looking one. The ceiling came down 7,800 to **6,900** in the same lap, since a ceiling left where a fold found it hands back exactly the room the fold just won. All twenty-nine touched rungs stand in the top rung's import closure, and that rung runs GREEN from a cold tree, with `tidings`, `abate`, `deem`, `suffice`, `reweigh`, and `apprise` re-run beside it. What remains of the carry is the reader-telling pair -- the two larger bodies that read a run's own report -- and the staircase beneath them, which wants the `comptime` seam rather than a whole-body lift.

**Fold F took the larger half on `20260820.224828`.** `tell_the_reader` carries one finding to the one person who asked for it, and it is the body the whole arc is built to end on: a run reads the quarrel out of the record that keeps it, reads the term that decided it, reads the address the raiser left, writes the result into that reader's own box, and reads the box back before the report believes anybody was told. Sixty lines apiece, standing byte for byte in **twenty-eight rungs**.

It reaches nineteen symbols where the note-writing pair reached six, so the verification came first and cost more. Every one of the nineteen was grepped as `pub` across all twenty-eight rungs before a line moved, and eighteen already stood public. The nineteenth is `tidings_of`, the accessor that finds this tier's own report inside a report nested as deep as the rung stands -- twenty-four `inner` hops in one rung, six in another. That accessor is precisely the staircase, and lifting the body above it needed no flattening of it: one word per rung widened the accessor the harness already reaches every other tier through, and the staircase stayed exactly where it is written.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 8,427 | **6,896** |
| Carried printing lines | 5,955 | **4,401** |
| Lines deleted from rungs | -- | **1,652**, for 56 lines of call |
| Neighbor walk, read independently | 5,735 | **4,069** -- within eight percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The whole-body reading holds at 93 while its line count falls 2,268 to **729**, since the two-line calls a fold leaves behind are themselves a body every rung writes identically. Reading that steadiness as a failure would misread it: the carry that matters is the line reading, and it fell 1,554. The neighbor walk's agreement widened from four percent to eight for the same arithmetic reason -- the same absolute gap standing against a smaller total -- and naming both keeps the next reader from drawing a wrong conclusion from a number that stood still.

The ceiling came down 6,900 to **4,800**, sized so a first new rung passes and a second refuses. All twenty-eight touched rungs stand in the top rung's import closure, that rung runs GREEN from a cold tree, and each of the twenty-eight ran its own witness GREEN beside it. What remains of the carry is `tell_the_reopener` -- forty-eight lines in eleven rungs -- and the staircase of per-tier bodies beneath both. Full reasoning: the design call [`../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`](../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md), and the lap that measured the printing, [`../session-logs/date/20260820/20260820-221349_caravan-ladder-the-printing-two-meters-cannot-see.kyri`](../session-logs/date/20260820/20260820-221349_caravan-ladder-the-printing-two-meters-cannot-see.kyri).

**Fold G spent the last whole body on `20260820.232126`.** `tell_the_reopener` carries what a second look came to out to the reader who asked for it: a run takes its subject off the wire rather than from anything the plan asked for, writes into that reader's own box, and reads the box back before the report believes anybody was told. Forty-eight lines apiece, standing byte for byte in **eleven rungs**, with the rung the family was born on left alone because it writes the body differently.

It reaches eighteen symbols, and this time every one of them already stood public across all eleven -- so the fold widened nothing. That is what the previous fold's one-word widening bought: the accessor pattern the harness reaches every tier through was already in place, and the third lift simply used it. Verification still came first, exactly as before, because a check that only ever passes is still the check that made a five-hundred-line edit safe.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 6,896 | **6,454** |
| Carried printing lines | 4,401 | **3,944** |
| Lines deleted from rungs | -- | **517**, for 11 lines of call |
| Neighbor walk, read independently | 4,069 | **3,483** -- within twelve percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The two readings' gap grew by 129 absolute this lap, where the earlier folds had widened it only proportionally, and the reason is read off the scan rather than guessed: the neighbor walk orders rungs by total file length and compares each against the one before it, so eleven rungs shrinking by forty-eight lines apiece reorder the sequence itself and the walk's own pairing moves beneath it. A fold that shrinks rungs unevenly is exactly the act that most disturbs that reading -- a property of the second reading worth naming, rather than a fault in either.

The ceiling came down 4,800 to **4,300**, sized as before so a first new rung passes and a second refuses. All eleven touched rungs ran their own witness GREEN, the top rung ran GREEN from a cold tree, and the whole choir of **98 Caravan witnesses** sang GREEN cold beside them -- which is how this lap found that the printing meter had never been registered in that choir (**REDS %101**), and, folding the ledger that red filled, that the ledger's own spine guard had been proving seventy-three rows of a hundred and one (**REDS %102**). Both closed with looms rather than with fixes: the roster bijection lifted into a scan the every-lap ladder meter pulls, and the spine guard taught to discover its archives on disk rather than read a list somebody maintains by hand.

What remains of the printing carry is the staircase of per-tier bodies, which wants a different fold than a whole-body lift -- the whole-body carry is spent.

**Fold H reached past byte-identity on `20260820.235259`.** The desisting telling -- `tell_desist_half` and the `tell_desist_third` it chains into -- stood in **eight rungs** at forty and fifty-two lines apiece, and the whole-body reading could not see it at all: no two of the sixteen bodies hashed alike, so every one of them counted as distinct. Reading them side by side showed why. They differ in exactly one thing -- the pair of words naming which plan each column reports, `holding, abating` in the abating rung and `leaving, hearing` in the answering one. Mask that pair and all eight halves are one hash, and all eight thirds are another.

So the fold takes the pair as **comptime text** and lifts the bodies whole. Each rung keeps a three-line call handing in its own two words, the harness composes the printed line by concatenation, and every line comes out exactly as that rung wrote it. Six symbols widened by one word in each of the eight -- `dwell_of`, `endure_of`, `heed_of`, `relent_of`, `swell_of`, and the tail the harness hands control back to -- verified as `pub` across all eight before a line moved, the check that has made every fold in this arc safe.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 6,454 | **5,848** |
| Carried printing lines | 3,944 | **3,433** |
| Lines deleted from rungs | -- | **816**, for 56 lines of call |
| Neighbor walk, read independently | 3,483 | **2,715** -- within twenty-one percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The proof this fold rests on is stronger than a hash, because a hash could no longer reach it. All eight rungs were built and run before the edit and their whole printed output captured; all eight were built and run after, and the two outputs stand **line for line identical** -- save forty-two lines whose order concurrent clients set rather than the fold, which hold their count exactly. Measurement caught that nondeterminism honestly: a first comparison read as a difference, and running one binary twice showed the ordering moves on its own.

The ceiling came down 4,300 to **3,700**, sized as before so a first new rung passes and a second refuses. All eight touched rungs ran their own witness GREEN, and the whole choir sang GREEN cold beside them.

What remained carried was the **true staircase** -- `tell_desist_tail` and `tell_beckon_own`, bodies that read tiers through a nesting each rung writes at its own depth, nine and ten `inner` hops in one rung where the next writes eight. Both looked like they wanted an accessor **born** rather than a body lifted. The two folds below found otherwise: every accessor those bodies needed was already standing.

**Fold I lifted the staircase's first half on `20260821.002546`, and widened nothing.** `tell_desist_tail` stood in **eight rungs** at fifty-two lines apiece with no two hashing alike, varying in two things: the pair of words fold H had already learned to lift, and the depth of the raw nesting reaching three tiers. The whole cost was read before a line moved, and it came to zero. Mapping each rung's nesting depth against its own accessor table showed all three tiers -- sufficing, reopening, reweighing -- already had an accessor standing at exactly that depth, and all **six symbols the body reaches already stood `pub` across all eight rungs**. That is folds F and G compounding: F widened one accessor by hand across twenty-eight rungs, G found eighteen of eighteen already public because of it, and this lap found six of six.

Substituted, masked, and hashed, all eight collapsed to one hash, and seven of the eight were then identical outright -- `desist` differing in one more thing, its trailing hop naming its own next tier where the other seven name theirs. That hop stayed in the rung's own delegate rather than widening seven symbols or reaching for indirection, so the staircase stayed written where each rung writes it.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 5,848 | **5,522** |
| Carried printing lines | 3,433 | **3,231** |
| Lines deleted from rungs | -- | **392**, for 8 lines of call |
| Neighbor walk, read independently | 2,715 | **2,646** -- the gap narrowing for the first time |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The ceiling came down 3,700 to **3,500**. Parity was proven by building and running all eight rungs before and after: every sorted multiset identical, zero non-client differences, and the interleave proven to be the run rather than the fold by running one *unfolded* binary twice and watching it disagree with itself by more lines than the fold did.

**Fold J lifted the whole staircase on `20260821.005102`, and the accessor it was said to want was already born.** `tell_beckon_own` stood in **seven rungs** from thirty-four lines to a hundred and eleven, and the length itself looked like content: each rung walks up to the tiers it owns, so neither a hash nor a mask could reach it. Reading the seven side by side against their own accessor tables showed what the lengths were hiding.

Each body is a staircase of **tier groups**, three printed lines apiece, and every rung prints the groups reaching from the recount tier up to its own. Masked for the pair of words and for nesting depth, the seven are **one thirty-five-line sequence in strict prefix order** -- beckon says the first seventeen lines, answer the first twenty, farewell all thirty-five -- each followed by the same three-line tail. Nothing in the seven is a variation; they are seven different lengths of one staircase.

And the depth needs no counting at all. Every rung of this arc already publishes **one named reach per tier it wraps**, exactly so a miscount cannot hide inside a chain of `inner`, and those reaches form an exact triangle: farewell declares eleven, refrain ten, beckon five. So a rung's share of the staircase is **derived** from the accessors it declares rather than kept in a list somebody maintains by hand -- the lesson REDS %102 taught, applied at the moment of design rather than after a guard went blind.

The staircase stands once in `ladder_checks.rye` as a comptime table of twelve tiers, and each rung keeps a one-line call handing in its own two words. The two invariant asserts lifted with it, written as named reaches -- every rung's second assert turned out to reach exactly the mind tier. Three symbols widened by one word each across the seven -- `below_of`, `bearing_of`, `preceded_of` -- the same one-word move fold F made.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 5,522 | **4,919** |
| Carried printing lines | 3,231 | **2,932** |
| Lines deleted from rungs | -- | **603**, for 7 lines of call |
| Neighbor walk, read independently | 2,646 | **2,616** -- within eleven percent, converging |
| Bodies past TAME's seventy-line bound | 9 | **4** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The ceiling came down 3,500 to **3,100**. All seven rungs were built and run before the edit and after it, and **every sorted multiset stands identical with zero lines differing** -- the strongest parity any fold in this arc has shown. The ordered comparisons differ by ten to sixteen lines, every one of them a concurrent-client line present in the same count on both sides, and an unchanged binary run twice against itself differs by eight in exactly the same way.

Five of the nine bodies past TAME's seventy-line bound left by construction rather than by a split, the ratchet and the fold wanting the same lap. `tame_style_check` and `width-check` are clean, all three ladder meters GREEN, and the whole choir of **98 Caravan witnesses** sang GREEN cold beside them.

**Fold K lifted the run-telling on `20260821.013000`, and it was the plainest fold this arc has had.** `tell_desist_runs` stood in **eight rungs at fifty lines apiece** -- 400 lines carried, the movement that counts phases and dependents before the telling turns to the quarrel the desisting rung holds. Its shape was measured rather than guessed: masked for the pair of words naming which plan each column reports, all eight collapse to **one hash**, and this time the nesting depth stood identical across all eight as well. No staircase hid here at all.

So the fold is fold H's shape with nothing added. The body lifts whole into `ladder_checks.rye` as `tell_desist_runs`, the pair arrives as comptime text, and each rung keeps a one-line delegate handing in its own two words. Nine symbols widened by one word each across the eight -- `abandoning_of`, `recanting_of`, `amending_of`, `couriering_of`, `disputing_of`, `abiding_of`, `lapsing_of`, `reposing_of`, `appeal_of`, with `below_of` making a tenth in the desisting rung -- verified as `pub` before a line moved, the check that has made every fold in this arc safe. **457 lines deleted for 157 of harness and call.**

One raw reach remains, and the harness names it rather than hiding it: the absorbed tally sits four levels below `abandoning_of`, since no rung publishes an accessor reaching that tier. The chain stood at the same depth in all eight rungs, and it stands once now, where a single reading governs every rung that calls in. Naming it is the honest form of fold J's lesson -- an accessor born for that tier is the next lap's cheap work, and the comment says so where the code is.

Parity is the strongest form this arc has settled on. All eight rungs were built and run before the edit and after it, and **every sorted multiset stands identical with zero lines differing**. The ordered comparisons differ by four to sixteen lines, every one a concurrent-client line present in the same count on both sides -- and an unchanged binary run twice against itself differs by fourteen in exactly the same way, so the interleave is the run rather than the fold, as folds I and J each proved before it.

The two rows a lift could most easily have inflated stood still for the seventh fold running: the byte-identical check carry holds at **47** and the orchestration spine at **0**. The ceiling came down 3,100 to **2,800**. The neighbor walk's gap narrowed 21 percent to **13**, by the same mechanism that widens it -- the walk orders rungs by file length, so a fold that shrinks eight rungs by forty-nine lines apiece moves its own pairing. `tame_style_check` and `width-check` are clean, all three ladder meters GREEN, and all eight rung witnesses GREEN beside them.

**The printing carry has fallen 5,955 to 2,686 across six folds -- and this lap found that the carry is far from spent.**

Six folds all lived inside the `tell_` family, and the arc's own record had begun to read "the staircase is spent" as though the family were the ladder. Asking the masked question of **every** printing body rather than the `tell_` ones alone answers otherwise, and the two largest carriers in the ladder had never been looked at:

- **`stand_taking_and_returning_reach`** -- **42 of its 44 rungs share one hash** at thirty-five lines apiece, **1,435 lines carried**. Larger than any single fold this arc has taken, and the two rungs that differ stand at seventy-six and eighty lines, which is their own content rather than a variation.
- **`run_dependent`** -- **43 of its 67 rungs share one hash** at thirty-three lines apiece, **1,386 lines carried**, with the remaining twenty-four genuinely various.

Naming this correction plainly matters more than the fold that found it. A narrative built from six laps in one family had quietly become a claim about the whole, and only asking the meter a wider question could disagree with it. **Measurement beats memory, including the memory written down six laps in a row.**

**Fold L lifted the standing-dependent window on `20260821`, and it is the largest single fold this arc has taken.** `stand_taking_and_returning_reach` -- the body that reads the arcs one dependent was handed, grafts every arc it is conferred, and returns the reach the run asks back before it comes home -- stood **byte for byte in forty-two of its forty-four rungs at forty-four lines apiece**. No mask was needed and none was used: the forty-two hash alike exactly as written, so the body lifts precisely the way a check lifts.

The two rungs that stand apart, `reclaim` and `revoke`, keep their own bodies at eighty-five and eighty-eight lines, which is their own content rather than a variation on this one.

Four symbols widened by one word each across the forty-two -- `read_own_line`, `graft_promised_reach`, `return_promised_reach`, and `reachable_between` -- every one verified as `pub` before a line moved, and `offered`, `falling_promised`, and `Words` already stood public on all forty-two, which is nine folds of the habit compounding. Four rungs that had never needed the harness gained their import. **1,638 lines deleted for 281 of harness and call, and 1,189 lines came off disk.**

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 42 | **0**, each keeping a nine-line delegate |
| Lines the body carried | 1,764 | **0** |
| Lines on disk, all of `caravan/` | 379,740 | **378,551** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

Parity is the strongest this arc has shown. All forty-two rungs were built and run before the edit and after it, and **every one of the forty-two sorted multisets stands identical with zero lines differing**. Thirty-three rungs differ in ordered comparison by two to eighteen lines, and an unchanged binary run twice against itself differs by eight the same way -- the interleave is the run rather than the fold, as folds I, J, and K each proved before it. All forty-two rung witnesses ran GREEN on metal, `tame_style_check` and `width-check` are clean, and the whole choir sang GREEN beside them.

### The wider question, made standing -- a fourth meter, and the room the three windows sit in

Fold L was found by hand, by asking one wider question after six folds inside the `tell_` family. That is the part worth keeping, and this lap turned it into a meter rather than leaving it as luck.

Three meters stood on this ladder, and every one reads through a **named window**: [`caravan_ladder_copy_scan.sh`](../tools/fixtures/caravan_ladder_copy_scan.sh) reads bodies opening on `check_`, [`caravan_ladder_print_scan.sh`](../tools/fixtures/caravan_ladder_print_scan.sh) reads bodies opening on `tell_`, and [`caravan_ladder_spine_scan.sh`](../tools/fixtures/caravan_ladder_spine_scan.sh) reads one named function. Each is honest inside its window, each says so in its own first sentence, and together they governed eleven folds. What none of the three can see is a body named anything else -- which is exactly why the largest carry on the ladder rode past all three for six consecutive folds.

So the fourth meter has **no name in its window at all**. [`caravan_ladder_carry_scan.sh`](../tools/fixtures/caravan_ladder_carry_scan.sh) reads every top-level body in every module, compares them by exact text rather than by hash, and prints the fold queue largest-first. Its answer, measured rather than estimated:

| Reading | Carried lines |
|---|---|
| Byte-identical `check_` bodies | 47 |
| `tell_` printing | 2,686 |
| Orchestration spine | 0 |
| **Every body, the whole ladder** | **142,850** across 10,198 copied bodies of 17,975 |

**698 families carry at least one copy, and 247 of them carry past a hundred lines each.** The largest is `mend_the_plan` -- 36 rungs holding one 178-line body, **6,230 carried**, which alone is larger than any fold this arc has taken, fold L included. Behind it stand `fill_table` at 2,898, `reckon_the_plan` at 2,700, `provision_notes` at 2,093, and `confer_one` at 2,067; `graft_promised_reach`, one of the very helpers fold L widened, carries 1,763 of its own.

This is a **ratchet rather than a red against the three**. Each named its window plainly, so nothing was measured wrong -- something was never measured. Yet the correction is worth stating without softening: the arc's own record had come to read the printing carry as *the* carry, and the ladder's real carry is two orders of magnitude larger. That is [`REDS %102`](../construction/REDS.md)'s family at ladder scale -- a reading that sees a subset answers in the voice of the whole, and a GREEN over part of a subject is more dangerous than a RED. The answer is never a fourth named window; it is one window with no name in it.

The meter is proven by [`caravan_ladder_carry_witness.rish`](../tools/caravan_ladder_carry_witness.rish) -- the living count under a named ceiling, the three windows read beside it so no reader mistakes a window for the room, the counting proven by hand on a two-rung control set whose added body opens on a prefix no meter names, and three RED paths refusing by name. It is **registered in the choir on the lap it was born**, which is [`REDS %101`](../construction/REDS.md)'s whole lesson, and the choir now sings **99**.


### Fold M -- `mend_the_plan`, the largest body on the ladder, and the accessor that brought the last rung in

The fourth meter was born on the lap before this one, and its first printed queue named `mend_the_plan` at the top. This lap folded it. **That is the whole argument for a printed queue**: fold L was found by hand after riding past three meters for six folds, and fold M was found by reading one line of output.

`mend_the_plan` is the body that repairs the losses a plan took which its author never asked it to carry, then settles whatever the repair could not reach. It stood **byte for byte in thirty-six rungs at a hundred and seventy-eight lines apiece** -- and nearly in a thirty-seventh.

That thirty-seventh is the interesting one. [`recant.rye`](recant.rye) *owns* the recanting tier, so where every rung above it reaches its recantation through `recanting_of`, `recant.rye` reached its own report directly -- two lines out of a hundred and seventy-eight. Naming the accessor there, three lines returning the report itself, brought the last rung into the fold. Fold J learned this on the staircase and it holds again: **an accessor born for the tier a rung owns is the cheapest line in the arc.** Thirty-six rungs became thirty-seven, and the carry to lift climbed 6,230 to **6,408**.

Twelve symbols were widened by one word each before a line moved, every one verified `pub` across all thirty-seven first: `Table`, `standing`, `appraising_of`, `abandoning_of`, `below_of`, `bearing_of`, `recanting_of`, `run_of`, and the four spine bodies the repair runs -- `seat_the_record`, `fill_table`, `reap_oldest`, `judge_outcome`. **427 widenings in all.** Every other symbol the body names -- its plan's phases, the wire it published its judgment to, and each refusal it may raise -- already stood public from earlier folds, which is ten folds of the habit compounding.

Widening those four spine bodies is the compounding made visible: `fill_table` carries 2,484 lines across 37 rungs and `reap_oldest` 1,716 across 40, and both now stand public for the folds that will come for them. A fold's own widening puts the next fold in view, exactly as fold L first noticed.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 37 | **0**, each keeping a nineteen-line delegate |
| Lines the body carried | 6,408 | **0** |
| The ladder's whole carry | 142,850 | **137,140** |
| Carry ceiling | 143,000 | **137,300** |
| Lines on disk, all `caravan/*.rye` | 378,383 | **372,895** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

Both endpoints of that disk row were re-measured this lap by the same command rather than carried forward from fold L's note, since a tally repeated from memory drifts ([`REDS %93`](../construction/REDS.md)).

**6,403 lines deleted for 747 of harness and call, and 5,488 lines came off disk** -- the largest fold this arc has taken, more than three times fold L. The two rows a lift could most easily have inflated stood still for the **ninth** fold running: the byte-identical check carry at 47 and the orchestration spine at 0. A cost removed rather than traded, nine laps in a row.

Proven the way this arc proves things: the whole choir sang **99 GREEN from a cold tree**, every one of the thirty-seven folded rungs among them, with `tame_style_check` bans clean, `width-check` clean, and the ladder reach guard holding at one rung below per rung. The carry meter's own pins moved with the measurement rather than after it, and its ceiling came down in the same commit -- because a meter whose ceiling lags its subject is a guard that has stopped guarding.

`reckon_the_plan` led the queue as fold M closed, at 2,700 lines across 37 rungs, with `fill_table` at 2,484 behind it -- and fold N below lifted it. **703 families still carry a copy**, so the queue outlasts many laps and no lap need guess what is next.


## `refusals.rye` -- the whole vocabulary a verified kernel answers with, and the four Caravan speaks today

`capabilities.rye` names four outcomes: allowed, no such dependent, no such resource, rights insufficient. Those four were enough while the table sat on hosted ground answering only to itself. A root task on seL4 answers to a kernel, and that kernel refuses a capability invocation with one of **eleven** named errors -- a count read out of seL4's own compiled enums on `20260821.043831` rather than recited from a manual.

`refusals.rye` states the whole eleven, maps Caravan's four onto them **totally**, and names for each of the seven remaining which subsystem will owe the answer. The mapping is pure policy -- hosted, no kernel beneath it -- and it is asserted rather than described, so the design agenda is a thing the compiler holds rather than a paragraph somebody remembers.

**Three distinct answers, chosen on purpose.** A dependent the table has never heard of is a slot with nothing in it, so it becomes a **failed lookup**. A dependent holding no capability for the named resource holds the wrong capability for the request, so it becomes an **invalid capability**. A dependent holding the capability yet lacking the right is asking a real object for a method closed to it, so it becomes an **illegal operation**. Collapsing any two of those is what the RED path plants, and the module's own self-test refuses it -- because a capability system that answers every refusal the same way cannot audit itself, which is the reason `refusal_reason` exists at all.

**The seven owed, each to a subsystem rather than to a wish.** The **derivation tree** owes *delete-first* and *revoke-first*, since a granted capability may be handed on and grants therefore form a tree Caravan must keep. **Untyped retyping** owes *not-enough-memory*, since memory a dependent receives is carved from a region with a real floor. The **IPC buffer** owes *truncated-message*. Argument, bounds, and alignment checking owe the remaining three, each at the edge where a supervised method meets its own arguments. That is a design list arrived at by measurement.

| Measured `20260821` | Value |
|---|---|
| Refusals seL4's header declares, read at run time | **11** |
| Caravan outcomes mapped onto them, totally | **4** |
| Refusals still owed, each named to a subsystem | **7** |
| Lines this module adds to the ladder's carry | **0** -- eleven distinct bodies, none a copy |

Proven by [`tools/caravan_refusals_witness.rish`](../tools/caravan_refusals_witness.rish), GREEN on metal. The eleven symbols **and their order** are diffed against the vendored BSD-2-Clause `sel4/errors.h` at run time, so a vendored bump that moves the vocabulary reds this rung on the lap it lands, and the right to read that header is re-checked at the file level rather than inherited from a verdict. Both RED paths fire: a header whose refusal names drift is refused by the parity scan, and a copy of the module with two answers collapsed into one fails its own self-test. The choir sang **100 GREEN** with it registered, and the four ladder meters moved their module pins 102 to 103 in the same commit as the code -- a meter whose pins lag its subject has stopped guarding.

**What this does not claim.** No kernel booted and no capability was invoked, so *which* of the eleven each Caravan outcome should become is design judgement, named as such at the door. This rung binds the vocabulary and the totality; the semantics earn their proof the day an invocation actually runs.

**Corrected one lap later, and the correction became a check (REDS %107).** The parity scan bound the eleven **names** and their order, and said nothing about what a name means -- so two of the meanings shipped wrong, `seL4_DeleteFirst` carrying `seL4_RevokeFirst`'s sentence. seL4 publishes a description for every refusal in its own BSD-2-Clause interface files, and it is unambiguous: `seL4_DeleteFirst` means *the destination slot already contains a capability*, in nine occurrences across `object-api.xml`, every one that sentence. Both meanings now read as seL4 publishes them, and [`tools/fixtures/caravan_refusal_meaning_scan.sh`](../tools/fixtures/caravan_refusal_meaning_scan.sh) holds three of them **two-sidedly** -- the kernel's own load-bearing phrase must still stand in the vendored XML, and our sentence must still carry its own, so a reword on either side reds the rung. The eight meanings still unbound are counted and reported rather than passed over. A parity check that binds a name proves nothing about what the name means.

## The derivation tree -- the two refusals only a lineage can answer

`derivation.rye` (`20260821.052104`) pays the largest of the seven debts the rung above named. A capability that may be handed on makes a **tree**, and a tree is the only thing that can honestly say whether removing one grant would orphan reach somebody is still holding. So the module keeps lineage: every derived capability knows the slot it came from, its depth beneath the root, and the rights it was narrowed to.

**Reach only ever narrows along a lineage.** A derived capability carries a subset of its parent's rights, always. A request to widen is refused with `seL4_IllegalOperation` at the edge, and the whole-table invariant re-proves attenuation across every live slot afterward -- so the property is checked twice, once where it could go wrong and once over the result.

**The two owed refusals, as the tree means them.** A **held destination slot** answers `seL4_DeleteFirst`: seating another capability there would silently drop the one standing, so the standing one is deleted deliberately, first. A capability with **capabilities derived from it** answers `seL4_RevokeFirst`: removing it would leave a child whose parent vanished, which is reach nobody granted and nobody can audit. Revoke clears a whole lineage in one bounded pass and keeps the capability it was asked about, deciding descent against the tree as it stood on entry so clearing one slot can never hide a deeper one from the same pass.

| Measured `20260821` | Value |
|---|---|
| Kernel refusals this rung answers | **2** -- `seL4_DeleteFirst`, `seL4_RevokeFirst` |
| Kernel refusals it reuses from the table above | **2** -- `seL4_FailedLookup`, `seL4_IllegalOperation` |
| Slots one tree holds | **32**, bounded on purpose |
| Depth a lineage may stand | **4**, so every walk up terminates in a known number of steps |
| Bounds refusing by named Rye error rather than kernel answer | **2** -- `SlotOutOfRange`, `DerivationTooDeep` |

Proven by [`tools/caravan_derivation_witness.rish`](../tools/caravan_derivation_witness.rish), GREEN on metal, with both RED paths planted rather than described: a tree that lets reach **widen** as it is handed on fails its own self-test, and a revoke that sweeps only **direct** children leaves a grandchild standing and the postcondition inside `revoke` names it. The choir sang **101 GREEN** with it registered, and the four ladder meters moved their module pins 103 to 104 in the same commit as the code. (The ladder stands one module wider since, and the meters moved with it -- REDS %108 caught a meter's closing prose reciting a module count its own scan contradicted, and closed it the way REDS %105 closed: the number is gone from the sentence and reaches the reader through the scan's own printed output.)

**What this does not claim.** The bounds are this module's own capacity rather than an answer the kernel offers, so they refuse by named Rye error and the general bounds-checking debt stays open. No kernel booted; the lineage rules are ours, written to the shape of the answers seL4 publishes, and they earn their behavioural proof the day a root task actually invokes a capability. **Five of the seven the rung above named remain owed** -- argument, bounds, and alignment checking, the IPC buffer, and untyped retyping. `refusals.rye` still counts seven, and rightly: its count is what the *policy table* can answer, and the table above the line has not yet learned to speak through the tree.


## The IPC buffer -- a bounded message with a named minimum

`ipc_buffer.rye` (`20260821.053811`) pays the next debt on the agenda, and its shape was named for it in advance: `refusals.rye` gave the IPC buffer's reason as *the message a dependent sends is a bounded buffer with a named minimum*. Truncation is a question about how many words arrived, rather than about rights or lineage, so neither the policy table nor the derivation tree can answer it. A message that declares its own length, read against a minimum each method states for itself, answers it exactly.

**The minimum belongs to the method.** Four supervision methods stand, each naming what it reads before it can act at all: `restart` reads a dependent, `enlist` reads a dependent and the cohort it joins, `apprise` reads a dependent and the status it reports, and `entrust` reads a dependent, a resource, and the rights handed over. A two-word message therefore satisfies three of the four and answers `seL4_TruncatedMessage` to the fourth -- so truncation reads as a floor rather than a mood, and a method never gets read half-way.

**Three properties carry the buffer.** A tag never claims more than the buffer holds, since the declared length is taken from the words actually written rather than from a caller's word for it. A reader never reaches past that length, and a read one word beyond it refuses by named Rye error with a hundred and nineteen words of array still standing behind it. And a shorter message leaves no residue of a longer one: the tail is cleared on every send, so a drifted length can never surface a word from the message that came before.

| Measured `20260821` | Value |
|---|---|
| Kernel refusals this rung answers | **1** -- `seL4_TruncatedMessage` |
| Words one message may carry | **120**, seL4's own `seL4_MsgMaxLength`, re-read from the vendored header each run |
| Capabilities riding beside them | **3**, derived from `seL4_MsgExtraCapBits` exactly as seL4 derives it |
| Methods naming a minimum | **4** -- `enlist` 2, `entrust` 3, `apprise` 2, `restart` 1 |
| Bounds refusing by named Rye error rather than kernel answer | **3** -- `MessageTooLong`, `TooManyExtraCaps`, `ReadOutOfRange` |

**The meaning is honestly unbound, and the witness proves that rather than assuming it.** seL4 publishes a per-method description for several of the eleven, and `caravan_refusal_meaning_scan.sh` binds ours to the kernel's two-sidedly wherever it does. `seL4_TruncatedMessage` is not among them: it stands in `errors.h` as a name and appears in no interface description, measured on this run. So the sentence beside it is Caravan's own reading, named as such -- and the witness asserts the absence, so the day seL4 publishes a description the rung reds and asks for the binding.

Proven by [`tools/caravan_ipc_buffer_witness.rish`](../tools/caravan_ipc_buffer_witness.rish), GREEN on metal, with both RED paths planted rather than described: a buffer that stops comparing the declared length against the method's minimum reads a short message as satisfied and fails its own self-test, and one that stops clearing its tail lets a word of a longer message survive a shorter one and the postcondition inside `send` names it. The choir sang **102 GREEN** with it registered.

**Four of the seven remain owed** -- argument, bounds, and alignment checking, and untyped retyping. `refusals.rye` still counts seven, and rightly: its count is what the *policy table* can answer, and the table above the line has not yet learned to speak through either the tree or the buffer.


## Untyped retyping -- a region with a real floor

`untyped.rye` (`20260821.060758`) pays the last of the three subsystem debts, and `refusals.rye` had written its reason a rung in advance: *memory a dependent receives is carved from an untyped region with a real floor*. Neither the policy table nor the derivation tree can answer `seL4_NotEnoughMemory`. A table says who may ask; a tree says whose reach a grant descends from. Only a region that knows how much of itself is spent can say there is too little left.

**Alignment is what makes the floor cost something.** seL4 places every object at an address that is a multiple of the object's own size, so the watermark climbs to the next boundary before a carve begins -- and the climb is spent memory. Sixteen bytes of endpoint followed by a page costs the whole four-thousand-and-ninety-sixth byte of boundary, and the region's yield says so. A page-wide region that has given out one endpoint holds four thousand and eighty unspent bytes and still refuses a page, honestly, because the only page boundary left is its own far end.

**The flattering sentence was refused.** It reads well to say that a raw remainder therefore over-promises, and that a region with a page of bytes free can be unable to hold a page. Reasoning it through to build the RED path showed it is **false** for a naturally aligned power-of-two region, and the module says so rather than shipping the flourish. Any carve large enough to be worth asking about forces the region to be at least as wide as the object, which makes the origin aligned to the object, which makes the span from an aligned start to the region's end an exact multiple of the object's size; the request is such a multiple too, and the padding is always strictly smaller than one object, so no request can land in the gap between the two readings. **The aligned floor and the plain remainder agree, always** -- proven by sweeping every kind, every count to the bound, and every reachable watermark over regions four to twenty bits wide at three origins apiece, rather than asserted once.

That agreement is a consequence of natural alignment rather than a licence to drop it, and the module holds the distinction structurally: `open` refusing a misaligned origin is what buys the theorem, so one of the three RED paths removes exactly that refusal.

| Measured `20260821` | Value |
|---|---|
| Kernel refusals this rung answers | **1** -- `seL4_NotEnoughMemory` |
| Region width | **4 to 38 bits**, seL4's own `seL4_MinUntypedBits` and `seL4_MaxUntypedBits`, re-read from the vendored riscv64 header each run |
| Object kinds carved | **3** -- slot 5 bits, endpoint 4 bits, page 12 bits, each stated by seL4 with no `#ifdef` above it |
| Configured sizes deliberately absent | **2** -- `seL4_TCBBits` (11 with an FPU, 10 without) and `seL4_NotificationBits` (6 under MCS, 5 without), each proven still config-dependent upstream |
| Objects one carve may ask for | **64**, Caravan's own bound rather than seL4's |
| Bounds refusing by named Rye error rather than kernel answer | **5** -- `RegionTooSmall`, `RegionTooLarge`, `RegionMisaligned`, `TooManyObjects`, `EmptyRequest` |

**The absent object kinds are earned rather than habitual.** In the very header these sizes are read from, two stand behind kernel configuration -- a TCB is 2,048 bytes with an FPU and 1,024 without, a notification 64 bytes under MCS and 32 without. A userland reciting one number for either would be right on one build and wrong on another, so the roster carves only what seL4 states unconditionally, and the witness asserts both are **still** stated two ways. The day seL4 names one size, the rung reds and is invited to carve it.

Proven by [`tools/caravan_untyped_witness.rish`](../tools/caravan_untyped_witness.rish), GREEN on metal, with all three RED paths planted rather than described: a carve seating at the raw watermark never spends its climb, a refusal that eats the region turns a declined request into spent memory, and an `open` that welcomes a misaligned origin breaks the very precondition the swept equivalence rests on. The choir sang **103 GREEN** with it registered, and the ladder meters moved their module pins 105 to 106 in the same commit as the code.

**Registering it found REDS %109.** Growing the ladder reddened the copy meter on a line that had nothing to do with the module count: REDS %108's own strongest RED path reached for `git show HEAD:` to hand the guard the drifted spine meter, and the fix and the guard had ridden in the same commit -- so `HEAD` named the repaired file from the moment it landed, and the control proved itself on exactly one lap. Closed by freezing the elder meter as a tracked copy at [`tools/fixtures/caravan_ladder_prose_count_elder/`](../tools/fixtures/caravan_ladder_prose_count_elder/), byte for byte as it shipped, which cannot follow `HEAD` and outlives a deep debride that would rewrite every hash in the tree.

**The three edge debts remain** -- argument, bounds, and alignment checking. They are one family and may well be one rung. `refusals.rye` still counts seven owed, and rightly: its count is what the *policy table* can answer, and the table has not yet learned to speak through the tree, the buffer, or the region.


## The edge -- three refusals asked of the request alone

`edge.rye` (`20260821.063720`) closes the last family on the refusal agenda, and the agenda had already grouped it: argument checking owes `seL4_InvalidArgument`, bounds checking owes `seL4_RangeError`, alignment checking owes `seL4_AlignmentError`. They are one family because they are **one moment** -- each is a question asked of the *request* rather than of the system, answerable before a slot is touched, before a lineage is walked, before a byte of a region is spent. That moment is the edge, and one rung is the honest shape for it.

**The ground is seL4's own, and `Untyped_Retype` publishes all three at once** -- which makes retyping the place to stand rather than an abstraction invented for the rung. A `size_bits` too big or too small for the requested object type is `seL4_InvalidArgument`; a `num_objects` greater than `CONFIG_RETYPE_FAN_OUT_LIMIT` is `seL4_RangeError`; and riscv's own page method gives alignment its sentence, *"the vaddr is not aligned to the page size."* Each is re-read from the vendored BSD-2-Clause XML every run, so a reword upstream reds the rung rather than leaving our reading quietly orphaned.

**The order is Caravan's own, and the module says so.** seL4 lists a method's errors **alphabetically** -- `DeleteFirst`, `FailedLookup`, `IllegalOperation`, `InvalidArgument`, `InvalidCapability`, `NotEnoughMemory`, `RangeError` -- which is a reading order for a manual rather than a checking order for a kernel. That was measured rather than assumed, and [`tools/fixtures/caravan_edge_order_scan.sh`](../tools/fixtures/caravan_edge_order_scan.sh) re-asks it every run, so the day seL4 publishes a real sequence the rung reds and asks for the reading instead of keeping ours by default. Ours is chosen so each check depends only on facts the checks before it established: **argument** first, since until a request names a real object at a size that kind can be there is no count to bound and no size to align to; **range** second, since a count is answerable the moment the kind is known and needs no address at all; **alignment** last, since it alone needs both the kind's size and an address the caller supplies.

Exactly one answer comes back, and where a request fails more than one check the **earliest** wins. That is proven by building requests that fail two and three at once -- including one failing the first and third while the second passes, so the answer is genuinely the earliest rather than the first found by luck of adjacency -- and then swept: over every kind, eleven widths, counts spanning the kernel's fan-out limit, and a thousand-odd addresses, every request is either welcomed with no check failing or refused by its earliest failing check, with both arms of the proof exercised.

| Measured `20260821` | Value |
|---|---|
| Kernel refusals this rung answers | **3** -- `seL4_InvalidArgument`, `seL4_RangeError`, `seL4_AlignmentError` |
| Debts closed on the agenda | **3** -- argument checking, bounds checking, alignment checking |
| Objects one seL4 invocation may create | **256**, stated two independent ways upstream and read both ways |
| Objects Caravan's own region carves | **64** -- a different line, kept apart on purpose |
| Published sentences bound two-sidedly | **3**, one per refusal |

**Two lines, both real, and which is which.** seL4 lets one retype create up to 256 objects; Caravan's region carves at most 64. A request for sixty-five is **welcomed** by the edge, because the kernel permits it, and **refused** by the region, because we do not hold that much. Both refusals are honest, and the rung proves each names its own author -- a reader who conflated them would think the kernel forbids what only we do.

**What this pays, and what it leaves standing.** Two conditions `untyped.rye` refuses by named Rye error have published kernel answers, and the edge now speaks them: a `size_bits` outside the untyped limits is `seL4_InvalidArgument`, a count past the fan-out limit is `seL4_RangeError`. `untyped.rye` keeps its own Rye errors unchanged, because they are its capacity rather than the kernel's line. The edge is the boundary; the region is the room.

Proven by [`tools/caravan_edge_witness.rish`](../tools/caravan_edge_witness.rish), GREEN on metal, with all three RED paths planted rather than described: a reversed checking order answers a request by the wrong one of its two failures, two checks collapsed into one answer tell a caller to fix the wrong argument, and an alignment check that welcomes every address is the quietest failure of the three since nothing refuses and every request looks healthy. The choir sang **104 GREEN** with it registered, and the ladder meters moved their module pins 106 to 107 in the same commit as the code.

**Every one of the seven owed refusals now has a module that answers it.** `refusals.rye` still counts seven owed, and that stays exactly right: its count is what the **policy table** can answer, and the table has not learned to speak through the tree, the buffer, the region, or the edge. The debt closes when the table itself can answer, never when a neighbour can -- which names the next real rung on this arc rather than letting four green modules quietly claim it.


## The reply -- the policy table speaks through its neighbors, and the agenda closes by measurement

`reply.rye` (`20260821.071421`) answers the question the edge rung deliberately left open. Four modules had paid every debt on the refusal agenda -- the edge for argument, range, and alignment; the buffer for truncation; the tree for delete-first and revoke-first; the region for not-enough-memory -- and `refusals.rye` still counted **four answered and seven owed**. That count was right, and it stayed right on purpose: it measures what the **policy table** can reach, and a table that has never learned to ask a neighbour reaches exactly as far as it did before the neighbour was born. A debt closes when the table itself can answer, never when a neighbour can.

So this rung is the asking. One **ask** arrives carrying everything a supervised request holds, and four stages read it in an order Caravan chose. The **edge** reads the request alone. The **message** reads whether enough words arrived for the method to name a subject. The **table** reads whether this dependent may do this thing. The **deed** carries out what a permitted ask asked for. Exactly one answer comes back, and the earliest stage wins -- the same rule the edge keeps among its own three checks, kept one floor up among the four.

**The order is Caravan's own, and each stage names its own reason in code.** The edge stands first because a request whose size no object can be gives every later question nothing to be about. The message stands second because until its method's words have arrived, the dependent and resource it names cannot be read out of it at all -- the table would be asked about nobody. The table stands third because whom and what are legible by then, and permission is settled before anything is acted upon. The deed stands last because acting is the one stage that spends something, and only a well-formed, legible, permitted ask ever reaches it.

**The reach is run, never credited.** Eleven named asks run against eleven fresh benches, and the measurement is counted from what they actually earn. Crediting the table by proximity -- four green neighbors therefore eleven answers -- would have closed the agenda five rungs ago and proven nothing. Both truths stand side by side in the self-test, each counted rather than recited: the table alone answers **four**, and the table speaking through its neighbours answers **eleven**.

| Measured `20260821` | Value |
|---|---|
| Stages one ask reads through | **4** -- edge, message, table, deed |
| Refusals owned, one author each | **10**, plus success owned by no stage -- the eleven |
| Named asks the reach is measured from | **11**, each on its own fresh bench |
| Reach of the table alone | **4** of 11, unmoved -- `refusals.rye` was always right |
| Reach through its neighbors | **11** of 11 |
| Asks swept, both arms exercised | **5,184** -- 30 welcomed, 5,154 refused |

**The one overlap is published rather than hidden.** The deed may answer `seL4_FailedLookup` or `seL4_IllegalOperation`, which the table owns, because a derivation tree looks a capability up in a slot and narrows rights along a lineage exactly as the table looks a dependent up by label and narrows rights by mask. Two different lookups about two different things, giving one sentence. `stage_echoes` says so in code, and the self-test earns the echo rather than describing it.

**A refused ask spends nothing, one floor up.** Each neighbour already keeps that promise alone; the reply keeps it across all four stages -- an ask refused at the edge or at the table leaves the tree exactly as it was found, and a two-page carve leaves a one-page region whole. And the two lines stay apart here too: a carve of sixty-five is welcomed by the edge, because the kernel permits 256, and refused by the region's own named Rye error, because Caravan holds 64. The reply carries that error out as the region's own rather than dressing it as a kernel word.

**The agenda in `refusals.rye` is unmoved, and that is the point.** A rung that closed the agenda by editing the count would have closed nothing. Proven by [`tools/caravan_reply_witness.rish`](../tools/caravan_reply_witness.rish), GREEN on metal, with all three RED paths planted rather than described: a reversed reading order answers an ask by its last fault rather than its first, a collapsed seam gives one sentence for a resource never granted and a dependent never heard of, and a **muted table** -- the very fault this rung exists to fix, planted in reverse -- lets every ask walk through to the deed while the measured reach quietly falls from eleven to eight. A reach credited by proximity would not have noticed a thing.


## Fold N -- `reckon_the_plan`, and a closing sentence that had drifted while nobody counted it

The printed queue named the next fold, exactly as it is meant to. `reckon_the_plan` stood **byte for byte in thirty-seven rungs at seventy-five lines apiece -- 2,700 carried lines**, the largest family on the ladder from the moment `mend_the_plan` lifted out of the same thirty-seven. No lap had to guess, and no name had to catch anybody's eye.

`reckon_the_plan` is the body that publishes what a run came to, weighs the judgments standing on that run's own wire, and leaves the report holding exactly the loss a repair must answer. It moves into [`ladder_checks.rye`](ladder_checks.rye) whole, takes the rung as a comptime parameter, and reaches every symbol through it -- so each rung still reckons its own plan, against its own wire, into its own report.

**This fold cost no accessor at all.** Fold L needed a three-line `recanting_of` in `recant.rye` to bring its thirty-seventh rung in; here all eighteen symbols the body reaches already stood `pub` on all thirty-seven, verified before a line moved. That is what a ladder looks like after eleven folds have taught it to publish what it shares.

**Four elder rungs keep a body of their own** -- [`reckon.rye`](reckon.rye) at 27 lines, [`mend.rye`](mend.rye) at 35, [`bear.rye`](bear.rye) at 41, and [`appraise.rye`](appraise.rye) at 51. Each is the rung where a tier grew, and each body genuinely differs; sweeping them in would have folded four meanings into one. They stay home, and the meter keeps counting them apart.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 37 | **0**, each keeping a nine-line delegate |
| Lines the body carried | 2,700 | **324** -- the delegate is itself a copy |
| The ladder's whole carry | 137,185 | **134,809** |
| Carry ceiling | 137,300 | **135,000** |
| Lines on disk, all `caravan/*.rye` | 375,997 | **373,828** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**A fold shrinks a family to its call; it never erases it from the count.** The carry fell 2,376 rather than the 2,700 the queue named, and the difference is the nine-line delegate now standing byte-identical in thirty-seven rungs. Any lap expecting a folded family to vanish whole is reading the meter wrong, so the meter says so in its own header now.

### The red this fold walked into (REDS %110)

Re-pinning the carry meter meant reading its closing sentence, and the sentence was wrong. It had been closing every GREEN run reciting *"137,176 lines across 10,198 copied bodies of the 18,039 standing on it"* while its own assert, four lines earlier, pinned **137,185, 10,199, and 18,055** -- and the line above the close recited the same stale number again.

The meter had stayed GREEN straight through, because the guard [`REDS %108`](../construction/archive/REDS-caravan-meter-prose-rows-108-109.md) built refuses exactly one phrase: a number followed by the word `modules`. This meter drifted on lines, bodies, and copies instead. **A guard bounded by a vocabulary catches the incident, never the class.**

So the rule is bounded by a property now: **every number a ladder meter prints in a `say` line stands asserted in that same file**, thousands separators stripped, since `137,176` and `137185` are one claim in two costumes. A subject number is asserted and survives; a context number earns an assert or leaves the sentence. Two frozen controls hold the RED path under version control rather than pinned to `HEAD` ([`REDS %109`](../construction/archive/REDS-caravan-meter-prose-rows-108-109.md)'s lesson): the carry meter exactly as it shipped, and the elder spine meter, which the new rule refuses too -- on the number rather than on the noun. The second rule is strictly stronger than the first rather than merely beside it.

The rule proved itself on the way in twice over. Drawn first at the closing line alone, it was too narrow within the hour -- the line directly above the close carried the same stale number -- so it widened to every printed line. And its first pattern, an `(^|[^0-9])` alternation, matched nothing at all, because this shell's grep reads a `^` inside a group as a literal caret; the probe caught it by refusing a number the file plainly asserts. A guard that has never refused what it should welcome is a guard nobody has tested.

## Fold O -- `fill_table`, the largest family the arc has folded, and the queue that could only see two thirds of it

The printed queue named `fill_table` next: **thirty-seven rungs at sixty-nine lines apiece, 2,484 carried lines.** Reading past that answer before folding it is what made this the largest fold the arc has taken.

**Forty-three rungs held the body, and the six the queue left out differ by the word `pub` and nothing else** -- one line out of sixty-nine. The carry scan names a family by exact text, which is precisely what makes it trustworthy about collisions and precisely what blinds it here: `pub fn fill_table(` and `fn fill_table(` are two texts and one body. Fold M had already measured the true size, **2,898 lines across forty-three rungs**, and written it down beside the four spine bodies it widened for exactly this fold. The queue simply could not see it.

**So a fold queue is a lead, never a verdict.** It names where to look; the reading that follows says how much is actually there. That sentence now stands in the scan's own header, so the next lap inherits the caution rather than rediscovering it.

`fill_table` is the body that takes up every phase a run may start right now -- conferring the slots that are owed, admitting what the doors allow, and recording each turn, fence, mask, and precedence a pick stepped past on the way. It moves into [`ladder_checks.rye`](ladder_checks.rye) whole and reaches every symbol through the rung handed in, so each rung still fills its own table, against its own doors, into its own report. `mask.prefix_mask` and `mask.fence_after` stay module-level, since a mask is the same arithmetic for every rung rather than something a rung writes over its own report.

**The cost is 435 widenings** -- eleven bodies and one shape, one word each, across forty-three rungs, every one verified at column zero before a line moved. Five of them move the table (`advance_head`, `confer_slot`, `confer_one`, `choose_pass`, `start_one`), three weigh a pick (`door_admits`, `sibling_waits`, `elder_waits`), three reach the report (`run_of`, `masked_of`, `preceded_of`), and `Table` is the shape they all name. Every one of them leads a family still standing in the queue, so this fold prepared the next several the way fold M prepared this one.

One rung needed a line no other did: [`reclaim.rye`](reclaim.rye) had never imported the harness, being older than it. Nothing the harness imports reaches back to `reclaim`, so the import is safe, and its own witness proves it on metal.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 43 | **0**, each keeping a sixteen-line delegate |
| Lines the body carried | 2,829 as the meter counted it, 2,898 as one family | **656** -- the delegate is itself a copy |
| The ladder's whole carry | 134,809 | **132,589** |
| Carry ceiling | 135,000 | **132,700** |
| Lines on disk, all `caravan/*.rye` | 373,828 | **371,654** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Widening a symbol moves that symbol's own family too, and the arithmetic closes because of it.** A declaration line is part of the body it opens, so making `elder_waits` public in forty-three of the fifty-one rungs that hold it split one family of fifty-one into one of forty-three and one of eight -- and a split *lowers* the carry by one body, since the new family's first copy becomes a distinct text. Eleven such splits account for the 47 lines by which the measured fall, **2,220**, exceeds the 2,173 the fold's own family gave back. Nothing is unexplained, and none of it is estimated.

## Fold P -- `confer_slot`, and the first fold the arc has taken for free

The printed queue named `confer_slot` at **forty-three rungs by thirty-nine lines, 1,638 carried**, and this time the queue was exactly right. Hashing every `confer_slot` body on the ladder before folding it confirmed the count rather than correcting it: forty-three rungs hold one body byte for byte, and 39 x 42 is 1,638 precisely. The check is worth running either way -- a lead that agrees with the reading is still a lead that was read.

`confer_slot` answers which standing dependent could carry this phase, if any could. It matches the phase's domain against a live dependent's, weighs the hops the phase declares against the reach that dependent still holds in reserve, and walks every arc it would take, checking each for both name and write intent before it answers.

**Fold O prepared this fold entirely, and the cost shows it: zero widenings.** The five symbols this body reaches through the rung -- `hop_count`, `reserve_depth`, `Table`, `max_in_flight`, and the harness import itself -- were all made public across the same forty-three rungs one lap earlier, for `fill_table`. Not a single file needed a word changed before a line could move. **A fold pays its successors**, so the honest price of a widening is charged once and spent several times over; a lap reading only the widening count of the fold in front of it reads that price too high. That sentence now stands in the scan's own header beside the caution fold O left there.

`confer.reserve_arc_at`, `intent.declares_write`, and `cycle.max_hops` stay module-level, since a reserve's arcs, an arc's write intent, and the bound on how many hops one item may name are the same for every rung on the ladder.

**Two elder rungs keep their own copies, for reasons that are real rather than stylistic.** [`confer.rye`](confer.rye) *owns* `reserve_arc_at` and calls it unqualified where every folded rung reaches it through this module -- and folding it would ask the module this harness imports to import the harness back. [`revoke.rye`](revoke.rye) predates the in-flight invariant and states one assert fewer, so folding it would quietly add a check rather than move a body. Both differences are two lines, and both stay home named.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 43 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,638 | **126** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **0**, every symbol already public from fold O |
| The ladder's whole carry | 132,589 | **131,077** |
| Carry ceiling | 132,700 | **131,200** |
| Lines on disk, all `caravan/*.rye` | 371,654 | **370,181** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes exactly, with no remainder at all.** The family gave back 1,638 and the new three-line delegate family carries 126, so the carry falls 1,512 -- which is what the meter measured. Fold O's 47-line gap came from eleven family splits its widenings caused; a fold that widens nothing splits nothing, so this one leaves nothing to explain. On disk the same closure holds: forty-three rungs each shed thirty-six lines for 1,548, the harness took 75, and 370,181 is what remains.

## Fold Q -- `confer_one`, and the absentees that dated the family

The printed queue named `confer_one` at **forty rungs by fifty-three lines, 2,067 carried**, and hashing every body by that name on the ladder agreed exactly: forty rungs share one text byte for byte, and 53 x 39 is 2,067 precisely. Fold O taught that a queue is a lead rather than a verdict, so the reading runs either way -- and twice now it has confirmed what the meter printed rather than corrected it.

`confer_one` is the moment a supervised run stops starting things and starts *reusing* one. The phase's hops are added to what a standing dependent has already taken, the grown reach is offered to `entrust` for refusal, the words are written, the dependent is asked, and only an answer read back off the wire lets the table believe the reach was carried. Then the report counts it three ways, and the slot remembers which phase it absorbed -- so a later mend can name the arc it lost rather than re-running the plan whole.

**The five rungs that stand apart are the ladder's own fossil record.** Every one of them writes a body by this name, and every one differs in exactly one place: how deep it reaches into the report. Read in ladder order they climb a staircase.

| Rung | How it reaches the report | Depth |
|---|---|---|
| [`confer.rye`](confer.rye) | `report_out.conferred` | 0 |
| [`revoke.rye`](revoke.rye) | `report_out.inner.conferred` | 1 |
| [`reclaim.rye`](reclaim.rye) | `report_out.inner.inner.conferred` | 2 |
| [`abandon.rye`](abandon.rye) | `below_of(report_out).inner.inner.conferred` | accessor + 2 |
| [`reckon.rye`](reckon.rye) | `below_of(report_out).inner.inner.inner.conferred` | accessor + 3 |
| the forty above | `abandoning_of(report_out).inner.inner.inner.conferred` | accessor + 3 |

Two things settle on that staircase, one rung apart. At `abandon.rye` the ladder stops counting hops and **names** the reach through an accessor; at `reckon.rye` the depth settles at three and never moves again; and from `amend.rye` upward the accessor's own name settles too, as `abandoning_of`. After those settlings nothing about the reach is a per-rung fact -- which is precisely why the forty above are identical and the five below cannot be. **A family's absentees are worth reading, since they say when the shape it shares was born.**

The two eldest also predate whole lines rather than a depth. `confer.rye` and `revoke.rye` were written before a conferral granted, served, or pruned, so folding either would quietly add behavior rather than move a body. Both stay home named, as they did for fold P.

**The fold cost forty-three widenings**, and both are bodies a rung writes over its own report or its own wire: `revoke_one` made public in all forty, and `abandoning_of` in the three that still held it private. `entrust.entrust_refusal`, `entrust.Line`, and `confer.write_words` stay module-level, since a refusal's arithmetic and the words a conferral writes are the same for every rung on the ladder.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 40 | **0**, each keeping a twelve-line delegate |
| Lines the body carried | 2,067 | **468** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **43** (`revoke_one` x 40, `abandoning_of` x 3) |
| The ladder's whole carry | 131,077 | **129,478** |
| Carry ceiling | 131,200 | **129,600** |
| Lines on disk, all `caravan/*.rye` | 370,181 | **368,641** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** The family gave back 2,067 and the new twelve-line delegate family carries 468, so the carry falls 1,599 -- which is what the meter measured. On disk the same closure holds independently: forty rungs each shed forty-one lines for 1,640, the harness took 100, and 368,641 is what `wc` reports. **The forty-three widenings split no family, and measuring why is more interesting than the number.** Fold O's own gap came from splits -- a declaration line belongs to the body it opens, so making a symbol public in some holders and not others cuts one family in two. Here neither widened symbol could split. `revoke_one` stands in forty-four rungs as **five** families already, the folded forty sharing one body and the four elders each writing their own, so the whole family moved together. And `abandoning_of` stands in forty rungs as **forty** distinct bodies carrying nothing at all, since each names its own rung's report type -- widening three of them changed no family's membership. A widening is free of splits exactly when it moves a whole family or moves nothing, and this one did both.

## Fold R -- `weigh_the_term`, and the absentee a single accessor brought home

The printed queue named `weigh_the_term` at **thirty rungs by sixty-nine lines, 2,001 carried**, and hashing every body by that name on the ladder found a **thirty-first**. Fold O taught that a queue is a lead rather than a verdict; fold Q found five absentees a shape born later had dated out of the family. This lap found the other kind -- an absentee that could simply be invited in.

`weigh_the_term` is the run's answer to the question an objection leaves open: how long does a recorded disagreement stand? A perpetual term never asks, so nothing expires and nothing is counted. Every other term reaches the reader's own published box, puts the question there, reads it back before weighing a word of the answer, and refuses a second hand that names any other quarrel. Past that refusal a hand at all is the objection raised again, and silence is the objection let go -- called so only where somebody was actually asked.

**The thirty-first rung differed in six places, and every one of them was the same difference.** `lapse.rye` *owns* the lapsing tier, so it reached its own report directly where all thirty rungs above reach it through `lapsing_of`.

| Rung | How it reaches the report |
|---|---|
| [`lapse.rye`](lapse.rye) | `report_out.unbounded`, `.asked`, `.renewed`, `.lapsed` -- its own tier, reached directly |
| the thirty above | `lapsing_of(report_out).unbounded`, and the same three beside it |

A rung that owns a tier can name the reach anyway. Three lines of identity accessor -- `pub fn lapsing_of(report_out: *Report) *Report { return report_out; }` -- and its sixty-nine folded with the other thirty. Fold M learned this on `recant.rye` and fold J on the staircase, and it holds here for the third time. **So the reading to make about an absentee is which kind it is:** one dated by a shape born after it, which stays home named, or one a single accessor brings home.

**The fold cost twenty-two widenings, and fourteen of its sixteen symbols were already paid for.** Every helper this body names -- `escort_written`, `dispute_recorded`, `objection_unbounded`, `asked_in`, `address_published`, `ask_again`, `asked_of`, `renewed_by`, `renews`, `renewed_in`, `lapsed_in`, `unasked_lapse`, `lapse_refusal`, `lapse_note` -- along with `max_address_len` and the four types stood public in all thirty-one rungs already, widened by the folds before it. **A fold pays its successors**, and fold P's lesson reads truer each lap. Only `lapsing_of` needed widening, in the twenty-two rungs that still held it private.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 31 | **0**, each keeping a three-line delegate |
| Lines the body carried | 2,001 | **90** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **22** (`lapsing_of` x 22) |
| The ladder's whole carry | 129,478 | **127,567** |
| Carry ceiling | 129,600 | **127,600** |
| Lines on disk, tracked `caravan/*.rye` | 368,473 | **366,543** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 2,001 -- twenty-nine copies of sixty-nine lines, since `lapse.rye` was unique and carried nothing -- and the new three-line delegate family carries 90 across thirty copies, so the carry falls 1,911, which is what the meter measured. On disk the same closure holds independently: thirty rungs each shed sixty-six lines, `lapse.rye` shed sixty-six and gained thirteen for its accessor, the harness took a hundred and three, and 1,930 is the fall `wc` reports over the tracked rungs.

**The twenty-two widenings split no family and handed back nothing.** Fold Q measured why a widening can be free; this one is free for the simpler of the two reasons. Every one of the thirty `lapsing_of` bodies is a **distinct text**, since each names its own rung's report type, so the family carried zero lines before the widening and carries zero after. A widening that moves a whole family or moves nothing cannot split one, and thirty singletons are thirty nothings.

## Fold S -- `record_the_dispute`, and the second tier-owner an accessor brought home

The printed queue named `record_the_dispute` at **thirty-two rungs by sixty-one lines, 1,891 carried**, and hashing every body by that name on the ladder found a **thirty-third**. That is three consecutive laps where reading past the queue paid, and this one paid the same way fold R did -- an absentee that could simply be invited in.

`record_the_dispute` is the run's answer to what a reader's objection earns. A run that carried nothing owes nobody a record, and says so by weighing nothing rather than by inventing a quarrel. A reader who agreed is left exactly as the rung below leaves them, agreed with and undisputed. Only a reader who answered in a word this plan cannot accept is written down -- and under `.settled` even that one is set aside, which is precisely the number this rung moves. Its hard half refuses a pair naming one reading twice: that is agreement wearing a quarrel's clothes, and writing it down would manufacture a disagreement nobody ever had.

**The thirty-third rung differed in five places, and every one of them was the same difference.** `dispute.rye` *owns* the disputing tier, so it reached its own report directly where all thirty-two rungs above reach it through `disputing_of`.

| Rung | How it reaches the report |
|---|---|
| [`dispute.rye`](dispute.rye) | `report_out.unrecorded` and `.recorded` -- its own tier, reached directly |
| the thirty-two above | `disputing_of(report_out).unrecorded`, and `.recorded` beside it |

Three lines of identity accessor -- `pub fn disputing_of(report_out: *Report) *Report { return report_out; }` -- and its sixty-one folded with the other thirty-two. **Fold R read this shape for the first time one lap ago, and fold S found it again immediately.** So a tier-owner standing outside its own family is no longer a surprise to stumble on; it is a shape to look for, every time a family is hashed before it is folded.

**The fold cost forty-nine widenings, and fourteen of its sixteen symbols were already paid for.** Every helper this body names -- `address_published`, `answered_by`, `delivered_to`, `hand_agrees`, `answered_unrecorded`, `recorded_in`, `unwritten_in`, `unheard_record`, `dispute_refusal`, `founded`, `dispute_note` -- along with `max_address_len` and the types stood public in all thirty-three rungs already, widened by the folds before it. Only the two accessors needed widening: `couriering_of` in twenty-five rungs and `disputing_of` in twenty-four. Every one of their bodies is a distinct text, since each reaches a different depth, so the widening split no family and handed back no carry.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 33 | **0**, each keeping an eight-line delegate |
| Lines the body carried | 1,891 | **256** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **49** (`couriering_of` x 25, `disputing_of` x 24) |
| The ladder's whole carry | 127,567 | **125,932** |
| Carry ceiling | 127,600 | **126,000** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 1,891 -- thirty-one copies of sixty-one lines, since `dispute.rye` stood distinct and carried nothing -- and the new eight-line delegate family carries 256 across thirty-two copies, so the carry falls 1,635, which is what the meter measured. On disk the same closure holds independently: thirty-two rungs each shed fifty-three lines for 1,696, `dispute.rye` shed fifty-three and gained ten for its accessor, `ladder_checks.rye` took ninety-one, and 1,648 is the net fall over the real rung files.

A naive count of tracked lines reads 366,543 -> 365,063, a fall of 1,480, and the 168-line gap has a name rather than a mystery: `caravan/parse_int.rye` and `caravan/tally_copy.rye` are tracked symlinks whose target text `wc` follows and `git show` does not. Naming the artifact is what keeps a discrepancy from becoming a drift.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold T -- `graft_promised_reach`, and the fold that had to widen a family whole

The printed queue named `graft_promised_reach` at **forty-two rungs by forty-three lines, 1,763 carried**, and hashing every body by that name found exactly **forty-two** -- one text, no absentee, no tier-owner standing apart. Three consecutive laps had each turned up a rung the queue's line count could not see, and this lap turned up none. That is the same discipline reporting a clean family rather than a discipline that quietly stopped paying: the hash runs whether or not it finds anything.

`graft_promised_reach` is the body that takes a promise off the wire and turns it into reach a dependent actually holds. A promise is a number and nothing more; the reach itself arrives as words the dependent must read, name, hold, and then stand up against its own store before any of it counts. So the body waits inside a bound rather than forever, reads only what has actually been given, grants only what it does not already hold, and proves each arc it took stands at the count the task names. A word that cannot be read back into a capability ends the graft by name rather than carrying quietly less than it claims.

It is also the body that the arc's second-largest fold already calls. `stand_taking_and_returning_reach` lifted into the harness at fold L and reaches `rung.graft_promised_reach` on its sixth line; this lap the callee joined the caller there.

**The fold cost 285 widenings, and the reason is the whole lesson of the lap.** Six symbols needed widening -- `read_count`, `read_words`, `word_at`, `already_holds`, and the two imports `queue_store` and `serve`. Four of those six are fold families in their own right, standing in **forty-five** rungs apiece where this body stands in forty-two. The carry meter reads a body by its exact text, so widening the forty-two and leaving three private would have split each of those families in two, and handed a later fold a family it could no longer lift whole.

| Symbol | Stands in | Widened in | Why |
|---|---|---|---|
| `word_at` | 45 rungs, one text | **45** | a whole family, kept whole |
| `read_count` | 45 rungs, two texts | **45** | both sub-families kept whole |
| `read_words` | 45 rungs, two texts | **45** | the same shape |
| `already_holds` | 45 rungs, two texts | **45** | the same shape |
| `queue_store` | 47 rungs | **47** | an import, carrying no family |
| `serve` | 58 rungs | **58** | an import, carrying no family |

**A fold pays its successors, and it pays them best by never handing them a split.** Fold P found five of five symbols already public and cost nothing at all, because fold O had widened exactly those five one lap earlier. This lap is that ledger read from the other side: the cheapest thing fold T can do for the folds after it is to widen past its own family's edge, where the symbol's family is wider than the body's.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 42 | **0**, each keeping an eleven-line delegate |
| Lines the body carried | 1,763 | **451** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **285** across six symbols |
| The ladder's whole carry | 125,932 | **124,620** |
| Carry ceiling | 126,000 | **124,700** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 1,763 -- forty-one copies of forty-three lines, the forty-second being the distinct text itself -- and the new eleven-line delegate family carries 451 across those same forty-one copies, so the carry falls 1,312, which is what the meter measured. On disk the closure holds independently: forty-two rungs each shed thirty-two lines for 1,344, `ladder_checks.rye` took seventy-four, and **1,270** is the net fall over the real rung files. A naive count of tracked lines reads 1,102, and the 168-line gap keeps the name fold S gave it -- `caravan/parse_int.rye` and `caravan/tally_copy.rye` are tracked symlinks whose target text `wc` follows and `git show` does not.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold U -- `hear_the_reader`, and the absentee that stays home

The printed queue named `hear_the_reader` at **thirty-three rungs by fifty-four lines, 1,728 carried**, second behind `provision_notes`, and it was the better crux for the same reason the last four laps chose the wider family: `provision_notes` at ninety-one lines stays the body most likely to reach a rung's own wire, and reaching the wire is what keeps a body home.

Hashing every body by that name found **thirty-four**, and the thirty-fourth is the finding. `caravan/hear.rye` owns the hearing tier, and its body stands at forty lines against fifty-four -- yet no accessor brings this one home. Fold R named two kinds of absentee, and this is the **first**: a body genuinely dated by a shape born after it. Where every rung above records a disagreeing hand as a non-agreement and carries on, `hear.rye` ends the run on it with `error.HearMisheard`. Two texts, two meanings, one name. The elder stays home, named in the harness for what it is, rather than folded into a shape it predates.

`hear_the_reader` is the body that reads back what the reader answered and says whether the plan ever listened. It reads the letter it carried out of the reader's own box, then reads that reader's hand out of the box beside it -- the wire before the memory, because a plan that heard its reader agree from its own memory has agreed with itself. A run that carried nothing owes nobody a hearing. A reader who answered in a word this plan cannot accept leaves the hearing exactly where it stood, and that is a record rather than a refusal.

**The fold cost one widened symbol, and it split nothing.** Every symbol the body reaches -- `couriering_of`, `max_address_len`, `address_published`, `answered_by`, `delivered_to`, `hand_agrees`, `carried_unheard`, `heard_in`, `unheard_in`, `unanswered_reach`, `hear_refusal`, and the four types `Receipt`, `Report`, `RunError`, `NoteError` -- already stood public in all thirty-three, the interest paid by folds before it. Only `hearing_of` was private, and fold T's lesson said to hash that symbol's own family before widening it. Its thirty-three copies are each a **different** text, three lines naming a different nesting depth apiece, so it is no fold family at all: widening it costs its thirty-three and hands no successor a split.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 33 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,728 | **96** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **33**, one accessor, no family split |
| Bodies standing apart, kept home | -- | **1**, `hear.rye`, named in the harness |
| The ladder's whole carry | 124,620 | **122,988** |
| Carry ceiling | 124,700 | **123,100** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** The family gave back 1,728 -- thirty-two copies of fifty-four lines, the thirty-third being the distinct text itself -- and the new three-line delegate family carries 96 across those same thirty-two copies, so the carry falls **1,632**, which is exactly what the meter measured. Bodies climb 18,064 to 18,065 and distinct texts 7,867 to 7,868, the one new body being the harness's own.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold V -- `settle_the_plan`, the fossil record, and a fold that cost nothing

The printed queue named `settle_the_plan` at **thirty-six rungs by forty-seven lines, 1,645 carried**, second behind `provision_notes`, and the last two laps had already named it the better crux for the reason five laps running have chosen the wider family: `provision_notes` at ninety-one lines stays the body most likely to reach a rung's own wire, and reaching the wire is what keeps a body home.

`settle_the_plan` weighs what a plan came to, publishes the verdict and the settlement, and reads both back. The reckoning waits until the last dependent has been reaped and every abandonment already answered for, since a verdict taken any earlier would judge work that may yet be carried. Every claim it makes it first writes to the wire and then reads back, because a settlement a run believes from its own memory has agreed with itself. Four refusals stand in it, each naming a story the wire cannot support: a loss called carried while an arc stands unserved, a plan called borne that re-ran what its author asked it to bear, a judgment weighed in private, and a recantation never spoken aloud.

**Hashing the family first found three bodies standing apart, and they are not the same kind.** `caravan/recant.rye` owns the recanting tier and stood apart by exactly two lines, reaching its own report directly where every rung above reaches it through `recanting_of`. That is fold R's **second** kind of absentee, and this time the accessor that brings it home had already been born -- fold M widened `recanting_of` in this very file, five folds ago. Two words came home and the family became thirty-seven.

**Two more stand apart, and they stay home: they are the ladder's own fossil record.** `caravan/bear.rye` holds twenty-eight lines and `caravan/appraise.rye` thirty-five, against the folded body's forty-seven. `bear.rye` predates the appraisal check and the recantation checks alike; `appraise.rye` carries the appraisal and predates the recantation. Read together, the three depths are a staircase naming the two laps on which settling learned to weigh an appraisal and then a recantation -- fold Q's finding, arriving again on a different body.

**An absentee can wear both kinds at once, and the first kind wins.** Each of these two elders also reaches its own report directly, exactly as `recant.rye` did -- `report_out.bore` in one, `report_out.weighed` in the other -- so each carries the second kind's signature too. Yet no accessor can give a body back a check it never had. Where the two kinds meet in one body, the dating decides, and the elder stays home named.

**The fold cost nothing at all.** All thirteen symbols the body reaches -- `below_of`, `unserved_after`, `settled_verdict`, `verdict_note`, `verdict_published`, `settlement_of`, `bearing_of`, `settlement_note`, `settlement_published`, `appraising_of`, `appraisal_published`, `recanting_of`, `recant_published` -- along with `max_queue_len` and the three types `Report`, `RunError`, `NoteError`, already stood public in every one of the thirty-seven. This is the arc's second zero-widening fold after fold P, and it says the same thing from the other side: **a fold's price is set by what its predecessors already made public**, rather than by how many rungs it lifts out of.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 36, and a thirty-seventh two lines apart | **0**, each keeping an eight-line delegate |
| Lines the body carried | 1,645 | **288** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **0**, every symbol already public |
| Absentees an accessor brought home | -- | **1**, `recant.rye`, for two words |
| Bodies standing apart, kept home | -- | **2**, `bear.rye` and `appraise.rye`, named in the harness |
| The ladder's whole carry | 122,988 | **121,631** |
| Carry ceiling | 123,100 | **121,700** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder, and it names what bringing an absentee home costs.** Thirty-five copies of forty-seven gave back 1,645 as the queue promised; `recant.rye` joining first *added* forty-seven to the carry, making thirty-six copies at 1,692; and the thirty-six eight-line delegates carry 288. So the fall is 1,692 less 288, less the forty-seven that came home -- **1,357**, exactly what the meter measured. **The accessor's two words paid for themselves thirty-six times over.** Bodies climb 18,065 to 18,066 and copies 10,197 to 10,198, the one new body being the harness's own; distinct texts hold at 7,868, since the body the harness now owns is a text the ladder already had.

On disk the thirty-seven rung files shed 1,480 lines for 37 of delegate, and `ladder_checks.rye` grew 88 -- a net of **1,355 lines** off the tracked tree.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold W -- `provision_notes`, the largest carry on the ladder, and a fossil record thirteen laps deep

The printed queue had named `provision_notes` at the top for five consecutive laps -- **twenty-four rungs by ninety-one lines, 2,093 carried**, the largest single carry the arc has ever measured -- and five consecutive laps had reached past it for the family standing second. The reason was always the same one, and it was a good one: at ninety-one lines this is the body most likely to reach a rung's own wire from end to end, and reaching the wire is what keeps a body home. This lap it was the crux by every reading, and it folded.

`provision_notes` seats one set of notes per declared domain, all standing at nothing, so a word a dependent finds at its first breath was left by this run's own supervisor rather than by the last. **The judgment it carries is what clears and what stays.** A run clears every note that answers for the run that wrote it -- the verdict, the bearing, the settlement, the recantation, the amendment, the disagreement, the plea. A run leaves standing every note that belongs to somebody else: the appraisal a run did not make, the reading a reader already holds, the position a person pressed, and the age that position has stood. Six invariants close the body by asking the wire whether each cleared note is genuinely gone, since a provisioning that believed itself would have agreed with itself.

**It reaches the wire, and option B is exactly the answer to that.** The body opens the rung's own note directory and writes under the rung's own plan name, both reached through the rung handed in, so one text provisions whichever rung called it. The wire stays the rung's; the words become the ladder's. That is the whole promise the harness made when it was built, arriving here on the body that most needed it.

**Hashing the family found forty-seven rungs where the queue named twenty-four, and the twenty-three are a fossil record thirteen laps deep.** Every elder is a strict truncation of the canonical -- shorter by whole notes and whole invariants, never by a different reach -- and they stand at thirteen distinct depths:

| Lines | Rungs | What the ladder had learned by then |
|---|---|---|
| 14 | `entrust` - `taper` | a pair of notes per domain, and nothing said of the plan |
| 16 | `confer` | the conferral notes |
| 19 | `revoke` | revocation beside conferral |
| 24 | `reclaim` | reclaiming, and the words a dependent is handed |
| 26 | `abandon` | abandonment counted |
| 31 | `mend` - `reckon` | the plan's own verdict, cleared with the rest |
| 38 | `appraise` - `bear` | the bearing and the settlement beside the verdict |
| 46 | `recant` | the recantation clears, the appraisal stays |
| 56 | `amend` - `courier` - `hear` | the amendment clears, the reading stays |
| 63 | `abide` - `dispute` - `lapse` - `repose` - `tidings` | the recorded disagreement clears |
| 70 | `appeal` | the published plea clears |
| 78 | `endure` | the standing position stays, and the regard clears with the findings |
| 86 | `heed` - `relent` | the age stays beside the position it counts |
| **91** | **the twenty-four** | every invariant asked of the wire |

Read down that column and it is the arc's own memory of which note it had learned to provision on which lap, and of the judgment each new note arrived carrying. **None of them can be brought home, and the reason is fold V's rule read once more: no accessor gives a body back a check it never had.** They are fold R's first kind, twenty-three times over.

**So the reading a large absentee set asks for is its shape.** One depth means one shape born later; thirteen depths mean thirteen laps of growth standing on disk in order. Both stay home, and for the same reason -- yet only the second tells you the family's whole history at a glance, which is worth more than the lines it costs.

**The fold cost thirty widenings, and it split nothing.** Nine of the ten symbols the body reaches -- `note_dir`, `plan_name`, and the six accessors `verdict_published`, `settlement_published`, `amend_published`, `dispute_recorded`, `appeal_published`, `regard_published`, along with the `NoteError` type -- already stood public in all twenty-four, interest paid by the folds before this one. Only `seat_note` needed widening, and fold T's rule governed how: the private text stood in **twenty-six** rungs where this body stands in twenty-four, so widening only the twenty-four would have split that family and handed a later fold something it could no longer lift whole. All thirty private `seat_note` bodies were widened instead -- the twenty-six-rung text and two small two-rung texts beside it -- which **merged** the widened twenty-six with the seventeen already public into a single forty-three-rung family. The merge costs fifteen carried lines today and hands the next fold one family rather than two.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 24 | **0**, each keeping a three-line delegate |
| Lines the body carried | 2,093 | **69** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **30**, one family widened whole |
| Bodies standing apart, kept home | -- | **23**, at thirteen distinct depths |
| The ladder's whole carry | 121,631 | **119,622** |
| Carry ceiling | 121,700 | **119,700** |
| Carrying families | 708 | **707**, the `seat_note` merge |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Twenty-three copies of ninety-one gave back 2,093 exactly as the queue promised; the twenty-four three-line delegates carry 69; and the `seat_note` merge added 15 by turning a distinct text into a copy. So the fall is 2,093 less 69 less 15 -- **2,009**, exactly what the meter measured. Bodies climb 18,066 to 18,067 and copies 10,198 to 10,199, the one new body being the harness's own; distinct texts hold at 7,868, since the harness's text is one the ladder already had.

On disk the twenty-four rung files shed 2,112 lines for 72 of delegate, and `ladder_checks.rye` grew 114 -- a net of **1,998 lines** off the tracked tree.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold X -- `release_the_standing`, and the family that folded whole

The queue named **twenty-four rungs by seventy-one lines, 1,633 carried**, and hashing every body by that name found a **twenty-fifth**. That is the second kind of absentee, read now for the fourth time: `relent.rye` **owns** the relenting tier, so it reached its own report directly where all twenty-four rungs above reach it through `relent_of`. Ten lines differed out of seventy-one, and every one of them was the same difference. Three lines of identity accessor, and the family folded **whole at twenty-five, with no elder left home** -- the first fold of this arc to leave nothing standing apart.

`release_the_standing` is the run's answer to what a person's pressed quarrel is worth. A quarrel is a living statement that the matter is not over, so the body reads the wire before it believes anything: the note that stands, the endurance that would have written it, the box its holder published, and the hand that box actually carries. **A holding run clears nothing, however plainly its holder moved on. Silence is never read as a withdrawal. A position whose holder cannot be reached stands rightly until they can be.** Only a reader who actually let go gets their position taken down.

**The wire before the memory, at both ends.** The note is read back after the release, and only a wire reading clear lets the report say the position came down -- because a note still naming a quarrel after its holder let it go hands every future run an objection nobody holds. The rung refuses that by name with `error.RelentMisrecorded` rather than trusting its own release.

**The fold cost sixteen widenings and split nothing.** Thirteen of the fourteen symbols the body reaches -- `position_standing`, `endures`, `address_published`, `pressed_by`, `withdrawn_still_standing`, `withdrawn_in`, `standing_in`, `withdraws`, `unwithdrawn_clearing`, `relent_refusal`, `release_standing`, `note_cleared`, and the `max_address_len` bound, with `Relent`, `Report`, `RunError`, and `NoteError` beside them -- already stood public in all twenty-five, interest paid by the folds before this one. Only `relent_of` needed it, and its whole family is exactly the twenty-four rungs this body stands in, so fold T's rule had nothing left to protect: widening the sixteen private bodies covered the family entire, and each of the twenty-four is a distinct text naming its own nesting depth, so the widening handed back nothing and split nothing.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 25 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,633 | **72** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **16**, plus one accessor born |
| Bodies standing apart, kept home | -- | **0**, the arc's first whole family |
| The ladder's whole carry | 119,622 | **118,061** |
| Carry ceiling | 119,700 | **118,100** |
| Carrying families | 707 | **707**, unmoved |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Twenty-four copies of seventy-one gave back 1,633 exactly as the queue promised; `relent.rye` joining first *added* seventy-one, making twenty-five copies at 1,704; and the twenty-five three-line delegates carry 72. So the fall is 1,704 less 72 less the seventy-one that came home -- **1,561**, exactly what the meter measured. Bodies climb 18,067 to 18,069 and copies 10,199 to 10,200; distinct texts climb 7,868 to 7,869, the newborn identity accessor being a text the ladder did not have.

On disk the twenty-five rung files and the harness together shed **1,741 lines for 149 added** -- a net of **1,592 lines** off the tracked tree.

**What this fold adds to the reading of an absentee.** Folds R, S, and V each brought one second-kind absentee home and left first-kind elders standing; fold W left twenty-three. This one left none, and the reason is measurable rather than remembered: `release_the_standing` exists **only** in the relenting tier and above. Every rung below it -- `heed`, `endure`, `appeal`, `repose` among them -- carries no body by that name at all, so there was never a shallower version to date this one out of its family. **A family with no fossil record is a family born whole**, arriving after the vocabulary beneath it had already settled, and the hash says so at a glance without anybody having to remember which lap wrote what.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold Y -- `stand_the_mark`, and the second family to fold whole

The queue named **twenty-nine rungs by fifty-eight lines, 1,624 carried**, and hashing every body by that name found a **thirtieth**. That is the second kind of absentee, read now for the fifth time: `repose.rye` **owns** the reposing tier, so it reached its own report directly where all twenty-nine rungs above reach it through `reposing_of`. Seven lines differed out of fifty-eight, and every one of them was that same difference. Three lines of identity accessor, and the family folded **whole at thirty, with no elder left home** -- the second fold of this arc to leave nothing standing apart, and the first time the arc has done it twice running.

`stand_the_mark` carries the term's own answer into the mark an operator actually opens. The wire before the memory, one tier further out than the term below it: the run reads its own mark out of the note an operator would open, reads the term out of the note that decided it, writes both into that same mark, and reads the mark back before the report believes a word of it. **A run that escorted nothing has no mark to speak for. An objection nobody asked about has no standing to carry.** Each is a silence no standing can fill, and each says so by weighing nothing rather than by inventing a finding. The number this rung moves is the mark that names an objection and never says whether anybody still holds it -- read live by every operator, however long ago the quarrel was let go.

**The fold cost twenty-one widenings and split nothing.** Fifteen of the sixteen symbols the body reaches -- `escort_written`, `term_written`, `mark_unstanding`, `read_in`, `bare_in`, `unweighed_stand`, `repose_refusal`, `stands_as`, `agrees`, `repose_note`, and `standing_written`, with `Mark`, `Report`, `RunError`, and `NoteError` beside them -- already stood public in all thirty, interest paid by the folds before this one. Only `reposing_of` needed it, and its whole family is exactly the twenty-nine rungs above the tier owner, so fold T's rule had nothing left to protect: widening the twenty-one private bodies covered the family entire, and each of the twenty-nine is a distinct text naming its own nesting depth, so the widening handed back nothing and split nothing.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 30 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,624 | **87** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **21**, plus one accessor born |
| Bodies standing apart, kept home | -- | **0**, the arc's second whole family |
| The ladder's whole carry | 118,061 | **116,524** |
| Carry ceiling | 118,100 | **116,600** |
| Carrying families | 707 | **707**, unmoved |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder, and it closes the same from either end.** Read forward: twenty-eight copies of fifty-eight gave back 1,624 exactly as the queue promised, and the thirty three-line delegates carry 87, so the fall is 1,624 less 87 -- **1,537**, exactly what the meter measured. Read through the normalization: `repose.rye` joining first made thirty copies at 1,682, which the fold gave back whole, and 1,682 less 87 less the fifty-eight that came home is the same 1,537. The tier owner's own body was never carried and never counted, which is why the two readings agree. Bodies climb 18,069 to 18,071 and distinct texts 7,869 to 7,870, the newborn identity accessor and the harness body being texts the ladder did not have.

On disk the thirty rung files and the harness together shed **1,701 lines for 148 added** -- a net of **1,553 lines** off the tracked tree. The diff is smaller than thirty times fifty-eight because a delegate keeps the body's own signature line and its closing brace, so each rung reads as fifty-six lines out and one in, with the twenty-one widenings making up the rest exactly.

**What this fold adds to the reading of a whole family.** Fold X met the first family with no fossil record and drew the rule from it: a body that arrived after the vocabulary beneath it had settled has no shallower version to date it out of its family. `stand_the_mark` says the same thing from the other side. It exists only in the reposing tier and above -- `heed`, `endure`, `appeal`, and `relent` carry no body by that name -- and the hash found its whole family at a glance, with the tier owner standing apart by exactly the difference owning a tier makes. **A rule read once is a reading; a rule that predicts the next lap is a rule.** This fold is that second reading, and it came in on the discipline rather than on a surprise.


## Fold Z -- the reap cluster, and the split that was only a word

The queue named **thirty-seven rungs by forty-four lines, 1,584 carried**, and hashing every `reap_oldest` on the ladder found **forty**. Three of them -- `appraise.rye`, `bear.rye`, and `mend.rye` -- held the body byte for byte and differed by the single word `pub`. That is the **third kind of absentee**, and it is the gentlest one the arc has met: no shallower ancestor, no tier owner reaching its own report directly, simply a family that a meter keyed on text read as two because one word of visibility stood between them.

Then the pub-ness audit turned the lap into something larger. `reap_oldest` reaches two private helpers, `reclaim_one` and `abandon_one`, so the fold could not happen without widening them -- and hashing *those* found each standing byte-identical in **the same forty rungs**, over the same three elder outsiders, `reclaim.rye`, `reckon.rye`, and `abandon.rye`. One body, two helpers, one cohort, one shared fossil record. **The widening a fold needs names the next fold**, because a body and the helpers it reaches enter the ladder together and settle together; the reach graph *is* the queue, read one step ahead of the meter.

So this lap lifted the cluster whole rather than the family alone. `reap_oldest` waits on the eldest dependent, takes back what it was conferred, answers for the work that conferral never bought, and closes the table over its slot. `reclaim_one` is the smallest of the three and the one the other two are built over. `abandon_one` names lost work only where there is lost work to name, writes it where an operator would read it, and reads it straight back off the wire before believing it. An heir found at home refuses the whole reaping rather than reporting around it, since a dependent whose children outlive it was never reaped at all.

**The fold cost eighty-three widenings and split nothing.** Every symbol the three bodies reach -- `Table`, `Answer`, `Report`, `RunError`, `NoteError`, `max_queue_len`, `max_in_flight`, `inherited_by`, `abandoning_of`, `run_of`, `read_count`, `reclaim_refusal`, `reclaim_notes`, `abandon_refusal`, `abandoned_reach`, `abandon_note`, and `abandoned_by` -- already stood public in all forty, interest paid by the folds before this one. Only the two helpers needed widening, at forty each, with three `reap_oldest` declarations joining them; and since each helper's family is exactly this cohort, fold T's rule had nothing left to protect.

| Row | Before | After |
|---|---|---|
| Rungs holding `reap_oldest` | 40 | **0**, each keeping an eight-line delegate |
| Rungs holding `abandon_one` | 40 | **0**, each keeping a nine-line delegate |
| Rungs holding `reclaim_one` | 40 | **0**, each keeping an eight-line delegate |
| Lines the cluster carried | 3,310 | **975** -- the delegates are themselves copies |
| Widenings the fold cost | -- | **83**, no accessor needed |
| The ladder's whole carry | 116,524 | **114,189** |
| Carry ceiling | 116,600 | **114,200** |
| Carrying families | 707 | **706** -- four families in, three out |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Four families went in: `reap_oldest` at thirty-seven copies of forty-four (1,584) and at three more (88), `abandon_one` at thirty-nine copies of twenty-six (1,014), `reclaim_one` at thirty-nine copies of sixteen (624) -- **3,310** together. Three families came out, one per delegate, at thirty-nine copies of eight, nine, and eight -- **975**. The fall is **2,335**, exactly what the meter measured. Bodies climb 18,071 to 18,074 and distinct texts 7,870 to 7,872: three harness bodies and three delegate texts born, four old texts retired. On disk the forty rung files, the harness, and the meter shed **2,653 lines for 335 added** -- a net of **2,318** off the tracked tree.

**Why the family count fell for the first time in this arc.** Every fold before it traded one carrying family for another and left the count unmoved. This one traded four for three, because the visibility split was healed by the same act that lifted the body: forty delegates, all public, all one text. A meter that counts what it can see was seeing a difference the ladder never had, and the fold gave it back the truth rather than an exception. **The clearest way to fix a measurement is to remove the thing that made it wrong.**


## Fold AA -- `post_the_amendment`, and the tier owner that needed nothing built

The queue named **thirty-five rungs by forty-five lines, 1,530 carried**, and hashing every `post_the_amendment` on the ladder found **thirty-six**. The thirty-sixth is `amend.rye`, and it differs in exactly the way this arc has learned to expect: where the cohort reaches its report through `amending_of(report_out)`, the tier owner reaches `report_out` directly, because the amending report *is* its report and it has no accessor at all. That is the **second kind of absentee**, met again and recognized on sight.

What made this the cheapest fold the arc has taken is what the pub-ness audit found. Fifteen symbols the body reaches -- `settlement_published`, `reading_published`, `superseded_unposted`, `amended_in`, `confirmed_in`, `unread_reach`, `amend_refusal`, `amend_note`, `seat_note`, `plan_name`, `amend_published`, and the four types `Notice`, `Report`, `RunError`, and `NoteError` -- already stood public in all thirty-five, interest paid in full by the folds before this one. **One symbol needed widening: `amending_of`, private in twenty-seven rungs and already public in eight.** Hashing that accessor across the cohort found thirty-five distinct texts, one per rung, each a different depth of `.inner` -- so it is an identity accessor by construction and folds nowhere, exactly as fold R's rule predicts. The reach graph named the price a lap ahead, and the price was one word.

What the body does is the arc's correspondence half, stated once. A run measures the readings its own settlement contradicts, weighed against what it settled rather than against what any notice asked for, so an elder reading is counted rather than refused. It refuses by name where an amendment would reach a reading nobody took. It writes the note, clears the reading off the wire in the same breath it is answered, and then reads the posting back out of the place an operator would open before letting its report believe it -- the wire before the memory, once more.

| Row | Before | After |
|---|---|---|
| Rungs holding `post_the_amendment` | 35 | **0**, each keeping a three-line delegate |
| Lines the family carried | 1,530 | **102** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **27**, one word, no accessor born |
| The ladder's whole carry | 114,189 | **112,761** |
| Carry ceiling | 114,200 | **112,800** |
| Carrying families | 706 | **706**, one family out and one back in |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Thirty-four copies of forty-five went in at **1,530**; thirty-four copies of three came back out at **102**; the fall is **1,428**, exactly what the meter measured. Bodies climb 18,074 to 18,075 and distinct texts 7,872 to 7,873 -- one harness body born, one delegate text born, one old text retired. On disk thirty-five rung files, the harness, and the meter shed **1,540 lines for 133 added**, a net of **1,407** off the tracked tree.

**The lesson this lap adds is about price rather than shape.** Twenty-six folds in, a family of thirty-five reached fifteen symbols and found every one of them already public. A fold pays its widenings once, and every fold after it inherits them; the ladder is now mostly paid, so the folds ahead are mostly free. What still costs is the reading -- hashing the family, auditing the reach, naming the absentee -- and that reading has never once been wasted.


## Fold AB -- the dependent cluster, and the absentee that stands below the line

The queue named **forty-three rungs by thirty-five lines, 1,470 carried**, and hashing every `run_dependent` on the ladder found sixty-seven bodies at eleven different lengths. Forty-three stand byte for byte alike; the other twenty-four are the arc's own memory of the walk growing. Fold Z's rule ran first this time, before scope was chosen: read the reach closure, since the helpers a body reaches are often its own cohort and fold with it for the price of one audit. They were, and they did.

`run_dependent` reaches six symbols on its rung. Three already stood public in all forty-three -- `fixed_argv_words`, `inherited`, and `outcome_name`. Of the three that did not, one was already a delegate from fold L (`stand_taking_and_returning_reach`, needing only the word `pub`), and **two were real bodies that fold with it**: `inherited_at_first_breath`, standing byte for byte in exactly the same forty-three rungs at thirty lines apiece, and `slot_from_argv`, standing byte for byte in **fifty-nine**. So one reading bought three folds.

**The fifty-nine named a third kind of absentee.** The sixteen rungs holding `slot_from_argv` outside the cohort are precisely the rungs the harness itself imports -- `cohort`, `cycle`, `confer`, `entrust`, `gap`, and the rest beneath the fold line. Folding them would have a rung the harness reaches for reach back through the harness, which inverts the ladder rather than lifting it. So the fold line is not the widest family; it is the widest family standing **above** the harness. The arc has now met an absentee dated by a shape born later, an absentee a single accessor brings home, and an absentee that stays home because of where it stands in the import order.

What the body does is the whole dependent half of the arc, stated once. A dependent reads the plan it was handed, defers to the rung below for any verb this rung does not own, refuses an unreadable or over-wide capability count by name, rebuilds its own hands from the words on its argv line, counts the reach it inherited at its first breath **before** touching those hands, answers for that finding on the wire, and only then stands.

| Row | Before | After |
|---|---|---|
| Rungs holding `run_dependent` | 43 | **0**, each keeping a three-line delegate |
| Rungs holding `inherited_at_first_breath` | 43 | **0**, each keeping a seven-line delegate |
| Rungs holding `slot_from_argv` above the line | 43 | **0**; the sixteen below it keep their body |
| Lines the three families carried | 3,600 | **771** |
| Widenings the fold cost | -- | **130**, one word each, no accessor born |
| The ladder's whole carry | 112,761 | **109,932** |
| Carry ceiling | 112,800 | **110,000** |
| Carrying families | 706 | **706** |

**The arithmetic closes with no remainder.** Out went 42x35, 42x30, and 58x15 -- 1,470 plus 1,260 plus 870, or **3,600**. Back came 42x3, 42x7, 42x3, and the sixteen rungs below the line at 15x15 -- 126 plus 294 plus 126 plus 225, or **771**. The fall is **2,829**, exactly what the meter measured, and the largest single fall this arc has taken.

**Carrying families held at 706 for a reason worth naming.** `slot_from_argv` split into two families, its delegates above the line and its bodies below -- one family gained. In the same act, widening `reachable_between` in `reclaim.rye` healed a two-rung private family into the forty-two-rung public one, leaving a singleton that carries nothing -- one family lost. Fold Z's split-by-the-word-`pub` recurred here and closed incidentally, which is what a paid ladder looks like.

**The lesson this lap adds is about the shape of a fold rather than its price.** A queue names one family; a reach graph names a cluster. Reading the closure first cost one audit and lifted three families in a single lap, and the same reading drew the line the fold must stop at. The widest family on the ladder was never the right unit of work -- the widest family a harness may honestly reach is.


## Fold AC -- the appeal cluster, and the reading that bought five folds

The queue named **twenty-seven rungs by fifty-six lines, 1,456 carried**, and hashing every `read_the_appeal` on the ladder found twenty-eight bodies at one length. Twenty-seven stand byte for byte alike; the twenty-eighth is `appeal.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `appeal_of`. Eight lines of the fifty-six differ, and all eight differ that one way -- the same shape fold AA met in `amend.rye`, so the owner stays home again.

Fold Z's rule ran first, before scope was chosen. `read_the_appeal` reaches thirteen symbols on its rung; twelve already stood public in all twenty-seven, and the thirteenth, `appeal_of`, cost one word in nineteen. That alone would have been a clean lap. **The reading gave more than that.** Four of the twelve are themselves whole carrying families standing above the harness line: `address_published` in **thirty-five** rungs, `told_of` in **twenty-nine**, `pressed_by` in **twenty-eight**, `appeal_published` in **twenty-eight** -- each byte for byte alike, each a wire reader that opens a note through its own rung's path builder and plan name. One reach reading bought five folds.

The fifth reached helper, `appeal_note`, stayed home for the plainest reason on this ladder: its body is three lines, and a delegate is three lines. A fold that trades a body for a body of equal length moves nothing, so the queue is right to leave it where it stands.

What the folded body does is the arc's whole appeal half, stated once. A run finds the address a reader published, counts what an unread answer costs, refuses by name where a position would be published that nobody voiced, writes the note, and reads it back out of the place an operator would open before the report believes a word of it.

| Row | Before | After |
|---|---|---|
| Rungs holding `read_the_appeal` | 27 | **0**, each keeping a three-line delegate |
| Rungs holding `address_published` | 35 | **0**, each keeping a three-line delegate |
| Rungs holding `told_of` | 29 | **0**, each keeping a three-line delegate |
| Rungs holding `pressed_by` | 28 | **0**, each keeping a three-line delegate |
| Rungs holding `appeal_published` | 28 | **0**, each keeping a three-line delegate |
| Lines the five families carried | 2,937 | **426** |
| Widenings the fold cost | -- | **111**, one word each, no accessor born |
| The ladder's whole carry | 109,932 | **107,395** |
| Carry ceiling | 110,000 | **107,500** |
| Carrying families | 706 | **707** |

**The arithmetic closes with no remainder, and the remainder it seemed to have was a fifth gift.** Out went 26x56, 34x13, 28x13, 27x13, and 27x12 -- 1,456 plus 442 plus 364 plus 351 plus 324, or **2,937**. Back came the same five cohorts at three lines apiece -- 78 plus 102 plus 84 plus 81 plus 81, or **426**. That is a fall of 2,511, and the meter read **2,537**. The extra twenty-six came from `note_path`: a forty-five-rung family that widening split into thirty-five public and ten private, and a family split into two smaller ones carries one fewer copy of itself. Fold Z's split-by-the-word-`pub` recurred a third time, and this time it paid rather than cost -- which is also why carrying families rose by one.

**The lesson this lap adds is that the reach closure has depth.** Fold AB read one hop out and found a cluster; this lap read one hop out and found four families larger than several the queue had been printing all along. A body's own reach is the cheapest survey on the ladder, because every symbol it names is already audited by the fold that lifts it. The next fold reads its closure first, as this one did -- and reads it for families, not merely for words to widen.


## Fold AD -- the quarrel cluster, and the fold that cost one word

The queue named **twenty-one rungs by seventy-two lines, 1,440 carried**, and hashing every `refer_the_quarrel` on the ladder found twenty-two bodies at one length. Twenty-one stand byte for byte alike; the twenty-second is `refer.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `refer_of`. Nine lines of the seventy-two differ, and all nine differ that one way -- the shape fold AA met in `amend.rye` and fold AC met in `appeal.rye`. Three laps, three tier owners, one rule: the owner stays home.

Fold Z's rule ran first, before scope was chosen, and this lap it reported the plainest number the arc has seen. `refer_the_quarrel` reaches **eighteen** symbols on its rung, and **all eighteen already stood public in all twenty-one**. The main fold cost nothing at all -- no widening, no accessor, no word.

**The reach reading paid again, and deeper.** Six of those eighteen are themselves whole carrying families standing above the harness line: `position_standing` in **twenty-seven** rungs, `dwell_published` in **twenty-four**, `forum_published`, `refer_refusal`, `case_delivered`, and `refer_note` in **twenty-two** each. Four are wire readers that open a note through their rung's own path builder and plan name; one is a wire writer; one is pure arithmetic that refuses by name. All six lifted. The whole seven-family lap cost exactly one widened word -- `case_path`, which `case_delivered` and `refer_note` share, made public in twenty-two rungs.

Six further reached bodies stayed home, and honestly rather than by rule: `endures`, `stands_loud`, `unheard_outside`, `referred_in`, `unreferred_in`, `is_party`, `refer_holds`, `referral_bytes`, and `settlement_published` each run three to seven lines, where a delegate runs three. They still carry a few hundred lines between them, so they are the next lap's cheap remainder rather than nothing at all -- the honest claim is that the gain is small, never that it is zero.

What the folded check does is the arc's whole referral half, stated once. A run reads what stands, refuses to act on a quarrel nobody presses, dates the position off the wire rather than out of memory, leaves this morning's argument with the people having it, refuses by name where a referral would go unaddressed or land back inside the argument, copies the case off the record rather than summarizing it, and reads the case back out of the box a third hand opens before the report believes a word.

| Row | Before | After |
|---|---|---|
| Rungs holding `refer_the_quarrel` | 21 | **0**, each keeping a three-line delegate |
| Rungs holding `position_standing` | 27 | **0**, each keeping a three-line delegate |
| Rungs holding `dwell_published` | 24 | **0**, each keeping a three-line delegate |
| Rungs holding `forum_published` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `refer_refusal` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `case_delivered` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `refer_note` | 22 | **0**, each keeping a three-line delegate |
| Lines the seven families carried | 3,128 | **459** |
| Widenings the fold cost | -- | **22**, one word, one shared path builder |
| The ladder's whole carry | 107,395 | **104,726** |
| Carry ceiling | 107,500 | **104,800** |
| Carrying families | 707 | **707** |

**The arithmetic closes with no remainder.** Out went 20x72, 26x12, 23x16, 21x13, 21x12, 21x13, and 21x10 -- 1,440 plus 312 plus 368 plus 273 plus 252 plus 273 plus 210, or **3,128**. Back came the same seven cohorts at three lines apiece -- **459**. The fall is 2,669, and the meter read **2,669**. Fold AC's extra twenty-six came from a family that widening split in two; this lap widened one word inside a family that was already whole, so nothing split and nothing was gained by accident.

**The lesson this lap adds is that a free fold is a signal, not luck.** Eighteen reaches, eighteen already public: the appeal, dependent, reap, and amendment clusters had each widened the symbols this tier shares, so by the time the quarrel came up the queue its whole neighborhood was already open. Folds pay forward. The cheapest fold on any ladder is the one taken after its neighbors have gone first, and the queue -- ordered by carried lines alone -- happens to walk a tier in roughly that order because a tier's families rise together.


## Fold AE -- the escort, its wire reader, and the owner brought home

The queue named **thirty-one rungs by forty-seven lines, 1,410 carried**, and hashing every `escort_the_word` on the ladder found thirty-two bodies at one length. Thirty-one stand byte for byte alike; the thirty-second is `abide.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `abiding_of`. Four lines of the forty-seven differ, and all four differ that one way -- the signature three laps running have now met in `amend.rye`, `appeal.rye`, and `refer.rye`, each of which stayed home.

**This one came home instead, and the difference is the whole reading.** An owner stays home when a shape born after it dates it out, as `hear.rye` was dated in fold U. An owner comes home when the only thing standing between its body and its cohort's is a reach it never needed to name -- and then three lines of identity accessor make it byte for byte the same body. `relent.rye` proved that in fold X and `repose.rye` in fold Y; `abide.rye` is the third, and the family folded **whole at thirty-two**.

Fold Z's rule ran next, and reported a clean neighborhood. `escort_the_word` reaches fourteen symbols beyond the accessor, and **all fourteen already stood public in all thirty-one rungs** -- the fold's whole price was the twenty-three rungs where `abiding_of` was private, plus the three lines the owner gained.

**The reach reading paid once more.** One of those fourteen is itself a whole carrying family standing above the harness line: `dispute_recorded`, a wire reader in **thirty-three** rungs at fourteen lines apiece, one text with no absentee at all. It opens the disagreement note through its rung's own path builder and plan name, reads the two settlements it holds, and returns nothing rather than guessing where the wire reads short. Lifting it cost **no widening whatsoever** -- its five reached symbols were already public in all thirty-three, and `Dir` is the harness's own alias for `std.Io.Dir`.

What the folded escort does is the arc's whole abiding half, stated once. A run reads its own published settlement out of the note an operator would open, reads the disagreement out of the note that keeps it, and writes the mark from those two rather than from anything the supervisor remembers doing. A run that published nothing marks nothing. A record holding no quarrel has nothing to quote. A word read alone carries no mark, however plainly its reader objected. Only a published word standing over a recorded disagreement earns an escort -- and the escort must quote the reading its reader actually holds, since carrying one person's word to whoever reads another means carrying that person's word.

| Row | Before | After |
|---|---|---|
| Rungs holding `escort_the_word` | 32, one apart | **0**, each keeping a three-line delegate |
| Rungs holding `dispute_recorded` | 33 | **0**, each keeping a three-line delegate |
| Lines the two families carried | 1,858 | **189** |
| Widenings the fold cost | -- | **23**, one word, one accessor reach |
| Accessors born | -- | **1**, three lines in `abide.rye` |
| The ladder's whole carry | 104,726 | **103,057** |
| Carry ceiling | 104,800 | **103,100** |
| Carrying families | 707 | **707** |

**The arithmetic closes with no remainder.** Out went 30x47 and 32x14 -- 1,410 plus 448, or **1,858**. Back came thirty-two and thirty-three rungs at three lines apiece, carrying 31x3 and 32x3 -- **189**. The fall is 1,669, and the meter read **1,669**. Carrying families held at 707 because both families folded whole into delegate families of their own, with no visibility split opened and none healed.

**The lesson this lap adds is that a tier owner is a question rather than a verdict.** Five owners have now stood apart from their cohorts, and the arc has answered each differently on evidence: `hear.rye` stayed home because it ends its run on an error the rungs above record and carry past, and no accessor gives a body back a check it never had. `amend.rye`, `appeal.rye`, and `refer.rye` stayed home because their difference was the reach and no accessor had yet been born for it. `abide.rye` came home because the accessor cost three lines and folded forty-seven. The test is never who owns the tier -- it is whether the difference is a meaning or a reach, and only reading the differing lines can say which.


## Fold AF -- a run's whole opening, and the two absentees that both came home

The queue named **`start_one` at forty rungs by thirty-five lines, 1,365 carried**, and hashing every body by that name found fifty-seven standing as ten texts -- the canonical forty, a shallower nine at nineteen lines, and eight singletons.

**Two of the singletons stood at the canonical's own length**, each differing in exactly one line: the reach that names the abandoning tally. Reading the accessors settled both. `abandon.rye` owns the abandoning tier, so its `below_of` returns the rung beneath and the body climbs back two hops -- which is precisely what an identity accessor named `abandoning_of` gives the shared text from the same pointer. `reckon.rye` stands one rung above `abandon.rye`, so its `below_of` already returns the abandon rung's report, the very type `abandoning_of` returns everywhere else. Three lines apiece, and the family closed **whole at forty-two**.

**`reckon.rye` is a sixth kind of absentee.** The arc had met one dated by a shape born later, one an accessor brings home, one standing below the fold line, and the tier owners who came home or stayed. This one is none of those: it is a rung close enough to reach a tier by its **position** rather than by its name. An absentee's distance from its cohort is a place on the ladder as often as it is a fact about its body.

**Fold Z's rule found the neighborhood nearly free.** Eleven of the twelve symbols `start_one` reaches through its rung already stood public in all forty-two, so widening one word -- `revoke_rung`, in forty-three modules -- paid the whole fold. Four of the reached symbols are whole carrying families: `open_generation` at forty-three by ten, `promise_pruning` at forty-three by eleven, `promise_falling` at forty-two by eight, and `offer` at forty-five by seven. Together they are the four promises a run writes to the wire before it spawns anything, and they now read in one place beside the body that calls them.

**The fold line still bites.** `offer`'s forty-fifth rung is `confer.rye`, which `ladder_checks.rye` itself imports; folding it would have a rung the harness reaches for reach back through the harness. It stays home, and `offer` folded at forty-four.

| Row | Before | After |
|---|---|---|
| Rungs holding `start_one` | 42, two apart | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **43**, one word |
| Accessors born | -- | **2**, three lines apiece |
| The ladder's whole carry | 103,057 | **101,252** |
| Carry ceiling | 103,100 | **101,300** |
| Carrying families | 707 | **707** |

Out went 3,017 lines of body across forty-seven files; back came 411 as delegates and calls. Choir GREEN at 105 registered witnesses.


## Fold AG -- the promised pruning, and the whole cluster beneath it

The queue named **`return_promised_reach` at forty-two rungs by thirty-three lines, 1,353 carried**, and hashing every body by that name found **forty-two texts and one hash**. No absentee at all -- the first lead family in this arc to stand byte for byte across its whole cohort with nothing to read and nothing to bring home.

What it does is the returning half of a conferred reach. A dependent told a pruning is coming waits, bounded, for the number that names what it may keep; it rebuilds its own hands down to that number, probes whether anything past the number is still reachable, and answers only when the probe comes back empty. A `null` says the words on the wire could not be read back into hands at all, which is a different answer from *nothing was returned* and is kept different on purpose.

**Fold Z's rule paid again, and paid almost entirely.** The body reaches eight symbols through its rung, and **seven already stood public in all forty-two**. The eighth, `prune_to`, was private everywhere -- so one widened word bought the fold, exactly as fold AA and fold AD each did before it.

**The reach reading opened the cluster.** Five of the reached symbols are whole carrying families of their own, and every one of them folded beside the lead: `reachable_between` at forty-four by twenty-four, `prune_to` at forty-four by twenty-three, `pruning_promised` at forty-four by six, `kept` at forty-four by eight, and `pruned` at forty-four by seven. Together with the body that calls them they are one coherent movement -- promise, wait, rebuild, probe, answer -- and they now read in one place rather than in forty-four.

**The elder rung came home twice over.** `revoke.rye` is the tier owner here, and it stood apart from its cohort in two small ways at once: its `reachable_between` was private where the other forty-three published it, and its `prune_to` lacked one invariant the other forty-three carry -- *a pruning always rebuilds from hands that hold their own line*. The first is a visibility split, healed by the word. The second is an elder body dated by a shape born after it, and folding hands it the invariant rather than asking it to keep going without one. Both families closed **whole at forty-four**.

| Row | Before | After |
|---|---|---|
| Rungs holding `return_promised_reach` | 42, none apart | **0**, each keeping a delegate |
| Rungs holding the five reached families | 44 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **45**, two words |
| The ladder's whole carry | 101,252 | **98,507** |
| Carry ceiling | 101,300 | **98,600** |
| Carrying families | 707 | **707** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **2,745**. Carrying families held at 707, since all six folded whole -- one visibility split healed and none opened. Checks 47 and spine 0 stand unmoved for the tenth fold running.

**The lesson this lap adds is that a family with no absentee is a signal about its neighborhood, not only about itself.** Every prior lead family carried at least one rung standing apart, and reading that rung is what taught the arc its five kinds of absentee. This one stood whole -- and the reason is that the whole cluster was written at one moment, by one hand, as one movement, and has never been touched since. A body that varies has a history; a body that does not has a birthday.


## Fold AH -- the courier cluster, the largest fall on the ladder, and the price was two words

The queue named **`carry_the_amendment` at thirty-four rungs by forty-one lines, 1,353 carried**, and hashing every body by that name found **thirty-five**. `courier.rye` stood apart by four lines, and all four differed the one way: the owner reaches its own report directly where every rung above reaches through `couriering_of`. That is the second kind of absentee, met now for the seventh time and recognized on sight -- three lines of identity accessor, and the family folded **whole at thirty-five**.

What the body does is the outward reach of the whole correspondence arc. A run that posted no correction carries nothing, and says so by weighing nothing rather than by inventing an errand. A reader who left no address cannot be reached, and the run refuses by name rather than choosing a destination on their behalf. Only a posted correction with somewhere to go travels -- and under `.waiting` even that one stays where it was written, which is precisely the number this tier moves. The hard half comes at the end: the run reads the reader's own box back before it believes a word of its own report, because a delivery claimed from memory of having written is a claim rather than a delivery.

**Fold Z's rule was walked to closure this lap rather than one hop out, and that is the whole story of the fall.** One hop from the lead named ten symbols, and every one of them proved a whole carrying family standing byte for byte across the same cohort. A second hop, from `deliver` and `delivered_to` down to the path builder they share, named **`box_path` at twenty-five lines over thirty-five rungs** -- the second-largest family in the cluster, and one the lead body never mentions. A reach graph read to its closure is a survey; a reach graph read one step is a glimpse.

| Family | Rungs | Lines | Carried before |
|---|---|---|---|
| `carry_the_amendment` | 35 | 41 | 1,353 |
| `box_path` | 35 | 25 | 850 |
| `carry_refusal` | 35 | 19 | 646 |
| `delivered_to` | 35 | 15 | 510 |
| `amend_published` | 36 | 14 | 490 |
| `deliver` | 35 | 13 | 442 |
| `addressable` | 35 | 11 | 374 |
| `carried_in` | 35 | 7 | 238 |
| `posted_unreached` | 35 | 6 | 204 |
| `unaddressed_reach` | 35 | 6 | 204 |
| `held_in` | 35 | 5 | 170 |

**The price was two words.** Every other symbol the cluster reaches already stood public in all thirty-five rungs, interest paid in full by the folds before it. `couriering_of` was private in `hear.rye` alone, and `note_path` private in `amend.rye` alone -- the amending tier owner, which joins this lap for `amend_published` and nothing else, since it carries no readers' directory and no box of its own. Two widened words and one accessor born bought eleven families.

**The cluster drew its own boundary honestly.** `address_published` is reached by the lead and stands in thirty-five rungs, yet it is already a delegate three lines long -- folded on an earlier lap -- so it stayed exactly where it was. A three-line body traded for a three-line delegate moves nothing, and a fold that reached for it anyway would be counting motion rather than making it.

| Row | Before | After |
|---|---|---|
| Rungs holding the eleven bodies | 35 or 36 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **2**, plus one accessor born |
| The ladder's whole carry | 98,507 | **94,151** |
| Carry ceiling | 98,600 | **94,200** |
| Carrying families | 707 | **707** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **4,356** -- the largest this arc has taken, half again the previous best. It closes with no remainder: the eleven families carried 5,481 lines between them and the delegates that replace them carry 1,125. Carrying families held at 707, since every family folded whole and no visibility split opened or closed inside a carrying cohort. Checks 47 and spine 0 stand unmoved for the **eleventh** fold running.

**The lesson this lap adds is that a delegate keeps the visibility of the body it replaces.** Two of these eleven were private in their rungs and stayed private, because nothing outside the rung ever called them and the harness reaches them as itself rather than through the type. Publishing a delegate that nobody outside reads would widen the module's surface for the fold's own convenience -- and a fold that quietly widens what it touches is charging a price it never names.


## Fold AI -- the whole standing movement, and four tier owners home in one lap

The queue named **`weigh_the_standing` at twenty-two rungs by fifty-seven lines, 1,197 carried**, and reading one tier out found its three siblings standing beside it: `date_the_standing` at twenty-two by fifty-six, `herald_the_standing` at twenty-two by fifty-three, and `carry_the_position` at twenty-two by fifty. Together they are one movement -- **what a run owes a quarrel still standing over its plan**, carried past the run that heard it, weighed into the word an operator reads, dated by how long it has stood, and heralded as loudly as that age deserves. The harness already runs them as a movement; `the_standing` calls all four in the order the arc grew.

**Every one of the four carried its own tier owner, and every one came home.** `heed.rye`, `dwell.rye`, `swell.rye`, and `endure.rye` each own the tier their sibling body reports into, so each reached its own report directly where the rungs above reach through an accessor. Four identity accessors, three lines apiece, and four families that had never once stood whole stood whole together.

| Family | Rungs | Lines | Carried before | Tier owner brought home |
|---|---|---|---|---|
| `weigh_the_standing` | 26 | 57 | 1,197 | `heed.rye` |
| `date_the_standing` | 24 | 56 | 1,176 | `dwell.rye` |
| `herald_the_standing` | 23 | 53 | 1,113 | `swell.rye` |
| `carry_the_position` | 27 | 50 | 1,050 | `endure.rye` |
| `regard_published` | 26 | 12 | 300 | -- |
| `swell_published` | 23 | 12 | 264 | -- |
| `dwell_note` | 24 | 7 | 161 | -- |
| `standing_note` | 27 | 5 | 130 | -- |
| `regard_note` | 26 | 5 | 125 | -- |

**The second hop was nearly free, and it stopped where it should.** Of the forty-odd symbols the four bodies reach, every one already stood public in every rung that has it at all, and the ones absent from a rung are absent exactly where the tier structure says they should be -- `swell_published` and `Volume` live only from the heralding tier up. Most of the reached helpers are already three-line delegates from earlier laps and were left exactly where they are. Five were real bodies and lifted; the rest moved nothing and so did not move.

**The visibility split here is meaning rather than accident.** Twenty-two rungs publish these bodies and four or five keep them private, and the reason is legible: a rung that only ever reaches the body through the harness's `the_standing` must publish it, since the harness calls `rung.weigh_the_standing`, while a rung that calls it itself has no reason to widen its own surface. Fold Z met this shape as a split to heal; this lap met it as a split to **keep**. So each delegate wears the visibility its body wore, and the meter honestly reads two families where the ladder honestly holds two.

| Row | Before | After |
|---|---|---|
| Rungs holding the nine bodies | 23 to 27 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **64**, plus four accessors born |
| The ladder's whole carry | 94,151 | **89,010** |
| Carry ceiling | 94,200 | **89,100** |
| Carrying families | 707 | **708** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **5,141** -- larger again than the lap before it, and it closes with no remainder: 5,780 carried in across the nine families and their visibility twins, 639 carried back out in delegates. Checks 47 and spine 0 stand unmoved for the **twelfth** fold running.

**Carrying families rose by exactly one, and the one is a family born rather than a family split.** Before this lap `dwell.rye` and `swell.rye` each held their own private `date_the_standing`, two distinct texts standing alone. Folding gave both the same three-line delegate, so two singletons became one carrying pair. A fold that lifts bodies out can still leave a new family behind it, and the honest reading is that the meter counts texts rather than intentions.

**The lesson this lap adds is that a movement is a better fold unit than a body.** The queue names one family at a time because it measures one name at a time, yet `the_standing` had been calling these four in sequence since the spine finished growing at `refer`. Reading the harness for what it already runs together found four families where the queue showed one -- and four tier owners whose accessors, born together, cost twelve lines and folded two hundred and sixteen.


## Held

Extended-run stability (dozens of supervised cycles, watched for resource growth) waits for a genuine indefinite consumer to make the longer run mean something -- see [`counsel/date/20260707/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](../counsel/date/20260707/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md) for the reasoning. `system.rye` reads flat Bron, the same notation Brix descriptors use, and it declares Caravan's own three rings alone -- composing a build remains Brix's work, and Pond's policy layer stays its own. Caravan supervises processes, and stops exactly there.

---

*May every dependent that falls be caught, and every dependent that finishes ordinarily be trusted to go again. May a stop always mean the same thing, however it arrives.*
