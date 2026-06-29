---
name: up-linear-digest
description: "Generates a Linear sprint digest for the current user's squad and sprint, including issue counts, point totals, sprint completion, and sprint time remaining. Use when: linear digest, sprint digest, squad progress, current sprint status."
argument-hint: "Optional squad name, cycle name, or date context when the target squad or sprint is ambiguous"
---

# Linear Digest

## When to Use

- Producing a quick sprint-status digest for the current user's squad
- Checking Linear issue counts and point totals by workflow state
- Summarizing sprint completion and remaining time for a standup or status update

## Procedure

1. Resolve the target cycle and squad.
   - If the user does not provide a squad, resolve the current Linear user and use that user's squad.
   - If the user does not provide a sprint or cycle, default to the active sprint for the resolved squad.
   - If the current user belongs to multiple squads, multiple active cycles match, or the squad cannot be resolved cleanly, ask for clarification before continuing.
2. Fetch the sprint scope.
   - List all Linear issues assigned to the resolved squad for the target sprint.
   - Capture each issue's status and estimate/point value.
   - Treat missing estimates as zero points unless the user asks for a separate unestimated count.
3. Compute state breakdowns.
   - Count issues in `Todo` and sum their points.
   - Count issues in `In Progress` and sum their points.
   - Count issues in `In Review` and sum their points.
   - Count issues in `Done` and sum their points.
4. Compute sprint progress.
   - Calculate total sprint points assigned to the squad from all issues in the cycle.
   - Calculate completed sprint points from issues in `Done`.
   - Report progress as `<done points> / <total sprint points>` and include the percentage when total points is non-zero.
5. Compute sprint timing.
   - Read the sprint start date and end date.
   - Report the number of full or partial days elapsed in the sprint as of today.
   - Report the number of full or partial days remaining until the sprint ends.
6. Present the digest in a compact structure.
   - `Todo: <issue count> issues, <point total> points`
   - `In Progress: <issue count> issues, <point total> points`
   - `In Review: <issue count> issues, <point total> points`
   - `Done: <done points> / <total sprint points> points (<percentage>%)`
   - `Sprint timing: <days elapsed> days elapsed, <days remaining> days remaining`
7. Call out data-quality gaps.
   - Mention if statuses differ from the expected names.
   - Mention if issue estimates are missing or if user squad ownership cannot be determined cleanly from Linear data.

## Constraints

- Always scope the digest to a single Linear cycle and a single squad before calculating totals.
- Use the exact workflow status names from the workspace when they differ from `Todo`, `In Progress`, `In Review`, or `Done`.
- Do not guess point values, sprint dates, or squad membership when Linear data is incomplete.
- If multiple squads share the cycle, filter strictly to the resolved current user's squad before reporting totals.
