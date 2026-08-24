# Session log fixtures for the fold selftest -- one file per shape the tool must know.

| Stamp | Log | Meaning |
|-------|-----|---------|
| 20260703.100000 | [alpha](20260703-100000_alpha.md) | prior day, `.md` with a sprig -- should fold |
| 20260703.110000 | [gamma](20260703-110000_gamma.kyri) | prior day, `.kyri` with a sprig -- should fold |
| 20260703.120000 | [delta](20260703-120000.bron) | prior day, **no sprig** -- should fold (REDS %180) |
| 20260704.100000 | [beta](20260704-100000_beta.md) | today, `.md` -- stays flat |
| 20260814 | [epsilon](20260814-fill-epsilon-x.md) | day only, no time -- never folds, since a resolver needs the whole stamp |
