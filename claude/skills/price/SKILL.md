---
name: price
description: Compute Claude Code token usage and estimated API cost from local transcripts (~/.claude/projects). Reports a per-day table of input/output/cache tokens and dollar cost at published API rates, with optional per-model breakdown. Supports --refresh to auto-update its rate table from the live pricing page. Use when the user asks how many tokens they've used, what their usage cost, "/price", token spend, or usage over the past days/weeks.
disable-model-invocation: false
user-invocable: true
---

Compute the user's Claude Code token usage and estimated API cost from local session transcripts.

## How it works

Claude Code logs every API response — with its `usage` object (`input_tokens`, `output_tokens`, `cache_read_input_tokens`, `cache_creation_input_tokens` incl. 5m/1h TTL split) and `model` — to JSONL files under `~/.claude/projects/`. The bundled script aggregates these per day, dedups responses by API message id (so resumed sessions aren't double-counted), prices each by model at published API rates, and prints a table.

## Instructions

**If the args contain `--refresh`, do the refresh step FIRST (below), then continue.** Otherwise skip straight to step 1.

### Refresh step (only when `--refresh` is passed)

The `RATES` table in `price.py` is plain data that goes stale when Anthropic changes pricing. `--refresh` updates it from the live pricing page. The Python script does NOT do this itself (no network) — you do:

1. WebFetch `https://platform.claude.com/docs/en/about-claude/pricing.md` with a prompt like: "Extract per-MTok pricing for every current model: base input, 5-minute cache write, 1-hour cache write, cache read (hit), output." (If that 404s, try `https://platform.claude.com/docs/en/about-claude/models/overview.md` for base input/output and apply the standard cache multipliers: read = 0.1×, 5m write = 1.25×, 1h write = 2× of base input.)
2. Read `~/.claude/skills/price/price.py`, and for each family in the `RATES` table (`fable`, `opus`, `sonnet`, `haiku`) compare the fetched numbers to the current tuple `(input, output, cache_read, cache_write_5m, cache_write_1h)`.
3. If anything changed, Edit the `RATES` table with the new values and bump the `# Last refreshed:` date comment to today. Add a new family line if a new model tier appeared. Keep the tuple order exactly `(input, output, cache_read, cache_write_5m, cache_write_1h)`.
4. Tell the user what changed (old → new per family), or "rates already current — no change" if nothing moved.
5. Then run the script (step 1 below) with the remaining args (drop `--refresh`). If `--refresh` was the only arg, run with defaults.

### Normal run

1. Run the bundled script. It lives next to this file:
   ```
   python3 ~/.claude/skills/price/price.py [DAYS] [--project SUBSTR] [--by-model] [--all]
   ```
   - `DAYS` — trailing days to include (default `14`).
   - `--all` — all history, ignore DAYS.
   - `--project SUBSTR` — only transcripts whose project path contains SUBSTR (e.g. a repo name).
   - `--by-model` — add a per-model breakdown table.
   - (`--refresh` is handled by you in the refresh step above, not by the script — strip it before running.)

2. Parse the user's request for a range/scope and pass matching args:
   - "last month" → `30`, "this week" → `7`, "all time" → `--all`.
   - A specific project/repo named → `--project <name>`.
   - Asks which model cost most / mix of models → add `--by-model`.
   - Plain `/price` with no args → run with defaults (last 14 days, all projects).

3. Present the script's markdown output to the user. It already includes totals, average/day, the cache-read percentage, and the API-vs-subscription caveat. Add brief commentary only if the user asked something specific (e.g. highlight the priciest day, or which project dominates).

## Rates

Per 1M tokens, by model family (input / output / cache read / cache write 5m / cache write 1h):
- **Opus** 4.x: $5 / $25 / $0.50 / $6.25 / $10
- **Sonnet** 4.x: $3 / $15 / $0.30 / $3.75 / $6
- **Haiku** 4.x: $1 / $5 / $0.10 / $1.25 / $2

Unknown models default to Opus rates. Run `/price --refresh` to auto-update the `RATES` table from the live pricing page, or hand-edit the table at the top of `price.py`.

## Notes

- The figure is the **pay-as-you-go API equivalent**, not what a Pro/Max subscription costs.
- Cache reads typically dominate token volume (often >90%) but bill at ~0.1× input, so dollar cost is driven by output + cache reads, not raw token count.
- Reads only local transcripts; days/projects with no transcripts on this machine won't appear.
