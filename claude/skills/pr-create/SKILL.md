---
name: pr-create
description: Create a branch from the session name, stage all changes, push, and open a pull request.
disable-model-invocation: false
user-invocable: true
---

Create a branch, commit all changes, push, and open a pull request.

## Flags

- `-m` / `--merge`: After the PR is created and Copilot feedback is addressed, monitor the PR and auto-merge it once it is ready (all status checks green, rebased onto and mergeable into `main`). See step 16.

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

4. **Run quality passes, then stage and commit all changes.** First, before staging, clean up the uncommitted changes:
   - Run the `/simplify` skill to apply reuse/simplification/efficiency cleanups.
   - If the `ponytail:ponytail` skill is available, run it to strip over-engineering.

   These edit the working tree in place; review their changes, then stage all modified, deleted, and untracked files (but skip files that look like secrets: `.env*`, `credentials*`, `*secret*`). Write a clear, concise commit message summarizing the changes. End the commit message with:
   ```
   Co-Authored-By: Claude <noreply@anthropic.com>
   ```

5. **Push the branch:**
   ```
   git push -u origin <branch-name>
   ```

6. **Analyze the changes for the PR description.** Run `git diff main...HEAD` to see the full diff against main. Determine:
   - A short PR title (under 70 characters).
   - A description with up to 3 bullet points summarizing the changes.

   **If the changes are too complex to summarize in 3 bullets**, do NOT guess. Instead, present the user with at least 2 viable description options and ask them to pick one or provide their own. Each option should take a different angle (e.g., one focused on the feature, one on the technical approach).

7. **Create the pull request as a draft.** It stays a draft during the Copilot review ping-pong so the expensive CI (Unit Tests, which skips drafts) doesn't rerun on every round; you mark it ready in step 15b. Do NOT include a test plan section. Do NOT append any "Generated with Claude Code" note or similar footer.
   ```
   gh pr create --draft --title "<title>" --body "$(cat <<'EOF'
   ## Summary
   <up to 3 bullet points>
   EOF
   )"
   ```

8. **Output the PR URL** so the user can see it.

9. **Get repo info** for the Copilot steps below:
   ```
   gh repo view --json owner,name -q '.owner.login + "/" + .name'
   ```
   The PR number is the one you just created in step 7.

9b. **Request a Copilot review.** Draft PRs don't auto-trigger Copilot, so ask for it explicitly:
    ```
    gh api repos/{owner}/{repo}/pulls/{pr_number}/requested_reviewers \
      -X POST -f "reviewers[]=copilot-pull-request-reviewer[bot]"
    ```
    If that returns an error (e.g. Copilot reviews not enabled for the repo, or the bot slug differs), report it and continue — the poll in step 10 still catches a review if one lands.

10. **Wait for Copilot to finish its review.** Launch a background sub-agent (using the Agent tool with `run_in_background: true`) that polls every 60 seconds (up to 10 minutes). This frees the main conversation to handle other user requests while waiting. The sub-agent should run:
    ```
    for i in $(seq 1 10); do
      count=$(gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '[.[] | select(.user.login | test("copilot"; "i"))] | length')
      [ "$count" -gt 0 ] && echo "COPILOT_REVIEW_FOUND" && break
      sleep 60
    done
    ```
    Inform the user you're polling in the background. When the sub-agent completes, check its result. If no review appeared after 10 minutes, tell the user and stop.

11. **Fetch Copilot's review comments** by running:
    ```
    gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --jq '[.[] | select(.user.login | test("copilot"; "i")) | {id: .id, path: .path, line: .original_line, side: .side, body: .body}]'
    ```
    Replace `{owner}/{repo}` and `{pr_number}` with actual values.

    **Important:** Use `test("copilot"; "i")` (case-insensitive) for filtering — the actual login varies (`"Copilot"`, `"copilot-pull-request-reviewer"`, etc.). Do NOT include `diff_hunk` in the output — it bloats the response; use `path` and `line` to read the actual files instead.

    If there are no inline comments, also check the review body:
    ```
    gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '[.[] | select(.user.login | test("copilot"; "i")) | {id: .id, state: .state, body: .body}]'
    ```

    If there are still no comments, inform the user that Copilot hasn't left any actionable feedback and stop.

12. **Address each comment**: For every Copilot comment, read the referenced file, understand the issue, and fix it. Use the `path` and `line` fields to locate the exact code. Read all affected files in parallel where possible.

13. **Commit and push** all fixes in a single commit with a message like:
    `Address Copilot code review feedback`

14. **Reply to each comment on the PR** explaining what was changed, by running:
    ```
    gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="<your reply>"
    ```

15. **Resolve addressed Copilot review threads** so addressed comments don't clutter the PR view. Only resolve threads whose comments you actually fixed in step 12 — leave unaddressed or skipped threads open. First, fetch all review threads and find unresolved ones authored by Copilot:
    ```
    gh api graphql -f query='
      query {
        repository(owner: "{owner}", name: "{repo}") {
          pullRequest(number: {pr_number}) {
            reviewThreads(first: 100) {
              nodes {
                id
                isResolved
                comments(first: 1) {
                  nodes {
                    author { login }
                  }
                }
              }
            }
          }
        }
      }
    '
    ```
    Filter for Copilot threads using case-insensitive matching on the author login (it will be `copilot-pull-request-reviewer` in GraphQL, different from the REST API login).

    Then, for each unresolved Copilot thread that corresponds to a comment you addressed in step 12, resolve it:
    ```
    gh api graphql -f query='
      mutation {
        resolveReviewThread(input: {threadId: "{thread_id}"}) {
          thread { isResolved }
        }
      }
    '
    ```

15b. **Mark the PR ready for review.** Once Copilot's feedback is addressed (or Copilot left nothing actionable), flip the draft to ready — this is what triggers the full Unit Tests / Integration suite:
    ```
    gh pr ready {pr_number}
    ```
    (If the `-m` flag was passed, step 16 also handles this, but do it here anyway so tests start promptly.)

16. **(`-m` flag only) Monitor and merge when ready.** Skip this step entirely unless the user passed `-m`/`--merge`. Launch a background sub-agent (Agent tool, `run_in_background: true`) that polls every 60 seconds (up to 30 minutes) until the PR is ready, then merges it. The sub-agent should:
    - Skip drafts: if `gh pr view {pr_number} --json isDraft -q .isDraft` is `true`, mark the PR ready first (`gh pr ready {pr_number}`).
    - Each poll, check `gh pr view {pr_number} --json mergeStateStatus,mergeable,reviewDecision`:
      - `CLEAN` (or `UNSTABLE` with only non-required checks failing) and `mergeable == MERGEABLE` → ready.
      - `BEHIND` → rebase onto main with `gh pr update-branch --rebase {pr_number}`, then keep polling.
      - `BLOCKED` → checks still running or required review missing; keep polling.
      - `DIRTY` → merge conflict; stop and report — do NOT attempt to resolve.
    - When ready, merge with rebase: `gh pr merge {pr_number} --rebase --delete-branch`.

    Tell the user you're monitoring in the background. When the sub-agent finishes, report whether it merged or why it stopped. If still not ready after 30 minutes, report status and stop.

Follow the project standards in CLAUDE.md.
