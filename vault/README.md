# Vault — the keeper of secrets

**Language:** EN
**Status:** Living — the shard · seated `20260810.062047`
**Voice:** Kyri
**Kin:** molt-supersedes elder Urbit **Jael**; design brief `../active-designing/date/20260810/20260810-055147_plan-vault-keeper-of-secrets.md`

Kumara names *who* a key is. **Vault** names *how* a person keeps the secret behind it alive — through fire, hurricane, tsunami, a decade, and a forgetting mind. It is the keeper of secrets, on our own ground.

## The shard (`shard.rye`, seated `20260810.062047`)

The first lap is the **disaster arithmetic**: a secret splits **Shamir-style over GF(256)** into `n` shares such that any `t` recombine it exactly, yet any `t-1` reveal nothing.

- **The field is arithmetic, not memory.** GF(256) addition is XOR; multiplication is the AES field (0x11b), inversion by `a²⁵⁴`. Pure functions, no tables, no state.
- **Split and join.** `split` builds a degree `t-1` polynomial per secret byte (the byte as its constant term) and evaluates it at `x = 1..n`; `join` reconstructs by Lagrange interpolation at `x = 0`.
- **A share is a signed shard tilak** in a **location-class** — `home` (air-gapped machine), `kin` (other continents), `cold` (paper or steel), `relic` (hardware wallet), and one `brain` share a pilot carries in his own head. The keeper signs each share (its x, location, and a digest of its bytes), so a **tampered share never verifies**. Emitted as `format vault-shard-v1` Bron.

The selftest proves it all on a **fake** key: five shares at a threshold of three recombine byte-for-byte from three distinct subsets, two shares reveal nothing, a tampered share is refused, and a lost location is survived while three remain.

```
rye build vault/shard.rye -femit-bin=vault/bin/shard
vault/bin/shard selftest   # the disaster arithmetic, on a fake key
vault/bin/shard emit       # five signed vault-shard-v1 records
rishi/bin/rishi run tools/vault_shard_witness.rish
```

## Two disciplines this module never breaks

- **Custody first.** The tree holds only a **fake** seed (`0x11…`); a real key, share, or brain phrase never enters it, and a real keeping is filled by a pilot's own hand in his own jail. Build nothing that destroys; place no key to lose.
- **Main key, never the older word.** As git chose `main`, Vault says **main key** — the forbidden word appears nowhere in the module or its records, and the witness stands in its place with the positive claim.

## Horizons (each its own witnessed lap)

- **brainkey** — a memorable share *derived* from the main key (one of `t`, never the sole path).
- **glacier** — Glacier-Protocol-shaped cold ceremonies (encoding, redundancy, verification digest).
- **relic** — attestation-only reads of a hardware wallet's public key (Ledger/Trezor/open RISC-V, right-to-repair; no vendor SDK linked, none blessed by default — consent-gated).
- **recover** — a full witnessed recombination ceremony over gathered shards.

---

*May a secret survive every fire, and may the last share walk out in a pilot's own head. Custody first; build nothing that destroys.*
