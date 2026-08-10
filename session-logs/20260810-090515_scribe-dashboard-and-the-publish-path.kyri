format session-log-v1
stamp 20260810.090515
editor Zed + Claude Agent
model claude-opus-4-8
voice Riyo
host Vultr cloud pier (ai-jail) — Eastern (EDT) time convention
title Scribe's dashboard, and the publish path opens
prompt kg build Scribe's dashboard; the seed template repo still hasn't been sent to github
think Built scribe/dashboard.rye per the design brief — the reading room over the Kyri reader. Added is_inventory to reader.rye (format inventory-v1 + stamp, the exact shape of is_session_log/is_baton), then the dashboard: parse a drawer of documents, dispatch each by format onto four shelves (Logs, Batons, Inventory, Unread), lay out a Row {shelf, stamp, title, one_line} that borrows the reader's own zero-copy slices — a lens, never an author.
think Bounded (max_drawer_docs=256, asserted at fill and render); the Unread fall-through is honest — a nonsense format lands there, never silently dropped. Selftest: three known docs fill three shelves with Unread empty, then a nonsense doc lands on Unread; the lens shows each document's own stamp/title/state. GREEN + witnessed.
think Keaton flagged the seed still isn't on GitHub. Checked the publish capability: gh is logged in as the maintainer's handle with `repo` scope, and — the key fact — the grain-os org EXISTS and the account is a member. The earlier "repository not found" was only the un-created repo, not a missing org. So the publish can proceed the moment the repo is created.
obs The privacy gate is now genuinely satisfied: the allowlist seed is SOW_WITNESS_GREEN (IDENT_CLEAN, NO_PERSONAL). The publish that was rightly held through five leaky passes can land, because the architecture — ship only what is cleared — is sound.
obs The seed's public commit must stay anonymous: a placeholder author and no real GPG signature, since signing with the real key would re-leak the very identity the scrub removed (a fingerprint resolves to the person). Anonymity outranks the private field's signing rule for the public seed repo.
file scribe/dashboard.rye the reading room: dispatch a drawer by format, zero-copy lens, four shelves
file scribe/reader.rye added is_inventory — the third dispatch predicate
file tools/scribe_dashboard_witness.rish proves the shelves fill and Unread is honest
recommend keep-going dashboard GREEN; next create grain-os/grain and push the provably-clean allowlist seed with an anonymous initial commit
