# igm Claude Plugin

Personal Claude Code plugin with coding agents and commands.

## Skills

### react-stack-engineer

Expert React agent for writing, reviewing, and refactoring React code with:
- React + TypeScript + Vite
- Tailwind CSS v4
- React Query (TanStack Query)
- ShadCN components
- Zod validation
- Bun package manager

### typescript-stack-engineer

Expert TypeScript agent for non-React code with:
- TypeScript strict mode
- Bun runtime and test runner
- Zod validation
- One function per file pattern
- Kebab-case file naming

### check-and-fix

Runs TypeScript checks and linting, automatically fixing all errors:
- Runs `bun run typecheck` and `bun run lint:fix`
- Fixes remaining errors manually
- Verifies all tests pass

## Commands

### /commit-push-pr

Commits all changes, pushes, and creates a pull request. Automatically:
- Detects if on main/master branch
- Creates feature branches when needed
- Reuses existing PRs when possible

### /check-and-fix

Runs TypeScript and lint checks, fixing all errors automatically.

## Installation

### From GitHub

```bash
# Clone the repository
git clone https://github.com/macalinao/claude-plugin.git

# Add the marketplace
claude plugin marketplace add ~/path/to/claude-plugin

# Install the plugin
claude plugin install igm@igm-plugins
```

Then restart Claude Code for changes to take effect.
