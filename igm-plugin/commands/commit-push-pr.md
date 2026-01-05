---
allowed-tools:
  - Bash
  - Read
  - Grep
description: Commit all changes, create a new branch, push, and create a pull request
---

Create a pull request with all current changes. Follow these steps:

1. First, run these commands in parallel to understand the current state:

   - `git status` to see all changes
   - `git diff --staged` and `git diff` to see what will be committed
   - `git log -5 --oneline` to see recent commit style
   - `git branch --show-current` to get the current branch name
   - `gh pr view --json url,state 2>/dev/null || echo "no-pr"` to check if there's an existing PR

2. Stage all changes with `git add -A`

3. Create a meaningful commit message based on the changes:

   - Summarize what was changed
   - Use conventional commit style if appropriate (feat:, fix:, chore:, etc.)
   - End with the standard Claude Code footer

4. If on the main branch (main or master), create a new branch:

   - Generate a good branch name based on the changes
   - Use kebab-case
   - Be descriptive but concise (e.g., `feat/add-user-auth`, `fix/login-validation`)
   - Prefix with feat/, fix/, chore/, refactor/, docs/ as appropriate
   - Create and switch to the new branch: `git checkout -b <branch-name>`

5. Commit the changes with a HEREDOC for proper formatting:

   ```bash
   git commit -m "$(cat <<'EOF'
   <commit message>

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
   EOF
   )"
   ```

6. Push the branch: `git push -u origin <branch-name>`

7. Check if a PR already exists for this branch (from step 1):

   - If a PR already exists and is open, skip PR creation and return the existing PR URL
   - If no PR exists, create one using `gh pr create`:

     ```bash
     gh pr create --title "<title>" --body "$(cat <<'EOF'
     ## Summary
     <bullet points describing changes>

     🤖 Generated with [Claude Code](https://claude.com/claude-code)
     EOF
     )"
     ```

     Return the PR URL to the user.

Important:

- Do NOT commit files that look like secrets (.env, credentials, etc.)
- Base the PR on the default branch (main or master)
- Make the PR title and description meaningful based on actual changes
- If a PR already exists for the current branch, just push and show the existing PR URL
