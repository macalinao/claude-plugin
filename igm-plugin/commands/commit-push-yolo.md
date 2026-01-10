---
allowed-tools:
  - Bash
  - Read
  - Grep
description: Commit all changes and push to the current branch
---

Commit and push all changes to the current branch. Follow these steps:

1. First, run these commands in parallel to understand the current state:
   - `git status` to see all changes
   - `git diff --staged` and `git diff` to see what will be committed
   - `git log -5 --oneline` to see recent commit style

2. Stage all changes with `git add -A`

3. Commit with a meaningful message based on the changes:

   ```bash
   git commit -m "$(cat <<'EOF'
   <commit message>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

4. Push to the current branch: `git push`

Important:

- Do NOT commit files that look like secrets (.env, credentials, etc.)
- Use conventional commit style if appropriate (feat:, fix:, chore:, etc.)
- Keep the commit message concise but descriptive
