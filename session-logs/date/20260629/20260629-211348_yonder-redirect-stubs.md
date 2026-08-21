# Yonder pass five — redirect stubs and path fixes

**Editor:** Cursor · **Model:** Composer  
**Stamp:** 20260629.211348

## Thinking trace

Continued yonder hygiene. Moved three executed redirect stubs (`10013`, `10015`, `10025`) to `expanding-prompts/yonder/`; repointed README and `tools/enrich/crosswalk.rye`; fixed `../` → `../../` inside each stub after the extra directory depth.

Passes two through five remain uncommitted — recommend one commit before more surface work.

## Files

| File | Why |
|------|-----|
| `expanding-prompts/yonder/*-redirect.md` (×3) | consumed stubs |
| `expanding-prompts/README.md`, `tools/enrich/crosswalk.rye` | repointed |
