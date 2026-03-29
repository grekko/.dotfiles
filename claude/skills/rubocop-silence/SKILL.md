---
name: rubocop-silence
description: Run RuboCop auto-correct, summarize remaining offenses, and optionally silence them all.
user-invocable: true
disable-model-invocation: true
---

Follow these steps exactly, in order:

## Step 1 — Auto-correct

Run:
```
bundle exec rubocop --auto-correct
```

## Step 2 — Capture remaining offenses

Run:
```
bundle exec rubocop
```

Parse the output and present a concise summary of remaining offenses grouped by cop name, e.g.:

```
Remaining offenses (12 total):
  Metrics/MethodLength       4
  Style/FrozenStringLiteral  3
  Layout/LineLength           3
  Metrics/AbcSize            2
```

If there are no remaining offenses, say so and stop — there is nothing to silence.

## Step 3 — Prompt

Ask the user exactly this question:

> Silence all remaining offenses with `--disable-uncorrectable`? (Yes / No)

Wait for the user's response before continuing.

- If the response is **Yes**: run `bundle exec rubocop --autocorrect --disable-uncorrectable` and report when done.
- If the response is anything else: stop and do nothing further.
