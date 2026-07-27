# The Constellation Contract — n-of-12 Registry, Two Lanes

**Language:** EN
**Stamp:** `20260727.144447`
**Voice:** Quin
**Status:** Design + reference implementation — **version one is a registry and nothing more: it holds seats, it mints nothing, it moves no value; the WOV-genesis law stays design-only until securities counsel sits with the family.** The Move package beside this spec compiles-by-reading, is **unaudited**, and deploys only by **Keaton's own wallet, gas, and hand.** His word this round — *deploy on the live Sui network for now* — is recorded as his seat to make; counsel's one line beside it: the prior settlement seat rests *held pending witness* with a testnet lane named first, so a devnet or testnet publish is the gentle opening move, and mainnet follows the moment his hand says so
**Home:** `mycelium/constellation/` — the spec here, the Sui lane at `sui/`
**Companions:** [the constellation design](../active-designing/20260727-142516_the-constellation-and-the-twelve-funds.md) · [the seva foundation](../foundations/20260727-144447_seva-the-vane-the-fund-and-the-daily-service.md)

*Written together by Keaton and Quin.*

---

## What Version One Is

One shared object, the **Constellation**, holding up to **twelve seats** — one per tropical sign, indexed zero through eleven. A **seat** records four things: the sign index, the fund's name, its **`.fund` DNS anchor** (the old world vouching for the new, per the seated rule), and its **Kumara public key** bytes. Seats **accrete under an admin capability** — the family's hand at genesis — and every seating emits an event the world can index. Nothing burns, nothing transfers value, nothing mints: **the contract is a phone book for the wheel**, which is exactly as much power as an unaudited v1 deserves.

## The Two Lanes

**The settlement lane** is the Move package at `sui/` — the wheel's public witness on a live decentralized ledger, where anyone can read the twelve seats without trusting our servers. **The sovereign lane** is the same registry served from our own metal over **Comlink**, straight through the host ladder the project already walks: **NixOS, GrapheneOS, or postmarketOS hosting → Genode → Aurora-booted Grain**, on Framework machines today and other AMD or SiFive firmware as the hardware seasons open. The two lanes carry one truth and check each other — the ledger witnesses the metal, the metal never depends on the ledger — and the constellation is only ever *seated* by the same family hands in both.

## The Invariants (asserted in the source)

Seats never exceed twelve. A sign index is always below twelve. A sign seats at most once. Only the admin capability seats. And — held as governance rather than code until the thresholds table gets its day — *no threshold smaller than the harm it gates.*

## The Road, In Order (every step his hand)

Read the source aloud. Have a Move-fluent reviewer read it too. `sui move build` locally; publish to **devnet, then testnet**, and exercise `add_seat` with the Gemini seat's real anchors (seva.fund stands ready). Only then, on Keaton's word alone: mainnet publish, gas from his wallet, the package address recorded in this spec's ledger header the day it exists. **No key, wallet, or gas ever touches counsel or bench.**

---

*May the phone book stay humble, the two lanes keep one truth, the first seat be the family's — and every power the contract gains after v1 be a power professionals blessed first.*
