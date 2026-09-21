# Provider Setup -- reaching an open-weight model from this pier

**Language:** EN
**Style:** Bhakta opening, Gauge Field body -- Civic register (name what a pricing model rewards), TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- practical setup instructions for a provider this tree does not yet call from any tracked code
**Last updated:** `20260920.192026`
**Kin:** [`README.md`](README.md) - [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md) - [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) (why Together AI is this page's default demo) - [`PROVIDER_COMPARISON.md`](PROVIDER_COMPARISON.md) - [`../.claude/rules/open-weight-companions.md`](../.claude/rules/open-weight-companions.md) - [`../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md)

---

## Part 1: one worked example, and why this page picked it

Every large language model lives somewhere -- on a company's own servers, reachable through that
company's own API. If you want to talk to GLM, you go to Zhipu's endpoint. If you want DeepSeek,
you go to DeepSeek's. Some companies also let another company re-serve those same weights from
their own hardware, since open weights are a published file rather than a locked service.

**This page walks through one provider concretely, Together AI, and names where the others
differ rather than repeating the whole walkthrough four times.** Together AI earns the demo slot
for a checkable reason: [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) found it US-datacenter
by default on its standard tier, with no extra setup needed to satisfy that policy, and
[`PROVIDER_COMPARISON.md`](PROVIDER_COMPARISON.md) found its billing per-token rather than
per-hour -- the simplest, lowest-risk combination among every provider this room has researched.
**Every other provider follows a similar shape -- sign up, get a key, call an endpoint -- with its
own base URL, its own model-naming convention, and its own small differences**, named in Part 4
below rather than left for a reader to guess at.

## Part 2: getting a key, step by step

1. Visit `together.ai` and create an account.
2. Add a payment method. Together AI charges per token on its standard tier, usage-based, with
   no subscription required to start.
3. Open the API Keys page from the account settings and click **Create**.
4. **Copy the key the moment it appears.** Most providers, Together AI included, show a key
   exactly once; if it is missed, the only recovery is creating a new one.

## Part 3: setting up on this pier

Store the key as an environment variable, never hardcoded into a file this tree tracks -- the
same discipline `GLOW_PROFILE.kyri` already keeps for every other personal credential:

```sh
export TOGETHER_API_KEY="..."
```

Add that line to the shell profile this pier actually sources (`~/.bashrc`, `~/.zshrc`, or the
ai-jail's own env passthrough), so the key survives past one terminal session without ever
landing in a tracked file.

**Verify the connection with a plain `curl` call first.** No install, no dependency, and it
proves the key and the network path work before anything more elaborate is built on top of them:

```sh
curl -X POST "https://api.together.ai/v1/chat/completions" \
  -H "Authorization: Bearer $TOGETHER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-ai/DeepSeek-V4-Pro-0813","messages":[{"role":"user","content":"hi"}]}'
```

A reply carrying a `choices` array means the key and the path both work. An HTTP 401 means the
key; anything else means the network or the request shape, and the response body usually says
which.

**A real key stays outside this repository entirely.** The safe home for it is a shell profile
(`~/.bashrc` or `~/.zshrc`) at the *user's* home directory, never a file this tree tracks, and
never a file this tree gitignores either -- a gitignored file can still be staged with `-f` by an
absent-minded hand, where a file outside the working tree cannot. A key pasted into a chat
session, a Slack message, or any channel not built to carry secrets is worth rotating on the
provider's own dashboard afterward, the same way a physical key gets a new lock once its copy has
passed through an uncertain hand.

**The seed's own scrub reads for this shape.** `tools/fixtures/s/sow_personal_scan.sh` widened
`20260920` to catch OpenRouter, Anthropic, OpenAI, GitHub, and AWS credential shapes, proven able
to red on a planted secret by `tools/fixtures/s/sow_personal_control.sh` before the widening was
trusted -- the same "a guard that cannot red guards nothing" standard this tree already holds
every other wall to. Together AI's own keys carry no fixed public prefix the way `sk-or-v1-`
does, so a Together key would not match that pattern today; the placeholder above (three literal
dots) stays honestly short of any pattern regardless.

**Look up exact model slugs rather than typing a guess.** Together AI model identifiers follow the
shape `vendor/ModelName`, and the exact slug for a given model changes as providers version their
own releases -- `deepseek-ai/DeepSeek-V4-Pro-0813` carries its own release date in its own name.
Ask the API directly rather than trusting a slug written down somewhere else:

```sh
curl -s https://api.together.ai/v1/models -H "Authorization: Bearer $TOGETHER_API_KEY" \
  | grep -i '"id".*\(glm\|qwen\|deepseek\|kimi\)'
```

**A named CLI was tried, and found not to hold up on this pier.** Simon Willison's `llm` tool has
two candidate Together plugins, `llm-together` and `llm-togetherai`; both were tested this round
via `nix-shell -p '(python313Packages.llm.withPlugins { ... })'`, and both built without loading
-- `llm plugins` returned an empty list either way, meaning neither is genuinely packaged for this
attribute on this pier today. **The plain `curl` call above stays the reliable path here**, and
it happens to be the same path Together AI's own documentation leads with regardless of host.

**On this pier specifically, `pip` does not exist at all** -- this is a declared NixOS host
([`../.claude/rules/declared-host-config.md`](../.claude/rules/declared-host-config.md)). A host
with a plain `pip` can still try `pip install llm-together` or `pip install llm-togetherai`
directly, which may succeed where the Nix package attribute did not; that path was not tested
this round, since it needs a non-Nix host to try honestly.

## Part 4: similar, but a little different -- the other providers

Every provider in this room follows the same three-step shape -- sign up, get a key, call an
endpoint -- and each one changes exactly three things: the base URL, the model-slug format, and
the environment-variable name. Once one provider is set up, reading the other three takes minutes
rather than a fresh start.

| Provider | Base URL | Env var | Model slug shape |
|---|---|---|---|
| **Together AI** (this page's demo) | `https://api.together.ai/v1` | `TOGETHER_API_KEY` | `vendor/ModelName`, e.g. `deepseek-ai/DeepSeek-V4-Pro-0813` |
| **OpenRouter** | `https://openrouter.ai/api/v1` | `OPENROUTER_API_KEY` | `author/slug`, e.g. `openai/gpt-4o` |
| **Hugging Face, Inference Providers** | routes through `huggingface.co`'s own router -- see [`PROVIDER_COMPARISON.md`](PROVIDER_COMPARISON.md) | `HF_TOKEN` | `org/model-name`, matching the model's own Hub repository name |
| **Hugging Face, Inference Endpoints** | one URL per deployed endpoint, chosen at deploy time | `HF_TOKEN` | not applicable -- one endpoint serves one deployed model |

**OpenRouter's own curl call, for direct comparison:**

```sh
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"openai/gpt-4o","messages":[{"role":"user","content":"hi"}]}'
```

Civic style asks what each provider's own shape actually rewards, and the answer differs by
provider rather than by this page's own preference:

| Provider | What it rewards | Best fit |
|---|---|---|
| **Together AI** | US-datacenter-by-default, per-token billing, breadth (100+ models) | the workload this page demos toward: simple, US-only, low-risk to leave running |
| **OpenRouter** | choice itself -- one integration reaching many backends | comparing models, or a workload whose best-fit model is not yet known |
| **Groq** | raw speed on a curated model list | a latency-sensitive workload built around a model Groq already hosts |
| **Fireworks AI** | developer experience -- structured output, function calling, agent tooling | building an agent or tool-calling harness rather than a single-turn chat |
| **Hugging Face** | either a no-markup router (Inference Providers) or an explicit, audited US region (Inference Endpoints) | the router for exploration, the dedicated endpoint once compliance rigor is actually needed |

None of these rewards is wrong; each is honest about what it optimizes for, and a workload that
knows what it needs should read this table and pick accordingly rather than defaulting to
whichever name is most familiar.

## Part 5: verify before trusting, the TAME lens

Every claim above was checked against a live source before landing on this page, per
[`docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md)'s own discipline --
assert it, don't assume it. The same habit applies to whatever a reader does next: run the `curl`
call in Part 3 before writing a single line of integration code, and re-run the model-lookup call
before trusting any slug this page or any other page names, since a provider's own catalog is the
one place a slug is guaranteed current.

**Nothing on this page is wired into this tree.** No fleet-loop script calls Together AI, or any
other provider named here, today. This page is exactly what
[`open-weight-companions.md`](../.claude/rules/open-weight-companions.md) already asks for -- the
standard and the setup path written down ahead of the day either is needed, so that day is met
with a working `curl` call already proven rather than one first typed under pressure.

May whichever model a reader reaches through this door answer as honestly as the question it was
asked, and may the key that opens it stay exactly as private as the hand that holds it.

## Sources

- [Together AI Quickstart](https://docs.together.ai/docs/quickstart)
- [DeepSeek models | Together AI](https://www.together.ai/models-providers/deepseek)
- [Qwen Models on Together AI](https://www.together.ai/models-providers/qwen)
- [llm-together | GitHub](https://github.com/wearedevx/llm-together)
- [llm-togetherai | PyPI](https://pypi.org/project/llm-togetherai/)
- [OpenRouter Quickstart Guide](https://openrouter.ai/docs/quickstart)
- [Discover models | OpenRouter](https://openrouter.ai/discover)
- [Top 5 AI Inference and Model Hosting Platforms (2026)](https://guptadeepak.com/tools/top-5-ai-inference-model-hosting-platforms-2026/)
- [Groq vs. Together AI vs. Fireworks AI: Fast LLM Inference 2026](https://pristren.com/blog/groq-vs-together-ai-vs-fireworks/)
