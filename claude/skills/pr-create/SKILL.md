---
name: pr-create
description: Create a branch from the session name, stage all changes, push, and open a pull request.
disable-model-invocation: true
user-invocable: true
---

Create a branch, commit all changes, push, and open a pull request.

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

4. **Stage and commit all changes.** Stage all modified, deleted, and untracked files (but skip files that look like secrets: `.env*`, `credentials*`, `*secret*`). Write a clear, concise commit message summarizing the changes. End the commit message with:
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

7. **Create the pull request.** Do NOT include a test plan section. Do NOT append any "Generated with Claude Code" note or similar footer.
   ```
   gh pr create --title "<title>" --body "$(cat <<'EOF'
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

Follow the project standards in CLAUDE.md.
