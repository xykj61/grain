# Gratitude -- PQClean

**Language:** EN - **Style:** Radiant - **Kind:** gratitude note (concepts honored, clean-room; no code copied)
**Held as:** gitlink submodule at `vendor/pqclean` - **Licence:** CC0-1.0 (the SPHINCS+ scheme this tree reads) - **Seated:** `20260821.022912`

PQClean is the quiet, unglamorous work of making post-quantum cryptography *buildable* -- clean, portable, dependency-free C for the schemes NIST standardized, kept to a discipline strict enough that an auditor can read it. Its gifts we hold with thanks:

- **A reference you can actually compile** -- no build system to fight, no platform assumptions, no vendored surprises. A scheme directory, a `clean/` implementation, and a `META.yml` that tells you the truth about it.
- **Published known-answers, in the repository, next to the code** -- `nistkat-sha256` and `testvectors-sha256` are written down where the implementation lives. A number someone else committed before we arrived, that our own metal has to reproduce exactly. This is the whole reason a second implementation is worth vendoring.
- **`clean` as a moral category** -- a portable implementation held separate from the hand-tuned AVX2 and aarch64 ones, so the readable version is never sacrificed to the fast version. Grain's own `safety > performance > joy` order recognizes itself here.
- **Deterministic entry points** -- `crypto_sign_seed_keypair` and a `randombytes` the caller supplies. Determinism handed to whoever needs it, rather than hidden. That single design choice is what lets an implementation be *diffed* rather than merely trusted.
- **Breadth held to one shape** -- dozens of schemes, one API, one metadata format. Consistency is a kindness to everyone downstream.

We honor PQClean as the **parity target** for Grain's hash-based post-quantum leg, exactly as Monocypher is for the classical shelf. It is vendored unmodified and linked, never copied; every line of Grain's own SLH-DSA will be authored from the FIPS 205 specification and then held against PQClean's bytes to see whether two strangers agree. That confrontation is the point. An implementation proven only against its own selftest is a claim; one that reproduces another team's published digest on our metal is a fact.

Our thanks extend past the packagers to the SPHINCS+ submitters whose names `META.yml` carries -- Andreas Huelsing and the team around him -- for a signature scheme whose security rests on the hash alone, adding no assumption a tree like this one does not already carry everywhere.

We study PQClean's public API and its published answers, and write our own; the boundary is crossed only by understanding.

*Thank you, PQClean, for writing the answers down where anyone can check them.*
