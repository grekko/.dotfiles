#!/usr/bin/env python3
"""Aggregate Claude Code token usage from local transcripts and estimate API cost.

Reads ~/.claude/projects/**/*.jsonl, sums per-day token usage (input / output /
cache read / cache write), prices it at published API rates per model, and prints
a daily table + totals. This is the pay-as-you-go API-equivalent cost; if you are
on a Pro/Max subscription you do not pay this.

Usage:
  price.py [DAYS] [--project SUBSTR] [--by-model] [--all]

  DAYS              number of trailing days to include (default 14)
  --all             include all history (ignore DAYS)
  --project SUBSTR  only transcripts whose project dir contains SUBSTR
  --by-model        add a per-model breakdown table

The RATES table below is refreshed by the /price skill on `--refresh` (the skill
WebFetches the live pricing page and rewrites it); this script itself does no
network access and silently ignores a stray --refresh arg.
"""
import json, glob, os, sys, datetime
from collections import defaultdict

# Rates per 1M tokens: (input, output, cache_read, cache_write_5m, cache_write_1h)
# Source: https://platform.claude.com/docs/en/about-claude/pricing.md
# Last refreshed: 2026-06-19  (update via: /price --refresh)
RATES = {
    "fable":  (10.0, 50.0, 1.00, 12.50, 20.0),
    "opus":   (5.0, 25.0, 0.50, 6.25, 10.0),
    "sonnet": (3.0, 15.0, 0.30, 3.75, 6.0),
    "haiku":  (1.0,  5.0, 0.10, 1.25, 2.0),
}
DEFAULT_FAMILY = "opus"

def family(model):
    m = (model or "").lower()
    for fam in RATES:
        if fam in m:
            return fam
    return DEFAULT_FAMILY

def human(n):
    for unit, div in (("B", 1e9), ("M", 1e6), ("K", 1e3)):
        if n >= div:
            return f"{n/div:.1f}{unit}"
    return str(int(n))

def parse_args(argv):
    days, proj, by_model, allh = 14, None, False, False
    i = 0
    while i < len(argv):
        a = argv[i]
        if a == "--all": allh = True
        elif a == "--by-model": by_model = True
        elif a == "--project":
            i += 1; proj = argv[i] if i < len(argv) else None
        elif a.isdigit(): days = int(a)
        i += 1
    return days, proj, by_model, allh

def main():
    days, proj, by_model, allh = parse_args(sys.argv[1:])
    base = os.path.expanduser("~/.claude/projects")
    cutoff = None
    if not allh:
        cutoff = (datetime.date.today() - datetime.timedelta(days=days - 1))

    seen = set()  # dedup by API message id across resumed sessions
    # day -> family -> dict of token counts; also reqs
    agg = defaultdict(lambda: defaultdict(lambda: defaultdict(float)))
    files = glob.glob(os.path.join(base, "**", "*.jsonl"), recursive=True)
    if proj:
        files = [f for f in files if proj in f]

    for f in files:
        try:
            fh = open(f, encoding="utf-8")
        except OSError:
            continue
        for line in fh:
            try:
                o = json.loads(line)
            except Exception:
                continue
            if o.get("type") != "assistant":
                continue
            msg = o.get("message", {})
            u = msg.get("usage")
            if not u:
                continue
            mid = msg.get("id")
            if mid:
                if mid in seen:
                    continue
                seen.add(mid)
            ts = o.get("timestamp", "")
            try:
                d = datetime.datetime.fromisoformat(ts.replace("Z", "+00:00")).date()
            except Exception:
                continue
            if cutoff and d < cutoff:
                continue
            fam = family(msg.get("model"))
            cc = u.get("cache_creation") or {}
            w5 = cc.get("ephemeral_5m_input_tokens")
            w1 = cc.get("ephemeral_1h_input_tokens")
            if w5 is None and w1 is None:
                # fall back: treat all cache creation as 5m
                w5 = u.get("cache_creation_input_tokens", 0); w1 = 0
            else:
                w5 = w5 or 0; w1 = w1 or 0
            r = agg[d][fam]
            r["in"]   += u.get("input_tokens", 0)
            r["out"]  += u.get("output_tokens", 0)
            r["read"] += u.get("cache_read_input_tokens", 0)
            r["w5"]   += w5
            r["w1"]   += w1
            r["reqs"] += 1

    if not agg:
        print("No usage found in transcripts for the selected range.")
        return

    def cost(fam, r):
        ri, ro, rr, rw5, rw1 = RATES[fam]
        return (r["in"]*ri + r["out"]*ro + r["read"]*rr + r["w5"]*rw5 + r["w1"]*rw1) / 1e6

    # Daily table
    print(f"## Token usage & estimated API cost")
    rng = "all history" if allh else f"last {days} days"
    pf = f" · project~={proj}" if proj else " · all projects"
    print(f"_{rng}{pf} · {len(seen)} priced responses_\n")
    print("| Date | reqs | input | output | cache read | cache write | total tok | **cost** |")
    print("|------|-----:|------:|-------:|-----------:|------------:|----------:|---------:|")
    tot = defaultdict(float); tcost = 0.0
    for d in sorted(agg):
        fams = agg[d]
        s = defaultdict(float)
        dcost = 0.0
        for fam, r in fams.items():
            for k in ("in","out","read","w5","w1","reqs"): s[k] += r[k]
            dcost += cost(fam, r)
        w = s["w5"] + s["w1"]
        ttok = s["in"] + s["out"] + s["read"] + w
        print(f"| {d:%m-%d} | {int(s['reqs'])} | {human(s['in'])} | {human(s['out'])} | "
              f"{human(s['read'])} | {human(w)} | {human(ttok)} | **${dcost:,.2f}** |")
        for k in s: tot[k] += s[k]
        tcost += dcost

    tw = tot["w5"] + tot["w1"]
    ttot = tot["in"] + tot["out"] + tot["read"] + tw
    ndays = len(agg)
    print(f"\n**Total: {human(ttot)} tokens · ~${tcost:,.2f}** "
          f"over {ndays} active day(s) · avg ~${tcost/ndays:,.2f}/day")
    if ttot:
        print(f"_cache reads = {tot['read']/ttot*100:.0f}% of tokens_")

    if by_model:
        print("\n### By model")
        print("| Model | reqs | input | output | cache read | cache write | **cost** |")
        print("|-------|-----:|------:|-------:|-----------:|------------:|---------:|")
        permodel = defaultdict(lambda: defaultdict(float))
        for d in agg:
            for fam, r in agg[d].items():
                for k in r: permodel[fam][k] += r[k]
        for fam in sorted(permodel, key=lambda x: -cost(x, permodel[x])):
            r = permodel[fam]
            print(f"| {fam} | {int(r['reqs'])} | {human(r['in'])} | {human(r['out'])} | "
                  f"{human(r['read'])} | {human(r['w5']+r['w1'])} | **${cost(fam,r):,.2f}** |")

    print("\n> API-equivalent (pay-as-you-go) cost. On a Pro/Max subscription you do not pay this — "
          "it's what the same usage would cost metered at API rates. Cache writes priced by actual "
          "5m/1h TTL recorded in the transcript.")

if __name__ == "__main__":
    main()
