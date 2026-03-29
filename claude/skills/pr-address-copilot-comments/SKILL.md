---
name: pr-address-copilot-comments
description: After creating or pushing to a PR, wait for GitHub Copilot's code review and address all comments.
user-invocable: true
---

Address GitHub Copilot's code review comments on the current PR.

## Instructions

1. **Get the current PR number and repo info** by running these in parallel:
   ```
   gh pr view --json number -q .number
   gh repo view --json owner,name -q '.owner.login + "/" + .name'
   ```
   If there's no PR for the current branch, tell the user and stop.

2. **Wait for Copilot to finish its review.** Poll every 60 seconds (up to 10 minutes) instead of a blind 10-minute sleep — Copilot often finishes within 2–3 minutes:
   ```
   for i in $(seq 1 10); do
     count=$(gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '[.[] | select(.user.login | test("copilot"; "i"))] | length')
     [ "$count" -gt 0 ] && break
     sleep 60
   done
   ```
   Inform the user you're polling. If no review appears after 10 minutes, tell the user and stop.

3. **Fetch Copilot's review comments** by running:
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

4. **Address each comment**: For every Copilot comment, read the referenced file, understand the issue, and fix it. Use the `path` and `line` fields to locate the exact code. Read all affected files in parallel where possible.

5. **Commit and push** all fixes in a single commit with a message like:
   `Address Copilot code review feedback`

6. **Reply to each comment on the PR** explaining what was changed, by running:
   ```
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="<your reply>"
   ```

7. **Resolve addressed Copilot review threads** so addressed comments don't clutter the PR view. Only resolve threads whose comments you actually fixed in step 4 — leave unaddressed or skipped threads open. First, fetch all review threads and find unresolved ones authored by Copilot:
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

   Then, for each unresolved Copilot thread that corresponds to a comment you addressed in step 4, resolve it:
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
