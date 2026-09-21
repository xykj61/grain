# Incense's own DeepSeek-via-Together setup -- the real runbook

**Language:** EN
**Style:** New Gauge, Field setting -- TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Landed -- this is what actually happened on this ship, not a plan for later
**Stamp:** `20260920.204041`
**Ship:** `incense` (`grain-incense`), the Earth fleet
**Kin:** [`../open/HARNESS_SETUP.md`](../open/HARNESS_SETUP.md) (the generalized template this runbook fed) - [`../open/PROVIDER_SETUP.md`](../open/PROVIDER_SETUP.md) - [`../open/US_DATACENTER_POLICY.md`](../open/US_DATACENTER_POLICY.md) - [`../fleet/README.md`](../fleet/README.md)

## The seed

Keaton asked incense to auth with Together AI, verify it live, wire up an open coding harness
against it, and confirm the requests actually land on US soil -- and to keep every step honest
rather than summarized, so a future ship reading this could reproduce it exactly or spot where
their own attempt diverges.

## What actually ran, in order

1. **Got a Together AI key**, added $100 of credit. First paste attempt exposed a real gap in
   this tree's own scrub guard (it caught only SSH/PGP key shapes, never a bearer token) and
   widened it the same round the risk was named, before any leak happened -- `tools/fixtures/s/sow_personal_scan.sh`
   gained the `sk-or-v1-` pattern that day, `tgp_v1_` the next.
2. **Stored the key in `~/.bashrc`**, outside the repository entirely -- never in a tracked file,
   never in a gitignored one either, since a gitignored file can still be force-added by an
   absent-minded hand.
3. **Verified live with a plain `curl` call** against `https://api.together.ai/v1/chat/completions`,
   model `deepseek-ai/DeepSeek-V4-Pro-0813` -- answered `"authenticated"`.
4. **Declared `hf`, `llm.withPlugins { llm-openrouter = true; }`, and `opencode` in
   `nixos/configuration.nix`**, each only after confirming it genuinely resolves from
   `cache.nixos.org` (a real `curl` against the store path's own `.narinfo`, HTTP 200) and
   genuinely runs. Re-locked the flake's `nixpkgs` input to the day's own revision first, since
   "latest as of today" is a claim about a pin, not a guess.
5. **Proved the whole system closure builds** with `nix build '.#nixosConfigurations.pier.config.system.build.toplevel' --no-link`
   before ever asking for `sudo` -- no root, nothing touched on the running host, a real store
   path printed as the answer.
6. **Ran the actual `sudo nixos-rebuild switch` from an outer host shell**, per
   `nixos/rebuild-outer.sh`'s own rule: ai-jail sets "no new privileges," so the switch never
   runs from inside the enclosure. Confirmed success, then confirmed `hf` and `llm` resolve
   straight off `PATH` with no `nix-shell` wrapper needed anymore.
7. **Wired OpenCode to Together AI** by writing `~/.config/opencode/opencode.json` (declaring
   Together as a provider) and `~/.local/share/opencode/auth.json` (the credential, in OpenCode's
   own `{ type: "api", key }` schema) directly, since the interactive `/connect` picker reads raw
   terminal keystrokes and does not accept piped input cleanly.
8. **Proved the whole chain with one real call**: `opencode run '...' -m together/deepseek-ai/DeepSeek-V4-Pro-0813`
   answered exactly the requested string.
9. **Measured the US-datacenter claim rather than only citing Together's policy** -- their API
   response carries an `x-request-id` shaped `<uuid>-aws_<region>`. Four live calls this round
   answered `aws_ue1` once, `aws_ue2` three times -- both AWS US regions.

## What this taught, worth carrying to the next ship

- **A guard widened after a real key is pasted is late; a guard widened the moment the key's
  shape is *learned* is on time.** Both scrub widenings this round happened before any leak, not
  after one -- the discipline is to check the guard the instant a new credential shape is real,
  not to wait for an incident.
- **A Nix module's own `environment.systemPackages` list is unforgiving of a misplaced comma of
  indentation.** The exact same syntax mistake -- a bare package name written outside the list --
  was made and caught twice in one day. Read the diff before evaluating, every time, especially
  right after a comment block that shares the same indentation as the list itself.
- **A TUI that reads raw keystrokes does not take piped stdin the way a line-buffered prompt
  does.** When a `/connect`-style picker refuses automation, write the credential file directly,
  in the tool's own documented schema, rather than fighting the picker.
- **Policy is a claim; a response header is a measurement.** Together's own stated US-default
  became a checkable fact only once a real header was read from a real response.

## Where this landed

Every generalized version of these steps lives in [`open/`](../open/README.md), stripped of this
ship's own name and specifics: [`open/PROVIDER_SETUP.md`](../open/PROVIDER_SETUP.md),
[`open/HARNESS_SETUP.md`](../open/HARNESS_SETUP.md), and
[`open/US_DATACENTER_POLICY.md`](../open/US_DATACENTER_POLICY.md). This page stays as the dated,
ship-specific record of the actual lap, per [`stamp-and-name.md`](../.claude/rules/stamp-and-name.md) --
testimony that keeps every word it wrote, rather than a template asked to also carry a real
ship's own history.

May the next ship that reads this find the path already cleared, and the reasons for each turn
still standing beside it.
