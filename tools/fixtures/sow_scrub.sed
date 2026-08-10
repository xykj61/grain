# sow_scrub.sed — the name -> role transform for the public seed.
#
# Handles the dominant case the witness found: maintainer NAMES appearing in
# prose and comments as decision-authority ("on Keaton's word", "Kaeden's
# word", "held for Keaton"). It turns them into the generic role the
# Acme-employee-voice rule prescribes (.claude/rules/acme-employee-voice.md).
#
# Ordered longest-first so compound names resolve before their parts.
#
# Names -> role.
s/Keaton Livermore/the maintainer/g
s/Kaeden Reyklah/the maintainer/g
s/Keaton's/the maintainer's/g
s/Kaeden's/the maintainer's/g
s/Keaton/the maintainer/g
s/Kaeden/the maintainer/g
s/Livermore/the maintainer/g
s/Reyklah/the maintainer/g

# Family and prior-name surnames -> role / a family member (20260810 — private).
# Longest-first: a family member's full name before the bare surname.
s/Michael Dunsford/a family member/g
s/Keaton Dunsford/the maintainer/g
s/Dunsford/the maintainer/g
s/Mayacama Golf Club/a club/g
s/Mayacama/a club/g

# Personal handles and contact identifiers -> owner placeholder (20260810 — private).
# Longest-first so a compound handle resolves before any bare fragment.
s/veganreyklah[A-Za-z0-9._-]*/acme-owner/g
s/cherry996[A-Za-z0-9._-]*/acme-owner/g
s/vegankeatonsiya[A-Za-z0-9._-]*/acme-owner/g
s/keatonsiya/acme-owner/g
s/xnkg30/acme-owner/g
s/reyklah/acme-owner/g
s/npub1[a-z0-9]\{58\}/acme-owner-npub/g

# Forge handles -> owner placeholder (Keaton's ruling 20260808).
# The field keeps its real handles; only the projected seed gets the placeholder,
# which a forker replaces with their own account. Swapping in the seed cannot
# break the field's live scripts, and a template push like `git push acme-owner`
# is exactly the placeholder a newcomer expects to fill in.
s/xykj61/acme-owner/g
s/autoproject96/acme-owner/g

# STILL DELIBERATELY ABSENT: the real Azimuth ship names (bandun, pacpet-solreb).
# Those are code literals whose value is behavior, not prose — swapping them is a
# code change with test implications, out of scope for a name/handle scrub. Any
# file still carrying them after this pass stays WITHHELD for human judgment.

# Wallet, fund, and company identifiers -> placeholders (20260810 — private, financial).
s/6Rb5E[A-Za-z0-9]*/acme-owner-wallet/g
s/AHs34/acme-owner-wallet/g
s/xykj61atgmail/acme-owner/g
s/siyafundllc/acme-fund/g
s/siyafund/acme-fund/g
s/thebittradingcompany/acme-co/g
s/bitscape/acme-co/g
s/xy96gen-z/acme-owner/g
s/xykld2/acme-owner/g
s/xnkg3/acme-owner/g
s/DJINN/a friend/g
s/DJINN/a friend/g
s/DJINN/a friend/g

# ============================================================
# Name-audit remediation (20260810) — the 8-agent seed audit
# (w34sfmeai) found 42 real identifiers surviving the scrub.
# Ordered longest-first; \b guards short risky words; a
# protect->scrub->restore dance keeps public "Serena Williams"
# and the OS name "Grain" while scrubbing the private senses.
# ============================================================

# -- protect the public VC figure before any bare-Serena scrub --
s/Serena Williams/PROTECT_SERENA_WILLIAMS/g
s/Serena Ventures/PROTECT_SERENA_VENTURES/g

# -- ventures / domains / handles (real accounts and filings) --
s/Grain Energy PBC/a public benefit company/g
s/Grain_Energy_PBC/a_public_benefit_company/g
s/Grain Energy/a civic venture/g
s/grain\.energy/acme.example/g
s/grain_energy/acme-owner/g
s/groupproject36/acme-owner/g
s/Siya Fund PBC/a fund/g
s/Siya Fund/a fund/g
s/Facebook Marketplace/an online marketplace/g
s/Tlon Corporation/a real workplace/g
s/The Ecological Farm/an ecological farm/g

# -- places / infrastructure (the pier's real location) --
s/Reno, NV/a region/g
s/Washoe County/a county/g
s/Vultr SEA/a cloud region/g
s/Vultr Seattle/a cloud region/g
s/Sabey SDC Columbia/a datacenter/g
s/East Wenatchee/a region/g
s/\bWenatchee\b/a region/g
s/\bVultr\b/a cloud provider/g
s/\bSeattle\b/a coastal city/g
s/Daylight DC-1/a tablet/g

# -- public figures named as fund / voice dedications --
s/Ariana Grande/a public figure/g
s/Kyler Murray/a public figure/g
s/Kamala Harris/a public figure/g
s/Sarah Guo/a public figure/g
s/Wayne Hsiung/a public figure/g
s/Helen Atthowe/a public figure/g
s/Ido Portal/a movement teacher/g
s/Chong Xie/an architect/g
s/\bHyperarch\b/an architecture practice/g
s/Parisa Yazdi/a designer/g
s/\bAvanti\b/a public figure/g
s/\bKia\b/an automaker/g
s/\bHyundai\b/an automaker/g

