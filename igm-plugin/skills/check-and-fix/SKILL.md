---
name: check-and-fix
description: Run TypeScript checks and fix all errors (project)
model: sonnet
tools: Bash, Edit, Read, Glob, Grep
---

Run the following commands in parallel to identify and fix errors:

1. Run `bun run typecheck` to identify TypeScript errors
2. Run `bun run lint:fix` to identify and automatically fix linting errors

Then fix remaining errors:

1. Fix each TypeScript error found by:
   - Reading the affected files
   - Understanding the error context
   - Making the necessary code changes to resolve the errors
2. If there are any remaining linting errors that couldn't be auto-fixed, manually fix them
3. Run both `bun run typecheck` and `bun run lint` again to verify all errors are resolved. IF THE ERRORS ARE NOT RESOLVED, REPEAT THE ENTIRE PROCESS.
4. Run `bun run test` in the root to ensure no tests were broken.
5. Provide a summary of what was fixed

Be thorough and ensure all errors are resolved and tests pass before completing the task.
