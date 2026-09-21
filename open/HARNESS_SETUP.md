# Harness Setup -- OpenCode against Together AI, proven live on this pier

**Language:** EN
**Style:** Gauge Field, Civic register (name what each choice rewards), TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- a working setup, proven live, not wired into any tracked automation
**Last updated:** `20260920.202705`
**Kin:** [`README.md`](README.md) - [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) - [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) (region evidence updated this same round) - [`../.claude/rules/open-weight-companions.md`](../.claude/rules/open-weight-companions.md)

---

## What this page proves, in one line

**OpenCode, pointed at Together AI, running `deepseek-ai/DeepSeek-V4-Pro-0813`, answered a real
prompt on this pier this round.** Every step below is the exact path taken to get there, kept
rather than summarized, so a reader can reproduce it or spot where their own attempt diverges.

## Part 1: the harness, and the choice behind it

**OpenCode** is this page's recommendation -- the most-used open coding harness in the world by
its own research (see [`../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md)),
and it carries Together AI as a first-class, named provider rather than an afterthought.

**The choice, if you have one:** [`Aider`](https://aider.chat) is the lighter alternative --
smaller, simpler, and the cleanest single object to study end to end. It is also packaged in
nixpkgs (`aider-chat`, version `0.86.1`, confirmed) and reads the exact same `TOGETHER_API_KEY`
environment variable this page already sets, since Aider is LiteLLM-backed and treats Together as
an OpenAI-compatible endpoint under the model name `together_ai/<model>`. Reach for OpenCode for
a fuller terminal-agent experience with session management and a web view; reach for Aider for a
smaller, more auditable surface.

## Part 2: install, on this pier specifically

`opencode` is packaged in nixpkgs at `1.15.10` -- confirmed genuinely fetchable
(`https://cache.nixos.org/np0i6dxmvjzrkfdyqcqy19i3igkrspnk.narinfo` answered HTTP 200) and
confirmed to actually run before being declared. It is now in
`nixos/configuration.nix`'s `environment.systemPackages`, reachable on `PATH` after a rebuild the
same way `hf` and `llm` already are.

**The version gap, named rather than hidden:** upstream's own newest tag is `v2.0.11` as of
`2026-09-20`; nixpkgs' `nixos-26.05` branch carries `1.15.10`, one major version behind. This is
the same honest gap `configuration.nix`'s own kakoune comment names for that tool -- a future
overlay lap, not attempted here without a tested source hash.

## Part 3: configuration, the two files this needs

**`~/.config/opencode/opencode.json`** -- tracked nowhere, personal, declares Together as a
provider and names the default model:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "together": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Together AI",
      "options": { "baseURL": "https://api.together.ai/v1" },
      "models": {
        "deepseek-ai/DeepSeek-V4-Pro-0813": { "name": "DeepSeek V4 Pro" }
      }
    }
  },
  "model": "together/deepseek-ai/DeepSeek-V4-Pro-0813"
}
```

**`~/.local/share/opencode/auth.json`** -- the credential, in OpenCode's own documented schema
for an API-key provider (`{ type: "api", key: string }`), written directly rather than through
the interactive `/connect` picker, which reads raw terminal keystrokes and does not accept a
piped answer cleanly:

```json
{ "together": { "type": "api", "key": "$TOGETHER_API_KEY" } }
```

`chmod 600` both files -- the same discipline `~/.bashrc` already keeps for the raw key.

## Part 4: the live proof

```sh
opencode run 'reply with exactly the word: opencode-together-live' -m together/deepseek-ai/DeepSeek-V4-Pro-0813
```

Answered, this round, on this pier: `opencode-together-live`. Model, provider, harness, and pier
all confirmed in one call.

## Part 5: the model, and the choice behind it

**DeepSeek V4 Pro (`deepseek-ai/DeepSeek-V4-Pro-0813`)** is this page's recommended starting
model, for the same reason [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md) named it: MIT-licensed,
leads raw SWE-bench Verified, and its own team ships a harness built around exactly this
agent-plus-tool-loop shape.

**The choice, if you have one:** `zai-org/GLM-5.3`, confirmed live in Together's own catalog this
round and confirmed to answer a real call, is the alternative -- current top open-weight score
overall on the Artificial Analysis Intelligence Index, permissively licensed. Reach for DeepSeek
V4 Pro for coding-specific strength already proven on a named benchmark; reach for GLM-5.3 for the
highest general-purpose score among the models this room has studied.

## Part 6: the US-datacenter question, answered on metal rather than by policy

[`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) named Together AI's default tier as
US-datacenter *by policy*. This round found a way to check it *by measurement*: Together's own
API response carries an `x-request-id` header (and repeats the same tag inside the JSON body's
own `id` field) shaped `<uuid>-aws_<region>`. Four live calls this round -- two to DeepSeek V4 Pro,
one to DeepSeek V4 Pro again, one to GLM-5.3 -- answered `aws_ue1` once and `aws_ue2` three times.
Both are AWS US regions: `us-east-1` (Virginia) and `us-east-2` (Ohio). Re-run this to check for
yourself, any time:

```sh
curl -s -X POST "https://api.together.ai/v1/chat/completions" \
  -H "Authorization: Bearer $TOGETHER_API_KEY" -H "Content-Type: application/json" \
  -d '{"model":"deepseek-ai/DeepSeek-V4-Pro-0813","messages":[{"role":"user","content":"hi"}],"max_tokens":5}' \
  | grep -oE '"id":"[a-f0-9-]+-aws_[a-z0-9]+"'
```

**This does not prove every request lands in a US region, every time, forever** -- four samples
are four samples, not a guarantee, and Together's own routing may draw from a wider pool under
load or over time. What it proves is that the stated default held on real, timestamped calls made
this round, which is stronger evidence than the policy alone and weaker evidence than a formal,
audited SLA. [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) is being updated in this same
round to carry this finding forward.

## Part 7: what this page does not do

**Does not wire OpenCode into any fleet-loop script or tracked automation.** This is a working
setup on one pier's own `$HOME`, proven live, and nothing more.

**Does not overlay OpenCode to its latest upstream version.** The version gap is named, not
closed, per Part 2.

**Does not claim the US-region evidence is a guarantee.** Per Part 6, four samples describe four
samples.

## Sources

- [Providers | OpenCode](https://opencode.ai/docs/providers/)
- [OpenCode Custom Provider Setup](https://haimaker.ai/blog/opencode-custom-provider-setup/)
- [Models and API keys | aider](https://aider.chat/docs/troubleshooting/models-and-keys.html)
- [OpenAI compatible APIs | aider](https://aider.chat/docs/llms/openai-compat.html)
