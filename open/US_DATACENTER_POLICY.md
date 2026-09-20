# US Datacenter Policy -- open-weight models, hosted and run on US soil

**Language:** EN
**Style:** Civic register (name what the policy rewards), Gauge Field body, Bhakta aside, TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- a policy stated and researched, not yet wired into any tracked code
**Last updated:** `20260920.180500`
**Kin:** [`README.md`](README.md) - [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) - [`HARNESS_RATIONALE.md`](HARNESS_RATIONALE.md) - [`../.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)

---

## The policy, stated plainly

Civic style asks one question first: *what outcome does this policy actually want?* Here, the
outcome is narrow and checkable: **a model's weights run only on hardware owned and operated by
a company incorporated and headquartered in the United States, in a datacenter physically
located inside the United States.** Two conditions, both required, and neither implies the
other.

## Part 1: two axes that get confused, kept apart

**Who trained the model, and who runs it, are two different companies answering two different
questions.** Open weights are a published file -- once GLM, Qwen, DeepSeek, or Kimi releases its
weights, any company with the hardware and the license rights can download that file and serve
it from their own machines, in their own country, under their own legal jurisdiction. A model
trained by a company headquartered outside the United States can still run entirely on
US-incorporated, US-located hardware, because open weights are portable in exactly this way.
This is the whole reason this policy is satisfiable at all -- it asks about the *second* company,
never the first.

**"Completely open-weight" means the full checkpoint is published with no gate, and its license
allows commercial hosting without extra permission.** DeepSeek V4 (MIT) and Qwen3.8's smaller
27B checkpoint (Apache-2.0) both clear this bar outright. GLM-5.3 ships under a permissive
license of its own. Kimi K3 and Qwen3.8's larger checkpoint carry their own named, conditional
licenses -- worth reading in full, per [`gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md)'s
own discipline, before treating either as clear for commercial hosting.

## Part 2: what a router does and does not guarantee

**OpenRouter has no literal country filter.** Its `provider` request field takes `only` (an
allowlist of provider slugs), `order` (a priority list), and `allow_fallbacks` (set `false` to
refuse every provider outside that list) -- but nothing in that shape accepts `"country": "US"`
directly. Enforcing US-only through OpenRouter means naming specific provider slugs you have
already verified are US-incorporated and US-datacenter, then locking `allow_fallbacks` to
`false` so a request never silently reaches an unverified provider when the named ones are busy.

**A US headquarters does not, by itself, prove a US datacenter.** Groq is a real, useful
counter-example rather than a hypothetical one: incorporated in Delaware, headquartered in
Mountain View, California -- and operating thirteen datacenters spanning North America, Europe,
the Middle East, and Asia-Pacific. Routing to "Groq" by company name alone says nothing about
which of those thirteen sites actually answers a given request, unless Groq's own API exposes a
region parameter and that parameter is set every time. **Verify the specific region a request
lands in, not only the company's own mailing address**, per this tree's own TAME lens.

## Part 3: the one candidate researched and verified for explicit region control

**Together AI is the strongest fit found this round, and it earns that place by being
checkable.** Together Computer, Inc. is US-incorporated, headquartered in California. Its
standard, default-tier serverless inference runs from US datacenters; reaching a datacenter
outside the US requires opting into a higher-tier plan and naming that need explicitly during
setup -- so a customer who never asks for EU or other international capacity stays on US soil by
default rather than by hope. Its **dedicated endpoints** go further: a customer chooses the
deployment region outright, under SOC 2 Type II and ISO 27001 certification, which is the kind of
explicit, audited region-pinning this policy actually asks for.

**Groq and Fireworks AI stand as open questions rather than as ruled out.** Groq's own API may
well expose a region parameter that pins a request to its North American sites specifically;
Fireworks AI's own multi-region footprint and any region-selection API were not confirmed this
round. Naming a provider "clear" here without having read that provider's own region-control
documentation would be exactly the unverified claim [`docs-implementation-sync.md`](../.claude/rules/docs-implementation-sync.md)
asks this tree to refuse.

## Part 4: what a compliant request looks like

**Through OpenRouter, pinned hard to a verified provider:**

```json
{
  "model": "deepseek/deepseek-v4",
  "messages": [{"role": "user", "content": "..."}],
  "provider": {
    "only": ["together"],
    "allow_fallbacks": false
  }
}
```

`allow_fallbacks: false` is the load-bearing field -- without it, a busy or unavailable `together`
endpoint lets OpenRouter reach for any other provider that happens to serve the same model,
silently, which is precisely the failure this policy exists to prevent.

**Direct to Together AI's own dedicated endpoint**, once a region has been chosen during setup,
skips the router entirely and removes the fallback question altogether -- one company, one
contract, one named region, with nothing in between to silently substitute.

## Part 5: what this page does not decide

**This page does not choose a provider for you.** It names Together AI as the one candidate
whose region-pinning was verified this round, and names the two open questions (Groq, Fireworks
AI) still wanting their own region-control documentation read before either earns the same
standing. **This page does not audit a provider's own claims independently** -- SOC 2 Type II and
ISO 27001 are the provider's own certifications, cited here as reported, not re-verified against
the underlying audit report.

**Nothing here is wired into this tree.** No fleet-loop script calls any of these providers with
a `provider.only` constraint today; this page states the policy and the research behind it, ahead
of any build.

## Sources

- [Provider Routing -- Smart Multi-Provider Request Management | OpenRouter](https://openrouter.ai/docs/guides/routing/provider-selection)
- [Enforce AI Data Residency at the Routing Layer -- OpenRouter Blog](https://openrouter.ai/blog/insights/ai-data-residency/)
- [Groq | Wikipedia](https://en.wikipedia.org/wiki/Groq)
- [Groq Raises $650M to Scale Its AI Inference Cloud Business](https://groq.com/newsroom/groq-raises-usd650m-to-scale-its-ai-inference-cloud-business)
- [EU Data Centers and Dedicated Model Deployment | Together AI Knowledge Base](https://support.together.ai/articles/8079447813-eu-data-centers-and-dedicated-model-deployment)
- [Dedicated Model Inference | Together AI](https://www.together.ai/dedicated-endpoints)
