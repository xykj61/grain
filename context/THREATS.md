# Threats — what the pier holds, who can reach it, what we assume

**Language:** EN  
**Stamp:** `20260724.220625`  
**Voice:** Quin  
**Status:** Living pin — descriptive threat model; Checkable where it cites seated paths  
**Bound:** under `living_pin_max_bytes` (24576)  
**Room:** Checkable for named assets; Mixed where a gap is named  
**Answers:** OPEN_QUESTIONS #3  
**Counsel:** [`../counsel/date/20260724/20260724-141612_names-maps-and-open-questions.md`](../counsel/date/20260724/20260724-141612_names-maps-and-open-questions.md)

*Descriptive, not prescriptive. Each line states what is true today, or names a gap and stops. No aspiration wears a fact's clothes.*

---

## 1. Assets

**OpenPGP master (cold).** The identity signing root. Documented at root [`PUBKEYS.md`](../PUBKEYS.md) and, for the retired identity lane, at [`PUBKEYS.md`](PUBKEYS.md) · [`../keys/`](../keys/). It certifies subordinate keys. Day-to-day commits are designed to leave it untouched — jail-local and sandbox keys exist so the master stays cold. Who reaches it: the operator on a host that holds the private half, and that operator alone; the sandbox and the forge never do.

**OpenPGP sandbox / jail-local key (revocable).** The key the jail and agent lanes sign with. Paths include `keys/jail_signing_linux_*.pub.asc` (current) and `keys/rye_signing_*.pub.asc` (retired lane). Who reaches it: processes inside the enclosure that hold its private half; compromise is contained by revocation and by keeping the master offline.

**Forge SSH keys.** Public fingerprints live in `PUBKEYS.md`. Private halves live outside the tree (host `~/.ssh` / project `.ssh`, gitignored). Who reaches them: the host that holds the private key, and any agent or shell that can use that key to talk to a forge.

**Append-only log of signed facts.** Weave — `mantra/src/weave.rye` — is the permanence substrate: an append-only DAG of immutable signed facts. Mantra projects history over it. Who reaches it: code paths that append and verify under the seated identity keys; readers of the pier who can see the history store.

**Digest roots and seated fixture bytes (integrity, not secrecy).** These prove sameness rather than guard secrets. Named today: the HAWM1 demo root `99b3ae96…e4c5fe` pinned in `linengrow/seva_b0_fold.rye` (and asserted by rename and product witnesses); the FLW corpus pin over `tools/fixtures/flw-four-letter.txt` (count and SHA3-512 in `tools/waymark_derive.rish`); seated waymark draws (HAWM · TUBE · ZETA · JABS · LULU · STOA · SETU · SEVA). Who reaches them: every clone of the pier; changing them breaks witnesses by design.

**The pier across remotes.** Canonical count and names live in [`REMOTE_ROSTER.md`](REMOTE_ROSTER.md). This cloud pier carries only `origin` today. Who reaches a remote: whoever holds forge credentials for that remote. Dated prose that says *five remotes* carries an erratum pointing at that roster — the wrong belief stays visible (Tier 2).

**Mand's audit log.** In-process bounded log in `mand/mand_ring1.rye` (`AuditLog`, max eight entries). Ring-1 appends on grant; ring-2 writes retention decisions (KEEP · ELIGIBLE · HELD) onto the same log. Who reaches it: the process running Mand's API; it is not yet a durable on-disk store.

**FUTURE (named, not present):** artist contact records; donation flows. Neither is a stored product surface today.

---

## 2. Adversaries and failure modes

Categories, not villains.

**Device seizure or loss** — including border and arrest contexts. The device holds sandbox or jail-local key material, SSH private halves if present, and a clone of the pier. The master key's cold posture is the designed answer; anything that entered the device is in scope for the seizer.

**Sandbox-key compromise.** An agent or process inside the jail signs as the sandbox key. Revocation and master-offline are the living mitigations. Digests and dated immutability still constrain what a bad signature can quietly rewrite.

**Forge account or single-remote compromise.** One remote accepts a push the operator did not intend. Multi-remote propagation, when used, is manual and signed; this cloud pier's single `origin` makes that discipline thinner here than the law describes for a full host.

**Supply chain.** Toolchain trust includes `ziglang` via pip on cloud raises (`manual/guides/cloud-agent-toolchain-setup.md` names the trade-off), Monocypher under `vendor/`, and Genode study material under gratitude/vendor paths. A compromised upstream package reaches every build that trusts it.

**Mistaken or manipulated agent in the bench loop.** Prompt injection, scope creep past a STOP, or a witness green for the wrong reason (assertions too weak, fixture too kind, wrong binary run). A green line means what its assertions say — and no more.

**Operator error and operator absence.** Wrong stamp, wrong remote, skipped witness, lost passphrase, illness, travel, death. Named plainly: today Keaton is the sole authority. That is a single point of failure and an honest one.

**FUTURE:** trustee misuse — waits on the succession answer (OPEN_QUESTIONS #2).

---

## 3. Assumptions

Each line is falsifiable. The break condition sits beside it.

| Assumption | What would break it |
|------------|---------------------|
| The master key never enters the sandbox. | A master private key found inside the jail, Pond, or an agent environment. |
| The jail signs with a revocable subordinate key. | Day-to-day commits verified under the master fingerprint instead. |
| This cloud pier sees `origin`; full multi-remote propagation is a host ritual, manual and signed. | Unattended fan-out from the jail to every forge, or a fifth remote seated without updating the signing rule. |
| Digest-covered bytes are Tier 1 (never edit); dated testimony is Tier 2 under `dated_guard` (Radiant pass / errata only). | A Tier 1 pin changed while witnesses claim the old hex; a dated path edited without living header, freeze pointer, or recorded Radiant pass. |
| A green witness means what its assertions say, and no more. | A GREEN line whose printed claims were not the checks that ran, or a parity skip that still prints GREEN. |
| Keaton is the sole authority — a named single point of failure. | A seated succession design (OPEN_QUESTIONS #2) that names who acts when the hand rests. |

---

*May what we hold stay named. May every gap stay a gap until a decision earns its seat. May a frightened day find a page that did not flatter the tree.*
