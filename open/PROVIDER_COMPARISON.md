# Provider Comparison -- finances and ops, tested on this pier

**Language:** EN
**Style:** Gauge Field, Civic register (name what each billing model rewards), TAME lens (verified on metal, not assumed)
**Voice:** Kyri
**Status:** Vision -- a comparison researched and tested this round, not wired into any tracked code
**Last updated:** `20260920.190528`
**Kin:** [`README.md`](README.md) - [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) - [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md)

---

## Part 1: two financial shapes, not one

Civic style asks what a billing model actually rewards. Across OpenRouter, Together AI, and
Hugging Face, exactly two shapes exist, and mistaking one for the other is the single costliest
error a newcomer can make:

- **Per-token billing** -- pay only for what a request actually consumes. Idle time costs
  nothing. OpenRouter, Together AI's serverless tier, and Hugging Face's **Inference Providers**
  all bill this way.
- **Per-hour-of-uptime billing** -- rent a GPU for as long as it stays warm, whether or not a
  request arrives. Together AI's dedicated endpoints and Hugging Face's **Inference Endpoints**
  both bill this way, and **Inference Endpoints bills always-on**: a minimum replica count of 1
  means the hourly rate runs 24 hours a day, every day, until the endpoint is explicitly paused
  or deleted. A dedicated endpoint left running over a quiet weekend is exactly the failure mode
  this shape rewards a careless hand toward.

## Part 2: the numbers, as measured

| Provider / product | Billing shape | What it actually costs |
|---|---|---|
| OpenRouter | per-token | the router's own published per-model rate |
| Together AI, serverless | per-token | roughly $0.18-0.88 per million tokens, by model size, at mid-2026 rates |
| Together AI, dedicated endpoints | per-GPU-hour | priced per instance type, region-pinned |
| **Hugging Face, Inference Providers** | per-token | **passes through the partner provider's own rate with no markup** -- it is a router in front of Together, Groq, Fireworks, and others, the same shape OpenRouter carries |
| **Hugging Face, Inference Endpoints** | per-GPU-hour, billed by the minute | **$0.033/hr (CPU) up to $10/hr (GCP H100)**, with T4 at $0.50, L4 at $0.80, A10G at $1.00, A100 at $2.50 (AWS) / $3.60 (GCP), AWS H100 at $4.50, B200 at $9.25 |

Hugging Face's "no markup" claim on Inference Providers is worth naming plainly as a real
financial edge over a router that keeps its own margin, and worth reading its current fee
schedule directly before relying on it -- a stated policy and a billed invoice are two different
things, and this page cites the policy as reported rather than as independently reconciled
against a real bill.

## Part 3: ops, tested on this actual pier rather than assumed

`curl` reaches every one of these APIs with zero setup, on any host -- the one universal path,
and per [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) Part 3, the most reliable one on this pier
specifically.

**Hugging Face's own CLI, `hf`, needed a real install path found rather than guessed.** The
common instruction -- `pip install huggingface_hub` -- fails outright on this pier: there is no
bare `pip`, `pipx`, or `uv` here at all, since this is a declared NixOS host. The command that
actually works, run live this round:

```sh
nix-shell -p python313Packages.huggingface-hub --run "hf --version"
```

That pulled and confirmed `hf` version `1.16.0` from nixpkgs' own cache -- one version behind
PyPI's `1.32.0` at the time of this reading, since nixpkgs pins its own snapshot rather than
tracking PyPI live.

**The `llm` CLI's OpenRouter plugin needed the same kind of correction**, and it surfaced a bug
already shipped in [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md): that page's own `pip install llm`
step has the identical failure on this pier. Worse, `llm`'s own imperative `llm install <plugin>`
step is **disabled entirely** under Nix, printing its own message that plugins are declared
through `llm.withPlugins` instead of installed one at a time. The corrected, verified command:

```sh
nix-shell -p '(python313Packages.llm.withPlugins { llm-openrouter = true; })' --run "llm plugins"
```

`llm plugins` confirmed `llm-openrouter` loaded and ready. `PROVIDER_SETUP.md` now carries this
same correction in its own Part 3.

**Neither Together AI nor OpenRouter needs a CLI at all** -- both are REST-first, and their own
documentation leads with `curl` or an OpenAI-SDK-shaped client rather than a bespoke tool. Hugging
Face is the one provider in this comparison with a genuine first-party CLI worth learning, and the
one whose install path most needed checking on this particular pier.

## Part 4: the US-only angle, since that policy is live

[`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) names Together AI's dedicated endpoints as
the one verified candidate for explicit US region-pinning. Hugging Face's **Inference Endpoints**
belongs beside it, and arguably ahead of it: Hugging Face, Inc. is Delaware-incorporated,
headquartered in Brooklyn, New York, and Inference Endpoints supports deployment to four named
regions -- `AWS us-east-1`, `Azure eastus`, `GCP us-east4`, and one EU option, `AWS eu-west-1`.
Three of four are US regions, named as literal, documented flags rather than an opt-in reached
through a sales conversation, which is a cleaner fit for a policy that wants a checkable region
name over a provider's word alone.

**Hugging Face's Inference Providers inherits OpenRouter's own weakness**, and the reasoning is
identical: it is a router in front of Together, Groq, Fireworks, and other partners, so pinning it
to a US-only guarantee needs the same per-provider verification `US_DATACENTER_POLICY.md` already
names as OpenRouter's own open question.

## Part 5: what this page does not decide

**This page does not choose a winner.** It gives the numbers and the tested commands so a later
decision is made against measurement rather than brand recognition. **Hugging Face's exact
per-token rates for GLM, Qwen, DeepSeek, and Kimi specifically were not confirmed this round** --
the "no markup" policy is confirmed, the underlying partner rate for each named model is not, and
naming a dollar figure without that check would be exactly the unverified claim
[`docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md) asks this tree to
refuse.

## Sources

- [Hugging Face Inference Endpoints Pricing 2026 | Spheron Blog](https://www.spheron.network/blog/hugging-face-inference-endpoints-pricing-2026/)
- [Inference Endpoints (dedicated) documentation -- pricing](https://huggingface.co/docs/inference-endpoints/support/pricing)
- [Inference Endpoints (dedicated) documentation -- access and regions](https://huggingface.co/docs/inference-endpoints/main/guides/access)
- [Hugging Face | Wikipedia](https://en.wikipedia.org/wiki/Hugging_Face)
- [EU Data Centers and Dedicated Model Deployment | Together AI Knowledge Base](https://support.together.ai/articles/8079447813-eu-data-centers-and-dedicated-model-deployment)
