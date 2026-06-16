---
name: follow-up
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

- Upfluence app: `https://staging.upfluence.co/?index_key=upfluence-web:<id>`
- Wednesday app: `https://friday.wednesday.app/?index_key=upfluence-web:<id>`

## Procedure

### Step 1: Load Workflow Reference

Read `~/Documents/code/upfluence/man/frontend/how-to/linear-ticket-workflow.md` to ground status names, owner roles, and the transitions expected at each step. Use it to disambiguate any status decision below.

### Step 2: Resolve Identity

- Linear: get the authenticated user (assignee filter).
- GitHub: get the authenticated user (PR author filter), scoped to `org:upfluence`.
- If either fails, stop and ask me to authenticate.

### Step 3: Fetch My Active Work

- Linear: list all issues where `assignee = me` AND `status ∈ {In Progress, In Review, Ready for RC}`. Also pull issues in `QA` if they appear linked to one of my open PRs (needed for test-link checks in Step 5c).
- GitHub: list all open PRs in `org:upfluence` where I'm the author in current sprint.
- Build a map: Linear issue ↔ PR(s) by matching the issue identifier (e.g. `DRA-1234`) found in the PR branch name (`em/dra-1234`), title, or body. **A single Linear issue can map to multiple PRs across different repos** (e.g. a change spanning `upfluence-web` + `oss-components`); keep them all linked to the same issue and treat them as a group from Step 5 onward.

### Step 4: In Progress — New Comments to Attend

For each issue in `In Progress`:

- Find the timestamp of the most recent transition into `In Progress` from issue history.
- Fetch comments created **after** that timestamp.
- Drop comments authored by me.
- For each remaining comment, output one line: `<author> · <relative time> · <one-line summary>` with a link to the comment.

If there are no new comments, list the issue under "In Progress — no new activity".

### Step 5: In Review — PR Health

For each `In Review` issue with one or more linked open PRs (and any open PR I authored even if its issue is in `QA`):

A single Linear issue may have multiple PRs across different repos. Run **5a–5d for every linked PR**, then aggregate per issue in Step 7.

#### 5a. Unaddressed review threads

List GitHub review threads where:

- The thread is **not** resolved, AND
- The most recent comment is from a reviewer (not me), OR a change was requested but didn't push a follow-up commit.

Per thread, output: `<reviewer> on <file>:<line> · <one-line summary> · <link>`.

#### 5b. Approvals & merge readiness

- Count approvals on each PR.
- A PR is **ready to ship** when it has ≥ 2 approvals, no outstanding `changes requested`, and no unresolved blocker threads.
- An issue is **ready to advance** only when **all** linked PRs are ready to ship. If only some PRs are ready, list which ones still block.
- For each issue ready to advance, ask me which transition to make on the Linear issue:
  - move to `QA`
  - move to `Done`
  - do nothing

Wait for my answer before transitioning anything.

#### 5c. Test link freshness

For each PR linked to a Linear issue in `In Review` or `QA`:

1. Scan the PR comments for test links matching the patterns above.
2. **No test link found** → tell me, then ask whether to run `make run_preview_job` in the matching repo (`~/Documents/code/upfluence/<repo>`). On confirmation, run it, capture the resulting link, and post it on the Linear issue. Note that some PR are purely technical and don't need a test link; in that case, I can skip the test link generation.
3. **Multiple test links** → keep only the latest one as the canonical reference.
4. **Test link is outdated** (the PR has commits newer than the build the test link was generated from) → tell me, then ask whether to regenerate via `make run_preview_job`. On confirmation, regenerate and update the Linear issue.
5. **Test link exists and is current but is missing from the Linear issue** → ask whether to add it, then add it on confirmation.

Never run `make run_preview_job` or write to the Linear issue without my explicit confirmation.

#### 5d. CI status

For each PR, fetch the latest CI run. If failing:

- Print the pipeline URL.
- Print the failing job name(s).
- Print a one-line root-cause hypothesis based on the first failure line / log tail (e.g. "lint: unused import in `app/components/foo.ts:42`", "test: assertion failure in `tests/integration/bar-test.js`", "build: missing dep `@upfluence/baz`").

### Step 6: Ready for RC — Mergeability

For each `Ready for RC` issue with one or more linked PRs:

1. Confirm the latest CI pipeline is green **on every linked PR**. If any PR is failing, surface the failure(s) as in 5d and stop here for this issue.
2. Show each PR's base branch (e.g. `master`, `staging`, `feature/<name>`).
3. Ask me: "Merge this/these PR(s) and advance the Linear issue to the next status?" with options:
   - merge all + advance
   - merge all only
   - skip
4. On confirmation:
   - Merge each linked PR with the repo's standard strategy ("create a merge commit" unless the repo convention says otherwise). If a merge fails partway through a multi-PR issue, stop and report which PRs were merged and which weren't.
   - Transition the Linear issue per the workflow reference (Step 1).
   - Report the new state.

### Step 7: Final Report

Output a single condensed markdown report grouped by Linear status. One block per issue, with:

- `<LINEAR-ID> <title>` (link to Linear)
- One sub-bullet **per linked PR**: PR `#<num>` in `<repo>` (link) — CI ✅/❌ · approvals X/2 · unresolved threads Y
- One-line **next action** for the issue as a whole (e.g. "respond to @alice's comment on `foo.ts:42` in PR #234", "regenerate test link on PR #235", "merge both PRs & move to Released"). If different PRs need different actions, list them as separate sub-actions.

Omit any status section that has zero items.

## Constraints

**Required (must always be satisfied):**

1. PR scope is the `upfluence` GitHub organization only. Never include personal forks or other orgs.
2. Linear assignee filter must use the currently authenticated user. Never hardcode a name or id.
3. Read the workflow reference (`~/Documents/code/upfluence/man/frontend/how-to/linear-ticket-workflow.md`) before deciding any status transition.
4. **Reads are free; writes always require explicit confirmation.** Read-only operations (listing issues/PRs, fetching comments, checking CI status, scanning for test links, reading workflow docs, computing report data) run without asking. **Every** write to Linear or GitHub — posting or editing comments, transitioning Linear status, attaching/updating test links on a Linear issue, requesting reviews, merging PRs, and running `make run_preview_job` — must be confirmed by me each time. Never batch multiple writes behind a single "yes"; ask per action (or per clearly-scoped group) and wait for my reply before proceeding.
5. Test link freshness is decided by comparing the link's referenced commit/build to the PR's HEAD commit SHA. Different SHA → outdated.
6. When running `make run_preview_job`, `cd` into the correct repo under `~/Documents/code/upfluence/<repo>` first. Never run it from another repo's directory.

**Quality (apply after required constraints are met):**

7. Group output by Linear status (`In Progress` → `In Review` → `Ready for RC`). One bullet per issue/PR. No long paragraphs.
8. Every reported item must end with a concrete next action.
9. If a status section has zero items, omit the section entirely (don't print "(none)").
10. Use relative timestamps (`2d ago`, `4h ago`) and short reviewer/author handles.
