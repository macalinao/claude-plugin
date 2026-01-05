---
allowed-tools:
  - Task
description: Run TypeScript checks and fix all errors (project)
---

Run the check-and-fix agent using the Task tool with `subagent_type: 'check-and-fix'`. This agent will:

1. Run `bun run typecheck` to identify TypeScript errors
2. Run `bun run lint:fix` to identify and automatically fix linting errors
3. Fix remaining errors manually
4. Verify all errors are resolved and tests pass

Use the following prompt for the agent:

"Run TypeScript checks and fix all errors in the project. Be thorough and ensure all errors are resolved before completing."
