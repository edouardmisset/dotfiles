---
name: up-follow-up
description: "Daily follow-up for an Upfluence frontend developer: scans Linear issues assigned to me by status (In Progress, In Review, Ready for RC) and the matching open GitHub PRs in the upfluence org, surfacing unread comments, stale review threads, missing/outdated test links, failing CI, and merge-ready tickets. Use when: doing daily follow-up, checking my sprint progress, preparing for standup, reviewing my open PRs, checking test link freshness, finding mergeable Ready for RC tickets."
---

# Follow-Up

## When to Use

- Daily check-in on Linear issues + GitHub PRs
- Finding which In Review PRs are mergeable, stale, or missing a fresh test link
- Confirming Ready for RC tickets are green and ready to ship

## Context

I'm a frontend developer at Upfluence. Local work tree: `~/Documents/code/upfluence/`. Each subfolder is a GitHub repo in the `upfluence` org.

Most-used repos:

- `upfluence-web` — monorepo with packages: `acquisition-web`, `crm-web`, `inbox-web`, `settings-web`, `affiliates-web`, `engine-base`, `publishr-admin-web` (my team uses this most), `upfluence-web`, `analytics-web`, `facade-web`, `publishr-client-web`
- `oss-components`
- `ember-identity`
- `RFCs` — textual RFCs for project specs

Other repos I touch: `creators-web`, `ember-influencer`, `ember-upf-utils`, `hypertable`, `hypertable-extension`, `identity-web`, `man`, `plugin-web`, `private-actions`, `uedit`, `w-conf`.

**Linear ticket workflow reference:** `~/Documents/code/upfluence/man/frontend/how-to/linear-ticket-workflow.md` — read this once at the start of every follow-up so status definitions and transitions are accurate.

**Test link patterns** (what gets posted on a PR by `make run_preview_job`):

- Upfluence app: `https://staging.upfluence.co/?index_key=upfluence-web:<short-sha>`
- Wednesday app: `https://friday.wednesday.app/?index_key=upfluence-web:<short-sha>`

## Tools and Rules

- Linear MCP: identity, issue list/history/comments, and all Linear writes.
- `gh`: every GitHub read and write. Use `gh api graphql` only for review threads.
- Scope every PR query to `upfluence`; never include forks or another organization.
- Resolve once: `GH_LOGIN=$(gh api user --jq .login)`. Stop if it is empty or the command fails.
- Request only listed JSON fields and cap discovery with `--limit 100`.
- Reads need no confirmation. Every write, merge, and preview build needs the separately stated explicit confirmation.

## Procedure

### Step 1: Load Workflow Reference

Read `~/Documents/code/upfluence/man/frontend/how-to/linear-ticket-workflow.md` to ground status names, owner roles, and the transitions expected at each step. Use it to disambiguate any status decision below.

### Step 2: Resolve Identity

```sh
set -euo pipefail
GH_LOGIN=$(gh api user --jq .login)
test -n "$GH_LOGIN"
gh search prs --owner upfluence --author "$GH_LOGIN" --state open --limit 100 \
   --json number,title,url,body,repository,updatedAt \
   > /tmp/up-follow-up-prs.json
test "$(jq 'length' /tmp/up-follow-up-prs.json)" -lt 100 || {
   printf '%s\n' 'PR discovery reached its limit; follow-up is incomplete.' >&2
   exit 1
}
```

- Resolve the current Linear user with Linear MCP and use that returned user as the sole assignee filter.
- Stop and ask the user to authenticate if either identity lookup fails.

### Step 3: Fetch My Active Work

- List Linear issues assigned to the authenticated Linear user in `In Progress`, `In Review`, and `Ready for RC`. Include `QA` only when it maps to one of the discovered PRs.
- For every discovered PR, fetch `headRefName` and `headRefOid` before matching or checking it:

```sh
head_json=$(gh pr view "$number" --repo "$repo" --json headRefName,headRefOid)
head_sha=$(printf '%s\n' "$head_json" | jq -er .headRefOid)
```

