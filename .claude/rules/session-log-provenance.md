# Session-log provenance

Apply this rule to new `session-logs/*.kyri` records. Keep dated logs unchanged unless Keaton asks for a factual correction.

## One session, one attributed hand

Record `provider`, `product`, `role`, and `modality` beside `editor`. Use the product actually holding the conversation, such as Codex desktop or Claude Code. A writing voice sits beside a provider rather than standing in for one: new logs still record `voice Kyri`.

The required `model` field names a verified active model identity. When the runtime exposes no authoritative identity, write `model unverified` and `model_status active runtime unverified`. Never promote a preference, alias, profile value, model catalog, or configured default into an active-runtime claim.

## Configuration stays separate

Use `configured_model`, `configured_reasoning`, `configured_service_tier`, and `configured_service_name` only for settings supported by named evidence. Add `configured_status` and `evidence` so a reader can tell a configured default from runtime telemetry. A clone's `GLOW_PROFILE.kyri`, a tracked product settings file, or a user-confirmed host config may prove configuration; each remains weaker than active-runtime evidence.

Keep identifiers in their own fields. For OpenAI Codex, `gpt-5.6-sol` is the user-selected default model slug (seated `20260912`), `ultra` is a Codex reasoning setting, and `priority` is the service-tier id whose user-facing name is Fast. For Claude Code, `.claude/settings.json` proves the FLEET DEFAULT `claude-opus-5` at `medium`, read `20260917`; it proves configuration alone rather than a running session's use of either value, and the effort a lap runs at depends on its launch path -- `tools/f/fleet_lap.sh` execs `--effort max` inside the enclosure while `tools/f/fleet-loop.sh` execs `--effort medium` bare, which this pier runs.

**A CLONE MAY RUN A MODEL NO TRACKED BYTE NAMES, so `configured_model` follows the RESOLVED value rather than the tracked file** (seated `20260917.184231`). `.claude/settings.local.json` outranks `.claude/settings.json` per key, exactly as Claude Code resolves them, and `.gitignore` line 146 denies it -- so it reaches no guard reading tracked bytes and no peer's checkout carries another ship's copy. On `20260917.180039` seven of the eight ships took `claude-sonnet-5` that way on Keaton's word while all eight continued to DECLARE `claude-opus-5`, and `tools/fixtures/d/declared_model_scan.sh` read `verdict=ok` on every one of them -- right about one ship and green about all eight. Read the pair rather than the file:

```sh
sh tools/fixtures/d/declared_model.sh resolved_model   # what THIS clone runs
sh tools/fixtures/d/declared_model.sh override         # whether it can differ here
```

The scan prints `resolved_model`, `resolved_effort` and `local_override` beside the declared pair and **gates neither**, since seven ships carrying an intended override would red a gate no lap may repair -- the shape [`derived-spine.md`](derived-spine.md) names as a gate somebody turns off. A log whose `configured_model` cites the tracked file while its clone runs another model has promoted a default into a claim, which is the one thing this rule exists to refuse.

For this Codex pier, record `configured_model gpt-5.6-sol` and name the evidence:
`~/.codex/config.toml` is the personal default; the fleet loop passes `-m "$CODEX_MODEL"`,
defaulting to the same slug. An explicit model override is logged as the configured choice
for that lap. Keep `model` tied to runtime evidence, as above.

## Separate sessions stay separate

For user-coordinated joint work, add `coordination user coordinated separate sessions`. Prefix the other hand's facts with `collaborator_`, including provider, product, role, modality, model, model status, evidence, scope, and status. Attribute each contribution to local Git evidence or to an explicit user report.

Describe the work as a joint effort only at the coordination layer. Never imply a shared runtime, direct model-to-model exchange, vendor partnership, endorsement, or a contribution whose evidence is absent.

Finish with `scope` and `status` for this hand. **Write `status` before the send, never after.** A lap cancelled mid-send cannot write one afterwards, and without it a killed lap and a finished lap that declined to send read identically -- two different facts wanting two different repairs, wearing one appearance. That is not hypothetical: an incense loop was cancelled by hand at the moment its lap completed on `20260907`, its work stood staged and whole, its log claimed no send and so said nothing false, and only Keaton's own word established which of the two had happened. **Counted rather than gated** by `tools/fixtures/s/status_declared_scan.sh`, because a lap killed mid-send cannot write a status by definition, so a gate would red hardest on exactly the laps it exists to make visible. **Run the scan rather than reading a figure here.** At `20260907.200326`, mid-day, 95 logs read 21 both and 73 neither; the day closed at 129 logs, 41 both, 87 neither; and `20260908` reads **26 of 26 carrying both** -- 25 naming their witnesses and one honest `WITHDRAWN` (re-read `20260908.041006`). The clause was seated on `tools/f/fleet_baton.txt` on `20260907`, which is how it reaches every ship, and the adoption arc is the baton's own receipt. **Counted rather than gated stays on its structural reason**, not on that figure: a killed lap cannot write a status whatever the fleet's habit is. Plain words are welcome after every field; Kyri values are the text after the first space.
