---
name: linear-issue-workflow
description: "End-to-end workflow to fix a Linear issue: analyze, branch, implement, test, commit, push, and open a PR. Use when: fixing a Linear ticket, working on a Linear issue, implementing a DRA/ENG ticket, creating a branch for Linear, opening a PR for an issue."
argument-hint: "Linear issue identifier (e.g., DRA-5005)"
---

# Linear Issue Workflow

## When to Use

- Starting work on a Linear issue
- Full workflow from issue analysis to PR creation

## Required Tools

This workflow requires access to: Linear, GitHub, and optionally Figma (if designs are attached).

## Procedure

### Step 1: Analyze the Issue

- Fetch the Linear issue details using the provided identifier. If the identifier is invalid, not found, or missing, stop and prompt the user to provide a valid Linear issue identifier before continuing.
- Read all attached comments and sub-issues
- If Figma links are found in the issue description or comments, use the Figma tool to fetch the design details (token such as sizes, colors, typography and layout) to inform the implementation
- Present a brief summary (2-4 sentences) of the problem, expected behavior, and planned approach. Wait for the user to confirm or correct before proceeding to Step 2

### Step 2: Create a Branch

#### Select Base Branch

1. **If the ticket belongs to an ongoing Linear project**, check whether a `feature/<feature-name>` branch already exists for that project. If it does, use it as the base branch.
2. **Otherwise**, determine the base branch with the following command (use the first branch that exists):

```sh
# Priority order: `staging` → `main` → `master`

for b in staging main master; do git show-ref --verify --quiet refs/remotes/origin/$b && echo $b && break; done
```

#### Update Base Branch

- Pull the latest changes from the base branch before creating the new branch.
  - If pulling fails due to merge conflicts or network issues, display the error and ask the user to resolve before continuing.

#### Create and Checkout New Branch

- Create a new branch named: `em/<squad-prefix-lowercased>-<number>`, e.g. `em/dra-5005` or `em/vel-1234` (extract the prefix and number from the issue identifier)
  - If the branch already exists, ask the user whether to check it out and continue from where it left off, or delete and recreate it.
- Checkout the new branch

### Step 3: Implement the Fix

- Implement the necessary changes based on the issue analysis
  - If multiple implementation approaches are viable, briefly present them and let the user choose. For straightforward changes, proceed directly.
- Follow existing code patterns by examining files in the same directory/module as the changes. Check for linter/formatter configs (e.g., .eslintrc, .prettierrc) and apply them.

### Step 4: Manual Verification

- **Stop and prompt the user** to manually check the UI
- Provide specific instructions on what to verify:
  - Which page/route to navigate to
  - What actions to perform
  - What the expected behavior should be
- **Wait for user confirmation** before proceeding

### Step 5: Tests

- Once the user confirms the fix works:
  - Update existing tests if they cover the changed behavior
  - Create new tests for the new/fixed functionality
  - Run the tests related to the changes to confirm they pass
  - If tests fail, analyze the failures, fix them, and re-run. If failures are unrelated to the current change, inform the user and ask how to proceed.

### Step 6: Commit

- Stage only the files modified or created as part of this fix. Do not stage unrelated changes.
- Commit using **conventional commit syntax without scope**
  - Choose the commit type based on the Linear issue: use `fix:` for bug fixes, `feat:` for new features, `refactor:` for code restructuring, `chore:` for maintenance tasks, `test:` for test-related changes, etc.
  - e.g., `fix: handle empty state in activity report`
  - e.g., `feat: add OAuth token refresh flow`

### Step 7: Push

- Push the branch to GitHub
- If the push fails, display the error and suggest the user check their Git authentication and remote permissions

### Step 8: Create the PR

Use the `linear-create-pr` skill with the current Linear issue identifier.

## Constraints

**Branching:**

- Branch naming must follow the `em/<squad-prefix-lowercased>-<number>` pattern exactly (e.g., `em/dra-5005`, `em/vel-1234`)

**Commits:**

- Always use conventional commit syntax without scope (e.g., `fix: ...`, `feat: ...`)

**Verification & Review (never skip):**

- Never skip the manual verification step (Step 4)
- Never open the PR without user review of the content (Step 8)