- Map an issue to a PR only when its identifier occurs case-insensitively as a complete token in `headRefName`, title, or body. Do not use partial number matches.
- Keep all matching PRs under the same issue, including cross-repository PRs. List unmatched PRs separately; do not infer a Linear issue.

### Step 4: In Progress — New Comments to Attend

For each issue in `In Progress`:

- Find the timestamp of the most recent transition into `In Progress` from issue history.
- Fetch comments created **after** that timestamp.
- Drop comments authored by me.
- For each remaining comment, output one line: `<author> · <relative time> · <one-line summary>` with a link to the comment.

If there are no new comments, list the issue under "In Progress — no new activity".

### Step 5: In Review — PR Health

For each `In Review` issue with one or more linked open PRs (and any open PR I authored even if its issue is in `QA`):

A single Linear issue may have multiple PRs across different repos. For every linked PR, set `repo` and `number` from `/tmp/up-follow-up-prs.json`, fetch and retain `head_sha` with the Step 3 command, then run 5a-5d before aggregating the issue. Fetch `headRefOid` again after 5a-5d; if it differs from `head_sha`, mark readiness incomplete and do not use any results collected for the earlier head.

#### 5a. Unaddressed review threads

```sh
query='query($owner:String!,$name:String!,$number:Int!,$after:String){repository(owner:$owner,name:$name){pullRequest(number:$number){reviewThreads(first:100,after:$after){nodes{isResolved path line comments(last:1){nodes{author{login} body url createdAt}}} pageInfo{hasNextPage endCursor}}}}}'
pages=()
after_args=()
while :; do
   page=$(mktemp)
   gh api graphql -F owner="${repo%%/*}" -F name="${repo##*/}" -F number="$number" \
      "${after_args[@]}" -f query="$query" > "$page" || {
         rm -f "${pages[@]}" "$page"
         printf '%s\n' 'Could not read every review-thread page; readiness is incomplete.' >&2
         exit 1
      }
   pages+=("$page")
   has_next=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.hasNextPage' "$page")
   test "$has_next" = true || break
   cursor=$(jq -r '.data.repository.pullRequest.reviewThreads.pageInfo.endCursor' "$page")
   test -n "$cursor" && test "$cursor" != null || {
      rm -f "${pages[@]}"
      printf '%s\n' 'Review-thread pagination is incomplete; readiness is incomplete.' >&2
      exit 1
   }
   after_args=(-F "after=$cursor")
done
jq -s '[.[].data.repository.pullRequest.reviewThreads.nodes[]]' "${pages[@]}" > /tmp/up-follow-up-threads.json
rm -f "${pages[@]}"
```

- A thread needs attention only when `isResolved` is false and its last comment author is not `GH_LOGIN`. If pagination cannot complete, treat readiness as incomplete and do not merge or advance the issue.
- Output `<reviewer> on <path>:<line> · <first line> · <URL>` for each such thread. Do not infer whether a later push addressed it; resolution is the source of truth.

#### 5b. Approvals & merge readiness

```sh
gh pr view "$number" --repo "$repo" \
   --json url,baseRefName,headRefOid,mergeable,mergeStateStatus,reviews \
   > /tmp/up-follow-up-pr.json
```

- For each reviewer, retain only their most recent review by submission time. Count distinct reviewers whose retained state is `APPROVED`.
- A current `CHANGES_REQUESTED` state blocks the PR. A PR is ready to ship only with at least two retained approvals, no current changes request, zero attention threads, `mergeable=MERGEABLE`, and `mergeStateStatus=CLEAN`.
- An issue is ready only when every linked PR is ready. For a ready issue, ask which one action to take: move to `QA`, move to `Done`, or do nothing. Transition only after that explicit confirmation.

#### 5c. Test link freshness

```sh
gh api "repos/$repo/issues/$number/comments?per_page=100&sort=created&direction=desc" \
   > /tmp/up-follow-up-comments.json
```

