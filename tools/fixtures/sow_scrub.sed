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
