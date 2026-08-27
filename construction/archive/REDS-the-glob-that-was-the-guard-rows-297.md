# REDS %297 -- the glob was the guard, and eight witnesses stood outside the name

*Written straight onto this shelf on `20260827.022424`, **CLOSED**, the way `%288` was written on
`20260827.004535`. The living pin had three bytes of room, and `tools/fixtures/reds_fold.sh`
refuses to move an open row, so a row closed on the lap it is booked is born here.*

***Booked as `%289`, re-seated at `%290`, and re-seated again at `%297`.** The first move answered
`xy`'s own `%289` from the Sound pier at `20260827.024604`, an unrelated sed-tamper red. The second
came on `20260827.173000`, when this whole commit was **adopted file-wise out of the mirror remote
`debrided`** -- it was authored at `03:25`, above the Kiln deep debride's checkpoint, and the rewrite of
`20260827.040024` never carried it, so it survived on `debrided/main` alone until that mirror was
force-matched to `xy` and the commit was preserved at `pier/pre-rewrite-20260827` rather than lost.
By then `%290` through `%296` were all spoken for. The push to `xy` is the allocation, so upstream's
numbers stand and this one moves each time.*

***This is the SIXTH firing** of the row-number door, after `%230`, `%252`, the `%283`-`%285`
re-seat, this row's own first move, and the `%294`-`%296` re-seat of `20260827.164655`. Six firings,
and the derived-spine key those rows keep surfacing still waits at Keaton's door. **A row number is
allocated by whoever pushes first, and three stars push into one tree** -- the argument is no longer
that a key would be tidy; it is that the ledger has now spent six rounds paying for its absence.*

---

