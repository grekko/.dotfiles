---
name: pr-address-copilot-comments
description: After creating or pushing to a PR, wait for GitHub Copilot's code review and address all comments.
user-invocable: true
---

Address GitHub Copilot's code review comments on the current PR.

## Instructions

1. **Get the current PR number** by running:
   ```
   gh pr view --json number -q .number
   ```
   If there's no PR for the current branch, tell the user and stop.

2. **Wait 10 minutes** for Copilot to finish its review. Run `sleep 600` in the background and inform the user you're waiting. After the sleep completes, proceed.

3. **Fetch Copilot's review comments** by running:
   ```
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --jq '[.[] | select(.user.login | contains("copilot")) | {id: .id, path: .path, line: .original_line, side: .side, body: .body, diff_hunk: .diff_hunk}]'
   ```
   Replace `{owner}/{repo}` and `{pr_number}` with actual values (use `gh repo view --json owner,name` to get owner/repo).

   If there are no Copilot comments, also check the review body:
   ```
   gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '[.[] | select(.user.login | contains("copilot")) | {id: .id, state: .state, body: .body}]'
   ```

   If there are still no comments, inform the user that Copilot hasn't reviewed yet and stop.

4. **Address each comment**: For every Copilot comment, read the referenced file, understand the issue, and fix it. Use the `path` and `line` fields to locate the exact code.

5. **Commit and push** all fixes in a single commit with a message like:
   `Address Copilot code review feedback`

6. **Reply to each comment on the PR** explaining what was changed, by running:
   ```
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="<your reply>"
   ```

Follow the project standards in CLAUDE.md.
