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

### Step 1: Gather PR Context

Fetch the PR details (title, description, changed files, diffs):

**When no PR is specified** (review the current branch's PR), use `github-pull-request_currentActivePullRequest`
**When a PR number or URL is provided** (e.g., "review PR #42"), use `mcp_github_pull_request_read`

- If the PR is closed or already merged, respond with: "This PR is [closed/merged]. Would you still like a review of the changes?"
- If the PR cannot be found or accessed, respond with: "Could not find PR [number/URL]. Please verify the PR exists and you have access."
- If the PR contains no changes, respond with: "No changes detected in this PR."
- If the PR contains more than 30 changed files, group files by directory and summarize trivial changes (e.g., import-only edits), providing detailed feedback only for files with substantive logic changes.
- Skip binary files, generated files (e.g., lock files, build artifacts, auto-generated code) and note them briefly under Changes without detailed feedback.

### Step 2: Identify Changed Files

List every unique file path modified in the PR. There may be multiple files with the same basename — always use full workspace-relative paths.

### Step 3: Read Changed Files

For each changed file, **read the file contents** using `read_file` to:

- Understand the full context around each change (not just the diff)
- Identify exact line numbers for every feedback point
- Verify function signatures, variable names, and control flow

This step is mandatory — do not skip it. Accurate line numbers are required for clickable references.

### Step 4: Determine Change Ordering

Only provide feedback on the final state of each file as of the latest commit. Do not flag issues that were introduced and then fixed within the same PR.

### Step 5: Produce the Review

Output the review in the format below.

## Output Format

### Changes

For each changed file:

- **File**: [path/to/file.ext](path/to/file.ext)
- **Summary**: What was added, modified, or removed
- **Feature/functionality**: Describe the feature or behavior change (e.g., "Implemented user activity reporting")
- **Refactoring**: If applicable, what was restructured and why

### Feedback

Concise, actionable points in plain English. Each feedback item must include a **severity tag** and a clickable file reference.

Severity levels: **🔴 Critical** (blocking) · **🟠 High** · **🟡 Medium** · **🔵 Low / Suggestion**

Prioritize in this order:

1. **Required modifications** (🔴/🟠) — specify exact file and line
2. **Logic errors and bugs** (🔴/🟠) — review every new function, variable, and code path
3. **Functionality correctness** (🟠/🟡) — does the code behave as expected? Highlight edge cases not handled
4. **Duplicate/unintended behavior** (🟠/🟡) — e.g., double submissions, race conditions
5. **Security concerns** (🔴/🟠) — missing validation, injection risks, auth gaps
6. **Test coverage** (🟡) — are new code paths covered by tests? Are edge cases tested?
7. **Readability** (🟡/🔵) — are names meaningful? Is the flow clear?
8. **Suggested improvements** (🔵) — concrete, not generic (no "add comments")

Example feedback item:

> **🟠 High — Missing null check in `processOrder()`**
> [src/orders/processor.ts](src/orders/processor.ts#L42-L45): `order.items` is accessed without a null check. If the API returns an order with no items, this will throw at runtime. Add a guard: `if (!order.items?.length) return;`

### Highlight

One specific positive aspect of the changes (do not mention tests in the highlight).

### Verdict

Provide a clear recommendation:

- **✅ Approve** — no blocking issues found
- **🔄 Request changes** — blocking issues must be addressed (list them)
- **💬 Comment only** — no blocking issues, but suggestions worth discussing

## Constraints

**File references (always apply):**

- Format every file reference as a markdown link: `[path/to/file.ext](path/to/file.ext#L42)` for a single line, or `[path/to/file.ext](path/to/file.ext#L10-L15)` for a range
- Use workspace-relative paths only (no absolute paths, no `file://` scheme)
- NEVER wrap file names in backticks — backtick-wrapped paths are not clickable in VS Code
- When referencing a function or symbol, include both the symbol name and a clickable link to its definition: e.g., `processOrder()` in [src/orders/processor.ts](src/orders/processor.ts#L42)
- Non-contiguous lines require separate links — never combine line references like `#L10-L12, L20`

**Specificity (always apply):**

- Every feedback point must reference a specific file path and line number(s)
- Feedback must be actionable — never generic (e.g., no "add comments" or "improve naming" without a concrete suggestion and location)

**Completeness:**

- Cover all prioritized feedback categories (required modifications, bugs, security, readability) before adding suggested improvements
- Skip categories that have no findings — do not output empty sections
