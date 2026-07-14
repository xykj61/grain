# Matklad — project-wide semantic understanding

**Honors:** Alex Kladov (matklad) — original author of IntelliJ Rust and rust-analyzer

**Sources:**

- Resume and writing: <https://matklad.github.io/>
- rust-analyzer architecture: <https://github.com/rust-lang/rust-analyzer/blob/master/docs/dev/architecture.md>
- Series: "One Hundred Thousand Lines of Rust"

**Role for us:** The grain-sketchbook credited Matklad for **project-wide semantic understanding** — a whole workspace held as a resolved model, not file-by-file fragments. Aurora's editor head in that archive mapped Tree-sitter AST nodes into a shared graph; today's tree reaches the same ground through **Weave**, **bolt**, and **Tilak** rather than one closed enum across consumers. The lesson is architectural: understand the whole honestly, then let each surface read only what it needs.

**Clean room:** We study public architecture docs and essays; we never copy rust-analyzer source into our modules. The Realidream lane's gratitude shelf seats this name formally per Kaeden's word (`20260708.174500`).

**Cross-ref:** [`../work-in-progress/ROADMAP.md`](../work-in-progress/ROADMAP.md) — Visual Track · [`../external-research/20260708-021912_grain-sketchbook-realidream-mining.md`](../external-research/20260708-021912_grain-sketchbook-realidream-mining.md) · distilled teachings [`../external-research/20260712-093812_matklad-teachings-distilled.md`](../external-research/20260712-093812_matklad-teachings-distilled.md)

**See also:** [`tigerbeetle/`](tigerbeetle/) — the same teacher walks us through TigerBeetle's own machinery across the IronBeetle series. Episodes 001, 002, 004, 005, 006, 008 through 015, 018 through 022, 025, 028, 030, 031½, and 032 through 038, 040, and 042 through 045 are written up; 003, 007, 016, 017, and 024 are still open. Own-voice silos (tracked; submodule stays unmodified): [`ironbeetle/`](ironbeetle/) (`20260712.092212`).
