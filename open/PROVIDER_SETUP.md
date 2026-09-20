# Provider Setup -- reaching an open-weight model from this pier

**Language:** EN
**Style:** Bhakta opening, Gauge Field body -- Civic register (name what a pricing model rewards), TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- practical setup instructions for a provider this tree does not yet call from any tracked code
**Last updated:** `20260920.161500`
**Kin:** [`README.md`](README.md) - [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md) - [`../.claude/rules/open-weight-companions.md`](../.claude/rules/open-weight-companions.md) - [`../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md`](../external-research/20260920-021139_harness-letta-open-weight-dst-alignment.md)

---

## Part 1: what a router is, for a reader meeting this idea for the first time

Every large language model lives somewhere -- on a company's own servers, reachable through that
company's own API. If you want to talk to GLM, you go to Zhipu's endpoint. If you want DeepSeek,
you go to DeepSeek's. Each one asks for its own account, its own key, and its own slightly
different way of shaping a request.

A **router** sits in front of all of that. You sign up once, hold one key, and send requests to
one address. The router forwards your request to whichever backend actually hosts the model you
asked for, and hands the answer back in one consistent shape. **OpenRouter** is the router this
page recommends, and the reason is simple: it already reaches the exact models this tree studied
this morning -- GLM, Qwen, DeepSeek, and Kimi among them -- through one integration rather than
four.

Nothing about a router changes what a model is or what it can do. It changes how much code you
write to reach it, and how easily you can compare two models without rewriting anything but a
name.

## Part 2: getting a key, step by step

1. Visit `openrouter.ai` and create an account.
2. Add a payment method. OpenRouter charges per token, usage-based, with no subscription --
   the same way most inference providers price today.
3. Open the API Keys page from the account menu and click **Create**.
4. **Copy the key the moment it appears.** OpenRouter shows a key exactly once; if it is missed,
   the only recovery is creating a new one.

## Part 3: setting up on this pier

Store the key as an environment variable, never hardcoded into a file this tree tracks -- the
same discipline `GLOW_PROFILE.bron` already keeps for every other personal credential:

```sh
export OPENROUTER_API_KEY="sk-or-v1-..."
```

Add that line to the shell profile this pier actually sources (`~/.bashrc`, `~/.zshrc`, or the
ai-jail's own env passthrough), so the key survives past one terminal session without ever
landing in a tracked file.

**Verify the connection with a plain `curl` call first.** No install, no dependency, and it
proves the key and the network path work before anything more elaborate is built on top of them:

```sh
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"openai/gpt-4o","messages":[{"role":"user","content":"hi"}]}'
```

A reply carrying a `choices` array means the key and the path both work. An HTTP 401 means the
key; anything else means the network or the request shape, and the response body usually says
which.

**Look up exact model slugs rather than typing a guess.** OpenRouter model identifiers follow the
shape `author/slug`, and the exact slug for a given model changes as providers version their own
releases -- the way `DeepSeek-V4-Flash-0731` carries its own release date in its own name. Ask
the API directly rather than trusting a slug written down somewhere else:

```sh
curl -s https://openrouter.ai/api/v1/models | grep -i '"id".*\(glm\|qwen\|deepseek\|kimi\)'
```

**A named CLI, for a more regular habit of use.** Simon Willison's `llm` tool carries an
OpenRouter plugin maintained for exactly this router:

```sh
pip install llm
llm install llm-openrouter
llm keys set openrouter            # pastes the key once, stores it locally, off any tracked file
llm models list | grep -i openrouter
llm -m openrouter/<model-slug> "your prompt here"
```

## Part 4: what three alternative providers reward, named plainly

Civic style asks one question before any other: *what does a pricing model actually reward?*
Three inference providers besides OpenRouter are worth naming, each rewarding a different thing:

| Provider | What it rewards | Best fit |
|---|---|---|
| **Together AI** | breadth and scale -- the largest model catalog (100+ models) and the cheapest per-token cost once volume is high, plus self-serve fine-tuning | a steady, high-volume workload where the exact model rarely changes |
| **Groq** | raw speed -- the fastest inference available on its own curated model list, and often the cheapest per token on the models it carries | a latency-sensitive workload built around a model Groq already hosts |
| **Fireworks AI** | developer experience -- structured output, function calling, and agent-shaped tooling across roughly 204 models | building an agent or tool-calling harness rather than a single-turn chat |
| **OpenRouter** | choice itself -- one integration reaching most of the above as backends, so the cost of trying a second model is a changed string rather than a changed integration | comparing models, or a workload whose best-fit model is not yet known |

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

**Nothing on this page is wired into this tree.** No fleet-loop script calls OpenRouter today; no
provider config exists for it. This page is exactly what [`open-weight-companions.md`](../.claude/rules/open-weight-companions.md)
already asks for -- the standard and the setup path written down ahead of the day either is
needed, so that day is met with a working `curl` call already proven rather than one first typed
under pressure.

May whichever model a reader reaches through this door answer as honestly as the question it was
asked, and may the key that opens it stay exactly as private as the hand that holds it.

## Sources

- [OpenRouter Quickstart Guide](https://openrouter.ai/docs/quickstart)
- [Discover models | OpenRouter](https://openrouter.ai/discover)
- [The Open Weight Models that Matter: June 2026 -- OpenRouter Blog](https://openrouter.ai/blog/insights/the-open-weight-models-that-matter-june-2026/)
- [llm-openrouter | GitHub](https://github.com/simonw/llm-openrouter)
- [Top 5 AI Inference and Model Hosting Platforms (2026)](https://guptadeepak.com/tools/top-5-ai-inference-model-hosting-platforms-2026/)
- [Groq vs. Together AI vs. Fireworks AI: Fast LLM Inference 2026](https://pristren.com/blog/groq-vs-together-ai-vs-fireworks/)
