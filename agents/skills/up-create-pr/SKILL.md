---
name: up-create-pr
description: "Create a GitHub PR for a Linear issue branch using the repository's PR template, with Linear issue linking and user review. Use when: opening a PR for a Linear ticket, creating a pull request for Linear, submitting Linear work for review."
argument-hint: "Linear issue identifier (e.g., DRA-1234)"
disable-model-invocation: true
---

## Scope Guard

Resolve the current repository from the active workspace or `git rev-parse --show-toplevel`; do not assume a home-directory path. Before a GitHub write, verify that the target repository belongs to the `upfluence` organization and confirm each write immediately before performing it.

# Create PR for Linear Issue

## When to Use

- Opening a pull request for a Linear issue branch
- Creating a PR after completing work on a Linear ticket
- Submitting Linear issue changes for review

## Required Tools

This skill requires access to: Linear and GitHub.

## Procedure

### Step 1: Resolve the Linear Issue

- If a Linear issue identifier is provided, use it directly.
- Otherwise, detect it from the current branch name using the documented `<initials>/<linear-id>[/description]` format (for example, `jd/dra-1234/fix-empty-state` → `DRA-1234`). Also accept an identifier found in the current PR title or body.
  - If no identifier can be extracted, prompt the user for it rather than guessing from the branch name.
- Fetch the Linear issue details (title, URL, identifier). If the issue is not found, stop and ask the user to provide a valid identifier.

### Step 2: Determine the Base Branch

- Identify the base branch for the PR target with the following command (use the first branch that exists):

```sh
# Priority order for Upfluence apps: `staging` → `main` → `master`
for b in staging main master; do git show-ref --verify --quiet refs/remotes/origin/$b && echo $b && break; done
```

- If the current branch is based on an existing `feature/<feature-name>` branch, use the GitHub base branch name `feature/<feature-name>` without an `origin/` or `remote/` prefix.
- If no base branch is found, stop and ask the user which existing remote branch should be targeted. Never create a PR with an empty or guessed base.

### Step 3: Prepare PR Content

- Use the repository's configured PR template when one exists; otherwise create the draft with sections for purpose, observable changes, developer notes, checklist, and additional notes.
- Fill in the template:
  - **Title**: use the Linear ticket title exactly
  - **"Related to" section**: add `[#<issue-number>](<linear-issue-url>)` (e.g., `[#DRA-1234](https://linear.app/upfluence/issue/DRA-1234)`)
  - **"Developers heads up" section**: set to "N/A" if not applicable
  - **Additional Notes**: set to "N/A" if not applicable

### Step 4: Review PR Content with User

- **Save the PR content as a temporary markdown file named `tmp-pr-draft.md` in the repository root and open it for editing**
- **Prompt the user to review and edit the markdown file, then confirm they have finished before proceeding**
- Never create the PR without user review

### Step 5: Create the PR on GitHub

- Create the PR on GitHub using the gh cli with the final content from `tmp-pr-draft.md`
  - If PR creation fails (e.g., API error), show the error to the user
  - If a PR already exists for this branch, provide the existing PR link instead
- After successful PR creation, add the current git user (as returned by: `gh api user`) as an assignee
- Display the PR URL
- Prompt the user whether they want to generate a test link for the PR.
  - If they confirm, add the following label to the PR: `actions/fe-deploy-preview`
  - If they don't, continue without adding the label

### Step 6: Cleanup

- Delete the temporary markdown file (`tmp-pr-draft.md`) after PR creation
- Ensure cleanup happens regardless of success or failure — if the workflow is aborted at any point after the file was created, delete it

### Step 7: Optionally Notify Squad on Linear

- Prompt the user whether they want to add a new comment on the Linear issue to tag squad-mates for review.
- If they confirm, let the user edit the handles and message, then ask for confirmation immediately before posting the comment.
- Use this template without hardcoded colleague names:

```txt
Ready for review

<reviewer handles>
```

- Separately ask whether to change the Linear issue to `In Review`. Only perform that transition after confirmation.

## Constraints

**Review (never skip):**

- Never create the PR without user review of the draft content (Step 4)

**Title:**

- PR title must match the Linear ticket title exactly

**Cleanup:**

- Always delete `tmp-pr-draft.md` after completion or abort

**Writes:**

- Confirm each GitHub or Linear write immediately before performing it.
