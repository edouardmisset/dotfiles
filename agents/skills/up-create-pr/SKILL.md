---
name: up-create-pr
description: "Create a GitHub PR for a Linear issue branch using the repo's PR template, with Linear issue linking and user review. Use when: opening a PR for a Linear ticket, creating a pull request for Linear, submitting Linear work for review."
argument-hint: "Linear issue identifier (e.g., DRA-1234)"
---

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
- Otherwise, detect it from the current branch name (e.g., `em/dra-1234` → `DRA-1234`).
  - If the branch name does not match the `em/<prefix>-<number>` pattern, prompt the user for the Linear issue identifier.
- Fetch the Linear issue details (title, URL, identifier). If the issue is not found, stop and ask the user to provide a valid identifier.

### Step 2: Determine the Base Branch

- Identify the base branch for the PR target with the following command (use the first branch that exists):

```sh
# Priority order: `staging` → `main` → `master`
for b in staging main master; do git show-ref --verify --quiet refs/remotes/origin/$b && echo $b && break; done
```

- If the current branch name starts with `feature/<feature-name>/`, use `remote/feature/<feature-name>` as the PR target instead.

### Step 3: Prepare PR Content

- Locate the repository's PR template (check `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md`)
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

- Create the PR on GitHub with the final content from `tmp-pr-draft.md`
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
- If they confirm, post a new comment on the Linear issue (resolved in Step 1).
- Use this default comment template (let the user edit names/message before posting):

```txt
Ready for review 🙂

@owen.coogan, @nathalie, @max
```

- Change the status of the linear issue to "In Review"

## Constraints

**Review (never skip):**

- Never create the PR without user review of the draft content (Step 4)

**Title:**

- PR title must match the Linear ticket title exactly

**Cleanup:**

- Always delete `tmp-pr-draft.md` after completion or abort
