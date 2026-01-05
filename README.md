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

## Commands

### /commit-push-pr

Commits all changes, pushes, and creates a pull request. Automatically:
- Detects if on main/master branch
- Creates feature branches when needed
- Reuses existing PRs when possible

## Installation

### Quick Testing (session only)

```bash
claude --plugin-dir ~/proj/macalinao/claude-plugin/igm-plugin
```

This loads the plugin for the current session only.

### Permanent Installation

```bash
# Add the marketplace
claude plugin marketplace add /path/to/claude-plugin

# Install the plugin
claude plugin install igm@igm-plugins
```

Then restart Claude Code for changes to take effect.
