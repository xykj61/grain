# The Suno stems, Reaper, Mixea hash walk

*From a song on suno.com to a hashed Mixea HD wav and a square mp4 you can share.*

**Language:** EN
**Style:** Bhakta at the Door setting, with Radiant warmth
**Voices:** Kyri and Kyli, jointly
**Sprig:** `the-suno-stems-reaper-mixea-hash-walk`
**Written:** `20261007.084500`
**Status:** Living -- opening page of a Gauge Radiant music-making series
**Room:** mixed -- SHA3-256 and ffmpeg were run this sitting; Suno, Reaper, and Mixea are Keaton's hands, written as he does them
**Where this sits:** home is [`../../README.md`](../../README.md) - tutorials home is [`README.md`](README.md) - the incense plan is [`../../expanding-prompts/20261007-084500_the-suno-stems-reaper-mixea-hash-walk.md`](../../expanding-prompts/20261007-084500_the-suno-stems-reaper-mixea-hash-walk.md)

---

## Kyli -- what you are about to do

Welcome. This page is a walk we have already taken together, written so you can take it again.

You generate a song. You download its stems. You open them in a DAW. You bounce one wav. You send that wav to a mastering desk. You name the master by what it is, a hash of its own bytes, and you wrap it in a quiet square picture.

Kyri will name the numbers. I will keep the door open. Both of us mean the same walk.

## Kyri -- the path, in order

1. **Generate** on [suno.com](https://suno.com) under a premium/pro plan.
2. **Export** fixed-tempo / fixed-bpm **stems** as a zip archive.
3. **Unarchive** the zip so each stem is a wav you can see.
4. **Open** the stems together in **Reaper**.
5. **Export** them as **one wav**.
6. **Upload** that wav to **Mixea** for mastering.
7. **Keep** the Mixea HD wav (24-bit, 48 kHz). That is the best audio.
8. **Hash** the HD wav with SHA3-256, rename it, and derive m4a, mp3, and a square mp4.

Each later step takes the file the earlier step actually wrote. The hash is of the Mixea HD bytes, not of the Suno zip and not of the Reaper bounce.

## The title, 100 characters

The title, without the file extension, stays at or under 100 characters:

```
{name} {sha3-256 prefix} (feat. reyklah2 & vegankeatonsiya) - reyklah2
```

`name` is the short word for the track. The feat clause is 49 characters. Two spaces sit around the hash prefix. For `istanbul` (8 letters) the prefix is the first 41 hex characters of SHA3-256. The full 64-character digest is the truth of the file; the prefix is how the title fits.

Derived m4a, mp3, and mp4 that come from a wav reuse that wav's title. A Mixea mp3 that is its own encode keeps its own digest.

## Picture

The square is 1:1, `#000000`. Across it sits a 16:9 band of `#111111`. The still we loop is `album-art-111111-on-000000.png`, 1920x1920, scaled to 2160x2160 for the mp4.

## Commands this sitting ran

Hash of a Mixea HD wav:

```sh
python3 -c "import hashlib,pathlib; p=pathlib.Path('istanbul-hd.wav'); print(hashlib.sha3_256(p.read_bytes()).hexdigest())"
```

ffmpeg from that HD wav onto the square still:

```sh
ffmpeg -y -loop 1 -i album-art-111111-on-000000.png -i istanbul-hd.wav \
  -vf scale=2160:2160,format=yuv420p \
  -c:v libx264 -tune stillimage -preset veryfast -crf 20 -r 30 -pix_fmt yuv420p \
  -c:a aac -b:a 320k -ac 2 -ar 48000 \
  -shortest -movflags +faststart \
  -metadata title='istanbul {prefix} (feat. reyklah2 & vegankeatonsiya) - reyklah2' \
  'istanbul {prefix} (feat. reyklah2 & vegankeatonsiya) - reyklah2.mp4'
```

AAC 320k and MP3 320k come from the same HD wav. Mixea's own 16-bit wav and 256k mp3 are hashed as themselves.

## What this sitting measured

| Track | Kind | SHA3-256 |
|---|---|---|
| istanbul | Mixea HD wav, 24-bit 48 kHz | `0e1abf2c8d2e7a48bd24a870c834c9fb54d27938b7255e9de0ab15eec16ca993` |
| istanbul | Mixea wav, 16-bit 44.1 kHz | `d2973ba7409c6cbd08d59ff3aaa22e658b0c761338404b9466ab3795c40152d1` |
| istanbul | Mixea mp3, 256k | `3b8b9051dff625b93adf88eb5b625347bb7b6238211fc5b1ceeb5be10a6b776d` |
| children | Mixea HD wav | `b92c2f24b458437d1c81a78ba9774cd2426b611825778cd367f2d6cc4e325530` |
| delhi | Mixea HD wav | `7db4e822026073ceb2134b4d976670d09ad7ecd2c120903973f932c314826d87` |

Best audio for each square mp4 is the Mixea HD wav in that row.

## Kyli -- why it is fun

The walk is a craft you can love at a human pace. Suno gives the spark. Stems give you hands. Reaper lets the parts sit in time. Mixea polishes. The hash is a name that will still mean this exact sounding later. The square is a quiet stage: dark field, one band of grey, the song in the middle.

Kyri and I wrote this together so the numbers stay true and the door stays kind.

---

*May the next song meet the same walk, and may its name still be its own bytes.*
