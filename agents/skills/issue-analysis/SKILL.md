---
name: issue-analysis
description: 'Analyze a Linear or GitHub issue with its comments and sub-issues, then propose a detailed implementation plan. Use when: planning an issue, analyzing a ticket, breaking down work, proposing a solution, creating an implementation plan.'
argument-hint: 'Issue identifier (e.g., DRA-5005 or GitHub issue URL)'
---

# Issue Analysis & Implementation Plan

## When to Use
- Planning how to implement an issue before starting work
- Breaking down a complex issue into actionable steps
- Understanding the full scope of an issue with sub-issues

## Required Tools
This workflow requires access to: Linear or GitHub (depending on the issue source).

## Procedure

### Step 1: Gather Full Context
- Fetch the issue details (title, description, status, assignees)
- Fetch all comments on the issue
- Fetch all sub-issues / child issues
- If linked issues exist, review those for additional context

### Step 2: Analyze Each Item
For the main issue and each sub-issue:
1. Summarize the requirement in one sentence
2. Identify the affected area of the codebase (search for relevant files)
3. Identify dependencies between sub-issues

### Step 3: Produce the Plan
For each issue/sub-issue, output:

#### `<issue-identifier>`: `<title>`
**Summary**: One-paragraph high-level description of the proposed solution.

**Affected files**:
- `path/to/file.ext` — what changes and why

**Implementation**:
1. Step-by-step changes with precise code blocks
2. Each code block should show the exact modification (not the full file)
3. Reference the specific file and location

**Considerations**:
- Edge cases, risks, or open questions

### Step 4: Suggest Ordering
- Recommend an implementation order based on dependencies
- Flag any blockers or items needing clarification

## Constraints
- Always include concrete code pointers (file paths, function names)
- Every step must have a code block showing the proposed change
- Start each issue's plan with the high-level summary before diving into details
