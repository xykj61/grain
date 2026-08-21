# TAME print alias convention and RTAC refresh

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260702.025012`
**Prompt:** Save RTAC; continue Let's-Keep-Working; should we alias `std.debug.print` as `print` like `assert`?

---

## Thinking trace

Kaeden asked whether bare `print` should mirror bare `assert` across Rye/Rishi hosted code. Checked TigerBeetle `src/tidy.zig`: ban list includes `debug.assert(` (unqualified assert discipline) yet **not** `debug.print(`. Tiger source uses qualified `std.debug.print` freely in tooling. Our assert gate (TH-2c) matches Tiger on assert only.

**Ruling:** yes as **convention**, as-you-touch migration — **not** a parity gate or tree sweep. Documented new **Diagnostic output (`print`)** section in `context/TAME_GUIDANCE.md`; mirrored in `.cursor/rules/tame-guidance.mdc` and `.claude/rules/tame-guidance.md`. TASKS hygiene line updated. RTAC refreshed at host-aligned stamp `20260702.025012` (host clock `20260702.025059` GMT). Parity **139** unchanged; no code migration this turn.

## Observations

- Rishi `.rish` keeps `say` at the pipeline layer — separate from `.rye` print.
- Functions named `printUsage` and similar stay; only the std binding is `print`.
- Add tame-check for qualified print only if proven need arises — same deferral as AST-tier lints.

## Files

- `context/TAME_GUIDANCE.md` — print alias section
- `.cursor/rules/tame-guidance.mdc`, `.claude/rules/tame-guidance.md` — agent rules
- `work-in-progress/ready-to-ask-claude.md`, `TASKS.md`

*Claude door unchanged: Edit 5 → Amber; SLC-2b after Kaeden nod.*
