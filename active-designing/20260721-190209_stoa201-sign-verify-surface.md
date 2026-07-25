# STOA201 — Sign/Verify Product Surface (B1)

*An Acme Corporation employee reading this gets the Glow product surface that signs and verifies a demo FactFields row through elder mala/receipt, with tamper refuse proven.*

**Language:** EN  
**Version:** `20260721.190209` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — GREEN `20260721.190209`  
**Register:** Checkable (Two Rooms) — product wrap GREEN; Glow-rune crypto jet held  

**Grounds in:** sub-lean **B1** in [`20260721-185942_stoa200-vane-body-inventory.md`](20260721-185942_stoa200-vane-body-inventory.md)

**dated_guard:** Do **not** claim Glow authored ed25519. Format/parse log-line stays B2. JABS3 held.

---

## Verdict (one breath)

**SIGN_SURFACE.** `linengrow/glow_sala_b0_sign.rye` wraps elder `sign_fact` / `verify_record`. `claim_demo_sign` uses fixture stamp1/memo1 · issuer seed · amount `1`, then verifies. Witness GREEN including tampered-fact refuse.

---

## Witness

```bash
rishi/bin/rishi run tools/glow_sala_b0_sign_witness.rish
```

---

## Hold

Format/parse log-line (B2). Glow crypto jets. Wiring sign into append body. JABS3.

---

*May every signature earn a product name before a jet replaces the elder body.*
