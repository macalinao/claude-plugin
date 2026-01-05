---
allowed-tools:
  - Bash
  - Read
description: Commit all changes, push, and create a pull request (creates new branch only if needed)
---

Run the following bash script to commit, push, and create a PR. The script will output what changes are being committed - use that to provide a meaningful commit message when prompted.

```bash
bash -c '
set -euo pipefail

RED="\033[0;31m"; GREEN="\033[0;32m"; YELLOW="\033[1;33m"; BLUE="\033[0;34m"; NC="\033[0m"
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

command -v gh >/dev/null 2>&1 || { log_error "gh CLI is required"; exit 1; }

CURRENT_BRANCH=$(git branch --show-current)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed "s@^refs/remotes/origin/@@" || echo "main")

# Check for existing PR
EXISTING_PR_URL=""; EXISTING_PR_STATE=""
if EXISTING_PR=$(gh pr view --json url,state 2>/dev/null); then
    EXISTING_PR_URL=$(echo "$EXISTING_PR" | jq -r ".url // empty" 2>/dev/null || echo "")
    EXISTING_PR_STATE=$(echo "$EXISTING_PR" | jq -r ".state // empty" 2>/dev/null || echo "")
fi

# Check if current commit matches default branch
CURRENT_SHA=$(git rev-parse HEAD)
DEFAULT_SHA=$(git rev-parse "origin/$DEFAULT_BRANCH" 2>/dev/null || git rev-parse "$DEFAULT_BRANCH" 2>/dev/null || echo "")

# Determine if new branch needed: no open PR AND (on default branch OR same commit as default)
NEEDS_NEW_BRANCH=false
if [[ -z "$EXISTING_PR_URL" || "$EXISTING_PR_STATE" != "OPEN" ]]; then
    if [[ "$CURRENT_SHA" == "$DEFAULT_SHA" ]] || [[ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]]; then
        NEEDS_NEW_BRANCH=true
    fi
fi

# Check for changes
if git diff --quiet && git diff --staged --quiet && [[ -z "$(git ls-files --others --exclude-standard)" ]]; then
    log_warn "No changes to commit"
    [[ -n "$EXISTING_PR_URL" ]] && log_success "Existing PR: $EXISTING_PR_URL"
    exit 0
fi

# Check for secrets
SECRETS_PATTERN="\.env$|\.env\.|credentials|secrets|\.pem$|\.key$|id_rsa|id_ed25519"
if git diff --name-only --cached 2>/dev/null | grep -qE "$SECRETS_PATTERN" || \
   git ls-files --others --exclude-standard | grep -qE "$SECRETS_PATTERN"; then
    log_error "Potentially sensitive files detected! Review before committing."
    exit 1
fi

# Stage and show changes
git add -A
echo ""
log_info "Changes to be committed:"
git diff --staged --stat
echo ""
log_info "Diff summary:"
git diff --staged --shortstat
echo ""
echo "NEEDS_NEW_BRANCH=$NEEDS_NEW_BRANCH"
echo "CURRENT_BRANCH=$CURRENT_BRANCH"
echo "DEFAULT_BRANCH=$DEFAULT_BRANCH"
echo "EXISTING_PR_URL=$EXISTING_PR_URL"
'
```

Based on the changes shown above, provide:

1. A **commit message** - use conventional commit style (feat:, fix:, chore:, etc.)
2. A **branch name** (only if `NEEDS_NEW_BRANCH=true`) - use kebab-case with prefix (e.g., `feat/add-user-auth`, `fix/login-validation`)

Then run the commit and push script:

```bash
bash -c '
set -euo pipefail

COMMIT_MSG="$1"
NEW_BRANCH_NAME="${2:-}"

RED="\033[0;31m"; GREEN="\033[0;32m"; BLUE="\033[0;34m"; NC="\033[0m"
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }

CURRENT_BRANCH=$(git branch --show-current)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed "s@^refs/remotes/origin/@@" || echo "main")

# Check for existing PR
EXISTING_PR_URL=""; EXISTING_PR_STATE=""
if EXISTING_PR=$(gh pr view --json url,state 2>/dev/null); then
    EXISTING_PR_URL=$(echo "$EXISTING_PR" | jq -r ".url // empty" 2>/dev/null || echo "")
    EXISTING_PR_STATE=$(echo "$EXISTING_PR" | jq -r ".state // empty" 2>/dev/null || echo "")
fi

CURRENT_SHA=$(git rev-parse HEAD)
DEFAULT_SHA=$(git rev-parse "origin/$DEFAULT_BRANCH" 2>/dev/null || git rev-parse "$DEFAULT_BRANCH" 2>/dev/null || echo "")

NEEDS_NEW_BRANCH=false
if [[ -z "$EXISTING_PR_URL" || "$EXISTING_PR_STATE" != "OPEN" ]]; then
    if [[ "$CURRENT_SHA" == "$DEFAULT_SHA" ]] || [[ "$CURRENT_BRANCH" == "$DEFAULT_BRANCH" ]]; then
        NEEDS_NEW_BRANCH=true
    fi
fi

# Create new branch BEFORE committing if needed
if [[ "$NEEDS_NEW_BRANCH" == "true" && -n "$NEW_BRANCH_NAME" ]]; then
    log_info "Creating branch: $NEW_BRANCH_NAME"
    git checkout -b "$NEW_BRANCH_NAME"
    CURRENT_BRANCH="$NEW_BRANCH_NAME"
fi

# Commit
COMMIT_FOOTER="

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git commit -m "${COMMIT_MSG}${COMMIT_FOOTER}"
log_success "Changes committed"

# Push
log_info "Pushing to origin/$CURRENT_BRANCH..."
git push -u origin "$CURRENT_BRANCH"
log_success "Pushed"

# Create or show PR
if [[ -n "$EXISTING_PR_URL" && "$EXISTING_PR_STATE" == "OPEN" ]]; then
    log_success "PR updated: $EXISTING_PR_URL"
    echo "$EXISTING_PR_URL"
else
    log_info "Creating PR..."
    COMMIT_MSGS=$(git log "origin/$DEFAULT_BRANCH..HEAD" --format="- %s" 2>/dev/null | head -20 || git log -1 --format="- %s")
    PR_TITLE=$(echo "$COMMIT_MSG" | head -1)
    PR_BODY="## Summary
${COMMIT_MSGS}

## Test plan
- [ ] Tested locally

🤖 Generated with [Claude Code](https://claude.com/claude-code)"

    PR_URL=$(gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base "$DEFAULT_BRANCH")
    log_success "PR created: $PR_URL"
    echo "$PR_URL"
fi
' -- "<COMMIT_MESSAGE>" "<BRANCH_NAME>"
```

Replace:

- `<COMMIT_MESSAGE>` with the commit message
- `<BRANCH_NAME>` with the branch name (only needed if `NEEDS_NEW_BRANCH=true`, otherwise omit or leave empty)
