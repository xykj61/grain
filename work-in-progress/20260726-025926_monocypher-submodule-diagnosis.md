# Monocypher submodule diagnosis

**Language:** EN  
**Stamp:** `20260726.025926`  
**Voice:** Quin  
**Status:** Reading-only — Z · propose nothing · H stays held · F note stays **RED**  
**Ground:** counsel `20260726.025120` · parity F RED on signed-Kumara · host `ai-sandbox` · pier `/home/xy/grain` · nib at start `0cdf4af9e8`

## Command and literal stderr

```text
$ git submodule update --init vendor/monocypher
error: pathspec 'vendor/monocypher' did not match any file(s) known to git
```

Exit code: `1`

## `.gitmodules` entry

```ini
[submodule "vendor/monocypher"]
	path = vendor/monocypher
	url = https://github.com/LoupVaillant/Monocypher.git
```

- **URL:** `https://github.com/LoupVaillant/Monocypher.git`
- **branch:** none set in `.gitmodules`

## Directory state

- `vendor/monocypher` — **absent** (not an empty directory; path does not exist)
- `vendor/` on this host contains only `zig-toolchain/` among immediate children observed

## Git index / HEAD

- `git rev-parse HEAD:vendor/monocypher` → `fatal: path 'vendor/monocypher' does not exist in 'HEAD'`
- `git ls-tree HEAD vendor/monocypher` — empty (no gitlink mode `160000` entry)
- `.gitignore` carries `/vendor/*` with an exception `!/vendor/monocypher/` — the name is expected, yet no gitlink is present in `HEAD`

## Outside the enclosure

- Host name: `ai-sandbox`; no `/run/.containerenv` or `/.dockerenv` on this run
- The same command was executed on this host; failure mode is **pathspec / missing gitlink**, not a fetch or credential error
- A network-capable host outside any enclosure would still fail `git submodule update --init vendor/monocypher` with the same pathspec error until a gitlink for `vendor/monocypher` exists in the tree — the observed stderr does not show a clone/fetch attempt

## Posture (no proposal)

Report only. Counsel names the third word only after the cause is known. **H stays held. Send notes say RED, not PARTIAL.**
