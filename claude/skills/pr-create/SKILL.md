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

9. **Run the `/pr-address-copilot-comments` skill** to wait for and address Copilot's code review.

Follow the project standards in CLAUDE.md.
