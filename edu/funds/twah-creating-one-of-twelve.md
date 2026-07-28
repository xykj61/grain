# Creating One of the Twelve — Page One (Twah)

**Language:** EN  
**Stamp:** `20260728.014523`  
**Voice:** Quin · nested frame Trey  
**Fund seat:** **Twah** — Taurus · earth · seat 2 · `%twah` · domain prep **twah.fund**  
**Status:** Steps **1–6 taught and witnessed** · Twah fund-prep arc **m5–m8 CLOSED** (`20260728.015058`)  
**Generator:** [`../../tools/gen_twah_fund_prep.rish`](../../tools/gen_twah_fund_prep.rish)

*Twah's gift under the fund seat: the edu-series tutorial for creating one of the twelve.*
Radiant pass `20260728.015058` — step 6 refuse-walk · Twah m5–m8 closed
Radiant pass `20260728.014918` — deepen steps 4–5 · phone book · Comlink knock
Radiant pass `20260728.014737` — deepen steps 1–3 · gen-twah witnesses

---

## What this page teaches

How a new fund joins the constellation wheel: a **four-letter** name, a **`.fund`** DNS anchor, a tropical seat, and honest prep that never pretends a wallet exists before Keaton's hand.

## Walk map

| Step | Meaning | Standing |
|------|---------|----------|
| **1** | Choose a four-letter fund name that fits Civic Style | **taught · witnessed m6** |
| **2** | Hold a **`.fund`** domain (elder anchoring rule) | **taught · witnessed m6** |
| **3** | Know the tropical seat (Twah = Taurus · index 1) | **taught · witnessed m6** |
| **4** | Read the phone book — registry-only, **mints nothing** | **taught · witnessed m7** |
| **5** | Knock Comlink before any seating byte | **taught · witnessed m7** |
| **6** | Refuse live deploy · wallet · gas from a tutorial page | **taught · witnessed m8** |

**arc: Twah m5–m8 CLOSED** at the refuse-walk.

---

## Step 1 — four-letter name (Civic Style)

A fund name on this wheel is **exactly four ASCII letters**, lowercase in vane form (`%twah`), title case in prose (**Twah**). The shape matches the house habit of short, speakable names (vanes, waymarks, modules) without borrowing a waymark draw for the fund itself.

**Worked example — Twah:**

| Check | Result |
|-------|--------|
| Letters | `T` `w` `a` `h` — length **4** |
| Alphabet | ASCII letters only |
| Civic Style | Public-benefit posture: teaching how seats join the wheel, not extracting rent from the lesson ([`../../context/CIVIC_STYLE.md`](../../context/CIVIC_STYLE.md)) |
| Distinct hats | Twah the **fund** ≠ any module token |

**witness:step1** four-letter name shape + Civic Style named — GREEN when gen-twah passes.

---

## Step 2 — `.fund` DNS anchor

Elder anchoring rule: a wheel entrant holds a **`.fund`** domain so the old world's name system vouches for the new seat. The domain is **prep until claimed**; counsel never purchases it.

**Worked example — twah.fund:**

| Check | Result |
|-------|--------|
| Anchor form | `twah.fund` — name + `.fund` |
| Claim | **Keaton's hand alone** |
| Tutorial duty | Teach the rule; never run the registrar |
| Elder sibling note | Siya's elder anchor path remains separate; Twah does not inherit another fund's domain |

**witness:step2** `.fund` anchor + claim-his — GREEN when gen-twah passes.

---

## Step 3 — tropical seat

Each fund seats one tropical sign. Index runs **0..11** (Aries through Pisces). Twah is **Taurus**, fund-order **2**, sign-index **1**.

| Field | Twah |
|-------|------|
| Sign | Taurus · earth |
| Fund order | 2 (after Mala · before Siya) |
| Sign index | **1** |
| Vane lean | `%twah` |
| Lexicon | **Twah (fund)** row |

Mala (Aries · index 0) leads; Twah steadies; Siya (Gemini · index 2) carries air — triad order seated at Constellation prep.

**witness:step3** Taurus · order 2 · sign_index 1 — GREEN when gen-twah passes.

---

## Step 4 — read the phone book

The constellation contract is a **phone book**, not a mint. Version one holds seats; it **mints nothing** and moves no value. Read before you seat.

| Artifact | Role |
|----------|------|
| [`../../mycelium/constellation/SPEC.md`](../../mycelium/constellation/SPEC.md) | Design — registry-only · two lanes · hard lines |
| [`../../mycelium/constellation/sui/sources/constellation.move`](../../mycelium/constellation/sui/sources/constellation.move) | Unaudited Move sketch — `add_seat` under AdminCap · **mints nothing** |
| Settlement lane | Sui package (devnet/testnet/mainnet = his hand) |
| Sovereign lane | Same registry truth over **Comlink** on house metal |

**What to verify when reading:** seats ≤ twelve · sign index &lt; twelve · a sign seats at most once · only admin seats · no token genesis in v1.

**witness:step4** phone book present · mints nothing — GREEN when gen-twah passes.

---

## Step 5 — knock Comlink first

Every constellation prep generator knocks **Comlink** before any seating byte. The wire is the door; the phone book is the book behind it. No generator skips the house stack.

| Check | Standing |
|-------|----------|
| Door | `comlink/` · `comlink/beading.rye` |
| Path | `prin → Comlink → constellation phone book` |
| Seating bytes | **not sent** from this tutorial or gen-twah |
| Why first | Two lanes share one truth; sovereign lane travels Comlink |

**witness:step5** Comlink knock · no seating byte — GREEN when gen-twah passes.

---

## Step 6 — the refuse-walk

A tutorial that can deploy is a tutorial that lies. Step six is the practiced **RED**: name the forbidden verbs and prove the generator exits rather than pretending.

| Verb | Who may run it | Tutorial / gen-twah |
|------|----------------|---------------------|
| `deploy` | Keaton alone | **REFUSE** |
| `mainnet` | Keaton alone | **REFUSE** |
| `wallet` | Keaton alone | **REFUSE** |
| `gas` | Keaton alone | **REFUSE** |
| `multisig-live` | Keaton + professionals | **REFUSE** |
| `claim-domain` | Keaton alone | **REFUSE** |

**Prove the refuse (part of GREEN):**

```bash
rishi/bin/rishi run tools/gen_twah_fund_prep.rish deploy   # must exit non-zero
```

gen-twah's own GREEN path re-runs this refuse as a post-fold so the page cannot stay GREEN if the door softens.

**witness:step6** refuse-walk taught · deploy RED proven — GREEN when gen-twah passes.

---

## Hard lines (always)

- **no live deploy** from this page or its generator  
- no private key, wallet, or gas in the tree  
- no domain purchase by counsel  
- n-of-12 multisig remains **plan only** (led by Mala) until professionals + Keaton  

## Prove the whole page (steps 1–6)

```bash
rishi/bin/rishi run tools/gen_twah_fund_prep.rish          # GREEN — includes refuse post-fold
rishi/bin/rishi run tools/gen_twah_fund_prep.rish deploy   # RED by name
```

---

*May the earth seat close its prep by refusing what it cannot honestly carry, and may every four-letter fund wait for the hand that alone may claim, pay gas, and deploy.*
