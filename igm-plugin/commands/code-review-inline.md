---
allowed-tools:
  - Bash(git diff*)
  - Bash(git status*)
  - Read
  - Glob
  - Grep
  - Task
description: Code review uncommitted local changes
---

Code review uncommitted local changes (staged and unstaged) for bugs and CLAUDE.md compliance.

## Process

1. Run `git diff HEAD` to get all uncommitted changes. If empty, inform the user and stop.

2. Use `Glob` to find relevant CLAUDE.md files:
   - Root CLAUDE.md if it exists
   - CLAUDE.md files in directories containing modified files

3. Launch 2 agents in parallel to review the changes:

   **Agent 1: CLAUDE.md compliance (sonnet)**
   Check changes against applicable CLAUDE.md rules. Only flag clear, unambiguous violations where you can quote the exact rule being broken.

   **Agent 2: Bug detection (opus)**
   Scan for bugs in the introduced code: syntax errors, type errors, missing imports, clear logic errors, security issues. Only flag issues you can validate from the diff context.

   Both agents must return issues with: file path, line number(s), description, category.

   **HIGH SIGNAL ONLY.** Do NOT flag:
   - Code style or quality concerns
   - Potential issues that depend on specific inputs
   - Subjective suggestions
   - Issues a linter would catch
   - Pre-existing issues

4. Output results:

   If no issues: "No issues found. Checked for bugs and CLAUDE.md compliance."

   If issues found, list each with:
   - File path and line number(s)
   - Description
   - Category (bug, CLAUDE.md violation)
   - Suggested fix if applicable

## Notes

- Quote exact CLAUDE.md rules when flagging violations
- Reference specific line numbers
- When uncertain, don't flag it - false positives erode trust
