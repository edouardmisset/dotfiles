---
name: linear-issue-workflow
description: 'End-to-end workflow to fix a Linear issue: analyze, branch, implement, test, commit, push, and open a PR. Use when: fixing a Linear ticket, working on a Linear issue, implementing a DRA/ENG ticket, creating a branch for Linear, opening a PR for an issue.'
argument-hint: 'Linear issue identifier (e.g., DRA-5005)'
---

# Linear Issue Workflow

## When to Use
- Starting work on a Linear issue
- Full workflow from issue analysis to PR creation

## Required Tools
This workflow requires access to: Linear, GitHub, and optionally Figma (if designs are attached).

## Procedure

### Step 1: Analyze the Issue
- Fetch the Linear issue details using the provided identifier
- Read all attached comments and sub-issues
- If Figma links are attached, inspect the designs
- Summarize the issue and confirm understanding with the user

### Step 2: Create a Branch
- Fetch the latest default branch (`staging`, falling back to `master` or `main`)
- Create a new branch named: `em/dra-<linear-issue-number>` (extract the number from the issue identifier)
- Checkout the new branch

### Step 3: Implement the Fix
- Implement the necessary changes based on the issue analysis
- Follow existing code patterns and conventions in the repository

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
  - Run the test suite to confirm everything passes

### Step 6: Commit
- Stage all changes
- Commit using **conventional commit syntax without scope**
  - e.g., `fix: handle empty state in activity report`
  - e.g., `feat: add OAuth token refresh flow`

### Step 7: Push
- Push the branch to GitHub

### Step 8: Open the PR
- Prepare the PR using the repository's PR template
- Title: use the Linear ticket title exactly
- In the "Related to" section, add: `[#<issue-number>](<linear-issue-url>)`
- If the "Developers heads up" section is not applicable, set it to "N/A"
- **Save the PR content as a temporary markdown file**
- **Prompt the user to review and edit the markdown file**
- **Wait for the user to close the file**
- Create the PR on GitHub with the final content
- Delete the temporary markdown file

## Constraints
- Never skip the manual verification step
- Never open the PR without user review of the content
- Always use conventional commits without scope
- Branch naming must follow the `em/dra-<number>` pattern
