---
name: babysit-dep-prs
description: Keep dependency-update PRs ready to merge — update labeled 'dependencies' PRs onto main, attempt to fix broken checks once, then report. Prep only, never merges.
disable-model-invocation: false
user-invocable: true
---

Keep dependency-update PRs ready to merge. **Prep only — NEVER merge a PR.** Designed to be re-run on a loop, so every step must be idempotent: skip work that's already done.

## Scope

Open PRs in the current repo that carry the `dependencies` label, regardless of author.

## A note on the GitHub API

`gh pr list` / `gh pr view` / `gh pr checks` go through GitHub's **GraphQL** endpoint, which is prone to a secondary (abuse) rate limit that returns `API rate limit already exceeded` even when `gh api rate_limit` shows quota left. Prefer the **REST** endpoints below — they use the higher core bucket and are reliable on a loop:

- List dep PRs: `gh api "repos/<owner>/<repo>/issues?labels=dependencies&state=open&per_page=100" --jq '[.[] | select(.pull_request) | {number, title}]'`
- Per PR state: `gh api "repos/<owner>/<repo>/pulls/<n>" --jq '{mergeable_state, mergeable, head: .head.ref, headSha: .head.sha, author: .user.login, draft}'`
- Checks: `gh api "repos/<owner>/<repo>/commits/<headSha>/check-runs" --jq '.check_runs[] | {name, status, conclusion}'`

Get `<owner>/<repo>` from `gh repo view --json nameWithOwner -q .nameWithOwner` (or hardcode the current repo). REST `mergeable_state` maps to: `behind` → behind main; `dirty` → conflicts; `clean`/`unstable` → current; `blocked` → up to date but gated by checks/reviews.

## Instructions

1. **Find the PRs** (REST list above). If none, report "No open dependency PRs" and stop.

2. **For each PR, decide if it needs updating onto main.** Look at `mergeable_state`:
   - `behind` → branch is behind main, needs update (step 3).
   - `clean` / `unstable` → already current; skip the update, go to check status (step 4).
   - `dirty` → merge conflict.
     - If author is `dependabot[bot]` → comment `@dependabot rebase` (Dependabot regenerates the PR against main and resolves the conflict itself when it can). Record as **rebase requested**. If a previous run already left a `@dependabot rebase` comment Dependabot hasn't acted on yet, don't spam another — mark **blocked: rebase requested, awaiting Dependabot**. (Check recent PR comments to tell.)
     - Otherwise → the agent can't safely auto-resolve. Don't touch it; note it as **blocked: conflicts**.
   - `blocked` → up to date but gated by required reviews/checks; go to step 4.

3. **Update the branch onto main** (only if `behind`). Merge main into the PR branch — counts as "up to date with main", no force-push, no local checkout:
   - If author is `dependabot[bot]` → `gh pr comment <number> --body "@dependabot rebase"`.
   - Otherwise → `gh pr update-branch <number>`.
   - If it fails because of conflicts, mark **blocked: conflicts** and move on. Do NOT force-push or rewrite history.
   - Record this PR as **updated** for the report.

4. **Check status checks** (REST check-runs above).
   - All `success` or still running → nothing to do; record state for the report.
   - One or more `failure` → go to step 5.

5. **Attempt to fix broken checks — ONCE per run.** This is the only step that changes PR code.
   - Read the failing check's logs: `gh run view --job <job-id> --log-failed` (job id is in the check-run's `details_url`, or via `gh run list --branch <head>`).
   - Only attempt a fix if the cause is clear and mechanical (e.g. a lockfile/schema/snapshot/version constraint the dependency bump left stale, a generated file out of date, a simple migration). For anything ambiguous, infra-level (CI runner / DB / service-container errors like `role "root" does not exist`), or risky, do NOT guess — mark **blocked: <reason>** and report.
   - To fix: `gh pr checkout <number>`, make the minimal change, `git commit -am "Fix CI for dependency update"`, `git push`.
   - **At most once per run.** If a prior `Fix CI for dependency update` commit already exists on the branch and checks are still failing, treat it as already-attempted — mark **blocked: checks still failing after fix attempt**, don't retry.

6. **Never merge.** Even if a PR is green and mergeable, leave it for the user.

7. **Report.** Concise summary grouped into:
   - **Updated onto main / rebase requested:** PRs you brought current or asked Dependabot to rebase (#, title).
   - **Fixed:** PRs where you pushed a check fix (#, title, what you changed).
   - **Ready (green, awaiting your merge):** PRs that are current + passing.
   - **Blocked:** PRs you couldn't prep, each with the reason (conflicts / rebase awaiting Dependabot / checks still failing / ambiguous or infra failure).
   - **No action needed:** count of PRs already current and passing.

Keep all git operations on PR branches only — never push to `main`. If `gh` isn't authenticated or the repo has no `dependencies`-labeled PRs, say so and stop.
