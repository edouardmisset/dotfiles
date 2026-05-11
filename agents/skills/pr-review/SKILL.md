---
name: pr-review
description: "Review a pull request for code quality, bugs, security, and logic errors. Use when: reviewing a PR, code review, reviewing changes, analyzing diffs, giving feedback on code."
argument-hint: "PR number or URL (optional, defaults to active PR)"
---

# Pull Request Review

## When to Use

- Reviewing an open pull request
- Providing structured code review feedback
- Analyzing diffs for bugs, security issues, and logic errors

## Procedure

1. **Gather context**: Fetch the PR details (title, description, changed files, diffs). If no PR is specified, use the PR currently open or active in the IDE (e.g., the PR associated with the current branch). If the PR contains no changes, respond with: "No changes detected in this PR."

2. **Identify all changed files**: List every unique file path modified in the PR. There may be multiple files with the same basename — always use full paths.

3. **Determine change ordering**: Use commit timestamps to establish the sequence of changes. Prioritize the latest commit's state when providing feedback. Do not mention timestamps in output.

4. **Produce the review** in the following format:

### Output Format

#### Changes

For each changed file:

- **File path**: `path/to/file.ext`
- **Summary**: What was added, modified, or removed
- **Feature/functionality**: Describe the feature or behavior change (e.g., "Implemented user activity reporting")
- **Refactoring**: If applicable, what was restructured and why
- **Potential issues**: Logic errors, bugs, or edge cases spotted

#### Feedback

Concise, actionable points in plain English. Prioritize:

1. **Required modifications** — specify exact file and location
2. **Logic errors and bugs** — review every new function, variable, and code path
3. **Functionality correctness** — does the code behave as expected? Highlight edge cases not handled
4. **Duplicate/unintended behavior** — e.g., double submissions, race conditions
5. **Security concerns** — missing validation, injection risks, auth gaps
6. **Readability** — are names meaningful? Is the flow clear?
7. **Suggested improvements** — concrete, not generic (no "add comments")
8. **Highlight** — one specific positive aspect of the changes (not tests)

## Constraints

**Specificity (always apply):**

- Every feedback point must reference a specific file path and location
- Feedback must be actionable — never generic (e.g., no "add comments" or "improve naming" without a concrete suggestion and location)

**Completeness:**

- Cover all prioritized feedback categories (required modifications, bugs, security, readability) before adding suggested improvements
