# SEED — autonomous loop · a self-paced unattended run under the laws held whole

*A blank fillable recursion prompt for an agent that runs unattended for hours, recurring through agent-doable work and stopping only at the custody gates. Copy into `../versions/` at a fresh live-clock stamp and fill every `{{slot}}`. Elder: the loop recipe in [`../../tools/launch-claude-season.rish`](../../tools/launch-claude-season.rish); craft guide: [`../../external-research/20260703-013412_writing-recursion-prompts.md`](../../external-research/20260703-013412_writing-recursion-prompts.md).*

---

## The one line (paste form)

> Read `work-in-progress/REMEMBER.md`; take the next agent-doable lap Lindy-first crux-first; send often — push each finished increment (a new file, a passing witness, a doc) to `origin` and `xykj61` as its own signed round so progress is followable on GitHub; approve your own design rounds and trust yourself before checking in; keep double-seating new visions that address calendar-itinerary blind spots; STOP at the custody gates in REMEMBER; if only those gates remain, run the shell command `touch .loop-gates-only` and print exactly `GATES-ONLY`, then stop. baton prin recur

## 1 — The lenses, loaded by reference

Read `context/` before large decisions: TAME (safety > performance > joy), CIVIC (name what the prompt rewards), the compass rose (`foundations/20260706-185112_follow-our-compass.md`), Two Rooms (checkable vs proposed), Radiant and Twilight style, Lindy-first crux-first, reds-first. The disciplines are written to be loaded this way; restating them drifts from them.

## 2 — The hard bounds, by tag (the custody gates — never cross)

Carried verbatim from `work-in-progress/REMEMBER.md` → *Custody gates*. An autonomous run **stops and surfaces** at each; it never crosses:

1. {{seed-force-push-gate — the final seed force-push to grain-os/grain}}
2. {{provisioning-or-paying — cloud/VPS/subscription; agents author IaC, Keaton provisions and pays}}
3. {{funds-keys-custody — moving funds, holding keys, opening any wallet/payment rail}}
4. {{maintainer-kumara — generating Keaton's own Kumara instance from his real seed}}
5. {{deep-debride — history rewrite + force-push of the living tree}}
6. {{collaborator-domain — seating a new module in a collaborator's domain beyond floor code}}

Everything else — design, code, witnesses, docs, weaves, seed *projection* (not push), reds — is agent-doable and does not wait.

## 3 — The route (Lindy-first, crux-first)

The itinerary is REMEMBER's season table and open doors. Each round: read the compass, pick the highest-Lindy crux among agent-doable work, land it, prove it, send it. Named route, never an open field.

- **Next lap:** {{the next agent-doable rung — file · what it composes · what it proves}}
- **Then:** {{the rung after, if pre-decidable}}

## 4 — Method: witness-first, red-then-green, in the same round

Name the proof before the work: {{witness path}} asserts {{invariant}}; green looks like {{green line}}. See the red before trusting the cure. Definition of done rides inside every rung, never as a closing exhortation.

## 5 — Tripwires (park, name, continue)

A tripwire is not a stop — it is a design round you **approve for yourself** and make progress on, rather than panicking to check in. Book it, name it, keep going:

- A new big vision that fills a calendar-itinerary blind spot → **double-seat** it (Lexicon + a rule/foundation) so it never disturbs the fixed itinerary, and continue.
- A red → book it in `work-in-progress/REDS.md` (what went wrong · what caught it · what it taught), close it on a witness on metal, then resume.
- A genuine custody fork → that is a gate (part 2); surface it, do not decide it.

## 6 — Clock, ledger, remotes, signing

- **Clock:** `TZ=America/New_York date +%Y%m%d.%H%M%S`, never fabricated. One clock, not one hand.
- **Commits:** CONTRIBUTING style — component-prefixed subject under 50 chars, Radiant body, `Related` section. The session log rides in the same commit.
- **Remotes:** push both `origin` and `xykj61` every send (ls-remote guard first; `origin` may 403 from the cloud — name it, the home pier closes the gap).
- **Cadence — send often:** push each *finished increment* as its own atomic signed round — a new file, a passing witness, a landed doc — rather than batching a whole rung, so progress is followable on GitHub in near-real-time. More granular than one-send-per-rung, yet still no pin-only commit: every send carries a green witness or an honest note, and each subject stays component-scoped.
- **Signing:** GPG-signing stays on; never `--no-gpg-sign`, never `--no-verify`.
- **REMEMBER git nib** updates in the same work commit; amend at most once; never a pin-only follow-up.

## 7 — Every round leaves a record

A `.bron`/`.kyri` session log per round (`session-logs/`), a newest-first row in `session-logs/README.md`, and REMEMBER's Now refreshed. The round summary is the agent's account in Kyri's voice.

## 8 — The budget and the stop rule

- **Budget:** {{N rounds or N commits, whichever first — or "until the clock reaches {{time}}"}}.
- **Stop rule:** if only the custody gates remain agent-blocked, `touch .loop-gates-only` (the loop's file sentinel — robust against the prompt echo that a grep on stream-json would false-match) and print exactly `GATES-ONLY`, then stop. Otherwise continue the recursion.

---

*{{closing radiant or twilight wish — earned, concrete to this run}}*
