# speechless

Converse in **Simplified Technical English**, adapted for software and AI engineering.

[ASD-STE100](https://www.asd-ste100.org/) is the controlled-language standard written for
aerospace maintenance manuals — documents where ambiguity gets people killed. It fixes one
meaning per word, bans complex verb tenses, caps sentence length, and removes hedging.

The properties that make a maintenance manual safe also make an engineering answer fast to
read. This plugin applies them to **everything Claude says** — long explanations and one-line
replies alike.

## Install

```
/plugin marketplace add krishnarathore12/sidecar
/plugin install speechless@windflow
```

## What changes

| | before | after |
|---|---|---|
| *"thanks, that fixed it!"* | Great — glad it's working. Let me know if anything else comes up. | Good. The problem is corrected. |

Measured across four prompts run with and without the skill:

| metric | before | after |
|---|---:|---:|
| total words | 1330 | 1118 |
| contractions | 25 | 0 |
| hedges / filler | 8 | 0 |
| Latin abbreviations | 2 | 0 |
| sentences over 25 words | 11 | 1 |
| avg words / sentence | 15.8 | 8.5 |

Sentence count goes *up* while word count goes down. That is the rule working — same content, shorter units.

## What it does not do

- **Code is never rewritten.** Identifiers, paths, commands, flags, error strings, and log
  output are quoted text. They are reproduced exactly. The standard governs prose only.
- **Technical vocabulary is not avoided.** ASD-STE100 lets each subject field define its own
  terms, and Rule 1.12 category 2 is "Computer processes and applications." So `deploy`,
  `parse`, `endpoint`, `embedding`, and `race condition` are all permitted.
- **Uncertainty is not erased.** The standard removes hedges, not honesty. `That's probably a
  race condition` becomes `The symptom agrees with a race condition. To confirm this, run the
  test 100 times.` — not a false claim of certainty.

## The trade

Short replies become blunt. That is intended. If you want warmth in acknowledgements, this
plugin is the wrong tool.

## Attribution

ASD-STE100 Simplified Technical English is a European Union registered trademark (No. 017966390)
owned by [ASD](https://www.asd-europe.org/). This plugin is an independent adaptation of the
standard's writing principles. It does not reproduce the specification, and it ships no part of
the controlled dictionary. It is not endorsed by or affiliated with ASD or the STEMG.

## License

MIT
