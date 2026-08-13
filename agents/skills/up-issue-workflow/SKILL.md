---
name: up-issue-workflow
description: "End-to-end workflow to fix a Linear issue: analyze, branch, implement, test, commit, push, and open a PR. Use when: fixing a Linear ticket, working on a Linear issue, implementing a DRA/ENG ticket, creating a branch for Linear, opening a PR for an issue."
argument-hint: "Linear issue identifier (e.g., DRA-5005)"
---

# Linear Issue Workflow

## When to Use

- Starting work on a Linear issue
- Full workflow from issue analysis to PR creation

## Tools

- Linear MCP: issue, comments, sub-issues, status, and assignee.
- Figma MCP: only when the issue or its comments include a Figma URL.
- `git`: all local branch, diff, commit, and push operations.
- `gh`: GitHub authentication and remote operations.

## Procedure

### Step 1: Analyze the Issue

- Fetch the Linear issue details using the provided identifier. If the identifier is invalid, not found, or missing, stop and prompt the user to provide a valid Linear issue identifier before continuing.
- Read all attached comments and sub-issues
- If Figma links are found in the issue description or comments, use the Figma tool to fetch the design details (token such as sizes, colors, typography and layout) to inform the implementation
- Present a brief summary (2-4 sentences) of the problem, expected behavior, and planned approach. Wait for the user to confirm or correct before proceeding to Step 2

### Step 2: Ensure Issue Status and Ownership

- Verify the issue status is `In Progress`.
  - If not, update the issue status to `In Progress` before continuing.
- Verify the issue assignee is the currently authenticated Linear user (e.g. `Edouard Misset`).
  - If not, assign the issue to the currently authenticated Linear user before continuing.
- If either update fails due to permissions or API errors, stop and ask the user how to proceed.

### Step 3: Create a Branch

```sh
set -euo pipefail
test -z "$(git status --porcelain)" || {
  printf '%s\n' 'Worktree has uncommitted changes; stop.' >&2
  exit 1
}
git fetch origin --prune
branch="em/$(printf '%s' "$issue_id" | tr '[:upper:]' '[:lower:]')"
base=''
for candidate in "${project_branch:-}" staging main master; do
  test -n "$candidate" || continue
  if git show-ref --verify --quiet "refs/remotes/origin/$candidate"; then
    base=$candidate
    break
  fi
done
test -n "$base" || {
  printf '%s\n' 'No project, staging, main, or master remote branch found.' >&2
  exit 1
}
```

- Set `project_branch` only when the Linear issue or project explicitly gives a `feature/<name>` branch. Do not infer one from the project title.
- `base` is the first existing remote branch in this order: explicit project branch, `staging`, `main`, `master`.

```sh
if git show-ref --verify --quiet "refs/heads/$branch"; then
  printf '%s\n' "Branch already exists: $branch"
else
  git switch --detach "origin/$base"
  git switch -c "$branch"
fi
```

- If the branch exists, tell the user and run `git switch "$branch"` and continue; never delete or recreate it without a separate explicit request.
- When invoking `up-create-pr`, pass `project_branch="$base"` so it targets the verified base selected here.

### Step 4: Implement the Fix

- Implement the necessary changes based on the issue analysis
  - If multiple implementation approaches are viable, briefly present them and let the user choose. For straightforward changes, proceed directly.
- Follow existing code patterns by examining files in the same directory/module as the changes. Check for linter/formatter configs (e.g., .eslintrc, .prettierrc) and apply them.

### Step 5: Manual Verification

- **Stop and prompt the user** to manually check the UI
- Provide specific instructions on what to verify:
  - Which page/route to navigate to
  - What actions to perform
  - What the expected behavior should be
- **Wait for user confirmation** before proceeding

### Step 6: Tests

- Once the user confirms the fix works:
  - Update existing tests if they cover the changed behavior
  - Create new tests for the new/fixed functionality
  - Run the tests related to the changes to confirm they pass
  - If tests fail, analyze the failures, fix them, and re-run. If failures are unrelated to the current change, inform the user and ask how to proceed.

### Step 7: Commit

```sh
git diff --check
git status --short
git add -- path/to/changed-file
git diff --cached --check
git diff --cached --stat
git diff --cached
git commit -m 'fix: concise imperative summary'
```

- Replace `path/to/changed-file` with only files changed for this issue; never use `git add -A` or `git add .`.
- Use conventional commit syntax without a scope. Valid examples: `fix: handle empty state in activity report`, `feat: add OAuth token refresh flow`.
- If the staged diff contains unrelated changes, unstage them with `git restore --staged -- <path>` and re-check before committing.

### Step 8: Push

```sh
git push --set-upstream origin "$branch"
```

- If the push fails, show the error and stop. Do not force-push or alter the remote without an explicit user request.

### Step 9: Create the PR

Use the `up-create-pr` skill with the current Linear issue identifier.

## Constraints

**Branching:**

- Branch naming must follow the `em/<squad-prefix-lowercased>-<number>` pattern exactly (e.g., `em/dra-5005`, `em/vel-1234`)

**Commits:**

- Always use conventional commit syntax without scope (e.g., `fix: ...`, `feat: ...`)

**Verification & Review (never skip):**

- Never skip the manual verification step (Step 5)
- Never open the PR without user review of the content (Step 9)
