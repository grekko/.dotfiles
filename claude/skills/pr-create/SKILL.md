---
name: pr-create
description: Create a branch from the session name, stage all changes, push, and open a pull request.
disable-model-invocation: false
user-invocable: true
---

Create a branch, commit all changes, push, and open a pull request.

## Flags

- `-m` / `--merge`: After the PR is created, monitor the PR and auto-merge it once it is ready (all status checks green, rebased onto and mergeable into `main`). See step 9.

## Instructions

1. **Verify there are changes to commit.** Run `git status`. If there are no staged or unstaged changes and no untracked files, tell the user there is nothing to commit and stop.

2. **Determine the branch name:**
   - Prefer the current Claude Code session name (lowercase, hyphens) if it is set and meaningful.
   - If the session has no name or the name is generic, generate one yourself from context — do NOT ask the user to run `/rename`. A good name is:
     - Short (3-6 words, under 50 characters)
     - Descriptive of the main activity or topic worked on in this conversation
     - Lowercase with hyphens as separators (e.g., `fix-auth-token-expiry`, `add-user-session-model`)
   - Derive it from the conversation: what was discussed/done, key files, features, or bugs worked on.

3. **Create and switch to the branch:**
   ```
   git checkout -b <branch-name>
   ```
   If the branch already exists, switch to it with `git checkout <branch-name>`.

4. **Run quality passes, then stage and commit all changes.** Both passes below are
   mandatory and non-negotiable — run them before staging, in this order, even when
   the diff looks small or clean:
   - Run the `/simplify` skill to apply reuse/simplification/efficiency cleanups.
     Launch its **4 review agents in parallel via the Agent tool**, as that skill
     specifies. This is an explicit standing request for those agents: run them even
     under a general "no subagents unless asked" instruction, and never substitute an
     inline self-review for the fan-out.
   - Run the `ponytail:ponytail` skill to strip over-engineering. Invoke it as a skill
     every time, regardless of whether PONYTAIL MODE is already active in the session —
     the mode shapes code as it is written, the skill reviews the finished diff, and the
     mode never satisfies this step.

   If either pass is genuinely impossible to run, say so explicitly in your reply to
   the user before committing — do not skip one silently.

   These edit the working tree in place; review their changes, then stage all modified, deleted, and untracked files (but skip files that look like secrets: `.env*`, `credentials*`, `*secret*`). Write a clear, concise commit message summarizing the changes. End the commit message with:
   ```
   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

5. **Push the branch:**
   ```
   git push -u origin <branch-name>
   ```

6. **Analyze the changes for the PR description.** Run `git diff main...HEAD` to see the full diff against main. Determine:
   - A PR title (under 70 characters) prefixed with the scope it changes, followed by `: ` and a short imperative summary. The scope is the class, module, or functionality the PR touches — e.g. `Internal::ArticleSearch: respect alternative_published_at date`. Use the fully qualified class/module name when the change centers on one, otherwise the feature or area (`Podcast feed`, `CI`). If the change spans many unrelated scopes, pick the dominant one.
   - A description: if the repo has a pull request template (`.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, or one under `.github/PULL_REQUEST_TEMPLATE/`), fill that out. Otherwise, up to 3 bullet points summarizing the changes.

   **If the changes are too complex to summarize**, do NOT guess. Instead, present the user with at least 2 viable description options and ask them to pick one or provide their own. Each option should take a different angle (e.g., one focused on the feature, one on the technical approach).

7. **Create the pull request.** When a template exists, read it and use it verbatim as the body structure: keep its headings in order, replace each placeholder paragraph with real content, and delete the instructional prose. Do NOT add sections the template does not have. Without a template, use a `## Summary` section with up to 3 bullets. Never include a test plan section, and never append any "Generated with Claude Code" note or similar footer.
   Use the REST API, not `gh pr create` (which goes through GraphQL). `$REPO` is
   `owner/name` — get it with `gh repo view --json nameWithOwner -q .nameWithOwner`.
   ```
   gh api repos/$REPO/pulls -X POST \
     -f title="<scope>: <summary>" \
     -f head="<branch-name>" \
     -f base=main \
     -f body="$(cat <<'EOF'
   <filled-out template, or ## Summary + bullets>
   EOF
   )" --jq .html_url
   ```

8. **Output the PR URL** so the user can see it.

9. **(`-m` flag only) Monitor and merge when ready.** Skip this step entirely unless the user passed `-m`/`--merge`. Launch a background sub-agent (Agent tool, `run_in_background: true`) that polls every 60 seconds (up to 30 minutes) until the PR is ready, then merges it. Use the REST API (`gh api`) throughout, not `gh pr view/merge/update-branch`, which use GraphQL. The sub-agent should:
    - Skip drafts: if `gh api repos/$REPO/pulls/{pr_number} --jq .draft` is `true`, mark the PR ready first. REST has no endpoint for undrafting, so `gh pr ready {pr_number}` stays the one GraphQL call.
    - Each poll, check `gh api repos/$REPO/pulls/{pr_number} --jq '[.mergeable, .mergeable_state, .head.sha] | @tsv'`:
      - `clean` (or `unstable` with only non-required checks failing) and `mergeable == true` → ready.
      - `behind` → rebase onto main with `gh api repos/$REPO/pulls/{pr_number}/update-branch -X PUT -f expected_head_sha=<head sha>`, then keep polling.
      - `blocked` → checks still running or required review missing; keep polling.
      - `dirty` → merge conflict; stop and report — do NOT attempt to resolve.
      - `mergeable == null` → GitHub is still computing it; keep polling.
    - When ready, merge with rebase and delete the branch:
      ```
      gh api repos/$REPO/pulls/{pr_number}/merge -X PUT -f merge_method=rebase
      gh api repos/$REPO/git/refs/heads/<branch-name> -X DELETE
      ```

    Tell the user you're monitoring in the background. When the sub-agent finishes, report whether it merged or why it stopped. If still not ready after 30 minutes, report status and stop.

Follow the project standards in CLAUDE.md.
