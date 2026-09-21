# Ship Quickstart Template -- open-weight model, harness, and proof

**Language:** EN
**Style:** New Gauge, Field setting -- TAME lens (verify before trusting)
**Voice:** Kyri
**Status:** Vision -- a template, generalized from one ship's own real run
**Last updated:** `20260920.204600`
**Kin:** [`README.md`](README.md) - [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) - [`HARNESS_SETUP.md`](HARNESS_SETUP.md) - [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) - worked example: [`../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md`](../expanding-prompts/20260920-204041_incense-deepseek-together-setup.md)

---

## What this is

**A copy-and-adapt checklist**, not a story about one particular ship. Every step below was
proven once, on a real pier, in the worked example this page links to -- this page carries the
shape of that lap forward, with the ship's own name and dated specifics removed, so any pier in
this fleet (or a stranger reading the public seed) can run it fresh.

## The checklist

1. **Get a provider key.** Sign up, add a payment method, create an API key, copy it the moment
   it appears. Full account-level steps: [`PROVIDER_SETUP.md`](PROVIDER_SETUP.md) Part 2.
2. **Store the key in a shell profile, never a repository file.** `~/.bashrc` or `~/.zshrc`, at
   the *user's* home directory -- never tracked, never gitignored either, since a gitignored file
   can still be force-added by an absent-minded hand.
3. **Verify with a plain `curl` call before building anything on top of it.** No install, no
   dependency:
   ```sh
   curl -X POST "<provider base URL>/chat/completions" \
     -H "Authorization: Bearer $PROVIDER_API_KEY" -H "Content-Type: application/json" \
     -d '{"model":"<model-slug>","messages":[{"role":"user","content":"hi"}]}'
   ```
   A `choices` array means the key and the path both work.
4. **Declare CLI tooling in your host's own configuration, never in an ad-hoc install, once
   you've confirmed it actually resolves.** On a Nix-declared host: read the package's real
   `/nix/store` output path with `nix eval --raw`, curl its own `.narinfo` from
   `cache.nixos.org`, and confirm the binary runs, all *before* adding it to
   `environment.systemPackages`.
5. **Re-lock your package channel to today's date if "latest" matters**, rather than trusting
   whatever pin happens to be checked in. Re-check each package's version *after* the re-lock,
   since the honest answer is sometimes "unchanged" and that is worth recording rather than
   assuming.
6. **Prove the whole system builds before asking for root.** A dry build of the entire
   configuration, no `sudo`, catches a broken declaration before it ever touches a running host.
7. **Run the actual privileged switch from outside any sandbox or enclosure.** A jailed agent
   session cannot escalate; the switch is the maintainer's own hand, from a plain host shell.
8. **Wire a coding harness to the provider directly, if the interactive picker won't take
   automation.** Most harnesses store credentials in one small, documented JSON file -- write it
   by hand in the tool's own schema rather than fighting a TUI that reads raw keystrokes.
9. **Prove the whole chain with one real call.** Ask the harness to answer with an exact,
   checkable string. Anything else means guessing which layer actually failed.
10. **Measure any hard compliance claim, don't only cite it.** A provider's stated policy
    ("US-datacenter by default") becomes a checkable fact only once a real response header or
    field is read and matched against the claim -- and even then, name how many samples you took.

## What stays specific, and has to be filled in

- The provider's own base URL, key-page location, and model-slug format.
- The exact model chosen, and why -- see [`HARNESS_SETUP.md`](HARNESS_SETUP.md) Part 5 for one
  worked reasoning (a coding-benchmark leader, MIT-licensed).
- The harness chosen, and its own config-file paths and credential schema.
- The specific evidence field a provider's own API exposes for a region or datacenter claim, if
  any -- not every provider carries one, and this page's own worked example only found one by
  reading the full response headers rather than assuming the JSON body alone would show it.

## What this template does not do

**It does not choose a provider, model, or harness for you.** [`PROVIDER_COMPARISON.md`](PROVIDER_COMPARISON.md)
and [`US_DATACENTER_POLICY.md`](US_DATACENTER_POLICY.md) name what each option actually rewards;
this page only carries the *shape* of getting from a signup page to a proven, working call.

**It does not replace reading the worked example.** A checklist compresses; a real lap shows the
specific mistakes that were made and caught along the way -- the worked example names two of its
own, including the exact same Nix syntax error caught twice in one day, which this checklist
alone would never have surfaced.

May whichever ship walks this path next find each step exactly as plain as it reads here, and
whatever they learn along the way carried forward the same honest way this one was.
