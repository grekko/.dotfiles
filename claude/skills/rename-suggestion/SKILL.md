---
name: rename-suggestion
description: Analyze conversation context and suggest a meaningful session name for /rename.
user-invocable: true
---

Suggest a concise, meaningful name for the current session.

## Instructions

1. **Gather context** by considering (do NOT run additional commands unless needed):
   - The current git branch name
   - What was discussed and done in this conversation so far
   - Any key files, features, or bugs worked on

2. **Generate a session name** that is:
   - Short (3-6 words, under 50 characters)
   - Descriptive of the main activity or topic
   - Lowercase with hyphens as separators (e.g., `fix-auth-token-expiry`, `add-user-session-model`)

3. **Output the suggestion** in this format:
   ```
   Suggested session name: <name>
   ```
   Then tell the user they can apply it by typing: `/rename <name>`