# -- private individuals (real people in the maintainer's life) --
s/Sara the maintainer/a co-founder/g
s/\bSara\b/a co-founder/g
s/Nate aka Wiggy/a videographer/g
s/\bWiggy\b/a videographer/g
s/\bRoger\b/a manager/g
s/Serena/a family member/g

# -- restore the protected public references --
s/PROTECT_SERENA_WILLIAMS/Serena Williams/g
s/PROTECT_SERENA_VENTURES/Serena Ventures/g

# -- live OpenPGP key fingerprints (keyserver-resolvable to the real identity) --
s/0646 2132 D3E6 3B83 4F97 6E03 A81D 720B 9235 FA7A/[redacted-fingerprint]/g
s/DBF8 5343 7A93 7B4E 36B9 3611 D949 807A C26B 2B99/[redacted-fingerprint]/g
s/06462132D3E63B834F976E03A81D720B9235FA7A/[redacted-fingerprint]/g
s/DBF853437A937B4E36B93611D949807AC26B2B99/[redacted-fingerprint]/g

# ============================================================
# Contact & holdings scrub (20260810) — emails, personal handles,
# and owned domains named for the private redirects record. The
# generic gmail catch closes the class the fingerprint audit missed.
# ============================================================

# -- ANY gmail address -> a generic placeholder (every current + future one) --
s/[A-Za-z0-9._%+-]\+@gmail\.com/acme-owner@example.com/g

# -- prior-name + personal handles -> owner placeholder (longest-first) --
s/keatonlivermore/acme-owner/g
s/keatondun/acme-owner/g
s/teamcarry11/acme-owner/g
s/xwb122m/acme-owner/g
s/b122mnet/acme-owner/g
s/xnflor3/acme-owner/g
s/kaexvx9/acme-owner/g
s/kj3x39/acme-owner/g
s/\bb122m\b/acme-co/g

# -- owned professional-service + venture domains -> example placeholders --
s/vegancpa\.\(net\|org\|com\)/acme-cpa.example/g
s/veganaccountant\.\(net\|org\|com\)/acme-accountant.example/g
s/veganarchitect\.\(net\|org\|com\)/acme-architect.example/g
s/veganbookkeeper\.\(net\|org\|com\)/acme-bookkeeper.example/g
s/vegan\.financial/acme.example/g
s/vegan\.work/acme.example/g
s/construction3x39\.\(com\|sol\)/acme-construction.example/g
s/\bconstruction3x39\b/acme-construction/g

# ============================================================
# Convergence audit (20260810 · wgn0745jf) — a 5th pass found a family-history
# layer, a third key fingerprint, and name-in-path leaks. Collapse the broken
# double-scrub FIRST, then the bare surname; scrub the family enterprise, the org,
# the third fingerprint, the leaked path slugs, and the region codes.
# ============================================================
s/the maintainer Sealy the maintainer/the maintainer/g
s/Bob the maintainer/the maintainer/g
s/Robert Sealy/a family member/g
s/\bSealy\b/the maintainer/g
s/\bZendex\b/a family enterprise/g
s/Direct Action Everywhere/an advocacy organization/g
s/\bDxE\b/an advocacy organization/g
s/\bKyler\b/a public figure/g

# -- a third live GPG fingerprint (sandbox) + the master short-id and its filename --
s/CC8BA67125E202E1DB0CBFD70E632656F07DD30B/[redacted-fingerprint]/g
s/\bCC8BA671\b/[redacted-fingerprint]/g
s/gpg_signing_06462132/gpg_signing_redacted/g
s/\b06462132\b/[redacted-keyid]/g

# -- names surviving in link/fixture PATH slugs (prose already scrubbed) --
s/wayne-hsiung/a-public-figure/g
s/helen-atthowe/a-public-figure/g
s/sarah-guo/a-public-figure/g
s/kyler-murray/a-public-figure/g
s/ariana-grande/a-public-figure/g
s/kamala-harris/a-public-figure/g
s/-ariana\b/-a-public-figure/g
s/-avanti\b/-a-public-figure/g

# -- VPS region codes that pin the pier's geography (provider already scrubbed) --
s/SEA only/one region only/g
s/never EWR/never a second region/g

# -- lowercase name forms in slugs / waymark input-names / link paths. The leak scan
#    is case-insensitive while these rules are case-sensitive, so a doc with a
#    lowercase name in a path was withheld though its prose scrubbed clean. Close it. --
s/keaton/the-maintainer/g
s/kaeden/the-maintainer/g
s/livermore/the-maintainer/g
s/dunsford/the-maintainer/g
s/\bsabin\b/a-friend/g
s/\bsealy\b/the-maintainer/g
s/\bzendex\b/a-family-enterprise/g
s/mayacama/a-club/g

# -- host hardware + timezone locators (the project's own anonymization discipline
#    says remove these; scrub so the spec ships generic rather than withheld). --
s/Framework 16/a laptop/g
s/Pacific Time/the local time zone/g
s/Pacific time/the local time zone/g
s/Pacific coast/the local region/g
s/Nevada/a state/g

# -- identifiers the agent-read clearance surfaced (20260810 . wnlsgtnxe) --
s/66041JEA306288/[redacted-serial]/g
s/bhagavan851c05a/acme-user/g
s/\bkae3g\b/acme-owner/g
s/\bBrooke\b/a friend/g

# -- external-research clearance surfaced (20260810 . w50krsfnv) --
s/Alexandra Livermore/a family member/g
s/Smart Access/a company/g
s/0646 2132/[redacted-keyid]/g
s/DBF8 5343/[redacted-keyid]/g
s/maicmalamurr/a council galaxy/g
