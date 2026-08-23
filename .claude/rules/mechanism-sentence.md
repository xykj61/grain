# The Mechanism Sentence -- say what changed in plain engineering words

**Seated:** `20260822.014628` on Keaton's word - **Status:** Living - **Kin:** [`commit-messages`](commit-messages.md) - [`radiant-style`](radiant-style.md) - [`session-logs`](session-logs.md) - [`docs-implementation-sync`](docs-implementation-sync.md) - **Foundation:** [`../../foundations/20260822-014628_the-mechanism-and-the-metaphor.md`](../../foundations/20260822-014628_the-mechanism-and-the-metaphor.md)

**Every commit body and every session log carries at least one plain sentence naming the change in ordinary engineering words -- file, function, parameter, type, import, call, field, signature -- and that sentence comes before any metaphor.**

The test a reader applies: someone who knows the language and has never read this tree reconstructs *what changed* from that sentence alone.

## The shape

Lead with the mechanism, then let the prose say why it matters.

```
caravan: the note name written once, not forty-seven times

`note_path` moved into `caravan/ladder_checks.rye` as one published
function taking the rung as a comptime type parameter, and each of the
forty-seven rungs now calls it through a three-line stub that reaches
`max_note_path_len`, `NoteError`, and `note_dir` through the type handed
in. The twenty-six-line body stood byte for byte in all forty-seven.

A rule written forty-seven times is a rule forty-seven files may quietly
come to disagree about.
```

The first paragraph is the mechanism sentence. The last line is the metaphor, and it earns its place by standing on a mechanism the reader already holds.

## What earns a metaphor

A metaphor that follows the mechanism carries meaning forward. A metaphor that stands in for the mechanism asks the reader to reconstruct a diff from an image, and the image is the only thing they receive. Radiant Style already asks that a coined term be given its plain function on first use; this extends the same courtesy from **terms** to **changes**.

## Where it applies

- **Commit bodies** -- enforced at write time by [`../../tools/hooks/commit-msg`](../../tools/hooks/commit-msg). Sixty words or more carries three distinct mechanism words; twenty-five to fifty-nine carries one; under twenty-five passes free, since a body that short hides nothing. The hook leaves the message untouched on disk, so a refusal is edited and committed again.
  - **One named exemption**, the same one [`git-signing`](git-signing.md) already carries: the depersonalized public seed ships a single root commit whose body describes a repository rather than a change, recognised by the `Grain OS -- ` subject that only `publish-seed.sh` writes. Every commit in this tree wears a lowercase `component: ` prefix and can never borrow it, which the wall scan proves both ways. A named exemption, never a bypass -- there is no flag, no environment variable, and no comment that turns the wall off.
- **Session logs** -- the `file` fields already name paths with a why-one-line, and the `think` and `obs` fields say the mechanism in words rather than only in image. Reported by the witness as a ratchet.
- **Design essays, foundations, and specs** -- the plain sentence comes first wherever a document describes a change to code.

## Where it rests

- **Subjects stay short and may stay poetic.** Fifty characters holds a name, and the body holds the mechanism.
- **Dated artifacts keep every word they wrote.** Accrete-never-break governs; this law governs what is written from here forward.
- **Small commits stay small.** A pin, a stamp refresh, a one-line correction says its one thing and stops.

## The meter, and its honest limit

[`../../tools/m/mechanism_sentence_witness.rish`](../../tools/m/mechanism_sentence_witness.rish) over [`../../tools/fixtures/mechanism_sentence_scan.sh`](../../tools/fixtures/mechanism_sentence_scan.sh) counts distinct mechanism words per commit body across a trailing window and holds the count of thin bodies under a ceiling that only falls. Measured at seating: **21 of the last 40 commit bodies** read below the floor.

The meter counts vocabulary, so it proves a floor rather than a comprehension. One commit scoring three still left its reader unable to name the change, which is how this law came to be written. **Word presence is the check; a reader reconstructing the diff is the standard.** Honest and incomplete is a different thing from wrong, and the second number to read is always the prose itself.

## Why the law exists

Keaton read six commits of one refactoring arc and still had to ask what it did. The arc was sound, the witnesses were green, and the record described it entirely in image. A commit message is read once by its author and many times by everyone who comes after, so the mechanism belongs where the many readers are.

Canonical Cursor twin: [`../../.cursor/rules/mechanism-sentence.mdc`](../../.cursor/rules/mechanism-sentence.mdc).
