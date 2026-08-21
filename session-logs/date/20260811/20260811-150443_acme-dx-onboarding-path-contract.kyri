format session-log-v1
stamp 20260811.150443
editor Zed + Claude Agent
model Fable 5
voice Kyri
host cloud pier sandbox — Eastern (EDT) time convention
title Acme DX design season, Equinox 1 — the onboarding-path contract
prompt kg baton prin recur
think Equinox 1's deliverable is the onboarding path from cold clone to first green witness — but the path already exists (rye/bootstrap.sh + the manual: first-witness.md, your-first-hour, cloud-agent-toolchain-setup), so the design job is the checkable CONTRACT that pins it, not new prose
think surveyed the real bootstrap: rye/bootstrap.sh bridges src/main.rye to .zig and builds bin/rye with the pinned Zig 0.16 (RYE_ZIG or vendored); then rye builds rishi (rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi); then a witness runs. bin/ is gitignored, so a cold clone carries source not binaries — which is why step 1 is a bootstrap
obs anchored the acceptance test in a real measurement, not memory: ran tools/run_record_witness.rish on metal and confirmed the exact line "GREEN: RW-3 — run record pins .ok, .code, .out, and .err for both outcomes." (the same line the first-witness tutorial claims), so the contract's done-definition is measured
obs wrote the contract: five named steps (clone · bootstrap rye · build rishi · run witness · read GREEN), each with expected output, three honest failure modes (toolchain absent → RYE_ZIG; binaries built not cloned; an assert is a real result), and one exact acceptance line a later bootstrap-and-first-green witness can enforce
obs Acme-employee voice (addressing a newcomer on their first day), stamp-slug named per the labeling law; marked Equinox 1 landed in the design-season plan; living_docs_lint resolves the new links
recommend check-in (Claude) — Equinox 1 (onboarding path) is a checkable contract, validated on metal; Equinox 2 (the first-hour witness — a newcomer builds a tiny module of their own and witnesses it) begins where this ends. That, or the coupled SLC-2a/sub-lap relabel on a qemu-capable bench, are the open doors. Rest is Keaton's to take