- Scan the newest 100 comment bodies newest first for `https://staging.upfluence.co/?index_key=upfluence-web:<short-sha>` or `https://friday.wednesday.app/?index_key=upfluence-web:<short-sha>`.
- The canonical link is the newest matching URL. Extract its suffix after `upfluence-web:` as `preview_sha`.
- It is current if `head_sha` begins with `preview_sha`; otherwise it is outdated. No matching URL means no link.
- For no link or an outdated link, tell the user and ask whether to run `make run_preview_job` in `~/Documents/code/upfluence/<repo-name>`. On confirmation only, run it there, capture the link, then ask separately before adding that link to Linear issue ("Add Link...").
- If the canonical link is current but absent from Linear, ask separately whether to add it to the Linear issue ("Add Link..."). Technical PRs may be explicitly marked as not requiring a test link.

#### 5d. CI status

```sh
set +e
gh pr checks "$number" --repo "$repo" --required --json name,state,bucket,link \
   > /tmp/up-follow-up-checks.json
checks_status=$?
set -e
test "$checks_status" -eq 0 || test "$checks_status" -eq 8 || {
   printf '%s\n' 'Could not read required checks; readiness is incomplete.' >&2
   exit 1
}
```

- A PR is green only when every required check has `bucket=pass` or `bucket=skipping`. Treat `fail`, `pending`, and `cancel` as blocking.
- For failed checks, output the check link, failing job names, and one root-cause hypothesis from the first failure line or log tail. If logs cannot be read, state that the cause is unavailable rather than guessing.

### Step 6: Ready for RC — Mergeability

For each `Ready for RC` issue with one or more linked PRs:

1. Run 5a-5d for every linked PR. Re-fetch `headRefOid` after those checks and require it to equal the retained `head_sha`; otherwise report readiness as incomplete and stop for this issue. If any check is non-green or `mergeable` is not `MERGEABLE`, report the blocking PR and stop for this issue.
2. Show each PR's `baseRefName` and `mergeStateStatus`.
3. Ask: "Merge these PRs and advance the Linear issue to the next status?" with options:
   - merge all + advance
   - merge all only
   - skip
4. On confirmation, merge each PR in a stable order by `<repo>/<number>`:

```sh
gh pr merge "$number" --repo "$repo" --merge --delete-branch=true \
   --match-head-commit "$head_sha"
```

5. If a merge fails, including a rejected `--match-head-commit` because the head changed, stop and report the merged and unmerged PRs. Never continue to the Linear transition after a partial merge.
6. For `merge all + advance`, read the workflow reference again and ask for separate confirmation of the resulting Linear status transition before writing it through Linear MCP.

### Step 7: Final Report

Output a single condensed markdown report grouped by Linear status. One block per issue, with:

- `<LINEAR-ID> <title>` (link to Linear)
- One sub-bullet **per linked PR**: PR `#<num>` in `<repo>` (link) — CI green/failed/pending · mergeable yes/no · approvals X/2 · attention threads Y · preview current/outdated/missing/not-required
- One-line **next action** for the issue as a whole (e.g. "respond to @alice's comment on `foo.ts:42` in PR #234", "regenerate test link on PR #235", "merge both PRs & move to Released"). If different PRs need different actions, list them as separate sub-actions.

Omit any status section that has zero items.

## Constraints

1. Scope GitHub activity to `upfluence`; scope Linear issues to the authenticated Linear user.
2. Read `~/Documents/code/upfluence/man/frontend/how-to/linear-ticket-workflow.md` before every Linear status decision.
3. Confirm each GitHub/Linear write and each preview build separately. Never batch approvals.
4. Compare a preview short SHA as a prefix of the PR `headRefOid`; any mismatch is outdated.
5. Run `make run_preview_job` only from `~/Documents/code/upfluence/<repo-name>`.
6. Group the report as `In Progress`, `In Review`, then `Ready for RC`; omit empty groups. Use one short issue block, relative timestamps, short handles, and a concrete next action per item.