**REDS %297 (`20260827.022424`) -- a witness backgrounded an AND-list, killed the wrapper, and read a file the service was still writing.**
*What went wrong:* `tools/ca/caravan_subscribe_poll_signal.rish` ran its whole SIGTERM probe as one
300-character `sh -c` string, opening `rm -f "$sentinel" "$out" && "$service" "$delivery" "$sentinel" >"$out" 2>&1 & pid=$!`.
In shell grammar **`&` binds looser than `&&`**, so that backgrounds the entire AND-list as a single
subshell and `$!` names the subshell rather than the service. `kill -TERM "$pid"` therefore killed
the wrapper; the service was orphaned to init and went on running; the wrapper was gone instantly,
so `while kill -0 "$pid"` fell through on its first check and `cat "$out"` read an output file two
lines deep. The witness asserted on output the service had not finished writing, and reported RED
about a supervisor that stops correctly every time. Each failed run then **leaked a live
supervisor** holding its store and its sockets, and the next run inherited them -- which is where
the `error: RevisionImmutable` seen mid-diagnosis came from, a stale process answering for a run
that had done nothing wrong.
*The second fault, and the reason the first stood for as long as it did:* the Caravan choir could
not see this witness. `tools/ca/caravan_suite_witness.rish` and
`tools/fixtures/caravan_roster_bijection_scan.sh` both find their subjects by globbing
`caravan_*_witness.rish`, and **eight runners in `tools/ca/` wore no such name** -- the four
`caravan_subscribe_poll_*` rings, plus `capabilities`, `restart_on_ok`, `seeds`, and
`witness_stop_footgun`. They were never unregistered; they were **invisible**, so the bijection
built to catch an unheard witness printed `ROSTER_OK` truthfully at 113 of 113 while eight stood
unheard. `caravan/LADDER.md` named all eight as the coverage for its **earliest** rungs -- the ones
every later rung composes over -- and the only living roster that ran them was
`tools/p/parity_ch01.rish`, which stands on no standing roster at all.
*What caught it:* running the witness rather than inheriting the prior lap's reading. That lap
recorded the failure as "identical under A/B", and the A/B was honest -- it compared the module's
two arms, while the fault was in the witness's own shell, identical in both. Then
`ps -eo pid,ppid,args` after a failed run, showing `subscribe-poll-service` alive at **PPID 1** with
two children of its own.
*Found twice the same night, and the record should say so.* The Sound pier reached the same
precedence fault independently while closing `%282`, measured it as `40851 against 40854`, and
repaired it in place with an `exec` before the service, so the subshell becomes the supervisor and
one pid receives the signal. That repair is correct and this tree keeps the stronger one, for two
checkable reasons: `exec` leaves the timeout path still returning `exit 2` over a live supervisor,
which is the leak that poisons the next run, and it leaves the 300-character one-liner standing,
which is the form that hid the fault from both piers for as long as it stood. **The naming fault is
a co-discovery; the coverage gap below is what only this lap found.**
*What it taught:* **when a guard finds its subjects by name, the naming convention IS the guard, and
anything outside it is not guarded at all.** `%81` and `%101` both taught that a witness on disk
must be registered, and the guard they produced counts by name -- so the next failure moved one
layer down, from unregistered to unnameable, and the guard stayed green through it. A second lesson
rides along: **a witness that leaks a process poisons its successor**, so a probe that gives up must
still reap what it started.
*Repaired:* the probe moved to
[`../../tools/fixtures/caravan_subscribe_poll_signal.sh`](../../tools/fixtures/caravan_subscribe_poll_signal.sh),
matching the shape its sibling ring's probe
[`caravan_subscribe_poll_source_crash.sh`](../../tools/fixtures/caravan_subscribe_poll_source_crash.sh)
had right all along -- one command per line, the service backgrounded **alone**, so `$!` names it.
Its timeout path reaps children by `pgrep -P` and then the supervisor, since a `KILL` on a parent
never reaches what it spawned, and `pgrep -P` asks by PARENT rather than by command text, which a
`-f` pattern here would match against this tree's own agent shell. The eight runners were renamed to
carry `_witness` and registered with the choir, which now reads **121 of 121** where it read 113;
fourteen living files were repointed in the same round, while three dated research and spec pages
keep every word they wrote (accrete-never-break).
*Proven both ways, on metal:* the honest leg runs **GREEN three consecutive times with zero orphans
left behind**; the refusing leg, a planted service that traps and ignores `SIGTERM`, is refused at
`rc=2` in 7 seconds against its 6.8-second budget with **nothing left running** -- and the same
plant before the reap was added left a `sleep 60` at PPID 1, which is how the child-reap earned its
lines. The precedence itself was shown directly: `sh -c 'true && sleep 30 & pid=$!'` reports a `$!`
that `ps` resolves to `sh -c ...`, while `sh -c 'true; sleep 30 & pid=$!'` reports one that resolves
to `sleep 30`.
*Measured independently on the other pier, the same hour.*
[`../../active-designing/20260827-034026_the-exemption-that-named-its-own-witnesses.md`](../../active-designing/20260827-034026_the-exemption-that-named-its-own-witnesses.md)
reaches the same reading from the other side and sizes the same repair -- eight renames, seven
living repoints, eight roster registrations, and the header sentence cut back to `ladder_checks`,
`parse_int` and `tally_copy`. It **deferred** the cut, because a rename stages sixteen index entries
at once while a second session holds this checkout open (`%281`). This lap is that repair landed,
and its header cut follows that note's reading rather than the looser one this lap first wrote: six
of the nine modules the sentence named as unwitnessed -- `bounded`, `capabilities`, `chain`, `seed`,
`service`, `twin` -- **are** witnessed, in this very room, and saying otherwise is what made the gap
read as settled rather than as drift. Two piers, one night, one fault, found twice and repaired once.
*Surfaced, not crossed:* `tools/p/parity_ch01.rish` remains the tree's **top ungated aggregator** --
`active-development/20260825-020027_which-witnesses-actually-run.md` measured it at **+107** new
witnesses reached for one roster row, the largest single row available. That note deliberately
argued for none of its three gating policies, and which population should be gated stays Keaton's
decision rather than this row's. **CLOSED.**
