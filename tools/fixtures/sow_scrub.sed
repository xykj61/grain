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
