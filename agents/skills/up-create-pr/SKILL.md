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

## Tools

- Linear MCP: issue read, comment, and status transition.
- `gh`: every GitHub read and write.
- `git`: local repository and branch state.

## Rules

- Run all commands from the target repository.
- Set `REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)` once and pass `--repo "$REPO"` to every `gh` command.
- Stop on a dirty worktree, missing upstream branch, missing Linear issue, or GitHub authentication failure.
- Every write requires the confirmation stated in its step. Do not combine confirmations.
- Delete `tmp-pr-draft.md` before stopping for any reason after creating it.
- Treat fenced shell blocks as independent commands. Before running a block, provide each named procedure value it requires; every block must validate those values before use.

## Procedure

### Step 1: Resolve the Linear Issue

- Use the provided issue identifier. Otherwise derive it from `em/<prefix>-<number>`; if the branch does not match, ask for the identifier and stop.

```sh
set -euo pipefail
test -z "$(git status --porcelain)" || {
  printf '%s\n' 'Worktree has uncommitted changes; stop.' >&2
  exit 1
}
branch=$(git branch --show-current)
git rev-parse --abbrev-ref '@{upstream}' >/dev/null
if test -z "${issue_id:-}"; then
  printf '%s\n' "$branch" | rg -qi '^em/[a-z]+-[0-9]+$' || {
    printf '%s\n' 'Provide a Linear issue identifier.' >&2
    exit 1
  }
  issue_id=$(printf '%s\n' "$branch" | sed -E 's#^em/##' | tr '[:lower:]' '[:upper:]')
fi
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
gh api user --jq .login >/dev/null
```

- Read `issue_id` through Linear MCP. Retain its identifier, title, and URL; stop if the issue is absent.
- Set `linear_title` to the returned title. The PR title must equal `linear_title` exactly.

### Step 2: Determine the Base Branch

```sh
base=''
for candidate in "${project_branch:-}" staging main master; do
  test -n "$candidate" || continue
  if git show-ref --verify --quiet "refs/remotes/origin/$candidate"; then
    base=$candidate
    break
  fi
done
test -n "$base" || {
  printf '%s\n' 'No staging, main, or master remote branch found.' >&2
  exit 1
}
```

- When invoked from `up-issue-workflow`, pass its verified `base` as `project_branch`; this preserves an explicitly configured project base.
- If `branch` matches `feature/<name>`, set `base=feature/<name>` only when `refs/remotes/origin/$base` exists. Otherwise retain the selected base.
- Do not guess another base branch.

### Step 3: Detect an Existing PR

```sh
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
branch=$(git branch --show-current)
existing_pr=$(gh pr list --repo "$REPO" --head "$branch" --state open --json url --jq '.[0].url')
```

- If `existing_pr` is non-empty, display it and stop. Do not create, modify, or notify on an existing PR.

### Step 4: Prepare PR Content

```sh
test -n "${issue_id:-}" && test -n "${linear_url:-}" || {
  printf '%s\n' 'Linear issue details are unavailable; stop.' >&2
  exit 1
}
test ! -e tmp-pr-draft.md || {
  printf '%s\n' 'tmp-pr-draft.md already exists; stop to preserve it.' >&2
  exit 1
}
template=''
for candidate in .github/PULL_REQUEST_TEMPLATE.md .github/pull_request_template.md; do
  test -f "$candidate" && { template=$candidate; break; }
done
test -n "$template" || template="$HOME/.dotfiles/agents/skills/up-create-pr/references/pull_request_template.md"
test -f "$template" || {
  printf '%s\n' 'No PR template found.' >&2
  exit 1
}
cp "$template" tmp-pr-draft.md || {
  printf '%s\n' 'Could not create tmp-pr-draft.md.' >&2
  exit 1
}
if rg -q '^Related to:' tmp-pr-draft.md; then
  LINEAR_ID=$issue_id LINEAR_URL=$linear_url \
    perl -0pi -e 's{^Related to:.*$}{Related to: [$ENV{LINEAR_ID}]($ENV{LINEAR_URL})}m' tmp-pr-draft.md || {
      rm -f tmp-pr-draft.md
      printf '%s\n' 'Could not update tmp-pr-draft.md.' >&2
      exit 1
    }
fi
```

- Populate only fields that exist in the selected template. Do not add headings, placeholder text, or unrelated content.

### Step 5: Review PR Content with User

- Open `tmp-pr-draft.md` and ask the user to review and edit it.
- Wait for explicit confirmation that the draft is final. Never create a PR without it.

### Step 6: Create the PR on GitHub

Ask separately for confirmation to create the PR. On confirmation, provide `REPO`, `base`, and `linear_title` from the verified procedure state, then run:

```sh
test -n "${REPO:-}" && test -n "${base:-}" && test -n "${linear_title:-}" || {
  rm -f tmp-pr-draft.md
  printf '%s\n' 'PR creation details are unavailable; stop.' >&2
  exit 1
}
pr_url=$(gh pr create --repo "$REPO" --base "$base" --title "$linear_title" --body-file tmp-pr-draft.md) || {
  rm -f tmp-pr-draft.md
  printf '%s\n' 'PR creation failed; no PR was created.' >&2
  exit 1
}
rm -f tmp-pr-draft.md
printf '%s\n' "$pr_url"
```

- If creation fails, show the error and stop. Do not retry with altered title, base, or body unless the user directs it.
- Run `gh pr edit "$pr_url" --repo "$REPO" --add-assignee @me`; if it fails, report that the PR was created but assignment failed, then stop.
- Ask separately whether to request a preview deployment. On confirmation only:

```sh
make run_preview_job
```

### Step 7: Cleanup

- The creation command removes only the draft it created immediately after a successful PR creation. On a declined draft or creation confirmation, run `rm -f tmp-pr-draft.md` before stopping.

### Step 8: Optionally Notify Squad on Linear

- Ask whether to notify the squad on Linear by posting a squad-review comment and moving the issue to `In Review`, showing the proposed text before writing it. The default comment is:

```txt
Ready for review

@owen.coogan, @nathalie, @max
```

- On confirmation, read the workflow reference, then post the comment and transition the issue through Linear MCP.
