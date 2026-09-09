# REDS -- the template and its admission

**Language:** EN
**Style:** Gauge, Meter
**Status:** Closed record -- checkable
**Stamp:** `20260909.030305`

A file's classification says how it may be prepared. The allowlist decides whether it enters the public seed.

---


**REDS %656 (`20260909.030305`) -- a template classification was described as seed admission.** *What went wrong:* `SOURCE.md` linked `nixos/configuration.nix` and said it shipped with the seed. `template-manifest.bron` classified `nixos` as `template` and excluded `nixos/local.bron`, yet carried no `allow nixos` entry. The projector and link scan both read that allowlist, so the configuration remained withheld. *What caught it:* the cold roster's `seed_link` red, at 849 living links outside the seed against a ceiling of 848; an expanded diagnostic named the new SOURCE link. *What it taught:* classification and admission answer different questions. Check the allowlist before promising a file to a seed reader. *Repaired (`20260909.030305`):* SOURCE names the file as part of the working repository and states that the public seed currently withholds its directory. The admission boundary stays intact; the configuration still carries personal SSH comment labels beside its placeholders, so admission deserves its own verification. `seed_link_witness` is GREEN on metal, its control proves both outcomes, and the count returns to 848. **CLOSED.**
