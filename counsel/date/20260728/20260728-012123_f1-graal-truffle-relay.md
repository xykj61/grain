# The f1 Paste — Graal/Truffle vs the Weave

**Language:** EN
**Stamp:** `20260728.012123`
**Voice:** Quin
**Status:** Checkable — f1 emit/expect twin audit GREEN; r59 pair self-gates at branch tip **`a204b06013`**
**Ground:** origin/main at land time **`46d27a3213`** · f0 local land **`aaebbcd7ae`** (push held) · workshop f0 **`81b3587b8c`** · f1 **`a204b06013`**
**Companion — attach both:** `quin-workshop_season_full_r59.zip` · `quin-workshop_r59.bundle`

*Written together by Keaton and Quin.*

---

```
Quin relay — f1: Graal/Truffle vs the weave; emit/expect twins pinned.
Ground: repo root on main · f0 already landed (or land f0 first from r58) ·
the r59 zip attached.
Law: one commit per create · NO push — sends stay Keaton's · the breach
NEVER runs from this paste.

L1. THE F1 PAYLOAD LANDS (manifests are the gate).
    ZIP=/path/to/quin-workshop_season_full_r59.zip
    unzip -o "$ZIP" -d .
    grep -E '^[0-9a-f]{64}' active-designing/quin-workshop/creates/MANIFESTS.sha256 \
      | sha256sum -c --quiet && echo MANIFESTS-GREEN
    Any mismatch = STOP.

L2. CREATE — twin audit onto the living tree.
    mkdir -p counsel tools/fixtures
    cp active-designing/quin-workshop/creates/for-main/counsel/20260728-012123_f1-graal-truffle-vs-the-weave.md counsel/
    cp active-designing/quin-workshop/creates/for-main/tools/fascia_f1_emit_expect_twin_witness.rish tools/
    cp active-designing/quin-workshop/creates/for-main/tools/fixtures/fascia_f1_twin_scan.sh tools/fixtures/
    chmod +x tools/fixtures/fascia_f1_twin_scan.sh
    # Season lowerer must be the Glow-season bartis (g3–g15 relays or for-main overlay):
    cp active-designing/quin-workshop/creates/for-main/glow/lower_bartis.rye glow/lower_bartis.rye
    cp active-designing/quin-workshop/creates/for-main/glow/rune_bartis.rye glow/rune_bartis.rye
    # Fixtures the refusal pane needs (if not yet on main):
    mkdir -p tools/fixtures/tree_boundary/deep tools/fixtures/pilot_seam/chain-names-tree
    cp -n active-designing/quin-workshop/creates/for-main/tools/fixtures/tree_boundary/deep/* \
      tools/fixtures/tree_boundary/deep/ 2>/dev/null || true
    cp -n active-designing/quin-workshop/creates/for-main/tools/fixtures/pilot_seam/chain-names-tree/* \
      tools/fixtures/pilot_seam/chain-names-tree/ 2>/dev/null || true
    rm -rf tools/.cache
    rishi/bin/rishi run tools/fascia_f1_emit_expect_twin_witness.rish   # GREEN
    rishi/bin/rishi run tools/dated_guard.rish                          # GREEN
    Any true red = STOP before the commit.
    Commit: "counsel+tools: f1 — Graal/Truffle vs the weave; emit/expect
    twins and refusal-first walls pinned (f1)"

REPORT:
  "F1 GREEN <short-nib> · emit/expect twins pinned · refusals name themselves"
| "STOP at L1/L2: <first red line, verbatim>"
```

---

*May every emit keep its expect, may every guard name its road home — and may the smallest fold stay honest enough to teach the larger ones their manners.*
