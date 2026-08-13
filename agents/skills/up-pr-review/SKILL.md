---
name: up-pr-review
description: "Review a pull request for code quality, bugs, security, and logic errors. Use when: reviewing a PR, code review, reviewing changes, analyzing diffs, giving feedback on code."
argument-hint: "PR number or URL (optional, defaults to active PR)"
---

# Pull Request Review

## When to Use

- Reviewing an open pull request
- Providing structured code review feedback
- Analyzing diffs for bugs, security issues, and logic errors

## Rules

- Use `gh` for every GitHub read. Do not use GitHub MCP for this skill.
- Resolve `REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)` in the target checkout, then pass `--repo "$REPO"` to every later `gh` command.
- Review only the current PR head. Do not report defects that were fixed in later commits.
- Do not claim workspace line links unless the matching repository checkout is present at the PR head.

## Procedure

### Step 1: Resolve the PR and Fetch Metadata

```sh
set -euo pipefail
if test -n "${pr_input:-}"; then
	pr_ref=$pr_input
	if printf '%s\n' "$pr_input" | rg -q '^https://github\.com/[^/]+/[^/]+/pull/[0-9]+/?$'; then
		REPO=$(printf '%s\n' "$pr_input" | sed -E 's#^https://github\.com/([^/]+/[^/]+)/pull/[0-9]+/?$#\1#')
		resolved_repo=$(gh repo view "$REPO" --json nameWithOwner --jq .nameWithOwner)
		test "$resolved_repo" = "$REPO" || {
			printf '%s\n' 'PR URL repository could not be validated.' >&2
			exit 1
		}
	else
		REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
	fi
else
	REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
	pr_ref=$(gh pr view --repo "$REPO" --json url --jq .url)
fi
gh pr view "$pr_ref" --repo "$REPO" \
	--json number,url,state,title,body,headRefName,headRefOid,baseRefName,changedFiles,files \
	> /tmp/up-pr-review.json
gh pr diff "$pr_ref" --repo "$REPO" > /tmp/up-pr-review.diff
```

- A PR URL must match `https://github.com/<owner>/<repo>/pull/<number>`; its owner/repository is validated before `gh pr view` and `gh pr diff` run.
- Stop for an absent, closed, or merged PR and ask whether to review it anyway. Stop if `changedFiles` is zero.
- For more than 30 files, group paths by directory and inspect substantive files first. Note generated, binary, lock, and build-artifact files without reviewing their internals.

### Step 2: Identify Changed Files

```sh
jq -r '.files[].path' /tmp/up-pr-review.json > /tmp/up-pr-review-files.txt
```

- List each unique full repository-relative path. Never identify a file only by basename.

### Step 3: Read Changed Files

```sh
head_sha=$(jq -r .headRefOid /tmp/up-pr-review.json)
if test "$(git rev-parse HEAD)" = "$head_sha" \
	&& test "$(gh repo view --json nameWithOwner --jq .nameWithOwner)" = "$REPO" \
	&& test -z "$(git status --porcelain --untracked-files=all)"; then
	source_mode=local
else
	source_mode=remote
fi
```

- In `local` mode, read each substantive changed file in the open workspace and use its exact current line numbers.
- In `remote` mode, fetch and decode the final file content only when needed, then inspect the decoded file:

```sh
remote_file=$(mktemp)
gh api "repos/$REPO/contents/<path>?ref=$head_sha" --jq .content | base64 -D > "$remote_file"
```

	Inspect the diff first and use the GitHub file URL or diff path in findings. Do not invent workspace line links.
- For every substantive changed file, inspect both its final source and the diff. Verify signatures, control flow, error handling, and caller-visible behavior.

### Step 4: Determine Change Ordering

Use `head_sha` as the only review revision. Do not flag code removed or corrected before that revision.

### Step 5: Produce the Review

Output the review in the format below.

## Output Format

### Changes

- **Changed files**: bullet list of changed files linked to their full repository-relative paths and line number.
  (e.g.,
  `[src/foo/bar.ts](src/foo/bar.ts#L42-L45)`
  `[src/foo/baz.ts](src/foo/baz.ts#L1-L4)`
  )
- **User-facing changes**: What was added, modified, or removed in the end-user product.
  (e.g., add the ability for the user to send their expenses to the accounting system)
- **Code changes**: What was added, modified, or removed in the codebase. (e.g., add a new function `sendExpensesToAccounting()` and the button in the UI along with tests)
- **Refactoring**: If applicable, what was restructured and why
  (e.g., refactor `sendExpensesToAccounting()` to separate the API call from the UI logic for better testability)

### Feedback

Concise, actionable points in plain English. Each feedback item must include a **severity tag**, a source reference, and one [conventional comment](https://conventionalcomments.org/). Do not separate an action point from the conventional comment: put the rationale and exact next steps in the comment's discussion.

```
<label>: <subject>

[discussion: rationale, impact, and exact next steps]

(optional GH code suggestion)
```

Severity levels: **🔴 Critical** (blocking) · **🟠 High** · **🟡 Medium** · **🔵 Low / Suggestion**

Use these labels:

- `praise`: highlight a specific positive aspect.
- `nitpick`: request a trivial, preference-based non-blocking change.
- `suggestion`: propose a clear improvement and explain why it helps.
- `issue`: report a concrete problem; pair it with a remedy in the discussion.
- `todo`: request a small but necessary change.
- `question`: ask for clarification or investigation when the concern is uncertain.
- `thought`: share a non-blocking idea for future consideration.
- `chore`: request a required process or maintenance task before acceptance.
- `note`: call attention to a non-blocking detail.

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
> [src/orders/processor.ts](src/orders/processor.ts#L42-L45)
>
> issue: Guard `order.items` before accessing it.
>
> If the API returns an order without items, the current access throws at runtime. Add `if (!order.items?.length) return;` before the first access.
>
> ```suggestion
> if (!order.items?.length) return;
> ```

### Highlight

One specific positive aspect of the changes (do not mention tests in the highlight).

### Verdict

Provide a clear recommendation:

- **✅ Approve** — no blocking issues found
- **🔄 Request changes** — blocking issues must be addressed (list them)
- **💬 Comment only** — no blocking issues, but suggestions worth discussing

## Constraints

**Source references (always apply):**

- In `local` mode, reference source as a workspace-relative markdown link: `[path/to/file.ext](path/to/file.ext#L42)` or `[path/to/file.ext](path/to/file.ext#L10-L15)`.
- In `remote` mode, reference the full repository-relative path and the GitHub file URL at `head_sha`; do not use a workspace link.
- When referencing a function or symbol, name it and link to its definition only in `local` mode.
- Never wrap paths in backticks. Do not combine non-contiguous line ranges.

**Specificity (always apply):**

- Every feedback point must reference a specific file path and, in `local` mode, exact line number(s)
- Feedback must be actionable — never generic (e.g., no "add comments" or "improve naming" without a concrete suggestion and location)

**Completeness:**

- Cover all prioritized feedback categories (required modifications, bugs, security, readability) before adding suggested improvements
- Skip categories that have no findings — do not output empty sections
