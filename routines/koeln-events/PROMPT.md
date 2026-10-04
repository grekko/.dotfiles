# Köln Events — monthly routine

You run unattended on the 1st of each month. Goal: refresh the artifact
https://claude.ai/artifact/WabH1vZLarp9eRw1fBPj4k with notable events in Köln for the next 3 months, then
send a push notification with the link. No questions, no confirmation —
nobody is watching.

## Scope

- Window: today through today + 3 months.
- Area: Stadt Köln only (city limits). Nothing in Bergisch Gladbach,
  Leverkusen, Hürth, Frechen, Pulheim etc. — drop those even if a Köln site
  lists them.
- Home is Köln-Bickendorf. Look hard for anything in Stadtbezirk Ehrenfeld
  (Bickendorf, Ossendorf, Ehrenfeld, Neuehrenfeld, Vogelsang, Bocklemünd/
  Mengenich) — small local things there are wanted (Veedelsfest,
  Flohmarkt, Stadtteillauf, Pfarrfest, Laternenzug, Weihnachtsmarkt).
- Rest of Köln: only notable events — things a resident would regret
  missing. Skip regular club nights, ordinary concerts/comedy tour stops,
  weekly markets, courses, guided tours that repeat every week.
- Categories (`category` field):
  - `run` — running & sports to take part in (Läufe, Marathon, Triathlon,
    Radtouren, Sportfeste)
  - `veedel` — neighbourhood: Veedelsfeste, Flohmärkte, Straßenfeste,
    local Weihnachtsmärkte, Martinszüge
  - `city` — big city events: festivals, Kölner Lichter, CSD, big
    Weihnachtsmärkte, Karneval milestones (11.11., Sessionseröffnung),
    Messen with public days
  - `culture` — Museumsnacht, Kunst-/Theaterfestivals, notable
    exhibitions openings, open-air cinema

## Sources (fixed list — check every one)

1. https://rausgegangen.de/cologne/ — protected by a bot challenge; try
   WebFetch once, and if it returns 403 use WebSearch
   `site:rausgegangen.de cologne <Monat> <Jahr>` instead. Never try to
   bypass the challenge.
2. https://www.stadt-koeln.de/leben-in-koeln/freizeit-natur-sport/veranstaltungskalender/
   — official city calendar, has category and Stadtbezirk filters; check
   Stadtbezirk Ehrenfeld and category Sport explicitly.
3. https://www.laufen-in-koeln.de/ — Köln running calendar; monthly views
   at `lik4.php?aid=C-3,<month>,<year>`.
4. https://www.marathon4you.de/laufkalender — filter to Köln.
5. https://prinz.de/koeln/events/ — city listings.
6. https://www.ksta.de/koeln — Kölner Stadt-Anzeiger; use WebSearch
   `site:ksta.de <Bickendorf|Ehrenfeld|Köln> <Monat> <Jahr> Fest|Lauf|Flohmarkt`.
7. https://www.eventbrite.de/d/germany--k%C3%B6ln/events/ — only for
   community events in Ehrenfeld/Bickendorf.
8. https://www.koeln.de/events/ — city portal, productive. Fetch
   `/events/kategorie/maerkte-und-feste/liste/` and day views
   `/events/kategorie/maerkte-und-feste/tag/YYYY-MM-DD/` for every weekend
   (Sat + Sun) in the window — that is where Veedel Flohmärkte and
   Straßenfeste show up. Also https://www.koeln.de/weihnachten/weihnachtsmaerkte-koeln.
9. Targeted WebSearch per upcoming month (German): "Bickendorf <Monat>",
   "Ehrenfeld Veedelsfest", "Flohmarkt Ehrenfeld <Monat>", "Lauf Köln
   <Monat> <Jahr>", "Köln Weihnachtsmärkte <Jahr>", "Köln <Monat> <Jahr>
   Highlights".

Actually WebFetch every listed source (each month / weekend view where the
site has one) — a WebSearch alone does not count as checking a source. Be
thorough rather than fast: this runs once a month. Expect 30–60 events; if
you have fewer than 30, go back through koeln.de weekend views and the
targeted searches before publishing.

If a source fails, note it and continue. Do not add sources outside this
list except via the targeted searches in 9.

## Rules for each event

- Must have a confirmed date and a source URL (prefer the organiser's
  page). Unconfirmed / "voraussichtlich" → skip.
- Dedupe across sources. Cap ~60 events; prefer Ehrenfeld-Bezirk items and
  `run` items when cutting.
- Shape (JSON):
  `{"id", "title", "start", "end"?, "allDay", "category", "location", "veedel", "url", "source", "note"?}`
  - `start`/`end`: `"YYYY-MM-DD"` (all-day) or `"YYYY-MM-DDTHH:MM"` (Berlin
    local time). Multi-day: `start` first day, `end` last day.
  - `id`: lowercase slug of title + start date, e.g.
    `nippeser-stundenlauf-2026-07-25` (keep stable across months).
  - `location`: venue + street if known. `veedel`: Stadtteil name.
  - `note`: one short German line, e.g. distances + Anmeldeschluss for runs.
- Titles in German as the organiser writes them.

## Build and publish

1. Write events to `/tmp/events.json` as `{"generated": "<today YYYY-MM-DD>", "events": [...]}`.
2. Build the page with Python (no sed):
   ```python
   import json
   data = json.load(open("/tmp/events.json"))
   blob = json.dumps(data, ensure_ascii=False).replace("<", "\\u003c")
   html = open("routines/koeln-events/page.html").read().replace("__DATA__", blob, 1)
   open("/tmp/koeln-events.html", "w").write(html)
   ```
3. Load deferred tools if needed: ToolSearch `select:Artifact,PushNotification`.
4. `Artifact` with `action: "read"`, `url: "https://claude.ai/artifact/WabH1vZLarp9eRw1fBPj4k"` (required
   before republishing from a fresh session).
5. `Artifact` publish: `file_path: "/tmp/koeln-events.html"`,
   `url: "https://claude.ai/artifact/WabH1vZLarp9eRw1fBPj4k"`. Do not pass `icon` or `capabilities`.
6. `PushNotification`: "Köln Events: <N> Termine bis <Monat>" + the link.
   Mention the count of Ehrenfeld-Bezirk events if any.

Do not commit or push anything to the repo.

## If publishing or the push fails

Send one Gmail message to claude.ai@grekko.de, subject
"Köln Events <Monat Jahr>", plain-text body listing the events (date,
title, location, URL) and the error you hit.
