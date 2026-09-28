---
name: up-frontend-rfc
description: "Skill for writing frontend RFCs in a structured two-phase workflow: first creating a document outline, then detailing the implementation."
disable-model-invocation: true
---

# FE RFC Writing Skill

This document defines the workflow to build a frontend RFC in two phases:

1. Document outline
2. Implementation details

The assistant must complete Step 1 first, get user validation, then proceed to Step 2.

## Inputs

The end-user must provide:

1. **Target Linear project** — URL/ID + full spec overview
2. **Reference RFCs** — List of existing RFC files to analyze for patterns (e.g., 3-5 similar projects)
3. **Impacted repos** — List of source repos involved (e.g., ember-identity, ember-upf-utils, publishr-admin-web)

The assistant will align structure and writing style with the provided reference RFCs.

## Writing style rules

- Use simple vocabulary.
- Keep sentences short and direct.
- Avoid unnecessary jargon.
- Do not hallucinate unknown details.
- When missing information, use [TBD].
- Prefer sentence-first prose for explanatory sections.
- Do not default to bullet lists for implementation details.
- Use bullet points only when they clearly improve readability (for example: accepted input lists, event payload fields, short checklists, or explicit enumerations).
- Avoid AI-sounding label blocks unless the user explicitly asks for them. Prefer direct prose over headings like "Responsibilities", "Implementation notes", "Proposed methods", or "Endpoint-level intent".
- Keep section content scoped to the section subject. Do not move usage-level behavior into primitive definition sections.
- When asked for a quick draft snippet, provide minimal scaffolding (not a near-complete implementation) and clearly label it as a draft.

---

## Step 0 - Research & preparation

Goal: ground the outline in actual codebase patterns, naming conventions, and repo structure before proposing any outline.

### Step 0 tasks

1. **Analyze provided reference RFCs**
   - Read the provided reference RFCs end-to-end.
   - Extract naming patterns (e.g., handler/manager naming, component structure, service organization).
   - Note shared patterns across repos.

2. **Map impacted repos**
   - Document the provided repos and their concerns (which handles services, which handles components, etc.).
   - Note which repos appear in the reference RFCs.
   - Document repo ownership for each major component or service type.

3. **Gather existing code references**
   - Search GitHub in the provided impacted repos for open PRs and code patterns.
   - Use keywords from spec to find relevant existing implementations.
   - Collect actual GitHub links to code patterns, components, services that will be built on.
   - For shared primitives (components, modifiers, services), capture the existing implementation first, then document only the project-specific delta.

4. **Identify scope boundaries**
   - Mark which user stories are backend-only, frontend-only, or shared.
   - Note US dependencies (e.g., US-1 must complete before US-2 can start).

5. **Define shared data structures**
   - Extract type signatures, interfaces, or models needed across multiple USs.
   - Capture these in TypeScript/pseudo-code form for reuse in outline.

6. **Confirm implementation strategy**
   - Clarify handler vs manager split based on existing codebase patterns.
   - Identify where state lives (services, managers, localStorage).
   - Confirm component library vs feature-specific component placement.

### Step 0 output

Collected info becomes the foundation for Step 1. Do not output an outline yet. Instead, provide:

- Naming patterns found (paste examples from reference RFCs)
- Repo ownership map (which repo owns what)
- GitHub code pointers (link to PRs and existing code)
- Shared types/models (TypeScript stubs)
- Scope boundaries (which USs are frontend vs backend)

Only after Step 0 is complete and reviewed, proceed to Step 1.

---

## Step 1 - Document outline

Goal: propose a high-level decomposition of the RFC before writing implementation details.

### Step 1 constraints

- Output structure only.
- No filled implementation details.
- No endpoint-by-endpoint behavior.
- No full component logic.
- No final code snippets except short type placeholders when needed for structure.

### Step 1 must include

- Overview
- Background
- Implementation
- Groundwork section for cross-story/shared work
- User-story-by-user-story sections in spec order
- Per-user-story subsection candidates (components, services, page updates, state handling)

### Step 1 overview rule

The Overview must summarize the Scope section of the target Linear project. It should stay short (1-3 sentences), describe the milestone objective, and clarify the current frontend phase boundaries (for example read-only vs write capabilities when relevant).

### Step 1 output format (template)

```md
# Overview

[1-3 sentence summary of the Linear Scope: milestone objective + current phase boundaries]

# Background

- [Impacted repos and dependencies]
- [Related RFCs or previous project context]

# Implementation

## Groundwork

### [Shared service or model updates]

### [Shared components]

### [Shared modifiers/utilities]

## US-1: [title]

### [Section name]

### [Section name]

## US-2: [title]

### [Section name]

### [Section name]

## US-N: [title]

### [Section name]

## Analytics / Tracking

### [Event group]
```

### Step 1 acceptance criteria

- Every spec user story appears once.
- Shared concerns are in Groundwork, not repeated across stories.
- Section names are specific enough to guide implementation.
- Outline is reviewable in one pass by product and frontend.

Only after explicit user approval of the outline can the assistant start Step 2.

---

## Step 2 - Implementation details

Goal: fill the approved outline with implementation guidance.

### Tech context

- Framework: Ember
- Language: TypeScript for new code (legacy JavaScript may exist)
- Templates: Handlebars
- Styling: LESS

### Step 2 constraints

- Favor concise snippets over full implementations.
- For services, provide method intent, verb/endpoint, and data shape.
- For service sections, keep the draft at the RFC level by default: describe the call flow, return shape, and state ownership, but do not write full class bodies, pseudo-code method bodies, or recursive implementation sketches unless the user explicitly asks for them.
- Keep handler vs manager responsibilities explicit.
- Add component argument interfaces whenever relevant.
- Use [TBD] for unknown code pointers or unresolved decisions.
- Treat Step 2 as iterative: draft first, then review section by section with the user.

### Step 2 review workflow (mandatory)

After the first full Step 2 draft is produced, the assistant and user must review the RFC section by section before finalizing.

The assistant should follow this loop:

1. Ask for feedback on the current section.
2. Apply edits only for that section.
3. Confirm the updated section is aligned with reference style and spec intent.
4. Move to the next section only after user validation.

Recommended section order:

1. Overview
2. Background
3. Groundwork (subsection by subsection)
4. Implementation US sections in spec order
5. Analytics / tracking

During this review loop:

- Prefer targeted edits over full-document rewrites.
- Preserve user-approved sections unless explicitly asked to revisit them.
- Keep wording aligned with team style (sentence-first prose, limited bullets).
- Keep unresolved items explicit with [TBD].
- After each section update, confirm tone alignment explicitly: does this sound like the team's writing style, and if not, rewrite before moving on.

### Preferred service split

- Handlers: API/external communication
- Managers: local app state and UI coordination

### Component documentation pattern

```typescript
interface ComponentArgs {
  title: string;
  onRetry?: () => void;
}
```

### Code pointers policy

- Add pointers when editing existing code.
- Do not invent links.
- If missing, write [TBD: add code pointer].

### Step 2 acceptance criteria

- Groundwork and each user story contain actionable implementation notes.
- Snippets clarify complex behavior without over-implementing.
- Responsibilities across repos/services/components are clear.
- Ambiguities are marked [TBD] and not guessed.
- Each major section has been reviewed with the user and updated as needed.
- Final document reflects validated section-by-section feedback, not only an initial draft.
